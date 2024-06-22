Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40A04436
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 07:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719042740; cv=none; b=iEciIfJBQBB2kBiaoFP1e+EX9UgI/ucybBeqjd9zpmhlDkPzgY2WwGcF1tfZ1lO+Lodtc4vzId/G2wxF1J0X87p/AwDNB+DTePP+CotAN9jeM2Rv/Qw5sqEcp5nEYj6wDdqOtZBI3xgsiUW+StUrO74sUSMR+a4cmed1D/6VlZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719042740; c=relaxed/simple;
	bh=NaFpvWTQkCjQdSmAfN3/y9rlnhHfWVRSPDwD0NKsXTY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ctb19Ws5Zdtp4XVm2XSulrv10WBl9e/dMG5nNdl00j2gs3OqW+US+BbrdbYjws40S4EWFDwsUuFodY006DwP52qp3xrUkpva7PK2Wq+tHcwE8rkbbJQthQKQ31+cqz6Z0+Pj8SYNU2L/3vWi/iarh1VK3upK+4TtoqKqLoNEjX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKGNYOIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKGNYOIs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB9B8C32789
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 07:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719042739;
	bh=NaFpvWTQkCjQdSmAfN3/y9rlnhHfWVRSPDwD0NKsXTY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MKGNYOIsRapIUBQQe1c3MRPEeek1LkwW0Co4faM2cNF1EMUehyqT66fD1jrA8gn54
	 KP24g5Sanql/p4MNH1qommgO06rv+nzCFyfRlJw3dNl7uPfzGyay8LmUx3Nlm/m70N
	 pdgIgOEEUIYuCEgRITXFv54qDPj6o3sNNb6UzHX+2N0jQ3iFZPMp91gaWJyQ6mgtZL
	 YRrbo/j0qSD1u1WsAA6DScoCIUZfSJq03U/nRslidDZ8C5hnL5849Mgt/EPdVeqmkX
	 5QBUuVvG3pLdGT58FWXbdk8LAkRwwAao6UnrP8dmbWerEg8VQMBHc9ectud1uNLx3o
	 +48sFPHG6I9Lg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ABC6FC53BA7; Sat, 22 Jun 2024 07:52:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Sat, 22 Jun 2024 07:52:19 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
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
Message-ID: <bug-218866-11613-4ARXwhvWK4@https.bugzilla.kernel.org/>
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

--- Comment #11 from Marc Debruyne (marc_debruyne@telenet.be) ---
(In reply to Phillip Susi from comment #9)
> This is no bug.  Fake raids are, well, fake.  The kernel sees both
> individual disks and since they are mirror images of each other, both have
> the same partitions on them.
>=20
> The dmraid utility can be used to recognize the fake raid metadata and
> configure the kernel device mapper to access the raid, and with the -Z
> switch, it will remove the partitions from the underlying individual disks
> from the kernel's view.

dmraid is not used; mdadm is used

********************

cat /proc/mdstat

--------

Personalities : [raid1] [raid6] [raid5] [raid4]=20
md125 : active raid5 sdh1[4] sdb1[2] sdi1[6] sda1[0] sdc1[1] sdf1[3]
      87890972160 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
[UUUUUU]
      bitmap: 5/131 pages [20KB], 65536KB chunk

md126 : active raid1 sde[1] sdd[0]
      975585280 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sde[1](S) sdd[0](S)
      2354608 blocks super external:ddf

unused devices: <none>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
