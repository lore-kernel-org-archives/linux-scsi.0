From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc: scsi/sd.c: use number-based device counting
Date: Wed, 6 Oct 2010 16:24:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010061613080.27021@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59864 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0JFOYa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 10:24:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

parent 4f91fd25ab1a0d5e475c336286d5c5e697583331 (v2.6.36-rc3-978-g4f91fd2)
commit dcc5ea2d228e6f0daf4a33eec5a54b23cb673c94
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 6 15:40:28 2010 +0200

scsi/sd.c: use number-based device counting

Switch sd over to number-based enumeration of disks, like many others
already do (e.g. sg, sr, md). On many systems, sd is the only remaining
driver to use the old a-z numbering (ls /dev/*a; exclude vcsa).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/scsi/Kconfig |   10 ++++++++++
 drivers/scsi/sd.c    |   11 +++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index bbf91ae..5590d07 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -88,6 +88,16 @@ config BLK_DEV_SD
 	  In this case, do not compile the driver for your SCSI host adapter
 	  (below) as a module either.
 
+config BLK_DEV_SD_NIDX
+	bool "Use 0-9 for disk indices rather than a-z"
+	depends on BLK_DEV_SD
+	---help---
+	Traditionally, the sd driver used "sda".."sdzzz" to enumerate its
+	disks. Enabling this option changes this behavior to enumerate it with
+	the numeric index ("sd0".."sd999") like most other drivers already do
+	(such as sg, sr and md). Note that the block layer will intersperse a
+	'p' to wall the off disk index from partition number, e.g. "sd0p1".
+
 config CHR_DEV_ST
 	tristate "SCSI tape support"
 	depends on SCSI
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2714bec..f825e86 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2206,14 +2206,21 @@ static void sd_unlock_native_capacity(struct gendisk *disk)
  *	determined using similar method as 26 base conversion with the
  *	index shifted -1 after each digit is computed.
  *
+ *	With BLK_DEV_SD_NIDX, all of this is skipped and the normal
+ *	index is directly used.
+ *
  *	CONTEXT:
  *	Don't care.
  *
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
+static int sd_format_disk_name(const char *prefix, int index, char *buf,
+			       int buflen)
 {
+#ifdef CONFIG_BLK_DEV_SD_NIDX
+	snprintf(buf, buflen, "sd%u", index);
+#else
 	const int base = 'z' - 'a' + 1;
 	char *begin = buf + strlen(prefix);
 	char *end = buf + buflen;
@@ -2232,7 +2239,7 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 
 	memmove(begin, p, end - p);
 	memcpy(buf, prefix, strlen(prefix));
-
+#endif /* CONFIG_BLK_DEV_SD_NIDX */
 	return 0;
 }
 
-- 
# Created with git-export-patch

