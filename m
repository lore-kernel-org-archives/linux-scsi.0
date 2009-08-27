From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 18:39:27 +0300
Message-ID: <4A96A8AF.2030901@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>	 <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>	 <4A952D54.5010102@panasas.com> <yq1ab1l91zy.fsf@sermon.lab.mkp.net>	 <4A965366.7080409@panasas.com> <1251380478.6426.11.camel@mulgrave.site> <4A96A37E.6010700@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:2169
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752251AbZH0Pj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 11:39:27 -0400
In-Reply-To: <4A96A37E.6010700@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 08/27/2009 06:17 PM, Douglas Gilbert wrote:
> James Bottomley wrote:
>> On Thu, 2009-08-27 at 12:35 +0300, Boaz Harrosh wrote:
>>> On 08/27/2009 09:58 AM, Martin K. Petersen wrote:
>>>>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
>>>>>> + *lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
>>>>>> + (u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
>>>>>> + (u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
>>>>>> + (u64)cmd[13] << 48 | (u64)cmd[12] << 56;
>>>> Boaz> get_unaligned_be64()
>>>>
>>>> As you noticed further down in that patch I do generally use the
>>>> get_unaligned_* macros in "my own" code.
>>>>
>>>> However, when I update somebody else's code I try to match the existing
>>>> style.  And in this case rest of get_data_transfer_info() is using
>>>> explicit shifts and to me it looks absolutely horrendous to mix the two.
>>>>
>>>> I generally avoid mixing cleanups and new functionality.  I don't have a
>>>> problem with switching over to the macros, but in that case I think the
>>>> whole function should be updated.  And that should be an orthogonal
>>>> patch.
>>>>
>>> I don't know. For me it is like checkpatch. I do not submit code over 80
>>> chars even if surrounding code does. "The new code rule".
>>
>> I'd take that as a guideline rather than a rule ... Especially when
>> lindent will generate 80 column long function templates over tens of
>> lines squashing about five letters per line ...
>>
>>> I generally agree with what you say but I think there is a balance.
>>> Personally, I think this is over the balance point, but it's your call.
>>
>> The general rule is not to confuse coding styles, so the correct way to
>> add stuff is to use the existing conventions in the file.  You can
>> optionally convert the entire style if necessary.  However, for these
>> get_cpu_be macros, there's no real benefit other than saving typing, so
>> a global conversion effort simply isn't worth it.
> 
> There is another aspect that I look at: portability to
> the user space of Linux and other operating systems.
> 
> Are there C99 or POSIX equivalents of get_unaligned_be64()?
> 
> Recently sg_read_block_limits was contributed to sg3_utils.
> Its author found a novel solution to this "problem" with
> network stack calls: ntohl() and friends. So I ran with it
> until I found it broke my builds in the MinGW environment
> for Windows. Rather than put in conditional compiles and
> wonder if my MinGW executables would get bloated, I opted
> to go back to what has worked for the last 25 years.
> 
> Doug Gilbert

Hi

As I said. I don't have a strong heart the way you guys have ;-)
even if I had to write it from scratch for every body of code I do
I would.

That said, the aligned accessors are exported from
linux to user space, the none-aligned I just kindly borrow into my project
as a couple of GPLed headers and that is that. Open source for you.

Boaz
