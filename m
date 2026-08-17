Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6E23F075D
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977704; cv=none; b=Mgpivo3CnzggcwRgaNfw5hOV8GzrA2EmVLZX7b4yHhnA33LOKwLFzN7YpPm2YIsCtDimxBeRYzQjh+UkyMu6PqRGvGI9O7Z/P1bBIiEkmaNhmt4c7qCp3uPOGPQ7xsFl0pOWuKtumoNziSsU6V8ZsCCh4uDTI3mgKJPNy+8O888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977704; c=relaxed/simple;
	bh=hGKhCtYoIc8YnajSyS9gUsE79/Sc7DT5GtBQyp7vi9U=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFVdGOOuD6nPPcvUdcbavrCQhozwijEARjWtm4SPK3bRmxDCPnuY7xQay0pE+jXeQlQ6thMXshGX+C5YkUv9rdF15V+bI2qg3aCKuov7T/+/HeBE5Zoz3pEj6N6y3AnYrp3YxtddU9bmxtJqSk1m05ZEzMH9FpO9hgUETqKwaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jLdryDRP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YuNdGyu4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jLdryDRP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YuNdGyu4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HD5h6t3454217
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=jVkth3kpUHRXcr0TC+DRXqle
	vjZ63VnF84EjoqycaKk=; b=jLdryDRPy+rKgiHKm1OLeDzjFXsn4zQbdzUurFxn
	rV8Irb0pFpMSJceeFj0dSam2yIEOEzFWhLJfsZCb/1M87uuNp262qKVFhKUP4oYA
	U5mNL/5MRrauVNShRtBXQBdNm0vqad3R5EiAPxvkAxOSo09wNAvQP4rmilEZU5K/
	AbpXCxp1KImNKTK+EJytxECgiutdxfg7ed8QST1/H5QRrB4aBYPkz7noTYfd5dqK
	ezRWjCwxH+2ioCBQvRkmqA2V/MGvmroYsG5Ain/52q0VncXOK2EJWc8uld7c9Sx6
	F6rwXRh/0QjC86usKoDwm5tbEjX7jBaIGio8llg8NoareA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3y7ks9vb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:41:41 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e62e3459fso323001385a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 07:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786977700; x=1787582500; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jVkth3kpUHRXcr0TC+DRXqlevjZ63VnF84EjoqycaKk=;
        b=YuNdGyu4C8O+O1I/GikTas03q/Dp3zSEdlgnG8eKoHm9hA3kWHoN3Ut9+ledA1mVLC
         hOBr65rbdqJ8Mb1lED693yCN+GgSx8m60rL64vVkc/f3CbJ/fze4GXJnWXGD2CQixJoK
         1X68fkUb9Naiw7ngIc05ZE5RYMFt9GUXsoaGBZUMn7z+rEg6Kq52Vmz17sVNpTOPmqq5
         M14Pi942oiowWOUOeq3PWoJLBHYumZIitLd+iGJir6kh0TN8IKe7CAzq9o5u9vIxY190
         9VrvjQYHe371fuASZGUCwtAdi2LAyrN7aoF1KuyyEeR3p0J1A58A9CqCMFU+lq5AYyVN
         fHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786977700; x=1787582500;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVkth3kpUHRXcr0TC+DRXqlevjZ63VnF84EjoqycaKk=;
        b=gIgBYZDgYk7cSkZ03xwNpTwhVmHebRySlgRH3Au0L8opXdP7aalYr+eEl/Cvp9va1H
         QxzUiSkuY0cenNAS3C5Nat4eJlAXrgDmnhdML6GAIV+qIgr5O5Qh6fe7juOnpE2o2Tn6
         IuVCL9L13CA3TyHgqg2lqG7tQdlrFgGYiT9daguC1PfY7itLm/9X6G9qxBmRJilxcUHG
         h5IRlk83hGL9IEXLNEgs3bsllIev/rSQCo7gdbAUx/uo24+YRUZ4YvKKlf9H5w1sffIC
         as8X5YxLc2+eqTWekoOYWC/BRTCypMaTi23bmUlG21aFVdgnOwiaDsSipL+vd4yEVsLY
         rf9g==
X-Forwarded-Encrypted: i=1; AHgh+RpTPFMHtoiZBtlXldiVVHr5eFwK4UEiELhOtG1fOHoAbIVfVP4yA3QBHyXpi9rl10w5VV7Xv07Qc2eR@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ5c+pouETTZALEiI9yCQbA9eVbhdsC7uXk8UBfEjZZNUJnOov
	lvjekaVDWIqFQKt1MJ4pL1w1lO82p76gk/vNbGeYSdwgL8JEOPzOSFDYBJsJbUX0Ioya3KyJcoL
	nlDU/3N5+YYo6DZ/GcUErq/jGAsY27aOfB0rmvi3kOPGOCVzsnN6TG5k3XqRxB2mH
X-Gm-Gg: AR+sD13JgfWu/8sVjYznVJaZPRPe9ysIXugIWQer3YXPnPb150bohPv23zk/jcp3grQ
	XSRJEJQ1C/ezyfbDzXuXmuk415umN8o9JbKw7xBd1ulOhhH9L9vKnxZTqjFhh0slX8rXZhBCGUy
	e9c6J8R+Z0cSsNK73wGJ5oAzS85k7NidcnAs09aXMh+Ip+NtuS7znm2Sxow2bD2SvgTxIC8tXhk
	EFxL4YiU7me0q9ObNOuL9FK1vmkpz46gbg6ZQjIGvTZW9PnuVxB72H7yOZRA9yDY8IV7UsR1OtD
	N40zhadV//FhrupuFDkeew2pnQ5Iq5MYkZtWYJhoOmpmRDVKYinANVpsRzeCZ0EEgSy56aubBs4
	+6YziUcKS5IpyGO4j6tKz3mxaob3JXw==
X-Received: by 2002:ae9:e51a:0:b0:92e:e3eb:de54 with SMTP id af79cd13be357-936d201e8c4mr2337366485a.11.1786977699412;
        Mon, 17 Aug 2026 07:41:39 -0700 (PDT)
X-Received: by 2002:ae9:e51a:0:b0:92e:e3eb:de54 with SMTP id af79cd13be357-936d201e8c4mr2337361085a.11.1786977698918;
        Mon, 17 Aug 2026 07:41:38 -0700 (PDT)
Received: from trex (189.red-83-60-95.dynamicip.rima-tde.net. [83.60.95.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a7c57fsm4286397f8f.22.2026.08.17.07.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:41:38 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Mon, 17 Aug 2026 16:41:36 +0200
To: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
Cc: Bean Huo <beanhuo@iokpp.de>, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <aoMdoE35kN_GjMHp@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
 <al3-w3j2-E2twGZj@trex>
 <anNN4gZc9nvadHNs@trex>
 <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
 <anRVtmk7ejWewDX_@trex>
 <anwYtSvM4HjI2VLv@trex>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anwYtSvM4HjI2VLv@trex>
X-Proofpoint-GUID: hSC0TLHu1pf7LoGz84qDzdpqsVogxqO2
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDExMyBTYWx0ZWRfX7y3Ma7CYjK2a
 HbAH0pSTF9qtuByCrr77RGzsGUUwcRtHMo04g5D4CCEJD6uATFsOBw/Tk5WehGUfzkkkLkhAMpB
 Rqfw8ZtwOxwpT19JWn/CuB374cOEJj0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDExMyBTYWx0ZWRfX/PduO39nQimX
 ew5PWMdrV07s2veOgD2AQISC8WlmS/4uT4e8A2OLYYL+fDM7z+aReB8yYw8NHopx9xjAS6fIgGJ
 0IfmwIWQfRZ1E2DSOZgytHyi5teQnJYsJQSyIEBOhGVMT2uaBAyciWSFkhJwx0ouOchA4/HPAzo
 SL8btlR6VF8LCDHhDH+kLTDLr87AZCn1d//jOCYrr6MaEKlM0D99o2v9e2PScIv4+kzJHrisgF6
 X6t/jXFYw+ZhaCT6lfyTwmjfFS/O+BHB6TvQybMjyht9h0ySDTFhkAQ/v3m+t8JQRiwegb6A8lX
 OgcTPwJ0FjpuUvDUSzTn6iOASs4DBTP5xFltAwlO0aPycyom582fkN3Bg7EwnNhbP4uiSjFaFwe
 5ophxy4kdNiOUu54WKZuBeoO/EI82pLJwUaib+X1U8cLOsyrfDh8IzUhYlX0eM+YESfD4tOo+Fl
 9umuqsUJzE0DGkS306g==
X-Authority-Analysis: v=2.4 cv=HYEkiCE8 c=1 sm=1 tr=0 ts=6a831da5 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=kuURLP+TZHqixYhcqKuzcw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=NEAV23lmAAAA:8 a=SdeXVGCZM-LbOE-x2sEA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: hSC0TLHu1pf7LoGz84qDzdpqsVogxqO2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170113

On 12/08/26 08:54:45, Jorge Ramirez wrote:
> On 06/08/26 11:36:54, Jorge Ramirez wrote:
> > On 05/08/26 18:18:31, Bean Huo wrote:
> > > On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> > > > On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > > > > On 20/07/26 12:23:39, Bean Huo wrote:
> > > > > > 
> > > > > > This is very strange, coverletter is v1, but the patches are v2?
> > > > > 
> > > > > I messed up (manual edition of the letter) but the thread is proper
> > > > 
> > > > Any other comment on this set? Can we agree on the ABI change?
> > > > 
> > > > you can check the overall integration description here for more info:
> > > > https://github.com/OP-TEE/optee_os/pull/7881
> > > 
> > > 
> > > I would be ok on the ABI change, for this series kernel patch, patch [1/2] ok to
> > > me, just [2/2], I will add comment in the patch.
> > 
> > ok. thanks Bean.
> 
> could we follow up on this please? 


just a reminder - there are op-tee/u-boot patches on the fly for the feature that come together.
These changes are important to unblock

tia
