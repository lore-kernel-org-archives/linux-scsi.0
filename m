From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Thu, 1 Oct 2015 04:38:45 +0000
Message-ID: <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
 <20150930151857.GA26594@lst.de>
 <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:51849 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbJAEmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 00:42:49 -0400
In-Reply-To: <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp>
Content-Language: ja-JP
Content-ID: <B8F82CC315CE8744887B288F4F6B65B7@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 10/01/15 09:56, Junichi Nomura wrote:
> With 4.2 kernel, scsi_dh->detach() was not called until the last
> reference has gone.  With 4.3-rc3, scsi_dh->detach() is directly called
> from the context of scsi_remove_device(). That's the point.

For my test script in the original post, I can't reproduce the crash
by just swapping the order of scsi_dh_handler_detach() and
device_remove_file() like this:

  void scsi_dh_remove_device(struct scsi_device *sdev)
  {
        device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
        if (sdev->handler)
                scsi_dh_handler_detach(sdev);
  }

But another workload using dm-multipath still caues the same crash.
I think a patch like the following is needed.
What do you think?


The commit 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm detach device
handlers") removed reference counting of attached scsi device handler.
As a result scsi_dh->detach() is directly called in the context of
scsi_remove_device() where activation request can be still in flight.

This patch moves scsi_dh_handler_detach() to
scsi_device_dev_release_usercontext(), at that point the device
is already in quiesced state.

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..19bf9db 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -232,10 +232,14 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 	return err;
 }
 
-void scsi_dh_remove_device(struct scsi_device *sdev)
+void scsi_dh_release_device(struct scsi_device *sdev)
 {
 	if (sdev->handler)
 		scsi_dh_handler_detach(sdev);
+}
+
+void scsi_dh_remove_device(struct scsi_device *sdev)
+{
 	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 644bb73..4d01cdb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -173,9 +173,11 @@ extern struct async_domain scsi_sd_probe_domain;
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
 int scsi_dh_add_device(struct scsi_device *sdev);
+void scsi_dh_release_device(struct scsi_device *sdev);
 void scsi_dh_remove_device(struct scsi_device *sdev);
 #else
 static inline int scsi_dh_add_device(struct scsi_device *sdev) { return 0; }
+static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
 static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
 #endif
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..dff8faf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -399,6 +399,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	scsi_dh_release_device(sdev);
+
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);