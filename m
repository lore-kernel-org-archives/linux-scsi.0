From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 20:11:46 +0200
Message-ID: <20110702181146.GM23059@one.firstfloor.org>
References: <1309609482.2554.8.camel@mulgrave> <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:52296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1GBSLr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2011 14:11:47 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

> The problem is that blk_peek_request() calls scsi_prep_fn(), which 
> does this:
> 
> 	struct scsi_device *sdev = q->queuedata;
> 	int ret = BLKPREP_KILL;
> 
> 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
> 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
> 	return scsi_prep_return(q, req, ret);
> 
> It doesn't check to see if sdev is NULL, nor does 
> scsi_setup_blk_pc_cmnd().  That accounts for this error:

I actually added a NULL check in scsi_setup_blk_pc_cmnd early on,
but that just caused RCU CPU stalls afterwards and then eventually
a hung system.

-Andi
