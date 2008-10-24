From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [ep93xx] Oops when inserting USB storage in 2.6.27
Date: Fri, 24 Oct 2008 17:30:46 -0500
Message-ID: <1224887446.3307.43.camel@localhost.localdomain>
References: <490173D1.80308@e2s.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56419 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbYJXWav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 18:30:51 -0400
In-Reply-To: <490173D1.80308@e2s.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Kaehlcke <mkaehlcke@e2s.net>
Cc: linux-scsi@vger.kernel.org, kernel@wantstofly.org

On Fri, 2008-10-24 at 09:05 +0200, Matthias Kaehlcke wrote:
> hi,
> 
> inserting a Verbatim 4GB USB stick in a ep9307 based device running 
> kernel 2.6.27 results in the following Oops:
> 
> [42949395.050000] usb 1-3: new full speed USB device using ep93xx-ohci
> and address 2
> [42949395.250000] usb 1-3: configuration #1 chosen from 1 choice
> [42949395.260000] scsi0 : SCSI emulation for USB Mass Storage devices
> [42949395.270000] usb 1-3: New USB device found, idVendor=13fe,
> idProduct=1f23
> [42949395.280000] usb 1-3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [42949395.280000] usb 1-3: Product: STORE N GO
> [42949395.300000] usb 1-3: Manufacturer: Verbatim
> [42949395.310000] usb 1-3: SerialNumber: 078813D90478
> [42949400.280000] Unable to handle kernel NULL pointer dereference at
> virtual address 00000003
> [42949400.280000] pgd = c0648000
> [42949400.300000] [00000003] *pgd=c0647031, *pte=00000000, *ppte=00000000
> [42949400.300000] Internal error: Oops: 13 [#1] PREEMPT
> [42949400.300000] Modules linked in:
> [42949400.300000] CPU: 0    Not tainted  (2.6.27 #3)
> [42949400.300000] PC is at scsi_calculate_bounce_limit+0x3c/0x44

Best guess is this line:

	if (host_dev && host_dev->dma_mask)
		bounce_limit = *host_dev->dma_mask;

I'd guess host_dev->dma_mask contains 0x3 ... could this be some sort of
ARM setup problem?

James



