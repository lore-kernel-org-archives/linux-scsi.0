From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 2)
Date: Tue, 10 Feb 2004 21:25:53 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210212553.A10779@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F255014@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:5648 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261464AbUBJVZ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:25:56 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F255014@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Tue, Feb 10, 2004 at 03:53:39PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

+	/*
+	 *      Only enable PAE mode if the dma_addr_t is larger than
+	 * 32 bit addressing, and we have more than 32 bit addressing
+	 * worth of memory.
+	 */
+	if( (sizeof(dma_addr_t) > 4)
+	 && (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT))) {
+		pHba->pae_support = 1;
+		pci_set_dma_mask(pHba->pDev, (dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
+#if (defined(CONFIG_HIGHMEM))
+		host->highmem_io = 1;
+#endif

	How is this supposed to compile?  The field doesn't exist anymore.

