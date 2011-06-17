From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 20:53:34 +0900
Message-ID: <4DFB403E.9020009@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com> <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59087 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab1FQLxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2011 07:53:40 -0400
In-Reply-To: <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

(2011/06/17 8:04), Kay Sievers wrote:
[...]
>>>>>>> So as userspace tools will still need to be fixed, I don't see how
>>>>>>> adding a kernel file for this is going to help any.  Well, a bit in that
>>>>>>> the kernel log files will look "different", but again, that really isn't
>>>>>>> a problem that userspace couldn't also solve with no kernel changes
>>>>>>> needed.
>>>>>>
>>>>>> This is true, but I think for the small effort it takes to implement the
>>>>>> feature in-kernel compared with what we'd have to do to the
>>>>>> distributions to get it implemented in userspace (we'd need klogd to do
>>>>>> the conversion for dmesg ... I'm entirely unclear what we need to modify
>>>>>> for /proc/partitions, etc.) the benefit outweighs the cost.
>>>>>>
>>>>>> Additionally, since renaming is something users seem to want (just look
>>>>>> at net interfaces), if we can make this work, we now have a definitive
>>>>>> answer to point people at.
>>>>>
>>>>> Renaming is something that we do NOT want to do, as we have learned our
>>>>> lesson of the network device renaming mess.  And as Kay pointed out, we
>>>>> already have an "alias" name there, which no one uses.
>>>>
>>>> Look at this as an opportunity to get it right.  The original proposal
>>>> was for renaming.  By iterating over the actual requirements, we have it
>>>> reduced to simply having the kernel print a preferred name.  I think
>>>> that's a nice achievement which we can point other proponents of
>>>> renaming to as they arise.
>>>
>>> Sure, we absolutely don't want renaming, and we can provide countless
>>> solid technical reasons why we should not allow it to happen. But I'm
>>> also pretty sure, we also don't want just-another-single-name to put
>>> somewhere in the kernel.
>>
>> I understand why we don't want renaming.  However, the technical reason
>> why we want a preferred name is that it's often associated with a name
>> printed somewhere on the box (say a label on the disk enclosure, or
>> ethernet port).  Not being able to use this name to address the device
>> is a usability issue which annoys the enterprise enormously.
>>
>> So if we stop there, regardless of solution (in-kernel or fix all
>> userspace), does everyone see what the actual problem is?
> 
> I don't think that solves the problem, no. We need _smart_ userspace
> with a debug/error message channel from the kernel to userspace that
> pops out _structured_ data. Userspace needs to index the data, and
> merge a lot of userspace information into it.

If that is possible, I think it's so helpful. But most of driver
developers doesn't like that... They may tend to continue using
printk() debug/error notification. (actually I hope them to
use some notification API, like traceevent...)

Maybe, some kind of errors, like AER/MCE, easily move on to
such smarter system. But I doubt other device-specific errors
can do that too. There are so much specific kind of errors...

> Adding just another single-name to the kernel just makes the
> much-too-dumb free-text printk() a bit more readable, but still sounds
> not like a solution. Pimping up syslog is not the solution to this
> problem, and it can't be solved in the kernel alone.

I agree with you that the _smart_ error notifier can solve our
problem too. However, we can't jump into it directly.
And just making printk() readable helps us A LOT!


>>>>> So again, I really don't like this, just fix the userspace tools to map
>>>>> the proper device name that the kernel is using to the userspace name
>>>>> the tool used, and all is fine.  This has been done already today,
>>>>> succesfully, by many of the big "enterprise" monitoring systems that
>>>>> work quite well on Linux, proving that this is not something that the
>>>>> kernel needs to provide to implement properly.
>>>>
>>>> Well, it's expediency.  Sure we could try to patch the world, but I
>>>> think the simple patch of getting the kernel to print a preferred name
>>>> solves 90% of the problem.  Sure there is a long tail of userspace
>>>> components that needs fixing, but that can be done gradually if we take
>>>> the kernel route.  If we go the userspace route, it will be a long while
>>>> before we even get to 50% coverage.
>>>
>>> I need to ask again ask for an explanation why logging all symlinks at
>>> device discovery from udev, does not solve exactly this problem. With
>>> that tag in the syslog message stream, all later kernel names can be
>>> safely associated with _all_ the current device names in question,
>>> until the next tag from udev is found.
>>
>> So if the user has one preferred name, us logging all the names (and we
>> have quite a few for disks) doesn't really help because the user might
>> want to choose a different name.  However, even if we assume they choose
>> one of the current names, they still have to do the mapping manually;
>> even if they have all the information, they can't just cut and paste
>> from dmesg say, they have to cut, edit the buffer to put in the
>> preferred name and then paste ... that's just one annoying step too far
>> for most users.  I agree that all the output tools within reason can be
>> fixed to do this automatically, but fixing cat say, just so
>> cat /proc/partitions works would never be acceptable upstream.
>>
>> The reason for storing this in the kernel is just that it's easier than
>> trying to update all the tools, and it solves 90% of the problem, which
>> makes the solution usable, even if we have to update tools to get to
>> 100%.
> 
> I don't think we can even solve 10% of the problems that way. It's
> just a hack that makes stuff a bit more pretty, but doesn't provide
> any reasonable solution to the problem. I doubt we can even make a
> simple use case out of it, what name to put into that field for a
> multipath setup.

Good point! we have to consider multipath case in document.
Perhaps, we need a special naming rule in that case. I think
it can be solved if udev script is enough smart :-)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
