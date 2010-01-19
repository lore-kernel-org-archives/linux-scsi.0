From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] bfa: comparison with wrong msgtag in bfa_pport_isr()
Date: Tue, 19 Jan 2010 21:17:51 +0100
Message-ID: <4B56136F.3070709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754999Ab0ASUM6@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Compare it with the disable msgtag.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this maybe intended? otherwise in case BFI_PPORT_I2H_ENABLE_RSP:
the same code is executed. Please review.

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index aef648b..f00d07b 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -918,7 +918,7 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+		if (pport->msgtag == i2hmsg.disable_rsp->msgtag)
 			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
 		break;
 
