From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pm80xx: fix Adaptec 71605H hang
Date: Sun, 14 Jul 2013 10:25:01 +0200
Message-ID: <51E2605D.3000301@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2928 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3GNIZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jul 2013 04:25:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: AnandKumar.Santhanam@pmcs.com, lindar_liu@usish.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com

The IO command size is 128 bytes for these new controllers as opposed to 64
for the old 8001 controller.

The Adaptec out-of-tree driver did this correctly. After comparing the two
this turned out to be the crucial difference.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: AnandKumar.Santhanam@pmcs.com
Cc: stable@vger.kernel.org      # for v3.10 and up
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 302514d..e1db5ca 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -275,7 +275,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 
 	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (128 << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -301,7 +301,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (128 << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
-- 
1.8.3.2

