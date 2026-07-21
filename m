Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEB842A7B4
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784617118; cv=none; b=e8z9dhAQWgnwcciD4qIxPY/I5VXNfB5whH+/IlEa1YgO4V/xcnUCKbflpRHCYmLDmDE/uSQ/mBzkwdFMkupuz15vkiRqLM9foYuz7+9IyO43lrHVqZIRRyD/QVAmCvNUIBs6an793s9ULqY1Wz9dEDz/TkN3ISz7Y8gIx+BNQPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784617118; c=relaxed/simple;
	bh=NJd4EkRfAtoEnjj2ihwLIc+eJJoaHCMMwHpoUKgEz5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzFlAD/fj093FM0zndVymdNW7Z8vCDpEdTPjInQ5VfzZyagxj32wGHuNw98EcVEahY5PcKsjhbR/Dh8XzLgPTqetyf4nZgEKnsE7UX/9xPsk/RcXye/ngYetjwLHdOZgxEaFsGPrtCPxCVzoKQraYyI5oKTujaZZ8sV3Q8mtDfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Df2rqP5x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gZYpRz7M; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Df2rqP5x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gZYpRz7M"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L2nCNL043254
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 06:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=sQp7omiTY5SOBB7FKn02Tfxd
	kP6lfbDEMgiOmcuIGzo=; b=Df2rqP5xKfuFqKwOBSbr9giW2PM6l/UIXVd4IDmz
	UczNwYD+az4/008yhjX68UBNgFdEPaU5YXgk00/3C6ZOzNf91R/CXnWNy/khLKpl
	N4B1qu1O+bIFCAdoMaJqo/ixHA8LiwVt10E7moqlljjKFcaceoK915BJg9IMJWzO
	vvbl2J4XgLqlu0G6ktmklcrgaiSVdBcTMVyjCqWXPy0yRQpAVQQKLvf6hNcSaoZ6
	ZPfLhtPLxz1YuIkYR0MvyTk+mhcql+5mZ0qRk7uTViRdcObVxlKTXo1ziy8VdTwj
	S2e1dnyOeELREpPbJKlcrfrpmYRzwc4eTukwyTGoPjHaEQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj0as0xnr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 06:58:34 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc640dfde3so88206745ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 23:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784617113; x=1785221913; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sQp7omiTY5SOBB7FKn02TfxdkP6lfbDEMgiOmcuIGzo=;
        b=gZYpRz7MKwedOV7xGp6YsB1uhYG0vOusiVDwDYCk18mmWyv3SPJzH+2Dl40U52+i/K
         ALvPrFu57CtNbEIIFfpt+XLkvD/s5wl+AnWzG/Ed78OdauY4Gmc/rg4bxaZ9HWU2sLnN
         ObZnZ6BN44Dg/QZnqwG+ZtjyeXRvvv/hS8mIX7RcFyIaOIOxm0MTwuPpN7ecI3M/+Ued
         CJ33KTtbypuZW5xXxcrLfLHtk20xqz8LuuGYEUF4DlRNrZe46oFYwmxv8+mJdhsodYFl
         wXMPJWAS/XDL5lPzInsf7aTFfydHAE+3GHxceioaau2QDsq/Fe1hooJlSXbjptd0a5uB
         k4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784617113; x=1785221913;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sQp7omiTY5SOBB7FKn02TfxdkP6lfbDEMgiOmcuIGzo=;
        b=poi/6wycmV9eKg5KF8cWL/lFgJ7SQQahCvpR7SoRKp8+b1wmEJ5u8OQZAAFoxU6k1g
         tag6t1jaEHRUCwWbMoqaSJyxuoZZeR6sU+JUo10ctZ0HQSg6IHBOuvpBnV/PlKhMisdL
         oaLLghq7/g3S9+ZMPQNRPzdf+ahdrW6O9PzazhTw49Otvnmu9hBOzgZ5kDAE31rZMkw7
         n0Le29xGLboa9/qPkcrpcW3WISh+ZcpLSMn1BuRfXH/FUbb+YmrciY1DcVivi1HNkRSo
         fxRchCcQOIGZDqMmyWzL/25n/CNtvKGtimcgWHDnS7nirfkKUFAjK0DWCi3BzJybwzYl
         HPpg==
X-Gm-Message-State: AOJu0YwjRxck3MCFTmRzqKk3GnXTkgaY1iVDaiSBBODJgPd57DYHkA7S
	3rdhXvAKkrxUswP5kYaOz1XJ96GuQ0ZD2AFRmcz+7mUyhSRQBan3oqQxHKBwcwms5wtKNrXqsTh
	Ys6BxCX9Xn6fVobPp2nsQ6KQyDsF8qqhIq2UGzUBub5Q8Fpp2pcEaqq4EsNwi9d3L
X-Gm-Gg: AR+sD11V8/AVpW0e3R5O07sH+qnLu1uP0gdJLxWNi6Ql6VGRPGRGjleE4UImxpBCEJn
	xpO1dMqMUSgmhKk1bRNHSs/j1VTITZzsO1j2YLpVKSnolyujL+3xaJnNO4q0yl4Wz8TNHbVtfGI
	Sx9ikWvB0V2ft694lrUpdWpZ+cVwL69vgt40Ie3/5o4z7qlfMKWrGp68X4yQwuUqB/ZbbFSCC3k
	jH4DS6xgIu7e6jXoLncae8s5UgBH7VWHImRyczB4q2sRwC++bQQBvAE+UDOf4Dhh/6ZX3vClAZW
	w1/HFRGZMdJ2/BQoCe4nRRFMlBXPQc+atP3LyxpLKrAiQvhduvbY6tuJ5NNEpbT99CawumkeIbv
	/h1b0Q5Dbs/yykjhl7U8quljUdUax6GcDvWu44ncSWY0=
X-Received: by 2002:a17:903:186:b0:2ce:e747:c5d4 with SMTP id d9443c01a7336-2cf34a34131mr191961935ad.46.1784617113564;
        Mon, 20 Jul 2026 23:58:33 -0700 (PDT)
X-Received: by 2002:a17:903:186:b0:2ce:e747:c5d4 with SMTP id d9443c01a7336-2cf34a34131mr191961725ad.46.1784617113103;
        Mon, 20 Jul 2026 23:58:33 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a6308sm69415505ad.82.2026.07.20.23.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:58:32 -0700 (PDT)
Date: Tue, 21 Jul 2026 14:58:25 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com, bvanassche@acm.org
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Message-ID: <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604133503.2049288-1-peter.wang@mediatek.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA3MSBTYWx0ZWRfX5YM+1UxawRLg
 z6N3i7/NB17EEpQ9hQxVVSxAB+CxCNGj58/Eb2PnSgG9XQJSooSz5MOYxp6kcSkoeJSmCQhyslL
 XdFd0fC7Zn1YRAzuOGqcRo4QG30w6RMA1WxWVADI66rMWo1x+aLccqw9Nkim/Twm22pkoG4eJ3A
 r57/1HcxzsKpf/bs/7Smw0n6orFug7n3TOHEAB9xkyuxqJZEPcTexMIAWKyO3OhS/IQxw5JpCxe
 mYESBLz5XjoCzb8DOV1as1mbi3j58cDhPHDKE/QJkgQr/Es+Eeu7+yBrCeLEtJ9oryQ90JFS0/S
 wIhoHG+kcVarTMygHOLPL34Auz65ZM/Yfki5NO0DRwrRJKKwagchMSZHJddBXl27U5gVbXX6nwX
 UvklGt3TiIWHxyjpyDjeA/ny5yIFn2qQN/EtP3RND/Q9I/wUMCv+YmSm376CSKFc9A/Jte1cca1
 tg1CWMVyK+lQwv/nAPg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA3MSBTYWx0ZWRfXyKXZ66Mf8c5e
 bNu1g02YDd20seHFHCKCKn0/WR/kAtyjTy35IfY4BFz810jpmTDD+4qkM/yY6PsRzjruwY28Zmo
 o9qc6ZmzHi/qSzAMqp9bNCvwEosKXwI=
X-Authority-Analysis: v=2.4 cv=DoFmPm/+ c=1 sm=1 tr=0 ts=6a5f189a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=mpaa-ttXAAAA:8 a=dEaLZe4p02KBFegDHk4A:9 a=CjuIK1q_8ugA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: wzKyS02dgB2hd9alaCi63IiLibRYUxr9
X-Proofpoint-ORIG-GUID: wzKyS02dgB2hd9alaCi63IiLibRYUxr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210071

On Thu, Jun 04, 2026 at 09:33:58PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> According to the MIPI UniPro Specification v2.0:
> 
> 5.3.2.3 PA_DL_PAUSE.ind
> This primitive informs the PA Service User, the DL Layer in
> this case, that the PA Layer was requested to execute a
> operation that requires the usage of the Link, e.g. Power
> Mode change or PACP frame transmission.
> 
> 5.3.2.4 PA_DL_PAUSE.rsp_L
> This primitive informs the Service Provider that the PA
> Service User, the DL Layer in this case, has reached
> a state where the Link may be used by the PA Layer.
> 
> 5.3.2.5 PA_DL_RESUME.ind
> This primitive informs the PA Service User, the DL Layer
> in this case, that the PA Layer has completed its operation
> and the DL Layer may continue to use the Link.
> 
> The detailed flow can be found in Figure 52:
> Power Mode Change Using PACP_PWR_req and PACP_PWR_cnf.
> 
> In short, when the PA layer do power mode change:
> 1. The DL layer receives PA_DL_PAUSE.ind.
> 2. The DL layer stops and responds to the PA layer with PA_DL_PAUSE.rsp_L.
> 3. Waits until the PA layer has completed its work.
> 4. The PA layer then informs the DL layer with PA_DL_RESUME.ind.
> 
> Hence, it is not necessary to stop I/O during a power mode change,
> and this step can be removed.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

I'm testing linux-next on a Qualcomm platform. UFS worked fine on
next-20260713 and got a regression on next-20260720 like:

[   36.243001] ufshcd-qcom 1d44000.ufshc: ufshcd_abort: Device abort task at tag 48
[   36.250616] sd 0:0:0:5: [sdf] tag#48 CDB: opcode=0x28 28 00 00 02 5f 32 00 00 10 00
[   36.258521] host_regs: 00000000: d5c7033f 20e0071f 00000400 00000000
[   36.265065] host_regs: 00000010: 01000000 00010217 00000c96 00000000
[   36.271607] host_regs: 00000020: 00000000 00371af5 00000000 00000000
[   36.278146] host_regs: 00000030: 0000010f 00000003 00000000 00000000
[   36.284688] host_regs: 00000040: 00000000 00000000 00000000 00000000
[   36.291229] host_regs: 00000050: fffdf000 0000000f 00000000 00000000
[   36.297775] host_regs: 00000060: 00000001 00000000 00000000 00000000
[   36.304317] host_regs: 00000070: fffde000 0000000f 00000000 00000000
[   36.310860] host_regs: 00000080: 00000001 00000000 00000000 00000000
[   36.317403] host_regs: 00000090: 00000002 15710000 00000000 00000004
[   36.323939] ufshcd-qcom 1d44000.ufshc: No record of pa_err
[   36.329595] ufshcd-qcom 1d44000.ufshc: No record of dl_err
[   36.335237] ufshcd-qcom 1d44000.ufshc: No record of nl_err
[   36.340878] ufshcd-qcom 1d44000.ufshc: No record of tl_err
[   36.346523] ufshcd-qcom 1d44000.ufshc: No record of dme_err
[   36.352252] ufshcd-qcom 1d44000.ufshc: No record of auto_hibern8_err
[   36.358790] ufshcd-qcom 1d44000.ufshc: No record of fatal_err
[   36.364701] ufshcd-qcom 1d44000.ufshc: No record of link_startup_fail
[   36.371332] ufshcd-qcom 1d44000.ufshc: No record of resume_fail
[   36.377428] ufshcd-qcom 1d44000.ufshc: No record of suspend_fail
[   36.383603] ufshcd-qcom 1d44000.ufshc: No record of wlun resume_fail
[   36.390142] ufshcd-qcom 1d44000.ufshc: No record of wlun suspend_fail
[   36.396769] ufshcd-qcom 1d44000.ufshc: dev_reset[0] = 0x0 at 3853838 us
[   36.403575] ufshcd-qcom 1d44000.ufshc: dev_reset: total cnt=1
[   36.409482] ufshcd-qcom 1d44000.ufshc: No record of host_reset
[   36.415478] ufshcd-qcom 1d44000.ufshc: task_abort[0] = 0x30 at 36258488 us
[   36.422546] ufshcd-qcom 1d44000.ufshc: task_abort: total cnt=1
[   36.428550] ufshcd-qcom 1d44000.ufshc: HW_H8_ENTER_CNT=2
[   36.434015] ufshcd-qcom 1d44000.ufshc: HW_H8_EXIT_CNT=1
[   36.439393] ufshcd-qcom 1d44000.ufshc: SW_H8_ENTER_CNT=3
[   36.444861] ufshcd-qcom 1d44000.ufshc: SW_H8_EXIT_CNT=4
[   36.450239] ufshcd-qcom 1d44000.ufshc: SW_AFTER_HW_H8_ENTER_CNT=1
[   36.456526] HCI Vendor Specific Registers 00000000: 00000193 00000000 00000000 00000000
[   36.464758] HCI Vendor Specific Registers 00000010: 002aaa52 00000000 00000001 1c00052c
[   36.472987] HCI Vendor Specific Registers 00000020: 1b0113ff 60020000 00000000 00000000
[   36.481216] HCI Vendor Specific Registers 00000030: 00000000 00000000 00000000 0000183c
[   36.489481] UFS_UFS_DBG_RD_REG_OCSC 00000000: 00000000 00000000 00000000 00000000
[   36.497175] UFS_UFS_DBG_RD_REG_OCSC 00000010: 00000000 00000000 00000000 00000000
[   36.504867] UFS_UFS_DBG_RD_REG_OCSC 00000020: 00000000 00000000 00000000 00000000
[   36.512558] UFS_UFS_DBG_RD_REG_OCSC 00000030: 00000000 00000013 00000000 00000000
...

A revert of commit 85b2b9662854 ("scsi: ufs: core: Remove unnecessary
block I/O quiesce for clock scaling") fixes the regression for me.

Shawn
