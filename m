Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E2634
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735779518; cv=none; b=cLokLH1DoEixSACwh7iFF76fWU7Egs9c/gDYM4907+NkzLVFEb94zmMjRNwi8DA890rZbdzl7CkAxAfkYi1/1vGVQnRz4eBNPVqrx8JcxEPIaTM7ncpeKQXVDU1YxjjhqW6apcF1CNyGUBGY/TKQBK2N7POzpfZXJnStghG/1Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735779518; c=relaxed/simple;
	bh=CS04RnUmyY7lExerAXEhenRMuVQASmRUVB7wc44xSa8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p0sOtGeinerz00/dpDpRbVy9Rno5Ovhhx8oZHRKcSuTJmtloJZD+UwgeuR/1i+LPFSr/Ptg4ZHF46v3vLcTW/VocFWkTo2Xd3gn2CGkznSg6KIl73KYl/cDCN7kL99Q9bzrQV1yuy6HKDn7p/hGEEXa87LTDM3ANCENjUKV5PbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzH6IIzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzH6IIzn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90168C4CEDD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735779517;
	bh=CS04RnUmyY7lExerAXEhenRMuVQASmRUVB7wc44xSa8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jzH6IIznm5Z+bbvxeCX4KGRMvsLWCMbV56NPJxBEnHDyHo/08F+yGcm5u1ADy2wgS
	 2PAs/MkpzQFByDySL5CgRRDyt883fk4BnK6joQ+SIYjeg39f/yT1NH3Ngm/Tuq0I28
	 Zxvbnk8tnjXTZJ+wxEv8wFqzdXuRIUXJevAil/bur4yCMeM7vX5R2MSVElQaxkWqq9
	 kSPNqd/Bw8Pq6zW06KFJiSGYulGN0AHCh6LnfMpvH1BGPq0lG1tQDwADgNlJZwxDRu
	 5d3vUxiK/iQMduYToHiF5X1EhrE7YfmeUlD3Ly2ruCfmFz/hcrZ9s8j9DBDcCOjlcN
	 HqrrFoDGo1wHQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8A5F8C41614; Thu,  2 Jan 2025 00:58:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 00:58:37 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugs-a21@moonlit-rail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219652-11613-8gv4kdvygp@https.bugzilla.kernel.org/>
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

--- Comment #1 from Kris Karas (bugs-a21@moonlit-rail.com) ---
Created attachment 307436
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307436&action=3Dedit
usbmon trace from kernel 6.12 showing failed capacity negotiation

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
