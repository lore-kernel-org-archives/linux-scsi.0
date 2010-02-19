From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SYNCHRONIZE CACHE command from sd on close
Date: Fri, 19 Feb 2010 03:04:07 -0500
Message-ID: <20100219080407.GA21905@infradead.org>
References: <4B79460A.7040207@interlog.com> <20100215132502.GA15360@infradead.org> <4B79515A.6020507@interlog.com> <20100215224847.GA2490@infradead.org> <4B7DD949.3010907@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0BSIEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 03:04:10 -0500
Content-Disposition: inline
In-Reply-To: <4B7DD949.3010907@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>, Dan Hor??k <dhorak@redhat.com>

On Fri, Feb 19, 2010 at 01:20:25AM +0100, Douglas Gilbert wrote:
> So send a START_STOP_UNIT(stop) through the SG_IO
> ioctl on a sd device opened RW and as a bonus get
> three INQUIRYs (one standard, two VPD pages) and 5 READ
> commands!
>
> If the device is SCSI (as the scsi_debug driver is
> simulating) then those READs fail because the drive
> is stopped. However if that is an ATA disk behind a
> SAT layer, then the disk will be spun up. That defeats
> the purpose of the pass-though, especially when it
> is being used to spin down the disk.
>
> My guess, reviewing the bug reports flowing into me is
> that this nonsense started around lk 2.6.29 .

We should never send INQUIRY or READ commands from the kernel
in response to opening a device.  But the combination sounds
like something udev might be doing for it's stable device
indentifier and manual partition scan because I don't trust
the kernel thing.  Can you check if these commands come from
udev or one of the realted tools (hal, device-kit-blah, udisks
whatever it is called today)

