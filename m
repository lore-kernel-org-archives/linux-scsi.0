From: Hannes Reinecke <hare@suse.de>
Subject: Re: Kernel oops in sym_int_sir
Date: Thu, 03 May 2012 17:05:02 +0200
Message-ID: <4FA29E9E.8090401@suse.de>
References: <4FA143BC.2010702@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA143BC.2010702@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On 05/02/2012 04:25 PM, Stefan Bader wrote:
> While looking at a bug report [1] I found that the immediate cause of=
 the crash
> was in that specific case the reference cp->cmd for a printk:
>=20
> /*
>   * The device didn't switch to MSG IN phase after
>   * having reselected the initiator.
>   */
>  case SIR_RESEL_NO_MSG_IN:
>          scmd_printk(KERN_WARNING, cp->cmd,
>                          "No MSG IN phase after reselection\n");
>          goto out_stuck;
>=20
> Unfortunately cp (that is returned by sym_ccb_from_dsa()) is NULL. Th=
is probably
> is as old as 2.6.24 when this patch added the scmd_printk:
>=20
> commit 3fb364e089e05c35ead55a08d56d3004193681f6
> Author: Matthew Wilcox <matthew@wil.cx>
> Date: Fri Oct 5 15:55:10 2007 -0400
>=20
>     [SCSI] sym53c8xx: Use scmd_printk where appropriate
>=20
> A quick research looks like it might be other cases where this happen=
ed[2].
> Maybe more often (or solely?) when running in a VM (KVM). I even foun=
d some post
> that looks like it tries to fix just this problem[3].
>=20
> However without more knowledge about that driver it could also be a p=
roblem in
> the hardware emulation so that normally cp =3D=3D NULL should never h=
appen. Or it
> might be that the emulation is just running sufficiently "different" =
to cause
> races to happen which never would be observed on real hardware.
>=20
> Would [3] still make sense?
>=20
cp->cmd =3D=3D NULL would point to a race with SCSI command completion,
basically the same issue USB is facing right now.
So yes, it can happen (as you've seen), so I would got for [3].
And if only to avoid the Oops and figure out what _really_ went
wrong here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
