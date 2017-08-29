From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: [PATCH 3/3] scsi: aacraid: report -ENOMEM to upper layer from aac_convert_sgraw2()
Date: Tue, 29 Aug 2017 13:59:04 +0200
Message-ID: <29ed79bb97060429247eeafc9d6d8f6793a7f6b5.1504007944.git.npajkovsky@suse.cz>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
In-Reply-To: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Nikola Pajkovsky <npajkovsky@suse.cz>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

aac_convert_sgraw2() kmalloc memory and return -1 on error, which
should be -ENOMEM. However, nobody is checking return value, so with
this change, -ENOMEM is propagated to upper layer.

Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
---
 drivers/scsi/aacraid/aachba.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 3c354766791e..ca38c2b52b47 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3956,8 +3956,12 @@ static long aac_build_sgraw2(struct scsi_cmnd *scsicmd,
 			if (!err_found)
 				break;
 		}
-		if (i > 0 && nseg_new <= sg_max)
-			aac_convert_sgraw2(rio2, i, nseg, nseg_new);
+		if (i > 0 && nseg_new <= sg_max) {
+			int ret = aac_convert_sgraw2(rio2, i, nseg, nseg_new);
+
+			if (ret < 0)
+				return ret;
+		}
 	} else
 		rio2->flags |= cpu_to_le16(RIO2_SGL_CONFORMANT);
 
@@ -3981,7 +3985,7 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 
 	sge = kmalloc(nseg_new * sizeof(struct sge_ieee1212), GFP_ATOMIC);
 	if (sge == NULL)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 1, pos = 1; i < nseg-1; ++i) {
 		for (j = 0; j < rio2->sge[i].length / (pages * PAGE_SIZE); ++j) {
-- 
2.13.5
