From: akpm@osdl.org
Subject: [patch 32/45] aic94xx: SATA tag mask not set correctly
Date: Fri, 20 Oct 2006 14:48:30 -0700
Message-ID: <200610202148.k9KLmUJM004171@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55686 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992780AbWJTVsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, djwong@us.ibm.com

From: "Darrick J. Wong" <djwong@us.ibm.com>

The aic94xx controller has a bitmask establishing which tags are ok to use
with a SATA NCQ disk.  When the queue depth is 32, however, the expression
that is used sets the mask to zero, not 0xFFFFFFFF.  This patch widens the
width of the integer so that this case is handled properly.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic94xx/aic94xx_dev.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic94xx/aic94xx_dev.c~aic94xx-sata-tag-mask-not-set-correctly drivers/scsi/aic94xx/aic94xx_dev.c
--- a/drivers/scsi/aic94xx/aic94xx_dev.c~aic94xx-sata-tag-mask-not-set-correctly
+++ a/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -134,7 +134,7 @@ static inline int asd_init_sata(struct d
 		if (w76 & 0x100) /* NCQ? */
 			qdepth = (w75 & 0x1F) + 1;
 		asd_ddbsite_write_dword(asd_ha, ddb, SATA_TAG_ALLOC_MASK,
-					(1<<qdepth)-1);
+					(1ULL<<qdepth)-1);
 		asd_ddbsite_write_byte(asd_ha, ddb, NUM_SATA_TAGS, qdepth);
 	}
 	if (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM ||
_
