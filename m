From: Willem Riede <wrlk@riede.org>
Subject: Scsi error handler strategy question
Date: Sun, 4 Jan 2004 18:24:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040104232425.GM4339@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:6559 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265768AbUADXZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2004 18:25:28 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i04NOPEM029626
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jan 2004 18:24:25 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

While testing the ide-scsi error handling, I observed that my ATAPI
device gets offlined too easily.

At some point, the host + device are getting reset. That's desired.
The error handler is programmed to then expect a "CC/UA" (check
condition / unit attention) when it does TUR (test unit ready)
following reset. That's appropriate.

But here is my first question: is there typically any need to wait 
some time between doing the host/bus/device reset and the first TUR?
Is there a standard that governs how fast devices have to be done
resetting to the point that they can respond to commands (if only to
say they're not ready?

When the first TUR completes, the CC/UA expected flag takes care of
the reported sense 06:29:00 (power on reset or device reset occurred).
So far so good. Second TUR issued. That one typically gets 02:04:01
(not ready - in the process of becoming ready) reported. The error
handler is programmed to retry TUR once if it sees this.

Second question: if the device firmware takes some time to re-initiate
the device, this code can be returned multiple times. So am I allowed
to submit a patch to increase that retry count? What would be a good
number? Hard to say in general, as this depends on what devices you
have and how fast commands get executed :-(

Finally, at least my device, the OnStream DI-30, will eventually want 
to report 06:28:00 (not ready to ready transition, medium may have
changed). The error handler considers that an error, and is guaranteed
to take the device offline, just as it came back to life :-(

Am I allowed to submit a patch that will also retry on that condition?

Thanks, Willem Riede.
