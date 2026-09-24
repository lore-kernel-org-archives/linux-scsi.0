Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA7B414A38
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269614; cv=none; b=OhKhIzlP1KSDLT+2CjBUY7vOuz6SDeN8H0hzKSZFV5mnuHUtiQCcZitRm3GfAhfu9id3Qde0ssrTn09gsc3FTu5nNcsJ9HfZwOtbQhPw7GsXgUwGoHa0uzwe2QPOMb91/tku+YE9CZJZjFureqxPgTmSeabyI9g2x/n0Lil5apI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269614; c=relaxed/simple;
	bh=9l3B/maKNuiXvrItdl/zY2ythyxY1A6Mc7jZyhhzAM4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jwR/i4L+D5s620pNjD8VbnUbu+wpcgGdF1SKr4Tr8fC/GryqnGbVCTuCwMDpd0rhnrDYegxrLe24eG/g9ipY4Fdj4HK101LBtyQqP+8JqRk4R/ZGhGzYvsCdTeIA7d9JfCyuRjbHNeWj6JgnU6zEd3UqrSY5N5R4L4SJa9JcqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWGfblNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWGfblNe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0220C2BCFA
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790269613;
	bh=9l3B/maKNuiXvrItdl/zY2ythyxY1A6Mc7jZyhhzAM4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VWGfblNet4VtzdyzSldU7VacFCl15KsxLAd8iTSSoP4hig2MBeDM7jVm6jr+cK9As
	 SCpqbaLyLgpN8YOegT69gbzTop9bi33Se8UXZwlu4nHaQNIt9pnUQxMblD/DDCSL6F
	 Uqd/wnUhNTS7Xv1Q/dYVGN/qmRjn43BgCGZV7uiacNJPJgu5OIRO6/xidSPBNdAD6W
	 JX8dhe8yqxZaXUBA5NFZjgPotLTAX+lsvmv9cuL/7uzp5rT0OHoN4Pcia/zopZ5yVn
	 Osea5t/lFp29bDxWWmwu59XzNs/PhssJH3P2hk9vcs/Tn0m4KpmIeW0t0zMRw0oF2z
	 fdDF4S3oaM28w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A6193C53BC5; Thu, 24 Sep 2026 17:06:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Thu, 24 Sep 2026 17:06:53 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-s75eviFekf@https.bugzilla.kernel.org/>
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

--- Comment #17 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
(In reply to Bastiaan Welmers from comment #16)

> I unfortunately also can confirm that a build of the
> git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git branch
> queue/5.15 commit 731937a9e48136b71ba06095c68204a4f545efed is failing with
> "Error 2"

What's the error? Is it related to the revert?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
