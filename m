Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83E724DFF3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 07:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966163; cv=none; b=mexBStfozZyTiRL6WgZwUp3uaxkhcJljYJcRqN0w8e7Hm4/o8PR0EH/qQuDbLiirSxDYTiRJs0SY/5yJhAud6OiSisqTXB1/U5mtYFJAMF/c5KlENaULwKdMQHQXDWYmLnpKBE4qs4KatbG9aP6xM604Lf+DKwebVbNvQBIxWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966163; c=relaxed/simple;
	bh=YPjLcEY4rANgxIqPduKrQOQlDIe69vI+TN1NbWtesA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ca4b+zMKWQCxc4KGSOPUqBK8DH2Yg+KhR1o6oEmtZ/0umNfkJfHD1JDPM6aYwavSD/8gjCzgFZhcpt81b/LO9rvEEBcaSqK25Qut/cFiOCGSreQkpwrRHSjsd7IoH1M3S7ccDnP1jqFSauTaFrlBwrgamDH+cRi0X+gMn5upvmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HQ7QopFP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D1zP/ywk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HQ7QopFP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D1zP/ywk"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61D0C4VD2734050
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 07:02:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ueBVrP/Dr00G/Np3iU43iq53
	p6C33zJvmbCUg30e9pU=; b=HQ7QopFPL/RpnoPwudVfqTytYZ0AKVkGtx/A8X6Q
	eAzQO6RUfjg3wV/x2yhH8z0FNP4zsbGJ1Xq9Fh02rywfcjJ4VE88y7tAZGy/R2De
	vMeP6MWrEAK+VOZaym2raJmZnfrrZIj2RUq7VovGlCotlFcrmS+YRORazApFv272
	vb/ArNsHH5409DZRY2Ajw6UH9c00MZrgza4Bqi+8w2d+JHGPrc+GVntQyWg48v8b
	ebQUvzQg0Wi52tg4vxAIohmo3kBLFkLC9vlBINRzg1cgJ158mxrVLxwDJte4VP03
	2AljHTqQED3QOjPXaGWDssLbzR4QnSS9LXKBP1Sa50/A9w==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c9s6ws5dw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 07:02:42 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a7b7f04a11so25233995ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 23:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770966161; x=1771570961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueBVrP/Dr00G/Np3iU43iq53p6C33zJvmbCUg30e9pU=;
        b=D1zP/ywkdtKvkfFsw77nJxawhjHFVuauLDT9tT4KPr90t33qVcE9hqYCqjmeGEl3uh
         wLNJAc11plHBcltwEXlZHsLbXOZSSGN1luW6tG2PpTobdjQGvCTAdGFXNEmLRPtFR+XZ
         7fnpKXHPMniHR93A8IAKQly4cc5q84ZVcH242Nr1T9XzPd+QMUmOj5KR9z3grdhBypWG
         B2xFYwY7500pvtF5KrN/AXN+c6Va/TMCe8kJuRGiEbBCtKXLUNPgE/wIqtWWu9jILgiz
         9GG1edJT6zXxmy0OzHIrCrM9zgvUhFkwarbGYVj/14HJ/MYCqtPYtxLEM/Pib53mi48i
         br2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770966161; x=1771570961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ueBVrP/Dr00G/Np3iU43iq53p6C33zJvmbCUg30e9pU=;
        b=SS4696ylIx06MFfeWw4xRz3eRXM5jfy2C6GlbU9aoRZUkcfUXOJSHSna9XMxJKRR+J
         pC0dzeBq5J/tyuxKoNxVtSGLneQX0A6/Kwr2KTQLg2OOUeijWdafYgv30dmwdP4C8v1v
         O5QYnQ6xMXvvMVTWUhBfUfMziWw/sqvlx4TqbxHqj0AxOqnon/OyyfTNKX8/Au2eISVF
         F+sbGaFDeLx/f00Hn6LAXpt1sRFR2533lWXXk7aMD+GHQrpjBkavUBF1VVdZ58nMxP83
         MheGVDuvC+a+uTqKhfpMDg0CqCp/J7USF0qPBzQVC5qouDsPNa8bDI7CRtFtwF+XTQ2Y
         cfgA==
X-Forwarded-Encrypted: i=1; AJvYcCURwyQDALIg8i5ze5eRxnmivRz206IchxAchTj2ekp6U8hpNY9AOf75xTPyeua5IuLtHeokTimBYU9V@vger.kernel.org
X-Gm-Message-State: AOJu0YwUEobDNdGbMGOn1WaKD/DV4JcnJp93sgvmui4VsKCA/XQLneum
	Vnsmvsttcl563i0seMEwCRD4tXtS/y1RdslLLxx4KDCMfK/i1PyipU/kK2XGZaq5MgSNrF/oJIK
	ATElLWNUx5ajL8bxykkjDL8ETwnGk5+Qm1NT5Lfo6YW7MBotH/55RSTZrJ3wG+JfJ
X-Gm-Gg: AZuq6aKl8puDOymjKQ/URrBBOfdsneA5SGTUFBZZQLZ1NvfZU/qErn5E+l+qhFARR3x
	FL0eZmglwB+XDO5LakXRajxQH+EHJOI0jh+BKvXUe5boV4KTcszbePMaS10DG/qblQTt7pkQcHo
	CLEAem1HQVl7CNwx1kudUivlPewTX8Wz69Of0EmpjI01e6DJ3m02sLtBLAzeqsCZGPSO5tVyhI+
	Jdj/yz8kOhYTAUt48/O07E14TlW1S41RuT2hW44dXM3Xz8wHs6p+LSmKJBcJYnilOvEVe5wUgmA
	y0v2fh/THMYpvaecykz4rqAAJeao+WIfBgvCnHk1erCcq3C0xVqFY/m0xv0TVtghakoCAvXdOpI
	wKsokEmcz41XNHQoZsFm9c70GOOktLdnifj5X7FyHQLLLDT2zJztyYUHumqg=
X-Received: by 2002:a17:903:2282:b0:2aa:d350:fbf0 with SMTP id d9443c01a7336-2ab5054aa42mr12147265ad.26.1770966161340;
        Thu, 12 Feb 2026 23:02:41 -0800 (PST)
X-Received: by 2002:a17:903:2282:b0:2aa:d350:fbf0 with SMTP id d9443c01a7336-2ab5054aa42mr12146895ad.26.1770966160833;
        Thu, 12 Feb 2026 23:02:40 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab2997a660sm74391245ad.64.2026.02.12.23.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 23:02:40 -0800 (PST)
Date: Fri, 13 Feb 2026 12:32:33 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: nvqpuOuFQv9p6eUnanrDhe6UZ1W6FSny
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDA1MiBTYWx0ZWRfX83hrDU8hC+L/
 5M/4y4pJ3/piQ/VDwhOmTdhF9z2f0xH2LCN4v4SvqKSMFxIV3jOVXhKR8tRKyyuTH4EDxZtFxhc
 MagXuI+cpk9/yfH16IZ932QLPcQGQ3cTtYL8PQpWOwQWlrmBoCjjRLjn9btZCwtUIQL59offb6q
 usqE5W9TQiHtfpEscUAchSvjuDwIXyLtvD2upt8OUkgkwiaSqnqRbY3AK1DKt/1D0u/3B437yDg
 6kQbMVkta6miBOgNgEbNtP4UWiyVJ+UTPCyyGMMm+4/WZ+7hQUvwt18i0DtCo3LEfp8SxoxQ5NY
 Z4COqc++YOWfJE30lBcw7E642N+9+SWYbLe7nVhw5I8dcpUOt0/dx/AAZAqK5rHSLOu5jQCTA1j
 q6gBRneFHqskoS52hhX0c7vEUG0/zI+KaG6ReLx7N2ip5d0O08K+1Ez1SiUkla9tXN5anLQtGbk
 6gtvrR/Nmpo0HFQjLJg==
X-Proofpoint-GUID: nvqpuOuFQv9p6eUnanrDhe6UZ1W6FSny
X-Authority-Analysis: v=2.4 cv=CLInnBrD c=1 sm=1 tr=0 ts=698ecc92 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=q3I9YNJuSRWBU34YNAkA:9 a=CjuIK1q_8ugA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_01,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602130052

On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > and aquire its minimum and maximum frequency during ICE
> > device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock based on the target frequency provided and if a valid
> > OPP-table is registered. Use flags (if provided) to decide on
> > the rounding of the clock freq against OPP-table. Incase no flags
> > are provided use default behaviour (CEIL incase of scale_up and FLOOR
> > incase of ~scale_up). Disable clock scaling if OPP-table is not
> > registered.
> > 
> > When an ICE-device specific OPP table is available, use the PM OPP
> > framework to manage frequency scaling and maintain proper power-domain
> > constraints.
> > 
> > Also, ensure to drop the votes in suspend to prevent power/thermal
> > retention. Subsequently restore the frequency in resume from
> > core_clk_freq which stores the last ICE core clock operating frequency.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> 
> [...]
> 
> > +/**
> > + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> > + * @ice: ICE driver data
> > + * @target_freq: requested frequency in Hz
> > + * @scale_up: If @flags is 0, choose ceil (true) or floor (false)
> > + * @flags: Rounding policy (ICE_CLOCK_ROUND_*); overrides @scale_up
> > + *
> > + * Clamps @target_freq to the OPP range (min/max), selects an OPP per rounding
> > + * policy, then applies it via dev_pm_opp_set_rate() (including voltage/PD
> > + * changes).
> > + *
> > + * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
> > + *         dev_pm_opp_set_rate()/OPP lookup.
> > + */
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> > +		       bool scale_up, unsigned int flags)
> > +{
> > +	int ret;
> > +	unsigned long ice_freq = target_freq;
> > +	struct dev_pm_opp *opp;
> 
> Reverse-Christmas-tree ordering would be neat

Ack, will update.

> 
> > +
> > +	if (!ice->has_opp)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Clamp the freq to max if target_freq is beyond supported frequencies */
> > +	if (ice->max_freq && target_freq >= ice->max_freq) {
> > +		ice_freq = ice->max_freq;
> > +		goto scale_clock;
> > +	}
> > +
> > +	/* Clamp the freq to min if target_freq is below supported frequencies */
> > +	if (ice->min_freq && target_freq <= ice->min_freq) {
> > +		ice_freq = ice->min_freq;
> > +		goto scale_clock;
> > +	}
> 
> The OPP framework won't let you overclock the ICE if this is what these checks
> are about. Plus the clk framework will perform rounding for you too

Right, maybe I can just add a check for 0 freq just to ensure the export API is
not miss used.
Something shown below:

if (!target_freq)
    return -EINVAL;

However, my main concern was for the corner cases, where:
(target_freq > max && ROUND_CEIL)
and
(target_freq < min && ROUND_FLOOR)
In both the cases, the OPP APIs will fail and the clock remains unchanged.
Hence, I added the checks to make the API as generic/robust as possible.

Please let me know, your thoughts.

> > +
> > +	switch (flags) {
> 
> Are you going to use these flags? Currently they're dead code

I agree, currently they are not used.
However, since its an export API, I want to keep the rounding FLAGS
support as it a common to have rounding flags in clock scaling APIs,
and to support any future use-cases as well.

> > +	case ICE_CLOCK_ROUND_CEIL:
> > +		opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> 
You never use the index (hardcoded to 0)

Ack, will update.

> 
> > +		break;
> > +	case ICE_CLOCK_ROUND_FLOOR:
> > +		opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> > +		break;
> > +	default:
> > +		if (scale_up)
> > +			opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> > +		else
> > +			opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> 
> Is this distinction necessary?

Well not necessary. However, I wanted to have the scale_up option as well and make use of
it in the API. Hence, I thought of having this to be harmless.

> Konrad
