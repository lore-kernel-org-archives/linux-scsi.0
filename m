Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BDE1F09A8
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754035458; cv=none; b=DQ1tv7+cU0zw3fa+JIIkpwZBqMMMGHlT7Ww2eVkmVor1IdvuJW/oFJg3JWcMPolINh29zuejP5eW6y8Fc2EuGnXfB6hiaLK+iiY/1CjcSntVJvmAgCzcJvVl+cHBOAbGJeB2VIMd2e9VN4TCXpGZTNDK/mNTE9DwesKuz/nTAR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754035458; c=relaxed/simple;
	bh=nnPCEfYl7P0n5cYp6ZV/HA5gOBYtTEE/RdugXDbE7l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JusZ+xQRPuOxXl4CH2E/L8oFDtacnp2apmEO84CuaH7QGv0F6g+yGgUnYbbQt/RsTXj25+0YGkwtCcNmHiqwC8kMZEpFmzjkf/PnZawEBkles4HEj2g66CIPrUGIQhUYIw53+xHwIcjDux2UTn//li0vL1wfoF/I6nOtYbdEMI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BOTaKfpJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BOTaKfpJ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57111LHV018862
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2025 08:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hkiPQOuq40Ps/bo+JMPRlBp1hyPYRZQxi7RXk1U3VoQ=; b=BOTaKfpJmYOnbUQk
	uFzj0TPh++pjY/1FfMbW4voVJicNPRRFTDhAxi05EgxlTfLVe6D/wP4kFgFElnWe
	warK4+7jO7r9eHC9hh/OYMAQoC4tqOwRUQS95i2lLn56ZMlzZe8Dd44bjs9izYKy
	1peD/xEU8szpcg6aruESTF8YSlpzIfqYAF55ZQ2Ox4uW4AjdgdLi34g9bdBdOMXC
	8BTLn+zNrButUUBk5d0LPjoI5EPINlT1tVnX50hcwcP9iA+SoQIwDk+Sr8qQ4Bl+
	/ipAusevWDGB68R0HWVOMVWC0VIbF17aCYw20lQomsC4trZzEo2O5PurLhBQbgqU
	KnJ1QA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 484qdaav27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2025 08:04:15 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b423dcff27aso550326a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2025 01:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754035454; x=1754640254;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkiPQOuq40Ps/bo+JMPRlBp1hyPYRZQxi7RXk1U3VoQ=;
        b=LX4XE/FIXkjCMzpo1A2ROfgTomuiVo73n0MwLurDZ4I+BeVUdYybKEDpa1eLEPOGLs
         2fCR/ohT3oV6QULcTkYSWF+jVlyGccXRej7d++wE9h8toAOzzj0wBGTPKO+moCDxsavH
         qCEbJmH4HSKo5shUlKDsGpDltKypE69hptX0fcW/MI6cbMb+5YoyNu+SXdQGejxkxA2z
         SQoPd2DeSh8R0atG9ugbxFUo/wLhvNstCNsqjL+P7A3wKykakLfYe03UCGtPW9gd0FzA
         ns976QtB98PJszhmP5255YH+G156U9YF/oOBxPKatxJPqgmPEgn7pwRyTZwOPniBmj0s
         sQXw==
X-Forwarded-Encrypted: i=1; AJvYcCUNPlIW4DgaDsCjGDBbCBvxns/MqBilKKha1WRyca1Eq0qv3vrMH5OWMokQ2PLbuJ6+8UENY1yK5MlB@vger.kernel.org
X-Gm-Message-State: AOJu0YxmH+K9YRv/RmHbGVqlqZj6hbU2mXrK+UHPHvNZxiRFCBRMlleD
	jeeiUbtCNY1CAhRPGOg+vGfRrp7J9sWQ3yMnSi78zTgFjwfF+I53uIHi/1y98wvZJHP7vM7ZoaE
	B/YiEkwhwzQmt6t/fMYHcf/FPfzImcqPfVwoLcB5GmaRyECNtz53yksWiW4uapL5D
X-Gm-Gg: ASbGncvTWnqfxx4NSldXPQpNSQNAPJ/joiIjfm325kVYQiYZcyByYUsqjhxhvmFOLwW
	qRoGaABdGz2iaEPLrAnxdJqbieEdGuo4q59Qoxn/0B8Di95aLS8qtx1qAiHibgEIfCEOE4egUbl
	OeBjwP9qJArdx3JjXmKaRi4P2DmqH8qFkO5vbV8EslpZ29Pwsmxmh2md5LZZPXduZUmSg2kZfKm
	mk/S1tEbdDAD9/ebeiNYCd64hRhBYonJz3ImweKTmQCziUajzrupusJz8wNdDV5t9xvdWgMafav
	cmg2gktmsWapwkGeI506ZwO5xzODR0THHEs9/DJTnDUEvLgmqt0wGHSNqLahOvlKVhoBLA+50pP
	WPy1pX7ewsY+B2DbqSLqRBFGL
X-Received: by 2002:a17:902:f2c6:b0:23f:fdeb:416f with SMTP id d9443c01a7336-24096b680afmr123067415ad.35.1754035454644;
        Fri, 01 Aug 2025 01:04:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeBFR6JRo/H9wRlRFcU/kwFK6wWe7Gqnlyfk0vlX/82+g+ocbEP3XFMzwGRpeP6fp8RZwjHw==
X-Received: by 2002:a17:902:f2c6:b0:23f:fdeb:416f with SMTP id d9443c01a7336-24096b680afmr123067115ad.35.1754035454279;
        Fri, 01 Aug 2025 01:04:14 -0700 (PDT)
Received: from [10.133.33.163] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aaadadsm36703015ad.156.2025.08.01.01.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 01:04:14 -0700 (PDT)
Message-ID: <923e52fb-fe4a-4c3d-9526-fc8536a28f28@oss.qualcomm.com>
Date: Fri, 1 Aug 2025 16:04:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 14/14] ufs: core: Inform the block layer about write
 ordering
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250724215703.2910510-1-bvanassche@acm.org>
 <20250724215703.2910510-15-bvanassche@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <20250724215703.2910510-15-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 6A5sLRHrMxgpKgKP4lThWffIWFdx1GLj
X-Authority-Analysis: v=2.4 cv=Pfv/hjhd c=1 sm=1 tr=0 ts=688c74ff cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=JF9118EUAAAA:8 a=COk6AnOGAAAA:8
 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=EUspDBNiAAAA:8 a=vGqm9230wn-5tKDOnP8A:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22 a=xVlTc564ipvMDusKsbsT:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 6A5sLRHrMxgpKgKP4lThWffIWFdx1GLj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDA1NiBTYWx0ZWRfX9LsAhCC0eDQ2
 gbCLPfgO8RCksTqrWBHt/LthRnH0dn+WIqviCDguFP5BwSyd9i30U/7OOLL+/koLisqjfyAVYym
 FlnXPSqavQ41K7O0kZ6gmrTyKh7CR3poONKm/eCYps79c8c7YT4j3YSRvbdQnEW47jK7nvYpQyw
 OETbVGLAnGDnHLH5hnT8wMvcKFgpBDtJyWYhIZFrTYnOb837JsLA4U5LZfsSq+7LbkM2wp92Oxj
 zYWMWa1q4C8OpPHoZIrfsDfh77O+J3NXPCmRctGH6q6fapISFbL3qxy7rnppwsKRPLjzwO2eVUM
 R9k4eKGtdQ0Qd8AIeyvPvzxNwe3EhpIKswy2gmwX/F3cQAIYD+jDHjwRayja0XjaL/mYwDGAy//
 WQQSv3rJQW1sQzuKlgqPOz/sophZKVRrYs5pGPD5QTmKO0ocNr0HGvMVpCb3dEyBjhzv+PaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_02,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1011 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508010056



On 7/25/2025 5:57 AM, Bart Van Assche wrote:
>  From the UFSHCI 4.0 specification, about the MCQ mode:
> "Command Submission
> 1. Host SW writes an Entry to SQ
> 2. Host SW updates SQ doorbell tail pointer
>
> Command Processing
> 3. After fetching the Entry, Host Controller updates SQ doorbell head
>     pointer
> 4. Host controller sends COMMAND UPIU to UFS device"
>
> In other words, in MCQ mode, UFS controllers are required to forward
> commands to the UFS device in the order these commands have been
> received from the host.
>
> This patch improves performance as follows on a test setup with UFSHCI
> 4.0 controller:
> - When not using an I/O scheduler: 2.3x more IOPS for small writes.
> - With the mq-deadline scheduler: 2.0x more IOPS for small writes.
>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 50adfb8b335b..6ff097e2c919 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5281,6 +5281,13 @@ static int ufshcd_sdev_configure(struct scsi_device *sdev,
>   	struct ufs_hba *hba = shost_priv(sdev->host);
>   	struct request_queue *q = sdev->request_queue;
>   
> +	/*
> +	 * The write order is preserved per MCQ. Without MCQ, auto-hibernation
> +	 * may cause write reordering that results in unaligned write errors.
> +	 */
> +	if (hba->mcq_enabled)
> +		lim->features |= BLK_FEAT_ORDERED_HWQ;
> +
>   	lim->dma_pad_mask = PRDT_DATA_BYTE_COUNT_PAD - 1;
>   
>   	/*
Reviewed-by: Can Guo <can.guo@oss.qualcomm.com>
