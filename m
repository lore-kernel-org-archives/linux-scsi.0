Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3805218026
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ER6YbbhT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFD5FC433C7
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 19:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701633046;
	bh=xfNCrb/1HjN0Av9C0TdcJcA5iVBiH6tfgQ7DPqmCWug=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ER6YbbhTt7C5hfbJjtu4tmCzExnEqqyV+TYXKL0EP17BaWzYGD9gE7pC+jZ8NQ7vI
	 zF6UdgpP8KDzIBoIbjUH3AxoZwJoGMFgw0S/GttEtvyjmW8BotzLGwpfsOddrtyirA
	 NVjFZqOC8C4/hnovT4ijYnc1ak2hGRxjmbrEXX45oo032zfHYZM83fsZA4GMJ8az1+
	 buJSJjbDWZWK2gxRy2SLr477Phy8EAkeVL+Y/OEA9slUwbxBGV9pty1wRmrkF7Si0F
	 CP/TylhK8hkA1bnRyjsT5QI/fZID4SCalurNUZuWE/4fP2mc/BFC20xCrU29eFOo6/
	 uyBrQKdVOdb5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A5B04C53BC6; Sun,  3 Dec 2023 19:50:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Sun, 03 Dec 2023 19:50:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: phill@thesusis.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-4m8lH62VXx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218198

--- Comment #12 from Phillip Susi (phill@thesusis.net) ---
bugzilla-daemon@kernel.org writes:

> I guess you need to ask Intel.
>
> I assume that their firmware simply requires the DEVSLP signal to be
> asserted in order to enter lower CPU power states.

I would say it's the hardware that requires the ata link to be powered
down, not the firmware.  They seem to have decided that the way to get
the hardware to power down was to add a new state to ALPM instead of
using runtime pm to actually disable the port.  I would love to hear
from Intel why they went this route.

> If you just send a command to the device, if it not easy for HW logic
> to determine which state is in. It would need to read some registers
> or similar. Sounds way more complex than just having a logic gate.

I'm not quite sure what you are getting at here.  The point of the ATA
SLEEP command is to inform the device that it should power down
everything, including the SATA PHY, and only keep a simple logic gate
active that can detect the big and obvious RESET signal from the host.
It seems to accomplish the same goal as DEVSLP without requiring hacking
in another logic line somewhere that wasn't meant for that purpose.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
