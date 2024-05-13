Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197382488
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 23:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715642552; cv=none; b=ZO3e+Hr/XeroZCwBRmzFaULkeIzpuPFaEVhBg+o+Dk4TWk+XrxHHdIZ/FbmGx2ShjTdGPdkGSMuy0bZqRWGyYiqk5z44ltY5Kp3hElOOr7o62qaOU0JkOJ0mBlEzNYWOEIdr+yp+lZbAmi1JJxOxc4P+l/AEanYn0du/dh9tllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715642552; c=relaxed/simple;
	bh=zXAKdttoR76Hq0ZEmsJoEjFv8blxz7tjDZCxx7PEKJU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C9Zmjm51ho/9arvw86mB/BOe/6bxs1L1yRT5OpvEIL7XO6p5tzngHBh/O35DkLpyGFqYX6NyhLNKRE07plPYQShFzCXqjRNyzm5Wmwsngr+K0BTzCb1S1VRethrRQXZMnFFUodlO8yvSgRBpB7EFHn/wOQmVrDLRD4K2CAKUNOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKHv+0/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKHv+0/s"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 343F1C113CC
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715642551;
	bh=zXAKdttoR76Hq0ZEmsJoEjFv8blxz7tjDZCxx7PEKJU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SKHv+0/sEzVoJrL1ELMtDrgDTs18gHWiCWyLncJbf1bhQWoTmU5PP5g9Z2zoafxSH
	 DDoSmIT0xCJU47VHWlHrhIUL2ABoHX5BFbFGFNBrQpHj7G7C7Z19O0uHOGDEafnGz5
	 Xj2z4NtdEuvPqOCUpFSJFHrczfyhBTksadN9D8itMtW4Nm7ygBpF1roaBMf5zykLbP
	 BY2yzswsB6XwqA3QMoxM0EaFc17JR6n+XyhpFx9pC7OCp3aKxiCgayrQV7CJN6Syxb
	 mZGYxf8v+rfiEnHri1G5ST89fcEXkxmjU3lum0o62XMMEt/rMD04Xvw80BtiQPoPpS
	 c9ml/rLEVkQYQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 22727C433DE; Mon, 13 May 2024 23:22:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 13 May 2024 23:22:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: longdescs.isprivate
Message-ID: <bug-198923-11613-QMBLrHdoLH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Comment #15 is|0                           |1
            private|                            |
     Comment #16 is|0                           |1
            private|                            |

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
