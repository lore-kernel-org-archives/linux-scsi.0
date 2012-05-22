From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Tue, 22 May 2012 11:56:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205221142570.2100-100000@iolanthe.rowland.org>
References: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> > (Or maybe it would be easier to make q->rpm_status be a pointer to
> > q->dev->power.rpm_status. =A0That way, if CONFIG_PM_RUNTIME isn't e=
nabled
> > or block_runtime_pm_init() hasn't been called, you can have
> > q->rpm_status simply point to a static value that is permanently se=
t to
> > RPM_ACTIVE.)
>=20
> I think we need q->rpm_status.
> Block layer check ->rpm_status and client driver set this status.

No, the client driver should not have to set any status values.  The=20
client driver should do as little as possible.

> And the status is synchronized with queue's spin lock.

Right, and the client driver should not need to acquire the queue's=20
lock.

> If we use q->dev->power.rpm_status then how to sync it between block
> layer and client driver?
> Do you mean block layer will need to acquire q->dev->power.lock?

That's not what I mean.

What synchronization are you concerned about?  The most important race=20
seems to be when a new request is added to the queue at the same time=20
as a runtime suspend begins.

If q->dev->power.rpm_status has already been set to RPM_SUSPENDING or
RPM_SUSPENDED when the request is submitted, the block layer should
call pm_runtime_request_resume().  Thus if the suspend succeeds, the
device will be resumed immediately afterward.  And if the suspend
fails, the new request will be handled as usual (note that the
block_*_runtime_* routines might need to kick-start the queue to get it
going again).

Alternatively, if q->dev->power.rpm_status is still equal to RPM_ACTIVE=
=20
when the request is submitted, the block layer will simply accept the=20
request.  If the request is still on the queue when=20
block_pre_runtime_suspend is called, it will return -EBUSY and the=20
suspend will fail.

The only synchronization needed to make this work is that the
block_{pre,post}_runtime_suspend routines need to hold the queue's lock=
=20
while checking to see if any requests are in the queue.  You'd expect=20
that anyway.

Alan Stern
