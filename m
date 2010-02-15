From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SYNCHRONIZE CACHE command from sd on close
Date: Mon, 15 Feb 2010 08:25:02 -0500
Message-ID: <20100215132502.GA15360@infradead.org>
References: <4B79460A.7040207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0BONZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2010 08:25:03 -0500
Content-Disposition: inline
In-Reply-To: <4B79460A.7040207@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Feb 15, 2010 at 02:03:06PM +0100, Douglas Gilbert wrote:
> Recently, judging from error reports reaching me
> from smartmontools, sdparm and sg_start, something
> changed in the sd driver associated with the
> SYNCHRONIZE CACHE command it issues when a device
> is closed.
>
> That only seems to happen when the device is opened
> RW and it exposes a nasty difference between the
> semantics of spinning up and down ATA disks compared
> to SCSI disks.

The sd driver itself never sends a SYNCHRONIZE CACHE in
response to access through the block device node, it is only
sent for barrier requests, when hot-unplugging a scsi device,
or when shutting down the system.

Now that has change recently is that we now send down a cache
flush from the block layer when fsync is called on the block
device node.  The kernel should never call that by itself when
closing the device, but can you double check that the tools
don't call fsync/fdatasync/msync or open the block device node
using O_SYNC/O_DYSNC?

