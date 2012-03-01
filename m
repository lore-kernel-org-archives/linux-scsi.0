From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] [SCSI] st: expand ability to write immediate filemarks
Date: Thu, 01 Mar 2012 08:44:16 -0800
Message-ID: <4F4FA760.6090900@suse.com>
References: <4F3C1189.7090406@suse.com> <alpine.LNX.2.00.1202282103460.6053@kai.makisara.local> <4F4D4F3F.5040204@suse.com> <4F4DCE31.1000001@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:49077 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2CAQoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 11:44:23 -0500
In-Reply-To: <4F4DCE31.1000001@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai:

Your argument makes sense. I will resubmit the patch without the module
variable, and with a little more added to the documentation concerning
the possible dangers of writing immediate EOFs.

On 02/28/2012 11:05 PM, Kai M=E4kisara wrote:
> On 02/29/2012 12:03 AM, Lee Duncan wrote:
>> Hi Kai:
>>
>> Thanks for your response ...
>>
>> On 02/28/2012 11:40 AM, Kai Makisara wrote:
>>> On Wed, 15 Feb 2012, Lee Duncan wrote:
>>>
>>>> The st tape driver recently added the MTWEOFI ioctl, which writes
>>>> a tape filemark (EOF), like the MTWEOF ioctl, except that MTWEOFI
>>>> returns immediately. This makes certain applications, like backup
>>>> software, run much more quickly on buffered tape drives.
>>>>
> ...
>>>>
>>>>   static int st_dev_max;
>>>>   static int st_nr_dev;
>>>> @@ -103,6 +104,8 @@ module_param_named(max_sg_segs, max_sg_segs,
>>>> int, 0);
>>>>   MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather
>>>> segments to use (256)");
>>>>   module_param_named(try_direct_io, try_direct_io, int, 0);
>>>>   MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user
>>>> buffer and tape drive (1)");
>>>> +module_param_named(st_nowait_eof, st_nowait_eof, int, 0);
>>>> +MODULE_PARM_DESC(st_nowait_eof, "Do not wait when writing EOF
>>>> (filemark) (0)");
>>>>
>>>
>>> I think this should not be a module option. The property should be
>>> settable only as a mode option like other options of this kind.
>>> (I may have not written this clearly in my previous reply).
>>>
>>
>> I respectfully disagree.
>>
>> There are legacy applications, such as the IBM network backup progra=
m
>> that sparked this
>> bug fix. Such applications do not know about the capability added by
>> this patch, just as
>> they do not know about the relatively new MTWEOFI ioctl. Hence the
>> module option is a
>> convenient method for such applications to achieve increased through=
put.
>>
> You may not have fully understood what there mode options mean in
> practice. For each physical tape, you have up to four different devic=
e
> files (modes; eight if you count both auto-rewind and non-rewind
> devices). Each can be programmed with different characteristics using
> the ioctls. For instance, you can have /dev/nst0a which uses "normal"
> WEOF and /dev/nst0b which uses immediate WEOF. If you want the progra=
m
> to benefit from immeadiate WEOFs, you tell it to use /dev/nst0b. The
> program does not have to know anything about the new options.
>=20
> The system should configure the devices when detected, according to t=
he
> choices made by the system manager. I once made a proof-of-concept
> program stinit for this purpose. mt can also be used for this. The tr=
end
> is systems has for tens of years to move from boot-time configuration=
 to
> run-time configuration.
>=20
>> I agree there is a small risk of loosing errors or error context whe=
n
>> writing immediate
>> filemarks, but is the same problem that already exists in the case o=
f
>> the MTWEOFI ioctl.
>>
> Yes, but in case of MWEOFI, the programmer takes a calculated risk. F=
or
> instance, he/she can use MTWEOF for the last filemark to catch the
> errors (or just look at possible errors from close()). The defaults a=
re
> safe. In case of a module option, the default for the unsuspecting us=
er
> is unsafe.
>=20
>> I would be glad to add a section in the st documentation that mentio=
ns
>> the dangers of
>> writing immediate filemarks, if you think that would help clarify
>> usage of this feature.
>>
> It helps clarity but it does not remove the danger.
>=20
> Kai
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Lee Duncan
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
