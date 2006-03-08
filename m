From: akpm@osdl.org
Subject: [patch 25/28] aacraid: fix the comparison with sizeof()
Date: Wed, 08 Mar 2006 00:14:41 -0800
Message-ID: <200603080816.k288GUd4002250@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:45996 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932497AbWCHIQf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, tiwai@suse.de


From: Takashi Iwai <tiwai@suse.de>

Fix the comparison with sizeof() in min() macro.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aacraid/aachba.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-fix-the-comparison-with-sizeof drivers/scsi/aacraid/aachba.c
--- devel/drivers/scsi/aacraid/aachba.c~aacraid-fix-the-comparison-with-sizeof	2006-03-08 00:13:07.000000000 -0800
+++ devel-akpm/drivers/scsi/aacraid/aachba.c	2006-03-08 00:13:07.000000000 -0800
@@ -1597,13 +1597,13 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		cp[11] = 0;
 		cp[12] = 0;
 		aac_internal_transfer(scsicmd, cp, 0,
-		  min((unsigned int)scsicmd->cmnd[13], sizeof(cp)));
+		  min((size_t)scsicmd->cmnd[13], sizeof(cp)));
 		if (sizeof(cp) < scsicmd->cmnd[13]) {
 			unsigned int len, offset = sizeof(cp);
 
 			memset(cp, 0, offset);
 			do {
-				len = min(scsicmd->cmnd[13]-offset, sizeof(cp));
+				len = min((size_t)(scsicmd->cmnd[13]-offset), sizeof(cp));
 				aac_internal_transfer(scsicmd, cp, offset, len);
 			} while ((offset += len) < scsicmd->cmnd[13]);
 		}
_
