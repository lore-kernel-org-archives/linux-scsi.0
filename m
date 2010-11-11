From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 11 Nov 2010 11:59:28 +0200
Message-ID: <4CDBBE80.40908@panasas.com>
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CDAFE6E.7050200@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 11/10/2010 10:19 PM, Vladislav Bolkhovitin wrote:
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

Thanks for putting up an example we can now speak more specifically.
(And saved me the time to actually look at code)
I'll first comment on your code below and I have some questions, please
see if I understood you correctly. Later below I'll try to explain what I
meant.

> 1. struct object_x {
> 	...
> 	struct kobject kobj;
> 	struct completion *release_completion; 

release_completion is only to be used by del_object!

> };
> 
> static void x_release(struct kobject *kobj)

This one is put on the kobj.release Right?

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

I don't see the unregister of the object_x.kobj, where do
you do this one in x_release or del_object below?
 
> void del_object(struct object_x *x)
> {
> 	DECLARE_COMPLETION_ONSTACK(completion);
> 
> 	...
> 	x->release_completion = &completion;
> 	kobject_put(&x->kobj);

This put might not be the last put on the object, IOs in flight
and/or open files might have extra reference on the object.
We release our initial ref, and below wait for all operations
to complete. (Is there a matter of timeout like files not closing?)

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
 	DECLARE_COMPLETION_ONSTACK(completion);
	x->release_completion = &completion;
Right?

> 	...
> 	kobject_put(&x->kobj);
> 	wait_for_completion(&completion);
> 	...
> 	kfree(x);
> }
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

One possibility (There are others)

3. struct object_x {
	...
	struct kref kref;
	struct kobject kobj;
	struct completion *release_completion;
};

Every body takes kref_put(&object_x.kref) and  kref_get(&object_x.kref)
I hope you have x_get/x_put, Yes?

static void x_kref_release(struct kref *kref)
{
	struct object_x *x = container_of(kref, struct object_x, kref);

	complete_all(&x->release_completion);
}

static void x_obj_release(struct kobject *kobj)
{
	struct object_x *x = container_of(kobj, struct object_x, kobj);

	kfree(x);
}

int x_put(struct object_x *x)
{
	return kref_put(&x->kref, x_kref_release);
}

void del_object(struct object_x *x)
{
	DECLARE_COMPLETION_ONSTACK(completion);

	...
	x->release_completion = &completion;
	x_put(x)
	wait_for_completion(&completion);
	kobject_put(&x->kobj);
}

Or

4. Exactly Like 3 but without the extra kref member
   Only x_put() changes and x_kref_release() now receives
   an x_object

int x_put(struct object_x *x)
{
	if (kobject_put(&x->kobj) == 1)
		// Like above [3] x_kref_release()
		x_kref_release(x);
}

Note that in 4 you don't actually have a kref member, and that you have
one extra ref on kobj from the beginning. In del_object above the first
x_put(x) makes it possible to reach the "1" count and then the final
kobject_put(&x->kobj); frees the object.
(You need to be carfull with [4] because it must have a refcount==2 before
you expose it to any IO or sysfs.)

So this is what I meant.
Cheers
Boaz
