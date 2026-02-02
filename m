Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02B3EBF37
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 06:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770014182; cv=none; b=pRCBFlK81LeKzVei+e9cVrpHM7e9ERNyGVUFRIaU7vQcph5R23khmWgsJgZ9GCIBIgLRS0RcgiEXnFgEpwooTXZQD2rwBiY1K4YIOazVpdfcUMG0JsvYL5JVT+LMtt9XxxQUHGC5zOj9XhOplnDTG9DVDDx39czPu2W2tU+DtOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770014182; c=relaxed/simple;
	bh=xg9NDRatmvfZM5E54UM8msbcE7qfGPKuOC+UcnpJ4/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijVif5vXo04vR/J01IRToEINjsQcK7o2yD6/PhS51F7APaBcZoSCE5dfERR5/EBxiye4ISN5ntBNCsG222nFNDY+PrPSgAeQEu5bnjGN24q+m52lPYCv+wjivrfgyL9gPlSkyrRQzIqf/3JlVQsVu9/cThj2rSMDWFvjExiY55M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GihNtjmD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bx8QmEpf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GihNtjmD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bx8QmEpf"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 611LU2mL1107334
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2026 06:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=; b=GihNtjmDDTRzpMPf
	6aQjhdbcDWzLLok01G/P6xrmiMCy5YL26eKMr5UhAhLNq+xPCNuY931OH5A8yJFq
	w0VLjs6ExTUiLrWVyJ2GDVsTRb9QVWeDcRaaYGIOih88S2QGyQekv1rx7OkhCaJT
	a1GKuGUgvtMVecwWXw+szM9yIt99hguynrrXi8EGQIfcZLp9ckSYTjwQQL6x7kxx
	Do6zy2/17Y5uJ4dXyN/tGAJICMWl3+rWYguIyfp+mC61+M3ke1/OkciUvPW8hiqk
	NhR2u/TcZf+pQNxPvBI9INuBpdPI/qImp/NH56nSRuGhC+mSBBmnWrq6lQaGtQxY
	ze4A4Q==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1as0v8w8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 06:36:20 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c613929d317so2538438a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2026 22:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770014180; x=1770618980; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=;
        b=Bx8QmEpf8z6FXjEdu0dfgpjH7Kh2Ncu+reja2w3ATFZa+vjvW7RLJv80mEHyK5db/j
         859ZC+E7EXv+QMANtCwviV90pTgFErVXw2Hczht3Mqt2fVzSf4QswWpsyi+PD2DHkKJ+
         t9xWQxVP/s3WN5ZIlrHQk7r5iF3qfSc0FeChCGnNhxikAGdSI+qfkHjGCkFbja+wQ8Jz
         zlFEWTK0GcDQYmqxDzwRO4Y48dvsvFZs55SHzbjiq1ctfEdaa8HG3a9MoQmg2BAaAav7
         tcvQ7JSlY2Cs1LDZ2k7nj2I1kbEGuvOK7wRkcF7zsekSqj6ggmiOdbbq8pm92XGQpeFg
         DCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770014180; x=1770618980;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=;
        b=iLkgilLf0QFQZPYPcr4Z1CFev6uJqD/xi41B7BYqWCAhj8nEEkU3Hn3Te29GisrpLW
         gv2BSrye63AaE0EUsSqPN95qPdNlIZck6PdOyOzn3Ei/PHT3swRSzrh4S00QPCy8oyXY
         blJrzkEOv+v1r+IWCBzCB/G4tErGPQTKTxpGqnZyVsz4LnxBbfv4rKfQel6cTMXYAOgQ
         1G+pbfYVG1/ejTPsFK7QP/BJv58XGWR188XN5FGBI06WmWg+7ZQsa/nz8Rc0aQi2A+NR
         klP6cDOm7QaFj4xuP2E639l0moBhLOI8ec/gN7CA3pMTaIRp1T80fd5dppzrmlX37ONa
         9Mog==
X-Forwarded-Encrypted: i=1; AJvYcCX+X/9AJ+pkog2xv3i4ETfHmBof3s+oyQhu1P6oDSV2Azu8smmq6nXNWDIc472ozOOZiKLyieomcsIp@vger.kernel.org
X-Gm-Message-State: AOJu0YwzYB4Ki2HWNX6lXQpXfXqmSzlNz9d4k2ROq7c8d9pDv79jMWW9
	xRz2mirI2D9qN6VYGEj9xn2cKKQrBfYPYRB0fH6ly/HTlmpdK3pCi0OSH5FLq3MD176eflcc052
	tFdHBe9SOB+byxNAl5gvYPb3hPd5smY6cJGmCFrTQF8FP8D/ub8P7pXj2bx99/a18
X-Gm-Gg: AZuq6aJvKSIH/e/DsRXo2BXcHr1HbaLxFW/Vc8WuNhnS4rYgQjBrQYDZ1J4YoSSJog8
	w5KX9dyBRG+zsHXX33S6NygLeORYRpxGXjxAaZZqbRb6SVqr+Z0f+orFSPyS8LJbXuEAbKcss7X
	7dOGcXAtFdFTTNEqACcnEoRpHJSJcz02JJf3HeRvzdd3IyxuVu/5tjeoyonzgkxBP5yvJPUH92K
	thdQ72RT/tirE3HuX/pWstr78gQayolvgnW8wLuf2dTVhlyC+lWgDGWiS5u1x9L/I4yZ4kyM89a
	iqPM5fEP+x5NAapLyILGY3Cp3WXr1M6xe8GVrkd3SiH8DPwY5IaqdsfW8ZFXuJrIBC4+2GLQ8eh
	U3xM7SPkUx3V3R2mqJnn7UiocfjIU4wuOffFn+bVXUngK4IA=
X-Received: by 2002:a05:6a20:cfaf:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-392e01b362amr9962844637.78.1770014179624;
        Sun, 01 Feb 2026 22:36:19 -0800 (PST)
X-Received: by 2002:a05:6a20:cfaf:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-392e01b362amr9962821637.78.1770014179151;
        Sun, 01 Feb 2026 22:36:19 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642846888fsm13626274a12.16.2026.02.01.22.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 22:36:18 -0800 (PST)
Date: Mon, 2 Feb 2026 12:06:12 +0530
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
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
Message-ID: <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA1NSBTYWx0ZWRfX21vl9m2PT+ey
 2XBS0A8FgMH0yNebADEvJMHl6HcuAWqW9uoxczwjJdEPTD1KT9NdNRDfJuUuAhdrodmu40E2U0M
 Vlii2TD2Dyi9lPngah535mrhZShvTex+wvmLyrmDFIqvA2t3IeLv2wVLLynCfWB+ZFSxuFNWKUx
 Xn0CnU39tQ3ygug0BLSg91P24EhVT+Fg/LuvdPCKg1hOQaDF0e9ZENH36HsBTYM0rJmTmOR0s9I
 5HFEKj73BPPVP/FoVSNjIO+w8vLDaehsWOKfcrjyv6SjA1r0HuCsKxRX52BDF/rGxbYqsWeuf0t
 IAJ/3Wq+5Z9sarpFA21Js8UDV+svRgxM3yV38qBFrFC4B6QeGStXjc49lxiATFd6M7L/kR8Vv8D
 d8krDfDUiQ2aMYl5w7RhlVy4FabHlOiiWg3pXdG6sTaAt/MF96zExYZJqvQ5QJsRqO0fr+USJxG
 xUv2e5Q0LQUAwweqdGw==
X-Proofpoint-ORIG-GUID: gvSTg5o9yim2zsmhxeoYk1SxteMeTMe5
X-Proofpoint-GUID: gvSTg5o9yim2zsmhxeoYk1SxteMeTMe5
X-Authority-Analysis: v=2.4 cv=MYthep/f c=1 sm=1 tr=0 ts=698045e4 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=OguJ8merRGVtADoZ0hMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020055

On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> > Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> > using the OPP framework. During ICE device probe, the driver now attempts to
> > parse an optional OPP table from the ICE-specific device tree node to
> > determine minimum and maximum supported frequencies for DVFS-aware operations.
> > API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> > controller driver in response to clock scaling requests, ensuring coordination
> > between ICE and host controller.
> > 
> > For MMC controllers that do not support clock scaling, the ICE clock frequency
> > is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> > consistent operation.
> 
> You skipped that bit, so I had to do a little digging..
> 
> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
> would absolutely wreck the power/thermal profile of a running device,
> however sdhci-msm's autosuspend functions quiesce the ICE by calling
> qcom_ice_suspend()
> 
> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
> and a mirrored restore in _resume

Thanks for pointing this out, its an important piece which is missed.
We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
suspended frequency in the _resume. Something similar which is used by sdhci-msm.
