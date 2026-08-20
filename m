Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311B13D1CB4
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212491; cv=none; b=TlKeBQpiuZFMdv5NX+v36Qk+jgPu4roa+4pnDzz2OwAz00SMGv9REyG6SI9E9CPVI783o5+uabdmJ+i5mH+kTrrVjrELLsuoBOg/6ENWh81o0/Nc7p8cqQOcJH1Z+BqS/1aq905Oz8qeJJAL1JLvZk4nddXQKixhOlJFh6Lzi+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212491; c=relaxed/simple;
	bh=1l/YQ2Q9sW0ee7w+CFNU2PIASjZBFJ47vNsG46svOZ8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kp8SlEoBz/9XVHozSiTGie86OPXK9HtpDORLsmFjbWxrBIgnwa0Avm+z7+CgTSX5sc2bwcZz8m7tFxJ6OqXfbVSsL1FaXs1taGCQgC1qGB7DKWRGnlu59fpUvYHtVRXQyyw+hSkUtrKLUQGGzLNF4BmfRDcEs2BZrmo0Hl7ereU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HKL7HhfV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XclJpQfL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HKL7HhfV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XclJpQfL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K5t3g81027529
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=iXUpKkTCBdD3TbgLEQbVnmXa
	UIluiRVOhhI4qtaRDJI=; b=HKL7HhfVrhAdaOvwkFGQWGe3XWZGDK9mJkd3c2a5
	wLFiICUcRaOCUlL1RdruUBInlaLs1jjOqs8pcoYyykEYcEgE8KtSljrVlWFJwHhT
	ZK+ZRHCqDzJwLIbo3mev3h/rAkeIHl5mOo5IoZxs4BJkIcxbOhm3K3YS2lclzQX8
	6HxHeE23KWk/9RtDy+2MKJhcAuUDKol/+P87XdCtTtRyc8qvCfY4s42tapEFja1S
	PeZYHHlsT+HqcV5Am2Ex8PMOMnvxxuARxUraKfiTJnwxQDMovIGo51838rmpDpEe
	trIkb5BUKOLMgnJNfNQSFp5By4996D6qVtBdznGiJs2HUQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es4ksus-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:54:48 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-933023a5980so314487485a.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 00:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787212488; x=1787817288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iXUpKkTCBdD3TbgLEQbVnmXaUIluiRVOhhI4qtaRDJI=;
        b=XclJpQfLmCYHHPmrRTDt08VKSPY2IwPIUQYpELI/i0Th/Oy9FIeHxQvsmBag8qzr1a
         WEs9dKCenF89/SrLlwkq8Dwx+41770jBfpRlk7ugMMbWzIxdNRkBUhsl41jSiDPjJ6db
         xDHaDypgCH70pbkZ6Sj+dwOsIiK6eZhvYf7bSNS5Qov2yzGz/sUZUOTsXEg7cT5tLSoo
         MpbcpswPFT1ILKwwJVQBYwQtNeQuWm/aJGppxoG6a7JzfBL8uwWXBLHA+RLntE3qgM1+
         KBHJ9JH9JbqvybApXvayBh2WGqe+C4jDQXzNSUq+OndOXICv62HaTlRwxbN8RwPWbjp/
         SxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212488; x=1787817288;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iXUpKkTCBdD3TbgLEQbVnmXaUIluiRVOhhI4qtaRDJI=;
        b=YbCwRwpeSv2A78GccFPfolHAfC71/9GSoPRTjd/0PMGpfetPkCY9N6hiID9xxfi5qS
         Xp+li/DUowcFSvCDOYrWwd5Ivv5/snWBSVaK0GGDDZAGlc1txUNR5dTzp0Ldhz/AAAA6
         zmaQ3gTMp0kbgJFMetaQ81SWb98tEMPqXi5gOTxGRg3i4SfSe1ruN8aGMsn3KuzUiSwp
         Q6NrBRxSX29gW9CkWm+rHTWsSWoIznh5tJcCkltKOi+WURDxgtvmlPvx6UH+2TI5CDWb
         hrhyAHYkMhJrNyn7W7sL6qpSnDHF9QiheaOszNEgsFPNMuUv6/+UCHtqzepDWYslNPEN
         UGLA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8pDKdv5yiW0RB39m8Hl+JcmrjpX2PXcYv1UygfgPChNB4QQdkrIMBYQ8Fs9lPW+iH0RH+LQi9IQMj@vger.kernel.org
X-Gm-Message-State: AOJu0YymOkYcjNGUDPzNcOa5LfZKNGYbqA1bfJXrQS9kr6b3bBL2VbPK
	3xoQb4q/LTJuC+KN5wsjV7pTtza6dRO6wcIrTz0wUV1Hs49SeE9UB+4tWMMjn/9BnW3z2BgD8B7
	Dhhe47xR0lAgh0J5l3KNVUKrJS+dobUgNAq2q9TcI0grzRldMTy/hq1FXH6lCLpgB
X-Gm-Gg: AR+sD12jV8jnOZXmklkY6riKKdoH+coZvh9xJYPZAVOseErNfGhRaLktT1ufxRSiEXh
	Ley7Wk3NPU1GtCkA1sepEdzPT4z0me1TCHcsdTIFcXdQB62ru8+Ks3/4ZMZbM88y6wpkeSJ54ko
	X6GnxC38N8cbH0TxYu+bn9nh/bpgrYrqXNpNXH6omj2rvFSFnrqA+rstEWTM/XMRwNPIH/aowLj
	aQBre9mrTdYcKGFJTYkuZ41kmmwxdA8RG4UPBUaYg2pFbhgtlXCCfSdnslEPM8a8N8iMKd/5upv
	Nj++SS2zFl4iVS/yx1n0DeLiSuJfDrJBrzVEvvvlCNqCGhmM7EEqqjxybEDleQ0x50/nC3aoRtV
	e6FP1ZM5U0joG64tolEjygB1VpMu2kg==
X-Received: by 2002:a05:620a:a418:10b0:937:2ac7:7255 with SMTP id af79cd13be357-9372ac77353mr307157385a.13.1787212488350;
        Thu, 20 Aug 2026 00:54:48 -0700 (PDT)
X-Received: by 2002:a05:620a:a418:10b0:937:2ac7:7255 with SMTP id af79cd13be357-9372ac77353mr307154385a.13.1787212487986;
        Thu, 20 Aug 2026 00:54:47 -0700 (PDT)
Received: from trex (189.red-83-60-95.dynamicip.rima-tde.net. [83.60.95.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm11501700f8f.13.2026.08.20.00.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:54:47 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Thu, 20 Aug 2026 09:54:45 +0200
To: Bean Huo <beanhuo@iokpp.de>
Cc: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        can.guo@oss.qualcomm.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <aoayxeLGw50r-Dem@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
 <al3-w3j2-E2twGZj@trex>
 <anNN4gZc9nvadHNs@trex>
 <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
 <anRVtmk7ejWewDX_@trex>
 <anwYtSvM4HjI2VLv@trex>
 <aoMdoE35kN_GjMHp@trex>
 <ef5b527c25b9965296287498f7849f8b62533298.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef5b527c25b9965296287498f7849f8b62533298.camel@iokpp.de>
X-Proofpoint-GUID: vwjHlC9yImsn06iAscvkUFmbv0e1c3ZP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA1NiBTYWx0ZWRfX2dihycGkimPG
 PcyaNgapIRl5tB16DaMx502K0Rmp54m4kxiTh2f7JB0UHVqVSCa9ZiVuW3taQRPEtN5RZZGwbcZ
 rw5oeiiTgtFWvcNuVFkvAmutxDPYF556UkU1CwzLhG59ND/SvcgHsw79HFBYwg0txT5dPJOmCEz
 4JkJI4Gw+3CPxXxBw2qkp1V7cAFqM+RYMRccZEPlor4k3dGOngcD6boIbgCk1oyuF+YjRyOxTpd
 GTtYvr1IG/SFBCXJWjvaT7d+SukT6LPiPZRWMh8F61hb4x1XXY0QeShaWe5YIgBnpZjdSfQlftI
 sIYmttItvy6nnTRAgNdZ+LpE5zxgIewHWgdfLCr2S0tgYUJB4qGxsXAVth9wanTg3gKmGMlzU3Z
 EvZPoRKLuinWghswArl78GXzgPvjvPc10M6J8zGYP0nh2duUt37CQehSxsXrotu6Oee8kKLGOeq
 QPrLDP7ACwVhTsyKcgQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA1NiBTYWx0ZWRfX0lIm1ImnS7FF
 wd7+tqP8Tkdete5iPTBh9MYRBMefjG5zbq0E47RBrXUd/ir7ks928VvtkT8+rnlhOfOC5BiLnWB
 e7RJRuPn8pFvUABgBb3zfP8pSD9fyu8=
X-Authority-Analysis: v=2.4 cv=CN8amxrD c=1 sm=1 tr=0 ts=6a86b2c8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=kuURLP+TZHqixYhcqKuzcw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=NEAV23lmAAAA:8 a=yhDMiL-uQhlxC4zyq1sA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: vwjHlC9yImsn06iAscvkUFmbv0e1c3ZP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200056

On 17/08/26 16:46:52, Bean Huo wrote:
> On Mon, 2026-08-17 at 16:41 +0200, Jorge Ramirez wrote:
> > On 12/08/26 08:54:45, Jorge Ramirez wrote:
> > > On 06/08/26 11:36:54, Jorge Ramirez wrote:
> > > > On 05/08/26 18:18:31, Bean Huo wrote:
> > > > > On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> > > > > > On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > > > > > > On 20/07/26 12:23:39, Bean Huo wrote:
> > > > > > > > 
> > > > > > > > This is very strange, coverletter is v1, but the patches are v2?
> > > > > > > 
> > > > > > > I messed up (manual edition of the letter) but the thread is proper
> > > > > > 
> > > > > > Any other comment on this set? Can we agree on the ABI change?
> > > > > > 
> > > > > > you can check the overall integration description here for more info:
> > > > > > https://github.com/OP-TEE/optee_os/pull/7881
> > > > > 
> > > > > 
> > > > > I would be ok on the ABI change, for this series kernel patch, patch
> > > > > [1/2] ok to
> > > > > me, just [2/2], I will add comment in the patch.
> > > > 
> > > > ok. thanks Bean.
> > > 
> > > could we follow up on this please? 
> > 
> > 
> > just a reminder - there are op-tee/u-boot patches on the fly for the feature
> > that come together.
> > These changes are important to unblock
> > 
> > tia
> 
> I don't know what exactly you need, I have added comment in your patch of this
> version, you need to update it.


that is the thing Bean, I dont see those comments. let me reply to v2/2 

