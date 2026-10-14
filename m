Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4133383C86
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976973; cv=none; b=LoWvEnHS9cO3fX9FVe3x9sJIpFK153yMG1dSk/++YU9tlCW/QbP2xk4XtW2Uf9O4SM7BTYIDPkQu3czLqSqdWh2rAC4Jg2gKyWGvmMK1olgM3ofxjV8X3xwXpYNTjICy2hl5DD0KAnYjs19tLEYgg7xjzhXPqLAnyqFCf75xAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976973; c=relaxed/simple;
	bh=gw7oTGG7uU8qweVcAhui9r/qte1vsWv0XL7j+PdgEog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3AjTgGfHBJU2eoEitgJ6Db1RCD9G/FRyOYcZOe54Rg2zkSmtTb6ypjcUGVfNMtCIn9gjwiNGRQ3OTcXM6ju90gnqCbmNOSn2L7Qe/GBF7FSnyDA32bmGJEJYa1p3TkM5zp2CGI6aToMMouvB09VQs2FZY9e1lxVAQe9YiIWLZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JStjHbJW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QoJt5mvt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JStjHbJW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QoJt5mvt"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E6ttTa2088183
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S+jntJSO0dOy1PXfg1N/yqC6Gk2DhxB67lCSd+0bZ4w=; b=JStjHbJW+lXBYnED
	Dd6Ik6HLhnhVyaCsTp1DxF1ENsBv2rAheS44KAoNP6Pwr9x8E4xIUUt21Tx3df5j
	kjG2JZAg8EW7Yx1HqKjoVwmP8UBACC7IOMxhShUNhxMTWXo+E1DNJybgNxBmk/73
	LCN+OJhT1P2LvFBcq9F0G98alMH7WlCM8bYkSjES2ijd0bTuoBAEFgrH6m03ks9L
	C8cqDDq5V+68jGyZ7nxMoyBR14YZz3wb82DeAZUdgrfad0+zQSgMDSBnSBqkdBzS
	QEO/B8OZSbos5rx90y3InExdDkMFotguCUYmOs/dDwQP6kYZjVCflQ1RnU0o+Sbn
	Do5s7A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9x49jjkp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:22:51 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc42a07d04aso800258a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 04:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791976970; x=1792581770; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S+jntJSO0dOy1PXfg1N/yqC6Gk2DhxB67lCSd+0bZ4w=;
        b=QoJt5mvte5rlkyi6ii+RQZq510i01t0vOoSegedwV8nJqgH1wFT/hDcE1poReuinpG
         i1FJAzZDzvt9GnXKmTkVD4YG1T7bAJ8r6YCKYyEcecREs1pokbYxyk1ikEt/4qnQgVO5
         gp1dC3RjJ8xAv7HRGmnynoUeD1yqprf8Kt/kSroGolXIM9QRpFb40TaIXgdFb6Oc+3WT
         8KoMP4nPNJltVajN9rT/lug9yN29kInnA7eWW6nhVWKhbeS2Awn8nreSrQxMFNrFZchg
         cUKnplFM6dviq8beugF1XWVO1BZfyZ+42Y6skGXP6mQKcKBJBHly3rcEMR8XC94PrC+t
         qWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976970; x=1792581770;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S+jntJSO0dOy1PXfg1N/yqC6Gk2DhxB67lCSd+0bZ4w=;
        b=0gMV7JEB42Kp5sTho0SA+AgzW91Y1I9YejS70Kl+6vlNtaXUZcCTPzhwv9sHNdI+sS
         Yv4s7sfF23FV6d5mvyJNs81WD+1J1lh+QEcKaREGCnqOkLCImn1aMrIijU0rUWhOiOMA
         af8nyAhyd49Y9MHEK8+QVPLJWJ2kShz7Q/qX1+cwKCuILvv1BOcxO5HoEdrEGLfFSEIi
         9DZb35r1J4KaCg/Vi4xGM4d9MVQOfRnKZ8NQo63rDDWk0mXgFDZOzxXO3H+cCpzgm1i7
         ZdFhnOoUChlwMWSoz9MK2GvANCYBb5l0A73b1HrowSIlnCuv2HdgjOga1peO6+SUQmFp
         t/XQ==
X-Forwarded-Encrypted: i=1; AKwUvBxqV+aoVTMytvc487z8cotTE3g8ZiM4OZV3JN4qyR1UhahgYh3bkftNcWeU3NwpojbH5Gehpajs67kC@vger.kernel.org
X-Gm-Message-State: AFq9FYLdyi/L8QFhn2F9Hi9K4MW6JZnu0p9c27+ySaRGWEMUp1I1zqpH
	j2/I7rv8hnbjnxFafTYlDryKNdRm2t7/x6BeA8AvtQB9GtRwacJEhf5YcPFcqvH5HsKvm4H7QDh
	F/LvOhCKybC7iCE84Ug9lsUhUl9/qzRVTDpTDK4Es5aZT265mo8ndq7Y9qlGlFQ4Xo2xcsIhv
X-Gm-Gg: AYBFou3TSeS+HZRIA6T/wRlVA0DMnhX001HDb5LMr1i1IMILbnamfCLI3wp1PMeqG86
	c2+9pE7O7BLwRsOcqgBglrJMC+ZrOuXopXNhxsRhk7P+58pdLKmh6mzUnerImlWR2a1kUNYZmOB
	qQBOP9FmjyMbYKkR8JS3auaMq0JSh1NK3V9+u028u3LRwbfJH3pZqEQgur8dMk0D9FbO9TrXPfl
	IDtaGYvrQ5y3mG+V+RyiG03cjqKF/OosHkK4iMKoJeHenYosbMgmw9P/EIwyW1so4U+LNICBOp2
	Z/MGHX7lRUg+8r+XVrCPbwRSAY0WJv4dLtmB4Fv3vOofm/1R1NmL7+lyCtlerwMxlN4sIPd29Oq
	/yqd4y45mpR1OVDAhLaLhaVpdxDwND/eI73wJMw==
X-Received: by 2002:a05:6a21:3b92:b0:3e1:51e5:f28a with SMTP id adf61e73a8af0-3e16b7792b7mr14830943637.0.1791976970331;
        Wed, 14 Oct 2026 04:22:50 -0700 (PDT)
X-Received: by 2002:a05:6a21:3b92:b0:3e1:51e5:f28a with SMTP id adf61e73a8af0-3e16b7792b7mr14830917637.0.1791976969839;
        Wed, 14 Oct 2026 04:22:49 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e088efsm7091424a12.11.2026.10.14.04.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:22:48 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:52:40 +0530
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
Message-ID: <as9mAK0JIbWhjNiX@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
 <CAPx+jO_Ltc6Q+VdUgOs81azTiM5Vx12GH1z+CXt6NW=M601THQ@mail.gmail.com>
 <aqrxBSw8OupqItDR@hu-arakshit-hyd.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqrxBSw8OupqItDR@hu-arakshit-hyd.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=YJcKWhGx c=1 sm=1 tr=0 ts=6acf660b cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=Rw_USdjLlEaQDXAQyuMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0NSBTYWx0ZWRfXx/WNQFuC5v+N
 +UbryD5jlpbAVXEFXhB3dpEn8p7oa9Q2IzjV6BN3V6pjYuN7dw5HD7vMDfUfLdnpIH0b8U60qLT
 5s2dfjp/pzA20Z3owVqRqC4k0629T4JT/1UU/3xoxal1DXj3hEfRY03AUKG2YBwj74/9dwsYCLB
 74gER55OnzcUL9KUWBrrafs+wfTY+ctXycEua1fFquBx4goA+xxuWriwJhLjPYhfqsbfTIy53HL
 +FvVIlewkRfP7/zWO2DQN7swJiWlWfglnMYGfqI+DsCqRfC7yUz7tlh0dVQ6aNmjB78HOWz30zU
 PfWCIguE+6Jpc2zyt/wMX2xQLWmpO6F69UNOsVSeqoRJRANOldI31Hs7wbVuKcS1awb4Q+X2WyB
 Nmu5QZ33gAwZledUlO/dLmarLO2TncKOoT+Q5s1qKrHL/oHG4lZJYDfEUIiGUNSN6sbQuM0GNMl
 b/QpC2imYn2d4Ayhaqg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0NSBTYWx0ZWRfX2PvXoPOB9gmT
 +k5All6JrlvH0VBprVMqDYqAzOPNBoAkUlTPcHDbeFov97PHIMMY6eJDyIhNjGCOQfgoYcYaRoM
 L4XISKiIWfCY/CGKMsRUBkVJLcdg7iU=
X-Proofpoint-GUID: oIquQUC5NnG3DPp_szLkWGC8R2BiR7on
X-Proofpoint-ORIG-GUID: oIquQUC5NnG3DPp_szLkWGC8R2BiR7on
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140045

On Thu, Sep 17, 2026 at 01:12:06AM +0530, Abhinaba Rakshit wrote:
> On Thu, Sep 10, 2026 at 12:17:46PM +0200, Ulf Hansson wrote:
> > On Sun, Aug 23, 2026 at 9:48 PM Abhinaba Rakshit
> > <abhinaba.rakshit@oss.qualcomm.com> wrote:
> > >
> > > MMC controller lacks a clock scaling mechanism, unlike the UFS
> > > controller. By default, the MMC controller is set to TURBO mode
> > > during probe, but the ICE clock remains at XO frequency,
> > > leading to read/write performance degradation on eMMC.
> > >
> > > To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> > > to align it with the controller clock. This ensures consistent
> > > performance and avoids mismatches between the controller
> > > and ICE clock frequencies.
> > >
> > > For platforms where ICE is represented as a separate device,
> > > use the OPP framework to vote for TURBO mode, maintaining
> > > proper voltage and power domain constraints.
> > >
> > > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > > Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> > > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > 
> > This looks good to me!
> > 
> > Although I have a question - should we never drop the vote? Like at
> > suspend and runtime suspend, at least?
> 
> This point is already discussed with Konrad on earlier patchseries:
> https://lore.kernel.org/all/d1232243-2f23-423b-84ac-4463eac79f9a@oss.qualcomm.com/
> 
> Since, as the device goes to suspend and power will be turned down,
> PM runtime will drop the votes and hence having it in suspend resume
> is redundent.

Ulf, I hope this answers to your question.
Can you please check and let me know, if anything else needed/open?

Abhinaba Rakshit
