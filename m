Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5AE1304BA
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721697023; cv=none; b=iox0FIFNp5bBG4icOLQcUYLB5pVhTK0MZKmTiVGtP0Ih/Dgo6ZpNlXCxK4iHv7VvyyUqvp/Jxq7L/pfDvdj2ZR33r0RPMDbsCnswSAQNQ9rtcNSrNIRf3fTLcKyKk1riQpcW5hVS+5WGrXiNek7BAmtlQrtM6CaJYxuCCiPw6eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721697023; c=relaxed/simple;
	bh=0gtaeiJqWMb9AykJ8dVASySbI4Y6v2O3rX7TthHBRFY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oHt4QRdyrOLZxCXwfEk3xI2icW8qv3lK0HoUjsdfwx4kUOH6r0B6155z4NkwzHGeNOQ+9bWNQ8CQTTpEGCBzTWC6gFAx4S6OYU/RyGLqCvIPxWmeYSYTKjRV6nI8SwPN2YSFm6QAyqTpP4r7IzADC/Z3uJntxrq/WXsz3TbXvzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EeUqTFcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EeUqTFcp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6A7FC4AF0E
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721697022;
	bh=0gtaeiJqWMb9AykJ8dVASySbI4Y6v2O3rX7TthHBRFY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EeUqTFcpE+JNjV7J221wVIEERlCLHkkjt1XZI4ueynWO69+MBzLkKNjLUwaDzIjXa
	 zwMUk+UmrqDAjvBWfSU4UvWifEHuN+O6VD2+lWJFgQTkwK4EzUugFT4lRfzC2wHPY3
	 LEjhscgd5t0hbBoJRmR/mnU3BNo5KXCLmbXkQHJQCDPtSaZl4ned1BNH1prrVAyKlU
	 p09u4m62UxZUQ9tFZf4NhViY5F9I62JZpDaMq0w2pgepBvT0sy+FjG0eQkYpLJJJN/
	 ZDDe0sPZppgusMokQ8RQPfh/DRcvimtutlEHJxIENYanZUYi6N2yYhjD6/LPw+ajpp
	 PDBe9P74WM2Xg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A64E8C53B73; Tue, 23 Jul 2024 01:10:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Tue, 23 Jul 2024 01:10:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mkp@mkp.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219027-11613-TwGVKOElw4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219027-11613@https.bugzilla.kernel.org/>
References: <bug-219027-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219027

Martin K. Petersen (mkp@mkp.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #1 from Martin K. Petersen (mkp@mkp.net) ---
Due to some legacy devices hanging when probing for non-existent pages the
Linux USB storage driver opts out of consulting the Block Limits VPD.

I suggest you create a udev rule to override
/sys/block/sdN/queue/max_sectors_kb.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
