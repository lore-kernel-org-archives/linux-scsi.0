From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 4/8] be2iscsi : handles core routines
Date: Wed, 2 Sep 2009 10:04:29 -0400
Message-ID: <19102.31597.873088.731026@stoffel.org>
References: <20090902041134.GA19137@serverengines.com>
	<4A9DFF0C.2080802@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:37981 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZIBOEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 10:04:35 -0400
In-Reply-To: <4A9DFF0C.2080802@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

Mike> On 09/01/2009 11:11 PM, Jayamohan Kallickal wrote:
>> This file handles initiallization/teardown, allocation/free as well
>> as IO/Management flows.
>> 
>> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
>> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>


Mike> I think the driver is looking ok now. I sent Jay patches to fix the 
Mike> iscsi issues and to do coding style/api-use fix ups. My only concern is 
Mike> this function below which seems to be a memory hog and not very 
Mike> resilient to memory allocation failures.

Mike> The memory requirements are due to how the HW is designed (Jay can fill 
Mike> in more details if needed), so I think we are stuck.

Mike> The memory allocation failure handling could be improved, but I am not 
Mike> sure if it is required for the initial upstream merge. It could handle 
Mike> the failures by trying to allocate less memory when a larger allocation 
Mike> fails. Today, it will just fail the operation, clean itself up and then 
Mike> fail the module loading.

Mike> If others are ok with this for now and there are no other issues then 
Mike> please go ahead and merge. I do not have any other issues with it. I am 
Mike> not a expert on pci api stuff though, but I think Rolfe had got a lot of 
Mike> those issues.

It would be good to at least put a comment in the code to say *why*
the hardware needs this much memory and what it's really looking for.

>> +static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>> +{
>> +	struct be_mem_descriptor *mem_descr;
>> +	dma_addr_t bus_add;
>> +	unsigned int num_size, i, j;
>> +
>> +	phba->phwi_ctrlr = kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
>> +	if (!phba->phwi_ctrlr)
>> +		return -ENOMEM;
>> +
>> +	phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(struct be_mem_descriptor),
>> +				 GFP_KERNEL);
>> +	if (!phba->init_mem) {
>> +		kfree(phba->phwi_ctrlr);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	mem_descr = phba->init_mem;
>> +	for (i = 0; i<  SE_MEM_MAX; i++) {
>> +		j = 0;
>> +
>> +		num_size = phba->mem_req[i];
>> +		while (num_size) {
>> +			if (j>= BEISCSI_MAX_FRAGS_INIT) {
>> +				SE_DEBUG(DBG_LVL_1,
>> +				 "Memory Fragment exceeded %d for"
>> +				 "index=%d. Failing to Load thedriver\n",
>> +				 BEISCSI_MAX_FRAGS_INIT, i);
>> +				goto free_mem;
>> +			}
>> +
>> +			if (num_size>= 131072) {

This magic number should be defined somewhere!

>> +				mem_descr->mem_array[j].virtual_address =
>> +				    pci_alloc_consistent(phba->pcidev,
>> +						 131072,&bus_add);

Same here...

>> +				if (!mem_descr->mem_array[j].virtual_address) {
>> +					SE_DEBUG(DBG_LVL_1, "Memory too"
>> +					"fragmented to Load the driver");
>> +					goto free_mem;
>> +				} else {
>> +					mem_descr->mem_array[j].bus_address.u.
>> +					    a64.address = (__u64) bus_add;
>> +					mem_descr->mem_array[j].size = 131072;

And here...

>> +					memset(mem_descr->mem_array[j].
>> +					       virtual_address, 0, 131072);

And here...

>> +					j++;
>> +					num_size -= 131072;
>> +				}
>> +			} else {
>> +				mem_descr->mem_array[j].virtual_address =
>> +				    pci_alloc_consistent(phba->pcidev,
>> +						 num_size,&bus_add);
>> +				if (!mem_descr->mem_array[j].virtual_address) {
>> +					SE_DEBUG(DBG_LVL_1,
>> +					"Memory too fragmented to Load driver");
>> +					goto free_mem;
>> +				} else {
>> +					mem_descr->mem_array[j].bus_address.u.
>> +					    a64.address = (__u64) bus_add;
>> +					mem_descr->mem_array[j].size = num_size;
>> +					memset(mem_descr->mem_array[j].
>> +					       virtual_address, 0, num_size);
>> +					j++;
>> +					num_size -= num_size;
>> +				}
>> +			}
Mike> --
Mike> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
Mike> the body of a message to majordomo@vger.kernel.org
Mike> More majordomo info at  http://vger.kernel.org/majordomo-info.html
