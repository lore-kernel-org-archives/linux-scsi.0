From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 3/4] block: implement runtime pm strategy
Date: Wed, 23 May 2012 16:23:18 +0800
Message-ID: <CAF1ivSbukHBZJsguAcUVDbQotyvE5iAfccgfv+-bGw1v6Z3Dvw@mail.gmail.com>
References: <1337671292-15583-4-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205221210360.2100-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205221210360.2100-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 12:14 AM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> When a request is added:
>> =A0 =A0 If device is suspended or is suspending and the request is n=
ot a
>> =A0 =A0 PM request, resume the device.
>>
>> When a request finishes:
>> =A0 =A0 Call pm_runtime_mark_last_busy().
>>
>> When pick a request:
>> =A0 =A0 If device is not active, then only PM request is allowed to =
go.
>> =A0 =A0 Return NULL for other request.
>
> You've got the right idea. =A0There are a few things that need fixing=
, in
> this patch and in 4/4.
>
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1130,6 +1130,10 @@ void __blk_put_request(struct request_queue *=
q, struct request *req)
>> =A0 =A0 =A0 if (unlikely(--req->ref_count))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>>
>> + =A0 =A0 /* PM request is not accounted */
>> + =A0 =A0 if (!(req->cmd_flags & REQ_PM) && !(--q->nr_pending) && q-=
>dev)
>
> I don't see that it makes any difference. =A0You might as well count =
PM
> requests along with the others, here and elsewhere.

Need to think about this.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_mark_last_busy(q->dev);
>> +
>> =A0 =A0 =A0 elv_completed_request(q, req);
>>
>> =A0 =A0 =A0 /* this is a bio leak */
>> @@ -1918,6 +1922,12 @@ struct request *blk_peek_request(struct reque=
st_queue *q)
>> =A0 =A0 =A0 int ret;
>>
>> =A0 =A0 =A0 while ((rq =3D __elv_next_request(q)) !=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Only PM request is allowed to go if the=
 queue is suspended */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (q->rpm_status !=3D RPM_ACTIVE && !(rq-=
>cmd_flags & REQ_PM)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Not even PM requests should be allowed to go if the status is
> RPM_SUSPENDED.

PM requests are used to wake up the device.
If they are not allowed to go, then how to wake up the device?

>
> Is this the only interface by which a client driver can get a request
> from the queue?

I searched __elv_next_request and it's only called in blk_peek_request.

Jens,
Could you confirm this?

Thanks,
Lin Ming

>
> Alan Stern
