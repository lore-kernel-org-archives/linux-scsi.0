Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF77E59A
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543588; cv=none; b=mHE3i5/UNrFes4HBYl6DmymtiIMp5gpwKSd5xXqt44bRuT+MyPFuDHfoCdSlc84MzYYDD2N0WNKIUmkyY6ZaUBeYZMM5c2lHkhubf+L668isvnJeWpgfHx0fsUvzQtVsr1cMKkVYhs+6ZnVvNRWCLgzIjiHJuGZfujxhqrU8DuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543588; c=relaxed/simple;
	bh=QXf6BlH0S3qnPaZyQEeYHQrghch3MNn9NjzPMriTTAA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oOonU+8pWcZzAbAEWA8cFIqC8nqC7uQAHZK/+LjDqkfF+O6JfLkGcZBq0rX9A5IcshMqs1ebDi96BxkbOiDrWw7hsFsgXHDXr6B4MK/wvNXtFm5VwB5hxFVP1R5Oqq+Ys7I+wgey1U2AduXOvezyw0xbQkGEfq9gM3KIskhJiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrlSsfsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrlSsfsM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47A30C32786
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716543588;
	bh=QXf6BlH0S3qnPaZyQEeYHQrghch3MNn9NjzPMriTTAA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BrlSsfsMYQ7GVHohvxTcMKr+NC/+VCYXN8GqmQgHPtXHgKiJvlYV/o8CPQN1BA1PF
	 g+Qovc062nblQMGX+1COqyF7V7Pg/T6GArBume3SvjG7FOmPSc7UUiL4jTpXExzknx
	 Cs8aqgFI4lp+YOGEMJGt/nsR3tPfecLlMacf5vzoDlj9SI2E1mHLaLCaKZdY4fu6Ok
	 rvcwhQsR9YQrYgcRQW5jSDcwdgimHg0iYfUd2sHC/RDaRqYvzweSni77wsExtQRUN3
	 yfc2uhdajTKEcN6WBNE27lLFiSrmf37UsGWbaNMk1DOj1qJwljzTAWj1rrRIjEXcWO
	 TG0L0oaBGWG2A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2FCE3C53BB8; Fri, 24 May 2024 09:39:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 24 May 2024 09:39:47 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218866-11613-OVo84LozEJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #3 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Is this a regression. IOW: is this something that did not happen with say 6=
.6.y
or 6.7.y? And are you using a vanilla kernel? Or something close to it?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
