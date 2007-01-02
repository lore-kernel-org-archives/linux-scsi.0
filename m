From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] block: export blk_verify_command for SG v4
Date: Tue, 2 Jan 2007 15:20:05 +0000
Message-ID: <20070102152005.GA21427@infradead.org>
References: <20061216001756S.fujita.tomonori@lab.ntt.co.jp> <20070102114916.GC24951@infradead.org> <200701021502.l02F2MI9019472@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbXABPUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 10:20:08 -0500
Content-Disposition: inline
In-Reply-To: <200701021502.l02F2MI9019472@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Wed, Jan 03, 2007 at 12:02:20AM +0900, FUJITA Tomonori wrote:
> > > blk_fill_sghdr_rq doesn't work for SG v4 so verify_command needed to
> > > be exported.
> > 
> > So fixup blk_fill_sghdr_rq to deal with SG v4 aswell.  We really
> > need to support all SGv4 features in the core code - bsg should
> > only be a small wrapper around core functionality at the end.
> 
> Should blk_fill_sghdr_rq take cmd pointer, cmd_len, timeout, etc
> instead of sg_io_hdr structure?


Yes, that's what I meant.  But now that I actually took a look at
blk_fill_sghdr_rq again that doesn't make a lot of sense anymore :)

We probably should have blk_fill_sghdrv3_rq and blk_fill_sghdrv4_rq
in core code instead.

> > And while you're touching this code, is there any chance you could
> > unifity the command permission tables for the block layer code and
> > the sg driver?  This has been long overdue.
> 
> No problem.
> 
> You refer to unifying allow_ops in drivers/scsi/sg.c and
> blk_verify_command in block/scsi_ioctl.c, right?

Yes.

> > doug has a nice document somewhere that documents the differences
> > between command allowances for the block layer vs the sg driver.
> > Please go through these and take the more resonable version for
> > each command.
> 
> SCSI command permissions:
> 
> http://sg.torque.net/sg/sg_io.html

Exactly, that one.

> You mean that the sg driver and the block layer code share the same
> tables (might break some user-space code)?

I don't really see it that way.  Eiter the more relaxed of the two
permissions was wrong in which case we need to fix.  Or it was okay
and we should support it generally.
