Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A564A31
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgOfLaxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0E85C433C8
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701155205;
	bh=k4cIoA+xuZaH6BL3WIINLMKmlSIzEzR/dpXUA6kBYIs=;
	h=From:To:Subject:Date:From;
	b=FgOfLaxJWB7a07/LjeeN7GkLtSVyj9qxNdPDEfrKdv96y/8QU3MpcTbT+963lqMzP
	 XDGHkL5uX0BGlUJUBYp2gh7zwOrerLx7E+nLma7F9aZGY71rVH6E+rpYbQwtg2mTq5
	 fAMUukB+Eo1dFt/kDmpoOWpzNv3LS+kxxAlENbg5/YFsCh9xLdpQb4QsrCZ93BTgnG
	 4GJwMflcmuTxl6T5d5cl1y1yq9Ggr/ZDW1iF49M1Pn9IRR6geSspTfqoutvRG/R0I5
	 bdRIDXrA3cSXvaqQz9AmHw9JUo1YfRPjkgeklcyQTT05FRAQl7J8+rXS/08SjEZ31B
	 3OO+2YLO6In9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C1624C53BCD; Tue, 28 Nov 2023 07:06:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] New: Suspend/Resume Regression with attached ATA
 devices
Date: Tue, 28 Nov 2023 07:06:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218198-11613@https.bugzilla.kernel.org/>
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

            Bug ID: 218198
           Summary: Suspend/Resume Regression with attached ATA devices
           Product: SCSI Drivers
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: dmummenschanz@web.de
        Regression: No

Hello,

the following commit from Kernel 6.7-rc1:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/dri=
vers/ata/libata-core.c?id=3Dd035e4eb38b3ea5ae9ead342f888fd3c394b0fe0

introduced a regression on my system where after successful resuming the CPU
won't enter lower Package Sates below pc2 even after letting it sit for 15+
minutes. Reverting this commit fixed the issue on my system with two ata
drives. Anyone experiencing the same issue?=20

I'm happy to try any troubleshooting steps or provide more details if neede=
d.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
