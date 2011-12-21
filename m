From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Tue, 20 Dec 2011 23:30:14 -0800
Message-ID: <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
	<4EF17DC4.5010008@tao.ma>
	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
	<4EF18129.7030407@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EF18129.7030407@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 20, 2011 at 10:48 PM, Tao Ma <tm@tao.ma> wrote:
> On 12/21/2011 02:36 PM, Meelis Roos wrote:
>>>> - =A0 if (unlikely(tag >=3D bqt->max_depth)) {
>>>> + =A0 if (WARN_ONCE(tag >=3D bqt->real_max_depth,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s: tag %d greater than tag map=
 size: %d\n",
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, tag, bqt->real_max_dep=
th)) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 /*
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0* This can happen after tag depth has b=
een reduced.
>>> Please also change the comments here since it should never happen i=
n the
>>> right workload.
>>
>> What do you mean by right workload? Normal workload?
> yeah, so real_max_depth is the maximum depth we ever have. So in norm=
al
> case(shrinking queue depth is also a normal user case), we should nev=
er
> arrive here. In another word, if tag >=3D real_max_depth, we should h=
ave a
> bug in the kernel.

So this is what Ed Nadolski suggested, just cut to the chase and do,
the following.  Seems like the comment is what got us into trouble in
the first place.

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..e297d9d7 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
struct request *rq)
        struct blk_queue_tag *bqt =3D q->queue_tags;
        int tag =3D rq->tag;

-       BUG_ON(tag =3D=3D -1);
-
-       if (unlikely(tag >=3D bqt->max_depth)) {
-               /*
-                * This can happen after tag depth has been reduced.
-                * But tag shouldn't be larger than real_max_depth.
-                */
-               WARN_ON(tag >=3D bqt->real_max_depth);
-               return;
-       }
+       BUG_ON(tag =3D=3D -1 || tag > bqt->real_max_depth);
