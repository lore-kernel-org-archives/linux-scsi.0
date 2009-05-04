From: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Mon, 04 May 2009 10:41:02 -0300
Message-ID: <1241444469.8515.21.camel@zeppelin.austin.ibm.com>
References: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
	 <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
	 <49ECD89D.3000005@linux.vnet.ibm.com>
	 <1240846712.3387.18.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:52379 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZEDNmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 09:42:01 -0400
Received: from mailhub3.br.ibm.com (mailhub3.br.ibm.com [9.18.232.110])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n44DfuW2016157
	for <linux-scsi@vger.kernel.org>; Mon, 4 May 2009 10:41:56 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n44DgMx32142232
	for <linux-scsi@vger.kernel.org>; Mon, 4 May 2009 10:42:22 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n44DfwTx025387
	for <linux-scsi@vger.kernel.org>; Mon, 4 May 2009 10:41:58 -0300
In-Reply-To: <1240846712.3387.18.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-04-27 at 15:38 +0000, James Bottomley wrote:
> On Mon, 2009-04-20 at 15:18 -0500, Brian King wrote:
> > Kleber found the problem, debugged it, and provided a fix to me.
> > I provided him with an alternate patch to fix it. I'm assuming this
> > should have been handled by me submitting with my signoff alone and
> > adding a reported-by tag for Kleber. Sorry for the confusion. Shall
> > I resend as I just described?
> 
> The original patch has the tabs replaced by spaces problem, so an
> applyable patch correctly attributed would be appreciated.
> 
> James
> 
> 

Sending the patch again, now with tabs.

Kleber



The ipr driver can hang if it encounters enough PCI errors
to trigger the permanent error handler. The driver will attempt
to initiate a "bringdown" of the adapter and fail all pending
ops back. However, this bringdown is unlike any other bringdown
of the adapter in the code as the driver. In this code path we
end up failing back ops with allow_cmds still set to 1. This results
in some commands, the HCAM commands in particular, getting immediately
re-issued to the adapter on the done call, which results in
an infinite loop in ipr_fail_all_ops. Fix this by setting allow_cmds
to zero in this path. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index dd689de..d640359 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7003,6 +7003,7 @@ static void ipr_pci_perm_failure(struct pci_dev
*pdev)
 		ioa_cfg->sdt_state = ABORT_DUMP;
 	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES;
 	ioa_cfg->in_ioa_bringdown = 1;
+	ioa_cfg->allow_cmds = 0;
 	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 }
-- 
1.6.0.6



-- 
Kleber S. Souza
IBM Linux Technology Center

