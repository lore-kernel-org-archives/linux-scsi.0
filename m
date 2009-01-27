From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Tue, 27 Jan 2009 16:54:30 +0900
Message-ID: <20090127165508L.fujita.tomonori@lab.ntt.co.jp>
References: <49762FC8.7000208@s5r6.in-berlin.de>
	<20090121074339N.fujita.tomonori@lab.ntt.co.jp>
	<4976D52F.5090109@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49678 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZA0Hyt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 02:54:49 -0500
In-Reply-To: <4976D52F.5090109@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 21 Jan 2009 08:56:31 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > The bug reporter said that copying stooped but it should not
> > happen. It doesn't happen with SCSI (copying can continue a bit
> > slowly). dma mapping errors are transient so SCSI retries.
> ...
> > If the bug report is true, then the FireWire stack or the driver (or
> > both) has problems. Make sure that FireWire can work even with dma
> > mapping failures.
> 
> sbp2_scsi_queuecommand returns SCSI_MLQUEUE_HOST_BUSY if DMA mapping
> failed.  Isn't this what should happen?

Returning SCSI_MLQUEUE_HOST_BUSY is the right thing and such problem
should not happen.


> However, both usb-storage and firewire-sbp2 currently have a queudepth
> of only 1; if there are no DMA resources to map just this one SCSI
> request, how should the system be able to recover?

Handling one outstanding command is must. If you can't, the system
can deadlock in OOM.

If you put the deadlock issue aside, the above host->can_queue issue
is irrelevant. Even if you set host->can_queue to 1, scsi-ml sends one
command to the LLD again and again until it succeeds, I think. As long
as the LLD can send a command occasionally, the system works.


> It can wait, but it
> can't lower the part of the workload which is related to this particular
> copying operation (which, as  the reporter wrote, ultimately stopped). I
> suppose there is something else* on the reporter's system which tied up
> too much swiotlb resources the whole time; and then just waiting a bit

Tying swiotlb resource the whole time is unlikely. Everyone uses it
temporarily.


> until the next queucommand won't get things going.
> 
> *) The report does not sound like there was a DMA mappig leak caused by
> copying between usb-storage and firewire-sbp2.  Else he would have hit
> the problem again even with increased swiotlb default size.

Maybe the reporter doesn't copy enough to hit the deadlock.

If you need 512MB swiotlb buffer, surely it's something wrong. The
kernel should work smoothly with much less (even if it works slowly).
