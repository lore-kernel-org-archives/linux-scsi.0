From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH V2] fnic: check pci_map_single() return value
Date: Wed, 12 Aug 2015 17:00:32 +0200
Message-ID: <55CB5F90.2040806@redhat.com>
References: <1439385964-4599-1-git-send-email-mlombard@redhat.com> <mqdmvxwk4wl.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbbHLPAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 11:00:35 -0400
In-Reply-To: <mqdmvxwk4wl.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, sramars@cisco.com, jbottomley@parallels.com

Hi,

On 08/12/2015 03:33 PM, Johannes Thumshirn wrote:
> Hi Maurizio,
> 
> Sorry but it looks like you've forgotten one change in fnic_eth_send().

Ok, I converted fnic_eth_send() to use gotos for error cleanup and sent V3.

Hopefully it'll be the final version.
Thanks for the review.

Regards,
Maurizio Lombardi

> 
> Maurizio Lombardi <mlombard@redhat.com> writes:
> 
>> the kernel prints some warnings when compiled with CONFIG_DMA_API_DEBUG.
>> This is because the fnic driver doesn't check the return value of
>> pci_map_single().
>>
>> [   11.942770] scsi host12: fnic
>>  }
> 
> [..]
>>  
>>  void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
>> @@ -981,6 +993,7 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
>>  	struct ethhdr *eth_hdr;
>>  	struct vlan_ethhdr *vlan_hdr;
>>  	unsigned long flags;
>> +	int r;
>>  
>>  	if (!fnic->vlan_hw_insert) {
>>  		eth_hdr = (struct ethhdr *)skb_mac_header(skb);
>> @@ -1003,6 +1016,13 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
>>  
>>  	pa = pci_map_single(fnic->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
>>  
>> +	r = pci_dma_mapping_error(fnic->pdev, pa);
>> +	if (r) {
>> +		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
>> +		kfree_skb(skb);
>> +		return;
>> +	}
>> +
>>  	spin_lock_irqsave(&fnic->wq_lock[0], flags);
>>  	if (!vnic_wq_desc_avail(wq)) {
>>  		pci_unmap_single(fnic->pdev, pa, skb->len, PCI_DMA_TODEVICE);
>> @@ -1071,6 +1091,12 @@ static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
>>  
>>  	pa = pci_map_single(fnic->pdev, eth_hdr, tot_len, PCI_DMA_TODEVICE);
> [..]
> 
> Otherwise:
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
