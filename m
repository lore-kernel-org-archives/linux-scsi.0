Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90A51B0F10
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735832327; cv=none; b=UeJj8uIRl38jyY0fq+vDa6HkvJ2wCVa8n+nmSKozlyOMW3mSywCjMgLo1mTNY9QehkAGCvuxt8M4iIbSUBdADnLH6B1AL5y9lbOgXIdjuI/03/U2ap3RMwZr+U6EJuXQ+KdXVseQSPDd2JZkpENyqpw0jWJJwpZRswG9rLwZkag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735832327; c=relaxed/simple;
	bh=TmS5hLZ4n1jWeiISNuGukRNotvFrdgAoUDCWKS4M3mk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KgPtknN7QSiQ78z7oG2ZC3nIRHw7qjBClsQfY8OLY9tl0v6v07fFrs3k6aHZppRWH0x9gLLxDgjMgUrwwrFSwSAvDa6Uh/PUDDXfDaMUOBRKmtXCkwuG6WYZ+EGeLHw8zII/X/Cxd/5XjWAqmSEuk1n0Aftq4nk/M0aUKheAHcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heQlcfGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heQlcfGI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83192C4CED0
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735832327;
	bh=TmS5hLZ4n1jWeiISNuGukRNotvFrdgAoUDCWKS4M3mk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=heQlcfGIR4SMxi/+ndFxvXGM32z5QSgpZ9OgA5zEZzsP6pzyMzmvGn/Av+n20Nrjd
	 oE/QM4+i7SpJrWZfRx9X4SSIhY4Mb5mTlZhg0baiGqGc2877UkMNl1hbW/sevFHp6A
	 H8h3h6CM2cAuX6O204fpA3U60MJRFRyY064DDgxBTRlV3a0oaLPu2ta4WBNt1Svqv1
	 a4/K+IaH4W6yxonOlAsk3DD1B6aUn5MleCjAyJxAe+OFqF1hJucthkMcARQUsX6PvP
	 zR3h0X3tbWh2wwABDB0l4obBFm555lc80M7CGVgEJSqKqGTlf3jJ0l1GFMY9sB767z
	 uTgrmFWpAuwcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6E44AC4160E; Thu,  2 Jan 2025 15:38:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 15:38:47 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: stern@rowland.harvard.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-ZXHxOdyf19@https.bugzilla.kernel.org/>
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

--- Comment #4 from Alan Stern (stern@rowland.harvard.edu) ---
Your best bet is to instrument the new read_capacity_10() routine and its
caller (sd_read_capacity()) with sd_printk() lines to find out exactly what=
 is
going on.

For instance, does sd_try_rc16_first() return true?  And why does the "Very=
 big
device. Trying to use READ CAPACITY(16)" line not get executed?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
