Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED11A7045
	for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748232560; cv=none; b=Iexq/esTE8byXMB5OpnK/bZJVqjMOCmGQ+K9h34JZJKM90rzCh2r+wfI0a+3fbwu2E9kHCqCLpQFRYsm6Gbr7xvjABRxFOhey6kMi8h//YpbOOlqebOHNDK5lwXx8Exp5OaDtN/bPNNX/mTJ/8uOz6ziw8RGVork1/QbBIVc1PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748232560; c=relaxed/simple;
	bh=YgnMgPiMx0q4LWFwEnLy5AN5AmBxr3lNfHH4GsRqRYQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ApYhQji35zi/oFw6pfpvwdAKofVxPZvdpvFNh5wV8agv+h66fKUwH84Vahe/Lw/yAUkkbJ1c0TftywkLQipuiCcXy2//SUy00mt/TcP5/3AU+R5gQtZ2BLynRlst3rR+B7o8Se9i/PvWEZsyb93G5safeTUf8knZ+ChqFWggCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7AEFnnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7AEFnnq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 201E5C4CEF0
	for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 04:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748232559;
	bh=YgnMgPiMx0q4LWFwEnLy5AN5AmBxr3lNfHH4GsRqRYQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=R7AEFnnqD6I1qfdr7yujwjFMeZZyVX0RaH75L13u1koWd4DGtYLd7j2U3T81MH0Zw
	 Wtlza+duSNqDiwIoCt7cAfmX98496KW+dZ/uZx7EKKPbGmlq5dwbHbetfmTSCLoCnQ
	 TVEvlcm25E0lLaHkm/2czkxi5kB/zQa3bbJVRSJjkOVVQ7VnbPsjEhOecIaoc3LNv4
	 uHUCznC9F38tYSJgHtSm+D2FvNg2wVv3pX5V0PNbu4LDcTMlRbRgH2MzWLvG++8YPU
	 J106u2P+VjljKTP94q8thjQboiWYLKOsw0xBsS1gR2y/7sM0hGSaPZsvWHlwoXEyyq
	 qQt0X+XSd3cWw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 122F7C53BC7; Mon, 26 May 2025 04:09:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 26 May 2025 04:09:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: thuhinn1233@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-198923-11613-bqVnCqdlix@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

--- Comment #21 from Elizabeth E. Hall (thuhinn1233@gmail.com) ---
(In reply to Elizabeth E. Hall from comment #20)
> What is this error. It seems quite complicated to me.

Seeing it is like playing a seemingly simple game, but suddenly encounterin=
g a
hidden bug that cannot be solved. Trying everything, resetting, reconfiguri=
ng
like "debug" in a difficult level [url=3Dhttps://101games.io/solar-smash]so=
lar
smash[/url] - not only wasting time but also making the player feel confused
and a bit frustrated.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
