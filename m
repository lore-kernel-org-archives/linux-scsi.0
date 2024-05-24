Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41D6381BB
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716555642; cv=none; b=fmcT/cDf7GlSoEyEIJ01lojN/PSXvRsY0tER3Yn0UDMnCoyy4BdqVSCFRVKDflgNs7fK4kEisTy7LlEx8/GFawHizPeAq9I3x5ZWUSoCi8AI249YcBEN3QFnCuFDLMC9eB/wp66ow8LwFowr+knW6X/6T6SF7TtyuN98Ki0HkFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716555642; c=relaxed/simple;
	bh=3Hvrvtv5oZMf3xau9nqx0pX3o0MoE/BbSyO3+CFVjZ4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XywNq9VpY9xeAFrD2wbPBIc1mp43QMW37UckANONLijIFdtVwr5BaRvkfvMFc8jLVcrkNKf+QeIpvTMLzYOYGgW1TXKbP5qVM0fnsVEaiwafbzqQKN24+EyY4ZgSpk1470i8rffdXga1DQxeKNgM54GY8BjEbD/0iSQrc+/e/vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbOY2azb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbOY2azb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DBFCC32782
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716555641;
	bh=3Hvrvtv5oZMf3xau9nqx0pX3o0MoE/BbSyO3+CFVjZ4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hbOY2azbhx/oaaHskVqQgZ5TdYmWVsLGfFSZrGnsR38hyr9Z5fvcFpKHe+t0C3iph
	 VmCx/EshDET7wEC8fkduewyqulaO2gYWVl1D+sxmAzI7tH9Bn0UIDFT3VfEoS7T2W4
	 4lHdsl1EZ4ZDC/+XiAdFsaQP0jEBz+C3AuKgfK+TQ3lglsSEISiP36swuqN7Efx1af
	 7RLNgRVD2D/fHeP6BBj9RBx9Zdb+ivtd5cTWJKE1cpKHd1uB5KQPGXTj1haFJfoJCI
	 QzwdME/cshhjOeyq1sG3UtZ9Kca4uRqwJNA95xWDmY6bOFa6GSAHAJSVd9XSOpek2H
	 cVnVnCFIvNc1Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 90FDBC53B73; Fri, 24 May 2024 13:00:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 24 May 2024 13:00:41 +0000
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
Message-ID: <bug-218866-11613-PPGaUdcLaI@https.bugzilla.kernel.org/>
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

--- Comment #5 from Marc Debruyne (marc_debruyne@telenet.be) ---
(In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
comment #3)
> Is this a regression. IOW: is this something that did not happen with say
> 6.6.y or 6.7.y? And are you using a vanilla kernel? Or something close

The Gentoo kernels are very close to a vanilla kernel.

On my Linux from Scratch on another partition on same system with a vanilla
6.4.12 kernel same is occurring.

On Ubuntu 22.04 also on same system with kernel 6.2.0-33: same

I will compile a kernel 6.6.30 and post result.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
