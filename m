Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E128B37269D
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772615983; cv=none; b=EOyiZ8Gj/NslwMYPzM71u0fAeunlpPpLlnTmy/px3gk7g30c1hJnzPGD95cbOxWR/OgAqm25M2Ax7eIwazvmCTMy9oHPs8uLnVWrJdPCqkH5XsyjYLYXFehFlvkumts//96TjzNOCkkovNJHhI39oC91DZqqDGAVzc3a5kyvzWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772615983; c=relaxed/simple;
	bh=XPKtr4J6k7pZ4z43ytwPodbm3Gbt9cpmoxV6bUX7gxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNMNW6PPPyz+m79XD/fv4Q0ZZWctYgTCcZqh+racqtcOcPCLTQiW2jZa2DikUmCzJ8+xPZZADPQ03hbCL6YsfvY8JVBZS/f25LPRu3YZohwPdiwKqqKx1amtaehvw+oYooUgD1A4IQGEpTv5B/1WPrTph9nFfT8hCTMtbGfjEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kOptwILF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jONjZsCL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kOptwILF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jONjZsCL"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6245Seeu632163
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2026 09:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tY6xI5ZYU7KY53biVtTPNFc2Qmis908LZVYfVV6cXDM=; b=kOptwILFLloFu3w7
	qS5wQMix1VsrJQZ1DGfvOREBfplYR5mYQ07rR3TyBkkOVjXb7hZ5JmcIeMvXfvRf
	HlWTWImKgDLc6Qa3gXNYIcLrxnnM0a0bmVufaSjhufDUPVbte2BBPnXKPxIr4jEr
	naMrn9wSy9yxZKiryGnlovD+Z/J4kJ8HDeKKxrgptrP5fZwYIRItxA2dWVyfR8Fe
	T7QrnU3QRVQelMtS7j3uhAY+IZVA3PDXhH+/2krbsQnrSPoOdLn7eV7IKWUQFj1t
	XC30V4WFgKiZGqyJ1nVLSBCFB24r+Jh4zyEEyzJb35qEihW23YbdkVG+0Ewd0t8Y
	EwIG6w==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnvtuce9m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2026 09:19:40 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2adef9d486bso59667735ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2026 01:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772615980; x=1773220780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tY6xI5ZYU7KY53biVtTPNFc2Qmis908LZVYfVV6cXDM=;
        b=jONjZsCLclMr+STfPSwHfex7wta5mKYeIfPDONPWiqURD6fZRDN+da0xZrwCQCK+/e
         +mbKgXjg68B4s7GINc0uTgdZ8E7zJpbL1kByZ9k+3b8wCh12zwnmxeJDU2fLaywYDkE2
         8srCIvRFtGxRfemQRRJcm5Gw5aVuSiR8oUESJqhCc+xbQuiasRzgBQ07PQGqd2S1oYF6
         n635BZbfOG6PrNDevRwXH67DIvOTi8QjqCU2ZN27TrDQ38AXKp8v2iauql5Fyai6p+bc
         cABygrgGYUWwcPX1eKb2Cw0STrSNtX1+yYoocRAQqnhIFtkao4pXIcEzUUQ4sApeRUpa
         ikIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772615980; x=1773220780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tY6xI5ZYU7KY53biVtTPNFc2Qmis908LZVYfVV6cXDM=;
        b=hwFBgPi6CLEjppqbGdeghHrtg7lcJyLH/LCZL0fn0lqzZs8tuG2UQApecnNKKVNdCa
         lb50858b/E2CykhrmqI1gxYlIshx+gPpadliZ4xkMVB/2HOfvpAVeld+BXNXHyRmr0wt
         Pfmj6RfxDWQQyNGtR/WBvL7HsquIynOnO48H7P3fFykocjRxcWNsR24OmiUfwVYfR1lK
         eqCgXDUcNrKZR5Knjpy05vtfw8OhhOp3lVRepISD8mDyPEMfNNx37VNTajn45cjLbFXS
         cOovqAbQfsG0UzjOBN97KmRHFBIL+Jb8G/YzgAknCJWuhLBuGYQ5J78q4Wi10k1dTUy/
         FLXw==
X-Forwarded-Encrypted: i=1; AJvYcCWDkHOoX1/AY5GVBkRQu/EBeMJaE56LQeOn8GmlKTU5VCNTsOmo4PY10sd8gdD0BXCdP1OzaER7/fvi@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7LuhRzD8HU4rm0mucZsMFFf8I9aqpkvsIE3Eav/1MSjg8jBS6
	cDU6+3lHTpRCEJBXUnmNs4U/lYSMX46LqCTnUPGf2PWb6v4OmCVHebPjjqbrHLWZBaWAsz2iguo
	o1pOxQ164luzzAWp51WXYX+4EL2VddkLKheG7n8s1wcUKzjQxh7XfIfzShYHY5tQX
X-Gm-Gg: ATEYQzxVCOfKIoGyyfnIH2G2wXUxqoXtHwPbo+7j1db/y7Cfnup0cX/n2mJno1tB3pg
	lnjNvRa7faOKSy+2QL8TCt+YuN0yH8PL88JMxkNPZOzkvuFgNz7TBryBx/y0600qwtrxkaXLMfN
	PdRj2yc61ABHVwv5JGBF955Fj95GTDfMxn7Osqq2F3xqF3swJ5Y4+eiop0DCPkRUgQfvWnp0phg
	J3gqloD7V3LrYsLAkTvYNUU+DDvl3GTh4mCYUoUOpOC+mSfn+XLx/Mjrevw2g9++XXnvQNk2Weu
	lsz/JI2x3yd/YuYqqW9x8wnskgoQh/UWaCZW1JfotZKorm63u169zwtZW2GDxtf8E0geCa0o0BN
	wBPilF1nZ5z6rf8DWYdJxzMF95UZV/BFnhw3n3yIm4AlFvN4=
X-Received: by 2002:a17:902:d503:b0:2aa:d5ea:4cfb with SMTP id d9443c01a7336-2ae6aa04db7mr16401005ad.9.1772615979845;
        Wed, 04 Mar 2026 01:19:39 -0800 (PST)
X-Received: by 2002:a17:902:d503:b0:2aa:d5ea:4cfb with SMTP id d9443c01a7336-2ae6aa04db7mr16400755ad.9.1772615979358;
        Wed, 04 Mar 2026 01:19:39 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f244sm202462505ad.59.2026.03.04.01.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 01:19:38 -0800 (PST)
Message-ID: <63796688-2733-4401-936b-3dc5a60f297e@oss.qualcomm.com>
Date: Wed, 4 Mar 2026 17:19:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "ram.dwivedi@oss.qualcomm.com" <ram.dwivedi@oss.qualcomm.com>,
        "tanghuan@vivo.com" <tanghuan@vivo.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "chullee@google.com" <chullee@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260301125116.808992-1-can.guo@oss.qualcomm.com>
 <20260301125116.808992-2-can.guo@oss.qualcomm.com>
 <f5e4e0e44b071fb355a2900e2b8c9ef504fb15a7.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <f5e4e0e44b071fb355a2900e2b8c9ef504fb15a7.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: hz-FPqQjBakD7RbFywt2vfm9yocw59WM
X-Proofpoint-ORIG-GUID: hz-FPqQjBakD7RbFywt2vfm9yocw59WM
X-Authority-Analysis: v=2.4 cv=A75h/qWG c=1 sm=1 tr=0 ts=69a7f92c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=C5vNK-4RAPWpfsQx8IEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA3MCBTYWx0ZWRfXxkZSDwSHF8bx
 c6c487OKFVeu2SMXUOIpGC9ZNw3ybBkUR6n53YsC1AkcwF+DWlmumdaZM4ITI8z9K13MCsN0BrG
 93kCzQpLoHe9nNyuJ+D+Zx/uVoPI2WO8jgM3yZIB5VX9B1D4/U5WOWezthrKsg969ZQi3bYMiUh
 LbsGhYJ01qSz26m3a/YLFqpLwzx8A9Wfoj6YLNP/rmg83WmKVZKF2makeQN0qHN0J7PEf6jAeJR
 exrcrwAqdSb6Kq1FzW5dtaNy57I8/cwqXJDl39AN64TZ0A7JBtzAWga7YkGur0FkgblJ/ykgIpe
 FO9weLPGSkRJ439dL27tnXMJiezcZmzWq2Y3V/NG8xkH4LWgktFIlZoXmP0DLr4LclUY6RJsbXU
 Gf65IKvbcTwTMFOqDsCAUAoAHdCVrsBsMdIFfeboSShbx8D4dkCg8MRZ1poxPBoPF88G1u9Vz1F
 KQcRA+9y/IL/RCXTLVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_04,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040070



On 3/4/2026 5:12 PM, Peter Wang (王信友) wrote:
>
> On Sun, 2026-03-01 at 04:51 -0800, Can Guo wrote:
> > @@ -1768,3 +1768,26 @@ Description:
> >                 ====================   ===========================
> > 
> >                 The attribute is read only.
> > +
> > +What:         
> > /sys/bus/platform/drivers/ufshcd/*/dme_qos_notification
> > +What:          /sys/bus/platform/devices/*.ufs/dme_qos_notification
> > +Date:          February 2026
>
> March 2026
Good catch
>
> > @@ -9097,6 +9106,12 @@ static int ufshcd_post_device_init(struct
> > ufs_hba *hba)
> > 
> >         /* UFS device is also active now */
> >         ufshcd_set_ufs_dev_active(hba);
> > +
> > +       /* Indicate that DME QoS Monitor has been reset */
> > +       atomic_set(&hba->dme_qos_notification, 0x1);
> > 
>
> Reset value should be 0?
Bit[0] is used to communicate to userspace that DME QOS has been reset,
see also the bit assignments explained in the patch.
>
> > @@ -1116,6 +1121,10 @@ struct ufs_hba {
> >         int critical_health_count;
> >         atomic_t dev_lvl_exception_count;
> >         u64 dev_lvl_exception_id;
> > +
> > +       atomic_t dme_qos_notification;
> > +       struct kernfs_node *dme_qos_sysfs_handle;
>
> Why is dme_qos_sysfs_handle necessary?
> Wouldn't it be sufficient to use
> sysfs_notify(&hba->dev->kobj, NULL, "dme_qos_notification");
> without checking whether dme_qos_sysfs_handle is NULL?
sysfs_notify() cannot be used under atomic context, i.e., IRQ context.

Thanks,
Can Guo.
>
> Thanks
> Peter
>
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

