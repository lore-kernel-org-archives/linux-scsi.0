From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 2)
Date: Tue, 10 Feb 2004 16:26:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F255023@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:688 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261152AbUBJV0r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:26:47 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Ooops, on my test CONFIG_HIGHMEM was not set ...

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, February 10, 2004 4:26 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64
bit and bitrot (part 2)

+	/*
+	 *      Only enable PAE mode if the dma_addr_t is larger than
+	 * 32 bit addressing, and we have more than 32 bit addressing
+	 * worth of memory.
+	 */
+	if( (sizeof(dma_addr_t) > 4)
+	 && (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT))) {
+		pHba->pae_support = 1;
+		pci_set_dma_mask(pHba->pDev,
(dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
+#if (defined(CONFIG_HIGHMEM))
+		host->highmem_io = 1;
+#endif

	How is this supposed to compile?  The field doesn't exist
anymore.

