From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] ibmvscsi driver - sixth version
Date: 31 Mar 2004 16:58:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080770310.2071.44.camel@mulgrave>
References: <opr3u0ffo7l6e53g@us.ibm.com>
	<20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com>
	<1079027038.2820.57.camel@mulgrave>  <opr5qwiyw4l6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:49077 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261932AbUCaV7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 16:59:16 -0500
In-Reply-To: <opr5qwiyw4l6e53g@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2004-03-31 at 16:26, Dave Boutcher wrote:
> Comments always welcomed.  I would like to get this upstream if I can, 
> since the linux distributors are complaining slightly that it is not.

Actually, this:

+	    (u64) (unsigned long)dma_map_single(dev, cmd->request_buffer,
+						cmd->request_bufflen,
+						DMA_BIDIRECTIONAL);
+	if (pci_dma_mapping_error(data->virtual_address)) {
+		printk(KERN_ERR
+		       "ibmvscsi: Unable to map request_buffer for command!\n");
+		return 0;

Should be

if(dma_mapping_error())

I have no idea why there are two identical APIs for the mapping error,
but since you use the DMA API, you should use its version.  You can also
drop the #include <linux/pci.h> as well.


This:

+	sg_mapped = dma_map_sg(dev, sg, cmd->use_sg, DMA_BIDIRECTIONAL);
+
+	if (pci_dma_mapping_error(sg_dma_address(&sg[0])))
+		return 0;

Is wrong.  dma_map_sg returns zero if there's a mapping error, you
should check for that.

James


