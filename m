Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2F33B8D47
	for <linux-scsi@vger.kernel.org>; Sat,  6 Dec 2025 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765061790; cv=none; b=tuAvGcnfDAC5Vt8oR64o1i4JQICbQ4kRzGWRz3SkeGZLjq3cORQO6XG4SLp7Hd5j4AwmxEb4x3dKGPFojfehmt9zwnSaKDlJVoUYnPBolJ5K+PGaCS8AnaqIROJz6TpyqlCHKeFSQCk5d+RmEAXNaZl1E8IcrqrSD7jbiMDNUMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765061790; c=relaxed/simple;
	bh=6OhBsMECsJjzJdrt6aJSePYYu30iN5Lm6CPcHbFnl38=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ahcSSFoi93fIBo8Jog/R+GSHFWI1b7/AuMm3m4i2BZuN1h1mOsDLyfximd8duDhIZvblTO54TJdx5vFFb1uHFZ60UgLhP4JD6jZpHnUxugGUjog0dWLF1SYaikLj2QGXTrJthPQidwT/q6pQR/NKofRLmnwabqz3O+rWMOd3Jwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6Mynfwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6Mynfwg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92B66C113D0
	for <linux-scsi@vger.kernel.org>; Sat,  6 Dec 2025 22:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765061789;
	bh=6OhBsMECsJjzJdrt6aJSePYYu30iN5Lm6CPcHbFnl38=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d6MynfwgMNtlVNI/yi8AUtCS1Ya4RcXAureB/wXVibbXsxP0nb7VKL2ZkKqyd4blk
	 /EU+JTB6O9ahP2NX/UEYQN0amuQbiTzH5dk/jUMFXlOerjyWn/L0YsVMZfV1kfA4Lw
	 aJEGwnycSA+/hXcQ6qg3R/7gY8+Ssi7rF/aA/7zBMWU38j8OLXL1BkufIoSNnuCyUR
	 5Nl+SHPPbMQx2fpdUqpUxf8zVm65jZGx48vq8vlt3O8TQoXVi9VNcYcKSf93ON3OcW
	 U4CEyaz8L+RIPSufCfTLqZ82k8mVz2/u5QsCru4YzvSwTbaaEvKRU79ycn+YH8wI9a
	 nZPElJ+uHz5pw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8D513C433E1; Sat,  6 Dec 2025 22:56:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219575] UBSAN: array-index-out-of-bounds in
 drivers/message/fusion/mptsas.c:2446:22 ; index 1 is out of range for type
 'MPI_SAS_IO_UNIT0_PHY_DATA [1]'
Date: Sat, 06 Dec 2025 22:56:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rdunlap@infradead.org
X-Bugzilla-Status: CLOSED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-219575-11613-1Y4KTMSwV2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219575-11613@https.bugzilla.kernel.org/>
References: <bug-219575-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219575

Randy Dunlap (rdunlap@infradead.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
