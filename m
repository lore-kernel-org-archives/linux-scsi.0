From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 21 Jan 2009 08:56:31 +0100
Message-ID: <4976D52F.5090109@s5r6.in-berlin.de>
References: <49762FC8.7000208@s5r6.in-berlin.de> <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55470 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZAUH4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 02:56:40 -0500
In-Reply-To: <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> The bug reporter said that copying stooped but it should not
> happen. It doesn't happen with SCSI (copying can continue a bit
> slowly). dma mapping errors are transient so SCSI retries.
...
> If the bug report is true, then the FireWire stack or the driver (or
> both) has problems. Make sure that FireWire can work even with dma
> mapping failures.

sbp2_scsi_queuecommand returns SCSI_MLQUEUE_HOST_BUSY if DMA mapping
failed.  Isn't this what should happen?

However, both usb-storage and firewire-sbp2 currently have a queudepth
of only 1; if there are no DMA resources to map just this one SCSI
request, how should the system be able to recover?  It can wait, but it
can't lower the part of the workload which is related to this particular
copying operation (which, as  the reporter wrote, ultimately stopped). I
suppose there is something else* on the reporter's system which tied up
too much swiotlb resources the whole time; and then just waiting a bit
until the next queucommand won't get things going.

*) The report does not sound like there was a DMA mappig leak caused by
copying between usb-storage and firewire-sbp2.  Else he would have hit
the problem again even with increased swiotlb default size.

> My dma mapping debug patchset might be useful:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git dmafault
> 
> You can inject dma mapping failures per device:
> 
> vine:/debug/pci/0000:00:1d.1# ls
> interval  probability  space  task-filter  times  verbose

This could be handy, thanks.
-- 
Stefan Richter
-=====-==--= ---= =-=-=
http://arcgraph.de/sr/
