Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D51184D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722914759; cv=none; b=eD36c6CYfLxLUOmBhQhvahor7rexsSL/OYLwJMGCfXCGmSmwBaClFZq2KmRnc4saakn2UVqMC7Rp3h4tJClUqyT6WN+rjB5voAK2aKoxW0+QH6y02tk31tbuZWu/MEQIlLlt3bO1mr5d5EPGTIE11/ItzngaECZ2L5/LHIoUdwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722914759; c=relaxed/simple;
	bh=+Ea/koHv5QXoInh30dC9wL8KaF6rO/MXg2uz4WaAEO0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sUCoxwkjeduPoluxZ61dz1MEM+rPW/tPWeZ7U0cFzJl0e9EcXmYsfvu7RMvbcM6yz7Ox7XxcAgxKglEj65gdO3t6qjAmFjeMHQ9pS96ZKYHOkcavD8Wk9x8NTDoJK1AzmCoo0xJy8mzqUW9jRExhS58JRIRZM4HJu37xGZPNM5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVDzxx2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVDzxx2y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97B81C4AF0D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722914758;
	bh=+Ea/koHv5QXoInh30dC9wL8KaF6rO/MXg2uz4WaAEO0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AVDzxx2yDMfhaZgw4BA0LdP9mF2eInhn/3BZBEOEyVixsaCxFIRWwGTXBcWgjQUFn
	 yIf7jtwxoU7XRIS9myGIIpwPCjBUVokaAM89s7+wSnbnECl2JZiqMWxARXcXFBdzcr
	 a5LPUu8C3qyqv9bxXAHLRIVjBTfeoFDFvTH4vEJqxRKAUAVECPTKy8piQCcrSvPI+Z
	 pepXBxSQOTNg01V6UoqgJt3dAdt60kTeuQ4pvWNnfyA9zcBxsljy6umh+5OfA0mI69
	 0R1mAS1muWpvOq6JvsEnGj8usGEDGdgmIevF4DKip4/bCkZQkJPEALTtSLM/lR318d
	 Q/QvH6oeN7H5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 80D83C53B73; Tue,  6 Aug 2024 03:25:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Tue, 06 Aug 2024 03:25:58 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixc17@lenovo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219128-11613-sUrHIZWrCy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219128-11613@https.bugzilla.kernel.org/>
References: <bug-219128-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219128

--- Comment #1 from Xavier (lixc17@lenovo.com) ---
Created attachment 306673
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306673&action=3Dedit
dmesg output log for upstream kernel 6.10

Errors still exist with 6.10 kernel, the attachment file is the kernel boot=
 log
with parameter "lpfc.lpfc_log_verbose=3D4115 log_buf_len=3D32M"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
