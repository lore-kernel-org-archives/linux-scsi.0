Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793283451;
	b=D+Zrqs6wqRjqmaBx5XKuhIHWKplmLuU+fJBItX34/AO9jXYO+Oe/1jydOa1XoYyC6KMu
	 c2aeiwwgw5bQAV2wChcgv3S7Oo1+6HpRzCKEent28PCu62IfQxIWNOlFSehZhLY1fJ+rM
	 0QbKxY4pzw4SCE7spSGzZ1Nj3DeozbrRs0zvui84MxsmpC5HpbP0K7ZJ8OnP3FtijMN+4
	 qtn3UcWHIOTv4ywLwM/Dxu9myYZPNU1iQHCtm/MmKS84G1Py2WKprXJRsEbd6ZpU8MebF
	 2TFpJWm2kNqTpUaS8TwtWT9QbHuffVTJMK8/5iOCZ89I/PL/atx4GSAfTlAO0TzEbcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283451;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
	b=x0R9Br/s/SMT/osT9PRjoADxhhY8PgQ/LQJcs8iJItNz+FADMnvt33LkvNZpznCCFHiR
	 raPhOGiJMbykpKq7hIgfdfC/P9DyfXyyoTP+rux4PM3ZXwruomiy/BdWv+oSeJg/Hp2ke
	 oQlU6czfTx66qmacYVkjnWIK1bMPnUFfzC1UYuc4nkS72TrI1thT+tgkLudAlMnjW4H/a
	 XTtPmjNMHF3PX0R/HQ8H2B+SOj9TSBba9n+7tvHqVlnNRyhfaIiLLgoWgtp7QcgUGcuYh
	 10y1IwEZkHHFu0V1K+A77uXneLxjMCWlGBiQxyGjd/RuGXQkDl+Ifa3KJz2wzHPyjEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MQtlFtN3;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FV7tq0S4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50B606A31F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 14:17:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC50B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MQtlFtN3;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FV7tq0S4
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCe41R061040
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 14:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=; b=MQtlFtN3Sm1zrKcl
	CXdHmjk1+4i2GVB87eTjCAk2iZ8XgI1ju1LAU9fXlFhNV3lr/9IrVHRJwAFbmdkm
	Yz7HoDbI3x23yjz2RH8Y3Buc3UnPlD7fF/Ua3OZYZE3Q6G3I1mAxGmbI3ZOnuBy3
	eia7RL+aIosfPaxgTMXhqvIFStyY4pkAGFJOMM+U+SSBGWn6HtliMKf4PNqmhyFe
	fnPaDJzPbHlf5JWHqENY1GquhwD1AiQPuMErzzn7/YMg0dl8MXa+Cy/mnjFjGFeV
	QKy32Fe913pIGO8sJQKEwvtopj3vAplKqWNOyhSRzxFOIwTfa+59EEnBiURPWoSJ
	S55T+A==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkpgpuycy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 14:17:29 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc73895c7d5so2338912a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793283448; cv=none;
        d=google.com; s=arc-20260327;
        b=ixt9+XuoESi8oLnMw/0gH575e0cita0SsyXmbza4CUU2dL8hRnzTjwnPKmq9SGo0DB
         Avy62DC98T0AIuVVZYXPjHOZ4HNk3G5m0p5h9uIwC4qmOrN2HyD5gCVMRuQiIin+Lkip
         qS0Lfz+sfzdM6nHMOrTS8XWWH1t/UyA7hTwGtcfNE1hP043Y7EXv9AWea/SfnfcuIvqY
         KpqKkvQotR/rIj3MMbTewef20ALoryOcuA95eDntXF27JQShy+fO5NyJQ2gxeoMNVsw4
         xP5GFOSLo8FaNWnfamyugXnmN+qnJOTaPyoxqw7XY9sudwg+UMn5BGx7/4AK1dAFXpBs
         MA+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        fh=uf0TZwQYsYrbrw8UHeAZpKBGjQ4IVZsGrSkQq/fvLMI=;
        b=q7fQDd28gXj8RAggrJz+oO6Q+CDua2DXr1lo+iy1ksVillwI01ufzagdRD97o80fJ9
         SzLiF4wOGn2Sxi4UGy6vr94DGNl1rG4Fg4QAjaohCqziU155dOFhZ0r0Lcv9GJXqSyqk
         +udoU6wCaCJkT0kcFLrrrWriIA9kJaM9DGJJk47Sseu5QBaLGIbw6He+6icQRTm55zbN
         ruTHhKtGa1GHnlMQUwsrpLoN2LR7sTA1Wta/l51C+/QEFsPKQrdHiKTsYzvnp3VCacSt
         odxbdMY489BFnW4Y8NZODd4BgB0dv4bmPH6FnFbGnu6rVSWxYrtByU+RYoKFCZ57WgDm
         YXHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793283448; x=1793888248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        b=FV7tq0S4XOyLA5hJtFsx831055+O53E5MQRGdNEJ+JLrsY+gVewcZdwKlvtqM/wiCX
         0SQbDs4dEYd5KE5PD5tZefAGantAp7looEZQJWa3fkqo93Id4UJAatOlpl6Dtru7dJNf
         pwJo1sR4ZFWGbjO56DMrL/A7S5YuYxnVFudDuOpoZrBHTIQ3X/WcG208SjxE1+bYrpYn
         2trjFG5CV+NZmm+B/3ughcoUNyLi9nNesn5tHmQ81NIzZvkf6hWHdsKOUSdTx1gHSyPs
         6DkEfxdTRtKBK885NKyclSseOWs5T/qdjFlE1r6Ib00YiGTUCUL8zDd8LCXSWUyRb0d9
         7WRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283448; x=1793888248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        b=OTZoWF002JH80iLkjNMkkBGPqNu5KlDdZGdPkDfP6LhPpJcx9q5+vdSPlEEx9Yy3S0
         rEXN8hzQ554NTVfZLsD4Vlv1hCwcWSkoNbxNH2VaNpXkDtWfHdwwblHawk4f//domwDC
         6ic1yjskE2WNwEMoh20J6erNu1nVDIUoc4/zfipXcws+T1km+fLtZnH8a0Uds8FK5pAI
         tRwG54Iw0T/+T6rQ+iybdZOudjLiRJvGGFz2WwspoYSdK+sNfAidcQHaHDm5FD0T45k6
         r2G2GIDhspaVr5COSBlX+xoRqPiVwP4vSXNc/6ouxMRQdJIdxZAMqlRVA7AJEFfsKty6
         XpWA==
X-Forwarded-Encrypted: i=1; AKwUvBwDBbk9r5HCDufogukDyde6RqmxBQ2r+I9na5wFxIPDxof6hQl+CmdWZkcUSN4Q/gQG4Zkp1oVH5ZIj@vger.kernel.org
X-Gm-Message-State: AFq9FYJmltCVqqtGv+y8l1iMgF9BcHsvJ0zvrMkWr1kdD71UZ7V4+nbE
	0CTV3O0ivcyfq3HsRsvqLNoLJRgfhc9ZRpTpeBYpKNglFkLmqAPh+LgCBfbKexesRiNwcyIDyN/
	cM/QEB2nVmcypvlBk22fGamU6v+VOTITrSaN1EHaAkTJ31HFa7kdVGcccqF4Y7FASee2k0hZRXr
	AsTUybGpcntoxvzlFg7IqQ3CW0Y1QaFsYlIxLu2gcmPPngMkI=
X-Gm-Gg: AYBFou0u57LBFdcgFAl5WqhPsizeJQxzeQMtDH7uWTCN7iGYzgnLzKjwc+K9v0Bg2xK
	GN6t/Oi+wrT5S58O2kXnvyrjs4xUNeiDfmnmduRd6hVl10WXLzLKLwA+LKkm+KQXF6tknkyGtzW
	vIiqYAJXxGcL5MLHr7zww6Uai0LdjQMAJ9JIyW4tZM4laR2uMVIkyP0XTLgw==
X-Received: by 2002:a05:6a20:6a0d:b0:3e3:1013:4665 with SMTP id adf61e73a8af0-3e90234d9cfmr5486421637.48.1793283448651;
        Thu, 29 Oct 2026 07:17:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a0d:b0:3e3:1013:4665 with SMTP id
 adf61e73a8af0-3e90234d9cfmr5486382637.48.1793283448152; Thu, 29 Oct 2026
 07:17:28 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 15:17:15 +0100
X-Gm-Features: AclHuK-yG8GjI7p3wdC6k_i_FEVr3l0Mml-BhNjxuIZOPYfSt36zwQfp3z00yhg
Message-ID: <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Subject: Re: [PATCH 0/3] ICE: Enable runtime PM support
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1NSBTYWx0ZWRfX+2J4UNMkgUVt
 ijH+Ff+8rfJm/w28qKjXZqJ9VeWeWsluePghYkIXqMlG0lKtgoBAQunZPkXlFpzHJ51SdONHDrf
 jH4yQ6n7WlhLQmMiM3Il0e9lTg6g+FF9gPcd0h7BenIb4n39sKgufOJgWF5S3kajNJen08hOq1S
 f3kpq1VIaemqhB6UUtdC4hcP49NOa6wSyf7nnVLK6ejX78xTi0dicVF4KnHh2gDozo7aPcgKOdM
 xMgfhSr4KXAGk5opcX1hSANALI4WGbMx4IDnmx8s2titnIwbU1FmYkasRrBTIBl695Iy1+slJZD
 479NyU+qbWBBZidfHkMYXoTevnGzw5zKPFfkVx4N1X4avocey6leNhSBVsRPB13icESzJzQS1KW
 LsGKdmjlB9tU8556E9157Oxcd35H7ZaHLkYKZzQBKB/E4fGKz/KNImRPOVe7zs5+WauKtA0Zpnm
 lymNsH/A3hJ26IKXJ+g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1NSBTYWx0ZWRfX2V4k10rs9TBc
 LLINvldjWgC/hO3vVWhBHP2Lu3GHTWzAE8ojQkhYgedFyR1zzt4tm/HHmgt4tRJpru9FOJTEw4T
 /wfMbYJOldhp/PB1bMs42PUjpXZ9D1A=
X-Proofpoint-ORIG-GUID: 0FwJXS7_TgzFx5EV1SpKH1VVvZeVMqVF
X-Proofpoint-GUID: 0FwJXS7_TgzFx5EV1SpKH1VVvZeVMqVF
X-Authority-Analysis: v=2.4 cv=T4oZ3PKQ c=1 sm=1 tr=0 ts=6ae35579 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=MNM1_axOnic6cDGTpHIA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290055

On Thu, Oct 22, 2026 at 11:52=E2=80=AFAM Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> wrote:
>
> This series fixes ICE clock lifetime handling when ICE is modeled as a
> standalone device and referenced by storage controllers through
> qcom,ice.
>
> Currently, ICE driver enables clocks during probe and keeps them
> prepared after probe completes. This keeps the ICE clock voted even when
> the storage controller is idle. Add runtime PM support to the ICE driver
> so the standalone ICE device can enable clocks for probe-time register
> access, then disable them and remain suspended while idle.
>
> While enabling runtime PM in ice exposed couple of sequence bugs in
> storage drivers(ufs and sdhci-msm) as any key programming call used to
> go ice and never complaint as ice-clocks were always on.
> Example, unclocked register access happened from ufs/mmc in
> qcom_ice_program_key().
>
> qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
>
> Fixing this issue require ice instance at early ufs/emmc probe so that
> correct sequence is established and ice is ready to accept key program
> calls from blk-crypto or any explicit storage operation.
>
> Merge strategy:
> Patch 1/3 and 2/3 are storage driver fixes and should be available
> before patch 3/3 lands otherwise will result in bootup crash.

Then it's perhaps better to send patch1 and patch2 first to get them
landed as fixes and for stable kernels, then when that is done, please
resubmit patch3 separately.

Kind regards
Uffe

>
> Validation:
> Tested on shikra-evk, kodiak rb3-gen2 and sm8750-mtp.
>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
> Kuldeep Singh (3):
>       mmc: sdhci-msm: Enable ICE before enabling crypto support
>       ufs: ufs-qcom: Enable ICE before enabling crypto support
>       soc: qcom: ice: Add runtime PM support
>
>  drivers/mmc/host/sdhci-msm.c |  21 ++-----
>  drivers/soc/qcom/ice.c       | 139 ++++++++++++++++++++++++++++++++++++-=
------
>  drivers/ufs/host/ufs-qcom.c  |  29 ++++++---
>  3 files changed, 142 insertions(+), 47 deletions(-)
> ---
> base-commit: 9a482184d910775cf648863148944945b74e2815
> change-id: 20261022-qcom_ice_pm_enable-3c5d21b99e42
>
> Best regards,
> --
> Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>
