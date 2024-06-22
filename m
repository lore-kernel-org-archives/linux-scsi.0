Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43A33F6
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719055965; cv=none; b=T1xrfH11Ovwgc33K4AugFrP7Mf8YxByAzKPOnHQTZKJwGYRy8zT7q/LRAAAw0GobRgiWBr1IU24wnsQv/fBmbuRewAK4l9wvhpcobxFhRdpQsbcGn8TptWjnNutkcsbOD1h6Tg5/dRgboylM52JNQKW6T5zZ4/XQQb+8VXYlwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719055965; c=relaxed/simple;
	bh=KTdOMPodoyw8ykZ1xFqs+6GM2CFYNzwLZd8NLsLL/dA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GM9ChwT9dFhrPCy3dR3FmE8N7onb8QU9+X+9E7a9vJjTrcMu7j7EN1KtP3nQ/SxHopLwgQS4/z8dXMyTp9RiXt75lew2RV8U8QI0yqZZh8VrShZd/gFOa33frEQ/QG3VAhdsLF3nNeiLnMy6LYWcdbmAGpotCztrF20tQVEM5E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUjAgbjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUjAgbjL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A773DC4AF0B
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719055964;
	bh=KTdOMPodoyw8ykZ1xFqs+6GM2CFYNzwLZd8NLsLL/dA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YUjAgbjLiGyH/CxU4Q8DQnPtnEgUQbBO6mu4ymW+3DACIQu9Dy2l6UiX/hHfCH53L
	 CJuHoERtDBQvnU5RpuZa4oWW3gT0Qwe1hViaTJF6DRxslTmh9bImpgGGyo4gjRcqFT
	 6CpoN51HrzwVCI/EoddeIjVFRyYTIrpOlYL2GAG+klqfQDVwY5Pf8uBYE7YfxAB2Tg
	 Emhsoq/m7GfdnZuonWGdLFQtEZifH2IgjNoKztY6LlYo/F8e/15AZ52G84cWO+4dSl
	 a44hHFBiebLpG3DrySImBNxkHOBVisVMPfb5N57T2lDiRwSLYLze4V2uYbi5LLs529
	 +rH+GewSmukyQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9DDCDC53B73; Sat, 22 Jun 2024 11:32:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Sat, 22 Jun 2024 11:32:44 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zeph@fsfe.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209177-11613-PllCSwWIIw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

Guido Serra (zeph@fsfe.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |zeph@fsfe.org

--- Comment #8 from Guido Serra (zeph@fsfe.org) ---
Hi, I'm having probably a related issue to this one on 6.1.0-21-amd64
Debian/bookwork (plain new installation). I cannot see any of the devices
attached to this card, lsscsi returns only the devices attached to the
motherboard

23:00.0 Serial Attached SCSI controller: Broadcom / LSI SAS2008 PCI-Express
Fusion-MPT SAS-2 [Falcon] (rev 03)
        Subsystem: Broadcom / LSI 9210-8i
        Flags: bus master, fast devsel, latency 0, IRQ 40, IOMMU group 25
        I/O ports at e000 [size=3D256]
        Memory at e2540000 (64-bit, non-prefetchable) [size=3D16K]
        Memory at e2100000 (64-bit, non-prefetchable) [size=3D256K]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [50] Power Management version 3
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [d0] Vital Product Data
        Capabilities: [a8] MSI: Enable- Count=3D1/1 Maskable- 64bit+
        Capabilities: [c0] MSI-X: Enable+ Count=3D15 Masked-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Power Budgeting <?>
        Capabilities: [150] Single Root I/O Virtualization (SR-IOV)
        Capabilities: [190] Alternative Routing-ID Interpretation (ARI)
        Kernel driver in use: mpt3sas
        Kernel modules: mpt3sas

I attempted, as reported on several forums, to alter
`mpt3sas.max_queue_depth=3D10000` as the Queue detected was pretty low

   mpt2sas_cm0: Current Controller Queue Depth(3364),Max Controller Queue
Depth(3432)

The change seem to have absolutely no effect... shall I open a new bug? Wan=
t me
to create a bug at Debian first? how can I proceed here? I initially opened=
 one
here as the initial installation was a Mint, and the ticket was closed abru=
ptly
https://github.com/linuxmint/cinnamon/issues/12251

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
