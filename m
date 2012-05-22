From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Tue, 22 May 2012 14:12:58 +0800
Message-ID: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
References: <1337269686-3781-3-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Thu, 17 May 2012, Lin Ming wrote:
>
>> Add runtime pm suspend/resume callbacks to request queue.
>> As an example, implement these callbacks in sd driver.
>
> This is not the way to do it. =A0The block subsystem should not use
> suspend/resume callbacks.
>
> Instead, there should be block functions that can be called by client
> drivers: block_pre_runtime_suspend, block_post_runtime_suspend,
> bock_pre_runtime_resume, and block_post_runtime_resume.
>
> They should do something like this:
>
> =A0 =A0 =A0 =A0block_pre_runtime_suspend:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0If any requests are in the queue, retu=
rn -EBUSY.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Otherwise set q->rpm_status to RPM_SUS=
PENDING and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0.
>
> =A0 =A0 =A0 =A0block_post_runtime_suspend:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0If the suspend succeeded then set q->r=
pm_status to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RPM_SUSPENDED. =A0Otherwise set it to =
RPM_ACTIVE and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0call pm_runtime_mark_last_busy().
>
> =A0 =A0 =A0 =A0block_pre_runtime_resume:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Set q->rpm_status to RPM_RESUMING.
>
> =A0 =A0 =A0 =A0block_post_runtime_resume:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0If the resume succeeded then set q->rp=
m_status to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RPM_ACTIVE and call pm_runtime_mark_la=
st_busy() and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pm_runtime_request_autosuspend().
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Otherwise set q->rpm_status to RPM_SUS=
PENDED.
>
> There should also be an initialization function for client drivers to
> call. =A0block_runtime_pm_init() should call pm_runtime_mark_last_bus=
y(),
> pm_runtime_use_autosuspend(), and pm_runtime_autosuspend().
>
> Next, you have to modify the parts of the block layer that run when a
> new request is added to the queue or a request is removed.
>
> =A0 =A0 =A0 =A0When a request is added:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0If q->rpm_status is RPM_SUSPENDED, or =
if q->rpm_status
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is RPM_SUSPENDING and the REQ_PM flag =
isn't set, call
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pm_runtime_request_resume().
>
> =A0 =A0 =A0 =A0When a request finishes:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Call pm_runtime_mark_last_busy().
>
> Next, you have to change the parts of the block layer responsible for
> taking a request from the queue and handing it to the lower-level
> driver (both peek and get). =A0If q->rpm_status is RPM_SUSPENDED, the=
y
> shouldn't do anything -- act as though the queue is empty. =A0If
> q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand ove=
r
> the request only if it has the REQ_PM flag set.
>
> For this to work, the block layer has to know what struct device
> pointer to pass to the pm_runtime_* routines. =A0You'll have to add t=
hat
> information to the request_queue structure; I guess q->dev can get se=
t
> by block_pm_runtime_init(). =A0In fact, when that's done you won't ne=
ed
> q->rpm_status any more. =A0You'll be able to use c
> directly, and you won't have to update it because the PM core does th=
at
> for you.
>
> (Or maybe it would be easier to make q->rpm_status be a pointer to
> q->dev->power.rpm_status. =A0That way, if CONFIG_PM_RUNTIME isn't ena=
bled
> or block_runtime_pm_init() hasn't been called, you can have
> q->rpm_status simply point to a static value that is permanently set =
to
> RPM_ACTIVE.)

I think we need q->rpm_status.
Block layer check ->rpm_status and client driver set this status.
And the status is synchronized with queue's spin lock.

If we use q->dev->power.rpm_status then how to sync it between block
layer and client driver?
Do you mean block layer will need to acquire q->dev->power.lock?

Lin Ming

>
> I may have left some parts out from this brief description. =A0Hopefu=
lly
> you'll be able to figure out the general idea and get it to work.
>
> Alan Stern
