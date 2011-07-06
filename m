From: Dan Carpenter <error27@gmail.com>
Subject: [patch 1/2] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()
Date: Wed, 6 Jul 2011 10:36:33 +0300
Message-ID: <20110706073633.GD18655@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If mc == BFI_MC_MAX then we're reading past the end of the
mod->mbhdlr[] array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index d6c2bf3..052373b 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2378,7 +2378,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 			return;
 		}
 
-		if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
+		if ((mc >= BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
 			return;
 
 		mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);
