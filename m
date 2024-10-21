Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982151E04AB
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729551384; cv=none; b=eaUHDPDrBiSMZtM6hnLi2xagHFLXFM9C4J6tde5nTQemXWy5JD4git2fbd2xnBKhZjewgKRUoQDZ3GATJJAN68LNmenTUl1XK29k3wq6vI40kwqes43xsRU2MGW5N4I8n5ICph6iPXBGpeTwuiW+V9Vj0rO3R+PmaHalBEhNg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729551384; c=relaxed/simple;
	bh=1fIseu5js0ZKnyssQEspCpBNzNZXVtSQ5ri1tlpsErU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LG1zL1BkAO4MOidNysAdUDlM8TD0Kj+x+HglOBpPlFj5mu24pDcYs7ZZWxu1vNuON8sh/2rnjoWbXnfjONj6yQEWArGJ4W+a9uoI+svtyvBB37WJfgFLf77CHpLXt7kK1BQylZXtJsq5VAdKmTABXExrJKYxhXKvGWfXjhZvFBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoVT3yjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoVT3yjs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EB44C4CEEF
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 22:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729551384;
	bh=1fIseu5js0ZKnyssQEspCpBNzNZXVtSQ5ri1tlpsErU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JoVT3yjskjl5o4BBKMxR+8CBqmhl53cRL7iueNzmVy5poBtwmmLZ78m1jLjyFD4f+
	 vLtqezfZaqZVd37LxOcJtEXmLOd/rqdgRQuXPEzFyy4v5G4MrqZZgkYfvfU7U+6Hqw
	 3u7Em4l7GYjb+mBkAQCjGuc8fRF9KNfPqEGXO4lqLFS1Ty9vH0JMnelG07B91/XcN1
	 02ZjoRYQgAd4drDqggXk6XNlU2WIPpdMPOtkzvYvXLyA0o3WmLtSk8As7xNePddfkf
	 d7i4VSZiMf3OLlwikHOHGw12thKnXsSdlEepbxESWIX/9WxTzAWzM6R90hSqm6y3RJ
	 VBrJ4xDVrPA4A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1A688C53BC5; Mon, 21 Oct 2024 22:56:24 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 21 Oct 2024 22:56:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-aefaJsKIZy@https.bugzilla.kernel.org/>
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

--- Comment #66 from Sagar (sagar.biradar@microchip.com) ---
Hi Maxim, Thorsten,

Currently I am investigating this issue.
I do not have a definite timeline on the fix, but I will post an update here
once I am certain of the solution and the testing timeline.

Thanks
Sagar

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
