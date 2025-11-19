Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086EC3148D3
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 08:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763540494; cv=none; b=PbcmlTtl5NLeXu0J8slAMjF6buONErXQmgi1G4bwtjjsAm0y/rIqk8B1nicRjhinJ4x9FA5NYDpvjFVPwM8JYO0y/U8yM05y5n89VBlX2xCnembrRm7yty94F63vcj8fc5npT2BidVoXrwigdX1Gtqg8ISYEV808HoRRC9R5D04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763540494; c=relaxed/simple;
	bh=SGwW4r5mjx2bwsfrVY30D26LHtxfAtTf3i3shZHSBNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKarbPLZNhY1ZYbFlHbNAHAL7Aw2QPZzJCMUYUf3xIuYCHD++Gd7eQrGSItX+MJY8Krd6LFyZoQsCt7JXGpNoP8qK1fqJYU85Fteot5277YAxv5NfKi0nXwU+X0jJ57808Ind8ZexKa6PmJx5dEAlQhT0BAlParYQAImCq7KArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MGbylInq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A9JxYkdk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MGbylInq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A9JxYkdk"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AJ7OiSk971701
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 08:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=xEAsUPywi8rUkrZqMBKpeI5/
	a9H3yBT33dG3WPief/Y=; b=MGbylInqBcS9kDYPoGzVXV3Z5mNjOfquuoXyPDMr
	7wFQPUiB+DV22cLuHIamnCr/zMvASUVMEnDgu6wnw9l7vRpomCEZwKnojz+ORXYV
	eA0U1PlG+xxtwkt5c9zUUJjX5hs9EGqoD+kqEAxpqetdRTZILr9QMyQUcVLtWue1
	2IqE4IGUv5JbQPQ30WVOzYMrq4tQhh1lwpK74LxywLsVJFdvhPafvixxEm/BRWys
	pVcFZOy1hgRx3iB7bt8njsfygidsOOY7ybqHfYRl3gRFofNZyvNesoGoWOYDwmU7
	ANzQIIKwMrxD3C04zYvavmRsxDxsYLnJASjUP+2M3b7fMg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ah9fu85vr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 08:21:30 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2657cfcdaso791082385a.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 00:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763540490; x=1764145290; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xEAsUPywi8rUkrZqMBKpeI5/a9H3yBT33dG3WPief/Y=;
        b=A9JxYkdk9P7QogAYuR3OuObCHzXFAdDsAFWlVGd2JAqSw9poRZ3LAcd1s6XCYDwPUR
         aPc/+jW2QUjT8WAM+ZUJCx4G6xrPUTczBd5NI/596Stln8iWdmnbvkeKI7TW+9RoEUkY
         cPSyXTRQQTPumUB/zRBXK4Wku18f+91IqB7ipmAJwioiMrKYnUUpYj1cB/r+9Sndnq9c
         wBtFw9N23mLEGGOxLFXyPI2LWY8t/eGewx929mTHq50EdxTreTFTvjbpbZz+FmLjFSZ6
         q0LJESKDzsxctUl2KRlXOMD1Csb+YrKzk/ZqUTMSIqcDluKz/LF5ILxyN8V1CjSoMqnl
         XgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763540490; x=1764145290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEAsUPywi8rUkrZqMBKpeI5/a9H3yBT33dG3WPief/Y=;
        b=sR+bdmD6Y5p+04mdYYCbnRwYW/5fccgyYUGoFO3/4ucbwZP1kNYL/H80Kt0c5m+Hht
         Zc8jdR+xgw1Y+dZ5go9QD2H56RY+Z+txRPNgIo/akQfkVWCGvHNZUQU1frFMThYGJHeJ
         hICpPbeLTPZwQ+WZ5NldAtyyysmPBaCcKfC+Hm3RKpWauNbmFRH6Ocb0xc6Q010md+h1
         Mt5LqXSzYtgOT0I8EjU1P7XAz3sTLiBou72FhJWaX0augsoCYyEyS71DtpCC4U5k3eVe
         p2d6zLCbutNZTqLaKxW0DNcWzwdZku450SdBSpaewUXImVHjgfP6cIq280fdw6KT7H2J
         lU/A==
X-Forwarded-Encrypted: i=1; AJvYcCXdAy7W3MwXY5OE4Va3Jt2Bv0Ve4UZmrzlR9iV/6O9xDhv1ZTtCDtOwfrpzxO4W9puatBO4bRjZLpNf@vger.kernel.org
X-Gm-Message-State: AOJu0YxDMthLt4N4ej29M+6SMhIoeyF/+nxVy/v0x7yBkn+oZyS+HMkM
	LGhLay+8bjk62TB1SKFFK2nz9zgW8xn//3SqU2sj6HW/+FzpmC+j1TvBHH10MyC9Q7UBa1JBJLZ
	fNgQHSa/8KA6BZYp8iLGZRdaVs3Fuhb6TeNTIpCEAb6EMDLFigzFJVEUj5ZRRvb2OmPLlHGB8
X-Gm-Gg: ASbGncsUHOPgpBMoQIQf9x7cVCRthb9brKY4a8ayfnqPFAeR46P0Nob3GPLGaM/ffd4
	o1d8bmYXYo0n7ePRQ/evCF8IxwPcGNZxNtk6fBy2cxFOxYnlp29EjJpucq03fRYFcXVbol4KYg0
	1/qEP5ovpvrnPxKyPNHTUFBJd1NT9uUVa7H2D3nP9MlHdW43JryBTu0AA+4QD/ysgdHRdnifmo1
	xSJpWfHowP/8vOyKZ+EU4JImaDw9fc7hBLCwK6nFXwQAb+dbdeslVJoTYpiA0TmaoqGkl/eml2M
	oShaX526Iu9n0uUN4WcRALHEryybuYaxTEUFuOlEO3EErgcWGIa0FsoPVwkoFWntNUPCIVdTxJw
	myszM2Xbfc4iF9vQDyMLq2qraGqNClToOaEantwYekrg61ebXAtVP8Z99Kyc75wQ11D+VBU37zC
	Yg0O7Xe0mjvxuoU+EizABHbLM=
X-Received: by 2002:a05:620a:1788:b0:8b2:e8b5:1e9a with SMTP id af79cd13be357-8b2e8b521bfmr1425462585a.21.1763540489538;
        Wed, 19 Nov 2025 00:21:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRXc8k0vTH4YXhYm8Uq7SOvE23kdJYfiJ1GXMBzpPl0mZrGGhj8dQCLjyo0yHmskt2tOKZnA==
X-Received: by 2002:a05:620a:1788:b0:8b2:e8b5:1e9a with SMTP id af79cd13be357-8b2e8b521bfmr1425460885a.21.1763540489071;
        Wed, 19 Nov 2025 00:21:29 -0800 (PST)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040049fsm4560259e87.61.2025.11.19.00.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 00:21:28 -0800 (PST)
Date: Wed, 19 Nov 2025 10:21:26 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, quic_ahari@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/3] MAINTAINERS: broaden UFS Qualcomm binding file
 pattern
Message-ID: <bow74xfqthpcx53ncr766dcyqmij2ycy4xuigh5elg73jmwqcb@vpm43t27mbfj>
References: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
 <20251114145646.2291324-2-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114145646.2291324-2-ram.dwivedi@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE5MDA2NSBTYWx0ZWRfX/H4nXXp2zTVv
 6SvrIhajswHfcnRFkGBw+a1wIDzyzvKMhZ/NSbUIinFGlvtnbAEUlUPFLbJwCzeAs5kzvt68VSL
 LH8TrJJONtdumRXQ2Vg0acwWkAK9KDvqfP20CT8SgTJjr6an9py7I/jn43HEu9WERXQ3e8g8pGW
 kRKlh1jZgoQpifnH8cQAWiBEdG2+UGbzCWJgQO/MIgHqQwRTkrGsfwb7m5MDmAst8JWRCSaRLNw
 +ufoFmXF5fomhYtOahPnLTBHbaDi01JEqUdqdRei+j4qMBP0E0C37O/JdJjnIbKeH+B1J18Fb+e
 /JrNdONIjh2f5CMZTUQWnUslGdNh78TLjFrCoAka6D2tZ3pDUorqPvySbmeBb8N9eFjg7QH6Wi2
 bmOukvVryGF/nPSxaosl2AWhf8CqJA==
X-Authority-Analysis: v=2.4 cv=KZTfcAYD c=1 sm=1 tr=0 ts=691d7e0a cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=qsePQymvRCq6VeTyyVoA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: eABH7x9hiBW5p1OlVvx7P_NPmdv8Zizb
X-Proofpoint-GUID: eABH7x9hiBW5p1OlVvx7P_NPmdv8Zizb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 suspectscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511190065

On Fri, Nov 14, 2025 at 08:26:44PM +0530, Ram Kumar Dwivedi wrote:
> From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> 
> Update the file pattern for UFS Qualcomm devicetree bindings to match
> all files under `Documentation/devicetree/bindings/ufs/qcom*` instead
> of only `qcom,ufs.yaml`. This ensures maintainers are correctly
> notified for any related binding changes.
> 
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
