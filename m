Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA484963F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719907773; cv=none; b=ro7riYalPkLFqCu9jVFbPpCQurHNk1Nw6cTqE5ySdlvBa6nhOmYj6u0lZ3VS3wF/zjprF6ib49BihQ4ZU7oWDCnxDojNCPdOVUtOpD+vDNHwwZMak6fAvgcDC+afuITuimts0yaQe145l8vZ+a1pxEbKsEjcnnpXC3fLWyDayxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719907773; c=relaxed/simple;
	bh=Skroyq3aTBY7hfPL4JdaHRuWffkLk23EobqK283C6Rg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NLYj0IXM+CbGj+/vGXwtZ1vQd9406xGvmtaetBdRcytoRHXsk8eI9vU1RXSSulwfYl8OndY1m0jSZDzYJMVDRIAbRurwtrKjlex4mqFehQ23rcIw7Qr6FJoR9Eces1BkspvRAU7bphhyNO8i4do89yt59gG+Bk4ZdnzIxim/oto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azTS0+Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azTS0+Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D483C4AF0F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 08:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719907773;
	bh=Skroyq3aTBY7hfPL4JdaHRuWffkLk23EobqK283C6Rg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=azTS0+ZuhM/y4xsGGhSQ1RFke4XjBHUjeJ7APTaIOC7RIaDHvH5uFmkgka1BCUCd+
	 isnjKlDvup/XB709l8Auo+3ZJk/kFTdUQ8BshHm9NowWYuTV2fG6HJXqQnAezo3LRD
	 MgaEjQ3GnI5VqcWx3SwN64OofEgizj/FQtOa8D6MqzP/rHaxH0MtuCCsvpXOQh/1QY
	 I9rLg2n3GkGauT4KBLSl7V/RhXzce3eJGtEOffUiKnyX9eJ++rW0MIAyJxsStTkP++
	 5WxSJmGU1g9aQ65lfLCxVuxiVP69MMjlCF7y+9G89vSe+l9Qe/rLLO7Wy/CbIU7msu
	 dA7QWaDeuKg6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 23DEBC433E5; Tue,  2 Jul 2024 08:09:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Tue, 02 Jul 2024 08:09:32 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ranjan.kumar@broadcom.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209177-11613-hg3m4ZHa32@https.bugzilla.kernel.org/>
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

Ranjan Kumar (ranjan.kumar@broadcom.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ranjan.kumar@broadcom.com

--- Comment #10 from Ranjan Kumar (ranjan.kumar@broadcom.com) ---
Hi,
LSI SAS2008 PCI-Express Fusion-MPT is a pretty old card that has reached EO=
L.
If any support is needed please contact Broadcom support channel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
