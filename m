From: merez@codeaurora.org
Subject: Re: [PATCH 1/1] scsi: ufs: Set fDeviceInit flag to initiate device
 initialization
Date: Mon, 6 May 2013 11:17:13 -0700
Message-ID: <b6d448b6b3bb18d4e078a23f7c95c9e0.squirrel@www.codeaurora.org>
References: <1367838052-27116-1-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1367838052-27116-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org, jbottomley@parallels.com, Dolev Raviv <draviv@codeaurora.org>, linux-arm-msm@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Tested-by: Maya Erez <merez@codeaurora.org>

> From: Dolev Raviv <draviv@codeaurora.org>
>
> Allow UFS device to complete its initialization and accept SCSI
> commands by setting fDeviceInit flag. The device may take time
> for this operation and hence the host should poll until fDeviceInit
> flag is toggled to zero. This step is mandated by UFS device
> specification for device initialization completion.
>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h    |   10 ++++-
>  drivers/scsi/ufs/ufshcd.c |  102
> +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |    7 +++
>  3 files changed, 118 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 086ff03..742363d 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -107,8 +107,13 @@ enum {
>  	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST = 0x81,
>  };
>
> +/* Flag idn for Query Requests*/
> +enum flag_idn {
> +	QUERY_FLAG_IDN_FDEVICEINIT = 0x01,
> +};
> +
>  /* UTP QUERY Transaction Specific Fields OpCode */
> -enum {
> +enum query_opcode {
>  	UPIU_QUERY_OPCODE_NOP		= 0x0,
>  	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
>  	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
> @@ -208,6 +213,9 @@ struct utp_upiu_query {
>  	u32 reserved[2];
>  };
>
> +/* Expose the flag value from utp_upiu_query.value */
> +#define MASK_QUERY_UPIU_FLAG_LOC 0xFF
> +
>  /**
>   * struct utp_upiu_req - general upiu request structure
>   * @header:UPIU header structure DW-0 to DW-2
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4090f6c..21aa0b4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -52,6 +52,15 @@
>  /* Reserved tag for internal commands */
>  #define INTERNAL_CMD_TAG   0
>
> +/* Query request standard retries */
> +#define QUERY_REQ_RETRIES 10
> +/* Query request standart timeout in seconds */
> +#define QUERY_REQ_TIMEOUT 5
> +/* Send Query Requst with default parameters */
> +#define send_query_request(ARG1, ARG2, ARG3, ARG4)	\
> +	ufshcd_query_request(ARG1, ARG2, ARG3, ARG4,	\
> +			QUERY_REQ_TIMEOUT, QUERY_REQ_RETRIES)
> +
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> @@ -952,6 +961,57 @@ int ufshcd_query_request(struct ufs_hba *hba,
>  }
>
>  /**
> + * ufshcd_query_flag() - Helper function for composing flag query
> requests
> + * hba: per-adapter instance
> + * query_opcode: flag query to perform
> + * idn: flag idn to access
> + * flag_res: the flag value after the query request completes
> + *
> + * Returns 0 for success, non-zero in case of failure
> + */
> +int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> +			enum flag_idn idn, bool *flag_res)
> +{
> +	struct ufs_query_req query = {0};
> +	struct ufs_query_res response = {0};
> +	int err;
> +
> +	switch (opcode) {
> +	case UPIU_QUERY_OPCODE_SET_FLAG:
> +	case UPIU_QUERY_OPCODE_CLEAR_FLAG:
> +	case UPIU_QUERY_OPCODE_TOGGLE_FLAG:
> +		query.query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
> +		break;
> +	case UPIU_QUERY_OPCODE_READ_FLAG:
> +		query.query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
> +		break;
> +	default:
> +		dev_err(hba->dev,
> +			"%s: Expected query flag opcode but got = %d\n",
> +			__func__, opcode);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +	query.upiu_req.opcode = opcode;
> +	query.upiu_req.idn = idn;
> +
> +	/* Send query request */
> +	err = send_query_request(hba, &query, NULL, &response);
> +
> +	if (err) {
> +		dev_err(hba->dev,
> +			"%s: Sending flag query for idn %d failed, err = %d\n",
> +			__func__, idn, err);
> +		goto out;
> +	}
> +
> +	*flag_res = (response.upiu_res.value & MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
> +
> +out:
> +	return err;
> +}
> +
> +/**
>   * ufshcd_memory_alloc - allocate memory for host memory space data
> structures
>   * @hba: per adapter instance
>   *
> @@ -1384,6 +1444,44 @@ out:
>  }
>
>  /**
> + * ufshcd_validate_device_init() - checks device readines
> + * hba: per-adapter instance
> + *
> + * Set fDeviceInit flag, than, query the flag untill the device clears
> the
> + * flag.
> + */
> +static int ufshcd_validate_device_init(struct ufs_hba *hba)
> +{
> +	int i, err;
> +	bool flag_res = 0;
> +
> +	err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +				QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
> +	if (err) {
> +		dev_err(hba->dev,
> +			"%s setting fDeviceInit flag failed with error %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	for (i = 0; i < QUERY_REQ_RETRIES && !err && flag_res; i++) {
> +		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +				QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
> +	}
> +	if (err)
> +		dev_err(hba->dev,
> +			"%s reading fDeviceInit flag failed with error %d\n",
> +			__func__, err);
> +	else if (flag_res)
> +		dev_err(hba->dev,
> +			"%s fDeviceInit was not cleared by the device\n",
> +			__func__);
> +
> +out:
> +	return err;
> +}
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -2212,6 +2310,10 @@ static void ufshcd_async_scan(void *data,
> async_cookie_t cookie)
>  	if (ret)
>  		goto out;
>
> +	ret = ufshcd_validate_device_init(hba);
> +	if (ret)
> +		goto out;
> +
>  	scsi_scan_host(hba->host);
>  out:
>  	return;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 17f4995..c1ede2b 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -286,4 +286,11 @@ static inline int ufshcd_dme_hibern8_exit(struct
> ufs_hba *hba)
>  	return ufshcd_dme_hibern8_xxx(hba, 0);
>  }
>
> +int ufs_query_request(struct ufs_hba *hba,
> +			struct ufs_query_req *query,
> +			u8 *descriptor,
> +			struct ufs_query_res *response,
> +			int timeout,
> +			int retries);
> +
>  #endif /* End of Header */
> --
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
