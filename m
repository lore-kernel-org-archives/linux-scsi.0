From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: Use vsprint extension %pV, save ~16KB
Date: Mon, 22 Nov 2010 19:40:09 -0800
Message-ID: <1290483609.27683.68.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1799 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0KWDkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 22:40:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Make a function out of the scmd_printk macro.
Use %pV in the scmd_printk function to reduce string duplication.
Move the function prototype to include/scsi/scsi_cmnd.h

allyesconfig x86 size
   text	   data	    bss	    dec	    hex	filename
5329860	 125779	1279944	6735583	 66c6df	drivers/scsi/built-in.o.new
5345681	 125779	1281912	6753372	 670c5c	drivers/scsi/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/sd.c          |   24 ++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h   |    4 ++++
 include/scsi/scsi_device.h |    6 ------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9564961..5a15e1b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2711,3 +2711,27 @@ static void sd_print_result(struct scsi_disk *sdkp, int result)
 	scsi_show_result(result);
 }
 
+/* scmd_printk utility routine */
+
+int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
+		const char *fmt, ...)
+{
+	int rtn;
+	struct va_format vaf;
+	va_list args;
+	
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (scmd->request->rq_disk)
+		rtn = sdev_printk(prefix, scmd->device, "[%s] %pV",
+				  scmd->request->rq_disk->disk_name, &vaf);
+	else
+		rtn = sdev_printk(prefix, scmd->device, "%pV", &vaf);
+
+	va_end(args);
+
+	return rtn;
+}
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..e055815 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -302,4 +302,8 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result |= status << 24;
 }
 
+__attribute__((format (printf, 3, 4)))
+int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
+		const char *fmt, ...);
+
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 85867dc..6f6fb36 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -214,12 +214,6 @@ struct scsi_dh_data {
 #define sdev_printk(prefix, sdev, fmt, a...)	\
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
-#define scmd_printk(prefix, scmd, fmt, a...)				\
-        (scmd)->request->rq_disk ?					\
-	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
-	sdev_printk(prefix, (scmd)->device, fmt, ##a)
-
 enum scsi_target_state {
 	STARGET_CREATED = 1,
 	STARGET_RUNNING,


