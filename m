From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V2] scsi: ufs: Add fDeviceInit set flag during initialization
Date: Wed, 8 May 2013 20:58:43 +0530
Message-ID: <CALMYJDsYSfDjZ6pug3cZ+wkFaL0VcZnNMk11DFAW7Ay56PjbdA@mail.gmail.com>
References: <1368022782-27178-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368022782-27178-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> + */
> +int ufshcd_query_request(struct ufs_hba *hba,
> +                       struct ufs_query_req *query,
> +                       u8 *descriptor,
> +                       struct ufs_query_res *response,
> +                       int timeout,
> +                       int retries)
> +{
> +       struct scsi_device *sdev;
> +       u8 cmd[UFS_QUERY_CMD_SIZE] = {0};
> +       int result;
> +       bool sdev_lookup = true;
> +
> +       if (!hba || !query || !response) {
> +               dev_err(hba->dev,

Please fix the static checker warnings mentioned by Dan in the previous mail.
Re-base it on Seungwon's V4 patch series and you can add my Acked-by:
Santosh Y <santoshsy@gmail.com>

> +                       "%s: NULL pointer hba = %p, query = %p response = %p\n",
> +                       __func__, hba, query, response);
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * A SCSI command structure is composed from opcode at the
> +        * begining and 0 at the end.
> +        */
> +       cmd[0] = UFS_QUERY_RESERVED_SCSI_CMD;
> +
> +       /* extracting the SCSI Device */
> +       sdev = scsi_device_lookup(hba->host, 0, 0, 0);
> +       if (!sdev) {
> +               /**
> +                * There are some Query Requests that are sent during device
> +                * initialization, this happens before the scsi device was
> +                * initialized. If there is no scsi device, we generate a
> +                * temporary device to allow the Query Request flow.
> +                */
> +               sdev_lookup = false;
> +               sdev = scsi_get_host_dev(hba->host);
> +       }
> +
> +       if (!sdev) {
> +               dev_err(hba->dev, "%s: Could not fetch scsi device\n",
> +                       __func__);
> +               return -ENODEV;
> +       }
> +
> +       mutex_lock(&hba->query.lock_ufs_query);
> +       hba->query.request = query;
> +       hba->query.descriptor = descriptor;
> +       hba->query.response = response;
> +
> +       /* wait until request is completed */
> +       result = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL,
> +                               timeout, retries, 0, NULL);
> +       if (result) {
> +               dev_err(hba->dev,
> +                       "%s: Query with opcode 0x%x, failed with result %d\n",
> +                       __func__, query->upiu_req.opcode, result);
> +               result = -EIO;
> +       }
> +
> +       hba->query.request = NULL;
> +       hba->query.descriptor = NULL;
> +       hba->query.response = NULL;
> +       mutex_unlock(&hba->query.lock_ufs_query);
> +
> +       /* Releasing scsi device resource */
> +       if (sdev_lookup)
> +               scsi_device_put(sdev);
> +       else
> +               scsi_free_host_dev(sdev);
> +
> +       return result;
> +}
> +
> +/**
> + * ufshcd_query_flag() - Helper function for composing flag query requests
> + * hba: per-adapter instance
> + * query_opcode: flag query to perform
> + * idn: flag idn to access
> + * flag_res: the flag value after the query request completes
> + *
> + * Returns 0 for success, non-zero in case of failure
> + */
> +int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> +                       enum flag_idn idn, bool *flag_res)
> +{
> +       struct ufs_query_req query = {0};
> +       struct ufs_query_res response = {0};
> +       int err;
> +
> +       switch (opcode) {
> +       case UPIU_QUERY_OPCODE_SET_FLAG:
> +       case UPIU_QUERY_OPCODE_CLEAR_FLAG:
> +       case UPIU_QUERY_OPCODE_TOGGLE_FLAG:
> +               query.query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
> +               break;
> +       case UPIU_QUERY_OPCODE_READ_FLAG:
> +               query.query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
> +               break;
> +       default:
> +               dev_err(hba->dev,
> +                       "%s: Expected query flag opcode but got = %d\n",
> +                       __func__, opcode);
> +               err = -EINVAL;
> +               goto out;
> +       }
> +       query.upiu_req.opcode = opcode;
> +       query.upiu_req.idn = idn;
> +
> +       /* Send query request */
> +       err = send_query_request(hba, &query, NULL, &response);
> +
> +       if (err) {
> +               dev_err(hba->dev,
> +                       "%s: Sending flag query for idn %d failed, err = %d\n",
> +                       __func__, idn, err);
> +               goto out;
> +       }
> +
> +       *flag_res = (response.upiu_res.value & MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
> +
> +out:
> +       return err;
> +}
> +
> +/**
>   * ufshcd_memory_alloc - allocate memory for host memory space data structures
>   * @hba: per adapter instance
>   *
> @@ -1324,6 +1488,44 @@ out:
>  }
>
>  /**
> + * ufshcd_validate_device_init() - checks device readines
> + * hba: per-adapter instance
> + *
> + * Set fDeviceInit flag, than, query the flag untill the device clears the
> + * flag.
> + */
> +static int ufshcd_validate_device_init(struct ufs_hba *hba)
> +{
> +       int i, err;
> +       bool flag_res = 0;
> +
> +       err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +                               QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
> +       if (err) {
> +               dev_err(hba->dev,
> +                       "%s setting fDeviceInit flag failed with error %d\n",
> +                       __func__, err);
> +               goto out;
> +       }
> +
> +       for (i = 0; i < QUERY_REQ_RETRIES && !err && flag_res; i++) {
> +               err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +                               QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
> +       }
> +       if (err)
> +               dev_err(hba->dev,
> +                       "%s reading fDeviceInit flag failed with error %d\n",
> +                       __func__, err);
> +       else if (flag_res)
> +               dev_err(hba->dev,
> +                       "%s fDeviceInit was not cleared by the device\n",
> +                       __func__);
> +
> +out:
> +       return err;
> +}
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -2153,6 +2355,10 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>         if (ret)
>                 goto out;
>
> +       ret = ufshcd_validate_device_init(hba);
> +       if (ret)
> +               goto out;
> +
>         scsi_scan_host(hba->host);
>  out:
>         return;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index a91c558..76485da 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -286,4 +286,11 @@ static inline int ufshcd_dme_hibern8_exit(struct ufs_hba *hba)
>         return ufshcd_dme_hibern8_ctrl(hba, 0);
>  }
>
> +int ufs_query_request(struct ufs_hba *hba,
> +                       struct ufs_query_req *query,
> +                       u8 *descriptor,
> +                       struct ufs_query_res *response,
> +                       int timeout,
> +                       int retries);
> +
>  #endif /* End of Header */
> --
> 1.7.6
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
~Santosh
