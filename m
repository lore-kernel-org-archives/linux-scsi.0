Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6253328FC
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775239889; cv=none; b=sLqQPw0bXxe8HHvbNIOZ3GOkpVXwY7YeWL9bSOtylDEvZyu2Y0byFnVZ+LHpkNQwynH0Yh9Yknr5JAwYYbCLChofvhCm0d7ndCS/IZcePtX9pYfkeoKzffkXQtuSOfqrrxAetmO3xHzp3M5BXp1nm8EPK449X9LnAnineXRi2d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775239889; c=relaxed/simple;
	bh=DzF10D1I+97HjEWxl98Cbs7hOuZlV88rFUr6Iuk5fP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbYeVUqZ6YyPzfXC+2psr6zKHRDdmgQJp/4p41cchHLko5dF8FpVQR+B5nWV8zETtnFGKbLNs14V1c2ny+evFinDDui+l4YskO7v14KUrXNJezq+I2WBHPnqIZxqqMxaOW96lhqXtgeCTMkz9Nd0KuqL62xik5XC3VtrEDxGAkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BzYT7Vpn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=grb8NrrZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BzYT7Vpn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="grb8NrrZ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 633GITmR3450759
	for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2026 18:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MtXL2iAOtYsDXiVQNN0H4B4e
	Un0PA2AWtcephXdhd3k=; b=BzYT7VpnNaCzbAEeGMJLxOEOKCN9WybmxMDCSBgl
	tm0MnN5zuc3xv9CpIfjdxv/vl0gFwfGTGNYgOtqm/685l3EscBg12euGOX14t8yV
	34uhKLoV+ADzKfwBj4rb2n8WaaiLMGuQ+n8lFQ/5y8wt3Ij9VFR7SRWWv7+TG6fG
	RxvljS8da59o0N+PAImzYAjF4vZbdL1TlGdMtokuieoxxfCG/s3x9XNVOED1uIEf
	ZEQV47/zgStC6+c0avfZ8DQN9BmnaSfKniwYhMW57KpA9BFVsHdchTuiW59jeBK2
	KaQ6cgOnpyRyLPiPmS0k4Ha2vZGu68ifYnaKbIPogeFoCw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4da8u59usk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 18:11:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b250d3699aso53323565ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 11:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775239886; x=1775844686; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtXL2iAOtYsDXiVQNN0H4B4eUn0PA2AWtcephXdhd3k=;
        b=grb8NrrZhbEaybweaS1xEyUYbkM6fAam/VVmhHtfVXSzbQewCeeSsr0+bHS6Zi/wKU
         5fzb3gB5p0Ds+3Zyb2kmQYsvXK/MA+ijUNcKheo+RuUdy6SjNPWfLG0+7psHyRO08Ran
         KU+FeTPhI8Dels3XFDjQD8TWssBHwoSlQc00HgRds4VMDKMifXu1FaqvLzhHhrjxyYxY
         ZV1fj3dF8WfFQ6y0yg2UDWDzlD0CnpScE8isuwD6RhvmhHtucY9D185zrOaIu9OGQ0PD
         nQDsLnN+wD4UY+13B1jnqtzezZmDp9q4dEnzR65iAt88rm6+AZcBkDPdqCJLSlpUVEOa
         KN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775239886; x=1775844686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MtXL2iAOtYsDXiVQNN0H4B4eUn0PA2AWtcephXdhd3k=;
        b=HzbGVcyWhj6jYZfgRAmq8hunW1k8adL/8Fg3QW4OCzYCvpv3fgn3NU0GLqm4PfRD4H
         DdTtwBXk/b+l7sekVNaWwib1piT6og/88rgndEgP44pj0tv+3mkYY5RIIFnGEtbK8NJT
         TTc0S8mHGlQHMAmjGa4BGAk2Zj6s8Xn8QojOHAvcKKHN6B2/77N/3fvmdZbotZjgbjNa
         PSS7DXinUpU5p1mgdKbIBjDv4N8qv6YcHOjV0Fnt26uB4xLqC+QPCU/NuHs1rCiSojAk
         MyiU/hXT/DS8Pe4D/AkIDbxAW77LiglIjrez3Q0YYj1V8B6tkQZEq/b3Rqn7sU96Sq/p
         pLEA==
X-Forwarded-Encrypted: i=1; AJvYcCWwaY8LJuMDfnHxwWjjLL3GJgjzExhZl+v/huUOp77Tk1AQiV0m11LH5p70MlBWC6za0r1Fej1sD5Il@vger.kernel.org
X-Gm-Message-State: AOJu0Yyawp0E0UxqP+tPMhDj1D09xCzB4Coo2PJ/xo+cWIPUUFFydB8j
	7msUTljWRAig9uKFJ+LUZm7qmN8kTeUt1aShpqO8vhCDXiPomXhHK3mfJUJrh9ewRDlHoSsDvfe
	bv4XroHf717Qj7HUsiD2zUqn1+SsE17bMnh6HGfoOLagVubu6zfPaglC+XIPk5IUD
X-Gm-Gg: AeBDieuvMC0L1yBrNzXKdCCeFCazbasGKrpJu2XjvDs5GlY2VHMlNhYMC6DZDv3zB0S
	HXPwRzmirUQ0fKsWRkyczn0kKM2DHSGZn8XueRqsM5wrgO01esb99T4Y5pqsPyiEsTzIgpUeNlP
	EzDFEyqZfzWEIVdsSWjYuuaszFH+hIgS5IZqNlnyGefjeRmeaVJS0QN1PqSDInz9A1ffnOqm+1a
	vOR8HRCnuxX5loFI88M2/i3vSkuZbhghNWLQC36MSIyXuEA5K42hAnsfU4cLkVpwaONORt1cd3O
	VA6QfiHRq5OsQcU/WRRM4KvH+b1IoG0b7ogNBrJL9uo02n5zEubnqk00gLfsJFui5/dPwOHnyS4
	LkakBBbx36BlBCH/DWZlcQJ0DCqIPREirWA/II1AOaO+O174ChbCrWCjb9lI=
X-Received: by 2002:a17:903:a86:b0:2b2:4d78:eeb4 with SMTP id d9443c01a7336-2b281779e2bmr40739995ad.22.1775239885857;
        Fri, 03 Apr 2026 11:11:25 -0700 (PDT)
X-Received: by 2002:a17:903:a86:b0:2b2:4d78:eeb4 with SMTP id d9443c01a7336-2b281779e2bmr40739785ad.22.1775239885297;
        Fri, 03 Apr 2026 11:11:25 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478bc96sm65435615ad.33.2026.04.03.11.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:11:24 -0700 (PDT)
Date: Fri, 3 Apr 2026 23:41:17 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
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
Subject: Re: [PATCH v7 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
Message-ID: <adACxdpwJOt92qLd@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
 <7fbd9d3f-a313-40dd-9335-799aea5a077a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fbd9d3f-a313-40dd-9335-799aea5a077a@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE2MiBTYWx0ZWRfX9VY17uG8cOxz
 nJ4yD0XIOKVmjR3qbznqWGA+7vbwM2i9/LSCC4Ajl4ThtMyP+XQBBfv18G4sr62FMNPcMdZzSVT
 cnf09cFdJR0RbF8K/AbkaItNq+CWg1h7EVNGKJMn3LGVLGoriWyYxEEUTrCPmVO9p9VKnEkhEJI
 YcWYM0flcPRxDXaPm2PysGL7VqA722kXTaoKzIKca+Gl03J5TwNK6E5MtCGTAeVWgWK7L8xIm2a
 9wBwipniSa1XLzw0wjHN17IQtoz0UJsz/GRWsgkDO4XzGBx8m14I/ybQZ+8cGeyeI4UPHc9cy5/
 FB+Zqzb4rG/4CvVkSK5rpUoub/I5ZqS6LabhaV5ZTnh6ffjme+co64bIUtOZBiHjVWmHlQ5ICIl
 FCdOjT5h9PwV0LmgHsq4eXncyjo1EikfFuciQlWTAxSWXxkbx89X03bYjwBfynsjZ1cFdKDRDoK
 tpXNMbnSJlqrRWbkXfg==
X-Authority-Analysis: v=2.4 cv=W5g1lBWk c=1 sm=1 tr=0 ts=69d002cf cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=wPS2iYinNOdQAA01N08A:9 a=CjuIK1q_8ugA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: fDECKUU_LJHfU_xaiJ-wx3QsNun3AjjO
X-Proofpoint-GUID: fDECKUU_LJHfU_xaiJ-wx3QsNun3AjjO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_05,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030162

On Mon, Mar 30, 2026 at 08:09:51PM +0530, Harshal Dev wrote:
> >  drivers/ufs/host/ufs-qcom.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 8d119b3223cbdaa3297d2beabced0962a1a847d5..776444f46fe5f00f947e4b0b4dfe6d64e2ad2150 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
> >  	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
> >  }
> >  
> > +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> > +				  bool round_ceil)
> > +{
> > +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> > +		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
> > +
> > +	return 0;
> > +}
> > +
> >  static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
> >  	.keyslot_program	= ufs_qcom_ice_keyslot_program,
> >  	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> > @@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
> >  {
> >  }
> >  
> > +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> > +				  bool round_ceil)
> > +{
> > +	return 0;
> > +}
> > +
> >  #endif
> >  
> >  static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
> > @@ -1646,8 +1661,10 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
> >  		else
> >  			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
> >  
> > +		if (!err)
> > +			err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
> >  
> > -		if (err) {
> > +		if (err && err != -EOPNOTSUPP) {
> 
> Using -EOPNOTSUPP here works fine for now. But anyone touching any of the lower APIs called by
> ufs_qcom_clk_scale_up/down_post_change() needs to ensure they don't return -EOPNOTSUPP, otherwise
> hibernate exit will be skipped. So this carries a minor risk of breaking.
> 
> Since regardless of whether ufs_qcom_clk_scale_up/down_post_change() fails or ufs_qcom_ice_scale_clk()
> fails, we exit from hibernate and return from this function, I suggest you handle the error for ice_scale
> separately.
> 
> >  			ufshcd_uic_hibern8_exit(hba);
> >  			return err;
> >  		}
> > 
> 
> Add the call to ufs_qcom_ice_scale_clk() along with error handle here, and let the above error handle
> remain untouched.
> 
> 		err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
> 		if (err && err != -EOPNOTSUPP) {
> 			ufshcd_uic_hibern8_exit(hba);
>   			return err;
>   		}
> 

Right, I did think of this later.
Yes, this needs change.
Ack will update in the v8 patchset.
Thanks.

Abhinaba Rakshit
