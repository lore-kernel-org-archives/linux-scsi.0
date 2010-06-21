From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/bfa: off by one in bfa_ioc_mbox_isr()
Date: Mon, 21 Jun 2010 08:45:08 +0200
Message-ID: <20100621064507.GA5940@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0FUGpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2010 02:45:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This should be ">=" here instead of ">" so that we don't read past the
end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index e038bc9..0ba624d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1595,7 +1595,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 		return;
 	}
 
-	if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
+	if ((mc >= BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
 		return;
 
 	mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);
