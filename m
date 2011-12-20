From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
Date: Mon, 19 Dec 2011 17:45:14 -0800
Message-ID: <CAA9_cmfRXgwsamx2Q+Wccyfqnz3ePt60Z950pPippJuOnooJLA@mail.gmail.com>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>
	<4EA57E40.2020301@tao.ma>
	<4EA670F9.8030601@kernel.dk>
	<CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com>
	<4EEFE0AE.7040201@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EEFE0AE.7040201@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 5:11 PM, Tao Ma <tm@tao.ma> wrote:
>>> Looks good, better than what we had. Applied.
>>
>> This appears to interact badly with scsi_adjust_queue_depth() when t=
he
>> tag space shrinks. =A0I can reproduce a similar crash as reported in
>> "3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
>> (__scsi_queue_insert)" [1].
>>
>> I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
>> BUG_ON(blk_queued_rq(rq)) check reliably with:
>> # for i in $(seq 0 10); do dd if=3D/dev/zero of=3D/dev/sdX & done
>> # echo 4 > /sys/class/block/sdX/device/queue_depth
>>
>> The following fixes it for me, if this looks ok (versus reverting
>> commit 5e081591) I'll roll it into a formal patch with Ed and Meelis=
'
>> Reported-by.
> Interesting. If I read the code correctly, real_max_depth is the maxi=
mum
> queue depth we ever have and max_depth is the current depth.
>
> In your fix, we never resize the tag size to be smaller than max_dept=
h.
> So I think this patch does expose some problem, but not lead to the B=
UG.

Yes, if we keep the "if (unlikely(tag >=3D bqt->max_depth))" check in
blk_queue_end_tag() then the side effect is that we can never shrink
the tag depth, which I don't think was intended.

> And in your new comment, you mentioned that "request between new_dept=
h
> and max_depth can be in-flight", but max_depth <=3D real_max_depth, s=
o
> what's wrong with the comment? Sorry, but am I missing something here=
?

Prior to the change blk_queue_end_tag() would continue to complete
requests with a tag > max_depth, now it silently drops them on the
floor leaving BUG_ON(blk_queued_rq(rq)) to trigger when we try to end
the request

> Having said that, I have tried the test in my machine here, but have =
no
> luck by now. My kernel version is 3.2.0-rc5+.

What controller are you using?  I am using the isci driver with a sas
disk.  Meelis saw it with aic7xxx on a parallel scsi disk.

--
Dan
