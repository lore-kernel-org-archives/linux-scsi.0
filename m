From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 2/3] [RFC] sd: print preferred name in kernel messages.
Date: Wed, 15 Jun 2011 17:16:36 +0900
Message-ID: <20110615081635.2237.84387.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailx.hitachi.co.jp ([133.145.228.49]:59628 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1FOIXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 04:23:45 -0400
In-Reply-To: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>

This patch modify sd_printk() and scmd_printk() to use preferred name.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Suggested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 drivers/scsi/sd.c          |    2 +-
 drivers/scsi/sd.h          |    2 +-
 include/scsi/scsi_device.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..6119760 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1071,7 +1071,7 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	int error;
     
 	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
-						disk->disk_name, cmd));
+				dev_name(disk_to_dev(disk)), cmd));
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ad798b..3fa14f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -91,7 +91,7 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
+		    dev_name(disk_to_dev((sdsk)->disk)), ##a) :		\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dd82e02..0fb955a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -219,7 +219,7 @@ struct scsi_dh_data {
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
+		dev_name(disk_to_dev((scmd)->request->rq_disk)), ##a) :	\
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {

