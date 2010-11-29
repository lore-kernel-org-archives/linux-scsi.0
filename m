From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] megaraid_sas: Convert SHT->queuecommand() to run
	host_lock-less
Date: Mon, 29 Nov 2010 12:54:35 -0800
Message-ID: <1291064075.17194.3.camel@haakon2.linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
	 <1290928656-31116-4-git-send-email-nab@linux-iscsi.org>
	 <20101129164100.GA22820@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60546 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0K2VAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 16:00:24 -0500
In-Reply-To: <20101129164100.GA22820@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@suse.de>

On Mon, 2010-11-29 at 17:41 +0100, Christoph Hellwig wrote:
> On Sat, Nov 27, 2010 at 11:17:36PM -0800, Nicholas A. Bellinger wrote:
> >  /**
> > - * megasas_get_cmd -	Get a command from the free pool
> > + * __megasas_get_cmd -	Get a command from the free pool
> >   * @instance:		Adapter soft state
> >   *
> >   * Returns a free command from the pool
> > + * Locking: Called with instance->cmd_pool_lock w/ spin_lock_irqsave
> >   */
> > -static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
> > -						  *instance)
> > +static struct megasas_cmd *
> > +__megasas_get_cmd(struct megasas_instance *instance)
> >  {
> > +	struct megasas_cmd *cmd;
> >  	unsigned long flags;
> > -	struct megasas_cmd *cmd = NULL;
> >  
> >  	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> 
> --- snip ---
> 
> > +static struct megasas_cmd *
> > +megasas_get_cmd(struct megasas_instance *instance)
> > +{
> > +	struct megasas_cmd *cmd;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> 
> I can't see how this works.
> 

Ugh, I had to recode patch #3 after accidently git resetting on the
wrong branch..

Thanks alot for spotting this, fixed with:

[lock_less-LLDs-for-38-v2 13a4cd2] megaraid_sas: Remove bogus hba_lock __megasas_get_cmd()
 1 files changed, 0 insertions(+), 3 deletions(-)

Thanks!

--nab

