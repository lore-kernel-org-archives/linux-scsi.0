From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/8] be2iscsi : handles core routines
Date: Wed, 02 Sep 2009 00:13:48 -0500
Message-ID: <4A9DFF0C.2080802@cs.wisc.edu>
References: <20090902041134.GA19137@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46908 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZIBFNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Sep 2009 01:13:55 -0400
In-Reply-To: <20090902041134.GA19137@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

On 09/01/2009 11:11 PM, Jayamohan Kallickal wrote:
>    This file handles initiallization/teardown, allocation/free as well
>    as IO/Management flows.
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>


I think the driver is looking ok now. I sent Jay patches to fix the 
iscsi issues and to do coding style/api-use fix ups. My only concern is 
this function below which seems to be a memory hog and not very 
resilient to memory allocation failures.

The memory requirements are due to how the HW is designed (Jay can fill 
in more details if needed), so I think we are stuck.

The memory allocation failure handling could be improved, but I am not 
sure if it is required for the initial upstream merge. It could handle 
the failures by trying to allocate less memory when a larger allocation 
fails. Today, it will just fail the operation, clean itself up and then 
fail the module loading.

If others are ok with this for now and there are no other issues then 
please go ahead and merge. I do not have any other issues with it. I am 
not a expert on pci api stuff though, but I think Rolfe had got a lot of 
those issues.



> +
> +static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
> +{
> +	struct be_mem_descriptor *mem_descr;
> +	dma_addr_t bus_add;
> +	unsigned int num_size, i, j;
> +
> +	phba->phwi_ctrlr = kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
> +	if (!phba->phwi_ctrlr)
> +		return -ENOMEM;
> +
> +	phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(struct be_mem_descriptor),
> +				 GFP_KERNEL);
> +	if (!phba->init_mem) {
> +		kfree(phba->phwi_ctrlr);
> +		return -ENOMEM;
> +	}
> +
> +	mem_descr = phba->init_mem;
> +	for (i = 0; i<  SE_MEM_MAX; i++) {
> +		j = 0;
> +
> +		num_size = phba->mem_req[i];
> +		while (num_size) {
> +			if (j>= BEISCSI_MAX_FRAGS_INIT) {
> +				SE_DEBUG(DBG_LVL_1,
> +				 "Memory Fragment exceeded %d for"
> +				 "index=%d. Failing to Load thedriver\n",
> +				 BEISCSI_MAX_FRAGS_INIT, i);
> +				goto free_mem;
> +			}
> +
> +			if (num_size>= 131072) {
> +				mem_descr->mem_array[j].virtual_address =
> +				    pci_alloc_consistent(phba->pcidev,
> +						 131072,&bus_add);
> +				if (!mem_descr->mem_array[j].virtual_address) {
> +					SE_DEBUG(DBG_LVL_1, "Memory too"
> +					"fragmented to Load the driver");
> +					goto free_mem;
> +				} else {
> +					mem_descr->mem_array[j].bus_address.u.
> +					    a64.address = (__u64) bus_add;
> +					mem_descr->mem_array[j].size = 131072;
> +					memset(mem_descr->mem_array[j].
> +					       virtual_address, 0, 131072);
> +					j++;
> +					num_size -= 131072;
> +				}
> +			} else {
> +				mem_descr->mem_array[j].virtual_address =
> +				    pci_alloc_consistent(phba->pcidev,
> +						 num_size,&bus_add);
> +				if (!mem_descr->mem_array[j].virtual_address) {
> +					SE_DEBUG(DBG_LVL_1,
> +					"Memory too fragmented to Load driver");
> +					goto free_mem;
> +				} else {
> +					mem_descr->mem_array[j].bus_address.u.
> +					    a64.address = (__u64) bus_add;
> +					mem_descr->mem_array[j].size = num_size;
> +					memset(mem_descr->mem_array[j].
> +					       virtual_address, 0, num_size);
> +					j++;
> +					num_size -= num_size;
> +				}
> +			}
