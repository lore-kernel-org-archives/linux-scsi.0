Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCB71E5000
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731069531; cv=none; b=JvyOGYzVHfg11EluQjbIQbowWJDomjMncerABOMpqq0BsZ5o0geAM+j680D64rcrXFqBK4gkw/PYMP50Set/PX1MTzkmoT366Hv4QTVzBXoiVV7In5on120ksROU93MAd2Wd8T2A+6yMV890xZXL04CYqEZ7nS0H+iK2yKDxFAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731069531; c=relaxed/simple;
	bh=Agd1GVrDuhT+DM19e7MI2y3tzYEoPlX1dm/KUpGgc5c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Svi1esm/iMQ+Y2mrSy32ROlVDYtE0IOXxQrRGGxqW6bA7JjbjZ05MJgim8DFqfG2ZqsoZJ+1ltxswx9qCfE6swf0N6VN2dEOKUJCbC+KKHwWDLD06grkgO5FfEzDORJGvpq5XbNOxuEE2D8L3JCT/CRTE8o2ibagQ7a0y/JUjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pp/DTaXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pp/DTaXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85BDBC4CED3
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731069530;
	bh=Agd1GVrDuhT+DM19e7MI2y3tzYEoPlX1dm/KUpGgc5c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pp/DTaXJhjRtvn9ZS+FTG2B/uJKe7xKRxGejNcVbTxL/spVUqJzCiAvy5w20rDyrf
	 ipqcDx/eQzxO9YMygCEbQM748aivDP/gg8amnxp3CmaZ4iTvR/5ktGvuESkxXgFJjN
	 jGJGyPMpot9RztVMWjfdgELfCMLostg5PXJMjufmYioK3Q1YXS713+/OABAdgGfjLa
	 i+JTInDZxvaQuqBn0TG2sk7SDLTU+0hoTGi7M9JBM8uwE8N2wsxzHypnpUzpS2V+Ko
	 tIEcvR6epSEwJI1vIZaJCXVoe/8PtjR8EyfTmZeYOiugOF5C9Mckz7T4n126LhqaoN
	 oM9rgbnOeGBvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7D104C53BC5; Fri,  8 Nov 2024 12:38:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Fri, 08 Nov 2024 12:38:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jeremywalsh4477@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-SyCXKqV7V1@https.bugzilla.kernel.org/>
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

JeremyWalsh (jeremywalsh4477@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jeremywalsh4477@gmail.com

--- Comment #19 from JeremyWalsh (jeremywalsh4477@gmail.com) ---
(In reply to Dennis Busch from comment #6)
> The bug report I linked to in comment 3 mentioned two patches (
> https://patchwork.kernel.org/patch/10181165/ and
> https://patchwork.kernel.org/patch/10233617/ ) but neither of those appea=
rs
> to have been applied. I would stick to the last working kernel version for
> now (for me that is 4.14.19 as mentioned in that other bug report) and ke=
ep
> an eye on
> https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/
> https://flappydunkgame.com to
> see if anything familiar looking pops up which suggests that this particu=
lar
> problem was fixed ( maybe it already was but I am unable to determine for
> sure as I do not fully understand the issue, just have a hunch the problem
> is/was a locking issue in the RCU system ).

I think so...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
