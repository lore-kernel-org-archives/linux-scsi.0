Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDEC1514CE
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 04:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726202337; cv=none; b=F+TXGhTljIjt/AEW3lQYPD/c1ZPo0f0gjLETYYjOzBdMhAqjYWOALx86kN3oW6BSopLWplJeGRoyMQD1j3o9oSbqAxi4amxFKaWPOrgn9dUy1qm573/BIa76PonkZK90vSALzSjxzlgEJh1Z7acIOc8ut2g+757wqhh7AQBpypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726202337; c=relaxed/simple;
	bh=6jtcXUtI2ZekWtLVOsfSGikt2RRkucnSwZ4m38Gil7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dc9epLvGAgonkD/Nd4WF4B3LGSdol9TLCrnWPm2yJAFXy2cp+KxdSsL6kIL7YqL2MxUeqCp4LYUuiV0b2j2jdKt/NG8usid4lvVy3qit+d2ZHfQjJva8QFZ/uzgv9hrRCNOM9FYZiEoF0Xt7pGBODqfHRVjGJBORCUCCrxBnltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=D03m0xEW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="D03m0xEW"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMB56G016900;
	Fri, 13 Sep 2024 04:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NZYlRciUnLmnlDsW76prX6cMTMhtzryFB11ZiavAbcc=; b=D03m0xEWHhiMwhr6
	JS8xIgzhDM4/7PZAg0cVrWVyWAWzJjwdey2XD57IEoQdypWN+4QOnC2fgywL+xhf
	OovBn9NNWiUjsocEJzIKGqfoxVAvvxCnoGeEOBj+0br+UI2dlrC5ChwyhwAZVOO8
	YZcqlFdqchc1tt58iCUlR+inwtjLJaqFC70A96jBtbiHOWZLvy9SO5dpAJiy4bRD
	nX7AUjtxZHb0vT4bAtklEZFQ87SK0C4fQ3G3TqUoONWCz/lyOJRMokxptq6qUe1u
	qMpXhgXB6TvxYh09qYJCYH/iFcS2+rPGOUcmF4L7sMZ75LWcdysAf/1XC9V6BzEL
	qoCgSA==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gy5rqey7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 04:38:43 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D4cfrC024211
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 04:38:41 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 12 Sep
 2024 21:38:41 -0700
Message-ID: <63cd4607-b65b-57ce-493e-ae5da8c54ff9@quicinc.com>
Date: Thu, 12 Sep 2024 21:38:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 05/10] scsi: ufs: core: Move the ufshcd_device_init()
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
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-6-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240910215139.3352387-6-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: eAmr7LB6HoHspm5qrEvnD8wIWqBBe_Wp
X-Proofpoint-ORIG-GUID: eAmr7LB6HoHspm5qrEvnD8wIWqBBe_Wp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409130030

On 9/10/2024 2:50 PM, Bart Van Assche wrote:
> Move the ufshcd_device_init() and ufshcd_process_device_init_result() calls
> to the ufshcd_probe_hba() callers. This change refactors the code without
> modifying the behavior of the UFSHCI driver. This change prepares for
> moving one ufshcd_device_init() call into ufshcd_init().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 31 ++++++++++++++++++-------------
>   1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 1094c1ba2212..f62d257a92da 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -298,6 +298,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>   static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
> +static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params);
>   static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>   static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
> @@ -7716,8 +7717,14 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   	err = ufshcd_hba_enable(hba);
>   
>   	/* Establish the link again and restore the device */
> -	if (!err)
> -		err = ufshcd_probe_hba(hba, false);
> +	if (!err) {
> +		ktime_t device_init_start = ktime_get();
> +
> +		err = ufshcd_device_init(hba, /*init_dev_params=*/false);
> +		if (!err)
> +			err = ufshcd_probe_hba(hba, false);
> +		ufshcd_process_device_init_result(hba, device_init_start, err);


Hi Bart, IMO the function name ufshcd_process_device_init_result() is 
not correctly describing the original code. As you can see, the "ret" 
passed into the function here is from the result of the 
ufshcd_probe_hba(), not the result of the ufshcd_device_init().
Same comment for the name device_init_start. Originally, it is the time 
spent in the ufshcd_probe_hba().

> +	}
>   
>   	if (err)
>   		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> @@ -8849,13 +8856,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>    */
>   static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   {
> -	ktime_t start = ktime_get();
>   	int ret;
>   
> -	ret = ufshcd_device_init(hba, init_dev_params);
> -	if (ret)
> -		goto out;
> -
>   	if (!hba->pm_op_in_progress &&
>   	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
>   		/* Reset the device and controller before doing reinit */
> @@ -8868,13 +8870,13 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   			dev_err(hba->dev, "Host controller enable failed\n");
>   			ufshcd_print_evt_hist(hba);
>   			ufshcd_print_host_state(hba);
> -			goto out;
> +			return ret;
>   		}
>   
>   		/* Reinit the device */
>   		ret = ufshcd_device_init(hba, init_dev_params);
>   		if (ret)
> -			goto out;
> +			return ret;
>   	}
>   
>   	ufshcd_print_pwr_info(hba);
> @@ -8894,9 +8896,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   		ufshcd_write_ee_control(hba);
>   	ufshcd_configure_auto_hibern8(hba);
>   
> -out:
> -	ufshcd_process_device_init_result(hba, start, ret);
> -	return ret;
> +	return 0;
>   }
>   
>   /**
> @@ -8907,11 +8907,16 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   {
>   	struct ufs_hba *hba = (struct ufs_hba *)data;
> +	ktime_t device_init_start;
>   	int ret;
>   
>   	down(&hba->host_sem);
>   	/* Initialize hba, detect and initialize UFS device */
> -	ret = ufshcd_probe_hba(hba, true);
> +	device_init_start = ktime_get();
> +	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	if (ret == 0)
> +		ret = ufshcd_probe_hba(hba, true);
> +	ufshcd_process_device_init_result(hba, device_init_start, ret);

Same comment about the function name. The "ret" here is the result of 
ufshcd_probe_hba().

>   	up(&hba->host_sem);
>   	if (ret)
>   		goto out;
> 

