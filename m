Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E46C38BF75
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772088919; cv=none; b=mmJ/GGhsc2pKPp4VeJ4TUA1WKEee0ypc+4PRjK+TMQ8lXriTMRP1fcz24j7aUH0DrAD29wa8rNTfe9rk/3aA3VYh3K9wmD7B7kNFJ7YST3cgtZHDE/Bwcu5hjTBucu+EQqhHjm4VxC30bgeuJZEMgEYoKnxpnBnTXUNBu37EKaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772088919; c=relaxed/simple;
	bh=SGjLdZB/OIBk6s2u0CnQarJYLiD8qrcGHxIL2rG8Q78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1ngUXrGc6rj5idFdcBLkU00XesQHRv2nOSRXLzo6h5uZtydeAi7HMHhbryc7zqLMQI+vy3p0s01p+LLr4QICSUalEs96CD8S4j6Ju/uUl2euFhSGsM+TxsTd0r7MjUrPVkXE/L1IUDnsSESLNxAfYrPIkAS+EnCCxp9+Kob/g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pJABNS8c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=es2LbDxp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pJABNS8c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="es2LbDxp"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4UtuW3225953
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=WZMy3HEaIGVZFlhw8LR5XDgJ
	mVmUwtmoD/hWO0tnibU=; b=pJABNS8cG04ZBWYbovIQvI6M+Bs5aSa2Refob88/
	Xv+4HrF3artKZhGfKS4HbRjkVFHvUSQN03lfeqfw7/oX7KhQ0VC7WbZ3xi7pmqj+
	eIE6Hm5IyEvZWBUKIBBLtZav4u0t00/vfPgkalFnq4qjfwOzKbJ3w3qsMeYP6aKQ
	+GM4+vZ2APSIhspGPBxEamC+fzwF7aZux6L3mwKytp+l5Go/CO8JC9ia+HT5bw9p
	1gU1ODxhJaNJ1c8t+vKMl/IZR88/lkKXQM51jDvHroC3sqY0YlgnQOpr5Wk6ahhi
	21tKwWWlLSzuIFyBXVDiK8vtTM9Q0Y6z4SDU1OckoBy1gA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjdph0m4a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:55:17 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358e5e33ddcso517476a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 22:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772088916; x=1772693716; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZMy3HEaIGVZFlhw8LR5XDgJmVmUwtmoD/hWO0tnibU=;
        b=es2LbDxpsb+EbJLKSDmRkaPcYTow5XRZR7MrfsAmWVg7watZaEbo68/IOClas7ExCL
         m0kAEahAgsAxrhiEFFVZFkgc/EqfYTrsfPDcaaHnM7YAr8XDlKvfoavOwN3CesfmB3Re
         dxbxknYGZnrwt7v7B/uzpaMQtP/awkKwZlrMRFq7wG/sdC3M2poVW6PMhOfEHiA7WqcM
         peoU2ztR3PAMe+qgH0ZcTvo1LH0bH9or7WEsvf4B6yqSCJ/ApkfVaHiDGxZj0MlUK7Pk
         PbyZOSLhK2uK8P5PepvF4EVysrIDN2K0J3t9kG99eYLi8QLfLq/LD+fck5vBC2P0KPKH
         4CbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772088916; x=1772693716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZMy3HEaIGVZFlhw8LR5XDgJmVmUwtmoD/hWO0tnibU=;
        b=VIDY+k0RITOzvVuAtef1dpvwPrsy3UvLClrV4Ah2NFtkBNBD31jztXa79znSD848OC
         8wzEYeQa6zmfYzdMLMTySDjrDERVDxB7jriZzvbSHY/IdKR9S5ZXy+ANgCZ6ugMQTw4I
         g2U6x5yrRdQLzbIiXjgv6tJxVvfC59gbG6dqO2aMKYaOAuDNhm0Rexa930cGlwaG/7wp
         fQXsoZYmzZlRAg+EOOzzpFE+tuUXUsqonUmu/94ITwSPWWgdFfXA/cFI/cwYny7DmoqM
         Jq0upXKZB+TnvEnfuyngdmrkwrxPpzhfGXLlO9YqCNybSAf4ShdxmsM1F6NzA+OVLwAw
         G3BA==
X-Forwarded-Encrypted: i=1; AJvYcCW9a2Of0RAxjI13gOZn/0I515+jKhzbOqbOa8XanDVOFtIPal3n4Xx5XgEFvg67TDk6gXMN029oDw5y@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ5H1UHsqbrgu2uGDUJjq1YHq003RWvHbZFlZPhhBDjcNxzXYY
	QxvbJlOUF5IBqIIy/RKaCngI2ZgkkoDMOiW8MKI/86yV5ago6dEt1G+IhRij17zvturmpeW/WBo
	eqyITbOjg3sWVcoZ1ylF7cLSGsRKIujmlTbAUymgWfpjdbpgWQzy4SlyljtgRRUf1
X-Gm-Gg: ATEYQzwa52CUprZ1nzVIOVx1znoM/MWXf6f9IU7/+Yu1XMLSlnxkbNGyZrjXG3npvuF
	rORz4d6NmOeDmFIh36Nx1ucBtTS2n5zeXRLVOxglDug9mrgg/TtLQKL3Oz4ZVyBkehyyZSP1qNZ
	Q0cj2cHSVI6989GICv+j/8RKwBMkNLp0J++dh8TYRcE+RcW4HmUThRU7SdOcXGJDmd1IrWTO8tW
	1qqTDGvEDGihEMoNGnnYJkIYdY5rqYW4c1fnwplCdo3+jiroWY/bAb+uQgnR4PlwOJGvRpnj5/e
	mVXs2cT37kUDeJI/ZZOxggJxNt5PcLwY+9m9gzTqfd20Wsv4tApaMTTFkp6ICzDXRPlMpgHAa2p
	YfWjRcV/Xj79fUR20Si/IovJR4GR7XjvS6HU9aFgSbcxevwdYUnAQrKP5XWc=
X-Received: by 2002:a17:90b:38cf:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-3593db8972amr1533441a91.23.1772088916522;
        Wed, 25 Feb 2026 22:55:16 -0800 (PST)
X-Received: by 2002:a17:90b:38cf:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-3593db8972amr1533422a91.23.1772088916052;
        Wed, 25 Feb 2026 22:55:16 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3593dcad63esm1422237a91.2.2026.02.25.22.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 22:55:15 -0800 (PST)
Date: Thu, 26 Feb 2026 12:25:09 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Message-ID: <aZ/uTUa4TgBsCPs4@hu-arakshit-hyd.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
 <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
 <aZ7x7gG0OZEQSKVy@hu-arakshit-hyd.qualcomm.com>
 <784d5711-3f3a-48af-ab1b-9a8834249445@kernel.org>
 <aZ/kqmGF5EJDE76W@hu-arakshit-hyd.qualcomm.com>
 <e714f615-1f55-4f13-a1d3-51dff71c4c7f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e714f615-1f55-4f13-a1d3-51dff71c4c7f@kernel.org>
X-Proofpoint-ORIG-GUID: O_qTMi6zr942Gmac6jGoOwd4B-FlF423
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MCBTYWx0ZWRfX1CAifoqjfrYM
 9Ggt5MnQEAReRfFg+2OtavCybrzuIwS8T4fhVG5bgwA1NQ8IYi6o1Q8Noko//tzfpBUpzEvVawu
 eybjZhrzVzHSaozA7kojdPVtc5uWkbJ3yc1+fuXYhKLh2ZKmWl4DiKKgn/8QvoT1uzPXx4zgqmC
 1X8pRyxZWzj0KeKq4FdIkli19BzV3VsqXh3mqMcphjxLOzab/Y1H3JYyQZj0VHxf9DfDEf2x8YX
 JC7jfmkpDgS7sT1Zp41vu+IOktH23tZTajsuqB3HkpjlrcXa0ZUPxkVPlbdrC8GDKyJb/q8jeOc
 kloTEW1oE8LGQKZOWjM2zPqK7YXstoaNMK2Y+eyu63CH5isW9ygyWoF21YwVyKSJapgqnAYelkP
 B4JaPsMCe5z7zQesjrqsZToYeEQ0rWdDmE8NsMQvyoYoIzx5ivZb1o6YFq56e5HP9c1HA/cNHRY
 OmLCkDA+/mzoXKeL9Og==
X-Authority-Analysis: v=2.4 cv=NJLYOk6g c=1 sm=1 tr=0 ts=699fee55 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=fAithCOwtWN0jAmX4kIA:9 a=CjuIK1q_8ugA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: O_qTMi6zr942Gmac6jGoOwd4B-FlF423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260060

On Thu, Feb 26, 2026 at 07:40:04AM +0100, Krzysztof Kozlowski wrote:
> On 26/02/2026 07:14, Abhinaba Rakshit wrote:
> > On Wed, Feb 25, 2026 at 03:12:18PM +0100, Krzysztof Kozlowski wrote:
> >> On 25/02/2026 13:58, Abhinaba Rakshit wrote:
> >>> On Wed, Feb 25, 2026 at 10:00:12AM +0100, Krzysztof Kozlowski wrote:
> >>>> On 19/02/2026 10:39, Abhinaba Rakshit wrote:
> >>>>> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> >>>>> UFS controller clock scaling. This ensures that the ICE operates at
> >>>>> an appropriate frequency when the UFS clocks are scaled up or down,
> >>>>> improving performance and maintaining stability for crypto operations.
> >>>>>
> >>>>> Incase of OPP scaling is not supported by ICE, ensure to not prevent
> >>>>> devfreq for UFS, as ICE OPP-table is optional.
> >>>>>
> >>>>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> >>>>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> >>>>> ---
> >>>>>  drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
> >>>>
> >>>>
> >>>> SCSI/UFS is not respecting subsystem boundaries, thus you must not
> >>>> combine multiple subsystem when targeting UFS.
> >>>>
> >>>> Please split your patches.
> >>>
> >>> Sorry, if I fail to understand the context here.
> >>> This patch-series is already split into 4 patches based on the subsystem.
> >>
> >> s/patches/patchset/
> >> Please split the patchset to not combine independent patches targeting
> >> different subsystem into one patchset.
> > 
> > In this series, the UFS subsystem patch depends on the new ICE clock-scaling
> > API introduced in the crypto/ICE patch. Without that ICE change, the UFS
> > driver cannot call the scaling helper, so the UFS subsystem patch cannot
> > be applied *independently*.
> 
> What? Where is this explained in the cover letter? Where is merging
> dependencies/order mentioned?

Get it.
Will ensure to add the details on patch dependencies and merge order
in the next patchset.

Abhinaba Rakshit
