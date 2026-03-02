Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAF430B85
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 00:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772410554; cv=none; b=ns48a6JRSYpDlRJ/8L9+pg4A0VtJIn2sxL0nfCDq88PJ7AjQDweCDITBF/7uSuj+RQLnttBbDbfm7P4cresRITObAYgRuK4xIW8lHykN1KqHac/qv6rB2pjBU20+pzuFZRJJKWQ+F0dYHiis2eYF1AR93BbZdK6S7A5mniaeypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772410554; c=relaxed/simple;
	bh=ybW7ZGIqp8Cj3D0c1tJ/QKxtNDpqm5IigPIVWWekitU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJt9TGO8keDbh2wt/97nK2id/3cZeEuEfSX1lT6p6XHUoUVmpk3vyHeq1sEHRGcTKp3XTb/pzXzmHsxaHiI3CzmORSI6OPUpGw6Ykn0phEuOdDuraeZsNNSbnitI/ZloMb9+uKKKGYmLhzLTjqv7KaB7cRcpvb8DodERJg3x8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CLibOj35; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fnAIchRr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CLibOj35";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fnAIchRr"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621BJ4fs1021251
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 00:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oBZuljD/+5TcXwhWoGNRFrGUV3OJ0gks35QtMWEwRDI=; b=CLibOj358az11iNu
	my+7sfE+tfLmzugD6ZsrX+Fz/sytJJuWg3AM8HkNW6shh6zg0EdFjQnDOSt5W8eE
	NYe227IFbhhsRnUD1jUTl0pwBWJtCFXAIo2n+dgUe7+hT1CqToItVHx5JjqfIfSU
	/ltgdt3b1Aunpxqxvkvbp7mjVv/fCNOMQ2Oi/8pe3+QVyC5pmYV/0cNOwxWt+LWu
	k0bMSUvD32CSNVgkf9ruC+5l2YQUyBv5fXXPW3sEwu+SClFmj/w2ZcOX86NDaYqp
	IJA1yxik+c5bEvTsUfLZ5DRWsu7lQ3Ww2MrVy9iiuknpCi9dmfp/nn2J6IhcD1ur
	ya9GdQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksgrug9a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 00:15:52 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ae415b68b1so12630855ad.2
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 16:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772410552; x=1773015352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBZuljD/+5TcXwhWoGNRFrGUV3OJ0gks35QtMWEwRDI=;
        b=fnAIchRr+ufq/YvbWpG3p9iRB5o2POSY3Ql909hhcF0NQVk7WqkJsV5irPmVGfDnKJ
         aX5pKYc4ZxZI4WbGTb34VKfxgWy5otHyWpYiio4gj8qkJ+03hgaeZpq5qdKzJXtKwQTM
         E3m2CBwG8FKKeQoo5hts9EvGHKxqSDRNIGLr48h75bnSViVfbZn7eGdNKqEPUktCQrgk
         MouNxAVccoL1X6r3VtlQRbul8B+U5MTNLiACX5VBvODwyBdhj+9VS9ass/BlituNKgeQ
         eO7Fe+JZj7PPCVYIoLte4CjXfK/SRiKdKqvslnmHdE5j7qWeM+qFnMjzG4glg8Ws4ehv
         wBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772410552; x=1773015352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBZuljD/+5TcXwhWoGNRFrGUV3OJ0gks35QtMWEwRDI=;
        b=HsePk9GSKWFEaPK5kzEAvb5KHuBDfsMcOrlxqPK/sxT2sRFqLLVqrgT496XU6B0mSi
         JFSumauqEt0lFJACplvoWFi7JCNlYG/SmDLKLgMWXI3FvHyw4Qn9YhOqCowkcEVaT42V
         ybOyG2Ax0JX5qyJvDIYnbsnvyEjmTq9upv5C522UiTB7Phu8TcOPJweI2JCNfWsF/Mqk
         EcYNOqtruufR9ipSUlQ4uduX7+hOvyr6S7A1k2gy5vYT0QGWs33lHZ8CE4wwxdQILmpm
         TYNMSzghTNpgYIY8/s73yUQTAtmT0SE0WsakGlQ4/+J7C2VHg4XQZE9qxfKQc8pdGAFn
         2Q1A==
X-Gm-Message-State: AOJu0YxQqKRnHguLsIIK0OouZVh3Xywnv0sJ6MAyDhqMkAxmC+R5y/5U
	ZqM0wXfLmxf5c+r0Fm80+aJX9WnNYD9sHVF0sITqUj9VL3ggk7B5bskhn5nKRaXwTqxwZFr8kUI
	Zg89LiA3+ibzWO3lnEVIh98S5KuOBEnN5Zs3p8LgvEVvkYSQ2OSau3uaScraRoYSt
X-Gm-Gg: ATEYQzxb4WlfXjmboO6VP6Zu4MBi8LPftWDQ7oQmcSadOxEpXqO08jHwI0YmciQykvw
	S+lJoAOGXOmYkNYndqzOY6A7WTggTzzBfsBaEIjb+60LINTGAPli76vHD/u58WRz0euxfe6DTen
	RG7UD3H+oFGKFFASxFRA5Er+pTouzBwuZ70DkvdzGUpFXkPcRVWoOw7B8WJ/6xtX1IFLQFsde76
	ZktTcZFOtiOcN3fv0CVj3hYmRYsan5rn8Z4l4La/ChxuNc5og2sU7DkzCzlUP27gAixpXo3L45L
	4089WSwoyWt76dbyXhJ2eGTq7X9jtoiwRloAxuZePGtOytVDCcqOMgw7fPIEokAopn3fFn3GqH8
	o0EtVgaSDHNZ4O/VgvH2wsqejP/1Qx1ahfgJBW/BemCdV4I8=
X-Received: by 2002:a17:903:3804:b0:2ae:3b36:23e7 with SMTP id d9443c01a7336-2ae3b3629c3mr58200985ad.16.1772410552090;
        Sun, 01 Mar 2026 16:15:52 -0800 (PST)
X-Received: by 2002:a17:903:3804:b0:2ae:3b36:23e7 with SMTP id d9443c01a7336-2ae3b3629c3mr58200545ad.16.1772410551609;
        Sun, 01 Mar 2026 16:15:51 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6c4dd0sm120565185ad.70.2026.03.01.16.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 16:15:50 -0800 (PST)
Message-ID: <e2fe080b-c935-4090-88ce-f8b8c15b6efa@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 08:15:42 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] scsi: ufs: core: Introduce a new ufshcd vops
 negotiate_pwr_mode()
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        Ajay Neeli <ajay.neeli@amd.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Archana Patni <archana.patni@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-mediatek@lists.infradead.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-2-can.guo@oss.qualcomm.com>
 <9d975881-7570-495d-94ea-085e2012a9af@acm.org>
 <5a2961af-dada-44f3-8e57-119076f10750@oss.qualcomm.com>
 <3abcef32-f872-4aa5-a7e1-c99286f426aa@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <3abcef32-f872-4aa5-a7e1-c99286f426aa@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDAwMCBTYWx0ZWRfXywShgdYo3TkJ
 yuF9grnu0BZwbF3/5HyOqd9imSlVnKpNaWLVyh2kdMfaDpC3xrsbUnBQO3N5FEzlNgFJWz7GiOu
 KXzw8n896z6JOdrLHI4H6ULYgZ2vN0uF89QjTzhsp8JAXbLY6CPwjbazVQkpOAcvm/S1cOVoqxq
 N7316H2SQ4iV0uSql9j8IIT9FduIdjvXtEjWBoOxz86OPQnKIEbxk62Uwx2SKTYknffvRNS/uaa
 qEpqacD91h2q3qZnuaR0lRo/Mpybqizx3vwlEnYgA7HoFXyHk0kiyaN4qC3lCFuPz4NYWC4DiFk
 FLxhoNaZ8Mgc2Um/wNK8ZISCY3n3/3MaRgkMZwJPPXCPg6JxKMyCEIJyv/aNWBUYtCEu2dayLY1
 feJ/pRX3cs0N77h8oRqN0GlfKMwqNmJorMk55mkBAPdlGYYFYKuMQjxHlR+qWrdWyuCCpHgLUfa
 jVIyBSp49A2/UGpxD7g==
X-Proofpoint-GUID: Zxq8gmMV2zd9etg_r8QK0BT_LN0rRN45
X-Proofpoint-ORIG-GUID: Zxq8gmMV2zd9etg_r8QK0BT_LN0rRN45
X-Authority-Analysis: v=2.4 cv=Zqzg6t7G c=1 sm=1 tr=0 ts=69a4d6b8 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=3hymWB_5rKpTfOV4Hd4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_05,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020000

Hi Bart,

On 3/2/2026 1:51 AM, Bart Van Assche wrote:
> On 3/1/26 6:26 AM, Can Guo wrote:
>> On 2/28/2026 3:31 AM, Bart Van Assche wrote:
>>> On 2/27/26 8:07 AM, Can Guo wrote:
>>>> -    return -ENOTSUPP;
>>>> +    return -EOPNOTSUPP;
>>>
>>> Why has ENOTSUPP been changed into EOPNOTSUPP?
>> I got a warning from checkpatch.pl when I add the new vops, so I 
>> changed the same for
>> ufshcd_vops_pwr_change_notify() too.
>>
>> WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
> Hi Can,
>
> SUSv4 = Single UNIX Specification, Version 4. This is a standard that
> defines how system calls should behave. Hence, ENOTSUPP must not be
> returned as an error value by e.g. sysfs callbacks. As far as I know the
> ufshcd_vops_pwr_change_notify() return value is never returned to user
> space and hence returning ENOTSUPP from inside this function is fine.
>
> If you want to keep this change in ufshcd_vops_pwr_change_notify()
> please make it a separate patch.
Thanks for the info. I will use ENOTSUPP in next version.

Best Regards,
Can Guo.
>
> Thanks,
>
> Bart.

