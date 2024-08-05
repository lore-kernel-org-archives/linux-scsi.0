Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11F913D521
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722886124; cv=none; b=qisEnVlXKkv6FybnTpx5AFM6FpyVNoLYF1pwPqYM1ohu8k+HX2lCSKMXEJF/G4WByCCL4H4TFWscZMGgzn02kNAfFf6CedUFpQXBZ0Tf55A+IGNvY60GvKRkbXbVAZX3VD7PCKFsYzJUSwqQw7GSHavOh1hT9qMi29O7N/JFmAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722886124; c=relaxed/simple;
	bh=QhHPtG9dSKC7lxQi+ivS4FVFV6S2QWEyZMv/ipIw4UM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ciW6/eJ7SJ11w5kczv25yz0yAvb9njKVgJMqVDwo1hu9mM2EBxhrLFXwCAw3VpM+d2wamobiihO66dcHa6d3HVNZ7lbWR0gPJJExoVLAowdHKCjgQYLQj0Jxf7eIKVpvCFazc/UvIBJYKrp0oZ7PRNfN9naEVXusBwvSdgqJkPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnEMIc/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnEMIc/s"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67254C4AF0E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722886124;
	bh=QhHPtG9dSKC7lxQi+ivS4FVFV6S2QWEyZMv/ipIw4UM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YnEMIc/s2geg9EttnvASjFsGJgrM0tzQbh6i8PCkuGEoO/Sj4K1c+F3kRKQE9GN+6
	 yyBCtgqiBvoJOaI53sOMhCmJc1LoxXqW9LBGRcGnMc/+rXWcAq2LivUTdvVqWtEdfY
	 k08xR2ZdVisZ5I/XWJn9rhcCotl7gQ++gTIaMYlXeAoEdrrRPkzVUbAIOObiAhc3xY
	 Da92cfvUb+8jdUAWIbQmHd/pd/rqWOgys5GVVE9ekZNvKOAURKlU/0LmQLy3Mm9xaz
	 N2niwbZzTRU65hTaWs/8dcjE9Mp6bBwUtCCQUvZjFpUAiXJBVK0EVatMczuZRqIc2r
	 CVKGfUyoL6tag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 59735C53BC0; Mon,  5 Aug 2024 19:28:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219027] The SCSI can't adjust Max xfer length (blocks) with
 different storage device
Date: Mon, 05 Aug 2024 19:28:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: imyxh@imyxh.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219027-11613-lU3EiBbTKG@https.bugzilla.kernel.org/>
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

--- Comment #6 from imyxh (imyxh@imyxh.net) ---
(In reply to LXY from comment #5)
> What a pity. I still haven't found a solution.

Have you tried simply handling the invalid write/read commands by returning
ILLEGAL REQUEST with INVALID FIELD IN CDB? (I know nothing about SCSI; this=
 is
just as per https://stackoverflow.com/a/33372494)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
