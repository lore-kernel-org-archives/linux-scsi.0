From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: LLDD: scatterlists only?
Date: Mon, 15 Aug 2005 01:59:12 -0500
Message-ID: <43003D40.3010602@cs.wisc.edu>
References: <20050814232446.58676.qmail@web51604.mail.yahoo.com> <1124063460.18802.27.camel@mulgrave> <43003471.5000108@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55974 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932102AbVHOG7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 02:59:42 -0400
In-Reply-To: <43003471.5000108@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> James Bottomley wrote:
> 
>>On Sun, 2005-08-14 at 16:24 -0700, Luben Tuikov wrote:
>>
>>
>>>Did someone have a patch or was there a talk
>>>that SCSI Core is moving towards sending _only_ scatterlists
>>>down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))
>>
>>
>>Yes, you can already see the beginnings in the -mm tree.
>>
>>Jens is maintaining a block tree with this in here:
>>
>>http://www.kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=rq-map
>>
>>And I have a scsi-block-2.6 tree based off this here:
>>
>>http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-block-2.6.git;a=summary
>>
>>The missing (and frankly really nasty) pieces are pulling all the sg
>>handling out of sg and st, but fortunately Mike Christie is working on
>>that.
> 
> 
> James,
> 
> I haven't looked at what would be involved with the sg
> driver but it is good to hear Mike C. is working on it.
> 

I sent a patch to begin this the other day
http://marc.theaimsgroup.com/?l=linux-scsi&m=112356952007369&w=2

The patch is not complete. I have to add a bunch of stuff I ripped out 
like the security checks and mmap code. I also have to move some code to 
a scsi command like James did for the sync code. I am looking over st to 
try and figure out what to share right now.

One question though. For SG_DXFER_TO_FROM_DEV it looks like for the 
block layer SG_IO code only the write part of the command could get run. 
This is becuase in sg_io() the reading variable is never used so a 
copy_to_user (that is if we end up not being able to do direct IO) may 
never happen. What commands use SG_DXFER_TO_FROM_DEV, and do we need the 
read part (or did I misread the block layer code or have we just been 
getting lucky and been doing zero copy).

Also for the new interface the write and read will be the same size 
becuase we use dxfer_len, but for the old interface is the same true? 
 From looking at the sg driver it looks like there could be different 
values for the read and write part, but is that ever used or is it just 
extra tests. And again what commands do this, so I can test them?

Thanks

Mike
