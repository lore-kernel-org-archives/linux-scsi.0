Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2343C988D
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781172809; cv=none; b=RGz07KnUXfWESdacxQwZmayKzzoOaeomem9mm5h8k3otLloRL7bnI6t6ohIXyn+iF4Es0UqrI1Voe3Ux3p4z46y8eJDfJKbZqpHt2JBpeuGeBCTRd7eXj05nxZoD6lo/seF03roueZcsCSjmuLmcm8AG59eHWmnHDbjHPqavZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781172809; c=relaxed/simple;
	bh=YDo8f7tzdscheRFFMTexaBZIDM1fKlLwL+kHTprN/vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMh53gO1naiMmAAszgV3q8cjJgLTi/Jv0x8PnxKcYuRKwz/S9ZIVmCbU6GrO8niifNJgGPCVNjtLkhPD71wwWu9PxeAVfqTTbnV9gDsKOoIQBpTf3q4+L367V11MFlsuQUVWNORZ5WNKt71eSa/WHnyHf5iSuphZLPA5gw6QJn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j2mQREcJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=StFFehpg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j2mQREcJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="StFFehpg"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BA0pY3303964
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 10:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Bh0jJTozn65zI8Feh54vu2pvrCDOQPSqIdgZRKqSjj8=; b=j2mQREcJVGn9U4G6
	cLCM2mYvAT/tC8YYRfzdt76hyaQaOqS4vG60pd5mjHFIKBSCKWkCTE7CpHmKNa5/
	TkqDmyE2QAkqH9IfdMPqAjeG1pjxbojsEm9PsEB0tBu6rwo7gODMbZttthQnqgOV
	MKYkrO7AmZCmM43aSSJq/jZ2o2MOjHNPVC3+ZvVhfCWUlHGrtDPG9yfdihu5lQ/Q
	LGBI7xZbF8+0769YLIh0zDdkImUDf8NzEWujpa+PeW8zNlfKSXSVbwUR+6+xe9fn
	TV4Ugfn4Hxr1fVFSj+Y5KRIuk1+iUge31Ik8oHikuBOwF7Ku9o5EbADHkHNyv/rh
	ssNEHA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqtb5g6de-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 10:13:26 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36bba9b849dso7276725a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781172806; x=1781777606; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bh0jJTozn65zI8Feh54vu2pvrCDOQPSqIdgZRKqSjj8=;
        b=StFFehpgBRBdMoK3HazK2jNH2SSu0KegNXYEs/Fc0BHfok6O65oXcCiMEvf5OwG0QM
         9aNen2T/TmxYE8uJc4kXih+vzss9ySuUI81R/4q8T909QoRnLHRjCoiHi8WwoC6/iUJW
         DAnMLqSUHoFymVr3WDsg6PXQllihY9khnfYL4UvjUlxrIvi2vr29zbwqZVYr2oOAk+UQ
         q1VA2/ed2EYp4NIuU2GI8i3jJWWOyfMZm+3HxV5Yj7aUMDVy3fLTuq223rcLHmgK/Xxm
         213/O7tn/ogpSsiJfipFSEDrYt17HfelEFfEyle2ntZnOFC+k3vnvvumkcY3RyNxBsj2
         k/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781172806; x=1781777606;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh0jJTozn65zI8Feh54vu2pvrCDOQPSqIdgZRKqSjj8=;
        b=P+avFVM8FIW/Hj6r+raBwO6siMx5AETsBD67X8kMOBM+COM8lN0uOaAS+6t3UWKcpf
         xq71tLQCTB6ZgDRDoxiTDt5PAoWGn7GmICXg0wzQ/C5NQbWj2sVFRaBdkKSrJe0MUj+b
         trjLSV7Vj1zHRTAh998aHPrStJ5su03UnTGqZltGQYwNwLW0Jc6WQtdxy9AqWIhBF96e
         Nw5z2SQPih0WUXXeIsp++F7SFumZnqMe3mZ7BDaGisEZekzsgL4hVsPaMNLeyqnjTh0w
         rRo+5a4u+mhFQ2OTjCPQfwcuCy/UwvaSOQzBljZUe3gIIqmu+lDtPP8mVm1s0KV34kJY
         j8vg==
X-Forwarded-Encrypted: i=1; AFNElJ/fstS2hRjf8x5s0vzelDxo6xrRYeCpHDE+MGgjUXA2N3An9lAgbArRp2HffYE0kmWwgmlhkmetNOue@vger.kernel.org
X-Gm-Message-State: AOJu0YyfgjgonYwv89kclk2h3VKrTgNrI2wu6+QWZnt2nEqh43Zrqp6/
	f+hAwz//eR/hxb8Sh4STmZq81COphY33l4s9d7+U0T4Ikqeu4CNNI+mg0BAmI+NelMGPFowWNgl
	pawX1ZRIO5NM289d6PGqDRu4E1n7q5z1cCcPwdRUOtBP9EmqPL7TxAHE5NO9q2rne
X-Gm-Gg: Acq92OH4e3kYCbyLc1icKGxTOxB3lZDG3Cta+AJ3NpAjv3lSo+r8SByoJw/Hbf2iOHJ
	rO5S7Y4ZZLH5OLUeK/0TYFrmBgzXSnU7HU6POKWHtJ8PLz3w2FbAU7E1LhzB5XL0E9tKoLJrz2l
	bX1pWBQ39fd4SN1FZBXWgjiCDlF71UWz9dJWftluoMPBKiEas0ZE5SjjTHJajuAy0OTlC/HBc+Z
	c4F8K62psKB+/CobK08kLpkd4MtJdnktJUtgocqKGXl9kLsd/FoNpAaw/arZV7x7Psn9ynD5rsQ
	dIzsoIxCTV1wAa9YKHsshwAB6phhR49fINCpHKL3kDjTDrBSKOGqAKPfPcfGtqxK2U2vx5/51Aq
	ykKrS1BfoVtDsfR7uY7YRJHt8Co3dmXmBVs/XidlaC963XNbP2yaiYGfkCu1ze08S6MPXOQ==
X-Received: by 2002:a17:90b:390a:b0:36d:b818:f848 with SMTP id 98e67ed59e1d1-3779bade6f1mr2514691a91.5.1781172805704;
        Thu, 11 Jun 2026 03:13:25 -0700 (PDT)
X-Received: by 2002:a17:90b:390a:b0:36d:b818:f848 with SMTP id 98e67ed59e1d1-3779bade6f1mr2514650a91.5.1781172805218;
        Thu, 11 Jun 2026 03:13:25 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-377a5ddd3cdsm797886a91.1.2026.06.11.03.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 03:13:24 -0700 (PDT)
Date: Thu, 11 Jun 2026 15:43:17 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
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
        devicetree@vger.kernel.org
Subject: Re: [PATCH v11 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aiqKPYmkIRl1QiSN@hu-arakshit-hyd.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-1-1cebc8b3275b@oss.qualcomm.com>
 <mcqrm4pwziflqomw22gepqusc7jdlb2foslcfvtjufuyyoslb7@37olf54qxtfv>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mcqrm4pwziflqomw22gepqusc7jdlb2foslcfvtjufuyyoslb7@37olf54qxtfv>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDEwMiBTYWx0ZWRfXzdKJpHJXNUIS
 XKC4185dqRNOB0bFDK6c448dUMaCR/wMYdtsobedJDTZJIQPpsI+FatPoWRN7X4D6KxtvlaTBeD
 hyJTADUyZKSSsErdw0/CBnlRgQFvYjl8z1Wnex5hq2ImHNsJXVqwapA7EPPeC6S+hLvaL6/9qiQ
 5VxmnI/7A4PmG741TVBr7vokIij+X+PHWWEN3FC+Zl3reez3c4n14k8eqfplPZ7nKJH+8N8JGye
 Q/A8XyF3xhJ/n4pJ9/MpM03crrXtIcCMV78YQcmM2g8veBfkP/9xHGsCkHHcNHAvHFDveEream7
 3m8ZMCgIsWbwbm8GXImtQoPzQJsHC8k32e492rc6xDTHQUjWB+7LCn4bA1dv3bT6vWdDn3Drbty
 iuUBT/nmWKwoxmGVo9ehr3mfrbrW6lbr7niY4obe+TZFBLTAM9GR5VbUBjzD6waFeFjMk9nicn1
 bthA+doLu6nJzpdN3Ng==
X-Proofpoint-ORIG-GUID: AiFtZJdPgCbQTxbqiAc59PkRX8ZU9bqM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDEwMiBTYWx0ZWRfXzKsfuOwXmQ5c
 NAuFNVz2ntMAqZr2GVhIklvfZ2pwSHUghMWp/+XIC6/KXMtvIeYq/BV0gL9+r4DOKHMlVlRsqf6
 ivu6P6mPg/EQccLnv/k3F1t3fI3Zpjw=
X-Authority-Analysis: v=2.4 cv=e6g2j6p/ c=1 sm=1 tr=0 ts=6a2a8a46 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=i-GQASlAym38gW1YhUoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: AiFtZJdPgCbQTxbqiAc59PkRX8ZU9bqM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110102

> > diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> > index 5f20108aa03ebe9a47a10fba9afde420add0f34a..519d08c4727a6cb2dc5991216a2c042ed6218857 100644
> > --- a/drivers/soc/qcom/ice.c
> > +++ b/drivers/soc/qcom/ice.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/of_platform.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/xarray.h>
> > +#include <linux/pm_opp.h>
> >  
> >  #include <linux/firmware/qcom/qcom_scm.h>
> >  
> > @@ -113,6 +114,8 @@ struct qcom_ice {
> >  	bool use_hwkm;
> >  	bool hwkm_init_complete;
> >  	u8 hwkm_version;
> > +	unsigned long core_clk_freq;
> > +	bool has_opp;
> >  };
> >  
> >  static DEFINE_XARRAY(ice_handles);
> > @@ -315,6 +318,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
> >  	struct device *dev = ice->dev;
> >  	int err;
> >  
> > +	/* Restore the ICE core clk freq */
> 
> Redundant comment.

Ack. Will drop.

> > +	if (ice->has_opp && ice->core_clk_freq)
> 
> Can core clk be 0 if OPP is used?

In the current logic, core_clk_freq will always be non-zero if has_opp is true.
I included the check to decouple the two variables defensively, but I agree it's
redundant if we assume the OPP table is the sole source of frequency scaling here.
I will simplify this to *if (ice->has_opp)* and ensure core_clk_freq is initialized
within the OPP registration block.

> > +		dev_pm_opp_set_rate(ice->dev, ice->core_clk_freq);
> > +
> >  	err = clk_prepare_enable(ice->core_clk);
> >  	if (err) {
> >  		dev_err(dev, "Failed to enable core clock: %d\n", err);
> > @@ -335,6 +342,11 @@ int qcom_ice_suspend(struct qcom_ice *ice)
> >  {
> >  	clk_disable_unprepare(ice->iface_clk);
> >  	clk_disable_unprepare(ice->core_clk);
> > +
> > +	/* Drop the clock votes while suspend */
> 
> Redundant comment.

Ack. Will drop.

> > +	if (ice->has_opp)
> > +		dev_pm_opp_set_rate(ice->dev, 0);
> > +
> >  	ice->hwkm_init_complete = false;
> >  
> >  	return 0;
> > @@ -560,6 +572,51 @@ int qcom_ice_import_key(struct qcom_ice *ice,
> >  }
> >  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> >  
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
> > + * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
> 
> s/error/errno

Ack. Will update.

> > + *         dev_pm_opp_set_rate()/OPP lookup.
> > + */
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> > +		       bool round_ceil)
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
> > +	if (ret) {
> > +		dev_err(ice->dev, "Unable to scale ICE clock rate\n");
> > +		return ret;
> > +	}
> > +	ice->core_clk_freq = ice_freq;
> > +
> > +	return ret;
> 
> return 0;

Ack. Will update.

> > +}
> > +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
> > +
> >  static struct qcom_ice *qcom_ice_create(struct device *dev,
> >  					void __iomem *base)
> >  {
> > @@ -738,6 +795,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
> >  	unsigned long phandle = pdev->dev.of_node->phandle;
> >  	struct qcom_ice *engine;
> >  	void __iomem *base;
> > +	int err;
> >  
> >  	guard(mutex)(&ice_mutex);
> >  
> > @@ -756,6 +814,41 @@ static int qcom_ice_probe(struct platform_device *pdev)
> >  		return PTR_ERR(engine);
> >  	}
> >  
> > +	err = devm_pm_opp_set_clkname(&pdev->dev, "core");
> > +	if (err && err != -ENOENT) {
> > +		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
> > +		/* Store the error pointer for devm_of_qcom_ice_get() */
> > +		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
> > +		return err;
> > +	}
> > +
> > +	/* OPP table is optional */
> > +	err = devm_pm_opp_of_add_table(&pdev->dev);
> > +	if (err && err != -ENODEV) {
> > +		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
> > +		/* Store the error pointer for devm_of_qcom_ice_get() */
> > +		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
> > +		return err;
> > +	}
> > +
> > +	/*
> > +	 * The OPP table is optional. devm_pm_opp_of_add_table() returns
> > +	 * -ENODEV when no OPP table is present in DT, which is not treated
> > +	 * as an error. Therefore, track successful OPP registration only
> > +	 * when err is not -ENODEV.
> > +	 */
> > +	if (err == -ENODEV)
> > +		dev_info(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
> 
> dev_dbg() please. No need to spam old DTs.

I intentionally used dev_info() here as it would provide a quick diagnostic hint
for KPI/performance regressions as mentioned in the cover-letter, which can be difficult
to trace. But I’m fine switching to dev_dbg() to avoid log noise if that’s preferred.

> > +	else
> > +		engine->has_opp = true;
> > +
> > +	/*
> > +	 * Store the core clock rate for suspend resume cycles,
> > +	 * against OPP aware DVFS operations. core_clk_freq will
> > +	 * have a valid value only for non-legacy bindings.
> 
> use full 80 column width for comments.

Ack. Will reformat the comment to include it within 80 columns.

> > +	 */
> > +	engine->core_clk_freq = clk_get_rate(engine->core_clk);
> 
> Why can't you conditionally cache the freq by moving it to the above else
> condition?

For core_clk_freq, I agree moving it under the else improves clarity and clearly
defines the purpose of the variable. I kept it outside earlier to avoid tying it
strictly to OPP presence, but I can move it for better readability.

Abhinaba Rakshit
