Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC6314B6D
	for <linux-scsi@vger.kernel.org>; Sat,  7 Mar 2026 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772888547; cv=none; b=TENfa5sY96VthrEoBWdTz6deD2yGnFpf79LFf7Wuu6/x3OkOx5uVCwZNYM3wYvV+w0EbfzI+bYAjCKPTiHRLGHb8Is2qzlQb65GreMNg6TtSYLML41SY4FyAsBXnVv0GyKE1vF/uuLvJuLtu1KJFLZaVRKYXQ3IN0nwE/+YhLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772888547; c=relaxed/simple;
	bh=rq0wbPaRWXXFADsPr/4TR/KHwsK0FYUDyGYXvTrXaiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rp0LKeqXoXcJ7rFuoD9ExlANWOAgN1iqHEyCC+l7Zh4P0bG6joFACsjN/OPkhySLTK1dRrPUho/SwXAXEZwuBudsOABcdI5pVU+qvStVQj+cJzS7evJJhbUcGNUM33NIuWBOMkw8LrEaG/CrDyS3uXzg+BjHjU16FuKOvTTkpIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZMmAm4Xh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RIcuUiqQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZMmAm4Xh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RIcuUiqQ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6276qoC22401940
	for <linux-scsi@vger.kernel.org>; Sat, 7 Mar 2026 13:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bsqG/fOrxLTztrfYdimrOt9nHUp4N1EZkp2EYUzLRuo=; b=ZMmAm4Xh/GnhB+eA
	mJIT9ttWKPxiH8X2LMELI0gX4lWgWqvTSdFu35YD1h/4yh73+6D62jiBq3yXScll
	/Cr+gS1xLZHSMxFbT4qNPW8FY4gO/I+JGpnm3q6cT0oiPMxO78PWE/0WutiAofPx
	ab3cRqKgFEr/9iHOyFDYVnQk6pLYXLMF2n9kmYOVnBcYMh3ZToF2laHXlsSxnCE1
	M8MSy3Ih70zs3tDZZwLo5OYNTMPAJ6kcmnSmjDOMwYKcFOn52rwirW+e53m5m52L
	Q1TvGJIV/2XPH9RTPqmc4enohGMIYhdXzsc3dVmjn1iPf7ttyMXVP+xa53vVhZDS
	64kz/w==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cr9qes4r0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 07 Mar 2026 13:02:25 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae4a6bb316so67513895ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 07 Mar 2026 05:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772888545; x=1773493345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsqG/fOrxLTztrfYdimrOt9nHUp4N1EZkp2EYUzLRuo=;
        b=RIcuUiqQA33yu9TOX7/4o84WnrsZ6y8bLaOeOl33LvScmXy/kj/N9mH9tc2UjbR1dz
         FJY/mwGd/FR0QpjiyMEaqUNMyE8K5chKKYHooHU+j0m6NoxS17hCgMnLc9qnBHcNCogR
         qjs90Uy4mRpBldQyHspN7FaPvP4J4CUXrnaAJmjwaaERYkPo5MAFxzuIOaxPKBjkRPyp
         xRIBSkUTBEiznv702ZDR5BdgZ8ClFCt9TqT5m60svU1Z32IscH82nsLplALvaoCLdOKR
         SKSRfn3vznO0jPY1JTn5nUZdpyFkCgGfoBLsLqXwH1jbs9J1WV98JJIUhK/4IQxGFp9p
         2gpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772888545; x=1773493345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsqG/fOrxLTztrfYdimrOt9nHUp4N1EZkp2EYUzLRuo=;
        b=q13e0INCLZ+f8gAa6Gqkj4Btrf0Jpn2aIVAGD0SDvx1s4P2+IWBFipne5JKY5DCwP6
         USbnqpTdRB2BIVMO7t08ISdEWUNuQ58D5z/CDmZYfgNHSLGHz0tZLioLTsxJN9FCMoTf
         AShZUHzIVxISX/MPbb9otEixxMTnj8uL4pXEARg2/X69FS1b7YGoUl+9t8vjkHpxSXSz
         a6/U3+hn+Rtr9soRK798TB7woGhRRDtyPc2o1CyvEOwr+/7O36wzcculEzJIC/iG38vZ
         8JjaEDdnPpu5UCe6whFc5PnXJTasu1mGrwZVmXBjZq4SDcnS5LdP5aSLgUzE0e4dMK41
         /sVw==
X-Gm-Message-State: AOJu0YyT4FuMrkcFDn0Pi0rh5wMCrtWV0YZ4Snp9XniVmgX9tN5xDNF4
	uo4Xj/CGAmvbVi7zpQax/ojX6v19ir1dgQKeh/AeNYB81JKrvs1CBuGqRLhDhAvobW5EXClmc/G
	0y1dT4IfK5HNwe3VQkXvnNiG9Hkp7b/T4xsIlFhi2aXGyNzIX3AIDaJHhwqE+9MpP
X-Gm-Gg: ATEYQzwRCPOW8h12bpaLtw7vv1JFZpR+hNWec4aa+YqCeYFBu/Q65hHMjW/ZcAa2i2A
	lXzGnXHRQCLajlBRCKXIvSbCSCej6X41Ph5UUjw8TlIyCQf7NoMXWP7RXKSC4PcFS0EM9t8SxWW
	WAxdeXt48164WIrh1B7G1iXJ8wkyD17i9cLSc9fwzdtkZuATLUv/dV0jR6LekqNCstjCsSJvU7s
	w9pKEtUyJvk70H+OGKewMgBy5rD3oOdJ0KKk62qUUcjzZ+HdXYU0hUfavBCDhtrDZeQeGqldA5R
	JJ88/Bjuuq/Rh8KM9JH5UUkff4yJFDG+z3NVuO6Snp1WzLaI03Zb2eZ4PKS7LljrAoiWek4hAQf
	4ihCtiHNRhV4oOqKOAr1ETyTUzAedp++32Wm0lJJGzhaD83mIsYQ1LV10fMC4DqoFbw6SnpTTis
	TQHWHZf8PxsAY=
X-Received: by 2002:a17:902:db09:b0:2ae:5723:afa9 with SMTP id d9443c01a7336-2ae8253c933mr62100695ad.53.1772888544701;
        Sat, 07 Mar 2026 05:02:24 -0800 (PST)
X-Received: by 2002:a17:902:db09:b0:2ae:5723:afa9 with SMTP id d9443c01a7336-2ae8253c933mr62100355ad.53.1772888544092;
        Sat, 07 Mar 2026 05:02:24 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e83ad5sm51866655ad.26.2026.03.07.05.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2026 05:02:23 -0800 (PST)
Message-ID: <824e88eb-56a1-4ecd-861e-df9be7cfb9c7@oss.qualcomm.com>
Date: Sat, 7 Mar 2026 21:02:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-7-can.guo@oss.qualcomm.com>
 <22dcd303-db72-4661-9d42-67c7215cc089@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <22dcd303-db72-4661-9d42-67c7215cc089@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 8UvHxrSc-svxovgbBL7r8a8TcPNSzzhu
X-Proofpoint-GUID: 8UvHxrSc-svxovgbBL7r8a8TcPNSzzhu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDEyMiBTYWx0ZWRfX62iyh4P8Ss+y
 GVyXAQeIzJwkh+ZrPGF1NJZJJK+FTjVgplRF3sOSerz1hKZc7yMqzbYBEup57tSk5R759kYm7hD
 b9yBSJspC+omL17CIpKZ5sp+bdMcJRzMw0OJgJG7cECtm3hmhHI7ZOjZQ9DcDB5MqV0lvL6fSGy
 chttbRltPAZZ0lPIw/WbM8BZZy/3ybH1Gz+T2TV3bxSAakKfraJR6lI+M+SgQzLyXPraLYN1w19
 jKh9iA98JFflqUqnmjW0gNy7OXwWPJfy2vrqRVNsSbzJEGFgdnHhHHaNQ3cOCfu7GJkqgQzCW1o
 D1Ova7XtNwCTbfq8gUJHRfY53aYsbvO8M1VxO1G7EVMgL8QjouY2SjoEzwOIVxHGk8U37auFrw1
 0q7vSwkfRLhQJVUTa651rYulu7w6sNjmhw1OCBECsSOIAQCdZsWR6ZN62Cc5P42YnNODU2Iieby
 Nu4hafPdY23mvwIEI9A==
X-Authority-Analysis: v=2.4 cv=dcqNHHXe c=1 sm=1 tr=0 ts=69ac21e1 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=ILuXRL2B8Dq3KeV0KTQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603070122



On 3/5/2026 10:11 PM, Bart Van Assche wrote:
> On 3/4/26 7:53 AM, Can Guo wrote:
>> +    ret = kstrtoint_from_user(buf, count, 0, &val);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (val != 1)
>> +        return -EINVAL;
>
> Why does "1" have to be written into the "retrain_tx_eq" attribute to
> trigger retraining? Nobody will know that "1" has to be written into
> this attribute without reading the code. I propose to accept strings
> for this attribute, e.g. "retrain" to trigger retraining. I expect that
> this will make shell scripts that write into this attribute easier to
> read.
Thanks for the suggestion, point taken. Will use string "retrain" as
input for the trigger.
>
>> +int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
>> +{
>> +    struct ufs_pa_layer_attr new_pwr_info, final_params = { 0 };
>> +    int ret;
>
> The recommended style for zero-initializing data structures is "{}"
> instead of "{ 0 }". The initializer "{}" doesn't trigger any compiler
> warnings if the first member of a data structure is a pointer. A
> compiler warning will be triggered when using "{ 0 }" and the first
> member of a data structure is a pointer.
Thanks for letting me know.
>
>> +    ret = ufshcd_pause_command_processing(hba, 1 * USEC_PER_SEC);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ufshcd_hold(hba);
>
> The ufshcd_hold() call probably should come before the
> ufshcd_pause_command_processing() call to reduce latency.
OK.
>
>> +int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 
>> timeout_us)
>> +{
>> +    int ret = 0;
>> +
>> +    mutex_lock(&hba->host->scan_mutex);
>> +    blk_mq_quiesce_tagset(&hba->host->tag_set);
>> +    down_write(&hba->clk_scaling_lock);
>> +
>> +    if (ufshcd_wait_for_pending_cmds(hba, 1 * USEC_PER_SEC)) {
>> +        ret = -EBUSY;
>> +        up_write(&hba->clk_scaling_lock);
>> +        blk_mq_unquiesce_tagset(&hba->host->tag_set);
>> +        mutex_unlock(&hba->host->scan_mutex);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +void ufshcd_resume_command_processing(struct ufs_hba *hba)
>> +{
>> +    up_write(&hba->clk_scaling_lock);
>> +    blk_mq_unquiesce_tagset(&hba->host->tag_set);
>> +    mutex_unlock(&hba->host->scan_mutex);
>> +}
>
> Because of the "one change per patch" rule, introduction of these two
> helper functions should go into a separate patch.
Sure.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

