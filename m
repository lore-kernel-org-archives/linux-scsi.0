Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD35663
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 00:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705883610; cv=none; b=Sb/OxkQ0mXYVnFNKGG+DvdsEFFhWPE0ycbp8CAWmOR7n+SsApVLkTFrOiF4gtjjAs6KSOpXQua+lOtyAACju7EBu5XkL26ksOX8AQolvpB1EPZRgWaH7AThkkecfdRyHscNB08yYIGTgEur6FtxQM+oFRHLbpytHeMBgOTqT3xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705883610; c=relaxed/simple;
	bh=vsuATLc704fYrj/RqfMec7fU96YGQDhi1sPZDd7rqTI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ibos3z8emJd5vbHIqTySneMzOh3guwbMfxeqn9r+HHQybiJ2CdNgO2C1SJ1lLlt/o00uYqa9EJ5ob6aiJQiOeMfA70CqjvXWZfampe7wdiUBI6t4n8h8QH9n8jpwoPl21YsrwXnZSI2RNGs3lPfnLPJ883urL6LALOp7I4BfcmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zya/kNo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zya/kNo8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86B7AC433C7
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 00:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705883609;
	bh=vsuATLc704fYrj/RqfMec7fU96YGQDhi1sPZDd7rqTI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zya/kNo83bh7sVGn7Zm29GAU51kPHL1EVFzclTMjwJsrVkQWvkuo3z42zFpEJ6RjD
	 1LXt0/TeXSVJxNmtmb6JhrC0uYbufUKIxOdvnae7apN0PBh352O4v8P9kRjqqkIau8
	 LJVqeE76lNXRbUMDf6DHLVkXjVbbOMsBUjdzzVy5qEXJCqT5A25UEEi6IsC1LFs064
	 E5mPEsD2tWFXjqtl7hyla3/3IQhAmFRQRt2IkMz+BC4sWgd3CRzyGxFR4OPt+rAmU6
	 x85EPSOB5aEefDsQsrQoX3R5O7h7p3far3vxRmrWFpGcdYmLgyRAtS2S7jFHXamVzg
	 6ZDDKrW+1Ax5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 75624C53BCD; Mon, 22 Jan 2024 00:33:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 22 Jan 2024 00:33:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: evawillms183@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-uAbY0fSlov@https.bugzilla.kernel.org/>
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

evawillms (evawillms183@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |evawillms183@gmail.com

--- Comment #13 from evawillms (evawillms183@gmail.com) ---

SCSI SUBSYSTEM
M:      "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
M:      "Martin K. Petersen" < https://run3online.pro >
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
