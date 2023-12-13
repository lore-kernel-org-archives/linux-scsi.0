Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="gHHBiUOU"
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [IPv6:2a00:1098:ed:100::25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7ECB0
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 02:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1702465195;
	bh=f7oFYjuEhLv10FZ/GqNK5bJ0ESqYP8VTVwEBkmP3swA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gHHBiUOUOcSbPaz/K/S2U4DuTzSymWsizm1pM1TZa+HqSLoOAs6MvS03PIDweWuAl
	 PXlloz159ssPpNd54D7CTbHR9kbGykVHN7chvbFFKQNRnNmcF72qLmYsKfItJ6Kv7R
	 Y+ZqweU2icahiC+e7vkLVKF2DHKF3K8GSlcV8U6hW4zlch23gKF8WBZ1F7v3KVOqG0
	 Bqm1YSfQcO+Yi4kWNn+Ljp4glJRRxNcto9Yhw7CUOgcVgvB0WMLu8NjOQTpHgVcauY
	 rq6blUpNs9EGg5J+922osEaVDyRwLYOYCo8WvrEsHqm6bp91cNLIl2Y5dPPTse+QWM
	 J/kDCOB3eUHXQ==
Received: from [100.113.186.2] (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id AAD6C3781453;
	Wed, 13 Dec 2023 10:59:54 +0000 (UTC)
Message-ID: <ecf4d4f8-8232-44bc-b1a0-c6bd4b579949@collabora.com>
Date: Wed, 13 Dec 2023 11:59:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] ufs: core: Add CPU latency QoS support for ufs
 driver
Content-Language: en-US
To: Maramaina Naresh <quic_mnaresh@quicinc.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, stanley.chu@mediatek.com
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <chu.stanley@gmail.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 quic_cang@quicinc.com, quic_nguyenb@quicinc.com
References: <20231213103642.15320-1-quic_mnaresh@quicinc.com>
 <20231213103642.15320-2-quic_mnaresh@quicinc.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20231213103642.15320-2-quic_mnaresh@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 13/12/23 11:36, Maramaina Naresh ha scritto:
> Register ufs driver to CPU latency PM QoS framework to improve
> ufs device random io performance.
> 
> PM QoS initialization will insert new QoS request into the CPU
> latency QoS list with the maximum latency PM_QOS_DEFAULT_VALUE
> value.
> 
> UFS driver will vote for performance mode on scale up and power
> save mode for scale down.
> 
> If clock scaling feature is not enabled then voting will be based
> on clock on or off condition.
> 
> Provided sysfs interface to enable/disable PM QoS feature.
> 
> tiotest benchmark tool io performance results on sm8550 platform:
> 
> 1. Without PM QoS support
> 	Type (Speed in)    | Average of 18 iterations
> 	Random Write(IPOS) | 41065.13
> 	Random Read(IPOS)  | 37101.3
> 
> 2. With PM QoS support
> 	Type (Speed in)    | Average of 18 iterations
> 	Random Write(IPOS) | 46784.9
> 	Random Read(IPOS)  | 42943.4
> (Improvement with PM QoS = ~15%).
> 
> Co-developed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>
> Signed-off-by: Maramaina Naresh <quic_mnaresh@quicinc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 127 ++++++++++++++++++++++++++++++++++++++
>   include/ufs/ufshcd.h      |   6 ++
>   2 files changed, 133 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ae9936fc6ffb..7318fa480706 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1001,6 +1001,20 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
>   	return ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6;
>   }
>   
> +/**
> + * ufshcd_pm_qos_update - update PM QoS request
> + * @hba: per adapter instance
> + * @on: If True, vote for perf PM QoS mode otherwise power save mode
> + */
> +static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
> +{
> +	if (!hba->pm_qos_enabled)
> +		return;
> +
> +	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0
> +							: PM_QOS_DEFAULT_VALUE);

This fits in one line.

> +}
> +
>   /**
>    * ufshcd_set_clk_freq - set UFS controller clock frequencies
>    * @hba: per adapter instance
> @@ -1147,8 +1161,11 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq,
>   					    hba->devfreq->previous_freq);
>   		else
>   			ufshcd_set_clk_freq(hba, !scale_up);
> +		goto out;
>   	}
>   
> +	ufshcd_pm_qos_update(hba, scale_up);
> +
>   out:
>   	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
>   			(scale_up ? "up" : "down"),
> @@ -8615,6 +8632,109 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
>   	ufshcd_release(hba);
>   }
>   
> +/**
> + * ufshcd_pm_qos_init - initialize PM QoS request
> + * @hba: per adapter instance
> + */
> +static void ufshcd_pm_qos_init(struct ufs_hba *hba)
> +{
> +
> +	if (hba->pm_qos_enabled)
> +		return;
> +
> +	cpu_latency_qos_add_request(&hba->pm_qos_req,
> +					PM_QOS_DEFAULT_VALUE);

same here.

> +
> +	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
> +		hba->pm_qos_enabled = true;
> +}
> +

Apart from that,

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


