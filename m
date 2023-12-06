Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E39E11717
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 06:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USpUEEwb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0CD1C433C8
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 06:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701845467;
	bh=UR7p/EAxQ+TDrXPl80i00N2pbtQNdBmGN2vE/4tSVIQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=USpUEEwbH8l+8Mvs65BH4L9XVRa6IusTXKfTJqTOuTPezH/XrXRcnBplfYXOk2ddR
	 YfOWyPW93y6StaHDcGyS8vvi4PJoh+tIiS7M1mq1clfwFKv8v1+R99HMg276/mQAuS
	 13/VGSBB+n624OwREupsyi9UiIpZuJ9xK3sXxSrgR3yNM2m+U9w6/EivfJh8wydbLB
	 qqNCYcvm6icSB8NLlaaIbuHaNxGa265s8OukWIsLzYROHmjLtmOl25/e3KZUqDrcEw
	 C4CdXuo4er2eYFkNYQ28JYpe0bTtx7VGs1qnlyUVI8QX7eNN+0oJ48QfVQgYaw8rAq
	 t6KT90sTMkgeQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D5BDBC53BD0; Wed,  6 Dec 2023 06:51:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 06 Dec 2023 06:51:06 +0000
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
Message-ID: <bug-218198-11613-PhU47dJ3D8@https.bugzilla.kernel.org/>
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

--- Comment #15 from Dieter Mummenschanz (dmummenschanz@web.de) ---
(In reply to Phillip Susi from comment #14)
> bugzilla-daemon@kernel.org writes:
>=20
>=20
> 2)  A mounted filesystem periodically issues a FLUSH CACHE command, even
> if nothing has been written.  A drive in STANDBY just ignores it but in
> SLEEP, it wakes up.
>=20
> I would imagine at once you access the disk in some way and so it wakes
> up, you won't get back to pc8 again without another hdparm -Y?  Is that
> correct?

No or at least I don't see this behaviour. However the drives occasional se=
em
to have some trouble waking up after resume and hdparm -Y:

[59984.831894] ata5.00: exception Emask 0x0 SAct 0x2000000 SErr 0x10000 act=
ion
0x6
[59984.831907] ata5.00: waking up from sleep
[59984.831914] ata5: hard resetting link
[59985.145261] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[59985.148840] ata5.00: supports DRM functions and may not be fully accessi=
ble
[59985.153322] ata5.00: supports DRM functions and may not be fully accessi=
ble
[59985.156822] ata5.00: configured for UDMA/133
[59985.166903] ahci 0000:00:17.0: port does not support device sleep
[59985.167045] ata5: EH complete
[59985.167268] ata5.00: Enabling discard_zeroes_data

When that happens the system is stuck in pc2/pc3 for a couple of minutes but
then transitions back in partial to pc8.

Regarding your patches: Anything I can test for you? :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
