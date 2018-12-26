From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v8 03/25] m68k/atari: Replace nvram_{read,write}_byte with
 arch_nvram_ops
Date: Wed, 26 Dec 2018 11:37:59 +1100
Message-ID: <0e72ee3231529ab642f6aea94cb93644689e79b5.1545784679.git.fthain@telegraphics.com.au>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1545784679.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

By implementing an arch_nvram_ops struct, any platform can re-use the
drivers/char/nvram.c module without needing any arch-specific code
in that module. Atari does so here.

Atari has one user of nvram_check_checksum() whereas the other "CMOS"
platforms don't use that function at all. Replace this
validate-checksum-and-read-byte sequence with the equivalent
rtc_nvram_ops.read() call and remove the now unused functions.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Christian T. Steigies <cts@debian.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The advantage of the new ops struct over the old global nvram_* functions
is that the misc device module can be shared by different platforms
without requiring every platform to implement every nvram_* function.
E.g. only RTC "CMOS" NVRAMs have a checksum for the entire NVRAM
and only PowerPC platforms have a "sync" ioctl.
---
 arch/m68k/atari/nvram.c   | 89 ++++++++++++++++++++++++---------------
 drivers/scsi/atari_scsi.c |  8 ++--
 include/linux/nvram.h     |  9 ++++
 3 files changed, 70 insertions(+), 36 deletions(-)

diff --git a/arch/m68k/atari/nvram.c b/arch/m68k/atari/nvram.c
index 3e620ee955ba..bafc9dc32830 100644
--- a/arch/m68k/atari/nvram.c
+++ b/arch/m68k/atari/nvram.c
@@ -39,33 +39,12 @@ unsigned char __nvram_read_byte(int i)
 	return CMOS_READ(NVRAM_FIRST_BYTE + i);
 }
 
-unsigned char nvram_read_byte(int i)
-{
-	unsigned long flags;
-	unsigned char c;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	c = __nvram_read_byte(i);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return c;
-}
-EXPORT_SYMBOL(nvram_read_byte);
-
 /* This races nicely with trying to read with checksum checking */
 void __nvram_write_byte(unsigned char c, int i)
 {
 	CMOS_WRITE(c, NVRAM_FIRST_BYTE + i);
 }
 
-void nvram_write_byte(unsigned char c, int i)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	__nvram_write_byte(c, i);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-}
-
 /* On Ataris, the checksum is over all bytes except the checksum bytes
  * themselves; these are at the very end.
  */
@@ -84,18 +63,6 @@ int __nvram_check_checksum(void)
 	       (__nvram_read_byte(ATARI_CKS_LOC + 1) == (sum & 0xff));
 }
 
-int nvram_check_checksum(void)
-{
-	unsigned long flags;
-	int rv;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	rv = __nvram_check_checksum();
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return rv;
-}
-EXPORT_SYMBOL(nvram_check_checksum);
-
 static void __nvram_set_checksum(void)
 {
 	int i;
@@ -107,6 +74,62 @@ static void __nvram_set_checksum(void)
 	__nvram_write_byte(sum, ATARI_CKS_LOC + 1);
 }
 
+static ssize_t nvram_read(char *buf, size_t count, loff_t *ppos)
+{
+	char *p = buf;
+	loff_t i;
+
+	spin_lock_irq(&rtc_lock);
+
+	if (!__nvram_check_checksum()) {
+		spin_unlock_irq(&rtc_lock);
+		return -EIO;
+	}
+
+	for (i = *ppos; count > 0 && i < NVRAM_BYTES; --count, ++i, ++p)
+		*p = __nvram_read_byte(i);
+
+	spin_unlock_irq(&rtc_lock);
+
+	*ppos = i;
+	return p - buf;
+}
+
+static ssize_t nvram_write(char *buf, size_t count, loff_t *ppos)
+{
+	char *p = buf;
+	loff_t i;
+
+	spin_lock_irq(&rtc_lock);
+
+	if (!__nvram_check_checksum()) {
+		spin_unlock_irq(&rtc_lock);
+		return -EIO;
+	}
+
+	for (i = *ppos; count > 0 && i < NVRAM_BYTES; --count, ++i, ++p)
+		__nvram_write_byte(*p, i);
+
+	__nvram_set_checksum();
+
+	spin_unlock_irq(&rtc_lock);
+
+	*ppos = i;
+	return p - buf;
+}
+
+static ssize_t nvram_get_size(void)
+{
+	return NVRAM_BYTES;
+}
+
+const struct nvram_ops arch_nvram_ops = {
+	.read           = nvram_read,
+	.write          = nvram_write,
+	.get_size       = nvram_get_size,
+};
+EXPORT_SYMBOL(arch_nvram_ops);
+
 #ifdef CONFIG_PROC_FS
 static struct {
 	unsigned char val;
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 99e5729d910d..f55d13e400da 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -760,13 +760,15 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 #ifdef CONFIG_NVRAM
 	else
 		/* Test if a host id is set in the NVRam */
-		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
-			unsigned char b = nvram_read_byte(16);
+		if (ATARIHW_PRESENT(TT_CLK)) {
+			unsigned char b;
+			loff_t offset = 16;
+			ssize_t count = arch_nvram_ops.read(&b, 1, &offset);
 
 			/* Arbitration enabled? (for TOS)
 			 * If yes, use configured host ID
 			 */
-			if (b & 0x80)
+			if ((count == 1) && (b & 0x80))
 				atari_scsi_template.this_id = b & 7;
 		}
 #endif
diff --git a/include/linux/nvram.h b/include/linux/nvram.h
index 28bfb9ab94ca..4f78147e74d9 100644
--- a/include/linux/nvram.h
+++ b/include/linux/nvram.h
@@ -11,4 +11,13 @@ extern void __nvram_write_byte(unsigned char c, int i);
 extern void nvram_write_byte(unsigned char c, int i);
 extern int __nvram_check_checksum(void);
 extern int nvram_check_checksum(void);
+
+struct nvram_ops {
+	ssize_t         (*read)(char *, size_t, loff_t *);
+	ssize_t         (*write)(char *, size_t, loff_t *);
+	ssize_t         (*get_size)(void);
+};
+
+extern const struct nvram_ops arch_nvram_ops;
+
 #endif  /* _LINUX_NVRAM_H */
-- 
2.19.2
