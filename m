From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
Date: Mon, 19 Dec 2011 16:07:04 -0800
Message-ID: <CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>
	<4EA57E40.2020301@tao.ma>
	<4EA670F9.8030601@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EA670F9.8030601@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 1:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-10-24 17:03, Tao Ma wrote:
>> Hi Jens,
>> =A0 =A0 =A0 any option with this patch?
>>
>> Thanks
>> Tao
>> On 09/14/2011 03:23 PM, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In case tag depth is reduced, it is max_depth not real_max_depth.
>>> So we should allow a request with tag >=3D max_depth, but for a
>>> tag >=3D real_max_depth, there really should be some problem.
>>>
>>> Cc: Jens Axboe <jaxboe@fusionio.com>
>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>> ---
>>> =A0block/blk-tag.c | =A0 =A06 ++++--
>>> =A01 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/block/blk-tag.c b/block/blk-tag.c
>>> index ece65fc..e74d6d1 100644
>>> --- a/block/blk-tag.c
>>> +++ b/block/blk-tag.c
>>> @@ -286,12 +286,14 @@ void blk_queue_end_tag(struct request_queue *=
q, struct request *rq)
>>>
>>> =A0 =A0 =A0BUG_ON(tag =3D=3D -1);
>>>
>>> - =A0 =A0if (unlikely(tag >=3D bqt->real_max_depth))
>>> + =A0 =A0if (unlikely(tag >=3D bqt->max_depth)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 * This can happen after tag depth has b=
een reduced.
>>> - =A0 =A0 =A0 =A0 =A0 =A0 * FIXME: how about a warning or info mess=
age here?
>>> + =A0 =A0 =A0 =A0 =A0 =A0 * But tag shouldn't be larger than real_m=
ax_depth.
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>>> + =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(tag >=3D bqt->real_max_depth);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>> + =A0 =A0}
>>>
>>> =A0 =A0 =A0list_del_init(&rq->queuelist);
>>> =A0 =A0 =A0rq->cmd_flags &=3D ~REQ_QUEUED;
>
> Looks good, better than what we had. Applied.

This appears to interact badly with scsi_adjust_queue_depth() when the
tag space shrinks.  I can reproduce a similar crash as reported in
"3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
(__scsi_queue_insert)" [1].

I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
BUG_ON(blk_queued_rq(rq)) check reliably with:
# for i in $(seq 0 10); do dd if=3D/dev/zero of=3D/dev/sdX & done
# echo 4 > /sys/class/block/sdX/device/queue_depth

The following fixes it for me, if this looks ok (versus reverting
commit 5e081591) I'll roll it into a formal patch with Ed and Meelis'
Reported-by.

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..09cf867 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -230,9 +230,12 @@ int blk_queue_resize_tags(struct request_queue
*q, int new_depth)
        /*
         * if we already have large enough real_max_depth.  just
         * adjust max_depth.  *NOTE* as requests with tag value
-        * between new_depth and real_max_depth can be in-flight, tag
+        * between new_depth and max_depth can be in-flight, tag
         * map can not be shrunk blindly here.
         */
+       if (new_depth <=3D bqt->max_depth)
+               return 0;
+
        if (new_depth <=3D bqt->real_max_depth) {
                bqt->max_depth =3D new_depth;
                return 0;

--
Dan

[1]: http://marc.info/?l=3Dlinux-kernel&m=3D132204370518629&w=3D2
