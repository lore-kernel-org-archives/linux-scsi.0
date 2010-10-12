From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 12 Oct 2010 22:53:45 +0400
Message-ID: <4CB4AEB9.30501@vlnb.net>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101011213235.GA11489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 10/12/2010 01:32 AM wrote:
> On Mon, Oct 11, 2010 at 11:29:22PM +0400, Vladislav Bolkhovitin wrote:
>> Greg KH, on 10/10/2010 01:20 AM wrote:
>>> On Sat, Oct 02, 2010 at 01:46:21AM +0400, Vladislav Bolkhovitin wrote:
>>>> +static void scst_tgtt_release(struct kobject *kobj)
>>>> +{
>>>> +	struct scst_tgt_template *tgtt;
>>>> +
>>>> +	tgtt = container_of(kobj, struct scst_tgt_template, tgtt_kobj);
>>>> +	complete_all(&tgtt->tgtt_kobj_release_cmpl);
>>>> +	return;
>>>
>>> Don't you also need to free the memory of your kobject here?
>>>
>>>> +static void scst_tgt_release(struct kobject *kobj)
>>>> +{
>>>> +	struct scst_tgt *tgt;
>>>> +
>>>> +	tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
>>>> +	complete_all(&tgt->tgt_kobj_release_cmpl);
>>>> +	return;
>>>
>>> Same here, no kfree?
>>>
>>>> +static void scst_acg_release(struct kobject *kobj)
>>>> +{
>>>> +	struct scst_acg *acg;
>>>> +
>>>> +	acg = container_of(kobj, struct scst_acg, acg_kobj);
>>>> +	complete_all(&acg->acg_kobj_release_cmpl);
>>>
>>> And here.
>>
>> Thanks for the review. In all those functions kobjects for simplicity
>> are embedded into the outer objects, so they will be freed as part of
>> the outer objects free. Hence, kfree() for the kobjects in the release
>> functions are not needed.
> 
> Sweet, you now have opened yourself up to public ridicule as per the
> documentation in the kernel for how to use kobjects!
> 
> Nice job :)

Thanks :)

> Seriously, you CAN NOT DO THIS!  If you embed a kobject in a different
> structure, then you have to rely on the kobject to handle the reference
> counting for that larger structure.  To do ANYTHING else is a bug and
> wrong.
> 
> Please read the kobject documentation and fix this code up before
> submitting it again.

Sure, I have read it and we rely on the kobject to handle the reference
counting for the larger structure. It's only done not in a
straightforward way, because the way it is implemented is simpler for us
+ for some other reasons.

For instance, for structure scst_tgt it is done using
tgt_kobj_release_cmpl completion. When a target driver calls
scst_unregister_target(), scst_unregister_target() in the end calls
scst_tgt_sysfs_del(), which calls kobject_put(&tgt->tgt_kobj) and wait
for tgt_kobj_release_cmpl to complete. At this point tgt_kobj can be
taken only by the SYSFS. Scst_tgt_sysfs_del() can wait as much as needed
until the SYSFS code released it. As far as I can see, it can't be
forever, so it's OK. Then, after scst_tgt_sysfs_del() returned,
scst_unregister_target() will free scst_tgt together with embedded tgt_kobj.

Sure, if you insist, I can convert tgt_kobj and other similar kobjects
to pointers, but it would be just a formal code introducing additional
kmalloc()/kfree() pair per each kobject without changing any logic anywhere.

Thanks,
Vlad
