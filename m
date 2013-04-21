From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V2] scsi: ufs: add support for query requests
Date: Sun, 21 Apr 2013 21:44:34 +0900
Message-ID: <CALMYJDuUprWnGSk2jQi=sFLa82PDPoTmg5-tqwwvaYwSFm_yLQ@mail.gmail.com>
References: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, vinayak holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> + * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
> + * @hba - UFS hba
> + * @lrb - pointer to local reference block
> + */
> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
> +{
> +       u32 upiu_flags;
> +       int ret = 0;
> +
> +       if (!lrbp) {
> +               dev_err(hba->dev, "%s: lrbp can not be NULL\n", __func__);
> +               ret = -EINVAL;
> +       } else if (!lrbp->ucd_req_ptr) {
> +               dev_err(hba->dev, "%s: ucd_req_ptr can not be NULL\n",
> +                       __func__);
> +               ret = -EINVAL;
> +       } else if (!lrbp->utr_descriptor_ptr) {
> +               dev_err(hba->dev, "%s: utr_descriptor_ptr can not be
> NULL\n",
> +                       __func__);
> +               ret = -EINVAL;
> +       }
> +       if (!ret)
> +               goto exit;
> +

ufshcd_compose_upiu() is not being called from anywhere else other
than ufshcd_queuecommand(), *lrbp* is being used before calling
ufshcd_compose_upiu(). So, if lrbp is NULL, it will give a problem in
ufshcd_queuecommand() itself and lrbp->ucd_req_ptr,
lrbp->utr_descriptor_ptr are being configured in
ufshcd_memory_config(). Also if lrbp can be NULL then why not hba? So,
the right thing would be to remove these checks.

>         switch (ocs) {
>         case OCS_SUCCESS:
> -
>                 /* check if the returned transfer response is valid */
> -               result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> +               expected_rsp_code = ufshcd_is_query_req(lrbp) ?
> +                       UPIU_TRANSACTION_QUERY_RSP :
> UPIU_TRANSACTION_RESPONSE;
> +               result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr,
> +
> expected_rsp_code);
> +
>                 if (result) {
>                         dev_err(hba->dev,
>                                 "Invalid response = %x\n", result);
>                         break;
>                 }
>
> -               /*
> -                * get the response UPIU result to extract
> -                * the SCSI command status
> -                */
> -               result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
> +               if (ufshcd_is_query_req(lrbp)) {
> +                       /*
> +                        *  Return result = ok, since SCSI layer wouldn't
> +                        *  know how to handle errors from query requests.
> +                        *  The result is saved with the response so that
> +                        *  the ufs_core layer will handle it.
> +                        */
> +                       result |= DID_OK << 16;
> +                       ufshcd_copy_query_response(hba, lrbp);
> +               } else {
> +                       /*
> +                        * get the response UPIU result to extract
> +                        * the SCSI command status
> +                        */
> +                       result =
> ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
>
> -               /*
> -                * get the result based on SCSI status response
> -                * to notify the SCSI midlayer of the command status
> -                */
> -               scsi_status = result & MASK_SCSI_STATUS;
> -               result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
> +                       /*
> +                        * get the result based on SCSI status response
> +                        * to notify the SCSI midlayer of the command
> status
> +                        */
> +                       scsi_status = result & MASK_SCSI_STATUS;
> +                       result = ufshcd_scsi_cmd_status(lrbp,
> scsi_status);
> +               }
>                 break;


The following would be better,

 static int
  ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
  {
         return (be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24);
   }


switch (ocs) {
         case OCS_SUCCESS:

                 /* check if the returned transfer response is valid */
               result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);

               switch (result) {
                 case UPIU_TRANSACTION_RESPONSE:
                              /* perform required steps */
                 break;
                 case UPIU_TRANSACTION_QUERY_RSP:
                          /* perform required steps */
                 break;
                 case /* reject upiu */:
                       you can add a check for Reject UPIU also if you want.
                        /* return error */
                 break;
                 default:
                             /* return error */
                }
                  ...
}

--
~Santosh
