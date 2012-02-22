From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: RE: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand
 handler
Date: Wed, 22 Feb 2012 13:49:06 -0500
Message-ID: <alpine.WNT.2.00.1202221346030.6020@N5102REMCQXM4BS.qlogic.org>
References: <1329230866-905-1-git-send-email-loke.chetan@gmail.com> <D3F292ADF945FB49B35E96C94C2061B915FD62A2@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36339 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BVStP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 13:49:15 -0500
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915FD62A2@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "lokechetan@gmail.com" <lokechetan@gmail.com>



On Wed, 22 Feb 2012, Loke, Chetan wrote:

>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Chetan Loke
>> Sent: February 14, 2012 9:48 AM
>> To: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
>> andrew.vasquez@qlogic.com
>> Cc: linux-driver@qlogic.com; loke.chetan@gmail.com
>> Subject: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand
>> handler
>>
>> Optimized queuecommand handler's to eliminate double head-room checks.
>> The checks are moved inside the 1st if-loop otherwise you would end up
>> checking twice when there is enough head room.
>>
>> Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
>> ---
>
> Ping...
>

Hi Chetan,

We have picked this up and it will be part of our next submission.  Since
this affects the I/O path we wanted to have this patch go through one of
our full test cycles.

Thanks,
Chad

>
>
>
>
>>  drivers/scsi/qla2xxx/qla_iocb.c |   19 +++++++++----------
>>  1 files changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
>> b/drivers/scsi/qla2xxx/qla_iocb.c
>> index 55a9676..825a046 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -383,9 +383,10 @@ qla2x00_start_scsi(srb_t *sp)
>>              else
>>                      req->cnt = req->length -
>>                          (req->ring_index - cnt);
>> +            /* If still no head room then bail out */
>> +            if (req->cnt < (req_cnt + 2))
>> +                    goto queuing_error;
>>      }
>> -    if (req->cnt < (req_cnt + 2))
>> -            goto queuing_error;
>>
>>      /* Build command packet */
>>      req->current_outstanding_cmd = handle;
>> @@ -1502,9 +1503,9 @@ qla24xx_start_scsi(srb_t *sp)
>>              else
>>                      req->cnt = req->length -
>>                              (req->ring_index - cnt);
>> +            if (req->cnt < (req_cnt + 2))
>> +                    goto queuing_error;
>>      }
>> -    if (req->cnt < (req_cnt + 2))
>> -            goto queuing_error;
>>
>>      /* Build command packet. */
>>      req->current_outstanding_cmd = handle;
>> @@ -1717,11 +1718,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
>>              else
>>                      req->cnt = req->length -
>>                              (req->ring_index - cnt);
>> +            if (req->cnt < (req_cnt + 2))
>> +                    goto queuing_error;
>>      }
>>
>> -    if (req->cnt < (req_cnt + 2))
>> -            goto queuing_error;
>> -
>>      status |= QDSS_GOT_Q_SPACE;
>>
>>      /* Build header part of command packet (excluding the OPCODE).
> */
>> @@ -2349,11 +2349,10 @@ sufficient_dsds:
>>                      else
>>                              req->cnt = req->length -
>>                                      (req->ring_index - cnt);
>> +                    if (req->cnt < (req_cnt + 2))
>> +                            goto queuing_error;
>>              }
>>
>> -            if (req->cnt < (req_cnt + 2))
>> -                    goto queuing_error;
>> -
>>              ctx = sp->ctx = mempool_alloc(ha->ctx_mempool,
> GFP_ATOMIC);
>>              if (!sp->ctx) {
>>                      ql_log(ql_log_fatal, vha, 0x3010,
>> --
>> 1.7.5.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

