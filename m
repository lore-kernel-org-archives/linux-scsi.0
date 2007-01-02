From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] block: export blk_verify_command for SG v4
Date: Wed, 03 Jan 2007 00:02:20 +0900
Message-ID: <200701021502.l02F2MI9019472@r-dd.iij4u.or.jp>
References: <20061216001756S.fujita.tomonori@lab.ntt.co.jp>
	<20070102114916.GC24951@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo06.iij.ad.jp ([210.130.1.94]:61322 "EHLO mfo06.iij.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbXABPDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 10:03:35 -0500
Received: MFO(mfo06) for <linux-scsi@vger.kernel.org> id l02F3RGx021023; Wed, 3 Jan 2007 00:03:27 +0900 (JST)
In-Reply-To: <20070102114916.GC24951@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] block: export blk_verify_command for SG v4
Date: Tue, 2 Jan 2007 11:49:16 +0000

> On Sat, Dec 16, 2006 at 12:18:23AM +0900, FUJITA Tomonori wrote:
> > blk_fill_sghdr_rq doesn't work for SG v4 so verify_command needed to
> > be exported.
> 
> So fixup blk_fill_sghdr_rq to deal with SG v4 aswell.  We really
> need to support all SGv4 features in the core code - bsg should
> only be a small wrapper around core functionality at the end.

Should blk_fill_sghdr_rq take cmd pointer, cmd_len, timeout, etc
instead of sg_io_hdr structure?


> And while you're touching this code, is there any chance you could
> unifity the command permission tables for the block layer code and
> the sg driver?  This has been long overdue.

No problem.

You refer to unifying allow_ops in drivers/scsi/sg.c and
blk_verify_command in block/scsi_ioctl.c, right?


> doug has a nice document somewhere that documents the differences
> between command allowances for the block layer vs the sg driver.
> Please go through these and take the more resonable version for
> each command.

SCSI command permissions:

http://sg.torque.net/sg/sg_io.html

You mean that the sg driver and the block layer code share the same
tables (might break some user-space code)?
