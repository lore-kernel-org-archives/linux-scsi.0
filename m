Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD273A1681
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787558455; cv=none; b=Dewmcnn6rV8te8ENq1U68DNG4ELPNSS77uWBZEE2aoJt4A729j3JZlmu6IumvLZtb4NkzUEXShj7bvW8PmNW7l6Rwk92NTyY0yAbshPxYq+UrXXRAriGm5679u2LC8a9bBAyd3q8AamriA2DFy7t9p/TAEOewND4S0q/Rn1CdoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787558455; c=relaxed/simple;
	bh=wwIZh3D2siD8GG/XEHUQg3dDfiI2uvf3F1Dybj4tgYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMel9OlwEIvDxot1bx80tBCV9RM0YWto/jnmG1KtUNvF9BnpN7lEENsiccG+tDSndqqeKYVQsSTA7wD/gxCMLNlpGAWaOKUE+IxgnMXvZXxbuHdj+dp62ly7VBHFduY6o7qYyA2k5IhYmICZWdZHez4+WYNEz5PuPGgQVOwFWqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ls7SXtKl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=drHIuC4a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ls7SXtKl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="drHIuC4a"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O7Pvl02666074
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bIx8Nsn0JHsiRfRvHWW3GAIk
	aw2Q/pmC3k/N1L5Qv3Q=; b=Ls7SXtKl0ApdBvxi+5JwpVf8rozualZE07CMk2W0
	ozpVTWb6rBULu7Vnhe9MmwRri+MJFE7/Barjqz2WOyem3Vul/8heRJ0h8xbbQIbN
	eHuHL6YK1qBXUo3+6gfSW4Z15aPuyr9DA/uh25OODLMr1mg3Kls27MbMJGMNwSA2
	ShFpAfNAIiuM/xX7p0MHCV0AXcgHFRFcN/bap1atn749TrglzH39uC8XISCWf2Wz
	Vd/D0pBycrK1KRF8i5+Hlcr9vwaEnVW2/pjQeXkaZ6zZqG/xPVrrzeobw9xv1gJ1
	RwgG9UobS5gyK+U3t7RTaw4gTX00J05QSHBQgl1AY+yonA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g8hjgr4h2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:00:51 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52d28f8737eso59473351cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787558446; x=1788163246; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bIx8Nsn0JHsiRfRvHWW3GAIkaw2Q/pmC3k/N1L5Qv3Q=;
        b=drHIuC4ayqYveg+2l8NVLKiSpv8sQ7WRu0vVFH/FD5nijxHBL/l/3uXY9i7aqnQnC5
         pTipz7V6ha05HwhennFr07ThUb+1H1ILdB6HKE4eQ3oVPI0RtGkx+rFNFwhIB0delbIz
         fUvY80IPc+6yapyvWBAUVM0netnpQF6vLP+huWpXsLLOFVH/2Vh3efomQGY99DfpgxL+
         isE28RZRCryjb0rO0//rYFOGfuEzLIQYkSQh6iYeHnmpHZPqoSHK1QAZY7ki23VeDbvQ
         C5xTP5eks/00cM/YiGdxl7xhZZATG9jVQYlDTlL/Mt4aLOYepQzA8Ll/tCWlHHLgqcXW
         rK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787558446; x=1788163246;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bIx8Nsn0JHsiRfRvHWW3GAIkaw2Q/pmC3k/N1L5Qv3Q=;
        b=FSzG+xxv9A9L3IE2DIU/yCxGwHyETZugOpnCACMaOQiyyBk3D71EZbm+bqhs6gUk6h
         6gikq9ln0M77xF8S4MgSYNlwpItLP1FxvbQT0T65cuAGoh88ku45M7icYVjfNS0OgF5y
         Ard9nSKfbt7TfaglAopcoTkjWTQoEgcv+TGu8zcHlk6KyYljP7x05+iVXQLt3YsXw3Jj
         TPxs0EqASkJFI4ahtV2vUBam6pszPE0u+OI+vyEURnFx6RmYxbGLoqG6SCMjEmNQzG7I
         vUcdmZgwo4dqkAuebyZSXjKpQmRmhBrGC6PpX9eLtcfkYBBkNQLWFT1DiDRaQpCPXvUM
         WVLw==
X-Forwarded-Encrypted: i=1; AHgh+RoqPH+/m02Y7YyvZBFcJj6h/fQHJXwyvXonz7Nnwg7ZFM8J1hRWjUUR7OiJQIgwCzaUKPIJeSqzD6pT@vger.kernel.org
X-Gm-Message-State: AFuF++kHrFyR+LcqH6DVSkkkiNHJsrT2cSRqeFRKpaucLM0tEYeej3Dh
	KD5y16glUoRj8SOsNwACSqUaXxU/LSllsCQ85ej47/twQa1PALVZsOs+T3jyXSd0iJs/QLqKBbW
	r0VkyGsZ1C3IGL4G9WgWT9xvhM+KtMiZfPknQK1/F5rEcLQkLdcfoOaV39bWR9bbF
X-Gm-Gg: AR+sD10JSkOcmAKaDM5p0NWON8Su6ipbs7+dWX9W00/Wk6BmWNRxO1ZqlBTsRs09jZu
	Xpcf93GLKvclqha4JUdvlNxoNXjjD+Ypw5QxaCEqIV89gNMnyYqATNuSk6wNAsKQAe2qHu5Ejag
	P4lpTyocx3oUKg4zrrAalCLB+jxmwXe17yInJHPqlVpv4j3pSCbStrx7lZ3vuR5ZNYxEcUQoct5
	6R3TdXLkx+HrzL6DDDB8okCxCEgZiadLqKpPhYRxR7uSMPlPCSXOPrEyb0plsn0LzEuf2CSPtpV
	morRbQ4x9gTt9gwSbssAbF7JiHkSQEJPbfN9HiLsD2eht7Mve3pG2YtqdqP9pJTFAHReaqo/HCk
	zWZY/l2PwdrTEq/Y=
X-Received: by 2002:ac8:6f09:0:b0:52d:e25b:b452 with SMTP id d75a77b69052e-52e09d2740emr172160261cf.41.1787558446071;
        Mon, 24 Aug 2026 01:00:46 -0700 (PDT)
X-Received: by 2002:ac8:6f09:0:b0:52d:e25b:b452 with SMTP id d75a77b69052e-52e09d2740emr172159411cf.41.1787558445508;
        Mon, 24 Aug 2026 01:00:45 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968a2e42sm920436866b.59.2026.08.24.01.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:00:23 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:00:20 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
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
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci
 ICE init
Message-ID: <bcaassbzr732pq67irovw2sds3lyixz3emotgwludhp74lgdf3@4dm7hvxnmcd3>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA2OSBTYWx0ZWRfX/KZAVzejgQi4
 JoJp1/o1sCnw0QnbOusZneHaxE5Dq/+5DjFrNBFgrmGiKAstOOUJcszWzhLrbR6VcuYeYUOQfNU
 X63IOxGjSweK4EMyI5n3DnECL6+EOz8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA2OSBTYWx0ZWRfX47xWPcwCpKkb
 w2efG1c6rQwHA0Ef5/pOyh78/RhL1ieZXt6qecOYhgLJwdZWouS8mk/PAwvsxpBBSdmhj7XwsxG
 a6oeJ1dRvFxvrtJjUyOg0GusaMgUPk6U/pcRhGV7lX2Wnr33f1pZRLlGjaDA9nDmp9rheTPIuUI
 xp1fvK6ydIEaa+TcHXM4FmIc+ia2qZg6HnISHA2PQGa1zlpnwAVGHdI/4uCezmPXdgYwBLv9foL
 EuSRmM6doVnd/KYsEBydDM6tb+5FeUiDlf4WNhOtGjIHmlKy/uiNY9H5yLlD3e1wdy/OflwEgoS
 QF5H80G8lDRSHlDw8O+9Tlo7e33HFG83uhFe680dp4QJCXfciz3OC7u8PoXPS+krEv4WKozrSAV
 jKzgLweGaavmK41ImOduNy4OvCdnGtNmsU2m0izG276YKRoqW8hAkyWUGgeiCghy5RYP1u0H7Hz
 aQPyj4W7GlE4MjZ+e/Q==
X-Proofpoint-ORIG-GUID: Ln8iwiviPbpsT16citt41I9oNHiRbh6L
X-Authority-Analysis: v=2.4 cv=CoCPtH4D c=1 sm=1 tr=0 ts=6a8bfa33 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=wUpz7uCjLrEXi01cjX+DLw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=cMLKu6bAwxN9LsRLQwsA:9 a=CjuIK1q_8ugA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: Ln8iwiviPbpsT16citt41I9oNHiRbh6L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240069

On 26-08-24 01:17:40, Abhinaba Rakshit wrote:
> MMC controller lacks a clock scaling mechanism, unlike the UFS
> controller. By default, the MMC controller is set to TURBO mode
> during probe, but the ICE clock remains at XO frequency,
> leading to read/write performance degradation on eMMC.
> 
> To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> to align it with the controller clock. This ensures consistent
> performance and avoids mismatches between the controller
> and ICE clock frequencies.
> 
> For platforms where ICE is represented as a separate device,
> use the OPP framework to vote for TURBO mode, maintaining
> proper voltage and power domain constraints.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
