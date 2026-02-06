Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB55F3AEF43
	for <linux-scsi@vger.kernel.org>; Fri,  6 Feb 2026 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384219; cv=none; b=L+zCY2trr5jlBOSnBLH1puXOB00Az2A9bUWNMvkCC6U7DlMeXUulfuKWiaEAlnpboNnPy9XeMA1abpKKbgwOMDRDb2dejfSwDl6rW7NbRPjE2gncRJ5sheiy+EAcpxHJl1J0k6VsI2SEpfIaraWYV0AjrVHeiGcC//NumK3nd+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384219; c=relaxed/simple;
	bh=fqZ8bqAlwUxBwe4Z1+H16jnykQV8yO9H8sw0Vqob/0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKDwVj94zSQeug9bJBk1G90k76kISFLlnN6TtHZLjraoBQGmLMwu/YJM+ufndVwGOxRTn/VFYiFToa29nIxR6hMwwDb04zee3QI/1LSVP8fDQFCGu5yRQDVZuZfb5akVL1fYtjpy7jc4jLiQXnRb3ZmrllqQ9wfzKj4b4SP4jgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oYLKpI92; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YuVg3Ixy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oYLKpI92";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YuVg3Ixy"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616B4Xkj3764807
	for <linux-scsi@vger.kernel.org>; Fri, 6 Feb 2026 13:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Qcbx8hOqgZKgbdxSnQdVeh45
	s4d6AAaaCPjmsAiQNIM=; b=oYLKpI92S6Q7d7Cf1DrAwDVbpDZdYaJQHEEYEz8i
	q7+upvosTjWwB73AvGT/DpOKcSWDuqZsIRNc3KnITrFiQLJ9IuzuwLK1Qfe8SWt0
	xPKxsdF9JGSpyQg0voI3pl0/RVSfz+qXq5gSgvObQ/RiECziXWgbdOst8cR9u5jj
	VyrWYjteW0DrTXIcgYG0io0DMfwjIsWLAZaB2jGQQBJZjYo3mhq2bdmMDiGyAXfq
	jONDLiC8TLq+60zWtaHleduCLB62m34ekmTP6UM3zy19XRfBebWJeZ4HjjFecNsT
	YIduTS67LujAYsfXJfj4LtxXw00N9peEy8qZ1FjldKVPFQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c5f3wgcfw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 13:23:37 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c613929d317so1403527a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Feb 2026 05:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770384217; x=1770989017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qcbx8hOqgZKgbdxSnQdVeh45s4d6AAaaCPjmsAiQNIM=;
        b=YuVg3IxyTS7DKgG4lVjz54J14oaNIMAFgY2VXC03zh1iYNiftCB5w/t5Uk9Dl/Edbk
         Asd5g/cRj7xPa2XAHV+SuRIFToUzeUlSnyYqdn/gHJqGdVrhmDkKQZ9vT29ntf/iIoFw
         S8+ySBkNtRM2ZWsMSr0kSXf14xxziFu0n1TO/G6UTryadQE1YHcaAXiHG6ZRFmxa0/Z3
         YHtxFaHL3L0oSMnKo98az484CkD6VK3NNGVvSzc/EdgZBzoz7DreaywLWgktu1um0dce
         CN9mA3MYk2VCSpsbMLs/B/rWkVEoe4A0XWrU26l66roVDSrh+BWCIr+vHMKqc+OXav17
         g+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384217; x=1770989017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qcbx8hOqgZKgbdxSnQdVeh45s4d6AAaaCPjmsAiQNIM=;
        b=wOIxmO8gl9EkrBW5PH5ydjmdNSITscEvbI36Q4YkbhulKipDcYzsHB5C7ifxejKUwJ
         jDWCS2CIYsMpxBG4kMwheMpWs78nClxfgiKn/EWWmR9evCzw4Gg4ugyKicpHOpIJ8oCy
         a11o1xma4bcypHDu/NL559Ot2jDTue/XckxE4xMbhBKspwpcfVdpE5HPYyp2KZGOwFVg
         mLNKsJ/EqWOJaDoH6iXXG6ia+Kt9j70EyJ2e1q7oXlrxO0DVATGr1/xYnu7Mk85rm5XJ
         s5ldyrlun8rDMpeeRn5/e5Oj/sHH4psAcz6AqRCDNGVXGP0XzXTyfNWn5uhv+yGK1yK4
         bgYw==
X-Forwarded-Encrypted: i=1; AJvYcCUPkmHEJ3TkLIpvwExKciH/SAQLlK5OMi91VHw68kUuLOjqbc/HNrHC/ZjaYTbc27DE5g2WERRCTJdT@vger.kernel.org
X-Gm-Message-State: AOJu0YwXrXzgzdc5VYEe7to0unS35n+lDuaqdMu+XiHbgzG9KKkyUAO+
	XduKxn7KXGg71IErblMp+UlIiz7FNwwokUB9e9wG9VFX0lE6Hj1qgDrBfPxZKP1yBrQv3oFeje3
	tuIf9uOtCPh+XX/EN8RfjGef0xrksfHCTgt3hc+O+J9i6RojgxCCIKd6AukHo2BQm
X-Gm-Gg: AZuq6aLR5UnvSfG2W/KHoDBQohqjYD3VqMEYR2OjAVUhqUxbZWw5hV+LjoXgUcEm1s4
	qoUz3fRCabLFh/JUQHIhxqFVlhXyyK2JVlf1Ad4W5FH5Gp8t0QR/urFpuOLHDLqlu7lWpJ2bUAW
	XVNqyQcJ+k2gdiTYtA0+5/wg6HA/SJm72WxlZGhdo8Y/sTwnGvAyJVMErmKLlJDpCS5uaurcCtC
	j4aw5RcmIVSSk9cVSgj1fVxPLWv6dC1fKjwXt0e54aG8uXVLZ0Jjr2gJAj/7RI1uHLlqBuHJTQq
	Dk5anUSUznNDfpfLptyksoU65dtCoxNRuLudHhpIGCE/FCnJQcS+HEXEj6rXJCoFJHUr5RP/bIv
	55+g9bPLr5m68VC1bWvRhRY8f6mpW0I8y1U25YkgvcTdRqQo=
X-Received: by 2002:a17:903:244a:b0:295:c2e7:7199 with SMTP id d9443c01a7336-2a9516fb30bmr25300715ad.29.1770384216753;
        Fri, 06 Feb 2026 05:23:36 -0800 (PST)
X-Received: by 2002:a17:903:244a:b0:295:c2e7:7199 with SMTP id d9443c01a7336-2a9516fb30bmr25300415ad.29.1770384216215;
        Fri, 06 Feb 2026 05:23:36 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521f3b6asm24313205ad.77.2026.02.06.05.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:23:35 -0800 (PST)
Date: Fri, 6 Feb 2026 18:53:28 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aYXrUM+Wuso+aHGc@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
 <20260128-daft-seriema-of-promotion-c50eb5@quoll>
 <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
 <b556cc32-2b8e-4451-b333-aec2eddee7b1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b556cc32-2b8e-4451-b333-aec2eddee7b1@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA5NSBTYWx0ZWRfXz9G+XsryxXh/
 Tb3qSx02PNm7nFple/pbF7F2+Zcxxz221OT6w/9shzaOkKpVAVXKWwmXPP1Zch9V7v7antkvBI+
 Xhy8v1usGCIOsNhaWh17qE6f6E249opUmWUPNoYqeIF85R0l6+u9fn/1Xr9DNEilM5eyUGMlo3D
 QTyDBm06PjklNMEORg3P3d9A7LqhuSp2hOsAbBCbirBP+gyDmYx3ZTAduUBAFBflgcJe6eVjHAj
 HryD2CJSAsK9tli4dPuRv+nZEsGLmN4kkmeukWiYEljV/OpYqEFxtIdcDcJO2u4Z+4DYNWXTRPI
 l1W1aFxClqQ90q6D8iZaYxYA9RSWaT8KBzjwHj2NkDjrORCN1V7UgM0xdEGemPew+H6fjlZUMPb
 JN+MB6z4cgant18CXgi/3j0QIC0qo7nxRebgWAHExyazqMmDBB/fdKkjocFPwEV0peax0Z+ZHJJ
 jj0GPm8V8mWFfh7IqmA==
X-Proofpoint-ORIG-GUID: lVW-864o14OMSNPA236-g4eumM6ml9qx
X-Authority-Analysis: v=2.4 cv=NajrFmD4 c=1 sm=1 tr=0 ts=6985eb59 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=utnUQDMwVCZhAfiAu78A:9 a=CjuIK1q_8ugA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: lVW-864o14OMSNPA236-g4eumM6ml9qx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602060095

On Thu, Feb 05, 2026 at 12:26:25PM +0100, Krzysztof Kozlowski wrote:
> On 02/02/2026 07:32, Abhinaba Rakshit wrote:
> > On Wed, Jan 28, 2026 at 12:04:26PM +0100, Krzysztof Kozlowski wrote:
> >> On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
> >>>  	struct qcom_ice *engine;
> >>> +	struct dev_pm_opp *opp;
> >>> +	int err;
> >>> +	unsigned long rate;
> >>>  
> >>>  	if (!qcom_scm_is_available())
> >>>  		return ERR_PTR(-EPROBE_DEFER);
> >>> @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>>  	if (IS_ERR(engine->core_clk))
> >>>  		return ERR_CAST(engine->core_clk);
> >>>  
> >>> +	/* Register the OPP table only when ICE is described as a standalone
> >>
> >> This is not netdev...
> > 
> > Okay, if I understand it correct, its not conventional to use of_device_is_compatible
> > outside netdev subsystem. Will update as mentioned below.
> 
> No, please read entire coding style, although the comment was about
> comment style.

Sure, will ensure to use the correct comment styles.

Abhinaba Rakshit
