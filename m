Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407D958101
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5bdDnIe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF5E4C43395
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 15:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700580436;
	bh=96KMETF6N+cfuHNSaFkNT6AZN4xvf87WsaEbKhn1W6g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t5bdDnIeXy6iNPRiOcxP6e1y40RZebDthlNfE7tBoxjPPwM5+RlEfBZ1TceSepr0w
	 6VT2QniUZh5tnHkIPqsQC4MI+nL8im5zqwbA2LztIvtHWG5Y4KZgOZO+t763J10Ilk
	 5n8K/wvFmLvwODnC9+kjhnqirNIH/gTXrZgZGB6UTQpNdGzrLa932Qcen4Ecd8551C
	 w1D6kM7VJfG5RqBA5ew0Pg6IVWFWcP6DOOq/RGoMJYydXy3cbCNNoRJ8FLjHNuQY3h
	 C5hcVBxGQGoPqj1G5Cu3N3v/ubteXo8deIIHGg4RV3YPFKD/MDGn1BMtmPudeAIheK
	 QWd3b4HCnJs4w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9D973C53BC6; Tue, 21 Nov 2023 15:27:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 21 Nov 2023 15:27:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: john.g.garry@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-UrfRGVHYSV@https.bugzilla.kernel.org/>
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

John Garry (john.g.garry@oracle.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |john.g.garry@oracle.com

--- Comment #33 from John Garry (john.g.garry@oracle.com) ---
Hannes' patch was to revert to using hw queue #0 always for internal comman=
ds,
and it didn't help.

@Sagar, Could there be any issue in using hw queue #0 for regular SCSI
commands? AFAICS, that's a significant change in "scsi: aacraid: Reply queue
mapping to CPUs based on IRQ affinity" patch. Previously we would use
fib->vector_no to decide the queue, which was in range (0, dev->max_msix).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
