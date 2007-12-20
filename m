From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Strange code in initio.c?
Date: Thu, 20 Dec 2007 18:22:54 +1100
Message-ID: <200712201822.54806.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48837 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXLTHXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 02:23:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

Hi Alan,

	Was looking through initio.c to convert it to sg_ring, and noticed this code:

initio_build_scb() around 2616:
		sg = &cblk->sglist[0];
		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
		}

Note how sg is never incremented... seems wrong to me.

Cheers,
Rusty.
