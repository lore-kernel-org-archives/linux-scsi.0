Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC63147C9B
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2024 07:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728890988; cv=none; b=O5kYtlVuZ9vsX34JXVMOgZaZsCVpL4uNq8VKFH7ul93Mn8L8PY7p7SpsInvR23Mvt7EYCQChtWGsQIu+mvDaoKNxTW7PTPeIaGj3+riiazBPyiGqoOgDId7rY3Ix37sNYgbacIZq6jgPLiMCIBcx313VwmUbs41zAh3oxn6S/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728890988; c=relaxed/simple;
	bh=ebHA/DQfDX7ySeuPpeVQBN5CQw7JV3jBmo90rHS5X+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c1o+hsMAslWCT59igriuQR5WlPa/iV78VDgnr6jpiFamKpjJrv1ry1JEtEYmL1qeSrPU7Bs24bHyGZa7bMZ+NR2csJAJMhvjTRoIZ9Q9RzsHITg1B/8uuJ2OScqdfuNlgm7Ng2g/BhdsADurPTbJ7wW6lOg48np8LkANmI8UVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEsfhfnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEsfhfnG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A53F3C4CED0
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2024 07:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728890987;
	bh=ebHA/DQfDX7ySeuPpeVQBN5CQw7JV3jBmo90rHS5X+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oEsfhfnGriE12/6cjit9MvJy6zSprSMZ5S+D15AGOHEMSUVhDO1eEwC/E/hNHfRfW
	 JWrG4d5aF79pk46ejn+axRmaEIrqmbku3SHY/UdJ4pjsvAJdDp3csGoIfP7grbGnwA
	 TJtIfNFOFgcNqN9Zz/ea+GI97/4d03NbmgfWr6wMHM8KuKhmJxBE9OThrHrJWnBJQm
	 4TpHSEQWkrQVLGt1KxI04VL111qbrnADmeOFlE2BTpuVCTRtFUBkfBcoMilCxCv/XK
	 C5x5MR9vKdsP8PRMFSXIimUpzuoCbr/I6CdYDcLPeiSQCAv+FKevBF8I/yhPQjDjrt
	 CQX1pvj3hXbIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9D3D1C53BC9; Mon, 14 Oct 2024 07:29:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 14 Oct 2024 07:29:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-BGjwUSC80J@https.bugzilla.kernel.org/>
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

--- Comment #65 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
(In reply to Maxim from comment #64)
>
> In other words, some errors still exist in the driver=E2=80=99s source co=
de, and a
> bisect starting from 5.15 is needed to resolve them.

That's a pity, but best discussed in a new ticket, as things otherwise get
highly confusing. Could you file one and then drop a link to it here? And I
guess we really need a bisection to make progress here. When performing one,
apply the revert with "git cherry-pick --no-commit c5becf57dd56" at each
bisection step while in the range containing 9dc704dcc09ea)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
