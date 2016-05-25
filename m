From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/2] mpt3sas - set num_phys after allocating phy[] space
Date: Wed, 25 May 2016 15:14:28 -0400
Message-ID: <1464203669-31974-2-git-send-email-joe.lawrence@stratus.com>
References: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0130.outbound.protection.outlook.com ([207.46.100.130]:28352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751485AbcEYTOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 15:14:44 -0400
In-Reply-To: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, Joe Lawrence <joe.lawrence@stratus.com>

In _scsih_sas_host_add, the number of HBA phys are determined and then
later used to allocate an array of struct  _sas_phy's.  If the routine
sets ioc->sas_hba.num_phys, but then fails to allocate the
ioc->sas_hba.phy array (by kcalloc error or other intermediate
error/exit path), ioc->sas_hba is left in a dangerous state: all readers
of ioc->sas_hba.phy[] do so by indexing it from 0..ioc->sas_hba.num_phys
without checking that the space was ever allocated.

Modify _scsih_sas_host_add to set ioc->sas_hba.num_phys only after
successfully allocating ioc->sas_hba.phy[].

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f2139e5604a3..6e36d20c9e0b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4893,13 +4893,22 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	u16 ioc_status;
 	u16 sz;
 	u8 device_missing_delay;
+	u8 num_phys;
 
-	mpt3sas_config_get_number_hba_phys(ioc, &ioc->sas_hba.num_phys);
-	if (!ioc->sas_hba.num_phys) {
+	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		return;
 	}
+	ioc->sas_hba.phy = kcalloc(num_phys,
+	    sizeof(struct _sas_phy), GFP_KERNEL);
+	if (!ioc->sas_hba.phy) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc->sas_hba.num_phys = num_phys;
 
 	/* sas_iounit page 0 */
 	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
@@ -4959,13 +4968,6 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 		    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
 
 	ioc->sas_hba.parent_dev = &ioc->shost->shost_gendev;
-	ioc->sas_hba.phy = kcalloc(ioc->sas_hba.num_phys,
-	    sizeof(struct _sas_phy), GFP_KERNEL);
-	if (!ioc->sas_hba.phy) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		goto out;
-	}
 	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
 		if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply, &phy_pg0,
 		    i))) {
-- 
1.8.3.1

