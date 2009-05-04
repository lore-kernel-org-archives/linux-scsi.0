From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Mon, 04 May 2009 17:11:39 +0200
Message-ID: <49FF05AB.5020801@interlog.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>	 <20090503071619.GP8822@parisc-linux.org>	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>	 <49FDEE64.5090302@garzik.org>	 <1241379476.5596.92.camel@mulgrave.int.hansenpartnership.com>	 <49FEF5C5.6010404@interlog.com> <1241448038.3315.19.camel@mulgrave.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241448038.3315.19.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-05-04 at 16:03 +0200, Douglas Gilbert wrote:
>> James Bottomley wrote:
>>> On Sun, 2009-05-03 at 15:20 -0400, Jeff Garzik wrote:
>>>> Is WRITE SAME associated with this current DISCARD work, or is that just 
>>>> a similar example?  I'm unfamiliar with its issues...
>>> It's an adjunct body of work.  T10 apparently ratified both UNMAP and
>>> the WRITE SAME extensions.  What WRITE SAME does is write the same data
>>> block to multiple contiguous locations as specified in the CDB.  What
>>> the thin provisioning update did for it is allow you to specify a flag
>>> saying I want these sectors unmapped.   The perceived benefit of WRITE
>>> SAME is that you specify (with the write same data ... presumably all
>>> zeros) what an unmapped sector will return if it's ever read from again,
>>> which was a big argument in the UNMAP case.
>> James,
>> Your presumption is correct. For the UNMAP bit to be honoured
>> in the SCSI WRITE SAME command, the user data part of the
>> data-out buffer needs to be all zeros, and, if present,
>> the protection data part of the data-out buffer needs
>> to be all 0xff_s (i.e. 8 bytes of 0xff). Otherwise the
>> UNMAP bit in WRITE SAME command is ignored and it does a
>> "normal" WRITE SAME.
>>
>> My $0.02's worth was a suggestion to report an error if the
>> UNMAP bit was given to WRITE SAME and the data-out
>> buffer did not comply with the above pattern. Alternatively
>> the data-out buffer could just be ignored. The author
>> of the WRITE SAME "unmap" facility duly noted my observations
>> and rejected them :-) The wording in sbc3r18.pdf for WRITE SAME
>> is contorted so there will be changes. And t10 is still
>> having teleconferences about thin provisioning so there may be
>> non-trivial changes in the near future.
> 
> Actually, I'd just like something far more basic: forcing a thin
> provisioned array to support all of the three possible mechanisms.  It's
> going to be a real mess trying to work out for any given array do you
> support UNMAP or WRITE SAME(16) or WRITE SAME(32)?  We can only do this
> currently by trying the commands ... then we have to have support for
> all three built into sd just in case ... and we get precisely the same
> functionality in each case ...

James,
Another aspect, especially if a large amount of storage
is to be trimmed, is how long will it take? This relates
to the timeout value we should associate with such an
invocation. The FORMAT UNIT and START STOP UNIT commands
have an IMMED bit, but not WRITE SAME.

Speaking of FORMAT UNIT, some words were added into sbc3r18
that suggest a FORMAT UNIT command could be interpreted as
unmap/trim the whole disk.

Doug Gilbert

