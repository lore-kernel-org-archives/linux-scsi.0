Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067F44A28
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 02:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753151584; cv=none; b=qf6nK4ZGJ9TdStbxdqYxVFVt2hhYRiNKow7Cy7k7xCqpBeHIAV7NQHxlfPRsLTAESXTnHKHfn1UtSjHe7vAUVdvQApPBiEvYecS3JtiBNafA0oTmy0CScICuRIy0gis0tUNXomvRVsppPRq0uMr/HU38tGJr7BHkxM6YYgWVmu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753151584; c=relaxed/simple;
	bh=Rblcl96wTj27k+vw1YsL0R5a1RiOtOTcJdteTIStFkw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rtc2hULtI/Zn9lyt4paMwdg32p90D+zN6bIuCvH9Hl3kIm0jUeerpFZFmgzw5xSosvd7151nKuv8aYoHz9I9OhiT0K1elOqUG/53CiFs08klIAY7kCSDF8eG6cXoTRS5DRqh9cTLf89/LeKmdfTscIdwkY84PUOzIbv93Bme9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHGBKx9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHGBKx9J"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84834C4CEF1
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 02:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753151583;
	bh=Rblcl96wTj27k+vw1YsL0R5a1RiOtOTcJdteTIStFkw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bHGBKx9JImMPfZyPUlNPMPny9oRuT337nsZpXxBuM8m/rC3ehvM03sak0TgVm5WQs
	 IbmOu+LfSgH4IqF8lpryipA4XfN6DWGGmix9RiDTJZ1iG1mHgqSbzDv+BN7loZuSfX
	 qSnnJzqKQgFYxvIRAVfjLwtziUDiuHMGSG+n8mAYMe/D3/3wa2w01RxUFGuHovqXsj
	 VGLtxkZp8/Iya4XGfsmaRRJ6cR6Nrvlgyo8w5R8796ZgQcJ9OHRg7lJ/bEulKWMn3Z
	 /8VW0PIG336DQVWApHjsNi/zhU9SE9Md14bQ11HNkhEvHJoR1eOUhMOl7BUEv5MVzW
	 kA7K1TDrxLf5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7D93EC4160E; Tue, 22 Jul 2025 02:33:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 22 Jul 2025 02:33:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jernej.jakob@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-j1e7Xm2xEZ@https.bugzilla.kernel.org/>
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

Jernej Jakob (jernej.jakob@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jernej.jakob@gmail.com

--- Comment #74 from Jernej Jakob (jernej.jakob@gmail.com) ---
Hi Sagar, any news? I see in the mailing list thread
https://marc.info/?l=3Dlinux-scsi&m=3D174490543129132&w=3D2 in April you we=
re testing
a new version of the patch. Any estimate on when it will be ready? We have a
couple Adaptec controllers that we are unable to use with an unpatched kern=
el
due to this bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
