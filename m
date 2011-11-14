From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [RFC] enclosure & ses: modernize and add target power management
Date: Mon, 14 Nov 2011 08:21:35 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:53998 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877Ab1KNQVk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Nov 2011 11:21:40 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4EBD948E.9000104@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Partially absorbed your response.

Douglas Gilbert [mailto:dgilbert@interlog.com] sez:
Sent: Friday, November 11, 2011 4:33 PM

> With my equipment, setting "device off" has no effect.
> [What does "device off" do on your test hardware?]

I have yet to integrate and unit test the kernel-side <grin>, but our
PMC-based expanders and Xyratex Firmware in Xyratex enclosures does in
fact power the targets off (using raw) via the sg tools. What would be
nice to know is how do we determine if the device off bit works, do you
see the bits coming back with the reflected state change, or do the raw
bits on page2 remain in the power-off disabled (power still on) state?
Xyratex has supported target power management for a long time, only way
to truly keep the breakers from tripping in large installations when
someone hits the big red switch on the front.

Hopefully so regarding the feedback on the bit, then we can 'see' the
success or failure.

> To your question about target power management, the
> kernel ses driver is probably better placed than a
> user space utility like sg_ses. Yet there are several
> ways of target (and related) power management. There
> is the Power condition mode page in SCSI which recent
> disks support (and the older START STOP UNIT command).
> In the SAS (transport) domain there are also power
> saving techniques, for example the expander phys facing
> the target disk can be put into slumber state (and I
> presume the target disk would go into a low power
> state in response to that).

Hmmm, this also means I should consider checking the ses page for the
ability to turn the power (back) on for a specified target (catch22)
associated with the Start command? Same tactics for taking a drive in
'green' mode to full-speed?

I have two reactions to this associated with the dip into the water
regarding ses (goes along with all the voices in my head):

1) If you built it, they will come, my 'idea' as-is and not specifically
architected for the future but with an unsupported ifdef around the
sysfs-visible node for testing purposes only. Later someone will figure
out how to add this to the power and spin-up management system in Linux
that makes sense. The net result may be to move the sysfs-visible
drive_power node somewhere else? This follows the ideal of Linux is
Evolutionary. In this case, split into two patches (a) to fix the
existing problems and (b) to add power control.

2) Take some time to explore and create the future, and see if power
states can be created at the target-level, where power condition,
start-stop and enclosure power levers are all coalesced into a single
kobj to manage. This sounds like some additional work in the scsi
layers... This follows the ideal of Linux is Intelligent Design.

Sincerely -- Mark Salyzyn
