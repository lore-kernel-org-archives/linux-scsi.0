From: Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Mon, 26 Nov 2007 08:54:26 +0100
Message-ID: <20071126075426.GC11261@ochil.suse.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4744A6F2.4030302@free.fr> <20071121144116.c932727b.akpm@linux-foundation.org> <4746814F.80502@free.fr> <4746866B.5070207@suse.de> <4746BB9D.2030508@suse.de> <1195926253.3195.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1195926253.3195.16.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 24, 2007 at 07:44:13PM +0200, James Bottomley wrote:
> Probing intermittent failures in Domain Validation, even with the fix=
es
> applied leads me to the conclusion that there are further problems wi=
th
> this commit:
>=20
> commit fc5eb4facedbd6d7117905e775cee1975f894e79
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
>=20
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> =20
> The essence of the problems is that you're causing REQ_FAILFAST to
> terminate commands with error on requeuing conditions, some of which =
are
> relatively common on most SCSI devices.  While this may be the correc=
t
> behaviour for multi-path, it's certainly wrong for the previously
> understood meaning of REQ_FAILFAST, which was don't retry on error,
> which is why domain validation and other applications use it to contr=
ol
> error handling, but don't expect to get failures for a simple requeue
> are now spitting errors.
>=20
> I honestly can't see that, even for the multi-path case, returning an
> error when we're over queue depth is the correct thing to do (it may =
not
> matter to something like a symmetrix, but an array that has a non-zer=
o
> cost associated with a path change, like a CPQ HSV or the AVT
> controllers, will show fairly large slow downs if you do this).  Even=
 if
> this is the desired behaviour (and I think that's a policy issue),
> DID_NO_CONNECT is almost certainly the wrong error to be sending back=
=2E
>=20
> This patch fixes up domain validation to work again correctly, howeve=
r,
> I really think it's just a bandaid.  Do you want to rethink the above
> commit?
>=20
Given the amounted error, yes, I'll have to.
But we still face the initial problem that requeued requests will be
stuck in the queue forever (ie until the timeout catches it), causing
failover to be painfully slow.

Anyway, I'll think it over.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=EF=BF=BDrnberg
GF: Markus Rex, HRB 16746 (AG N=EF=BF=BDrnberg)
