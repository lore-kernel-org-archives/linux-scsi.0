From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Tue, 5 Jun 2012 13:27:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206051313490.1542-100000@iolanthe.rowland.org>
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

> > Next, you have to change the parts of the block layer responsible f=
or
> > taking a request from the queue and handing it to the lower-level
> > driver (both peek and get). =A0If q->rpm_status is RPM_SUSPENDED, t=
hey
> > shouldn't do anything -- act as though the queue is empty. =A0If
> > q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand o=
ver
> > the request only if it has the REQ_PM flag set.

I just realized this isn't quite right.  In fact, when the status is
RPM_SUSPENDING or RPM_RESUMING you need to search through the queue for
the first request with REQ_PM set.

Otherwise you can end up in a deadlock.  For example, suppose the
device is suspended and a normal I/O request arrives.  It gets put on
the queue and a runtime resume is issued.  The sd resume method then
submits a "spin-up drive" command to the queue with REQ_PM set, and it
doesn't return until this command is finished.  But the command won't
even start, because it isn't at the head of the queue -- the I/O
request is, and it prevents the "spin-up" command from running.

There are two other issues you also need to address.  The first is
simple: Make sure your changes don't cause any harm if CONFIG_PM or
CONFIG_PM_RUNTIME is set to N.

Second, near the end of scsi_pm.c:scsi_bus_resume_common(), you can see
that during resume from a system sleep, the device automatically gets
set back to RPM_ACTIVE.  You want the queue's runtime status to remain
in sync with the device's status; therefore you need to call
blk_pre_runtime_resume near the start of this function and
blk_post_runtime_resume near the end.  (This is the drawback of having
separate rpm_status fields for the queue and the device.)

Alan Stern
