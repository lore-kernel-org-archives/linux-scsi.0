Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F336AEA
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qHr3CdgX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C4E1C433C9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702654117;
	bh=xmUdAt+j2fBqEhjFRWkHQ9RDTZ2MHpRKrWRWBLiCcVo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qHr3CdgX/BYfc2tkggMJSpqgmbLqhJ71jpUdZAkax+hGe/c49moeJD8suBTiq3a8O
	 i2igH+deQeA5D7Cc3p+o5ElugSF0ty/B9gfWd73lgY1P7MAAzDmqY7O7vxc70QOtfN
	 3Z8/V7OBaEgTKjUGgUPFImPRR8YtsLngKBmf+a8UJBEYCVKeXCWJr6HlLg+vCxnJpU
	 hAvvGWypof0I3v05c4Tswyf0UTW1gtKbtOabdDfW7LeJtODudQs1bpDFmWhopttO/6
	 VDWASpqiQpp6aSANJPBCCbK8qQbHHbGQ+/BSr8QAw3FqMAF04pBne4jr6IUsf3tK8R
	 scIlEwVWMKNLw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3408BC53BD2; Fri, 15 Dec 2023 15:28:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Fri, 15 Dec 2023 15:28:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: Niklas.Cassel@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-wKz0pVrrj9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218198

--- Comment #18 from Niklas.Cassel@wdc.com ---
Hello Dieter,


I'm really sorry for missing your reply.
The updates from bugzilla were not set to the libata mailing list
(only to the scsi mailing list).

Please consider writing to the libata mailing list instead of using
bugzilla, I'm quite sure that you will get more eyes on your problem
that way.

On Wed, Nov 29, 2023 at 06:10:20PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218198
>=20
> --- Comment #7 from Dieter Mummenschanz (dmummenschanz@web.de) ---
>  (In reply to Niklas.Cassel from comment #6)
>=20
> Hello Niklas,
>=20
> thanks for looking into this.
>=20
> > It would be nice if you could test with latest v6.7-rcX.
>=20
> Okay I took the latest 6.7-rc3 from Linux's git and included your patch.
> Booted
> up my Laptop, put it back to sleep and brought it up again. See attached =
log.
>=20
> I've disabed my link_power_management_policy override so all the time my
> system
> was stuck at pc2 package state according to powertop.
>=20
> > For devsleep to get enabled, you need "sadm sds" in the SATA controller
>=20
> Yep I can see that:
> [    0.379531] ahci 0000:00:17.0: flags: 64bit ncq sntf stag pm clo only =
pio
> slum part ems sxs deso sadm sds apst

Ok, good 1/4.

>=20
> > and "Dev-Sleep" in the SATA device print.
>=20
> I guess this is it?
> [    1.031169] ata5.00: Features: Trust Dev-Sleep NCQ-sndrcv

Yes, good, 2/4.

>=20
> > Additionally, your lpm-policy (lpm-pol) has to be either ATA_LPM_MIN_PO=
WER
> or
> > ATA_LPM_MIN_POWER_WITH_PARTIAL (i.e. lpm-pol has to print either 4 or 5=
).
>=20
> I'm afraid this is not the case here:
> [    0.399005] ata1: SATA max UDMA/133 abar m2048@0x42233000 port 0x42233=
100
> irq 125 lpm-pol 0

It appears that you have built your kernel with:
CONFIG_SATA_MOBILE_LPM_POLICY=3D0

All major distros use:
CONFIG_SATA_MOBILE_LPM_POLICY=3D3

Could you please try with CONFIG_SATA_MOBILE_LPM_POLICY=3D3 ?

If you build with CONFIG_SATA_MOBILE_LPM_POLICY=3D0, then set_lpm() in liba=
ta
will never be called, which means that we will never enable (or disable
devsleep), so you will use whatever your boot firmware has configured.
(And boot firmware might have enabled devsleep in the device.)



In your v6.7-rcX dmesg, we don't see any:
"port does not support device sleep" or
"setting devsleep to %d" (from my debug patch)
prints in your dmesg from v6.7-rcX, so set_lpm() is never called at all,
most likely because you have built with CONFIG_SATA_MOBILE_LPM_POLICY=3D0,
so DevSleep could be enabled if platform firmware enabled it.



In your v6.6 dmesg, we see:
"port does not support device sleep"
(but not "setting devsleep to %d" from my debug patch, so you
probably forgot to apply it to your v6.6 kernel).

However, the fact that you see "port does not support device sleep"
suggests that you either built your kernel with
CONFIG_SATA_MOBILE_LPM_POLICY set to something other than 0,
or you have manually overriden the policy via sysfs.

Note that since your platform firmware claims that the port does
not support DevSleep (PxDEVSLP.DSP is set to 0), this means that
ahci_set_aggressive_devslp() will return early:
https://github.com/torvalds/linux/blob/v6.6/drivers/ata/libahci.c#L2258-L22=
62
So it will neither enable nor disable DevSleep in the device,
so DevSleep could be enabled if platform firmware enabled it.


In both of your cases, it looks like you should have DevSleep set
to whatever platform firmware has set it to.
But you say that, for these logs, v6.6 can enter low CPU power states,
but v6.7-rcX can not?


You can run:
hdparm -I /dev/<your_device>
to see if DEVSLP is enabled in your device (hdparm prints a * in front
of the feature if the feature is enabled).

It could also be worth checking your BIOS, I've seen some cases where you h=
ad
to enable aggressive devsleep in BIOS for it to get enabled for the port.


>=20
> > Note that even if you have LPM_POLICY=3D3 (ATA_LPM_MED_POWER_WITH_DIPM)=
 in
> your
> > Kconfig, ahci_update_initial_lpm_policy() will possibly override this by
> > default
>=20
> That would explain why I'm seeing "max_performance" in
> link_power_management_policy without overriding it.

The sysfs reporting for LPM is really broken in libata...

$ git grep max_performance drivers/ata/libata-sata.c
drivers/ata/libata-sata.c:      [ATA_LPM_UNKNOWN]               =3D
"max_performance",
drivers/ata/libata-sata.c:      [ATA_LPM_MAX_POWER]             =3D
"max_performance",

So it reports "max_performance" both for LPM_POLICY =3D=3D 0 (ATA_LPM_UNKNO=
WN)
and LPM_POLICY =3D=3D 1 (ATA_LPM_MAX_POWER).

In your case, it is because of ATA_LPM_UNKNOWN, which means use whatever
platform firmware has configured.

ahci_update_initial_lpm_policy() will only override your policy if your
LPM_POLICY >=3D 3, so it will not override it for your case.


> > I would really not recommend you doing this, because when you force set
> > lpm policy via sysfs, ahci_update_initial_lpm_policy() is not called,
> > so if your platform requires ATA_LPM_MIN_* to enter lower power states,
> > you forcing lpm-policy to ATA_LPM_MED_POWER_WITH_DIPM will ensure that
> > you never enter lower power states.
>=20
> I understand however I do not know of any other way to enable lower packa=
ge
> states on my machine.

I do not understand why that helps you.

If you set:
ATA_LPM_MED_POWER_WITH_DIPM (LPM_POLICY=3D3) on v6.6 in sysfs,
you can enter low CPU power states?

If you set=20
CONFIG_SATA_MOBILE_LPM_POLICY=3D3 on v6.6,
can you enter low CPU power states?

Looking at AHCI 1.3.1
PM:Aggr:

State PM:DevSleep is gated with:

PxDEVSLP.ADSE =3D =E2=80=981=E2=80=99 and CAP2.SDS =3D =E2=80=981=E2=80=99 =
and CAP2.SADM
=3D =E2=80=981=E2=80=99 and PxDEVSLP.DSP =3D 1=E2=80=99 and PxSCTL.IPM !=3D=
 =E2=80=984h=E2=80=99 and
PxSCTL.IPM !=3D =E2=80=985h=E2=80=99 and PxSCTL.IPM !=3D =E2=80=986h=E2=80=
=99 and PxSCTL.IPM
!=3D =E2=80=987h=E2=80=99 and CAP2.DESO =3D =E2=80=980=E2=80=99 and pDitoTi=
meout =3D =E2=80=981=E2=80=99

So AFAICT, ALPM by the HBA should never be able to transition
to DevSleep if PxDSP.DSP =3D=3D 0.

Perhaps your platform actually does NOT support devsleep and
simply requires the device to enter slumber or partial in order
to enter the lower CPU power states?

We could test this by you disabling devslp on the device via hdparm,
and see if you can still enter the lower CPU power states.


Kind regards,
Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
