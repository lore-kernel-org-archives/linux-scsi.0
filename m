Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B1184D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722914156; cv=none; b=uJ7bBxN2HjmFxOBWC3yLRxh+YoR1LYjcB9F/r418KnHx/G+upybOGb7MG85vcpOvfWbj/s2Il+OqsPQpi2NH4QXcPyIg2r/GppSl1+zmwpNShIKWOdRDwvg1WHM7YSKv3mAcNwneS7J+rbrPGWdAKH3gnc+nktWylDGZ5da+EI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722914156; c=relaxed/simple;
	bh=M9vEgf0coS7SXrxEHk5DJofz1mZab8kj/XVdMXJnS0c=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=a9KNkYm4/CiW9ok6rSuAt/yMXwpjE+T15RY4wFhQHaBcvSCXYh4kh723rX5zsm/ghSFeIPH9e/2SulxImUO+nxNSRW4CS17g55BaaYgnoy9FXJWIyCAqaKrJQLbtwvzA5e2rkPLSFztb6DxdNYuoH0EzK8GTUkZXmd7BqgFcbRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiiChONZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiiChONZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C0CAC4AF0D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722914156;
	bh=M9vEgf0coS7SXrxEHk5DJofz1mZab8kj/XVdMXJnS0c=;
	h=From:To:Subject:Date:From;
	b=WiiChONZCiQWJKdy14lh+HvmKlngb7rZEj4+X2Aa4LUmerglPJEQXCpXqggIbQ65h
	 P62guWJ1ZWG2xGtREAuMSWw6KSA1qFlCMmd5T2tNf4BN/sDw73P1tk6E3WAVKl0KBk
	 SZ3y70bak/FYdYA8GU8nVVsF76LVuxp+SSwzZ2X8fN/R9qVb5LPLLwL434RvDfKHKi
	 7pJvDZWX0bAxWMR7OYJE3i1YuZGh9iiyrwFUwtGqchtQ+6wlVdxIt4FNoj1tTM8uNL
	 lm1iA6fU266G9hV6mN97jgnL6bfjhhTWD8p1LEHN4nifK/KCOwcVYhU7C0E4XpHNj0
	 xY9E6N4g9BuKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5A239C53B7E; Tue,  6 Aug 2024 03:15:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] New: lpfc driver reports failure message
Date: Tue, 06 Aug 2024 03:15:56 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixc17@lenovo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219128-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219128

            Bug ID: 219128
           Summary: lpfc driver reports failure message
           Product: IO/Storage
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: lixc17@lenovo.com
        Regression: No

After installing Ubuntu 24.04 in a SAN disk via "Emulex LPe35000 32Gb 1-Port
Fibre Channel Adapter", the lpfc driver show many errors, like:

lpfc 0000:41:00.0: 53: [ 250.627110] 0:(0):0220 FDMI cmd failed FS_RJT Data:
x211
lpfc 0000:41:00.0: 0:(0):2754 PRLI failure DID:030E00 Status:x9/x32a00, dat=
a:
x4 x0 x80000000
lpfc 0000:41:00.0: 25: [ 247.537454] 0:(0):9024 FCP command xa3 failed: x0 =
SNS
x0 x0 Data: x8 xfdc x0 x0 x0
lpfc 0000:27:00.0: 0:(0):2753 PLOGI failure DID:040F00 Status:x3/x103
kernel: rport-13:0-5: blocked FC remote port time out: removing rport

Reproduce Steps:
  1. Install Ubunut 24.04 - can intall successfully
  2. Boot into OS
  3. Check /var/log/syslog, found lpfc relevance errors.
  4. Update to the upstream latest v6.10 kernel, the lpfc errors still ther=
e.

 Expected results:
 No lpfc driver related failures or errors.

 Actual results:
 Many lpfc driver failed messages was recorded.

Configuration:
LENOVO SR630V3 - Intel EGS
XCC: ESX323N
UEFI:ESE123F
UEFI Setting=EF=BC=9ADefault

os:ubuntu-24.04-live-server-amd64-GA-0426
cpu: Intel(R) Xeon(R) Platinum 8460Y+*2
mem:M321R2GA3BB6-CQKEG*2
Emulex LPe35000 32Gb 1-Port Fibre Channel Adapter fw:=E2=80=83=E2=80=8314.2=
.673.40
Intel Ethernet Server Adapter I350-T4 fw:=E2=80=83=E2=80=831.3450.0
SAN - Lenovo DM7000

Additional info:
  1. Although there're those failures, we can read/write date to SAN disks.
  2. Intel Birch Stream platform has this lpfc driver issues as well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
