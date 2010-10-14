From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 14 Oct 2010 23:48:17 +0400
Message-ID: <4CB75E81.7000208@vlnb.net>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0JNTtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 15:49:45 -0400
In-Reply-To: <20101012190345.GA25737@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Greg KH, on 10/12/2010 11:03 PM wrote:
> On Tue, Oct 12, 2010 at 10:53:45PM +0400, Vladislav Bolkhovitin 
> wrote:
>>> Seriously, you CAN NOT DO THIS!  If you embed a kobject in a 
>>> different structure, then you have to rely on the kobject to 
>>> handle the reference counting for that larger structure.  To do 
>>> ANYTHING else is a bug and wrong.
>>> 
>>> Please read the kobject documentation and fix this code up
>>> before submitting it again.
>> 
>> Sure, I have read it and we rely on the kobject to handle the 
>> reference counting for the larger structure. It's only done not in
>>  a straightforward way, because the way it is implemented is 
>> simpler for us + for some other reasons.
> 
> Sorry, but I don't buy it.
> 
>> For instance, for structure scst_tgt it is done using 
>> tgt_kobj_release_cmpl completion. When a target driver calls 
>> scst_unregister_target(), scst_unregister_target() in the end
>> calls scst_tgt_sysfs_del(), which calls kobject_put(&tgt->tgt_kobj)
>> and wait for tgt_kobj_release_cmpl to complete.
> 
> Wait, why shouldn't the release then free the memory?
> 
>> At this point tgt_kobj can be taken only by the SYSFS. 
>> Scst_tgt_sysfs_del() can wait as much as needed until the SYSFS 
>> code released it. As far as I can see, it can't be forever, so it's
>> OK.
> 
> I don't understand, why can't you just free the memory, what are you 
> having to wait for?
> 
> You are only having one kobject for your structure, right?  If so, 
> then free the memory in the release, to wait for something else to 
> free the memory is wrong.
> 
>> Then, after scst_tgt_sysfs_del() returned,
>> scst_unregister_target() will free scst_tgt together with embedded
>> tgt_kobj.
> 
> As no other kernel code is like this, I don't think it's valid to be 
> doing so, sorry.
> 
> Please fix this.

I'm sorry, but after I started implementing it I'm confused..

Originally I thought you are asking to make tgt_kobj be not embedded in
struct scst_tgt, but a pointer in it, so scst_tgtt_release() will
kfree() tgt_kobj. Hence, all the above I wrote about why we have
tgt_kobj embedded.

But now I feel like you are asking that scst_tgtt_release() should
kfree() tgt, not tgt_kobj.

Is it correct?

If yes, we did it this way to make errors processing uniform and
straightforward. In the code (simplified) our current errors recovery
looks like:

void scst_tgt_sysfs_del(struct scst_tgt *tgt)
{
...
	kobject_put(&tgt->tgt_kobj);
	wait_for_completion(&tgt->tgt_kobj_release_cmpl);
}

int scst_tgt_sysfs_create(struct scst_tgt *tgt)
{
	init_completion(&tgt->tgt_kobj_release_cmpl);

	res = kobject_init_and_add(&tgt->tgt_kobj, &tgt_ktype,
			&tgt->tgtt->tgtt_kobj, tgt->tgt_name);
	if (res != 0)
		goto out;

	res = sysfs_create_file(&tgt->tgt_kobj,
			&tgt_enable_attr.attr);
	if (res != 0)
		goto out_err;
...

out:
	return res;

out_err:
	scst_tgt_sysfs_del(tgt);
	goto out;
}

struct scst_tgt *scst_register_target()
{
	struct scst_tgt *tgt;
	int rc = 0;

	TRACE_ENTRY();

	rc = scst_alloc_tgt();
	if (rc != 0)
		goto out;
...
	tgt->tgt_name = kmalloc(strlen(target_name) + 1, GFP_KERNEL);
	if (tgt->tgt_name == NULL)
		goto out_free_tgt;
...
	mutex_lock();

	rc = scst_tgt_sysfs_create(tgt);
	if (rc < 0)
		goto out_unlock;

	tgt->default_acg = scst_alloc_add_acg();
	if (tgt->default_acg == NULL)
		goto out_sysfs_del;

...

out:
	return tgt;

out_sysfs_del:
	mutex_unlock();
	scst_tgt_sysfs_del(tgt)
	goto out_free_tgt;

out_unlock:
	mutex_unlock();

out_free_tgt:
	scst_free_tgt(tgt);
}

We have a simple and straightforward errors recovery semantic: if
scst_tgt_sysfs_create() failed, then tgt_kobj returned deinited as if
scst_tgt_sysfs_create() has never been called. This is a regular
practice in the kernel: don't return half-initialized objects.

If we implement freeing tgt in scst_tgtt_release() as you requesting, we
will need to add in the error recovery path additional recovery code to
track and delete half-initialized tgt_kobj. Particularly, we will need
to add additional flag to track that tgt_kobj initialized, hence needs
deleting. Similar flag and code will be added in all similar to scst_tgt
SCST objects.

This code will be quite errors prone as you can see on the example of
device_register() which on failure requires device_put() to be called
(http://lkml.org/lkml/2010/9/19/93). (I'm not questioning
device_register() implementation, there might be very good reasons to
implement it this way (I don't know), I mean, it is too easy to forget
to do the needed recovery of the half-created objects as this case
demonstrating.)

Could you confirm if I understand you correctly and need to implement
freeing tgt in the kobject release() function, please?

Thanks you very much,
Vlad
