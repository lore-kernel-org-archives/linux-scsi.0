Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473EC13D51C
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726908280; cv=none; b=sd24FObzHpSP09VMHQq6AGxiK2n2wAzZ6IdeUI3HnRiFKLZ6V/wWOetgFT8D0n1+cJIkl6fz+vqOyvYfr+oG11xJ5O7+kYPG9fSoQ/21Xe3Z8dQxjw5pKtZrZdJ8QtDLETF49xRVOhRBjjUPoqlMuIjP3mXD/s/h0sxwixLKjPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726908280; c=relaxed/simple;
	bh=NLJwiLmhadbmBTo6z5Vzexb4S0CyodltMOGKH8EdurA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gE11zBcMH/o861GI+WGCYces609ufLeltnyUoQL2XVwKVGkknwpwUNr/imwzLJjzO7t3cRJA43ztLq2FuD3JsI00lTKVS61krn+vzK3KVflXzw5AbAxFf4ESY2ppWi+KLZ82RDgNCBPAoNBwiOrHlm6a7RPxw/28MpbxcoacXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSfRYNcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSfRYNcG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE13DC4CEC7
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726908279;
	bh=NLJwiLmhadbmBTo6z5Vzexb4S0CyodltMOGKH8EdurA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZSfRYNcGONcLezHpYCoBT1cZcbA//SvsQhnL2EplrpiA4z0qaOlbO4tjInQOHky3h
	 Ro7MApJzJobqN1EuX4UwNo8v9q9nKttOo5D1crFXgrMWxgzWH2dWqrSknM2c3RR4sN
	 7wQ03dnILxRib3RlVUAClRw22a3SDzTi++Z3vRqachKU8IEsRsZwd+y+9ce54erqjB
	 o8xFRsi9g17T4/fTbZ32oiQ778Ezd2yenf4R+NXIf7fizfsit5Y5VB4XtCDZDFKISt
	 h7eKEHnVBS/PRdpQ+QaKRQjcRe/sxBwyxCpvR0wJkBxuRBlYyOESj+L2fdwGmt7omX
	 tbUZMSvJIafuA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A468CC53BC8; Sat, 21 Sep 2024 08:44:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 08:44:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cf_kernel_version dependson
 cf_regression
Message-ID: <bug-219296-11613-Pi1SGogXAa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219296-11613@https.bugzilla.kernel.org/>
References: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |aa3998dbeb3abce63653b7f6d45
                   |                            |42e7dcd022590
     Kernel Version|                            |6.11
         Depends on|                            |218038
         Regression|No                          |Yes

--- Comment #4 from Artem S. Tashkinov (aros@gmx.com) ---
Damien,

Please take a look.

There's also bug 218038 which is a fallout from this patch.


Referenced Bugs:

https://bugzilla.kernel.org/show_bug.cgi?id=3D218038
[Bug 218038] bbbf096ea227607cbb348155eeda7af71af1a35b results in "dirty"
shutdown
--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
