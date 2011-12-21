From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 09:37:17 -0800
Message-ID: <CABE8wwuO7=Jo2RkrBFgnvuQP2X5UAohP-ZdWg6WejXUe+XRYyA@mail.gmail.com>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
	<4EF17DC4.5010008@tao.ma>
	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
	<4EF18129.7030407@tao.ma>
	<CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
	<20111221132029.GK20129@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111221132029.GK20129@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tao Ma <tm@tao.ma>, Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2011 at 5:20 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Dec 20, 2011 at 11:30:14PM -0800, Williams, Dan J wrote:
>> @@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
>> struct request *rq)
>> =A0 =A0 =A0 =A0 struct blk_queue_tag *bqt =3D q->queue_tags;
>> =A0 =A0 =A0 =A0 int tag =3D rq->tag;
>>
>> - =A0 =A0 =A0 BUG_ON(tag =3D=3D -1);
>> -
>> - =A0 =A0 =A0 if (unlikely(tag >=3D bqt->max_depth)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* This can happen after tag depth h=
as been reduced.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* But tag shouldn't be larger than =
real_max_depth.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(tag >=3D bqt->real_max_depth);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> - =A0 =A0 =A0 }
>> + =A0 =A0 =A0 BUG_ON(tag =3D=3D -1 || tag > bqt->real_max_depth);
>
> or ...
>
> - =A0 =A0 =A0 int tag =3D rq->tag;
> + =A0 =A0 =A0 unsigned tag =3D rq->tag;
> + =A0 =A0 =A0 BUG_ON(tag >=3D bqt->real_max_depth);
>
> since tags in the range INT_MIN to -2 are also a bug, right?

Yes, even better... patch coming up.
