Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7743F7A8B
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 08:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778832741; cv=none; b=hEt/Oz7rCyjEls6CokOVw6i+PxCv8NZt09QwCHDorMomkIH1RCcgbCaDGfq6I5TdiEq7VQOFbiYtSaPiNyh2QSPnuEPtHZIEUpTx10zNKxXwbTmcYSks5cPQu6LeInjfe1bLz75YWUoZoTo5AZVyU9RzJnuBgA6ObQDQQyYrmLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778832741; c=relaxed/simple;
	bh=FktCr/u3rOxg9ueRI8/8hQ2GHcP0pe315k2A5ix3uqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akvF9/8XqC1GX71OWMDw6pmXkd6hU2GmZ5i8x9Vd9jxZrf1+IeCCn1fg2sHsSIOY9tlmit6x6UDCvXxW6iES/eyJh+fJTOqCnHgHD7yTeENQT2b021/fQGGCbDJQDy0VjRbOvo6H/gD0s+VMP+lL2C9w9JL4ZX1G138STSrXky4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ilaXkHX4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VniqRsfv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ilaXkHX4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VniqRsfv"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F5HPKx3219672
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 08:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6Nfe5u1E6q+Bw4bVcH5OIoGsa4LydTmUn7m5gJGoe3c=; b=ilaXkHX41Ei6F2Ta
	UIw4O4gSXWAmwyiJgf4l/DbOSh9J/cajVBX4/d6EXu9oSFFxLYqAq3xFR8cebtAq
	/RSNipukXLv2jh/C/l/6bNNSBPkqE7IA2N5pkBSI4JuYRzpNgJzqNgZY+NyxYgsU
	nKaZPmmryJgI6OeWwLCE9pP9IA3TLvln25JmtPKgNupwFPoUiFxMD1/OtvnRbreK
	L/ncghVQnHnv/ucLdZmfygDZl5tjmDflJZZ//T0dZaq9ikRy8lj+fxOzblUegWEH
	auyee+mcotTXQ/p0FSgM3dMPDgVXwQBAaYk9YhJfI293bBvyWUmSCheSK5FLVU51
	Pbh4og==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1s2a70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 08:12:19 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c8271fb4407so6940826a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 01:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778832738; x=1779437538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Nfe5u1E6q+Bw4bVcH5OIoGsa4LydTmUn7m5gJGoe3c=;
        b=VniqRsfvzsVizd8c6LJP5+XNKX/j5Y/mqCTv+OPzI1iVtq4/V3qsKn1cYnb6CM34/Z
         oP/7UTkrxpi2mhak/TAPz91rTilS/wkggXhmWgbZaBmvIX9KVyjA2DSkOrHj++PBxnAO
         CYsSOjt3guHHwyGY0/omAVi5Z+n77Uqc9g9gYp2hW3qHOhcoPR60aRkn2z2FWdttCXK/
         bXV+NxLmg//UjlrBw6qg+b0Ur6SYXdz8SReI99qBNwe5bM47XR1WGbzObQeJ9r79uahq
         oNIML/XsM9uUVZIaptl1o9adbYqVSglAQH2zOiD0QiEMvCK13+HE0JXBv0GS4TqMHlmY
         Y8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778832738; x=1779437538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Nfe5u1E6q+Bw4bVcH5OIoGsa4LydTmUn7m5gJGoe3c=;
        b=aCRzXr/GW2Zrfq8iVP9E3xyJ7EVAhq9/HvSaAU8kdQ7zMVgMMKfN76dG1qGeu1vY3R
         vbjj/ei5SG955+97oJ2MTAhzhMeodroJfBffPSH3v3pZYWNFM9xiozq1IjLAKd5UldOB
         4Ja8Pqx4HWP0FkZM3801S+yadTF1STwh85GG8BTmq+sNmym1UNgciIljkkNIARZXLxGc
         PQKj/+YGlmR9uZ/RyhmKGB86LJLPHa8KjOSdTetW9xzPzmXPkapwvWl2tHcwMwhJX1zD
         GwZ34kILvGcNWnkQJd3j3HwODuUtkHhyQmKNlpt5uzDf/CUT+sTVX2IscnTyhoG4dZsP
         TOFg==
X-Gm-Message-State: AOJu0YxyDxnuTKwhck/uiljIgUFZbktqZ1OUNaPPyktRss2vzJ2Iu+4n
	tTgCppSWVnxcLNS0REyA73DI8x+OHueCJBMvCHOEvMOgok4mWdwoSRs+7I5LBpibzGnYTYMKBZB
	ZWgsk4qv9+EW7hqVpikeyS/86e/1oG0qaHMkXYr8+gmum+LiwSZco+8AhBZw3CU2p
X-Gm-Gg: Acq92OGr5dsykjz0kl6xUbD+9IOjyNmYyPl9SmgBZ15Y9el+cr8MhAkma7dFoHKlusD
	y3wKTSXcsWBjQ/6GgGSPIax25C4nkFX9RX8M7PXS7WWluhNL9KutiYOvu0+whJARDAj8CKbJd3/
	o85bR0pI9c1n+OkobI3PSPerJdKDEYRrKjpoK7gMeOTHbVeWeva6EgPgtmJ12XQmAjwgjB7717r
	V3iHsMUmzZ3SMxsU89Yt0FrxWl+rlAflN9NWi1x84xJkpt+0z6gyiBsVh7yxsKFC77iwgSG6dnb
	uvUhFZxjkOGVvHz+QTPc2UtddWie8wNrVLT+aJzO3R7A/1W2h9Tu/zb7U2e71pdUFwfIkadCgxw
	sF57YJJx4UrM7AZPA4j/WlAunePXyfR3UYenV/rw5xQt+ZLKkRFSyPptnJAMLTBpWVzLfogT3FW
	7KUUDc0d4XJg==
X-Received: by 2002:a05:6a20:7f82:b0:3a2:e26b:2940 with SMTP id adf61e73a8af0-3b22e19b526mr3566627637.0.1778832738023;
        Fri, 15 May 2026 01:12:18 -0700 (PDT)
X-Received: by 2002:a05:6a20:7f82:b0:3a2:e26b:2940 with SMTP id adf61e73a8af0-3b22e19b526mr3566570637.0.1778832737404;
        Fri, 15 May 2026 01:12:17 -0700 (PDT)
Received: from [10.133.33.62] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb102415sm4617352a12.19.2026.05.15.01.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 01:12:16 -0700 (PDT)
Message-ID: <3c54626e-671c-4334-a438-c241886ab8f9@oss.qualcomm.com>
Date: Fri, 15 May 2026 16:12:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Bean Huo <beanhuo@iokpp.de>, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org,
        powenkao@google.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
 <20260501134418.863432-3-can.guo@oss.qualcomm.com>
 <a0347bb7c1b5902d236855c773d55e0dd9fc19c3.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <a0347bb7c1b5902d236855c773d55e0dd9fc19c3.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDA4MSBTYWx0ZWRfXwP7aYONmg9FQ
 cWlAffgJi+nbDp/x96X4fjD669EJ5fifuo/3VbHUy52b5gT/5uo4wuGK+TU+J+FhoJdZ9cIT3oV
 EmFw7ddgKSl6AMJuzK6eKGFAGEQgoV5Sfg6p25+GtW5LowoWj0qq5/Ue9YOEA08gWr/dD4YSS5u
 /MEO/OuI3m1wP0Q96cciD9aKXUgIGUxfcieaT3u5ehodncA9IdP5J/sEBj2q0KOkoYplAYrB1xt
 uj/AxzGypVyt6dmESZ7l6CTCrshDjZ8lV8FswB4IjDDVVGRbz8h8WzyrLIbI95YLGOq3mQhF/OS
 RM3NSh/lQvkAe8ZGqx3b11PBC8CChKlt74ljkYGsd4tJ7aAOLtqmNtqmkGZocsSNKF5L7jo3Bvx
 3jE8Tio96Tkr5C40d743vokKe0ajDK879K4JXap8H+R+vlRsqgNnIYUJ5WxhIfwuB9W6iHYkU1W
 aAlKlY+bMuHC2LIWx4Q==
X-Proofpoint-GUID: nzgm6wLYzOZ1kM5qkvI6Y7KBO0Y8CCJH
X-Proofpoint-ORIG-GUID: nzgm6wLYzOZ1kM5qkvI6Y7KBO0Y8CCJH
X-Authority-Analysis: v=2.4 cv=HJ7z0Itv c=1 sm=1 tr=0 ts=6a06d563 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=2mUTFIH5eXoRPtnr5RcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 clxscore=1015 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150081

Hi Bean,

On 5/14/2026 9:57 PM, Bean Huo wrote:
> Can,
>
>
> Sorry for the late review of this patch. I have several questions:
Not at all sir.
>
>
> On Fri, 2026-05-01 at 06:44 -0700, Can Guo wrote:
>> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>          }
>>   
>>          params = &hba->tx_eq_params[gear - 1];
>> -       if (!params->is_valid || force_tx_eqtr) {
>> +       if (!params->is_valid || params->is_static || force_tx_eqtr) {
> When use_adaptive_txeq is on and params->is_static is true, EQTR will overwrite
> the static values. That is reasonable since EQTR is more accurate. Is the
> is_static check really needed here?
The check of flag is_static is required because we need it to 
differentiate the static
(DTS) settings from the settings retrieved from persistent storage:

- If settings are retrieved from persistent storage, TX EQTR should be 
skipped.
- If settings are from DTS, TX EQTR should execute anyways to override 
static settings.
>
>>                  int ret;
>>   
>>
> ...
>
>>   
>>   void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
>> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-
>> pltfrm.c
>> index c2dafb583cf5..de6302e8c067 100644
>> --- a/drivers/ufs/host/ufshcd-pltfrm.c
>> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
>> @@ -210,6 +210,86 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba
>> *hba)
>>          }
>>   }
>>   
>> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
>> +{
>> +       size_t sz = hba->lanes_per_direction * 2 * TX_EQ_SETTINGS_TUPLE_SZ;
>> +       u32 settings[UFS_MAX_LANES * 2 * TX_EQ_SETTINGS_TUPLE_SZ];
>> +       u32 *host_settings, *device_settings;
>> +       u32 lpd = hba->lanes_per_direction;
>> +       struct ufshcd_tx_eq_params *params;
>>
> ....
>> +
>> +               params = &hba->tx_eq_params[gear - 1];
>> +               host_settings = settings;
>> +               device_settings = settings + lpd * TX_EQ_SETTINGS_TUPLE_SZ;
>> +
>> +               for (lane = 0; lane < lpd; lane++) {
>> +                       params->host[lane].preshoot = host_settings[0];
>> +                       params->host[lane].deemphasis = host_settings[1];
>> +                       params->host[lane].precode_en = host_settings[2];
>> +                       host_settings += TX_EQ_SETTINGS_TUPLE_SZ;
>> +
>> +                       params->device[lane].preshoot = device_settings[0];
>> +                       params->device[lane].deemphasis = device_settings[1];
>> +                       params->device[lane].precode_en = device_settings[2];
>> +                       device_settings += TX_EQ_SETTINGS_TUPLE_SZ;
>> +               }
>> +
>> +               params->is_valid = true;
>> +               params->is_static = true;
> I want to confirm I understand the code correctly. Please tell me if I am wrong:
>
> 1, When use_adaptive_txeq = 0: static values are used directly as TX EQ for HS-
> G4 to G6. But ufshcd_config_tx_eq_settings() returns early when
> use_adaptive_txeq = 0. So which function applies the static values in this
> case?
ufshcd_post_device_init()->
     ufshcd_tune_unipro_params()->
         ufshcd_apply_valid_tx_eq_settings()
>
> 2, when use_adaptive_txeq = 1: static host values are used as the fixed host TX
> EQ during EQTR. This is because ufs_qcom_get_rx_fom() only sweeps the device
> side. It reads host values from hba->tx_eq_params[gear-1]->host[]. The static
> values also work as the per-lane fallback in ufshcd_update_tx_eq_params() when
> FOM is 0.
Correct.
>
>> +       }
>> +}
>> +
>>   /**
>>    * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
>>    * @hba: per adapter instance
>> @@ -528,6 +608,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>>   
>>          ufshcd_init_lanes_per_dir(hba);
>>   
>> +       ufshcd_parse_static_tx_eq_settings(hba);
>> +
>>          err = ufshcd_parse_operating_points(hba);
>>          if (err) {
>>                  dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index f48d6416e299..2d385d42fcff 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
>>    * @is_valid: True if parameter contains valid TX Equalization settings
>>    * @is_applied: True if settings have been applied to UniPro of both sides
>>    * @is_trained: True if parameters obtained from TX EQTR procedure
>> + * @is_static: True if settings are static
>>    */
>>   struct ufshcd_tx_eq_params {
>>          struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
>> @@ -367,8 +368,12 @@ struct ufshcd_tx_eq_params {
>>          bool is_valid;
>>          bool is_applied;
>>          bool is_trained;
>> +       bool is_static;
> is_static is added next to is_trained, which was added in your "Add persistent
> TX Equalization settings support" series, That series still has Brian's open
> question about wTxEQGnSettingsExt Bit[15] being RFU per JESD220H:
>
> https://patchwork.kernel.org/project/linux-scsi/cover/20260424151420.111675-1-can.guo@oss.qualcomm.co
>
> Is this the reason why "Add persistent..." has not been merged?
>
> I'd prefer to wait until that discussion concludes before tagging this one. I
> hope this is ok for you.
The persistent patch series has been merged by Martin, we just need to 
wait for Martin
to push the branch, then I will upload Patch V2 to address the comment 
from Conor.

Thanks,
Can Guo.
>
> Kind regards,
> Bean
>
>

