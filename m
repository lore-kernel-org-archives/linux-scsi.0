From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: DISCARD/WRITE_SAME request accounting (Was: Re: [PATCH 2/7]
 block: Implement support for WRITE SAME)
Date: Thu, 8 Mar 2012 11:48:53 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203081138440.5987@dhcp-27-109.brq.redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com> <1330658571-12958-3-git-send-email-martin.petersen@oracle.com> <20120302220823.GI26315@redhat.com> <yq1lindlimr.fsf@sermon.lab.mkp.net> <20120307170310.GE13430@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2CHKtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 05:49:12 -0500
In-Reply-To: <20120307170310.GE13430@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>

On Wed, 7 Mar 2012, Vivek Goyal wrote:

> On Tue, Mar 06, 2012 at 12:54:52PM -0500, Martin K. Petersen wrote:
> > >>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > Vivek> Thinking loud. Will it logically make sense to account for whole
> > Vivek> BIO (all the sectors and not just 1). Target device did the
> > Vivek> actual work of writing the sector. Just that we reduced the data
> > Vivek> transfer overhead.
> > 
> > We have absolutely no idea how much work the storage device will do. It
> > could be doing zero-detect or dedup causing it to update an internal
> > allocation map instead of actually writing out blocks. Or it could be
> > forced to do more I/O than we requested due to wear leveling or because
> > it is a RAID device which has to write out full stripes and parity
> > blocks.
> > 
> > 
> > Vivek> I thought it will make more sense to count WRITE_SAME towards
> > Vivek> number of sectors written and not DISCARDS. Not sure why it make
> > Vivek> sense to count discard sectors towards sectors written in
> > Vivek> disk/part stat.
> > 
> > But we're measuring page out activity, right?
> > 
> > In my mind the only thing we can reliably measure is the I/O we're
> > transmitting to or receiving from the device. So I'd personally like to
> > see zero for discard and logical block size for write same.
> 
> counting IO which is being transmitted/received from device makes
> sense (Given the fact we don't know how much actual work device will
> have to do). So counting 1 block for write same and zero block for discard
> sounds reasonable to me.
> 
> Looks like current code counts all the discard sectors towards number of
> blocks written. So that will need to be changed. CCing Lukas, he might have
> thoughts/opinion on discard request accounting.

I am little surprised that we still count all the discard sectors
towards the number of bock written. I have mentioned this problem to
Jens last year.

Anyway, it would be nice to have separate counter for discard requests
and actually counting the discard sectors rather than just one for each
discard bio. I know that the device can ignore the whole, or part of the
request for its own reasons. But it is not a reason for not counting
what we actually intended to discard. I think this statistic will be
useful.

Consider for example the situation where you find you that you're
constantly discarding more than you actually write to the device over
some period of time. The you would probably want to adjust your discard
policy.

Thanks!
-Lukas

> 
> Thanks
> Vivek
> 

-- 
