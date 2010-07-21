From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 1/3] drivers/scsi: Remove dead CONFIG_WD33C93_PIO
Date: Wed, 21 Jul 2010 15:57:41 +0200
Message-ID: <c79f7e0698d11050302082fc57c7fe98d2290aa2.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

CONFIG_WD33C93_PIO doesn't exist in Kconfig, therefore all existing
references to it from the source can be removed.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/wd33c93.c |   60 ------------------------------------------------
 drivers/scsi/wd33c93.h |    5 ----
 2 files changed, 0 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index b701bf2..f62efdf 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -171,65 +171,6 @@ module_param(setup_strings, charp, 0);
 
 static void wd33c93_execute(struct Scsi_Host *instance);
 
-#ifdef CONFIG_WD33C93_PIO
-static inline uchar
-read_wd33c93(const wd33c93_regs regs, uchar reg_num)
-{
-	uchar data;
-
-	outb(reg_num, regs.SASR);
-	data = inb(regs.SCMD);
-	return data;
-}
-
-static inline unsigned long
-read_wd33c93_count(const wd33c93_regs regs)
-{
-	unsigned long value;
-
-	outb(WD_TRANSFER_COUNT_MSB, regs.SASR);
-	value = inb(regs.SCMD) << 16;
-	value |= inb(regs.SCMD) << 8;
-	value |= inb(regs.SCMD);
-	return value;
-}
-
-static inline uchar
-read_aux_stat(const wd33c93_regs regs)
-{
-	return inb(regs.SASR);
-}
-
-static inline void
-write_wd33c93(const wd33c93_regs regs, uchar reg_num, uchar value)
-{
-      outb(reg_num, regs.SASR);
-      outb(value, regs.SCMD);
-}
-
-static inline void
-write_wd33c93_count(const wd33c93_regs regs, unsigned long value)
-{
-	outb(WD_TRANSFER_COUNT_MSB, regs.SASR);
-	outb((value >> 16) & 0xff, regs.SCMD);
-	outb((value >> 8) & 0xff, regs.SCMD);
-	outb( value & 0xff, regs.SCMD);
-}
-
-#define write_wd33c93_cmd(regs, cmd) \
-	write_wd33c93((regs), WD_COMMAND, (cmd))
-
-static inline void
-write_wd33c93_cdb(const wd33c93_regs regs, uint len, uchar cmnd[])
-{
-	int i;
-
-	outb(WD_CDB_1, regs.SASR);
-	for (i=0; i<len; i++)
-		outb(cmnd[i], regs.SCMD);
-}
-
-#else /* CONFIG_WD33C93_PIO */
 static inline uchar
 read_wd33c93(const wd33c93_regs regs, uchar reg_num)
 {
@@ -296,7 +237,6 @@ write_wd33c93_cdb(const wd33c93_regs regs, uint len, uchar cmnd[])
 	for (i = 0; i < len; i++)
 		*regs.SCMD = cmnd[i];
 }
-#endif /* CONFIG_WD33C93_PIO */
 
 static inline uchar
 read_1_byte(const wd33c93_regs regs)
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 1ed5f3b..3a74fcd 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -190,13 +190,8 @@
 
    /* This is what the 3393 chip looks like to us */
 typedef struct {
-#ifdef CONFIG_WD33C93_PIO
-   unsigned int   SASR;
-   unsigned int   SCMD;
-#else
    volatile unsigned char  *SASR;
    volatile unsigned char  *SCMD;
-#endif
 } wd33c93_regs;
 
 
-- 
1.7.0.4
