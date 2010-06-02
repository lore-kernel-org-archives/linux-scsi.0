From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 02 Jun 2010 11:54:25 +0300
Message-ID: <4C061C41.2010104@panasas.com>
References: <20100602163313S.fujita.tomonori@lab.ntt.co.jp>	<4C0612CC.6050602@panasas.com> <20100602173925H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:41827 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757508Ab0FBIy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 04:54:29 -0400
In-Reply-To: <20100602173925H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

On 06/02/2010 11:39 AM, FUJITA Tomonori wrote:
> On Wed, 02 Jun 2010 11:14:04 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>  static void scsi_run_queue(struct request_queue *q);
>>>  
>>> +int scsi_get_data_transfer_info(unsigned char *cmd, unsigned long long *lba,
>>> +				unsigned int *num, unsigned int *ei_lba)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	switch (*cmd) {
>>> +	case VARIABLE_LENGTH_CMD:
>>> +		*lba = get_unaligned_be64(&cmd[12]);
>>> +		*num = get_unaligned_be32(&cmd[28]);
>>> +		*ei_lba = get_unaligned_be32(&cmd[20]);
>>
>> This is true for scsi_debug maybe but totally wrong
>> for any none disk command set.
> 
> Ok, I can remove it.
> 
> 
>>> +		break;
>>> +	case WRITE_16:
>>> +	case READ_16:
>>> +	case VERIFY_16:
>>> +	case WRITE_SAME_16:
>>> +		*lba = get_unaligned_be64(&cmd[2]);
>>> +		*num = get_unaligned_be32(&cmd[10]);
>>> +		break;
>>> +	case WRITE_12:
>>> +	case READ_12:
>>> +	case VERIFY_12:
>>> +		*lba = get_unaligned_be32(&cmd[2]);
>>> +		*num = get_unaligned_be32(&cmd[6]);
>>> +		break;
>>> +	case WRITE_10:
>>> +	case READ_10:
>>> +	case XDWRITEREAD_10:
>>> +	case VERIFY:
>>> +	case WRITE_SAME:
>>> +		*lba = get_unaligned_be32(&cmd[2]);
>>> +		*num = get_unaligned_be16(&cmd[7]);
>>> +		break;
>>> +	case WRITE_6:
>>> +	case READ_6:
>>> +		*lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
>>> +			(u32)(cmd[1] & 0x1f) << 16;
>>> +		*num = (0 == cmd[4]) ? 256 : cmd[4];
>>> +		break;
>>> +	default:
>>> +		ret = -1;
>>> +		break;
>>> +	}
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL(scsi_get_data_transfer_info);
>>> +
>>>  /*
>>>   * Function:	scsi_unprep_request()
>>>   *
>>> @@ -1046,6 +1093,8 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>>>  {
>>>  	struct scsi_cmnd *cmd;
>>>  	int ret = scsi_prep_state_check(sdev, req);
>>> +	unsigned int num, ei_lba;
>>> +	unsigned long long lba;
>>>  
>>>  	if (ret != BLKPREP_OK)
>>>  		return ret;
>>> @@ -1082,7 +1131,10 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>>>  		cmd->sc_data_direction = DMA_TO_DEVICE;
>>>  	else
>>>  		cmd->sc_data_direction = DMA_FROM_DEVICE;
>>> -	
>>> +
>>> +	scsi_get_data_transfer_info(cmd->cmnd, &lba, &num, &ei_lba);
>>> +	req->__sector = lba;
>>> +
>>
>> Why do it for every command. Even if no one is using it?
> 
> Some LLDs already use scsi_get_lba(). They don't know scsi command
> from pc or fs so they can't use scsi_get_lba() now. Well, they can see
> scsi_cmnd->request to know pc or fs but it's layer violation. They
> shouldn't access to the block layer stuff.
> 

right, so hide it all under an API that is implemented at the right
level, and protect them. The driver should call a single simple
API the magic will be done at the generic level

	if (blk_fs_rq(req))
		return blk_rq_pos(req);
	else
		return scsi_somthing();

> 
>> Only drivers/code that actually cares should call this member.
>>
>> It should be easy enough to search for __sector and change them
>> to a function call.
> 
> I don't think that calling such function in LLDs is a clean design. We
> set request->__sector for fs requests. Why not for pc requests? Then
> we can use blk_rq_pos() cleanly. 
> 

Because "fs requests" have a defined blk_rq_pos(). But "pc requests"
don't necessarily have one. Pretending to invent one is stupid and
dangerous. Better keep a -1 for all "pc requests".

scsi LLDs can be pass-through for disks, as well as lots of other
type of devices. They should not assume the role of a disk. The use
of blk_rq_pos() at LLDs is probably wrong in the first place. Unless
it is some kind of scsi emulation driver like scsi_debug.

> 
>> This is not accepted, for osd for instance, on the hot path like this.
>> The few users should be fixed.
> 
> I'm not sure if this effects the performance notably.
> 
> I'll think about something different if James doesn't like the
> approach.

NAK from me
Boaz
