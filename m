From: ygardi@codeaurora.org
Subject: Re: [PATCH v7 03/17] scsi: ufs: implement scsi host timeout handler
Date: Tue, 8 Mar 2016 13:36:35 -0000
Message-ID: <44a072f304240a3b19440e13c53a76df.squirrel@us.codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
    <1457440568-13084-4-git-send-email-ygardi@codeaurora.org>
    <56DECD23.7090704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56DECD23.7090704@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On 03/08/2016 01:35 PM, Yaniv Gardi wrote:
>> A race condition exists between request requeueing and scsi layer
>> error handling:
>> When UFS driver queuecommand returns a busy status for a request,
>> it will be requeued and its tag will be freed and set to -1.
>> At the same time it is possible that the request will timeout and
>> scsi layer will start error handling for it. The scsi layer reuses
>> the request and its tag to send error related commands to the device=
,
>> however its tag is no longer valid.
>> As this request was never really sent to the device, there is no
>> point to start error handling with the device.
>> Implement the scsi error handling timeout callback and bypass SCSI
>> error handling for request that were not actually sent to the device=
=2E
>> For such requests simply reset the block layer timer. Otherwise, let
>> SCSI layer perform the usual error handling.
>>
>> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>
> Having a timeout handler is always a good idea, even though this
> doesn't do anything here.
> Are we sure that the requests will return eventually?
> Does the UFS spec provide for a command abort?
>

I'm sorry, but I believe you are wrong in this case.
This timeout handler is doing exactly what we intend it to do,
and also, it is already tested and verified to fix the race condition i
explained a few threads back.

if the scsi command was dispatched to UFS and sent, let the usual SCSI
error handling handle it (return value is BLK_EH_NOT_HANDLED).
but, if the SCSI command was not actually dispatched to UFS driver, the=
n
return BLK_EH_RESET_TIMER and reset the timer, so we don't get
>>unjustified<< timeout, for command that was never dispatched.

also, i will paste again, the race-condition scenario, if anyone is
interested:

----------
I will describe a race condition happened to us a while ago, that was
quite difficult to understand and fix.
So, this patch is not about the "busy" returning to the scsi dispatch
routine. it's about the abort triggered after 30 seconds.

imagine a request being queued and sent to the scsi, and then to the uf=
s.
a timer, initialized to 30 seconds start ticking.
but the request is never sent to the ufs device, as queuecommand() retu=
rns
with "SCSI_MLQUEUE_HOST_BUSY" (which is normal behavior).

so, now, the request should be re-queued, and its timer should be reset=
=2E
(REMEMBER THIS POINT, let's call it "POINT A")
BUT, a context switch happens before it's actually re-queued, and CPU i=
s
moving to other tasks, doing other things for 30 seconds. yes, sounds
crazy, but it did happen.

NOW, the timeout_handler invoked, and the scsi_abort() routine start
executing, (since 30 seconds passed with no completion).
so far, so good.
but hey, another context switch happens, right at the beginning of
scsi_abort() routine, before anything useful happens. (this is "POINT B=
")
so, now, context is going back "POINT A", to the blk_requeue_request()
routine, that is calling:
blk_delete_timer(rq); (which does nothing cause the timer already expir=
ed)
and then it calls:
blk_queue_end_tag()
which place "-1" in the tag field of the request, marking the request, =
as
"not tagged yet".

however, a context switch happens again, and we are back in scsi_abort(=
)
routine ("POINT B"), that now needs to abort this very request, but hey=
,
in the "tag" field, what it sees is tag "-1" which is obviously wrong.

this patch fixes this very rare race condition:
1. upon timeout, blk_rq_timed_out() is called
2. then it calls rq_timed_out_fn() which eventually call
the new callback presented in this patch: "ufshcd_eh_timed_out()"
3. this routine returns with the right flag:
BLK_EH_NOT_HANDLED or BLK_EH_RESET_TIMER.
4. blk_rq_timed_out() checks the returned value:
in case of BLK_EH_HANDLED, it handles normally, meaning, calling scsi_a=
bort()
in case of BLK_EH_RESET_TIMER it starts a new timer, and scsi_abort()
never called.

hope that helps.
regards,

Yaniv





> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
>
