Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B77331A56
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 07:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771573080; cv=none; b=PFYEZl1PrKBj/ecV6RHvcZzKTr3Kqt8FBXYOvMowAmhwriYeC3eSBfzmF7MZXdJmmUMaUkknWB1rHVvTLZw3gf5tfy2QtEF8//A6YXHxvudDK+pH1DsHWWOyffKGtvQXg4i7+A5Cg3GTBgt+3KvUV/DhbowtfhhepFCCpGWEn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771573080; c=relaxed/simple;
	bh=HGuSp2VF6EtcyW5OJmPkCM7XvToSlNH2F3wLtZoNy8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9Hd3RLLPzoIKyzMnta06p986GTcInzBMLo39sTN+DmAM7NxsuG5yUXkE6T1mO7ztevcmzMSQZdfC6wFIsV4Tk3iFeQ4i7zUePTosWol4fgFHCnwS34UPpSIzpojHXoUQBxUfnSM9Z14ELHmzpZxrFoUYRKA/psJeFRoIDPY9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QnJk6wnU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PrBMskYK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QnJk6wnU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PrBMskYK"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5S5uZ3698902
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 07:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=EYpf01VqzYMOqIKXop1UeY2N
	HKS7LocvqzJI2+Aqals=; b=QnJk6wnUt4vtseRe36MZ95F4GU5juTeFBeoNAVbv
	vKHuEMFZje53bXsBrspZIyuuM+/KIuU5GrZP6LR/B4tF4zqn6G7C8Se9N3qUA6Lb
	3yk3hMWlYPzpng5L7QIYTKmb7Fsf8zXLT9p9EHXoWq5HlYx0sGnMVSj6NKrOMx3T
	WZC9bvxyZaOIKdLcUDZnRAE7vcWBaEEZX18RonMTtipNUgpDidlat4xM4AnbX8/H
	H0jSIsd6ZxzPG2cDtOpbIJRdspw76fGIcclluyr18xAejjS3IjwozEhY/TkZDrmf
	AnMWPXkpSacIqS30cd0vSi87kxL3D2cnhyvEo7hMfmDprQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ceh5jgau8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 07:37:57 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3586e7cf42aso7948207a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 23:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771573076; x=1772177876; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EYpf01VqzYMOqIKXop1UeY2NHKS7LocvqzJI2+Aqals=;
        b=PrBMskYKrPwdEn2U8dXnURst53/BcEUoWF50nTLEgLZcRFj9t0e1v65mNq7mmA15wK
         w2KNRdkj0qDXdzFcUC60Xu0OtwnBkdL6+RhS5Azf2hg5CuvjYWDgFeZzF5g73ZdgYHvA
         zit3WbkBbLSoTBCagYAmdhJyhF5WspQ0tYcYuqMudOtJGTuI2ICp/sCeO05m2HINWcqt
         L9Fjy0elh52CiKViqUYU9thA5GvHJ3+KT8zqYbktZ0OC06rXYNpU2s7B4rdMZvIbkChT
         cE3cJGp9aMbYB2w2fF82vgaeHycpmjbRebGiA4629LujEPoKtejDXilSJ6AwUNO0dGyE
         QVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771573076; x=1772177876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYpf01VqzYMOqIKXop1UeY2NHKS7LocvqzJI2+Aqals=;
        b=AFQ8V1YOkreqfQs1wbL0HmLcU4XIGhlqXu/K63qKZOTstALOKxUiioJg999ePo0J38
         7idnecHHEjPZP3KM8FURvPDLMokM2s8MInPyeyJBSXFkfGJukBE2d7LZtxyN4J27lBCn
         XAfTAECd0fhZCJfgm7gujO+C1galE9DCi6+6laPQRBcRIwRRATxnV9zyQvREXjqPaK0m
         1nREbeFRC6ZSlUjJFcrizhW7ykxuByHQ+P/+nBgwn5ZkNU2I2WjSandy7RVKFC/8mb4C
         dKdNO5v+V/P7YTCXvNk8Fu1mhyTV976n6SzbrXTsssPCJVAHsevUUcLrWarNO4Qr/tXS
         tbGA==
X-Forwarded-Encrypted: i=1; AJvYcCVpINzdVyFqZAvADTMgZZpH2FImmAaNnWKDJbFoK7sP1TBYT02D8bADj9jTRXrZgPuzKB0cg6y4IVL4@vger.kernel.org
X-Gm-Message-State: AOJu0YwbJl+K6axWe/ddeVJbcDrQgKt8d+/tOq4BI3Bioqu4gGYapamg
	S9MZD+7/VtWDEcP4tZXgLxaKwnZbV1S18zbokknMpAF1NwOyLMgK0nb41QO/LFbKIrjDL+QXbdX
	IncRc1OHRt2QTw0nbQpIA923r92kz2OfIHubmIVWNy5uii2jsWT5tgOx5SSjpyDaF
X-Gm-Gg: AZuq6aKWKE6a9mNbLD9TbdVtcLxTCw4IxDsNRn0CqrRFT6Ox5NrqLNInb8g97+TzczP
	wG7670dJpAEpcx2eliaQvr0WCUBXHxxrMG3urg6diLDRT+VwsyvDL2SqvJNpy50WmKz3Lnwy/Ty
	ATKKKjxh+rXIb0Am9x2IuK3CsxSAYy1zF+v3mipSQ9Vq4QEVKq9+zCnLON5cF91JH7vRxgxzvr+
	dXImMBYM8YLoCiRcGlX7t9xno3zyR/n1EHDYOooHJmnKDV4bFpBweiutFWsYHaBTJuLdmo8EE38
	wqvyq8zmqVil5tEAAXEWC5LTcbqZoKEkE6IMUYU/Os4os3KyTIRVHy89JHfrvS7UA7FJ8i16AMZ
	2h0p6hkfoQdfRTAkdW/Hdn6xl8TyP6wl1sU+45DGhdp4ZvJ2Ahb7KsM3L3Ec=
X-Received: by 2002:a17:90b:2f45:b0:340:ca7d:936a with SMTP id 98e67ed59e1d1-35844f99201mr20142467a91.18.1771573076323;
        Thu, 19 Feb 2026 23:37:56 -0800 (PST)
X-Received: by 2002:a17:90b:2f45:b0:340:ca7d:936a with SMTP id 98e67ed59e1d1-35844f99201mr20142446a91.18.1771573075810;
        Thu, 19 Feb 2026 23:37:55 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3589d81eb8fsm2285630a91.8.2026.02.19.23.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 23:37:55 -0800 (PST)
Date: Fri, 20 Feb 2026 13:07:48 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
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
Subject: Re: [PATCH v6 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aZgPTLttO+fO8cfC@hu-arakshit-hyd.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
 <15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=Raedyltv c=1 sm=1 tr=0 ts=69980f55 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=3jkGTw76aC5nUHUS4j8A:9 a=CjuIK1q_8ugA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA2NSBTYWx0ZWRfXwnwqa2HA9zzu
 9FmhFexyewfMXklkNhcQ/NOYWLuPKan3NLmIiMgAuhvCVgq3Ko9p/e0lU8SZ8YtmsunA7M2FPaM
 wJjGq/JgVcS6JlIhs1HS+aoh3sOMXhXhxAtUMMVO+AeWhZl3vh4cKMDa1+0obSDwaICO28LeYRv
 CyqMikgKstpq7kceU4MiQjCv6xux+Pf2x5TvPoravqvGGHBb7F7dxk7LEGjKXvoT821BVzvFMlX
 fGkjHE7HAZnhqEdi7hOSsWUjabLANDMR38pDULeYQDUoRl5DqYcvsHhFbnCWluCuD/mCCTYNcim
 fbIhZEOMpd1/kUe1rKtfR0LUBkpcuhmQMgUPAFhbBLC6RV+tZEhHZA/fuMorD9eR+z/9ZJP3dvi
 dwqBUT3qqngY9/2uScbuxgvn4j3LE+Mxvuq+L3ju+mHvVwKE+xmntI4LZHLbXOWfDUpCTfYeNma
 yClI4aYp1TL8u6JCVXg==
X-Proofpoint-GUID: 8QzrlrAE1ZIvSYX7YF5Tz-Qp0yEvPMJW
X-Proofpoint-ORIG-GUID: 8QzrlrAE1ZIvSYX7YF5Tz-Qp0yEvPMJW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200065

On Thu, Feb 19, 2026 at 03:16:33PM +0100, Konrad Dybcio wrote:
> On 2/19/26 10:39 AM, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > during device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock based on the target frequency provided and if a valid
> > OPP-table is registered. Use flags (if provided) to decide on
> > the rounding of the clock freq against OPP-table. Disable clock
> > scaling if OPP-table is not registered.
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
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> > +		       unsigned int flags)
> 
> If you're not going to add more flags, 'bool round_ceil' would do just fine,
> without introducing new custom defines

I guess, the defines I am currently using are mutually exclusive and not intend
to extend it. Hence, can replace using 'bool round_ceil'.
Ack, will send a new patchset with the update.
 
> [...]
> 
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
> > +
> > +		if (!engine->has_opp)
> > +			dev_info(dev, "ICE OPP table is not registered\n");
> 
> dev_warn(dev, "ICE OPP table is not registered, please update your DT")

Ack, will send a new patchset with the update.

Abhinaba Rakshit
