From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: megaraid_sas - intercepts cmd timeout and
	throttle io
Date: Thu, 10 May 2007 14:23:45 -0500
Message-ID: <1178825025.3712.11.camel@mulgrave.il.steeleye.com>
References: <1178805687.4681.7.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44617 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755760AbXEJTXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 15:23:54 -0400
In-Reply-To: <1178805687.4681.7.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumant.patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com

On Thu, 2007-05-10 at 07:01 -0700, Sumant Patro wrote:
> eh_timed_out call back (megasas_reset_timer) is used to throttle io to the adapter
> when it is called the first time for a scmd.
> The MEGASAS_FW_BUSY flag is set and can_queue reduced to 16. The can_queue is restored
> from completion routine in following two conditions : 5 seconds has elapsed and the # of
> outstanding cmds in FW is < 17.
> Also removed reserved fields from struct megasas_instance.

And the rest of the comments?

This is the cut out of all the ones I made, I think:

> > +static enum
> > +scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
> > +{
> > +     struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
> > +     struct megasas_instance *instance;
> > +     unsigned long flags;
> > +
> > +     if (cmd) {
> 
> I don't believe we can ever get a command timeout with no command, can
> we?
> 
> > +             if (time_after(jiffies, scmd->jiffies_at_alloc + 170 *
> HZ))
> > +                     return EH_NOT_HANDLED;
> 
> This 170s is a bit arbitrary ... surely you want it to be related to a
> multiple of scmd->timeout_per_command?


> > +             if (!(instance->flag & MEGASAS_FW_BUSY)) {
> > +                     /* FW is busy, throttle IO */
> > +                     spin_lock_irqsave(&instance->throttle_io_lock,
> flags);
> > +
> > +                     instance->host->can_queue = 16;
> 
> can_queue is protected by the host lock ... I think you need to dump
> the
> throttle_io_lock and simply use the host lock for all of this.


> > -     if (cmd->scmd) {
> > +     if (cmd->scmd)
> >               cmd->scmd->SCp.ptr = (char *)0;
> 
> That's NULL, ordinarily ...

James


