Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472A9242D69
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 10:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745404942; cv=none; b=H+7gs629f0azoQi2xhssJFp3bPT5w6hW5aOFoF1kpQoxfEIFBu3tn2xTMWfmJRyqCR8k5X7PCKw3jK/ufvEFqvgympkuwttoRYhPkv2Tp627sbXxOsfcVkWDMPHn84WlAfDLg4tjwMYJyAOY66UCWZwL7kQoJACNaGDbw0+PzH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745404942; c=relaxed/simple;
	bh=+qd2CcY6IxK8CQAlvfKvFE8WrtuvDbfJCfTWsUc/asw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJmFnMeaaDda9+jEZkelxOQWlRr8P+mk+6z6djoIwYB8kzcdJFzk8KvbRSRPCYJvI8MMXKm4ODA2i+nlB4N+YzuaYeDAs4GJULVK/BCEP1f5V4odk6tAdyuReBG9/ZA5keJAeSVZQiUZysZg5crw94n52TmIqqTCFI/LAcbLh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IiU+rpCM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IiU+rpCM"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N0iN5I017062
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 10:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B/sUVk9OKoRUIb1LnNSnSHgYKaMS9g0fDBib8P+9OBo=; b=IiU+rpCMYxFJiHvO
	+HIoPm450HBMyp2/oWkQm2mY9CR70Z8whPzjZGhAk/IyZRSfWGH0p9EBggmsGTmx
	5SM6b07V62/6+9pY/ewyDAo2NozPqfZ8ilG6Bfgz4BDVnYZeO8lp1gqR3IaHMQ2I
	/SuIXkgnYcpw1aOYL0rK3vwBmoqZScauKBgvZCAnCwlqrQdeFK69SnunOZuoJVMU
	FF3Tp1IE5haUORVjnilSPfPF6ZWClMianHp0rY9n1eIcVUQqqv2/jR6vV8q+k2jP
	0k1PF3fgyMGPEosjFsbyMBqIeISr9nYC5mNHC3HywwPmqhwtqKAcq1pclbFYf9Zg
	u9hFgw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh3htva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 10:42:19 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5ad42d6bcso127841685a.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 03:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745404939; x=1746009739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/sUVk9OKoRUIb1LnNSnSHgYKaMS9g0fDBib8P+9OBo=;
        b=MSDD5EBTGwM8N5SSr1K5FnNvwVTdCkstJ1+ynmQ08kL1Qm/vYeNig80LpdW/kD4mc1
         L+LU8au1YX3Db3xImVa3PCD/f9aeBqDoDSvpifA46L027/GYqG+5zM3ruiKjEr/NmRWV
         hcUEiufmaYEoppEVvjMCU8JcUgWCr6LfdzbKn6UdWBqlQYekT2Lkv4nSBQEF25UuL9GZ
         Mor0IccudaKC3LocUk85zlMo//hJUnFCzCtCoJ3oEHaEFBYYBQrkob5HuFkzIRsgYHX9
         Azd33pIYdOtJj8K/tRg0paIp3hiC+JoIOJzx1pejSVPwOarKKPabXdASe9/X/6kKFSCs
         iuQw==
X-Forwarded-Encrypted: i=1; AJvYcCXJuYmQxxQnBaUfsDFgrknai7ZBIsZQ+2wIxfg+WIZwYAux2OQiHmTPU+d9VAG/SjCa484L4NRiSEjn@vger.kernel.org
X-Gm-Message-State: AOJu0Yyti0KmHDlbU+SXDp7zIRIigYOJTyPFhZfgq9t02jFw51zWjqc1
	omXHeDDjZzJNa7zFfRJY0l4sOpvAR0CP3NkrOxD/LXF/xLYVldWnSjHOqw28PWpMtmDWN5axXoQ
	ZJtpPLgeB01AjYmdNTmOGd2Lljj7YhjNnI0IkUhy28oqTQHt512BFBZ48daXr
X-Gm-Gg: ASbGncuNSA16RE5tQQ37vwXQvt+92f1dHxQNlo/H/S0rnpqwtq4C+nd0YHFrMC1vXBQ
	xFs5as2Epb9xAouG2xeJzYQIObjwBLhgnKJlNGZAvLjiTQc3ZBZ0ndIHX6WadBXyiCBDQWcfbTv
	yE+fC5QcnrbfpW5dnywU4WsJYFnPE+iNkCZIXW/UPRRtM8OasB8uek9zVwp3oWSK2hKV0N/Mg/t
	euoO+YFJedNM9PUV6VT1eCI93gPn/u4iUJ5R7DjXaKYYXkQL8IEdf25aEReaALnx6K94KolyhwI
	3uZp1Zk2S+jtqip/ir3kOVEZI18eMgE6sh9w7Q1cdxIXHNAJQK9TCJiPuLrAdZ3XMMs=
X-Received: by 2002:a05:622a:2d1:b0:474:e213:7482 with SMTP id d75a77b69052e-47aec49d152mr115859651cf.11.1745404939179;
        Wed, 23 Apr 2025 03:42:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiwe0IYpezKkV2uUZMKDuNbDxC8roBj3sADr4v35lgHslXOIiXv/KaGkpVkodjQUBRrJJZSA==
X-Received: by 2002:a05:622a:2d1:b0:474:e213:7482 with SMTP id d75a77b69052e-47aec49d152mr115859471cf.11.1745404938830;
        Wed, 23 Apr 2025 03:42:18 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625577f3esm7330749a12.21.2025.04.23.03.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 03:42:17 -0700 (PDT)
Message-ID: <3735f288-5ba2-4582-afbe-8b3f5d0f280c@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 12:42:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/9] scsi: ufs: qcom: add a new phy calibrate API call
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-2-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250410090102.20781-2-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: XUYJlNlL4RpNnZcqx2ewQs64A3u8eHk0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA3MyBTYWx0ZWRfX1pIdgSYxn7R4 vQL75PoATF8cMLoZOmw1gAlWAgEpv4RUQqWJTCpcQTsrZC26sZpwLoNC43hgLDgcBmFtzsOdFm+ I1/0Jcj+H7+XAYNGwdqG47cm7WetabeCU9Mcn1ihGZVwVSaBm9+ocMuOtgIsKwXczzKViFk8YOS
 HZLG9Wxg6mOOoI25kRNWZqrFIJr2bEYkqviTl12+Hk35wgHkGWws5CiObXkJdGPsPQ8pIwxU8bq U3eg8/3LpcoLb5ypIZpuU8UXjD7ikRJGdvQQrAg/cTxk+O8vZ60HKVDqQ9/Tj2xDYMQn+bTDQ9F nU1ZOI0DIcfVQ5mcWXK7ipraqOCRat9JGnlYCeFFbsv95xhI+r2guzEQoKToVLfnJTQ26Euqo0F
 8ldvw5252SbPRrWm4AbU5E/WlTwLIedlB07hcHInZ5YW4b7EDbOEGrIrll/NfkfVqvFw6Y9H
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=6808c40b cx=c_pps a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=P7VlLZW0XDfqy93HOhEA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: XUYJlNlL4RpNnZcqx2ewQs64A3u8eHk0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_07,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230073

On 4/10/25 11:00 AM, Nitin Rawat wrote:
> Introduce a new phy calibrate API call in the UFS Qualcomm driver to
> separate phy calibration from phy power-on. This change is a precursor
> to the next patchset in this series, which requires these two operations
> to be distinct.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 1b37449fbffc..4998656e9267 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -473,6 +473,12 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  		goto out_disable_phy;
>  	}
>  
> +	ret = phy_calibrate(phy);
> +	if (ret) {
> +		dev_err(hba->dev, "%s: Failed to calibrate PHY %d\n",

Please add a colon, so that it becomes "..PHY: %d\n"

> +			__func__, ret);
Avoid __func__, this print is fine without it

Shouldn't we fail the power-on if this can't succeed?

Konrad
