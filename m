From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 24/41] scsi: lpfc: lpfc_hbadisc: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:31:23 -0600
Message-ID: <8db99b2700dd1589b8cf5ddb6b3de84dfe1e9f82.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that, in this particular case, I replaced "Drop thru" with a
"fall through" annotation, which is what GCC is expecting to find.

Addresses-Coverity-ID: 114976 ("Missing break in switch")
Addresses-Coverity-ID: 114977 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6c2fb55d739b..1a61806739ff 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4645,9 +4645,11 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->context_un.ndlp == ndlp)
 				return 1;
+			/* fall through */
 		case CMD_ELS_REQUEST64_CR:
 			if (icmd->un.elsreq64.remoteID == ndlp->nlp_DID)
 				return 1;
+			/* fall through */
 		case CMD_XMIT_ELS_RSP64_CX:
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
@@ -5791,7 +5793,7 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 
 	case LPFC_LINK_UP:
 		lpfc_issue_clear_la(phba, vport);
-		/* Drop thru */
+		/* fall through */
 	case LPFC_LINK_UNKNOWN:
 	case LPFC_WARM_START:
 	case LPFC_INIT_START:
-- 
2.17.1
