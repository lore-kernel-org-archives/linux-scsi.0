From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for	ISA/EISA
 hotplug API
Date: Sun, 24 Feb 2008 00:18:23 -0500
Message-ID: <47C0FE1F.300@garzik.org>
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org> <20080224045810.GA17051@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41385 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYBXFSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:18:25 -0500
In-Reply-To: <20080224045810.GA17051@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Eventually we shoud just kill the INT_COAL ifdefed code.  It has never
> been enabled and clutters up the driver quite badly.

Noted (queued)...  fine by me, and makes life easier.


>> +#ifdef CONFIG_EISA
>> +	if ((ha->type == GDT_EISA) && (ha->ccb_phys))
>> +		pci_unmap_single(ha->pdev, ha->ccb_phys, sizeof(gdth_cmd_str),
>> +				 PCI_DMA_BIDIRECTIONAL);
>> +#endif /* CONFIG_EISA */
> 
> I don't think moving this into the common helper makes any sense, as
> it's only ever done for the eisa adapter.  Just keep it local there.
> 
>> +#ifdef CONFIG_EISA
>> +	if (ha->type == GDT_EISA) {
>> +		ha->ccb_phys = pci_map_single(ha->pdev, &ha->cmdext,
>> +				sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
>> +		if (!ha->ccb_phys)
>> +			goto out_free;
>> +	}
>> +#endif /* CONFIG_EISA */
> 
> Same here.

hmmmmm.  We'll see how it plays out...  on the remove side, the above is 
exact what happens in gdth_remove_one() without my patch, thus 
consolidating two cases of the same code into one.  There is a 
less-strong argument for doing the allocation that way, but it may turn 
out to be useful anyway once the ISA/EISA API conversion is complete.

	Jeff


