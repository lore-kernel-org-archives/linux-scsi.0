From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 11 Nov 2010 23:50:01 +0300
Message-ID: <4CDC56F9.9040601@vlnb.net>
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab0KKUuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 15:50:52 -0500
In-Reply-To: <4CDBBE80.40908@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Boaz Harrosh, on 11/11/2010 12:59 PM wrote:
>> static void x_release(struct kobject *kobj)

Yes. Precisely speaking, of its kobj_type.

> This one is put on the kobj.release Right?
> 
>> {
>> 	struct object_x *x;
>> 	struct completion *c;
>>
>> 	x = container_of(kobj, struct object_x, kobj);
>> 	c = x->release_completion;
>> 	kfree(x);
>> 	complete_all(c);
>> }
>>
> 
> I don't see the unregister of the object_x.kobj, where do
> you do this one in x_release or del_object below?

Which unregister? Put for object_x.kobj is in del_object()

>> void del_object(struct object_x *x)
>> {
>> 	DECLARE_COMPLETION_ONSTACK(completion);
>>
>> 	...
>> 	x->release_completion = &completion;
>> 	kobject_put(&x->kobj);
> 
> This put might not be the last put on the object, IOs in flight
> and/or open files might have extra reference on the object.
> We release our initial ref, and below wait for all operations
> to complete. (Is there a matter of timeout like files not closing?)

This is the last internal put. All other references are from outsiders.
So, we are waiting for all them to put before we go on.

> One possibility (There are others)
> 
> 3. struct object_x {
> 	...
> 	struct kref kref;
> 	struct kobject kobj;
> 	struct completion *release_completion;
> };
> 
> Every body takes kref_put(&object_x.kref) and  kref_get(&object_x.kref)
> I hope you have x_get/x_put, Yes?
> 
> static void x_kref_release(struct kref *kref)
> {
> 	struct object_x *x = container_of(kref, struct object_x, kref);
> 
> 	complete_all(&x->release_completion);
> }
> 
> static void x_obj_release(struct kobject *kobj)
> {
> 	struct object_x *x = container_of(kobj, struct object_x, kobj);
> 
> 	kfree(x);
> }
> 
> int x_put(struct object_x *x)
> {
> 	return kref_put(&x->kref, x_kref_release);
> }
> 
> void del_object(struct object_x *x)
> {
> 	DECLARE_COMPLETION_ONSTACK(completion);
> 
> 	...
> 	x->release_completion = &completion;
> 	x_put(x)
> 	wait_for_completion(&completion);
> 	kobject_put(&x->kobj);
> }
> 
> Or
> 
> 4. Exactly Like 3 but without the extra kref member
>    Only x_put() changes and x_kref_release() now receives
>    an x_object
> 
> int x_put(struct object_x *x)
> {
> 	if (kobject_put(&x->kobj) == 1)
> 		// Like above [3] x_kref_release()
> 		x_kref_release(x);
> }
> 
> Note that in 4 you don't actually have a kref member, and that you have
> one extra ref on kobj from the beginning. In del_object above the first
> x_put(x) makes it possible to reach the "1" count and then the final
> kobject_put(&x->kobj); frees the object.
> (You need to be carfull with [4] because it must have a refcount==2 before
> you expose it to any IO or sysfs.)
> 
> So this is what I meant.

OK, I see. You know, all non-trivial things can be done in >1 correct
way ;) (Although (4) is not too correct as Greg already wrote)

Vlad
