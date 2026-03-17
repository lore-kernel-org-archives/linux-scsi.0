Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBC73815E7
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732155; cv=none; b=Q1jp0ZFDHDpDrZU0UVyWXlMZO+FiGBEx6X75+zdZqIYypusyibI0fDmEJjcpLea7SE72RGrMuC9KRHQGOvvOAHtv+wpgVw0EvlWNl58+mkpYEyJGrAqx20OlgfAykkIJvjZdmvsvU8NH3/M7kW3yR4X06BqUBY6oWdjZXjo3MQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732155; c=relaxed/simple;
	bh=aidX4VggwlbheWyVlWlhwsvaEdcnaLQBcRbLFvtJBmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYOfqIFIJJf8aze64bJehtPRYCnFqJwfELYbTCRQNRhIIALDO9+gi9dVPjUmSwV6A6zaksaP41u0h6oxX3u2QYPusSfoQzdygvao/xz2enO3aBfObjoIqIJ5KfSpqg4DLXolvNl2R0LGgbf8uVFYK6XwIxjiiqmMhgctvZmn7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b6EDY8ZY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HFs8vqhl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b6EDY8ZY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HFs8vqhl"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7510L2375054
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZgChQj4whMjKyyIFMKD9guOoQ0/tWmaT5bd/2bd/WQ8=; b=b6EDY8ZYj7yg3CUf
	vVIvSkiOtd4fbURZkEWLWmOs7JuZbQDFr2kzzLtdSs1TQubo8xuzfbI3LDq2FbL+
	BbqTfYyvaiDcPRJXUf6RvIr7fjefYnW5tjRhGjWodRMOE9eHkJDW7Y639vdhcoc9
	J42PXOhJi4u4S+gEqQQmjkaR2ZXz1ZwCgjHYSuxik8JvSS7qP+rQhBarrflXR9pW
	/k74z1DGlxhzqluy+C0WJ3FEgUv6qbVy+tj06735IApb1kAo4T94cu8kv83W1y/e
	qXv/P+P6Z9OnCKAnpNFpffvu+v32qGwx8Lh5RlPdDRExHWBrnIdh3k9lXG9INY2u
	6VXd/Q==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkby33c6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:22:33 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-829a535ad50so2773770b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 00:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773732153; x=1774336953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZgChQj4whMjKyyIFMKD9guOoQ0/tWmaT5bd/2bd/WQ8=;
        b=HFs8vqhl3YPDS74vx4aqoMOnI/JOmp4zRDv5n9z13a6Kjrz+ehlUeSD69HHtwhR/HU
         4HEh5qcqwzI7JgViYSmUHZtcH8WCwriEPmc9u3qgCPkrTTWKaBUQSZMI8OGSF0t1+RnL
         dbWcGTY46agG/bVpEaIcB7zM+r1FVN/9p1bCdh5e/JJNs12Zpcf1zWUY70ncrxLgy6Du
         G+dnX+vEe/vGOmMKxAbDFRcZHxczsn0/DQGUSoXbUB7UuO77ddrog1F4kBWqnPobIXZd
         emjFaM4UVkaf2pwxU02tRx9V4vaAho2j9eBtbiKPrCoRid/zcabTgXdShFK2i5f+twi8
         aZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773732153; x=1774336953;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZgChQj4whMjKyyIFMKD9guOoQ0/tWmaT5bd/2bd/WQ8=;
        b=kM1qtCIp9gQInQN6bFUesXOjREkUexO+n2pJ08mzEgYpDKI62nVgw6s4ZmMLTuh7d9
         psgC+JoNHuknGmewR7Jb1CkgP0rkcJHPxprngDpH2NtAL8DSCv2+BE58PRWnzfC54xSa
         X/F/k0vHMGCmjgp99XC7oidJWYZ+a3ZW4BqfafTC9q8Nv6hMLiWHDig83oLR0Yh8cKEP
         Si2tSofSqYMMnxfwT46TytaFb4sn/xfiCLdFmSu6FqW6cxNUIs4hHKUQJhll/E27+Dvs
         62yXJUKNpo+1CBsCLOeHNAECGt11Kl+6eZWIUcXMHmEP7tpxDLm+CL8WLcEic749G0P7
         KVVw==
X-Gm-Message-State: AOJu0Yy43DkjP2xKRHRhc81aM3hxjss84zDjr429riYuP0KCIZqLn7aD
	kff9YlGasYXkgvwRDWMBo3sYKo2E5d2H9M6rJASkcTNhMhm3cpYI7g6STJijD7dcnaWtbo2kO3X
	tgl5HQG8GoAHIpZ84gJLz53wI/TgsY8chZ9VAKM1pb5bWhM6AFxIrbWEkIaSx2tm5
X-Gm-Gg: ATEYQzxfmp0duiWrEWLeomS/MWj995AyyflFB98f+hpCuJWkdOeIBXyrWVREQN80hci
	eLoG8HrrvCUrrTMAwBfjHPzAthAraXjBPZNkg3PpdF5dVr/jy2iMVe5Gw02e34FIIk7HMdiI41S
	z/f3ILNHLm7n22OrfCJtVW/vCD9y5onx8UYS3U/m+GWf4PLG+7N/TV4uDSnhHETqGt3dLJdhU5T
	q+9gm1x8o544B0IdCzEp7as3B8ljHUHY2QAoFwLncb01iJ0kQ1N7CrHEq3qQG6nGVHS0GNlgOGR
	LYoy3uktpYqknvHwiWCil3x6+Wre77bKDlsR0iUuDw4FqahhY1dI19MblWFj5Tn/zd73YjsYD8B
	6QQtF44tXEm56Mj4p1Vlfwvt6uZacShtj+sXffnbCw6rxuAH3UkG9Z6UcxcQa7z8HyUwr8AhH0v
	/P5LzdGmdEBQ==
X-Received: by 2002:a05:6a00:4b15:b0:81f:852b:a925 with SMTP id d2e1a72fcca58-82a197043a6mr13660906b3a.1.1773732153038;
        Tue, 17 Mar 2026 00:22:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:4b15:b0:81f:852b:a925 with SMTP id d2e1a72fcca58-82a197043a6mr13660880b3a.1.1773732152470;
        Tue, 17 Mar 2026 00:22:32 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0725bfd0sm18822110b3a.14.2026.03.17.00.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 00:22:32 -0700 (PDT)
Message-ID: <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:22:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jSJxLbprSeoE_wFvtgaoPZ3_PHUosFNm
X-Proofpoint-ORIG-GUID: jSJxLbprSeoE_wFvtgaoPZ3_PHUosFNm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA2MyBTYWx0ZWRfX1KkCDLsacx2D
 k+0M5sLwR3CLw+MKPIMl1cpLZ3uXONfurFZnztwN/ySZPfd+fH1R7wyjkmTfdL7hQJX/eEr5Kzc
 j1ND0D+jVZ6rnVrodb/FI/xaWcw3sXcD53gyCXH4yiEGP6zrUabHQ37vw6VJxyovW5T9OyVf0t/
 TNVseLinaadPPBE4czJ77vVZLWrSidQ4GcAGHGOkCN+ktEU5pdo5INF0wKI8xSgp6JvTdX32N17
 dk7mLr5y5dlzMSsAYmq/7Wx/uTYylA5Kv2fBOdNFFHDzeYG7jYbC5MWL4rmcffHAqcSSyoZ3HUF
 lCGpQx4YoEl6SCLXXp2X7cfMs8E6j2rjeky91whT/4MvKHoReX8OCIDkDgveseLhrQnCQYFS/O9
 WDjZOrVLwakMcj+GECq2iIc2XoCF29+EppW9fH1V5PP4W6lsqztV/apjsWxEelVVelwVThOW+uW
 +lKsordb0JY1rWtBUJA==
X-Authority-Analysis: v=2.4 cv=ZpLg6t7G c=1 sm=1 tr=0 ts=69b90139 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=dnBCdlAVUsKltJQhoPcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170063

Hi Peter,

On 3/17/2026 2:49 PM, Peter Wang (王信友) wrote:
>
> On Sun, 2026-03-08 at 08:14 -0700, Can Guo wrote:
> > +static bool use_txeq_presets = true;
>
> Hi Can,
>
> The default should scan all, not only presets.
> Or, how could make sure the best FOM is in the presets?
Here is the consideration:

1. Scanning all 64 PreShoot/DeEmphasis combinations cost (much) more time
   a. This could impact bootup KPI
   b. During TX EQTR, IOs are paused, when one conducts a re-training, 
the IOs could
        be paused for too long.
2. As per our study in the past few months, the optimal/best combination 
is most
     likely within the 8 presets, which is true for both Host TX lanes 
and Device TX lanes.
3. Even if sometime the optimal settings which fall out of the 8 
presets, they are very
     close to optimal one found within the 8 presets.

So, scanning the 8 presets only is more cost-efficient.
>
> > +ufshcd_tx_eqtr_result_examine(struct ufshcd_tx_eq_params
> > *old_params,
> > +                             struct ufshcd_tx_eq_params *new_params)
> > +{
> > +       int lane;
> > +
> > +       if (!old_params->is_valid)
> > +               return;
>
> Is is_valid always false, causing a return here?
It can be valid if we are here (again) because one conducts a re-training.
>
>
> > 
> > +                       /* Step 3 - Apply TX EQTR settings */
> > +                       ret = ufshcd_apply_tx_eqtr_settings(hba,
> > pwr_mode, &h_iter, &d_iter);
> > +                       if (ret) {
> > +                               dev_err(hba->dev, "Failed to apply TX
> > EQTR settings: %d\n",
> > +                                       ret);
>
> Can deemphasis and preshoot be printed as well?
Sure.
>
>
> > +       ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
> > +       if (ret)
> > +               goto out;
> > +
> > +out:
> > 
>
> The if check can be removed.
Good catch.
>
>
>
> > + * @is_new: Flag to indicate whether re-newed since previous
> > iteration
>
> is_new is confusing to me. Please consider using "need_renew" or
> "update_required", which are clearer.
I will move to 'is_updated'.
>
>
> > +struct ufshcd_tx_eq_params {
> > +       u32 tx_lanes;
> > +       u32 rx_lanes;
> > +
> > +       struct ufshcd_tx_eq_settings host[PA_MAXDATALANES];
> > +       struct ufshcd_tx_eq_settings device[PA_MAXDATALANES];
> > +
> > +       u32
> > host_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMP
> > HASIS];
> > +       u32
> > device_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEE
> > MPHASIS];
> > 
>
> Do these two records only store the FOM and are not used otherwise?
They are used by debugfs entries to print out the TX EQTR history.
>
> > +
> > +       ktime_t last_eqtr_ts;
> > +       int num_eqtr_records;
> > +
> > +       u32 saved_adapt_eqtr;
> > +
> > +       bool is_valid;
> > +       bool is_applied;
> > +};
>
> The size of the struct ufshcd_tx_eq_params is 2.2K.
> It seems that some fields could use u8 instead of u32.
>
>
> > +       struct ufshcd_tx_eq_params tx_eq_params[UFS_HS_GEAR_MAX - 1];
>
> This uses up to 12KB of memory. Is it really necessary to occupy
> so much memory? Can we use dynamic memory allocation instead?
> Especially since G1/G2/G3 are not used, and G4/G5 are optional.
> Only G6 is actually needed, so we shouldn't waste so much memory.
> After all, memory is expensive nowadays.
1. Even we use dynamic memory, it is still the same amount of memory.
2. G1/G2/G3 supports also TX Equalization settings, my next series will 
provide
     changes to allow one to give TX Equalization settings from DTS and/or
     persistent memory.
3. G4/G5 supports TX Equalization as well as TX Equalization training as per
     spec, we should support them like G6 equally to enable better link 
quality.
>
>
> > +#define PA_PEERRXHSG6ADAPTINITIALL0L3          0x15DF
> > +#define PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3      0x15DE
> > 
>
> These two lines should be swapped to match the correct order.
Will do.

Thanks,
Can Guo.
>
> Thanks
> Peter
>
>
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

