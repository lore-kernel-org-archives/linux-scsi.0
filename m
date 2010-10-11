From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 11 Oct 2010 23:29:22 +0400
Message-ID: <4CB36592.6060909@vlnb.net>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101009212047.GB27180@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 10/10/2010 01:20 AM wrote:
> On Sat, Oct 02, 2010 at 01:46:21AM +0400, Vladislav Bolkhovitin wrote:
>> This patch contains SYSFS interface implementation.
> 
> Nice, but you forgot to document it.  All sysfs changes need to be
> documented in Documentation/ABI/
> 
> Please add a file to this patch that does so.

I'll do. I didn't know about this. Thanks for pointing on it.

>> +static void scst_tgtt_release(struct kobject *kobj)
>> +{
>> +	struct scst_tgt_template *tgtt;
>> +
>> +	tgtt = container_of(kobj, struct scst_tgt_template, tgtt_kobj);
>> +	complete_all(&tgtt->tgtt_kobj_release_cmpl);
>> +	return;
> 
> Don't you also need to free the memory of your kobject here?
> 
>> +static void scst_tgt_release(struct kobject *kobj)
>> +{
>> +	struct scst_tgt *tgt;
>> +
>> +	tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
>> +	complete_all(&tgt->tgt_kobj_release_cmpl);
>> +	return;
> 
> Same here, no kfree?
> 
>> +static void scst_acg_release(struct kobject *kobj)
>> +{
>> +	struct scst_acg *acg;
>> +
>> +	acg = container_of(kobj, struct scst_acg, acg_kobj);
>> +	complete_all(&acg->acg_kobj_release_cmpl);
> 
> And here.

Thanks for the review. In all those functions kobjects for simplicity
are embedded into the outer objects, so they will be freed as part of
the outer objects free. Hence, kfree() for the kobjects in the release
functions are not needed.

Thanks again,
Vlad
