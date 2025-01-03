Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5AA1AAA02
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735875002; cv=none; b=QUyn3P7UupdOw8Od0KvpMAFfq/pEeywwiAkNkyzC5DEkPU+vLeIxXLppNnvumITbJE7DNPG2o/n+u4v7glVTnYeR9bbUPEUvhcsfp3CrPGifCtCZ8I1FRK/3il84yJnDr9ZAqwlATP787IbEMDeITN6TvLxSgd+uhnemLS2Asu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735875002; c=relaxed/simple;
	bh=3J64ccYbxsPBCIoT0ynikNZTWf7jXFZ9ywbF7sMRBes=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sKKfTI7zdlpu+NkWfJNY2a7ud93iKaIt6j1lyD8aAbMdeuaMsp/Rr2jRqWkRz4CwfQhqf3arIkcV5MsEpUFExjM8TqcNPa2BKiTgf2ZTEHg9fIip8KcAUxBV4uTXyoCw9FVJFjFz5SU43hstAUX5VPFOSmNLPOiUhaq3ASRGfYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9pl5BW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9pl5BW8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6FA6C4CECE
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735875001;
	bh=3J64ccYbxsPBCIoT0ynikNZTWf7jXFZ9ywbF7sMRBes=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=n9pl5BW8EegA4h1lmMPRuYld49sF2vKCjgYazur3Mq0N1ZPYmJnNMxqXQ1lOTa6sA
	 jq9FHL5ZEvHVconR2VanHLqjaZAYLzXb553/XcSavU7BVyBr15j2L0Fzw3v3pdxRO+
	 +CiwKNl6b0SzLVpnUZXrweYCYbX6QXgZC87LQKBJKSXRkNaK46EMoWnNXRvuzOW2Wd
	 9lLqcLaddFMEwN44deFUbSVru2/O4e675Iq7nFojYaTvrzT4o87rxFUAfv3OFeMzK5
	 ScXmTgzzs9rFE23zQwpefuBSy+jmYU1D9jZv1txzN6Lu+mhMpFEZzJl7QdBrrGr8XJ
	 anccbmbNhCKhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DBA0FC41613; Fri,  3 Jan 2025 03:30:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 03:30:01 +0000
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
Message-ID: <bug-219652-11613-5LnvEcp66x@https.bugzilla.kernel.org/>
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

--- Comment #10 from Alan Stern (stern@rowland.harvard.edu) ---
Re comment #8: I would like to know the answers to the questions asked in
comment #4 about the bad kernel:

   In sd_read_capacity(), does sd_try_rc16_first() return true?

   And why doesn't the "Very big device. Trying to use READ CAPACITY(16)" l=
ine,
along with the subsequent call to read_capacity_16(), get executed in the b=
ad
kernel?

   Or does read_capacity_16() get executed but return immediately with an e=
rror
instead of communicating with the device?

The whole business about 0xffffffff vs. 0xfffffffe is a red herring.  If the
bad kernel were working properly, the issue wouldn't even arise.  Notice th=
at
you never see the erroneous value under the good kernel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
