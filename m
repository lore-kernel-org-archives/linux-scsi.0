From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: DISCARD/WRITE_SAME request accounting (Was: Re: [PATCH 2/7]
 block: Implement support for WRITE SAME)
Date: Fri, 9 Mar 2012 11:54:04 -0500
Message-ID: <20120309165404.GA7746@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-3-git-send-email-martin.petersen@oracle.com>
 <20120302220823.GI26315@redhat.com>
 <yq1lindlimr.fsf@sermon.lab.mkp.net>
 <20120307170310.GE13430@redhat.com>
 <alpine.LFD.2.00.1203081138440.5987@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab2CIQyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 11:54:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203081138440.5987@dhcp-27-109.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Mar 08, 2012 at 11:48:53AM +0100, Lukas Czerner wrote:

[..]
> > > In my mind the only thing we can reliably measure is the I/O we're
> > > transmitting to or receiving from the device. So I'd personally like to
> > > see zero for discard and logical block size for write same.
> > 
> > counting IO which is being transmitted/received from device makes
> > sense (Given the fact we don't know how much actual work device will
> > have to do). So counting 1 block for write same and zero block for discard
> > sounds reasonable to me.
> > 
> > Looks like current code counts all the discard sectors towards number of
> > blocks written. So that will need to be changed. CCing Lukas, he might have
> > thoughts/opinion on discard request accounting.
> 
> I am little surprised that we still count all the discard sectors
> towards the number of bock written. I have mentioned this problem to
> Jens last year.
> 
> Anyway, it would be nice to have separate counter for discard requests
> and actually counting the discard sectors rather than just one for each
> discard bio. I know that the device can ignore the whole, or part of the
> request for its own reasons. But it is not a reason for not counting
> what we actually intended to discard. I think this statistic will be
> useful.
> 
> Consider for example the situation where you find you that you're
> constantly discarding more than you actually write to the device over
> some period of time. The you would probably want to adjust your discard
> policy.

Yes, may be recording number of discards is not a bad idea. Currently
we record following for disk stats.

struct disk_stats {
        unsigned long sectors[2];       /* READs and WRITEs */
        unsigned long ios[2];
        unsigned long merges[2];
        unsigned long ticks[2];
        unsigned long io_ticks;
        unsigned long time_in_queue;
};

May be it can be extended to record number of discards completed and
user space tools (iostat) modified to extract this info.

But that seems to be a separate functionality. So we can drop counting
discard sectors towards write? Anyway, as of today you can't extract
this info how many writes you did and how many of these were discards.
So as such there is no regression in terms of features?

Thanks
Vivek
