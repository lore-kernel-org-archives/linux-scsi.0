Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8B430C617
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 23:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788303652; cv=none; b=kWAAUijgIpRc1JTN1ofdC7Jh+pxnHb/hIFba7pwx+lg2fHVSYG31HOacJI6e1pi37NxyMYPf53QDo69QCwcus8dxOHBrdhwpNIQOmhRXNdqQCxAEBNpIwpfsfJc701aRxIJ2KI7I9YSwMhZc1Cv/0/dG9AoAVglyioM6zB8ryg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788303652; c=relaxed/simple;
	bh=upC9D2XVPdpvneF/ucxlVs4pd/Ku9T9AErXz2nCBWP4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EqOXwQpqMLfR2yIKoaVBSzEds5ouQyAmeJPkYluSiIeSkPSczFs+gxnocS1agX1qYMlDUmbQB1nXLYRb588JZpeHyFZjzpvZnKhrs+wvTKa5kGb393nLfLKlK9gLUs/rELIaEUlztgqFb7BKo46B2a5ECE9xcvpeS4OL/bYcHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=QyVtjJN4; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="QyVtjJN4"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id BD750240103
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 01:00:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1788303640;
	bh=n533z9YPNBc7/1apeLWGiTfcDorGQ40Y0X08///3rFs=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=QyVtjJN4NHDrbGErU7jvT4r1pc8Ij6fFb6AlgtH5ARKXlmBZqMCDUTaGL/cvVzodN
	 KCcAApGyE7J1cVw9UX7gZ2uo7+XU5luIlyuf8/ksUl0OtLplEMc95KpBGYIoB0J2fn
	 3rgkPfV9bWPCWGf1Ww2mwqYfTeZqr1Y01OMxR0lgdmCa/6PzC9YZ/qqiVAgxUjF/b9
	 yylvn4EJ5s4E3oGYK15yz9+7ZIP1v/QlhHlGvEFBWqenI6z+5lgWbRvT8EQU5DsWWo
	 Nt2Y5qGgZKPwLWGn+hhe0WAshsl9IwTyD+FkBPnuQYNRZbpmIoTuJzD9wfffAQi/Qy
	 zYfFHpCcmYV5w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hZLtc0tDNz6tsb;
	Wed,  2 Sep 2026 01:00:40 +0200 (CEST)
Message-ID: <1e8279e68f2b990e6183f5906ab0924739af28b3.camel@posteo.de>
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
From: Markus Probst <markus.probst@posteo.de>
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Tue, 01 Sep 2026 23:00:40 +0000
In-Reply-To: <03a91568-d1a0-4779-a465-2788f4765a42@gmail.com>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
	 <aXctPaaXFYemV20T@ryzen> <03a91568-d1a0-4779-a465-2788f4765a42@gmail.com>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=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
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-vX2SMDVTwD0R68gdcS7x"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt


--=-vX2SMDVTwD0R68gdcS7x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-01-26 at 10:19 -0600, Ian Pilcher wrote:
> On 1/26/26 3:00 AM, Niklas Cassel wrote:
> > But I'm not a fan of making the driver more complex.
> > If we want something more complex than what is already there, then it
> > is probably much better handled in user space, considering the amount
> > of possible configuration options.
> >=20
> > Basically the same argument as used in:
> > https://lore.kernel.org/linux-nvme/20220227234258.24619-1-ematsumiya@su=
se.de/T/#u
>=20
> Niklas -
>=20
> Can you provide some links on how this might be done in userspace?
>=20
> I've been maintaining my out-of-tree block device trigger for years, to
> make the LEDs on my NAS work.
>=20
>   https://github.com/ipilcher/ledtrig-blkdev/blob/v6.9%2B/drivers/leds/tr=
igger/ledtrig-blkdev.c
>=20
> I'd love to be able to replace it with something in-tree.

(I left the mailing lists except dt in Cc, so others with the same
feature requirement can find this mail on the LKML).

Hi Ian,

In the case you are interested, I ended up writing a userspace daemon:
https://codeberg.org/0xIO32/statusd .
Also published as rust crate at https://crates.io/crates/statusd .

It has a bit more functionality, but for simple disk blinking a example
config would be:

```
disks:
    # Any path that is a symlink to a block device works.
    # Any component in the path can be a regex, so any special regex
characters must be escaped.
  - path: '/dev/disk/by-path/pci-0000:02:00\.0-nvme-1'
    present:
      - led: disk1
        priority: 10
        mode: static
        brightness: 255
    io:
      poll_interval: 100ms
      # min_active_time: 300ms
      activity:
        - led: disk1
          priority: 20
          mode: blink
          delay_on: 90
          delay_off: 90
      # read: [] (events in here trigger only with read activity)
      # write: [] (events in here trigger only with write activity)

leds:
  disk1:
    name: multicolor:disk-1
    default:
      priority: 0
      mode: static
      brightness: 0
```
Config path: /etc/statusd.yaml

In this config, the led brightness is 255 if the disk is present, 0
otherwise. If there is read or write activity, it will blink with a
delay of 90 ms (brightness is unset, so it gets inherited from the
lower priority, resulting in 255).
Disk and Led Hotplugging is fine, but `ledtrig-timer` should be loaded
ahead of time or it might cause an error loop (statusd.service takes
care of that).

After the goals in the README are completed, I will try to get it
packaged into the debian repositories.

Thanks
- Markus Probst

--=-vX2SMDVTwD0R68gdcS7x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmqXWRUbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPSBG4QAKTBhRa25zZPtY89PoF0
eEjIXUouD/QxR/7GfmK1f9DvyJgl5GhUp0qgoohnT7Fa3drERe2xCaKnSA9WZHaN
bbeTr5CFJVUjXvMT/vMhTHtO10RYDJ3AVhJJ8APufFuVTmnWp1TnFsoSeipA6pJI
n0mst+13SxC1snq4/HAWBmtScYkY+FLYEjxhR8JtU73lCsTg4gqW/V3vgrGfJXRd
tnONjXbTDanOSmbKA9/5KN8rTAsi0NBnulN7YbnasL/Ai4Pur4wfkCaPLSkGuP7A
CHMb/O19/qR/xqq0gNAfubvkR8JDXt31OE1X1ZWv0TwPTiFVR8yImCu4KBi4WRox
RVKi39nawngseeE5XisFqLsVfEsASA36dbj5ob11VYlf3zupg2Jvxq68Xn6zpARY
CyWBPWWPco4noOgZqnrqHwD+7tEl3e/dvKbb8JfizBJVXJwuFy+rZV7DX/o+SsZY
iNJf2r5g1wkQCnueZ4DINrq9gRCXvydJRmOf90qCCTrboS8rXZr2OZmX5UN/Brjj
CqrwuzPOcWYFB5GMRBIfR1L8TuXpKrWbwf4QgfOAhdri/gIWgsplThrhVKeYfB5P
peO4ppZNnsnUl8qqeSxBfXw5fwii/p0t+PBDfUVm3UWUo4ytflp9EA8gLR4SInyd
jo8bVIBg+gKII/Y0Rx+qKFZe
=Rspn
-----END PGP SIGNATURE-----

--=-vX2SMDVTwD0R68gdcS7x--
