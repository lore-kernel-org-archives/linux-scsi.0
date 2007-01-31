From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 09:24:30 -0600
Message-ID: <1170257071.3402.6.camel@mulgrave.il.steeleye.com>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com>
	 <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
	 <45C0B211.2030305@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030205AbXAaPYi@vger.kernel.org>
In-Reply-To: <45C0B211.2030305@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-01-31 at 10:13 -0500, Mark Lord wrote:
> James Bottomley wrote:
> >
> > For the MD case, this is what REQ_FAILFAST is for.

> I cannot find where SCSI honours that flag.  James?

Er, it's in scsi_error.c:scsi_decide_disposition():

      maybe_retry:

	/* we requeue for retry because the error was retryable, and
	 * the request was not marked fast fail.  Note that above,
	 * even if the request is marked fast fail, we still requeue
	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
	if ((++scmd->retries) <= scmd->allowed
	    && !blk_noretry_request(scmd->request)) {
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		return NEEDS_RETRY;
	} else {
		/*
		 * no more retries - report this one back to upper level.
		 */
		return SUCCESS;
	}

> And for that matter, even when I patch SCSI so that it *does* honour it,
> I don't actually see the flag making it into the SCSI layer from above.
> 
> And I don't see where/how the block layer takes care when considering
> merge FAILFAST/READA requests with non FAILFAST/READA requests.
> To me, it looks perfectly happy to add non-FAILFAST/READA bios
> to a FAILFAST request, risking data loss if a lower-layer decides
> to honour the FAILFAST/READA flags.
> 
> So it's a pretty Good Thing(tm) that SCSI doesn't currently honour it. ;)

James
