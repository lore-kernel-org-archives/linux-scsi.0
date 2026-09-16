Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A7B45041C
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789587749; cv=none; b=ivstuD/cCYkYzKVC6RE6om86WOwqIVE/UCLynDB3+vBp6HCh7Xm8LSK21u4IKACcHyz/5JTqezXKQEWc+snGf1PZS3ZEevtg5svjSVfoT14Ek0HWodOwMiJI8lr7y8svDu0Ud6+GLZ+oFq/1F6v/BxRI6w5/YJ2zOyaoFBUgXZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789587749; c=relaxed/simple;
	bh=Dnc237LIK+dq38YOjzWu9j3d1wYHrJ3GApeY3U2aFec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/CQMlC7DVBUG8hOoqWimI/xIfR286xrRXow8UkAReHULjOHisCkOor97lUD7mi6GLA5/U8Q2iJLCV18Fcvw9XTY05LgnB+3/uHvgfNNUoEelO7AQiITlRoI9q081lYh7oPHovYk/8fQJYM9rUETq/YYO2oNVToZBL9Gfr1oN2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XMmYyhGs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BLOEBxQK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XMmYyhGs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BLOEBxQK"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GFeU661855070
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 19:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	irXsHZsnq2RJrG3HTJ0y9LXBcNkU5BE62K/lbfYKMow=; b=XMmYyhGso8YkV4VM
	fu/IahjwpGRkRkM6s1OPr+xa83UkQrLKEqEx/ph3PFBDcSAjWEO8o6slxUtSiaIs
	LmUJjTse1lUlxaO91G/eoVKpOi9qL40qliNU0DH8Qsnu1gyEkz/i/hVb/yYyuV4c
	3M/b6RjS2gDGHE9hxA3Nn8NHYJ8iua3nRHhWH0gUKDP9dbr2+o7Ng2IAQ2WiuRLx
	2j+h0k4GlB4yUUQ/FUtpoyhXNbRQZCRoZao7RiEBdDLXGlZsuV1sSpoSTlC5KCFz
	UNp9MnAiJBGgvxh+xcN4QgntV4qSVVKyupH85DcBHXdrd1Ei/SGTuPLJYgC5wY8X
	W2zTjA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqqp3txsj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 19:42:07 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-396901263b6so79658a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 12:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789587727; x=1790192527; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=irXsHZsnq2RJrG3HTJ0y9LXBcNkU5BE62K/lbfYKMow=;
        b=BLOEBxQK8eDcDB5bj8E7qEakRfrGmLaj5Tkss0+Ezuv74xZ1VqJozyOSLuCBe/Uaet
         Xb9X9kHktZVQfHV3zKhymG0UACf//G5Oa8+I49cDAKQ+iQpOgJXdrnmvgWjn0Mu1F5SY
         JxR4/t4epgSYn0ojjG2n5qg9GCkvY4qLdLPIfRo3qYTX6A7zV8HBCCAKh425w5wyYz7u
         5UQ4RMPNgEUpeZFdD7Xf/JEt1P+rLlxOedWaBSReQ2GPq60XrVYkOmS7X+/xaQnlJPE3
         qHfhPt/WFK4IMOK9JdprPd0Qs86ynx2mHt15CW93DPNymydGDT61Dzr79UDyeEsDkCDV
         pU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789587727; x=1790192527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=irXsHZsnq2RJrG3HTJ0y9LXBcNkU5BE62K/lbfYKMow=;
        b=aZ29k+s2O/yahAcMqm2ggPdevy04l1QvLq4flVyBoLV8Wtq9xeGAer7Tiv7IEM2ll2
         yXHNdWGMOz0srrbDl/IAPmlbZIV0eoaW36lpQhmrvZVsEYYFPnhsZmFyG2aOFnVoGnWX
         M18nSa9d36TafEWPhtH625ixFZflfyYlM7lrKzhCoxRmE0yGMvK7H9TvcGr/aH7Ijn1j
         K/Fyk8mrsdPK6aDhbXlvo5W2lRJhX8EWMYOUkZIR0b4b8+Y7yjzHgk5CJZRmgTB/EMxl
         aSJZzDMY19BYpkX6GSNkZQTeY/wUoWHyqL2w0NrNFZMypj+iTYbnSGn8oLX6CqWQ9fkK
         F/0w==
X-Forwarded-Encrypted: i=1; AKwUvBzUMAKvue6yewEXkVg9EzS83mYXesYaZECSJqtDZtlYgajy90DPur2NxfjwXAkjJj1A63p+Fwz2jbG7@vger.kernel.org
X-Gm-Message-State: AFuF++kNZsAE3qcrplGItStOwrvve6fYYezRtD1atIYmplvGD7/l+nDu
	34YKWgMpOQ59vDF6eehTDRCGI3tYxAJ7faKzHqXTQoeUGQhDwq3hEQZ3id7j/uf+kPXKuU660i9
	OZHv1zQRWDgEzTVjj0WA9z2EPr1KB5tbIuULQLE48OV8VPG4+DtPa3HIj14Lh+JV2
X-Gm-Gg: AYBFou3TWPjvYA3XOuQOe7i37JxEB7GtzhW8GmA76UJp4cnifC1xniwPDyCARKijqs0
	v3CcYKxcMnIndAOaHHXDemAMH3JhiyBn/U20QSQSwgLmc/BvTBbZ0dDthnu7q9iIWWbObKq7la4
	FZHOJ+kE0P91BhUV87G4Z+zbPsge2wLU1bZgLhbr/PgqrRPEfbKXTH3RY5Y4kV+prwykNcQjM61
	jwQrA2F7pws+Dhas+u3p6Fo3hzo6FntYr1Q6C9lzmDl8ifCvnOo9MpU5cP08mkC8UAUWNRsK36W
	ocIObUnvZ16X87nUrOaeM+u+JyPUEqK4t0jVBk2BgLM/6a+k8BNLeu8T0boNPRe+tNNbDgndjNb
	4FqR3koWRBmorOO/7CqBmlPyfbYUK+oYELwBoKA==
X-Received: by 2002:a17:90a:d646:b0:39e:3554:4d0c with SMTP id 98e67ed59e1d1-39e35545ae5mr3665564a91.2.1789587726579;
        Wed, 16 Sep 2026 12:42:06 -0700 (PDT)
X-Received: by 2002:a17:90a:d646:b0:39e:3554:4d0c with SMTP id 98e67ed59e1d1-39e35545ae5mr3665448a91.2.1789587726046;
        Wed, 16 Sep 2026 12:42:06 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5af6593sm9174704eec.25.2026.09.16.12.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 12:42:05 -0700 (PDT)
Date: Thu, 17 Sep 2026 01:11:57 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
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
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci
 ICE init
Message-ID: <aqrxBSw8OupqItDR@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
 <CAPx+jO_Ltc6Q+VdUgOs81azTiM5Vx12GH1z+CXt6NW=M601THQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPx+jO_Ltc6Q+VdUgOs81azTiM5Vx12GH1z+CXt6NW=M601THQ@mail.gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI3MiBTYWx0ZWRfXxaeFSJmiA0GY
 4knCXcTkhy431cCOwRELFn+uQOtVtDZp2JwSNJpNgujGy1mR492pegqpfRNHq3exV3WU7NxS7+J
 8bu0G5Mj9l6BnDNbFt3LY5LDVF9Bl45WobOz7mcTL+FmlVbo1De3G4CuDNW/OBj5SiGerzn/C0X
 SSF5iunWL5Ro+b+CC8JHFOQVlvU+As2GwrbSiutd1yl7O7LLXm9HxUevA7GNvetJYoGGaCRrHcQ
 bFeFlMMmGfOOelYACKRE2HMBcC8mK45rRcMiOhMKsFoNuP7WLucvhOmc6X1dUJsKKgyfgtjEOPh
 MSSm1qXC1+5gtZt9YjDCkdl5Jflynz++h74EVrNGEUwws0Pgy9E9j5dRgVLI5qXcMwnwS0klQw+
 WR/IoRPr3XtWj3UiBxetBMyBXagd2O2M5ZiVQtIzi3nF3bA4OgaJ/6RFkztdOfJVfepeiAUtnkT
 gfIVUr//+RX2GKDJYjQ==
X-Proofpoint-GUID: crxN3MVNKKPVGIos1WXpoLtQFxrxKQl7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI3MiBTYWx0ZWRfX1eZnJ/EDyqMM
 AWXkzqjSZ0ClPGEXV1Ezn/tajd5rZy7itmfuFfFw9MXkJJ2yLCWwxrqh26RDe+fQBzJuelioljB
 33XuoqNTffWgt5KSVqqQrY12hOKUuOo=
X-Proofpoint-ORIG-GUID: crxN3MVNKKPVGIos1WXpoLtQFxrxKQl7
X-Authority-Analysis: v=2.4 cv=F/DC5ahN c=1 sm=1 tr=0 ts=6aaaf10f cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=M7-gVhU5_WYnB0XQLAAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 phishscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160272

On Thu, Sep 10, 2026 at 12:17:46PM +0200, Ulf Hansson wrote:
> On Sun, Aug 23, 2026 at 9:48 PM Abhinaba Rakshit
> <abhinaba.rakshit@oss.qualcomm.com> wrote:
> >
> > MMC controller lacks a clock scaling mechanism, unlike the UFS
> > controller. By default, the MMC controller is set to TURBO mode
> > during probe, but the ICE clock remains at XO frequency,
> > leading to read/write performance degradation on eMMC.
> >
> > To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> > to align it with the controller clock. This ensures consistent
> > performance and avoids mismatches between the controller
> > and ICE clock frequencies.
> >
> > For platforms where ICE is represented as a separate device,
> > use the OPP framework to vote for TURBO mode, maintaining
> > proper voltage and power domain constraints.
> >
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> 
> This looks good to me!
> 
> Although I have a question - should we never drop the vote? Like at
> suspend and runtime suspend, at least?

This point is already discussed with Konrad on earlier patchseries:
https://lore.kernel.org/all/d1232243-2f23-423b-84ac-4463eac79f9a@oss.qualcomm.com/

Since, as the device goes to suspend and power will be turned down,
PM runtime will drop the votes and hence having it in suspend resume
is redundent.

Abhinaba Rakshit
