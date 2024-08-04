Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6090A7494
	for <linux-scsi@vger.kernel.org>; Sun,  4 Aug 2024 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722746307; cv=none; b=J0/eS8zvZe22sG6xk50Up/YtktWXjo78jMk9X3W/Mxqgml2e1RzTmbRENFiSQr2olIRK5iPnL7u61lCFcPKuia7E8TTs2xVa5wx5r6t7/Mq18OS7FfcTJxKgaHwhQxF8ztmk/7EX4aeAdJ8CmRJLEGTo7OaMWLGH1nnCqEOoWK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722746307; c=relaxed/simple;
	bh=BUMMDqfn8EtkJ9c6YgVYEJFRN9vXoTBdpHFDG9uF4t8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jI/Bk+TdqMqJjUFdSRBpglIfofA6rUB6b14juAGKsDydkKNbuE/HEUF/N/Coe+6IoRiZVXTLFPZvEmV/qXFvqek40PR0PrPty3thFQWrKRakHNl8S5abSacMUeF+y5ajcUIc08WQgmhTMddBSHIHz0PD7vw8uNngRBOWVJdAcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwFeZlNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwFeZlNz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2B07C4AF10
	for <linux-scsi@vger.kernel.org>; Sun,  4 Aug 2024 04:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722746306;
	bh=BUMMDqfn8EtkJ9c6YgVYEJFRN9vXoTBdpHFDG9uF4t8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QwFeZlNzNv+QeBlh41D/+JJfQorB6zNz+75nV0LWN/gPOUFMBxoj40t+u+CIfp4xT
	 rD+edwBZ95caWxIjUDdOs99z6px2/QvWcJiCB78uZiQeKEzUy9CAO5aT5f/8+RVPsh
	 bf89RDv1sFogMQFdBguabPYz65UQPfQI1S5cCPJ9K2jqNazynFRTe3D5fcFryM60G2
	 EU9oHsRKPGP36R6hoRHs+W45ERKLXhwNf6MIoFPHkMTqYDkySFbq1ovWwhQ5+5tGEY
	 UNtS6akatyuauF4n1Qm53eSfVdX0diA/0fEVKl8+2ZXxzXUPAshotTOhFreP8R9but
	 isqpLDaV6bEmg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D88ECC53B50; Sun,  4 Aug 2024 04:38:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Sun, 04 Aug 2024 04:38:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: imyxh@imyxh.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219027-11613-5AMtyq9IxZ@https.bugzilla.kernel.org/>
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

imyxh (imyxh@imyxh.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |imyxh@imyxh.net

--- Comment #4 from imyxh (imyxh@imyxh.net) ---
I stumbled across the same issue with an oscilloscope I bought and am just
writing to say that I needed to set max_sectors under the scsi subsystem, n=
ot
max_sectors_kb under the block subsystem. Even with max_sectors_kb set real=
ly
small, I was seeing read(10) commands for 240 blocks on Wireshark.

LXY, you wouldn't happen to be developing firmware for FNIRSI, would you? :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
