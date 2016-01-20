From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: Re: [PATCH] be2iscsi: add checks for dma mapping errors
Date: Wed, 20 Jan 2016 11:50:06 +0530
Message-ID: <e8b4bbae04fa08ad9d4aabc85557ac85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33837 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbcATGUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 01:20:14 -0500
Received: by mail-yk0-f182.google.com with SMTP id a85so597803800ykb.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 22:20:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: khoroshilov@ispras.ru
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

> -----Original Message-----
> From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
> Sent: Saturday, January 16, 2016 3:16 AM
> To: Jayamohan Kallickal; Ketan Mukadam; John Soni Jose
> Cc: Alexey Khoroshilov; James E.J. Bottomley; Martin K. Petersen;
> linux- scsi@vger.kernel.org; linux-kernel@vger.kernel.org; ldv-
> project@linuxtesting.org
> Subject: [PATCH] be2iscsi: add checks for dma mapping errors
>
> hwi_write_buffer() does not check if mapping dma memory succeed.
> The patch adds the check and failure handling.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
> b/drivers/scsi/be2iscsi/be_main.c index fe0c5143f8e6..1da9e31ea958
> 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2504,7 +2504,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct
> scatterlist *sg,
>   * @pwrb: ptr to the WRB entry
>   * @task: iscsi task which is to be executed
>   **/
> -static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct
> iscsi_task
> *task)
> +static int hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task
> +*task)
>  {
>  	struct iscsi_sge *psgl;
>  	struct beiscsi_io_task *io_task = task->dd_data; @@ -2536,6
+2536,9
> @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct
> iscsi_task
> *task)
>  							     task->data,
>
> task->data_count,
>
> PCI_DMA_TODEVICE);
> +			if (pci_dma_mapping_error(phba->pcidev,
> +						  io_task->mtask_addr))
> +				return -ENOMEM;
>  			io_task->mtask_data_count = task->data_count;
>  		} else
>  			io_task->mtask_addr = 0;
> @@ -2580,6 +2583,7 @@ static void hwi_write_buffer(struct iscsi_wrb
> *pwrb, struct iscsi_task *task)
>  		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0x106);
>  	}
>  	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
> +	return 0;
>  }
>
>  /**
> @@ -5025,6 +5029,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
>  	unsigned int doorbell = 0;
>  	unsigned int cid;
>  	unsigned int pwrb_typeoffset = 0;
> +	int ret = 0;
>
>  	cid = beiscsi_conn->beiscsi_conn_cid;
>  	pwrb = io_task->pwrb_handle->pwrb;
> @@ -5073,7 +5078,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
>  	case ISCSI_OP_LOGIN:
>  		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
>  		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
> -		hwi_write_buffer(pwrb, task);
> +		ret = hwi_write_buffer(pwrb, task);
>  		break;
>  	case ISCSI_OP_NOOP_OUT:
>  		if (task->hdr->ttt != ISCSI_RESERVED_TAG) { @@ -5093,19
> +5098,19 @@ static int beiscsi_mtask(struct iscsi_task *task)
>  				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
>  					      dmsg, pwrb, 0);
>  		}
> -		hwi_write_buffer(pwrb, task);
> +		ret = hwi_write_buffer(pwrb, task);
>  		break;
>  	case ISCSI_OP_TEXT:
>  		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
> -		hwi_write_buffer(pwrb, task);
> +		ret = hwi_write_buffer(pwrb, task);
>  		break;
>  	case ISCSI_OP_SCSI_TMFUNC:
>  		ADAPTER_SET_WRB_TYPE(pwrb, INI_TMF_CMD, pwrb_typeoffset);
> -		hwi_write_buffer(pwrb, task);
> +		ret = hwi_write_buffer(pwrb, task);
>  		break;
>  	case ISCSI_OP_LOGOUT:
>  		ADAPTER_SET_WRB_TYPE(pwrb, HWH_TYPE_LOGOUT,
pwrb_typeoffset);
> -		hwi_write_buffer(pwrb, task);
> +		ret = hwi_write_buffer(pwrb, task);
>  		break;
>
>  	default:
> @@ -5116,6 +5121,9 @@ static int beiscsi_mtask(struct iscsi_task *task)
>  		return -EINVAL;
>  	}
>
> +	if (ret)
> +		return ret;
> +
>  	/* Set the task type */
>  	io_task->wrb_type = (is_chip_be2_be3r(phba)) ?
>  		AMAP_GET_BITS(struct amap_iscsi_wrb, type, pwrb) :
> --
> 1.9.1
>
Reviewed-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Thanks,

JB
