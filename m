Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0A364CD
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716568368; cv=none; b=dERiBPMFZmpEFZONNK7HdcxEsOpqi5Hiob28hkrnvznYdTE7IvrAeq9PZWhAn+/0JXv1nR+0wL7Unwb/5DM7rPkVSlB+uvJ3m6I/5slckIC75ZOk/zuGhd3I2006Qdl919Fh4aR28ZR1gW7zSggRZc2Tpf8k0hfcSb6E1oufgkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716568368; c=relaxed/simple;
	bh=fO/fiJlCB783WYNl8k+HKfDEJB/N6ZXJMXrXf1txEkM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MjtK1mxLNejtEkeSiT82XuHGDbdXcd6BRmDbtI4gFnykIx4AIQsUvw408TzrTMenvVxjxtPiUSCIf63fiqBdCqBijCdbfJ5s+2aB70T4oOONXgcmJKVxBCDRQj47AJcFdXEfgwLo+snklIj+skJECBhDZ1Bb3pQ2WOruLvHiqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quh1VaVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quh1VaVp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02791C2BBFC
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716568368;
	bh=fO/fiJlCB783WYNl8k+HKfDEJB/N6ZXJMXrXf1txEkM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=quh1VaVphdffjx181RoSSeV0CsIQ6Au3bEY+dVi9prL6dgLuOYNGeJvZSVa/BZtu8
	 F+HCds5Xg71kJLqnaYkQJEObHmGe+9qZ6qRVqh2FVwoQeE4juVp4IP81WdM7zbfOfd
	 mm2IE+WtbXkfLKln1pSGPgc6JamzG5vFiZGWvX25m7NTHiDbb1GGtglX0muUFEWz1X
	 2Lyiepntl56PKjvDnVqSXQf1ipzp4YfgOm4sErH5mHa/jx80k3k0/e1j/b1NC2W5vR
	 F+pY2X4NqyH+2hye9jHDJ5xKFvIN7gJINHus8gHt7EwhpCb3R3JP+z/Cr6ANMSVQip
	 5bFVeWzOKy5FA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EB0E6C53BB0; Fri, 24 May 2024 16:32:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 24 May 2024 16:32:47 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218866-11613-pOknc9BYBK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

--- Comment #7 from Marc Debruyne (marc_debruyne@telenet.be) ---
Had to install kernel 6.6.21 on an old gentoo partition on same raid array.
Same result. So we can assume there is no regression.
Maybe it is the first time that someone uses so many partitions on a fake r=
aid.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
