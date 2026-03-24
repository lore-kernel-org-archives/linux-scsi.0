Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB5539657C
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774346971; cv=none; b=iUqTW/u69Jo8dTCaNwsgvuBFhu9GCbnkzgoItgsSMFTxP4ru+TfyLq87awBzvbnWaYIRVJWcBI+XA/7CyGa6VPhjTUdcBQYVNG2oqH1tv6Knkj5hr+JHiV/g7Y8cNUhfPo0DSXSNp9wSLiV1CrKCYKb1XimkVoKSU0Fz5qYlOt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774346971; c=relaxed/simple;
	bh=Y6l6P3mRcGumqcg7EpV61TZl1gP6VXw05dJB9IDwwgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MULCA1XVVVzSd80ECh04FC20ae+DDLzYSvT98P3U4Bp1OiHrCfU7qbf6PYS3wi9O4sIbEe9o64muHhj5BLm/7pbLXSFB7Va85f0GA3v9dtctLtUR0/O9QC3UlxQbv/tnmUP2V1KZz4czDBEJibEZ4+KKPUTKkzsQ2brZFjLeTso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ILcYQGHw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IkzRDKl/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ILcYQGHw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IkzRDKl/"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O8xgUN2322865
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 10:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UrpwhYpqVWH5PEq+bY3QVD0NRdHOyCw4udik0ap+snM=; b=ILcYQGHwjEsynasu
	pCmW7R5GVvcL12qoX5W5fmhLrJQCl7HXhY8WHq1YSjtpYsRSknf7GMLkuv+rMZHH
	RML1o0LVxf1qOy1dDxZ7soZHc9xBIHuGcgnLbOu+l0tFVdaCxq42utFv+Ip3Ytrj
	9OvDhDW1GZuJXhR0IgNKxKYgbHEOcUuv/r8e9giHbte3BrWBKMhnjz5Dt3XgX/Qm
	q/Y5ITR0rtr1O7Lkq84Th0HDVDT7/dQT7V3q28n9xR9Rf9abrPbtE3TbnHjadRGK
	kb7F16kEHanmfxgvnHIN6wSoOT4DHOwaxi2VU/teZWO/bY7CBLNSlnsSUPI3kna7
	xBBQ/Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3qker9w6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 10:09:26 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b0601ff3d9so21407425ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 03:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774346965; x=1774951765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UrpwhYpqVWH5PEq+bY3QVD0NRdHOyCw4udik0ap+snM=;
        b=IkzRDKl/2Vj0QzM2nqiwrIjm/7/0gIY36hwN3mZAlumvfn68r+eSM1QaokHcCBngis
         PK5iKi9QKLjvcaxLyYa4Iv3tq8cKZOkbvhYB4B/Tm+BRv4D9CS+ijxAZEEHMK/hDWUIf
         oA/wBLifCqR+7l0JZE9Zt5xmqRpMlzTc68rMLNzUrJ98l+X3wjPqiCFYCBv7yDGQdsTO
         QDeoto+g1MclyK0hqzCCJ6+Xx3/qCYj8KVP+kq7YxtmCCSCpAHJiyrBYLuIeKkOjG7o6
         7zIT7md0iAqMeQajpcuFxgYUnB7quC9VeBj1f+JwHzLDsXuPBYI9IJQ4jVv42LQr1Gp0
         Ud7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774346965; x=1774951765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrpwhYpqVWH5PEq+bY3QVD0NRdHOyCw4udik0ap+snM=;
        b=afaL+1FGTxsdBN0WcfpXFPC8Hy2rdkmzt5tk2Nb6LrayX5X2jq+9fyI3qi/cRe6/UW
         nfs2lOj02HQBaflDoUKkkpuPaz3wKBu0KjCqPczdgn/sG/9WTGtQew9DT0XdEK/zTF6a
         wjZqyXeqvVNbJSPsc1A/xeQ0f5kedq607CVr67VdSY4UHSFqJukWvE47n34tmLxMOPo0
         SRp+oOn541HREAbqxviyoOe0sINqu5cnqptSJNxfc8zFFCZTjqvEVNoJELd/B+QMlrnB
         iK6RA6Wxt8FZrfbSEaIkiEnAXVf37PeAcUBWMu+rClS/aUYOzOq+IHEgxDDC5MeK8t9E
         YBwA==
X-Gm-Message-State: AOJu0YwHz/vmzPLcVtFivIUFAAuH42jT7kqvbg77CIadlruWenJqVloX
	+Ya/cxUObgjNQyalIIrOWAViKOtehC5l3qWApl2tsK1JwEDqq95vKo6Slf/NmlprOIay/l2wAbF
	bkAnBkepdlkFn8snHyBuWiuAslULlr6bsWHs8N3yspeCjlgp5AmCWSDDd+m37WNyN
X-Gm-Gg: ATEYQzzURsZyydvwIrUpQUmDdqT5YriZ7c44LWhIvT5lWrvJpTXqJcMHe73/c+Voh9b
	z7c95KO6fLbJ/zks4Bf7weSa1AZDtDx5mF7ZfZ6rZY+bah4bm31MeawOo1Sk3JF88nAvht3T1BF
	nxvDdEq4njvb4gS+hx77j20KXGvrrXeCMWLnsWf42KVMIXdQ0GTtI2IXL4klnBSjLMGGEFU7rq/
	urrkp2bBK0SD15R1axvqszZpTdugiyy5s71D8Qn5rmmUoCUxW/mUtrYI0fO9rE8zr/7IiK/L7gw
	lUII/mkaazyIvJZnRXaD2UQX8JQi52JRmOajHaPYp6U77b+DU28Yq4WHH5wooQYxizmK2JAM1jO
	N9Ml/LwcCvqf3qxmTF062FICwgZgky3KTJitJ826AGAoNQJnRdVLc/l0XFg2FCq7Ycr7MUQyyUx
	n0KJNtlTNaXmQ=
X-Received: by 2002:a17:90b:2242:b0:35b:a7be:ae62 with SMTP id 98e67ed59e1d1-35bd2d2c8e1mr13176933a91.30.1774346965159;
        Tue, 24 Mar 2026 03:09:25 -0700 (PDT)
X-Received: by 2002:a17:90b:2242:b0:35b:a7be:ae62 with SMTP id 98e67ed59e1d1-35bd2d2c8e1mr13176904a91.30.1774346964614;
        Tue, 24 Mar 2026 03:09:24 -0700 (PDT)
Received: from [10.133.33.145] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0318f2ddsm2563054a91.17.2026.03.24.03.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:09:24 -0700 (PDT)
Message-ID: <1a038159-c847-4e58-a60c-cd5ecabeeed9@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 18:09:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX Equalization
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
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
 <bf904a137c1a3b8f6ec0dd712e15611155ce3e11.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <bf904a137c1a3b8f6ec0dd712e15611155ce3e11.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: AschAyFVdnzOoxviKfrs91kXqIGwY6nc
X-Proofpoint-ORIG-GUID: AschAyFVdnzOoxviKfrs91kXqIGwY6nc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4MSBTYWx0ZWRfX3WXFmyseql4F
 vayk00+9p0BSQmmYxB+sOd+NuLXW6+3NBO8/9Hd5HduMpswtvdTz4ANFIujqnP2OOPRRgUA83u5
 VoY6sKISLnvs6xA6hdwHt2ORximszA9BzBruMAJOggc058DXbmjCBfKxmrApbKeZpKQgllreNAF
 HZBfOOR53oEzAuZ6t7nfYFLsB5nMhL25Uu8O780Y8+hox2w+DgJt1qWOWTl8a9eaO20iVVofFiB
 5IASJEc6wbUqTyqY+wunv8X2G0Pqswbskd4Rd7pPXfOPV+dhZ+AR1HOzCMSWv5m8jJNLAsUuINT
 dxekoUhVP2bqVKlCZZy0QsyFHpR7Fm1IVmj752NmvyMtbW9tJBS8zg15Rwv53MeKHuEMEAXsblo
 6sjc094Ad+j4nJ/XQdE5dXtTu+3Jtzp0DWEkjQvVJy8nzGfi6mX3Ny6YuL9lGeqGhTOazmi2CeP
 ReQOwi4OeWStoLnkMZw==
X-Authority-Analysis: v=2.4 cv=Veb6/Vp9 c=1 sm=1 tr=0 ts=69c262d6 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=JjZgfduHwEyX-iJ7t1EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240081

Hi Peter,

On 3/24/2026 3:46 PM, Peter Wang (王信友) wrote:
>
> On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> > +static int ufshcd_tx_eqtr(struct ufs_hba *hba,
> > +                         struct ufshcd_tx_eq_params *params,
> > +                         struct ufs_pa_layer_attr *pwr_mode)
> > +{
> > +       struct ufs_pa_layer_attr old_pwr_info;
> > +       u32 gear = pwr_mode->gear_tx;
> > +       int ret;
> > +
> > +       if (gear < UFS_HS_G4 || gear > UFS_HS_G6) {
> > +               dev_err(hba->dev, "TX EQTR is not implemented for HS-
> > G%u\n",
> > +                       gear);
> > +               return -EINVAL;
> > +       }
> > 
>
> Hi Can,
>
> This check can be removed since ufshcd_config_tx_eq_settings
> has already checked it.
OK.
>
>
> > +       params = &hba->tx_eq_params[gear - 1];
> > +
> > +       if (gear < UFS_HS_G1 || gear > UFS_HS_GEAR_MAX) {
> > +               dev_err(hba->dev, "Invalid HS-Gear (%u) for TX
> > Equalization\n",
> > +                       gear);
> > +               return -EINVAL;
> > +       } else if (gear < adaptive_txeq_gear) {
> > +               return 0;
> > +       }
> > 
>
> "gear" should be checked before use?
I don't understand this comment.
>
> > +       /* TX EQTR is supported for HS-G4 and higher Gears */
> > +       if (gear < UFS_HS_G4)
> > +               goto apply_tx_eq_settings;
> > +
>
> Could we return 0 directly?
> and move this to the previous check, like this:
> } else if (gear < max_t(u32, adaptive_txeq_gear, UFS_HS_G4) {
> return 0;
> }
Sounds good.

Thanks,
Can Guo.
>
> Thanks
> Peter
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

