From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [RFC/PATCH 3/3] scsi: ufs: Logical Unit (LU) command queue depth
Date: Thu, 29 Aug 2013 18:09:06 +0300
Message-ID: <00d401cea4c9$b58e80c0$20ab8240$@codeaurora.org>
References: <1377788409-5628-1-git-send-email-rshvili@codeaurora.org> <00ce01cea4c9$81c13df0$8543b9d0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00ce01cea4c9$81c13df0$8543b9d0$@codeaurora.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Raviv Shvili' <rshvili@codeaurora.org>, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Yaniv Gardi
= > Sent: Thursday, August 29, 2013 6:08 PM
= > To: 'Raviv Shvili'; linux-scsi@vger.kernel.org
= > Cc: linux-arm-msm@vger.kernel.org; 'open list'
= > Subject: RE: [RFC/PATCH 3/3] scsi: ufs: Logical Unit (LU) command queue
= > depth
= > 
= > Looks good to me.
= > Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
= > 
= > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
= > member of Code Aurora Forum, hosted by The Linux Foundation
= > 
= > 
= > = > -----Original Message-----
= > = > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi- = >
= > owner@vger.kernel.org] On Behalf Of Raviv Shvili = > Sent: Thursday,
= > August 29, 2013 6:00 PM = > To: linux-scsi@vger.kernel.org = > Cc:
linux-
= > arm-msm@vger.kernel.org; Raviv Shvili; open list = > Subject: [RFC/PATCH
= > 3/3] scsi: ufs: Logical Unit (LU) command queue = > depth = > = > Some
of
= > the UFS devices may support different number of commands that = > can
= > be queued per LU. At the current implementation, SW configure each = >
of
= > the UFS devices LU's according to the controller capability.
= > = >
= > = > In this patch we read the queue depth available per LU and update
the
= > LU's = > SW structure.
= > = >
= > = > Signed-off-by: Raviv Shvili <rshvili@codeaurora.org> = > = > diff
--git
= > a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index = >
= > 202e15d..d42f424 100644 = > --- a/drivers/scsi/ufs/ufs.h = > +++
= > b/drivers/scsi/ufs/ufs.h = > @@ -132,6 +132,27 @@ enum desc_idn {
= > = >  	QUERY_DESC_IDN_RFU_2		= 0x9,
= > = >  };
= > = >
= > = > +#define UNIT_DESC_MAX_SIZE       0x22
= > = > +/* Unit descriptor parameters offsets in bytes*/ enum
= > unit_desc_param {
= > = > +	UNIT_DESC_PARAM_LEN			= 0x0,
= > = > +	UNIT_DESC_PARAM_TYPE			= 0x1,
= > = > +	UNIT_DESC_PARAM_UNIT_INDEX		= 0x2,
= > = > +	UNIT_DESC_PARAM_LU_ENABLE		= 0x3,
= > = > +	UNIT_DESC_PARAM_BOOT_LUN_ID		= 0x4,
= > = > +	UNIT_DESC_PARAM_LU_WR_PROTECT		= 0x5,
= > = > +	UNIT_DESC_PARAM_LU_Q_DEPTH		= 0x6,
= > = > +	UNIT_DESC_PARAM_MEM_TYPE		= 0x8,
= > = > +	UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x9,
= > = > +	UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0xA,
= > = > +	UNIT_DESC_PARAM_LOGICAL_BLK_COUNT	= 0xB,
= > = > +	UNIT_DESC_PARAM_ERASE_BLK_SIZE		= 0x13,
= > = > +	UNIT_DESC_PARAM_PROVISIONING_TYPE	= 0x17,
= > = > +	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
= > = > +	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
= > = > +	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
= > = > +};
= > = > +
= > = >  /* Exception event mask values */
= > = >  enum {
= > = >  	MASK_EE_STATUS		= 0xFFFF,
= > = > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index =
= > > d0cad34..9b0d769 100644 = > --- a/drivers/scsi/ufs/ufshcd.c = > +++
= > b/drivers/scsi/ufs/ufshcd.c = > @@ -111,6 +111,8 @@ static void
= > ufshcd_tmc_handler(struct ufs_hba = > *hba);  static void
= > ufshcd_async_scan(void *data, async_cookie_t cookie); = > static int
= > ufshcd_reset_and_restore(struct ufs_hba *hba);  static int = >
= > ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag); = > +static int
= > ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
= > = > +					struct scsi_device *sdev);
= > = >
= > = >  /*
= > = >   * ufshcd_wait_for_register - wait for register value to change @@
-
= > = > 1767,6 +1769,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba
= > *hba) = > static int ufshcd_slave_alloc(struct scsi_device *sdev)  {
= > = >  	struct ufs_hba *hba;
= > = > +	int lun_qdepth;
= > = >
= > = >  	hba = shost_priv(sdev->host);
= > = >  	sdev->tagged_supported = 1;
= > = > @@ -1777,6 +1780,14 @@ static int ufshcd_slave_alloc(struct
= > scsi_device = > *sdev) = >
= > = >  	/* allow SCSI layer to restart the device in case of errors
*/
= > = >  	sdev->allow_restart = 1;
= > = > +	lun_qdepth = ufshcd_read_sdev_qdepth(hba, sdev);
= > = > +	if (lun_qdepth == 0 || lun_qdepth > hba->nutrs) {
= > = > +		dev_info(hba->dev, "%s, lun %d queue depth is %d\n",
= > = > __func__,
= > = > +				sdev->lun, lun_qdepth);
= > = > +		lun_qdepth = hba->nutrs;
= > = > +	} else if (lun_qdepth < 0) {
= > = > +		lun_qdepth = 1;
= > = > +	}
= > = >
= > = >  	/*
= > = >  	 * Inform SCSI Midlayer that the LUN queue depth is same as
the
= > = > @@ -1785,7 +1796,7 @@ static int ufshcd_slave_alloc(struct
= > scsi_device = > *sdev)
= > = >  	 * SAM_STAT_TASK_SET_FULL, the LUN queue depth will be
= > = > adjusted
= > = >  	 * with scsi_adjust_queue_depth.
= > = >  	 */
= > = > -	scsi_activate_tcq(sdev, hba->nutrs);
= > = > +	scsi_activate_tcq(sdev, lun_qdepth);
= > = >  	return 0;
= > = >  }
= > = >
= > = > @@ -2862,6 +2873,38 @@ static int
= > ufshcd_eh_host_reset_handler(struct
= > = > scsi_cmnd *cmd)  }
= > = >
= > = >  /**
= > = > + * ufshcd_read_sdev_qdepth - read the lun command queue depth = >
= > + * @hba: Pointer to adapter instance = > + * @sdev: pointer to SCSI
= > device = > + * = > + * Return in case of success the lun's queue depth
else
= > error.
= > = > + */
= > = > +static int ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
= > = > +				struct scsi_device *sdev)
= > = > +{
= > = > +	int ret;
= > = > +	int buff_len = UNIT_DESC_MAX_SIZE;
= > = > +	u8 desc_buf[UNIT_DESC_MAX_SIZE];
= > = > +
= > = > +	ret = ufshcd_query_descriptor(hba,
= > = > UPIU_QUERY_OPCODE_READ_DESC,
= > = > +			QUERY_DESC_IDN_UNIT, sdev->lun, 0, desc_buf,
= > = > &buff_len);
= > = > +
= > = > +	if (ret || (buff_len < UNIT_DESC_PARAM_LU_Q_DEPTH)) {
= > = > +		dev_err(hba->dev,
= > = > +			"%s:Failed reading unit descriptor. len = %d
ret =
= > = > %d"
= > = > +			, __func__, buff_len, ret);
= > = > +		if (!ret)
= > = > +			ret = -EINVAL;
= > = > +
= > = > +		goto out;
= > = > +	}
= > = > +
= > = > +	ret = desc_buf[UNIT_DESC_PARAM_LU_Q_DEPTH] & 0xFF;
= > = > +out:
= > = > +	return ret;
= > = > +}
= > = > +
= > = > +/**
= > = >   * ufshcd_async_scan - asynchronous execution for link startup
= > = >   * @data: data pointer to pass to this function
= > = >   * @cookie: cookie data
= > = > --
= > = > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
= > = > is a member of Code Aurora Forum, hosted by The Linux Foundation = >
= > = > -- = > To unsubscribe from this list: send the line "unsubscribe
linux-scsi"
= > in the = > body of a message to majordomo@vger.kernel.org More
= > majordomo info = > at  http://vger.kernel.org/majordomo-info.html
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html
