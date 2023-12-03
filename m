Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13763A0
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 11:50:38 -0800 (PST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 5E58314BB90; Sun,  3 Dec 2023 14:50:37 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
In-Reply-To: <bug-218198-11613-IZUsDxnbCF@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-IZUsDxnbCF@https.bugzilla.kernel.org/>
Date: Sun, 03 Dec 2023 14:50:37 -0500
Message-ID: <87y1ebawvm.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

bugzilla-daemon@kernel.org writes:

> I guess you need to ask Intel.
>
> I assume that their firmware simply requires the DEVSLP signal to be
> asserted in order to enter lower CPU power states.

I would say it's the hardware that requires the ata link to be powered
down, not the firmware.  They seem to have decided that the way to get
the hardware to power down was to add a new state to ALPM instead of
using runtime pm to actually disable the port.  I would love to hear
from Intel why they went this route.

> If you just send a command to the device, if it not easy for HW logic
> to determine which state is in. It would need to read some registers
> or similar. Sounds way more complex than just having a logic gate.

I'm not quite sure what you are getting at here.  The point of the ATA
SLEEP command is to inform the device that it should power down
everything, including the SATA PHY, and only keep a simple logic gate
active that can detect the big and obvious RESET signal from the host.
It seems to accomplish the same goal as DEVSLP without requiring hacking
in another logic line somewhere that wasn't meant for that purpose.
