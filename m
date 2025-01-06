Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73970830
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 20:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736195620; cv=none; b=W14ImY6O7Fx8GWNxcGcTRvfpTmHYwJqBegt5JrwiSIOpwYxNLOHar7BsMiqRlqcqSssiyI0IwHeUJr6jG4lNcgCMz2Cg17LJtBKlTyUpIOZ1u7ZBPzkNIPIas77fZZVukInWuZ1i/9mSxN/uXd70lzs9hoA4z3UZlmBu1jqppn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736195620; c=relaxed/simple;
	bh=HASvGLVqzWTDinuteIXyxtIp4dPf91NZEFXSZ6VKAYE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TIbQhdaA1vsaAI/8B3ac2n3vn5Mz+1EFCS7Qa0eS25OBdMuq2GI2YTT96rR2ryB5q3xsHwa6utB3F3w3PtSBCvvqtU0nvueHa7K/jLVEpfoxEAjeIMRAGwN9SugP7oSC0BoBQMOizxhalH92m8u/8nlkpcwfxN5LHVuYDdCzLvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZoJTdYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZoJTdYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B242C4CEE2
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 20:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736195620;
	bh=HASvGLVqzWTDinuteIXyxtIp4dPf91NZEFXSZ6VKAYE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MZoJTdYJsC3mbRrvtCiCKQA0e2M7rZaq7M48tviAFo5PVBV9nFj/g5wTiTCi3O2uv
	 BkCZ3dKsemiLtQdhMx5PGkZ48RZUHtShAUtzSCzTGOKKg17niRYpZKYmJ1EA4ouLTT
	 V5n5ZuXrGBo8RkCsk6YsdEcPJQwdju6tvWW22y06r9zuz5Cd4QJUBVwRq36ugu7fFS
	 6XdWtch4DSR7+Om03nxjFREoAYNP/1k9wVJCQJtafYvV/cHH1P3bodAe8IVJMjeRmS
	 jElxepMtYqKgbVb5g2sVgUWycNxlh9r/POb5xXvO5DoHij5lhmEGxAUUnauRjbLJgx
	 WX9QJHHTIg9Gg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EBC40C41612; Mon,  6 Jan 2025 20:33:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Mon, 06 Jan 2025 20:33:39 +0000
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
Message-ID: <bug-219652-11613-6J9RBsAnC0@https.bugzilla.kernel.org/>
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

--- Comment #13 from Kris Karas (bugs-a21@moonlit-rail.com) ---
Sorry for late reply, was out of town.

Just checked Michael's proposed two-liner in comment #12, and am most happy=
 to=20
confirm it fixes this bug!

FWIW, I also investigated the related issue mentioned in comment #9, from t=
he
HDDGuru forum, and can confirm that (with this same brand, Initio) of
USB-to-SATA connector, when you perform a disk capacity check via USB, it
returns exactly one sector less than when the enclosure is connected via eS=
ATA.
 So their chipset/firmware clearly has a bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
