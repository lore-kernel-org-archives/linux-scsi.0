Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED49302165
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953088; cv=none; b=Ezhq13Uy1yvyTxlypWV6qZnjD+rNyqdVa9dMXg2Lb88vvUYP9j+Ibt5wxxDdd+4LVD0fWn1XcfxGPqKhxmCqit3yMPOihPbsKBTyhaf00KSfN+2FzrfxhCqFqPY633ycDEQ5uIu9CK5KtAo6FEgbDFBTImChUUoDBKWcYrThYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953088; c=relaxed/simple;
	bh=3idqJl6wcwvb0AxoBWTmL/VY5VBaQ2Axkzvg62roBUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VCnf1OtXC4bYVGxHRMUmxRDeuO3IZXBtZaux8gg8NWWZuEqjeSrdkRNSuB3HOVGSoka+Ep1Zuq9V8ffJLtrD3ULS+3W5B6fVaXB3lAkAnkN6xBW/b+o10sGQchL1T5UdKoiVkKayMgQKRmsOd0r/qVjwZcGwKXn2DEsiEcttIl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K/HIdM0J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IWFQqjYb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K/HIdM0J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IWFQqjYb"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S6bR5p2755150
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xG2QgzYKrgNHNc7YpKtXae1/+zJd/2dlkLEFMR6jA5Q=; b=K/HIdM0J4VfZNZg9
	gWwXPiL0VpXp98qi9sa+PsE8pR9yOzWdbihcKQxfeBa0l7v8LFXJmZerqGb/Y4Jm
	ugp5tdlGPxaXSQx9nOZiCFgl+MOBASaFP8Bj9ji2HwPM+OzmJP6i10zCAp5g8Afp
	34zYP/zK74oxdg9Ab2XvRgaVpMYsyGFnod/a6uLMCFFIABnPnel+Byfvst8t6+c3
	topwHEkkyimPNnYskjbVHMcHuT15BHBBzFxLL6H6JBaEeVGQNqMmGsurdzZTVML2
	MRFQQU1PN9HGPYcYK6IL8SMp0fUFnCKdDF+s3gU9Q4OfN6BTQcIoTsVfsf+ZPNsH
	QeDOsw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7yc9s3u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 07:24:44 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-367f715cbd0so12041993a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 00:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779953084; x=1780557884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xG2QgzYKrgNHNc7YpKtXae1/+zJd/2dlkLEFMR6jA5Q=;
        b=IWFQqjYbcjy+m3Q0dFfAfRPXpIcKV9gLC+fgRwGNNdT1B7C92M5WKUAlinOmoOY/vF
         9HuTFE0jCbTxQ1AbODI8NmK4FuRtjdUf12sFVTDv0h2ZTU7Dc43qHvMw36eJQrVHt/aq
         MRjzRWyQFCowVsAr+Su8s+N0mxUyt2jMrc5+WXgBEFPbAdKU9KoPOOS3l4tMTe4Wn+wK
         oaLNCGe7vqNGP/dqTG0qswp0byB8Iz9nDW/R8N5Q+XcvqafLDhpxCetfj0OTDmQ87/NT
         j5yQs7d1ciPBYFzSGEvKn8uAUI7VS/1EiyEffFDzKc/UI3FsNPCC2+kNVtSintBmAcXy
         WMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779953084; x=1780557884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xG2QgzYKrgNHNc7YpKtXae1/+zJd/2dlkLEFMR6jA5Q=;
        b=E97musxv16j4GYsBUSbXKjXIMCrGupkYq3wwaq6/RRExIM1yA9oTt3CJe2g6Wi439D
         ag37SWQVJxV3XOeZsDvtp16QPLe3n4wxRx+LV0Mfi3gr0IlO2yTsJzI8Le9Bfu19rfW7
         lPLECqc2uxTGNxgH96hLz+pbkmmCCaP5v/yDhgHNikEEweM1xA2o5d3ux8CBiWnE9t0Z
         8F3w45C4HojS6Pwqj2HtuwbiqI6sMvAd3buCjO9WsdMKyHLdfjJNiCUIm8eZFgwbg7UP
         FyNEx2qd+zTTmUKyRGXTtoVPJWS8LtwqayxZc4EoyIX4+2E8KYovWLdpCpKcY6BouvMF
         m8og==
X-Forwarded-Encrypted: i=1; AFNElJ/5DILgRbPV4Zn7gY4OAbkPwsCyBukGrpWT+4SN7gW5d95LxqzRoJFeeGLJvurYxAKM59ZB50Ps296n@vger.kernel.org
X-Gm-Message-State: AOJu0YzNqP2adAxCXkoo6ih2ow9Cx3CRtN07aXvcIzXq5K43TgeCMaIp
	4jxEMS33WW1Hp3ecaSdOw/pFi5tmpuzGJUsjggFDinlqOIuYUw0k5/4bMX8IwlCpxPSg//FVKDk
	6WN7O9uGSE8OzPGenTUBDWwM3cdjM19uNnrVBwsH42E/fkq/gTEwJhKm6Xjo+k6tB
X-Gm-Gg: Acq92OEDViP3aEjHKkVBdzIFckAlTKhqMk3HAGSj5ab99KIZYtxzJiVnKalL27THr8m
	FLx4k/vweenk56ElYKVKGgrkJM5sDrWpZ10+tq/Cb8dyypNkZjDJZ8Ba25lhlfQdKjEJ96pBidc
	/cg4bxNLFHXmfhE+ZwswfN6M1OrXTx2pWSusZVhEpBhNIWA9r0ykC/M9eTFcOUBrgGKovTZkmVy
	7T/p2FTm1JEdjjUfRwcq8SBtjBdSJfAfsBMwDvOck22rj3l6qfm7nKmmWdl4MzLl9Neg1do1rn1
	PrpC7idUkw/MpNtD+Ttyq9En/7/GvJeOrWN44ztgp7OrELa9EyS1jzQLFP4QQSMrhjAsdOBp4G7
	MvW4VPNr7TAmlN07ZUfB7xMS2eT+w2iJDoGmYt4VbcEs44M/C4d3LWraMJnTWsyWQdWENUriqpN
	DkF/GGo01iJ4anpmtS4xasmQ==
X-Received: by 2002:a17:902:d48e:b0:2ba:5a20:1d94 with SMTP id d9443c01a7336-2beb059944cmr298415495ad.13.1779953083699;
        Thu, 28 May 2026 00:24:43 -0700 (PDT)
X-Received: by 2002:a17:902:d48e:b0:2ba:5a20:1d94 with SMTP id d9443c01a7336-2beb059944cmr298414945ad.13.1779953083192;
        Thu, 28 May 2026 00:24:43 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695f05sm219572265ad.6.2026.05.28.00.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 00:24:42 -0700 (PDT)
Message-ID: <d57a0e9b-74f6-4472-842f-6479c7449cd8@oss.qualcomm.com>
Date: Thu, 28 May 2026 15:24:37 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-3-can.guo@oss.qualcomm.com>
 <mt2asdx4vnuxo3eodrc7dlfdtv3b5bpjfvxxglmncny36otfav@htri3l5q4ba3>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <mt2asdx4vnuxo3eodrc7dlfdtv3b5bpjfvxxglmncny36otfav@htri3l5q4ba3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VOntWdPX c=1 sm=1 tr=0 ts=6a17edbc cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=f2HFmwmC_kV93FwCZ9MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: Dmm9R27YsktkgqBOiUW_Ozc92emFIjIk
X-Proofpoint-ORIG-GUID: Dmm9R27YsktkgqBOiUW_Ozc92emFIjIk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA3MiBTYWx0ZWRfXzikY4Vu81Fzs
 C1t8OzAABrf6Gol6IlwmHsQWE6iS7zaKKfeSzd5zX9/GEssTvCyh4F5KtXCpE74bFQkJ0vTnFzp
 87F7c9BEIZXjNxXMXkcDojfRJR9ncqbcVYDo8xMFklg0XHBc09qWgRTdDcDp5FUkh7sD8D/8VMi
 UAnGviVyNY+6Gew5jErhTAsl5krKwbGRyuFOhFCSOUStweiAlsMGK/f1Jfv3OIBcyN7L+CDwWLu
 dA+uNCMblsQ3TWoBKD+Tiv6BKMl6RaZYoc81xpL/gnA/ekiWu9uZlFPKvGT7KnYq/GEfhYEpnMx
 cKlle2VyreCwJujC3J9vHJ7vXZLPH23IJVbP0hL3jeRteuENCX5OKD6/FuoJrADnie14ovT+jpc
 Z0Qd1UPi6SIOoIneZYhv1yCJvKCz9ScpDzhDmDoSdkdwzL8rfYImZ6LZu6K/2can8Iw1FYIapTE
 BSzTzaX1lDPCEwWUt4w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280072



On 5/28/2026 2:13 PM, Manivannan Sadhasivam wrote:
> On Wed, May 27, 2026 at 07:40:55AM -0700, Can Guo wrote:
>> Static TX Equalization settings and TX Precode enable indication from DT
>> properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
>> tx-precode-enable-g6 are board-specific baseline values. Values are
>> provided as per-lane tuples:
>>
>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>
>> Parse DT u32 properties with explicit range checks by using
>> of_property_count_u32_elems()/of_property_read_u32_array().
>>
>> When adaptive TX Equalization is used, these static settings are not final:
>>
>> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>>    those retrieved settings override static DT settings.
>> - If retrieval is not available/valid, TX EQTR runs and trained settings
>>    override static DT settings.
>>
>> So static DT settings are a fallback and are intended for cases where
>> adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
>> remains the primary path when enabled.
>>
>> No behavior changes for platforms that do not provide these properties.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufs-txeq.c      |   4 +-
>>   drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
>>   include/ufs/ufshcd.h             |   2 +
>>   3 files changed, 133 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>> index 4b264adfdf49..634ec039e129 100644
>> --- a/drivers/ufs/core/ufs-txeq.c
>> +++ b/drivers/ufs/core/ufs-txeq.c
>> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>   	}
>>   
>>   	params = &hba->tx_eq_params[gear - 1];
>> -	if (!params->is_valid || force_tx_eqtr) {
>> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>>   		int ret;
>>   
>>   		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
>> @@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>   		/* Mark TX Equalization settings as valid */
>>   		params->is_valid = true;
>>   		params->is_trained = true;
>> +		params->is_static = false;
>>   		params->is_applied = false;
>>   	}
>>   
>> @@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>>   	}
>>   
>>   	params->is_valid = true;
>> +	params->is_static = false;
> Maybe it's me, but I'm not able to understand how you want to apply these static
> EQ settings. In commit message you said, the static values should be used as a
> fallback, but you just check for 'params->is_static' while triggering
> ufshcd_tx_eqtr() which is supposed to perform adaptive TX EQ training. IMO, you
> don't need any check at all for applying static setting. If '(!params->is_valid
> || force_tx_eqtr)' condition is not satisfied, then the static setting should be
> used.
Thanks for the review.

The distinction is between two different sources that can pre-populate 
txeq_params with
is_valid set to true before ufshcd_config_tx_eq_settings() is called:

1. DT properties — parsed by ufshcd_pltfrm_parse_tx_eq_settings(),
     sets is_valid = true, is_static = true.
2. UFS Attributes (qTxEQGnSettings/wTxEQGnSettingsExt) — retrieved by
     ufshcd_retrieve_tx_eq_settings() (introduced in the 2nd series),
     sets is_valid = true, is_static = false.

Since both sources set is_valid = true, the is_valid flag alone cannot 
tell them apart.
The is_static flag is the discriminator:

- is_valid && is_static -> settings came from DT; they are a board-level 
baseline.
   TX EQTR should still run to find optimal settings, which will then 
overwrite the static ones.
- is_valid && !is_static -> settings came from UFS Attributes; they are 
previously trained
   known-good values. TX EQTR can be skipped.
- !is_valid -> no settings available yet; TX EQTR must run.

So the condition check on (!params->is_valid || params->is_static || 
force_tx_eqtr) handles
all three cases.

Thanks,
Can Guo.
>
> - Mani
>

