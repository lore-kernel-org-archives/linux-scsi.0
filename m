Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0F1803A
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722861981; cv=none; b=tW3Jexuyga+nwahnq/tNPifx6mTspI1Mt9YykanVIlGtuIV3JLGBJxWDMn70u8JEHwuVm1SqiXwuBuBa449yFjzZn0ZldPBfshCjhgu/ajt+1kR1HvHA15X7dS9L38R90UUubCth7Za93TFU/zV5LiaTwR/R6wFIlrqXtG6lyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722861981; c=relaxed/simple;
	bh=Mj8EtcguUYiUcc7pF7d+XhdofVSDGCfHKGntGSKd7Ug=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NuuVyNkgXC70cIPKCuyri6HG2jbP6AHB9nRFvFXmCBHzeSqzm+TvsXBMLJ8b3K/7Z1/Cd471pYQCGpiluceJB4Qm9JycVtQ9CUEHbPPQZ3GsaFdf7CkWHxoipTi/8q+78iZ52f633YrkIk0+Q42NocWG7VUiT/ziVphaLTEefX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJDJHu5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJDJHu5R"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72E63C4AF0E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 12:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722861980;
	bh=Mj8EtcguUYiUcc7pF7d+XhdofVSDGCfHKGntGSKd7Ug=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aJDJHu5Rv29e48E01AEJwt2Jc3pYt7DnHQfw3vzRv/Z357YvLrqmnBoZ5GsFTqmn0
	 FvqrLyIAxc489C9lRtdc1H/nIEBRAMXmODATWrD+k8TLHcp7Yixq55j2KV/7Fc0oIL
	 4+FHVIPBZvmWn2uGyqGIIYXduhgi1ZyxITxrfY7cGGPWlA24aH4env7lhvf5qk2n4d
	 RQKCmmEgugHOX8ASuTmyI4TjPDYxx5343TZ0WtRSC4gWZR2qfAmIE5MGlK753Ze7ZQ
	 2MFB72LCjTtNm3D9kkl+pKTN3J2c1/pXv9+8swIfS94y3mGyk7z+XHDhk00rrkohYi
	 od5w+P79HDOdw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 66E14C433E5; Mon,  5 Aug 2024 12:46:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Mon, 05 Aug 2024 12:46:20 +0000
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
Message-ID: <bug-219027-11613-d7vPCpAM0I@https.bugzilla.kernel.org/>
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

--- Comment #5 from LXY (983292588@qq.com) ---
(In reply to imyxh from comment #4)
> I stumbled across the same issue with an oscilloscope I bought and am just
> writing to say that I needed to set max_sectors under the scsi subsystem,
> not max_sectors_kb under the block subsystem. Even with max_sectors_kb set
> really small, I was seeing read(10) commands for 240 blocks on Wireshark.
>=20
> LXY, you wouldn't happen to be developing firmware for FNIRSI, would you?=
 :)

What a pity. I still haven't found a solution.

And I haven't developed firmware for FNIRSI. I'm developing TI's firmware. =
Just
for my interests.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
