Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EE8944F
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719321754; cv=none; b=Wt3OdQaferBqVFAE2JdUPIw7UlMDsaT/QVERr1QjLkmWeEbZkc8aMcrDyczD3SQnOV2HWYEV6iT1D4+2e47O7hbP8Yvd0wvBIcakGxWcTWn6AKJ7Xvgbcl+5oMsx+9EYeesiK53820DLXwafejv8o9diH8K+1jIfDxS2n40k83I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719321754; c=relaxed/simple;
	bh=QDuU07QcMAF7nkpprKkno0VUfJlkE/i4u3ct1aCo76I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rQaso1At0hi/oLbTXsnLusDwKf9WZs7eUbg8cq/Mhb8HsRMWA+FmdOO9bdM0gwEYYLhFqqR2Ql3t3Z5PdZhlNG3jhcZMZxxKlXdY1sKv4xQpoWcCtZ2M1d9sPJ+4q3z4Mr5UrQbNE9VOJnrrSTIUBCtyacRP5txZC/u0ZFdYDLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q690VOcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q690VOcy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87398C32786
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719321753;
	bh=QDuU07QcMAF7nkpprKkno0VUfJlkE/i4u3ct1aCo76I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q690VOcy+PVWNVEO3KOyU/I2JWqhINngfLAiiEpk384ZBVJLBDyiCdYTSil8yoCCH
	 86EY+CWk+J0s5cbg2eTpsgC4SIKu/zg5PrergoD9HkY/KDrAWNo+XWJ5/WoKy/Td2N
	 z2P7JcNn4gq59giT7F9Ud+RI/8qwo73TdYODBZPaQsC1UfDTSEJMsa4mC/9MDe5I94
	 wFSFZycHUiGiYawysRtvJOh3WuJjGGv1tw0vZaiD2NW07VMBims7QmT7Sy+HQYcYhh
	 fLPVuEOK3WmNB7MT/z28QK8ygIUZEdCL4ACfpyxydP1u/oKclMXMZXqRo85oWWEdti
	 +7pAIg5je6lqA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 787E4C433E5; Tue, 25 Jun 2024 13:22:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Tue, 25 Jun 2024 13:22:33 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218866-11613-Gm63kHpeCq@https.bugzilla.kernel.org/>
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

Marc Debruyne (marc_debruyne@telenet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|ANSWERED                    |---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
