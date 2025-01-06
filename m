Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A321474B9
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 21:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736197683; cv=none; b=Kt79KGl3WoENReyjFDhXSXXIm+NHKeR/9ATUNo25sBiJ0G7m1tFDBiMXMfjalMaf08i9V/nQXywI0y6ciqXnmDEKQUwFjPi00HBBwxoYoL7U+nEmPXDRPLHKt48uCE1bX5IowBKx3zUaxveOkbix1VEeKfoyZbV8TonrSUq5x2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736197683; c=relaxed/simple;
	bh=Ilg97tGiUJmCql9B/+Dw80pcrN/SVJAVd/ttzqaGbyY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LFiyNl6LVxZMrx1KLgegM/nytzs22jKbl05EcOm5pmOSkXb4llkKNOKH3BuJj9JQupXcfSJbSoE77nqyPVl1Lr+DhuTI1HkDdzKDIEbnwfe1mz47CliQp0yqO/FP42uosb/41Cwf2xmfz/j9iZ7MUY9GxbpivDGT2f0PGl5vRd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQn4uy+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQn4uy+E"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A769FC4CED6
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736197682;
	bh=Ilg97tGiUJmCql9B/+Dw80pcrN/SVJAVd/ttzqaGbyY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qQn4uy+ETvNKbxCxk9XLl8ETXR5PgXb67+EJ/Sjo0jZrqppFMZG0y2fmf2Qb1Pw5O
	 Hyj2kflwVvFOV+INCw1a+nAduRXfyg0ozdexQgEzF5k3Zy704/Pj2dhWZ7Nh34u5Tu
	 CXxMAyx7V8UPgRtj0HAJy7MNQOtiwwhnwNNLk/u6eU1ck8neGhX7+q+tLA0oGGKsdy
	 oys+1pNQgZlShJx4JESv/uonzOHBhFjjfFxEhOo1aQF53KPI5Srvs04qYpsanVUSR5
	 XPZAq0D1z3L94Qc5minGHDU2YRd2b+AG5RpVHEovEQ5kaF0ut8YF9caZFfQ23/Nuho
	 l/H1iJ19i5tmQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 92A6EC41614; Mon,  6 Jan 2025 21:08:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Mon, 06 Jan 2025 21:08:02 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: michael.christie@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219652-11613-MLq2QLtKqU@https.bugzilla.kernel.org/>
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

michael.christie@oracle.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michael.christie@oracle.com

--- Comment #14 from michael.christie@oracle.com ---
No problem. Thanks for doing the investigation and lots of debugging. I'll =
send
the patch upstream later today.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
