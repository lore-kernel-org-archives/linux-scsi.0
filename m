Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCF06FBF
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900532; cv=none; b=jZu0Y5m4Xqh7PwqnC2cie0Jf7UY11PqzXaR1FUXHEK6JP4+pwzLInzD+SnhRE+Eyjr+s0bJHoqoTKi8pd0U1D0kEEGgHITWmCHY4XVj4SVbxLm4FrAhnllyWRALrBuvR5HyyVT8PDAZrnEyl54Qw5RzNiuWMH78SPYKodKu1m+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900532; c=relaxed/simple;
	bh=37q1s/V8mh3MzNOyGGG1XdMC892g1dP2UfLuUnXmwvE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GBXhamWhnk/INxoC6bGz7Q/mFXJ2fsdVRF1DNUSiI4J6EReeKqs29qmZEOCE5qbmbqP4BL2/nOXROUfE+zXA6uK2vy8uGXwrv/SJ+a7Nmn4fxXK4GW5HIvr5y/zp6/QLJuThasHaPFI3ZBuA4KN/I1AE2CEUkxoLSDdCps/Q11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ET3PgdF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ET3PgdF3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7DD8C4CEC2
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726900531;
	bh=37q1s/V8mh3MzNOyGGG1XdMC892g1dP2UfLuUnXmwvE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ET3PgdF3vQy94vnyPegIk2/I3fela8TFeiuaeDtnkFzGkMpAjZ5jU16MfdDdx7XxS
	 MCSZLXhzQkpcwoJA9aV9L0ESer49YNd0jC3ceq5eIO2e18rPrgMDpRztWg0H+GrJH/
	 X15KfDYyzLVyB1UxHXcFYOgTQreyuXqBpYCZwR77eP5Exl6kF38MZmL+b+grrJV6Z6
	 MecrWm3L5cKBZRK63iqBzFy4pvR+RB50EAOjjOjq6BbcB0oT6kWHVEXFRYd3cEBqkl
	 TWJwgvXMQt8M6VaPPQ2OMjuzUk/mIkTTkZIfZFYPkAimJFim/Ph6l8dGG8PZfWM1MS
	 0/2GLgEdGIV8g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DA767C53BC5; Sat, 21 Sep 2024 06:35:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 06:35:31 +0000
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
Message-ID: <bug-219296-11613-1RuseKfGdk@https.bugzilla.kernel.org/>
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

--- Comment #3 from linuxcdeveloper@gmail.com ---
I attached 2 dmesg logs:

1. https://bugzilla.kernel.org/attachment.cgi?id=3D306906
2. https://bugzilla.kernel.org/attachment.cgi?id=3D306907

and the first one is the dmesg from first bad commit and the second one is =
the
last good commit I found after git bisect.

As "bad commit" I mean the commit on which the issue with power cycling of =
HDD
occurs and "good commit" is the commit on which this issue doesn't appear.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
