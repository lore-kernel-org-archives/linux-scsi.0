Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E99149C7B
	for <linux-scsi@vger.kernel.org>; Sun, 13 Jul 2025 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752391718; cv=none; b=F5H407vFEQIVClA6arbabb80ua89jx3lzRw2ukOzQTMpELjUCudOpX/KT7Nsq4myaRtWmXCWhkfFR6Dn+MMx0q0XlXVymT/fZPawTU1PO6KXLqJVR5DjsRVbZtGvcSnSrs7a9XgO3GKekPLBX8bxuX8XpnOP4cCyoYexFML1+Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752391718; c=relaxed/simple;
	bh=xHVzg5H1ec0tAlP6O89gEfTUbJU/jGOAAo4iDBJ2500=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OG0BO0aZz4Rtuo1fssBGYNkJnD9M5A6K5HoG1hE06nVxhrBP9MoiYZPFKUTuQw1TL+d1K1wCcP0ENe/6t3B86F25emzs/2aOKUFEtL+06DAY7wf3ArLzyXHMTkmL6XQmR+WlaPcQf1EXvtWhVjKBLR7/dGXmNeG5H+0ZdzSMh8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWGzGl7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWGzGl7m"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 446F5C4CEFB
	for <linux-scsi@vger.kernel.org>; Sun, 13 Jul 2025 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752391718;
	bh=xHVzg5H1ec0tAlP6O89gEfTUbJU/jGOAAo4iDBJ2500=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BWGzGl7mausa+aqW7TkPAAlqVfvaYVaJ0D9uYH4ol22OxqDDs7OO0XhYDXOLx3RP5
	 mNBR8poHFnY4QixzW+UNf6mjmy9nJiQMsqUjQkQhV50VprX9Cpp7gshkV0MfAzF45w
	 OKwauRu+soz9LrMEqDkrp1Wf9ZEEOfCfi3GP4GLW9xipEtyk3aKsKYdjCjymgv/KxG
	 xT3JfH6Zq0O56mZ2kLe4SYrGUdYCsEEWae21m+SYNfTQVaMN2r+rwKN8iWeK0fdR+n
	 sTLJivgeoJZoX4J8ZHUuM4OnBvqEMej3zROcJo45wURsCFutWpu6TSuy8JVsqIUwDz
	 PcsuPqxUjd3cA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3DA6CC4160E; Sun, 13 Jul 2025 07:28:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Sun, 13 Jul 2025 07:28:37 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pihes81860@coderdir.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-74D4BpsP2n@https.bugzilla.kernel.org/>
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

world4vehical (pihes81860@coderdir.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pihes81860@coderdir.com

--- Comment #19 from world4vehical (pihes81860@coderdir.com) ---
The XXC Renegade 1000 XXC is a high-performance ATV built for aggressive ri=
ders
who crave power and precision on challenging terrains. Equipped with a 976cc
Rotax V-Twin engine, it delivers exceptional acceleration and torque, makin=
g it
ideal for off-road adventures. The Renegade 1000 XXC features FOX suspensio=
n, a
lightweight yet tough chassis, and premium tires.Read More:
https://world4vehical.com/xxc-renegade-1000-xxc-power-speed-price-breakdown/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
