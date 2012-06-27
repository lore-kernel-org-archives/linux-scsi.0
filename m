From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [patch -resend] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()
Date: Wed, 27 Jun 2012 10:44:56 -0700
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A28396BCE90@HQ1-EXCH02.corp.brocade.com>
References: <20120627085800.GA3007@mwanda>
 <20120627085936.GA31212@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120627085936.GA31212@elgon.mountain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>, Jing Huang <huangj@Brocade.COM>
Cc: "'James E.J. Bottomley'" <JBottomley@parallels.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'kernel-janitors@vger.kernel.org'" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, June 27, 2012 2:00 AM
To: Jing Huang
Cc: Krishna Gudipati; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch -resend] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()

If mc == BFI_MC_MAX then we're reading past the end of the
mod->mbhdlr[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Wed, 6 Jul 2011.

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 14e6284..8cdb79c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2357,7 +2357,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 			return;
 		}
 
-		if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
+		if ((mc >= BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
 			return;
 
 		mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);


-----

Thanks for the patch.

Acked-by: Krishna Gudipati <kgudipat@brocade.com>
