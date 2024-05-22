Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088DD51E
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2024 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716405664; cv=none; b=SQdk/j5RRmlgS+syEWVrz4JtiFcHs8vckiFNof0PzkO73cxiEpDa2jtXwOv5EZ4l92GqV33GtZGEnJtQb7mPFywynrDpxoBt0IeVd4yNQ8w2F8aRsFP0ld5CZ4pXSdFTjCiREvoocDn4PxEEy+tD9NIlwLxdG6MuItSPhzfPfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716405664; c=relaxed/simple;
	bh=szCRTL94970Mk43XbmnpaxoclOPQV1QAzSkefy8py4k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FFwyikuE6HVOcrJMuBUDgn9AZKT+9OFLJXL3UW240U4bYeEdfqKUA3o8P2gvIAzvm1IqGEnJ33TcTH7sspHiXAjnIYHg6jjLLwCWb/5C4wWevrZmF5+r3Y8+E08UpImOF3Zk13QoWU+ylNC7bOBCPQC9PgTBzw1SyiHTpkKAjH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8o7eRxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8o7eRxd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1A83C2BBFC
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2024 19:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716405663;
	bh=szCRTL94970Mk43XbmnpaxoclOPQV1QAzSkefy8py4k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=n8o7eRxdevGn8Tz76RLCbXJxBWN6edK0AuPMFGxymEHgwXACF0midUMDkHarFJJVT
	 QVZ4L6ikOEnEI6VE/E95kHkh+kgiO33i9eB2keJ9rFe77hQSMrwFJNYcSRHUstY4Is
	 wktBk4Wzf4qGQx7f8b28RcxlPd9P8N0Kew3h06k6HgdRGCjbUsB0t6VZDW7ac/jJ3c
	 xuV0ekve0dT74j2pxXmSJg6hkKClJi/pANGy+xqkIHpbVzitaQ2ESG7qBWpnqTKwWu
	 lWWHifPVvfIba1UIyDfnGQdqunjqHpkj0OLxENmOqH++ZmWvU/5CiOrNOaL4knoF8X
	 Sn6fEUywyvCvQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9BA18C53BB7; Wed, 22 May 2024 19:21:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Wed, 22 May 2024 19:21:03 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218866-11613-u6CtlHchkB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

--- Comment #2 from Marc Debruyne (marc_debruyne@telenet.be) ---
Created attachment 306323
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306323&action=3Dedit
dmesg

dmesg contains:

[   32.827175] /dev/sde20: Can't open blockdev
[   32.846921] /dev/sde19: Can't open blockdev
[   32.878496] ntfs3: Max link count 4000
[   32.878839] /dev/sde17: Can't open blockdev
[   32.884543] /dev/sdd20: Can't open blockdev
[   32.905281] /dev/sdd19: Can't open blockdev
[   32.922129] /dev/sdd17: Can't open blockdev

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
