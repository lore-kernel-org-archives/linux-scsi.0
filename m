From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH][SCST]: Implementation of subdirectories sessions, luns,
 ini_group inside targets/<target_name>/target/.
Date: Wed, 20 May 2009 17:32:15 -0300
Message-ID: <4A1468CF.5080101@linux.vnet.ibm.com>
References: <4A0DE184.4010603@linux.vnet.ibm.com> <4A12F1C8.4040706@vlnb.net> <4A143671.4010407@linux.vnet.ibm.com> <4A144926.7090403@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:43484 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZETUcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2009 16:32:18 -0400
Received: from mailhub1.br.ibm.com (mailhub1.br.ibm.com [9.18.232.109])
	by e24smtp02.br.ibm.com (8.13.1/8.13.1) with ESMTP id n4KKuQtn027382
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 17:56:26 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.18.232.46])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4KKWfnE1266164
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 17:32:41 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4KKWGNL016255
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 17:32:17 -0300
In-Reply-To: <4A144926.7090403@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Daniel Debonzi, on 05/20/2009 08:57 PM wrote:
[snip]

>>>> Signed-off-by: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
>>> You forgot diffstat here.
>>
>> Actually I don't know how to generate them.
> 
> $ diffstat patch

Uhmm! for some reason I don't have it on my sistem. Will check it out.

>>> Looking at your patch I realized that, since we export our internal 
>>> objects, we need to decide their lifetime rules as well as decide 
>>> some unified agreement for the names of functions and error recover 
>>> (your patch has problems in this area). I suggest the following. Your 
>>> thought are welcome.
>>>
>>> 1. All kobjects without attributes will be dynamic kobjects. This is 
>>> the same as you did. Example is tgtt_kobj.
>>>
>>> 2. All kobjects with attributes will have dedicated kobj_type.
>>>
>>> 3. For ease of error recovery all sysfs content for each object will 
>>> be created in a single function with name 
>>> scst_create_object_name_sysfs(), like scst_create_tgt_sysfs()
>>>
>>> 4. All sysfs content of an object will also be cleaned by a single 
>>> function. For simple dynamic kobjects it will be called 
>>> scst_cleanup_object_name_sysfs(), like scst_cleanup_tgtt_sysfs(). For 
>>> other objects it will be called 
>>> scst_cleanup_object_name_sysfs_put_object_name(), like 
>>> scst_cleanup_tgt_sysfs_put_tgt(). It will also put reference to the 
>>> corresponding kobject and, hence, can destroy the whole object. This 
>>> is why I chose so big and inconvenient name: to emphasize that the 
>>> object can be destroyed after this function returned.
>>>
>>> 5. In the unregister functions the object will be fully cleaned as 
>>> much as possible for its sysfs attributes to work and not oops.
>>>
>>> I committed your patch with the above changes. Hopefully, now there 
>>> is a simple and straightforward path to implement other SCST sysfs 
>>> files and directories.
>>
>> I think we may have a problem here.
>> I agree with the name definitions and conventions but, unless I am 
>> missing something, there
>> is a problem on your 3th sentence.
>>
>> My first attempt to write the now called scst_create_tgt_sysfs 
>> function was using exactly
>> your approach but I stuck on the point that if any kobj creation 
>> (sessions, luns, ini_grp)
>> fail after a successful creation of tgt->tgt_kobj we  have to 
>> "destroy" tgt_kobj on the error
>> cover part, but I could not found a way do that if not with 
>> kobject_put(tgt_kobj).
>> That would call the release function (scst_tgt_free on scst_sysfs.c) 
>> that would kfree(tgt)
>> on a wrong place. I believe used kobject_del instead because of it but 
>> I afaik it does not
>> cleanup the kobj but only removes the directory from the sysfs.
>>
>> Searching for it now on the doc I found:
>> """
>> kobject_del() which will unregister the kobject from sysfs.  This 
>> makes the
>> kobject "invisible", but it is not cleaned up, and the reference count of
>> the object is still the same.  At a later time call kobject_put() to 
>> finish
>> the cleanup of the memory associated with the kobject.
>> """
>>
>> I feel that we only can kfree(tgt) on the error recover part if the 
>> error happened
>> before the tgt_kobj creation. After its creation the kfree only can be 
>> done by the
>> kobject release function.
>>
>> What do you think?
> 
> That problem was the one on which I spent the most time. Originally I 
> solved it by simply not calling kobject_put() on the error path, only 
> kobject_del(). Since we have tgt_kobj embedded it worked on the SCST 
> level pretty well. But I've just realized that it leaded to memory 
> leak(s) on the kobject level. So, I reconsidered it and now the code 
> looks like:
> 
> static void scst_tgt_free(struct kobject *kobj)
> {
>     struct scst_tgt *tgt;
> 
>     TRACE_ENTRY();
> 
>     tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
> 
>     if (tgt->tgt_sysfs_initialized)
>         kfree(tgt);
> 
>     TRACE_EXIT();
>     return;
> }
> 
> static struct kobj_type tgt_ktype = {
>     .release = scst_tgt_free,
> };
> 
> int scst_create_tgt_sysfs(struct scst_tgt *tgt)
> {
>     int retval;
> 
>     TRACE_ENTRY();
> 
>     retval = kobject_init_and_add(&tgt->tgt_kobj, &tgt_ktype,
>             tgt->tgtt->tgtt_kobj, tgt->tgt_name);
>     if (retval != 0) {
>         PRINT_ERROR("Can't add tgt %s to sysfs", tgt->tgt_name);
>         goto out;
>     }
> 
>     tgt->tgt_sess_kobj = kobject_create_and_add("sessions",
>                 &tgt->tgt_kobj);
>     if (!tgt->tgt_sess_kobj) {
>         PRINT_ERROR("Can't create sess kobj for tgt %s",
>                 tgt->tgt_name);
>         goto out_sess_obj_err;
>     }
> 
>     tgt->tgt_luns_kobj = kobject_create_and_add("luns",
>                 &tgt->tgt_kobj);
>     if (!tgt->tgt_luns_kobj) {
>         PRINT_ERROR("Can't create luns kobj for tgt %s",
>                 tgt->tgt_name);
>         goto luns_kobj_err;
>     }
> 
>     tgt->tgt_ini_grp_kobj = kobject_create_and_add("ini_group",
>                             &tgt->tgt_kobj);
>     if (!tgt->tgt_ini_grp_kobj) {
>         PRINT_ERROR("Can't create ini_grp kobj for tgt %s",
>             tgt->tgt_name);
>         goto ini_grp_kobj_err;
>     }
> 
>     tgt->tgt_sysfs_initialized = 1;
> 
> out:
>     TRACE_EXIT_RES(retval);
>     return retval;
> 
> ini_grp_kobj_err:
>     kobject_del(tgt->tgt_luns_kobj);
>     kobject_put(tgt->tgt_luns_kobj);
> 
> luns_kobj_err:
>     kobject_del(tgt->tgt_sess_kobj);
>     kobject_put(tgt->tgt_sess_kobj);
> 
> out_sess_obj_err:
>     kobject_del(&tgt->tgt_kobj);
>     kobject_put(&tgt->tgt_kobj);
>     retval = -ENOMEM;
>     goto out;
> }
> 
> I added tgt_sysfs_initialized flag to let scst_tgt_free() know if it 
> called normally or on the error processing path.
> 
> Should it work now?

I don't see any problems on that now. Very good solution. To be honest
I was looking for a way to know way the release was called (unregister
or error recover) for a long time and didn't think on that.

> You can also notice that there is kobject_del() before each the latest 
> on the SCST level kobject_put(). I did that to hide those objects ASAP. 
> Otherwise seems it is possible that, if any of them has external 
> reference, subsequent attempt to register object with the same name 
> (session, for instance) can fail. Don't know if it's possible on 
> practice, but better to be overinsured.

I don't know if it is really necessary and also I don't precisely know
what actions, events or whatever increment the kobj ref_count. Anyway
I think it can stay like that and if someone disagree and explain why
it is no necessary we can easily remote it.

Looking at this exactly moment on the kobject source code on kernel
to check what I wrote above I figured out that kobject_cleanup would
work where you were using kobject_del because it kobject_del and
cleanup all its resources.I could not found it on the kobject.txt so
it is not supposed to be used like this. Anyway I found worth to comment.

Regards,
Daniel Debonzi
