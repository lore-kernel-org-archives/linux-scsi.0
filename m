Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FFD37BE9B;
	Fri, 27 Feb 2026 21:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228370; cv=none; b=B5aM0UyYrzOHSSMYX78Lp72e6iVOdh0lOu/TBTgEwhsW9rO9sWOY2J0H79GNQPAsqqsk6L2uRq04kFYzSbCu8eGoWulWTyCoxaq08CPi4W8MLPsGvASPDpedXGag2khxIgvOChM3WAbU8lK4zWgeflk0gGA0fK4jcX4FIKQPiew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228370; c=relaxed/simple;
	bh=q07QquuZw7gPu2S5C22zoL1IzR5z6PJ+rlC/8oZNVec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MP1gUT44tFVuzq5PHd243Jl4zQ2nB9Fy440o87sv/ONWyWhzZmhb8ywlRg6o5EI+KS5HUNPOggmh6k133jXz79c/puXZbMdfizLRWZEgsVacUTidIWWkaIrpLpDk/OodYWZGWCs3TaPLLaYyoGC1Y+xZFTOtNQ+3tcN2slovvWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NhkOYwms; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NhkOYwms"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fN1tm4dVjzlffvb;
	Fri, 27 Feb 2026 21:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772228356; x=1774820357; bh=SOgpGjw+P1955vq4mqppC7E3
	mCs6HAXHDLc7ZOv92ms=; b=NhkOYwmsqiGiXtLjv+fVPpCwE6+gq7rqJm0WnIOt
	RShoKc0I5BczUik5tdzgDqyas+RZi3khUF6eIW04SxhHEA9FMwcPlylRkIr8CbuV
	EAYh5xydtcGTcNsuKruQ5l6v5dCmAPtj22YO6Z305AZuZhsgeMs3/Cbquuq+Ne8L
	YsXeSfEWJZbwbqlsork7ITJKNuylE70PiIiW5YQkLXUdvCq3FKSaDNzykNFRPfEu
	sZngXngwCBJmRnPwVxi1IQlfycnBZU3JaozGX9CZHaOyq1Sa9X5y7CxxBAP19vex
	qLof+SaIQSsOSpsuqILleHaMiV0juGi3pXeQqOgHMOmWTA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7QuWyJeNiRyQ; Fri, 27 Feb 2026 21:39:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fN1tV2wH3zlfl5n;
	Fri, 27 Feb 2026 21:39:14 +0000 (UTC)
Message-ID: <3bb51a3e-ff31-438c-a375-f5c94767a73c@acm.org>
Date: Fri, 27 Feb 2026 13:39:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] scsi: ufs: core: Add support for TX Equalization
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-5-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260227160809.2620598-5-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/27/26 8:08 AM, Can Guo wrote:
> +static bool use_adaptive_txeq;
> +module_param(use_adaptive_txeq, bool, 0644);
> +MODULE_PARM_DESC(use_adaptive_txeq, "Find and apply optimal TX Equalization settings before power mode change (default: false)");
> +
> +static int txeq_gear_set(const char *val, const struct kernel_param *kp)
> +{
> +	return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
> +}
> +
> +static const struct kernel_param_ops txeq_gear_ops = {
> +	.set = txeq_gear_set,
> +	.get = param_get_uint,
> +};
> +
> +static unsigned int adaptive_txeq_gear = UFS_HS_G6;
> +module_param_cb(adaptive_txeq_gear, &txeq_gear_ops, &adaptive_txeq_gear, 0644);
> +MODULE_PARM_DESC(adaptive_txeq_gear, "For the HS-Gear[n] and above, adaptive txeq shall be used");
> +
> +static bool use_txeq_presets = true;
> +module_param(use_txeq_presets, bool, 0644);
> +MODULE_PARM_DESC(use_txeq_presets, "Use only the 8 TX Equalization Presets (pre-defined Pre-Shoot & De-Emphasis combinations) for TX EQTR (default: true)");
> +
> +static bool txeq_presets_selected[UFS_TX_EQ_PRESET_MAX] = {[0 ... (UFS_TX_EQ_PRESET_MAX - 1)] = 1};
> +module_param_array(txeq_presets_selected, bool, NULL, 0644);
> +MODULE_PARM_DESC(txeq_presets_selected, "Use only the selected Presets out of the 8 TX Equalization Presets for TX EQTR");

Please minimize the kernel module parameters. Introducing new kernel 
module parameters is easy but removing these is hard. Can all the above
parameters be removed? If not, please only keep what is absolutely
necessary.

> +/* A HS-G6 capable M-TX shall support the presets. */
> +static const struct __ufs_tx_eq_preset {
> +	unsigned int preshoot;
> +	unsigned int deemphasis;
> +} ufs_tx_eq_preset[UFS_TX_EQ_PRESET_MAX] = {
> +	[UFS_TX_EQ_PRESET_P0] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_0P0},
> +	[UFS_TX_EQ_PRESET_P1] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_0P8},
> +	[UFS_TX_EQ_PRESET_P2] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_1P6},
> +	[UFS_TX_EQ_PRESET_P3] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_0P0},
> +	[UFS_TX_EQ_PRESET_P4] = {UFS_TX_HS_PRESHOOT_DB_1P6, UFS_TX_HS_DEEMPHASIS_DB_0P0},
> +	[UFS_TX_EQ_PRESET_P5] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_0P8},
> +	[UFS_TX_EQ_PRESET_P6] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_1P6},
> +	[UFS_TX_EQ_PRESET_P7] = {UFS_TX_HS_PRESHOOT_DB_1P6, UFS_TX_HS_DEEMPHASIS_DB_0P8},
> +};

Please mention in the comment above this array from what standard the 
above table comes.

> +static const u32 pa_peer_rx_adapt_initial[UFS_HS_GEAR_MAX] = {
> +	0,
> +	0,
> +	0,
> +	0,
> +	PA_PEERRXHSG4ADAPTINITIAL,
> +	PA_PEERRXHSG5ADAPTINITIAL,
> +	PA_PEERRXHSG6ADAPTINITIALL0L3
> +};
> +
> +static const u32 rx_adapt_initial_cap[UFS_HS_GEAR_MAX] = {
> +	0,
> +	0,
> +	0,
> +	0,
> +	RX_HS_G4_ADAPT_INITIAL_CAP,
> +	RX_HS_G5_ADAPT_INITIAL_CAP,
> +	RX_HS_G6_ADAPT_INITIAL_CAP
> +};
> +
> +static const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] = {
> +	0,
> +	PA_TXEQG1SETTING,
> +	PA_TXEQG2SETTING,
> +	PA_TXEQG3SETTING,
> +	PA_TXEQG4SETTING,
> +	PA_TXEQG5SETTING,
> +	PA_TXEQG6SETTING
> +};

Same comment for the above three arrays. Please add a comment that 
explains what standard these arrays come from.

> +	if (!local_precodeen && !peer_precodeen) {
> +		dev_dbg(hba->dev, "Pre-Coding is not required for either side\n");
> +		return ret;
> +	}

Here and elsewhere in this patch, please change "precodeen" into 
"precode_en". That will make it easier for readers to guess that
"precode_en" refers to enabling precoding.

> +/**
> + * ufshcd_evaluate_fom - Update TX EQ params based on FOM results
> + * @hba: per adapter instance
> + * @params: TX EQ parameters data structure
> + * @h_iter: host TX EQTR iterator data structure
> + * @d_iter: device TX EQTR iterator data structure
> + *
> + * Evaluate FOM results, update host and device TX EQ params if FOM results are
> + * improved, and record TX EQTR results.
> + */
> +static void ufshcd_evaluate_fom(struct ufs_hba *hba,
> +				struct ufshcd_tx_eq_params *params,
> +				struct tx_eqtr_iter *h_iter,
> +				struct tx_eqtr_iter *d_iter)
> +{
> +	u32 preshoot, deemphasis, fom_value;
> +	bool precode_en;
> +	int lane;
> +
> +	for (lane = 0; h_iter->is_new && lane < h_iter->num_lanes; lane++) {
> +		preshoot = h_iter->preshoot;
> +		deemphasis = h_iter->deemphasis;
> +		fom_value = h_iter->fom[lane] & RX_FOM_VALUE_MASK;
> +		precode_en = !!(h_iter->fom[lane] & RX_FOM_PRECODING_EN_MASK);

!! is superfluous when assigning to a boolean (precode_en).

> +static int __ufshcd_tx_eqtr(struct ufs_hba *hba,
> +			    struct ufshcd_tx_eq_params *params,
> +			    struct ufs_pa_layer_attr *pwr_mode)
> +{
> +	struct ufshcd_tx_eq_params *new_params;
> +	struct tx_eqtr_iter h_iter, d_iter;
> +	unsigned int preshoot, deemphasis;
> +	u32 gear = pwr_mode->gear_tx;
> +	ktime_t start;
> +	int ret;
> +
> +	new_params = kzalloc(sizeof(struct ufshcd_tx_eq_params), GFP_KERNEL);
> +	if (!new_params)
> +		return -ENOMEM;

Please combine the declaration of 'new_params' with its assignment and
use __free to simplify error handling, e.g. as follows:

struct ufshcd_tx_eq_params *new_params __free(kfree) = 
kzalloc(sizeof(struct ufshcd_tx_eq_params), GFP_KERNEL);

> +	/* TX EQTR main loop */
> +	for (preshoot = 0; preshoot < TX_HS_NUM_PRESHOOT; preshoot++)

Please surround the body of this loop with braces ({}).

> +		for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++) {
> +			if (!tx_eqtr_iter_update(preshoot, deemphasis, &h_iter, &d_iter))
> +				continue;
> +
> +			/* Step 3 - Apply TX EQTR settings */
> +			ret = ufshcd_apply_tx_eqtr_settings(hba, pwr_mode, &h_iter, &d_iter);
> +			if (ret) {
> +				dev_err(hba->dev, "Failed to apply TX EQTR settings: %d\n",
> +					ret);
> +				goto out;
> +			}
> +
> +			/* Step 4 - Trigger TX EQTR procedure start */
> +			ret = ufshcd_trigger_tx_eqtr(hba, gear);
> +			if (ret) {
> +				dev_err(hba->dev, "Failed to start TX EQTR procedure for target gear %u: %d\n",
> +					gear, ret);
> +				goto out;
> +			}
> +
> +			/* Step 5 - Get FOM */
> +			ret = ufshcd_get_rx_fom(hba, pwr_mode, &h_iter, &d_iter);
> +			if (ret) {
> +				dev_err(hba->dev, "Failed to get RX_FOM: %d\n",
> +					ret);
> +				goto out;
> +			}
> +
> +			ufshcd_evaluate_fom(hba, new_params, &h_iter, &d_iter);
> +	};

Please remove the superfluous semicolon past }.

> + * It ensures that EQTR starts from the most reiliable link state (HS-G1) with

reiliable -> reliable

> +static void ufshcd_tx_eqtr_unprepare(struct ufs_hba *hba,
> +				     struct ufs_pa_layer_attr *pwr_mode)
> +{
> +	int err;
> +
> +	if (pwr_mode->pwr_rx == SLOWAUTO_MODE || pwr_mode->hs_rate == 0)
> +		return;
> +
> +	err = ufshcd_change_power_mode(hba, pwr_mode, /*force_pmc=*/false);
> +	if (err)
> +		dev_err(hba->dev, "%s: Failed to restore Power Mode: %d\n",
> +			__func__, err);
> +}

What should happen if restoring the power mode fails?

> +int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
> +				 struct ufs_pa_layer_attr *pwr_mode)
> +{
> +	struct ufshcd_tx_eq_params *params;
> +	u32 gear, rate;
> +	int ret = 0;

Please remove the local variable 'ret' and move it into the two scopes
in which it is assigned a value.

> +	if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
> +		return ret;

To improve code readability, please change "return ret" into "return 0".

> +	} else if (gear < adaptive_txeq_gear) {
> +		return ret;
> +	}

To improve code readability, please change "return ret" into "return 0".

> +		params->is_applied = true;
> +	}
> +
> +	return ret;

To improve code readability, please change "return ret" into "return 0".

>   /*
>    * PHY Adapter attributes
>    */
> -#define PA_PHY_TYPE		0x1500

Please refrain from making whitespace changes in existing code in a 
patch that is already too big.

>   /* Adpat type for PA_TXHSADAPTTYPE attribute */

Adpat -> adapt

Thanks,

Bart.
