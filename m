From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 3/6] mpt3sas: Fix initial Reference tag field for 4K PI drives.
Date: Fri,  6 May 2016 14:29:28 +0530
Message-ID: <1462525171-6877-4-git-send-email-chaitra.basappa@broadcom.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Modified driver code to use scsi_prot_ref_tag() API instead of
scsi_get_lba(), while initializing reference tag field in the CDB.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 221f8bf..0fea937 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3961,7 +3961,7 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(scsi_get_lba(scmd));
+		    cpu_to_be32(scsi_prot_ref_tag(scmd));
 		break;
 
 	case SCSI_PROT_DIF_TYPE3:
-- 
1.8.3.1
