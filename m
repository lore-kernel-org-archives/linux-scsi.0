Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D99B37C90E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776922245; cv=none; b=dhRIAwc4YIzsRgPR8ni2mjDbKth0sH04z8TReKixthlpKoGcKzGmwiR3f/5cpOz6jt6JrZcsvPL4YB9+EDq9Ts3ron37l0PimKTEB8ZhSDuCnCe8bHKGle+xc1jtvo/uuti5CiUH4Gm+FPknqasDoAS9XtcDOOlLVeVXNAVnao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776922245; c=relaxed/simple;
	bh=I4l6lrJuTWGwYQ2DlWkBIgtDbAdtX0mad5D97+OmYL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qT3oLFw6n+ud6G3UVgiPHOdo2TYQ1LVNM5CcREDJ1JcfMi4rNOi6eNONGEFXZ/5Mg7lJ6QsgPgBhDuNFqgf4zGuo4vMTknVmOAZJV8tYhQzW4LkFeWnu6jxrII5UM4yhNiqT1Em+76IazLYaQT2tygSHMBzvQEDN30BOaQpNcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EvXS2y1z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bqGscQjW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EvXS2y1z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bqGscQjW"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N3GUBC2012272
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2ZD+sN3/yewzLhFBfVPxHnkHX+734akBFjIOW5kZJLE=; b=EvXS2y1zryBn9Lyt
	OlTb+dAcdW/sq+D2+QTKxrHpTVftDPXlpVSv2/A7qUh3eNHbxnou50wCmOeto/Rj
	ilDQ6AEtKhQg2mUvBfAXiChBRlgomh6PyadvlJQafmuSnSPvD7XN/hNqpa7hlsLk
	NbgpddBywkBp1tNJFap+V83AZggphemulC3ZXYr+zk8hqXOwofd5LU2cf8yavplh
	NlGV31qqMxW64y71gjVb1w0KXIVz+gBbaExhD8X7Q1sazyr5R0krwh1TCufMsNGV
	JjD/t07EThO0zodWm/eqPevNcTrpUuauxOL6CjVo9kXpUIawdr3GqsQ2Lyk4nwg0
	kfOwwA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq1h7aav3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:30:42 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b2d0c1ead1so116979255ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 22:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776922242; x=1777527042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ZD+sN3/yewzLhFBfVPxHnkHX+734akBFjIOW5kZJLE=;
        b=bqGscQjWOpBpCp4HCFYQ3yCCPt9l+l5faE/LRwMVRm72k+J4/onnWMD0jf9lz9v9WZ
         9BGxGRlyorv0zKe9YJuYBJRvxQgzLvqTG384Iq+pBw9QtkGfC2P6HVEamMaHXn36lEU8
         Ey4lsnKqVetgrqhzj+5JU0Ck/KYO3dDmz4LRovbgTU0fA+m/tsUzoX79Ba8/mnAuQroQ
         SbTPOnjEaJ1tqUYuz/pJJ0PV4yJZhY46n8NHyluoMLPyVZAgbJ83c1njwHhd6yhdakrm
         QVGhBMKnM5s41upSLSXM3LvdvNueZaBb3GCXRg3rDOAAA/+7rIFCNYXHTmol97l3ojUG
         aCjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776922242; x=1777527042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZD+sN3/yewzLhFBfVPxHnkHX+734akBFjIOW5kZJLE=;
        b=ZiuFR+nKsEhbqwFERqF1WiyuhSjbQzIziT64wh9i2d18pUKKJMPOVqL+HSYInDPjnl
         T3zJO6e660va/3DoxaURtVT4qw/tvZ/1L/e/GiRbg/pjqXJzQbCpb9kYUttdYemENKac
         ZMKwoGSOaWmckx0O67lE7LbY/Q3eYe4TXIdubXgztOxKaL0TiIO4Ut5IGkazVGtP40/B
         TBS5Dejy2QIxs8AIbuKepUrLPdcj698sfPg8PrWxzWthfgGtn7q39eeIb5bkZHbL9BYO
         6IfSr2oZOFI5VAtDjVFAVoTOXEJcp7q2MKSmfleY1sqzzGFNsg+/xrr5RdgJqvKexAYQ
         a4vw==
X-Forwarded-Encrypted: i=1; AFNElJ8oyqc8mbUB8UwN4mfQSX/5CV2ssFSglylgRzVJ78tLfA5DoFzhO2e67mLJHuzV24bFXsFE6K60RU/R@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/FYOsdTWXxejxaYU+uVFJ2SdtDwLGTUEH+BB0x2QkH4iDIFjc
	eJZtnJONYlaS0yW/aWCgY/f0xub50DAFSmHBub0cGRtXFaEqBozCXJZzvgyQeJViR/hmwYza4Rk
	vtMrz/BZU4LGxCfPY7Nt+zvSdrFDG5GWf6wGdDI9tkKLYTdgLlBpkZSoNWlbuDarX
X-Gm-Gg: AeBDietElZ1CzGsbDXZLsXugeIC3VfgZx2sPE7g8hjBhBK/Gsj3xwkbL0w/uVkMor7p
	XuQEnBsNDKZx7y/56TL2Hsmbdint3eQoBv5mbywhCev05ya3uDocMk3a56ISmuWvtwQDGmVG9rt
	urx3z0ClgrCcA6si3hdqrWw3yUzfQfurKoJ4HtnKXYqQxiZ9OKo/BxeI3TX+xFseOeRXxoKoTOm
	u9gio4fhKdg4Gqg/pn3LGSREp7I07fPfVzIAy4OwUAI4J8Uj1kRqEAiA0AZS1RNJ+wcLvSyYbPQ
	Rlh0VR3+H0+oAZrfcaRnzDTFOHpoH1P280NhdYh9+hyxzz7uIcdrPSTYSgD97JFPj5iyFo8j51b
	W3EDn2cnVnzvjIW1aXlPQJQkPIHvDePpWkB1unC9UNvRK4KWlXrI/H+z2TvEgHwc=
X-Received: by 2002:a17:903:17cb:b0:2b2:67cd:9963 with SMTP id d9443c01a7336-2b5f9fd5c04mr258808605ad.38.1776922241627;
        Wed, 22 Apr 2026 22:30:41 -0700 (PDT)
X-Received: by 2002:a17:903:17cb:b0:2b2:67cd:9963 with SMTP id d9443c01a7336-2b5f9fd5c04mr258808345ad.38.1776922241035;
        Wed, 22 Apr 2026 22:30:41 -0700 (PDT)
Received: from [10.92.175.180] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3ad18sm190222575ad.71.2026.04.22.22.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 22:30:40 -0700 (PDT)
Message-ID: <e772c05b-7813-4fdf-a0f1-9ddc4502580a@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 11:00:35 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 0/2] Add post change sequence for link start notify
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        bvanassche@acm.org, nitin.rawat@oss.qualcomm.com
References: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
 <anieqjzuel6lnrjfkckalb5p7u43d73tttapif5nwkjor57bnt@k7wzwkln4bmt>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <anieqjzuel6lnrjfkckalb5p7u43d73tttapif5nwkjor57bnt@k7wzwkln4bmt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: uSeWaRcePxPeWp62Awoo7cav9ES3oDyH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA0OSBTYWx0ZWRfX24tl49tIpRsX
 P1XKz34UUYBVszUsqrg+ti6n+d+qlihRpRMr2cds2yy6F2IFRXVxpEBR/MJQWVpmrqFeH3eGHqA
 C0CMHYdmpS+IJMV30tfds0a3gI22fHCrMo6jiPqM4+tVM89n3n2LUC73OBV1dXXcoDraB3a8r8q
 dcCiDHyjJSlTW3KeFVx4dc677Wbvy3Y7dIY2conzPNz33bOkmxvJh+O+aME0Cy95FMfgyF4h8o4
 ygLM/Kun37ihcr3UCDoJIvwZgmHPrhwRjYWCGa3eR1CgndoXhXzt5neXJS4qCk1dJ7JQvccadvu
 CKIRSCSu1ecgcDVlAmW3qtgW+8Ye+T6mVG7Dgvqt9uxuLDshF2WjikkYb8cI4Tf46AAwoQ6jaud
 u0Dwuab7gfg0fD72f9Jn2EZvANUB5aYYiecw4udIxfZ+Qiw8yNhr26KaOdOodP67U41IQzjf3qS
 BKI0u1A87ASF9guSGeA==
X-Authority-Analysis: v=2.4 cv=UqNT8ewB c=1 sm=1 tr=0 ts=69e9ae82 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=_eKqZ6KB7bK8Kc-SDgkA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: uSeWaRcePxPeWp62Awoo7cav9ES3oDyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230049



On 4/22/2026 9:42 PM, Manivannan Sadhasivam wrote:
> On Wed, Apr 22, 2026 at 05:19:37PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> This patch series introduces two updates to the UFS subsystem aimed at
>> improving link stability and power efficiency on platforms using the
>> Qualcomm UFS host controller.
>>
>> During link startup, the number of connected TX/RX lanes discovered may be
>> fewer than the lanes specified in the device tree. The current UFS core
>> driver configures all DT-defined lanes unconditionally, which can lead to
>> mismatches during power mode changes. Patch 1/2 ensures to fail on this.
>>
>> Additionally, certain Qualcomm platforms support Auto Hibern8 (AH8), where
>> the UFS controller autonomously de-asserts clk_req signals to the GCC
>> during Hibern8 state. Enabling this mechanism allows the clock controller
>> to gate unused clocks, providing meaningful power savings. Patch 2/2 adds
>> support for enabling this feature as recommended by the Hardware
>> Programming Guidelines.
>>
>> ---
>> changes from V1
>> 1) Addressed Shawn Lin's comments to fix comment to connected lanes.
>> 2) Addressed Bart's comments to remove warning and trigger failure
>>    incase of lane mismatch.
>>
>> changes from V2:
>> 1) Addressed Shawn's comments to fix commit text.
>> 2) Addressed Bart's comments to remove variable initializations and
>>    indentation fix.
>>
>> changes from V3:
>> 1) Addressed Manivannan's comments to remove extra comment and return
>>    logic.
>>
>> changes from V4:
>> 1) Addressed Manivannan's comments to fix indentation and return
>>    handling.
> 
> And you dropped all tags given in v3 :(
> 

Sorry, missed the tags, will add and reshare.

> 
>>
>> Palash Kambar (2):
>>   ufs: core: Configure only active lanes during link
>>   ufs: ufs-qcom: Enable Auto Hibern8 clock request support
>>
>>  drivers/ufs/core/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
>>  drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
>>  drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
>>  3 files changed, 56 insertions(+)
>>
>> -- 
>> 2.34.1
>>
> 

