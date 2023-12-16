Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C9328D6
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 22:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZmkIGWn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72D52C433AB
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 22:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702764016;
	bh=APMpUVI0ahOULtdPj4lUo/mJshs2RCkoaK9bWDjtv8E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AZmkIGWnhok2/C7CpMnsnwHtKhPdPBEkDkCVUsDDzM+YxSZUz+RRnoRaaFU5tK6qv
	 bPV9kYQ7+Ag0uIf/T2OdexcS5NGeSkLbisNrSoomb6dS6gwL2McI/2+ezjuTPh/pSd
	 2dTAnBw5gQBb0Pc9NEHAdxxFCzqz6NJS62OvRilg46A3n3MOP26djZ3K1LZ3AyeLLO
	 YGSUWSpzuagzUHpUcPCHmBWouFKytiD5x5hOGbsc8CNOgFfHN1/uJI6stHqyrJgNQe
	 9k/jPo/kKeMTKZB/JsnNXH7V0R/QulpaaOYjYyuolsirkN7vVoS39PIptKrdkmAxoL
	 TtRg5MRaf/zlQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 63B85C4332E; Sat, 16 Dec 2023 22:00:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 16 Dec 2023 22:00:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: leyyyyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-60h01BnW2q@https.bugzilla.kernel.org/>
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

--- Comment #49 from Maxim (leyyyyy@gmail.com) ---
I used 2 raid arrays:

- RAID0 with 8 SATA drives (8x4TB)
- RAID0 with 2 SATA drives (2x16TB)

Both was with LUKS and Ext4/BTRFS (tried both) on that moment.

To reproduce it I just started copying files from one array (2nd one) to
another using some file manager like Midnight Commander.

During copying it can process some amount of data before problem happens and
message appears in dmesg output. When it happens copying becomes slow, all
hangs, and finally the copying is rejected.

btrfs scrub gives similar result, it says that data is corrupt after starti=
ng
scanning (maybe 200-300 GB is scanned OK before it happens).

It is single CPU system, I never used multi-socket MB in in such scenarios.

I do not think you need fio, I think you need to move a lot of data to array
(for example big media files, VM images, backup files and so on).

2nd time when I got the same issue was different system, and it is also cop=
ying
of data from RAID0 10x1TB SSD to RAID0 6x8TB HDD (LUKS and BTRFS).

--

I do not think it is hardware issue because on old kernels it works fine wi=
th
the same settings of the array. If FS is not damaged I can just boot in old=
er
kernel and all will work fine on the same file system. Usually FS will not =
be
damaged if you not try to repair it by fsck.ext2 using problematic aacraid
driver.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
