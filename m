Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC317578
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2025 06:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742970396; cv=none; b=o8BWtxyCFL6mac/DCaoqWUOySpwGsxr1ZonZ5ELomZ/emiIFkr782sbj4Mryz1/5tkqREeP+qLO1rpwZNEbeeGMux8qhdmeS1jxt4DTQU7uQ6ZXWO8AUk6QEsrk6Nw5BOeBGoIR7sHNHgNFelCylEWCA503L/4lfbgAe5OQ4MsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742970396; c=relaxed/simple;
	bh=nrxwhoRJa6cIASw1ePHLyZ3WPFvetyf4pPI9u/bfT7s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cUwPD2UvtGyvtUN3YhBM2v7VHIYyqXS52oKG7agy8fewHs2zr3b2S4Vuv6IXv7XX7YZcQygwbqAOgpU68Ib1uDa9bkJaddj2iXOqioKua69vHAwDRMehrkUY4VRqBJVpBxozjKYFxNHMJForYVgMRRaPMSaATtAWLG5kPFYqo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqXNdnP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqXNdnP7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9463C4CEEE
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2025 06:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742970395;
	bh=nrxwhoRJa6cIASw1ePHLyZ3WPFvetyf4pPI9u/bfT7s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kqXNdnP7qrdf6GHF+v/L6VrSNItPeDa4/TZyJNpy/f6IG/ZhjAyJQrunqF5DpPM7e
	 jSyKgLcm6NLU3Nl9yxK7cJLIJWpBwG7N9Qn0W4g3X5rasQmFZrvvduy+o0PX3HlPzt
	 cbQS9U1LvSNlXFo6dXnbSIu/whR4EabhUIFBc+sp7FjfCnxPhQy49JCKUjj1n7KLXY
	 mJRXmsGZ5i/7WD2h3jc4Ac1z1L0PvM5FoBFp6CGEarlAnSYGzksSnRmkvuNNXgPQ/4
	 T34sd86+wOzlbNEuP/cEaeP+32SNdlB76vpB6nWyFaY+6RIz5/1y0r0V5WxQfW6Vyq
	 yFJ/HIpvENUog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D316AC3279F; Wed, 26 Mar 2025 06:26:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Wed, 26 Mar 2025 06:26:35 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: posorer270@hikuhu.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-Q6V3wUyLLK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Backhoe (posorer270@hikuhu.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |posorer270@hikuhu.com

--- Comment #17 from Backhoe (posorer270@hikuhu.com) ---
The CB 1CXT Backhoe Loader is a powerful, compact, and versatile machine
designed to handle a wide variety of construction, landscaping, and
agricultural tasks.
https://newcarbike.com/cb-1cxt-backhoe-loader-a-compact-machine-built/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
