From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/23] scsi: introduce sdev_prefix_printk()
Date: Tue, 30 Sep 2014 13:50:33 +0200
Message-ID: <1412077852-40893-5-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaI3LvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:02 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Like scmd_printk(), but the device name is passed in as
a string. Can be used by eg ULDs which do not have access
to the scsi_cmnd structure.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c          | 3 +--
 drivers/scsi/sd.h          | 7 ++++---
 drivers/scsi/sg.c          | 4 ++--
 drivers/scsi/sr.h          | 3 +--
 drivers/scsi/st.c          | 3 +--
 include/scsi/scsi_device.h | 9 +++++++++
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ef5ae0d..52060e7 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -85,8 +85,7 @@ static const char * vendor_labels[CH_TYPES-4] = {
 // module_param_string_array(vendor_labels, NULL, 0444);
 
 #define ch_printk(prefix, ch, fmt, a...) \
-	sdev_printk(prefix, (ch)->device, "[%s] " fmt, \
-		    (ch)->name, ##a)
+	sdev_prefix_printk(prefix, (ch)->device, (ch)->name, fmt, ##a)
 
 #define DPRINTK(fmt, arg...)						\
 do {									\
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4c3ab83..c01dc89 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -103,9 +103,10 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
-	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
-	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+	      sdev_prefix_printk(prefix, (sdsk)->device,		\
+				 (sdsk)->disk->disk_name, fmt, ##a) :	\
+	      sdev_prefix_printk(prefix, (sdsk)->device,		\
+				 NULL, fmt, ##a)
 
 #define sd_first_printk(prefix, sdsk, fmt, a...)			\
 	do {								\
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 01cf888..87304c8 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -219,8 +219,8 @@ static void sg_device_destroy(struct kref *kref);
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
 #define sg_printk(prefix, sdp, fmt, a...) \
-	sdev_printk(prefix, (sdp)->device, "[%s] " fmt, \
-		    (sdp)->disk->disk_name, ##a)
+	sdev_prefix_printk(prefix, (sdp)->device,		\
+			   (sdp)->disk->disk_name, fmt, ##a)
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1d1f6f4..1de3371 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -57,8 +57,7 @@ typedef struct scsi_cd {
 } Scsi_CD;
 
 #define sr_printk(prefix, cd, fmt, a...) \
-	sdev_printk(prefix, (cd)->device, "[%s] " fmt, \
-		    (cd)->cdi.name, ##a)
+	sdev_prefix_printk(prefix, (cd)->device, (cd)->cdi.name, fmt, ##a)
 
 int sr_do_ioctl(Scsi_CD *, struct packet_command *);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index d3fd6e8..e479343 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -306,8 +306,7 @@ static inline char *tape_name(struct scsi_tape *tape)
 }
 
 #define st_printk(prefix, t, fmt, a...) \
-	sdev_printk(prefix, (t)->device, "%s: " fmt, \
-		    tape_name(t), ##a)
+	sdev_prefix_printk(prefix, (t)->device, tape_name(t), fmt, ##a)
 #ifdef DEBUG
 #define DEBC_printk(t, fmt, a...) \
 	if (debugging) { st_printk(ST_DEB_MSG, t, fmt, ##a ); }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 27ecee7..0b18a09 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -244,6 +244,15 @@ struct scsi_dh_data {
 #define sdev_dbg(sdev, fmt, a...) \
 	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
 
+/*
+ * like scmd_printk, but the device name is passed in
+ * as a string pointer
+ */
+#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
+	(p) ?								\
+	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
+	sdev_printk(l, sdev, fmt, ##a)
+
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-- 
1.8.5.2

