Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC3210E7
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jul 2024 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720360515; cv=none; b=W0tuVCYno8bGprqRHUyRnZ5kjNTeRrly32xEQecTUT5M/zpTm8T7GCl5+xVmm9sDVHyKcai+UBEwcGxyV4rtV0w6U3yWR4joMSzJqAXazqs4QrZiZFM7hj1KFmdRJEHSuWV29dE0UgwNX5Ywe6Ay98JHTrDuE9IOHPNkLI56E+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720360515; c=relaxed/simple;
	bh=pQfGno24Ga1MJPQ4Q/cL5gOPu2oDpQ73G6D9WUL4nKQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KnBm/u0CJIBNoQ8edHzNy6akBF2RzCt6q70Jf3Znb68ZkfkMlDB0eOSqgFABoExJU+18v5fi2wWiz51r771XdRRDv7DH3hmVnMvMFdi0IgP4cAYAbqJBlfKhtvfhLiuLs2GGsG0MBG9lRWsIaKmpcUtbnYI7V1Ry7IRhHui8uOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2GOMS6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2GOMS6w"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2091AC4AF12
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jul 2024 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720360515;
	bh=pQfGno24Ga1MJPQ4Q/cL5gOPu2oDpQ73G6D9WUL4nKQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j2GOMS6whawYccW1Jg7iUn13ZuHH0NyIOGouEpyH5nMgd1b1OcN9CyxAbzimN1c0W
	 SyOW2eKr/dhoOiAE/dwmQGpC/+avOHllDVmNDx+FtjPvB5aKre5bdffOVbXX0Ufmt5
	 orFw2E/xA3gG05KdUgPYxtn3k/yRpbPG5wlcxe/6pmvciNib6xFNc0r9GHNfccLwWa
	 RwBV8MvVoIBY1GJ8NkSP30Td4i/Ch8kSac4uOaGQ8mbV4AKNuooTmOvsiTdXB2zWy3
	 QxxgV4+qkmb9ajuTKq7NU7Bf37MI4NOwmBk6GdOM6mEO8Tbct7KdxZIHbnDx2vpB/6
	 Y2r/D8crpQKGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1A14FC53BB8; Sun,  7 Jul 2024 13:55:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Sun, 07 Jul 2024 13:55:14 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xagal46449@cartep.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-MCaqIubvv6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Earl McConnell (xagal46449@cartep.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xagal46449@cartep.com

--- Comment #14 from Earl McConnell (xagal46449@cartep.com) ---
The issue is still reproducible with the Linus kernel as it stands, however=
 it
is no longer reproducible with the fixes I have queued in my tree.
Specifically:

d0e36a62bd4c "quota: correct error number in free_dqentry()".
9bf3d2033129 "quota: check block number when reading the block in quota fil=
e".
Can be found at
https://googleprojectzero.blogspot.com/2017/04/over-air-exploiting-broadcom=
s-wi-fi_4.html
https://geometrydashworld.net=20

Alludes to this entry on Bugzilla. Perhaps the following changes to
nvme_dev_ioctl will strengthen the driver.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
