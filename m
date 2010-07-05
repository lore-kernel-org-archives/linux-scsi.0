From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/12] be2iscsi: Fix for premature buffer free
Date: Mon, 05 Jul 2010 13:58:41 -0500
Message-ID: <4C322B61.3030802@cs.wisc.edu>
References: <20100630000021.GA20279@serverengines.com> <4C30E874.2090200@cs.wisc.edu> <201007042222.36951.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43576 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0GESzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2010 14:55:49 -0400
In-Reply-To: <201007042222.36951.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/04/2010 03:22 PM, Rolf Eike Beer wrote:
> Mike Christie wrote:
>> On 06/29/2010 07:00 PM, Jayamohan Kallickal wrote:
>
>>> @@ -160,18 +179,34 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd
>>> *sc)
>>>
>>>    	spin_unlock_bh(&session->lock);
>>>    	inv_tbl = phba->inv_tbl;
>>>
>>> -	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
>>> +	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
>>> +				sizeof(struct invalidate_commands_params_in),
>>> +				&nonemb_cmd.dma);
>>> +	if (nonemb_cmd.va == NULL) {
>>> +		SE_DEBUG(DBG_LVL_1,
>>> +			 "Failed to allocate memory for"
>>> +			 "mgmt_invalidate_icds\n");
>>> +		return -1;
>>
>> return FAILED.
>
> Why not ENOMEM? That would come into my mind when an allocations fails.
>

Because that function is called by the scsi layer's error handling code 
and it uses SUCCESS and FAILED for return values.
