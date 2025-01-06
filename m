Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421011917E9
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 04:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736137918; cv=none; b=dM6gqFvzRU9LxwPn/uD7D8zmXiBZmjgRVkRefeoZth/OqTZNuZtOq2MehLSHrQmHCUsQAk6JkaVfLgZ28ZpOw8kVxCRlbb8wgqdcuX3T/kCKleYKFPHJSB2I8iaS0Ujn+/hHYUUOtiHzNWkz+QiDKB22+wE4dCWmVAvQuB2Py3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736137918; c=relaxed/simple;
	bh=JteebABBMtcacaalcYbaqx8UuUwJuCB9e/cKaZEVQGg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TzK6x8Bdc+Or9f5U/MS/JcGTCiH5aUIfBwT1B1MiOB68iA662fjUMZCDinX8vOfbNFL9JuvSAQt6PL9APcuuY4ajYGSLS3U2c23iGJM0CK5pYuRpgrAZcONiuGvZ3qurbCo6dixj7mUx/IcpWLsipuCaks06KEO0GsqFL80+IIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Thl152SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Thl152SX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C082AC4CEE2
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 04:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736137917;
	bh=JteebABBMtcacaalcYbaqx8UuUwJuCB9e/cKaZEVQGg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Thl152SXqOHBARnMbalWcvFlt2g5dK+6Xtx3M1QLFaVftKacgs6cPr8JUxiLzbX3G
	 q9HA9HTQDoCxdQ0O5/3YBmcyyTgx4mi9T5MwxGyULy8FF40RiG870zWtGl1A79OOJ+
	 c+F+uUBMSmx2R54uMxZss1XzFSfIZfM1RDFLcH8NWvPfWLeMhLhPL0MQzvYrlrR38Z
	 6T7k/QLVyVrfQqaOSlrtOSpsNvazhlx1Kv9+a4M1mmsEPRlIkp0kpkj58CkGGGwzg7
	 51bVAjNZu8l7MEJJw4KThdEpkJ8HZHKTTE/bEt+RoDBiIJON8euLDDU3vv871xyhTB
	 tlfxSHDh5E4SQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B8D8FC3279E; Mon,  6 Jan 2025 04:31:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 06 Jan 2025 04:31:56 +0000
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
Message-ID: <bug-217599-11613-rdFczxK7rH@https.bugzilla.kernel.org/>
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

--- Comment #69 from Sagar (sagar.biradar@microchip.com) ---
Hi all,
Currently the patch which caused the issue has been reverted.
I have reworked and I have a fix ready for this issue.

I am working towards submitting the patch sometime this week.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
