From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] lpfc: start to use new trasnport errors.
Date: Wed,  4 Jun 2008 20:41:44 -0500
Message-ID: <1212630106-13413-6-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-5-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-5-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This is only a test patch to get lpfc going. For the case I changed
it looked like the rport is deleted then we fail these IOs with
DID_BUS_BUSY so using DID_TRANSPORT_DISRUPTED was correct. In testing
the driver by stopping the fcp service on the target this worked.

I was not sure if maybe this bus busy:
                case IOSTAT_NPORT_BSY:
                case IOSTAT_FABRIC_BSY:
                        cmd->result = ScsiResult(DID_BUS_BUSY, 0);
should also be converted. For qla2xxx I thought we blocked the
rport for similar errors (at least the names sounded similar :)) and so I
used DID_TRANSPORT_DISRUPTED, but for lpfc I could not
hit this code and was not sure by just looking at it if it was exactly
the same, so I did not touch it in this patch.

I was also not sure about some cases where if I just unplugged a cable.
I would sometimes get IOSTAT_LOCAL_REJECT with IOERR_DEFAULT, so it seemed
like DID_ERROR was right for that, but I had seen that there is also
a IOERR_LINK_DOWN value. Maybe for that if we end up deleting the rport
we should be returning DID_TRANSPORT_DISRUPTED, but I was not able to
hit that case and was not able to tell from the code when I should, so
I did not touch it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0910a9a..83f7e43 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -590,7 +590,14 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
-			cmd->result = ScsiResult(DID_BUS_BUSY, SAM_STAT_BUSY);
+			/*
+			 * Port is not setup so fail IO with
+			 * DID_TRANSPORT_DISRUPTED, and allow the fc
+			 * class to determine what to do with it when
+			 * its timers fire.
+			 */
+			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED,
+						 SAM_STAT_BUSY);
 	} else {
 		cmd->result = ScsiResult(DID_OK, 0);
 	}
-- 
1.5.4.1
