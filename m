Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAE02E2EFC
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 09:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758189451; cv=none; b=eJBpQmZypzOHyVjErkXp2dA5wYnDp4fmQKD9J9j3PDulZ0i7D25ycXvxhiayRU6cAWew9GDnZ87U9/G/dn48Rk87tFBMSLOfy3heWDF5btAC55piSl6ra6/RUAGhuIo8OtLdqE+7ozlV/AT6Hr2R977dSEt2evEF+HTymQIHatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758189451; c=relaxed/simple;
	bh=DqU1N+O/wes0P065QC+RNWMhMh08T+1GH6wdnFBI8GU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qk0BV/zuBQOmqHY7Vi4jM+vFTLPdFyVWUkma120cVsxEIBPETVPdH2CcF7IpxMR7M9klkhYYJTGmoMQ/GHJ1/axGYMEWAzQtZgn5o/5WEGx+wHXGXoPQ2XJu8/BljYwgcUJENbG7RN2LmmKAKX4u75IPHLDbDhy3WepHKET0dvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQCOvLPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQCOvLPY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3AAAC4CEF7
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 09:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758189451;
	bh=DqU1N+O/wes0P065QC+RNWMhMh08T+1GH6wdnFBI8GU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nQCOvLPYfkQfsvNb33kdjsKmQoABoeCoQ0h4zh5DNXWOplfckaCASxCX0fYiTvrLW
	 KS0Rp32nf4Knx3Lv8E6UA2VNWQNtud52cTnfsvaPXuDZvEhOradz268V050DIup+rF
	 1BV+Rd2/mxtl2VLMfoO14D7xcQeSYHwFVhi6KXODKR72foHWvQE8bhTY8yP/twK8a0
	 8wb+yrkbNyMpHMzChIXP1lk180rWWWS2hVGXZ44p3t7N0MqhZ660ww9JDSkVJwRlJ1
	 NZULyQw4YFoHXsf+WcJWuRbrhJa3oPF3RnzbOnr7lR36+lnDH4bu34tWyzHdqcXrc7
	 dZz6/JEEzR4MQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E4B01C53BC5; Thu, 18 Sep 2025 09:57:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Thu, 18 Sep 2025 09:57:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: dmmnychl123@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-85101-11613-hbW5sYmPBY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D85101

Emma Alva (dmmnychl123@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmmnychl123@gmail.com

--- Comment #11 from Emma Alva (dmmnychl123@gmail.com) ---
Try booting the system with no peripherals connected first, then add one
expander, followed by two, and finally connect drives to the expanders.
https://tinyfishing.co

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
