Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEDA2EBBB8
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755170774; cv=none; b=eNPAJRL2tXbtRjnd8MClYl/bl/tdptyTe8ojPArAUstFVaODEWEU+AvxezFPz++f0M8rWYnTjyq+rxp3eDcfnlz+zaxjm3RtcxkZmG1F/mA3m3/rslw7Bht6pupW0tlge0qNnVP1sMmwSfIdQy7Rpfeso951R70ZZlrMviTA960=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755170774; c=relaxed/simple;
	bh=TXbSNiEB3R/2ieN7xtCoarUmorqxnfg3YNjh0dqu3+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJydADI5Eyk66TXUyUcyKCxhM2iB9ZfLA6TJEMFkcDvlge8qGCX/aEu3udXewpgnkcEaabpJS8XrKgXhBArKNsOmWfIN04RFaPF/lJKsurlF43Wf0T9yd7msc+mPc2So0SzSphLiJ8VhUOO18iYHiJFx8Wt9MV7HF31yMyA/Jo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U8Lzcoi0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U8Lzcoi0"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E96qq0011085
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 11:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=9l5Xf7ay6Os+hJPhNXMLzGQB
	mPfNGIe/A5XHYvxm8IY=; b=U8Lzcoi0K2t2nPu4CVPuCIGWaldrI1vDN/RMfRyw
	6fj6vqz+Ek+TPMf9b+QSMIPbHaW1cZheiHo3aglRKRBiTSdCNEgcN2827vSTNZHG
	j2NiTMCv0Ain6uCeKl5ytRi9zqa/1j0dqwt0jaMWPlFAr0WOcTrCQoxBqamteMNt
	CCyz08J73RhTlx7Jq5JrUuRB1lJUFX9yNttjvu8eRXmPp4V2wgWf9wywfC551VTZ
	M+ClCLiDqKsLT5WrRNXHQY2pzoDqAHkb3ndybAAd9IbUiIa+Nt5605T9NX8CQGnr
	3OmuuCwBBMEeC/VQGQIM88fmFg8xwUtjkupwJsGyQJplVw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48fjxbjmu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 11:26:12 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e8704e1baeso208679285a.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 04:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755170771; x=1755775571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9l5Xf7ay6Os+hJPhNXMLzGQBmPfNGIe/A5XHYvxm8IY=;
        b=m8oUqst5h7kyCFBOLH3e3nhZ355pw+6zOEIGLynJgT4DAs552fQ5ePJ+iDbS7NqXZw
         zj+0cywFqcWrLFtammQHHiAx08Ag1B8rbvlZTAOb41h/7URCx1QpWfwOWoqHMa39ekCN
         T7A1vjg5MfZi58hIm4eTBtMesfUxBo43sb3okpnTQ3pyCZmzL5cvtBlWvc4MvGtsUGve
         QusXOSbWK/ydipGUy9wups4zqJZz+AqECDerUgo6urIvQrDMXRPaXmD9eb8OZpeSaxht
         oiuNnba2QbXYsA576IjoJCgOLaPY7j3Ng8B0DqKdER32xwMf535pP7I9d+11ZPcMP1JD
         4Wgw==
X-Forwarded-Encrypted: i=1; AJvYcCWo6YLTxlZ2N7XKt4SNw1Pn0zqKxxvoAvqZTtPsj03h1kSR7sy54+2k+K9DvoHcKqkd+2YAqwJYQOLc@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm86NqLgawyfVVktAqcdihl7oghNnqfiwmluOyo7cpCq6TY5Cn
	/4L1b5UrbR+HhmL8Zd0gF7NUdVZDjGtGaQj7qSgSAJMzRqiffzESSZa40TvqLlmAx2FGoDk0P8b
	2z2d34q4YApbWGcJ4yZgDlMxkrUawijj8WBqQEejp7z8bJqPG1ep4DUh1AgLMl3EH
X-Gm-Gg: ASbGnctMwuE4j7w78taYVMMPMQma03Iil9bGujOyTDUQ+cmfjvvhHwVmd5EfFJ5OO6h
	F/d5dxgSeGL5n9NUJ7am6MvzG/nxYDrvRAl3slHZ0+hXgSSbPLOJS00msaoddm3rv/Sq2ZSnTdy
	6UHCQFP43oe1gKpLH0PwPg9FbiGa7a5r1OLYP5I4ZrJ240nmv5/AVeVjRS9hGjl9AkJ5vlDT6OS
	/uxFngpWw6aYmVgCTZOzeZFfy2DgwVLLscAuE/GOK7QdnQ1fZ9nfjxTO/uthc3zJVCCcUlJEDJ6
	FRaRghiX+75jmXabmlwgm3MnqUREDZhTThUBrHogNkosUCIoWZYCbLHU6YqgpK61FsdazGZCdWQ
	5LN6VlnpexIC5NQBrLiq+bu2yEiAUawFvG16A9uPsQJSYBpi5zI74
X-Received: by 2002:a05:622a:511:b0:4b1:dd3:e399 with SMTP id d75a77b69052e-4b10dd3eb4fmr18484591cf.64.1755170771057;
        Thu, 14 Aug 2025 04:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtN6pLL60KSnafzV8jSq1qMtlj0g/UPMsEkwHvO3oPzQWBiZQja+mqbp1z25h70yy7INfOYg==
X-Received: by 2002:a05:622a:511:b0:4b1:dd3:e399 with SMTP id d75a77b69052e-4b10dd3eb4fmr18484171cf.64.1755170770552;
        Thu, 14 Aug 2025 04:26:10 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88caf0ebsm5610119e87.154.2025.08.14.04.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:26:09 -0700 (PDT)
Date: Thu, 14 Aug 2025 14:26:07 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Harrison Vanderbyl <harrison.vanderbyl@gmail.com>, marcus@nazgul.ch,
        kirill@korins.ky, vkoul@kernel.org, kishon@kernel.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] dts: describe x1e80100 ufs
Message-ID: <25c5vwdgrfar6rz657nyijan7ozo5nzyyxb2w26wf5rvxftkvm@wy2fbsi77prj>
References: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
 <20250814005904.39173-4-harrison.vanderbyl@gmail.com>
 <tlkv63ccpnti367am47ymhaw3agjnyuonqstgtfaazhhptvgsp@q4wzuzdph323>
 <57ce520f-a562-471f-b6b4-44f0766a7556@kernel.org>
 <aa0ed59a-4eb6-4f7f-b430-4976ee9724d8@oss.qualcomm.com>
 <433e1189-e2b6-4299-9fa7-13e7994ec89c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433e1189-e2b6-4299-9fa7-13e7994ec89c@kernel.org>
X-Authority-Analysis: v=2.4 cv=G6EcE8k5 c=1 sm=1 tr=0 ts=689dc7d4 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=4zz7r-QmOHHUCVnHuw4A:9 a=CjuIK1q_8ugA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA5NyBTYWx0ZWRfX7sdyJoy3f2yf
 49lc3siUO0fLOVPV9JUn29AmIZp60cp4arpWbe+DLR5G68jRe4weZomdVBwFZ1PmC8xgbf3KKTU
 KnoZYmukn9tsqL4974cvxhwlf+CWEwwmdGKyk4dyhCOJIdZBOQu4a855W4XQ5pylTLPq7mvUYc6
 w9qXf5qAgLsoEEOBxt5Id1RQPoXkCGXl2wCumcHMISJLjnTrGcbI5LV6pOY4lpKsn02RtHxL8Vl
 PQ9xdChavPSFMKrkuDIeziozrhCk8GqdoJ/rX/I+CncET69uciNAeqXaH4xPy+Aj3aDof592OZx
 zaTyJWNxUYKr2fVglJPy2PQpD9xRFY95E7pjiUkXPd5hKMD+ENUXVUssAs7fHscYTc6i3fZpLyv
 2buN7ILz
X-Proofpoint-ORIG-GUID: JrH6-DvH_31z_ZXhf0eUAeTl8HrZ0fRh
X-Proofpoint-GUID: JrH6-DvH_31z_ZXhf0eUAeTl8HrZ0fRh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508110097

On Thu, Aug 14, 2025 at 01:18:46PM +0200, Krzysztof Kozlowski wrote:
> On 14/08/2025 11:46, Konrad Dybcio wrote:
> > On 8/14/25 8:59 AM, Krzysztof Kozlowski wrote:
> >> On 14/08/2025 04:42, Bjorn Andersson wrote:
> >>> On Thu, Aug 14, 2025 at 10:59:04AM +1000, Harrison Vanderbyl wrote:
> >>>
> >>> Welcome to LKML, Harrison. Some small things to improve.
> >>>
> >>> Please extend the subject prefix to match other changes in the files of
> >>> each patch, e.g. this one would be "arm64: dts: qcom: x1e80100: ".
> >>>
> >>> "git log --oneline -- file" is your friend here.
> >>>
> >>>> Describe device tree entry for x1e80100 ufs device
> >>
> >> This is duplicating earlier patches:
> >> https://lore.kernel.org/all/szudb2teaacchrp4kn4swkqkoplgi5lbw7vbqtu5vhds4qat62@2tciswvelbmu/
> > 
> > (that submitter clearly expressed lack of interest in proceeding)
> > 
> 
> Sure, would be good though to reflect that - provide summary of previous
> discussions, changelogs or at least give links.

... Also keep authorship and SoB chain.

-- 
With best wishes
Dmitry
