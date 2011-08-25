From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [-v3 PATCH 3/3] sd: modify printk for alias name
Date: Thu, 25 Aug 2011 18:04:24 +0900
Message-ID: <20110825090424.2288.54946.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56353 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1HYJKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 05:10:32 -0400
In-Reply-To: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, Joe Perches <joe@perches.com>

From: Joe Perches <joe@perches.com>

Reduce size of code and text of scmd_printk and sd_printk
macros by converting to the macros to functions and using
vsprintf extension %pV.  This moves the code out-of-line
and centralizes the code used to emit additional arguments.

Save ~32KB of space in an x86 allyesconfig.

$ size drivers/scsi/built-in.o*
   text    data     bss     dec     hex filename
5860439  135396 1393024 7388859  70bebb drivers/scsi/built-in.o.new
5882368  135396 1395848 7413612  711f6c drivers/scsi/built-in.o.old
5887100  135396 1397264 7419760  713770 drivers/scsi/built-in.o.with_patch_1_and_2

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 drivers/scsi/scsi_lib.c    |   26 ++++++++++++++++++++++++++
 drivers/scsi/sd.c          |   23 +++++++++++++++++++++++
 drivers/scsi/sd.h          |    8 +++-----
 include/scsi/scsi_device.h |    8 +++-----
 4 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..63579d4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2574,3 +2574,29 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+/* Logging utilities */
+
+int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
+		const char *format, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, format);
+
+	vaf.fmt = format;
+	vaf.va = &args;
+
+	if (scmd->request->rq_disk)
+		r = sdev_printk(prefix, scmd->device, "[%s] %pV",
+				alias_name(scmd->request->rq_disk), &vaf);
+	else
+		r = sdev_printk(prefix, scmd->device, "%pV", &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(scmd_printk);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a7942e5..7824f7a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2889,3 +2889,26 @@ static void sd_print_result(struct scsi_disk *sdkp, int result)
 	scsi_show_result(result);
 }
 
+int sd_printk(const char *prefix, const struct scsi_disk *sdsk,
+	      const char *format, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, format);
+
+	vaf.fmt = format;
+	vaf.va = &args;
+
+	if (sdsk->disk)
+		r = sdev_printk(prefix, sdsk->device, "[%s] %pV",
+				alias_name(sdsk->disk), &vaf);
+	else
+		r = sdev_printk(prefix, sdsk->device, "%pV", &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(sd_printk);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ad798b..46aa748 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -88,11 +88,9 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
-#define sd_printk(prefix, sdsk, fmt, a...)				\
-        (sdsk)->disk ?							\
-	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
-	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+extern __attribute__((format (printf, 3, 4)))
+int sd_printk(const char *prefix, const struct scsi_disk *sdsk,
+	      const char *format, ...);
 
 /*
  * A DIF-capable target device can be formatted with different
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d371c3c..2632502 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -216,11 +216,9 @@ struct scsi_dh_data {
 #define sdev_printk(prefix, sdev, fmt, a...)	\
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
-#define scmd_printk(prefix, scmd, fmt, a...)				\
-        (scmd)->request->rq_disk ?					\
-	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
-	sdev_printk(prefix, (scmd)->device, fmt, ##a)
+extern __attribute__((format (printf, 3, 4)))
+int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
+		const char *format, ...);
 
 enum scsi_target_state {
 	STARGET_CREATED = 1,

