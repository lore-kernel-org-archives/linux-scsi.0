From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: st.ko with usb-storage problems
Date: Sun, 14 Sep 2003 17:41:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030914174104.A20722@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:1284 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262143AbTIOAmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Sep 2003 20:42:08 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: USB Developers <linux-usb-devel@lists.sourceforge.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(NOTE: Cross-posted to several lists.  Watch your replies.)

For a while now in 2.5 and 2.6, I've been getting reports of an
incompatibility between st.ko and the usb-storage driver.  I've finally
managed to figure out the problem; it only affects certain hardware, and
only on certain operations.

USB is a packet-oriented protocol.  Important to the protocol is the
concept of a packet being full or not -- in a given transfer, all packets
should be full except the last one.  Since usb-storage maps the SCSI
command's scatter-gather list for direct I/O, each scatter-gather segment
(except for the last one) must be a multiple of the packet size.  That
value can vary, but is always a power of 2 (I've personally seen up to
512 bytes).

When st.ko goes to do a read, it will create a scatter-gather list with
(what looks like) a mapping of the user-space buffer.  This often results
in not-so-nicely sized segments, which are often a multiple of 8, but not
64, 128, or 512 (which are the common USB packet sizes).  This causes a
problem for the USB host-controller hardware, and the transfer fails.

Why this doesn't happen on a write is something of a mystery to me, but it
doesn't seem to happen.

If the module flag 'try_direct_io' is set to 0 (not the default), then
st.ko doesn't generate scatter-gather lists at all, and all is well.

It's not immediately clear to me how to fix this.  First, I need to figure
out why 2.4 kernels don't show this problem, I think.  Help from people who
understand st.ko would be appreciated.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

THEY CASTRATED MY QUAKE BITS! I WANT THEM BACK!!!!
					-- Greg
User Friendly, 3/27/1998

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/ZQqgIjReC7bSPZARApEGAJ93XpxcN59i3VZMOSdR94qw0T/F/gCgx59W
YofEz/Pbg94+POE7za8YlEQ=
=WlgG
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
