From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BK PATCH] SCSI -rc fixes for 2.6.10-rc3
Date: Sat, 11 Dec 2004 08:46:46 -0600
Message-ID: <1102776407.5688.4.camel@mulgrave>
References: <1102650988.3814.13.camel@mulgrave>
	 <20041210201115.GD12581@suse.de>  <41BA2948.4030906@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27011 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261937AbULKOrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 09:47:05 -0500
In-Reply-To: <41BA2948.4030906@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, 2004-12-10 at 14:55 -0800, Randy.Dunlap wrote:
> I have a drive, but I'm not near a highmem machine atm.
> I can test it next week if no one else does so.

So would you be amenable to fixing it properly?  It looks like what
needs to happen is that it needs to accept its commands into the
scsi_pointer with page and offset (scsi_pointer doesn't have these
fields, but you could probably cast in ptr and dma_handle).  Then do a
kmap/kunmap around imm_in() and imm_out() when it's operating on
SCp.ptr.

James


