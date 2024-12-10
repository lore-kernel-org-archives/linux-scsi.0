Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD941BDAA2
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858007; cv=none; b=JtJFW0D1n2a2S5xCKSLDvgEf8HcfX9GRWT0iRSxt1HJujSxYEmMJTjj+UtsGczKtiMtXA9jp+POpAOfHz7O+cphxx2oE2XjSw/MWCEmIDKmsHpZ4DkvbuUoXq7p3+0r1fcL0+52FyXh4UzBoEyA6qqYeM0MMHxCgd60nU7zlb8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858007; c=relaxed/simple;
	bh=77h6Je4z57EpIDmVcEU5N4R/RGyFVJ4wjFwVzjY06ec=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HbGxVxcfkDiNvgkqAjmr+0ytJdvOIs030yemE3teSk7u3wKeIbsLJxOPyM1dNpiiPU+oH6BQ9fSLKGy8PGGwBWWl9uxJ14hF6FncFC3ApPTtcnQ1Q4r1INFbhawZFbXn7pJZjE1jseYphcf1hU2S3CSBkBWdYfw8j5tEOJFHCD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hC/3Qn4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hC/3Qn4N"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36B12C4CEDF
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733858006;
	bh=77h6Je4z57EpIDmVcEU5N4R/RGyFVJ4wjFwVzjY06ec=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hC/3Qn4NGPc/NO+2/ZUrgyIRVB2K4Tr3xgbegWgdkMMje1iStEFj/WbWRlWSjxDaf
	 uaZUrPR0O1mLeE780lvEUMKlv1ZkTCjG0L97rtn80vwBmKvZ3e8ZBZ8HV7TE866Gyy
	 gCseakhlMFHagCNfesvBBo7tbsvxik5x5kyXU4HIOneeXMIw7SdL9NmX4x8S/YfNBS
	 7HstBY3W8s0fuAJXtCSw0Teb3hbPOavj0KJ8Zk/ewZq7mFI8yDN838HTgu69gEMJux
	 UYuDaiFq7Jg2eJSAx0vTGyKRAOdK9thazNCnIwctDTatOd2aNtwkU+7H0brJSkn/e8
	 DV5fdu2EZer7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1F3E8C41613; Tue, 10 Dec 2024 19:13:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219575] UBSAN: array-index-out-of-bounds in
 drivers/message/fusion/mptsas.c:2446:22 ; index 1 is out of range for type
 'MPI_SAS_IO_UNIT0_PHY_DATA [1]'
Date: Tue, 10 Dec 2024 19:13:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej.jakob@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219575-11613-i8SFH1zq6p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219575-11613@https.bugzilla.kernel.org/>
References: <bug-219575-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219575

--- Comment #2 from Jernej Jakob (jernej.jakob@gmail.com) ---
I tried it now and no, it doesn't appear in 6.12.4.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
