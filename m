Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF114F8C
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1qRaUmn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B8C2C433CB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894724;
	bh=xhdYode+uIttNzAY2HVp6URBTgS78aWb5o4pdi3yreY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S1qRaUmn44APwRzpfrmkUzDKwtloSruek7UnXlW0Ils5OIWtu5+giJFFjvGVOdYBv
	 iMt6HycTfvOK29Z1kkKkIZC7kMthgVAlIu6GXv/kIka9Tp+FSRn5eCZ9GdCLvczBAY
	 m3oFQOlrXsNLVUXmcaDIuB7vBU8jo+fAvOMp+qmE7egHsO0U3B9+qSgYutbmgdYHId
	 ujaSo/FVEnnZKUSDv5wFLy878F3iFhoEL/e/lT09yrne5izlaa/9sAIhkE2x/PqA3J
	 yQLrQItyedF/uwL0gd2fGxTJL0yeOWLN9Oy6PxkAfxjpSE4mm8A5O3UZtXhxM9sxGG
	 h+qb6pj/Dbjcg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 05E02C53BCD; Mon, 18 Dec 2023 10:18:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:18:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-72JcrIjRZb@https.bugzilla.kernel.org/>
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

--- Comment #19 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Hallo Niklas,

thanks for getting back to me on that.

> Please consider writing to the libata mailing list instead of using
> bugzilla, I'm quite sure that you will get more eyes on your problem
> that way.

Could point me to that mailing list please. I can't seem to find it. Do you
want me to repost the issue there or is it okay to just copy & past the
messages from this bug?


> It appears that you have built your kernel with:
> CONFIG_SATA_MOBILE_LPM_POLICY=3D0


Definately not! I've attached my kernel config. LPM policy is definately se=
t tp
"3" CONFIG_SATA_MOBILE_LPM_POLICY=3D3. Thats puzzles me because after booti=
ng the=20
link_power_management_policy is set to performance. Somehow the kernel
overrides the config or uses parameters suggested by the BIOS I don't know.
I've also tried to to switch the ASPM polity to Powersave instead of BIOS
default. Didn't help.

> In your v6.7-rcX dmesg, we don't see any:
> "port does not support device sleep" or
> "setting devsleep to %d" (from my debug patch)
> prints in your dmesg from v6.7-rcX, so set_lpm() is never called at all,
> most likely because you have built with CONFIG_SATA_MOBILE_LPM_POLICY=3D0,
> so DevSleep could be enabled if platform firmware enabled it.

The print is not called, right but not because of
CONFIG_SATA_MOBILE_LPM_POLICY=3D0 since It is set to "3". However when I fo=
rce=20
link_power_management_policy to "echo med_power_with_dipm" the message appe=
ars
in dmesg:

[    9.434663] ahci 0000:00:17.0: setting devsleep to: 0 port support 0
[    9.434668] ahci 0000:00:17.0: port does not support device sleep
[    9.434674] ahci 0000:00:17.0: setting devsleep to: 0 port support 0
[    9.434678] ahci 0000:00:17.0: port does not support device sleep

so somehow the LPM Policy is either not set or reset by the kernel I assume.

> However, the fact that you see "port does not support device sleep"
> suggests that you either built your kernel with
> CONFIG_SATA_MOBILE_LPM_POLICY set to something other than 0,
> or you have manually overriden the policy via sysfs.
>=20
> Note that since your platform firmware claims that the port does
> not support DevSleep (PxDEVSLP.DSP is set to 0), this means that
> ahci_set_aggressive_devslp() will return early:
> https://github.com/torvalds/linux/blob/v6.6/drivers/ata/libahci.c#L2258-L=
2262
> So it will neither enable nor disable DevSleep in the device,
> so DevSleep could be enabled if platform firmware enabled it.
>=20
>=20
> In both of your cases, it looks like you should have DevSleep set
> to whatever platform firmware has set it to.
> But you say that, for these logs, v6.6 can enter low CPU power states,
> but v6.7-rcX can not?

Not quite. In 6.6 the PC8 transition worked only when forcing
link_power_management_policy to "echo med_power_with_dipm". The policy was
still performance after bootup like it is in 6.7-rc. The only difference I =
see
is that after resume my laptop won't enter PC8 again. For 6.7-rc I have to =
call
hdparm -Y for sda and sdb after resume to enable the transition.=20


> You can run:
> hdparm -I /dev/<your_device>
> to see if DEVSLP is enabled in your device (hdparm prints a * in front
> of the feature if the feature is enabled).

Attached to this bug for both (identical) drives.

> It could also be worth checking your BIOS, I've seen some cases where you=
 had
> to enable aggressive devsleep in BIOS for it to get enabled for the port.

My Laptop BIOS (INSYDE) does not offer any knobs to tune dleep for any ATA =
or
PCI devices. Only thing I have set is the powersave profile.

> The sysfs reporting for LPM is really broken in libata...
>=20
> $ git grep max_performance drivers/ata/libata-sata.c
> drivers/ata/libata-sata.c:      [ATA_LPM_UNKNOWN]               =3D
> "max_performance",
> drivers/ata/libata-sata.c:      [ATA_LPM_MAX_POWER]             =3D
> "max_performance",
>=20
> So it reports "max_performance" both for LPM_POLICY =3D=3D 0 (ATA_LPM_UNK=
NOWN)
> and LPM_POLICY =3D=3D 1 (ATA_LPM_MAX_POWER).
>=20
> In your case, it is because of ATA_LPM_UNKNOWN, which means use whatever
> platform firmware has configured.

Thats confusing :(

> ahci_update_initial_lpm_policy() will only override your policy if your
> LPM_POLICY >=3D 3, so it will not override it for your case.

> > I understand however I do not know of any other way to enable lower pac=
kage
> > states on my machine.
>=20
> I do not understand why that helps you.

Me neither but it works. :(

> If you set:
> ATA_LPM_MED_POWER_WITH_DIPM (LPM_POLICY=3D3) on v6.6 in sysfs,
> you can enter low CPU power states?

> If you set=20
> CONFIG_SATA_MOBILE_LPM_POLICY=3D3 on v6.6,
> can you enter low CPU power states?

As described above I'm doing this for years during bootup otherwise I'm stu=
ck
at PC2.

>=20
> Looking at AHCI 1.3.1
> PM:Aggr:
>=20
> State PM:DevSleep is gated with:
>=20
> PxDEVSLP.ADSE =3D =E2=80=981=E2=80=99 and CAP2.SDS =3D =E2=80=981=E2=80=
=99 and CAP2.SADM
> =3D =E2=80=981=E2=80=99 and PxDEVSLP.DSP =3D 1=E2=80=99 and PxSCTL.IPM !=
=3D =E2=80=984h=E2=80=99 and
> PxSCTL.IPM !=3D =E2=80=985h=E2=80=99 and PxSCTL.IPM !=3D =E2=80=986h=E2=
=80=99 and PxSCTL.IPM
> !=3D =E2=80=987h=E2=80=99 and CAP2.DESO =3D =E2=80=980=E2=80=99 and pDito=
Timeout =3D =E2=80=981=E2=80=99
>=20
> So AFAICT, ALPM by the HBA should never be able to transition
> to DevSleep if PxDSP.DSP =3D=3D 0.
>=20
> Perhaps your platform actually does NOT support devsleep and
> simply requires the device to enter slumber or partial in order
> to enter the lower CPU power states?

How can I tell?

> We could test this by you disabling devslp on the device via hdparm,
> and see if you can still enter the lower CPU power states.

Okay and how do I so that?

Kind regards,
Dieter

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
