Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473682E737B
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044180; cv=none; b=e0/MF1VoY4pA6Xc6jmhphjNz/eCy0UP42tMxpn2pH4vnEqom6GQ9dz3pD2asXqtF9hBitW9WAPd7JSxLu3C/9GfMOy0BkAUFPv8ROitmzCg8S6RnrLKVVVyJNycdd55nS/VaN3NNA1UT6F7WLrhdL7hVSqDYgbR2paI7+NWJMno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044180; c=relaxed/simple;
	bh=H2R1rAAC2qP2s6RXU1ks0J1r6HVE8RZDjOliU6dTxjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/9B3JsdueRA3O/PYW6dy/0EDlnyLe9kvlF6b6l6lhRYhWxB/HaCo01oGz3yhJOj1B5lDd75KUrYJPbeNysCEh9CFVdzl4l00xWwPDyBrao+XAzo1RkFZ8a4x5o0nT9+hwwpfIUvLwMofXqUmOHBNnsg9cda+AuwIq7RCzXh5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kqN992Ug; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CambGTOK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kqN992Ug";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CambGTOK"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T7EnZr1830098
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+O4THh1DQwVCJTT5A1E+2yOFluHVMghLlE26G57FGbk=; b=kqN992Ugst/rSc0C
	VVCL7GpUAW5C/qSUpK/fFe2HI9zkkjm/SwGt83i3AMeFbUNLCN9BtAZphqPuqfgL
	IbRtazw7RtMEHa8kyiio/HdGdb7eBtgX7yeUHo2NzhjZnNHzcTEAlaKnKty3rmTE
	gVBVxMUUnZVk7ycL9ARoVoElHf7TVic33Z6ZWiYHLY9SmHhlTimKvLy/trCIWVDc
	OjU58u5tpqbOmYKocR4FaUSx/a6MnczuT0wswFEG+zo1zm4emyUCUrqgNHHQ7Noj
	QfSByeL7wbEygGM5IRwUpPyqBvCt5FZ9GougagMMfiJQk/r3mue3mqmezmmm6eOn
	d1lqUg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eex6m2c32-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:42:58 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b7aba0af02so136228975ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780044177; x=1780648977; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+O4THh1DQwVCJTT5A1E+2yOFluHVMghLlE26G57FGbk=;
        b=CambGTOKVfRB7FIUfb1weK4x5dUX/vOS9L9C+lPuP013syoVcZNoyXAWCpqMOwE7/2
         8ZCtuRXtKWOAXSx1x2+TbZAvDQxCNVYCIFPlINxs3MG6L02hxPWbBk220TuwXINiQ1d7
         sps/l7PAl9OF/sEJFUm+RK8UGKoatOK8c3qjIiBV1Y/bPgzaTNJ4taW4NECfSMatgOG6
         t3vxdopjYOQkYgOz0e7x0r1QbN371wQc2uDXU8OSuf38VvBwrd7fUjw8S17UbUbFEA8/
         qPbfsMCUd9A2OMxJ9RBW6xkvMhQ3ebncorZ05uR/vYP1lcfXdWJxMGAa2bALC5llSaEw
         2ABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780044177; x=1780648977;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+O4THh1DQwVCJTT5A1E+2yOFluHVMghLlE26G57FGbk=;
        b=CS4jJ8gYB/27eJx2AN8HYw1Ltl6J3I3vo9FvFMxObnMRt+XaA3n77ubiIV6b3TsrTu
         HCyRYGAsayWskFdhGuakEBgZQCGrvCJ3ZrNsxPextAc5LowInZDaNy0GRMpLE8VoENe3
         m4Eu1D7X91G9SS0FfZpOON0iFaVImA4FxliIFf72XawwU7fn55MFRUNvAoaq5CTKhzgQ
         XGsd6H8OmbRS5b1eAJ/EdPS2utY7xmlmWTQ6a9dItE9VEbgHZsf4q2QlLA8aVS/ZU7kB
         P1bmshqzhGtVFNOyWsJHLXw0s3HcWU3tE8fdcb0GfZyQCMyiAduvIj1RAhzO7mIzTufa
         Fbdw==
X-Gm-Message-State: AOJu0YwnPKNCzXSLVaZOZlEFdJQaF1oux0SOMu9zcAr4L//SUuFNJDN7
	luLb3TpbI4YWFwH8gQZpWl4JlrFYVSFkh8ysRM4WqhD8WuFsfKmIfBsJXLkTqFfS5QUGxMVnACD
	66HvT148OSj7GlAaitmADxihmZfxP8QhnJsVhxojucr4+6EzC2MCGLgvhjG0a1Vaq
X-Gm-Gg: Acq92OEu9fENM4Af3b127R2QZGYhaBpoeGkTbHS/FU/TMzmTsWRQaT1drDzwb7lwZrg
	eBLRVbs0BILLPI8w+7Cs9ZMt/kJ2NcexoJpk/ZJ/0Ekh8+T090w1T38gLGVQLNXIOZHvALKIssT
	Ylx97q90ChAkVpU6S5u+Qqfy4FixmF0xv+O5MWAAdzoJsx3zYIpcYuRznPpIWohbUKeDdIHC0Vx
	M475nXy3RzH9JT8YqfzFEz4fgTjIEyFusReNO+fj/Z/X+wtWOjAKa1/chYPpGOfOjwdLM5kZxaQ
	iURHRXML6n8k9n0l2kKX+o4oVsiGL+49qR7qqojDpw4DTsVS8RvBqgd6uHL7NyDCiasWiES1Ti7
	DcMY4JYQ69Tty6GTIIh7srF/mVqMH0E7aVZjMcJgAOjqPVB35rmPwbytj3dR8UT/iJ/9ngpkojL
	X2bVhOhjYAHWcDOfmeExgTVw==
X-Received: by 2002:a17:903:350c:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2bf203dbc13mr26417785ad.0.1780044176978;
        Fri, 29 May 2026 01:42:56 -0700 (PDT)
X-Received: by 2002:a17:903:350c:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2bf203dbc13mr26415845ad.0.1780044173663;
        Fri, 29 May 2026 01:42:53 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c2da36sm15253425ad.69.2026.05.29.01.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 01:42:53 -0700 (PDT)
Message-ID: <0e3c4e21-0c54-42b5-8863-8604f1b698a8@oss.qualcomm.com>
Date: Fri, 29 May 2026 16:42:49 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
 <20260529011421.462046-3-can.guo@oss.qualcomm.com>
 <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
 <7f2f9a0a-03e9-4a0e-ae57-2b0c557e029f@oss.qualcomm.com>
 <f2e1a0335a7c05ca7dbf48c17e9662e9695ded51.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <f2e1a0335a7c05ca7dbf48c17e9662e9695ded51.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDA4NCBTYWx0ZWRfXww1TSYiNzwuo
 XTUGU5Usp8SqzSRjlxq3J3E4P2wdBv9ErfewwTcUW8G+IyFfHnv0H1VRD9hjDlQ6PAn6auA5ZwW
 vsHV/cf+Y5Tc8lAoR8wATgIennj3r01nRPQ0+1UT235+XQ8kyBc0Bmb2PpXMuUg5ynadJSfn0zL
 EyJA3kSohyV0QFL9kPRtBxBREEJNTZ71CM6oNTLoQyO5xG48TxooYM1MhonXnazTDkhNHW+HxhX
 1nXgxvfYf7cw6ZBmuN8cFsLS2idU0BxnkEu30YTy6VSKYdcC0NskMq7IPcSHpQmRW4NwQHk9akY
 xW/CvfJOC0Yya/bp8cyFXkRNSLNchrScvsI5rRpdqxzgb2cMrcJWvpdDp3EWysa+8jA9+/krkTp
 rUetSC2fpaq8KZi2Fv8DyL5naiWGuA5SlzhdcEfpeju0vcsMXD7t1exxHb078DQ8ht/lgVvgGZL
 oz9klznO7H9bmohwOGA==
X-Authority-Analysis: v=2.4 cv=frnsol4f c=1 sm=1 tr=0 ts=6a195192 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: D8-JmsWVNRk0LyQKnvNV1VPm7mSewkw1
X-Proofpoint-ORIG-GUID: D8-JmsWVNRk0LyQKnvNV1VPm7mSewkw1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290084



On 5/29/2026 4:40 PM, Peter Wang (王信友) wrote:
>
> On Fri, 2026-05-29 at 16:12 +0800, Can Guo wrote:
> > > > +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba
> > > > *hba)
> > > > +{
> > > > +       const u32 lpd = hba->lanes_per_direction;
> > > > +       const u32 num_elems = lpd * 2;
> > > > +       int gear;
> > > > +
> > > > +       if (!lpd) {
> > > > +               return;
> > > > +       } else if (lpd > UFS_MAX_LANES) {
> > > 
> > > Unnecessary else if after return.
> > You mean removing 'else if (lpd > UFS_MAX_LANES)' and the dev_warn()?
> > 
> > Thanks,
> > Can Guo.
> > 
>
> Hi Can,
>
> No, what I mean is that the check below aligns better with
> kernel code style:
>
> if (!lpd)
>      return;
>
> if (lpd > UFS_MAX_LANES) {
>      ...
> }
OK, got it.

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

