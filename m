Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD19D273D6F
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756272930; cv=none; b=Z8+pN1wCB/ISQNriC592DgKDo7wNEyj/XpbNde5MXb8jWHqPHJZyyt6WZ49C/puchvr41aO7sIcuSOn9w+g8rIWR5y6hPypVVrnOe3Ej08K6OPU14SdUME2zNkQxkgV5hbT8o1BA33fIkkHLliXfr+s+l3SarsEchNpv6KwPlJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756272930; c=relaxed/simple;
	bh=g2wvWzSaW7A/sU/CKz3XUb6+yPwiJdVg5rsYWZTswJM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZrX5h6PQ5J11FLSO8+qA3snDsLidBKJyUwfbC9hWTfMF9wgzzlf7qF3zhAneE14ujV6qrSV/3CNpBdb4cfQ0zzazOBbsdTt+o4yXEv8wGpUyt2dvFPbVhfa+QrDCM9coQQl0QJB8vcTSxMpP/KVl42VBJIp3FaeMXwJn74Uw6Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RObSAdWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RObSAdWv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45494C116C6
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756272929;
	bh=g2wvWzSaW7A/sU/CKz3XUb6+yPwiJdVg5rsYWZTswJM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RObSAdWvqUTru2oa78oUVqd3VzpyGieKMuYCi9mHo9NphNVdzJ/p5QGoYYsT7SSDo
	 GhFoIQDZrXjQI3mhRIBNojie3Ha41zq5NEPcGnhkqfFgCDIcAjsS8a8/TnCgkiAsmN
	 /XVPMzuMbecZa4xOFW2iAsnatLT7V0ZKEwGRWdI2Y6dn/qGYe/lvc7S6C4fsaYj6FV
	 0oCNUg1fMYUZqOYeMfleiSG+fGUW8FNBksPSUNRGh5Le7dX4OdRJ6wcZLdlIkdVj6B
	 QFSkBiWLuWCNij7yMzs0mjybk6PR1eLeeJt6Fgeq1enFQ2YrQTGA2k33bou176MB/O
	 wqOuf15iRtT5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3C902C53BBF; Wed, 27 Aug 2025 05:35:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220504] [BUG] aacraid: DMA mapping leak in aac_send_raw_srb()
 causes eventual -ENOMEM failure
Date: Wed, 27 Aug 2025 05:35:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: shobu@ume2001.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220504-11613-4uPgJU7pRV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220504-11613@https.bugzilla.kernel.org/>
References: <bug-220504-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220504

--- Comment #1 from UMEMURA Shobu (shobu@ume2001.com) ---
Created attachment 308557
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308557&action=3Dedit
script for accelerated test

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
