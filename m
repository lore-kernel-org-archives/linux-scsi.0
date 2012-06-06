From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Wed, 6 Jun 2012 23:26:47 +0900
Message-ID: <CAF1ivSYzeUzKPwgopYZTpSDR4oZKdXJ28GJNVVs7ysm1sn02TA@mail.gmail.com>
References: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
	<Pine.LNX.4.44L0.1206051313490.1542-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1206051313490.1542-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 6, 2012 at 2:27 AM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> > Next, you have to change the parts of the block layer responsible =
for
>> > taking a request from the queue and handing it to the lower-level
>> > driver (both peek and get). =A0If q->rpm_status is RPM_SUSPENDED, =
they
>> > shouldn't do anything -- act as though the queue is empty. =A0If
>> > q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand =
over
>> > the request only if it has the REQ_PM flag set.
>
> I just realized this isn't quite right. =A0In fact, when the status i=
s
> RPM_SUSPENDING or RPM_RESUMING you need to search through the queue f=
or
> the first request with REQ_PM set.
>
> Otherwise you can end up in a deadlock. =A0For example, suppose the
> device is suspended and a normal I/O request arrives. =A0It gets put =
on
> the queue and a runtime resume is issued. =A0The sd resume method the=
n
> submits a "spin-up drive" command to the queue with REQ_PM set, and i=
t
> doesn't return until this command is finished. =A0But the command won=
't
> even start, because it isn't at the head of the queue -- the I/O
> request is, and it prevents the "spin-up" command from running.

At least for SCSI sd driver, the PM request is always queued at the hea=
d.

scsi_execute()
  blk_execute_rq(req->q, NULL, req, 1);

"1" means the request will be inserted at the head.

blk_execute_rq_nowait()
   spin_lock_irq(q->queue_lock);
   __elv_add_request(q, rq, where);
   __blk_run_queue(q)
   spin_unlock_irq(q->queue_lock);

So the request is inserted at the head and executed immediatly.

>
> There are two other issues you also need to address. =A0The first is
> simple: Make sure your changes don't cause any harm if CONFIG_PM or
> CONFIG_PM_RUNTIME is set to N.
>
> Second, near the end of scsi_pm.c:scsi_bus_resume_common(), you can s=
ee
> that during resume from a system sleep, the device automatically gets
> set back to RPM_ACTIVE. =A0You want the queue's runtime status to rem=
ain
> in sync with the device's status; therefore you need to call
> blk_pre_runtime_resume near the start of this function and
> blk_post_runtime_resume near the end. =A0(This is the drawback of hav=
ing
> separate rpm_status fields for the queue and the device.)
>
> Alan Stern

I am travelling through June 10.
I'll investigate these when I'm back.

Thanks,
Lin Ming
