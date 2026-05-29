Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3634F255
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017087; cv=none; b=ly4Zp61qMzZFkTKK0yehYWsc0m9R5VQdo6DSOeKwD9G/Uj2lyKbMe0H299ECbhYr1rLdPOfXx5AJfZnQmK+4ACjdWJH5dltthPNU0FzG/PCamJUEXyl7IIDegpR6OQkeaSqXMt4zGP7gqDvDw1bPUYWBDIsCl2/xOc+sbDnSI3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017087; c=relaxed/simple;
	bh=mcHo8JfFEIPdyBUH3cQiAKFGy1GHwOjxXVO4i593kUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p68C7hgGTWmEOuHqNyglIMfFgXUfgs1+8jIR9RrcRLbgiVjGHp6Z0VgMp3boPY9C89LiwQo/NrQaOc/XJIvxgI3antJXaZYExYE1+tteh9NN5WAXVCniq9GPVvLdF9EiXvUY8DRisCFLV4UjaQGAiURHczXV057Q5fZH4oBRKbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nbEAfdBX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BRMpTHEW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nbEAfdBX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BRMpTHEW"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64SNkZch2242700
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J4shBszuHUw9GWZJYtSKssHaaKnXl5RvEARP037Y9X8=; b=nbEAfdBXG+a1G0FU
	Yv66BJRaGRfwkX7Cvltzx1hWJl9lfmQn+jrPCw2oSSd7mxv5BGeoVclalPz+l4Ds
	yIcQgUD6/YaZdEl9mIJsC8UwGjg45MKGrabLzQ/j3SXVAJQ0s4RnupRLnyimi6ac
	ZTdBPaqmri/3+udDLFBGkeufaKuxTiEr/h2nzx9YhQL9OHynt2Wwbf/IdoXzCBVk
	vTQ9h9Pil4hVNbd09cDYEYYlDGfVCFMukCGVaNVcCJe4W3Jszr9XdcIdsNMgYx/H
	wMDXtmD8L1QtTcxXB7yPeR/IkROZRNZSNDKjmyMH9W0IlCZmVxm8fS32/sjaTOSo
	1408Tg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eety51hty-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:11:25 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82f9f49e4beso6994099b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 18:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780017084; x=1780621884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J4shBszuHUw9GWZJYtSKssHaaKnXl5RvEARP037Y9X8=;
        b=BRMpTHEWlG9CGt3J2yrQoO0iCcF7y+2U2aeIEp+jgEiyhkaX9OuTNSSlUMYyiy81ZP
         ECRP/eaTPOB7tSVaTLTS2fcIGXFkFDvPTIdbjNTdwMn64useNOLW/oITtlwejIM1voC3
         r12AK9RRHDpsSTgARfTk5Xa9S0w1GNPwvfS45jFNR1JAtenySHZhLw9m8otUz0lpdUmJ
         3/mOPykx1xsfpYJQsGB3nEctY7y1W+Rzpl9W35vvCcxRmRvex5YxsMBJSXCg9zZT2ucp
         7z7XqVkMaOUGhsehGZL6rQ2FJwbjXNKhb18ehOiot3Ko+YpxWgEb4mRO71TTvRl9z2km
         BO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780017084; x=1780621884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4shBszuHUw9GWZJYtSKssHaaKnXl5RvEARP037Y9X8=;
        b=IhYWsi+EBrFxr3+k9HhUUprOiig7zHr6juCo6PjtTBcuFS2Rg29KASDNc+k3SABbT+
         efl9+0fWAvFeQ6DkeOyW+V5rE7qlxoGrc39OJp8ZJ3bcdZL4OPhAdBB0HA32UdCrnDiv
         WEb3O9qGutewl0YYQe2aWq79wz9zHVXqGKBM5t/0JMupNfMpRuA9H9KU40rcUoYo4c1l
         XEzmc6XNjcHODXAR6D95FHialaTP1UyrpC4gbWuc4ZP/89dhUora7VFi1vZljh1FT+pB
         HxZbzD1FNmPozZKWhSSvUT9hDGKYRMmWHdCbHhqaHcQjT+aI1PNjw8KWGy5kbqwUOgWr
         cVTg==
X-Gm-Message-State: AOJu0YzBLnVRZQGuNTqDZN6qnOqzl3iJDYq6oFFgWThjM0ZY98ISpqJa
	qK9rG9biXTNKz23jT+sUp9nsVxXJyEpm+2byMqkIEfYVMWXHPx7xxMWxYUpvN6ErVReOdIpNL/X
	Sx5FbWjipE8HAClD8KpLeyssNUuBxvsu0MFEdZ6VLfzYWfqfNs+w2f8Hk0u2NYpBI
X-Gm-Gg: Acq92OEajIhseqkRP+YfhXtw52UfuBXmeVj6qBltQ2x8Gi4VS/FRAXzhbPOK1Far0jX
	43COFEMHOxpjlcAcWFoCuvGK1eM+/z0uI2IVm4OkFZlethzuxofLTM9kcADKotpm3MwtWkL8bCJ
	aVPbysaKQhOCa+l9SlUs2jXdhtyjuCcjZkz6x4q/N5t7Yd0qGzpYNLIntoDWw4aQ//uRC50+yOF
	44tzdDmwSfmj3i/6rnwN3sGPwfAoFFTshpvHihKkTsoISCupZ00ZRboATmwlGTGbLEgQZy/UWlS
	d0RTqgamQPbX1rkgSedE5XSFjoAfVUWRAlspuM0MgR6xCrRbGjy1fopxgtkYBnTPuz7qklOPzT3
	v9EdOoI2iuHQTE0VbyR8D9NTTXPdoU6t7vdcV0C+40tETX73o6sniS6yQvKKzJN/dy72NI4aLla
	pqpMzdIo5lhPi5gb+PyL/h4g==
X-Received: by 2002:a05:6a00:39a5:b0:841:dcb5:e6f2 with SMTP id d2e1a72fcca58-84212ce3e93mr602235b3a.23.1780017083945;
        Thu, 28 May 2026 18:11:23 -0700 (PDT)
X-Received: by 2002:a05:6a00:39a5:b0:841:dcb5:e6f2 with SMTP id d2e1a72fcca58-84212ce3e93mr602201b3a.23.1780017083408;
        Thu, 28 May 2026 18:11:23 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214cc3575sm23322b3a.47.2026.05.28.18.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 18:11:23 -0700 (PDT)
Message-ID: <e8c740d0-99d3-4c01-87e5-f324698eac2a@oss.qualcomm.com>
Date: Fri, 29 May 2026 09:11:18 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Bart Van Assche <bvanassche@acm.org>, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
 <20260528100614.3386423-3-can.guo@oss.qualcomm.com>
 <312d0eca-108f-48af-a1b9-a5dcc24e70fd@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <312d0eca-108f-48af-a1b9-a5dcc24e70fd@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDAwOSBTYWx0ZWRfX1BNCvNhBxgVm
 6650tr0URIJ8LEPgmHYx8ZgnLDTQPwzyARt4igYGb2ofx8l7ZU7De1VVgFL9bcHkRs+fcrGjIuL
 tIIJ8zEbgqiFEebRn8vEVIUS6n6RXLqh9SY45qguQij4hXy6EGHujQpMM5tepXepeasWSlzgdTF
 H8ufYWDSTRY3bs+o9DQcvHhxs1ZjBwni2shr+TmjMZhWrBVHK6oCgcZDkcZo9BOk5F+jCzG6iOk
 3I5/dlhgIJzS32LAeSgdK8lEWsvOp16WruxQd+kQRREMKeObdFLB7YBuwUeLOyxqGMHUoiiPPVR
 iX9aEVM/eh9WgBkVuBMcDbfl2AOdrPE99Q3iF2ywRzSJfT0RHlQcAxI40NMjyAdCqmZlMTwiy8d
 uJBnNvki1EDb4HJhiVpMxfkyPwuDgZMYNzEgCF0ZN7I5BLP4Gd4R5J+Tw9drZogR149V8SgFZlS
 QQyoCIQ5WjLSt9RbFZg==
X-Proofpoint-GUID: I-_xjJ9c8ucDubvEFd4an9ZcWrl-Hi-g
X-Authority-Analysis: v=2.4 cv=WaM8rUhX c=1 sm=1 tr=0 ts=6a18e7bd cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=io7CIJzrRBQDuDm3A98A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: I-_xjJ9c8ucDubvEFd4an9ZcWrl-Hi-g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290009



On 5/29/2026 12:02 AM, Bart Van Assche wrote:
> On 5/28/26 3:06 AM, Can Guo wrote:
>> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
>> +{
>> +    size_t sz = hba->lanes_per_direction * 2;
>
> Please mark constants with "const". Additionally, is "sz" a good name
> for this variable? The code below compares "count" and "sz". I haven't
> seen it before that a count and a size are compared with each other.
>
> Why "size_t" as data type? u32 should be sufficient, isn't it?
>
>> +    u32 lpd = hba->lanes_per_direction;
>
> Is this another constant?
>
>> +    if (!lpd || lpd > UFS_MAX_LANES)
>> +        return;
>
> Should a kernel warning perhaps be issued if lpd > UFS_MAX_LANES?
>
>> +    for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
>> +        snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
>> +        count = of_property_count_u32_elems(dev->of_node, prop_name);
>> +        if (count <= 0)
>> +            continue;
>
> The body of this for-loop is long. Please consider moving the body of
> this for-loop into a new function to reduce the indentation level of
> the code.
>
>> +        for (i = 0; i < count; i++) {
>> +            if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
>> +                dev_err(dev, "An invalid TX EQ PreShoot (%d) 
>> provided in %s property\n",
>> +                    preshoot[i], prop_name);
>> +                break;
>> +            }
>> +        }
>> +
>> +        if (i != count)
>> +            continue;
>
> The traditional way in the Linux kernel for breaking out of a nested
> loop is using a "goto" or "return" statement.
Hi Bart,

Thanks for the review, I will address them in next version.

Can Guo.
>
> Thanks,
>
> Bart.

