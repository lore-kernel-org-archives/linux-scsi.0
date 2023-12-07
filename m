Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9824A3D0DD
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcyQxFd6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C8C0C43397
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701957345;
	bh=9/znfTElNxgOBUWf0K8xQAFlXAnJ17nWEAhkuzsbW88=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NcyQxFd6Hp9VQj0OD97OMc62h2Oqo4w8iZzwXI5xowiS3UF1EVtKwanLOK0ovxdyw
	 KTcd4VFu+LoGlZDdSoLjfpuyJrZFzCHLVn3Ga5nXz0kmo4cfb/zAmPvcwhCozpOl6i
	 KsJphQjd7rF5QoKctcS0GVRuXa6PvzTNG0m3uJg0M7e4df+lNcQkMGahXTMvxwF1hk
	 MfsuvEb0BR2VVA/cbh5vPRnzZ0+NfgJAnChOdnx082/vknKODkH9bw6DthwMEgd0S0
	 kZpMiYW06EtH/ZQ7oUdsdfC9NSkTSdVvaiOd5JYY6G3hcRSb0+j9bGndZGErIYqvMe
	 wpPVOIWJfED3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 57903C53BD2; Thu,  7 Dec 2023 13:55:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Thu, 07 Dec 2023 13:55:45 +0000
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
Message-ID: <bug-218198-11613-pWKj6cstOG@https.bugzilla.kernel.org/>
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

--- Comment #16 from Phillip Susi (phill@thesusis.net) ---
bugzilla-daemon@kernel.org writes:

> No or at least I don't see this behaviour. However the drives occasional =
seem
> to have some trouble waking up after resume and hdparm -Y:

That's strange.  Once the drive is woken back up that should once again,
prevent pc8, just like it did before being put to SLEEP.

> [59984.831894] ata5.00: exception Emask 0x0 SAct 0x2000000 SErr 0x10000
> action
> 0x6
> [59984.831907] ata5.00: waking up from sleep
> [59984.831914] ata5: hard resetting link
> [59985.145261] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [59985.148840] ata5.00: supports DRM functions and may not be fully
> accessible
> [59985.153322] ata5.00: supports DRM functions and may not be fully
> accessible
> [59985.156822] ata5.00: configured for UDMA/133
> [59985.166903] ahci 0000:00:17.0: port does not support device sleep
> [59985.167045] ata5: EH complete
> [59985.167268] ata5.00: Enabling discard_zeroes_data

That's normal.  The way to wake the drive up from SLEEP is to issue a
link hard reset.  That's just the kernel showing that it's doing that.
At least the first part is normal, I'm not sure about the bit about DRM
functions.  The bit about the port not supporting device sleep seems to
be your main issue with it not getting to pc8 using ALPM.

> Regarding your patches: Anything I can test for you? :)

Keep an eye on the libata list.  Hopefully I'll clean them up and post
them in the next few days.  Initially it will just be to keep hdparm -Y
from being woken up for silly reasons.  Sorting out the bigger problems
with runtime pm so that the kernel can automatically put things to sleep
when idle is going to be a bigger issue than I first thought.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
