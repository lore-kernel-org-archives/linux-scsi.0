Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED93F9D2
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900219; cv=none; b=iym9GL0fWlBAaeboMhJ/ciJtFS9Uu+PpO16Cl6Yr9FGYE0XCbfwBtxD0pGv5iP/M4rFMe+4WqYdTG/YMPBhHTdgjVLXb0VtOwDu1Nz1HsvxkRantHRNWTbR9ZR4UxupZKVYGvKq+nAedyUHF9vrraHGR8UvlftkNdN1eLbtwWrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900219; c=relaxed/simple;
	bh=FNbsZjfDXNw4K4s3NfqVeZ1GsxcYKq9KUOtmg/vZLYM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dPoNgqRi1KG1AXgFggKOhQ1K6HwKs4GZK618fIQqSwys/ezhWSrHKyyOAruXUO6RXveSTFBrhNIVxHylt2f0QJfWvLM4LDJ39BreO7dacumomGnWNHqLXIY89m4stWXykqYUePwu9UpJcuKVjwRY8B02PqloHTPE96tmX3/XIQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ht1SI5NR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ht1SI5NR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13AFDC4CEC6
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726900219;
	bh=FNbsZjfDXNw4K4s3NfqVeZ1GsxcYKq9KUOtmg/vZLYM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ht1SI5NRWKAZonFuWB6GbRl1aSmNPujxIpB1RjpXhrN+QtV4Ea8ZzplHrLnh8U43Z
	 B7y3dirLjkYreJXwT0eNovXvRyQ/VPFW23uUO0N7L4EjArzpEcuQ/JQf70+u0sjfYE
	 jjNrjvj0CuMZLet9Oc2Bmbkc/0yziHqjfhu1z5HhZGlekSzCoztmPVyFHXJCwoCbrd
	 mhhq5fDXe4K/dr5n/6Zae9zGQ7leMrKpaJHpmjyO1Thwy6euN65cQcIAav3qJUYIpP
	 yyN5i8TW5AiP3tsvM8XtCE4SXD2Y9MYquT/87pj93bBWMuQLcrdRmDBj6xSOo3bnxU
	 XzjRkP7dQ3DKA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0C52BC53BC5; Sat, 21 Sep 2024 06:30:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 06:30:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linuxcdeveloper@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219296-11613-xyF64DXOaW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219296-11613@https.bugzilla.kernel.org/>
References: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296

--- Comment #1 from linuxcdeveloper@gmail.com ---
Created attachment 306906
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306906&action=3Dedit
dmesg from first bad commit aa3998dbeb3abce63653b7f6d4542e7dcd022590

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
