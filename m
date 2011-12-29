From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v2 27/28] libsas: fix sas_find_local_phy(), take phy references
Date: Thu, 29 Dec 2011 14:18:59 +0800
Message-ID: <B0C89E887B4642239ECCC0B2A7F4E52A@usish.com.cn>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6><20111223030049.21827.90091.stgit@localhost6.localdomain6><47F78521CCB14D959AB0CD172E61E0C7@usish.com.cn> <CAA9_cmfmBK2cYWpSO8aQiiwXpLmX9r0u8=BJVh3Q-kZVhpzrZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfmBK2cYWpSO8aQiiwXpLmX9r0u8=BJVh3Q-kZVhpzrZg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, 'Xiangliang Yu' <yuxiangl@marvell.com>, linux-ide@vger.kernel.org, 'Luben Tuikov' <ltuikov@yahoo.com>
List-Id: linux-scsi@vger.kernel.org

>=20
> On Tue, Dec 27, 2011 at 1:21 AM, Jack Wang <jack_wang@usish.com> wrot=
e:
> >>
> >> In the direct-attached case this routine returns the phy on which =
this
> >> device was first discovered. =A0Which is broken if we want to supp=
ort
> >> wide-targets, as this phy reference can become stale even though t=
he
> >> port is still active.
> >>
> >> In the expander-attached case this routine tries to lookup the phy=
 by
> >> scanning the attached sas addresses of the parent expander, and BU=
G_ONs
> >> if it can't find it. =A0However since eh and the libsas workqueue =
run
> >> independently we can still be attempting device recovery via eh af=
ter
> >> libsas has recorded the device as detached. =A0This is even easier=
 to hit
> >> now that eh is blocked while device domain rediscovery takes place=
, and
> >> that libata is fed more timed out commands increasing the chances =
that
> >> it will try to recover the ata device.
> >>
> >> Arrange for dev->phy to always point to a last known good phy, it =
may
be
> >> stale after the port is torn down, but it will catch up for wide p=
ort
> >> reconfigurations, and never be NULL.
> >>
> >> Q: How is pm8001_I_T_nexus_reset getting away with not performing =
reset
> >> =A0 =A0on direct attached sata devices?
> >>
> > [Jack Wang]
> > We found reset may lead to some SATA disks can not be found sometim=
e, in
> > fact no only for direct attached sata devices.
> >
> > I wonder why we always reset the sata device when probe, for pm8001
direct
> > attached sata firmware will report Initial SATA FIS when phy ready.
> >
>=20
> We need to get the drive to a known state.  Do these problems still
> happen in your tests with the "wait for ready" checking?  That's
> supposed to allow enough time for the signature fis to be transmitted=
=2E
>=20
> I'll take a closer look at your libsas fix, because I believe we are
> still seeing failures to rediscover all attached devices even with
> these patches.
>=20
> --
> Dan
[Jack Wang]=20
I only test sata behind expander, will add lldd_ata_check_ready to have=
 a
test later.



