From: Muli Ben-Yehuda <mulix@mulix.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Sat, 17 Jan 2004 01:01:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116230118.GP734@actcom.co.il>
References: <40085EDA.4010802@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aIbcA3MSwnGacr4f"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.actcom.co.il ([192.114.47.15]:34726 "EHLO
	smtp2.actcom.co.il") by vger.kernel.org with ESMTP id S265975AbUAPXB3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 18:01:29 -0500
Content-Disposition: inline
In-Reply-To: <40085EDA.4010802@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


--aIbcA3MSwnGacr4f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2004 at 03:59:54PM -0600, Brian King wrote:

> http://www-124.ibm.com/storageio/ipr/patch-2.6.1-ipr-2.0.0-1.gz

Hi, I took a look and I have some comments / questions. I will try to
go over all of it in the next few days, but here's what I went over so
far:=20

> +static int ipr_unsafe =3D 1;		/* xxx set to 0 for ship */

Should it be set to 0 or to 1 for inclusion in the kernel? any driver
that is first included is considered experimental, so just how unsafe
is ipr_unsafe?

> +module_param_named(unsafe, ipr_unsafe, int, 0);
> +MODULE_PARM_DESC(unsafe, "Do not use!");

Same question, I guess, and if you decide to keep it, please add a
more descriptive MODULE_PARM_DESC string...=20

> +static void ipr_sleep_no_lock(signed long delay)
> +{
> +	DECLARE_WAIT_QUEUE_HEAD(internal_wait);
> +
> +	sleep_on_timeout(&internal_wait, (delay * HZ) / 1000);
> +	return;

just a nitpick, but the Linux coding style says no 'return' from void
functions.=20

>+static void ipr_sleep(struct ipr_ioa_cfg *ioa_cfg, signed long delay)
> +{
> +	spin_unlock_irq(ioa_cfg->host->host_lock);
> +	ipr_sleep_no_lock(delay);
> +	spin_lock_irq(ioa_cfg->host->host_lock);

Hmpf... it's called from ipr_diagnostic_ioctl(), which does
spin_lock_irqsave()
ipr_sleep()
spin_unlock_irqrestore()

So I guess you really do intend to enable interrupts before going to
sleep? it's somewhat fragile... also, is the dropping and
reacquisition of the lock safe here (in the sense that none of the
data the lock is protecting that we care about can change while the
lock is not held?)

Same questions wrt ipr_interruptible_sleep_on(), which does the same
thing. By the way, ipr_dump_ioctl does not check the return value from
ipr_interruptible_sleep_on(). If this is intentional, perhaps call it
using (void)ipr_interruptible_sleep_on()?

> +static void ipr_block_requests(struct ipr_ioa_cfg *ioa_cfg)
> +{
> +	ENTER;
> +
> +	if (0 =3D=3D ioa_cfg->block_host_ops++) {
> +	   ioa_cfg->allow_cmds =3D 0;

This is racy unless a lock is held. I think a lock is held here in all
callers of this function, but a comment to that effect would be nice
before the function. This also applies to every other function which
either must be called with a lock taken, or modifies the "locking
status" - takes a lock which is released elsewhere, enables interrupts
unconditionally, etc.=20

+static void ipr_unblock_requests(struct ipr_ioa_cfg *ioa_cfg)
+{
+	ENTER;
+
+	if (0 =3D=3D --ioa_cfg->block_host_ops) {
+	   ioa_cfg->allow_cmds =3D 1;
+	   spin_unlock_irq(ioa_cfg->host->host_lock);
+	   scsi_unblock_requests(ioa_cfg->host);
+	   spin_lock_irq(ioa_cfg->host->host_lock);

Eeek! What happens if on another CPU a call comes in that does
ipr_block_requests() after the lock is released and before it is taken
again?

That's as far as I got, for now.=20

Cheers,=20
Muli=20
--=20
Muli Ben-Yehuda
http://www.mulix.org | http://mulix.livejournal.com/

"the nucleus of linux oscillates my world" - gccbot@#offtopic


--aIbcA3MSwnGacr4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFACG0+KRs727/VN8sRAqZAAJ4wiZz+Aut8ttKS1YywHSocRy4JDgCgq2an
6Pm6QGySdoxz1b6uXaiiyZM=
=xdx0
-----END PGP SIGNATURE-----

--aIbcA3MSwnGacr4f--
