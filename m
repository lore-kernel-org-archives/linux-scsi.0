Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D25EC2
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699773; cv=none; b=C6UHbq6/F/5fYCkIaYG2g4MaM/MW/Mkk7ztcJ/8rU/yaoDyfIryUxVfRHVb37cy+Pvxp1dTEjcXTSrVyIMawAAKQpWDGkFFU+m2FivOvy4qEY3PgefdiWrB8zsX0BKS5r4EVr+1adnNCpWvkKxxalvVcau3PLIuVWNFVixKsLK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699773; c=relaxed/simple;
	bh=k1ntAoi50lOyaKn1/ARw7CujZpCpKkg8ZmNkjxr04Bo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V1dMlkhSXLW/d0HByKuw3BwtDgzWkiLV63mEUzlKAqNOKzimMftR9/qOfeOiZ8w5lycWLPM3iIDkGcCzH0hid4FLq9kIdkJWDKo3xsHZhgKC8ogBrdEZoLtM8T8lQerSBcIeMX1rqkK9zrXd6sB4Dx/XreYfT/PH+HDbP1I4Mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpxp9LAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpxp9LAx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45C3DC4AF0E
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721699773;
	bh=k1ntAoi50lOyaKn1/ARw7CujZpCpKkg8ZmNkjxr04Bo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bpxp9LAxNq3gs8SIzU3czBaWrDUoq3+11o7u6gJ3gZQ+waAIJZuh57uSoC88Qnmco
	 UM5brqm+FnZ/8ct1/v//UO1j6JzBlMz+uWeTXDnVbj+EtuZ/BmMYjQOHIE3fcp+8gJ
	 oTfp9avdC1UeLZfJR+oxkKtk8HFD8I/uOipnMFh91DKnZZM5UU5eRHwq2+nd8/SgBj
	 VoJWCdNBDIX6Q18RozEfjoEQ/m0Rp8QZwyZQczJSLLgQAG1ipAG36JcEHhMYs/jixh
	 goJlLrpDTtGafn78yhv5QKjs3oXqF/Nkcdlcdj2jUqCLgv8bxo43Xam2d0+6K7AXQ2
	 kJ06viH+seuOg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 365CEC53BBF; Tue, 23 Jul 2024 01:56:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Tue, 23 Jul 2024 01:56:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 983292588@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219027-11613-EK7nk4sqnZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219027-11613@https.bugzilla.kernel.org/>
References: <bug-219027-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219027

--- Comment #2 from LXY (983292588@qq.com) ---
Thanks for your reply.


I've tried creating udev rules and it works. But whenever I use my USB stor=
age
device on a new PC, I find it a little inconvenient to create rules.


So I'm trying to find a way to get Linux PC consulting the Block Limits VPD=
. Do
you mean that for all Linux USB storage drivers, Linux hosts will not consu=
lt
the Block Limits VPD?


I actually have the firmware source code for my USB storage device, and I c=
an
make some changes I want. For example, change the VPD page it supports. Do =
you
think it will work?


Best wishes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
