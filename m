From: Ben Collins <bcollins@ubuntu.com>
Subject: Re: [scsi:pending 3/3] drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type
Date: Wed, 20 Jun 2012 12:44:56 -0500
Message-ID: <9F0D52A8-D4E0-40C9-8619-6802A1378C16@ubuntu.com>
References: <20120620171239.GB5512@localhost>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: multipart/signed; boundary="Apple-Mail=_B023C285-DD0D-41C8-80FC-D2C034629D03"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47742 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2FTRpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2012 13:45:03 -0400
Received: by gglu4 with SMTP id u4so5888222ggl.19
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jun 2012 10:45:01 -0700 (PDT)
In-Reply-To: <20120620171239.GB5512@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wfg@linux.intel.com
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org


--Apple-Mail=_B023C285-DD0D-41C8-80FC-D2C034629D03
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2012, at 12:12 PM, wfg@linux.intel.com wrote:

> Hi Ben,
>=20
> There are new compile warnings show up in
>=20
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git =
pending
> head:   e766db42f45c7685fce5c0d48ba74eaa97e6d715
> commit: e766db42f45c7685fce5c0d48ba74eaa97e6d715 [3/3] [SCSI] aacraid: =
Fix endian issues in core and SRC portions of driver
>=20
> All warnings:
>=20
> drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
> drivers/scsi/aacraid/src.c:425:2: warning: right shift count >=3D =
width of type [enabled by default]

Hrmm, pretty innocuous, but I guess it could be rewritten as:

#if BITS_PER_LONG > 32
        src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
#else
        src_writel(dev, MUnit.IQ_H, 0);
#endif

I'm assuming the compiler can optimize line 426 to skip the masking in =
such a case.

> drivers/scsi/aacraid/src.c:425:
>   422		if (address & (ALIGN32 - 1))
>   423			return -EINVAL;
>   424		address |=3D fibsize;
>> 425		src_writel(dev, MUnit.IQ_H, (address >> 32) & =
0xffffffff);
>   426		src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
>   427=09
>   428		return 0;
>=20
> ---
> 0-DAY kernel build testing backend         Open Source Technology =
Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel =
Corporation
> =
<0001-SCSI-aacraid-Fix-endian-issues-in-core-and-SRC-porti.patch><src.c>

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/


--Apple-Mail=_B023C285-DD0D-41C8-80FC-D2C034629D03
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iEYEARECAAYFAk/iDBoACgkQbVJJsWDoC1uMCwCfWuI/gHk5QvzyBcpMMuddaDn8
SiAAn0fB2ktKPwqFkMO6sVO3h09/utGp
=uuAk
-----END PGP SIGNATURE-----

--Apple-Mail=_B023C285-DD0D-41C8-80FC-D2C034629D03--
