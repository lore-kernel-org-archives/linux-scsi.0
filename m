From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6 patch] scsi/qla4xxx/ql4_isr.c: remove dead code
Date: Tue, 19 Feb 2008 18:35:59 -0800
Message-ID: <20080220023559.GF23759@plap3.qlogic.org>
References: <20080219192922.GH31955@cs181133002.pp.htv.fi> <1203473618.3103.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54006 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbYBTCgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 21:36:07 -0500
Content-Disposition: inline
In-Reply-To: <1203473618.3103.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, David Somayajulu <david.somayajulu@qlogic.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 19 Feb 2008, James Bottomley wrote:

> On Tue, 2008-02-19 at 21:29 +0200, Adrian Bunk wrote:
> > This patch removes dead code spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> >  drivers/scsi/qla4xxx/ql4_isr.c |   18 +-----------------
> >  1 file changed, 1 insertion(+), 17 deletions(-)
> > 
> > --- linux-2.6/drivers/scsi/qla4xxx/ql4_isr.c.old	2008-02-19 20:29:16.000000000 +0200
> > +++ linux-2.6/drivers/scsi/qla4xxx/ql4_isr.c	2008-02-19 20:30:37.000000000 +0200
> > @@ -91,38 +91,22 @@ static void qla4xxx_status_entry(struct 
> >  		if (scsi_status == 0) {
> >  			cmd->result = DID_OK << 16;
> >  			break;
> >  		}
> >  
> >  		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
> >  			cmd->result = DID_ERROR << 16;
> >  			break;
> >  		}
> >  
> > -		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
> > +		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER)
> >  			scsi_set_resid(cmd, residual);
> > -			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
> > -				cmd->underflow)) {
> > -
> > -				cmd->result = DID_ERROR << 16;
> > -
> > -				DEBUG2(printk("scsi%ld:%d:%d:%d: %s: "
> > -					"Mid-layer Data underrun0, "
> > -					"xferlen = 0x%x, "
> > -					"residual = 0x%x\n", ha->host_no,
> > -					cmd->device->channel,
> > -					cmd->device->id,
> > -					cmd->device->lun, __func__,
> > -					scsi_bufflen(cmd), residual));
> > -				break;
> > -			}
> > -		}
> 
> This code doesn't look dead to me, it looks to be enforcing
> cmd->underrun if set ... what makes the coverity checker think it can
> never be executed?

Hmm, guess it's the earlier 'if (scsi_status == 0)' check a few lines
up...  Dave S., can you take a look at this...  Thanks, av
