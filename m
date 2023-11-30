Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26671F61A
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djiE3xku"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CF8BC433C8
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2023 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701334152;
	bh=dsOCANZr1rDY6GZxnYZMVCq24EeUHLAAcWkqn80b0Fk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=djiE3xkuCd2vXJZvqxSG/aRxR3ioRZtbCCWGpQNPPXZaBMElDnHvfvI9kg0I8Hxuo
	 OHImdPlPFD+AMfjKTCbrRijy3oQU8MS1UTBEqIHyDgRWO1s3QzaWNpt75MUx+Zb9Ab
	 x1PBURYJ5Xne6m+Dc8zLWww4ZmwdthRv5hanUXJU9FwrWBaQsk/oYHOMIZbisPtJM1
	 JiUZAPdgNY+4fTSUBCS56C9KI0xACO3wYQLagKGrfioejMXX11tTY+O3UoynJwsrkr
	 89NpU8s8mnNrrGHN8RuH2obppuujBcNugWyXalZskBMMGyd0p8+hqcN2hLCT4Zz3+7
	 czIBfdwKUX5nQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 46DFDC53BD2; Thu, 30 Nov 2023 08:49:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Thu, 30 Nov 2023 08:49:12 +0000
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
Message-ID: <bug-218198-11613-IZUsDxnbCF@https.bugzilla.kernel.org/>
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

--- Comment #11 from Niklas.Cassel@wdc.com ---
On Wed, Nov 29, 2023 at 01:47:16PM -0500, Phillip Susi wrote:
> Niklas Cassel <Niklas.Cassel@wdc.com> writes:
>=20
> > The reason why many platforms do this override, is because:
> > "One of the requirement for modern x86 system to enter lowest power mode
> > (SLP_S0) is SATA IP block to be off. This is true even during when
> > platform is suspended to idle and not only in opportunistic (runtime)
> > suspend."
> >
> > "SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
> > user has to either use scsi-host sysfs or tools like powertop to set
> > the sata-host link_power_management_policy to min_power."

Note that I copied this text from the original patch authored by someone
at Intel.

I've seen similar claims from people at AMD.


>=20
> What?  I'm confused.  Here are several things that come to mind that
> when taken together with this statement confuse me.  Perhaps I am wrong
> about one or more of them?
>=20
> 1)  DEVSLP is an odd thing they invented to have ACPI twiggle a GPIO bit
> to cut the power rails to CDROM drives that aren't in active use.
>=20
> 2)  SATA ALPM has the SATA controller automatically transition the sata
> link to lower power states when it isn't being used, and back again on
> use.

Yes, the HBA can initiate a transition to DevSleep automatically using ALPM,
however, the specs says that:
-DevSleep is disabled by the device on power up (and has to be enabled by a
SET FEATURES command).
-PxDEVSLP.ADSE (Aggressive Device Sleep Enable) for the port is 0 on reset
(the kernel resets the HBA on boot, so ADSE will be disabled for the port).

(DevSleep is never initiated by the device.)

The kernel will only do:
-SET FEATURES to enable the DevSleep feature on the device, and
-Set PxDEVSLP.ADSE to 1

If _all_ of the following are true:
1) SADM and SDS bits are set in the HBA
2) the device reports that it supports DevSleep
3) PxDEVSLP.DSP is set for the port
4) the kernel LPM policy is either ATA_LPM_MIN_POWER or
   ATA_LPM_MIN_POWER_WITH_PARTIAL

See:
https://github.com/torvalds/linux/blob/v6.7-rc3/drivers/ata/libahci.c#L2322=
-L2324


This means that if any of 1-5 it not true, the HBA ALPM will never transiti=
on
the device into DevSleep state.

AFAICT, the HBA asserts the DEVSLP signal as long as being in DevSleep stat=
e.

To exit from DevSleep state you can just issue an I/O like normal using PxC=
I,
or write to PxCMD.ICC to force a state change.


> 3)  The SATA controller can not be suspended until all of its ports are
> suspended.
>=20
> 4)  Suspending a SATA port does not happen during ALPM, but rather only
> either during system suspend, or when you enable runtime pm on the disk
> and the ata port in sysfs ( both are disabled by default ).
>=20
> A quick google led me to this: https://smarthdd.com/device_sleep.htm
>=20
> Which indicates that this DEVSLP thing is now being used to send an OOB
> signal to a SATA SSD so that it can power down its PHY completely, but
> isn't that what ATA SLEEP is for?  aka. hdparm -Y.  That command tells
> the drive that it can power down its PHY and then the host can power
> down its PHY and it takes a sata link reset to wake the drive back up.
> The link reset is easy to detect with minimum circuitry that is far
> simpler than the full sata PHY.
>=20
> It sounds like somebody decided to hack an OOB signal into ALPM rather
> than use ATA SLEEP, but why?

I guess you need to ask Intel.

I assume that their firmware simply requires the DEVSLP signal to be
asserted in order to enter lower CPU power states.

If you have a signal, it is easy for the HW logic to detect if the signal
is set or not.

If you just send a command to the device, if it not easy for HW logic
to determine which state is in. It would need to read some registers
or similar. Sounds way more complex than just having a logic gate.


Kind regards,
Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
