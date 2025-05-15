Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896DD1548C
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 13:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747315184; cv=none; b=ERt7dssCUJOOSTeVJ4EuD/qWIuFpZNvIBLEAbFYAen99K9NgyKRYqvwP0L/LG1sUYRiSnRaZrzNq4vXMJ/e48ELcpqKTMJqdpbP6fM+f5WKXjyJFm3uZeZUsWMsqsmnsslXK1uhskBxrkz2xWbmyiHeCKndZkuNEwmJrBDxmHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747315184; c=relaxed/simple;
	bh=Zm9G2xwsKgxjJOV+s44pc/j48Bw+8HAAyt7i8aA5CFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uYpU7zwlLnWL7NoMxI5uQxdzrztfCgnNQvonqYqMZwTjHkjL4eKCU6qyl+ggZJKuLzZuiPQC8ZczNzBoRTph4Wr8tiFCzb7DsxXc1QfFjT4AbLV1LDaEDN65IVnXBAG8dd8y2mMG7w7SmfholGOSdSDuB0DaO2PXd410D3iTyWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mrdd1QGl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mrdd1QGl"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FDEGpU003738
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 13:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	N9ZnOH3H7D9T5/jcmUmV/UrEQ7z2gjM/s4aRVI7E4pk=; b=mrdd1QGlH3nmNBIG
	urW5H4IpT4TLGnVcnFeUH61/QNb7SX4g4wLgSDtWGMu5hDLXH505aD+A3weKnbzZ
	iN5EUUKRfIqqNY827pgoBsdY60RszFWco8mEcKBzdmKXBPkAY4t+TaZ5YwKTNkho
	KYurG1J4VepnRPGW10zUegjnEIM9E/qIbJhw5KMxt+YOVO0fQqyBEBz0hoPbsYRe
	9qdclVsJDcH3vMSHYFP/LWtHcrox8xPpEYrIe2nt+Mb6iNPZdD1sOdwn1WhLPBys
	lR9KSTTv42pqaVZX+ZsSPlWIRnQ3QO1QP3Ai8c1M3EavIa7HCUHtMBpWpNE58E4i
	mgDWDA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46mbcmxe6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 13:19:34 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b269789425bso953266a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 06:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747315174; x=1747919974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9ZnOH3H7D9T5/jcmUmV/UrEQ7z2gjM/s4aRVI7E4pk=;
        b=p3jt100bq3OAZiVV9lcFW0IkzuHckrInj9ScnwNOsV9IUy4HmdKq+tRDJuNad6GHLy
         C53zvTqDQK3NBGx09k7Exdg9XjH3ZB+ho8iNDQ6aDsX9WM2Nd8m7QqhedZjGN+RttCV6
         Vmntrb4HCJNWPrbr38MhBPQeHhLgWgyPOGlAQpmzyOZ7I7CREJDkgAReDdZXkFElWsJd
         ilbSyaHEdPutOhaxE+soLq3xgv41HNHhoAKS1TDYf8ATEm0pDlLRi2O4lfEas/d1JWjD
         o3is+ZQYu96tZKsxx5wj2dj2raEOThNwvhyqF5QeeCuRT3abYcagwIA7y3Hsnxgt6mLe
         b4Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXaFlhElojiOKux9BRzwVZLENPcFJF9cafkpcBSubE9eKFFlesx3z9JtBfe69HuNDmd0tOwNSrNAFfE@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhgw3SwSUwmYeQnHlhcXugygE33V40Dt7TjiMH+JhUmExneA+C
	Go4L3gua8HoL7vaP8cqOuDoAZpbZaW+JODcgSD5ejTurjL5fs2H5uGUE3hK5upXemthVjiAZa41
	2UyOxaSVrUhcMga03wLrujR0DDjyCnq5kVmBvYyyZHHuKQz7tjyubDxH7V0jfDB7GhVPQQYMRku
	ACO1+JeI2yMsP3HWTwQQF5huSbBDVxAfz8l2o=
X-Gm-Gg: ASbGncuL2lIo5VKIbWuPO9KdhxuYstz76/k7EHFVkY0/pVMw9BpB/7WxfnvrDH0bHYY
	V7lnINWchdxfdLPKyV9FBljA1QoFhjeaSA5WAfshZ3IMjPrZXKn22epZDPCfBEvn9jL1UeA==
X-Received: by 2002:a17:90a:e188:b0:301:1c11:aa74 with SMTP id 98e67ed59e1d1-30e2e623b1cmr11402954a91.28.1747315173516;
        Thu, 15 May 2025 06:19:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg3d7BDHmGBsWU5XublPLB/XPFKdVZJsCS3maA+2gokDf2UXAOsvoNFXdOBK9T9ttq9rS6Ga8UZDTSSIcvfmM=
X-Received: by 2002:a17:90a:e188:b0:301:1c11:aa74 with SMTP id
 98e67ed59e1d1-30e2e623b1cmr11402926a91.28.1747315173123; Thu, 15 May 2025
 06:19:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250509075029.3776419-1-quic_ziqichen@quicinc.com>
In-Reply-To: <20250509075029.3776419-1-quic_ziqichen@quicinc.com>
From: Loic Minier <loic.minier@oss.qualcomm.com>
Date: Thu, 15 May 2025 15:19:20 +0200
X-Gm-Features: AX0GCFuFBDmXAIIDwfx2Hc0T0HWQcGYYPE6n1w2SXKdLrh5wT3S981IyVtwjass
Message-ID: <CAAwKf-cBLTN_H-tOYu-k-4uBJB0qE=A2GE5LyH3frSV09eU91A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Bug fixes for UFS multi-frequency scaling on Qcom platform
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com,
        neil.armstrong@linaro.org, luca.weiss@fairphone.com,
        konrad.dybcio@oss.qualcomm.com, peter.wang@mediatek.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: emjHv-dQCLOha_5TmBoNxyXdMch05H20
X-Authority-Analysis: v=2.4 cv=HZ4UTjE8 c=1 sm=1 tr=0 ts=6825e9e6 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10
 a=VwQbUJbxAAAA:8 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=COk6AnOGAAAA:8
 a=KKAkSRfTAAAA:8 a=thS5M9DFgM1jH-ShU_sA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=Soq9LBFxuPC4vsCAQt-j:22 a=TjNXssC_j7lpFel5tvFf:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: emjHv-dQCLOha_5TmBoNxyXdMch05H20
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEzMSBTYWx0ZWRfXyXizgRbjc2ms
 hEblVxqeVjzsfz+xXXrja2fDG0EuEb/Lwcw1ktAd3y7lSxsfuEvOir4gRvBIy7B/dKjFidfdAKS
 3vBTfZnroU+k6TH1Af6HSl14m/QozKtFSlRlVITK0pQpKafsxHocZnPpArcmiAdW91q99uA2fDH
 mtFrb3gTqoDaslpoewGl3nhlp2H8uCpbqD29JktjzpaGYk7mIXsFTGsU0zlL5jmz2e7Lkkcki/H
 Ai24KZyMvPpS0+xQ8zeKulWhNBk89QCK+Lbs3j9ar+nLk5nb+wKL/YDNo3cIDb79yYARs+PBQvu
 zCEwdObXYhrlW503yWSlxPZ5fy6pONfyHXt4GDfpFzISmZNkrafEBScTCoL2gbBVL3JfFN1hChZ
 bCQmZU8WT6QX+XGkIArBdbn3YEgVto92kXhzefe0FpcEBbIK4DmetwOjxFwTWsqUx3TKpmAi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150131

Hi,

For all 3 patches of this v3:
Tested-By: Lo=C3=AFc Minier <loic.minier@oss.qualcomm.com>

On QCS6490 (RB3 Gen2) on top of 6.15-rc6 with defconfig.

Thanks!
- Lo=C3=AFc


On Fri, May 9, 2025 at 9:55=E2=80=AFAM Ziqi Chen <quic_ziqichen@quicinc.com=
> wrote:
>
> This series fixes a few corner cases introduced by multi-frequency scalin=
g feature
> on some old Qcom platforms design.
>
> 1. On some platforms, the frequency tables for unipro clock and the core =
clock are different,
>    which has led to errors when handling the unipro clock.
>
> 2. On some platforms, the maximum gear supported by the host may exceed t=
he maximum gear
>    supported by connected UFS device. Therefore, this should be taken int=
o account when
>    find mapped gear for frequency.
>
> This series has been tested on below platforms -
> sm8550 mtp + UFS3.1
> SM8650 MTP + UFS3.1
> QCS6490 BR3GEN2 + UFS2.2
>
> For change "scsi: ufs: qcom: Check gear against max gear in vop freq_to_g=
ear()"
> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on RB3GEN2
>
> For change "scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock fr=
eq"
>            "scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling =
path"
>
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Closes: https://lore.kernel.org/linux-arm-msm/D9FZ9U3AEXW4.1I12FX3YQ3JPW@=
fairphone.com/
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
>
>
> v1 - > v2:
> Change "scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear(=
)":
> 1. Instead of return 'gear', return '0' directly if didn't find mapped ge=
ar
> 2. Derectly return min_t(gear,max_gear) instead assign to 'gear' then ret=
urn it.
>
> v2 - > v3:
> Change "scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear(=
)":
>   Replace hard code '0' with enum 'UFS_HS_DONT_CHANGE'.
>
> Change "scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq"
> 1. Skip calling ufs_qcom_opp_freq_to_clk_freq() if freq is ULONG_MAX to a=
void useless error prints.
> 2. Correct indentation size to follow Linux kernel coding style.
>
> Change 'scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling path=
':
> Skip calling ufs_qcom_opp_freq_to_clk_freq() if freq is ULONG_MAX to avoi=
d useless prints.
>
>
> Can Guo (2):
>   scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq
>   scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling path
>
> Ziqi Chen (1):
>   scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear()
>
>  drivers/ufs/host/ufs-qcom.c | 136 +++++++++++++++++++++++++++---------
>  1 file changed, 103 insertions(+), 33 deletions(-)
>
> --
> 2.34.1
>
>
