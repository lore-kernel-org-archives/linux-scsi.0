Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B9155316
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725707589; cv=none; b=CpScRDnrT+xvltCK1qy834+zNwbho0CUhQf6sMpKPyA9rlH5F5DsFan6zkslahEYnhl2BCwKvI8ZsCUs8YWq91D37lrg3MeCRMD3XzqozZQceKf2klS3aQ4VMkN0hpSkJgmEF2i8mUQsey2aq86s4NztM0eSRMkVWkMd9QepArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725707589; c=relaxed/simple;
	bh=ZS0kB4KHm7+kkg6pftd0pQlXF9P9FjwLlUsa7l0DewI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=E1BkaVkysZ3yWGoFbkiC94YouAWXUhIl99qsD4hyv8+qKcdSZz3xMTRDoNMfUbd1m6hPRxN03CL0/HDXSd7U9CQDTgZKMw+ZzIqpfy/O9gee3/VElcFjzewVQNOqhoiFuxsGBMSojt6ARJSKrVHKonPWkfFcxql0Of0+OJ4aGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=A7W4bXnP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="A7W4bXnP"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4876tIBY029462;
	Sat, 7 Sep 2024 11:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oA3rxca2mEt1WjkmcrhYDC+hoz8NzVKSdcuwQz1R7Vo=; b=A7W4bXnPqaeDyZEj
	nvI72KUwBLO0D3gCx6VlmtulNPIDBKy0onmrsq3DEsrwZNvT1IR1exVhYEL3yjA5
	s5tPxtTYyo9iStEq4eLuFOPZAK88jdNqnx18VQCj1T4KdF/jXXYxFgPOWhpAPfo1
	S5nOQ/5j+CSirufBsaP2DGPTTkPEa1j9aEDVS2z9dXss36FBg7EI6UbYeqtAGN3P
	bWhgzr89ZM7WYbn6Z2foIHZ8LPV4MbhDrwp/2tW/VL3yMGz+C2mvV7NsVMxxlj2P
	gr2eKhK8c2ZYf7Lp2aBbIyMn99Etff+w4joi4bipwSv85Mn5Ba673jdptqNUR5lZ
	4+xa9Q==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gdep0kfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 11:12:54 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487BCrlS022938
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 11:12:53 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 04:12:53 -0700
Message-ID: <26d4b581-51fc-9fb0-ffc4-f16389a53545@quicinc.com>
Date: Sat, 7 Sep 2024 04:12:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 05/10] scsi: ufs: core: Move the ufshcd_device_init()
 call
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean
 Huo <beanhuo@micron.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-6-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-6-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HM6qF71v85zkd4lCkQT_EhlgpHlr9XXL
X-Proofpoint-ORIG-GUID: HM6qF71v85zkd4lCkQT_EhlgpHlr9XXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409070090

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
> remove the 'init_dev_params' argument of ufshcd_probe_hba(). This change
> refactors the code without modifying the behavior of the UFSHCI driver.
> This change prepares for moving one ufshcd_device_init() call into
> ufshcd_init().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 25 +++++++++++++------------
>   1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e2137bcf3de7..6e3cffcdf9a6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -298,7 +298,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>   static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
> +static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params);
> +static int ufshcd_probe_hba(struct ufs_hba *hba);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>   static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>   static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
> @@ -7693,8 +7694,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   	err = ufshcd_hba_enable(hba);
>   
>   	/* Establish the link again and restore the device */
> -	if (!err)
> -		err = ufshcd_probe_hba(hba, false);

In the original code, if ufshcd_probe_hba()->ufshcd_device_init() fails, 
the hba->ufshcd_state is updated to UFSHCD_STATE_ERROR;

> +	if (!err) {
> +		err = ufshcd_device_init(hba, /*init_dev_params=*/false);

Calling ufshcd_device_init() here changes the behavior of the code 
slightly. If the ufshcd_device_init() fails, it exits without updating 
the hba->ufshcd_state to UFSHCD_STATE_ERROR.


> +		if (!err)
> +			err = ufshcd_probe_hba(hba);
> +	}
>   
>   	if (err)
>   		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> @@ -8830,21 +8834,16 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>   /**
>    * ufshcd_probe_hba - probe hba to detect device and initialize it
>    * @hba: per-adapter instance
> - * @init_dev_params: whether or not to call ufshcd_device_params_init().
>    *
>    * Execute link-startup and verify device initialization
>    *
>    * Return: 0 upon success; < 0 upon failure.
>    */
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
> +static int ufshcd_probe_hba(struct ufs_hba *hba)
>   {
>   	ktime_t start = ktime_get();
>   	unsigned long flags;
> -	int ret;
> -
> -	ret = ufshcd_device_init(hba, init_dev_params);
> -	if (ret)
> -		goto out;
> +	int ret = 0;
>   
>   	if (!hba->pm_op_in_progress &&
>   	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
> @@ -8862,7 +8861,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   		}
>   
>   		/* Reinit the device */
> -		ret = ufshcd_device_init(hba, init_dev_params);
> +		ret = ufshcd_device_init(hba, /*init_dev_params=*/false);

Originally, the ufshcd_async_scan()->ufshcd_probe_hba() has the 
init_dev_params = true. However the init_dev_params is updated to false 
here for the ufshcd_async_scan()->ufshcd_probe_hba() path.

>   		if (ret)
>   			goto out;
>   	}
> @@ -8910,7 +8909,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   
>   	down(&hba->host_sem);
>   	/* Initialize hba, detect and initialize UFS device */
> -	ret = ufshcd_probe_hba(hba, true);
> +	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);

Same issue as mentioned earlier. If ufshcd_device_init() fails here, the 
hba->ufshcd_state is not updated to UFSHCD_STATE_ERROR. Compared to the 
original ufshcd_probe_hba()->ufshcd_device_init() failure would update 
hba->ufshcd_state.

Thanks, Bao

> +	if (ret == 0)
> +		ret = ufshcd_probe_hba(hba);
>   	up(&hba->host_sem);
>   	if (ret)
>   		goto out;
> 

