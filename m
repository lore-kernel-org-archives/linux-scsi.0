From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Wed, 30 Jun 2010 20:55:09 +0900
Message-ID: <20100630205458C.fujita.tomonori@lab.ntt.co.jp>
References: <20100628075738.GA26606@lst.de>
	<20100628171218Q.fujita.tomonori@lab.ntt.co.jp>
	<20100628152536.GA16013@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50578 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0F3L4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 07:56:20 -0400
In-Reply-To: <20100628152536.GA16013@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010 17:25:36 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Jun 28, 2010 at 05:14:28PM +0900, FUJITA Tomonori wrote:
> > > While I see the problems with leaking ressources in that case I still
> > > can't quite explain the hang I see.
> > 
> > Any way to reproduce the hang without ssd drives?
> 
> Actually the SSDs don't fully hang, they just causes lots of I/O errors
> and hit the error handler hard.  The hard hang is when running under
> qemu.  Apply the patch below, then create an if=scsi drive that resides
> on an XFS filesystem, and you'll have scsi TP support in the guest:

Ok, I figured out what's wrong.

As I suspected, it's due to the partial completion.

qemu scsi driver tells that the WRITE_SAME command was successful but
somehow the command has resid. So we retry it again and again (and
leak some memory).

I don't know yet why qemu scsi driver is broken. Maybe there is a bug
in it or converting discard to FS sends broken commands to the driver.

I'll try to figure out it tomorrow.

I've put a patch to complete discard command in the all-or-nothing
manner:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git discard


At least, the guest kernel doesn't hang for me.
