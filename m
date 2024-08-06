Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1C320E
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722910582; cv=none; b=qnG0KHipAbQg1PnR11g4TyVoRQQ9Gp/g4IyCeyGk8JXKBO+zQ1uBsKP5masuBJuWNHPOKMsl4jl0Lvm30dPCu36OI1hOWKp7qNQuCKt39O+0rsdFwKzUZfEjyeso8ZWoUHmPrpF8inOuWWnyi70adGtVVY76t+mTFU5vmTocpCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722910582; c=relaxed/simple;
	bh=sRoJn9VASFKET7t9g3tVUhXJ6Z5MeCou5dN6Q1R00+Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eFbVUMjNxsPxe4dYSOUPSi6WySv5CefqbwCMilMga4pDuIIiVtntsW1cpd/VxSqAVl6AO06FW4kCj0GDZa5oP98dImtGNNLRJNshlhrjkZ3v37EGYsgof/TzqkBfPmKsqQKo4RuCm0OqpyrbCMt+3Z2ojW6oyHsDLWm8W+NnVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7DsZnsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7DsZnsX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0915C4AF0F
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 02:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722910581;
	bh=sRoJn9VASFKET7t9g3tVUhXJ6Z5MeCou5dN6Q1R00+Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L7DsZnsXGkw30Qt+mUpUPrMCtJL6XhiTRVf2JruQj98JlPqIeqUn7xCemLbW9RsQ9
	 3A0U2u+qd/eCqsGQfXNwev1wktwJQSXGRbt3Tsv9EFOkHhldLeal4npPkxWLwNYuUI
	 3rFHgaqvdR/MyX9QNNdU+nToCfPPpIbby5l0mCBQ7XpsDI2bK4zeEe+vWAc13A/Gc8
	 b/RBqk7WNDiJeCkDfUjhacqrJygesiU4dG04zBQ11+JuO4T56we/xENNMSFJtOiWtI
	 Js2yWGmbM63v9WqCIF4mhZxqh9VhxzmgB+e/XmU7OtmEx7f8k+xSLczRsIx1x37ZCs
	 D4thlAOwWmr9w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B4256C53BC0; Tue,  6 Aug 2024 02:16:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Tue, 06 Aug 2024 02:16:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 983292588@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219027-11613-RtxxwXzPTa@https.bugzilla.kernel.org/>
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

--- Comment #7 from LXY (983292588@qq.com) ---
(In reply to imyxh from comment #6)
> (In reply to LXY from comment #5)
> > What a pity. I still haven't found a solution.
>=20
> Have you tried simply handling the invalid write/read commands by returni=
ng
> ILLEGAL REQUEST with INVALID FIELD IN CDB? (I know nothing about SCSI; th=
is
> is just as per https://stackoverflow.com/a/33372494)

Yes, but it doesn't work for my device.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
