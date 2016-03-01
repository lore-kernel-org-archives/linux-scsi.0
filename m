From: ygardi@codeaurora.org
Subject: Re: [PATCH v5 03/15] scsi: ufs: implement scsi host timeout handler
Date: Tue, 1 Mar 2016 13:25:49 -0000
Message-ID: <2b8282aad0b3edfaf873628edf03513d.squirrel@us.codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
    <1456666367-11418-4-git-send-email-ygardi@codeaurora.org>
    <56D544E6.8040005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56D544E6.8040005@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
>> A race condition exists between request requeueing and scsi layer
>> error handling:
>> When UFS driver queuecommand returns a busy status for a request,
>> it will be requeued and its tag will be freed and set to -1.
>> At the same time it is possible that the request will timeout and
>> scsi layer will start error handling for it. The scsi layer reuses
>> the request and its tag to send error related commands to the device=
,
>> however its tag is no longer valid.
> Hmm. How can the host return a 'busy' status for a request?
> From my understanding we have three possibilities:
>
> 1) queuecommand returns busy; however, that means that the command ha=
s
> never been send and this issue shouldn't occur
> 2) The command returns with BUSY status. But in this case it has alre=
ady
> been returned, so there cannot be any timeout coming in.
> 3) The host receives a command with a tag which is already in-use.
> However, that should have been prevented by the block-layer, which
> really should ensure that this situation never happens.
>
> So either way I look at it, it really looks like a bug and adding a
> timeout handler will just paper over it.
> (Not that a timeout handler is a bad idea, in fact I'm convinced that
> you need one. Just not for this purpose.)
>
> So can you elaborate how this 'busy' status comes about?
> Is the command sent to the device?
>
> Cheers,
>
> Hannes


Hi Hannes,

it's going to be a bit long :)
I think you are missing the point.
I will describe a race condition happened to us a while ago, that was
quite difficult to understand and fix.
So, this patch is not about the "busy" returning to the scsi dispatch
routine. it's about the abort triggered after 30 seconds.

imagine a request being queued and sent to the scsi, and then to the uf=
s.
a timer, initialized to 30 seconds start ticking.
but the request is never sent to the ufs device, as queuecommand() retu=
rns
with "SCSI_MLQUEUE_HOST_BUSY"
by looking at the code, this could happen, for example:
	err =3D ufshcd_hold(hba, true);
	if (err) {
		err =3D SCSI_MLQUEUE_HOST_BUSY;
		goto out;
	}

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

> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>
