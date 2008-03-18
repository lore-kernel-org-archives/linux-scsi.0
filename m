From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg?
 device causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 09:48:25 +0900
Message-ID: <20080318094816C.tomof@acm.org>
References: <47D7035F.5000700@sgi.com>
	<47DEB3A7.1030600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:51064 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYCRAtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 20:49:09 -0400
In-Reply-To: <47DEB3A7.1030600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: mdr@sgi.com, dougg@torque.net, linux-scsi@vger.kernel.org, jeremy@sgi.com, James.Bottomley@SteelEye.com, tomof@acm.org

On Mon, 17 Mar 2008 13:08:39 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> Michael Reed wrote:
> > -		++blk_size;	/* don't know why */
> > -/* round request up to next highest SG_SECTOR_SZ byte boundary */
> 
> I think we can remove this code. This was asked before, and here is 
> Doug's reply:
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11757.html
> 
> It was probaly due to some weirdness in that the scatterlist that sg.c 
> made used to be sent directly to the LLD (now it is only used to 
> hold/organize the pages/segments that the sg and st driver manages in 
> their internal reserves), or maybe it had something to do with that and 
> dma alignment problems or something. I really have no idea, but the 
> block layer SG IO code has not been rounding up in its indirect path and 
> it has been fine.

The block layer (blk_rq_map_user) does padding for LLDs, I guess.
