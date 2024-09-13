Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4CC2F24
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 04:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726201877; cv=none; b=cGy7UVJDInNVr6JMv+rbSLoujAU/rmp9DUqJyUKwplY5iMIeD9ClI5H3lt1RfLW2kM4ebXYF/I33car5iZWuGvziOWCFvx0dvvzeT1slICvc1oSQaqwMLtNtjlW8Kqzy8gaYREywuYnud9tAU0vW0B3kMxwbJbSewMZPK9II8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726201877; c=relaxed/simple;
	bh=ao1fG7ryhfrjJLrwjbISDcgrkluZ6rHR4g9X6AezILs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kdwWT/ckTQLrzVwvRUxXINu32eRrq4Nz8LiNvo1z0cYRwy122zX/iuHuROebUiVaSE3zhjMJlH2yUq2rK0NjTibsJwcYl9QCPqp6f/O4xYWLTxLN/x+oUX3QDdhkiysXKmm4cvMNLXDxZNBRJPjbE3pmMTk8oGBHD+CKZCp9cZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JQgHhEG+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JQgHhEG+"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBuJY013065;
	Fri, 13 Sep 2024 04:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wjCw9+7WjsJFbG1zzwMAL/RYU1L4LljC8jXO1Rz6wH0=; b=JQgHhEG+nc7Rr+pM
	rC2nzvd+r0sIuHSpNEwbw9Yra2fwQDKUuC+4MuCaSgxaCy8rqCsPksw97xgGXyhk
	A6+K2/GC02LRcCvEkiMTRWsMdP1jqGUVoL1++w5dITIu5nPaV8RQOx4ELyb0Qe2k
	gZb5ICQZptloXgFYRB90fgy8EA8y8WRerKUcOZUtJQy/DqZLkOz2kFBMf+fPX9wf
	RqstXwvtAGVxT0VmPsrbzWdCqWBExDj1U4ySpJ2xTRRlkEcBgl3vbSLrnX6pm89W
	7YcV8M+8uD37VoPJR8eBfFt+sM6iB+NQPXOu+wW97R4gixYU86eUzEhFmYTZoHWp
	4WhzQw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gy51fd1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 04:31:03 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D4V1ER029601
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 04:31:01 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 12 Sep
 2024 21:31:01 -0700
Message-ID: <6a6c4497-4847-70a1-1f0f-45d071abe9f5@quicinc.com>
Date: Thu, 12 Sep 2024 21:31:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 04/10] scsi: ufs: core: Introduce
 ufshcd_process_device_init_result()
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
 <20240910215139.3352387-5-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240910215139.3352387-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: ZkKxVE9K0B5_BafMmgzNHAov9NXl4N7U
X-Proofpoint-GUID: ZkKxVE9K0B5_BafMmgzNHAov9NXl4N7U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2408220000 definitions=main-2409130030

On 9/10/2024 2:50 PM, Bart Van Assche wrote:

> +/**
> + * ufshcd_process_device_init_result - Process the ufshcd_device_init() result.
> + * @hba: UFS host controller instance.
> + * @start: time when the ufshcd_device_init() call started.

Replace @start with @device_init_start?

> + * @ret: ufshcd_device_init() return value.
> + */
> +static void ufshcd_process_device_init_result(struct ufs_hba *hba,
> +					ktime_t device_init_start, int ret)
> +{

