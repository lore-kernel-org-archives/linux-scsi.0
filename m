Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32831BD519
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 23:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735859249; cv=none; b=rFPxiPKbdM5GBEmttpzyNAn8H/c4Qqta04p2IOUXM5t+nphXjA3mTzw+k2Y53ATmX1CSjECxfO1MZpvq2HPo935p756We9+aDdBQYHZUBRd9PFqBYTQdQooXu8u9R3zACxdP54olt0HLJR6YkduQmwzKcEX77F5TUAo3+tj0iG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735859249; c=relaxed/simple;
	bh=Dz85it6wE5OeHN4kRN90bQDQOtPn1nAa/vW0LCZMirc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=diT/NILWwuYBdvQwWCp/RE84rYDiu1Jtp/Y+SAUWHP2GYXVkxsywFsw4OApARj2JgT4pmVX9SC23fuaBkUthDyNI/DqNQ7lWnE7awEodO45MCNP2jgp/w9DubRSkyPsT/URS/ax8SZlnRN0KlqnHmnFgFF+ewhJBGzd0d3dVAYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1kX+KNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1kX+KNT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BA06C4CEDD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735859248;
	bh=Dz85it6wE5OeHN4kRN90bQDQOtPn1nAa/vW0LCZMirc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L1kX+KNTa/cT7sotzbtI27twGQyb0QOdp5mlBSa7W3tI0XS3tp8ipQOSDxd/OdLin
	 ID69GNUzRkUF0DE+gAQ/tL23ncYn9fyYWGk/kw0+F+E4ZmaEzCxhDrhwST8GBgOjZP
	 mbCm6Gi93tlEPkocJkMbXCakwMMVwdXFk1reitYCEh3daxZB5UwH4e/5vlFFktQNyG
	 syBdImz0bFVu95waG4tIomyNLkcaMY8TzNN/hEyQBepTiWPPM/SJ9lRwniZ2fb0wq+
	 f8v+sp2XC/kjuaw+yehFcuiFuonRcXIE4PGHje5D+lLfTMNQ9QthBbLAOPIxKvnfMW
	 tRtKGX4+2wfEg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5EBC9C41614; Thu,  2 Jan 2025 23:07:28 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 23:07:28 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mkp@mkp.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219652-11613-dS835jkQNg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
References: <bug-219652-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

Martin K. Petersen (mkp@mkp.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #5 from Martin K. Petersen (mkp@mkp.net) ---
Also, please provide the output of:

# sg_readcap --hex /dev/sdb
# sg_readcap --hex --16 /dev/sdb

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
