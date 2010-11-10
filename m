From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Wed, 10 Nov 2010 12:29:54 -0800
Message-ID: <4CDB00C2.2090200@cisco.com>
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:40269 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0KJU3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 15:29:55 -0500
In-Reply-To: <4CDAFE6E.7050200@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>



On 11/10/10 12:19 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 11/10/2010 12:58 PM wrote:
>> On 11/09/2010 10:06 PM, Vladislav Bolkhovitin wrote:
>>>
>>> Sorry, but what is incorrect in the working implementation without any
>>> bugs doing its job in the simplest, smallest and clearest way?
>>>
>>> If those objects remade to free themselves in the kobjects release(),
>>> what value would it add to them? Would the implementation be simpler,
>>> smaller or clearer? Not, I believe, new implementation would be only
>>> bigger and less clear. So, what's the point to do it to make the code worse?
>>>
>>
>> Totally theoretically speaking, since I have not inspected the code.
>>
>> If today you wait for the count to reach zero, then unregister
>> and send an event to some other subsystem to free the object.
>>
>> Is it not the same as if you take an extra refcount, unregister and
>> send the event at count=1. Then at that other place decrement the last
>> count to cause the object to be freed.
>>
>> I agree that it is hard to do lockless. what some places do is have
>> an extra kref. The kobj has a single ref on it. everything takes the
>> other kref. when that reaches zero the unregister and event fires
>> and at free you decrement the only kobj ref to deallocate. This is one
>> way. In some situations you can manage with a single counter it all
>> depends.
> 
> Thanks for sharing your thoughts with us. But the question isn't about
> if it's possible to implement what we need locklessly. The question is
> in two approaches how to synchronously delete objects with entries on SYSFS:
> 
> 1. struct object_x {
> 	...
> 	struct kobject kobj;
> 	struct completion *release_completion;
> };
> 
> static void x_release(struct kobject *kobj)
> {
> 	struct object_x *x;
> 	struct completion *c;
> 
> 	x = container_of(kobj, struct object_x, kobj);
> 	c = x->release_completion;
> 	kfree(x);
> 	complete_all(c);
> }
> 
> void del_object(struct object_x *x)
> {
> 	DECLARE_COMPLETION_ONSTACK(completion);
> 
> 	...
> 	x->release_completion = &completion;
> 	kobject_put(&x->kobj);
> 	wait_for_completion(&completion);
> }
> 
> and
> 
> 2. struct object_x {
> 	...
> 	struct kobject kobj;
> 	struct completion release_completion;
> };
> 
> static void x_release(struct kobject *kobj)
> {
> 	struct object_x *x;
> 
> 	x = container_of(kobj, struct object_x, kobj);
> 	complete_all(&x->release_completion);
> }
> 
> void del_object(struct object_x *x)
> {
> 	...
> 	kobject_put(&x->kobj);
> 	wait_for_completion(&completion);
> 	...
> 	kfree(x);
> }

I'll admit I don't understand this all that well, but
why not just have x_release() (based on (2))
do free(x), and have del_object
do the kobject_put(&x->kobj) as its very last thing?
Then you don't need the completion.

> 
> Greg asserts that (1) is the only correct approach while (2) is
> incorrect, and I'm trying to justify that (2) is correct too and
> sometimes could be better, i.e. simpler and clearer, because it
> decouples object_x from SYSFS and its kobj. Then kobj becomes an
> ordinary member of struct object_x without any special treatment and
> with the same lifetime rules as other members of struct object_x. While
> in (1) all lifetime of struct object_x is strictly attached to kobj, so
> it needs be specially handled with additional code for that if struct
> object_x has many other members which needed to be initialized/deleted
> _before and after_ kobj as we have in SCST.
> 
> Vlad
