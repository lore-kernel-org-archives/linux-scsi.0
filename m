Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ECA623
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 07:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726211382; cv=none; b=oHIDKI4sD4sA6YpyO/BrozX9SVqBbtKC6DtsY8hXXiLEbbMqRXlB+DdcbMFu/ErCy4ecU2ciqZQza2G6868YkjR+pSuwes/oEfYHvDx9p4jBFQPZBPZmZ+UFnaZ6V+jer36piOc2TyDM6EQOvD7XqqscMO0qdw+TVMFlf1PwJX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726211382; c=relaxed/simple;
	bh=WgNo8f1omOOSErvtwi6P+CgUxgaR3AQUNuqek2pW1JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HIxQyurGLtSVnUYwL9sLBXaFn+0VQAsGYHBAYuDQcEkSp3n82peN8oGqcQDpsWkxUMfGqwjRnOPkWanhtYBBLenv1cuDzNDpzQAmL8TTjC4Io/+4EMt4uQbzMG3joAZjdsIkys7mj4H0V0kLSXbChLGY2bmE6ba2RWSNbsGNls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nmFmaq62; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nmFmaq62"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMB5pM030116;
	Fri, 13 Sep 2024 07:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	izwfmA+9AAo6Xv0i+gJbeJJiILLIJXXfCPZocAvJ2Xo=; b=nmFmaq622hkIJY/b
	lEp2G01dam7cGjcHqPuE15BeB3MBQ0XMut8u4nwM2nADzdMkPMhJ7eNMPeP+4+No
	e14nCiCf7KmG7gvb4SkVCtbectT5URhcOeKPwOXfYwYRDoJwowsBhiLsIw673omT
	J7VMPpBjTkCIqMkC3LjUp/3pEYcyx3qliWsgHuc5GEpIaixX6FZP7bzjLSVsZJjl
	sKNnMzrlVQR7cZJ4+//oQx1AP3ZjFyT8b/v54wlYtBgUMsUqhxO8mU0eg0bHTnNe
	t4RwmXKPb9sCw8v3zgU0dwaF0uwPWrdUux7DW6kv7gxKbwf+X1WK2GL/6ZhykiNh
	P5VnvQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gy5a7wys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:09:28 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D79RUq024674
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:09:27 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 13 Sep
 2024 00:09:27 -0700
Message-ID: <24c0c685-08da-e765-7537-dce6cd6c2692@quicinc.com>
Date: Fri, 13 Sep 2024 00:09:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 2/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to read
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Bean Huo <beanhuo@micron.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
	<matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew
 Halaney <ahalaney@redhat.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
 <20240912223019.3510966-3-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240912223019.3510966-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: p7tvrCU_D9viAVQMCH__qzSPL7nBZHLF
X-Proofpoint-ORIG-GUID: p7tvrCU_D9viAVQMCH__qzSPL7nBZHLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=855 phishscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130049

On 9/12/2024 3:30 PM, Bart Van Assche wrote:
> Introduce a local variable for the expression hba->active_uic_cmd.
> Remove superfluous parentheses. No functionality has been changed.
> 
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>

