Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A11EC2
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699826; cv=none; b=T9kHamsNs0ozkRqUzyofIZjmnOLqPhd3RCPGRhd9kfInLDDqAgQ+JuFowcJoVniat28pVuOwbOhOanFP6kmcbzMPlEzagHETMgI/2OEHDS08M9aJx738BewJp+6aMqgy3FlY2HW4N0f04S2yRQqKjwfT+VFik4Cyuiq7R8bPa4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699826; c=relaxed/simple;
	bh=BwQmvcshaG7PJ7zswmLAVuFza8sMG1S4gMHgFzA1gZY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GLApwp+NFaUMDDHsnl8NnzFeFgWrotPOcqJimTs4LTfcqgXNKkc93sZEjUKUVGVBfTplx9BM+bDXbttZc9tJ2mP142SQCZziRyCM5eSGwVDR7J+NBPnWDtwiy2gql4EuwFi72Fu21l+YdXVo07NH+KhTgXJf81dPQBhGftEyuzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6XNiUvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6XNiUvS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5045C4AF0E
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721699825;
	bh=BwQmvcshaG7PJ7zswmLAVuFza8sMG1S4gMHgFzA1gZY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=W6XNiUvSoi6Mx3fGrKolwy3grqwNi8oCFRAEsT2mM7Aewt8D08S0UYleZUTSUH+iH
	 BPC2tY+/dhIjXMjePxoi8jwz8N1ABldifRkyg1N5qKuhkgwch3Z9mXTF2B4cCkDH30
	 fvR4QNh+x0zdnPgjmujoBhNrRNHvAU6OKidaZPqkdFlzcigRJ0brOQakuVc8g85cNe
	 VqGAb/O1Bhu/dMe5ZVrUOXpC0Nc7HiDbBn9wrC2IvjVPzJnXYN2HP0YmOhPiapmQW8
	 zM1lncZWJSdv2NBo7A8d6cSv6EKvpDc2AVD79eTRRCW+qJjFPuHD3aYEMy39e2u1yP
	 a01OV4Fqq78xg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CAFF3C433E5; Tue, 23 Jul 2024 01:57:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Tue, 23 Jul 2024 01:57:05 +0000
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
Message-ID: <bug-219027-11613-LLWhFYpd9s@https.bugzilla.kernel.org/>
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

--- Comment #3 from LXY (983292588@qq.com) ---
(In reply to Martin K. Petersen from comment #1)
> Due to some legacy devices hanging when probing for non-existent pages the
> Linux USB storage driver opts out of consulting the Block Limits VPD.
>=20
> I suggest you create a udev rule to override
> /sys/block/sdN/queue/max_sectors_kb.

Thanks for your reply.


I've tried creating udev rules and it works. But whenever I use my USB stor=
age
device on a new PC, I find it a little inconvenient to create rules.


So I'm trying to find a way to get Linux PC consulting the Block Limits VPD=
. Do
you mean that for all Linux USB storage drivers, Linux hosts will not consu=
lt
the Block Limits VPD?


I actually have the firmware source code for my USB storage device, and I c=
an
make some changes I want. For example, change the VPD page it supports. Do =
you
think it will work?


Best wishes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
