From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.11-rc7
Date: Sat, 31 Aug 2013 09:53:05 -0700
Message-ID: <1377967985.2149.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49048 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026Ab3HaQxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 12:53:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a bug fix for the pm80xx driver.  It turns out that when the new
hardware support was added in 3.10 the IO command size was kept at the
old hard coded value.  This means that the driver attaches to some new
cards and then simply hangs the system.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Hans Verkuil (1):
      pm80xx: fix Adaptec 71605H hang

And the diffstat

 drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

With full diff attached below.

James

---

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 5456f5c..4a21957 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -221,7 +221,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
 	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -247,7 +247,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7f77210..9f91030 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -275,7 +275,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 
 	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -301,7 +301,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=


