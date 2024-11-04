Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AC81AB6EA
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730760449; cv=none; b=c2Q3C9Xx75Pxnczvc46Ny/HxS4XSBXrCf5Sr0y2yG71mL7BXYanf3jcvTynl4hiztRC5IFNl9T3ns3aWSTdxdJcV6X5Y7u++wZiUTW0s2n+YGDSp8IN+CeBYcdQmZYGaf1mvbLSP0whCg/vFn7DdqRoagAPx20s7U/xtMO1UFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730760449; c=relaxed/simple;
	bh=q8nzBUid/dmACNcq8jO0aGD9Y8udJfyrv2YmYBXd7NI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gPZ7I13plK+OgmUAOGlytR5H2NLUKVGjJlZ60Njl6UjCqnjNVcsVgXqQMdVZzqNaBa3eAV9v/J0apXafq1bZgz6HAotoR4c15Pv3iVntztYNn9FQ5CXFVOvFqeCpoRiwA0Kcb9x1SRUHDjQERPDNGaffBHXkJYN7qOG5MPOXHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eli/i3ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eli/i3ex"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97370C4CED4
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730760448;
	bh=q8nzBUid/dmACNcq8jO0aGD9Y8udJfyrv2YmYBXd7NI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eli/i3exezXk6f9/1glCNh7rSyMSuBv48X31T2Z7rRjz5GwX/qQzk92bUqbsaPlqP
	 RyQjam8HMn8w46gwlXOGTBxOV7gpVP07yD60phZ0lFHO0uSgQOEtmORClDij3D0mBb
	 7EbgU9GkqDWwoRyYqn4LUIJwVEHEkGgZT4udPQwZxc7+NoiSPnWY4pqRl+33d4bUVe
	 SUywoWG5MgM3uWK8T1CeD7h6BQHWV/C68Q1ugHu3tjwI5GdGsc78/dg7U8zctX1jTN
	 IoK2u2GKAg5VLvKW1szGYzR3Bv4Am3RsPaVi8p64K9DWcdLREap7KZo+bxw+Yhd7iP
	 VfZBI0X3He2yA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 87E6BC53BC4; Mon,  4 Nov 2024 22:47:28 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219467] Adaptec 71605 hangs with aacraid: Host adapter abort
 request after update to linux 6.11.5
Date: Mon, 04 Nov 2024 22:47:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel-bugzilla@cygnusx-1.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219467-11613-3BybXnKlVW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219467-11613@https.bugzilla.kernel.org/>
References: <bug-219467-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219467

--- Comment #2 from Nathan Grennan (kernel-bugzilla@cygnusx-1.org) ---
Normal boot kernel messages about the disk controller for both version of t=
he
kernel:
Nov 04 11:31:53 storage kernel: Linux version 6.11.5-300.fc41.x86_64
(mockbuild@a0564de4e00d4277aa3a51770ad85255) (gcc (GCC) 14.2.1 20240912 (Red
Hat 14.2.1-3), GNU ld version 2.43.1-2.fc41) #1 SMP PREEMPT_DYNAMIC Tue Oct=
 22
20:11:15 UTC 2024
Nov 04 11:31:53 storage kernel: Adaptec aacraid driver 1.2.1[50983]-custom
Nov 04 11:31:53 storage kernel: aacraid: Comm Interface type2 enabled
Nov 04 11:31:53 storage kernel: scsi host2: aacraid

Nov 04 12:09:05 storage kernel: Linux version 6.10.14-200.fc40.x86_64
(mockbuild@2cac3d8aa36b4f0888a34a961cba75ab) (gcc (GCC) 14.2.1 20240912 (Red
Hat 14.2.1-3), GNU ld version 2.41-37.fc40) #1 SMP PREEMPT_DYNAMIC Thu Oct =
10
18:49:57 UTC 2024
Nov 04 12:09:06 storage kernel: Adaptec aacraid driver 1.2.1[50983]-custom
Nov 04 12:09:06 storage kernel: aacraid: Comm Interface type2 enabled
Nov 04 12:09:06 storage kernel: scsi host2: aacraid

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
