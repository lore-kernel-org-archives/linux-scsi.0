Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF718EB1
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2024 09:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716368798; cv=none; b=XmB8E5WOK4cCcFK3fVd9zIFiX6XNHKMXqPOxY8U5d2NsGJ5bowzgys9QBIC4TZh/3Y1PSytnx9MrN8ApUfrQw265BYLQdmlzEP5w+KNUr3yp9BE64A2MWUm9c3h1hY9IfedgKP5DUa7Yc4gA8FldKB3YPHGL2GeOnmJGpQ7bYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716368798; c=relaxed/simple;
	bh=x3DP1oymv+I7KMXjlRkq9u282sPbIaVjg1GuUjtDRKk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EXHaJPTF3Lr5PuF2N9GdAOC7zJIzMCE2WLijDNfdQna4Y2non69YTZA3/zRDP5Q9/c+BxgduChjNylcXClCKkkgQ2GZ/Q1FSyRi9R75fiNHtAYLHAZlWISa1Sv5GgizVGrEJ8yYAD6mDb/w8S2l5q15S5BcORD7j4iyp+CWjk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAcRSw9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAcRSw9C"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 934F2C32789
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2024 09:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716368797;
	bh=x3DP1oymv+I7KMXjlRkq9u282sPbIaVjg1GuUjtDRKk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jAcRSw9C5qQuSgnXjGeq3p0Pj9aB9Glb/EdKXUTqZFQG4tRC+kwC6xZuVumLtvIaf
	 XfADdi6XK+phTm4fjljXYhgR8gN8ko8KGHqJqP51mhgpt4hdmIcWsH5FnCN/Etz/BR
	 oStUjUx3usHn8LWvy12MbBcI7RNWex4d/vBKuBz6SV/odqkgV8FnzmZKT1sNAhK8zX
	 XYbVh5Kf3Z3EMAbV8Ond1PZMOn0dXSnNTqLs2STMsuT2GRtoYDlQuuYfO1shIewCVV
	 oVF85s4QfokLwEEyZkkcMsluUOju31FdJEdKthXT2RpaFPJgS7/HEkscjDL9JmeF0U
	 gu9JAyDJblysQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8599EC53B7F; Wed, 22 May 2024 09:06:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Wed, 22 May 2024 09:06:37 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218866-11613-EcOfHzZjxq@https.bugzilla.kernel.org/>
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

Marc Debruyne (marc_debruyne@telenet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|6.8.3                       |6.9.1

--- Comment #1 from Marc Debruyne (marc_debruyne@telenet.be) ---
Upgraded kernel to 6.9.1-gentoo-x86_64 (6.9.1)

same result.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
