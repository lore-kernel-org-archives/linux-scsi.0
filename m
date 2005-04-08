From: Christophe Saout <christophe@saout.de>
Subject: flush barriers and SCSI/3w-xxxx with latest 2.6 kernels
Date: Fri, 08 Apr 2005 20:20:15 +0200
Message-ID: <1112984415.2325.10.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FiGHs5SaeKwM/Zca+DFN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from websrv2.werbeagentur-aufwind.de ([213.239.197.240]:50387 "EHLO
	websrv2.werbeagentur-aufwind.de") by vger.kernel.org with ESMTP
	id S262897AbVDHSU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 14:20:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@suse.de>, linuxraid@amcc.com


--=-FiGHs5SaeKwM/Zca+DFN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just enabling flush barriers on machine using a 3ware controller
(by adding barrier=3Dflush to the filesystem options) since this is
working wonderfully here at home.

But when the filesystems are mounted, the filesystems turns them off
because they are unsupported:

Apr  8 19:59:46 websrv2 reiserfs: disabling flush barriers on dm-3

"cat /sys/block/sda/device/queue_type" said "none" instead of ordered.
An "echo 254 > /sys/block/sda/device/queue_length" fixed this, but it
seems that I can't enable this afterwards.

I put back a simple tw_slave_configure method to the 3w-xxxx.c driver
(that calls adjust_queue_depth) and now queue_type shows "ordered" from
the beginning.

But flush barriers are still not working. A quick peek at the code
reveils that scsi_alloc_queue is called before slave_configure.
scsi_alloc_queue calls blk_queue_ordered only there. It's reading
another ordered_tag which is not set.

Why is there an sdev->ordered_tags and another shost->ordered_tag.
Should ordered_tag be set to 1 in driver_template or is this really not
supported?

I am missing something here?


--=-FiGHs5SaeKwM/Zca+DFN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCVstfZCYBcts5dM0RAo1pAJ94in9l59Tlb09QH17v4AWf1ON6kgCgpQP8
9csxZ6cf3poQqjyxFGlIZqA=
=PVDG
-----END PGP SIGNATURE-----

--=-FiGHs5SaeKwM/Zca+DFN--

