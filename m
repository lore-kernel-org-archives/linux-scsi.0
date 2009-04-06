From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 2/6] mpt fusion: Firmware Event implementation using
	seperate WorkQueue
Date: Mon, 06 Apr 2009 14:45:35 +0000
Message-ID: <1239029135.3641.3.camel@mulgrave>
References: <20090403115025.GC17721@lsi.com>
	 <1238782865.3359.78.camel@mulgrave.int.hansenpartnership.com>
	 <0D1E8821739E724A86F4D16902CE275C1410F4CA52@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49393 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbZDFOpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 10:45:38 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410F4CA52@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Mon, 2009-04-06 at 13:47 +0530, Desai, Kashyap wrote:
> Comment #6. This routine looks like a recoding of
> scsi_test_unit_ready().  Firstly, why not just use it, but secondly,
> why is it necessary ... the use case is when you spot a device added
> and the mid layer does inquiry and
> settle checking anyway.
> -> We can use scsi_test_unit_ready only if sdev is created for end
> device. In some of the cases Device takes ~150secs to come up even
> after sending hotplug event. If we report add device event to Scsi
> Subsystem, It will inquire MAX 3 times to see weather device is
> present or not. It will reject Device Add event and eventually Device
> which will come up after long delay will not be seen to Scsi mid
> layer.
> We required similar call like scsi_test_unit_ready() for our driver so
> that  we can issue TUR much before reporting it to SCSI midlayer.

Um, so it sounds like you're saying that hotplug has jitter problems
which the mid-layer doesn't cope with (but should)?

So the solution should be to fix the mid layer, not code around it in
your driver.

> Comment #7. OK, this is getting sillier.  You send a TUR to a device,
> but the device may not have a LUN 0, so now we're going to send a
> report luns and fish for an actual lun to test?  Again, the mid layer
> does all of this when the device appears, why not just let it?
> -> I accept your concern. It is not optimized way of doing TUR. We
> have fix for this in SAS2 driver. Since this code is well tested I
> will request you to consider this code as of now. I will resend well
> tested code soon.
> Why we are doing it, not allowing SCSI mid layer?  Answer is same as
> explanation in comment#6.

Well, it's also what you're actually doing.  The jitter is presumably on
the line, so if you get a report luns through, that's sufficient
indication that the target is responding, there's no need to do an
additional test unit ready.

If we pull this into the mid-layer, it seems reasonable just to probe
for target readiness with report luns.  Or do you have some specific
array problem that comes up via hot plug (so the line is clear) but then
terminates commands with errors for the 150s?

James


