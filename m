Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDFC14BF97
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061983; cv=none; b=aGLT4u9Ag6a/Ghuz3eAz/afIj9aSe8v/7gS+TISw7NzCR6Knu2LWqtor2y3QEaiVWzkyyfJ577judGGhxPMqux4UEYDqyMFwlhZ/R7EshqlP3tsTDwRnpj14T9EQ2IMXk5Xv5fhEwnR5gwQbNuxRHLPTg3BSUsClC1xg3PEQuGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061983; c=relaxed/simple;
	bh=xwU4KNgtNw2nqKOZKVrdCKKkfVJacUz21atrQ2SToWk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ytr/n5JONwmw8Z16hNdDCIsS8cJwvqCR2oINsgtK0OMsrSaZrFrJsiM+b2q2GE3eOkAiEcMTRtgcwgM73dWQnY7ZEQEUxlLEuBee5B6hzHaOdw20jdbcu10ESX5IlIi+yrPpUK3GnBSQq+mkjn0F1LYjcmkkCjUxoXIRqTTrN3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hl/l89fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hl/l89fY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF00BC2BC86
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772061982;
	bh=xwU4KNgtNw2nqKOZKVrdCKKkfVJacUz21atrQ2SToWk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Hl/l89fY1TkI6+Y9btoamPD/yzfMMfBoOl01OVmypgnLjij9zIRxanZ2Nmhu0u7ba
	 qvOXX6gMZoRy10Hd7oswapoPtqyc+hU1bt28x0FGtEdWjFYaQ4+0byGAJSTYPZDtLS
	 fXo6jwGzDXg3vPSuidd8fRmCEAPJvOXesVUNNj6d7XbqrNuaWQEvApJ+LAek2Ozqr5
	 OW+5sOWZr7QStcxdHkKxgC93MMjKgHhlCg3m4xawaq8OOjC5rw0cNw+FevFYzrZRmP
	 iP7N5Bibvn4k8iId80ZZcyk9+V1FwsoYfv+jkoE3s0leGbE8gLrTBrwoK1eer6QWs+
	 EWJQnlqUAnpog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CAAFFCAB781; Wed, 25 Feb 2026 23:26:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date: Wed, 25 Feb 2026 23:26:22 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216696-11613-lkgyAlYRMW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #10 from Kamil Kaminski (kylek389@gmail.com) ---
Created attachment 309465
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D309465&action=3Dedit
0002-scsi-sd-Treat-locked-encrypted-drives-as-no-media.patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
