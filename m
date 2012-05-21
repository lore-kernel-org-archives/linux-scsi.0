From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Mon, 21 May 2012 14:32:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205211430220.1725-100000@iolanthe.rowland.org>
References: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 21 May 2012, Lin Ming wrote:

> On Mon, May 21, 2012 at 11:00 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
> > On Mon, 21 May 2012, Lin Ming wrote:
> >
> >> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard=
=2Eedu> wrote:
> >> [snip]
> >> > I may have left some parts out from this brief description. =A0H=
opefully
> >> > you'll be able to figure out the general idea and get it to work=
=2E
> >>
> >> All journal threads and flusher thread of the disk need to be free=
zed
> >> before suspend and thaw after resume.
> >
> > Why? =A0If any of those threads needs to write something to the dis=
k
> > while the disk is suspended, the disk will simply be resumed.
>=20
> When tested the patches, I found that kjournald and flusher thread
> frequently resume the disk.
>=20
> I'm not familiar with journal.
> Are the journal threads still need to be in active state when the dis=
k
> is already suspended?

I don't know the answers.  Maybe Jens can tell us.

Ideally, a rotating disk wouldn't be suspended unless all the dirty=20
blocks were already flushed and the journal was up-to-date.  For an=20
SSD, frequently suspending and resuming doesn't matter quite so much. =20
This may come down to a matter of setting the right value for the=20
autosuspend timeout.

Alan Stern
