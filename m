Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF7D343D9D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789964373; cv=none; b=pB7twqZO6f2ZWXdtQDUOC4gHlIzueMla2JsQ4AMZNwV4gD0kQl3o7i2aFWNx9T0wYOFn7Fm7I0AF0HsOEK5HpUUFBqZAKnZuwhNwSLhaLyy4TyvCMia/FsndT/i/vpgqRdUiEQLraf87AcUEzRyNttmEsqoCWpN6/TCRvBNhpVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789964373; c=relaxed/simple;
	bh=h6nQrNpsC2SPsf3g4KDElWL4WOWUQsl/By1ui4Dyx+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LfrooXrhg6dQiXTnCIMdhlqLQWowgOf1QD4waCA6A8dzhVz1oUhEjql6Ne8D+AcAdGP4NTURPKRgnXq2+K0qT8wPeqIfUdAFAWAAPxDJZ8uji2oBoRlVbNfT4lJ1oEr99FREWaYYP/uhU7pBx1L6AW3WRTu/65Rw8LwVjpotKZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MngaA47F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MngaA47F"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 754A5C2BCFC
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789964372;
	bh=h6nQrNpsC2SPsf3g4KDElWL4WOWUQsl/By1ui4Dyx+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MngaA47FkM4/kA9VLbhdhm9X1+RTwNYc/DBTU4fUelv+j63Q1CMT5t+6PXACmzqWB
	 1L+iySGjYfP7AWD3h4aa4hcGnzmMjjJfJwXjj7gnQqN8tgAH7mN0zaQIjjT3wrol/M
	 R1U2V5RUxrcij4n+3TGyy6Mqqh9nP80hMpAIRva81NizYLtaU/i7nKRXeCxSX7MfXK
	 JLyAmVqA8LHOUgiIJqiEe29GsW/RIr3xe8bIg1aDWSlIEue1rmVydcHCAO5U5Wtm1u
	 K1Efc2CkUTYQV3IzDTj45tNzItErlwmkb8cAVW4kk+8prpNK+YborWZmSu4h02ABlB
	 T7vSGiBzmwQ3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 60FCBC53BC5; Mon, 21 Sep 2026 04:19:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 21 Sep 2026 04:19:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lindabonds836@hotmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-mM9cTfxJwa@https.bugzilla.kernel.org/>
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

Anne C. Flores (lindabonds836@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lindabonds836@hotmail.com

--- Comment #22 from Anne C. Flores (lindabonds836@hotmail.com) ---
This is an interesting issue to follow, especially because kernel problems =
like
this can depend on specific hardware and system configurations. The additio=
nal
details in the discussion are useful for narrowing down the cause and
understanding whether the problem is related to the kernel itself or the
surrounding setup. Hopefully, the information shared here can help lead to a
reliable fix. After all the technical troubleshooting,
[url=3Dhttps://geometrydashs.com]geometry dash online[/url] is a fun way to=
 take
a short break with fast-paced levels and challenging obstacles.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
