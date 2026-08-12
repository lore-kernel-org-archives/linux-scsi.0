Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC5A36166A
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786517691; cv=none; b=gb5wrYI2+BvjDRhEsP18wKxDFOblSdeovCLtru/ViuOt7LsstmlrfxjtABAZ4Vhrz6f3Vb/Ba2iJdqrI8Pm3La/Udd0N/+sK7imWSicZM4vegCEOjF+l4yjED0M8yxcmnxh/bYnS7k6PlA+JW69FuAEdiBKDqTNoUkfeM/psUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786517691; c=relaxed/simple;
	bh=BFpKMu+N+lhLUOhUBprUSLMaE/aR5fqxZY4RYmGejds=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lILmFcQyEX4c5Bbqx8ypjG+K+noMxcm4gwKHWhsZNfKtJo+7y05m/G/F+Q/rnPXbgoqXCYXMEOAkLhzYgZA22lzacoPnWwTREk0b2elb9EJRDMECwNxCTZs6TUZi/TDuVLNjvMlhC6z3XUgGw6bs91/XEBiyS1GYuT6Q1K+easw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dyGho3gV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TWjZz6QI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dyGho3gV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TWjZz6QI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67C62RNJ1720190
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 06:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=v3VVXKFAuDaFyAg4gLlAG94a
	Btk5XT2S6br2Q1phvrc=; b=dyGho3gVk+lFAajEzJsE4kCJ3oedIearnfjc5BHC
	W1lUYX4GLJYWQCrJBLqAxenFoLtdWTMzMUzm6b6EzIjT5z8s7dbhTD4Cx/K3IpVz
	fa7D6VvOHqE8msiPbKAHdybBZmAf6DoboVaPA51/AE6N+uXD/jyR8XAtqXbCa8vp
	KrESHNiSRhKDDDhxQxxrHPZet+Sqt8eB7kho+huGDAxGKdtF/Pw4NI6Stm/SyvaQ
	G94tr0q8PX5UAgTwHaiH5zYjihKKd84yvhrFpIUbBaBtfKLnTzYvE/jn3x88D7dK
	rLjUgctg38rbO7A3s+Kg8/esmQ3ei3yZ8tc/Ng5PoyEzDw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0hfw0jkm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 06:54:48 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ce64c41efso11443991cf.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 23:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786517687; x=1787122487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v3VVXKFAuDaFyAg4gLlAG94aBtk5XT2S6br2Q1phvrc=;
        b=TWjZz6QIRcTvnc10HLgvCibDAXVyxdsOHYnZWTwQOZXr9Ko6hQn0V2VlIDD00DL5ld
         ReTO7PYokTlPyvURABKAvzUR9JbVGWNNsNB/BHuj2l84ao4TKwcT3fOC+LhD/dxdXKaf
         pdIoJohK9JT517XkgOcSLsyO7RDlo3PwYgFi3M/UYhr+1MyEguzFXeRITvtleJvKVRPl
         gD0jAcUh5+Uy+xRG9f+QcppHYOoGStbxAxiikf/4tRqk3YBG2b49PbnARmlK/dOtaBLE
         NQwmpP/Jo1IJWBbDR1hL7YGTLeUK72DkrZpDaJ2xAeQzUNGVoJ7HQme/xFX1Dqgc4PN2
         l+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517687; x=1787122487;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3VVXKFAuDaFyAg4gLlAG94aBtk5XT2S6br2Q1phvrc=;
        b=Ki2uqMvUZyAwhPPviwTmizIqwg/Rq+Jwx7tyRinIgI8BA5thw3RXVibNAAY60ibWuG
         tLciHkVtnLODrUopcaLlevrMlX/g5KkBci2umUN7R3G5BBjvWWzoSXm+yoUuXKnpMnmH
         V0AneF5WGt+Ww7WPMETBfmwcnR+yELb3BI1HxF8gRsYckRKUpBJElJ4dH9F7xhjWJ22p
         smL4wrs95BGe4NymT/W9hsd68U1ERe6BSiu1HF+E3FE3PIBWImn3BRiRODnjsTfnKdTF
         g5WecUO8oyI1Vn2AeromKHT5/glthxCIwOcOjkc9DK7u10M6/hSsNiBt7z+N8+r/Mu1I
         NwHg==
X-Forwarded-Encrypted: i=1; AHgh+RrrwiNu0i2/ILkDUfe2VFyz0UioQ+sJ6jQlnSh85fFpzJsZ0EwEKOvNVrZtVAC+ZD1mwwdWVo2YXdvT@vger.kernel.org
X-Gm-Message-State: AOJu0YxKYPmQlQudUMGTG+vmRhgEyA4VthEiScJ4jh96NiKu2nPuCWzU
	wjV/dE15S9WIvRNZfSkQn3CQBq7FZGqlmpFgYwncwJDb+69yJe1j/MAj7eG/KyzOMVa7G7XKoSc
	9sm9GBU/8b2brOc5JoNXVOpCU4CmIpn0HJkDxTRuo69ZsD4poVALVgdd31/8ax6KS
X-Gm-Gg: AR+sD13kiqjRDiBvUWi/EMuR+fCp30J477EkN0wmfwLGiN+gjW4QNbIOLLRp3TcSeq3
	RmY8QCjlLL+N3EwrynTUniFCQSAuqJlXwxkkXOQ6F+gI+VXH1Gi7D6KE1zA2+6VMjuS5wZ2jvKH
	aeJaPE8dhpez47QWK4Us3dBPiDrZzbkdHiDI/Ub8OC7dZgO24KMtu0+2BbM/hg/aQbhao5lHzxT
	JJiIlDiH136lfNAgRYId5EDwZtwJkq598ra9n4yOurle1JNVq7AU32sYhdNSQ/PsTg2biQIJ8uY
	DeTwONk5bDglzGz50zp/YeRqBzZoxOmgt6FU/Hlr+yXpsQG/wb9jLTK10QgK39sgg3LBE8nYWAL
	P+tiVlrXl+fjNBNqNeHExqVnMWui1xBNJrqE=
X-Received: by 2002:ac8:5892:0:b0:51a:8dc5:bf89 with SMTP id d75a77b69052e-52d646b8909mr23232331cf.5.1786517687415;
        Tue, 11 Aug 2026 23:54:47 -0700 (PDT)
X-Received: by 2002:ac8:5892:0:b0:51a:8dc5:bf89 with SMTP id d75a77b69052e-52d646b8909mr23232141cf.5.1786517687089;
        Tue, 11 Aug 2026 23:54:47 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c9944ecsm22591555e9.14.2026.08.11.23.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:54:46 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Wed, 12 Aug 2026 08:54:45 +0200
To: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
Cc: Bean Huo <beanhuo@iokpp.de>, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <anwYtSvM4HjI2VLv@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
 <al3-w3j2-E2twGZj@trex>
 <anNN4gZc9nvadHNs@trex>
 <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
 <anRVtmk7ejWewDX_@trex>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anRVtmk7ejWewDX_@trex>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDA1MyBTYWx0ZWRfX7SecJdO4kEw8
 E+LNrMkKw79LX5zvfwsPIHJCFLV9F/48nieAaxkb4jaNRLgN28o3Qf2o1xjparrFeEOh0Q7tHGx
 A2aYR9z72SyCTtDgzQVjuAVh2InS3ic=
X-Proofpoint-GUID: DBRBmbE9fkkD5KbQRJ5u9lIrmI4rohQg
X-Authority-Analysis: v=2.4 cv=fpDsol4f c=1 sm=1 tr=0 ts=6a7c18b8 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=NEAV23lmAAAA:8 a=8CC5C0rKepkKukIsmMEA:9 a=CjuIK1q_8ugA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: DBRBmbE9fkkD5KbQRJ5u9lIrmI4rohQg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDA1MyBTYWx0ZWRfX1XIGp0d3Dswx
 uALgaBHEVVoUlLVWucZgPPXCfZeh+l4yrf8fauVgJfPmT0EoVGhobHk9+rMstMtqwGUBjszVmSh
 xraKJMPaWPaQ2zq6JrK5dI02mTM386QSGoDGiv0S161jPo4+XMPQlueFVCSZU5QYfg4Qs+ygh4c
 Oo8pVUUWkVXGAQlfbYFBLCo4UFlLV7JyNAgcWa60KnDj1JIgtJWnptN3SdPYDhL7zk8zVEaYuwu
 jnI6pqvMnpA4xLshVOHJrzAoPvw8s4Dve4RbiM1zSt7XC10n5eforI7QgP06APBfBh5kcNR05Jf
 VDoRQjvlaBU9CyzebW+NAIkVx/RoCc2QLl2S6iZUjW2ysiUg2iHfkE90DhFrkff4Zrej+eN+Id7
 3TtPQxMzSoSBxE0CNO4mJgvLzhQXVwuU40JvxBCu7iWAqI+Fkz8aK8pXwp8GJ9TuEkc3koR+oHv
 oKl3i+EvBDrTq+yytfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_02,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608120053

On 06/08/26 11:36:54, Jorge Ramirez wrote:
> On 05/08/26 18:18:31, Bean Huo wrote:
> > On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> > > On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > > > On 20/07/26 12:23:39, Bean Huo wrote:
> > > > > 
> > > > > This is very strange, coverletter is v1, but the patches are v2?
> > > > 
> > > > I messed up (manual edition of the letter) but the thread is proper
> > > 
> > > Any other comment on this set? Can we agree on the ABI change?
> > > 
> > > you can check the overall integration description here for more info:
> > > https://github.com/OP-TEE/optee_os/pull/7881
> > 
> > 
> > I would be ok on the ABI change, for this series kernel patch, patch [1/2] ok to
> > me, just [2/2], I will add comment in the patch.
> 
> ok. thanks Bean.

could we follow up on this please? 
