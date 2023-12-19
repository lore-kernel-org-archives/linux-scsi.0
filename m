Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA748BE6;
	Tue, 19 Dec 2023 05:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Gg/imrXx"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BJ4lv2C025193;
	Tue, 19 Dec 2023 05:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=dVTS67fnPeIyokXdraxPjIHcZetDlo6a/vjiKyFZpho=; b=Gg
	/imrXxsMI9q0lKUHnSe1YFSRIIIXQQ4cqKRfrlu43CHUVzY6m4wrvM9fFjNcolvw
	uptAE9Ggam/tWc4avPBc7bYR1KbHXf+/U+dWK3f+/OsrmIWT8zH5uY4PKMZNn3Wc
	aS7D26VnoTSRi2it+H5K1/9pu5d/MBIFFmpTdkQG9Ki8iXwTE9+MUAVRwm4Kjo0t
	LTrw0JRD8G+4E50hEkP/KT2AJK2S++gLg/KeRa8iSuwB8TDoHGE7i2RW1OigMwTd
	T+I00nycBgg4B0s/Zb/BzkrCDBORDtKptu38/YRQkspMAwqbasqYuM49SjHnCQIu
	UI6YtqId6Ejp83XC5bAw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3v2nxsa594-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 05:04:51 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3BJ54obI007250
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 05:04:50 GMT
Received: from [10.253.12.246] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 18 Dec
 2023 21:04:47 -0800
Message-ID: <46b8e4b7-8fc9-4cc0-a37c-80553c34c14a@quicinc.com>
Date: Tue, 19 Dec 2023 13:04:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: Simplify power management during async
 scan
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        "James E.J.
 Bottomley" <jejb@linux.ibm.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das
	<quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-2-bvanassche@acm.org>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20231218225229.2542156-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: edaYRKPxUw804XtZ30tVg7M72mO25bu_
X-Proofpoint-ORIG-GUID: edaYRKPxUw804XtZ30tVg7M72mO25bu_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2311290000 definitions=main-2312190034



On 12/19/2023 6:52 AM, Bart Van Assche wrote:
> ufshcd_init() calls pm_runtime_get_sync() before it calls
> async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync()
> directly or indirectly from ufshcd_add_lus(). Simplify
> ufshcd_async_scan() by always calling pm_runtime_put_sync() from
> ufshcd_async_scan().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d6ae5d17892c..0ad8bde39cd1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8711,7 +8711,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>   
>   	ufs_bsg_probe(hba);
>   	scsi_scan_host(hba->host);
> -	pm_runtime_put_sync(hba->dev);
>   
>   out:
>   	return ret;
> @@ -8980,15 +8979,15 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   
>   	/* Probe and add UFS logical units  */
>   	ret = ufshcd_add_lus(hba);
> +
>   out:
> +	pm_runtime_put_sync(hba->dev);
>   	/*
>   	 * If we failed to initialize the device or the device is not
>   	 * present, turn off the power/clocks etc.
>   	 */
> -	if (ret) {
> -		pm_runtime_put_sync(hba->dev);
> +	if (ret)
>   		ufshcd_hba_exit(hba);
> -	}
>   }
>   
>   static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)

Reviewed-by: Can Guo <quic_cang@quicinc.com>
