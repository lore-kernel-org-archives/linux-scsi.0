From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()
Date: Mon, 22 Mar 2010 21:48:59 +0100
Message-ID: <4BA7D7BB.1080506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:49553 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0CVUqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2010 16:46:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

It appears that the wrong fcport H2I message was tested

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this intended?

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index c589488..5e5e6fe 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1281,7 +1281,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.pdisable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
