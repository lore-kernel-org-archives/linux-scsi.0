Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC1F15D1
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 05:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735795345; cv=none; b=sUxzF3mdrXhJimimJv/FO2mcKDA9S6q7GBxsPJlrCdfLDhR+dJvMM/7FrTusyA5TzJ3Jykr1c3UIf+K2C5dr6dxgvgr2snzYonQxbrh/myHktHWtWVJMYNZrmcF3+hXkHhKt8oB7p7FWQibQNmuFO7b/QcWMxsNmX9PIXe79yKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735795345; c=relaxed/simple;
	bh=NRFK/+/OA21AogO0QU/NvlQI9vfPTj8d++tzQNDRqp0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hXzn1M9dfAyUgVeFSSogw5Lr1uN1tiR5YuHVrXUv8osw00s8VMlGGuXdNg/ilo4B0+uzuaALRFOGfOhEDMCpWYDpaXaR+WAbqZ5fLBDz4c+gd69B7IZWlUbcMLnoZoRcHjB2TeN9gr2TJ9dDUFd1YK4cA3p6+T69UpDIX0hOBgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+NN77R5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+NN77R5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6064AC4CEDC
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 05:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735795345;
	bh=NRFK/+/OA21AogO0QU/NvlQI9vfPTj8d++tzQNDRqp0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=X+NN77R5P2F/3LEuPDydRXcZEr7kU8Dk0xiEDmxzDKeFvdQpDLpuxWWGmDELqjZf2
	 4XVDT3JQvac52YxvN7KhQqEOaHWuUGLiQwb0j5JqJ5JvN5RTew3n/1Onh2J+mc/XUS
	 AiQDuWdCp3OC5mLcGzIunzCmVITHN66LIeubamz6rFgkNfi1ty10yo9cDF+HLe7gky
	 la5Xvi6xSX1F6jl9usywJiWW71ygwam8klVQ8krL7XYYZtlkxFltXDj71k8txI1gEQ
	 tPwMPoutkuUWlBmet2wSHGFFpw++zkkQJ43czeeCyLuqoAEeBsLZBinh4TEGahg5vn
	 rdrvfwgbPOoIw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 346B5C41614; Thu,  2 Jan 2025 05:22:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 05:22:25 +0000
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
X-Bugzilla-Changed-Fields: cf_bisect_commit
Message-ID: <bug-219652-11613-o8eDELdcNN@https.bugzilla.kernel.org/>
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

Kris Karas (bugs-a21@moonlit-rail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |0f11328f2f46618c8c4734041fd
                   |                            |b2aacfa99b802

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
