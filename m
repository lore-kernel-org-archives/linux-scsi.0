From: Daniel Drake <dsd@gentoo.org>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs  disabled
 - dmesg filled with warnings
Date: Sat, 16 Feb 2008 11:49:47 +0000
Message-ID: <47B6CDDB.8000605@gentoo.org>
References: <47ADC74B.9080009@control.aau.dk>	 <1202580076.4254.24.camel@localhost.localdomain>	 <20080209193518.GC11299@hoblitt.com>	 <1202586219.4254.35.camel@localhost.localdomain>	 <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com>	 <1202855436.3137.153.camel@localhost.localdomain>	 <20080215205657.GB23625@hoblitt.com>	 <1203112643.3058.48.camel@localhost.localdomain> <1203113047.3058.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:62426 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYBPLsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 06:48:09 -0500
In-Reply-To: <1203113047.3058.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joshua Hoblitt <josh@hoblitt.com>, Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, j_gentoo@hoblitt.com, nick.cheng@areca.com.tw

I assume you're aware that this patch is just a subset of commit 
76d78300a6eb8 which you've already pushed up to Linus. Adding Nick Cheng 
(commit author) to CC so that he can go over the feedback.

James Bottomley wrote:
>>> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
>>> index f4a202e..4f9ff32 100644
>>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
>>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
>>> @@ -1380,12 +1388,13 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
>>>  
>>>  	case ARCMSR_MESSAGE_READ_RQBUFFER: {
>>>  		unsigned long *ver_addr;
>>> -		dma_addr_t buf_handle;
>>>  		uint8_t *pQbuffer, *ptmpQbuffer;
>>>  		int32_t allxfer_len = 0;
>>> +		void *tmp;
>>>  
>>> -		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
>>> -		if (!ver_addr) {
>>> +		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
>> GFP_DMA is pretty pointless for a buffer which never actually gets anywhere near a DMA, isn't it?
>>
>>> +		ver_addr = (unsigned long *)tmp;
>> No cast needed from void *
>>
>>> +		if (!tmp) {
>>>  			retvalue = ARCMSR_MESSAGE_FAIL;
>>>  			goto message_out;
>>>  		}
>>> @@ -1421,18 +1430,19 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
>>>  		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
>>>  		pcmdmessagefld->cmdmessage.Length = allxfer_len;
>>>  		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
>>> -		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
>>> +		kfree(tmp);
>>>  		}
>>>  		break;
>>>  
>>>  	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
>>>  		unsigned long *ver_addr;
>>> -		dma_addr_t buf_handle;
>>>  		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
>>>  		uint8_t *pQbuffer, *ptmpuserbuffer;
>>> +		void *tmp;
>>>  
>>> -		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
>>> -		if (!ver_addr) {
>>> +		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
> 
> Actually, also all the code around here implies we're in atomic context,
> so that GFP_KERNEL can't be right either.

Further confirmed by the fact that dma_free_coherent() was complaining 
about IRQs being disabled.


