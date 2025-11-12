Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F772D5A14
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928782; cv=none; b=FMogEaB1V5f5CWVP1k5ae6jK9dz/hwOWtu8BT27kSnItn7dbcR2APVeqp8jenGX1lQLz1EOSf1xi43zX3Qt4H5gG5Fg7tDNxHlWm9INkkYRnXdO1pypWt90/+5Lz9LfwkixM2e9efAAjd+whOb3Iwi4RJc34+YER1Q+AW8X7FCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928782; c=relaxed/simple;
	bh=7cNsMy0TilUH2idBCaLTV0/wx4B4LwinQE6xmQeQ74I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJ7va7jedjvmwiugU+HZEkErbtSqsWUqkvPbIC/cJBVIDy+jUDdY0Du09Qqt8hjiSzsyDsOjOr3vwV4OHc8PiQCjrjvqQb6H8F/W2Mb4j2xNC/F5WObkuN9hQAvY8c3eQ4tQ5GGQHQuVVvvB174eBdX9uxXSlShHdH7ZFbYJJIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JazUFIiu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kwM8tqYK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JazUFIiu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kwM8tqYK"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AC3HZLn4053645
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=DJ2gU5bCjGTpIsiHGccNxiCb
	rIQ97KDbuRdyIzahWDs=; b=JazUFIiuuzfaacaTw7dr9rK/xPZ7LOCPtZV0WbHz
	OQ87MZZ9aUw9Hednlk72rLLka8qH20ZzD71Dpgjve2Zb7zwa3x6JmiQt7dKyrS/S
	LfyOs71mC1tOFvak3n1hSk8oYu7s/tA7D3B/FQrQT5Bap1V6xjXOnaATmYrYg6Nb
	+NviipPD3seekW1GSwzQ9IObs7r6dOw2XFWuhS+rLNFMZ+fQW51WJK2s/PAoV1/q
	KOklJrkom3NP62rvr7T1jQmxJ2nunWf7MXf9tMbztyroCBEO3WYkTwNO5XGnn/Zb
	mBRRLxyzDq6jgnTvxgFc0VUsWyyWT2cJF8fiR6ChC7nCdQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4acj6v8fbp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:26:20 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-295952a4dd6so5743625ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 22:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1762928780; x=1763533580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DJ2gU5bCjGTpIsiHGccNxiCbrIQ97KDbuRdyIzahWDs=;
        b=kwM8tqYK6lKVDueNN/ZliYPFkb8CKOVfsparR6nxQa4c8sfQQVrNBr6W7c7ga2G3ne
         tuF/QwDWocMkbqWisBUq7XNM+KQeWFgFuNIhhGh7Aiyq3ckrbY/sEHnxTHHjj8CH2AN9
         f36ckYgXh8gw0q6sFeLk5rcIoabXm1VTqjTYkr2a1/VwYXGA7WAEKbu/kI75nXdoAcTE
         Ldh7ik3zA0BONa8Svx00Ph5i6igTl9Fqy3/tYJebsQPpPjlf2jBhjCX7yuvmSTWHh1fZ
         hQzvfQRf243C8XUGLvhB/WvvemAG7LkCBNfvVszY2GZu6SQq7JLSKi+H8CDgKR4iFuay
         bDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762928780; x=1763533580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJ2gU5bCjGTpIsiHGccNxiCbrIQ97KDbuRdyIzahWDs=;
        b=lcbN1cf2yJEw/zBBY12q+H2Y8IHUzXIX8Wwy3WRDRvfkCHY4bl8IJocn4J7PgFfeVz
         hHYAEkHDMCIBYpJ3m5x1qk9/ngxwCMRkv//tDOV7wAZKaVGgoyGj3wktw8xDUxQZgE+9
         DwxcCBnHNRK6z+a7TQLWqu2KElbGoFybdgHv82BhzUiGp2gned3hZTBGJvjcaVpRVh5k
         faHUggEge16UiWPRnLNZj+3uvINK41H/I7XphDROM3/ncor6VEVCzoXfWUvHB3VvIuKC
         WYpcrSHWwzGudtFdWkqM/hZjRewH4KphpErr/ihGe3y0sl2onjamNJcsQYH0uRK435Fy
         kSzw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ8SEyjdcD3cJ3GcdyMe3Be6J04AS1HK9rd01zUEV2uv6h8sZcPRXPFcUxIYfxCt0K2qU5w6Hr6chs@vger.kernel.org
X-Gm-Message-State: AOJu0YwG0WD0OBbRT4xwoJvC6uxkTotIO4whA8gYzXhfquidSn15Gkr7
	OpDDHpBvX1CvnHRWFU7FiHB/Kk1s6AVdy0EGexuN6XXeAEQOGSGItZaTuoPAE5uoD7y5/clms7j
	D+Jf+uaBq7Hq9Cy3JG+ImfprAmY7rK2RF+mee1oDBAVO99OhHcyXOu6yp3XtewbQ7
X-Gm-Gg: ASbGncty727wI9LR0GW9tr3AWgJKaP9tcJYxDIMPcJAAIMWpFQRbMh2lS6AipvV/yAx
	kNeCifM0afRODxVZGSb/1XfVtOmGJ4eaifiGo4P2+NY2CkbYdBR1nV32DIqvYpWJKU/JjB6cZnL
	Wc9IzZ5MtRSKGtoPY7kKv6z6lEAKw99FNbVKj16p9ujK2kIobQCuZHszMr2936lJz6VV+DQ7KcF
	+3+jRaDqI/Iogj8U8XAISHzxNqhM4foNzM300JPnZg+FydGdKrZ4zhAhmEMe2nWuq+MHl8fkbxJ
	lVlzOAZOwHI3H4qkUjnfLN0xm8ZQtud4j5qYMC1fxYo2PREP/e3w0aiFOcCjs96jOfYGEjueMhu
	09vs6VT1zTTOFFu2KgkpyMGGwSPY7fGwzuq8X
X-Received: by 2002:a17:902:d543:b0:295:99f0:6c65 with SMTP id d9443c01a7336-29840b4b1dcmr73920475ad.30.1762928779717;
        Tue, 11 Nov 2025 22:26:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdPYGS02Zp2ukMNxCKwDxvQGW+xbsrHTAJZPviBeLRtQAtKBwye+kN8OTi2mmGMSLVJJUS0g==
X-Received: by 2002:a17:902:d543:b0:295:99f0:6c65 with SMTP id d9443c01a7336-29840b4b1dcmr73920155ad.30.1762928779205;
        Tue, 11 Nov 2025 22:26:19 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e1cdfe29sm426981a91.3.2025.11.11.22.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:26:18 -0800 (PST)
Date: Wed, 12 Nov 2025 11:56:14 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] ufs: host: scale ICE clock
Message-ID: <aRQohlIVrU971aKj@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-2-ec956160b696@oss.qualcomm.com>
 <w66a6wfln25o7h7gublrnit5ky33s4vkhbf6jvwylsl4f2n2ou@kgqr7g45a5an>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w66a6wfln25o7h7gublrnit5ky33s4vkhbf6jvwylsl4f2n2ou@kgqr7g45a5an>
X-Proofpoint-GUID: g1gqEunl5z13SFADCLYAOSr1gMGYpcKv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA0OSBTYWx0ZWRfX+2620q80GqXD
 QIFlJcF0DnYSolgZgBWee8j9U1kMEKpdTModQ+grC8aDXFgp6hkXLim7s2TCBh5bAyRrKVQyAzZ
 bjSvkMFkiP/m2IbOq198Y33qh5Fk7quJ33oXpSevIzC6JNVX+7jMRZBggoqO4Ixd1WYVX6dK9F8
 InhBHxoig+qm74vKs2lqO6V4/qPIh9xfJjIjdWMk943sGhThEbAoo8pj558CKcx8viv0RJZLL95
 xr7D6NuikJx5UEcWwgytDZHAKqrqwMHprAU/C7pfvXFkqjS4+3neID5Evx7Oh9oUsSb1rNHIgCc
 svwss86JrDEz7LJSuiiNPPVTXWI8UlIiHJ2csCwcXmpeHWF2/+A8GeWCRX+7/Z2maSofCqY93Xj
 Qed6rnev7l8kDQvrTSUIh2ebZFWJUw==
X-Authority-Analysis: v=2.4 cv=f8dFxeyM c=1 sm=1 tr=0 ts=6914288c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=fj1KHxAH09wAVEZJ720A:9
 a=CjuIK1q_8ugA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: g1gqEunl5z13SFADCLYAOSr1gMGYpcKv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_02,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511120049

On Wed, Oct 01, 2025 at 10:15:27PM -0500, Bjorn Andersson wrote:
> On Wed, Oct 01, 2025 at 05:08:20PM +0530, Abhinaba Rakshit wrote:
> > Scale ICE clock from ufs controller.
> > 
> 
> This isn't a good commit message.

Sure, will add more details in patchset v2.

> 
> Regards,
> Bjorn
> 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 3e83dc51d53857d5a855df4e4dfa837747559dad..2964b95a4423e887c0414ed9399cc02d37b5229a 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -305,6 +305,13 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
> >  	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
> >  }
> >  
> > +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> > +{
> > +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> > +		return qcom_ice_scale_clk(host->ice, scale_up);
> > +	return 0;
> > +}
> > +
> >  static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
> >  	.keyslot_program	= ufs_qcom_ice_keyslot_program,
> >  	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> > @@ -339,6 +346,11 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
> >  {
> >  }
> >  
> > +static inline int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> > +{
> > +	return 0;
> > +}
> > +
> >  #endif
> >  
> >  static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
> > @@ -1636,6 +1648,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
> >  		else
> >  			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
> >  
> > +		if (!err)
> > +			err = ufs_qcom_ice_scale_clk(host, scale_up);
> >  
> >  		if (err) {
> >  			ufshcd_uic_hibern8_exit(hba);
> > 
> > -- 
> > 2.34.1
> > 
