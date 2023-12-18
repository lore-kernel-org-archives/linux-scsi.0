Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8431D101C2
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 06:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqasvphT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD2FDC433A9
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 06:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702882687;
	bh=1krHSbZxjRVCLTT2qyiBFgnaJEJTkSWUAIl97fW6VZU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gqasvphToAZGxbH6gfDXD0Si6e3NoE7FVw/7zGv1Y8m83nO+Gg4gIhmNkfCgUzTG/
	 L+28jU/REjIDF9aON4bevtT3QWeyt48B8IJYQNJcH7LHxZ/8Tnf4tS967p8qHffCbn
	 RROf5Rn543+sXJI+9JlitTxq8HPrYhxwei/Mb0vDxt6tOQ8U1xVIOgBCWn0Wfn1eUg
	 1V69kU8amCyeYoPmntGs1CqkOMHbqIgEILMGPGTndnc86Qg+c9Iamalm7v0S5S+jTe
	 fTVYIk1hpsDgeROtK/PqRi9XNzdvKgJo0y8IJBhpyd86XIJICh5dgFH7CMQJFcxKB9
	 gjp7FdLq2nXDQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BD2FCC53BCD; Mon, 18 Dec 2023 06:58:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 18 Dec 2023 06:58:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mail.spyden@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-TC8QIaRHV6@https.bugzilla.kernel.org/>
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

Denis V. Kuznetsov (mail.spyden@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mail.spyden@gmail.com

--- Comment #50 from Denis V. Kuznetsov (mail.spyden@gmail.com) ---
Hi.

I have the same problem after update Proxmox 8.0 -> 8.1 (kernel version 6.2=
.19
to 6.5.11).

My config is:
Controller Model : Adaptec ASR81605Z
BIOS             : 7.16-0 (33456)
Firmware         : 7.16-0 (33456)
Driver           : 1.2-1 (50983)
Boot Flash       : 7.16-0 (33456)

I use ext4 over lvm volume (neither BTRFS, LUKS or ZFS) and have same probl=
em
with periodical hangs of adapter:

2023-12-17T20:02:57.135482+03:00 ve5 kernel: [ 9568.092740] aacraid:
Outstanding commands on (0,0,0,0):
2023-12-17T20:02:57.135483+03:00 ve5 kernel: [ 9568.093590] aacraid: Host
adapter abort request.
2023-12-17T20:02:57.135484+03:00 ve5 kernel: [ 9568.093590] aacraid:
Outstanding commands on (0,0,0,0):
2023-12-17T20:03:30.675479+03:00 ve5 kernel: [ 9601.630477] aacraid: Host b=
us
reset request. SCSI hang ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
