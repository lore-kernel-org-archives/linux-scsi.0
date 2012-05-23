From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Wed, 23 May 2012 23:59:07 +0800
Message-ID: <CAF1ivSbSv+pWFxgf8LrHdamxSQZuJh5S5_0L82DWfy34Si7iLg@mail.gmail.com>
References: <CAF1ivSa_hYFu2JXLUOv2k+AhqUZWUvY-uzmocQKh_RUJJUP5Ag@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231054150.1566-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205231054150.1566-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 10:58 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Wed, 23 May 2012, Lin Ming wrote:
>
>> Let's consider below code.
>>
>> @@ -587,6 +591,11 @@ void __elv_add_request(struct request_queue *q,
>> struct request *rq, int where)
>> =A0{
>> =A0 =A0 =A0 =A0trace_block_rq_insert(q, rq);
>>
>> + =A0 =A0 =A0 if (!(rq->cmd_flags & REQ_PM))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (q->nr_pending++ =3D=3D 0 && (q->rp=
m_status =3D=3D RPM_SUSPENDED ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rpm=
_status =3D=3D RPM_SUSPENDING) && q->dev)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_request_resume(q->d=
ev);
>> +
>> =A0 =A0 =A0 =A0rq->q =3D q;
>>
>> =A0 =A0 =A0 =A0if (rq->cmd_flags & REQ_SOFTBARRIER) {
>>
>> Block layer reads runtime status and pm core writes this status.
>> PM core uses dev->power.lock to protect this status.
>>
>> I was thinking will it have problem if block layer does not acquire
>> dev->power.lock?
>> From your explanation below, it seems does not have problem.
>
> I don't think it's a problem, because all you're doing is reading
> dev->power.rpm_status -- you're not writing it.
>
> On the other hand, there's nothing really wrong with keeping your own
> local copy of rpm_status. =A0You could think of it as being the queue=
's
> status as opposed to the device's status. =A0(Also, some people might
> argue that dev->power.rpm_status is supposed to be private to the
> runtime PM core and shouldn't be used by other code.)

Agree.
So I'd like to keep local copy of rpm_status.
