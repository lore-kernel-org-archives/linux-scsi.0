From: James Bottomley <James.Bottomley@steeleye.com>
Subject: aic7xxx compile failure
Date: 20 May 2003 16:43:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053467040.3784.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:22023 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261219AbTETVcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 17:32:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: wli@holomorphy.com, Stian Jordet <liste@jordet.nu>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Several people have reported compile failures due to this code in
aic7xxx_osm.c:

	if (sizeof(bus_addr_t) > 4
	 && (ahc->flags & AHC_39BIT_ADDRESSING) != 0) {
		/*
		 * Due to DAC restrictions, we can't
		 * cross a 4GB boundary.
		 */
		if ((addr ^ (addr + len - 1)) & ~0xFFFFFFFF) {
			struct	 ahc_dma_seg *next_sg;
			uint32_t next_len;

			printf("Crossed Seg\n");
			if ((scb->sg_count + 2) > AHC_NSEG)
				panic("Too few segs for dma mapping.  "
				      "Increase AHC_NSEG\n");

			consumed++;
			next_sg = sg + 1;
			next_sg->addr = 0;
			next_len = 0x100000000 - (addr & 0xFFFFFFFF);
			len -= next_len;
			next_len |= ((addr >> 8) + 0x1000000) & 0x7F000000;
			next_sg->len = ahc_htole32(next_len);
		}
		len |= (addr >> 8) & 0x7F000000;

The main problem being the constant on line 767 is 33 bits wide and thus
too long for the computation.

My initial reaction is that obviously this should become zero minus to
keep everything within u32.

However, I note that the code is unnecessary anyway: both 2.4 and 2.5
will not let physical segment merging cross a 4GB boundary (in 2.5 the
boundary is settable, but defaults to 4GB).  Could we just take this
out, please?

James


