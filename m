Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1335D4BE
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyD4pAw9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 345E3C433C9
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701283647;
	bh=kKqoVZrMG6NrpK7GCnxOULu65KHt9pRUoLDLYOHMMSA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OyD4pAw9JqhNru8S62dg8a8L8tszpV/MDgnniEqOrkH0vHWJ4y5MBb5YnHgyztm4n
	 jCxvacgTEAxylXuDbfKkI/gVTvP/aGnp/gIwzG1jLhe3J6N1ek9uXpqLhkyftXvcO3
	 R/hQv4tX4rswmD98XupZm+8km5WW5U3yY7hzX6V+NdyiwbYpCFhHEuEDy4RnZ2DpAQ
	 HIr1nzTCA6pedpU/68cgjpTwxDdNcTuI/1Bdtu5OEO0BZiYqlTd4OaTPmSZZpRQaWj
	 KiZ3IlEQPSp66QdRWguI8z6sBlxUfzTyv9bLZRiysdWTm9wU6Ii1Y7lG+g2piaA3BE
	 8aYjhsnKliMnA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1DD41C53BD2; Wed, 29 Nov 2023 18:47:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 29 Nov 2023 18:47:26 +0000
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
Message-ID: <bug-218198-11613-ocr8fkurzT@https.bugzilla.kernel.org/>
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

--- Comment #10 from Phillip Susi (phill@thesusis.net) ---
Niklas Cassel <Niklas.Cassel@wdc.com> writes:

> The reason why many platforms do this override, is because:
> "One of the requirement for modern x86 system to enter lowest power mode
> (SLP_S0) is SATA IP block to be off. This is true even during when
> platform is suspended to idle and not only in opportunistic (runtime)
> suspend."
>
> "SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
> user has to either use scsi-host sysfs or tools like powertop to set
> the sata-host link_power_management_policy to min_power."

What?  I'm confused.  Here are several things that come to mind that
when taken together with this statement confuse me.  Perhaps I am wrong
about one or more of them?

1)  DEVSLP is an odd thing they invented to have ACPI twiggle a GPIO bit
to cut the power rails to CDROM drives that aren't in active use.

2)  SATA ALPM has the SATA controller automatically transition the sata
link to lower power states when it isn't being used, and back again on
use.

3)  The SATA controller can not be suspended until all of its ports are
suspended.

4)  Suspending a SATA port does not happen during ALPM, but rather only
either during system suspend, or when you enable runtime pm on the disk
and the ata port in sysfs ( both are disabled by default ).

A quick google led me to this: https://smarthdd.com/device_sleep.htm

Which indicates that this DEVSLP thing is now being used to send an OOB
signal to a SATA SSD so that it can power down its PHY completely, but
isn't that what ATA SLEEP is for?  aka. hdparm -Y.  That command tells
the drive that it can power down its PHY and then the host can power
down its PHY and it takes a sata link reset to wake the drive back up.
The link reset is easy to detect with minimum circuitry that is far
simpler than the full sata PHY.

It sounds like somebody decided to hack an OOB signal into ALPM rather
than use ATA SLEEP, but why?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
