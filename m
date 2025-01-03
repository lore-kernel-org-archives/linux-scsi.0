Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF7519DF8D
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735873265; cv=none; b=V25q1xF/myGrALlGs+26hwk/g75EUsyj53Fp+3OhDCHqT7U1wjn6mdgMf9GLodDMNb3bFZ6er21jaf9lRpWCBynsLSsoaBNzv8eG9/6e/jM+FqJR5Z9HBMKQ+3Bjfc0zNRpNZW5R2c9O6dbf/g2sKOEVMRdShA7yXgzrPXtvdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735873265; c=relaxed/simple;
	bh=nay4NmIEc/Kulx00SrFoE7UNrW/CPjw/dxsUYXOyXXk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t4V+F81v+x1CREmAWC8vBt7h8i+Jq6sAKcMp8bVUNXngb35LMhP+wkhKCLBPWd2Uq098kpIqyqMhdOF/TWr44euYNbsogsPKn2TE0tdAFtOSvxELyFVNG0UBanQqBcLu94YcuWdpb+LpnRIKZDt3Cif39eqO/V/JWD2qLs1CXdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTvd28sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTvd28sg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7618AC4AF09
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735873264;
	bh=nay4NmIEc/Kulx00SrFoE7UNrW/CPjw/dxsUYXOyXXk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hTvd28sgkFQ7KI7Nc+4iR6dDbA2Hc7y/lDOYcx0F6WBHRgQ0EjeHk/I9ia1YlCElj
	 FmLgJZXZkRa4D5iUucSMM+eM+8kdMtvZFzFG+fgDFOvd7WzmfvvHxpnR2Mo/thNTtE
	 g1Ulxx70dGHrZLr8Nhoet3L7GnjwoCOevWB26aK0DIwgNX6riCqT0J5fwZowEd5iy5
	 o3Phblf4QfqGSJiYjzNjq/Po6uYF0ET3BT6H54KqiFp436K+oDG/vsIZUnAzoMpHS2
	 PTbWQv7WOvGCyqWzX1ssIfDhGEI8ahOWUmST4CtFAOlveKATpBWNow+CAmMomOV961
	 tcQGWcpcC/w1w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 62FD3C41614; Fri,  3 Jan 2025 03:01:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 03:01:04 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugs-a21@moonlit-rail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-x7rrreeyvD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
References: <bug-219652-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

--- Comment #9 from Kris Karas (bugs-a21@moonlit-rail.com) ---
Just saw Alan's comment #7 (posting race).

FWIW, there are two drives showing this error.  The first is a Toshiba
DT01ACA300, and the second, a Seagate ST3000DM001.  So it's rather unlikely=
 to
be a drive firmware bug.

Given that this patch has been out since 6.9.1 (if I read git correctly), i=
t's
a bit odd that my searches for relevant/duplicate bug reports came up empty=
.=20
Hardware bug with this particular USB/SATA bridge?  I checked the
manufacturer's website, and the model 1610 sports an embedded 8051 uP with
downloadable firmware; however, there are no firmware resources on their
website.

I found one "smoking gun" in this report from site hddguru:
https://forum.hddguru.com/viewtopic.php?t=3D33369
It indicates that other initio USB-to-SATA adapters report sector_count-1 in
some cases.

If this is specific to Initio adapters, perhaps the easiest patch here is to
assume that if read_capacity_10 is reported as 0xfffffffe, then it's buggy
hardware, treat it as 0xffffffff and proceed thusly.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
