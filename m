From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] scsi: mpt3sas: cleanup _scsih_pcie_enumeration_event()
Date: Wed, 8 Nov 2017 11:38:01 +0300
Message-ID: <20171108082101.wwseluw5bwnsgwue@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The indenting wasn't right, because the last two prints weren't
indented far enough.  Also it used pr_info() where it was supposed to
use pr_cont().  I reversed the if statement and pulled the code in one
tab and did a couple other minor cleanups.

Fixes: 4318c7347847 ("scsi: mpt3sas: Handle NVMe PCIe device related events generated from firmware.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3a9438a1704e..93b45e618edb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7700,17 +7700,18 @@ _scsih_pcie_enumeration_event(struct MPT3SAS_ADAPTER *ioc,
 	Mpi26EventDataPCIeEnumeration_t *event_data =
 		(Mpi26EventDataPCIeEnumeration_t *)fw_event->event_data;
 
-	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
-		pr_info(MPT3SAS_FMT "pcie enumeration event: (%s) Flag 0x%02x",
-			ioc->name,
-			((event_data->ReasonCode ==
-			MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
-			"started" : "completed"), event_data->Flags);
+	if (!(ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK))
+		return;
+
+	pr_info(MPT3SAS_FMT "pcie enumeration event: (%s) Flag 0x%02x",
+		ioc->name,
+		(event_data->ReasonCode == MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
+			"started" : "completed",
+		event_data->Flags);
 	if (event_data->EnumerationStatus)
-		pr_info("enumeration_status(0x%08x)",
-		    le32_to_cpu(event_data->EnumerationStatus));
-	pr_info("\n");
-	}
+		pr_cont("enumeration_status(0x%08x)",
+			le32_to_cpu(event_data->EnumerationStatus));
+	pr_cont("\n");
 }
 
 /**
