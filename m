Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7B95393
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 05:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="QunMSvzF"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BJ1jsWR020404;
	Tue, 19 Dec 2023 05:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=B0Z9pwzJBZXyc2XACQn/mryPhhXtcGZCCjlV6tUb6Fw=; b=Qu
	nMSvzFMMOdbTARd7QVJihVKb2VYMS1pKEakd5Wsj4VyJiTXejJwC/Em39Wo12YsZ
	Lz/fXWG1r0+03utVhRSIwlprgqvOO4Pmd8uP48pDVaYKytlr9xHFrF1oop/YlK1N
	i6cmGFREZvBNKzcF6zlnBxv8AfVthH6r5U0Y5AowuVJefyjotQAVjbVbfMd66Zi7
	N6NpXilt6x1b5gfDQUhSTf/VIrjipPNu8U/fekgfxqdsiX4H6J6qAbojyTaIxGiC
	fREvhHunWFLzK9bQIMfbdFlvkMR+JQuYVqVG8ALHUUb1rOqM6WLmbU8relzdAS2h
	FL0CTKlNlIWhOO+IMj3g==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3v2mjft9m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 05:05:15 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3BJ55ERC007958
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 05:05:14 GMT
Received: from [10.253.12.246] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 18 Dec
 2023 21:05:11 -0800
Message-ID: <a4a50ff9-b50b-4d7c-9c52-a8a62175bfbd@quicinc.com>
Date: Tue, 19 Dec 2023 13:05:11 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Remove the ufshcd_hba_exit() call from
 ufshcd_async_scan()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Daniel Mentz <danielmentz@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Jhu
	<chu.stanley@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das
	<quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Arthur
 Simchaev" <Arthur.Simchaev@wdc.com>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-3-bvanassche@acm.org>
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20231218225229.2542156-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3iWpgc_xyA_jA3MiyybYZIt0k2e0O21x
X-Proofpoint-ORIG-GUID: 3iWpgc_xyA_jA3MiyybYZIt0k2e0O21x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2311290000
 definitions=main-2312190034



On 12/19/2023 6:52 AM, Bart Van Assche wrote:
> Calling ufshcd_hba_exit() from a function that is called asynchronously
> from ufshcd_init() is wrong because this triggers multiple race
> conditions. Instead of calling ufshcd_hba_exit(), log an error message.
> 
> Reported-by: Daniel Mentz <danielmentz@google.com>
> Fixes: 1d337ec2f35e ("ufs: improve init sequence")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0ad8bde39cd1..7c59d7a02243 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8982,12 +8982,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   
>   out:
>   	pm_runtime_put_sync(hba->dev);
> -	/*
> -	 * If we failed to initialize the device or the device is not
> -	 * present, turn off the power/clocks etc.
> -	 */
> +
>   	if (ret)
> -		ufshcd_hba_exit(hba);
> +		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
>   }
>   
>   static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)

Reviewed-by: Can Guo <quic_cang@quicinc.com>
