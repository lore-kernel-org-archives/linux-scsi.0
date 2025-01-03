Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4F1119A
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 02:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735871163; cv=none; b=eYbT6Xck69AeLd+BGVHuZJTf0UPUlpeV9RewZS6uFY2TKgZmsNt6QSfH7d9ufM7kbZJwgE8Y4+1ELOH/bj4qMhxsVAxQUaQ9GCBR5x8eIgw6qyuvad06lhVXd+ZREmn7jExQlaMpYdSadjxK8RUZ3pwtnxfFCsJF0zWQSHg/mbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735871163; c=relaxed/simple;
	bh=VISwiCA3dLo8wjYs1UzqFfiiSCNFXn1IVVtsUtPUAqg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HPHiZ/Z93GdczzzIBJNazIKkv/iz7ISEMhmdr77nz44YCeYIB/811gItcUEFh9QPN5NSxR6Hy/C0GdU7bm8YWLZo2yEpOc06tKwiXxIzfMBbf4p0eBOD5pvUI3VhPOW9Xyqqg7JYbd90BZjYjT3oJ3QW8mvCwFd0dkjThKPuPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rr1Vzd0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rr1Vzd0A"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01932C4CEDD
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 02:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735871163;
	bh=VISwiCA3dLo8wjYs1UzqFfiiSCNFXn1IVVtsUtPUAqg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Rr1Vzd0ArQC2QMeT4hQYjuy0cU5A0t2mw3DBSQNo57JErUDFvwfrpm0m9iDHUYzYK
	 Je91NzZs7APUallerE6yb4fUZVXJ2ApdvRE7zKuLIgsiXLW7AF+ZE1fuTKPRyYov4n
	 nr/WfZ4ZE3mpBHuTICJ46OwNvmvQl27mKnCc/6/v1ktnJ3TFvuMp6UZvwh8UMCdi2v
	 Ko7sxujh34Xe6E3QLXDty4kvx1HKwAfLMHnBFDF4vAXxfmpJPeUloR6+e0gEFKus5A
	 QyvF1dIQtNNXphfzZ6bIHMx6HOUoSPeN0c2y0gyeq5ylGi4row3vETbcWRVYCUg7Mh
	 iDkCuG2o2abYw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E0928C41614; Fri,  3 Jan 2025 02:26:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 02:26:02 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugs-a21@moonlit-rail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-fPVVd6wRXq@https.bugzilla.kernel.org/>
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

--- Comment #8 from Kris Karas (bugs-a21@moonlit-rail.com) ---
For Martin in comment #5:

    # : Working kernel sg_readcap
     00     ff ff ff ff 00 00 02 00
    # : Ditto --16
     00     00 00 00 01 5d 50 a3 ae  00 00 02 00 00 00 00 00
     10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
    # : Failing kernel sg_readcap
     00     ff ff ff fe 00 00 02 00
    # : Ditto --16
     00     00 00 00 01 5d 50 a3 ae  00 00 02 00 00 00 00 00
     10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

As Michael surmised, the only difference I can see from the above is in the
regular READ_CAPACITY, returning ffffffff normally and fffffffe under the
failing patch.

For Alan in comment #4 and Michael in comment #6:

I spent a couple hours staring at the code (all of it new to me), and the o=
nly
thing I could see pre/post patch is that the retry loop was moved one level
down.  Commands passed, buffers, etc., look the same.  Timing/Race?

Command buffer is a bit bigger (16 vs 10).  sshdr.ascq is checked (=3D=3D 0=
x00)
pre-patch but not post-patch.  Retry count 13 vs 10.

Can you guys write me a couple sd_printk()'s you would like to see in there=
?  I
am not familiar with the structure extractors enough to craft a printk with
useful info in it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
