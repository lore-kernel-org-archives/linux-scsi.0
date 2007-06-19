From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Mon, 18 Jun 2007 23:07:31 -0700 (PDT)
Message-ID: <20070618.230731.11645150.davem@davemloft.net>
References: <1181947242.3600.8.camel@mulgrave.il.steeleye.com>
	<20070615.160858.26276547.davem@davemloft.net>
	<20070619055629.GE18542@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45848
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbXFSGHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 02:07:12 -0400
In-Reply-To: <20070619055629.GE18542@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: James.Bottomley@SteelEye.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 19 Jun 2007 07:56:29 +0200

> A SCSI pass through is of course perfectly fine.  If you have a separate
> block passthrough that has additional magic a separate block driver is
> the way to go because it actually is simpler than a scsi driver decoding
> command blocks and translating them to deep magic.  The ps3 storage
> drivers this thread discussed are a good example for that.  We now
> have a very nice and simple disk, scsi and flash chardev driver each
> that don't include abstractions layers and cruft.  Combine that with
> their initial scsi layer driver that was full of internal dispatches
> because each of these device types speaks a completely different command
> set.

That's how I'm currently writing my virtual disk client driver
for the Sun LDOMS stuff, as a block device.

The remaining issues are the partitioning (which we're discussing in
another thread) and how to export the scsi passthru support in such a
non-scsi block driver.

The main disk I/O block read and write is done using descriptors
sent to the disk server.  SCSI pass-through is provided (optionally)
so that disk analysis tools can do things like MODE_SENSE on the
disk.
