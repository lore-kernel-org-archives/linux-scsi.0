Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC9E38AC7E
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787865112; cv=none; b=iVSLO0RaHMexFy2sFyQmYZRAhhKsm0hfaGytRWh/Oqpz3aLLgkG80I0SIWCqG3Uo5RwvDsAvpUFrhmMqzcTp6MtOovmPNpZ55szMjkd/LLE+hJGXVaDjrlt98CglkSukfmpPFLdfBXQgQsIkSNAIzuY0XJQbFU5tRBVvDzeKuu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787865112; c=relaxed/simple;
	bh=5DiTONfLGfzVRBMIwWQ+35enC6CcVIcxY6kW47nLHjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qgm4r5w8KUEwKxlmGcOc3U8h8VcFhTIem2QxzobabimftEHehQCWgU2GH4y3Z+igZHrSXNXaTQlAd26bWI5ie5xvurLoUhuXN4HcCBNmsP8xe2+6hLwcn+OPwlWFPRCyPSAgD2dkzMrUqLQw2MBS4r4Mwc6u40hT4P2PsqFtRZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QsxacJvx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XXU7XOHI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QsxacJvx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XXU7XOHI"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RJLrlm125198
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 21:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=b4qSUBRWwKynQruKg+4d/vg2
	0odJ4RqXuTZyRs4vdw8=; b=QsxacJvx+dPTgQNyyBE5KeO2KP+t/kNcNazm9/+y
	vwwEH4yaSuEdezsV9Y6Z4W6Fgh4980zebKRwQUdZqqr0HWOX0prWhOo7B3C5gJIC
	VVJ++4cJNAH4Xqngu6VcwsN8O/SXETnsVGds3f378AhHvfHlTuL0HOe4Yahy5ars
	QQ7P3jGeFtinxAHYVVCwIMzK8lH5j6WVbNYiHP4//G0+WFGoNndhDysEBhMp33ow
	gzT4DcxOB1e6ObT0QRcfkNeWyYZdI7tGJ8tQ1b+n6vZBM0LefFKl+JGq3sjg/rtc
	GBc67qjWe9bwO20/eeU9DXmEoVyPqZq8S58KPGTMWJl67g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4game7tnax-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 21:11:50 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cfa4e4684bso5884605ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 14:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787865110; x=1788469910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b4qSUBRWwKynQruKg+4d/vg20odJ4RqXuTZyRs4vdw8=;
        b=XXU7XOHIVcqS7VH+GMf9iX4dt//5uGkjtIcRfIr+zQen6LM/Ae2GMJFyiFCD+r39hG
         jY49mFrDtBTcg4IqEi0co5F2G/Loe6ZZrgaL+/M+KCy1CVznZF98HQ+80V01UpTD2ID8
         rLklnkICSmbH6Nf/25YOt9iz6NDDxzcSTpTsAGBl+SfhREDNvJ0OGfUgfVi0pFsJBypM
         9LYcLOkFs2ezyGk4ma6yQARQuKhaSY+2Q6Jlsms50Co6C3F4351GLB3yRlWQGUWLwSZJ
         RYjrqmlUhxrloN5YCYLW7zX776wYEMU/Wgf4J+zmrk10FEQoiNimkeXLo3uhBH7jmDbl
         qRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787865110; x=1788469910;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b4qSUBRWwKynQruKg+4d/vg20odJ4RqXuTZyRs4vdw8=;
        b=DdDgRlndqdR7eEIqJr+mZaLnS+7raEWMKY+3+D1HpUiayH+iDONStLEhvkeXQvjFfa
         snZUURppym5gSfn2U1waHDJwnZprlBxE9v7Ewf5jzVHJSgEO9zZQgKMYqZv6GKroKEjY
         ed50ZXyIHgnNwS7FC31YtPgZBn3PvrDAS0Fo3tZ6MF5FnduI3aOfiIGgl1g5mVg9hs0x
         miFOWKCJXf1mR7ewepYz0QtRh2OrXYehDtHT0kfh3RAvAN0aK4HhTlqko5tPEWjpegpE
         Zyn/qUYYygN4meolzWRFvt+wqNhzFXxNuZZOl2SgGcD82s18QEbqBRpKWkkBs0ZdyPvt
         5boA==
X-Forwarded-Encrypted: i=1; AHgh+RqaZDs+M310rMgDHqzqeNI0p2JeME/czToHUwywxaRO2dBknz9JXXA4iNxoKGKKyYrvLHm0ePJwSQRv@vger.kernel.org
X-Gm-Message-State: AFuF++nwxps5zkvBcWVA7dd1D0zYAYzJizLP9eEAbsgRhrCrgzOMIt5h
	GNjOkSmDT4aFp1ZJqUB8jgbsF+3/ad2CE1EZSB+KsJ/RNVaUhS7gMC5/GPDKYAEy6kit/UGzsmS
	OlIwb69Uzpnn9sIhKMOIhu3t39ISSaRWR33bCJKQXS5WHDAR3no5ML1qpjTMKHAHA
X-Gm-Gg: AR+sD10FMPf7jAQatBw/Zi5DlZHyd9SJhbezyemo86D+2tsUgCudjBtTm2kJwkVpPqC
	dV2q0dstZ550nJg4qB5HInYQueH3XTkbq8axG4Jy1Go5b+1MJKTFV+QBwaz1JQ+50SoXUqqJKZ2
	v0de4xQj/YTBitBGFN9/4vOfcRWEt/rIFbfoI83JPtK7V2zeXqxQQN6zoWN/+3C0DP7TOfrHHkU
	BfsGklUPeNFcz/OukEN2/Dw6L3Gr3vR4dYdvMlo56x9vlBHzIStamJ6qtxZspMgi7QTM3Oz5A//
	xVTwsuEKoY7fMYo1oE4vjENx8FPlXPs5jwuLN/h3qHUJg/lr1AZxVu4RkJqA1g9R0J/+dwCwVGZ
	z0qE//SifVPXqavWS2pqpLgBOae7cNVqY2M+2Hw==
X-Received: by 2002:a17:903:b06:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2d74ce16d3bmr35880615ad.0.1787865109870;
        Thu, 27 Aug 2026 14:11:49 -0700 (PDT)
X-Received: by 2002:a17:903:b06:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2d74ce16d3bmr35879605ad.0.1787865109415;
        Thu, 27 Aug 2026 14:11:49 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3285f3cd3b0sm7758654eec.12.2026.08.27.14.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 14:11:48 -0700 (PDT)
Date: Fri, 28 Aug 2026 02:41:41 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
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
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v12 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <apCoDfzaQBGgJu4K@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
 <d8304387-ecff-42d5-8cc6-d3b4526fb294@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8304387-ecff-42d5-8cc6-d3b4526fb294@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDE3OSBTYWx0ZWRfXx2nCal5nbATL
 8HnljHEanwAEOEEyHLYyyeHamiy/apBQihmeVZuzH/VNzlUM4bMPlilOga6h2CuR/BS2jNrahs8
 2AlpCzUeKXlaWW+yWgV/6DDmKskQ1bj+2jZrLYiTqTAQJbuI3Fu6DZNYJGER8uPZodRCD9Tspx4
 +bJzKj+EbdW3/C7bQBKKhuywoKz89QnbsTBYPnhr39JGN0SjsK/0rAuoqxaBnZ2Mo8P/uP3S1KP
 XbFl5E9dTazOlqgDZ3vqE/etTES0H2itL2+RXL7gvpq05RadrAtvhaXyuI+s5P5ucJvoaxopFT5
 ldCHZ3FMYiiR9epVHRcrC8yHkqvaKbuzOhcDwz3MdwcNjvWot95UtHBxnINcLNDUFOy4Z+/OLne
 8DJJgFihTAjU/YGsRtCz4T/4dARhe4EJJdNSSJ7OL4QHS1ifCpEYLyG6tctInH2BE6lnBUxs8ut
 0WIbM/+XeRgkUQFfFmg==
X-Proofpoint-GUID: 0fqS_VU8q3P2sIRaqshGPCWTs481vlqe
X-Authority-Analysis: v=2.4 cv=Yrc/gYYX c=1 sm=1 tr=0 ts=6a90a816 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=AC2Mn6xCbOXL0dGbV_AA:9 a=CjuIK1q_8ugA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: 0fqS_VU8q3P2sIRaqshGPCWTs481vlqe
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDE3OSBTYWx0ZWRfXz9IQMZbX9Mby
 ayPSHBeRVkL6QpZxDoS+GiA2KugxCTmPHh5XVLZcGAUXwekboDVKCyzOmeJI6E2P8GanGgt+eMj
 /H7nttDimaxNqWTAAycFkI4r4u3xyzs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_08,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270179

On Thu, Aug 27, 2026 at 12:17:02PM +0530, Kuldeep Singh wrote:
> On 24-08-2026 01:17, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > during device probe. Attach the OPP-table with only the ICE
> > core clock. Since, dtbinding is on a transition phase to include
> > iface clock and clock-names, attaching the opp-table to core clock
> > remains optional such that it does not cause probe failures.
> 
> iface clock and corresponding dtbindings are merged for v7.3 and your
> change will land post that.
> We can drop this from commit message?
> 
> I think we should scale only core clock and for iface clock should rely
> on ufs/eMMC controller maitained frequency.
> 

The idea here is to scale only the core clock and I am achieving it by using
dev_pm_opp_set_clkname() API. However, for that clock-names needs to be as
required property under DT bindings for qcom ICE.

As the comment mentioned here: https://lore.kernel.org/all/b32c7091-b2c4-443d-b58e-759b471f67db@oss.qualcomm.com/,
the current dtbindings supports backward compatibility with iface being optional,
hence it is expected that driver should be backward compatible as well.
Once, we plan to break this backward compatibility and make iface clock and
clock-names property as required, we can say its out of transitional phase.

Abhinaba Rakshit
