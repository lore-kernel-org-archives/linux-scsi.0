From: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>
Subject: [mpt3sas driver 02/10] mpt3sas: Used IEEE SGL instead of MPI SGL while framing a SMP Passthrough request message.
Date: Thu, 28 Jan 2016 12:06:59 +0530
Message-ID: <1453963027-19770-3-git-send-email-suganath-prabu.subramani@avagotech.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

As driver was using MPI SGL while framing the SMP Passthrough request
message due to which firmware unable to post the Reply Data in the host
memory and timeout is observed for this SMP Passthrough request message
and so unable to perform phy disable operation.

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index ca36d7e..df08aeb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1418,7 +1418,6 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	u32 ioc_state;
 	unsigned long timeleft;
 	void *psge;
-	u32 sgl_flags;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
@@ -1507,24 +1506,10 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	    cpu_to_le16(sizeof(struct phy_error_log_request));
 	psge = &mpi_request->SGL;
 
-	/* WRITE sgel first */
-	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
-	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
-	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	ioc->base_add_sg_single(psge, sgl_flags |
-	    sizeof(struct phy_control_request), data_out_dma);
-
-	/* incr sgel */
-	psge += ioc->sge_size;
-
-	/* READ sgel last */
-	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
-	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
-	    MPI2_SGE_FLAGS_END_OF_LIST);
-	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	ioc->base_add_sg_single(psge, sgl_flags |
-	    sizeof(struct phy_control_reply), data_out_dma +
-	    sizeof(struct phy_control_request));
+	ioc->build_sg(ioc, psge, data_out_dma,
+			    sizeof(struct phy_control_request),
+	    data_out_dma + sizeof(struct phy_control_request),
+	    sizeof(struct phy_control_reply));
 
 	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
 		"phy_control - send to sas_addr(0x%016llx), phy(%d), opcode(%d)\n",
-- 
1.8.3.1
