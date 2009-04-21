From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Date: Tue, 21 Apr 2009 15:00:10 -0700
Message-ID: <1240351210.10627.30.camel@nimitz>
References: <1240347174.10627.20.camel@nimitz>
	 <20090421211858.GA1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758290AbZDUWAu@vger.kernel.org>
In-Reply-To: <20090421211858.GA1926@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Here's a patch implementing Al's suggestion.  Not quite as trivial as
Matthew's, but even nicer aesthetically.  (Description stolen from
Matthew's patch).  I have verified that this fixes my issue.

--

Shifting an unsigned char implicitly casts it to a signed int.  This
caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
which was not supported by at least one drive.  Using the
get_unaligned_be*() helpers keeps us from having to worry about how the
extension might occur.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..c50142b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1344,12 +1345,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
-			(buffer[10] << 8) | buffer[11];
-	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
-		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
-		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
-		((u64)buffer[6] << 8) | (u64)buffer[7]);
+	sector_size = get_unaligned_be32(&buffer[8]);
+	lba =  get_unaligned_be64(&buffer[0]);
 
 	sd_read_protection_type(sdkp, buffer);
 
@@ -1400,10 +1397,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
-			(buffer[6] << 8) | buffer[7];
-	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
-		(buffer[2] << 8) | buffer[3];
+	sector_size = get_unaligned_be32(&buffer[4]);
+	lba = get_unaligned_be32(&buffer[0]);
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "


-- Dave
