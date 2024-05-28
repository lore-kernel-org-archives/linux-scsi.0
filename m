Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDDE175AB
	for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716920940; cv=none; b=VK0Mp7VXv9MODgEk1zed/EkeHnUV2dktqxUThxxczI5Mno/Ekc3gELaMv5RYPs5hUduo/6dA+9hS+LYncH563Nq2iBtbK5ZsuxVpHOkUwzBKuL/OeiAzqNJJmwpt23Abde2G9djkOIpoIR1wfuh7jOexzdtyYCnSx8vCXal7kwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716920940; c=relaxed/simple;
	bh=S1nu9/sJymZS/jcQ81Os6n8mHhUka48MMic4ClOLC2w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o2H2ZZMft+qM3SMZu4smPuOxfNcl84jfBbVG8BFY/w6EQ2MBOZ9hj+WBbawSLRH5h2KRMB+lOgpTC58J3NNMuexK8AYDVV7HfrkiW10A6+4Bfdpssngt11tMQGaUt277/16rw0vH1JR1WyjFNBuufdgCml0kvEUiTX8oQDrZwYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlJmYqIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlJmYqIj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4026AC4AF07
	for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716920940;
	bh=S1nu9/sJymZS/jcQ81Os6n8mHhUka48MMic4ClOLC2w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GlJmYqIjA3pMR4fFyEr+2hGAYLAGQyHcBKkxW9CZ5EM1s8YvGpV5Vd9a29aP0vIJK
	 WoQH6XRvEBMnhYmMp+CaC7mKGjgQXNznLLnInEafOeCq9Rv/XtSMYMOvES8X/pq7Jw
	 pBgR3jv/ytyR5uBVvLYSG18TMzEdFJRsxCxcV2LuagCTSTswqCFzGktJLZVGMGZ8dJ
	 oSkc1mNIJUp02GHYGiCENx8qB0lnj1ICotPECf2GVR8m6/iGMgEW1buSq5hvUxB0T4
	 dFzd0BYrIjxrDMrpZUip8aFJ1H3f4vuU5RZkhAJHGar9WBTp3FSkNluaKC8497Usl6
	 Ct3Lq/RwK1DjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2D982C53B7F; Tue, 28 May 2024 18:29:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Tue, 28 May 2024 18:28:59 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: phill@thesusis.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218866-11613-UAbV25GRRO@https.bugzilla.kernel.org/>
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

Phillip Susi (phill@thesusis.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |phill@thesusis.net

--- Comment #9 from Phillip Susi (phill@thesusis.net) ---
This is no bug.  Fake raids are, well, fake.  The kernel sees both individu=
al
disks and since they are mirror images of each other, both have the same
partitions on them.

The dmraid utility can be used to recognize the fake raid metadata and
configure the kernel device mapper to access the raid, and with the -Z swit=
ch,
it will remove the partitions from the underlying individual disks from the
kernel's view.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
