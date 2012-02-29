From: =?ISO-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] [SCSI] st: expand ability to write immediate filemarks
Date: Wed, 29 Feb 2012 09:05:21 +0200
Message-ID: <4F4DCE31.1000001@kolumbus.fi>
References: <4F3C1189.7090406@suse.com> <alpine.LNX.2.00.1202282103460.6053@kai.makisara.local> <4F4D4F3F.5040204@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:52936 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2B2HFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 02:05:31 -0500
In-Reply-To: <4F4D4F3F.5040204@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org

On 02/29/2012 12:03 AM, Lee Duncan wrote:
> Hi Kai:
>
> Thanks for your response ...
>
> On 02/28/2012 11:40 AM, Kai Makisara wrote:
>> On Wed, 15 Feb 2012, Lee Duncan wrote:
>>
>>> The st tape driver recently added the MTWEOFI ioctl, which writes
>>> a tape filemark (EOF), like the MTWEOF ioctl, except that MTWEOFI
>>> returns immediately. This makes certain applications, like backup
>>> software, run much more quickly on buffered tape drives.
>>>
...
>>>
>>>   static int st_dev_max;
>>>   static int st_nr_dev;
>>> @@ -103,6 +104,8 @@ module_param_named(max_sg_segs, max_sg_segs, int, 0);
>>>   MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (256)");
>>>   module_param_named(try_direct_io, try_direct_io, int, 0);
>>>   MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer and tape drive (1)");
>>> +module_param_named(st_nowait_eof, st_nowait_eof, int, 0);
>>> +MODULE_PARM_DESC(st_nowait_eof, "Do not wait when writing EOF (filemark) (0)");
>>>
>>
>> I think this should not be a module option. The property should be
>> settable only as a mode option like other options of this kind.
>> (I may have not written this clearly in my previous reply).
>>
>
> I respectfully disagree.
>
> There are legacy applications, such as the IBM network backup program that sparked this
> bug fix. Such applications do not know about the capability added by this patch, just as
> they do not know about the relatively new MTWEOFI ioctl. Hence the module option is a
> convenient method for such applications to achieve increased throughput.
>
You may not have fully understood what there mode options mean in 
practice. For each physical tape, you have up to four different device
files (modes; eight if you count both auto-rewind and non-rewind 
devices). Each can be programmed with different characteristics using 
the ioctls. For instance, you can have /dev/nst0a which uses "normal" 
WEOF and /dev/nst0b which uses immediate WEOF. If you want the program 
to benefit from immeadiate WEOFs, you tell it to use /dev/nst0b. The 
program does not have to know anything about the new options.

The system should configure the devices when detected, according to the 
choices made by the system manager. I once made a proof-of-concept 
program stinit for this purpose. mt can also be used for this. The trend 
is systems has for tens of years to move from boot-time configuration to 
run-time configuration.

> I agree there is a small risk of loosing errors or error context when writing immediate
> filemarks, but is the same problem that already exists in the case of the MTWEOFI ioctl.
>
Yes, but in case of MWEOFI, the programmer takes a calculated risk. For 
instance, he/she can use MTWEOF for the last filemark to catch the 
errors (or just look at possible errors from close()). The defaults are 
safe. In case of a module option, the default for the unsuspecting user 
is unsafe.

> I would be glad to add a section in the st documentation that mentions the dangers of
> writing immediate filemarks, if you think that would help clarify usage of this feature.
>
It helps clarity but it does not remove the danger.

Kai
