From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Fri, 11 Jun 2010 19:39:33 -0500
Message-ID: <4C12D745.3030701@cs.wisc.edu>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org> <4BFF6124.8000101@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA871286CE1A0@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38354 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab0FLAhX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 20:37:23 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA871286CE1A0@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

On 06/11/2010 03:44 AM, Vikas Chaudhary wrote:
>>> +/*
>>> +Address and length are byte address
>>> +*/
>>> +uint8_t *
>>> +qla82xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
>>> +            uint32_t offset, uint32_t length)
>>> +{
>>> +    scsi_block_requests(ha->host);
>>> +
>>> +    qla82xx_read_flash_data(ha, (uint32_t *)buf, offset, length);
>>> +
>>> +    scsi_unblock_requests(ha->host);
>>
>>
>>
>> What is the block/unblock for?  Looks like it could be racey.
>>
>>
>
> We want to block I/O while doing flash operations.
>

I was more wondering if there is also a test below that is also hit when 
you are doing flash operations? Is it the dpc reset bit check?

And what happens to scsi commands that are running when the flash 
operation runs? Does your firmware fail them and if it does what host 
byte error code are you using (or could you point out the chunk of 
driver code that handles this)?



> if (test_bit(DPC_RESET_HA_INTR,&ha->dpc_flags) ||
>              test_bit(DPC_RESET_ACTIVE,&ha->dpc_flags) ||
>              test_bit(DPC_RESET_HA,&ha->dpc_flags) ||
>              test_bit(DPC_HA_UNRECOVERABLE,&ha->dpc_flags) ||
>              test_bit(DPC_HA_NEED_QUIESCENT,&ha->dpc_flags) ||
>              !test_bit(AF_ONLINE,&ha->flags) ||
>              test_bit(DPC_RESET_HA_FW_CONTEXT,&ha->dpc_flags))
>                  goto qc_host_busy;
>

I missed that chunk when I first reviewed the patch. I think that is 
where I got confused in the other comment.
