Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B3749550A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372826; cv=none; b=i3y5rqzkH0ME2Sby+DBnb308+qPTEK1frUlIbZTHCEsOHZ5Gv3WVESZ1N7U8FPMplx2Hi/0dD0iqGPQEnQ6rzFowNuK8sBEV/GvRgKO2UrkMk05UsiL/yVT+wwW9xR0tLiI9PibSr9vLruDICKC8zONRWO3/m17FduL2nd5PL/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372826; c=relaxed/simple;
	bh=dJRew0RCqMZrsYX/336mtM66FOjge+oEkiH4dzIm7gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mwD8HoeV1Cu+v8wIIVivzOK6ek4RmJehXm3g0f4JGjTHj+CdpBzGZUiqbQLdCpim5Wfp0uJoRVNbH1gMdggwh4drEN5a0HQzfXT//9n152SXbPB7Ctx+O/RAGPhjHM0ayjg2PPfGHbE6d0Tb1Lxaor6B61/F4PTSBFAoUC4MNtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bIPME/+y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J4QBIZQ+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bIPME/+y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J4QBIZQ+"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BV8sx3821198
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 11:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rnRfrie7kW8dU2T1uAcEvLq8NNMvKQJZG3o5AFfDelU=; b=bIPME/+yaFa5Wgzk
	TUcNEiMvX+kYVG1Ym02c7L5TxxWdyXt6yXweG3dSfvGbt360GtTNOoFu6Y1UJc5B
	co4tADcrkp6gJAf0d2Yo7u6nVm0uXNGYeE1rn22g9IGpq3rUD/aDAJhnQuIoDU4G
	s6dJDANvoLDtJBJtx2eSmCWQDl1onJlMlCkN7IKhzP+t6g9osbAAhB3/a0O2og4b
	2bdgXQkd09fsLdlhHkP1b+9YT7Jecqxk/s3oiE/24jzh6zNs4gvk2bNznFd0u/qj
	uiKvVDXciTyJ4BcjJMCZG6QFDUYD28MktAf/VNWvtUGrJOyGvGy/uUt2kCKW2lOr
	FrGptw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h54623tcu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 11:33:14 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-868db1b2c64so3363849b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 04:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791372794; x=1791977594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnRfrie7kW8dU2T1uAcEvLq8NNMvKQJZG3o5AFfDelU=;
        b=J4QBIZQ+2Lt4hRxL05gK0bsu9/XFTaDz0ofeY6t/0u0EeI57xUPwYT0SmZMN5OOYMx
         /8gcTZFPRqUOep8HnxeTzA+VjxyuGSdxm7Gtv3pTpomJHJACyA70YHfx/Tcgu+hCUXW+
         b1Q86qigjCUeBRDzX8XiOYLYgcFhTZ1t9vi+lL2m1p8LISopOC+adCpcrMMPkfTzjesL
         gDTg1yyTDOR9cg5RCLfQ+nKSgrELxHCoPdL+afd0Oq8FcT/6BIQPk9SGJ2LAWPizAY/k
         9doJ3C3V9mXSOBcuWvxaQuDdrH3z6pimbzqIA4JmsEqPxX/HVQQo6TTfdNKvRTbKLeSf
         0eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791372794; x=1791977594;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rnRfrie7kW8dU2T1uAcEvLq8NNMvKQJZG3o5AFfDelU=;
        b=PEBovK3rWv3Zq4JWdIUrN1VlQc1rHM1kp4xnNEIK5mi8tSmIeiBrapEtRbCGEZ9el4
         dM3Ht3k0Mf4boej3nVXwehtB63VvsvPmJZLjlvxF5OnrystYJOEJsAeAsToTTIMuI3jV
         HVgv5HYTwMSV+DK92VYRztjyG0sFIEid6in6G3aRwfcHU6TYJ6ALOb+uY18lJQu9HKIQ
         JCBTo+PN/aaHJEgTt8UrhDLB+BCEX3VOjeiz3D60Aavdbpm/cMmSXeNX/aCCEJx8iWCd
         izEzVcM7FRvwu1whL8wgoqSeDNLIM6jaLpj/gGaohVRf+IhDXmQ+dISF6hUtRcwsdOI8
         yFkg==
X-Forwarded-Encrypted: i=1; AKwUvBxb4+9/j9aVG4KX9FS42dDu0lX6IU5FLbRNvDlJCGxrVUCSdcuuRzCTViXnlB4qtsJg152Ewp/hOtM8@vger.kernel.org
X-Gm-Message-State: AFuF++lruCxFnKB3C/e3Xgp7I4JBOK64nJ315lqf09btwd5FseC0syie
	7q9d5y+74UV1r/sRHzSYMRCwaMDRJ0cfWxWxqkVZPnrV5Sas2mNnUHAUmWhfUHtRQEEF5XqbqzV
	WPTwwr7Vf61a0sMy+KDeDGMzbeFioTKQ8GDJb5L+pw4tMVtJ7XSwO+Js1467yNuG/
X-Gm-Gg: AYBFou19Rr0SRbQujtGtTRr3qw67tkCZjRZFsY0dn/sAJMdOERIN77jvQLAJmMEgHbJ
	SPwE7XaRIeOK3VQ/g6VZhp/qseXalPlDMeDfv6wBduZaNo4r5V5MRb7YTiyq9domJANW3+m1e0h
	GUyDRbFV4sKHppSPAgApv+x4bIWvPXziw1UeV4E+D0l02Rgg2FqXDJJsB8s79skLvUeKo3fdj8O
	PXLaHgWeKqv8loy0GdiE3J/cOOAveuuSgouWy5jCIJt6Cbpa5D+6gnrTObKmPvNQXsHs+uqAfXQ
	IFBXp+Q8mTyvebUwpx4dwA3OuTrSoS2rmgeIu7BGTMDfU+zo2S6z7lRc5+PlTNrN2Ci/ySjRm7x
	Dy5BEfd6x8kwSVWu3UENyXueXrsjmKpVMcrOfog==
X-Received: by 2002:a05:6a00:2188:b0:882:6d80:e5ad with SMTP id d2e1a72fcca58-891b0c83960mr1586032b3a.9.1791372793111;
        Wed, 07 Oct 2026 04:33:13 -0700 (PDT)
X-Received: by 2002:a05:6a00:2188:b0:882:6d80:e5ad with SMTP id d2e1a72fcca58-891b0c83960mr1586011b3a.9.1791372792597;
        Wed, 07 Oct 2026 04:33:12 -0700 (PDT)
Received: from [10.218.41.37] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89188914299sm1203497b3a.15.2026.10.07.04.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:33:12 -0700 (PDT)
Message-ID: <f9c7bd4a-2e97-43e1-a9bf-295b841ef0a3@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:03:02 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] phy: qcom-qmp-ufs: Add Glymur support
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong
 <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com,
        Taniya Das <taniya.das@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-5-84cf4f861415@oss.qualcomm.com>
 <zovl7lrhlleflaewk32o4wofr4bzm2bmkdnakev47peijrnkfe@p3ixrxltdpcm>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <zovl7lrhlleflaewk32o4wofr4bzm2bmkdnakev47peijrnkfe@p3ixrxltdpcm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: pORTs0V4mk23YyJSd1F2h_3ryeShy0Fb
X-Authority-Analysis: v=2.4 cv=ZZiIpcVA c=1 sm=1 tr=0 ts=6ac62dfa cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=FIX8ga0CBHvb0ZQaSzQA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NSBTYWx0ZWRfX55QJ6vxe/CqP
 d38eERJ3vAi9BlaI2SMa9QCxDKwPIGLF03TV+uLqnjuqHiZGY2y7W45dprTW96+tM8MNRUc1tyZ
 si9Ir0mobRkA2ROXRhcusP5C/+ypC64=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NSBTYWx0ZWRfXzHcabIPk4Za6
 kU/5Maiy/UBL94jupuHhUYP3vSHTkkcEuGC3yx+XIq4H0FmEkBJq4jDTufGt+ZKHrhTV26sBQPv
 W73rdKUErQrJNHgN559hHQdYjod5CsIxNoe1xNc+Ndt6+5BRm3NhfCvP3s8WNdhL24HF6cLGL0T
 tjfiL9yD/SGYVnZL4oZAZlWmaU57PeBE9GwlIurFX4wQGTxfn7T3hn2+6rQ9gnhv/IwxpMNvy1N
 bVIggRzV7auqGu1dn5VTDpzpiocoFvbfz3MEgBxJ7ZyWw7TGE0D2z47p7XV7DDtNa8a6eMIutk+
 xahOoA2dLqVPPVp8sAScRzWsFeqgIhErB+E5ukFo2NahbaHSrYC5wM4JeTB74cXPXyW3KiHyihL
 s8tAMCKToQZZRCq5b7Ri1/vscNnaaEl6VWfy3aCvk2Dn9UgYYg5xOnZ4xQGIS4I9V0PVJdlStHC
 CMzVyGODl2bsne7De0g==
X-Proofpoint-ORIG-GUID: pORTs0V4mk23YyJSd1F2h_3ryeShy0Fb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070045



On 10/7/2026 1:18 PM, Dmitry Baryshkov wrote:
> On Wed, Oct 07, 2026 at 11:59:38AM +0530, Pradeep P V K wrote:
>> Add the init sequence tables and config for the UFS QMP phy found in
>> the Glymur SoC.
>>
>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
>>  1 file changed, 99 insertions(+)
>>
>> +	.offsets		= &qmp_ufs_offsets_v6,
> 
> So, is it a PHY using v6 offsets, but v7 registers inside?
> 
The QSERDES RX0 register offsets on Glymur SoC are aligned with the v7 register layout offsets.
Therefore, the v7 QSERDES RX0 register offsets are used for Glymur (similar to SM8750).

>> +	.max_supported_gear	= UFS_HS_G5,
>> +
>> +	.vreg_list		= glymur_ufsphy_vreg_l,
>> +	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
>> +	.regs			= ufsphy_v6_regs_layout,
> 
> v7
> 
>> +};
>> +
>>  static const struct qmp_phy_cfg milos_ufsphy_cfg = {
>>  	.lanes			= 2,
>>  
> 

