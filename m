Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6DA15AEA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlqwAr55"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 400E3C433C7
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 08:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701159842;
	bh=2yMYjPRIu172Hqx1XGhVCnzKLEAzVgJH4ALP3OSQLrs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LlqwAr551QEkFZ2n2nCm+CQqsIxRHeZFG8P0iznzvHB2mqW7hfWtlvlaOmPN4nSzV
	 2HUn6heUvvpIx84MeaQ/1D+8AHnbl4E11h7zu6XF5BpXhWj7B7ZKdWzKU9ZqezwngH
	 sXtH7azALYq2z7Hhz7dcNoNJ97TNN5QlLfnHxsX/2CL2vYYoTt7rBLjwmI1s8zp+BA
	 KryCilVI4y2CppA8acW5AAJH0PMlLa85rcNT4jwWMTjy7+/r87Lg/J1ZXVoapNc+A5
	 NMBrXSzN8BqZA7AFwMO95I2Rk3hR6af5S1DiWZEpar8KveFKQ7mAmZz0lubXNanXlp
	 pB5fSoLUJUr0w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2C609C53BCD; Tue, 28 Nov 2023 08:24:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 08:24:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-NAsEdarpyZ@https.bugzilla.kernel.org/>
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

--- Comment #2 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Thanks for the swift reply.

I've applied your patch. Booted up my machine and waited until it transitio=
ns
into lower package states (pc8 at the lowest). After that I closed the lapt=
op
LID and let the machine suspend to RAM (S3). After that I reopened the LID =
and
gave the machine 1-3 minutes time to transition to lower package states whi=
ch
it now does.
I've attached the dmesg part including your patch when the machine enters
suspend. One thing is odd though:

[  109.424369] ata5.00: qc timeout after 5000 msecs (cmd 0xe0)
[  109.424397] ata5.00: STANDBY IMMEDIATE failed (err_mask=3D0x4)

this shouldn't be there, right?

Regarding automatic transitioning I'm not sure how this works. However even
though I've set CONFIG_SATA_MOBILE_LPM_POLICY=3D3 in the kernel config, I h=
ave to
call an init script explicitly forcing the scsi host to use low power when
idle:

for foo in /sys/class/scsi_host/host*/link_power_management_policy;
  do echo med_power_with_dipm > $foo;
done

Otherwise the machine is stuck at PC2 state always.

So we have a fix I guess?

Anyway if there is anything alse I can try or provide you with more debug
output please let me know.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
