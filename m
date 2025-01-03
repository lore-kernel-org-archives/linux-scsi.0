Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7229E9475
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735869743; cv=none; b=sVzeB2YjbuiUhp48Jqt5xmXRKbvYf0EY9Euk4dKzjDXjyc8QsZ+hplBzL+iSUrVT86nGyfmtbv1Gkaz/3T03cInpV++tXDTwLhCo9JesoDPit9qPthaaGaMoXdjLLfhjaIn2uYk7s4MulMcZPrHPzOJzjubB7t9ZSKM/fecnjLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735869743; c=relaxed/simple;
	bh=Uqn98ZcFTTfN8ZAR60khU4ftnY47UINfLi82sDKUt4E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hEaFzFj9skpEw4bypsVCnpG7MSPWhV9Ig4/md15pvzVx+qSeuvCvO0ZrDXqOeoW2W+2a5GelIpdnjmgUOQDmmd2ZfusA8w0T285Ekk4SgTos1Pm0B5JY/NiNRDklVMXhmIqvRUa1x4MBZxEHCz5sYXqD3Pe51ahCiwHCuLG3NXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjxy04mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjxy04mU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9D40C4CED0
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735869743;
	bh=Uqn98ZcFTTfN8ZAR60khU4ftnY47UINfLi82sDKUt4E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gjxy04mUENGruOVmFgcnvayy979g/Arb7lsqOVmF+db7WYR6V7BlIVKzzchlD3Opx
	 7M0pGlJt9L7qZ7FbUwpfjSLq9gwHJDywJpFuC1/U9MJOq/huVk/P5cncPxCjGVeHZ8
	 VnNw1Yy/ikY2hHigywvn6EKdtqcsfABXZHzCERfJ3LTiSg7azOLbjnqqmFbfuqciK+
	 tGgMGqefNF0Kw/pE29fO1GpGoxD6F4hORSv6zN8/Mr04FbzVQNZ5hFGIvAikTX4WhA
	 PgM/K92cJRUMIoFyEdG2dZD+e38R0a0qhfhEqp5fYZCZhRZbmHsO8+/IACwAD9q1Hb
	 fSMbNXn7uT1mw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D775DC41606; Fri,  3 Jan 2025 02:02:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 02:02:22 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: stern@rowland.harvard.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-yrS1zqkPr8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
References: <bug-219652-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

--- Comment #7 from Alan Stern (stern@rowland.harvard.edu) ---
The two kernels perform identical USB initializations, and the two SCSI
initializations also start out identically: INQUIRY, TEST UNIT READY, and R=
EAD
CAPACITY(10).  Under both kernels, the response to the READ CAPACITY(10) is
0xffffffff blocks with blocksize 0x00000200, no errors.

At that point the bad kernel repeats the READ CAPACITY(10) command, issuing=
 it
a total of 4 times before stopping (the fourth time, the returned value says
0xfffffffe blocks instead of 0xffffffff -- I'm not sure if the device does =
this
or if usb-storage changes the value in flight, but it doesn't really matter
because the error has already occurred).

By contrast, at that point the good kernel issues READ CAPACITY(16), receiv=
ing
a response of 0x15d50a3ae blocks of size 0x00000200, the correct values.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
