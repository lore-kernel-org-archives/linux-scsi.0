Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245215B992
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725737970; cv=none; b=Pdvfzj3wadLZKP7DmhYmTikh2qVqJW6Xdxx+5epqxVuh3OXUBZnRXvSnj/Ds/ICofh/zFDGxz8UnMluPCAH7zAUwTUrMQbWds+x/z46vTHK8Xk3tS9ZglM7riJ2dWw8pQLQ9zqk+OtTlomESpd/wlNMjiy3CDKY4CDB58/Qs7jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725737970; c=relaxed/simple;
	bh=/XPLjpAfOpvjv5CAwcBzn8FvzM3KLgsQ7M7U8SjcJOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rKDzAJnTyQTP4Uaz4Sftr/mlslhK6xHltUl2DFXM6KT3FsFC47lhs2piUFYNGsN3RU1UBSSryIa6Csw19O1I+Fpp8qqGAgZv2xGxFzsjVPrLikc1HOYXe4sVT6XRoi6RoieahgSM9XPR5STrHUhBrKjUl0oTpAeiOTxgQB8b+Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=WlzgXATH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="WlzgXATH"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 487JKedT008158;
	Sat, 7 Sep 2024 19:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ox/vz3VY/55idjY2vXvsupJmZJ3gDy6YxrYpBXmOnU8=; b=WlzgXATHF2cvRP3O
	8a7LDJsfZTGwl7HKYAcUEYNUtkrAwqz47ycNCnhEG1cRKdcgep6GTTpxfcxt+pJE
	CTCUgx7llwZZUkVzwlKdzn9/WC0j2+J6Q2Ot/I4TeDZHa2Qlqze/b/GbGDh+aOVv
	dcrRyrRZA5TTAApfJAE+6d96QcO5sGW0pZEYoOn0cgKAcrOCLJMhR14iHtGoaAeg
	YVEXcHRyZZzppEeEQ7Q82XjZzvDwGxOthMGTaNLg6I3CGk4UZedA1wp6S9poEVOS
	SREwbYjaLrbLP+kvejebRy95uxmkPd19bp7fVOToPVRURPIy/TEfkG/IGakczd8j
	aZ3jjA==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gg0g0vyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 19:38:42 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487JcfkE008342
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 19:38:41 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 12:38:41 -0700
Message-ID: <5bc336ef-5dc3-de16-bbab-c093220c4baa@quicinc.com>
Date: Sat, 7 Sep 2024 12:38:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 06/10] scsi: ufs: core: Move the
 ufshcd_device_init(hba, true) call
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
 <20240905220214.738506-7-bvanassche@acm.org>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _PF7AdeQEkvRlN-4qgmHgQOOoJjF8Tha
X-Proofpoint-ORIG-GUID: _PF7AdeQEkvRlN-4qgmHgQOOoJjF8Tha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409070161

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
> into ufshcd_init(). This patch prepares for moving both scsi_add_host()
> calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
> ufshcd_init() without holding hba->host_sem is safe. This is safe because
> hba->host_sem serializes core code and sysfs callbacks. The
> ufshcd_device_init() call is moved before the scsi_add_host() call and
> hence happens before any SCSI sysfs attributes are created.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 6e3cffcdf9a6..843566720afa 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8908,10 +8908,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   	int ret;
>   
>   	down(&hba->host_sem);
> -	/* Initialize hba, detect and initialize UFS device */
> -	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);
> -	if (ret == 0)
> -		ret = ufshcd_probe_hba(hba);
> +	ret = ufshcd_probe_hba(hba);
>   	up(&hba->host_sem);
>   	if (ret)
>   		goto out;
> @@ -10605,6 +10602,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	 */
>   	ufshcd_set_ufs_dev_active(hba);
>   
> +	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	if (err)
> +		goto out_disable;
> +

In SDB mode, the order of execution for these two functions changed by 
this patch. In the original code, the scsi_add_host() happens first, 
then the code within ufshcd_post_device_init(). Here it is the opposite. 
However, it seems the order can be swapped without any issue.

>   	err = ufshcd_add_scsi_host(hba);
>   	if (err)
>   		goto out_disable;
> 

