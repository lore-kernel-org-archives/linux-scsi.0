Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB138FAD
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546188; cv=none; b=L1z2YzGsA4Dgd6RoueCDDNMtuJtDSX2a/Fy7eBKrk2lQgQW4ORznBAoLVhZKrejcUZk5InRwIi2LF2xC0PLYPmNk5d8TEylfFmYb26OJ957m1/zJ7R+OsPa2h/SdmUhQPgcq7Qw5vB/VAItho9v/5gAue5uGLRbcTNUgaqLQA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546188; c=relaxed/simple;
	bh=8sV18Yva6f6CqjKJQdbGZ3qYVOuDcrZF0WUTYC8IZBw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HMTzLMJP2/3reeRawrBhhuhf7GCQk/rj1KF63ZpEmWnGp2yG5XWCtNDKZjdHYdLDXNBg1g0rk6n1vYbbNBzInesm2II4QZuxZQbQeHbMW4yJHVhx+UiSdpxc3JaUoQxWI5G48gcy7a3qS1weWbOWYmHXUvRDqxuIIkWnet1yDL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9Fv+u51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9Fv+u51"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03127C32786
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 10:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716546188;
	bh=8sV18Yva6f6CqjKJQdbGZ3qYVOuDcrZF0WUTYC8IZBw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A9Fv+u51FH9pTBdKEIfQGKev7eQKD1l94nyHq2V9DaD+L2N1ZdUdfdOVpe//i+k10
	 fev9NoEJHCxfUUEDZfiXWqeBo5yf2Ugvax/SwZvqoAylObO/LLzRAp5aunmF0AUo3H
	 7Ej3wWWZTiJioW4CI8fY83btjPDxLFntg8R8LmSyIVJi1otI4ph49EmRCNQ/yV3qif
	 Ze1ZkHX0x4f1K2PjgEvvTmWsaZ9j+VnNfu+QrIxZrX6B6mzEGV+xVBDA68olwFW+tm
	 NQGm4BzQAdG3l5jgwCXSvpDqjExA9RuxGgxuEKbT42pSwTbjx6FENOs+rAo3vWDS1L
	 wPGdHFVOMdppg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E47ABC53BB8; Fri, 24 May 2024 10:23:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 24 May 2024 10:23:07 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mkp@mkp.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218866-11613-rZqN6Tf4A2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

Martin K. Petersen (mkp@mkp.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #4 from Martin K. Petersen (mkp@mkp.net) ---
Looks like the partition table is invalid:

[    3.037149] GPT:Primary header thinks Alt. header is not at the end of t=
he
disk.
[    3.037151] GPT:1951170559 !=3D 1953525167
[    3.037153] GPT:Alternate GPT header not at the end of the disk.
[    3.037154] GPT:1951170559 !=3D 1953525167
[    3.037156] GPT: Use GNU Parted to correct GPT errors.
[    3.037168]  sdd: sdd1 sdd2 sdd3 sdd4 sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 sdd=
11
sdd12 sdd13 sdd14 sdd15 sdd16 sdd17 sdd18 sdd19 sdd20
[    3.037441] GPT:Primary header thinks Alt. header is not at the end of t=
he
disk.
[    3.037443] GPT:1951170559 !=3D 1953525167
[    3.037445] GPT:Alternate GPT header not at the end of the disk.
[    3.037446] GPT:1951170559 !=3D 1953525167
[    3.037448] GPT: Use GNU Parted to correct GPT errors.
[    3.037459]  sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10 sde=
11
sde12 sde13 sde14 sde15 sde16 sde17 sde18 sde19 sde20

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
