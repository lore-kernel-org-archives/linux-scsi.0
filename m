From: Douglas Gilbert <dougg@torque.net>
Subject: Re: LLDD: scatterlists only?
Date: Mon, 15 Aug 2005 22:51:30 +1000
Message-ID: <43008FD2.5010907@torque.net>
References: <20050814232446.58676.qmail@web51604.mail.yahoo.com> <1124063460.18802.27.camel@mulgrave> <43003471.5000108@torque.net> <43003D40.3010602@cs.wisc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:61368 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750741AbVHOMv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 08:51:26 -0400
In-Reply-To: <43003D40.3010602@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Douglas Gilbert wrote:
> 
>> James Bottomley wrote:
>>
>>> On Sun, 2005-08-14 at 16:24 -0700, Luben Tuikov wrote:
>>>
>>>
>>>> Did someone have a patch or was there a talk
>>>> that SCSI Core is moving towards sending _only_ scatterlists
>>>> down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))
>>>
>>>
>>>
>>> Yes, you can already see the beginnings in the -mm tree.
>>>
>>> Jens is maintaining a block tree with this in here:
>>>
>>> http://www.kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=rq-map
>>>
>>>
>>> And I have a scsi-block-2.6 tree based off this here:
>>>
>>> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-block-2.6.git;a=summary
>>>
>>>
>>> The missing (and frankly really nasty) pieces are pulling all the sg
>>> handling out of sg and st, but fortunately Mike Christie is working on
>>> that.
>>
>>
>>
>> James,
>>
>> I haven't looked at what would be involved with the sg
>> driver but it is good to hear Mike C. is working on it.
>>
> 
> I sent a patch to begin this the other day
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112356952007369&w=2
> 
> The patch is not complete. I have to add a bunch of stuff I ripped out
> like the security checks and mmap code. I also have to move some code to
> a scsi command like James did for the sync code. I am looking over st to
> try and figure out what to share right now.
> 
> One question though. For SG_DXFER_TO_FROM_DEV it looks like for the
> block layer SG_IO code only the write part of the command could get run.
> This is becuase in sg_io() the reading variable is never used so a
> copy_to_user (that is if we end up not being able to do direct IO) may
> never happen. What commands use SG_DXFER_TO_FROM_DEV, and do we need the
> read part (or did I misread the block layer code or have we just been
> getting lucky and been doing zero copy).

Mike,
As I noted in an earlier post, in the absence of a reserve
buffer, SG_DXFER_TO_FROM_DEV should simply translate to
SG_DXFER_FROM_DEV (i.e. a read from device).

> Also for the new interface the write and read will be the same size
> becuase we use dxfer_len, but for the old interface is the same true?

Yes it was always assumed the contents of the sg_io_hdr structure
given to write() and the corresponding read() would be the same
apart from the sg_io_hdr::pack_id field when the
SG_SET_FORCE_PACK_ID was given to sg_io_hdr::flags. See
Documentation/scsi/scsi-generic.txt for details of that
special case.

For DIO/mmap-ed IO, the sg_io_hdr::dxfer_len value given to
the read() cannot be operative (e.g. the IO may have already
occurred by the time the read() is called).

> From looking at the sg driver it looks like there could be different
> values for the read and write part, but is that ever used or is it just
> extra tests. And again what commands do this, so I can test them?

If there are tests then it is just sanity/paranoia.

Doug Gilbert

