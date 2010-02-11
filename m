From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Thu, 11 Feb 2010 03:08:52 -0800
Message-ID: <20100211110852.GB8237@linux-qf4p>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53982 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0BKLHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 06:07:41 -0500
Content-Disposition: inline
In-Reply-To: <4B671BFC.90107@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On Mon, 01 Feb 2010, Mike Christie wrote:
> 
> On 01/30/2010 12:28 AM, Ravi Anand wrote:
> >
> > -		msleep(2000);
> > -	} while (max_wait_time--);
> > +		if (got_ref&&  (atomic_read(&rp->ref_count) == 1)) {
> > +			done++;
> > +			break;
> > +		}
> > +
> > +		msleep(ABORT_POLLING_PERIOD);
> 
> 
> Did you want to use krefs for the refcounting?

We will add it to our to do list and submit a patch later on.
For right now we will like to stick to it as kref will require
additional testing.

> And why is this so funky (got_ref arg and refcount peak) compared to the 
> qla2xxx one?

I don't think qla2xxx is doing any reference counting in eh_abort() path. 
Basically its trying to differentiate for case where it takes an additional
reference when the cmd is with the F/W. In that case if its the last guy, 
then it can go ahead and complete the command.

Hope this helps.

THanks
Ravi



