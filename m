From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 04/18] qla2xxx: Proper cleanup of pass through commands
 when firmware returns error.
Date: Fri, 16 Dec 2011 10:32:39 -0500
Message-ID: <alpine.WNT.2.00.1112161030380.3796@N5102REMCQXM4BS.qlogic.org>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>  <1321635802-16491-5-git-send-email-chad.dupuis@qlogic.com> <1323863717.3063.52.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7466
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab1LPPcr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 10:32:47 -0500
In-Reply-To: <1323863717.3063.52.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Wed, 14 Dec 2011, James Bottomley wrote:

> On Fri, 2011-11-18 at 09:03 -0800, Chad Dupuis wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_isr.c |   73 ++++++++++++++++++++++++++++-----------
>>  drivers/scsi/qla2xxx/qla_os.c  |   19 +++++-----
>>  2 files changed, 61 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>> index b6023e9..c5d6cd1 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -1895,6 +1895,45 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
>>      }
>>  }
>>
>> +static int
>> +qla2x00_free_sp_ctx(scsi_qla_host_t *vha, srb_t *sp)
>> +{
>> +    struct qla_hw_data *ha = vha->hw;
>> +    struct srb_ctx *ctx;
>> +
>> +    if (!sp->ctx)
>> +            return 1;
>> +
>> +    ctx = sp->ctx;
>> +
>> +    if (ctx->type == SRB_LOGIN_CMD ||
>> +        ctx->type == SRB_LOGOUT_CMD ||
>> +        ctx->type == SRB_TM_CMD) {
>> +            ((struct srb_iocb*)ctx->u.iocb_cmd)->done(sp);
>
> This cast is completely pointless: u.iocb_cmd is already a struct
> sr_iocb * (and yes, you do need the space).

Yes, this makes sense. Thanks.

>
>> +            return 0;
>> +    } else if (ctx->type == SRB_ADISC_CMD) {
>> +            ((struct srb_iocb*)ctx->u.iocb_cmd)->free(sp);
>
> And here.
>
>> +            return 0;
>> +    } else {
>> +            struct fc_bsg_job *bsg_job;
>> +
>> +            bsg_job = ctx->u.bsg_job;
>> +            if (ctx->type == SRB_ELS_CMD_HST ||
>> +                ctx->type == SRB_CT_CMD)
>> +                    kfree(sp->fcport);
>> +
>> +            bsg_job->reply->reply_data.ctels_reply.status =
>> +                FC_CTELS_STATUS_OK;
>> +            bsg_job->reply->result = DID_ERROR << 16;
>> +            bsg_job->reply->reply_payload_rcv_len = 0;
>> +            kfree(sp->ctx);
>> +            mempool_free(sp, ha->srb_mempool);
>> +            bsg_job->job_done(bsg_job);
>> +            return 0;
>> +    }
>> +    return 1;
>> +}
>> +
>>  /**
>>   * qla2x00_error_entry() - Process an error entry.
>>   * @ha: SCSI driver HA context
>> @@ -1905,7 +1944,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
>>  {
>>      srb_t *sp;
>>      struct qla_hw_data *ha = vha->hw;
>> -    uint32_t handle = LSW(pkt->handle);
>> +    const char func[] = "ERROR-IOCB";
>>      uint16_t que = MSW(pkt->handle);
>>      struct req_que *req = ha->req_q_map[que];
>>
>> @@ -1928,28 +1967,20 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
>>              ql_dbg(ql_dbg_async, vha, 0x502f,
>>                  "UNKNOWN flag error.\n");
>>
>> -    /* Validate handle. */
>> -    if (handle < MAX_OUTSTANDING_COMMANDS)
>> -            sp = req->outstanding_cmds[handle];
>> -    else
>> -            sp = NULL;
>> -
>> +    sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
>>      if (sp) {
>> -            /* Free outstanding command slot. */
>> -            req->outstanding_cmds[handle] = NULL;
>> -
>> -            /* Bad payload or header */
>> -            if (pkt->entry_status &
>> -                (RF_INV_E_ORDER | RF_INV_E_COUNT |
>> -                 RF_INV_E_PARAM | RF_INV_E_TYPE)) {
>> -                    sp->cmd->result = DID_ERROR << 16;
>> -            } else if (pkt->entry_status & RF_BUSY) {
>> -                    sp->cmd->result = DID_BUS_BUSY << 16;
>> -            } else {
>> -                    sp->cmd->result = DID_ERROR << 16;
>> +            if (qla2x00_free_sp_ctx (vha, sp)) {
>
> And there's an extra space here (checkpatch warns about this, so I
> assume you didn't run it).
>
> James
>
>
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

