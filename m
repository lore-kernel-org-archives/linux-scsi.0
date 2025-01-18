Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516E31F60A
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 03:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737169655; cv=none; b=UwEvA3cddT8WXGRJFHnsdgz2jMSwJZQnaUVIq7RRO9MecWWZSkhsSmAhnOPJpsHht8dskdXmvXgOxeVRBdn/5KfQxSvmzQAl6kV2oC8bZQUhawBhNYXAXqzYO+xIb4N6UB6XFwPz+vUgTq+GvXBgq6xXvSv7BF6rk5Xk4LL32iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737169655; c=relaxed/simple;
	bh=xzXgKMf0DDPr6NZ4KlE/II4GZl8hq2mmxI0UHxeNtLg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RA49UZGjkGNG/KcRmiXFpyacnDI/Ng2kZ82fn+eoab3CqAocr/PTABM6sl2XoOaBmxB26lOv6qNZ39ErgH/ub/Xwv6wNH5z3Og8PjHYimMysApOPNM5y5iA0ccukTgPF1PT0rIQF+gXxQ5HqtV2z8l7uEDdlLV7DCzewDjS0RcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esGhR77y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esGhR77y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C2BC4CEE4
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 03:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737169654;
	bh=xzXgKMf0DDPr6NZ4KlE/II4GZl8hq2mmxI0UHxeNtLg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=esGhR77y+WGKVPZxzgI/DSdMKCMuSufcf9NOUg8ifZ4ln4aCD/TzKhA5bWDh3W+ho
	 ebdPvA7vBcTzwb6JhITKPBfoWM/YvmMH3PMc3lz/J8COK3Xs6/MkjjikOYxucDhIpS
	 LN0no8uCGFc84I2LkXuXhA6NRmYaxluX2hBgW3M+GzGJo9zK6tFiY4N299y117WTqe
	 DPFbNULMhLhaZ/fsMViGtAuiyLKHDHuf/+CjPol/BltDdUZ2tMYys7CBqvszKJm9h8
	 PtwozF/TL0GSG7sDPcunJ7oU2FakdxO1UDIzoByr2Qxz6M+OukaAtu22mV9S+uSRPj
	 DyeqOlrzHC1+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AAF60C41615; Sat, 18 Jan 2025 03:07:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date: Sat, 18 Jan 2025 03:07:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: andyzhu35@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-214967-11613-w2l53DNdTa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

Andy Zhu (andyzhu35@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andyzhu35@yahoo.com

--- Comment #18 from Andy Zhu (andyzhu35@yahoo.com) ---
Created attachment 307503
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307503&action=3Dedit
Resurface the bug -- 1/17/2025

I encountered a similar issue with the initial report back in 2021.=20

I tried to revive my old workstation which has BIOS/MBR with 5 HDD slots.
However, Arch linux can only detect 2 of the disks. BIOS can see all the HD=
Ds.
Linux kernel is: 6.6.72-1-lts and updated system with pacman -Syu.  attache=
d my
journalctl output here.

First time to post, not sure what posting policy/requirement. Thanks for any
help in advance.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
