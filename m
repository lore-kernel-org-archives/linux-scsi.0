Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C83909BF
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941480; cv=none; b=jbsFvYRlbd0wqO+6LK9B2df+LIX9jQlHJjwXYh40PPRo2jVMgJmrXSjQVAeozRLYBFd6cq6HAZZXGaBQsE5aM2i2nkGt+S579yFVpo0sy9G/1DGnmFAsiVvIzaLIX/DLTlQexSlNLCPDSBXfMtc/uMkWteTUznwZbNWzHkVqc60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941480; c=relaxed/simple;
	bh=r8wejnoyMZuW2ThUCaa9H36Qhbzxuw3zpmwOHv9oiLo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icEulqImfILOr8q1VXOfG9fZQMU0OwjNWqoQhnyAdiOjnC/S4ZebWUgAF+MK802U/IvbFFrAVVkAZUpdDwP2hTyqJJaHYt/2oHDfRBY+gDcN/IkB/r6QAT252o0krsj6BCtkNNXLyPzBtUGOsLdkcaaPm2p8jDamioyKzU0CyfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G03EbsLZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vhxzq5fy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G03EbsLZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vhxzq5fy"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675BvYxu3998276
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2026 14:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ySMBZ+9dWCN0A9oIfLP+vEgb
	ei44nCNm1qys/RLtjgU=; b=G03EbsLZbhK1ztnrXaI5BOZ0CvBH+S44FCI2ZY8F
	D8c5TEqxSi2p0eD4c988OMnL/IoOeu+EmXLq0oOviNUIJ3sR6oCKUzRsO2X7QqR0
	GNqc3h7E+P1kfNRel28mkUb4HSYEDY3kEY4JZlK7ncpQb4wnv43Ie/lJjsXp7yrV
	uRG4mm2wDwFfZId1d3fHUGTLyU1nMNuH08SjewuW32h4nm6eIFweFqsSOo54dDk+
	dG379+Xz2f0Lvk4aPieVlt9LmiysoGlEpOVL2uKePNI0LJkAVXhYgNvJcf8iiZ/9
	FHADJjVt2dg+Iwc2GyGcopTmcqYqefevqWx565C/16lgEw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fuu3ukcg2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 14:51:18 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-526da7e3c9dso9982031cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 07:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785941477; x=1786546277; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ySMBZ+9dWCN0A9oIfLP+vEgbei44nCNm1qys/RLtjgU=;
        b=Vhxzq5fynAhpM1IFNTKakQp7vhyz9vpU5jr2V/icb/X7vrHy17CCfBXerfalvpkrPb
         w9Cs8mu3Aqwh4QqxAC4iH0ZFIdr3z2vv3SesQL+LuztWyp/4rwcP30HiHPGnBmgioBf/
         2UoGzds6KCLnbekWrzcc4+rTZHwozfpeoJeHoDIn2H/vszUo4z4dRoQqELBHcPdXCNDi
         OsoMQTQdbEIiSmQGuzFLZa2vmZPmZ37ixvIgFzRXmiYzS+//w7bavI1mRsBaxg6AjEjc
         zzid0SdCCQJhTBOZdrq3kK4tRtzzjdNWXrHGT/n6lHzYLOlHxWu5oyYNV/y0tFABkIku
         mJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785941477; x=1786546277;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ySMBZ+9dWCN0A9oIfLP+vEgbei44nCNm1qys/RLtjgU=;
        b=i7sN8ZkbkxfUnxjZ0DzRQu1QG6vIYM0fzESfohfWwjSflHZwQdSNJ4mHGM8Py06A2O
         Ge1ggHoE1gn/++hhz/XVMVydFLu4FX/l7SCizwKHxUw4AP4Iw5ukXbHYFgljt6vjZ4rt
         teDoPoJzbD/jXec35yjj2isd4obEzFSPagGYnrV5oZoRvQrv5V/tn5Cewz5QI20WtRNb
         ncpTbwMKP8pxl5N19E8S3PPPNayrfJ4v2SUZ4OTVqjPtukWRUK9CDuhnw2lUQd/jwtXq
         /7ZKCFGshivDPZjGUtL9mHUcA6d0gaJe7YyFrR2ceUmjRHqmlwzjZT1Y+zNZ+eWBy1hr
         AuDQ==
X-Forwarded-Encrypted: i=1; AHgh+RppQ48GLR/p/VgdqT+nTwJ9gpZSNSS8jQvfV1XrUNw8kl62SXvWWdZfVLIgflVtiw6UGp/2TAVUUe3y@vger.kernel.org
X-Gm-Message-State: AOJu0YwKAR+p5HaglpQGecLfH1qvEOtJCzOFSKnc5TJ4cKEi8dsK/GAf
	60eUnyAhGdAlvx8ajp+MC4tMh7F7XtrNW74MUOngFgngD4lqihkD+XGdNSrb0ioS7a053/gVrf5
	Sk5n5OgbOtD+yAZbdyxaksNOCNe7jtGIyQmJKQ9l+FmOgSxo0Wa0l9hWiR6V71rzb
X-Gm-Gg: AR+sD10ngmVQmwpsWkoSkc8R5TxSlGbEyGyZIy9FQO9fshRSpX4rSrY3K/+XQDmexX5
	PWwlNW6Lg5/wI5n7O3XHLIxsrMut7FuTDT+8w+NK75laQn5NszhTxglyaHactJ5A2LGiShxA30s
	9MoLJjELT8AUU7qvRSAsYqOIJkQ424A5f9GvG6EAWInjh/ITlOtSt107XFhPoVZZYDfp6sV7SeW
	UcuHYSFv1IZgmMLWPfETXklJkV66keZVUtQUere43ZqT3adBHoiE4uG24nUCMQI0Qm0MDkhJmFT
	zf0WWvVjmFppNZgXhUOAD/ahCXL3WTaxBEIOUYGcbEXfgg5PknnZ10hMwNgsZLbrFzB1wAilQyD
	iEV/gS9fmGA4Axx3O+9BT2lVgdeyKjq/WQ/E=
X-Received: by 2002:a05:622a:1486:b0:51c:857f:9c12 with SMTP id d75a77b69052e-52ce5f8f653mr75365081cf.4.1785941477503;
        Wed, 05 Aug 2026 07:51:17 -0700 (PDT)
X-Received: by 2002:a05:622a:1486:b0:51c:857f:9c12 with SMTP id d75a77b69052e-52ce5f8f653mr75364471cf.4.1785941477041;
        Wed, 05 Aug 2026 07:51:17 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994dff10a4sm100689705e9.8.2026.08.05.07.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:51:16 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Wed, 5 Aug 2026 16:51:14 +0200
To: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
Cc: Bean Huo <beanhuo@iokpp.de>, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <anNN4gZc9nvadHNs@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
 <al3-w3j2-E2twGZj@trex>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al3-w3j2-E2twGZj@trex>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyMCBTYWx0ZWRfXzSRv9fsyOJnx
 KT3SX7Kts63hJmiSO5jIexgiejC1me4wR8lUVoOoBeUwAqgFn8FwclLjDdV8gl6FpDnboNh0Lo8
 8katTEdN85cLchVL9DmFn7vZybX9M2w=
X-Proofpoint-GUID: gqtCTDjJSzFKY07fb1AL2o7oUxqq2Dn3
X-Authority-Analysis: v=2.4 cv=B5aJFutM c=1 sm=1 tr=0 ts=6a734de6 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=NEAV23lmAAAA:8 a=IDoqMZ8Uth_GIsVG9SgA:9 a=CjuIK1q_8ugA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: gqtCTDjJSzFKY07fb1AL2o7oUxqq2Dn3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyMCBTYWx0ZWRfX9E2uWVaY1uIH
 caP7iRgXPNDvSS0FNlo1cE2govBoA+QOKfJOSKPB1AtByHPW/AVshbmX6W9MogQI00/ORtfJuYE
 fNL+TSYIYxDiW6b1t3q84ZCI57yYQt5OI857Fx0q0XP8sEHLXBApRG9ZYVkUCYoiI/CEBjJ6433
 bIR2TKbwvwbOlz9BIQ2vQAYtkh/rNnMDDkE895EzT+e3Mbt1os0jF6yo2t8UY/2LaIQxq790TXw
 ixknK/qnQHgZS8ftpw+xnLyGcyrlwZoWTq6ryQ5NuPXPg54u9fPIYfkqa8zX5OWRClc06m0I19U
 UZrNiO4/RzLuEQy+t86tx9SE6Wey413VWfLqH6LoKLNDQ0VQas43AXjLAeXnW8tVp563qtI9T1O
 5QOURj5scHCwrBFBeItfTajMXynbbcJ0XXhQhvsb/75zdbEp7skEg6wGObOjZz1XA+dWRlQta0g
 +ZFD/sSUh7k3JvOTpuA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 clxscore=1015
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050120

On 20/07/26 12:56:03, Jorge Ramirez wrote:
> On 20/07/26 12:23:39, Bean Huo wrote:
> > 
> > This is very strange, coverletter is v1, but the patches are v2?
> 
> I messed up (manual edition of the letter) but the thread is proper

Any other comment on this set? Can we agree on the ABI change?

you can check the overall integration description here for more info:
https://github.com/OP-TEE/optee_os/pull/7881
