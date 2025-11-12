Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84212D6630
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928946; cv=none; b=NXgwyyGqZLMXwjytUp2bWKpxo7GpKpi21EAHdQA8lbNSOZVF/0HWWASmUIirVtSLK87vY9bEP03DsyWvbQ/FGRqXqeym287Dm19tlYWjCXB4AUCx+UsNjfJGqzs6LA0zHnGqAAPuDG6M5CibpSrwLp+QdT5AsSnX0hDG2tfyDHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928946; c=relaxed/simple;
	bh=A7CUWqMjauXHT6hHhvu+ZIxufMH4sPH9yuX5FupcZVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzWa9a/6h7rh9P0l9Psy6y/SxslrjpRzn00d+3Eq8UQmzjpqbys9hzbGKNy+Ci6adsoljtkQHMEwiXBVtbmdA0exsE6k/nn0CVnmvVMnKoBpsskQ/oah4QVyntmSco9qMuO92VQqltFzmN4B9nWa66wLtOqgH2vF8TH3GAt/P1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SgKdOT9b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RiFQUaXT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SgKdOT9b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RiFQUaXT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AC1id1M4077485
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FzAUhRKeGOhDrL0SVzP88ptswnErMqcNrlcNyCzXAfU=; b=SgKdOT9bNkdk2FG2
	oLkEW/LEAQK9mTDR635/9241IOdAebnYCzzVOk9KKYiwBfkKVuR0GAp9+SRb96xj
	ivb/+UVJLrKHI7Z5UjWDLuf1jQ8d3vujsNScV1TrCb2xN4hEympNeuwJvI6nTkvf
	HCAqcJ5776+1wLfT9fXDD84FLtLrAyO2+flNveFjL4Yt/+Aq7wA53qdiEolDPv+y
	syRoIwia6rb0pKPQP8tJayNCxAnAiZgDsptmyLYLcCq1cqKZun+AtpPFUnqhkvmh
	Lqsh7Rcp8/yPvsy7Pif/AQuBD7Xcodu5CfsUbOK+1ymtyMt6IgB15lvjNDfV4IaQ
	eizd2w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4acguagp0f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:29:03 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-340c261fb38so1134212a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 22:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1762928942; x=1763533742; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FzAUhRKeGOhDrL0SVzP88ptswnErMqcNrlcNyCzXAfU=;
        b=RiFQUaXTtg8GPTSaOLHIlhG8QbrFZjkJ7+zXhzD6cNzFRETilMSnHZFQOyrUhF5W4j
         CThLa2tau33YXv0u6q9ip6aXkjH3QJesAEEgtVGiT1m/dfi9SugEq2kQdCs1eOUh4CGR
         B9hmMqQqTiqVPkclKbGDdNAmcfPD2z1h0J1JLYtU+GVxl8vRrC2PmwYSMMVJvY2gXWHY
         2SspnZnQ3dXTASO6K0Ys/RVp528b2FGGP2YBpV694XiMj5Ef+M2oZd7vSdPJRpIiejny
         WCUaIbnM7B2/VdpViSZCc8CiBCKWT5KOLkZj+p5CXwU6bOdVInkY5dxmYn47QNnovICJ
         tlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762928942; x=1763533742;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzAUhRKeGOhDrL0SVzP88ptswnErMqcNrlcNyCzXAfU=;
        b=Ikl9lN/jwVi8T6/YANOABQk5D9ULvFPFU1SLMJZEMPXSM2wJq1v3h8g0kL/1Z1nl2M
         xRFE490C0+uI+s/cTWTf6UtWM3SDmzMw4nQLIHCejkoWpDUsuovEA0B5QYHnXrpoLHI8
         bfh2YvCU2Z8iOQHree0VZ1bfj8kriQE7s/QxvUWlnJy1lG0PB/qeJdwGx9yQzR65Y2js
         EdWtagfQBWIjn3XPHOflzfqFWn70wz9lv4cNA/AFZOImbeOaC4Fhzlz9Wit3DUp0RZc8
         y1qTiyaT0uctuYQRUam32M5HBNEzD1hI4kYCX87VtLkTtIrJD5BxCPnZW2kVFlSytoYe
         65pQ==
X-Forwarded-Encrypted: i=1; AJvYcCU442sG7yyH62/2Gn/OHdU5238zAJMqVlAmrPZHu03YkTMDaLZ0hVp9ZegFWJuR+iV7pkUMhqekwWmv@vger.kernel.org
X-Gm-Message-State: AOJu0YzqOGSA1Gg+JhyzXL5r+zEbCS6aIxIs8hwHnWevvdGXwlwV0swa
	2vFagYHDNR8fBO2SY/j8JeLjADpiVpiCn/DiTLBgkPruz3FX8VOo8RUEh3CrnkcHohj/wqZwpaG
	Y0w3dkhaUBNusM5GR92PfsB6dIKmZjP58UOS1xZ3TcncQ5z3oIHkqS4LO67KeF27W
X-Gm-Gg: ASbGncsxFMz3o4KsSIYSd3nWFi+OvS6UJeIGfclLj3hPCvS+ksut9cRJr+RC/jboCss
	sQ7dcI4hIbiDDf95AJ0S2SoFx/Q/QFkInqvEiekrMiLhniuOQxraIEbJGNyVn/TPuggUSNyuOGM
	1UJekz9TFqjeqTNcasiK13R0aeaVDKEN3beblaIwYEczqw/yZEK1UgwWAlAHj1K43dIzCL5LASh
	6/yykffqHE0oi1+uic9aFpZJGk096kZAffb7ZxCAXm4Men41GmieN4QgWDeb55y2JVqlWTtqOmR
	0h6ctKVOQeg0u4rMxP2Ubjqvu62/7H+iMWK9brc152yaeQytpPrAkqiMzwgrm6ReXrkojRwKJgY
	KcPoIfB4Lt4Vw/DDg/fHJR2T3Ewi+aZU30yvw
X-Received: by 2002:a17:90b:3dd0:b0:341:8adc:76d2 with SMTP id 98e67ed59e1d1-343dddeef9emr3091931a91.16.1762928942279;
        Tue, 11 Nov 2025 22:29:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoBsSl4PPVzSUNTAvxsQL7O5rfO/S9VTHWSRRJfl3UQVRGtUcOGu7eHItKP8uuHcfci1PbXg==
X-Received: by 2002:a17:90b:3dd0:b0:341:8adc:76d2 with SMTP id 98e67ed59e1d1-343dddeef9emr3091904a91.16.1762928941763;
        Tue, 11 Nov 2025 22:29:01 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc179f14sm17849673b3a.45.2025.11.11.22.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:29:01 -0800 (PST)
Date: Wed, 12 Nov 2025 11:58:57 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] ufs: host: scale ICE clock
Message-ID: <aRQpKdRkadwN2WaA@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-2-ec956160b696@oss.qualcomm.com>
 <rge3ozfojjpurnxi5otwuobzcw5v6fstlvpodw4icmhimauckx@wpdb4orkjd5t>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rge3ozfojjpurnxi5otwuobzcw5v6fstlvpodw4icmhimauckx@wpdb4orkjd5t>
X-Proofpoint-GUID: 0ZbGlGX9LsAde6NEiltGhtlFeMmPDsYr
X-Authority-Analysis: v=2.4 cv=ao2/yCZV c=1 sm=1 tr=0 ts=6914292f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=OMFupFYHVdvZUXidDu4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 0ZbGlGX9LsAde6NEiltGhtlFeMmPDsYr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA0OSBTYWx0ZWRfX6BmWHm0n6VaK
 w60VYigEwZywD6WIBDecAkwpI2bLXfcmWJnd1EWYz5JKW/igK4bhAdtk7H7uPsQcxCZrrsh71S1
 K+fefTYDbpwhLOKMLoW3sQhskyUAKBmQCPhsXpzirw//IkWHL6PcJbVJHjknz75pK3nhpN/6JOZ
 zUS/xk5OWDZAl4nkzsCPkOrEX61vQ6xN9Gs03MmGqzU8u8gELhwpxd83vNPkUpUOGMRtjYSM1Fu
 w4gmA2Yxdzyz+QykYTI3ZhLYkplrZ0tWpYTTcM1DSgZnm3z7s8D9WxixBE0HmutCfVC+yE09heH
 CEh2Iko3HLg0QMTCir4bxu3OHUvao1ccilTjcqGZAvCC9vSVFrCBKL8iarcV7Kzw5erVxxT3m86
 AAx5ordTMWPJZbrbYJE/3NNJV4GHlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_02,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511120049

On Fri, Oct 03, 2025 at 10:14:44PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Oct 01, 2025 at 05:08:20PM +0530, Abhinaba Rakshit wrote:
> > Scale ICE clock from ufs controller.
> > 
> 
> Explain the purpose.

Sure, will add more details in patchset v2.

> 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 3e83dc51d53857d5a855df4e4dfa837747559dad..2964b95a4423e887c0414ed9399cc02d37b5229a 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -305,6 +305,13 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
> >  	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
> >  }
> >  
> > +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> > +{
> > +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> > +		return qcom_ice_scale_clk(host->ice, scale_up);
> 
> newline
> 
> > +	return 0;
> > +}
> > +
> >  static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
> >  	.keyslot_program	= ufs_qcom_ice_keyslot_program,
> >  	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> > @@ -339,6 +346,11 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
> >  {
> 
> > +static inline int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> 
> Drop the 'inline' keyword.

Will update this in patchset v2.

> 
> - Mani
> 
> -- 
> மணிவண்ணன் சதாசிவம்
