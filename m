Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015C34A8A08
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269087; cv=none; b=R/SvYzQSvalBIRMwcx14vm1NhaolwKx30MgRbotsSZmV5WMm2oh6nI1FnbBTBSixrEI53nuF9nMmVxxXOmE1pKI/tfBnGWywcjlClPVQCG6LoYowMSN/mKia9pNHvWTlZ1aY+CDD08k0hEQ+WKC9O3QbmHXaPA91qEWJ+XSUHo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269087; c=relaxed/simple;
	bh=GiZmCOIxf25d8Vx4qYLU9lGgX+KIRLeHWGYs34sqLII=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CyPAKBtFtsI1pBbIIvY2fQ5Qs8jLMDdKkKCvCS2HB7bCAMOMwr4MtkSMrtAsCMrANuXMZ/xkHTFDVL1AYQDNz2BwC7lT2veJqeAdfWW4/nXUbGmJnAxR6RolafqGGxloGv7wTCZjod+qb9BsM/2xhHCHoCtkS7+AyEk1UZ2s+KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lze7YZju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lze7YZju"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6612C2BCF5
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 16:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790269086;
	bh=GiZmCOIxf25d8Vx4qYLU9lGgX+KIRLeHWGYs34sqLII=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Lze7YZjuV20lcFSt+lcISsdcojQbj1VUvIelt1QCXRdCYE227v5gaoGF3aFidTZ8A
	 apYO2CHFI1Xt9RxfycUTrKwM+yqR1ZmDrR+FXqiT33ejVYOEO5oHAqSteveMfZcFHe
	 2UrhPbVvx3TbeXw4J8bJ6JOtnri4VjODzm9TlvCNFWMkMcPEPX7/anFwjbgZ61kAG4
	 S4ZFkDC8sAWBg4WncJyYw+kOrOGcn9FLJIyu4kTkvYUiCO2AbTYSdD/SWksWu/osTh
	 cRmin7xkTk/V4O2mtoTpFLVnoOCCOhyscs7f9PuUbv4HaDbFjS8sozseoCpJdFpMyU
	 rg11vcb7PNetw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9ACF8C53BC5; Thu, 24 Sep 2026 16:58:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Thu, 24 Sep 2026 16:58:06 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: haasje@welmers.net
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-222016-11613-0iSDTZuXY4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222016-11613@https.bugzilla.kernel.org/>
References: <bug-222016-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222016

Bastiaan Welmers (haasje@welmers.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |haasje@welmers.net

--- Comment #16 from Bastiaan Welmers (haasje@welmers.net) ---
I can confirm this issue of not booting because sata devices are missing, a=
fter
building with Ubuntu 22.04 kernel patches. (Every 5.15 build until 5.15.220
succeeded thus far and ran succesfully)

I unfortunately also can confirm that a build of the
git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git branch
queue/5.15 commit 731937a9e48136b71ba06095c68204a4f545efed is failing with
"Error 2"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
