From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Mon, 29 Jul 2013 16:21:40 +0530
Message-ID: <51F6493C.3020105@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <1374280885-11526-2-git-send-email-mita@fixstars.com> <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com> <51F608F4.9020107@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38404 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3G2Kvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 06:51:45 -0400
In-Reply-To: <51F608F4.9020107@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On 7/29/2013 11:47 AM, Subhash Jadavani wrote:
> On 7/26/2013 7:15 PM, Seungwon Jeon wrote:
>> Fatal error in OCS(overall command status) field indicates
>> error conditions which is not covered by UFSHCI.
>> It means that host cannot define the result of command status
>> and therefore host may need to check transfer response UPIU's
>> response and status field.
>> It was actually found that 'CHECK CONDITION' is stored in status
>> field of UPIU where OCS is 'FATAL ERROR'.

It looks like you are assuming that there will be some kind of response
from the device. But the spec. mentions - "OCS_FATAL ERROR: within host
controller that is not covered by the error conditions described above
in this table."

So spec. left everything to implementers on how to trigger this error.
Also, it says "within host controller" so ufshcd_is_valid_req_rsp()
might fail as well.

I couldn't understand why there is a need for a host controller to
interpret the SCSI command status and raise an OCS_FATAL_ERROR?

If it is clarified by the spec. then we can have generic implementation
otherwise I would prefer to make this specific to those host controllers
that raise OCS_FATAL_ERROR for CHECK_CONDITION.

>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c |    3 +--
>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b743bd6..4cf3a2d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>> struct ufshcd_lrb *lrbp)
>>       switch (ocs) {
>>       case OCS_SUCCESS:
>> -
>> +    case OCS_FATAL_ERROR:
>>           /* check if the returned transfer response is valid */
>>           result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
>
> I don't see the response UPIU data of the last command response is
> cleared anywhere in the driver. This means its quite possible that if
> the current command failed (and if it is using the same tag as the last
> succeeded command) with the OCS_FATAL_ERROR then response UPIU (pointed
> by lrbp->ucd_rsp_ptr) content may be still the same as the last one. If
> we ensure to clear the response UPIU data after every command completion
> then only we can rely on the response  UPIU content in case of fatal
> errors.
>
> Regards,
> Subhash
>>           if (result) {
>> @@ -1229,7 +1229,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>> struct ufshcd_lrb *lrbp)
>>       case OCS_MISMATCH_DATA_BUF_SIZE:
>>       case OCS_MISMATCH_RESP_UPIU_SIZE:
>>       case OCS_PEER_COMM_FAILURE:
>> -    case OCS_FATAL_ERROR:
>>       default:
>>           result |= DID_ERROR << 16;
>>           dev_err(hba->dev,
>


-- 
Regards,
Sujit
