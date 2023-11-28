Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770D312E42
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzZUrZvo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2B4CC433CA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701157671;
	bh=CFxs60hl7Kwz2jpUde+Ej7vbxvGYWYeT2pqEpRzmPds=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JzZUrZvoFQOk01MG8AtBwXoiFu5DX8k3woUu054DCAkWs0OPM6sBxhUuHXE2ysnAd
	 6cXHWl0NQnwMFZVyDCpQlDSHFJJE589rSYVAlXO0ikvPlunMUvvL4Qa/cHIJWyqCHT
	 LRZegB39HucgZ2vpEf6vU+m62mW6J7Zok9QoVtvZk9dF34rjyAK22t9xxvadUOO8mj
	 jq+F8x0eKORLZgpEOCUSsXlV19SVvGWBc91rGAo7PcTLkJFlvo85R40PrZoxl0ZNAR
	 DK3fo4gNGLV/pFUbYxhTiPQMkPXtUEpVFV7EYxw0DCDZ5bsupCS64aFuw4zPqpfwYD
	 S+HMQZWM3GR0g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D82EEC53BD1; Tue, 28 Nov 2023 07:47:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 07:47:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dlemoal@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-j4SDRiRHSX@https.bugzilla.kernel.org/>
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

--- Comment #1 from dlemoal@kernel.org ---
On 11/28/23 16:06, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218198
>=20
>             Bug ID: 218198
>            Summary: Suspend/Resume Regression with attached ATA devices
>            Product: SCSI Drivers
>            Version: 2.5
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: dmummenschanz@web.de
>         Regression: No
>=20
> Hello,
>=20
> the following commit from Kernel 6.7-rc1:
>=20
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/d=
rivers/ata/libata-core.c?id=3Dd035e4eb38b3ea5ae9ead342f888fd3c394b0fe0
>=20
> introduced a regression on my system where after successful resuming the =
CPU
> won't enter lower Package Sates below pc2 even after letting it sit for 1=
5+
> minutes. Reverting this commit fixed the issue on my system with two ata
> drives. Anyone experiencing the same issue?=20
>=20
> I'm happy to try any troubleshooting steps or provide more details if nee=
ded.

Could you try adding this:

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 09ed67772fae..8d4871fff099 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6185,6 +6185,9 @@ void ata_pci_shutdown_one(struct pci_dev *pdev)
        for (i =3D 0; i < host->n_ports; i++) {
                struct ata_port *ap =3D host->ports[i];

+               /* Wait for EH to complete before freezing the port */
+               ata_port_wait_eh(ap);
+
                ap->pflags |=3D ATA_PFLAG_FROZEN;

                /* Disable port interrupts */

and see if this changes anything ? Beside that, I am at a loss seeing what =
is
going on. The commit you mention essentially reverted an earlier change tha=
t is
not necessary, bringing back ata_pci_shutdown_one() to the how it was for
ages...

When you say "successful resuming", what exactly are you talking about ? Sy=
stem
resume from suspend-to-ram ? from hibernation (suspend to disk) ?

I can always revert this revert, but I would rather understand why that is
needed. Do you see any suspicious libata EH activity in dmesg ?

Also, are the lower Package Sates transitions automatic or driven by the ke=
rnel
PM core ? I do not know that. If it is the latter, does the pc2 state also
include adapters ? Isn't it limited to the CPU power state ? I ask because =
if
it
is and libata EH is in a bad loop constantly running after resume, that wou=
ld
explain why you cannot reach a lower CPU power state.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
