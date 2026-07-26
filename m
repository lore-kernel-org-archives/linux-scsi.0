Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596D33C194
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jul 2026 02:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785033660; cv=none; b=rMD+dDUkouZJf/W7VMuZaRNBJP+9eo6+lQXvT3uaQ5z+UQASahXP/7ETpPihvJ0iWO/4nbWHvhBGD35H4CUBDOSgAgFvS++IzuhVFlIok232OQLlLm496nuQ0X6yTZPvlTL0BrUbZweoTULSmaykXqaoe9c5lgPeot1Qz3E8RKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785033660; c=relaxed/simple;
	bh=bGinmj9HAQbqbkT1zowrN8spDu+gNaURRFhkOFq316M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdZx1yD9rbyH+BnoOj9Bs4utLYyeieEuMvU0/u4oiLJOKLxH+22MRLpTLkaWzzcpwgfRj1hAN50+mq6K7hEYGZxMDPnlOVMdjkOV+d3tbqv6ivkO+ejX8Y/f7yIL+VZqOf9v9mD0Yp23uR31HfxzyBQCiQrK2uwhUyMyXz9cwjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FlwFWeZy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BwFGL7s/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FlwFWeZy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BwFGL7s/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PMvGGs3386138
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jul 2026 02:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bGinmj9HAQbqbkT1zowrN8sp
	Du+gNaURRFhkOFq316M=; b=FlwFWeZyqVbWsgQ0MDWwMvTsQWwX1ci4DWJvRyjW
	vJOGxzRp2fIBsl0v4XUZGH0OTQ7TtoBMWkc7voEOZzjGnvwWbxWP1+PRFtlBB+fI
	EVNmVLn9xLQPbgz4eYLeV/iKaOUd0WtOz442JpAlRhjm8dH5gWDLc+aNFrU8uftk
	xGFKcAn2GORJoJMLYhcGKPgNRI30kYS6uM2aTHdDWcbOHsrGHjHNB65tSKIOVZwY
	bUCQtnwVdRTqvPg/wY/lpn2ZotVcxjawUb9pmFdMOXt7ZPRTWErKJSOLdrM1eiL+
	CQnSWVzEdzqCxRg/NYRHTJdNg9YsQjm8FbZZhVPz7T6Rqg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmm57284w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jul 2026 02:40:57 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e7131849bso1958086a91.1
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 19:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785033657; x=1785638457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bGinmj9HAQbqbkT1zowrN8spDu+gNaURRFhkOFq316M=;
        b=BwFGL7s/xlTh0FkHyMzo5KuhmvjOosqi38/zFAt0MSOv5B9zW+tpGFK1lRWf72JXk9
         6sz1AVY8ZGiODw+QEX2LcWo8sQ5Xb50MmyZYcuVJnAbBszfGdv82GKkoUM1FXpeGmMjd
         U19HAzttVj5HjEDPRV9Sm97P5GvwlhRZXwS14lVAVqG7E+mTDY1C/LvSl7/J17HFBU6Q
         G2KREfCRepcB8wDKLjYMC5WSwPyPYH5hpNFpg2lr5BjzQBlICti2lc49O7eAqW5GmdqM
         jtz/o1XZ+d2X596CHdpblx1U6ID49GN/6/a1QGNVBeRPJxdg2v4ynB8R52bqk/Z0hEPP
         xtGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785033657; x=1785638457;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bGinmj9HAQbqbkT1zowrN8spDu+gNaURRFhkOFq316M=;
        b=M5fNM2EY53/uOkZpMn7lKULNFvy80Fma82KNLylZHBhbMDo6pxL1A01iR6MYVof8H6
         Fsn7LwOwPESg+uXBKB43csk1WrogDOORsDj0S6pyqpx6DNGLEQIGrGSXQ76WWbXKExqV
         YrPKuKJK4iAWqeqGPaf5qdPfPHmRbt5hdjjh5LHdOWeH5C68vN5DyTTLxqJBO9xetapN
         3XS+B+o6Rax82CC/kPGv9ETukN8LWC3JJtVdnqly+VrQ6OaKnYfrhHYjEC1oNR1YBJJ1
         HEZq3eHOxqpF+h5dDV9P3IBVW2ciOF/iCbiY1Za9pfL+uw8VPunqRywydY3UqLeMqJPK
         JxNQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCIuuYj5ijk5DVjP15DWAz3r/kGxbsffOfvDPoBw0RzQHPPuIpkIyz5Wc8iXTUja+WV+ZKx1eFkj3X@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6mmRQgVCK23OSJzfM97rJvLg42bpcsHidgcoqNn6DRqL/6coS
	KeHbpFAMfKCJ38qrq1U7EL+zlcLlNxltRJZcNJBTtzT4fTXvD/UPm00qe1Kon3Bvqe48TZVcEN0
	nq7XPhCKo+11I4hi+xZDi43nQYtWqO+ElM8wVB7oPXE+cnodviAQoMyQBVMmSjEdv
X-Gm-Gg: AR+sD10Lk9oNzgV8eQuydNUgQyB9gvfBNJSh+DEhPvCoQgcSMirvU9hcyUnyO29JcY3
	iisAfgatlEaruUDZYq/y5CAEQEDG2fChtPiYDYzh7BZje+/F1dqymzl7vDc9m54oUDVAdJVI6ga
	y+IO5Khv7X1gCCvYTLDcywIZAKbrhI2C6OEpCWdgEnhFcM+xxDhk6k4BMiQlbuNs0/qskFQT4Ut
	vyFmKuDNPqNxLAnFIFloigHnmGR40mpOQlZOTWRJtP5Wvx/7S7YVPBK8pPtmSPB+FpIEiV+VOad
	RVWbDOAtUsw4mTd4mKsFNPffkrH84fFCftFOHyKJYJ24zIy6YugEfT0wjRm1YdBCYg0IEf9XkcN
	+SEXH+U1a2HBE+elwHcJuMSqz3kDcIcpcEos5TIXoo+w=
X-Received: by 2002:a17:90b:1dcf:b0:38e:4482:ab14 with SMTP id 98e67ed59e1d1-38f29605bf2mr3868342a91.32.1785033656316;
        Sat, 25 Jul 2026 19:40:56 -0700 (PDT)
X-Received: by 2002:a17:90b:1dcf:b0:38e:4482:ab14 with SMTP id 98e67ed59e1d1-38f29605bf2mr3868326a91.32.1785033655891;
        Sat, 25 Jul 2026 19:40:55 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc59cfb4sm15374676eec.26.2026.07.25.19.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 19:40:55 -0700 (PDT)
Date: Sun, 26 Jul 2026 10:40:50 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        alim.akhtar@samsung.com, avri.altman@sandisk.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
Message-ID: <amVzsmnZxze5PZIT@QCOM-aGQu4IUr3Y>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
 <a1d56354-a556-4e47-875e-e6a079fd4938@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d56354-a556-4e47-875e-e6a079fd4938@acm.org>
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDAyMSBTYWx0ZWRfXyojuqckuX3qW
 iIeFmwsc9S2cp/yNMqkGod2Q5rGbg83Uqlgwo7z+/TPPoAWga0xOGnslgGp8OL7V+DRnlP91PR9
 /XOjq41IRxckoDDkefJ1M97Vx92pMQw=
X-Proofpoint-GUID: fA4aD5GUqYBOhvnjYmA3rRvtT0iegYH2
X-Authority-Analysis: v=2.4 cv=FOErAeos c=1 sm=1 tr=0 ts=6a6573b9 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=s4jt7IWuD85VgkVn8k8A:9 a=CjuIK1q_8ugA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: fA4aD5GUqYBOhvnjYmA3rRvtT0iegYH2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDAyMSBTYWx0ZWRfX8RiXpaQqpIkc
 SD4ktpG1QFcCWyXh32ojorH1BU+I7QtA65KIkb/PGgKzn8c6nZTSMA4o6ESzwfNxvR5kTe8u4UL
 0fHI0qqiwvOyU+ZRFzHR9jx/e5T2C2/9VKEjCjtEY6S9JPJBBEzMhA0yP25e49f9VFR7NZza1kr
 kSGxE683kJC+zHDKy8lNKB6aGEBmNnPiIizsbxBeEzq+CbdXH1EDziRdRwCzjIZF8KjMorYxVYU
 H7QAip9AswFIcJZ3s/AQ4bT2ikZA/xd1rb4mx3Y8mtGbnq3pCie7p7V0ccr/WzeWDrTJAVNTqeb
 Csp24QKLE2Ujjl8KgyNvPmt1EnopPWMrRJq/v63wfzCEvyu7nRHURhnExTPpN1JHj0p7Gbwdt8O
 R9Bs6davd+U4DNwQR7vrCIe4y7//ygAuYv9GGmOvKMtybvkoks4xGW0aTy0+oF1S7iBEU8YynbC
 z7jQUKygkWRWI1UQ5jg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_07,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260021

On Fri, Jul 24, 2026 at 07:19:34AM -0700, Bart Van Assche wrote:
> On 7/23/26 5:47 AM, Manivannan Sadhasivam wrote:
> > Reported-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> > Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Has it been considered to add a Fixes: tag to guarantee that this patch
> gets backported to stable kernels?

I'm not sure I follow. The offending commit hasn't even landed on
mainline.

Shawn
