Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CA4221274
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 10:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369007; cv=none; b=dqMVtfMWwYQpWB+ohXWaZfpkjCyXLumWtUpJ1zKWNOYP2qK12oxI+x1Q6rsO4iDVTZSdphUXSrXoYx4oRvDHnjNyDHlJYFLot2RjN/wtSQxG06zN6WvOMQ2OVAMdF8LHWHqH/foy6YWDx2Rk6gPRPaHGa2RMUzqJ9JxDiuLyzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369007; c=relaxed/simple;
	bh=z+r9d889Eoa+DB7Ik17dKAV89gPyeioS4D9kppwe7T8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQyaTSBM3rM5GIlXxoW2srLj4HlWGDn3S2WE7hqq5m751pvz0hlx9Gdb/hVJhmUtp1By7kjtcOSl02yXUdw054/+BEnh9oz972FguabRHM/5SUn96KDSvr5/SnEKdnYk6tRVYuOxrTpEWVweg06WYNf5Q3rRV/Z0MZbA0BJdXvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CIqcFrmk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CIqcFrmk"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53B5pqMN017273
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 10:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=NMnuTa2g/u6bG5PBHb9WLLOX
	p+EvkptmiqFPCHgzMnk=; b=CIqcFrmkaz+J91+AAQCMZo8BtGjG2gHwDxlWR8Mj
	Ubba4ZfDjw1kgMt7k92VYQ+E35NEj9QGX5Ei14goYUFLjhewVzB49wNOGmkNz99U
	M9eUxCLgyEuVZbWB7piS/7tanafjCwVf73vurRimktUx4Bbp3bmFKuAFgL2nXzZS
	SW1N8Brkom7+aM+xiMUaBibMStEvjIm/jbtuRpuzTxezWT4szr3bQQgvxZ0M3HpS
	eGBoc9icqRpNFZYFsqzr9jf78e7aqz9qbfGsewctKqShg9b5LcGAfjmH6mIxt3T2
	lwO2a54aFPQMBkXzDTMNPW7PE4RgcnQSWphjrLaPMb/T7w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twc1sy3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 10:56:44 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-306b590faaeso1639357a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 03:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744369003; x=1744973803;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMnuTa2g/u6bG5PBHb9WLLOXp+EvkptmiqFPCHgzMnk=;
        b=KID4jH5yGsUqNqKnWw4WIhj9FQ+WzYV+sk7ENcJhzDt/CFfUGMZJev/hpfabA6xADE
         0yg2i7e+pI5gm686ew/yx47qRyg3DQSf6+i76cP81vQi4Sp6T3T9tHjwYHNzmBjfrn8B
         7cbbAYXp8yrVOjyG2jRNBqJZuO1BewSkgnB7TjvnVJu/VqA7M6x2bTyhQK5AyEoB14CZ
         828nPSbihRqk27rWBxkuDvx7f2ICZ90s+Nxj3fWSd88301apAnZ6JDjxxiiANoOWGEGx
         c2cfeHlckU5BknwQCPBsyphPkSKGAof4101Wt2F3kMEXRkPbefApte0ix5NHn/BH01Jd
         UelQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfEl47B1t0EJqmNzwgCiiUzFFo9KkRJwNi55a67WATh1Y589s6FlFhBqNufs+11CiroLeEMPdl3qKB@vger.kernel.org
X-Gm-Message-State: AOJu0YzRotdenvT2fY2u4W5Hjg1Odq6+eSnRbwF/NOuPs19rht+fLE88
	NyKUVO+hYzCXkwoociO3GnXcytfbxjrXk6oS9/bzrnRNl8JR5yX9lpC/hX6hWvRX7FDTDb6V6pv
	dctW9i/zl8bBjPv/qmN73E45yywJ4JI0w7y5hlgNq8wI+vJchUHWaq7k04c5988K5QDnHLuSn1x
	MDNw8E8uB4nVVU8o4OOw7YVfF2fK8Iet+Tq2k=
X-Gm-Gg: ASbGncv6UYrlTRSeDteFXdf8I8BRERYx2SnzeNXpZFRfk7v5mGhPF5EjGobyUTJz0pr
	N/S/AbOE9mvGJtcWKlJ2Mt+GOqh3qwn8tM1bx/WJS3h8CTmaVbBNxTqvLnCQFnTAQgP7g
X-Received: by 2002:a17:90b:5190:b0:2ff:4bac:6fba with SMTP id 98e67ed59e1d1-3082367ccebmr3972426a91.24.1744369003013;
        Fri, 11 Apr 2025 03:56:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEC10V4HuepcPrjAbfR7o7tQD4T9I5MwkHAg2tixv6MMcm+xs1JfiXocI3oSlU1LZsF7E5UV8cn7MGz9lE5X8g=
X-Received: by 2002:a17:90b:5190:b0:2ff:4bac:6fba with SMTP id
 98e67ed59e1d1-3082367ccebmr3972395a91.24.1744369002676; Fri, 11 Apr 2025
 03:56:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-6-quic_nitirawa@quicinc.com> <zvc3gf7mek7u46wlcrjak3j2hihj4vfgdwpdzjhvnxxowuyvsr@hlra5bmz5ign>
 <4557abf9-bcd2-4a06-8161-43ad5047b277@quicinc.com>
In-Reply-To: <4557abf9-bcd2-4a06-8161-43ad5047b277@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Date: Fri, 11 Apr 2025 13:56:30 +0300
X-Gm-Features: ATxdqUFwNiDRdMcwM_zHvHGXNZvki0LX1hVsBLYCd-Z5sRRiCA8vfgXKNnKyQxk
Message-ID: <CAO9ioeXyDWOhe1cbGO_tR=ppZd1aC0GSdeMzQjir4XmDRMQ3Jg@mail.gmail.com>
Subject: Re: [PATCH V3 5/9] phy: qcom-qmp-ufs: Remove qmp_ufs_com_init()
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: nCFkIPFO4nL_MjZHuH2skYlRbdmi2cXi
X-Authority-Analysis: v=2.4 cv=KtdN2XWN c=1 sm=1 tr=0 ts=67f8f56c cx=c_pps a=RP+M6JBNLl+fLTcSJhASfg==:117 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=1tzRQYHw1gqR9l_dhREA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: nCFkIPFO4nL_MjZHuH2skYlRbdmi2cXi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504110068

On Fri, 11 Apr 2025 at 13:42, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>
>
>
> On 4/11/2025 1:39 AM, Dmitry Baryshkov wrote:
> > On Thu, Apr 10, 2025 at 02:30:58PM +0530, Nitin Rawat wrote:
> >> Simplify the qcom ufs phy driver by inlining qmp_ufs_com_init() into
> >> qmp_ufs_power_on(). This change removes unnecessary function calls and
> >> ensures that the initialization logic is directly within the power-on
> >> routine, maintaining the same functionality.
> >
> > Which problem is this patch trying to solve?
>
> Hi Dmitry,
>
> As part of the patch, I simplified the code by moving qmp_ufs_com_init
> inline to qmp_ufs_power_on, since qmp_ufs_power_on was merely calling
> qmp_ufs_com_init. This change eliminates unnecessary function call.

You again are describing what you did. Please start by stating the
problem or the issue.

>
> Regards,
> Nitin
>
>
>
> >
> >>
> >> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> >> ---
> >>   drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 44 ++++++++++---------------
> >>   1 file changed, 18 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >> index 12dad28cc1bd..2cc819089d71 100644
> >> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >> @@ -1757,31 +1757,6 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
> >>      qmp_ufs_init_all(qmp, &cfg->tbls_hs_b);
> >>   }
> >>
> >> -static int qmp_ufs_com_init(struct qmp_ufs *qmp)
> >> -{
> >> -    const struct qmp_phy_cfg *cfg = qmp->cfg;
> >> -    void __iomem *pcs = qmp->pcs;
> >> -    int ret;
> >> -
> >> -    ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> >> -    if (ret) {
> >> -            dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> >> -            return ret;
> >> -    }
> >> -
> >> -    ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> >> -    if (ret)
> >> -            goto err_disable_regulators;
> >> -
> >> -    qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> >> -
> >> -    return 0;
> >> -
> >> -err_disable_regulators:
> >> -    regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> >> -
> >> -    return ret;
> >> -}
> >>
> >>   static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> >>   {
> >> @@ -1799,10 +1774,27 @@ static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> >>   static int qmp_ufs_power_on(struct phy *phy)
> >>   {
> >>      struct qmp_ufs *qmp = phy_get_drvdata(phy);
> >> +    const struct qmp_phy_cfg *cfg = qmp->cfg;
> >> +    void __iomem *pcs = qmp->pcs;
> >>      int ret;
> >> +
> >>      dev_vdbg(qmp->dev, "Initializing QMP phy\n");
> >>
> >> -    ret = qmp_ufs_com_init(qmp);
> >> +    ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> >> +    if (ret) {
> >> +            dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> >> +            return ret;
> >> +    }
> >> +
> >> +    ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> >> +    if (ret)
> >> +            goto err_disable_regulators;
> >> +
> >> +    qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> >> +    return 0;
> >> +
> >> +err_disable_regulators:
> >> +    regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> >>      return ret;
> >>   }
> >>
> >> --
> >> 2.48.1
> >>
> >
>


-- 
With best wishes
Dmitry
