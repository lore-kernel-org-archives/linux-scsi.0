Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F82033FE36
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 09:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780911188; cv=none; b=N07CmJNTcjsqOdP4JmsqZAzQ64rE/ebUHuSSlHWTcc8XvtkpS+dDIDl2wrfGnao9wEPqR90FmPbQuxjYM4WBdyuKZds8NtFh/14jJlNx7p8nme0qH5nzsVOL0KS5X90Noe6tmpQZlyVo7fGCOPszteHeZCnvNe7/7qz/S6b2U1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780911188; c=relaxed/simple;
	bh=2mKuoNeczjYmLgNRJsQsMc3RGm1bt+Gt8+Odq/otNCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=knzgxgdx/baSBlRfZTlw2wGKTKXYeGQytO/kiMeGN8o0ROulcsQp763sFHmCBipp6dHUqdCBrUng/vEEF7WJ4liDgjdk8pxLIvR0LctHT35+33PNkkEVMoKI6dJ/tZAQf2NpaoUQWm36sq6a0+JS9qOv9eKzkGxgW8poZF0TRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h/FSNtbJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FGscSEv8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h/FSNtbJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FGscSEv8"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6586P2Di2802607
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2026 09:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BZtl15ww4PXc5flceKtv+LPJ3x3xJtHYHA2F+jHkfLs=; b=h/FSNtbJsjoVXbt3
	Dzkg8y6u7GxupvGXgs6sS15rhtrQ0p+i5A5xECXxovdmyBJ7wM7Mt3PssJUTDBd+
	oKlhiMTLfRtoDJ+aH8hikFv/vSrYGv2bXmHtUoPrehanPTGRURwM9VTIWkatXphQ
	o0pjmL/OxuTKvGGBHZVgoIaa6/azJVPYX5oKg5yDQSVEZUMozGJdiPkMO2mnDZja
	DACEu20q+2LIodR+KJmVY27DtY3s2az4ifNYtUbqUSFtCDqZGwhSte3QfOrv5PY0
	Sa7XHgbYuRbK7Dw3lOa8UMRYHU+PDAFv8o+pwe8Ra7Q8+j+K4Pmi20LD0ZvGOuYl
	VYyHyQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4em9k3qgqc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 09:33:06 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-517741bcc53so11288361cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 02:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780911186; x=1781515986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZtl15ww4PXc5flceKtv+LPJ3x3xJtHYHA2F+jHkfLs=;
        b=FGscSEv8H22tjO+kkZH1qKapc2mgkhFgP0Co0YwXLiIC69JD71o2kCy/ua9p4sZegy
         SMHmbNhLJi87/Jpzu6zp74Cu24WxVgkK8mr6QW3xIEV4WQ853VRwJM+TkMlV4ZvuFIBT
         3z6ibdL7WIZ9+F8AluOyprZHjnzFN+eHfPrgXVdxZaPvX01fsuNrqv9IpR0u0RaK0XG7
         xno3PYsfendRlyy4WVvgKRTJiZI2x2VzPjjgZo6llxfO8eyhT9dtMMsuOYV/W53N4BVb
         WdPLDdFRRI5zJ046uiSvyGr8uvKu9pCaOzdLAMirXesyc8BabV3FHibNmOPbeqJnDHHD
         YcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780911186; x=1781515986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZtl15ww4PXc5flceKtv+LPJ3x3xJtHYHA2F+jHkfLs=;
        b=cTX/ddsxD7xgi5vEqiG98ObknzmbdC8W7wKvd8R8+DjKxZyIyn9dVTk0H/5VwXZIBn
         Ko6ZgIKuFk4UkYH4xsu5ofDHR3ZWMg+F6AOmAQuG9NQypm5n7hA8+aKzMRWjWPA4qrAj
         EDVC3+jj/rYe/XoOzvZupE7mAJHlJx1zWuOY3kM2Twm1S7wk0/64LK1UXvlRLGYPgxgs
         RkV475pfrBFCCBUc7B3FgbUevJH5WBOn/QvWDyvAs3tivAc3Rk8lvZHBt69hZSTajRU+
         qySJO18OFKdMWo2p6M+YE7RSi1goc9HrmfDaXqbzNCLWaf4wVPVBbI0X2JMbUgJpKwAQ
         xw4g==
X-Gm-Message-State: AOJu0Yyydgc2H4aelkULI4IyJj+Pri+2xRpvrv2bacrByEgNssqQfVDq
	bMs8JA9L1zmfvpOLMDBU9hNGWBZ+sRkFwFSkeyo8Vcj/R45zN3BC1Bk5Qkai+TCnofugXA6wdnb
	KjDyiDR+ADEOvjlpFNWRtpZxcz1PNVrtAmu/RzdHHA5uQdpHrWqpwsVRuB406l2NT
X-Gm-Gg: Acq92OHcrpUOGQp7xGmqfVZALJgSR8Y+hOiO0HI5GSSYPpjsyhJZTYIMNHzgC3Ebuf1
	MLSeOh8t87/yAsLVDCYltrYIhL3I4Jp1ifeC/QhUKJPxkgBTkg46nC7RwCCg11y/RTnWQSIaMDS
	81pRo0Ig8EmvrvIh/XuiXlZQNr4HYVmEoUz1p/CHcTHdEKD/bX33UWGodNzi9JGSo5lLmv3cuv2
	J0r7vb/nqYUDi8IgSuTYjTnMtp1YDohbslGPY2qm+BEC5Qm9xJ5bk9lQM7H9QtnYyw3CbQdKMO9
	ubESqQV45muVGEm+P4ueNY56fbk68AbiO+EkJG4fnRNYYGJthVh+F4o5IniayLHBumBeE+7k760
	gLSjTLNDAJ2B1LB9TGVvA7XrgoKnlG2ZHfJ5ah6WcuewdaBt0F/Egh5bT
X-Received: by 2002:a05:622a:58cf:b0:50f:bea5:52a with SMTP id d75a77b69052e-517958e7faemr125040521cf.0.1780911185731;
        Mon, 08 Jun 2026 02:33:05 -0700 (PDT)
X-Received: by 2002:a05:622a:58cf:b0:50f:bea5:52a with SMTP id d75a77b69052e-517958e7faemr125040321cf.0.1780911185313;
        Mon, 08 Jun 2026 02:33:05 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05176fd07sm852062466b.1.2026.06.08.02.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 02:33:04 -0700 (PDT)
Message-ID: <c7036b15-853b-445c-87ae-f9ff06ede326@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 11:33:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] scsi: ufs: core: Add
 UFSHCD_QUIRK_SKIP_DEVICE_RESET quirk
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20260531235011.1052706-1-nitin.rawat@oss.qualcomm.com>
 <20260531235011.1052706-2-nitin.rawat@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260531235011.1052706-2-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA4OSBTYWx0ZWRfX/wmrBrG1pn4U
 PUwBC4QnhY5a/4AUtYzpORHvWAHCMurWO87PVX1I3/dof/yF05C2fSNWH2b+8JTdx0u7DLjtdEi
 6mQJMjqbLZUbUNaHczRCY2lrISl28hwuCViDu4ds/pdQI8LIRq5cTvdBegsjFpXNNHgtzluB6UP
 8ZFKly6mGZ2aG0stgNtrTe1zTkgGFhTs0us0iRbd84OtY7+q1qq+nYeXqDjW9AR9Ax69Mcq0p7U
 1VszbIMIJXqgUT0aOrF9vDZiJADqdz2Dx8cEpFZ4IL359d36mdEo0iAlTMWh0AXTOLEOrcPBgja
 Ak3xtlp5iLKg+UjsQQktD/lKkDzzgrXcN6PpZpFaF3yNz3omtHoHhpoUWc5FeiNS4Q7uRhx/xpk
 OLPMJJ2lrm4kpT7yJ/s6YxZMSTYD+35NCUqxviXaJQ0JBI/lgCXFmDp/KuG13s2ZRYk4XIyF1UQ
 0BQWNFY77jKbQl1Tzyw==
X-Proofpoint-ORIG-GUID: QfEjBNaJNK5hSAUDej_8RzUl0DZWu4KE
X-Proofpoint-GUID: QfEjBNaJNK5hSAUDej_8RzUl0DZWu4KE
X-Authority-Analysis: v=2.4 cv=TIB1jVla c=1 sm=1 tr=0 ts=6a268c52 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Am--5WPmF5lAGn9LL3QA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080089

On 6/1/26 1:50 AM, Nitin Rawat wrote:
> Add a new host quirk UFSHCD_QUIRK_SKIP_DEVICE_RESET to allow host
> controller drivers to skip asserting device reset during UFS power
> down.
> 
> When RST_N is asserted, the UFS device firmware wakes up and executes
> its internal reset routine. This routine initializes multiple hardware
> blocks and causing the device to draw a large curreny during this time.
> If the power rail transitions to LPM (Low Power Mode) while the device
> is still drawing this elevated current, it may trigger an
> OCP (Over Current Protection) fault in the regulator.
> 
> For some UFS devices (e.g., Micron), the elevated current draw persists
> until the reset line is deasserted, making a fixed delay insufficient
> to prevent OCP. This quirk allows such devices to skip device reset
> during UFS power down. The device reset will instead be asserted as
> part of the platform shutdown sequence.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  include/ufs/ufshcd.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 3eaae082329c..18d634499ce5 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -813,6 +813,20 @@ enum ufshcd_quirks {
>  	 * allowed by M-PHY spec ver 6.0.
>  	 */
>  	UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3	= 1 << 28,
> +
> +	/*
> +	 * Some UFS devices keep drawing larger current after reset is
> +	 * asserted until it is deasserted. Asserting device reset
> +	 * during UFS power down causes the device firmware to wake up and
> +	 * execute its reset routine, drawing current beyond the permissible
> +	 * limit for low-power mode (LPM). This may trigger an OCP fault on

Is that UFS-LPM, or Qualcomm-regulator-LPM?

Konrad


> +	 * the regulator supplying power to UFS.
> +	 *
> +	 * Enable this quirk to skip asserting device reset during UFS power
> +	 * down. This is handled only in shutdown; the device reset will be
> +	 * asserted as part of the platform shutdown sequence.
> +	 */
> +	UFSHCD_QUIRK_SKIP_DEVICE_RESET			= 1 << 29,
>  };
> 
>  enum ufshcd_caps {
> --
> 2.34.1
> 
> 
