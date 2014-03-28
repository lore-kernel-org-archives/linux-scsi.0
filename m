From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Deadlock in usb-storage error handling
Date: Fri, 28 Mar 2014 09:52:22 -0700
Message-ID: <1396025542.15365.17.camel@dabdike>
References: <Pine.LNX.4.44L0.1403201548160.866-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44089 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbaC1QwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 12:52:25 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403201548160.866-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-03-20 at 15:49 -0400, Alan Stern wrote:
> On Thu, 20 Mar 2014, James Bottomley wrote:
> 
> > On Thu, 2014-03-20 at 12:34 -0400, Alan Stern wrote:
> > > On Thu, 20 Mar 2014, James Bottomley wrote:
> > > 
> > > > OK, so I think we have three things to do
> > > > 
> > > >      1. Investigate SCSI and fix it's abort state problem that's causing
> > > >         it not to send the abort second time around
> > > >      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
> > > >         with outstanding commands)
> > > >      3. Find out why we're sending a spurious request sense.
> > > > 
> > > > I can look at 1 and 3 if you want to take 2.
> > > 
> > > It's a deal!  Thanks for your help.
> > 
> > OK, I think this is the fix for 1, if you could try it out.
> > 
> > Thanks,
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 771c16b..c52bfb2 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -145,14 +145,14 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  						    "scmd %p retry "
> >  						    "aborted command\n", scmd));
> >  				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> > -				return;
> > +				goto out;
> >  			} else {
> >  				SCSI_LOG_ERROR_RECOVERY(3,
> >  					scmd_printk(KERN_WARNING, scmd,
> >  						    "scmd %p finish "
> >  						    "aborted command\n", scmd));
> >  				scsi_finish_command(scmd);
> > -				return;
> > +				goto out;
> >  			}
> >  		} else {
> >  			SCSI_LOG_ERROR_RECOVERY(3,
> > @@ -162,6 +162,8 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  		}
> >  	}
> >  
> > +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> > +
> >  	if (!scsi_eh_scmd_add(scmd, 0)) {
> >  		SCSI_LOG_ERROR_RECOVERY(3,
> >  			scmd_printk(KERN_WARNING, scmd,
> > @@ -170,6 +172,10 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  		scmd->result |= DID_TIME_OUT << 16;
> >  		scsi_finish_command(scmd);
> >  	}
> > +	return;
> > + out:
> > +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> > +	return;
> >  }
> >  
> >  /**
> 
> This worked the first time.  :-)
> 
> But I wonder, is it safe to access scmd after calling 
> scsi_finish_command()?

Agree, I've redone the patch integrated into the try_to_abort call
instead.  Will post shortly.

James



