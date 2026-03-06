Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548E2C21C2
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772802007; cv=none; b=uVnBmkhECkk4aAVbjspZaL1p9qUgTL9f1ufK5ADn/Fhh/3f4RFUv6HA4lGmK+itH8V77YoTn+ygF/Kox3U6Q8xEDQGjyQlHOtxQXaOi6jj4d7cIdcqB9aSgKOSI9quMi4aT3z0p2WJvOsntQU1Q/kfJI1SzswTZ8AORurrfJbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772802007; c=relaxed/simple;
	bh=To3oybs//nRCsZfr15UepiH/PCQfLOLM9azq0B2N2sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g44kyMuWdcyPeSdhMuP3PxnHd7rlsbssKIIYSR+HCyx0EdbzQpf9QwXfGRqtjXirZkpfN1K47C2tjiShKnwxPHVgr2/6aO2uezQJNqj71NAt6F6UAkvnD2qPyGZAzpGvUFdP7qCuD3uE1MbNCkD0V3b25hoB62JBZXknLvf4DY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Owvsm2vG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eJWjt9FJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Owvsm2vG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eJWjt9FJ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BafKE4185879
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 13:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	To3oybs//nRCsZfr15UepiH/PCQfLOLM9azq0B2N2sk=; b=Owvsm2vGUrvJE22y
	WzZJ+aJ+0j58D0sAjmnnynh4XZS6ynoR08wwFD1ZFCdW7LDVOH91FUUesARe83l1
	U/my4EWv57ILb7REGIrqMtB+VIGUX/UhQFBNdKztCh9/XEmtektKN8+6BBP9j7xU
	T0G6BTE6YlL3ZuDgBvf1K3khj5/DlrEMZ5VyvklyKNLKdMM3yLy/xSgamr1wiFlI
	6d1dTK/ri2mWsxDRpj/6rJjtSQLKYac8elIGvSBjmEZMCmaqKx+ZcibVb3S1UNpf
	/nBtTcjVRh5Y9mQr95YYUpVhbZA8UeBZMVveRJnEEjL6QcGihvb31V2x38kSNetS
	JrL7Pw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqruk9dts-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 13:00:05 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ae3badc00dso72211865ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 05:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772802004; x=1773406804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=To3oybs//nRCsZfr15UepiH/PCQfLOLM9azq0B2N2sk=;
        b=eJWjt9FJwhipgu2IQeDXsXKtFH4Clcfkz+7j10nCyh4zDZcEri36J9MaruZqU2H4Re
         jQwuzMhdqQBof1ztW+J7mO5GpnqmQ19GlhBzNHpVQ/9gdpnLRw2ztg7pbdE++C1YIZy/
         KOqFhQZ/74n+oZe2nL2nf5HLLS7PgkWn4mVR2L9myQ3PMzDKxdSTakxHO6ClieaXOMVi
         cNGPkgIXCLyuLwGfd1XPYRq5bFN8RfSfZClvkHopg+NQb4vJI43x/oqkFLy3Mpb/oX/e
         cxV+2M3xXWBoHvuXE7uYlO0wUCuqXg9khdyFkCD0pUvT7TWDzJgwhoLAOxCKHaTmJI5z
         2gPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772802004; x=1773406804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=To3oybs//nRCsZfr15UepiH/PCQfLOLM9azq0B2N2sk=;
        b=UqWeFikTOGz7oe0pTNpsACLx67nCQpkzYt5UqFdlsZH/AYbEeOuFjHPKDWMQINnORr
         reR3IbsHkTkLT1Jc/4QVTDA/K4wSFd0/l2D6GLMnHL+a1DyIB7PRv2Qfe9HU6c8aL7Tf
         MRQV315rdXM1+Z87zzNYtxRo6O4jSlAO3McJeCU46JRPZNobRsqVpAmTrvXf4+giwp1j
         RXZuaYPmpeJoRCr83U6n8p2BxYwwTdfPz6/j2BqtCQqyXsdfceiarDTh89i8uhKI1Whb
         7F47qEfPcsehU4doYBf9l0SPQ06N1jMmMJn5GqOBMSpkqDH0c/rveb6TjOb8MIaaSSWe
         FLzg==
X-Gm-Message-State: AOJu0Yz0b2qafE3DQqyDQhhMDKNeUkWPGndUBWIXaJehhvDIHl7zB7jC
	qzVK4jWB7Q1KpQxVi87qFUYr9iXRKWc4SeJgE2p9h12QNn/PwJMzQK3KF5CeQ0SZmK4+wNjK+Bj
	gmkSglXPp1AF1RixmY9rzTwDDZFd7toa4h2McG7tYGHHRFBI/mWglFQFitL4YmL65
X-Gm-Gg: ATEYQzyweupa202THvrS15FkA+XQesGy2DJb41BZ3EY2JBsmzpLkk6/RAnH5raVtQZj
	286RujOUntHwIgL90PujuBzc5pPCwOhLxo6JwoHtyrSs+gBTF40Uo4Ol4ZgXCgDUDiQ3MJl1F64
	lK8Mr0rLvXjgCxr7ebgxGdW0Zz2WJuq4JDUHn++jtOEnUBDqFWiFegrA4zsi6zUC3cd7mIDREYz
	HaRZF7arl/dkfZNwUBTU599HitCKmJmJnrhxESm4xZor0llR9UxELtjVkPUbFvmqbQMD1f/HrgB
	VLcgaUIqUzxHnaeyt+FPAi8XxyLa5igOa+H9g1FVxs5Seg1z6m2OyAH8paVjMlulKjwLs9O7EsT
	x4X7V4/trDA2umHB5hE10bZYSvYOSlyiUMihxnYjcQZg63AWekzCgzWr/nX0pIyl8C3iPObJnLB
	MUxoxX+Zbe6WY=
X-Received: by 2002:a17:903:41d0:b0:2ae:6192:8da4 with SMTP id d9443c01a7336-2ae8236711cmr24147125ad.2.1772802004319;
        Fri, 06 Mar 2026 05:00:04 -0800 (PST)
X-Received: by 2002:a17:903:41d0:b0:2ae:6192:8da4 with SMTP id d9443c01a7336-2ae8236711cmr24146695ad.2.1772802003793;
        Fri, 06 Mar 2026 05:00:03 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f759fdsm28945635ad.57.2026.03.06.04.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 05:00:03 -0800 (PST)
Message-ID: <f0ba8af8-5843-4104-b6ed-05d9160c7498@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 20:59:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] scsi: ufs: core: Add support for TX Equalization
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-5-can.guo@oss.qualcomm.com>
 <5f998c89c2939baa2939a1ad8942b015d3ccccfc.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <5f998c89c2939baa2939a1ad8942b015d3ccccfc.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEyNCBTYWx0ZWRfX1BF6bXG+V1od
 5qp904D1uQyPqhzqyMIfldHDZUGoyTR9xXlq0iaHgK7iB31DnZcoIHw30GSCQjhjAPMeD5yXQlg
 YMBOnIQkHHUbfDGPnxmBSOE1h2xdrn94U592QI9wZD89DB7SroIbjUC6JXrQY5RVeN84x3jB3iP
 DRwq75084MQtd+JvSDH0Hxr9RK2Nh8UFNahjQ1JFUWRwuKrjA10BsFw2sMNbADT2Kgl+BX5X0TS
 vqOPmC7lmYXM7OkOCxqApO6tpfOMyzwxKqcBDm1hLXxBbKG6oAk+VLNAOtFT8jzBsq+qfL57Boj
 CvDhxD9VZQ95RddqBUrQIJlc0n+mspfSpVI3XOzHi2NpJ/iyvRW5K/HEScwf4H+mEYgZKwH5sh5
 DA/v0c6L/PM0vIQFiLXozI6CzR3m/jtUgw4UZfBV0c68fSWi1TJu/geTPCCaUDWrKK/rcvsCs3z
 YhWBiq5w7WPt84EG5OA==
X-Proofpoint-ORIG-GUID: -rrGzlcHE-ircClzlB0tuPxLFFImhfoK
X-Authority-Analysis: v=2.4 cv=DvZbOW/+ c=1 sm=1 tr=0 ts=69aacfd5 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=oayze6Pay6DZa2MYWdUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: -rrGzlcHE-ircClzlB0tuPxLFFImhfoK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060124



On 3/6/2026 5:50 AM, Bean Huo wrote:
> On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
>> + */
>> +static int ufshcd_tx_eqtr_data_init(struct ufs_hba *hba,
>> +                                   struct ufshcd_tx_eq_params *params,
>> +                                   struct tx_eqtr_iter *h_iter,
>> +                                   struct tx_eqtr_iter *d_iter)
>> +{
>> +       u32 cap;
>> +       int ret;
>> +
>> +       if (!hba->host_preshoot_cap) {
>> +               ret = ufshcd_dme_get(hba,
>> UIC_ARG_MIB(TX_HS_PRESHOOT_SETTING_CAP), &cap);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               hba->host_preshoot_cap = cap & TX_EQTR_CAP_MASK;
>> +       }
>> +
>> +       if (!hba->host_deemphasis_cap) {
>> +               ret = ufshcd_dme_get(hba,
>> UIC_ARG_MIB(TX_HS_DEEMPHASIS_SETTING_CAP), &cap);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               hba->host_deemphasis_cap = cap & TX_EQTR_CAP_MASK;
>> +       }
>> +
>> +       if (!hba->device_preshoot_cap) {
>> +               ret = ufshcd_dme_peer_get(hba,
>> UIC_ARG_MIB(TX_HS_PRESHOOT_SETTING_CAP), &cap);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               hba->device_preshoot_cap = cap & TX_EQTR_CAP_MASK;
>> +       }
>> +
>> +       if (!hba->device_deemphasis_cap) {
>> +               ret = ufshcd_dme_peer_get(hba,
>> UIC_ARG_MIB(TX_HS_DEEMPHASIS_SETTING_CAP), &cap);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               hba->device_deemphasis_cap = cap & TX_EQTR_CAP_MASK;
>> +       }
>> +
>> +       memset(params->host, 0, sizeof(params->host));
>> +       memset(params->device, 0, sizeof(params->device));
>> +       memset(params->host_eqtr_record, 0xFF, sizeof(params-
>>> host_eqtr_record));
>> +       memset(params->device_eqtr_record, 0xFF, sizeof(params-
>>> device_eqtr_record));
>> +
>> +       memset(h_iter, 0, sizeof(struct tx_eqtr_iter));
>> +       memset(d_iter, 0, sizeof(struct tx_eqtr_iter));
>> +
>> +       h_iter->num_lanes = params->tx_lanes;
>> +       d_iter->num_lanes = params->rx_lanes;
>> +
>> +       /*
>> +        * Support PreShoot & DeEmphasis of value 0 is mandatory, hence they
>> are
>> +        * not reflected in PreShoot/DeEmphasis capabilities. Left shift the
>> +        * capability bitmap by 1 and set bit[0] to reflect value 0 is
>> +        * supported, such that test_bit() can be used later for convenience.
>> +        */
>> +       h_iter->preshoot_bitmap = (hba->host_preshoot_cap << 0x1) | 0x1;
>> +       h_iter->deemphasis_bitmap = (hba->host_deemphasis_cap << 0x1) | 0x1;
>> +       d_iter->preshoot_bitmap = (hba->device_preshoot_cap << 0x1) | 0x1;
>> +       d_iter->deemphasis_bitmap = (hba->device_deemphasis_cap << 0x1) | 0x1;
>> +
>> +       return ret;
>
> ret is returned without guaranteed initialization when caps are already cached.
Good catch.

Thanks,
Can Guo.
>
>> +}

