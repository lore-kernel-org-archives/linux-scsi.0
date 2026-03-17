Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1AE3909B3
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732948; cv=none; b=iS6JDByaHP2EKbfWgM0AB8ha3M8mJFUT3nPhP81Ov91AJbtfSZBAmkwN4G0eSQjHuxC0+gtmeC8abGU4j9woeMVn1Nj4qIuxv1fPMM+mYA4xpeRnsOk9163M1TApqdMfZlg3VMnO4fyR+HSw7K48SALiE0sq7UQCjQC3N9II+Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732948; c=relaxed/simple;
	bh=6HsdBTgJo6yOxpN7KXRRlJ+48dUWpP0VrvpRav0Js7Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UyESjY5HM/6i8aOTymraCBdJxbhSVL9RTXupGJmjuLzcXxjm+izN7h20BTASQPrfBg6+28bfYczmo/HwPJ8b/A4IJTUczeO48pxm79vmYX5Q2TRveZ+E3LbrjxFubqab5sUNGBpSTuPfQ2jtL5UbeCKzApIEiFK9opN+q0yy5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ihcJeK5v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SWZkFHT0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ihcJeK5v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SWZkFHT0"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H79mGm2375172
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ey0/oq89ClsqfDrJuhx/hc9oMHoJv+emgmlJI69fD6k=; b=ihcJeK5vQdxuqKb+
	AOgZgJYKQqLieWAQgstkNPuFCCytPcnaC/Q9fEQ2dCqNk80ccmn1Y1GsZVnpwpsl
	Fdizsp0qDBDizqRjcKGf1+VnoT4RbIHiMYWyEmE5RxxcL+kpt3OuV2jFN4MJo71U
	YWNyNslqiWxrq1pVrFS+VnjmQscbyNDxcV+yT6q9p++giJvmqRFRi5PjvPHmAq6d
	URE7j+99S9TeUbI5iuNciceFEgLGmsoAg3K7KO9PvWoLAN67pFRPxn8nb+k0Z6rx
	R6H8i/YuXMDjOwCYjkYcCTrjApLj9FA05h9VUzOPdPs8DdnYnaH44dw/zgq0tx/I
	5joYzA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkby34xm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 07:35:46 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829ba0e63e8so2709651b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 00:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773732945; x=1774337745; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ey0/oq89ClsqfDrJuhx/hc9oMHoJv+emgmlJI69fD6k=;
        b=SWZkFHT0iu8iJFqrgleNXT4Szq+LuOjuaBXb2SoMc0TS3M5B/HMx+Qrv63zgvgt1ha
         kUEOTZnYRfhwl+60CkK90DNZdRt26CPbKdjXX+IdTrVg24siEDA54Thwv91bnWLZfeju
         B3/vj1n1B0z6umIXr5OIPSbZztUO3EkypzmzaKOf7Zk2loSwn9ZKcn3UqEQh9Dxt2MO7
         0g4rnVWFunRRHHPDDJtjDwvoxYbin5fMgQT2Do3Vi/ISZegdPF7a/J1CCscrWmPX8nrs
         nC2pW+CW2q/4sCtctH8zVFf5jgC43QZH1k5ctEHRN8TdTIi6ml90swRVj9GXkokvOC56
         Wdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773732945; x=1774337745;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ey0/oq89ClsqfDrJuhx/hc9oMHoJv+emgmlJI69fD6k=;
        b=bKZnTIqo7hXmH2E5T3BROC36KOAjw+hFpksncOPFQwGdslEK289euS+74uSfGHkEyP
         Bn8VYPA4W2g0dHaP8g85ksTzBO61o+TuAYyZDj0Woskl0u1li+P+a5sngJ0ryZqk8kOZ
         MDCscmpiawLZjTwkt1ZS13RszEYg/mXYFHjdfEPWRhpy+2EXGNpQi6IEYnU8SSdqqH47
         8Msbg4jlk0cbtJHc4a9FIZLPuePeY5SJ+eftzpfi+U4tAqg0SDqlaZSXP9XMR3SxWm/I
         V2Z4Jd5nQPywUXrxc5nYFASZoiyUXkmtlyEgKE2DxK7wzY+3qcDBZaPlEysyeVcK97wY
         mvdQ==
X-Gm-Message-State: AOJu0YxAY/pc2RvRk5rSJoniRqV1vXlzUY33DfKUL33pN1EOAa+lr7ag
	o5FGVziW/Hb0qzX0lNhwDR2x4nHSJE+HVG+78iUXbukjF8r0oGp/KItatMwd9/OTzMJi/OldJms
	QuHBiScZ/6Txu97NQmFTj55dXw+pVJL+QvR0xm/CTtEkY8saitnurpvT+phX51RHP
X-Gm-Gg: ATEYQzxUijR7FiMVIFG/Bl/VOnPo7qR8ftL/hpxZ30YrT2QFfQnFOX6KClZeuOjjiFR
	sQsGIvyRhuOTErdHQQiRxNWsyP/U1eeoG+tFpJXNYlamgCPLEHC4sNUG+qGp1ICoz0w/5L6NRL/
	Ogcndj5IZQvE5GtYJ8p6+45GOmVzdKpsmbtpY6eN47gr9pRks/U5R/aDPB8/OsAgnnArRcRx1zA
	TnDXY3SZXRyGAMkYsnQllJe+RVcb0ZHgqPgd9+lN7H1PqN3VLM/yka0mkfR8rkOs+V1SKoJdM9Q
	xc73USIKq8JlAZsD/VOjMc07ecaWDYItHHMFzdqvWOHRKRF+D9VmqwYMzWJwltJC3VpNVNxMUUB
	iEYPBNkoxPCC+wj+wb5Bu70JfMpQAanGi55XTh+txN+8hSlPXD+iQIGq/pET2p+jH5/7X7whign
	LtyyibeECXDg==
X-Received: by 2002:a05:6a00:1da3:b0:81f:4dc7:d31 with SMTP id d2e1a72fcca58-82a198c5874mr12942798b3a.33.1773732945308;
        Tue, 17 Mar 2026 00:35:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:1da3:b0:81f:4dc7:d31 with SMTP id d2e1a72fcca58-82a198c5874mr12942772b3a.33.1773732944799;
        Tue, 17 Mar 2026 00:35:44 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0727c40esm15487188b3a.26.2026.03.17.00.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 00:35:44 -0700 (PDT)
Message-ID: <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:35:38 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
From: Can Guo <can.guo@oss.qualcomm.com>
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
 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: WLlZiSWmQ3jRkhsyFkemol2T4WLWemyP
X-Proofpoint-ORIG-GUID: WLlZiSWmQ3jRkhsyFkemol2T4WLWemyP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA2NSBTYWx0ZWRfXy6QWuO5aiZ6E
 wrXsPHfKSZhQoIb+QUreKIEUbvD56LaVxcY67AbOfo9yBzvDoDVsTamm1IqOvw4FiynZefzM0QI
 KaDMFtf12vYRtn6T5XcmrY/QF5D8ehDrCw2l3dPPqarcA5yIW1DVUWy43Ro+AKx+VRlDmMGGFl/
 xjp8PebmqxBA+l4w6+3J0xT0h07DHoJBLf/AzfUOEaOqlqZKf5mHW2kVzqJoxrAnQzkX42gXvCX
 TN9paijuAhq0tfBjOoX+Fc+tikCwFSVKNV+UFO73BWyfIWD6zyXBZMFB6HOcT4BkaF20HsYJjrR
 Cf7lM0gMfrl7qij7ThORgddDDSqVBH0Vy/cwD60eNDtVIm0sWnmPTU2gAesFvbWn6JQg8cH61JC
 3sbxmMMlQ0ooQUpqxkoBIOWaxIqLC7QeNiSpmHaJbPMN6TqEXtnGDA+S/xoVE4HJmSLc69ZSC9P
 XtPQvRZwAAbkENHCxLg==
X-Authority-Analysis: v=2.4 cv=ZpLg6t7G c=1 sm=1 tr=0 ts=69b90452 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=sVS9pCE8PFdP2kJLLzsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170065



On 3/17/2026 3:22 PM, Can Guo wrote:
> Hi Peter,
>
> On 3/17/2026 2:49 PM, Peter Wang (王信友) wrote:
>>
>> On Sun, 2026-03-08 at 08:14 -0700, Can Guo wrote:
>> > +static bool use_txeq_presets = true;
>>
>> Hi Can,
>>
>> The default should scan all, not only presets.
>> Or, how could make sure the best FOM is in the presets?
> Here is the consideration:
>
> 1. Scanning all 64 PreShoot/DeEmphasis combinations cost (much) more time
>   a. This could impact bootup KPI
>   b. During TX EQTR, IOs are paused, when one conducts a re-training, 
> the IOs could
>        be paused for too long.
> 2. As per our study in the past few months, the optimal/best 
> combination is most
>     likely within the 8 presets, which is true for both Host TX lanes 
> and Device TX lanes.
> 3. Even if sometime the optimal settings which fall out of the 8 
> presets, they are very
>     close to optimal one found within the 8 presets.
>
> So, scanning the 8 presets only is more cost-efficient.
>>
>> > +ufshcd_tx_eqtr_result_examine(struct ufshcd_tx_eq_params
>> > *old_params,
>> > +                             struct ufshcd_tx_eq_params *new_params)
>> > +{
>> > +       int lane;
>> > +
>> > +       if (!old_params->is_valid)
>> > +               return;
>>
>> Is is_valid always false, causing a return here?
> It can be valid if we are here (again) because one conducts a 
> re-training.
>>
>>
>> > > +                       /* Step 3 - Apply TX EQTR settings */
>> > +                       ret = ufshcd_apply_tx_eqtr_settings(hba,
>> > pwr_mode, &h_iter, &d_iter);
>> > +                       if (ret) {
>> > +                               dev_err(hba->dev, "Failed to apply TX
>> > EQTR settings: %d\n",
>> > +                                       ret);
>>
>> Can deemphasis and preshoot be printed as well?
> Sure.
>>
>>
>> > +       ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
>> > +       if (ret)
>> > +               goto out;
>> > +
>> > +out:
>> >
>> The if check can be removed.
> Good catch.
>>
>>
>>
>> > + * @is_new: Flag to indicate whether re-newed since previous
>> > iteration
>>
>> is_new is confusing to me. Please consider using "need_renew" or
>> "update_required", which are clearer.
> I will move to 'is_updated'.
>>
>>
>> > +struct ufshcd_tx_eq_params {
>> > +       u32 tx_lanes;
>> > +       u32 rx_lanes;
>> > +
>> > +       struct ufshcd_tx_eq_settings host[PA_MAXDATALANES];
>> > +       struct ufshcd_tx_eq_settings device[PA_MAXDATALANES];
>> > +
>> > +       u32
>> > host_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMP
>> > HASIS];
>> > +       u32
>> > device_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEE
>> > MPHASIS];
>> >
>> Do these two records only store the FOM and are not used otherwise?
> They are used by debugfs entries to print out the TX EQTR history.
>>
>> > +
>> > +       ktime_t last_eqtr_ts;
>> > +       int num_eqtr_records;
>> > +
>> > +       u32 saved_adapt_eqtr;
>> > +
>> > +       bool is_valid;
>> > +       bool is_applied;
>> > +};
>>
>> The size of the struct ufshcd_tx_eq_params is 2.2K.
>> It seems that some fields could use u8 instead of u32.
>>
>>
>> > +       struct ufshcd_tx_eq_params tx_eq_params[UFS_HS_GEAR_MAX - 1];
>>
>> This uses up to 12KB of memory. Is it really necessary to occupy
>> so much memory? Can we use dynamic memory allocation instead?
>> Especially since G1/G2/G3 are not used, and G4/G5 are optional.
>> Only G6 is actually needed, so we shouldn't waste so much memory.
>> After all, memory is expensive nowadays.
> 1. Even we use dynamic memory, it is still the same amount of memory.
> 2. G1/G2/G3 supports also TX Equalization settings, my next series 
> will provide
>     changes to allow one to give TX Equalization settings from DTS and/or
>     persistent memory.
> 3. G4/G5 supports TX Equalization as well as TX Equalization training 
> as per
>     spec, we should support them like G6 equally to enable better link 
> quality.
The main data struct which is costing memory is the TX EQTR record 
arrays, I can optimize
in next very by dynamically allocating memory ONLY for the Gears which 
actually
need TX EQTR.

Thanks,
Can Guo.
>>
>>
>> > +#define PA_PEERRXHSG6ADAPTINITIALL0L3          0x15DF
>> > +#define PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3      0x15DE
>> >
>> These two lines should be swapped to match the correct order.
> Will do.
>
> Thanks,
> Can Guo.
>>
>> Thanks
>> Peter
>>
>>
>> ************* MEDIATEK Confidentiality Notice
>>   ********************
>> The information contained in this e-mail message (including any
>> attachments) may be confidential, proprietary, privileged, or otherwise
>> exempt from disclosure under applicable laws. It is intended to be
>> conveyed only to the designated recipient(s). Any use, dissemination,
>> distribution, printing, retaining or copying of this e-mail 
>> (including its
>> attachments) by unintended recipient(s) is strictly prohibited and may
>> be unlawful. If you are not an intended recipient of this e-mail, or 
>> believe
>>   that you have received this e-mail in error, please notify the sender
>> immediately (by replying to this e-mail), delete any and all copies of
>> this e-mail (including any attachments) from your system, and do not
>> disclose the content of this e-mail to any other person. Thank you!
>

