Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686611FC7CF
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729002293; cv=none; b=RwWgRTSj/SlF6m8BL9oXKp1fhqMzYnQCmD70kAAhytZisulOLPdv71nuyzzpVJyaYu/MxnXcTSutnh7VPqAkZiliLJzzEdN8dDhzsn+GjhMOv92HNUiicrtvcogdH8SLg4aF5tTPtrPsviveN/DrmKBFz5FsDhcCqkPMpk8/ybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729002293; c=relaxed/simple;
	bh=wEPFlPRx/W5Xg4X036d6je2M3j4GR5MmKPobKmWFH/8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AaqwakKfJRsjQZkVjAoalp+XAZK9S1twuD1lR1G4BqF8eoKIkNEGJ8kk2dzFp/fyyjuQhvA4durcI6/dYYxyFSGH+hDdXoWhaAoKxI+Y+2C1rqbFdCZd92nM7VEB3acdVQWNVs4uhRJBm+qzQ8A4ZJcdw/wnLKlVEJT7cKz76dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wx2aqmBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wx2aqmBT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01709C4CED0
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729002293;
	bh=wEPFlPRx/W5Xg4X036d6je2M3j4GR5MmKPobKmWFH/8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Wx2aqmBTxg3HzwQQVJ+zmVdJnCQlBDvCCIjMs5V2V5mYkFD0jBr3plZw4RNsmaC3L
	 04fnqOVfP0BRdPlOilLJcd4Ww6tolsFxqn8uxhfyGmxJdYvrEkJ++X6AZnfbj/dOPW
	 HZpVH4HL8ZO1pwGDbFIt7Jg0AxzrZNy8kfaOEi2wsq70os4FhlQHVxaUgztEN0VMAP
	 Dr9KAATYMfjPAZ7zqe6MWNedIGYI49zDDPUtuVrzFl2h3hpitVrcdW8CvMkXFhVDQl
	 guC/mS+CHweGRZlU13rdAiEppdcOJ0NPnv7AXxhPnl27O39mLHV+X67BtpmAC0FpES
	 +l7aFE+k+0scA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E5FAEC53BCA; Tue, 15 Oct 2024 14:24:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Tue, 15 Oct 2024 14:24:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linuxcdeveloper@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219296-11613-B6eKgUaJS1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219296-11613@https.bugzilla.kernel.org/>
References: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296

linuxcdeveloper@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #7 from linuxcdeveloper@gmail.com ---
The issue has been fixed in following commit:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dv6.12-rc3&id=3Da38719e3157118428e34fbd45b0d0707a5877784

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
