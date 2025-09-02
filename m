Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74612DECB1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756795412; cv=none; b=tK5hoGmZalFvk1f3JkhRc+PdYboRsSvps6pb2Fc7OWhNuQ9bROBjFDgtKq9tY3Pr0CjJYH+ALYzxz+H2ViBCsXAKzgNiXm8pAPw4GCsuArBAxEJYdIwkV3aHHtVbaYE/HeBoFRrUcbPuIeJnb2E0LV745dueJFIQQ84EF8+R+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756795412; c=relaxed/simple;
	bh=eQHkJIMj4GLSh/E8+eAhQ3z9EzguvaN1cFQ4hEnsI1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QmjDTdMgSOhv2upXxIQ6WRYSDcT2dtEZk09XjkkDVYWkv43j4IAuLtFtzXCY+hZ8gg30k1zwtPYq3DnKZJF6tnfOcn0ra4rXsIZy72n7rUNVgLk6kt/RjhLRABLGubKudQDzcDdEE8KeyjjDGV39SSVNUdWjM/bv6WFPwuBiWOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ToHadPwI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ToHadPwI"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5822S6r8025232
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2025 06:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wqwzz7vQBwmgJDGDQ5Zr46ApYXaYEYSR8DBAfoF7V9s=; b=ToHadPwIeajG0O8E
	+uFvCWqi7NDZKSqIGlVWiq3+HXwZo0xV8yfDAS2lyczpn6wEOrc4qCAFYTV34giQ
	9GpXZgutJbLVX8jfCsl9nRvAiXpkeunhY1ZkLOGg5d8QCiY1El6UoL5xINKbhqIX
	0v+3AYna71sa3V/zromdrcuHQql97mYjE3RV9RGYhEqUXACPZ3zvmgkxY/5SJAsw
	dafv/bnc/LR2xpNRJAq3zAJtLz/9Osa37V1yJ9mzE7Kjlkr4XQtWakSyxGArwa9E
	+AKGtdB4+syUb+nAVJYJjJne1HF8ls7eDAJi8BXi0PuFk6NnalAEJptHtO0DyU4i
	923yWw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48uscuxu5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2025 06:43:29 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b4f738792b0so2429879a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Sep 2025 23:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756795408; x=1757400208;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wqwzz7vQBwmgJDGDQ5Zr46ApYXaYEYSR8DBAfoF7V9s=;
        b=ezlUCt2zyzYRicM7sOEbL/6mPJV8tns1B7La1X7i5tHVwGvLgIDdlA9vfFPwe+0s70
         ocvOC/xbLzVOvEkxgz4lybT2WflnYFtvBJaffNRZb9CwRckfr9WEWoP/pKg8vS6+ktvF
         wf7duKQcyW1t2Q/NRR/QBWAP3PpxOBH8sOT+zNr0apLW0Uo02/YEf+9ZyVGvIYWady/u
         jQ3IpDsg2tDqfGdq5NyKswPqK6MKe67J4XNeZHXVmJUf+sQz2CgUPMB+242OSjgfDaN2
         6yPCQPjG6qHIZY48cCEo7TbOnH9IYrxurwyZyQeHf7rPn38COCeWCz9OqC4Le53w129F
         JyVg==
X-Forwarded-Encrypted: i=1; AJvYcCVVDzUwHfkgcIHRJGsQkl4ZiQ9lEe/5BaXhJRJGqio2CJdHEXAvtV9o3SFMOJMEigJjiLgPF3trQ/tc@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy00Kv52jPzEgWjc2QQmvGgnXJQ3zVgZYelClDR3taOAnD5YfC
	ffH5Ls9mn3DLC1S+ok8CzQiw+uUWWSH+JGsfdpVcbrsX61oVVbwr8XzE7bc0P/9ED6qtIlBEqsu
	ul9lDTBYQmFJZAOgVCLUEeM4JTOYQldQFikmepXToqVWXanu4UlSkjYn6Q0bmXWQl
X-Gm-Gg: ASbGncsERo2IS5fs4T69K3nPhEY6A6044JE0eIloqM0FrLhYCr7llzUTdFXDm0PxmAu
	FaxvfJh+UvPFVtcrlq/yDWMJJkMIEHyJ1Sa/MWKw7mvRssC8UtMIkbZWI40TGB31WBOwjfdABDq
	kbOldljQjqcwGzYTqG+q7Mbr8UoF03GCrS4NOL7K5VATNdbEaLLyk8wsao3vhzg7gWpO7NGBQtC
	5ME2Z8vAdkgSi45/w4vo1SlkpRgiTQkCqHJqV04MvUlYfls9muVZMZsFr0gVGDIdcSRe9OvcNuC
	j1+R1IcmGPA4FVCI/aCcRGWwDeOW7Ecm7A/1uv0BF9Xqkya9gBitFMneZRvw4jkI
X-Received: by 2002:a05:6a20:939d:b0:243:d432:3d50 with SMTP id adf61e73a8af0-243d6f885bbmr14010533637.56.1756795408508;
        Mon, 01 Sep 2025 23:43:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfc90fOfbafaS1yPL+ADGfwHyRWbfJVbN9Bw1aOX+e9aSn/HDowpEl4WyiFudM3cxJ1cYlhQ==
X-Received: by 2002:a05:6a20:939d:b0:243:d432:3d50 with SMTP id adf61e73a8af0-243d6f885bbmr14010499637.56.1756795407978;
        Mon, 01 Sep 2025 23:43:27 -0700 (PDT)
Received: from [10.239.155.136] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcf0567sm18729666a91.27.2025.09.01.23.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 23:43:27 -0700 (PDT)
Message-ID: <1174ecf9-b806-4c2d-b755-8a3cd594d337@oss.qualcomm.com>
Date: Tue, 2 Sep 2025 14:43:19 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>
Content-Language: en-US
From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
In-Reply-To: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfX5oex/Wo+lK3o
 mhK0E9g9YbpcAj3RhDGzzfytSiJ/rDnnUsS8d+jmGU4wZBoqj4wzT+EZVm6bv/lKTdFe4Tdguu9
 E/G9zKoXDomvc6Pe2L3MY/1gjLnGYg5nGOeMMEU1Qc5cwpYgIEYM/G2OrT7+cgOciP9aONzs+lH
 di7ufBbyfFR3htomBTNfM3Nomcvae2njENEE6yVwza8OrNJPqdai2aKiAg2Xhqrk5gxj47qm5M0
 ts8EMhXZ472F/1aAJTYZFP0a0BAey1t/2dWkTUuqRe84g8DZ7/BuzRY7eGD0yM4alwjVR7U1Eg9
 xMDI9+68sqBslj6v13KvnhZHW5Zl77XUvHAu7BUzxk/dCqX+wdOtpMg4njfe3ysh1tsD+CuNtZD
 lNTYQEBX
X-Authority-Analysis: v=2.4 cv=A8xsP7WG c=1 sm=1 tr=0 ts=68b69211 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=6LOm9izlHsDA83q8FugA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: PLYQmJAg1BTZCFeceVeEeJRXKr8DTo5U
X-Proofpoint-GUID: PLYQmJAg1BTZCFeceVeEeJRXKr8DTo5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300031


On 9/1/2025 4:51 PM, Zhongqiu Han wrote:
> The cpu_latency_qos_add/remove/update_request interfaces lack internal
> synchronization by design, requiring the caller to ensure thread safety.
> The current implementation relies on the `pm_qos_enabled` flag, which is
> insufficient to prevent concurrent access and cannot serve as a proper
> synchronization mechanism. This has led to data races and list corruption
> issues.
>
> A typical race condition call trace is:
>
> [Thread A]
> ufshcd_pm_qos_exit()
>    --> cpu_latency_qos_remove_request()
>      --> cpu_latency_qos_apply();
>        --> pm_qos_update_target()
>          --> plist_del              <--(1) delete plist node
>      --> memset(req, 0, sizeof(*req));
>    --> hba->pm_qos_enabled = false;
>
> [Thread B]
> ufshcd_devfreq_target
>    --> ufshcd_devfreq_scale
>      --> ufshcd_scale_clks
>        --> ufshcd_pm_qos_update     <--(2) pm_qos_enabled is true
>          --> cpu_latency_qos_update_request
>            --> pm_qos_update_target
>              --> plist_del          <--(3) plist node use-after-free
>
> This patch introduces a dedicated mutex to serialize PM QoS operations,
> preventing data races and ensuring safe access to PM QoS resources.
> Additionally, READ_ONCE is used in the sysfs interface to ensure atomic
> read access to pm_qos_enabled flag.
>
> Fixes: 2777e73fc154 ("scsi: ufs: core: Add CPU latency QoS support for UFS driver")
> Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
> ---
>   drivers/ufs/core/ufs-sysfs.c |  2 +-
>   drivers/ufs/core/ufshcd.c    | 16 ++++++++++++++++
>   include/ufs/ufshcd.h         |  2 ++
>   3 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 4bd7d491e3c5..8f7975010513 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -512,7 +512,7 @@ static ssize_t pm_qos_enable_show(struct device *dev,
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   
> -	return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
> +	return sysfs_emit(buf, "%d\n", READ_ONCE(hba->pm_qos_enabled));
>   }
>   
>   /**
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 926650412eaa..f259fb1790fa 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1047,14 +1047,18 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
>    */
>   void ufshcd_pm_qos_init(struct ufs_hba *hba)
>   {
> +	mutex_lock(&hba->pm_qos_mutex);
>   
>   	if (hba->pm_qos_enabled)
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
Missing the curly braces for this If statement.
>   
>   	cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
>   
>   	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
>   		hba->pm_qos_enabled = true;
> +
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }
>   
>   /**
> @@ -1063,11 +1067,15 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
>    */
>   void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>   {
> +	mutex_lock(&hba->pm_qos_mutex);
> +
>   	if (!hba->pm_qos_enabled)
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
Same here.
>   	cpu_latency_qos_remove_request(&hba->pm_qos_req);
>   	hba->pm_qos_enabled = false;
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }
>   
>   /**
> @@ -1077,10 +1085,14 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>    */
>   static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
>   {
> +	mutex_lock(&hba->pm_qos_mutex);
> +
>   	if (!hba->pm_qos_enabled)
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
Same here.
>   	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }
>   
>   /**
> @@ -10764,6 +10776,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	mutex_init(&hba->ee_ctrl_mutex);
>   
>   	mutex_init(&hba->wb_mutex);
> +
> +	/* Initialize mutex for PM QoS request synchronization */
> +	mutex_init(&hba->pm_qos_mutex);
> +
>   	init_rwsem(&hba->clk_scaling_lock);
>   
>   	ufshcd_init_clk_gating(hba);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 30ff169878dc..e81f4346f168 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -962,6 +962,7 @@ enum ufshcd_mcq_opr {
>    * @ufs_rtc_update_work: A work for UFS RTC periodic update
>    * @pm_qos_req: PM QoS request handle
>    * @pm_qos_enabled: flag to check if pm qos is enabled
> + * @pm_qos_mutex: synchronizes PM QoS request and status updates
>    * @critical_health_count: count of critical health exceptions
>    * @dev_lvl_exception_count: count of device level exceptions since last reset
>    * @dev_lvl_exception_id: vendor specific information about the
> @@ -1135,6 +1136,7 @@ struct ufs_hba {
>   	struct delayed_work ufs_rtc_update_work;
>   	struct pm_qos_request pm_qos_req;
>   	bool pm_qos_enabled;
> +	struct mutex pm_qos_mutex;
>   
>   	int critical_health_count;
>   	atomic_t dev_lvl_exception_count;
