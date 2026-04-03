Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462743C3C0F
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775225847; cv=none; b=oO1Sh666awQeVCmV53Pp5efpsU56K0j6EDNdMpJBlRO411Y+S7ZbkSopwMJxmG//zWsvI/YLZWAE810fKkcZ5nMYrES/6C9H/H0/Q5LcfRlp8kaJopS5NPYDwozaQxJdO/W0dWn0ANbfFMMLCUUWE3m0Y6jDF3Wf1POSGX0LRc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775225847; c=relaxed/simple;
	bh=x1GMrzZmo29qt8wAIiATRsd4Ew8aTktyUtdtWzc8bns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIp3KGVckFMnDXRuKU62zM6hxKqCsJ156edDHexOrT19UnAQwiaGyxSLbKMFPrUtiEK/rUewyZsgTLan520tc11GAIk8b+XJ4YPGs54w/5w7qMXKlhS822ZfWuQucS5iTevRq2ZVMTPtHN4g2+WHIeKZFiGhzIkLFwAyMEZRBmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JdVjTWHZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BH5ixiLn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JdVjTWHZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BH5ixiLn"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6336JUSt3772540
	for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2026 14:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5gzzElj7aj1o4ak21+gPFFPTZzAOuQGBCbltKvS4sOY=; b=JdVjTWHZhnX/UUTs
	US/THmy3mz2Xa8Y2GMeul+tYXJQVpgljkJE9SbpFpUb1v/n4a26CXodZsXV4morx
	f2jBz9GJ50hx+L7u9KYSkAKzUlDX0odKG2mQ5pAnv2P5UBInmtshHlL+8p3RhjnA
	TeZSHgE7QVhS/215Bu92zbv87M9mDFofgjcM7jOjXdgV9ULnhdHak5N3LhCGhjSc
	VV0xyQWlR+RhUkJOvtgPfmZvQiE9/2Ix2vdDB7u7+Wi8TMvk0wxXY+5YPCdzgSqj
	eFbaSlMCPNDFHADUmbTblqwcHGWvUzHkcwDRodCcbY9Gv7hbQvNgMpPnwwg3B0MR
	lNIN0w==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d9wcs35yv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 14:17:25 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2adef9d486bso28358535ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775225844; x=1775830644; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5gzzElj7aj1o4ak21+gPFFPTZzAOuQGBCbltKvS4sOY=;
        b=BH5ixiLncUHMnAHNIYIOuQoCUIH+KxoXKgsRSWPLYXMPJoA1GTmDAe8XsOqXawAayv
         IqWW44SqeLVvdx+WWzpYb/OXG9MGCvkewJWn0RSRALXtNj43RRYXaOOLA7YjGrw2NANT
         FLJDwx0jGhv022qsB7K/IRNXtUXSAzkKIxe9ekY38BTFRMlw/vFBOQSzPPZH/bf1ZTeP
         D0kl4ja/6ugYBe1pVZ121sIZktYuv/vIooFxVbqUE+cuQbDydWJVRMad7L1G3HI6y8E3
         VXpV5mO/oCXS5IInLra/XfxWzROMCBA12H/pdFR+asye7WrfpUJZMayfANaizvIlWnz3
         F2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775225844; x=1775830644;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5gzzElj7aj1o4ak21+gPFFPTZzAOuQGBCbltKvS4sOY=;
        b=eGvIROuinui1qOyp68qvlSN0MQknqKknd1I8Z5mZ1LM9gE7504gattcjLxA/2r2Hvk
         SpSznBRYD0J+u+Oxyh3iWL+x678c0SwisbnBpn59Lr36UolRS+dvlQ77ubKynIDe+7vS
         QVKBAYz8hA9zrwW7RgMRQ5kWGA3p8wAcY3BsJs6kFfDkxQmloxw2mFZ+ddYxTYwiYAR6
         Di6MMmK3sF4lAkrsvznWtS5scv5fAWowNxGLlx1D55DXUb9GcET6+3iDwCXgS64le4vt
         fkqwKML/tVneeTZ/Ubyzn7oiDXGtCPmJuPeYVVrrYMrNMgDhCkmqKXXdg2h7AhX9nlF9
         0tTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5cYb/4T75pKYKeVK4PmkNii8UgbGfqIK51jxLvVYSFZP7yUaqelvmnIH571aZp/FFZH3dW6P3LPF7@vger.kernel.org
X-Gm-Message-State: AOJu0YwsxDE1QmMirdseh3Vdwi9QbHjhnAicklOOOrTQd5f6Dw1f+FUh
	7JrwGQRsxLcqbzVUS/FJZ4msQEGox4WfaaAzUusjeZzWwMERxqYNgrdx8g6HFC+CeekRUXDFwgs
	msYjbdEhGE2eF1BTB2VJE5Bj1ZuI686RyK+O1hmR01eoPVn9FPZArCHa8f1HxKstm
X-Gm-Gg: AeBDietkVIkDsQlerBjr6d/KXdpLqaOyiWur7LWZ4LJfDxPHOTws1CeBveSpvbalQ7I
	8Zq8Tfl4HrR++3V4PDaSoDI9kwUngZvwdBUcJpxBctEsEoWrviBGY1wsoh1cGwOVJWHGZRVe/zu
	HE78LmCknhmINmpW/W24iceYV/SOr4IncCcaGHv3XSY+lKPS3UOt/AQUGd0mHVGtP5nE9p7ZDMr
	Vmg1htc5cOZTPj/Z2VlQ3cKZzVR+JjwvPxCKTai66KerARYEE+v999F4hrOxAfu/RDqXdsh7nAB
	CtnU8quxPPIC5HyaPIfjVE+6CPegwyRTY4YxvFYPClckccmHpz9/1hBDZSO9iRtW3D0e1H4KXuQ
	/WdNPGDI/zzkK0I3C8JUay1yoDmYDusS1l8PGlUs15ojPYjFdlQ7nOa2tOqE=
X-Received: by 2002:a17:902:f552:b0:2b0:7d6f:4627 with SMTP id d9443c01a7336-2b2817ad6camr33018905ad.37.1775225843848;
        Fri, 03 Apr 2026 07:17:23 -0700 (PDT)
X-Received: by 2002:a17:902:f552:b0:2b0:7d6f:4627 with SMTP id d9443c01a7336-2b2817ad6camr33018455ad.37.1775225843132;
        Fri, 03 Apr 2026 07:17:23 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749c38adsm75917555ad.69.2026.04.03.07.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 07:17:22 -0700 (PDT)
Date: Fri, 3 Apr 2026 19:47:15 +0530
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
Subject: Re: [PATCH v7 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <ac/L6y5B+6SyTNuE@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-1-669b96ecadd8@oss.qualcomm.com>
 <a616c056-f9aa-420c-a543-7f1539e9e886@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a616c056-f9aa-420c-a543-7f1539e9e886@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: tzN1ql4LjGDHeJrPjLVwq5meP-2J18Gr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDEyNyBTYWx0ZWRfXybtvPw0WXZN2
 JAPQYsgDYJ+DkdvSrbxda/4lelr2fJ2ZKPqcII/dNrCw9HS3rsLapNX2oFfKugaCUju4lxLvSAP
 +zee5pDUYDz2Z25oE7FFEBgv9a3QZLpYjUS2W1a9JAzGNCJHdAx2eigNPgo+lmb0vA9bbi4ocmn
 WoPhyGmyzJQfhH/OF7J+zWlw0HW91p92sr5ybbj9j3zqc6E5YIHeOvssDJd3WS7ixKhvPGwn/la
 /fQfxcXJZqvl4GDNgDEhIY93MRlfCXmC/2wB6YbY91Mz9qPWpwDPJMcp20oNBTiPodim5ufA37L
 HLTDjxo/WEVA48G1HSZ6F6igI8za6cVaqmyKECcMtGUSCeEnfr2GwhnQRUDw3t5ngAfXN3INk0J
 JFJH1aiqS0+ffwBIzoY7wRNZ23cEz4e5eVP02kkub2xpmdkGFmhqm0xIM1wlz8Pct3/lzoVlqUI
 HKDYtuhoI4F5jE5rrjQ==
X-Authority-Analysis: v=2.4 cv=ZuPg6t7G c=1 sm=1 tr=0 ts=69cfcbf5 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=32UUs-Vz8nlSIkZsdJkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: tzN1ql4LjGDHeJrPjLVwq5meP-2J18Gr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_04,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604030127

On Mon, Mar 30, 2026 at 08:09:35PM +0530, Harshal Dev wrote:
> > +/**
> > + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> > + * @ice: ICE driver data
> > + * @target_freq: requested frequency in Hz
> > + * @round_ceil: when true, selects nearest freq >= @target_freq;
> > + *              otherwise, selects nearest freq <= @target_freq
> > + *
> > + * Selects an OPP frequency based on @target_freq and the rounding direction
> > + * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(),
> > + * including any voltage or power-domain transitions handled by the OPP
> > + * framework. Updates ice->core_clk_freq on success.
> > + *
> > + * Return: 0 on success; -EOPNOTSUPP if no OPP table; -EINVAL in-case of
> > + *         incorrect flags; or error from dev_pm_opp_set_rate()/OPP lookup.
> > + */
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> > +		       bool round_ceil)
> 
> Any particular reason for choosing round_ceil? Using round_floor would have
> saved the need for caller to pass negation of scale_up.

There isn’t a strong technical reason for choosing round_ceil specifically.
The choice was mainly influenced by the earlier discussion here:
https://lore.kernel.org/all/15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com/
 
Also, this helper isn’t necessarily limited to the current caller.
We might see additional users in the future where the semantics align more
naturally with flags like scale_down, which map cleanly to a round_ceil‑style selection.
That said, I agree that using round_floor could simplify the current callsite by
avoiding the negation of scale_up.

I don’t have a strong objection to switching it if you feel that would be
more cleaner for now.
 
> > +{
> > +	unsigned long ice_freq = target_freq;
> > +	struct dev_pm_opp *opp;
> > +	int ret;
> > +
> > +	if (!ice->has_opp)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (round_ceil)
> > +		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
> > +	else
> > +		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
> > +
> > +	if (IS_ERR(opp))
> > +		return PTR_ERR(opp);
> > +	dev_pm_opp_put(opp);
> > +
> > +	ret = dev_pm_opp_set_rate(ice->dev, ice_freq);
> > +	if (!ret)
> > +		ice->core_clk_freq = ice_freq;
> 
> Nit: Follow same error handling pattern everywhere in the driver.
> 	if (ret) {
> 		dev_err(dev, "error");
> 		return ret;
> 	}

Ack

> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
> > +
> >  static struct qcom_ice *qcom_ice_create(struct device *dev,
> > -					void __iomem *base)
> > +					void __iomem *base,
> > +					bool is_legacy_binding)
> 
> You don't need to introduce is_legacy_binding.
> 
> Since you only need to add the OPP table when this function gets called from ICE probe,
> you should not touch this function. Instead, you should call devm_pm_opp_of_add_table()
> in ICE probe before calling qcom_ice_create() then once qcom_ice_create() is success, you
> can store the clk rate in the returned qcom_ice *engine ptr by calling clk_get_rate().

This was added as part of the review comment from Krzysztof:
https://lore.kernel.org/all/20260128-daft-seriema-of-promotion-c50eb5@quoll/
 
While I agree moving this to qcom_ice_probe would be more cleaner without needing
to change the API, most of our initializing code for driver by parsing the DT node
happens through qcom_ice_create, which keeps qcom_ice_probe much simpler.
Please let me know, if you think otherwise. 
 
Also, I don't see any reason for moving the clk_get_rate() logic to qcom_ice_probe
though as it will not be set on legacy targets in that case.

> >  {
> >  	struct qcom_ice *engine;
> > +	int err;
> >  
> >  	if (!qcom_scm_is_available())
> >  		return ERR_PTR(-EPROBE_DEFER);
> > @@ -584,6 +640,26 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >  	if (IS_ERR(engine->core_clk))
> >  		return ERR_CAST(engine->core_clk);
> >  
> > +	/*
> > +	 * Register the OPP table only when ICE is described as a standalone
> > +	 * device node. Older platforms place ICE inside the storage controller
> > +	 * node, so they don't need an OPP table here, as they are handled in
> > +	 * storage controller.
> > +	 */
> > +	if (!is_legacy_binding) {
> > +		/* OPP table is optional */
> > +		err = devm_pm_opp_of_add_table(dev);
> > +		if (err && err != -ENODEV) {
> > +			dev_err(dev, "Invalid OPP table in Device tree\n");
> > +			return ERR_PTR(err);
> > +		}
> > +		engine->has_opp = (err == 0);
> 
> Let's keep it readable and simple. engine->has_opps = true; here and false in error handle above.

Well there are 3 cases to it:

1. err == 0 which implies devm_pm_opp_of_add_table is successful and we can set engine->has_opp =true.
2. err == -ENODEV which implies there is no opp table in the DT node.
   In that case, we don't fail the driver simply go ahead and log in the check below.
   This is done since OPP-table is optional.
3. err == any other error code. Something very wrong happened with devm_pm_opp_of_add_table
   and driver should fail.

Hence, we have the condition (err == 0) for setting has_opp flag. 

> > +
> > +		if (!engine->has_opp)
> > +			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
> 
> Since OPP table is optional, I don't understand the reason for requesting the user to add one.

This was added as part of the review comment from Konrad:
https://lore.kernel.org/all/15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com/

OPP-table are mostly optional across kernel and I guess, this warning helps developers
to go ahead and update with the OPP-table.
 
Abhinaba Rakshit
