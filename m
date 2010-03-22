From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()
Date: Mon, 22 Mar 2010 16:12:55 -0700
Message-ID: <04391A4E90BB2149B010D22452FA16876F6C9279@HQ-EXCH-6.corp.brocade.com>
References: <4BA7D7BB.1080506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:60097 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab0CVXNG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2010 19:13:06 -0400
In-Reply-To: <4BA7D7BB.1080506@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

This is not intended. Using penable_rsp or pdisable_rsp in this case doesn't have functional difference since it is a union, but it is confusing and should be fixed.

Thanks

Jing

-----Original Message-----
From: Roel Kluin [mailto:roel.kluin@gmail.com] 
Sent: Monday, March 22, 2010 1:49 PM
To: Jing Huang; linux-scsi@vger.kernel.org; Andrew Morton; LKML
Subject: [PATCH] bfa: wrong fcport H2I message tested in bfa_fcport_isr()

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
 
