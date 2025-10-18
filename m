Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A84221543
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760770177; cv=none; b=XKmJjYHXqrxaAJRx2hF5e89ttwoTo5NDPng1+W8ynGiiTR2xIFBjcV0XywFKJ7a+eqHjRREWX/BC9rgALrHIlCrePRF1GpwOrA+tfvsfZlNzB8oHYHrKCgkBmo0AzosKQ0MXS4I9BB83camVas2aPsAdoi87hybLnHg8YnlBaa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760770177; c=relaxed/simple;
	bh=NjyFIWWiLjNkFVpMIJdFbukfb0uqE8RJDQ6r2TinqO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9HR2QpGtQeKeb8pOjyszMbsBIrOel+/r4nP1pEhSl8UnI/Hvxuu8bM9KRkuRB3ifRxcHZjTN7B33sTejvDusAJZfrqWtqA5pZqIn+zWS6/dcp+kF6xKwJcxt2qlwcBZAE8quvXOHnyDfUpLvsv0AtBpjzoNmCI6/iT4UGQqxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZF2JSD0y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZF2JSD0y"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59I3FLPO019810
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NjyFIWWiLjNkFVpMIJdFbukfb0uqE8RJDQ6r2TinqO8=; b=ZF2JSD0ynOnd7HFH
	txnyqRD8a5lKpNybNzcBvBr9hiukW0Kz76voObJqJOa4VorkBQD9l6r+PvS3eUgQ
	YpVVGX1a+MAFuuWtHYyc+K0kB4ma4Xs/wB0tJjq3CtDjKU1O50ekaeKI26jOvxyE
	Wze4Pu0hIvDtyls5rAzsxZFh+0yeKAgPVU2cFI9Vrr0BdpZuSvEM72/GHI0Al5iQ
	8LOGrXwQDGWo8KitqHqpA96A4N/Pcl8pQskZFbwLC6AHH8RpSAbo6maP8xNXvtfq
	Ao4fIKKdctXff61HeZP9yLDn6BOSOiQ/tkPS72uerS3WkoTKMoMbaZfO7zABvXdy
	CvFq9w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v2gdrahw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:49:34 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3304def7909so2240857a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 23:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760770174; x=1761374974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjyFIWWiLjNkFVpMIJdFbukfb0uqE8RJDQ6r2TinqO8=;
        b=rozfqXY4GNOOsJykvWTmbdFIWxwpebQFCDVYfTsPu5HWzf/7UpMKljkt3ggPOW9lXr
         LxOtaYHDIozdgZkbOTKz1CT11Pzlaq32tPH+9TD3LwgZp9lqxvIf/Cg6eAkXqFQk4K8d
         FGt/o7myU70JXqEpZlmDUJvJv3kD14MMHmZiBiWaJGU0/qvihc3ZPE8kncvoqRFKF63K
         8+ssYPx8s7hmWs571HhDtGPJgmSYzzM9sWtkm573sQaB8gbZLlCunHAnunMCdxUpcTfU
         qanDTFnf+UtUq6ceqODiIcLCDjeo7EJoDYGGmqf3Mt0+ECfxfrOaBidKlatZx2/SOmAp
         4ewA==
X-Forwarded-Encrypted: i=1; AJvYcCX/Ob484yz+2G4a1LwYP/kYaFiBudlxbwH1Zna3Qln5a87Oa7IudSStxNlpkqarmR/aYUwdSbJpWOGg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2qf6A4RVvzN2OGLXwFYErJq3BVwQHp/9HUIa7Bbghe6r+YJDe
	hgNhVa3VPjEnrnUWkDRazFjvDbeeRDqPASRZNIIYGS6bwDF3r0VIrOgyq3UgAgcyjp2jQb4VgQQ
	vuMtJJGw3xdbfNAeLapNGGRPWiAViXS6QtHEFUNO45F+Q1Yp2u5/FVNkbp3hnumJC
X-Gm-Gg: ASbGncv7D1zh+xjB884uYDh8wkF8x8jgxHY60hMHXFSmRmg1VCVN2iiLUTIP+HTp7dp
	+DlN01nIsv9MaHMDCCm9h2wevMSOCJGLj82Vxv5LXfwjCO3kPRz+cAcAyQymrsAvcP/r7H3pwaB
	AFryWufL6xCJpGY7cYSkv2NgV1eDA2cJzg1fOaQlfB2zmOn/kRNcBookDY99W+vWtGeCrrttX+o
	hO6QV4eZV5TKKKfOtRMRT53ZC1Vfz2JEYlHXAwSsAjx3ileJa0Q1mtwf/pUhMIxwLMlPG+oI0xf
	tD4Uy089qjna7UzHNlUZ6Aqby/NcB/qGCeHsgfZgZqQhRsLy2apQzJkmh1qfKroooNPcQEswzHt
	/oOQ4U++n5bIfejFhNNGFOoLSK0uR
X-Received: by 2002:a17:90b:58ae:b0:33b:e034:c1c0 with SMTP id 98e67ed59e1d1-33be034c22fmr4958725a91.23.1760770173584;
        Fri, 17 Oct 2025 23:49:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLKdYdrSsWt/K0na02/iC7US2cAWuk9uzzLTM/xsMIIzhirt1VKeo3sQKvC5k+1NMY5WSAAw==
X-Received: by 2002:a17:90b:58ae:b0:33b:e034:c1c0 with SMTP id 98e67ed59e1d1-33be034c22fmr4958662a91.23.1760770173096;
        Fri, 17 Oct 2025 23:49:33 -0700 (PDT)
Received: from [192.168.1.14] ([58.84.62.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5ddeb13csm1554574a91.1.2025.10.17.23.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 23:49:32 -0700 (PDT)
Message-ID: <a26d7160-d303-4257-a63a-1e94b61f5331@oss.qualcomm.com>
Date: Sat, 18 Oct 2025 12:19:26 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] ufs: core:Add vendor-specific callbacks and update
 setup_xfer_req interface
To: Bart Van Assche <bvanassche@acm.org>, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, peter.griffin@linaro.org,
        krzk@kernel.org, peter.wang@mediatek.com, beanhuo@micron.com,
        quic_nguyenb@quicinc.com, adrian.hunter@intel.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com
References: <20251014060406.1420475-1-palash.kambar@oss.qualcomm.com>
 <20251014060406.1420475-2-palash.kambar@oss.qualcomm.com>
 <d027689e-9c45-4584-ac35-411b74b551a9@acm.org>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <d027689e-9c45-4584-ac35-411b74b551a9@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMCBTYWx0ZWRfXzQE4/E09mLQp
 uhY/tms5F8hs6WaCd5eEv6hmRpgpNyv6zrUmMco5ujoApNsLvfeoEdPS93DzHfRmjRa3jAdz8CF
 dCw6Dxu3NlWbo/mk6Qw253cP0wGzhES50kaEIK9xlD13uY7nR0h+t9d3/4wjSzLl7wBDuOTh2FD
 Eh0Yjh5ijv6u1oGvP0SpUV59N/fmpNExppCnTd8IT5B3phk50Og5V6VzZGKuInsMLXfMGVk1P15
 gGaNqbfLzf/6uqKbBbkfMaYkBUQOvR1Fro0MOU/5kmuV/E+tZ0PnSzY+zAfhb1f1BIw0vGHIgJS
 gJkveIZ+z7QLBf4o3zm4NRePmhj4nMZT92VRBxK+z0gd28d1ZqZPC2+ZdknKfAdcNY20YxrNj5d
 AlE8e3oDxK2JhFFX0+MThNpxHcKRYg==
X-Authority-Analysis: v=2.4 cv=KqFAGGWN c=1 sm=1 tr=0 ts=68f3387e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=IrkFCgFlEHDHcOs+Gij41Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=zPb30M-LlVYnm6LaiLoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 97Bd_0fEtGcfSF-U7lPgFjUjXxsvdGru
X-Proofpoint-ORIG-GUID: 97Bd_0fEtGcfSF-U7lPgFjUjXxsvdGru
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-18_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180020


On 10/14/2025 9:40 PM, Bart Van Assche wrote:
> On 10/13/25 11:04 PM, palash.kambar@oss.qualcomm.com wrote:
>> On QCOM UFSHC V6 in MCQ mode, a race condition exists where simultaneous
>> data and hibernate commands can cause data commands to be dropped when
>> the Auto-Hibernate Idle Timer (AHIT) is near expiration.
>>
>> To mitigate this, AHIT is disabled before updating the SQ tail pointer,
>> and re-enabled only when no active commands remain. This prevents
>> conflicting command sequences from reaching the UniPro layer during
>> critical timing windows.
>>
>> To support this:
>> - Introduce a new vendor operation `compl_command` to allow vendors to
>>    handle command completion in a customized manner.
>> - Update the argument list for the existing `setup_xfer_req` vendor
>>    operation to align with the updated UFS core interface.
>> - Modify the Exynos-specific `setup_xfer_req` implementation to match
>>    the new interface and support the AHIT handling logic.
>
> Yikes. Please disable AHIT entirely or disable/enable AHIT from inside
> the runtime power management callbacks rather than inventing a new
> mechanism for tracking whether any commands are outstanding.
>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 568a449e7331..fd771d6c315e 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -2383,11 +2383,11 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
>>           memcpy(dest, src, utrd_size);
>>           ufshcd_inc_sq_tail(hwq);
>>           spin_unlock(&hwq->sq_lock);
>> +        hba->vops->setup_xfer_req(hba, lrbp);
>
> What will happen if hba->vops->setup_xfer_req == NULL? Will the above
> code trigger a kernel crash? 


Thanks for catching this, will take care of this in next patch set.

>
>> @@ -5637,6 +5637,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>>       }
>>       cmd = lrbp->cmd;
>>       if (cmd) {
>> +        hba->vops->compl_command(hba, lrbp);
>>           if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>>               ufshcd_update_monitor(hba, lrbp);
>>           ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
>
> Yikes. New unconditional indirect function calls in the hot path are not
> acceptable because these have a negative performance impact. 
>
Sure, will take care of this in next patch set.


>> @@ -5645,6 +5646,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>>           /* Do not touch lrbp after scsi done */
>>           scsi_done(cmd);
>>       } else {
>> +        hba->vops->compl_command(hba, lrbp);
>>           if (cqe) {
>>               ocs = le32_to_cpu(cqe->status) & MASK_OCS;
>>               lrbp->utr_descriptor_ptr->header.ocs = ocs;
>
> Same comment here. 

Sure, will take care of this in next patch set.


>
>> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
>> index 70d195179eba..d87276f45e01 100644
>> --- a/drivers/ufs/host/ufs-exynos.c
>> +++ b/drivers/ufs/host/ufs-exynos.c
>> @@ -910,11 +910,15 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
>>   }
>>     static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
>> -                        int tag, bool is_scsi_cmd)
>> +                        struct ufshcd_lrb *lrbp)
>>   {
>>       struct exynos_ufs *ufs = ufshcd_get_variant(hba);
>>       u32 type;
>> +    int tag;
>> +    bool is_scsi_cmd;
>>   +    tag = lrbp->task_tag;
>> +    is_scsi_cmd = !!lrbp->cmd;
>>       type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
>>         if (is_scsi_cmd)
>
> I'm about to remove lrbp->cmd so please don't introduce any new users of
> this structure member.
>
> Bart. 

Sure will update this as per the new change.


Regards,

Palash K


