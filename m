Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30483341649
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770716402; cv=none; b=W322CrgymTUZ6rW9pSPJJ28aYvOXRqtgVWdnhtTR0sujCtm9RLgAsEngkyqhs5154l82F1a+RmW6MjS/eBWpYaVUIgDa7uzJ9i2877TFK8NeoFJOQ19dZ+FlqT3R+hD92UR+7lagJIfCktugYprd70IVcXviqPCKSYF5QNQRWuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770716402; c=relaxed/simple;
	bh=iJ8I2MLehXxWMGH8SM93i052CBAir46Pqt//1QASbh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rD8fx/2Q+HBboGgcpdsy5tJMJdDnDrQ1lACP6uuy1Cq+rHtpcK19e0eBjTVQRH7dPYmO33h5v6qvrcJYMTdiZo7973ySr1NYgLQyCUhPVrRe5b9clvJQU7hB3VRvmpgrBIC6eAj/RByfnHkuMQM49gnx2JJRBqIvU0kWnexQqWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mLbAddnd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XYEcGnEk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mLbAddnd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XYEcGnEk"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A6qS0G4003606
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0TAMvNeZiQWgcpalJSVZi3FF+L38Q5MAyklwP4Kb4qQ=; b=mLbAddndJbDn5ony
	egOTVcGnWdUyI2FZkelsdXo6pWG2Xk9p06LQyqwgfs8jtv1q7zKoJkESvCZd5Olu
	Xz39JOMVgn4SrsG4UcIsll0CQr7NTMHY/D0L6qmnvwn/ib5SI38kzjTrb7Nda0Aq
	L4LzVAuq2EqosezwVlLyuEm+88a9WfDLxBOxrCMMg2dpMm0DW2iEpG2gFjtOybrG
	/oC+uKEGwUoOBLGbnZApqOcDzBIwUNCAXEWnGGg14kVTpz78X070JJ6hfJHBlw89
	g2UzMyvtUVO5hChmc5Yug9js03JjvYkJ/z1w7JjH6ByLJT79R6hrPdVjKGx003zN
	ATYssQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c7r23j16m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:40:00 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70cb31bcdso105717385a.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 01:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770716399; x=1771321199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0TAMvNeZiQWgcpalJSVZi3FF+L38Q5MAyklwP4Kb4qQ=;
        b=XYEcGnEkYYX6QW12NkiKCvTYOa/DtIlHFi1+Lhzet8ERnvFWxGjvZnzG+OX8ljQ5oN
         98sBosJNd9HBnHtD/qH4YyoTQJ4ycxiKmEPudNX+U/Kx++YcQGZVb76jxG/q/gYAsq2X
         36Kj3DxzFHgiFOJWWFkHAYyi1p2o9jG8DgZ8oleYe3LFCcwMKidSdstgOAONWSQzhKrZ
         8iQ3LVY7YrjKosrkq3NrqDTBHxwdOdHj3cc9MgNCxVeRTze+pR872LYA8f3NriQl1WOA
         h0yeQon7KHFmEMG8N2XHDMQHqd7hpfKI9uuOnNxw+LTxFhnvE8udUZ9jf/aKK0MMIv1I
         oo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770716399; x=1771321199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0TAMvNeZiQWgcpalJSVZi3FF+L38Q5MAyklwP4Kb4qQ=;
        b=sGfzPWfztpSrIp6vb0AC5r2MQArE+ojkPyatMzYolXbDB0Q4GaksleIUqI+ySyIItv
         FaVLVMOtk3PJjMCZHuvwVg/QDN6OBXg0yEFsFcluT8t94i2lWKCEMOtqjfN5nO6G7953
         O8tORH5RNGnSJPH0jqX4Fp8DS9CNwL4DhNmz2mfm8ERMKIyNEvGIg3Ipn3kPxILek9s9
         7eaJs6mq5HId2GZA8EtDEp8RqOFbI/na47t7381s2W2SoreWx0oJt44LFMDipuSOFJnH
         Fk8WRsPtYGrzdGXoqW3KGuJXp9KCN2+6tIPL8DGaj5QnxFfHu3CoIaE+LaCdSXMSVfvy
         lYMw==
X-Forwarded-Encrypted: i=1; AJvYcCV9dctT5iHlfG/ULe0C8QtcRyIbyUAtpjOYltjvl+vTfqL0PWrxQWF5YAnIjwwreNYMpI0Wi6wZGGJP@vger.kernel.org
X-Gm-Message-State: AOJu0YwNlCLjYJZgbN4s3yPil+78VfAD+FsvHwSpx4rNmxB/bCH4cEeZ
	tgOv3LeioQMgs1w6iZej5UqRmbWwXwiqEn3TLuhzkNsv/7qm2u11PNjWrrUqgFj9Ul0lL+VE1r9
	Zf+IRFtMClmgKm/0vaeDLhnl2BiHJKfpx+iUXkcruNQ3f8SK/bsekyBfHkyJT/56B
X-Gm-Gg: AZuq6aL9O7iijYXTAyUPvIeoShO8sCL3LrHBXlbhQVIAG/36cETPzKjln5yWn50v2GX
	g5oEgNRD6MKNSzx2j6RYksPdVkvEHeHOZj6AZcUdc76SNoHB7unYPEEGbLFJIDPhrvkvaqyo454
	5u8hHWWs8rldgeRCTqUPPjWWjx/nVADG7TPCG8mFQ757ugiHqR4s4NkstNb2a7DQ7EIs6UEp8qV
	4kJvb3uA8EBnHlnFE4nWRCa/8gZYzFPAqwJxWv8RDAJ8Bo6wG7oHQXkGNIpo2NhfB/XlDEm+Sa6
	3pGW2UHfdYgGQOYSaaVFg30LqQ5oC/VtmifKli9Vs59gvaE5HwliJO0a3F9ZbzHD0fvrbFxdUjo
	6tGTvWziamswPKqFVVn/ay2UqZdYzpjSgKP82lLqcNY9Cebh/JBYDOF1X7Aw90XjukOakjnUuww
	dSjl8=
X-Received: by 2002:a05:620a:468d:b0:8c6:f7ad:49b with SMTP id af79cd13be357-8cb1fef263cmr107729385a.5.1770716399508;
        Tue, 10 Feb 2026 01:39:59 -0800 (PST)
X-Received: by 2002:a05:620a:468d:b0:8c6:f7ad:49b with SMTP id af79cd13be357-8cb1fef263cmr107727585a.5.1770716398983;
        Tue, 10 Feb 2026 01:39:58 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edae3ae99sm516585566b.60.2026.02.10.01.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 01:39:57 -0800 (PST)
Message-ID: <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>
Date: Tue, 10 Feb 2026 10:39:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: Remove platform_driver support and
 expose as a pure library
To: manivannan.sadhasivam@oss.qualcomm.com,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA4MCBTYWx0ZWRfX/w1hS/LhTH7u
 sdNnFe96EGDnPAZCnaNvwDguOB6OAH40mmR1+ORXky+myBGdD5TxeqxZZUzqCWn8LpAxZ8WeAPj
 +Du1mueuUR0lkuITQ2AhnDLnld/pUgR4CVRt4t8KaISHqoN2qynVGaxWBqA6Gf5fQMo/JctKXiz
 OBTboSB2gyrQO+08w7rnCS7plKX8NPEgzwaYCPKjE9XtIvIgwLsh9cvnRMVumTcdMzSPYxAiywe
 esoDZoFpsunhWyHnj0oW9tM1GvCI1GI0d66ooWHvf6Yx0ha+Km9k2AA81nYVXJzKSYWzJSseuy6
 kbwZrshm+AocHcMA5yov12VQSMO9hpBHyDptjAwV+dZbAxIHHnxapvssksE8AAmUS+2Ko0SY/ha
 JLpy0ht8CwtAHlrXzvxRly1V4i+UCjBMR3rdT8aqPRqWabeSlbmcGMBroVZ9n4wBUHJf9ZHaG7K
 Wr1oYgYH5EUKE+YGcWQ==
X-Authority-Analysis: v=2.4 cv=MLRtWcZl c=1 sm=1 tr=0 ts=698afcf0 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=Oy1HdLtELvYQmIkUJ8cA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: 5UNkzn1UNkaiGP4OP02e2PEKN0OdDOCP
X-Proofpoint-GUID: 5UNkzn1UNkaiGP4OP02e2PEKN0OdDOCP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100080

On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> The current platform driver design causes probe ordering races with
> consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
> probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
> with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
> be gracefully disabled. devm_of_qcom_ice_get() cannot know if the ICE
> driver probe has failed due to above reasons or it is waiting for the SCM
> driver.

[...]

> -static void qcom_ice_put(const struct qcom_ice *ice)
> +static void qcom_ice_put(struct kref *kref)
>  {
> -	struct platform_device *pdev = to_platform_device(ice->dev);
> -
> -	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> -		platform_device_put(pdev);
> +	platform_device_put(to_platform_device(ice_handle->dev));
> +	ice_handle = NULL;
>  }
>  
>  static void devm_of_qcom_ice_put(struct device *dev, void *res)
>  {
> -	qcom_ice_put(*(struct qcom_ice **)res);
> +	const struct qcom_ice *ice = *(struct qcom_ice **)res;
> +	struct platform_device *pdev = to_platform_device(ice->dev);
> +
> +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> +		kref_put(&ice_handle->refcount, qcom_ice_put);

IIUC this makes the refcount go down only in the legacy DT case - why?

Konrad
