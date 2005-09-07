From: Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 7 Sep 2005 12:59:32 +1000
Message-ID: <20050907025932.GU6945@krispykreme>
References: <20050906212801.GB14057@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:1228 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S1750866AbVIGDCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 23:02:21 -0400
Content-Disposition: inline
In-Reply-To: <20050906212801.GB14057@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>


Hi Dave,

> This device driver provides the SCSI target side of the "virtual
> SCSI" on IBM Power5 systems.  The initiator side has been in mainline
> for a while now (drivers/scsi/ibmvscsi/ibmvscsi.c.)  Targets already
> exist for AIX and OS/400.

Good stuff. Got a couple of small suggestions.

+/* Allocate a buffer with a dma_address.  Don't use dma_alloc_coherent
+ * since that uses GFP_ATOMIC internally and we can tollerate a delay
+ */
+static void *alloc_coherent_buffer(struct server_adapter *adapter, size_t size,
+				   dma_addr_t *dma_handle)
+{
+	void *buffer = kmalloc(size, GFP_KERNEL);
+
+	if (buffer) {
+		*dma_handle = dma_map_single(adapter->dev, buffer, size,
+					     DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(*dma_handle)) {
+			kfree(buffer);
+			buffer = NULL;
+		}
+	}
+
+	return buffer;
+}

This should be fixed in mainline, on ppc64 we no longer build the dma_*
ops on top of the pci_* ops. This means we actually look at the flags :)

+	adapter->max_sectors = MAX_SECTORS;

Does this mean we are limited to 128kB transfers? Would it be OK to
bump the default?

Anton
