From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCHv2] pm80xx: fix Adaptec 71605H hang
Date: Fri, 26 Jul 2013 19:51:42 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501BED6A1@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <51F2A741.1020702@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:57884 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983Ab3G0Cvz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jul 2013 22:51:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <51F2A741.1020702@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-scsi@vger.kernel.org
Cc: lindar_liu@usish.com, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, xjtuwjp@gmail.com

Hi Hans,

Thanks for addressing the comment.

Acked-by: AnandKumar.Santhanam@pmcs.com

Regards
Anand



-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Friday, July 26, 2013 10:14 PM
To: linux-scsi@vger.kernel.org
Cc: Anand Kumar Santhanam; lindar_liu@usish.com; Sangeetha Gnanasekaran;
xjtuwjp@gmail.com
Subject: [PATCHv2] pm80xx: fix Adaptec 71605H hang

The IO command size is 128 bytes for these new controllers as opposed to
64 for the old 8001 controller.

The Adaptec out-of-tree driver did this correctly. After comparing the
two this turned out to be the crucial difference.

So don't hardcode the IO command size, instead use pm8001_ha->iomb_size
as that is the correct value for both old and new controllers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.10 and up
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 69dd49c..ce3f129d 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -221,7 +221,7 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt
= 0x01;
 	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16)
| (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB +
i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -247,7 +247,7 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16)
| (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB +
i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
b/drivers/scsi/pm8001/pm80xx_hwi.c
index 302514d..e1c4896 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -275,7 +275,7 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 
 	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16)
| (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB +
i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -301,7 +301,7 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16)
| (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB +
i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
--
1.8.3.2


