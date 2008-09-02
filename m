From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: WAS: "Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If
	I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64"
Date: Mon, 01 Sep 2008 19:05:10 -0500
Message-ID: <1220313910.3353.4.camel@localhost.localdomain>
References: <8635.97645.qm@web27302.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37119 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbYIBAFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2008 20:05:14 -0400
In-Reply-To: <8635.97645.qm@web27302.mail.ukl.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pinc_o@yahoo.it
Cc: Pierre Ossman <drzeus@drzeus.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, linux-usb@vger.kernel.org

On Mon, 2008-09-01 at 23:30 +0000, pinco pallino wrote:
> Hi Andrew,
> 
> with the new kernel 2.6.26.3 the SD are now read and wrote correctly, but SDHC are not read! The kernel repeat the error. Follow the error:
> 
> Sep  1 22:08:20 athos -- MARK --
> Sep  1 22:19:12 athos kernel: usb 1-6: new high speed USB device using ehci_hcd and address 5
> Sep  1 22:19:12 athos kernel: usb 1-6: configuration #1 chosen from 1 choice
> Sep  1 22:19:12 athos kernel: scsi5 : SCSI emulation for USB Mass Storage devices
> Sep  1 22:19:17 athos kernel: scsi 5:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
> Sep  1 22:19:47 athos kernel: usb 1-6: reset high speed USB device using ehci_hcd and address 5
> Sep  1 22:20:14 athos last message repeated 3 times

This is definitely a USB issue (correct cc's added).  It looks like some
attempted reset finally ...

> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: Device offlined - not ready after error recovery
> Sep  1 22:20:14 athos kernel: usb 1-6: USB disconnect, address 5

... leads to disconnection here.

> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] READ CAPACITY failed
> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Result: hostbyte=0x01 driverbyte=0x00
> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Sense not available.
> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Write Protect is off
> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Attached SCSI removable disk
> Sep  1 22:20:14 athos kernel: sd 5:0:0:0: Attached scsi generic sg3 type 0

This is all symptomatic of the command SCSI is trying to send never
reaching the device.

Then USB begins again with the same device:

> Sep  1 22:20:14 athos kernel: usb 1-6: new high speed USB device using ehci_hcd and address 6
> Sep  1 22:20:14 athos kernel: usb 1-6: configuration #1 chosen from 1 choice
> Sep  1 22:20:14 athos kernel: scsi6 : SCSI emulation for USB Mass Storage devices
> Sep  1 22:20:19 athos kernel: scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0

And runs into identical problems.

Most likely, knowing USB, it's either some interface problem, or the
device hung up on a SCSI command it didn't like.  What's the last known
good kernel?  If the usb people don't recognise it, then likely we'll
need a bisection search from there.

James


