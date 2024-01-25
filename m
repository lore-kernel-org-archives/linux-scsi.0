Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C63913AA25
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706207410; cv=none; b=E/QAS6krokl+vPxzTt0nUDllOg+n1KXcSOhH4BpuzeCEace8h494rTgqdKGhn0jDwa7ooyhK3OnNeqW7I7svPHugvASm8BPNdumYTT/1uVBdUgC0K6xu2hLPB5JkcNS2YpfDQgFng1/Wzp7woWexwi4ISnAl2+j64F7Q70vjHpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706207410; c=relaxed/simple;
	bh=Df8gTzkQFyXMHwuu4mK1dT5q6aM7dRG9M4q6o50agOk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jHfPbp0827I0++R2JRqSxLu35NBxYMEFriA+SZWCKTIS9DWptTpeQZVqeDFB40JlNGoJZtI8DtWhT93aONsjQ08C4o56cpAtW4YXALUDuFJkRtkbUoHz47goMXm+WfKZpmf1rRtZvJoH0ZK2RDtAacnx+3Z820theipAHVu/SdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2WgbcTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2WgbcTY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D808BC43142
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706207409;
	bh=Df8gTzkQFyXMHwuu4mK1dT5q6aM7dRG9M4q6o50agOk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L2WgbcTYdk/tER8pgL+8v5ggqJakiszL7C+aMONSKghG9L07CXQ5aQDethGO1i5KD
	 2GenHKuw50Rm20N6RQ/5/Vc/4WRvyAsPvuO36nYp627u6yXHMGQ/rJ4rl0VEZ+OglS
	 LHvK+30n17RCtehCsedpDp4FDq1xmw9TY5O3M2pr4hgZeSa56dVh8l3A9DT3GqFMLA
	 kuwTz7iwUwWQEuuKXW79dLX9mtc0rbwB1cZenFeMO6Ts5DaH/wyzkcxb9o4i6Ow3KZ
	 MgdGJUUirHBOmLdTGo19tFe8GQAhdVAzMxQTqvO9w9BTUdByL8kr4LZxPQWBg7P45U
	 BGizX7JoRYmKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C9CEBC53BD2; Thu, 25 Jan 2024 18:30:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 25 Jan 2024 18:30:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ro_ux@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-PgAQIicgx7@https.bugzilla.kernel.org/>
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

Netix (ro_ux@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ro_ux@hotmail.com

--- Comment #60 from Netix (ro_ux@hotmail.com) ---
I had the same issue and I've put my x16 pcie slot in x8 and it seems to ha=
ve
considerably reduce the occurence I had while running on unRAID 6.12.6.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
