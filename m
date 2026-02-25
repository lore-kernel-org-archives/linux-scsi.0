Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C414BF97
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061958; cv=none; b=pP13Rq8rfbw3IqQuyiGFrVt7rRHHjIEITZSvbYI7tgT4w9zIAXQ/VjpgRlQrMMk9FDz/pmqkG8iesBXovfVL8x5J89zujTMtolMIjRw6HfSrMMdsMXUAPjPu5OpTyAzI5RbbfXcve8n1TpcG2sctLVMRBpG81GFV3zaMWJKRSWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061958; c=relaxed/simple;
	bh=s20vuPoTLnFFQbljBq71xMbGGKecwZ9Xv0VUVz8+W84=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dn6nSfRV0Id4l3Ow59eQBCQY/3bNQ5Ko5E3MidgM0zlTshXnW56LGEvt8IiZ+ugvn6IcucfpxVtnYbuBupXMIx3ckz/SE1Ux6L2aJaj7bNFuBCN5dkQHkTunMFTGPjRF4Af4FX12vmfL+byhRBtn5pXRDImgjVhq+utjW1fFBRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvbQIl+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvbQIl+e"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D241CC2BC86
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772061957;
	bh=s20vuPoTLnFFQbljBq71xMbGGKecwZ9Xv0VUVz8+W84=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZvbQIl+e8wClNY30+py7TvA6dkpqBXsjB5qBab+ck91OK2U8QevUT+mdeZzKJmx1n
	 0NVe2KddC9W/cmRsadBVH7kWGCoJjTOpsKQBlgZha0zlF9ThdRs7131an6GS+Hx3JP
	 OLXE9SXQWq6JcA6QjE5hdVl40dP5KUo2ksIXWgmaseUYsk56tROSPDJIV7B9OHDGV1
	 1ZociGB5QnwECFzES92izlpKsFoM9vGQaL6h7IgUDr/jlUwxWrh1vqrNLormVA4udS
	 0LzaZW9mfgTqhKZgxBQgVt4DsPX1NP6502jpTXEJjSFvwGzcqR5Yi6pk0LZHtU2lZg
	 4vjTn3LXqzEhQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CBE7BCAB781; Wed, 25 Feb 2026 23:25:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date: Wed, 25 Feb 2026 23:25:57 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216696-11613-mND2EdjbCz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #9 from Kamil Kaminski (kylek389@gmail.com) ---
Created attachment 309464
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D309464&action=3Dedit
0001-scsi-core-Treat-Logical-unit-access-not-authorized-a.patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
