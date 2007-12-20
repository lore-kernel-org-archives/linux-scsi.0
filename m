From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Strange code in initio.c?
Date: Thu, 20 Dec 2007 16:27:24 +0900
Message-ID: <20071220162724R.fujita.tomonori@lab.ntt.co.jp>
References: <200712201822.54806.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:48557 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXLTH1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 02:27:50 -0500
In-Reply-To: <200712201822.54806.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org

On Thu, 20 Dec 2007 18:22:54 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi Alan,
> 
> 	Was looking through initio.c to convert it to sg_ring, and noticed this code:
> 
> initio_build_scb() around 2616:
> 		sg = &cblk->sglist[0];
> 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
> 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
> 			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
> 		}
> 
> Note how sg is never incremented... seems wrong to me.

It was fixed.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a169e63740779f62a9a5ddf0aa61091a393a03c5
