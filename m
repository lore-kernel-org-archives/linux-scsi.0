Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B302DB780
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 07:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789801976; cv=none; b=XPST8iBUKyNnpxYV17uhhMBQcKWyJeS0XuLjbBW4eLJuAx4B1VDkdKF+cCHaIrj3Rh8HyRat5dbheFHMOHEyI61tKLiRprkYmcUTe0rD5B/jBgivDHHBlM6rstIaMoUs9bRjZu6sNZ01lxE7zofhXDLc4Hn3DGAuqtia9bdV5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789801976; c=relaxed/simple;
	bh=auMKvpG/aFQeEB2t4EW2J13ert3aXm3gp/4X6atSyzk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QSWIaLSJK7i4tm52f4vb8tGNb8UUJEHrlbrE50CI6mhf+JXwS2wcqhDBwd6l916XC7146WIp1uYHRMQznZIj4vMN2e6iENNeoj445B2avCd58J6I1JDFRwlzQmBzp4d/53omfAGDCjKok+PtVs7szdAD6Xg1Om4vPO3JzJZp/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHkD/JrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHkD/JrG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5011BC2BCF7
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 07:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789801976;
	bh=auMKvpG/aFQeEB2t4EW2J13ert3aXm3gp/4X6atSyzk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IHkD/JrGBzT4CjI5CbH3ievQXTnE7ajN+8/1S4bDDQpTxwazyn7Rkk7ME0VkHcx0k
	 zMZMz/tbRxDHwPQvPIPg5lUQML1MwOKwmjAOy6vQlZkltxpo2ZhAYfbxKEywWlR4YV
	 zVa2PknKA2vM/qHRB9W0ViDN7MZkFmVoP9v3GbK2KKVNqnBC8oOOfzrRDy0WVDS0xW
	 /DHEkZ9vS6nwL/cHG6vDvC4mj6GGIx5ZjCodTdvtChdQxhSChoF+MPw1G9wvZOFEcf
	 ZcqW82V9SPNjQqxxXMpBhPke8tXYanyAUAm3qyozWcWlrz/8ThMGMUeOU7SEwAEk7B
	 uXcjsqe/Q7l2g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 37259C53BC5; Sat, 19 Sep 2026 07:12:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Sat, 19 Sep 2026 07:12:55 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-222016-11613-LS8saZ7SlD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222016-11613@https.bugzilla.kernel.org/>
References: <bug-222016-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222016

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #14 from Artem S. Tashkinov (aros@gmx.com) ---
Queued for 5.15.222:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tre=
e/queue-5.15/revert-scsi-core-register-sysfs-attributes-earlier.patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
