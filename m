From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [0/8]  qla2xxx: Summary of changes...
Date: Tue, 7 Sep 2004 11:34:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907183459.GB2288@praka.san.rr.com>
References: <20040907042603.GA29557@praka.san.rr.com> <1094536856.2801.3.camel@laptop.fenrus.com> <1094566150.1716.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:8902 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S268450AbUIGShJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 14:37:09 -0400
Content-Disposition: inline
In-Reply-To: <1094566150.1716.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 07 Sep 2004, James Bottomley wrote:

> On Tue, 2004-09-07 at 02:00, Arjan van de Ven wrote:
> > I found a "funky" bug the other day with this driver; I was testing on a
> > RAID device of which I won't mention the vendor, but it had the habit of
> > returning QUEUE FULL when it's internal queue was full, with multiple
> > luns active that could even be on a lun which had exactly zero
> > outstanding IO already. The qlogic driver happily takes the number of
> > outstanding commands (0) and subtracts 1 from it to guestimate the
> > max... needless to say that didn't go down to well :-) Sounds like a
> > bound check would make sense here...
> 
> Actually, this isn't at all unusual.  RAID devices often have a single
> memory pool for all the LUN queues.  Heavy activity on a set of LUNs can
> lead to no resources for a command on others.
> 
> Although we have queue full tracking, predicting the behaviour on
> devices with coupled queues like this is impossible.
> 


> However, I thought the qlogic driver used the mid-layer queue full
> tracking, which takes all of this into account and won't adjust the
> depth below a certain number (8 I think).
> 

It does.  Relevant code from qla_isr.c:

	case CS_QUEUE_FULL:

		...

                /* Adjust queue depth */
                ret = scsi_track_queue_full(cp->device,
                    sp->lun_queue->out_cnt - 1);
                if (ret) {
			...

Now, sp->lun_queue->out_cnt at this point should at least be >= 1, so
conceivably we could be passing 0 for the second argument.  But,
scsi_track_queue_full() as James points out should handle this and
drop the depth to cmd_per_lun.

		...
		if (sdev->last_queue_full_depth < 8) {
			/* Drop back to untagged */
			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
			return -1;
		}

Do we want checks for this case in all LLDDs who use the mid-layer
API?

Regards,
Andrew Vasquez
