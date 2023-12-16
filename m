Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0641212B85
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 05:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxOxuBj3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CCFCC4339A
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 05:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702704927;
	bh=5iKtdCFjgq5745qvGECjqmqRowxZfQrHrHVhpKxRhCo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oxOxuBj30UyZU9MV7qG5JnTpufMcMAqiEQEWgyRjs3T+9sR7dBY2/ED9ES/Lzhlk4
	 Qqc2z+Oy3+s0W8dBDY8acQ20J+AebapzZaJVoXQDLLub12CllN/P0IQZPq5HUn9YdV
	 sFExovrDKOfOPRC62X4v0N11VWewu65ipcn+R0gVv0ScsMgSY8dlaF2FZN5wFvC6bT
	 CvdD15b3xuUbWrGMtZx4XjDPZAE9hiuYpKWcTDgd77LG6/bV21UQ7GUSczfQWnF154
	 150pvy1laHLRZvbldLCR+8nNJgkD5CWSb6TPcfnobYxdvEEeBcTzKUvtiKUZapXnDb
	 GCoH6aBYNNHsw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5C77FC53BD1; Sat, 16 Dec 2023 05:35:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 16 Dec 2023 05:35:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: encore2097@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-eRvgA89PTH@https.bugzilla.kernel.org/>
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

--- Comment #48 from encore2097@hotmail.com ---
Hi Sagar,

I'm using a setup with 10 SATA disks in HBA mode and running a zfs raidz2
filesystem (akin to raid-6). This is a single CPU system so I don't believe=
 the
CPU count is the main issue here =E2=80=94- although its likely related.

From examining the logs, doing some research, and drawing from my experienc=
e,
it seems that timeouts and queues are the primary culprits. My suspicion is
that during heavy loads, there's an overflow somewhere in the stack (could =
be
in the kernel driver, firmware, or hardware), causing I/O requests to get l=
ost
and timeout. After a series of these timeouts, the driver triggers an error=
 and
resets the adapter.

I stumbled upon threads dating back to around 2017 where users faced similar
issues (check this one:
https://forum.proxmox.com/threads/pve-5-1-aacraid-scsi-hang.38259/). One
suggestion for a fix was to extend the disk timeout window for waiting on I=
/O.
However, the current kernel (set at 60s) has already doubled the previous v=
alue
of 30s, which makes me think it might not be the root cause but is also
related.

I'm not sure of the physical disk setup of other users connecting to their
controllers, but I reliably see this issue with my 10 disk setup so my
recommendation would be to increase the number of disks attached to the
controller and stress test it with simultaneous sequential and random I/O u=
sing
tools like dd and fio at the same time.=20

My specific use case involves a file server and database with multiple user=
s. I
consistently observe the adapter aborting requests and resetting a few minu=
tes
after boot, when the file server and database applications start and warm up
their caches (cache size is approximately 120GB in RAM).

Upon further investigation, I found that anyone experiencing this issue cou=
ld
gather more information by modifying aacraid with dump_stack() added around
line 713 of linux/latest/source/drivers/scsi/aacraid/linit.c within
aac_eh_abort (refer to this:
https://stackoverflow.com/questions/32557040/how-to-get-stack-trace-at-vari=
ous-points-in-kernel-device-driver-code).

Unfortunately, due to unacceptable downtime I had to revert my system to a
different HBA and lack spare systems to test with.

Best regards.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
