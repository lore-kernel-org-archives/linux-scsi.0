Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D8189BAF
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886916; cv=none; b=b7wVbLYSFL5wPOZrgwgSoR/MCcgrKiJdj32nnB1tOg9RdOPCpTVmlOm6M8pik/TbEQ7RUcfSlCA5goLzjUqxIjMVmdrIdh0/ixxnMIvbcn5ybrLHRhqayDr+klgQOHQDtApjvSADMFIaSCilcRbvUGMGLQ9Toz9nJdcSGdb45TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886916; c=relaxed/simple;
	bh=uATKcbHrr4oTJE/cn4lhLMPPtuzpNY/82PPgYbeOaKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuS/c02xohcPmczkeseCmdAijKLl0oCIoVoNpguZHg1WgKTz67ZExs2xGXt2sM4EQkVomOp9gyUwEhRAPiDSD7zZwnsnc1T10Mok5Zw1KGqdNuOQ4aJ3t+wTLLJwMtCGdQX/hVFL4hsE+5iaXDCO5Z8wjOMkVWfi5hJRzAWkefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zgphnUfa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zgphnUfa"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22438c356c8so25432925ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 10:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741886914; x=1742491714; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HZrGVNwUQ5jJGSVofb8QOBJpSOkJrQt8IsuJ+7RddHI=;
        b=zgphnUfabVju1LN+pQ09wRKtcqsLT0YY7Uwtz5nCkkbctLSlck3KwcRQO7RNNmbHzE
         E4Om9pINvxGeDVF91NcRGVLRBxoQXpD2mqZrDp0kgsXd1+ZGdta+nZFwEwCMYEGsxZRt
         FOe2c5kHtOvqicG7sRXMdVKFlZMiF6XtOu3gQ/7+1/poDVFJQMMQT33aVYAXYganrYLz
         8SQF80029uIdlM1FG6pXObyx77RbIPu1TUdNuSq8Jy0+yQfHHfPDhA/jpi7cl3jBrJDs
         VNmt6pvf8qo8NHPFhcgA8fXt3KIK+VHyy8J5kLUOBG52dwLiAGXw1cPASoByrh6ZdwH9
         2ODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741886914; x=1742491714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZrGVNwUQ5jJGSVofb8QOBJpSOkJrQt8IsuJ+7RddHI=;
        b=C4po6/18KCGe9JWFeDkvvyO1pSo3RQnM9qVTxABDFvFhcSarhKfHM6G6mh92HQBi1t
         OWNHQVLDhwR5v/Xdd5TcKQ19zVg3KFWUgZsdSatKc4i7CJZIWBugXyUrHr5ep+XgAp4v
         ago1D0URY8smtHI7+s/toll96qJv7VkdvMgYnQB5mW+KqRvGwvrNijCk4XqV/wI6SHxU
         bK9L2UtDumOAmmt+g7mhuY+3SWHFONbe6qowfUm0Da8z+RrnpITB0ApGQmAv+Znq9DOS
         hRynEpSglBrG2/Pa/c6lzII7wLqB/4HHbB8GK+SplHKgoiqcvLGhaLTrLQG9RagruLIs
         /06A==
X-Forwarded-Encrypted: i=1; AJvYcCUqb3e0hJKjWN5RcBB62piwQklfULi0CPMdmeOX/H2GXyEmFnuOki8FVXuz1eeDl6r7s5976SQWd25H@vger.kernel.org
X-Gm-Message-State: AOJu0YwuRbjgeQwBtvJJBv8vbNy00dwwpm/VinypfsnHWantj/6/S+QZ
	LLhqgOPsJvCg6AhbHxV5/xCmguVQ03sk6flQSlNDGPkoJAP4mvPq/8HE88sSRw==
X-Gm-Gg: ASbGncvFSUUzHDclFyyDCduDTCUNmrIY3o925NI2qUU8pwjBu3SFJKkheEgA7HNarR3
	G55FuL5oPnnqolCVKVC1RYVVey/t6r8zrVOl0mj8QkV9ISNarhxpUtOpZTAMwhHr4p2x1Chz41L
	ca7THfsIrGVFPmTgm1GIb7rMF7gdnWJyTJXHBggUMSuJIfsXWhS9iBmP+X/F6gtUYxiu+oMkkKh
	fboIG/wQzdxi9a+BiRa/sy+PJN48xfZUMnnY3W4mTgVP6FOtM/nBImGF2XyIWEbgOOBbF3Qxh69
	yzVZvyNFVhebdu9CuDX+4aNvqUYRccZIQfqEmXmRSCnHhQ+FfEJKKw==
X-Google-Smtp-Source: AGHT+IEggtRzx3PbFGQOkRuQrNEotEzfOz11JYuzd2X6Iwabnvc8Zf8QuXU1XcSuu/NAfUiKCrzDgw==
X-Received: by 2002:a05:6a21:9188:b0:1f5:9024:3246 with SMTP id adf61e73a8af0-1f5bd7d2271mr844783637.17.1741886914092;
        Thu, 13 Mar 2025 10:28:34 -0700 (PDT)
Received: from thinkpad ([120.60.60.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea93e1dsm1538175a12.69.2025.03.13.10.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 10:28:33 -0700 (PDT)
Date: Thu, 13 Mar 2025 22:58:26 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: quic_cang@quicinc.com, quic_nitirawa@quicinc.com, bvanassche@acm.org,
	avri.altman@wdc.com, peter.wang@mediatek.com, minwoo.im@samsung.com,
	adrian.hunter@intel.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bean Huo <beanhuo@micron.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Biggers <ebiggers@google.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: add device level exception
 support
Message-ID: <20250313172826.xzqkrx5rzuqpvz7j@thinkpad>
References: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>

On Thu, Mar 06, 2025 at 09:31:06AM -0800, Bao D. Nguyen wrote:
> The device JEDEC standard version 4.1 adds support for the device
> level exception events. To support this new device level exception
> feature, expose two new sysfs nodes below to provide
> the user space access to the device level exception information.
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
> 
> The device_lvl_exception sysfs node reports the number of
> device level exceptions that have occurred since the last time
> this variable is reset.
> The device_lvl_exception_id sysfs node reports the exception ID
> which is the JEDEC standard qDeviceLevelExceptionID attribute.
> The user space application can query these sysfs nodes to get more
> information about the device level exception.
> 
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 23 +++++++++++
>  drivers/ufs/core/ufs-sysfs.c               | 54 ++++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd-priv.h             |  1 +
>  drivers/ufs/core/ufshcd.c                  | 61 ++++++++++++++++++++++++++++++
>  include/uapi/scsi/scsi_bsg_ufs.h           |  9 +++++
>  include/ufs/ufs.h                          |  5 ++-
>  include/ufs/ufshcd.h                       |  5 +++
>  7 files changed, 157 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index ae01912..5cf3f43 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1604,3 +1604,26 @@ Description:
>  		prevent the UFS from frequently performing clock gating/ungating.
>  
>  		The attribute is read/write.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		The device_lvl_exception is a counter indicating the number
> +		of times the device level exceptions have occurred since the
> +		last time this variable is reset. Read the device_lvl_exception_id
> +		sysfs node to know more information about the exception.
> +		The file is read only.

No. This attribute is RW and the write of 0 will reset the counter. Please
change it here and also in commit message.

Also document the spec version requirement for these attributes.

> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		Reading the device_lvl_exception_id returns the device JEDEC
> +		standard's qDeviceLevelExceptionID attribute. The definition of the
> +		qDeviceLevelExceptionID is the ufs device vendor specific design.
> +		Refer to the device manufacturer datasheet for more information
> +		on the meaning of the qDeviceLevelExceptionID attribute value.
> +		The file is read only.
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 90b5ab6..0248288a 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev,
>  	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
>  }
>  

[...]

> +int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id)
> +{
> +	struct utp_upiu_query_response_v4_0 *upiu_resp;
> +	struct ufs_query_req *request = NULL;
> +	struct ufs_query_res *response = NULL;
> +	int err;
> +
> +	if (hba->dev_info.wspecversion < 0x410)
> +		return -EOPNOTSUPP;
> +
> +	ufshcd_hold(hba);
> +	mutex_lock(&hba->dev_cmd.lock);
> +
> +	ufshcd_init_query(hba, &request, &response,
> +			  UPIU_QUERY_OPCODE_READ_ATTR,
> +			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
> +
> +	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
> +
> +	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
> +
> +	if (err) {
> +		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	upiu_resp = (struct utp_upiu_query_response_v4_0 *)response;
> +	*exception_id = get_unaligned_be64(&upiu_resp->value);
> +
> +out:
> +	mutex_unlock(&hba->dev_cmd.lock);
> +	ufshcd_release(hba);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_read_device_lvl_exception_id);

There is no need to export this function.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
