Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CC175A8D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790344726; cv=none; b=JKJIugaAX+OIu62e/P3SPqoMw1gFBcyA9H4uqxknfhe/v/0Y6UzLCdxYzuRXafRoI1r3ftAGU1PW2myW81czThExkMX7gGXjJcxvgiFdz8ECYWzBcnapTkYnGFXJGHy4/enNkDTelFq4YCRh8d9MgMTTu4hWbavSeKPkJpe0efM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790344726; c=relaxed/simple;
	bh=dQzohNI0NSVkXFlZwZadfvSn8Jt/rpVkYeNIjorPgTA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rYl/E61dIgSuALGVpW3itRx/7XTbbG8fiKeBKGlDtq4yGLvkSCPoU4IdFD/NZExo5fzJ+18zYgG4CZQ/629dUkdSMKa2+VD1PB+3cjBKPZHQw7cT2mGojCNowlwjIvE2dB0uNqydVp3ha2BB3/aBvjGWkVsEbvpdw12XrVR82hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GshHC1M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GshHC1M+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50362C2BCF7
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790344726;
	bh=dQzohNI0NSVkXFlZwZadfvSn8Jt/rpVkYeNIjorPgTA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GshHC1M+edIz4ZxkYMTkZ5u8H45pynvmMTrcaFtirSOkjs8CJWKvBcG1FCIF8RMOn
	 TJwJBkHj8PV1Jur2h7/0hPosMU7Z/O5p4suyKx0Jd51YkfBdNmxc2WXPabO37gyo6+
	 /V99Gb9jzDnfT6IESHo052a54ccG8WiD9sc0kmm2+bdr2tPmzylSdPUpSftFSV8B25
	 NgNsFT1nU2ecRMoQm5nJlNOjxhgAlqLnyCztl3MKqPKgEXkAr5ytwvFCXxE1zZD2CO
	 zxEFMO9Nor6HvlMbuM3J/d+p0jYtqHTuNQyZidkY7E6n4a5BcelfkLV/mtdVbiOv47
	 Y5mhIfXLpfp2A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 34364C4160E; Fri, 25 Sep 2026 13:58:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Fri, 25 Sep 2026 13:58:45 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-j4oL5UhJWJ@https.bugzilla.kernel.org/>
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

--- Comment #18 from Bastiaan Welmers (haasje@welmers.net) ---
Update: good news, my build now succeeds and runs without problems on a
Thinkpad T450s when using 38803ff4fab8 from
git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git branch
queue/5.15

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
