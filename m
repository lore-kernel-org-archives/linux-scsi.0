From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: scsi: ufs: add support for query requests
Date: Mon, 15 Apr 2013 03:14:30 -0700
Message-ID: <b06461081f5d78273616300bd8536cd5.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: draviv@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vinayak holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Santosh, thank you very much for your comments. Most where adopted, others
where replied inline.

Please note the comment on removing ufs_coe.c file. I will appreciated
your opinion on that.

> linux-ufs@vger.kernel.org is for UFS filesystem.
>
>> The API for submitting a query request is ufs_query_request() in
ufs_core.c. This function is responsible for:
>
> This can be part of ufshcd.c which is actually the core file, no need to
create a new core file for the function.

You are right and I moved it for now. But, I think that a good design that
will allow easy extension and feature development, will be to separate the
hci and features from the rest.
>
>> +
>> +#define UFS_QUERY_RESERVED_SCSI_CMD_SIZE 10
>> +
>
> Move this to ufs.h, The name seems too big, it can be changed to
UFS_QUERY_CMD_SIZE.
>
>> + if (!hba || !query || !response) {
>> +               pr_err("%s: NULL pointer hba = %p, query = %p response
= %p",
>> +                                   __func__, hba, query, response); +
return -EINVAL;
>> + }
>
> The function will be called withing the driver, So, no need for these
checks. The caller will/must pass the correct parameters.
I disagree. Why not play it safe?

Anyone can make this function accessible for IOCTLs or EXPORT it in
future. In case they forget (most do), let's not leave holes.
>
>> + /*
>> + * A SCSI command structure is composed from opcode at the
>> + * begining and 0 at the end.
>> + */
>> + memset(cmd, 0, UFS_QUERY_RESERVED_SCSI_CMD_SIZE);
>> + cmd[0] = UFS_QUERY_RESERVED_SCSI_CMD;
>
> Remove memset. Anyway only the first byte is being checked in
> ufshcd_is_query_req();
>
>> + * ufshcd_is_valid_query_rsp - checks if controller TR response is valid
>> + * @ucd_rsp_ptr: pointer to response UPIU
>> + *
>> + * This function checks the response UPIU for valid transaction type
in + * response field
>> + * Returns 0 on success, non-zero on failure
>> + */
>> +static inline int
>> +ufshcd_is_valid_query_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
>
> Combine this with ufshcd_is_valid_req_rsp(), accordingly handle it in
ufshcd_transfer_rsp_status().
>
>> +static inline void ufshcd_copy_query_response(struct ufs_hba *hba, +
struct ufshcd_lrb *lrbp)
>> +{
>> + struct ufs_query_res *query_res = hba->query.response;
>> + u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr + GENERAL_UPIU_REQUEST_SIZE;
>
> This can be done inside the following if condition i.e. if
> (hba->query.descriptor != NULL).
> and change the condition to if (!hba->query.descriptor).
>
>> + /* Get the descriptor */
>> + if (hba->query.descriptor != NULL && lrbp->ucd_rsp_ptr->qr.opcode ==
+ UPIU_QUERY_OPCODE_READ_DESC) {
>
>
>> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb
*lrbp)
>> +{
>> + struct utp_upiu_req *ucd_req_ptr;
>
> Remove ucd_req_ptr, it is not doing anything.
>
>> + if (!lrbp || !lrbp->cmd || !lrbp->ucd_req_ptr ||
>> +                                     !lrbp->utr_descriptor_ptr) { +   
        if (!lrbp)
>> +                      pr_err("%s: lrbp can not be NULL", __func__); + 
             if (!lrbp->cmd)
>> +                      pr_err("%s: lrbp->cmd can not be NULL",
>> __func__);
>> +                if (!lrbp->ucd_req_ptr)
>> +                      pr_err("%s: ucd_req_ptr can not be NULL",
__func__);
>> +                 if (!lrbp->utr_descriptor_ptr)
>> +                      pr_err("%s: utr_descriptor_ptr can not be NULL",
+                                     __func__);
>> +                  ret = -EINVAL;
>> +                  goto exit;
>> + }

I rather play it safe and not remove it.
I rewrote it to make it cleaner.
>
> These are redundant, remove them.
>
>> + if (ufshcd_is_query_req(lrbp))
>> + lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
>> + else
>> + lrbp->command_type = UTP_CMD_TYPE_SCSI;
>
>>  /* form UPIU before issuing the command */
>> - ufshcd_compose_upiu(lrbp);
>> + ufshcd_compose_upiu(hba, lrbp);
>> err = ufshcd_map_sg(lrbp);
>>  if (err)
>>         goto out;
>
> Why call ufshcd_map_sg() and scsi_dma_unmap() in
> ufshcd_transfer_req_compl() for requests of type
> UTP_CMD_TYPE_DEV_MANAGE?

We are doing this since there is no harm calling it when the buffer is
null, as well as this flow is responsible for setting the length parameter
in the transfer request descriptor.
Bottom line there is no need to split the original flow.
>
>> ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>
>> + if (ufshcd_is_query_req(lrbp))
>> + result = ufshcd_is_valid_query_rsp(lrbp->ucd_rsp_ptr);
>> + else
>> + result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
>> +
>
> As already mentioned you can combine these.
>
>> +/* Query response result code */
>> +enum {
>> + QUERY_RESULT_SUCCESS = 0x00,
>> + QUERY_RESULT_NOT_READABLE = 0xF6,
>> + QUERY_RESULT_NOT_WRITEABLE = 0xF7,
>> + QUERY_RESULT_ALREADY_WRITTEN = 0xF8,
>> + QUERY_RESULT_INVALID_LENGTH = 0xF9,
>> + QUERY_RESULT_INVALID_VALUE = 0xFA,
>> + QUERY_RESULT_INVALID_SELECTOR = 0xFB,
>> + QUERY_RESULT_INVALID_INDEX = 0xFC,
>> + QUERY_RESULT_INVALID_IDN = 0xFD,
>> + QUERY_RESULT_INVALID_OPCODE = 0xFE,
>> + QUERY_RESULT_GENERAL_FAILURE = 0xFF,
>> +};
>
> Move this to ufs.h.
>
>
> --
> ~Santosh
>

-- 
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
