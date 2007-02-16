From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy
Date: Fri, 16 Feb 2007 11:50:54 -0600
Message-ID: <1171648254.3443.34.camel@mulgrave.il.steeleye.com>
References: <0631C836DBF79F42B5A60C8C8D4E8229921362@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39428 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946023AbXBPRvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 12:51:11 -0500
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229921362@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

On Thu, 2007-02-15 at 19:53 -0700, Patro, Sumant wrote:
> Hello James,
> 
> 	I re-submitted the patch yesterday with the "space" issue fixed
> (adhering to coding guideline).
> 
> 	I will check for alternative to calculate the time driver have
> been sending host busy to OS. Will check with time_before() as you have
> suggested.
> 
> 	Throttling from megasas_generic_reset() handler did not help.
> megaraid does not have feature to abort cmds. So, in the generic reset
> routine, the driver just waits for cmd completion by FW. These timed-out
> cmds gets retried by mid-layer with "retries" incremented by 1.
> Eventually we see retries equals max_allowed followed by SCSI error with
> "DRIVER_TIMEOUT".

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


