Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E148786
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfS+bz40"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA125C433CB
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702303867;
	bh=T/0xottVlCypmObn/DTUakeUnK6pRwk22Bm9INEALrA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CfS+bz40FBsIHw1WyhWkfP0jcUox4DQg1mqxkBXyQgWqMNDk6gfActUnmAVBnTCFC
	 wO7M+CrLvxgjoOTuJ23wlEYbzvQBG1Pn9uSWbOSn/XN/Eox53yKmfJlNe1BepouQMm
	 OL0OyRRv5Y8RnQmXn5PONKGmn/0fsqiH0MG1cgKEUkwxYyJkDu33FZMKvjOgoGwLRE
	 NhVtkE5Bkbh7sUwGt8M2+TpvmiQ65f0oabTdgEiN2rez6qkKz/OynbYWwOXWJaChny
	 rFfrbxx3GjsVsTjPKVjvT+hm1NMe4bONPUHKN3vgunzo3QYBz3aqPjLmZ22MbT6aUh
	 /UAuW4t+M0D0A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C5719C53BD3; Mon, 11 Dec 2023 14:11:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date: Mon, 11 Dec 2023 14:11:07 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: manu@unam.re
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214311-11613-jwq664whdL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

Manu (manu@unam.re) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |manu@unam.re

--- Comment #9 from Manu (manu@unam.re) ---
I had the same problem with Dell Poweredge R340 and RAID0. I could not veri=
fy
with UEFI because If UEFI is enable it does not detect the VirtualDisk.

My fix for linux-image-5.10.0-26-amd64 was adding to grub CMDLINE
"intel_iommu=3Don iommu=3Dpt"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
