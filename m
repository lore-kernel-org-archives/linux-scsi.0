From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 08/10] mpt3sas: set EEDP-escape-flags for SAS35 devices.
Date: Thu, 20 Oct 2016 17:50:16 +0530
Message-ID: <1476966018-10457-9-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33999 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbcJTMVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 08:21:46 -0400
Received: by mail-qt0-f170.google.com with SMTP id q7so51388762qtq.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 05:21:45 -0700 (PDT)
In-Reply-To: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>

An UNMAP command on a PI formatted device will leave the Logical Block
Application Tag and Logical Block Reference Tag as all F's (for those LBAs
that are unmapped). To avoid IO errors if those LBAs are subsequently read
before they are written with valid tag fields, the MPI SCSI IO requests
need to set the EEDPFlags element EEDP Escape Mode field, Bits [7:6]
appropriately. A value of 2 should be set to disable all PI checks if the
Logical Block Application Tag is 0xFFFF for PI types 1 and 2.  A value
of 3 should be set to disable all PI checks if the Logical Block
Application Tag is 0xFFFF and the Logical Block Reference Tag is
0xFFFFFFFF for PI type 3.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a1c541d..c58f326 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3989,6 +3989,9 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 
 	mpi_request_3v->EEDPBlockSize =
 	    cpu_to_le16(scmd->device->sector_size);
+
+	if (ioc->is_gen35_ioc)
+		eedp_flags |= MPI25_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE;
 	mpi_request->EEDPFlags = cpu_to_le16(eedp_flags);
 }
 
-- 
1.8.3.1

