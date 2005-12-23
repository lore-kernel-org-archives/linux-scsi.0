From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Sat, 24 Dec 2005 00:26:04 +0300
Message-ID: <20051223212604.GA9382@procyon.home>
References: <200512212359.jBLNxluV016971@hera.kernel.org> <20051222221329.5f317b8d.akpm@osdl.org> <20051223234338.798294f9.vsu@altlinux.ru> <1135371219.3728.50.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master.altlinux.org ([62.118.250.235]:1041 "EHLO
	master.altlinux.org") by vger.kernel.org with ESMTP
	id S1161052AbVLWV0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 16:26:21 -0500
Content-Disposition: inline
In-Reply-To: <1135371219.3728.50.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 23, 2005 at 02:53:39PM -0600, James Bottomley wrote:
> On Fri, 2005-12-23 at 23:43 +0300, Sergey Vlasov wrote:
> > So if that GFP_ATOMIC allocation ever fails, the target is leaked
> > forever - does not look nice.
>=20
> Yes, but it will print a warning.
>=20
> > Does anything depend on starget->siblings being empty after we had
> > removed it from the shost->__targets list it was on?  Seems that all
> > other uses of this field are:
> >
> > drivers/scsi/scsi_scan.c:313:   list_for_each_entry(starget, &shost->__=
targets, siblings) {
> > drivers/scsi/scsi_scan.c:365:   INIT_LIST_HEAD(&starget->siblings);
> > drivers/scsi/scsi_scan.c:373:   list_add_tail(&starget->siblings, &shos=
t->__targets);
> >=20
> > So probably we can reuse this field and do deferred reaping without any
> > memory allocation at all.  The following patch should be applied
> > _instead_ of the James' patch, not on top of it (I can make a combined
> > patch if it is desired).  The difference with the previous patch is that
> > scsi_target_reap() still removes the target from shost->__targets
> > immediately - only device_del() and subsequent actions are deferred to a
> > workqueue.
>=20
> No, you can't.
>=20
> If you do this, the target namespace will potentially be in use in sysfs
> after the system thinks the target is gone.  Thus, any reallocation
> fails because you can't add a new target with the same name as an
> existing one.

Ah, I see now... scsi_alloc_target() checks if a target with the same
channel/id combination is on the list and adds new target only if
there was no such one before.

However, what prevents a race between scsi_target_reap_work() and
scsi_alloc_target()?  If the worker thread is interrupted/preempted
just after releasing host_lock (when it has already removed the target
from the list, but before it has called device_del()),
scsi_alloc_target() might consider the target as new and get to
device_add() faster.

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDrGtsW82GfkQfsqIRAugoAJ4ljqQ6Bs1TJxVZj3zyUD9rZ0jAYwCfeJH4
lTgvb1a5JxgGfYxyIuXYm4g=
=dXKp
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
