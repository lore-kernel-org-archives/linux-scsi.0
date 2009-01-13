From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 07:11:41 -0700
Message-ID: <20090113141141.GF29283@parisc-linux.org>
References: <496C9C26.9020106@suse.de> <20090113135856.GE29283@parisc-linux.org> <496C9EF3.2090409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44669 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZAMOLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 09:11:42 -0500
Content-Disposition: inline
In-Reply-To: <496C9EF3.2090409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 13, 2009 at 03:02:27PM +0100, Hannes Reinecke wrote:
> Matthew Wilcox wrote:
> >Backwards jumps are generally disapproved of.  How about:
> >
> >	spin_lock_irqsave(shost->host_lock, flags);
> >	for (;;) {
> >		sdev = __scsi_device_lookup_by_target(starget, sdev, lun);
> >		if (!sdev || !scsi_device_get(sdev))
> >			break;
> >	}
> >	spin_unlock_irqrestore(shost->host_lock, flags);

> I must say I don't really like the for(;;) construct.

I'd be fine with:

	do {
		sdev = __scsi_device_lookup_by_target(starget, sdev, lun);
	} while (sdev && scsi_device_get(sdev));

though I find that slightly less clear than the for (;;) construct.

> And it's really confusing as we want to find an sdev, so breaking
> if it's _not_ found is ... weird.

Those are the two conditions when we want to stop trying -- if there's
no device or if the device we've found is bad.  I can definitely see an
argument for splitting the two conditions to make that more obvious.  I
can also see an argument for not returning an sdev in the _DEL state
from __scsi_device_lookup_by_target in the first place.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
