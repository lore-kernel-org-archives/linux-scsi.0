Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D8526A1B6
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 06:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573802; cv=none; b=A9XJWod6YrOwbYf8F099E7yULHhxlpBmoSzMniL78nH0BIb/Y7dGTRhBq8DFw2mc/swjjXFQwOZxRLVHVhfxDs05QmaCj3puRwTBP48jCFd+OeaHgXjrmWnpc8WQiTDfHl7a2aKb7hcKq2MGZus5oQYQYYTzgzwmEmZ3BnIfhsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573802; c=relaxed/simple;
	bh=sblEJvuu+yGOs0V9hFTmaATfIDhOqrS8xdqAJkutzKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CeuwtBZRgvfBj7XIrvq3uC/VmSlVs2i9IWG/q9QfR4fISlyoyLZoz9fH3cSsLn79/50wEXVXLTN9fgv/+Nk8hDkHSvhC//UtH67B1Wfy9FPgzzdwH8FJ2wPPhbh1h5NbVN8az2Y3d9Z94codjJX5cFE5Wll43lCXEfk0GhN9ucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k7TB30xJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k7TB30xJ"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B2J1ng016853
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 06:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	L0/f9kwfpciu7DfEkuARJ15E4Z8kw8VAZZm5KrXW658=; b=k7TB30xJ6YBYISUC
	t1Xchjhihv1zKFGNzmUAnVSpbPi3lhNYnUNDoYH/lkA3LUpiznRCmDrhD28ZYrI1
	LI8R5eV1SA/r0ZiZ2JJJ0xvi+CBQa8EJRVtevg/KtY8021k8r63iKHPRPnALlEQp
	l8lQO0YBOk4JQ4/LJV1O5inedvf0G+NdnUDpUIdfEGmGy3LjW1OGx5WRT6kAW9tZ
	HUPPc4DnX3YPmeABeRNheK1z2q8cbyR+Zu9aQl05f8xjJsFR4+tdJcDl/PAhA4Dx
	FN1W5h2xlddmbrD7+/TOM1O8Y5ML0/PZsFKTmXClSWscA7U07TgGcqGs9a0q2NXg
	sG5aFQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 491t38328s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 06:56:39 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7741ef59d18so381092b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 23:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757573798; x=1758178598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0/f9kwfpciu7DfEkuARJ15E4Z8kw8VAZZm5KrXW658=;
        b=FDsvqqM7dlsx1w7plMmPN+eaqP78RYyuR/UtRiCtG+5+LCDGcBu4U3w+qtVOkzjZ+3
         XlVl7vMdMxe7yd9QT0IZ1347FMGIj8oOeoBTSZzmYLvjv7aF9iIkK78jGtbMnseK2VOL
         wjMYanBRcabln9olKJtuz5kjOaQ95+sg1SgrEdPhbPasNyx0THF9uv3OBuOwBodBM3JP
         2VopQdm+kWt8Ztwxdd/ds32Env4FqGtHB9CLY+KQi2UkAmANRJE1cpJBZu0LB6o+2Jir
         vkfXYAAkSxSzI8YPXSgIAipqPqSVGGvC+indyPsFIgBMwYP1TDbcsvQBxXKAj2k7DaQi
         nM1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3OcK4A54860mwQwhNQ8RR+Pvi/avMZKmLqvTo3+wJbcnhY4MSeRp1ZBIIBRyWrHNse6QRb6al7caB@vger.kernel.org
X-Gm-Message-State: AOJu0YzR6M4x+/jj+SEZeRLnSS0cdJbn/mqpGrYdglN81qPzHHoLO7Cl
	9vvqLxXgC8abJxDzqWqVs85Xr3VxEotQv6IeY75RyX51WY8yO8K3oCalg/IKq9sCKyMsOctwliB
	EvfybYe7bUuodHD5T7okm9QQjjLmYwY9cIdfTizhGwY6camc4kbNKic+xGm8MgctegTNWb1tE
X-Gm-Gg: ASbGncuCQISrlMmaBZ08WC60tkPQplEcaYBlX3XIZ//8WbHWCUUjkd5kgEdIOqTfbVm
	E9QZuuYk/CO5QIzoUQVPZv+/yE/9DE8Z67Jk3w2By9jqjnp3AwaYsFfmfjxkT8OVz59f+dES8fi
	6oKkpqHQvUvJi6d+MITU1nAV6DOiter40SoPoMzrnPhXfedspLWZV0IaymzCfGEgMtIyaEv9XkZ
	shJKcV7LjZ/T234Zw4wvl2gYlggM4LEoo6WxrRNJf/FaskCDU5sIvVnbp9w4fZ7Q2uGuNWAS6V3
	GdYqKSDWYNI2BUvlwmHM5B/eOJy2A0vfL2NW3VdaqTxcCxeSMdVlAbDTfBCtHNwtcoKWFefAh+n
	+ysb0kpOMA9wPas3/ZsJDnoPcVXCjWLk=
X-Received: by 2002:a05:6a00:13a0:b0:770:579a:bb84 with SMTP id d2e1a72fcca58-7742dca7eb8mr19249047b3a.5.1757573798338;
        Wed, 10 Sep 2025 23:56:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQJqIhfBQbD1AYfL/Znlo74DGsw2IRepNE1WdWQRW2mKhFrPcwTfZ5gu3E11Lb2M8x804pDw==
X-Received: by 2002:a05:6a00:13a0:b0:770:579a:bb84 with SMTP id d2e1a72fcca58-7742dca7eb8mr19249026b3a.5.1757573797778;
        Wed, 10 Sep 2025 23:56:37 -0700 (PDT)
Received: from [10.133.33.180] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b33c45sm966960b3a.71.2025.09.10.23.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 23:56:37 -0700 (PDT)
Message-ID: <730f8cdd-e863-4b33-96b3-dcfb9cea7e1e@oss.qualcomm.com>
Date: Thu, 11 Sep 2025 14:56:29 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com,
        zhongqiu.han@oss.qualcomm.com
References: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
Content-Language: en-US
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: jWrCWU0TkvVfYIHTgj-6JCD_CPMyA9x4
X-Proofpoint-GUID: jWrCWU0TkvVfYIHTgj-6JCD_CPMyA9x4
X-Authority-Analysis: v=2.4 cv=NdLm13D4 c=1 sm=1 tr=0 ts=68c272a7 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=7YBbx7_t3QDw2YeiogQA:9 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDA2NiBTYWx0ZWRfX37VQT//W0bHZ
 8gFrQKWGstVIErFczRmR4RN4LElh1qZuky/+cJvGht3BhhZn0iMuGmV1gmMpZ72mw56rqxnVfBN
 5IbcI5Cde1c8V+WFwGdp5LxpuymCoMvcTTZDog6RpCHt5qTgcCh9oy9TPU0yXp9vqqmZf16BzXD
 ir0kwuWBjKNUIZv7vccTid1tq8WL6mo7c2jVRJffxsK+2HAuMMcx58T2AF9K1VOgCAP0V0HTDDT
 caGlRGFyzJ9sxq+GsNw72JDjzF8lM6zgzEQHbV1wJrS6PolRG/3s+1R4Xn/SzsjbqlMOBC5GkhH
 BlvOoLqDjmQQUWmn1oOr1dwB8PN/AVKKup1KVrmanMfqUR0PGEe7N+H4qROFQhpVYfzAu4JDA6X
 iEeUlGL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509080066

On 9/2/2025 3:48 PM, Zhongqiu Han wrote:
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

Hi Martin K. Petersen,

Just a gentle ping on this patch,

Would appreciate any feedback when you have time. Thanks!




> ---
> v1 -> v2:
> - Fix misleading indentation by adding braces to if statements in pm_qos logic.
> - Resolve checkpatch strict mode warning by adding an inline comment for pm_qos_mutex.
> - Link to v1: https://lore.kernel.org/all/20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com/
> 
>   drivers/ufs/core/ufs-sysfs.c |  2 +-
>   drivers/ufs/core/ufshcd.c    | 25 ++++++++++++++++++++++---
>   include/ufs/ufshcd.h         |  3 +++
>   3 files changed, 26 insertions(+), 4 deletions(-)
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
> index 926650412eaa..98b9ce583386 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1047,14 +1047,19 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
>    */
>   void ufshcd_pm_qos_init(struct ufs_hba *hba)
>   {
> +	mutex_lock(&hba->pm_qos_mutex);
>   
> -	if (hba->pm_qos_enabled)
> +	if (hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
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
> @@ -1063,11 +1068,16 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
>    */
>   void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>   {
> -	if (!hba->pm_qos_enabled)
> +	mutex_lock(&hba->pm_qos_mutex);
> +
> +	if (!hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
>   
>   	cpu_latency_qos_remove_request(&hba->pm_qos_req);
>   	hba->pm_qos_enabled = false;
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }
>   
>   /**
> @@ -1077,10 +1087,15 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>    */
>   static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
>   {
> -	if (!hba->pm_qos_enabled)
> +	mutex_lock(&hba->pm_qos_mutex);
> +
> +	if (!hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
>   
>   	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }
>   
>   /**
> @@ -10764,6 +10779,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
> index 30ff169878dc..a16f857a052f 100644
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
> @@ -1135,6 +1136,8 @@ struct ufs_hba {
>   	struct delayed_work ufs_rtc_update_work;
>   	struct pm_qos_request pm_qos_req;
>   	bool pm_qos_enabled;
> +	/* synchronizes PM QoS request and status updates */
> +	struct mutex pm_qos_mutex;
>   
>   	int critical_health_count;
>   	atomic_t dev_lvl_exception_count;


-- 
Thx and BRs,
Zhongqiu Han
