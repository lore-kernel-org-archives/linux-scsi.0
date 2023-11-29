Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10813ADC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fihhhMro"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7941C433C7
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701281420;
	bh=/buDonHeYNudoXJG2oog77ai2lFjhSkrhiftHcgio9k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fihhhMro0LhUyfD+9c+qCmuwQ0KPAGgK6GzBf3mPsVaPf628CuRNFhDqBB1zzm4ry
	 LIDaqX4Mx4GwU9VOEoG7RwGxtHAH/GTbL5oj5b/UrgO673E8bL0lvMC41xQ8HnwGHZ
	 FWP8+ks03iJ4K4d02Vur8Yef1yfRSd/FNKciPZcFmYG0JWHnkrpPcWpSAAu/Ck2vwt
	 1Jm4bszzOtQ3icANM0OAcFhmKVykGlC8b9oQkCvWgDWU7X5xtUWQlW2SAF91wWZyGi
	 AD2L2PcR6UAHLnlRxtMooXGV1Qv0cjZzTvkdHWgxi/EZ7ea5M8etkGHirUzqvE3yRN
	 qCIDRwFEYyklA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C8202C53BCD; Wed, 29 Nov 2023 18:10:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 29 Nov 2023 18:10:20 +0000
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
Message-ID: <bug-218198-11613-r2O2qSYOjG@https.bugzilla.kernel.org/>
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

--- Comment #7 from Dieter Mummenschanz (dmummenschanz@web.de) ---
 (In reply to Niklas.Cassel from comment #6)

Hello Niklas,

thanks for looking into this.

> It would be nice if you could test with latest v6.7-rcX.

Okay I took the latest 6.7-rc3 from Linux's git and included your patch. Bo=
oted
up my Laptop, put it back to sleep and brought it up again. See attached lo=
g.

I've disabed my link_power_management_policy override so all the time my sy=
stem
was stuck at pc2 package state according to powertop.

> For devsleep to get enabled, you need "sadm sds" in the SATA controller

Yep I can see that:
[    0.379531] ahci 0000:00:17.0: flags: 64bit ncq sntf stag pm clo only pio
slum part ems sxs deso sadm sds apst=20

> and "Dev-Sleep" in the SATA device print.

I guess this is it?
[    1.031169] ata5.00: Features: Trust Dev-Sleep NCQ-sndrcv

> Additionally, your lpm-policy (lpm-pol) has to be either ATA_LPM_MIN_POWE=
R or
> ATA_LPM_MIN_POWER_WITH_PARTIAL (i.e. lpm-pol has to print either 4 or 5).

I'm afraid this is not the case here:
[    0.399005] ata1: SATA max UDMA/133 abar m2048@0x42233000 port 0x42233100
irq 125 lpm-pol 0

> Note that even if you have LPM_POLICY=3D3 (ATA_LPM_MED_POWER_WITH_DIPM) i=
n your
> Kconfig, ahci_update_initial_lpm_policy() will possibly override this by
> default

That would explain why I'm seeing "max_performance" in
link_power_management_policy without overriding it.


> The reason why many platforms do this override, is because:
> "One of the requirement for modern x86 system to enter lowest power mode
> (SLP_S0) is SATA IP block to be off. This is true even during when
> platform is suspended to idle and not only in opportunistic (runtime)
> suspend."
>=20
> "SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
> user has to either use scsi-host sysfs or tools like powertop to set
> the sata-host link_power_management_policy to min_power."
>=20
> See:
> https://github.com/torvalds/linux/commit/
> b1a9585cc396cac5a9e5a09b2721f3b8568e62d0

Thanks for the insight.

> I would really not recommend you doing this, because when you force set
> lpm policy via sysfs, ahci_update_initial_lpm_policy() is not called,
> so if your platform requires ATA_LPM_MIN_* to enter lower power states,
> you forcing lpm-policy to ATA_LPM_MED_POWER_WITH_DIPM will ensure that
> you never enter lower power states.

I understand however I do not know of any other way to enable lower package
states on my machine.

> So it appears that your port does not support devsleep...

Anything we can do to preserve the old bwhaviour until 6.6?

> PxDEVSLP.DSP (in AHCI specification) is the bit that determines if devsle=
ep
> is supported for a specific port. This bit is initialized by BIOS.
>=20
> So this could be a BIOS bug...
> But you said that it works if you revert Damien's patch...

Yes, I had no issues up to 6.7-rc1.=20

> Perhaps you could test this patch:

Yweah, see logs.=20=20

> You mentioned that it works when you revert Damien's patch.
> It could be interesting to see these prints, before/after the
> suspend/resume both with and without the revert.

I've attached the dmesg logs from kernel 6.6.


Thanks again for your help
Dieter

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
