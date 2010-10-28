From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: tune fc_exch_em_alloc() to be O(2)
Date: Thu, 28 Oct 2010 22:12:52 +0800
Message-ID: <AANLkTi=gT1CZyaq1AsTDo3_DVVzrF6c0JLJaYKr+A85r@mail.gmail.com>
References: <AANLkTinpHyH31BsBKTHEg8CpbBYL1x7G3tMVu-1KGpy5@mail.gmail.com>
	<1288215374.1431.21729.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56965 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759040Ab0J1OMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 10:12:54 -0400
Received: by wyf28 with SMTP id 28so2001112wyf.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 07:12:53 -0700 (PDT)
In-Reply-To: <1288215374.1431.21729.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 5:36 AM, Robert Love <robert.w.love@intel.com> =
wrote:
> On Fri, 2010-10-22 at 20:20 +0800, Hillf Danton wrote:
>> For allocating new exch from pool, =C2=A0scanning for free slot in e=
xch
>> array fluctuates when exch pool is close to exhaustion.
>>
>> The fluctuation is smoothed, and the scan looks to be O(2).
>>
> Hi Hillf,
>
> =C2=A0 I think this patch is fine, aside from a few minor nits below.=
 I'm
> not sure how much this benefits us though. I don't think that it will
> hurt us, but I'd like to leave it in the fcoe-next tree a bit to make
> sure there aren't any adverse effects. I will fix the two issues I
> mention below and check it into fcoe-next, unless there are objection=
s.
>
> Have you done any profiling with this patch to show the improvement?

It is O(1) when looking up exch. Very cool.
In allocating O(1) was tried but failed.

>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-09-13 07:07:38.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-10-22 20:02:54.=
000000000 +0800
>> @@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
>> =C2=A0struct fc_exch_pool {
>> =C2=A0 =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0next_index;
>> =C2=A0 =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0total_exches;
>> +
>> + =C2=A0 =C2=A0 /* two cache of free slot in exch array */
>> + =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
left;
>> + =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
right;
>> +
>> =C2=A0 =C2=A0 =C2=A0 spinlock_t =C2=A0 =C2=A0 =C2=A0 lock;
>> =C2=A0 =C2=A0 =C2=A0 struct list_head ex_list;
>> =C2=A0};
>> @@ -397,13 +402,26 @@ static inline void fc_exch_ptr_set(struc
>> =C2=A0static void fc_exch_delete(struct fc_exch *ep)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 struct fc_exch_pool *pool;
>> + =C2=A0 =C2=A0 u16 index;
>>
>> =C2=A0 =C2=A0 =C2=A0 pool =3D ep->pool;
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&pool->lock);
>> =C2=A0 =C2=A0 =C2=A0 WARN_ON(pool->total_exches <=3D 0);
>> =C2=A0 =C2=A0 =C2=A0 pool->total_exches--;
>> - =C2=A0 =C2=A0 fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid) >>=
 fc_cpu_order,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 NULL);
>> +
>> + =C2=A0 =C2=A0 /* update cache of free slot */
>> + =C2=A0 =C2=A0 index =3D (ep->xid - ep->em->min_xid) >> fc_cpu_orde=
r;
>> + =C2=A0 =C2=A0 if (pool->left =3D=3D FC_XID_UNKNOWN)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =3D index;
>> + =C2=A0 =C2=A0 else if (pool->right =3D=3D FC_XID_UNKNOWN)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D index;
>> + =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XXX
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* next =3D entropy=
(index, left, right);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0**/
>
> We can remove this comment, right?

Node.

>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->next_index =3D ind=
ex;
>> +
>> + =C2=A0 =C2=A0 fc_exch_ptr_set(pool, index, NULL);
>> =C2=A0 =C2=A0 =C2=A0 list_del(&ep->ex_list);
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&pool->lock);
>> =C2=A0 =C2=A0 =C2=A0 fc_exch_release(ep); =C2=A0 =C2=A0/* drop hold =
for exch in mp */
>> @@ -679,6 +697,19 @@ static struct fc_exch *fc_exch_em_alloc(
>> =C2=A0 =C2=A0 =C2=A0 pool =3D per_cpu_ptr(mp->pool, cpu);
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&pool->lock);
>> =C2=A0 =C2=A0 =C2=A0 put_cpu();
>> +
>> + =C2=A0 =C2=A0 /* peek cache of free slot */
>> + =C2=A0 =C2=A0 if (pool->left !=3D FC_XID_UNKNOWN) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 index =3D pool->left;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =3D FC_XID_UN=
KNOWN;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto hit;
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 if (pool->right !=3D FC_XID_UNKNOWN) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 index =3D pool->right;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D FC_XID_U=
NKNOWN;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto hit;
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 index =3D pool->next_index;
>> =C2=A0 =C2=A0 =C2=A0 /* allocate new exch from pool */
>> =C2=A0 =C2=A0 =C2=A0 while (fc_exch_ptr_get(pool, index)) {
>> @@ -687,7 +718,7 @@ static struct fc_exch *fc_exch_em_alloc(
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto err;
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 pool->next_index =3D index =3D=3D mp->pool_max_=
index ? 0 : index + 1;
>> -
>> +hit:
>> =C2=A0 =C2=A0 =C2=A0 fc_exch_hold(ep); =C2=A0 =C2=A0 =C2=A0 /* hold =
for exch in mp */
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ep->ex_lock);
>> =C2=A0 =C2=A0 =C2=A0 /*
>> @@ -2181,6 +2212,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(st
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto free_mempool;
>> =C2=A0 =C2=A0 =C2=A0 for_each_possible_cpu(cpu) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool =3D per_cpu_pt=
r(mp->pool, cpu);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =C2=A0=3D
>
> I think we should initialize this without relying on the following li=
ne.

It looks like,

                    pool->left =3D pool->right =3D FC_XID_UNKNOWN;
right?

I want cache play its role after warm-up.

thanks //Hillf

>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D FC_XID_U=
NKNOWN;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&poo=
l->lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&poo=
l->ex_list);
>> =C2=A0 =C2=A0 =C2=A0 }
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
