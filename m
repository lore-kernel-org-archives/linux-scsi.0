From: Santosh Y <santoshsy@gmail.com>
Subject: Re: scsi: ufs: add support for query requests
Date: Wed, 10 Apr 2013 18:53:41 +0900
Message-ID: <CALMYJDs1Ds34Sm0FTuiG8WE=w_foOxkTqdy5hZAkFkGsUapRWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: draviv@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vinayak holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

linux-ufs@vger.kernel.org is for UFS filesystem.

> The API for submitting a query request is ufs_query_request() in
> ufs_core.c. This function is responsible for:

This can be part of ufshcd.c which is actually the core file, no need
to create a new core file for the function.

> +
> +#define UFS_QUERY_RESERVED_SCSI_CMD_SIZE 10
> +

Move this to ufs.h, The name seems too big, it can be changed to
UFS_QUERY_CMD_SIZE.

> + if (!hba || !query || !response) {
> +               pr_err("%s: NULL pointer hba = %p, query = %p response = %p",
> +                                   __func__, hba, query, response);
> + return -EINVAL;
> + }

The function will be called withing the driver, So, no need for these
checks. The caller will/must pass the correct parameters.

> + /*
> + * A SCSI command structure is composed from opcode at the
> + * begining and 0 at the end.
> + */
> + memset(cmd, 0, UFS_QUERY_RESERVED_SCSI_CMD_SIZE);
> + cmd[0] = UFS_QUERY_RESERVED_SCSI_CMD;

Remove memset. Anyway only the first byte is being checked in
ufshcd_is_query_req();

> + * ufshcd_is_valid_query_rsp - checks if controller TR response is valid
> + * @ucd_rsp_ptr: pointer to response UPIU
> + *
> + * This function checks the response UPIU for valid transaction type in
> + * response field
> + * Returns 0 on success, non-zero on failure
> + */
> +static inline int
> +ufshcd_is_valid_query_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)

Combine this with ufshcd_is_valid_req_rsp(), accordingly handle it in
ufshcd_transfer_rsp_status().

> +static inline void ufshcd_copy_query_response(struct ufs_hba *hba,
> + struct ufshcd_lrb *lrbp)
> +{
> + struct ufs_query_res *query_res = hba->query.response;
> + u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr + GENERAL_UPIU_REQUEST_SIZE;

This can be done inside the following if condition i.e. if
(hba->query.descriptor != NULL).
and change the condition to if (!hba->query.descriptor).

> + /* Get the descriptor */
> + if (hba->query.descriptor != NULL && lrbp->ucd_rsp_ptr->qr.opcode ==
> + UPIU_QUERY_OPCODE_READ_DESC) {


> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> + struct utp_upiu_req *ucd_req_ptr;

Remove ucd_req_ptr, it is not doing anything.

> + if (!lrbp || !lrbp->cmd || !lrbp->ucd_req_ptr ||
> +                                     !lrbp->utr_descriptor_ptr) {
> +            if (!lrbp)
> +                      pr_err("%s: lrbp can not be NULL", __func__);
> +               if (!lrbp->cmd)
> +                      pr_err("%s: lrbp->cmd can not be NULL", __func__);
> +                if (!lrbp->ucd_req_ptr)
> +                      pr_err("%s: ucd_req_ptr can not be NULL", __func__);
> +                 if (!lrbp->utr_descriptor_ptr)
> +                      pr_err("%s: utr_descriptor_ptr can not be NULL",
> +                                     __func__);
> +                  ret = -EINVAL;
> +                  goto exit;
> + }

These are redundant, remove them.

> + if (ufshcd_is_query_req(lrbp))
> + lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
> + else
> + lrbp->command_type = UTP_CMD_TYPE_SCSI;

>  /* form UPIU before issuing the command */
> - ufshcd_compose_upiu(lrbp);
> + ufshcd_compose_upiu(hba, lrbp);
> err = ufshcd_map_sg(lrbp);
>  if (err)
>         goto out;

Why call ufshcd_map_sg() and scsi_dma_unmap() in
ufshcd_transfer_req_compl() for requests of type
UTP_CMD_TYPE_DEV_MANAGE?

> ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)

> + if (ufshcd_is_query_req(lrbp))
> + result = ufshcd_is_valid_query_rsp(lrbp->ucd_rsp_ptr);
> + else
> + result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> +

As already mentioned you can combine these.

> +/* Query response result code */
> +enum {
> + QUERY_RESULT_SUCCESS = 0x00,
> + QUERY_RESULT_NOT_READABLE = 0xF6,
> + QUERY_RESULT_NOT_WRITEABLE = 0xF7,
> + QUERY_RESULT_ALREADY_WRITTEN = 0xF8,
> + QUERY_RESULT_INVALID_LENGTH = 0xF9,
> + QUERY_RESULT_INVALID_VALUE = 0xFA,
> + QUERY_RESULT_INVALID_SELECTOR = 0xFB,
> + QUERY_RESULT_INVALID_INDEX = 0xFC,
> + QUERY_RESULT_INVALID_IDN = 0xFD,
> + QUERY_RESULT_INVALID_OPCODE = 0xFE,
> + QUERY_RESULT_GENERAL_FAILURE = 0xFF,
> +};

Move this to ufs.h.


--
~Santosh
