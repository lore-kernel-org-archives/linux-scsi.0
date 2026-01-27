Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EB92857FA
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506311; cv=none; b=CPmWddDrZE/5p9K4Q8RIC9ofPOfU4+coKBdIR06V9cdHfuz0J3uZGVSd2XN/Vlt+R4D7AtBU+piGFf9Rc3NKfquudzp5TmK90n31xUEMs0Z2K4IrPUXB1yimv79qV1xV70Hgu26J2Fb2oSbEIRyNa1thKlLOvNv8NPlZXLW8JZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506311; c=relaxed/simple;
	bh=h3npmff8M3XFVgZvC0hZB5CpQpsvBhOspR9SPG5vZDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HupNaQ0lu2bupEZA5FNS4AK+4GqDKF2X5URXb/vvAKX/WOEpWXkIpPaV0QbATe5I5doGabeR+g8DsIwo7QSC7291mp3COBknWCtrNQl810m13fzmhoJtKsI8DA4HezT5unur+bn1xzB53iQNKD5nMw5QiFc9orSPZI9xJV1tLAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SgnWoRMR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IUYhv25x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SgnWoRMR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IUYhv25x"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R4U6AX171374
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vmDHSjdW7r6E7Cs4UyeHIlulePC82WTKEubnvNqm1pQ=; b=SgnWoRMRvVSMjGBe
	RoOBDfg2DPpU9kkIePFGNC7fu1OZyy+eYAG0cC8z/N5r4JDJllZ8PJT3Ljep0rWL
	siPLP/DIRrMS4S5PpWPXeYkVZU1rqDD8y51xNs7MC//yg1227f+WYKxLvbKevB6P
	Y1s/XD2y18N7pAK/MN3VDZnNgB4zSlHVuoet4nb9GI+esrnhx6ozl5wTfj9/C8wJ
	NnFBjQ7HauaL2VlFq6LdH7Xe0OaOtXGvmP5gm88IEOBo/lr7wjuZNOXC31qZiKrz
	6xXLX6/3EyK4iRHNJ0RtpAJHizqQsZz5D6dcWw7ocIPOrWu3bZ6zuRN6T31HudQ9
	OelYNQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bxf3a27je-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:31:48 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a75ed2f89dso45120465ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 01:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769506308; x=1770111108; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vmDHSjdW7r6E7Cs4UyeHIlulePC82WTKEubnvNqm1pQ=;
        b=IUYhv25xJS7rtfbf5OjI8b0CqwCotbr9Wy361XaidDXj4vb9Rz2HMhjx2soALtE1kq
         WrRbdH/HWMkHA9xCI7zKyj9wOdejySUzzKuE2WetyvH6CZLBzFY+J0pyjGmF2W7Abfza
         8wmUHaFw1m2FuPN5NHvpTO7DMXFpBSaBNo+8svk73BhD2kyFRIb/Y42Bzx3H9H7YCv7R
         mG33mce9n4Qhvh3ZNusiVWWIXvrvVRIS/nNm516nifYuJGryi87RG0douZjZMkxUJVeR
         r6IO0fRDLt8JdEu20BNM3OMFWxHb/FHF5hSgOEL51stXklKnbYbc6DPGmIZ1gDzPWTs/
         d5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506308; x=1770111108;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmDHSjdW7r6E7Cs4UyeHIlulePC82WTKEubnvNqm1pQ=;
        b=IqT38CIF4UMW2D2QZcctIePPsUaDoVZtfevjebKccqclUdVzlw0prOL3pzr2KCWE6F
         iGyAIc/YriQn8+LoLZ6jLk9PRviwEhB+HvpfPXuvUqU4XmKIGdRa1bOnR4DWRz08Yf1l
         58AdTF+jfgoz6p8bOp8BcQFS/Ee0ObGIepMEkWzh3B6TJUGB4Icd+4PPh09/oYt7Mg3B
         +JjGX9u9t3Xu7zE4Xi1hy40LVzh3glxdoRiqotY+av1cldaGkMoQMrfrCVjmxn0fVVdX
         nYTP+zcWrLlKehjI/bDVTRhc2Xu4KOXEi/bVNwtL6+Rb+/yM9d3c9/Oic4s4zIHFblDK
         g+lA==
X-Forwarded-Encrypted: i=1; AJvYcCXsO2WZQ+2skuqWMJUww7De+rPt4UYAoe+76O6nEpsvTgq3QWqmvDe8GpSVDp6UR7aAqD/PXE1Tr89F@vger.kernel.org
X-Gm-Message-State: AOJu0YzCIWcSpMuxBy4TY9DIRku+GXnWzVXxagTpopsrRInw3T2Xe5GJ
	HYLqF1Upuhw+LJSlfeHwsGmbu+IqLbpQSxbdoRPmCY6PR3Ekhd4QrWPa97zp0Sme6XSwWIyKB8a
	bdyyqDbZX069RuKmCRJeFeTMI+SonoovK37cm6VY2XcaFXqGsdo+QoPnTqtSRQsui
X-Gm-Gg: AZuq6aKHhIISNhjvojS8ZLnQEy4hb0C2F+/FNp2O14GvHnydzxcHmRfWsOd2SBl+gXY
	d4rr0AcuZV1WSJhZx20I4+OvzP71sbnbios3MGN7U3jha55lEYlDvBGtSe+SrO7+6Lpz1cKDoCW
	q7Z0P+bIfOSm3ajdg3TcBmHB1fAY6jJbM4VAWLQCF1TMWnIn0E7SYXDyEDXPBMXqq++w68g1WW7
	/czOm0H4hnD3JIYu1uCISKMD5vLJJeCgh5b4xAqA3nzzMGzYzMOKaHkocFdwqof8gm88KdEG5U8
	LwXuMX4T/+nDP/RpvfcrKk41StEbNa3QFCNQOSI+Kf2bMdBVSl4rI/CI+5Ij5NLlQ5fB2rJAW4i
	HZvR+yco6Zl3Z5mN7dvxLGLol+BxoveIZrpxpkSzY3hBZcTk=
X-Received: by 2002:a17:903:1aae:b0:2a8:7814:47ce with SMTP id d9443c01a7336-2a8781449cfmr6915415ad.23.1769506308044;
        Tue, 27 Jan 2026 01:31:48 -0800 (PST)
X-Received: by 2002:a17:903:1aae:b0:2a8:7814:47ce with SMTP id d9443c01a7336-2a8781449cfmr6915135ad.23.1769506307531;
        Tue, 27 Jan 2026 01:31:47 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fdd4e8sm112566615ad.99.2026.01.27.01.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:31:46 -0800 (PST)
Date: Tue, 27 Jan 2026 15:01:41 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Enable ICE clock scaling
Message-ID: <aXiF/W1IooozQlV9@hu-arakshit-hyd.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
 <cb6g64efyoauel34hsckp3kwfprw7etag3fthqlkucz4ue5ytf@t4gejdalvvow>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb6g64efyoauel34hsckp3kwfprw7etag3fthqlkucz4ue5ytf@t4gejdalvvow>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA3NyBTYWx0ZWRfXzYzBYWfhnqzp
 GjsHA201vTRt6vbrY3IIukoZPIu4Kmgv/iLPqjEnpe1n9mun0CZmtBNOOsSlq5gDsO04/3ZCB6c
 lRkQDJGtcoeB4JPDI67jdT5uJy++gWdrGcJIF3jgMBaIoUj73j+xu9mZahAxNMeZ0VIHaK4aSBX
 WizWE0w17p+lCTcG18r0KjiTg7lXcENeJh7I6CoL5R8qVOsu8xJuU0CrjhJbXHIOXdr2MbqQ3b9
 rnN7/aE3QGZ1PYUEqCQoJYXKNfNqbEG1ZhlhsEWadYB9gikXth6WZuZa0ZkBOP9x4s5ueHCdzCZ
 gIImCvfaqsOSlTGc6PJ/ks0xP6QVytolF4EE4VOfLU7B8qRDTmZ4QuGq3/wVrVUp9BBn4N5D5uS
 W7BftZV9oUNKybwJxtN5a5CUJDt3d39JdTvl3FYdocmNzWBa6I9qEj/IifDv3rPZqijIJlJBYjp
 BJtDmWznXrTdf+myrrA==
X-Proofpoint-ORIG-GUID: oiKUw73cFW6qxCy9oLNYDhGJNe3PhINV
X-Proofpoint-GUID: oiKUw73cFW6qxCy9oLNYDhGJNe3PhINV
X-Authority-Analysis: v=2.4 cv=a6k9NESF c=1 sm=1 tr=0 ts=69788604 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=A3LgJq9kZUdRc3Vt2WcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601270077

On Fri, Jan 23, 2026 at 09:18:36PM +0200, Dmitry Baryshkov wrote:
> On Fri, Jan 23, 2026 at 12:42:11PM +0530, Abhinaba Rakshit wrote:
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
> > 
> > Dynamic clock scaling based on OPP tables enables better power-performance
> > trade-offs. By adjusting ICE clock frequencies according to workload and power
> > constraints, the system can achieve higher throughput when needed and
> > reduce power consumption during idle or low-load conditions.
> > 
> > The OPP table remains optional, absence of the table will not cause
> > probe failure. However, in the absence of an OPP table, ICE clocks will
> > remain at their default rates, which may limit performance under
> > high-load scenarios or prevent performance optimizations during idle periods.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> > Changes in v3:
> > - Avoid clock scaling in case of legacy bindings as suggested.
> > - Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
> > - Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com
> > 
> > Changes in v2:
> > - Use OPP-table instead of freq-table-hz for clock scaling.
> > - Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
> > - Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
> > - Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
> > - Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com
> > 
> > ---
> > Abhinaba Rakshit (3):
> 
> DT binding changes should be a part of the same series.

Sure, will bring the dt-bindings change to this patchseries.

