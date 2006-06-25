From: akpm@osdl.org
Subject: [patch 21/26] Bogus disk geometry on large disks
Date: Sun, 25 Jun 2006 01:58:58 -0700
Message-ID: <200606250858.k5P8wwHw021243@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42645 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932116AbWFYI71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 04:59:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com, willy@debian.org


From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We currently stuff a truncated size into the geometry logic and return the
result which can produce bizarre reports for a 4Tb array.  Since that
mapping logic isn't useful for disks that big don't try and map this way at
all.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsicam.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsicam.c~bogus-disk-geometry-on-large-disks drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c~bogus-disk-geometry-on-large-disks
+++ a/drivers/scsi/scsicam.c
@@ -57,6 +57,7 @@ EXPORT_SYMBOL(scsi_bios_ptable);
 int scsicam_bios_param(struct block_device *bdev, sector_t capacity, int *ip)
 {
 	unsigned char *p;
+	u64 capacity64 = capacity;	/* Suppress gcc warning */
 	int ret;
 
 	p = scsi_bios_ptable(bdev);
@@ -68,7 +69,7 @@ int scsicam_bios_param(struct block_devi
 			       (unsigned int *)ip + 0, (unsigned int *)ip + 1);
 	kfree(p);
 
-	if (ret == -1) {
+	if (ret == -1 && capacity64 < (1ULL << 32)) {
 		/* pick some standard mapping with at most 1024 cylinders,
 		   and at most 62 sectors per track - this works up to
 		   7905 MB */
_
