From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 08 Nov 2010 22:58:37 +0300
Message-ID: <4CD8566D.1020202@vlnb.net>
References: <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0KHT7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 14:59:25 -0500
In-Reply-To: <20101022185437.GA9103@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Greg KH, on 10/22/2010 10:54 PM wrote:
> On Fri, Oct 22, 2010 at 10:40:34PM +0400, Vladislav Bolkhovitin wrote:
>>>> +	unsigned int tgt_kobj_initialized:1;
>>>
>>> It's the middle of the merge window, and I'm about to go on vacation, so
>>> I didn't read this patch after this line.
>>>
>>> It's obvious that this patch is wrong, you shouldn't need to worry about
>>> this.  And even if you did, you don't need this flag.
>>>
>>> Why are you trying to do something that no one else needs?  Why make
>>> things harder than they have to be.
>>
>> I tried to explain that to you in http://lkml.org/lkml/2010/10/14/291
>> and mentioned there the need to create this flag to track
>> half-initialized kobjects. You agreed
>> (http://lkml.org/lkml/2010/10/14/299) that don't return half-initialized
>> objects is a regular kernel practice, but then requested to strictly
>> bound the larger object freeing to its kobject release(), which means
>> that all SYSFS creating functions now have to return half-initialized
>> SYSFS hierarchy in case of any error. Hence the flag to track it.
> 
> I agreed that you needed to do something about it, not that this is the
> correct way to do it.
> 
> Think for a second as to why your code path looks different from EVERY
> other kobject user in the kernel.  Perhaps it is incorrect?  You don't
> need all this completion mess, in fact, it's wrong.
> 
> Just do what everyone else does please, as that is the simpler, and
> correct, way to do it.

Hello Greg,

Why SCST objects are different from most other kernel objects and why
they can't be implemented the same way as them is exactly what I'm
trying to explain you. Let me try again from a bit different angle.

SCST objects are different from the most other kernel objects, because
they are very complex, hence complex to initialize and delete with
dependencies in order how initialization and delete actions should be
performed. Particularly, SCST objects have a lot of attributes and
sub-objects, so their kobjects can't be inited and exposed to SYSFS or
removed from it until they reach some point during initialization or
delete correspondingly, otherwise their attributes' reads and writes can
crash.

I can elaborate all those on examples, if you request.

I understand you are very busy and appreciate very much your review and
comments, so be glad to implement what you are requesting. But I don't
see how to implement that in an acceptable manner with neither the
completion-based delete as now, nor with x_initialized flag as in the
previous patch.

Note, SCST's kobjects are not the only kobjects in the kernel using the
completion based delete. See, for instance, ktype_cpufreq, ktype_cpuidle
or ext4_ktype.

Also, elevator (struct elevator_queue) uses "registered" flag to see if
it was added to the SYSFS.

Thus, you can see, both the completion and the flag approaches already
used in the kernel. Hence, I believe, the way how SCST is doing it
should also be acceptable.

I'm not a person who, as you, probably, guessed, at first doing, only
then thinking and reading docs. I before writing a code line at first
read all the available docs and carefully consider possible
alternatives, so there isn't a well thought bit in SCST.

I believe, the completions aren't mess, they are refinement.

> Oh, and why are you using a kobject at all anyway?  Shouldn't you be
> using a 'struct device'?

We need only to represent our internal SCST objects on the SYSFS. The
objects are not devices, but special entities for special purposes. For
instance, struct scst_session is a representation of SCSI I_T nexuses.
Struct scst_tgt_dev - I_T_L nexuses. Another example is struct scst_acg,
which is a representation of per initiator access control groups to
determine which initiators can see which LUNs. Hence, for such purpose
kobjects are fully sufficient.

Thanks,
Vlad
