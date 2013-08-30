From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH] scsi: ufs: read door bell register after clearing interrupt aggregation
Date: Sat, 31 Aug 2013 00:25:47 +0300
Message-ID: <000001cea5c7$81945520$84bcff60$@codeaurora.org>
References: <1377427016-28469-1-git-send-email-draviv@codeaurora.org> <521C6155.9080207@codeaurora.org> <521C6A5C.4050202@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38024 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3H3VZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Aug 2013 17:25:54 -0400
In-Reply-To: <521C6A5C.4050202@codeaurora.org>
Content-language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Subhash Jadavani
Sent: Tuesday, August 27, 2013 11:59 AM
To: Dolev Raviv
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; open list
Subject: Re: [PATCH] scsi: ufs: read door bell register after clearing
interrupt aggregation

On 8/27/2013 1:50 PM, Subhash Jadavani wrote:
>
>
> Looks good to me.
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>
> On 8/25/2013 4:06 PM, Dolev Raviv wrote:
>> In interrupt context, after reading and comparing the UTRLDBR to
>> hba->outstanding_request and before resetting the interrupt 
>> hba->aggregation,
>> there might be completion of another transfer request (TR). Such TRs 
>> might get stuck, pending, until the next interrupt is generated.
>>
>> The fix reads the UTRLDBR after resetting the interrupt aggregation 
>> and handles completed TRs.
>>
>> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index 4dca9b4..30c84d8 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1915,6 +1915,13 @@ static void ufshcd_uic_cmd_compl(struct 
>> ufs_hba *hba)
>>   /**
>>    * ufshcd_transfer_req_compl - handle SCSI and query command 
>> completion
>>    * @hba: per adapter instance
>> + *
>> + * Resetting interrupt aggregation counters first and reading the
>> DOOR_BELL
>> + * afterward , allows us to handle all the completed requests.
>> + * In order to prevent other interrupts starvation the DB is read 
>> + once
>> + * after reset. The down side of this solution is the possibility of
>> false
>> + * interrupt if device completes another request after resetting
>> aggregation
>> + * and before reading the DB.
>>    */
>>   static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>>   {
>> @@ -1924,47 +1931,36 @@ static void ufshcd_transfer_req_compl(struct 
>> ufs_hba *hba)
>>       u32 tr_doorbell;
>>       int result;
>>       int index;
>> -    bool int_aggr_reset = false;
>> +
>> +    /* Reset interrupt aggregation counters */
>> +    ufshcd_config_int_aggr(hba, INT_AGGR_RESET);

You may have to rebase your change on top of "[PATCH v3 2/6] scsi: ufs: 
fix the setting interrupt aggregation counter" patch. Once you do that, you
will be calling ufshcd_reset_intr_aggr() (instead of
ufshscd_config_int_aggr()) to reset the interrupt aggregation counters.

>>         tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>       completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
>>   -    for (index = 0; index < hba->nutrs; index++) {
>> -        if (test_bit(index, &completed_reqs)) {
>> -            lrbp = &hba->lrb[index];
>> -            cmd = lrbp->cmd;
>> -            /*
>> -             * Don't skip resetting interrupt aggregation counters
>> -             * if a regular command is present.
>> -             */
>> -            int_aggr_reset |= !lrbp->intr_cmd;
>> -
>> -            if (cmd) {
>> -                result = ufshcd_transfer_rsp_status(hba, lrbp);
>> -                scsi_dma_unmap(cmd);
>> -                cmd->result = result;
>> -                /* Mark completed command as NULL in LRB */
>> -                lrbp->cmd = NULL;
>> -                clear_bit_unlock(index, &hba->lrb_in_use);
>> -                /* Do not touch lrbp after scsi done */
>> -                cmd->scsi_done(cmd);
>> -            } else if (lrbp->command_type ==
>> -                    UTP_CMD_TYPE_DEV_MANAGE) {
>> -                if (hba->dev_cmd.complete)
>> -                    complete(hba->dev_cmd.complete);
>> -            }
>> -        } /* end of if */
>> -    } /* end of for */
>> +    for_each_set_bit(index, &completed_reqs, hba->nutrs) {
>> +        lrbp = &hba->lrb[index];
>> +        cmd = lrbp->cmd;
>> +        if (cmd) {
>> +            result = ufshcd_transfer_rsp_status(hba, lrbp);
>> +            scsi_dma_unmap(cmd);
>> +            cmd->result = result;
>> +            /* Mark completed command as NULL in LRB */
>> +            lrbp->cmd = NULL;
>> +            clear_bit_unlock(index, &hba->lrb_in_use);
>> +            /* Do not touch lrbp after scsi done */
>> +            cmd->scsi_done(cmd);
>> +        } else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
>> +            if (hba->dev_cmd.complete)
>> +                complete(hba->dev_cmd.complete);
>> +        }
>> +    } /* end of for_each_set_bit */
>>         /* clear corresponding bits of completed commands */
>>       hba->outstanding_reqs ^= completed_reqs;
>>         /* we might have free'd some tags above */
>>       wake_up(&hba->dev_cmd.tag_wq);
>> -
>> -    /* Reset interrupt aggregation counters */
>> -    if (int_aggr_reset)
>> -        ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
>>   }
>>     /**
>> @@ -2569,6 +2565,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>       int poll_cnt;
>>       u8 resp = 0xF;
>>       struct ufshcd_lrb *lrbp;
>> +    u32 reg;
>>         host = cmd->device->host;
>>       hba = shost_priv(host);
>> @@ -2578,6 +2575,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>       if (!(test_bit(tag, &hba->outstanding_reqs)))
>>           goto out;
>>   +    reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> +    if (!(reg & (1 << tag))) {
>> +        dev_err(hba->dev,
>> +        "%s: cmd was completed, but without a notifying intr, tag =
>> %d",
>> +        __func__, tag);
>> +    }
>> +
>>       lrbp = &hba->lrb[tag];
>>       for (poll_cnt = 100; poll_cnt; poll_cnt--) {
>>           err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag, 
>> @@ -2586,8 +2590,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>               /* cmd pending in the device */
>>               break;
>>           } else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
>> -            u32 reg;
>> -
>>               /*
>>                * cmd not pending in the device, check if it is
>>                * in transition.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

