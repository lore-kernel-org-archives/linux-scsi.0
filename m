From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 3/4] block: implement runtime pm strategy
Date: Wed, 23 May 2012 10:53:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231052270.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSbukHBZJsguAcUVDbQotyvE5iAfccgfv+-bGw1v6Z3Dvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSbukHBZJsguAcUVDbQotyvE5iAfccgfv+-bGw1v6Z3Dvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* Only PM request is allowed to go if t=
he queue is suspended */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (q->rpm_status !=3D RPM_ACTIVE && !(r=
q->cmd_flags & REQ_PM)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >
> > Not even PM requests should be allowed to go if the status is
> > RPM_SUSPENDED.
>=20
> PM requests are used to wake up the device.
> If they are not allowed to go, then how to wake up the device?

When blk_pre_runtime_resume runs, the status is changed to
RPM_RESUMING.  _Then_ PM requests are allowed to go.  Not before.

Alan Stern
