From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Thu, 1 Jul 2010 13:21:42 +0900
Message-ID: <20100701132130F.fujita.tomonori@lab.ntt.co.jp>
References: <20100628171218Q.fujita.tomonori@lab.ntt.co.jp>
	<20100628152536.GA16013@lst.de>
	<20100630205458C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40259 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0GAEWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 00:22:49 -0400
In-Reply-To: <20100630205458C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Wed, 30 Jun 2010 20:55:09 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 28 Jun 2010 17:25:36 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Mon, Jun 28, 2010 at 05:14:28PM +0900, FUJITA Tomonori wrote:
> > > > While I see the problems with leaking ressources in that case I still
> > > > can't quite explain the hang I see.
> > > 
> > > Any way to reproduce the hang without ssd drives?
> > 
> > Actually the SSDs don't fully hang, they just causes lots of I/O errors
> > and hit the error handler hard.  The hard hang is when running under
> > qemu.  Apply the patch below, then create an if=scsi drive that resides
> > on an XFS filesystem, and you'll have scsi TP support in the guest:
> 
> Ok, I figured out what's wrong.
> 
> As I suspected, it's due to the partial completion.
> 
> qemu scsi driver tells that the WRITE_SAME command was successful but
> somehow the command has resid. So we retry it again and again (and
> leak some memory).
> 
> I don't know yet why qemu scsi driver is broken. Maybe there is a bug
> in it or converting discard to FS sends broken commands to the driver.

looks like your qemu WRITE_SAME patch isn't completed :)

You implement WRITE_SAME as if it doesn't do any data transfer. So
qemu scsi driver gets resid.

The reason why WRITE_SAME works now is that scsi-ml doesn't care about
resid with PC commands but it cares with FS commands.

I confirmed that qemu scsi driver gets the identical command with both
PC and FS commands and qemu calls xfsctl.


> I've put a patch to complete discard command in the all-or-nothing
> manner:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git discard

Seems that I finished discard FS conversion. I'll update it on the top
of James' uprep patchset soon.
