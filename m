From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 28 Jan 2009 00:46:13 +0100
Message-ID: <497F9CC5.8080807@s5r6.in-berlin.de>
References: <20090127165508L.fujita.tomonori@lab.ntt.co.jp>	<20090127183723W.fujita.tomonori@lab.ntt.co.jp>	<tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de> <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57128 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZA0Xqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 18:46:30 -0500
In-Reply-To: <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> +static void sbp2_unmap_scatterlist(struct device *card_device,
>> +				   struct sbp2_command_orb *orb)
>> +{
>> +	if (scsi_sg_count(orb->cmd))
>> +		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
>> +			     scsi_sg_count(orb->cmd),
>> +			     orb->cmd->sc_data_direction);
>> +
>> +	if (orb->page_table_bus)
>> +		dma_unmap_single(card_device, orb->page_table_bus,
>> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> 
> Well, this does not look correct since zero can be a valid dma
> address.

Hmm.

> static void sbp2_unmap_scatterlist(struct device *card_device,
> 				   struct sbp2_command_orb *orb)
> {
> 	if (scsi_sg_count(orb->cmd))
> 		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> 			     scsi_sg_count(orb->cmd),
> 			     orb->cmd->sc_data_direction);
> 
> 	if (scsi_sg_count(orb->cmd) > 1)
> 		dma_unmap_single(card_device, orb->page_table_bus,
> 				 sizeof(orb->page_table), DMA_TO_DEVICE);
> 
> 
> Well, looks cranky a bit but firewire is cranky for me :)

Even if scsi_sg_count(cmd) > 1, the outcome of dma_map_sg() could have
been 1, couldn't it?  So I need to take note of that in another way.
-- 
Stefan Richter
-=====-==--= ---= ===--
http://arcgraph.de/sr/
