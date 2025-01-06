Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2C51DD877
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736171526; cv=none; b=BR6cU/Gz+pWgIwooCsLB9wCpRBp7gsErJs6haLSH2Ej+nv+osFoGgfXxV+fyVuzwdQgSpGJsA4x1hSnxZEBXQYP79UOGUnoO8DeOyJQbSKMAimqXPccoLIUqOBXQhNxAsndBA9FXtFeHrFjwMFq7IiUlhPeB9xa6KO/b69WqZcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736171526; c=relaxed/simple;
	bh=j8BUBv/IuiO1bgUUs8Mkhf9QCaHYc2Wa/BUflCSNpVo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UaTKEI2ciWWbn1+ADVlqHgZscaT168DuBz382MxVnr7nktCkn7pr2J0oscqdL01ZculFtrPpz96R5W4ygqX3r4r1PXELL1UVNmgFrfZpCuTkeXVB8BESP030E80wvVc5shkB0LqLNodbPgUKJaUgzoDqSZ0aSGDbjXwvk2/CUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxieakJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxieakJc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74194C4CEED
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736171526;
	bh=j8BUBv/IuiO1bgUUs8Mkhf9QCaHYc2Wa/BUflCSNpVo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AxieakJcFQkP6nZMd0PyKnDg2zS3fyZCyC8LgSWwgbdl8FEbPY1mocibTTOd3lF4n
	 FYevKvSFXaMjMNOaWco5B6Dj34VrdCwpuaWmHth90Ul3hObzYTpky8BYR83Sp0NiAf
	 SvdtYBYwg4NGynRvNaF04AbpBLzWQ4gdZH3sPr/O7xVJXA54koZB1XYNii9RXXvJ7X
	 M8XMv+AvI04XlQx0CsGhAIrwT83GLv4FuECSYBBTXSv7Jf8jLrnfO7bCXiMgXNDZ5K
	 R9dWGjY5bQSf0cUBoWasHwgVzGLDym4Cqt6a5E5+OrDlE8hZZyoE+wGqIEy5O0Y4/g
	 9TACZBfGRKNxA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6DDB1C3279E; Mon,  6 Jan 2025 13:52:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 06 Jan 2025 13:52:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: wavepacket@outlook.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-JCeggSj9yh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #70 from Steve (wavepacket@outlook.it) ---
(In reply to Sagar from comment #69)
> Hi all,
> Currently the patch which caused the issue has been reverted.
> I have reworked and I have a fix ready for this issue.
>=20
> I am working towards submitting the patch sometime this week.

this is my dmesg log if it can help:

[    0.801036] Adaptec aacraid driver 1.2.1[50983]-custom
[    0.801047] aacraid 0000:03:00.0: can't disable ASPM; OS doesn't have AS=
PM
control
[    0.805979] aacraid: Comm Interface type2 enabled
[    0.839258] scsi host0: aacraid
[    1.933550] scsi 0:3:0:0: Enclosure         NETAPP   DS424IOM6        01=
91
PQ: 0 ANSI: 5
[    1.947104] aacraid: Host bus reset request. SCSI hang ?
[    1.947113] aacraid 0000:03:00.0: outstanding cmd: midlevel-1
[    1.947114] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
[    1.947115] aacraid 0000:03:00.0: outstanding cmd: error handler-0
[    1.947115] aacraid 0000:03:00.0: outstanding cmd: firmware-0
[    1.947116] aacraid 0000:03:00.0: outstanding cmd: kernel-0
[    1.954062] aacraid 0000:03:00.0: Controller reset type is 3
[    1.954063] aacraid 0000:03:00.0: Issuing IOP reset
[   78.145262] aacraid 0000:03:00.0: IOP reset succeeded
[   78.151156] aacraid: Comm Interface type2 enabled
[   87.187835] aacraid 0000:03:00.0: Scheduling bus rescan
[   97.589026] aacraid: Host bus reset request. SCSI hang ?
[   97.589047] aacraid 0000:03:00.0: outstanding cmd: midlevel-1
[   97.589054] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
[   97.589057] aacraid 0000:03:00.0: outstanding cmd: error handler-0
[   97.589061] aacraid 0000:03:00.0: outstanding cmd: firmware-0
[   97.589064] aacraid 0000:03:00.0: outstanding cmd: kernel-0
[   97.599053] aacraid 0000:03:00.0: Controller reset type is 3
[   97.599066] aacraid 0000:03:00.0: Issuing IOP reset
[  173.373888] aacraid 0000:03:00.0: IOP reset succeeded
[  173.380165] aacraid: Comm Interface type2 enabled
[  182.417010] aacraid 0000:03:00.0: Scheduling bus rescan
[  192.812389] scsi 0:3:0:0: tag#164 timing out command, waited 120s

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
