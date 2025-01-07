Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF6C259493
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736220841; cv=none; b=e6/9nBxPLXjONyv6T0o0/KCw6sFnkWGLjY8CIUygK8Mv7nun2ILEwnJMsddcQvQslA48E/a8Pmbd9nT8AesDY1pwbpovEbuvWjBI0HGA7S2xIFX6L3PjZ6HIn16sOYzhzA7CNxAGZRfIY3zLNwGHf7aAwez1YFJNRy0Ywk9vLBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736220841; c=relaxed/simple;
	bh=VxiwwODegGwBFty7b9GkbGbA2RmJT4zHSKMKdZ6Gmns=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lA5v4e9ey5JY79Y5xKtihA/9kweLPt1DKYrJPTffRY8rPi5TgeBvMbEEh2oRdYXYPksNuOl9zTVBe5y/2ZnmrXFCRqw+9FUHrjr/zWHkUyxc50fdkpeh8i2KpdMItJOvJUt4CPlY844QQ2Ds0GsP5aIcwpFZjz21yOf6NZm9xDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGv0tV8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGv0tV8E"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 929E7C4CEE1
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 03:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736220840;
	bh=VxiwwODegGwBFty7b9GkbGbA2RmJT4zHSKMKdZ6Gmns=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MGv0tV8E20kJWugQ/kxf8FuQDU+qMrZiLMRcEEoDeAUBjrjWUa45HRViB2B6Eey4e
	 ylKTnab2S0dTzANl6mzNgQMKKcisut73B0VFYSl1hlxpACRiaDQe1nBerNKWMg18SL
	 0I7LjRlhKeZCSCYdusCCMWKBCAZUR0JK1uEnl8x3Tp2mstmxFLkd5jvuFYcXam9coK
	 F9INOPBn2u6gt3GJkaMy0PRtCkxH8T2RAKgEPvqtmhiH8yLI9Ad6e3R2aMNvFNFZGm
	 TH7dzo7t3iHuG192B9rWmB7DSHI1uMIMzdbHaKxCSON9nmhtSaWOwPL4R9y13ws1zY
	 YS20DUgqEuy/Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8A182C3279E; Tue,  7 Jan 2025 03:34:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 07 Jan 2025 03:33:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-5ReMht2qWA@https.bugzilla.kernel.org/>
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

--- Comment #71 from Sagar (sagar.biradar@microchip.com) ---
(In reply to Steve from comment #70)
> (In reply to Sagar from comment #69)
> > Hi all,
> > Currently the patch which caused the issue has been reverted.
> > I have reworked and I have a fix ready for this issue.
> >=20
> > I am working towards submitting the patch sometime this week.
>=20
> this is my dmesg log if it can help:
>=20
> [    0.801036] Adaptec aacraid driver 1.2.1[50983]-custom
> [    0.801047] aacraid 0000:03:00.0: can't disable ASPM; OS doesn't have
> ASPM control
> [    0.805979] aacraid: Comm Interface type2 enabled
> [    0.839258] scsi host0: aacraid
> [    1.933550] scsi 0:3:0:0: Enclosure         NETAPP   DS424IOM6=20=20=
=20=20=20=20=20
> 0191 PQ: 0 ANSI: 5
> [    1.947104] aacraid: Host bus reset request. SCSI hang ?
> [    1.947113] aacraid 0000:03:00.0: outstanding cmd: midlevel-1
> [    1.947114] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
> [    1.947115] aacraid 0000:03:00.0: outstanding cmd: error handler-0
> [    1.947115] aacraid 0000:03:00.0: outstanding cmd: firmware-0
> [    1.947116] aacraid 0000:03:00.0: outstanding cmd: kernel-0
> [    1.954062] aacraid 0000:03:00.0: Controller reset type is 3
> [    1.954063] aacraid 0000:03:00.0: Issuing IOP reset
> [   78.145262] aacraid 0000:03:00.0: IOP reset succeeded
> [   78.151156] aacraid: Comm Interface type2 enabled
> [   87.187835] aacraid 0000:03:00.0: Scheduling bus rescan
> [   97.589026] aacraid: Host bus reset request. SCSI hang ?
> [   97.589047] aacraid 0000:03:00.0: outstanding cmd: midlevel-1
> [   97.589054] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
> [   97.589057] aacraid 0000:03:00.0: outstanding cmd: error handler-0
> [   97.589061] aacraid 0000:03:00.0: outstanding cmd: firmware-0
> [   97.589064] aacraid 0000:03:00.0: outstanding cmd: kernel-0
> [   97.599053] aacraid 0000:03:00.0: Controller reset type is 3
> [   97.599066] aacraid 0000:03:00.0: Issuing IOP reset
> [  173.373888] aacraid 0000:03:00.0: IOP reset succeeded
> [  173.380165] aacraid: Comm Interface type2 enabled
> [  182.417010] aacraid 0000:03:00.0: Scheduling bus rescan
> [  192.812389] scsi 0:3:0:0: tag#164 timing out command, waited 120s

Hi Steve,
Thanks for your efforts with providing the logs.
Yes,  we are aware of the issue and I have put together a patch that works =
for
me.
I will submit it to the community sometime this week and please feel free to
provide me your inputs.

I will post the link of the patch once I submit it.
Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
