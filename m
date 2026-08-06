Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0352442B2E
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786009024; cv=none; b=lv7K9VNIRucsjeWf1+Y/pci26ksqBPbAa8dtnwNKq5Z6e5gX+IY/+75Dzxddh1gFERIiRckBimdHaRESJVFcc47opqouDYrsXfHe6YNiKxpS1OBckzNzTEWtC4xv7LGWUsyUo9Y1Cel6/Aa7itJxIfh1IJ+LOUgBTDe/2aFG6TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786009024; c=relaxed/simple;
	bh=EoJwW2AIGAVoRz1s88wGO7qv62KN0DxtcIeSHONyd6E=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSVsG9EbgdRjkxII1a4XbJJMTRBspmImpMRGzFVkYus0/bmsOBxXpuWOa6LmcTaQZHde4Yn+j8UAMKz3aF+2Q7DRp6DPjWVYhAIG8PRoDmzek/Cxj1fn3BGsY1jgHMYg2zsG8PXOOv6mPlh3ltPULANvUK6avA8lroDZq8Zz0ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fbfVqBx0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bg46oFwT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fbfVqBx0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bg46oFwT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67694BLM1426418
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2026 09:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=dK1oNDeHDzcUUHKAc13B0n+c
	BXiGBb5aihE7jSuzR28=; b=fbfVqBx0G3b3Po9c0ry9s8bHxKfD5N3hTWuSoLEy
	+eJHRWnXbO0pvNhdus7UK3ZWgd8U3897MOAE0bCacsDGxKI6L3xl9bMCe0GfCC0b
	WQoLhDgOI07RVZgqK36xME3aQwJzwjhV8UWv2Wx6UZpiA2UK48+aKzifBDJvSHgn
	EiXMywbZ+u4C7wSy5N0/LOkch4IPAyipNTRtmqWSkl1i52DMWrCl/5w+N6mm20Oo
	G4A2SGZqF8LOs5REqM63RU1uQyv5FVskvYy5NZ4rgcxSMFb+pYtUHHwKbL+LAOQw
	kbJm0KrYOwan+fZTFTlAahah7sO3bMvLvD0VvR1Mgc0qlA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvn8prqx6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 09:36:58 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0e702df8so21034081cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 02:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786009018; x=1786613818; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dK1oNDeHDzcUUHKAc13B0n+cBXiGBb5aihE7jSuzR28=;
        b=bg46oFwTCNfn3HMR6VUrgWfiX6EKD/GBe60P0u+OuEjKd96AddxO3d+mnCCg0pKG1Z
         xvE9hfjnsx17cpYiGt77QoeYK6gDerg1PQXjGFJROeJhHOZQjjHGuKwCuhKRskoCkM1C
         GQIpKT6fpF0v3y+SFPqaX3QItoYiPxI15jFi1+s5sP57LkNYpnjk33du/CKxTWLkiDJw
         BH/0NXyiU1r6RxdZTc+AVmkQwohIw4H7vHiOlPJTssXvUL2i1aK6Acgc72BMwKgbUT7W
         nlnZbDc4L3KWnN5r15HMyJj4tv7sDCe/Qgev3Du0km8RKJYBtPaI7RKS4YUcSU/8FJdH
         Nk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786009018; x=1786613818;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dK1oNDeHDzcUUHKAc13B0n+cBXiGBb5aihE7jSuzR28=;
        b=Nbe9O8I4yigDvhuhWxo8vSkVoTKsWJ1G6TrIfZqB22pSatfykno0TX3GtnserlUtx3
         zyy//h+ZoV4vYgFAazc3vc0ScWklHbAwg926qrAv/3ofmbCrc3gl9BNYoVkl+ifDPcSF
         aR+EWdPr8gB6LBwahJczfuFQ7YrfoKFV6UaInGK8Wlpu4keu4vplWGxqzhpZmtkIqV/G
         9QqnRCAqr3vdtO8xQwLmw7qAIvqZESIkMGKdSBF8lEug8Qfk2YI02X489jYoAMX6Wp0J
         vkNdhPBaTul0IQFGgsZyJIcEVhZ3SjISykAi7sHvpCEThQ2iJiUDw+HvX4DbBCN2xA1D
         wL9w==
X-Forwarded-Encrypted: i=1; AHgh+RoXdzQi+mNYN3hTxTnq4Wuk5DCHzuiyn1GD5+QURZq2sl29SBkY1/0KwRZh6z5xKBBIh1JLdlxfiWT8@vger.kernel.org
X-Gm-Message-State: AOJu0YwhjMlVgDpJu7LORoLrwL+Y6zPb8SzG1VFvWHiLKSdgd8lqmFNO
	gNddYLwAwPKepM+24L3QgdnpjhllC6OglVUY3CsfPIOMb6CF/sn1Up/fh2Mme2+xi2csz7eMVBT
	llZBFn4mWX1AeGJbmQBCn/Clj17omTm3tAmqe6u+oycIYvdYwPy7lJXvr6tKZ/Ccr
X-Gm-Gg: AR+sD10HYvaPoo0n0ktWXLsNmz57AQbETeotLi+4HiPyZZuqJp6qEwbPs9gfBmjb/bj
	60uSpAoRzHZyJ+68fsL2wxg1L0OvSO7CoFiBQIMDPKql/vgVSIKVO88qRdiFMJnk9WZxNWT9hcL
	LBD0+jpv9J36aRevqtLjF9AyMuJoe5e9a/R8T86WcZ1sNO9NP8m6fTyMqikFMBq+9hEtc9rngC5
	cGPZ8G5qEyHOJD2ljGjEPY9ZIunGWIiWCvYluCa1SWOF6MTAQpRm4M0Tk7tAcAUBamBlPHEIPX4
	02z7TNfCQ8X6x1j5mErCbq0hmumUO3HDK97rH8M/9lB4ii4ewE5IxhuTuO6oodkO3MvjIm6HkeY
	jyXhp6IB9scf7TurOVikZ1XOdQKxD0P6Rg/w=
X-Received: by 2002:a05:622a:345:b0:51c:73f:e3a7 with SMTP id d75a77b69052e-52ce6108188mr133865841cf.26.1786009017677;
        Thu, 06 Aug 2026 02:36:57 -0700 (PDT)
X-Received: by 2002:a05:622a:345:b0:51c:73f:e3a7 with SMTP id d75a77b69052e-52ce6108188mr133865471cf.26.1786009017085;
        Thu, 06 Aug 2026 02:36:57 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm55101825e9.12.2026.08.06.02.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:56 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Thu, 6 Aug 2026 11:36:54 +0200
To: Bean Huo <beanhuo@iokpp.de>
Cc: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        can.guo@oss.qualcomm.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <anRVtmk7ejWewDX_@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
 <al3-w3j2-E2twGZj@trex>
 <anNN4gZc9nvadHNs@trex>
 <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3NSBTYWx0ZWRfX/FH50ooleVNQ
 Dkqy3m5geIlL2jyqfTCWH6KPTRav5GQHBC+USBiN9vDKVpDVdJdKf7A3dLI7mAZ7IpUeMgOh66G
 tg0pkre29unrzdGRRju60FOR4vkNIcE=
X-Authority-Analysis: v=2.4 cv=RPeD2Yi+ c=1 sm=1 tr=0 ts=6a7455ba cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=NEAV23lmAAAA:8 a=cv3o0ptGONNHt5ILADgA:9 a=CjuIK1q_8ugA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: gcHmf0TVcrOOSu_N46JU1nIPjUBcF3Py
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3NSBTYWx0ZWRfXzLjbvy1Jw9Y5
 +YcrfR8Y42YgSvyxPpIeAPNuvnV+i4tErXnG20sHTZncYY0qtXhQh6zY+tZ+K8IsKaujsmFVpYg
 Fn8+cRJ3VxSTIvZYZM/B2LrJP56eL5/WD8xglyZFRKQsCQUZ2yjagRCLxkR1/pJ5ZeHbzI5hRzl
 AGgF4FaM7kO0erizdfKQO7aOMUC2i6zEvqr0EPpwwScXIuFeuRPIGZLJk6K2tLwVt3GdaGZM24Q
 ZCXMFyuHRqrSOVbuWMmr/sQyCwx1h8YdtTFLeQqfC1h0gDW/VgVh+xEJXTL7kOHJWB05zvQIkNy
 rI2VKzxk4yZ2RKAFJvWvLmw59ehL5dsNutK6yIEUv5+k5x9IoeN87iwIVSRMZfMVIf+5fShBN29
 oMpRQguPgRKVWlZh+9LhZSAo8yekvBgovaMT0nKVz2wuMr+YYAXrTlLyyRz+5qfyKXAOyPROjWk
 PsbkLDnugKmsF+ncc5A==
X-Proofpoint-ORIG-GUID: gcHmf0TVcrOOSu_N46JU1nIPjUBcF3Py
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060075

On 05/08/26 18:18:31, Bean Huo wrote:
> On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> > On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > > On 20/07/26 12:23:39, Bean Huo wrote:
> > > > 
> > > > This is very strange, coverletter is v1, but the patches are v2?
> > > 
> > > I messed up (manual edition of the letter) but the thread is proper
> > 
> > Any other comment on this set? Can we agree on the ABI change?
> > 
> > you can check the overall integration description here for more info:
> > https://github.com/OP-TEE/optee_os/pull/7881
> 
> 
> I would be ok on the ABI change, for this series kernel patch, patch [1/2] ok to
> me, just [2/2], I will add comment in the patch.

ok. thanks Bean.
