Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA76B126F3D
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 13:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716556429; cv=none; b=cvSTRfjJvM4HqH55KRgvB3wB4LWgzY+dtbgOlZ8fW6jEFbL9ednJBoCbYrL2xuG1mYQonmy6JWltjp/gcOgaTthpUqmbKw441LBopO5RY2z0tJv8CZ0ZFflHbfrN6KlET0/waIjY075zRB05fWST9mSXxGDJOiQ0pKE6CTLCJAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716556429; c=relaxed/simple;
	bh=Spotd7VUV3LOJWBXqXST+L3OG4IHY4VSxIbbI8wsRQw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F0sUPWZTXBjO4OxRvTpuCHA+LT0wp1iEugyohLsI/Sgq1pAJNS4ORHMcLMh+2xjeX6z3/G5FpeLh6EL8ey7maWsWsQvLWS+g2ZiucY2R+E6eksjxHmpSOAEwKszyJz7Vgadvv6Z6+/3soqlxApjEMR4BGfxa8114hbEEGAyDkZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hz17h9Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hz17h9Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D510C3277B
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716556429;
	bh=Spotd7VUV3LOJWBXqXST+L3OG4IHY4VSxIbbI8wsRQw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hz17h9YdHbqfjNZQTbdYLof2C84xlQ0F0P9ZVw6f0AY8cEEOvT88qc/eNyh0xAFPr
	 ZLZvScRjxT73rNAbiITLBBGK4QUntldycdg5NhMJEm3/tXM4/6x1wJEKb7CjnE33sd
	 eT+MmGSPBJ54K0uqBA8RCPhBc7H2pIkAqukl/S2j/s6RznoIxcxKvILvCGvFp+Xsgk
	 plDawGgwCQDmLhKK/Zdd8TEBASci4BbKZPGRkZfW3rKUReQxX7zoF0z8hZX0+6pT5o
	 6it9C/+itkZc0Sdj5IKIlKl57flrWb0dlQxO8ugv7QOoFaVjOLwsiuxfXrjGRQ9j7D
	 o7JtKIxUeN7xA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 42556C53BB0; Fri, 24 May 2024 13:13:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 24 May 2024 13:13:48 +0000
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
Message-ID: <bug-218866-11613-QXZUURJSZ9@https.bugzilla.kernel.org/>
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

--- Comment #6 from Marc Debruyne (marc_debruyne@telenet.be) ---
(In reply to Martin K. Petersen from comment #4)
> Looks like the partition table is invalid:
>=20
> [    3.037149] GPT:Primary header thinks Alt. header is not at the end of
> the disk.
> [    3.037151] GPT:1951170559 !=3D 1953525167
> [    3.037153] GPT:Alternate GPT header not at the end of the disk.
> [    3.037154] GPT:1951170559 !=3D 1953525167
> [    3.037156] GPT: Use GNU Parted to correct GPT errors.
> [    3.037168]  sdd: sdd1 sdd2 sdd3 sdd4 sdd5 sdd6 sdd7 sdd8 sdd9 sdd10
> sdd11 sdd12 sdd13 sdd14 sdd15 sdd16 sdd17 sdd18 sdd19 sdd20
> [    3.037441] GPT:Primary header thinks Alt. header is not at the end of
> the disk.
> [    3.037443] GPT:1951170559 !=3D 1953525167
> [    3.037445] GPT:Alternate GPT header not at the end of the disk.
> [    3.037446] GPT:1951170559 !=3D 1953525167
> [    3.037448] GPT: Use GNU Parted to correct GPT errors.
> [    3.037459]  sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10
> sde11 sde12 sde13 sde14 sde15 sde16 sde17 sde18 sde19 sde20

/dev/ssd and /dev/sde are members of a raid 1 array.
This array is a fake raid. It's a LSI Software RAID witch is standard avail=
able
on the ASUS Z10PE-D16 WS motherboard. The firmware uses the end part of the
disk.

Note that the partitions 1 to 15 do not have this problem.
The partitions 16 to 20 contain a windows 11 system and 2 LFS systems which=
 are
fully operational. (In Windows only the raid partitions are visible).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
