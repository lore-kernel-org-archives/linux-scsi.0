Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D412E7648
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773484742; cv=none; b=cj064R5+5DgWndbFcHbIEiajKLaF/xgPGgYmO3xDjoOQTdgmdkf8rV8F0n2WLlnFB0cru70jxeGQpZbeeH6kF4aXXkHoQaQMEvvpViAuRpyhyw90iXwrJzUpKFWvQvUMPXoPdz8ZHfxWTVcXOViw6GPqaUEXd0tK2a/K6KOHP1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773484742; c=relaxed/simple;
	bh=TQAcTPuy9qmTOFzd4C6AY3pEnyhsklJUVhh//XexyH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IPP920ozqtHg8VlYyR8ftaHyWFLs5vl6lna/0ROj+zl99Z2zmVugZKyUqqfcutK1lDLlVAgk4K1vHbZ3FPJ4aYfWpfYtfaZQxPiz/Um4PgvSajNT8rKI+rpJoyQ1QilzaVSA6NiDX2pMSLezfVkm9JkqEo7fOvnsEMUEmQgdkpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GIuqclkS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LQQhmwra; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GIuqclkS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LQQhmwra"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E4BZ2K721463
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+uII683kruET/93bVNIIxmYnjfBn2cMoc1lNez4/AeY=; b=GIuqclkSxoYMkpFT
	6joZmnWPhA3kyKuyxZKNHRMt3rT0q3kn1ms0TdEXeaVHyb7ZHBBs9Id3W7jROoj7
	Xtr/gtCJ//QJrwuUM5EgfTE1ttvwDZlyhyfMPOKPwJ7Wo/m4UNUoKozhKwkFss1P
	fwxhi3mFOHlCdgqIQrOJeuOcJH/sVv2sLE5994gR6C9OO8TkX6j/Ig13muc6fBkK
	fd0J8UqnWUSK4xy7wr7aqZmxqToraMgnio0w+coEQ6IsUQgpzAQauwdpjwGUkoyY
	rX5lBki/QcUtGkQMVJVcK7JBx2FrKKdZaEyS+5S17n/oHJ0643CaB3eQhRpjn/U4
	RKhzHg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw0ec8hwe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:39:00 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b04293b16cso24932795ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 03:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773484740; x=1774089540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+uII683kruET/93bVNIIxmYnjfBn2cMoc1lNez4/AeY=;
        b=LQQhmwraGYJ0Sj+PTSf/JElNQGRLDKcIOsxF2eRDcglEwcDoU7qWOKOoanuDPKQ5Lc
         JMDoVl58Qhy9ARp/bN/dlA/tHGlW1Spkj4iEv3uglzXZQyVxKUkkvcq+N7234Eb9PZFd
         u5dCWii9VTPx4hyofyLFf0FLXVUaR8+rPcV6jlrmCwL8a0IGxr/Gcen4nT7iuVQSyGPu
         4BuSCpQm3b48/ivwhlhJq3fizpjspuEzXO0R+5Oq7UsO+wY5WHIAzXifcC79WtSIWjNL
         aWC4dDRs13euvk99RKNXeMqOc2mD0BVcre//KpnHG0N6CoOHRaSZ7JkvPI3dIi9o3Y0o
         glWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773484740; x=1774089540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uII683kruET/93bVNIIxmYnjfBn2cMoc1lNez4/AeY=;
        b=Qocfhsxu8DpONote4HG4rLpxBWjNDaqaBNwB0B/QoLfqDFcpnoxHkC1yYCK89GWveB
         S5JPdEaxRI2vkngm7W7FJemzY7TsXgM6Ok4vCo4ZV6gmBgonPfa8MI8cyCc2Qdlnt9Yp
         0R6KJpuz89i84aDgjA1sK53TfBBtGpfsnIZibVTOkdyAuJCEcTSfXd38qCwnNFLYERh6
         3neqJbdkCpGJo/Rjtn6470JYAn/bKCnqWv7teIHzsNuqLoA5+0xaYxmQ1a+02faVmL+u
         1G2FAYpfxR34s3Sbaz1tkbQWJLCsKwAyNkJts4OdWZr1Ql6fObqFIaqCHLTWmAKbLGXc
         UbLg==
X-Gm-Message-State: AOJu0Yx5VywauZHe/ODKnaAhVn/ydyT+7i6vPEmsMBadDWfbHIJowGXQ
	qMbGKI4Y/4426NnpjgmLNznA1M1lXnQZ5cQm/uz9ITvjXR1VxQRRhdAR8ycx57O3xG+wVg9If/D
	6rND5xvnqBEwhRJ7FnhV8s6xO9BwVzqGUTevyvg8KQeFiID+QER65VHZgC9mSEUqi
X-Gm-Gg: ATEYQzxrVMskOBE0rmD8hxLVNUATP4W+NYHWY+D1WLwRpAO1yCYX2CB8Z67spObog+M
	JkiAoPcIVZ2G/JFrxWUBHbEIem8nwcC/wTdawSXvRJqMfefcb1YheI8o8yIx93Ay2/1bXvyDv+O
	zZRTECxzgFbrGlGPWmLuAqtaISH5KMpIll0yYPaNn3JBavmcIm69BIvqciSGVRALLj6KQii0Scx
	OViYj5OE/KHVjZLLvMyAzs/HSBx3TtbToOu16hFhbwVej0ZPNUDVyT3/CTbGV66jeoF2eRt/t0b
	Le0H31Y092qWWji+nntQPis9mmM3jYtHixBoGRhdmLwLl0SpWrxJuO45VOYvip7I9BKtc1JRZOh
	Y6hQErAgkIJibDqx9OEjtYfDAjVeTEhE+yEZ6uEmsaXXTdYTo4e/sx+rwIkb1fzT9LPOr2YQCrM
	stED9tGtH0BQ==
X-Received: by 2002:a17:902:d484:b0:2ae:d427:d3ff with SMTP id d9443c01a7336-2aed427d732mr46004335ad.36.1773484740158;
        Sat, 14 Mar 2026 03:39:00 -0700 (PDT)
X-Received: by 2002:a17:902:d484:b0:2ae:d427:d3ff with SMTP id d9443c01a7336-2aed427d732mr46004165ad.36.1773484739689;
        Sat, 14 Mar 2026 03:38:59 -0700 (PDT)
Received: from [10.133.33.24] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece8453cdsm45893895ad.84.2026.03.14.03.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 03:38:59 -0700 (PDT)
Message-ID: <8c992c0c-6694-4b30-8e57-3bf12323dd77@oss.qualcomm.com>
Date: Sat, 14 Mar 2026 18:38:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/12] scsi: ufs: core: Add helpers to pause and resume
 command processing
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-7-can.guo@oss.qualcomm.com>
 <edaac4ff-4d8d-498e-a38d-6474b9d39743@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <edaac4ff-4d8d-498e-a38d-6474b9d39743@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: y7-jqmhRS6BV8_20PM00JbT-ZHY2-AYS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDA4MiBTYWx0ZWRfX2Ur7gn1VqK0H
 +o0rn3vrBi1+kObh9Vy8fcZYIQILP/1n2GAOFVxXctGwLv+8YYbxSjRO/GQ4duFjuwW2vfataE8
 ao0+tlBr3uEgNSfIzP0o149p6XhxeChiNMmS15rEdZOmRDuBB2+IKTWbC3JhnVdZ8hGupjoQoPW
 2qTQbn+n+aZMqlIXvUG91wA+dWJyfRDjawdUon4qK0tdcgmSrKrFDeLhn4ON2aC1eunNUOtb8s3
 5c0Xl5BdLx1gYWHXcCecP2R1mUQTi5lYKUcscb0gwTFsggDeMPW99R98Vk/pzKHlsg69kQ+Bdns
 80volPofmsFMgDKBQcLbk7unaHk2RnURYAYZ8IW0SAO4LDFDE0LSGvPx6jcuPcnvam5KMfTeXWO
 +z7Xa8nUQIqm3/AsEZ47/ZxirJmgl9GaMYslZtq+CP1UeSTCqfU1E2JhUD+cowb26d+vOebn3bY
 OJf6lmo9nn4hFTnDcWg==
X-Proofpoint-ORIG-GUID: y7-jqmhRS6BV8_20PM00JbT-ZHY2-AYS
X-Authority-Analysis: v=2.4 cv=BqqQAIX5 c=1 sm=1 tr=0 ts=69b53ac4 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=9LMX3ljFYsvWsaVO_aYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-14_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603140082

Hi Bart,

On 3/14/2026 6:26 AM, Bart Van Assche wrote:
> On 3/8/26 8:14 AM, Can Guo wrote:
>> +/**
>> + * ufshcd_pause_command_processing - Pause command processing
>> + * @hba: per-adapter instance
>> + * @timeout_us: timeout in microseconds to wait for pending commands 
>> to finish
>> + *
>> + * This function stops new command submissions and waits for 
>> existing commands
>> + * to complete.
>> + *
>> + * Return: 0 on success, %-EBUSY if commands did not finish within 
>> @timeout_us.
>> + * On failure, all acquired locks are released and the tagset is 
>> unquiesced.
>> + */
>> +int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 
>> timeout_us)
>> +{
>> +    int ret = 0;
>> +
>> +    mutex_lock(&hba->host->scan_mutex);
>> +    blk_mq_quiesce_tagset(&hba->host->tag_set);
>> +    down_write(&hba->clk_scaling_lock);
>> +
>> +    if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
>> +        ret = -EBUSY;
>> +        up_write(&hba->clk_scaling_lock);
>> +        blk_mq_unquiesce_tagset(&hba->host->tag_set);
>> +        mutex_unlock(&hba->host->scan_mutex);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +/**
>> + * ufshcd_resume_command_processing - Resume command processing
>> + * @hba: per-adapter instance
>> + *
>> + * This function resumes command submissions.
>> + */
>> +void ufshcd_resume_command_processing(struct ufs_hba *hba)
>> +{
>> +    up_write(&hba->clk_scaling_lock);
>> +    blk_mq_unquiesce_tagset(&hba->host->tag_set);
>> +    mutex_unlock(&hba->host->scan_mutex);
>> +}
>> +
>
> This patch duplicates existing code. Please integrate the following
> changes in this patch:
> - ufshcd_clock_scaling_prepare() calls
>   ufshcd_pause_command_processing().
> - ufshcd_clock_scaling_unprepare() calls
>   ufshcd_resume_command_processing().
I looked into ufshcd_clock_scaling_prepare() and 
ufshcd_clock_scaling_unprepare(),
I see they are coupled with Writebooster, wb_mutex and check on 
scaling.is_allowed,
I don't see an easy way of calling ufshcd_pause_command_processing() and
ufshcd_resume_command_processing() from there.

I also checked the history of changes to ufshcd_clock_scaling_prepare() and
ufshcd_clock_scaling_unprepare(), I can see multiple issues, e.g., deadlock,
were reported and fixed. I am not confident at all to make intrusive changes
to the two functions without breaking clock scaling.

Can we do it later as a separate patch and with enough testing conducted?

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

