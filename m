Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C28230D08
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747065618; cv=none; b=fT11qhopOafgRvKjhA8XvFUcfCRELmsqUsepbJb50ipq8tCo+vTvf2iEjLML0aQSPP7W/sj+g+BqXYDXhzog7Pmi9jM3B9KZyu7ZZBfjXr7wDj6X5u0ew0NI5sLh5d4ilqZy7JbzetB9KZLSReZwJzkB4Jw1OFXY/5c3Vbu3LUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747065618; c=relaxed/simple;
	bh=7CYZ9riknA472ksZ+IraasbprFF2j0liMKhXc25tang=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRGjEip5fo+/PiWbMPiQ8wT6W1sC4xs1xIKi6/lMd4iOUg7yk6o6sptWM7s6l6z1xB9t8miL0dOBp5SlZDUAYcM7P/LudTAj/xoeHwsB5CxG14pAweCGjc3cyift4cIRUsSyfNrGiPOwBvjJd4ZYxiBUbu21qhcsOfS/CHnc/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mmw8PO4p; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mmw8PO4p"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C9HOUt029694
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 16:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=jVsnjHIPMc4UjE20nXbN/0Gh
	CASBV1MVcwaZVTJw9co=; b=mmw8PO4p8phC89FVBOUEwZAILQonYdmf3Xkj18Av
	t1EDSmy0cFmU8nax+fKaZ+Eetc1u6jIUyX6meRs2FFmrh4pvW2ngLmzjnTecrpTB
	QmK15c8SxFqo6sBWs+9AKFA/mp4K6hIzBA3geQmhs/3hQGz7+xakQnhJcgFcDp+u
	GpCtgqGhnSEQDUDfBzFOZ9weIF5GldxVn7O1sgXrvl4kgIjSXCqDM51Zlz7hqFeY
	aqYBsyF13n/eWpCkItMm4PGmfWvWdDkwv+iNQzAuvpuvW1aEnVyUiiT/xnJGLGT+
	3F2NrdGFaF4gVFgOw4H1+KXUoHyfgzsiaDuNE+tmzEOM0g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46hvghd3fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 16:00:16 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5c9abdbd3so448962585a.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 09:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747065615; x=1747670415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVsnjHIPMc4UjE20nXbN/0GhCASBV1MVcwaZVTJw9co=;
        b=vCe1aMov1UYEUC23xg3sUKJt3/1kkc5QN+UnoNIQqoshsQU7HheZ/0YVe+FOR6HhXR
         2+Nb1ASV/lulVhGYrefPgcPCZB7Oxy4Gb0zXKiy2CVpDq8qlwpmupyGRzGh4VQDriGj6
         T2rvbLt4RP6VCaQU/4katFZseqI+MPiXM8zi5rXGLXoE/+rs6Tkv3KnpVa6BTVn3/Fxd
         vHrNfW2+SV3OR1n0VLKMaL0gUqEertit//FTvPaR9oYIvHqB5ulx84VEm+lsHfFEiBef
         vSq93xbY+EUtFNUyaySFMoslKodhBwJBbb1TkmkGHWvKIVzBMPyNHbwCcoGMnU2ypHIL
         tp/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVL641QCVD4Vj3W7zz0o1YmoVkRYeKfAD+o4n4MXjRNHMvz0r8SWqE2mlqxCnkJ4HR67jZpn2mKQbP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3DV65ixWpgwb9KrF3yYAtjCWxu0l7uI070Wl5fX7yqf6eVCcQ
	2lgbrYl2DJUjsQ/v+LPcuLJElrftmv5+yOk5Y5zru8m0i1eJLfkmvI0fWgvv3xtZWXD/EJ5zKqv
	xErGc0kBX4tbnuvtyQZ1hX0nT+VqTxMHEddg0bhlTg7aj1+MLLHkJOphkxw7A
X-Gm-Gg: ASbGncvh/fVqSlANEE8RS35SK5LIjb2N5WzNKiZmqTC7BOIOFRjH/Ipk8xN9OsXyJQ+
	joQTBwXVYtWOPez/cyc2BwEa5Sj0H426iOtg6Io0181Y4XNvm7H0E2abAwZ+TuLTCH7GsrIoVKX
	xmVOe+e+78E8UhZ1QupPL/VU1YM3pvjt6IwO+vn7W0ZiSHv7vWisdg6IlFXCj7xwHMjl2wJjNfq
	ug1hrfce1hV7uLGvsHnv9LRLN9mR/T1SPA7Uyw5yqMOlx4maFpD0dg0IjIe/My+UEopi4tmpfEn
	A08Y3Ab1RHWGYz3urnklRmgeNh+ljo4nIwrFBYGmMlbDiVJGFVyElfhEhxXUFHjuoyXUn5U3Kb4
	=
X-Received: by 2002:a05:620a:254c:b0:7ca:df2c:e112 with SMTP id af79cd13be357-7cd0113e3fcmr1865032385a.45.1747065610592;
        Mon, 12 May 2025 09:00:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcgCdyq3zyS28tN3F2p/Ex+KYAVnsB2ZDiCcC9Z5PrA9qpZZZLy2A7EDKvjbQNL/WjcEU2bg==
X-Received: by 2002:a05:620a:254c:b0:7ca:df2c:e112 with SMTP id af79cd13be357-7cd0113e3fcmr1865000085a.45.1747065608247;
        Mon, 12 May 2025 09:00:08 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-326c3502dc8sm12723831fa.79.2025.05.12.09.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 09:00:07 -0700 (PDT)
Date: Mon, 12 May 2025 19:00:00 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, krzk+dt@kernel.org,
        robh@kernel.org, mani@kernel.org, conor+dt@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, peter.wang@mediatek.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V2 1/3] scsi: ufs: dt-bindings: Document UFS Disable LPM
 property
Message-ID: <34kz7pj7bjbmpfyrlwf2u4vikrbbmga5mxv2i7x3zga57qysg7@oou3m2rbazdb>
References: <20250506163705.31518-1-quic_nitirawa@quicinc.com>
 <20250506163705.31518-2-quic_nitirawa@quicinc.com>
 <667e43a7-a33c-491b-83ca-fe06a2a5d9c3@kernel.org>
 <9974cf1d-6929-4c7f-8472-fd19c7a40b12@quicinc.com>
 <8ebe4439-eab8-456a-ac91-b53956eab633@quicinc.com>
 <852e3d10-5bf8-4b2e-9447-fe15c1aaf3ba@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <852e3d10-5bf8-4b2e-9447-fe15c1aaf3ba@quicinc.com>
X-Proofpoint-GUID: zym8aZbGNTo7-5siYFRt656OzveznOIc
X-Proofpoint-ORIG-GUID: zym8aZbGNTo7-5siYFRt656OzveznOIc
X-Authority-Analysis: v=2.4 cv=AMDybF65 c=1 sm=1 tr=0 ts=68221b10 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=L0YddVROYn7RqkBwd_kA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDE2NSBTYWx0ZWRfX28se2UXeyJwa
 i4/nR/FUn8WIj75GLinvwvzWJn+XHDNcFGIH2tnySGswMgX+y1zyagONzrLaXhCyqiGgpYL4rdE
 tKrqth4V8ncWYDfhR7C5Qchn7YQ06loZitiAjheJcEpOKM9xWjMeayZiJYP5TSj2hsUtrNfpDlr
 SjjPb03X0l10OySZFXW8ZsDRgCDXEDUsgj6CpfeVs82Tz3lhae48qFMYgPgDkeNzEzKzzXIxcTN
 I42VQE5RqJVJILnfgKmtLGni7U84vz0tqunXXaZ1MGQEsFFVAWm889pVPZNChdYYqNC/HnCMSJD
 yZWWqfkYK4fSfHteeR1mD1wt3lceXjrkj3WjTkL4qp6XaIxYv8BfShNymTg6p3ddHTog9X8Dgpd
 UYGbMlpKIYt5ynDw+mHOeiakvFmxa3v8GqYIeWYI2O0OTdUi9gF+SlVP+qCUJSCuMUhzOabk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_05,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505120165

On Mon, May 12, 2025 at 01:11:08PM +0530, Pavan Kondeti wrote:
> On Mon, May 12, 2025 at 09:45:49AM +0530, Nitin Rawat wrote:
> > 
> > 
> > On 5/7/2025 8:34 PM, Nitin Rawat wrote:
> > > 
> > > 
> > > On 5/6/2025 11:46 PM, Krzysztof Kozlowski wrote:
> > > > On 06/05/2025 18:37, Nitin Rawat wrote:
> > > > > Disable UFS low power mode on emulation FPGA platforms or other
> > > > > platforms
> > > > 
> > > > Why wouldn't you like to test LPM also on FPGA designs? I do not see
> > > > here correlation.
> > > 
> > > Hi Krzysztof,
> > > 
> > > Since the FPGA platform doesn't support UFS Low Power Modes (such as the
> > > AutoHibern8 feature specified in the UFS specification), I have included
> > > this information in the hardware description (i.e dts).
> > 
> > 
> > Hi Krzysztof,
> > 
> > Could you please share your thoughts on my above comment? If you still see
> > concerns, I may need to consider other options like modparam.
> > 
> 
> I understand why you are inclining towards the module param here. Before
> we take that route,
> 
> Is it possible to use a different compatible (for ex: qcom,sm8650-emu-ufshc) for UFS controller
> on the emulation platform and apply the quirk in the driver based on the device_get_match_data()
> based detection?

Emulation platforms are generally not visible and not supported by the
upstream Linux kernel. During the bringup stage you can apply any kind
of quirks, but I don't think that FPGA or emulation are of concern to
the upstream kernel.

-- 
With best wishes
Dmitry
