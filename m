From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/08] scsi: fix hot unplug sequence
Date: Wed, 23 Mar 2005 11:14:59 +0900 (KST)
Message-ID: <20050323021335.4682C732@htj.dyndns.org>
References: <20050323021335.960F95F8@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Received: from rproxy.gmail.com ([64.233.170.194]:31359 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262723AbVCWCPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 21:15:07 -0500
Received: by rproxy.gmail.com with SMTP id 40so186780rnz
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 18:15:04 -0800 (PST)
In-Reply-To: <20050323021335.960F95F8@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

08_scsi_hot_unplug_fix.patch

	When hot-unplugging using scsi_remove_host() function (as usb
	does), scsi_forget_host() used to be called before
	scsi_host_cancel().  So, the device gets removed first without
	request cleanup and scsi_host_cancel() never gets to call
	scsi_device_cancel() on the removed devices.  This results in
	premature completion of hot-unplugging process with active
	requests left in queue, eventually leading to hang/offlined
	device or oops when the active command times out.

	This patch makes scsi_remove_host() call scsi_host_cancel()
	first such that the host is first transited into cancel state
	and all requests of all devices are killed, and then, the
	devices are removed.  This patch fixes the oops in eh after
	hot-unplugging bug.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 hosts.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: scsi-export/drivers/scsi/hosts.c
===================================================================
--- scsi-export.orig/drivers/scsi/hosts.c	2005-03-23 09:39:36.000000000 +0900
+++ scsi-export/drivers/scsi/hosts.c	2005-03-23 09:40:11.000000000 +0900
@@ -74,8 +74,8 @@ void scsi_host_cancel(struct Scsi_Host *
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	scsi_forget_host(shost);
 	scsi_host_cancel(shost, 0);
+	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
 	set_bit(SHOST_DEL, &shost->shost_state);

