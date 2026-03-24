Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7888E3F54BD
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 12:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774355575; cv=none; b=cNJu/9ikeu2sRgBDbdAbq7b7QtMZMbn3yMJLzyVm6SRMOKu21H94YHQDARWSQpkRfzInH5Ajm5wA0xmdGUHOgIogMmyFg6r+1I243Z2FQMTJpj+bj/6BDMoMmelI0caiZW637oaEXnPLsWPL7cDpAbIhxCJnoc+la1EBYrFMwn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774355575; c=relaxed/simple;
	bh=K+62/RY1VqDt8d7ZbBqBcK+vgSO+rSU5Shy+fhN5Djs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJsV8+LvPJpZXHVNlNGnEQiOvDF2zq1RreFqHZe47UkcETBSJtIy+7zLNRz5SXL4BQH5UXXds3TRLyqTINegrFQViUZnKTmgQ1tEwTiDpwKt0ImsttyXyXiZMeDzXM6KEYPMscUFf3kmr8xvfI1dkPFTccCr0aWMobmUNs2pzpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=J2KjtTBR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RVSsXbnE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="J2KjtTBR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RVSsXbnE"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O9dp0A1762212
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 12:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SFSY807vxOyGgTezoYLzQbN/077d0T02CNYv84Cish4=; b=J2KjtTBRra5gAVm5
	eissekn4TC5/MK4BRy00pqXUARBbM8QYwLHOkyxIbSios7VXxnnxHPZ3i1pRwm2K
	PQZff4y3+RPEe9ht7zBOb0tgJUOHy7pD8ESpAyOXVgdMPFri9S6Z70abOnRLQXtt
	Qel8A81Mi2StWqoyrf4+5G5eKTY+AkpG+FneMsoK4Bs2Xp6StI58KFpBCMYAcZrk
	dHLv9P33fN7nLJLK0TsXyg+WFFgFYBhQDfX0K1XggVNN8qPV3c2lK45CUIrikLzM
	ViNUPalLvVB1hQ/Fqjf/u0KVgigdkLVrTSv7qAXITp0ozE2wnuGLwtemAIQevTIH
	86BQZw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d36f0cfyy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 12:32:50 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aeb90532f6so25611355ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 05:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774355570; x=1774960370; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFSY807vxOyGgTezoYLzQbN/077d0T02CNYv84Cish4=;
        b=RVSsXbnE6UML1g8S9yd/Ed0BGwMs610svkkkD48ooWM4vv3QCpuZIamK/iUFUMTzgX
         9RqyRtW2ZR8D/88Jfu9CXsJS9MOenYBZdZXV2RGS6oXnWauZYInw9UOFU75FoTCa6W+e
         grb5/Pek+KOxsYUBSqqvu+lJ3GYNMa0psD2lFeOS/YyZzi6J5bMOrKFZhtORES3ApjZm
         IOewUOl/YbjPtp/v/VwX/6NKjtO8FN9E6ECokO/5g/aB1s0TF5CfPo+4wWECwpl6U6sZ
         idxFx1F7PTnhf2NHujjWetwYWrKahIbFUT+Orri/0iBwCPJeu03k1+B50p+j5Gb+Ir2y
         MHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774355570; x=1774960370;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFSY807vxOyGgTezoYLzQbN/077d0T02CNYv84Cish4=;
        b=Klkwv7Y3WbhKJb/DcyXfXowH0qaOJYdU/FJ2VYsYSs5nO1nKdyy4UbWYPmzk9I1ipv
         2oRWVp0YYFkRYTAM2HHOdMTAdr5Fhb9fXrnENOdf3LwqDcVYdTTCcGqNcmHpobFRWXJW
         KGJxQJ81ZsxoHMzJcSCnBS2+JLv026wy9MLfXEkwAJRChE5HdBr548Z/LFjVIgs6eJBs
         xhgrxlaM7fRgjXxBr+V0SwQ5FjE54ZAAPkh7yo5lkBj1krh6yEPGdpUwvfwW7geyVShD
         FBb2pbQmJLQqWrP59dbkE5zMKNnZ5Ia50vuCN9o0LJgHOodZKNLBbpKtK3wtEtTwhz5T
         ldnA==
X-Gm-Message-State: AOJu0Yw+ySTt08r4nwaoiZcG2HokuGcYGcGQP9JU7eDaCjH1SJBrNxf4
	SlZzFxNaYEI2yeTfws020bWdTEGc8tfEQTrhb02OGfSHoMC6OBNI02lCUhimV2OAkjb8AydmFOK
	ILfqZiJcvTxLtEUk+M5tf2A5/rhKr3VEey7YBJusduleUdAFIB+xji68YpJniyn80
X-Gm-Gg: ATEYQzyILJxwLa12Ub9Cy0n8BgJzs07152iCbke87XmcwWBJ0L2ezaYpwo4SpiYnXKS
	dFjNQhmybErb/3lp0gL0wN9e905ooi22Kz6Hz2FRnY/tSRiPmFla6qddOz95QHFHANDMimfHAuD
	1nRMib/fUxWidlrXoMWEpcr3WhzQBfQ5zzNxi3/4mwQ6mwinqH8vIk6Lc7acEj/47VhUh9cpZaI
	qFBhn+CKl5Lcewj53rci5mkR7MLNo7dcBlhiIQZnBPid3BZUK2vWS+IKMmOiw6rvE2ulR9DBfRP
	XVysgY2DQ6uci/XDDG7T6YNst4dyQGB5IVp1NRCrhiW5fN2u2PiQfsqjbno5JuV3i5c4z1N9oq7
	w4W7Spu1CFuTvCyxDr0la6NJfUEigJhaLUK0sm8YQOQb6luAhabvljN4O/hnFOjkIecbYZMCNYt
	9oJIUTr1VpnUg=
X-Received: by 2002:a17:903:b0e:b0:2b0:4b3a:9b49 with SMTP id d9443c01a7336-2b082820d55mr143990435ad.51.1774355569551;
        Tue, 24 Mar 2026 05:32:49 -0700 (PDT)
X-Received: by 2002:a17:903:b0e:b0:2b0:4b3a:9b49 with SMTP id d9443c01a7336-2b082820d55mr143990185ad.51.1774355569032;
        Tue, 24 Mar 2026 05:32:49 -0700 (PDT)
Received: from [10.133.33.145] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0af3008eesm1053265ad.67.2026.03.24.05.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 05:32:48 -0700 (PDT)
Message-ID: <3913b65a-85da-4951-a3a1-1316f4e9e9bd@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 20:32:39 +0800
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
 <1a038159-c847-4e58-a60c-cd5ecabeeed9@oss.qualcomm.com>
 <67dbc2869e68a29d5eed452f0db74acd2021c3e3.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <67dbc2869e68a29d5eed452f0db74acd2021c3e3.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=b+q/I9Gx c=1 sm=1 tr=0 ts=69c28472 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: onOIasCndBeYNtFMcxp5X1mEQngyBhHW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA5OSBTYWx0ZWRfXykChrOOw5qo2
 vMP2qMui2ysBure4nJR+YPcVJ3QDQTC3dkXOcFcql3vhZz7sIQtd4New37mW8ophdpS85EK9Jv5
 ySBZE0Z2lyAdKth/twoAvRkHKDh4eicgGe5iMMW663Hswrd+IkcXlSad5f3MW+DC/TgMLBC9jL9
 ygPJZ3CoMRzvp+0FIhsJaDm1vGGn/PmzFsGduPYqn5f53Yq273+9VxHmki48ICevReS+IoWhMXu
 961rkVirvoznVdzw2TNIZoHGsTQ1lIZq3cRCt5H7r5PiVSuH7AeXIw/BYHZbdmzBbznHEn9qNM2
 aeVxXAKDlH/JluFnf+yJ+d7I5dT6IE3TgdTeNky5fHG4ZM1diaV23ldBFw/PQQsO5moDjr2oX2Z
 v+3yrpkqdGICz8oA506WMaJZ3VnqIalMB+JG/MVfT+quwQ/hTtw30irwRotRoeHb8CD2AQmxYY0
 0fg3oH5bSceHnH/0GfA==
X-Proofpoint-GUID: onOIasCndBeYNtFMcxp5X1mEQngyBhHW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603240099



On 3/24/2026 7:54 PM, Peter Wang (王信友) wrote:
>
> On Tue, 2026-03-24 at 18:09 +0800, Can Guo wrote:
> > > > +       params = &hba->tx_eq_params[gear - 1];
> > > > +
> > > > +       if (gear < UFS_HS_G1 || gear > UFS_HS_GEAR_MAX) {
> > > > +               dev_err(hba->dev, "Invalid HS-Gear (%u) for TX
> > > > Equalization\n",
> > > > +                       gear);
> > > > +               return -EINVAL;
> > > > +       } else if (gear < adaptive_txeq_gear) {
> > > > +               return 0;
> > > > +       }
> > > > 
> > > 
> > > "gear" should be checked before use?
> > I don't understand this comment.
> > 
>
> Hi Can,
>
> I mean that gear is used here:
> params = &hba->tx_eq_params[gear - 1];
> If gear is 0, it could be dangerous if params is used.
>
> Therefore, we should move this line after the following check:
> if (gear < UFS_HS_G1 || gear > UFS_HS_GEAR_MAX) {
>     ...
> }
You are right...
Let me address it in next version.

Thanks,
Can Guo.
>
> Thanks.
> Peter
>
>
> ************* MEDIATEK Confidentiality Notice ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

