From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Sat, 12 Jun 2010 02:56:40 -0700
Message-ID: <647AA6F2-6F49-42FC-9167-84741A55EF20@qlogic.com>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
 <4BFF6124.8000101@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA871286CE1A0@AVEXMB1.qlogic.org>
 <4C12D745.3030701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:19934 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0FLJ4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2010 05:56:39 -0400
In-Reply-To: <4C12D745.3030701@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>


On Jun 11, 2010, at 5:39 PM, Mike Christie wrote:

> On 06/11/2010 03:44 AM, Vikas Chaudhary wrote:
>>>> +/*
>>>> +Address and length are byte address
>>>> +*/
>>>> +uint8_t *
>>>> +qla82xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
>>>> +            uint32_t offset, uint32_t length)
>>>> +{
>>>> +    scsi_block_requests(ha->host);
>>>> +
>>>> +    qla82xx_read_flash_data(ha, (uint32_t *)buf, offset, length);
>>>> +
>>>> +    scsi_unblock_requests(ha->host);
>>> 
>>> 
>>> 
>>> What is the block/unblock for?  Looks like it could be racey.
>>> 
>>> 
>> 
>> We want to block I/O while doing flash operations.
>> 
> 
> I was more wondering if there is also a test below that is also hit when 
> you are doing flash operations? Is it the dpc reset bit check?

Actually any one of the below bit will be sit during the flash operation.

> 
> And what happens to scsi commands that are running when the flash 
> operation runs? Does your firmware fail them and if it does what host 
> byte error code are you using (or could you point out the chunk of 
> driver code that handles this)?
> 

Driver during init time or at runt time does flash operation mainly to download F/W
and activate it. So basically at this point of time F/W is not active. So the  I/O will
be primarily handled as outlined below.

After further careful analysis of the code, looks like above *_unblock_request()/_block_request()* code is redundant
and can be removed. Its already been done in recover_adapter(). So actually its not needed.

> 
> 
>> if (test_bit(DPC_RESET_HA_INTR,&ha->dpc_flags) ||
>>             test_bit(DPC_RESET_ACTIVE,&ha->dpc_flags) ||
>>             test_bit(DPC_RESET_HA,&ha->dpc_flags) ||
>>             test_bit(DPC_HA_UNRECOVERABLE,&ha->dpc_flags) ||
>>             test_bit(DPC_HA_NEED_QUIESCENT,&ha->dpc_flags) ||
>>             !test_bit(AF_ONLINE,&ha->flags) ||
>>             test_bit(DPC_RESET_HA_FW_CONTEXT,&ha->dpc_flags))
>>                 goto qc_host_busy;
>> 
> 
> I missed that chunk when I first reviewed the patch. I think that is 
> where I got confused in the other comment.

Hope this helps.

Thanks
Ravi