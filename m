Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4139F273FD
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756802768; cv=none; b=emZMmVByhSOmy+WL7yxQbm2NPbGqkJ2fkevwfz5yEmP6d3aw1n12dp/ZzGK5ygWRE257nfi5UB/XtR1pF445JBuWEZ40ebdjFQE0ogtJTMYkhh+iYR0L+x0RUofAGE6Anfo6XOoDoR2bR1MbWyD56PJQumuXokbOYsWreVMqJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756802768; c=relaxed/simple;
	bh=IU5KSuERKFOff7YoeQFlF/eDIiUCS3ER4x7/uJbGcaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uAWf3AiUy8JnSNmv+kDxIzJrefYzCHIQM8NC/7t+kRkupn84evAhWEA7Q8TNHIdICGnP1UYhn/QyXxaA4DTAErzGV5CHUMKXmB4frSb7GoQREGLYZ9ImqZwokeet5YJuNRr43LKkTMhWmZeJwFPnoFXZB4Tk7PxnCrzn4GZMaEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Dx1XUi+l; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Dx1XUi+l"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5822Rkl5016481
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2025 08:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9DdypEXonIxbTZgmqW/GG/QjXoKUlrEkhIPatpNasJY=; b=Dx1XUi+l4Q9OfwF1
	7uWYmq8bXAY7isKIJb/5WqKDMxNpgb795bb530b0V0oplDYsRiu7v3feV1cVep76
	RaTbYmbhA9w9Pam07InUUtwRX2yJa0WwiHqhMfwkHirmidNn0YToiCNmz4f1h2eg
	MP0EkZtd0nArQ876ZxybTl/mx0w1/FjY97Jdnu0ApPCC9waMfAjXj94Fe1V3NwbC
	gzhpSfbYgETbio/rTvT9lYgJsHlE10IiHJ9uD5/QoGXnM11Z3k5IeZ3ez0Qj8F5F
	K9cdQaTuxUoOG5xZsKyH8VYjAc3YuZnwwCDTN6XlId1xWpMzori+NZr5JMyNlr4k
	M+M/Rg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48utk8xyc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2025 08:46:05 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3278bb34a68so4726785a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2025 01:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802764; x=1757407564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9DdypEXonIxbTZgmqW/GG/QjXoKUlrEkhIPatpNasJY=;
        b=Rwxqkf2KPhH1vMqxoRqoaT2UdgUA33S7S6ELVz4Lrd8LJe28ckAg6ExKVA+QZWysMZ
         vZ2wPfb7+5awISIhjzgd4YrVse17+BV3oPFhshLEZCDHmlBj8x+7p2IEKPAVNGivH9QK
         hXwOpIOxn45IvtKXbTkN7iQgvgnRs8uIoZlBKkurOD1x45UdqhSDwGu0YXO8jXC96oKF
         SiJ2Sx2dYTOMmVkoaUaZngr/szibHsWHB0f4lnqUTQvb+ZEF7jlenVuRXqrsHGzzew2E
         bwg1va+osfkG5vwu5qr9qMWm0DqFmJ9gsYC+3TytWM1uzUxCksKrubksi/aG3YK983Ad
         oRIg==
X-Forwarded-Encrypted: i=1; AJvYcCVV+oNRrw7/j8zm2KrnuX71BnZKqTkB/dVHlbUyYwuTZeFFCQJuF0hjNAPZWYFLmnEU+vyLVej9fmb4@vger.kernel.org
X-Gm-Message-State: AOJu0YzqJo3o3r/AGU88kBtASZ+aX9D2OBmWmW/DGmugAnzXYP5sBQ36
	2G4Hmaa1F0DBogITTiNODVuHNCJzAWyUm2lE4ggXmDOw/qjTQHFfa9sl5y6I7wqjy6tW1FuchoE
	bkYI71DEdlxcEGlkhgKFajO/YgXT0VgcBRdYSX1v4ZOMB9LA7+zk7VOLdMPJk4Xex
X-Gm-Gg: ASbGncutuW7dFAf90yzsoSgvsrEwGfUknDD3TTx5dqj3CX19Y03zF1Oo4PbnuDkrYH7
	rs7JUl7vAe/shawok3sYqrnS8vcBIjoyLe7V77ekKYkO6pHs4WxNeaZIvs/Ou8xE2Oa5FRZfFvl
	nCjhuaLMli2SiBXwVCNlkC3A7D+Vgexf3Bd035eT5J9F6W461UrvaF6RQjGDMu8TyAsYNl6HHKY
	4sJ2OFGsF5CkW9RJROyWPyDnikRaz368+zuI0HRqhkBsIJq45WF630k+zfZ+tR3Hi4bj9zMDZaV
	cPiue6/OxU7wiz6NHxUUKHMCE4VgaFQ1+OAb7AdtQNW2xOBFjarfHNljNzrFgTVh9lHulOqGtdX
	cO9VW5/6cdo6ys5elmlxP7KqMgjQk
X-Received: by 2002:a17:903:198b:b0:248:e716:9892 with SMTP id d9443c01a7336-24944b22091mr134500045ad.59.1756802764444;
        Tue, 02 Sep 2025 01:46:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNIgt7obz4JURxVGJHkvnfA881OlV+TX+JH491+i3sFtiyAGB0czxK7st5H/fPfL/f3sPRww==
X-Received: by 2002:a17:903:198b:b0:248:e716:9892 with SMTP id d9443c01a7336-24944b22091mr134499845ad.59.1756802763900;
        Tue, 02 Sep 2025 01:46:03 -0700 (PDT)
Received: from [10.133.33.19] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249037285b9sm127053325ad.44.2025.09.02.01.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:46:03 -0700 (PDT)
Message-ID: <c79814ed-3e97-48c0-9ad9-cf5337967fd8@oss.qualcomm.com>
Date: Tue, 2 Sep 2025 16:45:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: Ziqi Chen <ziqi.chen@oss.qualcomm.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, zhongqiu.han@oss.qualcomm.com
References: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>
 <1174ecf9-b806-4c2d-b755-8a3cd594d337@oss.qualcomm.com>
Content-Language: en-US
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <1174ecf9-b806-4c2d-b755-8a3cd594d337@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: oOFoto-Sg4AUd-93JMqQaTgaT0Q7KulM
X-Proofpoint-ORIG-GUID: oOFoto-Sg4AUd-93JMqQaTgaT0Q7KulM
X-Authority-Analysis: v=2.4 cv=ccnSrmDM c=1 sm=1 tr=0 ts=68b6aecd cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=JS0ieFr0-Jg96Rwx31IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDA0MiBTYWx0ZWRfX4nSVM5gZsI0N
 XQ9rLy58slAQ5XIzkpRH2AfA4A/Irqz9QUP31ozifdRCvDquvH4YGCARia5YjQcBa1SsiO3XWVw
 qcKuLYB6yR1kn1M5qtofRn3K7/dbFdfjBjsJnu33ldTrnlmVUqGYUpovez3B1ZVxCSVft8XKJD9
 RLuprvkFe/E7Xr64snVRuTwaVjkPpME4948+SUNFxfumuaOFDvvMia86frgjEl04HxMlDDd98PP
 byiYxl2oqKUK0l8JM7keqRQg7ypAP1hj3HwtK4NDi2+0rrkY6BvoEE0up0roE8ttGMGWqHfFS7r
 39sC/lqR+xsfOL4dDz9YKX1tFW7co7GN/SdLeAqsrd4SPGptjF81tHun8rxz6yYCbZsDnoWr9tq
 plcosMHv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300042

On 9/2/2025 2:43 PM, Ziqi Chen wrote:
>
> On 9/1/2025 4:51 PM, Zhongqiu Han wrote:
>> The cpu_latency_qos_add/remove/update_request interfaces lack internal
>> synchronization by design, requiring the caller to ensure thread safety.
>> The current implementation relies on the `pm_qos_enabled` flag, which is
>> insufficient to prevent concurrent access and cannot serve as a proper
>> synchronization mechanism. This has led to data races and list 
>> corruption
>> issues.
>>
>> A typical race condition call trace is:
>>
>> [Thread A]
>> ufshcd_pm_qos_exit()
>>    --> cpu_latency_qos_remove_request()
>>      --> cpu_latency_qos_apply();
>>        --> pm_qos_update_target()
>>          --> plist_del              <--(1) delete plist node
>>      --> memset(req, 0, sizeof(*req));
>>    --> hba->pm_qos_enabled = false;
>>
>> [Thread B]
>> ufshcd_devfreq_target
>>    --> ufshcd_devfreq_scale
>>      --> ufshcd_scale_clks
>>        --> ufshcd_pm_qos_update     <--(2) pm_qos_enabled is true
>>          --> cpu_latency_qos_update_request
>>            --> pm_qos_update_target
>>              --> plist_del          <--(3) plist node use-after-free
>>
>> This patch introduces a dedicated mutex to serialize PM QoS operations,
>> preventing data races and ensuring safe access to PM QoS resources.
>> Additionally, READ_ONCE is used in the sysfs interface to ensure atomic
>> read access to pm_qos_enabled flag.
>>
>> Fixes: 2777e73fc154 ("scsi: ufs: core: Add CPU latency QoS support 
>> for UFS driver")
>> Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufs-sysfs.c |  2 +-
>>   drivers/ufs/core/ufshcd.c    | 16 ++++++++++++++++
>>   include/ufs/ufshcd.h         |  2 ++
>>   3 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
>> index 4bd7d491e3c5..8f7975010513 100644
>> --- a/drivers/ufs/core/ufs-sysfs.c
>> +++ b/drivers/ufs/core/ufs-sysfs.c
>> @@ -512,7 +512,7 @@ static ssize_t pm_qos_enable_show(struct device 
>> *dev,
>>   {
>>       struct ufs_hba *hba = dev_get_drvdata(dev);
>>   -    return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
>> +    return sysfs_emit(buf, "%d\n", READ_ONCE(hba->pm_qos_enabled));
>>   }
>>     /**
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 926650412eaa..f259fb1790fa 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1047,14 +1047,18 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
>>    */
>>   void ufshcd_pm_qos_init(struct ufs_hba *hba)
>>   {
>> +    mutex_lock(&hba->pm_qos_mutex);
>>         if (hba->pm_qos_enabled)
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
> Missing the curly braces for this If statement.

Hi Ziqi,
Thanks for the review, yes, i will fix it on v2
https://lore.kernel.org/all/20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com/
  
The internal test version does not contain this bug; in fact,
the internal test version is correct.

>> cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
>>         if (cpu_latency_qos_request_active(&hba->pm_qos_req))
>>           hba->pm_qos_enabled = true;
>> +
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
>>     /**
>> @@ -1063,11 +1067,15 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
>>    */
>>   void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>>   {
>> +    mutex_lock(&hba->pm_qos_mutex);
>> +
>>       if (!hba->pm_qos_enabled)
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
> Same here.

Acked.

>> cpu_latency_qos_remove_request(&hba->pm_qos_req);
>>       hba->pm_qos_enabled = false;
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
>>     /**
>> @@ -1077,10 +1085,14 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>>    */
>>   static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
>>   {
>> +    mutex_lock(&hba->pm_qos_mutex);
>> +
>>       if (!hba->pm_qos_enabled)
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
> Same here.

Acked.

>> cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : 
>> PM_QOS_DEFAULT_VALUE);
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
>>     /**
>> @@ -10764,6 +10776,10 @@ int ufshcd_init(struct ufs_hba *hba, void 
>> __iomem *mmio_base, unsigned int irq)
>>       mutex_init(&hba->ee_ctrl_mutex);
>>         mutex_init(&hba->wb_mutex);
>> +
>> +    /* Initialize mutex for PM QoS request synchronization */
>> +    mutex_init(&hba->pm_qos_mutex);
>> +
>>       init_rwsem(&hba->clk_scaling_lock);
>>         ufshcd_init_clk_gating(hba);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index 30ff169878dc..e81f4346f168 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -962,6 +962,7 @@ enum ufshcd_mcq_opr {
>>    * @ufs_rtc_update_work: A work for UFS RTC periodic update
>>    * @pm_qos_req: PM QoS request handle
>>    * @pm_qos_enabled: flag to check if pm qos is enabled
>> + * @pm_qos_mutex: synchronizes PM QoS request and status updates
>>    * @critical_health_count: count of critical health exceptions
>>    * @dev_lvl_exception_count: count of device level exceptions since 
>> last reset
>>    * @dev_lvl_exception_id: vendor specific information about the
>> @@ -1135,6 +1136,7 @@ struct ufs_hba {
>>       struct delayed_work ufs_rtc_update_work;
>>       struct pm_qos_request pm_qos_req;
>>       bool pm_qos_enabled;
>> +    struct mutex pm_qos_mutex;
>>         int critical_health_count;
>>       atomic_t dev_lvl_exception_count;


-- 
Thx and BRs,
Zhongqiu Han

