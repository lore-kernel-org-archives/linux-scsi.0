From: Matthijs Kooijman <matthijs@stdin.nl>
Subject: Potential overflow of sdkp->capacity
Date: Wed, 31 Aug 2011 12:52:15 +0200
Message-ID: <20110831105215.GR10237@login.drsnuggles.stderr.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CyUt1yqRwzqLO9jK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:35301 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1HaLgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2011 07:36:32 -0400
Received: from login.drsnuggles.stderr.nl ([10.42.0.9] ident=mail)
	by mail.drsnuggles.stderr.nl with smtp (Exim 4.69)
	(envelope-from <matthijs@stdin.nl>)
	id 1QyiP1-0007To-Hk
	for linux-scsi@vger.kernel.org; Wed, 31 Aug 2011 12:52:28 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--CyUt1yqRwzqLO9jK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Please CC me, I'm not on the list)

Hi folks,

while tracing a problem in an old kernel version regarding a big (3TB)
disk, I suspect I found a potential overflow of the sdkp->capacity
variable when disks with > 512 byte sectors are involved and support for
large block devices is turned off.

I haven't tested this on recent krenel versions, but from looking at the
code in 3.1-rc4, it seems the overflow is still present.

In sd_read_capacity(), the capacity is read from the disk, in sectors.
This is done by  read_capacity_16() or read_capacity_10. Both of these
functions check sizeof(sdkp->capacity) to see if the capacity would fit:

1789         if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
1790                 sd_printk(KERN_ERR, sdkp, "Too big for this kernel.  Use a "
1791                         "kernel compiled with support for large block "
1792                         "devices.\n");
1793                 sdkp->capacity = 0;
1794                 return -EOVERFLOW;
1795         }

Now, at the end of sd_read_capacity, the sdkp->capacity variable is
normalized to 512-byte sectors:

1926         /* Rescale capacity to 512-byte units */
1927         if (sector_size == 4096)
1928                 sdkp->capacity <<= 3;
1929         else if (sector_size == 2048)
1930                 sdkp->capacity <<= 2;
1931         else if (sector_size == 1024)
1932                 sdkp->capacity <<= 1;
1933         else if (sector_size == 256)
1934                 sdkp->capacity >>= 1;


At this rescaling, no check for the size of capacity is done.

My particular case was a 3TB disk, with 732558336 (0x2ba9f400) sectors,
each 4096 bytes big. The 732558336 fits within a 32-bit word, so no
error is produced. Then, the capacity is corrected with by shifting it
three bits, producing 5860466688 (0x15d4fa000), which is one bit too
long to fit into sdkp->capacity, making the capacity incorrect (which in
my 2.6.26 kernel produces "access beyond end of device" errors).

It seems an extra check before scaling the capacity, or when loading the
capacity, is appropriate. I'm not well-versed enough in kernel coding to
provide a proper patch, but I suspect somebody can pick this up from
here.

Gr.

Matthijs

--CyUt1yqRwzqLO9jK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk5eEl8ACgkQz0nQ5oovr7wL5QCdFC9qS64CRGp9NL99hUy6vrkL
od4AoJ32npnLlFI6sDuR4Fn5QYDV8l0l
=sGHB
-----END PGP SIGNATURE-----

--CyUt1yqRwzqLO9jK--
