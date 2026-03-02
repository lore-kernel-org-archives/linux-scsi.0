Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75B175A85
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772423210; cv=none; b=RoY56cdRQxaC+dKn3t4JzREuQ8q3av0Xfeh7091/xNwN5MRe48ewrUw7WftQm/34RpvNPDaNLTVUrCMTk+DlqpxOr3SbNMWRqcvdFtc67u4qMBEpKLXb4CMWS9T6gFoXV+4/llElVZzZyXtNiBItomd+DVOiPivAS8hkQXz5CIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772423210; c=relaxed/simple;
	bh=HdsIAujIFNuJUi1gYgJ4nzyO8z4usUFzdsGUlnJtnN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/nDP5Mx3MZ/3XgqMOC0+TBxNsLHDDWACLW2rOOHW8PWEbbgVvI4n2P7PECfePVRtOhUI4qqwrxtAWqmJXMg2Mzo7smOHh4I6NwkgzVxeO4f3cw1EyirkUmIR7bJhTuARriI5O448Q1OUoJCS/OHd67ad+JJUB2f+LEEVKoBqbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YjQ6Gn/L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HzN+dYwH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YjQ6Gn/L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HzN+dYwH"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6220Roxg2964276
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 03:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B1iKbHy9ECQl1o6LO7wfHbMbuxEuMM5OTQDw7BbR9Yo=; b=YjQ6Gn/LUmfXkF2/
	MiJHIf2h506PRMUJI029XqMpMtg7BVGUUizUxNmGS/URisjeyoFHPAWaRgb5nGKr
	98cbhOX4UPGSU6XkrlH/Jz1g+3ScpNy1SyIbiFO3tZAMPKEAvZRE//hwrDcSjrO0
	f4lqHEVgu4S/xcRjzvIxPj8hGVOkoozUJscVK2hP/rjHAEYcY6T8a7sGReBBQXj8
	v2yWuzHTdbYDz1P5tNTOR3ICVSSWv/BOgnemtp0zbsuWLOemzZ6dHRoKnyWBTmMy
	KHhsjHDE4jge4lQAT3BnDWrWQts81IorfDeHl9puDWVARpcYVGlWhTvJEDuRjIpi
	0+hNrA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cmgbasj3w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 03:46:48 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35979a03106so1593802a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 19:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772423207; x=1773028007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B1iKbHy9ECQl1o6LO7wfHbMbuxEuMM5OTQDw7BbR9Yo=;
        b=HzN+dYwH9d5oQbgxa3No8O3lTdKOG9zHSxrgixWksiymZr1FT9Ahyqm5MbNLRnxryA
         kcOtphUnLErkAbKNlRAJ5WmB++1E+vIVZXxl7ypSs2WS043YYVL7O3kIMUdkgmFeod0z
         dsgPPgb79c+u98sEFzYa5XulOnZqSVsHjOLizZUCuXq7eu/uDwKEaKuFOR451cFwtwSW
         4+HPogErizRuhuAdk95Rl+qT0xjffklgThbCUxmN+/uCBZ6bbIbW/4wAuXvDHpEN0jYK
         oQOkg+1d5HoLBbQEn5BSYHrgZ8CZqDT1KXVJqI8sLk24pThCVvBbm1xEc6YRbQ6xWzzb
         sk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772423207; x=1773028007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1iKbHy9ECQl1o6LO7wfHbMbuxEuMM5OTQDw7BbR9Yo=;
        b=HeNJurFWxChpS5pA8JpkXyFLTKXl2+re7fhNZ16v4+EuVwq7l+PJ/0ybOhgxtT6FLD
         UakEMQr7kwQTTQjWqldk9TBkQNN53J4gJja6UZk0v9l+pkHkg77XSAssmBZVJQuIEu55
         7feiFnS2uss4yYdRyBoSTq0YuAi8i2XiFD46GR4DK74/PZO0WhPD42SAEgtyU0Yyum6M
         VVdHyDUIjnKMf72wFoScK2X2dZHCNSGOxRsYDuYq3YGYh6Lft0dKeZovLOTJzpNUD6pm
         jDP3hTTgJ0wcQAH44pvX2JewgZjbMPMd12ggP9l+0dqw/iRm3QAdGc2tc94e6PRrV7dr
         y7JA==
X-Gm-Message-State: AOJu0YzTYe7QU+rP1JKHySmA9RobzBBmFgPHCzQro21oYO8ziOoiM89d
	iW+vK/oam3nvf2U45eP8PihAY669MiPID+Fp7WUp3woaJBxAMjwws3vlqoM1tNcO1w/Vkr4SPEc
	Mmb5RNbMgcdaycK1egMwK9x7GsMEzwDKkxKxw+TVNzK41ulh9N1z9IW31YUn6WP3w
X-Gm-Gg: ATEYQzwx+DbjIyJaCX268TRdzgAkhew8j8lgCrCIE6hi4rWzkdgcIqE+mYW05yP3F8F
	bN7h2GH2odW7h1ldNLlrk6J+tf09650+iFhG7oSTfo/gM9A8SKyfH1YGbLrILcsEfh7nJU+82vz
	h6/pgiymEYZe31ZbDfNswJP2DQ2EpTsC0+KXFISTGwHCveQRxbYbtGvOOyP68FJR7Yq/w7aXdfp
	QuaQiUhuXDDIFvL0ufBU3D/thIlf5yygsXWNNsvv7D1DeWLdAtzevAxghYfVR8A0zILVYSUOP13
	m/qzA/wZyLOHXzWpU/Svu0aPf0yeHL4IyyJnjpdSZkX3kxxS0pkfMnlXpix1tOx8j8Kay6yTa+y
	Zpg5d78z2DcR7JbT/ktmavXD3LpOT31LIvf6nWLrdkS0OT5Y=
X-Received: by 2002:a05:6a20:7350:b0:38b:d95d:efd7 with SMTP id adf61e73a8af0-395c3b03ebemr10636238637.44.1772423207137;
        Sun, 01 Mar 2026 19:46:47 -0800 (PST)
X-Received: by 2002:a05:6a20:7350:b0:38b:d95d:efd7 with SMTP id adf61e73a8af0-395c3b03ebemr10636208637.44.1772423206494;
        Sun, 01 Mar 2026 19:46:46 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa82dab1sm9898145a12.27.2026.03.01.19.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 19:46:46 -0800 (PST)
Message-ID: <5ef5dda6-9756-4c01-be0a-1c2dce9ac264@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 11:46:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] scsi: ufs: core: Add support for TX Equalization
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-5-can.guo@oss.qualcomm.com>
 <3bb51a3e-ff31-438c-a375-f5c94767a73c@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <3bb51a3e-ff31-438c-a375-f5c94767a73c@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDAzMCBTYWx0ZWRfX0bx1xE6KJWTN
 7fgpUV7NSLe9KR/PHT9N5VVcnFYClv6UYki3rUrFwTo5r9pt3oo15uwX8qvfwClMTuGuZ9l5rHp
 waaGvGm19v5LhTZEQgFQ1apjrSgUSjrfhln5Cw9wt6+QqyfJrbHB3Xh79YBPpoJ8y2zoQHMKJth
 ANfGQuzQmJYJQ2Xr71E1Puc28Z8yLYCV8Rk3fy9iJThUPtVBm+QeCE+Xpsa3RbL74yYJIe2ma5d
 r2dgLzdV0uV+/LTVAkTlPQIOP0Sib6cNGWaIfFXKq6XW0eyc1MDZjmoiFUAcS6zhRgoQibuuajY
 pTca3HiG8Zsx1+wH6dMuNQJ6XV8/F+9ov2dvStlatc1BAbZuRA1DR4zVl9nC4x+/247oLsMZJrV
 MJ0XbcoWP9NTuy82UL7m+M/ZVYUAbRlO4+sLE5OTmAZqXDwBcJzvswWrQhi41iF4X68G1kxqMEt
 zdVcQ2MBjeBrs2EB/3g==
X-Authority-Analysis: v=2.4 cv=QfVrf8bv c=1 sm=1 tr=0 ts=69a50828 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=6VAxXXE_Yb1B0lhAutsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: eYM-oDcfIClsvBwnzEuGJfugKL_pCtMX
X-Proofpoint-GUID: eYM-oDcfIClsvBwnzEuGJfugKL_pCtMX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_01,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020030

Hi Bart,

On 2/28/2026 5:39 AM, Bart Van Assche wrote:
>
> On 2/27/26 8:08 AM, Can Guo wrote:
>> +static bool use_adaptive_txeq;
>> +module_param(use_adaptive_txeq, bool, 0644);
>> +MODULE_PARM_DESC(use_adaptive_txeq, "Find and apply optimal TX 
>> Equalization settings before power mode change (default: false)");
>> +
>> +static int txeq_gear_set(const char *val, const struct kernel_param 
>> *kp)
>> +{
>> +    return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
>> +}
>> +
>> +static const struct kernel_param_ops txeq_gear_ops = {
>> +    .set = txeq_gear_set,
>> +    .get = param_get_uint,
>> +};
>> +
>> +static unsigned int adaptive_txeq_gear = UFS_HS_G6;
>> +module_param_cb(adaptive_txeq_gear, &txeq_gear_ops, 
>> &adaptive_txeq_gear, 0644);
>> +MODULE_PARM_DESC(adaptive_txeq_gear, "For the HS-Gear[n] and above, 
>> adaptive txeq shall be used");
>> +
>> +static bool use_txeq_presets = true;
>> +module_param(use_txeq_presets, bool, 0644);
>> +MODULE_PARM_DESC(use_txeq_presets, "Use only the 8 TX Equalization 
>> Presets (pre-defined Pre-Shoot & De-Emphasis combinations) for TX 
>> EQTR (default: true)");
>> +
>> +static bool txeq_presets_selected[UFS_TX_EQ_PRESET_MAX] = {[0 ... 
>> (UFS_TX_EQ_PRESET_MAX - 1)] = 1};
>> +module_param_array(txeq_presets_selected, bool, NULL, 0644);
>> +MODULE_PARM_DESC(txeq_presets_selected, "Use only the selected 
>> Presets out of the 8 TX Equalization Presets for TX EQTR");
>
> Please minimize the kernel module parameters. Introducing new kernel 
> module parameters is easy but removing these is hard. Can all the above
> parameters be removed? If not, please only keep what is absolutely
> necessary.
The three module parameters are necessary -
1. use_adaptive_txeq parameter is needed as an overall disable/enable
    switch.
2. use_txeq_presets parameter is needed because a full TX EQTR procedure
    with all 64 (8 x 8) PreShoot&DeEmphasis combinations give more
    accurate TX EQTR result, but it takes long time. use_txeq_presets
    parameter selects only the 8 combinations (or presets defined by M-PHY
    spec) as a tradeoff.
3. txeq_presets_selected parameter provides a finer resolution of the 8
    presets to further reduce TX EQTR loops. Qualcomm platforms would use
    this module parameter.
>
>> +/* A HS-G6 capable M-TX shall support the presets. */
>> +static const struct __ufs_tx_eq_preset {
>> +    unsigned int preshoot;
>> +    unsigned int deemphasis;
>> +} ufs_tx_eq_preset[UFS_TX_EQ_PRESET_MAX] = {
>> +    [UFS_TX_EQ_PRESET_P0] = {UFS_TX_HS_PRESHOOT_DB_0P0, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P0},
>> +    [UFS_TX_EQ_PRESET_P1] = {UFS_TX_HS_PRESHOOT_DB_0P0, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P8},
>> +    [UFS_TX_EQ_PRESET_P2] = {UFS_TX_HS_PRESHOOT_DB_0P0, 
>> UFS_TX_HS_DEEMPHASIS_DB_1P6},
>> +    [UFS_TX_EQ_PRESET_P3] = {UFS_TX_HS_PRESHOOT_DB_0P8, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P0},
>> +    [UFS_TX_EQ_PRESET_P4] = {UFS_TX_HS_PRESHOOT_DB_1P6, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P0},
>> +    [UFS_TX_EQ_PRESET_P5] = {UFS_TX_HS_PRESHOOT_DB_0P8, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P8},
>> +    [UFS_TX_EQ_PRESET_P6] = {UFS_TX_HS_PRESHOOT_DB_0P8, 
>> UFS_TX_HS_DEEMPHASIS_DB_1P6},
>> +    [UFS_TX_EQ_PRESET_P7] = {UFS_TX_HS_PRESHOOT_DB_1P6, 
>> UFS_TX_HS_DEEMPHASIS_DB_0P8},
>> +};
>
> Please mention in the comment above this array from what standard the 
> above table comes.
Will do.
>
>> +static const u32 pa_peer_rx_adapt_initial[UFS_HS_GEAR_MAX] = {
>> +    0,
>> +    0,
>> +    0,
>> +    0,
>> +    PA_PEERRXHSG4ADAPTINITIAL,
>> +    PA_PEERRXHSG5ADAPTINITIAL,
>> +    PA_PEERRXHSG6ADAPTINITIALL0L3
>> +};
>> +
>> +static const u32 rx_adapt_initial_cap[UFS_HS_GEAR_MAX] = {
>> +    0,
>> +    0,
>> +    0,
>> +    0,
>> +    RX_HS_G4_ADAPT_INITIAL_CAP,
>> +    RX_HS_G5_ADAPT_INITIAL_CAP,
>> +    RX_HS_G6_ADAPT_INITIAL_CAP
>> +};
>> +
>> +static const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] = {
>> +    0,
>> +    PA_TXEQG1SETTING,
>> +    PA_TXEQG2SETTING,
>> +    PA_TXEQG3SETTING,
>> +    PA_TXEQG4SETTING,
>> +    PA_TXEQG5SETTING,
>> +    PA_TXEQG6SETTING
>> +};
>
> Same comment for the above three arrays. Please add a comment that 
> explains what standard these arrays come from.
Sure.
>
>> +    if (!local_precodeen && !peer_precodeen) {
>> +        dev_dbg(hba->dev, "Pre-Coding is not required for either 
>> side\n");
>> +        return ret;
>> +    }
>
> Here and elsewhere in this patch, please change "precodeen" into 
> "precode_en". That will make it easier for readers to guess that
> "precode_en" refers to enabling precoding.
Sure.
>
>> +/**
>> + * ufshcd_evaluate_fom - Update TX EQ params based on FOM results
>> + * @hba: per adapter instance
>> + * @params: TX EQ parameters data structure
>> + * @h_iter: host TX EQTR iterator data structure
>> + * @d_iter: device TX EQTR iterator data structure
>> + *
>> + * Evaluate FOM results, update host and device TX EQ params if FOM 
>> results are
>> + * improved, and record TX EQTR results.
>> + */
>> +static void ufshcd_evaluate_fom(struct ufs_hba *hba,
>> +                struct ufshcd_tx_eq_params *params,
>> +                struct tx_eqtr_iter *h_iter,
>> +                struct tx_eqtr_iter *d_iter)
>> +{
>> +    u32 preshoot, deemphasis, fom_value;
>> +    bool precode_en;
>> +    int lane;
>> +
>> +    for (lane = 0; h_iter->is_new && lane < h_iter->num_lanes; 
>> lane++) {
>> +        preshoot = h_iter->preshoot;
>> +        deemphasis = h_iter->deemphasis;
>> +        fom_value = h_iter->fom[lane] & RX_FOM_VALUE_MASK;
>> +        precode_en = !!(h_iter->fom[lane] & RX_FOM_PRECODING_EN_MASK);
>
> !! is superfluous when assigning to a boolean (precode_en).
Will remove !!.
>
>> +static int __ufshcd_tx_eqtr(struct ufs_hba *hba,
>> +                struct ufshcd_tx_eq_params *params,
>> +                struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +    struct ufshcd_tx_eq_params *new_params;
>> +    struct tx_eqtr_iter h_iter, d_iter;
>> +    unsigned int preshoot, deemphasis;
>> +    u32 gear = pwr_mode->gear_tx;
>> +    ktime_t start;
>> +    int ret;
>> +
>> +    new_params = kzalloc(sizeof(struct ufshcd_tx_eq_params), 
>> GFP_KERNEL);
>> +    if (!new_params)
>> +        return -ENOMEM;
>
> Please combine the declaration of 'new_params' with its assignment and
> use __free to simplify error handling, e.g. as follows:
>
> struct ufshcd_tx_eq_params *new_params __free(kfree) = 
> kzalloc(sizeof(struct ufshcd_tx_eq_params), GFP_KERNEL);
Thanks for the suggestion.
>
>> +    /* TX EQTR main loop */
>> +    for (preshoot = 0; preshoot < TX_HS_NUM_PRESHOOT; preshoot++)
>
> Please surround the body of this loop with braces ({}).
Will do.
>
>> +        for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; 
>> deemphasis++) {
>> +            if (!tx_eqtr_iter_update(preshoot, deemphasis, &h_iter, 
>> &d_iter))
>> +                continue;
>> +
>> +            /* Step 3 - Apply TX EQTR settings */
>> +            ret = ufshcd_apply_tx_eqtr_settings(hba, pwr_mode, 
>> &h_iter, &d_iter);
>> +            if (ret) {
>> +                dev_err(hba->dev, "Failed to apply TX EQTR settings: 
>> %d\n",
>> +                    ret);
>> +                goto out;
>> +            }
>> +
>> +            /* Step 4 - Trigger TX EQTR procedure start */
>> +            ret = ufshcd_trigger_tx_eqtr(hba, gear);
>> +            if (ret) {
>> +                dev_err(hba->dev, "Failed to start TX EQTR procedure 
>> for target gear %u: %d\n",
>> +                    gear, ret);
>> +                goto out;
>> +            }
>> +
>> +            /* Step 5 - Get FOM */
>> +            ret = ufshcd_get_rx_fom(hba, pwr_mode, &h_iter, &d_iter);
>> +            if (ret) {
>> +                dev_err(hba->dev, "Failed to get RX_FOM: %d\n",
>> +                    ret);
>> +                goto out;
>> +            }
>> +
>> +            ufshcd_evaluate_fom(hba, new_params, &h_iter, &d_iter);
>> +    };
>
> Please remove the superfluous semicolon past }.
Sorry, my bad.
>
>> + * It ensures that EQTR starts from the most reiliable link state 
>> (HS-G1) with
>
> reiliable -> reliable
Thanks.
>
>> +static void ufshcd_tx_eqtr_unprepare(struct ufs_hba *hba,
>> +                     struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +    int err;
>> +
>> +    if (pwr_mode->pwr_rx == SLOWAUTO_MODE || pwr_mode->hs_rate == 0)
>> +        return;
>> +
>> +    err = ufshcd_change_power_mode(hba, pwr_mode, /*force_pmc=*/false);
>> +    if (err)
>> +        dev_err(hba->dev, "%s: Failed to restore Power Mode: %d\n",
>> +            __func__, err);
>> +}
>
> What should happen if restoring the power mode fails?
I made ufshcd_tx_eqtr_unprepare() void because I don't want power mode
restoring (if successful) to override the actual err which leads to power
mode restoring in the first place.

ufshcd_tx_eqtr(), caller of ufshcd_tx_eqtr_unprepare(), would anyways
return the actual err to its caller regardless of power mode restoring
succeeds or not. Eventually, the ufshcd_config_pwr_mode() would return
the same err to its caller.

Currently the two paths which call into ufshcd_config_pwr_mode() are
probe() and clock scaling.

For probe(), if ufshcd_config_pwr_mode() returns any err, probe() would
fail anyways regardless of if power mode is restored to HS-G1.

For clock scaling, if ufshcd_config_pwr_mode() returns err and
ufshcd_tx_eqtr_unprepare() couldn't restore to original power mode,
the worst case is that power mode is left as HS-G1 (the most reliable gear).

Do you see a problem with this approach?
>
>> +int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>> +                 struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +    struct ufshcd_tx_eq_params *params;
>> +    u32 gear, rate;
>> +    int ret = 0;
>
> Please remove the local variable 'ret' and move it into the two scopes
> in which it is assigned a value.
OK
>
>> +    if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
>> +        return ret;
>
> To improve code readability, please change "return ret" into "return 0".
Will do.
>
>> +    } else if (gear < adaptive_txeq_gear) {
>> +        return ret;
>> +    }
>
> To improve code readability, please change "return ret" into "return 0".
Will do.
>
>> +        params->is_applied = true;
>> +    }
>> +
>> +    return ret;
>
> To improve code readability, please change "return ret" into "return 0".
Will do.
>
>>   /*
>>    * PHY Adapter attributes
>>    */
>> -#define PA_PHY_TYPE        0x1500
>
> Please refrain from making whitespace changes in existing code in a 
> patch that is already too big.
OK.
>
>>   /* Adpat type for PA_TXHSADAPTTYPE attribute */
>
> Adpat -> adapt
Thanks.

Best Regards,
Can Guo.
>
> Thanks,
>
> Bart.

