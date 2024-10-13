Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA0536B
	for <linux-scsi@vger.kernel.org>; Sun, 13 Oct 2024 00:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728780745; cv=none; b=FL+ycu/ZXJZe3xYf/2BJ63+zL9nRy2l8JNelMrazZe/kkgsMKm/ntduH40NIlZkKufZKQqCTNPYPFxYBLN6st4xPR08iidOqJTGgec12CGpCj6xW9nZ3KAA+mwAFPZ/3AFCii2p4zwiEjNmRImBwKy2csQeQP8vy3aEFonjpiK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728780745; c=relaxed/simple;
	bh=SnTS/SO6HOkgbKsQlEr2Qiq/il94kfd/Ec/kr5Js2PU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CNqxZK+XlEXsHvu6abiKk2sxctNIYI2RAn7CKolQl7XJG551XgJ+g8C08JuMZZeVxoPScBHfQmHgxx1XcnGZ7LEAr9sIFVcMcTKSFDrwv1II+HDi0AlPj2OCfMh1fSnqZQrgl6Y14xFgi7vqI3+dtZtDO7YA+qOme8/bGGEOp9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSbZhWa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSbZhWa0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97A66C4CEDA
	for <linux-scsi@vger.kernel.org>; Sun, 13 Oct 2024 00:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728780744;
	bh=SnTS/SO6HOkgbKsQlEr2Qiq/il94kfd/Ec/kr5Js2PU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XSbZhWa03dgZpHmoSatlEecw0N1Zjj/UYCrYEIo8i0teJFJcYKV4Fou63BlMXrz3t
	 wQeu7u37XvgIwAWox9ZqtgpgxI7dAGWL6oDlCLJ3jY4F4Ie6L0aN7MHyJT0tBZRYQ8
	 OpJuK5MRS0MMq1eUAvt4mTRWmB9kjinbzy1UePHJdJYIkNdzzLp6UyLJgm28c4uOpR
	 pks1g206VIuSDlrovCJi5rhpWG1upbvqBwecUxAVaypr1shq/yqbEbTD+9eaAjHkce
	 sivcqotFDpf8N4IxghsyGVx6/zQlPD00MoGTlho+/5UqSnpLEcgICUwmuSK/ttRCW3
	 J54j5Dh3sy8ow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 902DEC53BCA; Sun, 13 Oct 2024 00:52:24 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sun, 13 Oct 2024 00:52:23 +0000
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
Message-ID: <bug-217599-11613-4JNWf59Fky@https.bugzilla.kernel.org/>
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

--- Comment #64 from Maxim (leyyyyy@gmail.com) ---
I am still encountering issues with the aacraid driver.

While the reverted version has shown significant improvement in terms of
stability and consistency, and I no longer face issues after the system has
successfully booted, there is still one persistent problem: the system hangs
for 120 seconds during the boot process. It is related to NetApp disk shelf
(0000:03:00.0) connected to ASR-78165.

For example Ubuntu Server 24.04 (live ISO):

$ cat dmesg | grep aacraid

[    0.915806] kernel: Adaptec aacraid driver 1.2.1[50983]-custom
[    0.916680] kernel: aacraid 0000:03:00.0: can't disable ASPM; OS doesn't
have ASPM control
[    0.928906] kernel: aacraid: Comm Interface type2 enabled
[    0.958831] kernel: aacraid 0000:03:00.0: 64 Bit DAC enabled
[    0.975916] kernel: scsi host0: aacraid
[    1.275877] kernel: aacraid: Host bus reset request. SCSI hang ?
[    1.277602] kernel: aacraid 0000:03:00.0: outstanding cmd: midlevel-1
[    1.279315] kernel: aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
[    1.280986] kernel: aacraid 0000:03:00.0: outstanding cmd: error handler=
-0
[    1.282672] kernel: aacraid 0000:03:00.0: outstanding cmd: firmware-0
[    1.284357] kernel: aacraid 0000:03:00.0: outstanding cmd: kernel-0
[    1.292931] kernel: aacraid 0000:03:00.0: Controller reset type is 3
[    1.294620] kernel: aacraid 0000:03:00.0: Issuing IOP reset
[   34.039710] kernel: aacraid 0000:03:00.0: IOP reset succeeded
[   34.045955] kernel: aacraid: Comm Interface type2 enabled
[   49.015695] kernel: aacraid 0000:03:00.0: Scheduling bus rescan
[   59.522832] kernel: aacraid: Host bus reset request. SCSI hang ?
[   59.525823] kernel: aacraid 0000:03:00.0: outstanding cmd: midlevel-1
[   59.528323] kernel: aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
[   59.529023] kernel: aacraid 0000:03:00.0: outstanding cmd: error handler=
-0
[   59.529707] kernel: aacraid 0000:03:00.0: outstanding cmd: firmware-0
[   59.530372] kernel: aacraid 0000:03:00.0: outstanding cmd: kernel-0
[   59.537907] kernel: aacraid 0000:03:00.0: Controller reset type is 3
[   59.538609] kernel: aacraid 0000:03:00.0: Issuing IOP reset
[   91.184486] kernel: aacraid 0000:03:00.0: IOP reset succeeded
[   91.191966] kernel: aacraid: Comm Interface type2 enabled
[  106.042633] kernel: aacraid 0000:03:00.0: Scheduling bus rescan
[  116.351867] kernel: aacraid: Host bus reset request. SCSI hang ?
[  116.354649] kernel: aacraid 0000:03:00.0: outstanding cmd: midlevel-1
[  116.357268] kernel: aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
[  116.357904] kernel: aacraid 0000:03:00.0: outstanding cmd: error handler=
-0
[  116.358523] kernel: aacraid 0000:03:00.0: outstanding cmd: firmware-0
[  116.359113] kernel: aacraid 0000:03:00.0: outstanding cmd: kernel-0
[  116.366903] kernel: aacraid 0000:03:00.0: Controller reset type is 3
[  116.367580] kernel: aacraid 0000:03:00.0: Issuing IOP reset
[  147.979313] kernel: aacraid 0000:03:00.0: IOP reset succeeded
[  147.981970] kernel: aacraid: Comm Interface type2 enabled
[  162.916919] kernel: aacraid 0000:03:00.0: Scheduling bus rescan


As I mentioned previously, the 5.15 kernel version is fully functional and
performs consistently well. The same boot issue occurs even with RHEL8 fork=
s,
such as Rocky 8.10, likely because the driver has been backported.

On the other hand, Ubuntu 22.04, which relies on the 5.15 kernel, works
exceptionally well. This is the reason I can't use OpenSUSE Leap 15.6 and m=
ust
stick with Ubuntu.

In other words, some errors still exist in the driver=E2=80=99s source code=
, and a
bisect starting from 5.15 is needed to resolve them.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
