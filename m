From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Sat, 11 Jun 2005 11:15:16 -0700
Message-ID: <20050611181516.GA8555@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com> <20050611153745.GA31943@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:20479 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261768AbVFKSQC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:16:02 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5BIG1iw429146
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jun 2005 14:16:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5BIG13k193702
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jun 2005 12:16:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5BIG0VC026682
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jun 2005 12:16:01 -0600
Content-Disposition: inline
In-Reply-To: <20050611153745.GA31943@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 04:37:45PM +0100, Christoph Hellwig wrote:

> > +	if (shost->transportt->target_parent) {
> > +		spin_lock_irqsave(shost->host_lock, flags);
> > +		parent = shost->transportt->target_parent(shost, channel, id);
> > +		spin_unlock_irqrestore(shost->host_lock, flags);
> > +		if (!parent)
> > +			return NULL;
> > +	}
> 
> Ok, this idea is a lot better, but I think scsi_alloc_target is still
> the wrong place to put this.  It has an explicit parent argument that
> all but one of it's callers get right, and we're now totally ignoring
> and looking it up again when the transport has a ->target_parent method.
> 
> I'm not totally sure where the right place to put it in the
> scsi_scan_host_selected path is, though.  Probably scsi_scan_host_selected
> shoud just become __scsi_scan_host_selected, scsi_scan_host would call
> it directly but the sysfs and legacy procfs scanning would call the method.
> 
> Or it might be better to give the transport completely control over the
> scan sysfs attribute, that way we could even allow scanning by WWNs or
> similar things.

What do you think of Mike C's patch, to add a transportt->scan function?

http://marc.theaimsgroup.com/?l=linux-scsi&m=111671146532103&w=2

It needs a bit more code in the transport compared to the above. It also
allows the transport to more efficiently scan (the transport can scan only
devices it knows are attached, versus all id's up to max_id).

If the scsi_target (sysfs targetC:I:L) was always under the scsi_host
(syfs hostH) in the device tree there would no problem. Then the transport
specific target object (like rport for FC) would have to be parallel to or
under the target.

-- Patrick Mansfield
