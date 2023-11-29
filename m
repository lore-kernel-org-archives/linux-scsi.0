Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B551BDCF
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp9VyQ42"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADA5BC433C9
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701254575;
	bh=XJ0IfHFmkF4hqv2Mkt2eNxApDelPjwo7HLK8FlvGpv8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Mp9VyQ42dLC0yFd14nHV72pfRxNuxVUgxK9DoY7QYJU0s7X8+E8EtCLQ6iQKxoxxR
	 9e+Aqtx2D2eDiNq0t9IPnxDL2nVclZCu5AZE+NINwXgjtw7E/JeoaAYy13fXjvwEgH
	 90+lV60ki1UPBN1m//o9w7XnucDTcpUGVDCvPdYMOjmJpp4MxWzgKi9Dy4gJdn3Zvs
	 XkaPKD/760AKPQWR0u78q6B0tey5ayyjJsAMqEDF8TSdVW0KU7e/0uDQzKl8pXLOiW
	 etLlMSCBqnWjpzT+nec4PY+qcX7HO2IO+A08bG+Rcl3a8PawaDxlYxp8nd3S9vqqM2
	 imLecp3le2reQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 96472C53BC6; Wed, 29 Nov 2023 10:42:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 29 Nov 2023 10:42:55 +0000
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
Message-ID: <bug-218198-11613-lxqGr67jvB@https.bugzilla.kernel.org/>
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

--- Comment #6 from Niklas.Cassel@wdc.com ---
On Tue, Nov 28, 2023 at 08:24:01AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218198
>=20
> --- Comment #2 from Dieter Mummenschanz (dmummenschanz@web.de) ---
> Thanks for the swift reply.
>=20
> I've applied your patch. Booted up my machine and waited until it transit=
ions
> into lower package states (pc8 at the lowest). After that I closed the la=
ptop
> LID and let the machine suspend to RAM (S3). After that I reopened the LID
> and
> gave the machine 1-3 minutes time to transition to lower package states w=
hich
> it now does.
> I've attached the dmesg part including your patch when the machine enters
> suspend. One thing is odd though:
>=20
> [  109.424369] ata5.00: qc timeout after 5000 msecs (cmd 0xe0)
> [  109.424397] ata5.00: STANDBY IMMEDIATE failed (err_mask=3D0x4)
>=20
> this shouldn't be there, right?
>

Hello Dieter,


I took a look at your logs, but they are very stripped.

It would be nice if you could test with latest v6.7-rcX.

And then provide these messages at boot:

[   50.101909] ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo only pio
slum part ems deso sadm sds apst=20
[   50.375109] ata10: SATA max UDMA/133 abar m524288@0xa5700000 port 0xa570=
0480
irq 270 lpm-pol 4
[   50.783496] ata10.00: Features: Dev-Sleep NCQ-sndrcv NCQ-prio


Because, for devsleep to be enabled, you need support in:
1) The SATA device
2) The SATA controller
3) The SATA port (even if the controller supports devsleep,
                  not all SATA ports have to support it)



For devsleep to get enabled, you need "sadm sds" in the SATA controller pri=
nt,
and "Dev-Sleep" in the SATA device print.
Unfortunately, there does not seem to be a print for the port.

Additionally, your lpm-policy (lpm-pol) has to be either ATA_LPM_MIN_POWER =
or
ATA_LPM_MIN_POWER_WITH_PARTIAL (i.e. lpm-pol has to print either 4 or 5).


> Regarding automatic transitioning I'm not sure how this works. However ev=
en
> though I've set CONFIG_SATA_MOBILE_LPM_POLICY=3D3 in the kernel config, I=
 have
> to
> call an init script explicitly forcing the scsi host to use low power when
> idle:

Note that even if you have LPM_POLICY=3D3 (ATA_LPM_MED_POWER_WITH_DIPM) in =
your
Kconfig, ahci_update_initial_lpm_policy() will possibly override this by
default
to either ATA_LPM_MIN_POWER_WITH_PARTIAL or ATA_LPM_MIN_POWER, see:
https://github.com/torvalds/linux/blob/master/drivers/ata/ahci.c#L1639

The best way is to show the:
[   50.375109] ata10: SATA max UDMA/133 abar m524288@0xa5700000 port 0xa570=
0480
irq 270 lpm-pol 4
print as this is printed after ahci_update_initial_lpm_policy().

The reason why many platforms do this override, is because:
"One of the requirement for modern x86 system to enter lowest power mode
(SLP_S0) is SATA IP block to be off. This is true even during when
platform is suspended to idle and not only in opportunistic (runtime)
suspend."

"SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
user has to either use scsi-host sysfs or tools like powertop to set
the sata-host link_power_management_policy to min_power."

See:
https://github.com/torvalds/linux/commit/b1a9585cc396cac5a9e5a09b2721f3b856=
8e62d0


>=20
> for foo in /sys/class/scsi_host/host*/link_power_management_policy;
>   do echo med_power_with_dipm > $foo;
> done

I would really not recommend you doing this, because when you force set
lpm policy via sysfs, ahci_update_initial_lpm_policy() is not called,
so if your platform requires ATA_LPM_MIN_* to enter lower power states,
you forcing lpm-policy to ATA_LPM_MED_POWER_WITH_DIPM will ensure that
you never enter lower power states.


Looking at your logs, we see:
[ 2022.700556] ahci 0000:00:17.0: port does not support device sleep

Which comes from:
https://github.com/torvalds/linux/blob/master/drivers/ata/libahci.c#L2260

So it appears that your port does not support devsleep...

PxDEVSLP.DSP (in AHCI specification) is the bit that determines if devsleep
is supported for a specific port. This bit is initialized by BIOS.

So this could be a BIOS bug...
But you said that it works if you revert Damien's patch...



So the question is, is PxDEVSLP.DSP always 0?
(Even on the first boot, before you have done any suspend/resume).
If so, it could be a BIOS bug...

Perhaps you could test this patch:

And show us all the prints, and tell us which prints are before/after
the suspend/resume.

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2255,6 +2255,9 @@ static void ahci_set_aggressive_devslp(struct ata_port
*ap, bool sleep)
        int rc;
        unsigned int err_mask;

+       dev_info(ap->host->dev, "setting devsleep to: %d port support %d\n",
+                sleep, readl(port_mmio + PORT_DEVSLP));
+
        devslp =3D readl(port_mmio + PORT_DEVSLP);
        if (!(devslp & PORT_DEVSLP_DSP)) {
                dev_info(ap->host->dev, "port does not support device
sleep\n");



You mentioned that it works when you revert Damien's patch.
It could be interesting to see these prints, before/after the
suspend/resume both with and without the revert.

I would expect us to be able to read PxDEVSLP even when the SATA device
is in suspend state... I could imagine that we could get a bogus value
back from the read if the from the SATA controller itself is in a suspend
state, but I don't see how Damien's patch that you bisected to:
https://github.com/torvalds/linux/commit/fd3a6837d8e18cb7be80dcca1283276290=
336a7a

changed any of that. It does touch ata_pci_shutdown_one(), which should
only get called on shutdown... not suspend/resume AFAICT.

So the fact that this patch changes things for you is weird in the first
place. Damien, is it possible that ata_pci_shutdown_one() is incorrectly
called during suspend/resume? Got any ideas?


Kind regards,
Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
