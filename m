From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: making the queue_type attribute read only, was: Re: tag
 handling refactor V2
Date: Thu, 13 Nov 2014 00:33:41 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A10D8@G9W0745.americas.hpqcorp.net>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
 <20141112174142.GA14359@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:37747 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaKMAfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 19:35:04 -0500
In-Reply-To: <20141112174142.GA14359@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, 12 November, 2014 11:42 AM
> To: Christoph Hellwig
> Cc: linux-scsi@vger.kernel.org; James Bottomley; Elliott, Robert
> (Server Storage); Hannes Reinecke; Martin K. Petersen; Bart van
> Assche; Mike Christie
> Subject: making the queue_type attribute read only, was: Re: tag
> handling refactor V2
> 
> >  - how is the change_queue_type API supposed to be used for most
> >    drivers?  It only changes the tag type from none to simple
> >    or back, but except for the special implementation in the
> >    53c700 driver doesn't change the queue depth,
> >    which might cause it to issue multiple non-tagged command.
> >    Fortunately most drivers never look at this information, but
> >    then again changing the queue type is useless to start with.
> >  - for those drivers looking at the command tagged information
> >    we'd need to quiesce the LUN.  No driver but the 53c700
> >    driver does that, and the 53c700 does it at a target-level,
> >    which despite a comment claiming it's needed doesn't seem
> >    to make sense given the code.  If we can make sure
> >    to quience all LUNs we could avoid the per-command flag for
> >    tagged commands and always look at the scsi_device flag.
> 
> I've not merged the series, but ondering the above two issues I've
> become convinved that we should make the queue_type sysfs attribute
> read only.
> 
> Switching off tagging isn't really something we should leave to
> users, as the hardware knows much better.  Changing the tag type
> might have made sense during the times of the ordered tags for
> barriers insanity, but now that it's just tagged vs untagged
> it's pretty pointless.
> Especially given that only a single driver ever got the
> implementation right.
> 
> Does anyone have objections to removing the change_queue_type method?

A queue_type of "none" disables the SCSI midlayer automatic queue depth
adjustments based on TASK SET FULL vs. other status values, while
"simple" enables them.  That's the feature where TASK SET FULL reception
causes the queue depth to be lowered, while several GOOD status values
in a row causes it to be increased.

That logic doesn't work very well right now, so that sysfs file
might be the best way to keep controlling the automatic adjustment
feature even if it no longer controls whether tags exist.

One problem is it adjusts the queue depths for all devices sharing
the same target number; we talked about letting the host choose
the policy (http://marc.info/?l=linux-scsi&m=140440001619574&w=2).

Even if that is corrected, the ramp-up/ramp-down algorithms
and controls are not quite right for the full range of device 
types (SSDs to HDDs).  With SSDs, I saw the queue_depth:
* ramp down by about 10 every 2 seconds
* with the default queue_ramp_up_period of 120000: never ramp up
* with a queue_ramp_up_period of 120: ramp up by 16 ever 2 seconds

At 1M IOPS, 2 seconds is far too long to decide anything; some
algorithm changes are needed.

---
Rob Elliott    HP Server Storage



