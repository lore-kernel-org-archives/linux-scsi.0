From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] hpsa: add support for legacy boards
Date: Wed, 9 Aug 2017 16:50:07 +0200
Message-ID: <ecbf59f4-8d34-8062-5f21-f3056dce8727@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-3-git-send-email-hare@suse.de>
 <20170809134514.GD25852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40923 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751940AbdHIOuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 10:50:10 -0400
In-Reply-To: <20170809134514.GD25852@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/09/2017 03:45 PM, Christoph Hellwig wrote:
>> -static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
>> +static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
>> +				bool *supported)
>>  {
>>  	int i;
>>  	u32 subsystem_vendor_id, subsystem_device_id;
>> @@ -7242,9 +7266,22 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
>>  	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
>>  		    subsystem_vendor_id;
>>  
>> +	if (supported)
>> +		*supported = true;
>>  	for (i = 0; i < ARRAY_SIZE(products); i++)
>> -		if (*board_id == products[i].board_id)
>> -			return i;
>> +		if (*board_id == products[i].board_id) {
>> +			if (products[i].access != &SA5A_access &&
>> +			    products[i].access != &SA5B_access)
>> +				return i;
>> +			if (hpsa_allow_any) {
>> +				dev_warn(&pdev->dev,
>> +					 "unsupported board ID: 0x%08x\n",
>> +					 *board_id);
>> +				if (supported)
>> +					*supported = false;
>> +				return i;
>> +			}
>> +		}
> 
> Can you explain the point of the supported flag?
> 
'hpsa_allow_any' just enables the _driver_ to bind to older /
unsupported boards, it doesn't tell us if this particular instance is an
old board.
For older boards we should suppress messages from not-implemented
features, whereas on 'real' boards those features should be implemented,
and we should be throwing an error or a warning.
Hence the =supported" flag.

>> +	unsigned long register_value  =
>> +		readl(h->vaddr + SA5_INTR_STATUS);
>> +	return (register_value & SA5B_INTR_PENDING);
> 
> This should be condensed into:
> 
> 	return readl(h->vaddr + SA5_INTR_STATUS) & SA5B_INTR_PENDING;
> 
Yeah; but this is _actually_ just copied over, so other lines will be
affected here, too.
Will be adding a patch for that.

>>  	.command_completed = SA5_completed,
>>  };
>>  
>> +/* Duplicate entry of the above to mark unsupported boards */
>> +static struct access_method SA5A_access = {
>> +	.submit_command = SA5_submit_command,
>> +	.set_intr_mask = SA5_intr_mask,
>> +	.intr_pending = SA5_intr_pending,
>> +	.command_completed = SA5_completed,
>> +};
>> +
>> +static struct access_method SA5B_access = {
>> +	.submit_command = SA5_submit_command,
>> +	.set_intr_mask = SA5B_intr_mask,
>> +	.intr_pending = SA5B_intr_pending,
>> +	.command_completed = SA5_completed,
>> +};
> 
> Please align the fields nicely, e.g.:
> 
> static struct access_method SA5A_access = {
> 	.submit_command 	= SA5_submit_command,
> 	.set_intr_mask		= SA5_intr_mask,
> 	...
> 
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
