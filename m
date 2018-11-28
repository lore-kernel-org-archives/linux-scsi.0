From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 09/41] scsi: bfa: bfa_fcpim: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:27:08 -0600
Message-ID: <8f042a78366807fe4cf3c1f7157dc80f1dd49219.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that I replaced "Fall through !!!" with a "fall through"
annotation, which is what GCC is expecting to find.

Addresses-Coverity-ID: 114971 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/bfa/bfa_fcpim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 2c85f5b1f9c1..7e996bcf026c 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2586,6 +2586,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	case FCP_IODIR_RW:
 		bfa_stats(itnim, input_reqs);
 		bfa_stats(itnim, output_reqs);
+		/* fall through */
 	default:
 		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_fn_lpu(ioim->bfa));
 	}
@@ -2820,6 +2821,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	case BFI_IOIM_STS_TIMEDOUT:
 		bfa_stats(ioim->itnim, iocomp_timedout);
+		/* fall through */
 	case BFI_IOIM_STS_ABORTED:
 		rsp->io_status = BFI_IOIM_STS_ABORTED;
 		bfa_stats(ioim->itnim, iocomp_aborted);
@@ -3215,9 +3217,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 	switch (event) {
 	case BFA_TSKIM_SM_DONE:
 		bfa_reqq_wcancel(&tskim->reqq_wait);
-		/*
-		 * Fall through !!!
-		 */
+		/* fall through */
 	case BFA_TSKIM_SM_QRESUME:
 		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
 		bfa_tskim_send_abort(tskim);
-- 
2.17.1
