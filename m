Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DA4481DD
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2026 07:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773041449; cv=pass; b=V2YqwPtRr8nx1vksjojGA4XgMltwokcyq9uiUxGy5eedTx3PMijJMiVLyslBFs6QMbHG2RBbF4k+6smrmC20XJTsweEVtBsqOsE4u69VyqtSQjo4DY5Y4L8l7c0Nwh9XCzKoP6jS8RvygsmGNFNz5K6kME22MUpQJRjQ0Bu0W+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773041449; c=relaxed/simple;
	bh=Kd8qJEQ1MJLL0QfvPt72Ua3hnI5RJ/rb/CwYYMsza9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I/4QeirDWjbhpJHJqzEoD9W9vkGWRga+Ta9B/exlILv3IRkGff6v4Tn7+5ZpO1DjAEtclX49LujxpQiXXPrVJjGFffWekFiMVcSWZ2Q6XTqY9MYm1Rp3E9a0R3gMxYf9PmdMR1cz8w3fYydySvQqk26740XEWJiIirsc46GCFLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RSFBYzch; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q6/1Gvy7; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RSFBYzch";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q6/1Gvy7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628N02tT756776
	for <linux-scsi@vger.kernel.org>; Mon, 9 Mar 2026 07:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6vgyV+Kwyk8s5UKBM6CVvq8A5daBL1eUe5rh4Kx2894=; b=RSFBYzchkx1FJOkU
	MSQihrtqCbBriUU/UThW3/sACa3gwCpnDJS1F1MHLzbZtwHgEVzzg9YU/BB9FeyM
	FqqlvLcdZiu2627KnFin5jCxRKRPi60KfPfyOYUODjjIhxfgAUDzvSYp7U0ZTVEp
	W/8/cN+vX1RMI/0S9mBb3aak1m5bJPygWcUvtjLLFq665QEJYOPBW792BvxO9k68
	RLO6O6k2OjGks3/8L7wu+G7J/p1DwGktcmm9Y8mkqHAzp8HTzYtflJAmDQpWt1P9
	jkAJdC6fDxbnRmNQYywgjl88sdUCYq/D9ficpnRqvVlYp0uXhdaHZWvVUqNrLgTe
	kRCbWw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crb14vfsy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2026 07:30:45 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2be191ce356so8025459eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2026 00:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773041444; cv=none;
        d=google.com; s=arc-20240605;
        b=iqaf0u7nRRBlrGehbpmyeLR7QVT8ECPpGcJJF/8wYTASBuyz6bSnOvBhB2YoW1s74Q
         +f0d6PcjFvs9zqNc+cytRO+2wi8rIV6D8SWrF9B8WZHIcaDuiM+Bd7+/QITUPvKgkSnU
         xx1D9nv3zijMke14jRibofkEAA6HYVG//fZFNoHwG69yIwiikXGx3pYQpI9nQb87pFDi
         ZHwxuQu33GLInhVKewYwfAlG802B56iT2BQ9H1KR1phCdr3hKGh9aUBli2cSRfzf5SqT
         w0fYH8/sZ3jyrUr0zPi1v8hJ2MhEp/c45Kqh9vBqeDKYYBFM218eEjjAqIA540uNTABq
         /JYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6vgyV+Kwyk8s5UKBM6CVvq8A5daBL1eUe5rh4Kx2894=;
        fh=oAQVzaxNU8B5I9dCu3A2P2WF/ZhfyFwu6ToR90O77I4=;
        b=NfWUAAeV1KX8JAGlvgzpYA1zkRI2wI3C48hhjswXYI4lfsJ1mLODffx45ifC8S2dP4
         VwJb3dNp4WXFbvzAhg+dym/5CHAnYAIG+Kc2sz2ZbHg0VIuQ1WYzgSG1LIlhlhJ3v/0y
         grZ2PbVPclvorVfsBFzkIbURL0oS8verXn38YBMSkcMOrCLhMJyHz7w7wsK5WBierfw/
         LJVc9Xrq+GyKFXJLXabJmaxKYfsg6jnZCE/aIwAtAxyLArAVz1pkDY/+X//bKwNoqC/R
         v8vLeu0hjlIpEuqu/a3fuCoiZrEg2P+LoHr9WSnWzQ7JA0XcKgQHF4fLnDZ+1hUxL5RJ
         MtFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773041444; x=1773646244; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vgyV+Kwyk8s5UKBM6CVvq8A5daBL1eUe5rh4Kx2894=;
        b=Q6/1Gvy7mh+NwQGngFQ8eA3klw/zVldQh2efbXiJz0NGl7rhU4RtbdlS3hkvYwnlDj
         F4xikf9sTyhzsU88WtU5Ai0mw5IrGcRQeM8qQ2kuUgs0ItwctiMNUzxg4ZO0G/vPex58
         IRXHTWjqrrSEbSNvFAv0cnv0e2j5gNz0Fb8X3ieyTaxYCcUkXePxDmfEsBKysnMzfEE4
         /fFC855a+oXXKQeXIcnpTr6g7Q3UrLr/FjFzfR+tOwtclyZtQY8zBe6WJizw0RKCXZxr
         f+uuqBhhzI/fsvWqjPvJZJRYOD2o1YLQpE//1ocacq9kqr4R4CidnSOmpcw7wKPeOuvL
         EfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773041444; x=1773646244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6vgyV+Kwyk8s5UKBM6CVvq8A5daBL1eUe5rh4Kx2894=;
        b=cbahIQddgFu7Z046Pvt9ry5VUaF3sxce4hqMEeUuOHwnzVdC0rdO+5WxLwZSZ9UTKS
         j/h/X5C7jt+XDCKDhichL+jG5ar8akH9La5p0OTenvl2ZctedtRqNiTD17IgpGgCwxhV
         CtdjOlF731aV/Opt1smJ0ZdqKOWPWos2PoSIO1Q6j0dBumWM/SV5XRrZArsyETC/oYj2
         d5eMk4xfM0Y6LvMYF6GOpo4sUPZzc7Xelsi45Y3y9nU7xyK8P9D9GgRDXGeb9nWBohd8
         e2Gir9yPVHXsdvFcaeC9C1Bym9cg1QSaN5Px+PoHbXHaRDzfeil2UOzW1CIBHVq6LR0S
         nceQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt6FM6s/WiUBRJT7r57bodnFy2M9hQPsFqWFNCDitFAyZEMGlw5GQNWfTiBEEU/S04CI7rc+vxta4S@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtq8XpSAlr4mFQBd/5wMBc3kcthIXggz77am1cnwPMrZSJDMc+
	iBZdX7E1C35RimaHvZmdeqX0qmvaV0at+XhxOKXQanNOriLjPQww8T/1s/usruOln8aJ/RVP/a2
	LsMaYcxKXTuhZKNnzny2xBkyFAL6bs/wEqe11GzkyB2qwA3FmWWsfri+3jLWbb8qgoQeT27uaRN
	e0brgXmDHLSbElS4DlUv6Aw5y59Atq6BmW/TykNqw=
X-Gm-Gg: ATEYQzzo2eyTb+O3C14+I74OTHzhBg5jW5Ms3oKzcu1Lwbiy0yNsqdGWbLDNi5FF7xl
	yncXwFl0NpAAN8moKiEZNmLEJ1ns8pXtc0n2Q3pCbS5oRMRYuTuuAB7XpZD6rKkwlGFtW7wQjm/
	mw8znmeuH0eZBGyzRQe1ZVyBQlBaEmnvH+EsRsjpYxg4EsOm4i9yJRYO/pVan7r+5KoYLBT8Rjp
	FU/QpM=
X-Received: by 2002:a05:7300:80cb:b0:2bd:cbc7:16e2 with SMTP id 5a478bee46e88-2be4deaee17mr4001095eec.13.1773041444356;
        Mon, 09 Mar 2026 00:30:44 -0700 (PDT)
X-Received: by 2002:a05:7300:80cb:b0:2bd:cbc7:16e2 with SMTP id
 5a478bee46e88-2be4deaee17mr4001080eec.13.1773041443825; Mon, 09 Mar 2026
 00:30:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309-qcom-ice-fix-v6-0-4dd3347df530@oss.qualcomm.com>
In-Reply-To: <20260309-qcom-ice-fix-v6-0-4dd3347df530@oss.qualcomm.com>
From: Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Mon, 9 Mar 2026 13:00:31 +0530
X-Gm-Features: AaiRm52VPpypDsuJ5PtJbOzCheET4KyzNoAC9-1s0jjopDFrH_S9Z9ZnkapMfGE
Message-ID: <CAGptzHP7g3frxtF2UKfUj=TJaJQobX3FrTb+eqRE6p8JPDZjEA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] soc: qcom: ice: Fix race between qcom_ice_probe()
 and of_qcom_ice_get()
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        stable@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=IYSKmGqa c=1 sm=1 tr=0 ts=69ae7725 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=D8yADozZ_YwZBmLQuGgA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: 81ZMWhLd0LkLqHljhHBYr5IvhfN6NWND
X-Proofpoint-ORIG-GUID: 81ZMWhLd0LkLqHljhHBYr5IvhfN6NWND
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA2OCBTYWx0ZWRfX6NWBMiK/UIy7
 uvf6nKBrKIkNB7EASR/7YWdAWBvFjlXVMtJzymsQD+Y7DnfUdnL8lzTCeZ4V5Cm+wrP7kD2G/gD
 ej70mGp26z7HyOXJRSyId9XuOOLW0KfD92rLWPNhOi4ZpoLZiajrpINASMBVY5PkWzYldoAIox4
 Thb+4GLBvOmZiKkMebqCB0HLdg6/3rJfQxD41Rqn4w2X8SGee9Fvuv9pgrlmqIJFOZ4N98kdgUf
 5m5f8hzcbG81ITJKGkAzfpp17lC3JDYHlw9+j5TJb/tj78TcOA5nw8UhjriPLz470aNr958FTbj
 jHbIj2pfAos3slO4ERHjamPD2eyLtfK9x3MKQ13QLEbgsvx2UT2ZRJKeFtKLa4sgSqXaaV1bKDr
 2wv2xngnOUi/vQJLNfetyBvZILi9xJiN6A2id8f5zzXYM3ovH9/XwFhq6flfSU84/rEAET2kwof
 2JZxjFvKF9wRAAsux/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090068

On Mon, Mar 9, 2026 at 12:28=E2=80=AFPM Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org> wrote:
>
> Hi,
>
> This series fixes the race betwen qcom_ice_probe() and of_qcom_ice_get()
> but synchronizing the two APIs and properly propagating the error codes t=
o
> clients.
>
> Merge Strategy
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Due to dependency, all patches should go through Qcom SoC tree.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.=
com>
> ---
> Changes in v6:
> - Fixed sparse warnings
> - Link to v5: https://lore.kernel.org/r/20260308-qcom-ice-fix-v5-0-e47e8a=
44b6c4@oss.qualcomm.com
>
> Changes in v5:
> - Used Xarray instead of platform drvdata for passing the pointer since d=
river
>   core frees drvdata on probe failure.
> - Link to v4: https://lore.kernel.org/r/20260302-qcom-ice-fix-v4-0-0e6574=
0a5dcc@oss.qualcomm.com

Thanks Mani for taking care of my inputs, this patch-set works for me. FWIW=
:

Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ

-Sumit

>
> Changes in v4:
> - For supporting multi-ice instances in a SoC, stored the err ptr in plat=
form
>   drvdata instead of in a global pointer.
> - Link to v3: https://lore.kernel.org/r/20260223-qcom-ice-fix-v3-0-6ca584=
6329f7@oss.qualcomm.com
>
> Changes in v3:
> - Dropped the platform driver removal patch and used the ice_handle to pa=
ss
>   error codes. This was done as I learned that we need to have the platfo=
rm
>   driver design going forward and also removing it introduces other issue=
s.
> - Link to v2: https://lore.kernel.org/r/20260210-qcom-ice-fix-v2-0-9c1ab5=
d6502c@oss.qualcomm.com
>
> Changes in v2:
>
> - Added MODULE_* macros back
> - Removed spurious platform_device_put()
> - Added patches to remove NULL return
>
> ---
> Manivannan Sadhasivam (5):
>       soc: qcom: ice: Fix race between qcom_ice_probe() and of_qcom_ice_g=
et()
>       soc: qcom: ice: Return -ENODEV if the ICE platform device is not fo=
und
>       soc: qcom: ice: Return proper error codes from devm_of_qcom_ice_get=
() instead of NULL
>       mmc: sdhci-msm: Remove NULL check from devm_of_qcom_ice_get()
>       scsi: ufs: ufs-qcom: Remove NULL check from devm_of_qcom_ice_get()
>
>  drivers/mmc/host/sdhci-msm.c | 10 ++++-----
>  drivers/soc/qcom/ice.c       | 49 ++++++++++++++++++++++++++++++++------=
------
>  drivers/ufs/host/ufs-qcom.c  | 10 ++++-----
>  3 files changed, 46 insertions(+), 23 deletions(-)
> ---
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> change-id: 20260210-qcom-ice-fix-d2a3a045b32d
>
> Best regards,
> --
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
>
