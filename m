From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [RFC PATCH 2/4] sd: modify printk for alias_name
Date: Fri, 08 Jul 2011 17:46:10 +0900
Message-ID: <20110708084610.2091.8405.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53731 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1GHIqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 04:46:24 -0400
In-Reply-To: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, Nao Nishijima <nao.nishijima.xt@hitachi.com>

This patch modify sd_printk() and scmd_printk() to use alias_name. If user set
an alias_name, those print an alias_name instead of a disk_name.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Suggested-by: Jon Masters <jonathan@jonmasters.org>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 drivers/scsi/sd.h          |    2 +-
 include/scsi/scsi_device.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ad798b..66c7ae8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -91,7 +91,7 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
+		    alias_name((sdsk)->disk), ##a) :			\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dd82e02..125c05c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <linux/genhd.h>
 #include <scsi/scsi.h>
 #include <asm/atomic.h>
 
@@ -219,7 +220,7 @@ struct scsi_dh_data {
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
+		    alias_name((scmd)->request->rq_disk), ##a) :	\
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {

