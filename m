Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C5E29E114
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 09:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772356204; cv=none; b=Isd96wjPC0pmcBwXeAREZTcQdYmAFSMLZZvqD1VHD5pumuCUTEKMOVuMC07xhWK24uCN9P36yAPTDd1uMR9dm19VtMG3R+izAGwpNqdUVtQJJjVZhvn4Xzgt7mHgUuA6zB3co9oqU34+CsJ5/tvVF+al0YIbr1zxznhOkNF8UPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772356204; c=relaxed/simple;
	bh=yd0din2CFhkKc6+zQGkxU54A2Oz7x7hnyXhQR68IdOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXaaBuG9FgPR0QLW/3JclOiLMr7M51uQwcTG9fnNa1LN8V+24G3eQ/4fSbn9WeEjFMQ77RKYrkfz22CQaAPa2akzb0YHj9HUaiQUKPb+mE4pX+eY+x6tmlCHpSqct9ZKvOWsIly7/nIO/UZiGB9kd8Y2fx8paAVfbFgDZVmmO30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IFyFbzdU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i7YJ0Imh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IFyFbzdU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i7YJ0Imh"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SNAOR41645460
	for <linux-scsi@vger.kernel.org>; Sun, 1 Mar 2026 09:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cqpnCWSjrXNGU8tQQOHKsgYLZa/58lkhtss7lhrdjvA=; b=IFyFbzdUwfgg/Huy
	GuI8UEIY6aphYLR+UYDhoCHn8mTir0Qjedomelc4gx9q/8KVUtrL7VH6OcGosM1n
	tu/7l19exG5OGAlwV48e+p46AddcMXyG5WbUQBRMGGjB5g5s1UtF3QI0J8ba+wYc
	VLl9DfcF3JnDBxtXyY5Htm+Y+GBGKbKEahXYsmTR9Bf+uxAbCBSjnK3BGkFrJu9G
	GczYAD3TPjPNCooJM4Spl0DRC7w1TFlaG5MsIeLGgFbWf9hwkSx7N+Zz5o2bHqNS
	lZZ9up4+l4KsytwZ0VF7koOENFE8+5hao9/aiYbn1I2gZtaNVLqSeisueXQ2b9dD
	Iuanog==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksf8jghf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 09:10:02 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2aae146bab0so50035325ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 01:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772356202; x=1772961002; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cqpnCWSjrXNGU8tQQOHKsgYLZa/58lkhtss7lhrdjvA=;
        b=i7YJ0Imh/TOjpfhc6XUmvPwGp2KH+wAy/KNHC20el9+XhG5O4+tcF7Xiais9k3IG+J
         CSCyCY5fWmVn9eBCEdV6Ng6viT5qfSwM7u2r1xtymv11ePGm6jT+eyYQKWOPx1/TxHuZ
         wvQFb3qXViNtVXg9O3pVbnxTchbZspzXd0gJl/2vNhD9RY74He1RA/4XsmuyqKR5myup
         xt0ETZEUURQ56AT1kaJrW//MnnapEj55vg9Pz/Y8a52fahS6n6PoXT8rFMIUwRk3ZO+V
         BEpEFFfvW0QIH/l+tw9FjxLpi4uKrb34Btlbhsd5Mxdd4KkbJS5WMoGUol005nzpoDjc
         csTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772356202; x=1772961002;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cqpnCWSjrXNGU8tQQOHKsgYLZa/58lkhtss7lhrdjvA=;
        b=F+Z3YhfJHkj0hkg+7TGaQZzCuYaw9tCplCKSMIGOfUhYGvx8GnKK1TknoBzmkZQPR5
         sBEkVnyFOhHRLbLwHCTXkwhM8jF6SHxf7yjm4RTh5+zKoiKCh9fFHCPAPSFFEVVLIJI4
         cu6+q34F7LFPRgON8+9O7HHBjYYMl66lOt9rBXYyYdlaa/7P8gyL4S/fqgPVAXyfuUTd
         RSoCYMuw6LIJRa3NIrJPxhhXIIXfwgxkrH/oR9g/c/8nQBgJQ1XX61IV4SJ395Dicu+V
         2NASUNNtPm1AkSGMOOyd6+NJ1AW//bWwWPzigNWjCECl4z+jaDAluDorh9nfNjYxFbV2
         gpcw==
X-Gm-Message-State: AOJu0YzHdyKBFpjnerBdEGs0ujYlzfeMDLSx25Io5tc+spDPyUGokEQQ
	37sztq11H29yysB2dyHVVbjeR5BmyYM7jJ+k/lhVPOk7oqh+ru2QxYKdcwLuOcbHWmfSmZ+Lq6V
	NA9CDjdiPlCwcENE2sLOoB0JY9pGhrLMFR76FZHW2QnxMwkRJBTBKVl1AcPOFz1zw
X-Gm-Gg: ATEYQzz+cqi0CbFM+gGeL1Zs0hez7CuSdhZxKn6T64loPrfyHf9YXZnra07HyAYh0Dr
	PeC2eB8gwY9Mny6RU3V4n7MRtMOqUWFuiv+NstIk36Vs5imvho8LXVnbAKruKtvWH5EPGDxuSBJ
	zD0jj7GbmLXGUXNHJY6ErdJT/CFMrn19/sCMBWoCLdjrFKvZEqmpT3H1DvRL6qa0eHMT5b2yDHL
	FOYhoahJOjzLubiD//9w2n4sguPbEF408YlbuGPXfQCJJvE+dZ24GPVzG1+U3ZlDUyXoX7xvKZg
	iNSSYLfBmQShA5OLzz6YAe5Ko9r9wGgdWId5vHgBbk+vfve+yh2ejZngmm6nAqQUgx5pYhrr4Zi
	hh2jvNbQoc8AqdbSnDCqChgRDg0AaFqIEdJek5w+tP3wIEsI=
X-Received: by 2002:a05:6a21:2e15:b0:394:6328:210f with SMTP id adf61e73a8af0-395c3a471bamr7757445637.28.1772356201877;
        Sun, 01 Mar 2026 01:10:01 -0800 (PST)
X-Received: by 2002:a05:6a21:2e15:b0:394:6328:210f with SMTP id adf61e73a8af0-395c3a471bamr7757432637.28.1772356201402;
        Sun, 01 Mar 2026 01:10:01 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa8016f9sm8871197a12.17.2026.03.01.01.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 01:10:00 -0800 (PST)
Message-ID: <9b30afb1-c38a-44a6-8a17-3073b5d408ce@oss.qualcomm.com>
Date: Sun, 1 Mar 2026 17:09:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Huan Tang <tanghuan@vivo.com>, Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Liu Song
 <liu.song13@zte.com.cn>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Daniel Lee <chullee@google.com>, Bean Huo <huobean@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
 <20260225022942.345564-2-can.guo@oss.qualcomm.com>
 <72cd1fba-0f7d-41d3-b933-88eb8fe861fe@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <72cd1fba-0f7d-41d3-b933-88eb8fe861fe@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDA4MSBTYWx0ZWRfX65EkmXGNqWYa
 HNniaKKL20NFDOa5DV9/DomP11ijtf7C2QnQy21ZbwPUawqvHW/QyzohbvK/TOaZWbGZmd4gFjZ
 PcZrorQbyg5Hiv3ceYvHmwFqaH4jhLbO8lR+PRQAIYjpSJcB3+8e8cLnTyFHaU2KEEqw1XYV/ey
 DEpmC3YJxv/O1a9CxLYkMwx0b2FiZ1eFvNcabBMM91MCGwIzk0rpvu6bly6MSXScoCU1l4EpTjD
 nOklbChv0jn72rVbqJcv0ZgM/TckTtCCD6qXeMfNmizuo2lvoyFOmb2wSvF+ei2bY3nVNDB9RjI
 aSq2zhkKtzhnPiEO/54jNlMksd00cAz+QNWXPvZH6a1vRi+mi04gMWo+dZypGOZUauicNE+pVIY
 lWNwa3CvPbkI2Nzg0KScTyDoNz/BeFuTOwVBA0pRJVGAXIHj/7Zm8fxbC9L8PF+aJgU/AZ642Ji
 kjJeZWAd2amESaPvGug==
X-Proofpoint-ORIG-GUID: CjNP535zL7JdcViA-8j3k2lbHgDLErjv
X-Proofpoint-GUID: CjNP535zL7JdcViA-8j3k2lbHgDLErjv
X-Authority-Analysis: v=2.4 cv=I5dohdgg c=1 sm=1 tr=0 ts=69a4026a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=cbjCF3xpEg4mx4SGrvsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_01,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603010081

Hi Bart,

On 2/26/2026 2:48 AM, Bart Van Assche wrote:
>
> On 2/24/26 6:29 PM, Can Guo wrote:
>> +What: /sys/bus/platform/drivers/ufshcd/*/dme_qos_notification
>> +What: /sys/bus/platform/devices/*.ufs/dme_qos_notification
>> +Date:        February 2026
>> +Contact:    Can Guo <can.guo@oss.qualcomm.com>
>> +Description:
>> +        This attribute shows and clears the DME    Quality of Service
>> +        notification from UFSHCI UECDME.
>> +
>> +        The attribute is read/write.
>
> The above text is incomplete. It should explain that
> dme_qos_notification is a bitfield, what the meaning of the bits in this
> bitfield are, when this bitfield is updated, that the only value that
> can be written into this bitfield is 0 and also what the effect of
> writing 0 into this bitfield is.
Done.
>
>> diff --git a/drivers/ufs/core/ufshcd-priv.h 
>> b/drivers/ufs/core/ufshcd-priv.h
>> index 7d6d19361af9..14e8cb145f43 100644
>> --- a/drivers/ufs/core/ufshcd-priv.h
>> +++ b/drivers/ufs/core/ufshcd-priv.h
>> @@ -446,4 +446,10 @@ static inline void ufs_rpmb_remove(struct 
>> ufs_hba *hba)
>>   }
>>   #endif
>>   +static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
>> +{
>> +    if (sd)
>> +        sysfs_notify_dirent(sd);
>> +}
>
> This function is very short and is not used outside
> drivers/ufs/core/ufshcd.c. Is it really needed to introduce this 
> function? If this function is preserved, please consider moving it into
> drivers/ufs/core/ufshcd.c.
Done.
>
> > @@ -11044,6 +11051,8 @@ int ufshcd_init(struct ufs_hba *hba, void 
> __iomem *mmio_base, unsigned int irq)
> >           goto out_disable;
> >
> >       ufs_sysfs_add_nodes(hba->dev);
> > +    hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
> > +                             "dme_qos_notification");
> >       async_schedule(ufshcd_async_scan, hba);
> >
> >       device_enable_async_suspend(dev);
>
> Where is the sysfs_put() call that corresponds to the above 
> sysfs_get_dirent() call?
Good catch, I missed it.. Will add it in next version.
>
>> + * @dme_qos_notification: UFS host controller DME QoS notification
>
> Please explain also here that this is a bitfield and where the meaning
> of the bits in this bitfield are defined.
Done.
>
> Thanks,
>
> Bart.

