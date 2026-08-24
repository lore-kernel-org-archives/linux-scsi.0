Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA63A0E8B
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787558741; cv=none; b=RNafoLNo7hB+BKiu+edQ54CGKtaGQxOpfpG1kV1p1CQNICWWOcd4B1LI+Hz603QFCAKN587cGNpNmLc+HFeYLcu79vv4s4Y6YERXCX7iGnUZGNMkydX+LSM+S8jFc+5b3QO7M2vPDJAT4kVre5tIpeND0XYqh10BVa0PUo0DZLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787558741; c=relaxed/simple;
	bh=t1Q5l7E2NYA9ruZLWO4AvWE7k4IA7tU8aqEhVm7aL7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lk46nSvkFdwQp3sYMbI6hmIwl5nIqmvpF3FUGXsT6K0vl5v8279xTBxTgmw+AqX4Ic5Ti8WeP2FTp8F56pk7VeDIio6V9UH/Ts/SdU7XZOKefNXL2F5Vm6k8mNF0cu/6hW8ySSuekFiwFMJhWmBlZOReN/pJUlbELZMqrM2nUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BJ+irut3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XjTBMApy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BJ+irut3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XjTBMApy"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O5Rwv01009223
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=HO6pzy8hdqwatnNdzVyG4rmy
	PCjNL3yeag8ExcEKy7g=; b=BJ+irut3ccBgSn9wUrIC8NiLjx7J+5GHz2zCyAfg
	A2OvEI5Q3CevhJ44/P0AC4Jz1rM1QpE6XZjwDbKvDNmxxw9xhTvYbcU8X6gE94Qf
	mWEnUDu5yrN3oKpK9CRiDwIGrUia9s0SZ+vcuw2U6i8w2lvw15RIo6gTG0Tzi+Cr
	+0fb7zkrlJ8tPuedh3pz1nIFcri8F8i8+/2GuiPZ2Vqz+sbqa1jMBNKM1K/Fwn0P
	t9+xZhLQ4K1/iPFGgJwPv0WS2mwX+268KJKgCH15hgXf69o6GlB1U27jAKU8CA5s
	buPRDVD189ykC7yT2EOTNRVO/szpXkxePWJilRKqVFkLog==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g74xhdw5p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:05:39 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90a602a4e6fso58897186d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787558738; x=1788163538; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HO6pzy8hdqwatnNdzVyG4rmyPCjNL3yeag8ExcEKy7g=;
        b=XjTBMApyb9gtgEJaJh+1p1yvlAsu6RD9Bp66iKklAxeRSgL8lrxCvdfYI+sRtyx+39
         TLthtbfdsltmxtH5oW+MZrruMqnsNY7vUeLfjiNEDL8ykjhsvW0YSqgtL1gMjgdFZgMU
         8MJnt17ShFbhvmgFux+DWRAjwAqwbW6LGZqxqk1VFx9qLLJqRUpg2yzvjyzMPjOWQuYb
         yXkVvrWy4xRmLdizVnx3zPoT64mnR8T2qlR35LoVsAOLwAJzWugz4MH9U3ziEXRaxAnJ
         KBYHnsenGr1+sSuTbF/H8YYRXTYBAwmL81gg1nICRom03DcngM5Ey/Q7Aiuf7v4qmzRX
         lPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787558738; x=1788163538;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HO6pzy8hdqwatnNdzVyG4rmyPCjNL3yeag8ExcEKy7g=;
        b=e4pwHpjNhO0UTLuVQXrgJ1LOsJRl2Q1DuYzYU8MHN4CJ2JjwC436qJKmuucqA+ySYu
         j+nD2sNN1Kd3wmm80+LWijvpKrE1xF9e9zidSdkKgF6v53u/YRJAmkS/WBLlKJArw+4C
         5c85+Nb+Q/ncVhgLd+/f9eosKcwi2HwJH8KJ5EmqNthecC3BfVbMV+DPnyXUP5V3s3kx
         Vgl0QgVv6VIPcRrAFQzelJzIVbUYK+MbNfhcEGBhKiH+2idkm2a/+01jADo/feKuDp/q
         CUxQTZeE4q1+6hrjivWsRJpPGdTnP2+9/HOKW5AfSB2KrD8psdAQwkfRLN/NweW4Et8B
         +pGA==
X-Forwarded-Encrypted: i=1; AHgh+Ro+zS7vfkNGx+SirRCp+palJj1TJCeIAgMDCgQHi7PMhYVymOHpZ0ikRWaiH+k6ZaOf64YeNNj+RLEP@vger.kernel.org
X-Gm-Message-State: AFuF++mUBFoRRc7XKB+FVaa47gWT4BqU9rhk+p932DrT0b+MQIGu44MA
	uaGOzH6Lb8W40s9FemaR/njGQGNdVApYx/H8nsK6EIyOcv9EyNjjFlY67wmVx+r8+TYiWzAqLVL
	COhDPB0bvFeWVcf0PLLVUkbi1XFpbn+OvVCrL44WAAtR9Z6KEXbqCTsCmdXD34Ffs
X-Gm-Gg: AR+sD10UAQxmOf7XE2hg3ayomc1z9amj4xnHE65eVPJ4Pps9XrZFr2NgoLsxf6v4318
	jc/mEwjGfHEJvPKh88XghHj5fz5oI1LZMpVgdd8gDQX6y1oltiN3b0VUD/zVyVSpvxnuTCleM2E
	IMGIirKJci+vZYt4pk5CLiCtfgL72AKPKD+5GHphhC3pkP1B532JVW1caSHGyzEX3bvDAcJNx9K
	10mzHL1gM5/1T9bruNaMrHU0YTJZ44lDlxneVI54/NV9rTsBGx9fkA+AP0HEYrBMiyUJsxbVgee
	jaamObFwlmWGcW3/PX0l3K/TvnKOyOKLtfepvGGQNxv5ebWq/ZDKicaQ5SiOIQ5AOJUArJcy05A
	jRn8xCyBKJMDIh5A=
X-Received: by 2002:ac8:7e95:0:b0:52d:9a3f:85bc with SMTP id d75a77b69052e-52e09bea1efmr169365381cf.18.1787558738045;
        Mon, 24 Aug 2026 01:05:38 -0700 (PDT)
X-Received: by 2002:ac8:7e95:0:b0:52d:9a3f:85bc with SMTP id d75a77b69052e-52e09bea1efmr169364541cf.18.1787558736879;
        Mon, 24 Aug 2026 01:05:36 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24962bd8fasm1739877966b.28.2026.08.24.01.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:05:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:05:33 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v12 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE SDHC nodes
Message-ID: <snkzt5xwhkm7lueb5vp5bqjr2b7devmh4mnawlbjptl2gcuq6b@khutwr5w2zdn>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: GoSQSrzx1nB41t2dThfvJfM28Um5r0Dp
X-Authority-Analysis: v=2.4 cv=GdQnWwXL c=1 sm=1 tr=0 ts=6a8bfb53 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=wUpz7uCjLrEXi01cjX+DLw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=-W0wxAWcNmATYll7EfoA:9 a=CjuIK1q_8ugA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfX5OZ7EclbKeOG
 41Iy94/WUIKPBzr7wg1f2UZvXRZzv9GSL740YUcgAMKTMyBwOPGgJ9rb5xr1WYKWE/K/lWKud3V
 dPY9bnuKVJIHNtlRTilD2rXgBBVKsqLw7EbGjWoqDblmoXJtE9Sg7aNPmgzYiMzgWDgeGiFI3HS
 ZwkOIw6VV7gdEb+xZ23nwFfZgfkzXbWC6zdiiwU5cBypm3gUWDrHkPXWY5DDA4brnjhp8mFW7Ka
 ABreGIDaKEuVhuQB9oIoXE78/5Mlh5LF4WjPkryULlCKulDiC4ar9aOkHZJfiz4hK3MtSwFwovv
 qc42YYOThooo5eaTGJrpqfDcA5+3Cb+pVBS0Etj1g1W4ZAgBf5DJjYDDJ5GDVCWPtX8SfL4wlqm
 YgMEQ3yUWEpZCX/K16BXBcYJ0kzrC3A789/QcOImNVyahgf51rGxE22WFIaPHQpkZlSvunebD8Q
 mS5L48HEmO1YP2eM5Zg==
X-Proofpoint-GUID: GoSQSrzx1nB41t2dThfvJfM28Um5r0Dp
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfX4dJbwuB1a8v2
 5iLWGhJiea8cfPZIP+U3rGTFkk0UsiyvISTryynP/eF6/duYtGeAVjZwnV7bwHJH1DZBxQpVwBv
 of6sfEzCvDk8Fgev87WjCz1w352IX2c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608240070

On 26-08-24 01:17:42, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE SDHC device nodes for Monaco
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
