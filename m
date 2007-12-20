From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Strange code in initio.c?
Date: Thu, 20 Dec 2007 09:26:44 +0200
Message-ID: <476A1934.5060808@panasas.com>
References: <200712201822.54806.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24006 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbXLTH07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 02:26:59 -0500
In-Reply-To: <200712201822.54806.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Thu, Dec 20 2007 at 9:22 +0200, Rusty Russell <rusty@rustcorp.com.au> wrote:
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
> 
> Cheers,
> Rusty.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Already in scsi-rc-fixes.
It seems your not using scsi-misc-2.6 git tree for all this.

