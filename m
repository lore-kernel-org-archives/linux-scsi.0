From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [4/18]  qla2xxx: ISR RISC paused fixes
Date: Mon, 21 Jun 2004 22:51:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055117.GA8411@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:33956 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266592AbUFVFrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:47:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1840 04/06/03 15:59:16 andrew.vasquez@apc.qlogic.com +1 -0
  Problem reported/corrected by Michael Reed [mdr@sgi.com]:
  
  We have a 2312 that puts the 8.00.00b12-k qla2xxx driver
  into an infinite loop with a solid interrupt, 0x8008,
  hcsr = 0x7430, risc status register 0x40008110,
  immediately after enabling parity on the board.
  
  It looks as though the early out test in
  qla_isr.c:qla2x00_intr_handler() against stat is broken.
  HSR_RISC_PAUSED is set.  Also, there's a stale mailbox
  completion flagged (stat&0xff) which will short circuit
  the default case in the switch if it got that far.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_isr.c |   47 +++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:37:09 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:37:09 -07:00
@@ -109,7 +109,25 @@
 			}
 		} else /* IS_QLA23XX(ha) */ {
 			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-			if ((stat & HSR_RISC_INT) == 0)
+			if (stat & HSR_RISC_PAUSED) {
+				hccr = RD_REG_WORD(&reg->hccr);
+				if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
+					qla_printk(KERN_INFO, ha,
+					    "Parity error -- HCCR=%x.\n", hccr);
+				else
+					qla_printk(KERN_INFO, ha,
+					    "RISC paused -- HCCR=%x\n", hccr);
+
+				/*
+				 * Issue a "HARD" reset in order for the RISC
+				 * interrupt bit to be cleared.  Schedule a big
+				 * hammmer to get out of the RISC PAUSED state.
+				 */
+				WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+				RD_REG_WORD(&reg->hccr);
+				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				break;
+			} else if ((stat & HSR_RISC_INT) == 0)
 				break;
 
 			mbx = MSW(stat);
@@ -139,29 +157,9 @@
 				qla2x00_async_event(ha, mbx);
 				break;
 			default:
-				hccr = RD_REG_WORD(&reg->hccr);
-				if (hccr & HCCR_RISC_PAUSE) {
-					qla_printk(KERN_INFO, ha,
-					    "RISC paused, dumping HCCR=%x\n",
-					    hccr);
-
-					/*
-					 * Issue a "HARD" reset in order for
-					 * the RISC interrupt bit to be
-					 * cleared.  Schedule a big hammmer to
-					 * get out of the RISC PAUSED state.
-					 */
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_RESET_RISC);
-					RD_REG_WORD(&reg->hccr);
-					set_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags);
-					break;
-				} else {
-					DEBUG2(printk("scsi(%ld): Unrecognized "
-					    "interrupt type (%d)\n",
-					    ha->host_no, stat & 0xff));
-				}
+				DEBUG2(printk("scsi(%ld): Unrecognized "
+				    "interrupt type (%d)\n",
+				    ha->host_no, stat & 0xff));
 				break;
 			}
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
@@ -344,7 +342,6 @@
 		break;
 	}
 
-	mb[0] = LSW(mbx);
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:	/* Fast Post */
 		if (!ha->flags.online)
