Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C3F29A2
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720664512; cv=none; b=H1vDdjVNYMYkRJCLIhhvqlIuGpWZn8pqntEm6uE8hiz9+3tWzBaRMzqcBlsHFRuZ6FDgLh+qkcA/hYV8X/AZzKCwsCGvionU5kGSLYbJCaQ04EJs+d2GtLmXw+zNcTkK7JBy8Pha+/z9BbND1KinycjKNqaLOoU4EoErZ4N8fjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720664512; c=relaxed/simple;
	bh=Z4eYIhAIpPzR7KvVH7SvdRBxljKgXD4yxtIo7verzGM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QCvUIlQg3uIINJzCj+QOtXUZRdsyu3GPmhy9oWqrMgieKLoxQyX9wZTyymovpY3WANzgREUHR11kxERiudJhX5Tv62RTmRE8BPcUKLkTPvSqmjIg9sMI0LBst1fGxNzKqCITib3+9dt0p8S+sF72AWUvADaywdeFgDGgo0jDPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBCTgAgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBCTgAgG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 058F7C4AF07
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 02:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720664512;
	bh=Z4eYIhAIpPzR7KvVH7SvdRBxljKgXD4yxtIo7verzGM=;
	h=From:To:Subject:Date:From;
	b=WBCTgAgG/IUug6uPqnFP8LLUOE9Gr2Uz9+tdu+GPq6D9kg1RBBgzb4W79Lp37GItl
	 oE1SAuAMYByX2Znm192M4BK9jzc/f8IgGoThGDqHuw7hMfPjrfdxvVzVfCiKp89f40
	 7gL2iLmTLklYS6abH8L/fescNcfEHCDnr/ZsXAwXERA82biqP+Fl+bEe0r7NPQ6uUU
	 FV4t9DoWxgeiSLlm2s8INglFKcnHDsEulia8W/vcGG2mjsf7QCh5Ags20oQT2gP+va
	 dkyIssR+YsccUk2TxIpNi0mz778r5PShpCA8EIgcP/dPamkyEZejFzT7+qIDwCt73a
	 EJ+d+9U87dFDQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ECA48C53BB8; Thu, 11 Jul 2024 02:21:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] New: The SCSI can't adjust Max xfer length (blocks)
 with different storage device
Date: Thu, 11 Jul 2024 02:21:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219027-11613@https.bugzilla.kernel.org/>
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

            Bug ID: 219027
           Summary: The SCSI can't adjust Max xfer length (blocks) with
                    different storage device
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: 983292588@qq.com
        Regression: No

My storage device CPU has a 64kB (limited by hardware) buffer used to cache
reads/writes which means it can only cache up to 128 blocks(512Byte) of mem=
ory.

But the Linux source code says that for USB2.0, the default max_sectors=3D2=
40
blocks. So the SCSI Write-10 and Read-10 command has a total-blocks field t=
hat
can be up to 240 blocks (120KB) for USB2.0.=20

When originally testing the product on Windows 11 it never writes more than=
 128
blocks at a time. However, when tested on Linux it sometimes writes more th=
an
128 blocks(240 blocks as setting above), which causes the usb storage devic=
e to
crash.=20


Is there a way to tell the Linux host OS not to request more than 128 block=
s?

My storage device's firmware has implemented block limit VPD page (page =3D
0xB0), and it works well on Windows 10/11. I even set the block limit to be=
 64
blocks, it's OK too. Because before the data transfer, the windows host iss=
ue
an SCSI inquiry order with the VPD PAGE CODE =3D 0xB0, so the device could
transmit the block limits information to the host. And then the windows host
could adjust the amount of data transferred.

However, on Linux or MacOS, the host does not appear to be running the block
limits command. So maybe the host doesn't know what is the block limits. Th=
en
the write/read blocks number beyond the buffer size.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
