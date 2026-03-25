Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C273D47AE
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774443453; cv=none; b=Ts7FxyIIZDBtc/5aHF+jH0zEyVvsz0W83slz8ipejecbLUofnDYLOelfSIqAVe8ubi2l0k7ZEDfZmKi1JgVzgypJ1WAqVn3locjNEXUMcVjcY/y3gb+8VuY4rVaxGXAs4lJfnljxAOBuQo9ZYZao3Bi2/w0O6lkNa55TlWrdWIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774443453; c=relaxed/simple;
	bh=Ton7OXeU/OGHbpaFMxjuPdZ7xpVrD9m4vETwWgal5OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5tcea2G/ALAoPmL/P/pp/cT/0b5H06XrU3hyalcnnauexSG7Ksw6mLyIFgOq13NlLM/9XDljtn7gq+SwK9msRnl8EOxlGKmjnWVa35ZR3VTGpH43AXb7rk0FPJRQ5j/0LaMA/mk+vWd49pr6X7ylMxbJcpOGSbfWlAw8UGBxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p5ETOsTf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SHkh235G; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p5ETOsTf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SHkh235G"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PBGdxk1626601
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yh8YD1fe3q6lkUTUbwyQJcm9o7uQqNCFZM2t39dKUzM=; b=p5ETOsTfWmUVZVfl
	0Uc+mxIM/uGruS00KaZoCe8YlqrhNP7if8zoffLbEnWqlFvPGCAv0vE/xc7r6bFS
	Iw0/k/O6372oS5ziqufglczIPHkJgDyci+D9+Qvgzc5aTOdW0/WNYQa/TFjKHgem
	Cq8iA+a+HS+g2wGMc3QwFtTMcDTDlv80zjtoZeNYqtToRWlT8ZUF7G/QK/7sz6cf
	91K5Rx7Qh1A9zZrlXyIlxRAa0mvd7yDCZLuW4D44wdi79T20jvwwFxU/TbKXiwz1
	4sWhPGvAzM17k7MMlw+bKzJc0IHKNi6/aayEe3TOZM5CQoqX7sNhP50FDgAuaQPi
	lTAflw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d489whst1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 12:57:30 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82a855dc82aso4779278b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 05:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774443450; x=1775048250; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yh8YD1fe3q6lkUTUbwyQJcm9o7uQqNCFZM2t39dKUzM=;
        b=SHkh235GxTXEVEq5KA4W8nXUS9haK8LmkmM+yXLUyoFSkAeVRpW2k1fbuwCxJabMR2
         I3gHZeaBWhXcSH9+QieGpYlAfTdFMunB2Z34TdlVfi2h4Dhf/6w0u+sCzvyoi885VwFK
         UjtYTtgiwWANJd54MsoHxGdNS5Qbg4Dye8OZhJ8gLBGOAfPAnsV/iw88cyyNMVwaBN2R
         h1DIN4mghRaFvVMT33UU4XPNosa1oCJWjvTjjLnfhoZzhY2+b5mkmHfzBvHxnATVZsm/
         lV9W9xhvkPEoOtvobFfZ4LKkTBUBrBRahZ7lThWz+HsAqW0pXRo1TmTQ8GLU/9mzbtkS
         M6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774443450; x=1775048250;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yh8YD1fe3q6lkUTUbwyQJcm9o7uQqNCFZM2t39dKUzM=;
        b=KbGp9eE+oXcsYzed9/7vREKBbdep6gqRXNaOOVl3xa8tRzXmEA7Jmkafq74ZyXRFBx
         lUMSEK/LxysmsiOTdM0tyqeLX5ZdrDFa3EKlUTSV216aCktqXp+H7mVv0KhDSspxMZ5K
         odqUA+TpIkGrnpSOcLWnS7DrHceA7ExQGDoWpBjQ8fTzVILzWXo9YkiYrdblCy43+ONs
         sUjd3edn/mG0V1kt640zVeSLcOX2HOYp9MC5P6C3LpxdPb2mQNVznNfEz4NgSJxWH7we
         BtPAONEgzegr7k6fNqyjfVy/tFy+EOAi6xBDBimwzo/azx72EP4w3cBuY+HXotybWqGD
         nfGA==
X-Forwarded-Encrypted: i=1; AJvYcCU+Nw9BU9oBw3A6PwUDAve2cpfZRvs2zjkGYWgv/f+zIYoGJP03jC+64RZZQODxvL/mQvXvAmNSa/nJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwLS1SXl0nX9dB22QQj4EpEcMfHYvY3nNB7rXZABc+ILGJ9KKPy
	P8+pglFMWH3XWwM9ZXP75BnmMdbg1WItazWPQGhdtDErFyG0zjFrawqB5iBd0dGdJ78021rlh8x
	B4pJUsKIt/xbEZ2fqPsTbFpZseVqaJkmrpqh0IC7fnX3kRgFiMX4zMkDtJMpf71pjheGQiJEL
X-Gm-Gg: ATEYQzxn/jswPpkiKEPdyJC42VtKtUGKbT3src+6QauOaqOfkBbvw4qHVe2qXqNaqo5
	4y4ZfN4b+C90K5ZS3CUSXL5PPOSswkxlPJ1ySjWaUCWN8d8fm4UmILzY5A7qsVh9l/PYqPUIpeK
	K0g4GcVclsnEeUNNlfC0qWnNU2AtnA/J5Qhulqyd5grYU8zA4gj5ccTCg5zuBkDiXAoDsL8P00A
	sA702jLRtXt+7DExVu1xISVex1AKu4VhYa9VkZ6DHop5quzg3vC4zXTxDzsGU3DQXYty5nUVeNW
	oTYuh2hApMedHo8Hx8fvAi0ZDdnOop1dDEgt8fC0zGnfNTw9BphP4+iSLjunlun0OgA5tqWelei
	PSNFm4dqF4B5UNJ/7dyogLiPHiV5fyR3Jg3Q2
X-Received: by 2002:aa7:88c7:0:b0:81f:3afe:281e with SMTP id d2e1a72fcca58-82c6de8c9damr3447038b3a.3.1774443449589;
        Wed, 25 Mar 2026 05:57:29 -0700 (PDT)
X-Received: by 2002:aa7:88c7:0:b0:81f:3afe:281e with SMTP id d2e1a72fcca58-82c6de8c9damr3446996b3a.3.1774443449089;
        Wed, 25 Mar 2026 05:57:29 -0700 (PDT)
Received: from work ([120.60.74.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c66487634sm4699158b3a.29.2026.03.25.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:57:28 -0700 (PDT)
Date: Wed, 25 Mar 2026 18:27:24 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Drop the PHY power_count check
Message-ID: <vv7uzpybgyea7qmwryslxgfv445d5o5bx7wqgfjxxggechowwx@zi3g66yxgmzz>
References: <20260325120122.265973-1-manivannan.sadhasivam@oss.qualcomm.com>
 <20260325122922.wzihturkkfpr73qn@skbuf>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325122922.wzihturkkfpr73qn@skbuf>
X-Proofpoint-GUID: ZOTHJ2Byl4uSZlVJ5SA-kqgFC2VU0iCp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA5MiBTYWx0ZWRfX+bJiqKqZ5+i/
 qWmt/Lv1Oic1jGI2DMPjQXJUN7HHxmx16ijk0DAIIWr5C9HktATlDovMWwsZhAjF+2bGPcfQRNI
 Mhdv7ZDO2mS3MZ41CaTnkOsKVHRYDM/ZI11iKPEJaPLI4g2h8GcrJ0WIyLTjt2qBmL3FekwSY6V
 bv8el7klug+QQD1WcLvv/1uL1Kh9WbDRIXvOlgwnovdIhtu6YAAgE/q33N8y2+Gf2DEhSPAjohR
 WrdSYfe6YNCurb/x3y7Hhu+aoMm7a8dN0Q64Mg8VcEt7RxhWBRu+XfYo1yNCcgIchWe1XThW3MG
 FJnVix0SDYZC/cOPXuJ8sfZbs8cUYnyFUFxXGPb33myrJerGyIY6r4dh50KQ1Wv2vEekCxsrTyY
 qBF+D2GcT1DwqZDqg8JTX/OxFG9Gu+ApDBd3zNdpzgXQ+v6Jv1PxQCN1BbZoUuc9ovqKefVePl5
 53Gp1wzI9Gj/e1hpLBw==
X-Authority-Analysis: v=2.4 cv=e/gLiKp/ c=1 sm=1 tr=0 ts=69c3dbba cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=DfnuZq+CPLWApegUcJV09w==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=8sJpPIWwF3nvvNpkCuQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: ZOTHJ2Byl4uSZlVJ5SA-kqgFC2VU0iCp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250092

On Wed, Mar 25, 2026 at 02:29:22PM +0200, Vladimir Oltean wrote:
> On Wed, Mar 25, 2026 at 05:31:22PM +0530, Manivannan Sadhasivam wrote:
> > phy_power_off() can safely be called even when PHY is not powered on. So
> > drop the PHY power_count check.
> 
> Sorry, do you mind writing a more elaborate explanation _why_ you think
> that phy_power_off() can safely be called even when the PHY is not
> powered on? If 0, the power_count would become negative after
> phy_power_off(), and a subsequent phy_power_on() would merely bump it
> back to 0, thereby not calling into the driver's qmp_ufs_power_on().
> If there is a regulator assigned to phy->pwr, this would see a call to
> regulator_disable() with no prior call having been made to regulator_enable().
> At the very least you'd want to explain in the commit message why that
> is something to be desired, so as to give reviewers confidence that
> conscientious thought has been given to the change.

Sorry, I just rushed through it. So far in my tests, phy_power_on() gets called
first, before phy_power_off() in ufs_qcom_power_up_sequence(), so I mistakenly
thought that the clk, regulator disable APIs will silently bail out if not
enabled earlier. But I was wrong as they will just scream out loudly with
WARN() and that's too bad.

Though I couldn't trigger that in my tests, I'm still not 100% sure about that.
So let's drop this patch and proceed with your state tracking patch instead.

Apologies for the noise!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
