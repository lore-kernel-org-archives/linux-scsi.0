From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v9 04/22] nvram: Replace nvram_* function exports with static
 functions
Date: Tue, 15 Jan 2019 15:18:56 +1100
Message-ID: <7de1ad4d2647a5c4df703afa66705195f4d843f9.1547525936.git.fthain@telegraphics.com.au>
References: <cover.1547525936.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1547525936.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace nvram_* functions with static functions in nvram.h. These will
become wrappers for struct nvram_ops method calls.

This patch effectively disables existing NVRAM functionality so as to
allow the rest of the series to be bisected without build failures.
That functionality is gradually re-implemented in subsequent patches.

Replace the sole validate-checksum-and-read-byte sequence with a call to
nvram_read() which will gain the same semantics in subsequent patches.

Remove unused exports.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 arch/m68k/atari/nvram.c   | 39 +++------------------------------------
 drivers/char/nvram.c      | 27 +++++----------------------
 drivers/scsi/atari_scsi.c |  8 +++++---
 include/linux/nvram.h     | 32 +++++++++++++++++++++++++-------
 4 files changed, 38 insertions(+), 68 deletions(-)

diff --git a/arch/m68k/atari/nvram.c b/arch/m68k/atari/nvram.c
index a8c457e40b0b..1d767847ffa6 100644
--- a/arch/m68k/atari/nvram.c
+++ b/arch/m68k/atari/nvram.c
@@ -34,38 +34,17 @@
  * periodic 11 min sync from kernel/time/ntp.c vs. this driver.)
  */
 
-unsigned char __nvram_read_byte(int i)
+static unsigned char __nvram_read_byte(int i)
 {
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
-void __nvram_write_byte(unsigned char c, int i)
+static void __nvram_write_byte(unsigned char c, int i)
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
@@ -73,7 +52,7 @@ void nvram_write_byte(unsigned char c, int i)
 #define ATARI_CKS_RANGE_END	47
 #define ATARI_CKS_LOC		48
 
-int __nvram_check_checksum(void)
+static int __nvram_check_checksum(void)
 {
 	int i;
 	unsigned char sum = 0;
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
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index c660cff9faf4..c98775bfd896 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -74,13 +74,12 @@ static int nvram_open_mode;	/* special open modes */
  * periodic 11 min sync from kernel/time/ntp.c vs. this driver.)
  */
 
-unsigned char __nvram_read_byte(int i)
+static unsigned char __nvram_read_byte(int i)
 {
 	return CMOS_READ(NVRAM_FIRST_BYTE + i);
 }
-EXPORT_SYMBOL(__nvram_read_byte);
 
-unsigned char nvram_read_byte(int i)
+static unsigned char pc_nvram_read_byte(int i)
 {
 	unsigned long flags;
 	unsigned char c;
@@ -90,16 +89,14 @@ unsigned char nvram_read_byte(int i)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return c;
 }
-EXPORT_SYMBOL(nvram_read_byte);
 
 /* This races nicely with trying to read with checksum checking (nvram_read) */
-void __nvram_write_byte(unsigned char c, int i)
+static void __nvram_write_byte(unsigned char c, int i)
 {
 	CMOS_WRITE(c, NVRAM_FIRST_BYTE + i);
 }
-EXPORT_SYMBOL(__nvram_write_byte);
 
-void nvram_write_byte(unsigned char c, int i)
+static void pc_nvram_write_byte(unsigned char c, int i)
 {
 	unsigned long flags;
 
@@ -107,14 +104,13 @@ void nvram_write_byte(unsigned char c, int i)
 	__nvram_write_byte(c, i);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 }
-EXPORT_SYMBOL(nvram_write_byte);
 
 /* On PCs, the checksum is built only over bytes 2..31 */
 #define PC_CKS_RANGE_START	2
 #define PC_CKS_RANGE_END	31
 #define PC_CKS_LOC		32
 
-int __nvram_check_checksum(void)
+static int __nvram_check_checksum(void)
 {
 	int i;
 	unsigned short sum = 0;
@@ -126,19 +122,6 @@ int __nvram_check_checksum(void)
 	    __nvram_read_byte(PC_CKS_LOC+1);
 	return (sum & 0xffff) == expect;
 }
-EXPORT_SYMBOL(__nvram_check_checksum);
-
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
 
 static void __nvram_set_checksum(void)
 {
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 78b43200c99e..e809493d0d06 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -759,13 +759,15 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 		atari_scsi_template.this_id = setup_hostid & 7;
 	} else if (IS_REACHABLE(CONFIG_NVRAM)) {
 		/* Test if a host id is set in the NVRam */
-		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
-			unsigned char b = nvram_read_byte(16);
+		if (ATARIHW_PRESENT(TT_CLK)) {
+			unsigned char b;
+			loff_t offset = 16;
+			ssize_t count = nvram_read(&b, 1, &offset);
 
 			/* Arbitration enabled? (for TOS)
 			 * If yes, use configured host ID
 			 */
-			if (b & 0x80)
+			if ((count == 1) && (b & 0x80))
 				atari_scsi_template.this_id = b & 7;
 		}
 	}
diff --git a/include/linux/nvram.h b/include/linux/nvram.h
index 28bfb9ab94ca..eb5b52a9a747 100644
--- a/include/linux/nvram.h
+++ b/include/linux/nvram.h
@@ -2,13 +2,31 @@
 #ifndef _LINUX_NVRAM_H
 #define _LINUX_NVRAM_H
 
+#include <linux/errno.h>
 #include <uapi/linux/nvram.h>
 
-/* __foo is foo without grabbing the rtc_lock - get it yourself */
-extern unsigned char __nvram_read_byte(int i);
-extern unsigned char nvram_read_byte(int i);
-extern void __nvram_write_byte(unsigned char c, int i);
-extern void nvram_write_byte(unsigned char c, int i);
-extern int __nvram_check_checksum(void);
-extern int nvram_check_checksum(void);
+static inline ssize_t nvram_get_size(void)
+{
+	return -ENODEV;
+}
+
+static inline unsigned char nvram_read_byte(int addr)
+{
+	return 0xFF;
+}
+
+static inline void nvram_write_byte(unsigned char val, int addr)
+{
+}
+
+static inline ssize_t nvram_read(char *buf, size_t count, loff_t *ppos)
+{
+	return -ENODEV;
+}
+
+static inline ssize_t nvram_write(char *buf, size_t count, loff_t *ppos)
+{
+	return -ENODEV;
+}
+
 #endif  /* _LINUX_NVRAM_H */
-- 
2.19.2
