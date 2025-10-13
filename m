Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9DD22A7E5
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760358877; cv=none; b=HgXktAhM4eSr4BoLOTPKqf2R1LFpQmDy2gsyfjGYYvBTjBMRPfYFNC2JnwNgaYr2Lo8Brgvn/v2w7crGVwmI/0nN/qh+moVPDRMpk3sg4q3EpJd2cKCH3P2qkDGhH9Y8kdgDZ87yhrowXibAC7lO1XbT2hzsMeMeb/fJVb5wxUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760358877; c=relaxed/simple;
	bh=O5IBxsN6ic5oG/r8QyaBfjvgKnYuqZyVcNxtNddUJ8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEAUY5zIxIHlku/J8OFEClLH7N+l5Pjs/WkxzWS9pdKwKZgAL6Ps+yoeBM1z622sfCUdyAjnhcwmCNOc2a6WS1NPWRiHGQ6KFgr1AbxoYBuLdQcY7410fqfKKm+xQdRRy6FYvH6SvoiiRp3GCsPRNR/CsXpjJ1Th9MbVHX+DfDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cHKE6Szt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cHKE6Szt"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7Q96N012691
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=0c/YLYaDMoEGnP2p+UDoLSwW
	bwVJnzjUv4KnwNKCfEY=; b=cHKE6Szt423RB8gknU+LDvdj0Cuw4qswyTZSaxAw
	3Vln1wH/aKoGO3yopYn8nbYnpcw2S5NHX7Sm79VwKwLYqcQLc+ZXI9mJfef7hziV
	AKyPZ2BlBcuN5v238ZNwTY7D5BQ55vFbmhOXJXLfe40w7C6yQPCZFlJkWD+9Scay
	ynngzBZIK4MUfj9Pj6V8NhLYw4l6QgLJ27bWbS19Ao6+8gDR/kWDmmWrjCyZLQJS
	Drz4A2m+5QZP+VC6nw07jEHuiMMqSvOsKt+L4sJGzjlqmM7rq0O7DHaJwuV9FO5I
	WjOXqD+QR0hcatHH0bdFdVzbAjOv4iTSBuOaVcQi0GtIuw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49rw1a8usc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:34:34 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-883feb13e83so2674737285a.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 05:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760358873; x=1760963673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0c/YLYaDMoEGnP2p+UDoLSwWbwVJnzjUv4KnwNKCfEY=;
        b=X3z49lO63gGQeJv9POF4+9eLNrfBZcCiUAuKDDCyYuWk0qEgYJRo5PfEtqdicDzU1I
         xIZGqojbwb13uRyF4Vd95GKwNu+K/kjkjX7Cgr1kchduyreF9B3IcW/CMefd7M30cwFW
         UHZSGXGTW6F2F6oHrFMptYizzvWWXoxpSSWdSBPTt17g+/8UTOKc+wJJ5y5m+UHsTsGY
         pYh8TQu0QVGEhu8TTxhHxEhr2Rp0mSynduJmhYXEoXmLpYhvGwWoVWoQI1oZ2OXGm6yn
         FO9l4fxbFVhTSCEmUSPO8L65bn0RA8AOWHTSO0Ie5Id/PkzTjML4K2FuDzCWPuYf+3AG
         FwFw==
X-Forwarded-Encrypted: i=1; AJvYcCVcrLGiOCxl0PDkgoj8rEdFUGG4KRHAyu2YJEgBqJ9H85FJHg4fseqtjIZ7yfHIbVgxYUsjvd9Rsdfa@vger.kernel.org
X-Gm-Message-State: AOJu0YxnpDoAZw61Rcr/PFI3/GlzaAVtjZOhLozKQoMDcrbBx5JP5A8q
	e/fVQVyUoSwg7zfbFj+9wc6fcerErttC5h1fC5G+MGiQHf7fzyfV5MWViRz6PBYeNhBQNKJR1MU
	UeZ8bOsS4/IijBSs2hbDTuJzWPr/0S3YnnJVAN6kuzHLK/XoLG/55VH1Pn2HNYBRl
X-Gm-Gg: ASbGncvOAbDy/NjNvhbeS7ZyVWhox9ZDN6CXYa+2ITD3tKci14oLVNrebHKYaKJ3IAI
	/kX0C9EeAfhdw5568EtVAqhvNwgjv7PdcQH2ORRlDniRw4bDbxbqNPpy7noYdgkSEgyZeyXDGsb
	nuHoM4Jkx/Nj6Tbg6pEU42piU3GRvcreXZDR0Ik1s1hbouMRCqiogeBnAGvyp9/btLYLzPTOrJq
	3P1lpkzF5wx/I5YkVWGToFgEisVsKAsy7O63t8CP8j0Qizzl8WCIRyI9IttnaNKka8UXt0gTW7D
	hvuxEiNME+vaO2WUmI3phbxHczVSxf2mG67vKTERhpx5lAKRldjpMFUt5M4DMsnKmfQMFyrtOQ/
	A2nOKEQcUH4Xvdc8oF+zr5xmjEzrOfkuQdgzAD/H5Y/WxMTk+PrQM
X-Received: by 2002:ac8:5d46:0:b0:4ce:9cdc:6f2f with SMTP id d75a77b69052e-4e72122afacmr71752651cf.13.1760358873404;
        Mon, 13 Oct 2025 05:34:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNbh12YwL4Iy4NRipEsFChMHtKqDe+smfm+D7B0YFilvKsxmQIYfhkB/7L1zjAmITtmN+oiA==
X-Received: by 2002:ac8:5d46:0:b0:4ce:9cdc:6f2f with SMTP id d75a77b69052e-4e72122afacmr71751921cf.13.1760358872891;
        Mon, 13 Oct 2025 05:34:32 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-590881f862asm4116608e87.27.2025.10.13.05.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 05:34:32 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:34:30 +0300
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
Message-ID: <7jmk3txdrnit6zn7ufra7davmomggd3graizdu6wqonp3lljza@mfnxt2owpknq>
References: <20251013104806.6599-1-quic_riteshk@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013104806.6599-1-quic_riteshk@quicinc.com>
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=68ecf1da cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=sf-Njp88EExxdhEklOUA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: HewcucKaNl9xjyswPu27jXcEnC8dSwF4
X-Proofpoint-ORIG-GUID: HewcucKaNl9xjyswPu27jXcEnC8dSwF4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDAzNSBTYWx0ZWRfX0LpDx0x1nYAI
 enTLahIHs7JtgcOBSfOJzDqmrwbipaXqXHHKoHXbuM6MYuMGAibvuOv7dJ6lmHklIPL5ZjA1Yy5
 NzXjP1DUmIp7dQGxCzJdtsactzTrzQRZL+effKTAQ01iGfqEB4DjQtQuGDhoBzXCVdZSDmT3d/4
 24Pns9Uj5ifLuZ0OJktTh1MDvHwQDeWCgCPhSsqqtyzFRCxI6Fn0g2/5i1+dxoPLpHovSNOdluo
 b6TeCWBNZZdtkgVEJQeLR5JNy0O1wVTVkGuZrRYd4S8PeytrOxG+nQPviimc2H3Fia2EzM29edR
 8WgMA1zwBWdeFE8MORadsxEHoyt3k7iWjts2C/5kFvFTXa12lCGwhFiEkO+Pl3N55IQ2CLOO6YU
 0JlvQuopaDJ1Wr/4kKDG4VZ/6no+8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510130035

On Mon, Oct 13, 2025 at 04:18:03PM +0530, Ritesh Kumar wrote:
> On lemans chipset, edp reference clock is being voted by ufs mem phy
> (ufs_mem_phy: phy@1d87000). But after commit 77d2fa54a9457
> ("scsi: ufs: qcom : Refactor phy_power_on/off calls") edp reference
> clock is getting turned off, leading to below phy poweron failure on
> lemans edp phy.

How does UFS turn on eDP reference clock?


-- 
With best wishes
Dmitry
