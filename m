Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0008DE578
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 07:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2G6rxiG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 657FEC433CA
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 07:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702883652;
	bh=iZNvdx8VjL3YuaVpOKhD6zJqCfTgKeRlAo8oAKGZs98=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O2G6rxiGj6zHjDsnKSQJ7mHbKw8S/j/Qb22jxv7G3wrTkWTy2gursmLIACNPr7Nij
	 ftmgzmgoNPhpreqt/8yxMpxOFUkrJLdAmvJ9nU5qnYCylnLOztkKfqZ0dCRdZ8zRIG
	 VITSKBAMeFtLVevgWiMwY3SblKTIkvAVMBAkOmJLXHIadnJmOKr1w5YthAMe/Fjv5p
	 SdETN+V7XY/wpo5LeT8r+xGXZOErtahYPRpIvyMyM/2F37cMxO3rm1Kxq6SEZnrp7E
	 6ERj5n29Dv2LTE74djlAQNAIkIv50K3ZDfEbI7h7vrrwMfX9d891y7e6AqKkPfGJpJ
	 KX7LEBMcWkc4A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5816DC53BD1; Mon, 18 Dec 2023 07:14:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 18 Dec 2023 07:14:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: amigo.elite@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-nHox8evNBl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #51 from Vladimir (amigo.elite@gmail.com) ---
Hi,

I was able to bisect this issue down to
https://github.com/torvalds/linux/commit/9dc704dcc09eae7d21b5da0615eb2ed792=
78f63e

I'm using Adaptec RAID 8405 and 6.1.68 kernel with this applied in reverse =
and
everything went back to normal.

I hope this patch could be reverted in 6.1.x and mainline.

Cheers

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
