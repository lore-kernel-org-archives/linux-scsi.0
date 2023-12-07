Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9410410FB
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 05:55:37 -0800 (PST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id A69A814C6AA; Thu,  7 Dec 2023 08:55:36 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
In-Reply-To: <bug-218198-11613-PhU47dJ3D8@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-PhU47dJ3D8@https.bugzilla.kernel.org/>
Date: Thu, 07 Dec 2023 08:55:36 -0500
Message-ID: <87ttout8vb.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

bugzilla-daemon@kernel.org writes:

> No or at least I don't see this behaviour. However the drives occasional seem
> to have some trouble waking up after resume and hdparm -Y:

That's strange.  Once the drive is woken back up that should once again,
prevent pc8, just like it did before being put to SLEEP.

> [59984.831894] ata5.00: exception Emask 0x0 SAct 0x2000000 SErr 0x10000 action
> 0x6
> [59984.831907] ata5.00: waking up from sleep
> [59984.831914] ata5: hard resetting link
> [59985.145261] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [59985.148840] ata5.00: supports DRM functions and may not be fully accessible
> [59985.153322] ata5.00: supports DRM functions and may not be fully accessible
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

