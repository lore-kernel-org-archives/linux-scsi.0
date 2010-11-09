From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 09 Nov 2010 23:06:16 +0300
Message-ID: <4CD9A9B8.70708@vlnb.net>
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101109002829.GA22633@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 11/09/2010 03:28 AM wrote:
> On Mon, Nov 08, 2010 at 10:58:37PM +0300, Vladislav Bolkhovitin wrote:
>> Greg KH, on 10/22/2010 10:54 PM wrote:
>>> On Fri, Oct 22, 2010 at 10:40:34PM +0400, Vladislav Bolkhovitin wrote:
>>>>>> +	unsigned int tgt_kobj_initialized:1;
>>>>>
>>>>> It's the middle of the merge window, and I'm about to go on vacation, so
>>>>> I didn't read this patch after this line.
>>>>>
>>>>> It's obvious that this patch is wrong, you shouldn't need to worry about
>>>>> this.  And even if you did, you don't need this flag.
>>>>>
>>>>> Why are you trying to do something that no one else needs?  Why make
>>>>> things harder than they have to be.
>>>>
>>>> I tried to explain that to you in http://lkml.org/lkml/2010/10/14/291
>>>> and mentioned there the need to create this flag to track
>>>> half-initialized kobjects. You agreed
>>>> (http://lkml.org/lkml/2010/10/14/299) that don't return half-initialized
>>>> objects is a regular kernel practice, but then requested to strictly
>>>> bound the larger object freeing to its kobject release(), which means
>>>> that all SYSFS creating functions now have to return half-initialized
>>>> SYSFS hierarchy in case of any error. Hence the flag to track it.
>>>
>>> I agreed that you needed to do something about it, not that this is the
>>> correct way to do it.
>>>
>>> Think for a second as to why your code path looks different from EVERY
>>> other kobject user in the kernel.  Perhaps it is incorrect?  You don't
>>> need all this completion mess, in fact, it's wrong.
>>>
>>> Just do what everyone else does please, as that is the simpler, and
>>> correct, way to do it.
>>
>> Hello Greg,
>>
>> Why SCST objects are different from most other kernel objects and why
>> they can't be implemented the same way as them is exactly what I'm
>> trying to explain you. Let me try again from a bit different angle.
> 
> I'm sorry, but I just don't buy it.
> 
>> SCST objects are different from the most other kernel objects, because
>> they are very complex, hence complex to initialize and delete with
>> dependencies in order how initialization and delete actions should be
>> performed.
> 
> Then don't abuse kobjects with this "different" type of kobject, as that
> is not how the kobject code was designed to be used.
> 
> It was only designed to be used with the "sane" type of kernel objects
> :)

SCST objects are generally 1:1 mapping of SCSI Architecture Model (SAM)
objects. Is SAM insane and should have been designed with kobjects in
mind? ;)

>> Particularly, SCST objects have a lot of attributes and sub-objects,
>> so their kobjects can't be inited and exposed to SYSFS or removed from
>> it until they reach some point during initialization or delete
>> correspondingly, otherwise their attributes' reads and writes can
>> crash.
> 
> That sounds like an implementation error.  No other kernel code has that
> problem from what I can see.
> 
>> Note, SCST's kobjects are not the only kobjects in the kernel using the
>> completion based delete. See, for instance, ktype_cpufreq, ktype_cpuidle
>> or ext4_ktype.
> 
> ext4 is using this to get stuff under the /sys/fs/ext4 location.

"To get stuff under /sys/..." is exactly for what SCST needs kobjects.
SCST objects are user interface agnostic and can be equally well exposed
to user space via SYSFS, PROCFS, or anything else, like CONFIGFS or
custom IOCTLs.

> And
> even there, I don't think it is using kobjects correctly, but I really
> don't want to go audit that code at the moment.
> 
> cpufreq and cpuidle is also probably incorrect, but again, I don't feel
> like auditing it right now.

Sorry, but what is incorrect in the working implementation without any
bugs doing its job in the simplest, smallest and clearest way?

If those objects remade to free themselves in the kobjects release(),
what value would it add to them? Would the implementation be simpler,
smaller or clearer? Not, I believe, new implementation would be only
bigger and less clear. So, what's the point to do it to make the code worse?

>>> Oh, and why are you using a kobject at all anyway?  Shouldn't you be
>>> using a 'struct device'?
>>
>> We need only to represent our internal SCST objects on the SYSFS. The
>> objects are not devices, but special entities for special purposes. For
>> instance, struct scst_session is a representation of SCSI I_T nexuses.
>> Struct scst_tgt_dev - I_T_L nexuses. Another example is struct scst_acg,
>> which is a representation of per initiator access control groups to
>> determine which initiators can see which LUNs. Hence, for such purpose
>> kobjects are fully sufficient.
> 
> No, you should be using a struct device as you are putting stuff into
> the device tree.  NEVER put a kobject into the device tree, that is just
> wrong and will cause problems.

Hmm, we never put any stuff into the device tree. Why do you think we
do? None of SCST objects has any relation to any hardware device, hence
there's no need to touch the device tree.

Thanks,
Vlad
