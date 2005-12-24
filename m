From: David Caldwell <david@porkrind.org>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA	passthrough
 CDBs
Date: Fri, 23 Dec 2005 23:11:29 -0800
Message-ID: <A0B73F5BB4320BF55FB4615D@dev.porkrind.org>
References: <20051221122442.GA16571@porkrind.org>	
 <1135353160.3728.10.camel@mulgrave>	
 <FEB7BF7CC02839AFCC0CF35D@dev.porkrind.org>
 <1135370071.3728.43.camel@mulgrave>
 <0C1803A3682E0D951A5A631C@dev.porkrind.org> <43ACC054.6080305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-67-49-70-252.socal.res.rr.com ([67.49.70.252]:41200 "EHLO
	death.porkrind.org") by vger.kernel.org with ESMTP id S1422626AbVLXHLN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Dec 2005 02:11:13 -0500
In-Reply-To: <43ACC054.6080305@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On 12/24/05 13:28:20 +1000 Douglas Gilbert wrote:

> David Caldwell wrote:
>> On 12/23/05 14:34:30 -0600 James Bottomley wrote:
>>
>>> On Fri, 2005-12-23 at 11:12 -0800, David Caldwell wrote:
>>>
>>>> What about the patch's cdb length additions in sg and scsi_lib.c? It
>>>> seems  like half the code guesses CDB length and the other half passes
>>>> it around.  Clearly, given devices like this, guessing isn't going to
>>>> work 100% of the  time. So either eveyone needs to pass around lengths,
>>>> or there needs to be  another flag somewhere. The code should at least
>>>> be consistent though.
>>>
>>>
>>> I don't think they're necessary, are they?  Zero in cmnd_len means
>>> mid-layer determines size.
>>
>> I think it's fine for zero length to mean mid_layer figures out the
>> size,
>
> David,
> I don't think it is a good idea to ever pass zero command
> length through a scsi pass through. I'm not even sure the
> SCSI-2 (1992) standard asserts that the first command byte
> can be used to determine command length. Definitely nothing
> since then.

I only did this because the ST driver happens to call this 
scsi_execute_async() from a function that itself gets called a bunch of 
times with no cdb length. So I either had to change even more things, or 
build in that "zero == guess" backwards compatibility. It wasn't really 
meant to be used from the SG_IO interface, but it happens to work (unless 
you call it on an sd device which is a completely different code path).

>>  but right now SG is throwing away the user passed in length (since
>>  scsi_execute_async() doesn't have a cdb_length parameter) and then
>>  guessing at it later regardless of whether it's zero or non-zero.
>
> I can find no such code. Which kernel version are you
> describing?

This is in the scsi_misc git tree from kernel.org.

> There was a bug in the block layer SG_IO
> ioctl code in the early lk 2.6 series that caused
> the user supplied length to be ignored. That has now
> been fixed. The sg driver from about 1998 has had
> mechanisms to explicitly supply the command length.
>
>> blkdev/scsi_ioctl.c doesn't do this, but sg.c does which is at least
>> inconsistent.
>
> do what ??

Ignore the user supplied length (from the SG_IO ioctl).

> I supplied a patch to allow the user to write to scsi_level
> in sysfs, thus overriding any assumptions that scsi_lib
> made about the device supplied scsi_level:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113343693013725&w=2
> That would solve your command overwrite problem in a less
> invasive way than the patch you are proposing.

Sort of. It's kind of an oblique way of stopping it from messing with the 
LUN though. There seems to be checks all around the scsi code for the scsi 
level (I saw it in more than one place). So changing the scsi_level so that 
the LUN wouldn't be overwritten could affect other code paths in unintended 
ways... I think it would be better to be more granular with these kind of 
overrides.

-David

