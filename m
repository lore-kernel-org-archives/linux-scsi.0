Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F5814B960
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 10:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726914964; cv=none; b=lTwKgKdH6COyqfdWInUFv2lhjesp+dAXhvAk9zIi0cnWRe44qoPCydYO2HAvioR6isr82vXF+I5W1dxcQPjuby1lgdZCX2v4YAwNyE9xGqCG8YSG4REdLg87qFbDwOn+gsIpt8SJamB2UJ+dSz/oZkBOr3vdS/pgCW3KV/Pza4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726914964; c=relaxed/simple;
	bh=Ur85nBdR8plwf3/ZzGozm6oITOPryAgM+W3CFgABV3Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FKyaA97zz9sLIuVnUThnfG0qo4ONKqgfk1qqStRZ7ge02/YXyuEueIeC+KY1F/4g1OMNvImxyTu0yNiUvMCZNBRmK0H6JbfAmrIjvdt6hUzHTnp5v2ukiSQ8XXPcYSGHZEnHnGYhauvHhe/WWp+OCJLg3QBj/DLo/+R32j6t8fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/3HAbKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/3HAbKY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0498C4CECE
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 10:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726914963;
	bh=Ur85nBdR8plwf3/ZzGozm6oITOPryAgM+W3CFgABV3Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=R/3HAbKYYYqz8PXB5OEAymIr4Npau7zyabLFi/OvLFS5iaOpbTMrzJDEyOpIPDPmZ
	 7DXnu3l50OT56prl+oxyzxiCvlzp2VGi3o1LBmbPhEMc8/1HLvg1r1cJAd8ibtt84d
	 eFO7nm+BihkGB3ixZiGvig+8U+ufm7MCqSJROEKIRwpE1qsCnkOjC1bCNHOgfleY2T
	 GyDg9TJ9p30nj/maB9Xw5mfJ5WDhiXQH3P2ydTsmkogxtd5x6mymq7BdsoUCPzMSFy
	 CVruNnZI4rMY2rliLh4mW1LbbH1KDySGWKuHUdRZlY8IK9yrv05l+ndRbKvzJ00GjC
	 MRrrUtBiSLOmg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CFC1EC53BB8; Sat, 21 Sep 2024 10:36:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 10:36:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linuxcdeveloper@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219296-11613-UOrgtSOPrp@https.bugzilla.kernel.org/>
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

--- Comment #6 from linuxcdeveloper@gmail.com ---
@Artem: Oops, I forgot to mention in previous comments that I've already tr=
ied
also 6.10 but still the issue occurs.

Today I tried also some newer ones:
- 6.11.0 (sha: 98f7e32f20d28ec452afb208f9cffc08448a2652)
- master (sha: de848da12f752170c2ebe114804a985314fd5a6a)

but unfortunately the HDD power cycle is happening.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
