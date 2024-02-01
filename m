Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0370741760
	for <linux-scsi@vger.kernel.org>; Thu,  1 Feb 2024 19:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816783; cv=none; b=AuNnESCENSDz4A4MGIRaLqYR+jqwEhGdT6ZXPz8SZnNv2Pu/vJFXt3QaS0LzUwkB5zwyu7bwpBi8NzzfGh4E/FAVBcEEvmZjXXAFNy3+QGDOe0SmfcSBPAP68ppJlxojlkh6xRspwImfSMarnxs6Gv/rM/9e2XlSQsTcU7Srj6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816783; c=relaxed/simple;
	bh=Xn+HeZwjrhL38IU0Ow1AtlMtY0ELrkM/Pfv2vB1b6do=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cbAb672tP7XG25AkO+ow6urNDshWheeHB6aV719l+C2ZCXcqCMOmQg+RgAJze3W6rMQ+8GU0F60uA1oYQvC0vlCn5a1BktmFd0JNC/RjD0bkNka6b7DlIsgJCS36X9toFBTXEZakg2bHcoE1mmJqf2Dq+svH3+AMwiFYAdpC+bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E48Zvt9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E48Zvt9d"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDF7EC4166A
	for <linux-scsi@vger.kernel.org>; Thu,  1 Feb 2024 19:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816782;
	bh=Xn+HeZwjrhL38IU0Ow1AtlMtY0ELrkM/Pfv2vB1b6do=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=E48Zvt9d3nvOAs5fFJ3VE9aMFQb4ZWYsbQ1b7N6VOuj5vOWS/JnjdXzJ9jaUWKae+
	 4/6IymQxIY7jkJJceG9iYMyu3AGHRxUMsQ2X1tiu3gXmljytfBb+1Lov4NUjijSKZR
	 Zw3bdY5NgIoewYp15Rnm5fmKRvcUdO3qTS6ECwGiacMrFsD378fmS1VHbQT4Rgx9YM
	 YWuSDo7j3uTrPFnG6mQcDOWSn4+j87+HIImSOr4kj8VFuizhZaJoKS+uZlv3U8WbhS
	 hnj6QjxEWe72cmP0EziAnTgDhJrXKIJLXf6/cglm0XgkIauIZLyMI2ui2LMLDLuutF
	 npGAz7fJwfuKA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BE2C2C53BC6; Thu,  1 Feb 2024 19:46:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 01 Feb 2024 19:46:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ro_ux@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-837rnM7BHb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #61 from Netix (ro_ux@hotmail.com) ---
(In reply to Netix from comment #60)
> I had the same issue and I've put my x16 pcie slot in x8 and it seems to
> have considerably reduce the occurence I had while running on unRAID 6.12=
.6.

Small update. I've made the switch (pcie slot to x8) on January 19th and si=
nce
then it didn't happen at all. No occurence. Still running unRAID 6.12.6.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
