Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044C7483
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 12:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760876071; cv=none; b=TXdxmzvlQ0zOO9KaIIIjjqcYVcMqtTbYOYwIZ8/aS2HOnQWna4JS3DodWQaHJ72m+wocSjp2SRU/bsSV+yI8yCp7TGd/h37Pyva/IJEPOTQXJ1fprgKZ6yjQylyC6NEd4MzEDqnDh9mLxQmH55aRnrMd69IVkwgV/TeRGLi5PLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760876071; c=relaxed/simple;
	bh=ukqOXoH0B8Rm/K0oOmFS3+X11r1F7wE1V9gnidNhdI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULj422a/1BhKPtEjuP8U7ZKuZP1B5xAgtvkckcrwKAlkh1xGGdGP9kYnoCzXmfEeVkDnqjZDVNLMTWmDJ6tXkl4xWECjzAkMZJUFBvC21bKs2+3RHltUExaDp6lq/wuyvoOtEcVwmRgToBiAD97pYi8kuDZxBhe8Es5rf9LOg5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=En65Ngbl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="En65Ngbl"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59JAOmVs020591
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 12:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	puNPrhTEXrfqnZblxaqGqUil1ruzTr+zCkgmrxJ5Bek=; b=En65NgblGY8NIrNy
	BjKP5KUK4ujMB3MNse92ose8la5TWB9nGsRowsVSqd47vWUpN1okqFrwbLRbe/Pe
	FNXx2CSQ1X00JbGgoIsnH6KHLWY1Qolrujvn/NYfSUhBI4uBbBj3taB/vAEKIjMg
	G+LNq+UP+2K3EqrMaLSzL+a9/fwmXBc2Vc95pgWrtnRnurCCfm6AZnlgQNC/gZv1
	RIiZAK7ux1qSlEfc63GcdYqlW9InQamQsiC4mUnRhK9etJjKT0GL+cHeJx6Kjb/s
	cRb/ARXhJ2FMsgtGx0SoulEaH3RtZW1rxb22UtmhV6SMakH6axSzxO6MljqW6bs8
	EtMyZw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v469a8ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 12:14:29 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-88f1dad9992so364807985a.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 05:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760876068; x=1761480868;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=puNPrhTEXrfqnZblxaqGqUil1ruzTr+zCkgmrxJ5Bek=;
        b=SfDYpTSYbTN1ft04mPd0zgQyEIRx0MvwEga2HaSgh76eRh1daICBtb2bmyXT/pmtOr
         tvauHo16eCG31s7YZE5P/LA4nqKKBrWDS94A5xFcb+iekC0O347VxoN1IC9iQUO1DoCZ
         cPozFAng8Zp6zbClKYAcoPJ++BEZzhKzoXeqbQY5m5U3xBA6RqrRr8Ko4uTbCz256iAZ
         PTZDhs22i6srTIevStm30HQf+Gon7tpCGDWdEBS+r/ZdiEqIjz10RZWApaqLttR2AV1e
         uHJzqwVYmbPyxCKoAiuiSrig5xgs7qOW76CXdirDYGis8eFXVIpGETpPmBfY1mrV4iy7
         VSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKFVd/MIqGFyny4iU16hvGFScZvTY9H+hUFDmr9dqowJTKxlDVc7HXyyq9XFjLOCaSSb2j+IENUF4l@vger.kernel.org
X-Gm-Message-State: AOJu0YzbRBb9vrdupmavl1xVfjhHgjdd0quxLNQejvIpyQZbkDRAaZ+V
	5X/BmGXCb4o0twFGIoD7t1stqLOM33zL18rP1WR0opGKDc81kr75zryag/sN2WnqlBdmcPTR11P
	eHzX7NPY12Jxy6Odnv/eoA/GlEKekdLitd91vuwfQaBhQgwAk7HqgrfHKw0kR2T4z
X-Gm-Gg: ASbGncuxTdlnqfEyIqf45Ld4zOHnGWcaFNJ0RrBNmjzshTOFx1vkDih1eHG9+C5BDSr
	VkTxm8gm+vBC40comkw33762GBuYS8O7nTwEULJKOIiXadBl1FD7mpRwsbuUituSuhGbA+gNH93
	fIAyKbPHxSA2kZSOCL+QVPeq70HC9Op8YC5CFthw10TcMTMJ6TFBrQYBGEAhpW5tUq1Fl3jBFEA
	ofmyTSeU1LYefy3VxJUxIEPZQsiUSUCR730RiIo5beJdfS1J9h1xdCgi+Z0rW6J6r2nGh5qPxQf
	a1FmhjVhuFSV7i6ywg3t3g4WG2UblQBG33XmVvgmSpY9pN6NYDTpiHt8IrsIOZcsXIWEyBA+sFG
	l0AYJrLZWedhJjX+lX4V1qvd6O7pcTzhpkIrzmVzwAcL9ihoVeLZ7YYbhGE/AnFZKMJcU/qBKWP
	3s22DLh7Omv8Q=
X-Received: by 2002:ac8:5985:0:b0:4e8:911a:2af1 with SMTP id d75a77b69052e-4e89d3625e2mr152707031cf.46.1760876067803;
        Sun, 19 Oct 2025 05:14:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8+CZ0NJ9bBoZZ1GZiXuCbYiL/YP/qmggrLH+uJV7bA2b9ganhGBoaFnRrleOl3gY/Yk+zFA==
X-Received: by 2002:ac8:5985:0:b0:4e8:911a:2af1 with SMTP id d75a77b69052e-4e89d3625e2mr152706601cf.46.1760876067319;
        Sun, 19 Oct 2025 05:14:27 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-591deec0b98sm1528227e87.40.2025.10.19.05.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 05:14:26 -0700 (PDT)
Date: Sun, 19 Oct 2025 15:14:23 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ritesh Kumar <quic_riteshk@quicinc.com>
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jessica.zhang@oss.qualcomm.com, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, andersson@kernel.org,
        konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org, linux-phy@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        quic_vproddut@quicinc.com
Subject: Re: [PATCH v2 0/3] Add edp reference clock for lemans
Message-ID: <ql5ps7cv7x6hz3otzz45uv6pbr64x2hdapa66vq2jtnt6l536h@kbktvupxpf4y>
References: <20251013104806.6599-1-quic_riteshk@quicinc.com>
 <7jmk3txdrnit6zn7ufra7davmomggd3graizdu6wqonp3lljza@mfnxt2owpknq>
 <4bd619e7-e9ca-44a8-9d36-10c18d7a8157@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bd619e7-e9ca-44a8-9d36-10c18d7a8157@quicinc.com>
X-Proofpoint-ORIG-GUID: V8oVIrAipuxEslzI7C0IEgeoz2j6R2U9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAzMiBTYWx0ZWRfXyMDDuLgNKtsF
 scgCSt3sSmpIYUpYrmu+0QX9O1p1T0CTV6c4W8/TxlgpU0dLOnj8VuxdE3eG/0Z8Nm5Hk1BY4o7
 kiJ0Td7Aq8u6727JgShRHepZeZ12VYuJniPq9yVj/XmR/wu0+tOAMvfBOUpB0wVwgNEGMizc5ON
 GMqzsQmRpHqkREiyNeFjlDC9b5VauMJK3Nubx4Bhqwn051LQ3pPzkFOX1mVy2Qcw55dJ+123E7f
 9w1si8AbDOF67jby7km5abe+U6EvTt4AgmywHTsQo00Iwbi+I3WdGGtQUmYxucseaQ1Cv+BzFte
 cnT7OdSzgzDVph1HA6hSgBUaiRvsya5tJX8RT69w19ENbVODFAUxMXp/mzd6AVaCn9H1k6urBWQ
 2GXuwU4tGj6m61I67xUllvk/9CTK7Q==
X-Authority-Analysis: v=2.4 cv=U8qfzOru c=1 sm=1 tr=0 ts=68f4d625 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=FYAu2dUYg65mSESSDlUA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: V8oVIrAipuxEslzI7C0IEgeoz2j6R2U9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-19_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180032

On Wed, Oct 15, 2025 at 02:49:08PM +0530, Ritesh Kumar wrote:
> 
> On 10/13/2025 6:04 PM, Dmitry Baryshkov wrote:
> > On Mon, Oct 13, 2025 at 04:18:03PM +0530, Ritesh Kumar wrote:
> > > On lemans chipset, edp reference clock is being voted by ufs mem phy
> > > (ufs_mem_phy: phy@1d87000). But after commit 77d2fa54a9457
> > > ("scsi: ufs: qcom : Refactor phy_power_on/off calls") edp reference
> > > clock is getting turned off, leading to below phy poweron failure on
> > > lemans edp phy.
> > 
> > How does UFS turn on eDP reference clock?
> 
> In lemans, GCC_EDP_REF_CLKREF_EN is voted as qref clock in ufs_mem_phy.
> 

Ack, please fix other comments.

> 
> ufs_mem_phy: phy@1d87000 {
>     compatible = "qcom,sa8775p-qmp-ufs-phy";
>     reg = <0x0 0x01d87000 0x0 0xe10>;
>     /*
>      * Yes, GCC_EDP_REF_CLKREF_EN is correct in qref. It
>      * enables the CXO clock to eDP *and* UFS PHY.
>      */
>     clocks = <&rpmhcc RPMH_CXO_CLK>,
>              <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>              <&gcc GCC_EDP_REF_CLKREF_EN>;
>     clock-names = "ref", "ref_aux", "qref";
> 
> > 
> > 

-- 
With best wishes
Dmitry
