From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] add cpu on/offline support in Fibre Channel
 exchange and sequence handling
Date: Thu, 14 Oct 2010 22:55:53 +0800
Message-ID: <AANLkTimint=YBjeU3hrgDP16cPttKxzzEmJGB=f=85n=@mail.gmail.com>
References: <AANLkTi=ViAo=uYK0JwK597WkV1x78mntFqU-Cn4u0Dju@mail.gmail.com>
	<1286834888.13422.1572.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35410 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0JNOzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 10:55:55 -0400
Received: by ewy20 with SMTP id 20so3422574ewy.19
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2010 07:55:53 -0700 (PDT)
In-Reply-To: <1286834888.13422.1572.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, devel@open-fcoe.org, linux-scsi@vger.kernel.org

Hi Rob,

Sorry for replying late.

On Tue, Oct 12, 2010 at 6:08 AM, Robert Love <robert.w.love@intel.com> =
wrote:
> On Fri, 2010-10-08 at 22:57 +0800, Hillf Danton wrote:
>
> Hi Hillf,
>
> Can you please prefix the libfc patches with "libfc: <title>"? Also, =
for

Yes, I can.

> your other patches that have a "SCSI" prefix, I think James' system a=
dds
> the "[SCSI]" prefix when he applies patches so you don't need to add =
it.

I will remove SCSI.

>
>> Fibre Channel exchange pool is setup in a per cpu way that
>> entire exchange id range is divided equally across all cpus.
>>
>> When cpu goes offline, the corresponding range of exchg id
>> becomes unavailable until it is online again.
>>
>> This work tries to fix the unavailability based on notifier_block.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- o/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c =C2=A0 2010-09-1=
3
>> 07:07:38.000000000 +0800
>> +++ m/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c =C2=A0 2010-10-0=
8
>> 22:24:48.000000000 +0800
>
> Most patches I've seen on the various mailing lists are created by
> diffing the files within the kernel directory, so that you don't have
> the "/linux-2.6.36-rc/" in each hunk. It's the difference between usi=
ng
> 'patch -p1' or 'patch -p2' when applying the patch.

I want to show clearly patch reviewers the kernel version.

>
> I think this is preventing git-am from applying the patches. To impor=
t
> them I ended up having git-am fail and then manually using the 'patch
> -p2' command, so that I could get both the commit message from git-am
> and then the patch itself from 'patch'. I don't know about anyone els=
e,
> but if you post patches without the kernel directory in the diff line=
 it
> would help me out. Thanks.

Sorry for getting you in trouble.

>
>> @@ -26,6 +26,9 @@
>> =C2=A0#include <linux/timer.h>
>> =C2=A0#include <linux/slab.h>
>> =C2=A0#include <linux/err.h>
>> +#include <linux/notifier.h>
>> +#include <linux/cpu.h>
>> +#include <linux/cpumask.h>
>>
>> =C2=A0#include <scsi/fc/fc_fc2.h>
>>
>> @@ -40,6 +43,8 @@ static u16 =C2=A0fc_cpu_order; =C2=A0 /* 2's power=
 to
>> =C2=A0static struct kmem_cache *fc_em_cachep; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 /* cache for exchanges */
>> =C2=A0struct workqueue_struct *fc_exch_workqueue;
>>
>> +static cpumask_t fc_offline_cpu_mask =3D CPU_MASK_NONE;
>> +
>> =C2=A0/*
>> =C2=A0 * Structure and function definitions for managing Fibre Chann=
el Exchanges
>> =C2=A0 * and Sequences.
>> @@ -666,6 +671,7 @@ static struct fc_exch *fc_exch_em_alloc(
>> =C2=A0 =C2=A0 =C2=A0 unsigned int cpu;
>> =C2=A0 =C2=A0 =C2=A0 u16 index;
>> =C2=A0 =C2=A0 =C2=A0 struct fc_exch_pool *pool;
>> + =C2=A0 =C2=A0 unsigned int index =3D -1;
>
> This patch doesn't compile:

This is my fault when I prepare the patch based upon
for_each_cpu in cpumask.h, and sorry.

/**
 * for_each_cpu - iterate over every cpu in a mask
 * @cpu: the (optionally unsigned) integer iterator
 * @mask: the cpumask pointer
 *
 * After the loop, cpu is >=3D nr_cpu_ids.
 */

>
> drivers/scsi/libfc/fc_exch.c: In function =E2=80=98fc_exch_em_alloc=E2=
=80=99:
> drivers/scsi/libfc/fc_exch.c:674: error: conflicting types for =E2=80=
=98index=E2=80=99
> drivers/scsi/libfc/fc_exch.c:672: note: previous declaration of =E2=80=
=98index=E2=80=99
> was here
> make[3]: *** [drivers/scsi/libfc/fc_exch.o] Error 1
>
> In general I think the idea is fine. I haven't run into any
> circumstances where the per-CPU pools are exhausted. I know others ha=
ve

The design of exch pool is an outstandingly good model for applications=
 in
the environment of multiple cpus, it will be in my work.

> when using NPIV, but there were other ways to fix those issues.
>
>>
>> =C2=A0 =C2=A0 =C2=A0 /* allocate memory for exchange */
>> =C2=A0 =C2=A0 =C2=A0 ep =3D mempool_alloc(mp->ep_pool, GFP_ATOMIC);
>> @@ -679,6 +685,7 @@ static struct fc_exch *fc_exch_em_alloc(
>> =C2=A0 =C2=A0 =C2=A0 pool =3D per_cpu_ptr(mp->pool, cpu);
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&pool->lock);
>> =C2=A0 =C2=A0 =C2=A0 put_cpu();
>> +again:
>> =C2=A0 =C2=A0 =C2=A0 index =3D pool->next_index;
>> =C2=A0 =C2=A0 =C2=A0 /* allocate new exch from pool */
>> =C2=A0 =C2=A0 =C2=A0 while (fc_exch_ptr_get(pool, index)) {
>> @@ -719,6 +726,17 @@ out:
>> =C2=A0err:
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&pool->lock);
>> =C2=A0 =C2=A0 =C2=A0 atomic_inc(&mp->stats.no_free_exch_xid);
>
> I think this should be moved below the offline pool check, when we've

Node.

> really failed to allocate an exchange. It's not a per-CPU pool stat,
> it's an overall resource allocation failure stat, which you're now
> helping to happen less frequently. With the current placement we'll b=
e
> bumping up the counter even though we have allocated an exchange.
>
> Thanks, //Rob
>
>

Thank you for sharing so much.

//Hillf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
