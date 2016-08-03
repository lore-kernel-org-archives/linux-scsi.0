From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: Set READ FCP_XFER_READY DISABLED bit in PRLI
Date: Wed,  3 Aug 2016 16:36:52 -0500
Message-ID: <1470260213-19087-2-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The READ FCP_XFER_READY DISABLED bit is required to always be set to
one since FCP-3. Set it in the service parameter page frame during
process login.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ab67ec4..4a680ce 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3381,6 +3381,7 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
 	prli->parms.type = IBMVFC_SCSI_FCP_TYPE;
 	prli->parms.flags = cpu_to_be16(IBMVFC_PRLI_EST_IMG_PAIR);
 	prli->parms.service_parms = cpu_to_be32(IBMVFC_PRLI_INITIATOR_FUNC);
+	prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_READ_FCP_XFER_RDY_DISABLED);
 
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
-- 
2.7.4
