From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#733565: SIX messages per on boot console should be TWO
Date: Mon, 30 Dec 2013 04:14:41 +0100
Message-ID: <1388373281.2900.42.camel@deadeye.wl.decadent.org.uk>
References: <87vby7l08j.fsf@jidanni.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DTxWV1mfUcCDJ6l2OlJd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58747 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab3L3DOx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Dec 2013 22:14:53 -0500
In-Reply-To: <87vby7l08j.fsf@jidanni.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidanni@jidanni.org
Cc: 733565@bugs.debian.org, linux-scsi <linux-scsi@vger.kernel.org>


--=-DTxWV1mfUcCDJ6l2OlJd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Control: reassign -1 src:linux 3.12.6-1

On Mon, 2013-12-30 at 07:13 +0800, jidanni@jidanni.org wrote:
> Package: linux-image-3.12-1-686-pae
>=20
> Currently any such devices as below that are attached during boot still
> produce the below SIX messages per device when they should only produce
> TWO:
>=20
> # dmesg |egrep Caching\|Assuming
> [    3.960663] sd 3:0:0:0: [sdb] No Caching mode page found
> [    3.960701] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [    3.978659] sd 3:0:0:0: [sdb] No Caching mode page found
> [    3.978694] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [    3.998652] sd 3:0:0:0: [sdb] No Caching mode page found
> [    3.998689] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [    4.174630] sd 2:0:0:2: [sde] No Caching mode page found
> [    4.174669] sd 2:0:0:2: [sde] Assuming drive cache: write through
> [    4.196628] sd 2:0:0:2: [sde] No Caching mode page found
> [    4.196664] sd 2:0:0:2: [sde] Assuming drive cache: write through
> [    4.220624] sd 2:0:0:2: [sde] No Caching mode page found
> [    4.220661] sd 2:0:0:2: [sde] Assuming drive cache: write through
>=20
> Please confirm that you also see the six messages right there on the
> console stderr.

I'm not seeing it at all here as my SSD apparently does implement the
caching mode page.

I can see that it is emitted by sd_read_cache_type(), which is called by
sd_revalidate_disk(), and that is apparently now called 3 times during
probe.  Which is quite ridiculous.

And I wonder whether this situation (no caching mode page) is really
serious enough to deserve logging at ERR severity?

Ben.

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-DTxWV1mfUcCDJ6l2OlJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUsDlIee/yOyVhhEJAQqDcRAAjYjdEyiewrc2jj9gmj/ALewavF92TGrM
XOHaKQN+vSTfpniLyWMwJFPxsk2dZLSC358N7PD/xiZ2clqbmNSM3i/tYyny/ewz
WvHK+9M7RUO2QyKbJ+q1XrtYFDAygLFeXN2KAXoPoj5zQFtClZ93GFlIBmntCmZ2
y1wnH4wuZEDYSx/DBe9wJobjmbl5p21rzcLPGc5ow0ydvArpPC6IMb8i1RCd8Bl2
N5RuaFBWJhTw0+sLOxYpzFhOSc39yDlzUhwgFs8+WcH9VBXYiesqgtqBgK0nDOWK
u/6KbGBtdspNfidI9ahuOIv8npeWphyybINN+Da0ATVAHV7eAPhBa5H0LXLkV4cO
UhDjh6MZejKKhmmvQpksoON7ZKWO1461w94rFsiG6Yxe9LGXPdShYq6t+oosj7AA
e8xbOphwtOmHmYoCUBs7acGGpHt0sbIU9EJ2+brmlZr0ouo2G5DOiLhVpH0r9qt+
QGMeUVoTMtYwW8MyR7yioNco88MMn7HS5VmzakB/P0Myew3a7QS+6c445Hpn1qJg
a5UAiO6v5b/OkcXdT9W8UaVvX9MU30s5Dk2Nqgu3AyAEf3rhDzy1kQFAWMdsS5q7
B4nMZrbSLcRQKimcBBf8H9Uk8M5PLVJI70nRGO4HkW2wsMNYlvercXhaA2CiaJLJ
E9hokXxdIJs=
=S14j
-----END PGP SIGNATURE-----

--=-DTxWV1mfUcCDJ6l2OlJd--
