Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD3C125D6
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 10:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735813035; cv=none; b=ivmiu+4ikzaD6UhadZimTAVlWDGpilqrPERfYtrooa0gKU1ShbV5cX6lyIyJaL1QKPel3dkMMC9Y/WWDI4Z0gMihNO8246MwF6gvlBV2KB9TYUHrhN9+ZDjxDiYQV9fFbmYRPUsQwOHTQWlcSJAvGuhXmG3f4VbGaCHQMRZH0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735813035; c=relaxed/simple;
	bh=8Yxobkf47zTaOf+dH1hY724RGyYkywaLcFNEaORNrHI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qY4dMXnUGki/AaOKTfTibaGT43fWHRXK6zkKwNeSA2YvHGWik+f4nReCU0NbMV4JPj7DRVNgwckgD2RezaAUFvtw7OQXF33v1JxJSE1gyOTuilqX0oTLQMWewqkzAj/w+UwuxDfsfbHY4pDYj8PFd0gKI6MMUPVYwRAHAThypa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjhg1G6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjhg1G6j"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11B51C4CED0
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 10:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735813035;
	bh=8Yxobkf47zTaOf+dH1hY724RGyYkywaLcFNEaORNrHI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pjhg1G6jv7OUAl9u9CXlcJkthtfJTNZGx/5ybwXacMi6i1Gr5YXzxtIsUSKFuvoWQ
	 y9Ghw1oC7vUN98u8yPKcS1mgJK0IoVASuLssk4xpoWbM1njrq501hKD8bwQuhTEy3w
	 2C5W40i9zUeeVzzq2Azq2pMcU8k62v9pLMRwB08lzhpMQJM2pxOhHAsvtKCrwgG0nG
	 K945uazCjpjz0B1In/LdZM4Gs0hEQH04YQp9fkTusMrgztQP2aLraaQ22h320KVYMj
	 QRFTOaDqbkHu6LZJqT336uAz3mzHMTD1j469ObyVK276YHMXRsM6+AwT5oO5epYuWd
	 0oAfi7SMdQKzg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0CBA7C4160E; Thu,  2 Jan 2025 10:17:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 02 Jan 2025 10:17:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: wavepacket@outlook.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-scOwvskxvB@https.bugzilla.kernel.org/>
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

Steve (wavepacket@outlook.it) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wavepacket@outlook.it

--- Comment #67 from Steve (wavepacket@outlook.it) ---
(In reply to Sagar from comment #66)
> Hi Maxim, Thorsten,
>=20
> Currently I am investigating this issue.
> I do not have a definite timeline on the fix, but I will post an update h=
ere
> once I am certain of the solution and the testing timeline.
>=20
> Thanks
> Sagar


Hi Maxim, Sagar and all,


I can confirm this issues are still persistent on Ubuntu Desktop 22.04.1 wi=
th
kernel 6.8.0-50-generic #51-22.04.1-Ubuntu.

Controller Information
Controller                              : ASR71605
BIOS                                    : 7.5-0 (32118)
Firmware                                : 7.5-0 (32118)
Driver                                  : 1.2-1 (50983)
Boot Flash                              : 7.5-0 (32118)

Issues found as of now:
- Adapter bus hang under high I/O: should be fixed by reverting with
c5becf57dd56 (as you reported, need to try yet)
- Maxim reported issue (#64), I have the controller connected to NetApp DS4=
246
and I face the same issue, very slow boot and sometimes boot hangs -> Maxim,
have you opened a new dedicated ticket for this?

Sagar: any update from your side?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
