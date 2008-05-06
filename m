From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Added flush_disk to factor out common buffer cache
	flushing code.
Date: Tue, 6 May 2008 04:44:11 -0400
Message-ID: <20080506084411.GA31380@infradead.org>
References: <20080505230414.12905.15331.stgit@bluto.andrew> <20080505230419.12905.36939.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYEFIoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 04:44:14 -0400
Content-Disposition: inline
In-Reply-To: <20080505230419.12905.36939.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com

On Mon, May 05, 2008 at 05:04:19PM -0600, Andrew Patterson wrote:
> Added flush_disk to factor out common buffer cache flushing code.
> 
> We need to be able to flush the buffer cache for more than just when a
> disk is changed, so we factor out common cache flush code in
> check_disk_change() to an internal flush_disk() routine.  This routine
> will then be used for both disk changes and disk resizes (in a later
> patch).
> 
> Include the disk name in the text indicating that there are busy
> inodes on the device and increase the KERN severity of the message.

This doesn't make much sense to me.  When a disk has grown there's no
point in invalidating any buffers, and when it has shrunk it's too late
already.  Also I suspect modern filesystems might be really allergic to
this kind of under the hood actions.  That is if they use the bdev
mapping at all, something that at least xfs and I think btrfs aswell
don't do at all.

