From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] block: Check that queue is alive in blk_insert_cloned_request()
Date: Mon, 11 Jul 2011 20:52:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107112050480.17690-100000@netrider.rowland.org>
References: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Jul 2011, Mike Snitzer wrote:

> [cc'ing dm-devel, vivek and tejun]
>=20
> On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wro=
te:
> > From: Roland Dreier <roland@purestorage.com>
> >
> > This fixes crashes such as the below that I see when the storage
> > underlying a dm-multipath device is hot-removed. =A0The problem is =
that
> > dm requeues a request to a device whose block queue has already bee=
n
> > cleaned up, and blk_insert_cloned_request() doesn't check if the qu=
eue
> > is alive, but rather goes ahead and tries to queue the request. =A0=
This
> > ends up dereferencing the elevator that was already freed in
> > blk_cleanup_queue().
>=20
> Your patch looks fine to me:
> Acked-by: Mike Snitzer <snitzer@redhat.com>

There's still the issue that Stefan Richter pointed out: The test for a=
=20
dead queue must be made _after_ acquiring the queue lock, not _before_.

Alan Stern
