Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3514ED3
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 13:37:14 -0800 (PST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 79AE214C1F0; Tue,  5 Dec 2023 16:37:13 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
In-Reply-To: <bug-218198-11613-Bo6VtC0lyT@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-Bo6VtC0lyT@https.bugzilla.kernel.org/>
Date: Tue, 05 Dec 2023 16:37:13 -0500
Message-ID: <87o7f4qqk6.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

bugzilla-daemon@kernel.org writes:

> a couple of seconds after successful resume my system transitions down to pc8.
> hdparm manual doesn't explicitly tell what command is issued with the -Y
> switch.

SLEEP.  One problem with using it though is that several things
tend to wake the drive up from it soon.  I've had patches to address
this for years.  Maybe I'll finally get them merged soon.  Those things
are:

1)  smartd or udisks2 polling the SMART status of the drive.  They
already issue CHECK POWER CONDITION first to see if the drive is in
STANDBY and if so, don't bother with the SMART read.  That avoids waking
up a disk in STANDBY mode, but in SLEEP, you can't even ask the drive
whether it's in standby without waking it up.

2)  A mounted filesystem periodically issues a FLUSH CACHE command, even
if nothing has been written.  A drive in STANDBY just ignores it but in
SLEEP, it wakes up.

I would imagine at once you access the disk in some way and so it wakes
up, you won't get back to pc8 again without another hdparm -Y?  Is that
correct?

