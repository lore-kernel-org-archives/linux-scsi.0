From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Sun, 13 May 2007 16:04:07 +0200
Message-ID: <46471AD7.5010105@s5r6.in-berlin.de>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>	<20070512153151.GB8088@infradead.org> <200705130330.l4D3Ut3Y027684@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48754 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbXEMOEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 10:04:24 -0400
In-Reply-To: <200705130330.l4D3Ut3Y027684@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Christoph Hellwig <hch@infradead.org>
...
>> As James already said the device argument should not be needed at all.
...
> +int scsi_dma_map(struct scsi_cmnd *cmd)
> +{
> +	int nseg = 0;
> +
> +	if (scsi_sg_count(cmd)) {
> +		struct device *dev = cmd->device->host->shost_gendev.parent;
...

As a side note:

What is currently not supported by SCSI mid layer is that an sdev could
be moved from one initiator port to another.  If that happens, transport
layer drivers have to destroy the sdev and create a new one.  Or they
could represent /all/ initiator ports by a single shost, but then they
can't use the two new scsi_dma_ wrappers.  (Assuming there aren't any
other issues which would prevent the single-shost approach.)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
