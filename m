Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05580154BFC
	for <linux-scsi@vger.kernel.org>; Mon,  9 Dec 2024 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767693; cv=none; b=JAvwSUZfMP81INnAPkfdLrhztUCGLB+rr4sKWg6Dp4BO3vVYqP4FFAowH0avSbGKk+ATJ3mQBQw7P7krn+XgROk5KQVa8hqGgllnOWLZDL5eN9s0BujbUV0jMQwJ2vGalfSC45nIvb3CEZmL/3ujk2Eu5F5ik+Hbl6W+zV5KtJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767693; c=relaxed/simple;
	bh=gaCqSzov3nG1gwdM1Xq3FGe+lidVlKrnCqjU3z3HBjM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b84Sqh34hV8hRHw3GkUGpvULMevHnhaybuwPkdj4qD4142nnUJtyRfJR+mn1/C5AxhRzpv+7nX8RYui7TDxo5c2q7Xrdvp52njLPXBUKI07WHanW3IXG+/TTZsDFLYnBMrnDSAlz/xd3uEao8Dhxo07EBnJBa6mKXQfYy3ej09Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqHBQLNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqHBQLNR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82E26C4CEE1
	for <linux-scsi@vger.kernel.org>; Mon,  9 Dec 2024 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733767692;
	bh=gaCqSzov3nG1gwdM1Xq3FGe+lidVlKrnCqjU3z3HBjM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iqHBQLNR0rw0TvUizon1JZBxPfVgYOVYVBx+ZTp7CCWAB29ZfS0+zKGe3CwLbqRht
	 bwemO3vcIL2sZwU5aOc1aZriUKRg+LeIhL6BnYuXoBxghj83pI/O9ilrzcTjA9PWZM
	 /YqJGKkN9fM3eLehTH67JboY0eWOrjWCkR4sr7c0jeIp0sPQM3GbJzWQT7G0q5vnz3
	 U5I/dfXitszXLK9wBcyLcP1FNY9kFA9Es64H6PlPWtmyDeHbRDa0cnsMv3lKKS9Y0+
	 3QEAJSrbVsq0C0Z8+w1D3nZzxN6qf8OyU3lYLBgOnBjYdi91CI6MNJd+enkAuAaT/J
	 laHwtyaVuxY5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7DF0BC41614; Mon,  9 Dec 2024 18:08:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219575] UBSAN: array-index-out-of-bounds in
 drivers/message/fusion/mptsas.c:2446:22 ; index 1 is out of range for type
 'MPI_SAS_IO_UNIT0_PHY_DATA [1]'
Date: Mon, 09 Dec 2024 18:08:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219575-11613-ogrtZ0J3EJ@https.bugzilla.kernel.org/>
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

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Have you checked Linux 6.12.4?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
