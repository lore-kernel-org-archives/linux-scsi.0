From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 22 Oct 2010 22:40:34 +0400
Message-ID: <4CC1DAA2.7030602@vlnb.net>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101022175624.GA13640@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 10/22/2010 09:56 PM wrote:
> On Fri, Oct 22, 2010 at 09:30:53PM +0400, Vladislav Bolkhovitin wrote:
>> +	unsigned int tgt_kobj_initialized:1;
> 
> It's the middle of the merge window, and I'm about to go on vacation, so
> I didn't read this patch after this line.
> 
> It's obvious that this patch is wrong, you shouldn't need to worry about
> this.  And even if you did, you don't need this flag.
> 
> Why are you trying to do something that no one else needs?  Why make
> things harder than they have to be.

I tried to explain that to you in http://lkml.org/lkml/2010/10/14/291
and mentioned there the need to create this flag to track
half-initialized kobjects. You agreed
(http://lkml.org/lkml/2010/10/14/299) that don't return half-initialized
objects is a regular kernel practice, but then requested to strictly
bound the larger object freeing to its kobject release(), which means
that all SYSFS creating functions now have to return half-initialized
SYSFS hierarchy in case of any error. Hence the flag to track it.

Simply, any SCST object has a lot of other things to initialize besides
its kobject, hence the need either to free it independently from its
kobject, or track by a flag if its kobjects initialized.

For illustration, here is the simplified code from my previous example,
i.e. without this patch. I added to it scst_unregister_target() to make
it more complete.

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

void scst_unregister_target(struct scst_tgt *tgt)
{
...

	scst_tgt_sysfs_del(tgt);
...
	scst_free_tgt(tgt);
}

You can see complete source code of those functions in the original
patch set I sent in this thread (patches 4 and 8).

What am I missing and how errors processing should be done with neither
freeing tgt not in tgt_kobj release() as above, nor without
tgt_kobj_initialized flag as in the patch?

Thanks,
Vlad
