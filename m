From: Vivek Goyal <vgoyal@redhat.com>
Subject: DISCARD/WRITE_SAME request accounting (Was: Re: [PATCH 2/7] block:
 Implement support for WRITE SAME)
Date: Wed, 7 Mar 2012 12:03:10 -0500
Message-ID: <20120307170310.GE13430@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-3-git-send-email-martin.petersen@oracle.com>
 <20120302220823.GI26315@redhat.com>
 <yq1lindlimr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab2CGRDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 12:03:19 -0500
Content-Disposition: inline
In-Reply-To: <yq1lindlimr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>

On Tue, Mar 06, 2012 at 12:54:52PM -0500, Martin K. Petersen wrote:
> >>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:
> 
> Vivek> Thinking loud. Will it logically make sense to account for whole
> Vivek> BIO (all the sectors and not just 1). Target device did the
> Vivek> actual work of writing the sector. Just that we reduced the data
> Vivek> transfer overhead.
> 
> We have absolutely no idea how much work the storage device will do. It
> could be doing zero-detect or dedup causing it to update an internal
> allocation map instead of actually writing out blocks. Or it could be
> forced to do more I/O than we requested due to wear leveling or because
> it is a RAID device which has to write out full stripes and parity
> blocks.
> 
> 
> Vivek> I thought it will make more sense to count WRITE_SAME towards
> Vivek> number of sectors written and not DISCARDS. Not sure why it make
> Vivek> sense to count discard sectors towards sectors written in
> Vivek> disk/part stat.
> 
> But we're measuring page out activity, right?
> 
> In my mind the only thing we can reliably measure is the I/O we're
> transmitting to or receiving from the device. So I'd personally like to
> see zero for discard and logical block size for write same.

counting IO which is being transmitted/received from device makes
sense (Given the fact we don't know how much actual work device will
have to do). So counting 1 block for write same and zero block for discard
sounds reasonable to me.

Looks like current code counts all the discard sectors towards number of
blocks written. So that will need to be changed. CCing Lukas, he might have
thoughts/opinion on discard request accounting.

Thanks
Vivek
