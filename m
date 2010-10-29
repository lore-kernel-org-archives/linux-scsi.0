From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: tune fc_exch_em_alloc() to be O(2)
Date: Fri, 29 Oct 2010 22:47:38 +0800
Message-ID: <AANLkTikaYEPybOjfm-jbf8EFA+iaiTsC5wxrRKpdB4x9@mail.gmail.com>
References: <AANLkTinpHyH31BsBKTHEg8CpbBYL1x7G3tMVu-1KGpy5@mail.gmail.com>
	<1288215374.1431.21729.camel@fritz>
	<AANLkTi=gT1CZyaq1AsTDo3_DVVzrF6c0JLJaYKr+A85r@mail.gmail.com>
	<7C88852EF6F99F4EB538472FCFEBE2220146F9C539@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44867 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab0J2Orl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 10:47:41 -0400
Received: by eye27 with SMTP id 27so2167346eye.19
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 07:47:40 -0700 (PDT)
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE2220146F9C539@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "Love, Robert W" <robert.w.love@intel.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Oct 28, 2010 at 11:04 PM, Zou, Yi <yi.zou@intel.com> wrote:
>> On Thu, Oct 28, 2010 at 5:36 AM, Robert Love <robert.w.love@intel.co=
m>
>> wrote:
>> > On Fri, 2010-10-22 at 20:20 +0800, Hillf Danton wrote:
>> >> For allocating new exch from pool, =C2=A0scanning for free slot i=
n exch
>> >> array fluctuates when exch pool is close to exhaustion.
>> >>
>> >> The fluctuation is smoothed, and the scan looks to be O(2).
>> >>
>> > Hi Hillf,
>> >
>> > =C2=A0 I think this patch is fine, aside from a few minor nits bel=
ow. I'm
>> > not sure how much this benefits us though. I don't think that it w=
ill
>> > hurt us, but I'd like to leave it in the fcoe-next tree a bit to m=
ake
>> > sure there aren't any adverse effects. I will fix the two issues I
>> > mention below and check it into fcoe-next, unless there are object=
ions.
>> >
>> > Have you done any profiling with this patch to show the improvemen=
t?
>>
>> It is O(1) when looking up exch. Very cool.
>> In allocating O(1) was tried but failed.
>>
> How much fluctuation have you observed? Your patch looks reasonable t=
o me
> to cache the freed xid and reuse it instead of scanning the array. Cu=
rrently,
> as we incrementally allocate new xid, earlier allocated xids are expe=
cted to
> be freed earlier, I would think so the distance to scan would not be =
really

There are many factors, say the load of the other end and the
congestion of network, as covered in TCP/IP, and I think it is hard to
estimate the fluctuation of the distance in middle/high usage of
exchange pool. //Hillf

> that bad.
>
> Also, on low use, we will probably only see xids of left and right, w=
hich I
> guess it's fine, don't recall if there's requirement on consecutive x=
id being
> apart from each other from the spec, but I am not sure.
>
> yi
>
>> >
>> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> >> ---
>> >>
>> >> --- a/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-09-13 07:07:=
38.000000000
>> +0800
>> >> +++ b/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-10-22 20:02:=
54.000000000
>> +0800
>> >> @@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
>> >> =C2=A0struct fc_exch_pool {
>> >> =C2=A0 =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0next_index;
>> >> =C2=A0 =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0total_exches;
>> >> +
>> >> + =C2=A0 =C2=A0 /* two cache of free slot in exch array */
>> >> + =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0left;
>> >> + =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0right;
>> >> +
>> >> =C2=A0 =C2=A0 =C2=A0 spinlock_t =C2=A0 =C2=A0 =C2=A0 lock;
>> >> =C2=A0 =C2=A0 =C2=A0 struct list_head ex_list;
>> >> =C2=A0};
>> >> @@ -397,13 +402,26 @@ static inline void fc_exch_ptr_set(struc
>> >> =C2=A0static void fc_exch_delete(struct fc_exch *ep)
>> >> =C2=A0{
>> >> =C2=A0 =C2=A0 =C2=A0 struct fc_exch_pool *pool;
>> >> + =C2=A0 =C2=A0 u16 index;
>> >>
>> >> =C2=A0 =C2=A0 =C2=A0 pool =3D ep->pool;
>> >> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&pool->lock);
>> >> =C2=A0 =C2=A0 =C2=A0 WARN_ON(pool->total_exches <=3D 0);
>> >> =C2=A0 =C2=A0 =C2=A0 pool->total_exches--;
>> >> - =C2=A0 =C2=A0 fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid)=
 >> fc_cpu_order,
>> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 NULL);
>> >> +
>> >> + =C2=A0 =C2=A0 /* update cache of free slot */
>> >> + =C2=A0 =C2=A0 index =3D (ep->xid - ep->em->min_xid) >> fc_cpu_o=
rder;
>> >> + =C2=A0 =C2=A0 if (pool->left =3D=3D FC_XID_UNKNOWN)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =3D index;
>> >> + =C2=A0 =C2=A0 else if (pool->right =3D=3D FC_XID_UNKNOWN)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D index=
;
>> >> + =C2=A0 =C2=A0 else
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XXX
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* next =3D entr=
opy(index, left, right);
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0**/
>> >
>> > We can remove this comment, right?
>>
>> Node.
>>
>> >
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->next_index =3D =
index;
>> >> +
>> >> + =C2=A0 =C2=A0 fc_exch_ptr_set(pool, index, NULL);
>> >> =C2=A0 =C2=A0 =C2=A0 list_del(&ep->ex_list);
>> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&pool->lock);
>> >> =C2=A0 =C2=A0 =C2=A0 fc_exch_release(ep); =C2=A0 =C2=A0/* drop ho=
ld for exch in mp */
>> >> @@ -679,6 +697,19 @@ static struct fc_exch *fc_exch_em_alloc(
>> >> =C2=A0 =C2=A0 =C2=A0 pool =3D per_cpu_ptr(mp->pool, cpu);
>> >> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&pool->lock);
>> >> =C2=A0 =C2=A0 =C2=A0 put_cpu();
>> >> +
>> >> + =C2=A0 =C2=A0 /* peek cache of free slot */
>> >> + =C2=A0 =C2=A0 if (pool->left !=3D FC_XID_UNKNOWN) {
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 index =3D pool->left;
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =3D FC_XID=
_UNKNOWN;
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto hit;
>> >> + =C2=A0 =C2=A0 }
>> >> + =C2=A0 =C2=A0 if (pool->right !=3D FC_XID_UNKNOWN) {
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 index =3D pool->right=
;
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D FC_XI=
D_UNKNOWN;
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto hit;
>> >> + =C2=A0 =C2=A0 }
>> >> +
>> >> =C2=A0 =C2=A0 =C2=A0 index =3D pool->next_index;
>> >> =C2=A0 =C2=A0 =C2=A0 /* allocate new exch from pool */
>> >> =C2=A0 =C2=A0 =C2=A0 while (fc_exch_ptr_get(pool, index)) {
>> >> @@ -687,7 +718,7 @@ static struct fc_exch *fc_exch_em_alloc(
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto err;
>> >> =C2=A0 =C2=A0 =C2=A0 }
>> >> =C2=A0 =C2=A0 =C2=A0 pool->next_index =3D index =3D=3D mp->pool_m=
ax_index ? 0 : index + 1;
>> >> -
>> >> +hit:
>> >> =C2=A0 =C2=A0 =C2=A0 fc_exch_hold(ep); =C2=A0 =C2=A0 =C2=A0 /* ho=
ld for exch in mp */
>> >> =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&ep->ex_lock);
>> >> =C2=A0 =C2=A0 =C2=A0 /*
>> >> @@ -2181,6 +2212,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(st
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto free_mempoo=
l;
>> >> =C2=A0 =C2=A0 =C2=A0 for_each_possible_cpu(cpu) {
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool =3D per_cpu=
_ptr(mp->pool, cpu);
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->left =C2=A0=3D
>> >
>> > I think we should initialize this without relying on the following=
 line.
>>
>> It looks like,
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 pool->left =3D pool->right =3D FC_XID_UNKNOWN;
>> right?
>>
>> I want cache play its role after warm-up.
>>
>> thanks //Hillf
>>
>> >
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pool->right =3D FC_XI=
D_UNKNOWN;
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&=
pool->lock);
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&=
pool->ex_list);
>> >> =C2=A0 =C2=A0 =C2=A0 }
>> >> _______________________________________________
>> >> devel mailing list
>> >> devel@open-fcoe.org
>> >> http://www.open-fcoe.org/mailman/listinfo/devel
>> >
>> >
>> >
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
