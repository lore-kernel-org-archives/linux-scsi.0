From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH][SCST]: Implementation of subdirectories sessions, luns,
 ini_group inside targets/<target_name>/target/.
Date: Wed, 20 May 2009 13:57:21 -0300
Message-ID: <4A143671.4010407@linux.vnet.ibm.com>
References: <4A0DE184.4010603@linux.vnet.ibm.com> <4A12F1C8.4040706@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:46976 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZETQ5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2009 12:57:31 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp05.br.ibm.com (8.13.1/8.13.1) with ESMTP id n4KGuTaL000392
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 13:56:29 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4KHuhKs3940498
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 14:56:43 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4KGvQNb001218
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2009 13:57:27 -0300
In-Reply-To: <4A12F1C8.4040706@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Hi Vlad,

Vladislav Bolkhovitin wrote:
> Hi Daniel,
> 
> Daniel Debonzi, on 05/16/2009 01:41 AM wrote:
>> This patch implements the creation of the subdirectories sessions, 
>> luns, ini_group
>> inside targets/<target_name>/target/.
>>
>> Also it makes some changes on scst_unregister since the scst_tgt can't 
>> just be
>> kfreed as long as it has a kobject embedded on it. Resuming, the 
>> scst_unregister
>> call kobject_put and on the kobject release functions there is a call 
>> to scst_release
>> (which is the same as scst_unregister was).
> 
> Unfortunately, your patch still contain a whitespace in the beginning of 
> each line. Do you use mouse to paste the patch in the message? I 
> personally use "Copy" and "Paste" through menu. Copy from KScope's editor.

Really?
I will check it out again. Sorry for that inconvenience

> 
>> Signed-off-by: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
> 
> You forgot diffstat here.

Actually I don't know how to generate them.

> 
> Looking at your patch I realized that, since we export our internal 
> objects, we need to decide their lifetime rules as well as decide some 
> unified agreement for the names of functions and error recover (your 
> patch has problems in this area). I suggest the following. Your thought 
> are welcome.
> 
> 1. All kobjects without attributes will be dynamic kobjects. This is the 
> same as you did. Example is tgtt_kobj.
> 
> 2. All kobjects with attributes will have dedicated kobj_type.
> 
> 3. For ease of error recovery all sysfs content for each object will be 
> created in a single function with name scst_create_object_name_sysfs(), 
> like scst_create_tgt_sysfs()
> 
> 4. All sysfs content of an object will also be cleaned by a single 
> function. For simple dynamic kobjects it will be called 
> scst_cleanup_object_name_sysfs(), like scst_cleanup_tgtt_sysfs(). For 
> other objects it will be called 
> scst_cleanup_object_name_sysfs_put_object_name(), like 
> scst_cleanup_tgt_sysfs_put_tgt(). It will also put reference to the 
> corresponding kobject and, hence, can destroy the whole object. This is 
> why I chose so big and inconvenient name: to emphasize that the object 
> can be destroyed after this function returned.
> 
> 5. In the unregister functions the object will be fully cleaned as much 
> as possible for its sysfs attributes to work and not oops.
> 
> I committed your patch with the above changes. Hopefully, now there is a 
> simple and straightforward path to implement other SCST sysfs files and 
> directories.

I think we may have a problem here.
I agree with the name definitions and conventions but, unless I am missing something, there
is a problem on your 3th sentence.

My first attempt to write the now called scst_create_tgt_sysfs function was using exactly
your approach but I stuck on the point that if any kobj creation (sessions, luns, ini_grp)
fail after a successful creation of tgt->tgt_kobj we  have to "destroy" tgt_kobj on the error
cover part, but I could not found a way do that if not with kobject_put(tgt_kobj).
That would call the release function (scst_tgt_free on scst_sysfs.c) that would kfree(tgt)
on a wrong place. I believe used kobject_del instead because of it but I afaik it does not
cleanup the kobj but only removes the directory from the sysfs.

Searching for it now on the doc I found:
"""
kobject_del() which will unregister the kobject from sysfs.  This makes the
kobject "invisible", but it is not cleaned up, and the reference count of
the object is still the same.  At a later time call kobject_put() to finish
the cleanup of the memory associated with the kobject.
"""

I feel that we only can kfree(tgt) on the error recover part if the error happened
before the tgt_kobj creation. After its creation the kfree only can be done by the
kobject release function.

What do you think?

> 
> See also below.
[snip]
> Thanks,
> Vlad
> -- 

Regards,
Daniel Debonzi
