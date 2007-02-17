From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy
Date: Fri, 16 Feb 2007 17:50:11 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82299214CE@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61788 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946348AbXBQAu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 19:50:28 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>


Hello James,

	It is difficult to know when the device will go into a state
where it is not able to process cmds within timeout period consistently.
Many factors may be contributing for the device to get into this state. 
	Reducing can_queue may help but the difficult part is when does
the can_queue value be restored to the original value. Because, the
device may come back to normal functioning after some time. Also
reducing it to a optimum value that will work for all possible cases is
a challenge.

	In a typical setup the throttle io code may not get executed. It
is required only when it has not been able to complete cmds more than 2
times within timeout period.

Regards,

Sumant

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Friday, February 16, 2007 9:51 AM
To: Patro, Sumant
Cc: akpm@osdl.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo
Subject: RE: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy

On Thu, 2007-02-15 at 19:53 -0700, Patro, Sumant wrote:
> Hello James,
> 
> 	I re-submitted the patch yesterday with the "space" issue fixed 
> (adhering to coding guideline).
> 
> 	I will check for alternative to calculate the time driver have
been 
> sending host busy to OS. Will check with time_before() as you have 
> suggested.
> 
> 	Throttling from megasas_generic_reset() handler did not help.
> megaraid does not have feature to abort cmds. So, in the generic reset

> routine, the driver just waits for cmd completion by FW. These 
> timed-out cmds gets retried by mid-layer with "retries" incremented by
1.
> Eventually we see retries equals max_allowed followed by SCSI error 
> with "DRIVER_TIMEOUT".

That's rather what worries me.  When the error handler activates (which
it will on the first timeout), it waits for all commands to complete or
time out before running.  Your reset handler does nothing other than
wait for the firmware to complete the commands (now uselessly), so we
now wait for the entire firmware command queue to drain, then you tell
the mid layer everything is OK, so it loads you up again with all the
commands plus a few test unit readies for good measure, then you
throttle.

You really want to catch the device going into this condition and do
something at that point ... prime candidate would be lowering the
can_queue depth to get fewer commands transiting the firmware.

James


