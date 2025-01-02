Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9002D17C68
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 05:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735795603; cv=none; b=gNHbTvt2RRWvMUi7+782PfZQ3uqzwkUhixYtuiowcvqTMhmwJfD+Jdht8Sjlvddf1psEwbRJMTtvBlWbvPYkEA0ZxMYHvFOB/SiXJK7Ct9wx4BooJXrPQ0axcaPg5OkfThkc2zjES2+voWXmrkF5vuAx4soetI0+d/6Mwjk8Yik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735795603; c=relaxed/simple;
	bh=BPedjIw7SBkbAlxbeAoPQ1OkxepgtfcQJx2dq3dMb80=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SNpF4owgRsz5oh/GLuoSxqd9idz/LboQrm5lw/vOWxyxEdOJDh+FgBtPfcZTsCrUyI/N8oyWP6horZg4b/s0z2K0MyViVDe3caXkI+CtWax9k7lb4uIhWpcTpavT87wrOIFyYcX0a6j0/hCML5bZS0NYlcFSqP5zXrpMEZ0Q24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNN69wwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNN69wwS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11D13C4CEDD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 05:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735795603;
	bh=BPedjIw7SBkbAlxbeAoPQ1OkxepgtfcQJx2dq3dMb80=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QNN69wwS9xOBREIMRe3f+MSW52l29rUUdLlzZwihUr7Is2FINPZpyLE6go16/z/ZV
	 WV+QDG7Ca8RjwxZEXWLG+O+WA5oBFJyNvapZfsYVQ2/EVsP1/ktlLsrjFGavtyXwUs
	 Ij241HAWq4+OF+hNuRj/Oifwf4BMv+HOCIklgN7o+xP47beP/N0jwwikQcAQdIVgDO
	 z4hYseUUFTO+4CFUXuabtSQWtKXkT5+1S0TDrCmSSEOCcN6G8QJ5K3j5r5JSKv/tHB
	 IlndoVmSNFwLTefYhD8oPjgZbjkUQdUMR4CWUZeSv/zsyYeJpyE4kZI7y7hssZS91I
	 gpUFiFVnjZxSA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 05D33C41614; Thu,  2 Jan 2025 05:26:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 05:26:42 +0000
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
Message-ID: <bug-219652-11613-e4TORKU2PI@https.bugzilla.kernel.org/>
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

--- Comment #3 from Kris Karas (bugs-a21@moonlit-rail.com) ---
I had a feeling that Greg KH would amble by and say, "Can you bisect that?"=
=20
:-)

So, I figured I'd try to get to that first.
And the winner is...

    commit 0f11328f2f46618c8c4734041fdb2aacfa99b802
    Author: Mike Christie <michael.christie@oracle.com>
    Date:   Mon Jan 22 18:22:16 2024 -0600

        scsi: sd: Have midlayer retry read_capacity_10() errors

        This has read_capacity_10() have the SCSI midlayer retry errors
        instead of driving them itself.

I have tested 6.12.7 with that backed-out, and confirm that read capacity w=
orks
normally again.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
