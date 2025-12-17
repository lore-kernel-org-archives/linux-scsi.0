Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3B3345CB5
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992583; cv=none; b=tkNWF+uzpKuKV26GZhWUYAjWrSXX0W9QVucbXBJ9u8KWzo5J7CCbUs8xRpFxq8UIOnWQrcbYZvbODDosBFlM33GvwUukEyIIoUdIKh8gmvPpKBjzFe+PPjWzmX4jxmjRr82e3G9edZxFeEaZ+ssdPuqHTgX5zm+VldtzxdXYUp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992583; c=relaxed/simple;
	bh=cE/fzwGmGex+gbEb/M2MHVuvMP28mI4f04dihfJ1/FE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7/7K+ISl2jiwkEs3NrpYcv+kd0VBUHaNf4uzqHVJKgw0DGhPrljm+eKEKAhzWBf7MNNtsCSzTj+AEI1ATKaIUBfzzS7PHP9ng7rXovi6AwGo4897k+Eke0FzZ9GlW5pRQmWJ2Pp02rgaKoUH1L7Veb6masxN+jY3KUT6q8V+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lU6h/GOu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f5EN8Uy8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lU6h/GOu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f5EN8Uy8"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHCKoJn3000633
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 17:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NV/xBVCEIHHVy6FpNdEqG+lcE8kdbNFVPJBDmZRxQk0=; b=lU6h/GOuGEVvkg+k
	zx/dZJIpiLnl4Qc2MaR9LnuspUMxk4UhG45T9YPX9H+dXkCu9HaWz+FxUag5yowL
	gDpylwwPvcWR/0uMWl0L+56SpdgLzTwNg/3SplO2RmiiZSgIVFUo/+ne6Dk9SKpf
	VLEdNsUHBYtur+6894bTrJTPMxTOXxIZ9BlOgVwI5c2hpOh1mslBpMBcJ/AKLnk9
	yS23See1/zWO+53L5hETMf+5onHt93aM+RIs/r1Rmn0sLkID0LlWPbQS5hPDOhmg
	QQFpTEEgaav5+hKuSuJmLpr9ZF8HmIaI+f/OwyMS8YRJBeLMyAHZrhGnkJt8Iga6
	LEAZqw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b3n332hug-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 17:29:40 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f13989cd3so191701205ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 09:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765992579; x=1766597379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NV/xBVCEIHHVy6FpNdEqG+lcE8kdbNFVPJBDmZRxQk0=;
        b=f5EN8Uy8yruX1kE7RWHF/sVUtM9PHNy8vvPY7eLrkmmsEr5xI0pXU624XGGB417M82
         VJO+yTxjH/A44KUInCV2L/Wxxeob8w0+SDvhbe7EzEs8Eq1NNr6Xmre+u7dBi32u+9P3
         LXZQd0ISe/y2nX1O6ac5sf2tpD3cJr1XkVrPGjmOs8e1LdvEN6bYbwnn1tdsbiG8wkCX
         e1XEgVSBCYBULzmrUr3urMMS2hemZxqisnneazjZCj99rO2taJoASCBFVuGMIH2snJ12
         RMcH4NmcNL0dCUJuJCnWT8qc8kAQuTTDM+U3MpsC4pCHQbGvRrwfR8QR/2DssvSvEj5s
         nOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765992579; x=1766597379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NV/xBVCEIHHVy6FpNdEqG+lcE8kdbNFVPJBDmZRxQk0=;
        b=LuTYS9mODsZ1cEnQVbKKSM9Kw6Ob5PI9yh1b60uVotnNAaDFv9IRr1n86+nX+DQrDX
         VTz8nzxHlOX5xBavA8NgMvyuLY1GUAzg6pLItjKq4hp2lmnbKmjYahXC8+xRsxrZxdPc
         KEN6BJVjFfznYjqxv9HVDr2PGEEfqhcrlu/Y7o8jRP9dtEjUfpVhh9oqjMNUOhNvUu2v
         bpcDzGAz4otr0F1AkrzcXNFiGlaXTYY7AKQPbahWZN8jeNgOx7iAbeKqBaLNjsKXSc8c
         xavnLhgZxzONzSH8ZcwhCigmMhYKYY5AxAk5oGCqqRiS8W7Vi2csWGb4LfeGTlKE6eFQ
         QZ0w==
X-Forwarded-Encrypted: i=1; AJvYcCWdUgcupE8I5l5CFSxuIGkcSsVaDxGB+dEpUXcn8r1Z7AKSoD3nCERad6JmvRu5u1XQ1Gxj76VLylg8@vger.kernel.org
X-Gm-Message-State: AOJu0YxeMCzsd+9PoATXIphMcfdU1cZHOx1mAlodReqpFQIAnXUMtTsB
	63Q6Pq4EKpUwR1t4RtzyqpoAz5ZGTjsS8J8LQ21K53CF8A3qdMHQsz5iZW4uWNJ0FIEvHYksmqI
	/aAKUQ2IOL8x+2vvM0sgRlkpSy9HPmj1eKrBh77LGG2lcGpchqRwfkbwmMg2XXqR5
X-Gm-Gg: AY/fxX5qwLTqw9zMcTXmzhHwVLLaGOmUom4aoj1M2gP5C4ks56PItoJI/2/wT9NbXvR
	WyaK+Ulw9d0En5XUnpJBTllyrJXC0nNUhItshqq8XxudmOjHV/MToDTohubFqXpoovSPE2jH4QN
	WYY0EuF+w5INdjgPzKUSQyGF17C+dlNJU72PRKaT7eJpxEe+lVb8M7jza1ke3JxA2z1Vdp802zb
	c2bHwrc25pFNJJfJxmMqa/kyz6byyxdna+MYJka1o1CvWr8xnNTvfShIUwzE0sZBA3ZMANjKjgR
	ebqrCHGgah+KhARQEdEJLDAnD9EvCTHFRMsVpL00dKekBua+6pluAcMXSiPJ/rsCFm1sor5Kh+o
	eMps4aVMco46v3ZDyEhGjrfg9AQ0plTwnsKl3Tw==
X-Received: by 2002:a17:903:1a87:b0:297:e59c:63cc with SMTP id d9443c01a7336-29f23c73363mr200515485ad.35.1765992578911;
        Wed, 17 Dec 2025 09:29:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+hhm5Qpn11aQHm+heDc/ckRb3L8vk5ifLctFQyVMPVINa66gItIW1rOjKVaHRwtpsAHYSrA==
X-Received: by 2002:a17:903:1a87:b0:297:e59c:63cc with SMTP id d9443c01a7336-29f23c73363mr200515245ad.35.1765992578378;
        Wed, 17 Dec 2025 09:29:38 -0800 (PST)
Received: from [10.216.54.238] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2de913b4sm4239a12.13.2025.12.17.09.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:29:37 -0800 (PST)
Message-ID: <0c897443-a33a-421b-906d-de2fb92aa904@oss.qualcomm.com>
Date: Wed, 17 Dec 2025 22:59:31 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Bart Van Assche <bvanassche@acm.org>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
 <3bcc40b9-5085-471b-85a9-259ec25c5c0b@acm.org>
 <aa40a658-f036-45ad-8d7c-e133b3003748@oss.qualcomm.com>
 <8bd59ca3-ac8a-4bc3-af5b-ba48000fb0ad@acm.org>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <8bd59ca3-ac8a-4bc3-af5b-ba48000fb0ad@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDEzOCBTYWx0ZWRfX/PW47AmwS9O5
 39NHTAuLRfexxmWKu0Cn6JD92kOWAozTi5TIIRJOU/yteBRcNLilkDwYPx1eBUFSkqmkK7T9G4+
 Z2elNGIGYbBsxcBedB2oUTjF/+ZyTkBLzcP5s/o0s77FGHDOsWCCfINSqE7+OzECZZ6TG8aAmTp
 nxSkwyj/fw3v+aB9xca+LqRqD0IkzLUXcxFZ1rga0CUT5pL3bnn3yRBaf2e+vM9fdEBM0Jy0Rp+
 bHwcQyrsrIm/Dj8za6d5RSW9rAMbJZ1EwCZuvh/zXQWw9KGPibe8igDO3khR+5qvnN4PNKEZJzw
 kGsTw9YshSnogxcEwvPiwZ4icEz1/9VtKkPjlv2kDcKBw1ZwgWX9Tu0g1M+S7Gj2LNrz7b72uV3
 gVRPCaHGYXue9uTbEj9LH38PSYasiA==
X-Proofpoint-GUID: v2hclSDv7uFjfPQ6UStQkGeihw7Wh5j1
X-Proofpoint-ORIG-GUID: v2hclSDv7uFjfPQ6UStQkGeihw7Wh5j1
X-Authority-Analysis: v=2.4 cv=U82fzOru c=1 sm=1 tr=0 ts=6942e884 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=N54-gffFAAAA:8 a=VlTWkPfyIKX3guytBVcA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512170138



On 12/17/2025 2:23 AM, Bart Van Assche wrote:
> On 12/4/25 6:36 AM, Nitin Rawat wrote:
>> However, the UIC error persists, causing the error handler to run on 
>> every boot. The behaviour is same on both SM8650 and SM8750.
>>
>> [    3.516236] ufshcd-qcom 1d84000.ufs: ESI configured
>> [    3.516272] ufshcd-qcom 1d84000.ufs: MCQ configured, nr_queues=9, 
>> io_queues=8, read_queue=0, poll_queues=1, queue_depth=64
>> [    3.516275] scsi host0: ufshcd
>> [    3.584233] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; 
>> HBA state eh_non_fatal; powered 1; shutting down 0; saved_err = 0x4; 
>> saved_uic_err = 0x40; force_reset = 0
>> [    3.607898] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; 
>> HBA state operational; powered 1; shutting down 0; saved_err = 0x4; 
>> saved_uic_err = 0x40; force_reset = 0
> 
> Does the patch below help? This patch is sufficient to solve this issue
> on my test setup.


Hi Bart,

It resolved the issue on my end as well. I tested it on SM8750, where 
the error was previously reported. Thanks


-Nitin



> 
> Thanks,
> 
> Bart.
> 
> 
> Subject: [PATCH] ufs: core: Configure MCQ after link startup
> 
> Commit f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
> did not only cause scsi_add_host() to be called earlier. It also swapped
> the order of link startup and enabling and configuring MCQ mode. Before
> that commit, the call chains for link startup and enabling MCQ were as
> follows:
> 
> ufshcd_init()
>    ufshcd_link_startup()
>    ufshcd_add_scsi_host()
>      ufshcd_mcq_enable()
> 
> Apparently this change causes link startup to fail. Fix this by configuring
> MCQ after link startup has completed.
> 
> Fixes: f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
> Change-Id: I59754fdd910b9a88bdd681280342b923c4c494b0
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d18a3e616c8a..310fd3fa0897 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10812,9 +10812,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba 
> *hba)
>       if (is_mcq_supported(hba)) {
>           ufshcd_mcq_enable(hba);
>           err = ufshcd_alloc_mcq(hba);
> -        if (!err) {
> -            ufshcd_config_mcq(hba);
> -        } else {
> +        if (err) {
>               /* Continue with SDB mode */
>               ufshcd_mcq_disable(hba);
>               use_mcq_mode = false;
> @@ -11088,6 +11086,9 @@ int ufshcd_init(struct ufs_hba *hba, void 
> __iomem *mmio_base, unsigned int irq)
>       if (err)
>           goto out_disable;
> 
> +    if (hba->mcq_enabled)
> +        ufshcd_config_mcq(hba);
> +
>       if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
>           goto initialized;
> 
> 

