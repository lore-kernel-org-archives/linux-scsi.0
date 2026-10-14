Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604374F6485
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976636; cv=none; b=KjmgK0vDLx08FrQLT1nBrbNJNnubHyzJ1nsfkb3nGrL39LBSDT76YdkZZWPpK1JVdWdi+iFYxVjkFefEgJECtvRndA5cE1m2OrpAvjUxRj7IddTsm3HOaD4iaZ3smuw41qaMnYO1yIPRgFoxnKSIPKevPfZQSKVCZEUaG6jT//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976636; c=relaxed/simple;
	bh=2vrKF8mOD5KYteJonBX97eQDhJTkrsZRQJ+cGz7SJz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suapbUA5dMzQe22/CYkQIE8kO/O+p4NEfmo+Ia2jcXbhCqNQu9L0+UGHfAk1N97ITtjOjO+lTGQGOpGiYV+gleYyJu1qadWGvyQlp1Z210jEZtMVtTkeq4gRZ0u8Io/wXDuFwxAZ38QQ8o22P3aLbYFIJ1NaN4uZ5oLiBXwGszs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RvMdUCLl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YmZ8oXUn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RvMdUCLl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YmZ8oXUn"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E6jSZ22088499
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nR/ijon+rHa9vEbSCj1pW479jS8KYiNuAqFs2gzfUdc=; b=RvMdUCLlldwO+tzO
	9bib1Vnywyje91Yi716mGMgy1YM+Xn9pduiK3OrKsXpSmXcs4s8fBEAmT84F4mRy
	8acPDtBpn2yovYksr1N7erSWy0gpefatXHSexbRNZsD/1azOSKHPIRmUdth/N59h
	Zfvr2fMZdjS/SXXlz032mh9XLmTLf0dy9U1iMdEGX0DG3lwzFPQN2Mi+AwbzNGSG
	Qae3SjQ9pmJ6Z3iT9MZR5SUMVqVB9fcKBuLP5YF/YfaQA4dU+aVUXCNfV4odejyz
	xEh3osAJv5MPW6C8ZxKA4j/yUz2GVqBGsGbQEcVHW3MSAOqF3fzIcKQJIMyswTeC
	g2XmgQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9x49jhwe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:17:14 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39deda201bcso6600506a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 04:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791976634; x=1792581434; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nR/ijon+rHa9vEbSCj1pW479jS8KYiNuAqFs2gzfUdc=;
        b=YmZ8oXUn9yvR7WUlg9hM+ZHooDGdn5U0vicy+vAYPKjBXLjhvSAXLAfwjo8V9sEzOF
         BL/SLcj35HlYvIbG3kJZR4FoAkPlLP1wAV2Lxcexd4/f6gYikasEwVh7kJAd0XrAgXtL
         6Q6tY9fsG+hu8qMyUyL4Eq6mupQtGqQs927K7tf3YxrZIAgjZFdRU4w9/aBSOKRLXdQJ
         zoL0rHipf/GGe6PIFA5zrnXNSSBTMwCANyR79GHv5iwQb2+GVnZJKtP5nXXogVqCz9bQ
         Ip+MoFUvl4GEx4BILj9g5kQHIBwHFP9EHVlZvUwSiW1Zyd8v8BpipnkdeJX612n8dyg0
         eOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976634; x=1792581434;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nR/ijon+rHa9vEbSCj1pW479jS8KYiNuAqFs2gzfUdc=;
        b=zmSh9B/FV1r3HtBdtnxIkchVdAFiLA+aSGZN4EM5FxLNL/bEBNXw6xhpirynPexbSo
         jFEc505vHr029gX0KYelgeM+7l1oYH8NHwwQj/+HOAIwGRBE702gtT9csiyHbV8OHfC9
         uQMalbdRwQAFmIrtVYfCz5yPSjQApLgNZwLVqv8XqDnHOU/BH3QBrSYA3oM6/VJpAezh
         w+hITFYUehbWRpyaV88qjIlLrxpcP2mjIsZT2tGL1YivdSEj/c3+6Ujq7oKWeJW8fWqE
         zLg6FHwOq1xdmPIRG9yLyKyJbHl9SToYrmcqvdJpcpgVR9k+BsMNtBodLFK2OvmgzVZ7
         jDfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxctTvjsUrqmAgJCuhj7AYlMVposg5h6y8GJT7rR4lI4PYLaqyLCiVlYORaS9O/Beo7p1XA82Iz63BS@vger.kernel.org
X-Gm-Message-State: AFq9FYI7hX/B+Mn3O9uKJXzcN6Y3e3lN8w/xYp3SWQeikxFFWXtT2abf
	6yIOysYLpvpwyGvPDWxcGwWYAEYXuYA1d+G1HPakYlS3NJOvBsWbZEIIQC8qSMCGWEOPCt7ahM1
	9xG8WidDWzarQBGQVj9G2N/tMgNCFcBh7URz2RDVc7gAqzku+FUoxjDWojQ0dTeyT
X-Gm-Gg: AYBFou2lNLMH+HJLPuIgpcQ+MMIwNLXzKNqZiA8384+pcsRV3FZksJgkue6w5kVph51
	82ltwgaRD4Ab6F7XLs2P6TrezCmwPCQbfbJh0SOQgZd8mX4uJqL6JnlXTkZVLptI7yPj4qH3Rgg
	WhMCMxo2IqPsjT8GrGV4i6I/lq1Oqt9sLkIm4AYTf7qD0hcngCMJg4rab5PKVNSwByfvV4/FVNB
	+G5insF/syBwBDn7cOdrlitmDDf35s5ivzAFceDvy0D68Ko+d7//WZpq8rAUbkB/XnNkR4He8My
	torTOWi2nWMPWg7Mux6tzM1BGTzXkn07bRKVrhmKbD3UqR0a4toqmlnxgEhQ3NIQQ5ClqKucgGG
	9CDjPWv/URpIpehhSs+NaCfgw9yae9MKfCuhe
X-Received: by 2002:a17:90b:3b82:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3ab3a94f426mr14359520a91.24.1791976633807;
        Wed, 14 Oct 2026 04:17:13 -0700 (PDT)
X-Received: by 2002:a17:90b:3b82:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3ab3a94f426mr14359445a91.24.1791976632686;
        Wed, 14 Oct 2026 04:17:12 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6325e28dsm1962341a91.1.2026.10.14.04.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:17:11 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:47:04 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 0/6] Enable ICE clock scaling
Message-ID: <as9ksJKk55wYuoOS@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=YJcKWhGx c=1 sm=1 tr=0 ts=6acf64ba cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=yZ4vNV_xbO2V9HmvDQUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0NCBTYWx0ZWRfX+055GwNii3qi
 4XtQuYX+/CZ+x/nPumB8WkZimsKZuFacdx7dL30r8/jE5F1Cy2R+Vcsd7OgNYUX+S2hd++EKrX2
 VROgCEYkG2zndAV5r/dp7IyX7Mz5EwIITJzJNGewsc/fkalpqRfgEaBTorh+OkEAbbyGdvbfws6
 iK+dFS3OS3xojOL+otvob3fFxDfKNvLm71j2Q6GEX4zwt0SfZnrR4eWpi60CypxFoVhsjENhzEs
 CgBET4+8vKtv+Dc+yOzRcEQF7scEwB/2MGFRbmb6M0812k/+epZtOu+88kGvo2ycbdDm0m/+vMT
 lkDVjy5PPHSVDtaRftgT7ALVHDKgfg7uSlxPZaot9ynqG4hNQXm9vNtUxZ8Q2zDTWp2/QKYWhze
 NBs9e73CYEobkFh/esJNyBjG4yzzyI+4Xm7qtr3b1TdNSobtx4c6xVAX0HmKtZoQ05QQlvY+9pe
 nbFcnDLx1jXhLXit7dA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0NCBTYWx0ZWRfX8i4E9RU8zF/K
 QgYn29fIOMOo34vk9r0OC0xhlzE7BLClUwT/wqJ/CUPPTTTDkUt29qmy1MJA5yP4a7+nkn9BJZ8
 9+hNuMEjliocDMwQtyU4WiRnzIEI7ls=
X-Proofpoint-GUID: OUEii-CK_ekN3GtXNw8nXYL9stI9Vk3A
X-Proofpoint-ORIG-GUID: OUEii-CK_ekN3GtXNw8nXYL9stI9Vk3A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140044

On Mon, Aug 24, 2026 at 01:17:37AM +0530, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node for 
> DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
> and is invoked by UFS host controller driver in response to clock scaling
> requests, ensuring coordination between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.
> 
> Dynamic clock scaling based on OPP tables enables better power-performance
> trade-offs. By adjusting ICE clock frequencies according to workload and power
> constraints, the system can achieve higher throughput when needed and 
> reduce power consumption during idle or low-load conditions.
> 
> The OPP table remains optional, absence of the table will not cause
> probe failure. However, in the absence of an OPP table, ICE clocks will
> remain at their default rates, which may limit performance under
> high-load scenarios or prevent performance optimizations during idle periods.
> 

Konrad, can you please review all the patches in this patcheseries and let me know
if anything is pending?

Abhinaba Rakshit
