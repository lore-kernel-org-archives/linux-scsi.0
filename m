Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083AAA55
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725708504; cv=none; b=uW5VH4/cF6yv237MpSTPZGDwqC9qCDy01zkYHoRYgxFj1yEP7Z/7d4mgU1FMz9ZkA9DsZAZsxG2HaW+aPnF15rNfrtraGndxp1D1cVEQkQKwRkh+/6dFSPikHh7LMvwwn6wYfMUVHHo3sn5+mwdM4XpfzlJG9jlgrzYouw8NXJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725708504; c=relaxed/simple;
	bh=7RIj3V/DMVTw6HKIpIephCeEP9SLLzL0oIjiWcg5yjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ibkXwe5Cuqfc0xMzyQY7U7wyhWarv1+/nqGZE0LQF2Kd8zwn8sRfJgYao87xXKwxwJ0NKAQHjmm5o/SQ8BrO/NEfkL6fuIEMJ4DtIjXs9vaYaG31STtO6AWYHwIJpryCW1mf7Ziwc+/QBn25Z6+yGh82T0ZhHeLNirfvTISQOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=QltI8ubb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="QltI8ubb"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 487AlQLD005948;
	Sat, 7 Sep 2024 10:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WHv+z/5vHHSnNU3Zfjemt84Oo6QexxFa6s/OhPxtF1U=; b=QltI8ubb1vrh6lUm
	Lhtmc/Y9ny+w5Pm/VPVJp2nCAlflQjTR5cS7bNKT5rywInFFKGl4rmZjz274wxrz
	AqF0Gr0VBXWDDz4tWywrFjz+4RlAd5Ce6QhFzMmFVTzArcVV38BG4aEyXRp3Y36H
	3De6MiKL+tPGesRgy+QTSDH5amRp3nDCGGy+hETKoyuH81u7w1LdjHtvidcrl68t
	yyxJ/AUlYq9snW14YJSAJPUCFFTenLX3lLrNAIw7fLIE48Y5ikgKtCRwslDVvTp3
	r+UdokJIu3aDyFH8Idosh5rZ2+3Souxm9Fy5fe6C4MC6FSQ2srKmSA0LajR35ZYn
	n0aoTA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gf758edh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 10:52:57 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487AqtGo017982
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 10:52:55 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 03:52:55 -0700
Message-ID: <d68d0f7c-ce71-3973-cf72-e789f0916ca1@quicinc.com>
Date: Sat, 7 Sep 2024 03:52:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 04/10] scsi: ufs: core: Call ufshcd_add_scsi_host()
 later
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Bean Huo <beanhuo@micron.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney
	<ahalaney@redhat.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-5-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: oplIUMsUG_w7lLacpNDhgV639ifREwdm
X-Proofpoint-GUID: oplIUMsUG_w7lLacpNDhgV639ifREwdm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 mlxlogscore=776 bulkscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409070087

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Call ufshcd_add_scsi_host() after host controller initialization has
> completed. This is possible because no code between the old and new
> ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
