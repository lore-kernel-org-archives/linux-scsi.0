From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] [SCSI] Fix abort state memory problem
Date: Mon, 31 Mar 2014 09:06:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403310905430.11739-100000@netrider.rowland.org>
References: <5339121E.50106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:52296 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752932AbaCaNGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 09:06:36 -0400
In-Reply-To: <5339121E.50106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 31 Mar 2014, Hannes Reinecke wrote:

> On 03/28/2014 06:49 PM, James Bottomley wrote:
> > The abort state is being stored persistently across commands, meaning if the
> > command times out a second time, the error handler thinks an abort is still
> > pending.  Fix this by properly resetting the abort flag after the abort is
> > finished.
> > 
> > Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > ---
> >  drivers/scsi/scsi_error.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 771c16b..b9f3b07 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -869,10 +869,13 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
> >  
> >  static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
> >  {
> > -	if (!hostt->eh_abort_handler)
> > -		return FAILED;
> > +	int retval = FAILED;
> > +
> > +	if (hostt->eh_abort_handler)
> > +		retval = hostt->eh_abort_handler(scmd);
> >  
> > -	return hostt->eh_abort_handler(scmd);
> > +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> > +	return retval;
> >  }
> >  
> >  static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
> > 
> Hmm. No, I don't think this is correct.
> 
> SCSI_EH_ABORT_SCHEDULED signifies whether scmd_eh_abort_handler()
> needs to run. As such it needs to be reset when the workqueue item
> is triggered.
> 
> Can you try with this instead?
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..9694803 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -120,6 +120,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>         struct scsi_device *sdev = scmd->device;
>         int rtn;
> 
> +       scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> +
>         if (scsi_host_eh_past_deadline(sdev->host)) {
>                 SCSI_LOG_ERROR_RECOVERY(3,
>                         scmd_printk(KERN_INFO, scmd,

This doesn't seem like a good idea either, because the flag is tested 
later on in scsi_decide_disposition().

Alan Stern

