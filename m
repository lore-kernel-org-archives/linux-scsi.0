Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB0D28E3E
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081544; cv=none; b=sdBkck8+gmpdSlcIOZxzbHvB/wv5t7QqE1rQEtaNe5z8/Rl6zKNGI4lQMQ8MwemsWoPhAUUpkIKBerU3ho21w6jqDnZ+VKu1yfLGVnZUdfhXgoSOi40QE1GUpZ2SUacQGQnzgFP6mX1D9UWZh+oqeStSyBre4G53LpmNs3r/hts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081544; c=relaxed/simple;
	bh=uD4XN3B3lOGzAWk0bpL3bBsh07nMv4V/vbHgANAq8XU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WwuQsmYPUDdpr5wfjVDvsr9kWC2w/QbW54yokPouo5oG3K9/8AzY4MA6+YKk5BCstcQQOAamCLAlXUnXZR9tO7xgAn79QLAYkL+J9w1aYws2xRdpbHI91hoNcSp2fnyLfdC3ShCDQ2JjSrn6BXB7gWpetWTvl0wYxf+/5/IQygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfAmNKbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfAmNKbS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3671CC43399
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707081544;
	bh=uD4XN3B3lOGzAWk0bpL3bBsh07nMv4V/vbHgANAq8XU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pfAmNKbSvlqc81Fh3gALWOymTdN1jr3UWz/mZEX1fO5Cam/7NQJPLGmRJ4YQ6GhzX
	 /TS3edzIs3lPGM2zvAK7el0tFDv+9Gdw7WhWLr/7ToXQ54WrY64c4RZVv67cjWnjNH
	 76tp3zoSOE2RDdpsevxXAxK2/d6RRYBD1CKqvhZ51ZRo0N9ClkpnVhuQSo87wd1+LO
	 Us8kH5AaUYSHZXml4SiRIKPubvIP+UVtn85dvDnA9mcblAPPuO/pGSW+zNO+7Nqddc
	 I+llVzyXhvaURD0SZXBfPB2Ip4eeOWCs6XEet8C1gzgJLdVysfnrWowLtPpRXEzWU6
	 ffAOlO5AqbVsA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1B58FC53BD2; Sun,  4 Feb 2024 21:19:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date: Sun, 04 Feb 2024 21:19:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgperkow@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-214967-11613-u9W52KklEY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

Matthew Perkowski (mgperkow@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
