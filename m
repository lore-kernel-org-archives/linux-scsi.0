Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E524A6885
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790001503; cv=none; b=UGJXBHRQZchr9L3prWaTg4l6cnpJqxNqQfX1xtnB5CqnKouJsbC9eY6stP2pTsjNAoMLtEQKeUKSOy64MTi3jMu5Ikz9BnavQUc9N8lRk4pglnba7HhuBqjXGB8FrEf59XrC5qvvBfjUYayzadBAAi9gd0OfWcAtjEcJTKvxStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790001503; c=relaxed/simple;
	bh=UwD2ayMM/4zZurIIxUjhNY/81VC/tfcLG03zM/jIEBM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T818YkQAS/vI9VP1fBMWrpgLmSAcnzfsbUsGcLvZYERIN9r+Jy6QSVbs72+Ceqe9GUQzVyywEO4/6NJHC2Y+PRbw+SfLcucyN8ODQpYccSaU82gvTnZspbNsYEDlMmP+55RMHpbDO4VgWrh0zmol/VLzrqGkqERFoo5E5AzNhw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miMVH7UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miMVH7UI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3272C2BCB3
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790001503;
	bh=UwD2ayMM/4zZurIIxUjhNY/81VC/tfcLG03zM/jIEBM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=miMVH7UILo6UviPxHaNWeKpAz1sAB58PFG0L+cSp19JbShV8R9N9XF1tPGvGHCTlT
	 M5l5qkzVblr5mVuDCezLD9rOULglVWFKUSxLXJMeQngdJ+J+YGN9r+wPFkkqQ/CVMO
	 pfcGFhItlXpBrIQ934Fy0wQ0CTr/05BDep0+5aTfj7IC3XACNmpWGMzqLn10w/mBKz
	 l412cwhz3i+fqEoxXI+9JJeFSZKfl6Jk0o08ogruaKPV8dgrjC6Wh2BUUVl4dkZ7Su
	 s6GqpmDSoKCa6mj6SesHN1BtWOY3S2PHoCqHLAOODx3GYNMtELaiFAqg1IJI2EeKm2
	 29+wHEWuRWYdQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C6623C433E1; Mon, 21 Sep 2026 14:38:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 21 Sep 2026 14:38:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: longdescs.isprivate
Message-ID: <bug-198923-11613-hY5jCKwkTJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Comment #22 is|0                           |1
            private|                            |
     Comment #23 is|0                           |1
            private|                            |

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
