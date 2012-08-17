From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] target: Remove unused se_cmd.cmd_spdtl
Date: Fri, 17 Aug 2012 14:05:41 +0300
Message-ID: <502E2585.7080106@panasas.com>
References: <1345091092-4539-1-git-send-email-roland@kernel.org>  <CAL1RGDVOdPCOv-frz6UkD9DKp_DW10MmWyWQA7CnyDeGqSQ6=Q@mail.gmail.com> <1345155175.25161.85.camel@haakon2.linux-iscsi.org> <502E21B5.9040400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <502E21B5.9040400@panasas.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@kernel.org>, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

We should switch this topic to the scsi mailing list

On 08/17/2012 01:49 PM, Boaz Harrosh wrote:

> On 08/17/2012 01:12 AM, Nicholas A. Bellinger wrote:
> 
>> On Thu, 2012-08-16 at 09:24 -0700, Roland Dreier wrote:
>>> Actually I'm not sure removing cmd_spdtl is the right answer.
>>>
>>> If /dev/sda is a device on an iSCSI initiator exported by an LIO
>>> target, try doing:
>>>
>>> # sg_raw -r512 /dev/sda 28 0 0 0 0 0 0 0 2 0
>>>
>>> This issues a READ (10) for 2 sectors, but only sends a length of 512
>>> at the transfer level.
>>>
>>> The target responds by setting the residual to 512 but transmits all
>>> 1024 bytes, 
> 
> 
> Is this the correct behavior from the Target? I would imagine that the
> target needs to only send 512 bytes (transfer level size) and set the
> OVERFLOW bit and residual to 512.
> 
> Not that it really matter because as you stated below the Initiator makes
> sure nothing bad happens.
> 
> BTW what target are we talking about, on the other side of the initiator
> here? (There are two targets in this setup right?)
> 
>>> and the Linux initiator at least rejects it because it
>>> hits:
>>>
>>> 	if (tcp_task->data_offset + tcp_conn->in.datalen > total_in_length) {
>>> 		ISCSI_DBG_TCP(conn, "data_offset(%d) + data_len(%d) > "
>>> 			      "total_length_in(%d)\n", tcp_task->data_offset,
>>> 			      tcp_conn->in.datalen, total_in_length);
>>> 		return ISCSI_ERR_DATA_OFFSET;
>>> 	}
>>>
>>
>> Ok, this is the 'overflow' case when the fabric ->data_length (expected
>> data transfer length of the initiator's buffer) is smaller than the SCSI
>> CDB allocation length or sectors*block_size (attempted transfer length)
>> the target has been asked to process.
>>
>> The following patch which appears to do the right thing from the
>> perspective of the target for overflow, but AFAICT open-iscsi still
>> returns GOOD status w/ no data-in payload (at least via sg_raw) when the
>> iscsi-target is signaling overflow bit in iSCSI Data IN PDU.  Not sure
>> yet why this is the case, but drivers/scsi/libiscsi.c:iscsi_data_in_rsp
>> code:
>>
>>        if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
>>                            ISCSI_FLAG_DATA_OVERFLOW)) {
>>                 int res_count = be32_to_cpu(rhdr->residual_count);
>>
>>                 if (res_count > 0 &&
>>                     (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
>>                      res_count <= scsi_in(sc)->length))
>>                         scsi_in(sc)->resid = res_count;
>>                 else
>>                         sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>>         }
>>
> 
> 
> OK I admit I kind of rearranged all this code a few years ago. Guilty ;-) 
> 
> Well now that I look at it again, I think it is totally wrong!!
> The scsi and block layer do not know anything about CMD_OVERFLOW
> If a scsi_in/out(sc)->resid is set it only ever means UNDERFLOW.
> 
> Both scsi and block expects to only do transfer_length - resid.
> This is why you get empty buffer back because the transfer_length=512
> minus resid=512 means zero bytes.
> 
> So the "|| ISCSI_FLAG_CMD_OVERFLOW" case is wrong.
> 
> Now the big question is what to do. Fail the all command, or say
> nothing?
> 
> The correct thing is to teach the middle layers about overflow,
> With some kind of warning level system.
> I was also thinking that we can make resid signed and signal
> an overflow with a negative resid. Now the math of
> transfer_length - resid will become correct since it means
> more, in the case above 512 - (-512) would be our 1024 CDB len.
> 
> For now this code must be fixed. And the command must fail.
> Do you need that I prepare a patch? (Please you do it, I'm
> swamped, it'll take me time)
> There are 3 more places like this.
> 
> BTW did you notice how in the code above we have mixed up the
> use of: ISCSI_FLAG_DATA_OVERFLOW and ISCSI_FLAG_CMD_OVERFLOW?
> That's another bug, here it should be ISCSI_FLAG_DATA_OVERFLOW
> only. The other places with the other flags.
> 
>> appears to be setting resid for non bidi cases correctly, right..? (mnc
>> + boaz CC'ed)
>>
>> How about the following to ensure we restrict overflow to keep the
>> existing (smaller) cmd->data_length assignment, and only re-assign this
>> value for the underflow case..?  (hch CC'ed)
>>
>> WDYT..?
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 0eaae23..63b3594 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1183,15 +1183,20 @@ int target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
>>                         /* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
>>                         goto out_invalid_cdb_field;
>>                 }
>> -
>> +               /*
>> +                * For the overflow case keep the existing fabric provided
>> +                * ->data_length.  Otherwise for the underflow case, reset
>> +                * ->data_length to the smaller SCSI expected data transfer
>> +                * length.
>> +                */
>>                 if (size > cmd->data_length) {
> 
> 
> I'm a bit out of context. Is this code exercised on the first target that is in
> pass-through over the initiator. Or this code is at the other target at the other
> side of the initiator? (The final real target)  
> 
> Because if it's at the pass-through target then this test might or might not
> be correct because we lost the overflow information by now. (Now if resid was
> negative that would be another thing)
> 
>>                         cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
>>                         cmd->residual_count = (size - cmd->data_length);
>>                 } else {
>>                         cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
>>                         cmd->residual_count = (cmd->data_length - size);
>> +                       cmd->data_length = size;
>>                 }
>> -               cmd->data_length = size;
>>         }
>>  
>>         return 0;
>>
> 
> 
> Thanks
> Boaz
