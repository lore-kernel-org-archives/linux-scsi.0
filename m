Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE32B9B7
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 09:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773480807; cv=none; b=ox0wXqAIKnUiIOJylvgPX244dy3JTsYFjczKtOLvZPtf8XYJLuTHaWL5+yVYe6MfELKAsLFurxqJaA3QS74WhxHTgPw0TG8z80ibZ2vTsPnBjCJ/MlI3RobE+FlPrrL0+IvEHYtjzvagW6CnEk7XmPPVhsLp0SFyD+IRVWsXtVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773480807; c=relaxed/simple;
	bh=ib8seA0g2PtzjPipXOSyi0qCKs3NiqTO75CZZBotfmw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ge093npEfhYzNym5HCNjwZD0XmpEy1MQlPRrBy6BjIKwUrACJSIEibmgk5+sYNRXFp66cxCf3cWuJxR6KC/zPJl34uiTfujADk2/8g9Efp5dyjs6G6jbAVNEApp7Sgtu2NPozWQJEH5ifRqAudR10ShqAsCnIEw40gl0KgDKBOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YN/a4jXN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DrM/WRPr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YN/a4jXN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DrM/WRPr"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E3nQb4677275
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 09:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yaMwFAS+Gg2koBcg2Kz91VQgclbp+hdxDTu4+qgo8Mw=; b=YN/a4jXNBd0+GpZy
	sU4h1QLhTkEGoUS0AM8czhOulw/nNl4pqwpNAWSm531fhgyve7t5PZK8JYvUZicj
	Ni8jBi9GauWeLDfQle+nShoKB/y7LIpT5f8Qk59XtfZ/cmqitIgnDXZKeQzgLbIA
	TECzFmoDdr7O1IZjq3FA8psW3nca+JTwWP52H9iv2sLsl4r1r9QcZcWco4CB4I5Z
	bnfwWAqRXqctFfrgG9RU7sfrNnWLFNQZIDr6xb0QZK7Rwq7vOGozODnHFugzJp7B
	dw3hHSZGqgxHYOOdpnqDiqJOt4wEDXnsIk/3bC6xsNfIc9xquRXmVvOtzB/M6gn0
	9cFkYg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw03xggpv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 09:33:18 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35641c14663so3327368a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 02:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773480798; x=1774085598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yaMwFAS+Gg2koBcg2Kz91VQgclbp+hdxDTu4+qgo8Mw=;
        b=DrM/WRPr4eUSs8E/ZdUevS5oF4/qic50sqKCaSrr9QIJwICO13B4ehMiJ6shScvxcs
         o43BCl5S4TF9a5yGffWNCLQD5YXZxQzF5iBXi2//58Rqze83AA8k71vzG5FU8aUUkGSW
         w8ZxG2fQAhXBqnqbwrnztiQhugAjdzg9KFN3UAQeXPFvaPL5FiHNJZOjmtFG4iWL16Cm
         lMEz2Prxxr6VcjMymX8os/FCgP/Iv0fyWTfWGv76kJB8RpHM3JyCaAixS2J0reFqtZfU
         NqKA/mw0e63aUlfIdercjv9lhjxCj9/x27kOR1RKtkKB2Ykp6qPCFsA0hd16pYNa8war
         sjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773480798; x=1774085598;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yaMwFAS+Gg2koBcg2Kz91VQgclbp+hdxDTu4+qgo8Mw=;
        b=jYJukUjBXLrg+4oJLh6N9XsNn7ZX53U07SdsOuaoONjEuE+tRz51EpkX8XJRxOOCDk
         RW616Qr5uxFKnHDQDLfuFffHf3utEt6okuroxfgJfTmwn8FX3pSjNhfSlc41uAqOQc/D
         I/AhR6UGIZ2cWSivE2H2W3Dk75OEquF2eFdIZAFJZDWi1NmNlky/UcugVWdtbiGwNzYC
         +zZD/MKyOpuBic8rzpitm6or9mOj9krVrnxUVnUozzW5p1IzM01QSfguy1XW4DqqQ/HY
         4N2r6bBrFRMwjK4tp3F3hFGqC5thk4HQ+M2KqiTeYdCOYM7lKx/FzB2fRMBXm93N8X/C
         Z68Q==
X-Gm-Message-State: AOJu0YwGz2w9oF0NbbShtq73MFCFjsjd96S0JKDe3DX6eiYjp6WBzx3i
	BYzHu2O3fMC36P0f+Z8BAf1ZTxJJLgMTXO+vgb6uSwfF4dEX06thNwIlr4wLAY+JA6bLMwwVnIJ
	aXYOSofFU2JHt7FOX9jc6ljSEJ7a2fu3pqZKMb+Km5WanORGQXx4cenB1j8klaPnl
X-Gm-Gg: ATEYQzynUibYDIQyJ3kJ0xvBdRNLs1NFUogd38uCcCQbDuz8sDhWh0MKGlt7LyzUA0d
	dSUm+xj5liG1Fe9ne2DZAjO8VUTYMWQVvVok3CSBknpU3SLMnn7/g630pE4+/RkK1+AlSvIiS1t
	x6WZWBynov+dtYDyYlm5wMQkKTqbkpS6r8Kzo3nL669kLp/Lx6/7UaVWwbcbd1dF69rkQBPG0z/
	VI5bLKhvXYJJBWQuPdyWm1B2JBqW0XvPST5tejfwbmz/XdmKDlcUfKALRCiin5xMJnaDs6dTLZy
	NywoC47lcmaBIHK6/WsIeqfLAZbiDAxmyRsrrrZGN43Aw2QJebK7SuSyzSurGzpE20c8I+lE8pd
	QYVHNeH3VuKluSTnxxALkMN7lRjQ73/FUg3WU1Etb2KWRvxtHndbnTNY0OtNGfTEw06WlbYXysM
	Bgaj6Rp+c3qQ==
X-Received: by 2002:a17:90b:4c4c:b0:359:8f7e:d34a with SMTP id 98e67ed59e1d1-35a21e4650bmr6181555a91.9.1773480797959;
        Sat, 14 Mar 2026 02:33:17 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4c:b0:359:8f7e:d34a with SMTP id 98e67ed59e1d1-35a21e4650bmr6181528a91.9.1773480797493;
        Sat, 14 Mar 2026 02:33:17 -0700 (PDT)
Received: from [10.133.33.24] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a1c34fa3esm6955088a91.4.2026.03.14.02.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 02:33:17 -0700 (PDT)
Message-ID: <6e07208c-a94b-44dc-8f7e-ccbb0ff8840e@oss.qualcomm.com>
Date: Sat, 14 Mar 2026 17:33:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
From: Can Guo <can.guo@oss.qualcomm.com>
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <c44cc56f-513e-457b-96de-203d4b534496@acm.org>
 <f88d9fc6-4227-4cd3-a124-0e93122e1d85@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <f88d9fc6-4227-4cd3-a124-0e93122e1d85@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDA3MyBTYWx0ZWRfX7zjgdJ/XlVHE
 2crOsEB7i2iI+DTfk75x0w2Rt/+xicaaX6NKKf4+ntztM+4HkLBcxhaQzrxL3iecaUXlb5pmskG
 Et4AbQKjYg3pJbNN+d55Zuk5odA8dGeyMuTN7wtZDtgQDP7nqtQRdzO7ptCJDcb4YrQMm8elT3C
 q7TYgIKseJrvvnGxnbTh7Qa4ZUXvdGmambbDAKTFZ/ezzAUbsY4ioX8DdEEoUB1rVFqnqDqXhbx
 B0yfcDojJcwuv6vCbHzfpNKEElRW+bkVaOF5fc/G69a1tFiBgrvFSS1u1JfNboATyh+r6FFAvwb
 L/eETJfaiYZCcig2Hp092txR83O70tscdAxlDvgewfP/cvPIfp65KpR3NvoZ6V44HKQmMg6VpkN
 X2ZFN97b6PQx770iE+fRSsksHx9mysrVEOOPMEm5zBngetxJqPFdX3CUrN7Hm0iTaC4n/BOJ22E
 6qoJ8+DAWtYC3dSFxZQ==
X-Authority-Analysis: v=2.4 cv=YLOSCBGx c=1 sm=1 tr=0 ts=69b52b5e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=3GuXBLcyPA-KnW9U8h4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: dhrpCQEQ4WoKu-uU8k0wnRxMI-XBCnHs
X-Proofpoint-GUID: dhrpCQEQ4WoKu-uU8k0wnRxMI-XBCnHs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-14_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603140073



On 3/14/2026 4:19 PM, Can Guo wrote:
>
>
> On 3/14/2026 6:19 AM, Bart Van Assche wrote:
>> On 3/8/26 8:14 AM, Can Guo wrote:
>>> +static int txeq_gear_set(const char *val, const struct kernel_param 
>>> *kp)
>>> +{
>>> +    return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
>>> +}
>>
>> Why UFS_HS_G6 instead of UFS_HS_GEAR_MAX?
> I will use 'UFS_HS_GEAR_MAX - 1' in next version.
On second thought, to make the code more readable and scalable, I will 
use UFS_HS_GEAR_MAX
here. To achieve so, I am going to tweak the code like below:

enum ufs_hs_gear_tag {
         UFS_HS_DONT_CHANGE,     /* Don't change Gear */
         UFS_HS_G1,              /* HS Gear 1 (default for reset) */
         UFS_HS_G2,              /* HS Gear 2 */
         UFS_HS_G3,              /* HS Gear 3 */
         UFS_HS_G4,              /* HS Gear 4 */
         UFS_HS_G5,              /* HS Gear 5 */
+      UFS_HS_G6,              /* HS Gear 6 */
+      UFS_HS_GEAR_MAX_INVALID,
};
+
+ #define UFS_HS_GEAR_MAX         UFS_HS_GEAR_MAX_INVALID - 1

Thanks,
Can Guo.
>>
>>> @@ -955,6 +1045,11 @@ enum ufshcd_mcq_opr {
>>> + * @host_preshoot_cap: host TX PreShoot capability
>>> + * @host_deemphasis_cap: host TX DeEmphasis capability
>>> + * @device_preshoot_cap: device TX PreShoot capability
>>> + * @device_deemphasis_cap: device TX DeEmphasis capability
>>
>> Please either explain the meaning of the bits in the above four new
>> member variables or add a reference to the standard that defines the
>> meaning of the bits in these member variables.
> OK.
>>
>>> +#define UFS_HS_RATE_STRING(rate) \
>>> +    ((rate) == PA_HS_MODE_A ? "A" : \
>>> +     (rate) == PA_HS_MODE_B ? "B" : \
>>> +     "Unknown")
>>
>> Why a #define instead of an inline function? Aren't inline functions
>> preferred over preprocessor macros?
> Let me change to inline function in next version.
>
> Thanks,
> Can Guo.
>>
>> Thanks,
>>
>> Bart.
>

