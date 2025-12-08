Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B261419A9
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2025 06:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765176088; cv=none; b=CHLNSDC8uHcROY6KmELvTCR/d57OAzW3Z6JBi+QdBzdDdZmUDd/waWYx4fXVck2XfsfwXUG+2lVuXjN/iOgtMFKVoxTWXm/IcLZOcwEVhdnpnK5AciO6NCZe8LEGPKLrEyXop+uNND7DprVRvAiYPD4uRsNnwHfJU3F3RJQDy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765176088; c=relaxed/simple;
	bh=k5iUnphT/T7MHXqI7HQcIM0UNu6C0d12wJAiXFnRFRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRdDdyPvr6IhWWmVZV3ZiTvT61yZlZdFckYyPBoa1JbTA4ZQNKefDOgQw2sPBL9v0fFuGPewDMvqKXyPAYVkKrud+Y1cnBneOvJDErmXcvKFI8ckXYn2rbG6zJQUeGNqhdrohvEKG9sgBf8liMy61220/7/nhov2f+z6Pa2i+jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E4CJoupE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iv6EIRa9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E4CJoupE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iv6EIRa9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B7N2TNP2940608
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2025 06:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LSDqhiWm+CugFyvYJbKry5IzJEjaCWJe0/yuFEfBQNk=; b=E4CJoupEZOYcSqFF
	cI9H+LPfUWvIZTgCXUFcpezmSJh6aiy/XBUPirgPFjg4Wt95Ugv0XVXMXBisHpap
	1+gIaf1cHW96CxGTJwEdZpuS0dYDJNW5vt8X9sPtw2ApXxpLWzuJq/oLRlwpZjHK
	U2NfsSA2W68HupbwfhMPGcERr6WtaJoTw18/xM7r9hYHSi6JWg0BWJFbwU9utQNh
	9YDE0roh+8Ryk9cY3xwGT3Wn86bGNG1CZROVc88xow/KfypBwPf58srvyaD4zRLM
	xx1+kiQQ96brdCKALnj02KiJ079xnX52gyye5HeI1Ok2nlVtxenodRxmZni8PoGh
	/WYqzg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4awhaqrwjs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Dec 2025 06:41:26 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297f8a2ba9eso86295255ad.3
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2025 22:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765176085; x=1765780885; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LSDqhiWm+CugFyvYJbKry5IzJEjaCWJe0/yuFEfBQNk=;
        b=iv6EIRa9LUGZr0Nc2cO4sFbiNqunKYaU3tUr8aJpTQHCI2u11DC1r+vSayD5Y3Nj8S
         Ho+pEjwm6Fh6NlQqLdlQfw5R7zk8kN/3ZCt4G+/nh1+enAZsULTMTQVv4ifUL5MNDzzC
         ouo5BTe/XfpL1bK6yTlbYjQsgwo/BL7vV2zJJNa1AhYwu6mwOsluTQvzITN6IA5iGfz5
         Tj/IqycyGSBcDWsMD40mzs4kDpCRwQN6sI5+2orDrFPrVU++NE9ToL2gzRjLn/jX5OcY
         6vqfljA3XoBZZRVXUu9Zixkxpskrmjui3GXzgTq+tNXTo6L+YxxoMUyhgVOLora//HlO
         5vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765176085; x=1765780885;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSDqhiWm+CugFyvYJbKry5IzJEjaCWJe0/yuFEfBQNk=;
        b=GzBV2rr8dxdFPVZ1WMcTWCkA8A2W0kCrhxVQ1TcSGhZoV5Ppz8TvSqJDzR9sUJi0X3
         riPQAntMnhX8HsLuCBSMN7lzvFBoaOzYUja8m503jPAUgj+sQkltGTo3WcPzZnWg1g3i
         neishrn2aanxSLZjJStPYaY1twaWzB2uawhs4Gty5NU+yXwpDnv7x2rAKt0MJhl+kMbO
         ZyXiXavokwG0zu3Y3iTZGu8S4U+0FcIY4qY0qFC12Ed5KF4qmykKma6sq6SJ5DDcPSPl
         jC4EYydRvVAqigULiicDCoS71xnQjzt1zMduQvOTQCvC0YURImyBli+nsneM4jpMtZIa
         lgiw==
X-Forwarded-Encrypted: i=1; AJvYcCVuQCmbrRqm9qUO7qE3MSpOD88/ANpsTpPNPT4igGBLI392k4KmD1oiDqyfi6Lzvol+nr8OVA0vAKUE@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0iw3+Ej9+zujI4hcmwrjYJkoIWJUK4BLDPdzvWfO50uedwrxo
	QR0pwtljutLBsL0VuCJ1LyKVwH74JWsbiiqVAFy6I9RdAUDRYuXrTdcfNXoJeFJWBzyrWxaBNzJ
	GOmthoXJvwbBN/s2U8n/gagO16BPyYANZRyWVHleuAh3uDiKGO3HpLW4LZ/nFmO6h
X-Gm-Gg: ASbGncuOYnKuyRbtaZzT0EdxDElXVcNbG5oMJ4o3BmXfWmF5vlZElNbFDtjeMJcDWSG
	eqA3pg8IIabVkb4xlsgrdc1ZsH6dnhXCjaw1Ir3N0KGiLA+hjrRk3LlfuL8eQ8f4Y56llu/x3gl
	20fWPH23w8cN7uVBCsEU0XzMETE587JFEXktQuAz7JoxrLlrX8TddkuV7lJzKVzIEsn1BHIfOMY
	cxib0P0dgVWjn5l1tbwVQLpHJYm85ILhezI/+A6nwwqdtNsPl8f9iwPqypx52giZYvp1znxOZBm
	/0tprlyT+9CtviAxHYqlJ0HCO+Dme2m8w4n+dkYNWIGD98fWvBO9IOkAaz1RnE/AHc0mlAXIk37
	o6+knks9lJRmWdm6UgNdGkf75EOZ9qBTD0V/x+Y8iHFnXwtQ=
X-Received: by 2002:a17:902:ccce:b0:297:f5ad:6708 with SMTP id d9443c01a7336-29df5dba64amr52343575ad.43.1765176085449;
        Sun, 07 Dec 2025 22:41:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbH93JyoiyzCcfWOerrtKg9NHJJBFEqgi3KY+ZTtd7cQp80NU3qg+cSsp6pAje0M2d04qVtw==
X-Received: by 2002:a17:902:ccce:b0:297:f5ad:6708 with SMTP id d9443c01a7336-29df5dba64amr52343325ad.43.1765176084991;
        Sun, 07 Dec 2025 22:41:24 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99f027sm114818855ad.54.2025.12.07.22.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 22:41:24 -0800 (PST)
Date: Mon, 8 Dec 2025 12:11:19 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aTZzD6ujz0+mZD7j@hu-arakshit-hyd.qualcomm.com>
References: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
 <20251121-enable-ufs-ice-clock-scaling-v2-1-66cb72998041@oss.qualcomm.com>
 <c04cd051-b6d0-4d98-ac2d-4fc7ffcb4301@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c04cd051-b6d0-4d98-ac2d-4fc7ffcb4301@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA1NSBTYWx0ZWRfXytuT8meZuriy
 YCFMZCQy/TtSxvY4TkcAHhFEhZqYvBE+qu/AZF/1zeVHtjaoyIiCc8RMKPiIDLj+NmGViAevOZm
 Inee5YJEJUa4m/M8NHEtfpr1xAqMzaGleX0tNN5wDYJn3vjXkmoqWa3PjvvTwQ7HsM6PN1dmC3W
 VJymki1jZsl9HMaehv7se/i2DmwkjM4RnEZvPgPgEDTjyhjLurIIeJ8hlmEBd/n4OjBo0viiJB0
 zpJ31wzJ1CjK+Uv9gTGQZ6l02LtuwnWtVhnuGQh0DQxBDRVLHDRxkVkurylTE5i6NiRZfWIn5ii
 DCD24/p+E0vYHnPrC69l6z/JXezQ5nttr+tki3sSTpoOPOEpdD+09uhWm6jHLcWhWr8mNhKbC19
 gm/aFOM2xyvg7mpo1c2oA7xIRPx7BA==
X-Proofpoint-GUID: C-hRLF2Vm8u--udFDlBqWZIC_hesfwnG
X-Authority-Analysis: v=2.4 cv=ItUTsb/g c=1 sm=1 tr=0 ts=69367316 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=2r6_o0aEtt8sHetHFGkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: C-hRLF2Vm8u--udFDlBqWZIC_hesfwnG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512080055

On Fri, Nov 21, 2025 at 02:46:52PM +0100, Konrad Dybcio wrote:
> On 11/21/25 11:36 AM, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > and aquire its minimum and maximum frequency during ICE
> > device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock if valid (non-zero) frequencies are obtained from
> > OPP-table. Zero min and max (default values) frequencies depicts
> > clock scaling is disabled.
> > 
> > When an ICE-device specific OPP table is available, use the PM OPP
> > framework to manage frequency scaling and maintain proper power-domain
> > constraints. For legacy targets without an ICE-device specific OPP table,
> > fall back to the standard clock framework APIs to set the frequency.
> 
> You can still set a frequency through OPP APIs if the table is empty
> (and one is always created even if devm_pm_opp_of_add_table() fails)
> 

We observed that when devm_pm_opp_of_add_table() returns -ENODEV (indicating
that no OPP table is defined in the devicetree), subsequent calls to APIs
like dev_pm_opp_set_rate() fail because the device does not have an OPP table
registered. As a result, the clock rate cannot be set using OPP-based helpers.

Here is an dmesg ice driver logs for lemans device without opp-table defined in its devicetree.
sh-5.2# dmesg | grep qcom-ice
[    7.316366] qcom-ice 87c8000.crypto: dev_pm_opp_set_rate: device's opp table doesn't exist
[    7.325596] qcom-ice 87c8000.crypto: Failed boosting the ICE clk to TURBO
[    7.333288] qcom-ice 87c8000.crypto: _find_key: OPP table not found (-19)
[    7.340968] qcom-ice 87c8000.crypto: Unable to find ICE core clock min freq
[    7.348832] qcom-ice 87c8000.crypto: _find_key: OPP table not found (-19)
[    7.356510] qcom-ice 87c8000.crypto: Unable to find ICE core clock max freq
[    7.364377] qcom-ice 87c8000.crypto: Found QC Inline Crypto Engine (ICE) v3.2.0
[    7.372594] qcom-ice 87c8000.crypto: QC ICE HWKM (Hardware Key Manager) version = 1

Additionally, on legacy targets where ICE does not exist as a separate device,
the OPP table is managed through the storage subsystem. In such cases, using
OPP APIs directly for ICE would not be appropriate because the OPP table may
also control other clocks, leading to unintended side effects.

> [...]
> 
> >  	/*
> >  	 * Legacy DT binding uses different clk names for each consumer,
> > -	 * so lets try those first. If none of those are a match, it means
> > -	 * the we only have one clock and it is part of the dedicated DT node.
> > -	 * Also, enable the clock before we check what HW version the driver
> > -	 * supports.
> > +	 * so lets try those first. Also get its corresponding clock index.
> > +	 */
> 
> I would argue *not* setting the rate on targets utilizing a binding without
> an OPP table for the ICE is probably a smart thing to do, because we may
> brownout the SoC this way

Understand the concern here.
However, our approach is to scale the ICE clock only when the storage subsystem scales
its own clocks. Since the storage driver already manages the associated power domain
and voltage adjustments (even for targets without opp-table for ICE) —which are shared
with ICE—this ensures that any frequency changes occur in a safe context. As a result,
the risk of a SoC brownout condition should be effectively mitigated.

> 
> Konrad
