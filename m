From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] scsi: megaraid_sas - intercepts cmd timeout andthrottle io
Date: Thu, 10 May 2007 13:57:26 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229AB3446@NAMAIL2.ad.lsil.com>
References: <1178825025.3712.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55765 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXEJT5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 15:57:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1178825025.3712.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Sorry I had missed those comments.

Will address those and resubmit.

Regards,

Sumant 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, May 10, 2007 12:24 PM
To: Patro, Sumant
Cc: akpm@osdl.org; linux-scsi@vger.kernel.org; Kolli, Neela; Yang, Bo
Subject: Re: [PATCH] scsi: megaraid_sas - intercepts cmd timeout
andthrottle io

On Thu, 2007-05-10 at 07:01 -0700, Sumant Patro wrote:
> eh_timed_out call back (megasas_reset_timer) is used to throttle io to

> the adapter when it is called the first time for a scmd.
> The MEGASAS_FW_BUSY flag is set and can_queue reduced to 16. The 
> can_queue is restored from completion routine in following two 
> conditions : 5 seconds has elapsed and the # of outstanding cmds in FW
is < 17.
> Also removed reserved fields from struct megasas_instance.

And the rest of the comments?

This is the cut out of all the ones I made, I think:

> > +static enum
> > +scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd) {
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
> the throttle_io_lock and simply use the host lock for all of this.


> > -     if (cmd->scmd) {
> > +     if (cmd->scmd)
> >               cmd->scmd->SCp.ptr = (char *)0;
> 
> That's NULL, ordinarily ...

James


