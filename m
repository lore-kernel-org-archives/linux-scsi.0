From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 12:23:46 +0100
Message-ID: <20081117112346.GI6703@one.firstfloor.org>
References: <20081116221722.GB6703@one.firstfloor.org> <20081117141240X.fujita.tomonori@lab.ntt.co.jp> <20081117102227.GG6703@one.firstfloor.org> <20081117200720M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:52650 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYKQLOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Nov 2008 06:14:09 -0500
Content-Disposition: inline
In-Reply-To: <20081117200720M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

> > I would rather prefer to fix the driver to always GFP_DMA, but I am
> > not aware of any driver who needs it. Are you?
> 
> Well, theoretically, there migth be an user who want these ioctl with
> all the drivers that are not capable of 64bit DMA since sg allocates
> the reserved buffer with GFP_KERNEL. These driver might use the
> block-layer bounce buffer. Users might want to use
> SG_SET_FORCE_LOW_DMA to avoid the bounce buffer latency.

But that would force everything through the 16MB zone,
putting a lot of pressure on it and might even overflow on some
loads. I don't think that's a good strategy for any application.

-Andi
-- 
ak@linux.intel.com
