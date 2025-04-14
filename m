Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4625A2C0
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 07:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744616607; cv=none; b=CyHdkbB/Irl6B+rPJBY+EhMFdBKacDfZW0FnLRAkY7m9OYNH/s/GWGT0ytFey2l5k5HkUmgo7KIii+Bg2TLB9nbOo8YcO4C4G/fERkIX7/USzGpAajoBgI1BcOhigiw+XtDt5ZT6b0bc9tqAIuqBopP28Gi41thrR9ZAiUdqOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744616607; c=relaxed/simple;
	bh=slvBVC6hmkYGxoROIH5HdxzsQjsj+FPXh6qtqyS+NEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyqzKW3VqLVbD2s7gwcfzMNqcDC3SjhIf6ggDP+If+xjNluwsP9IIcfvVISDHh/owg0JpHo2jaB8Ij9GcxP2Ikio62mtB1dgOHEkFsjSKoB7l6HXOfqRyI8QHEmjGFBE5NhxIdoAeo3kAl32DfKpait7SnJeaFDt9bccyREqEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kvtWch+Z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kvtWch+Z"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53DLkmTX010748
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 07:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Um1Ee0fatfSrCr9mgfrQaagy
	x2fBqusvxToSaiBP3Q0=; b=kvtWch+ZdYjXuycHx3pXD8GetCiRqYKLmtbPNll1
	EUrbuB0WMT9iBY0LIWApw19lumo9tkNyOj+7SSgvW0WXCM+Jp35Cc/f+tD0WpJD5
	HGhxmLzX3Je49Yb2zdWdnmTkB7T2IcFeoRjMP+ivOibKt3ggrXqoaI18mWZoPnjY
	vOeyZ/SnDj82DoBh4e3MNTLjxVl1N5xa1BtfqPJsbLhruLrQVH9tpjHC/ijIUnD1
	WoScX45w96aaA48CkqPh2Dsn8XYIc5n7kvjgdfSy1CGpBOuqPZ7RueLIcH5NP+Mt
	knEU20PwYBJM/TW9klPLZoJZeZxo9uYVyu2wrbfmaU2WTg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45ydvj3v8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 07:43:18 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c3c5e92d41so632033185a.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 00:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744616597; x=1745221397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Um1Ee0fatfSrCr9mgfrQaagyx2fBqusvxToSaiBP3Q0=;
        b=oY/394v/FIWvNgXzfuu9gzOumDvU1sQPnzhvblEKr4VmsEoEFN2Y+ADHQKFt7MqXbK
         2P7aYXJVgyD5hlUccf/mM/esjLC2M+8zxXDCsqluEc10N1WXr7nWd10L0sWMW0FFiP4O
         +A4T8/eiZnBrz0M/1mNBEw5OZTWMaE+3r4WXICN5LH6rxYDbWFLgTOqis63A7SwXhGzB
         Dac1haFFPrG3LsO8z/ftbLv3QGu6kg3EYb00zPNp452lnmHC6BC0b4EVGN6DjOgoOLGJ
         JNvvAwBWIWsL3PtDorvA8L+5gAbO9vUK0Jox+p1CYdEmxuORw9T1t7nT2/XK8l85u8YF
         cXQA==
X-Forwarded-Encrypted: i=1; AJvYcCV/fn1rBZr81tGpgkkjnC5ayq5OiBGNSdSPuWorKbtmPlPZZ2ghPb8V+Djss14wkSpJtGRRR5c8tjAT@vger.kernel.org
X-Gm-Message-State: AOJu0YydCxWTpkvd7ChphF8gT7iHgEfUAboXrPpzoK8UuZx599gp9RiF
	XETebEcWvlZZWWg1orQZZgzsGw+w+Adww++x9ycq3TdjQjpyOwfV35zUti/EJ83N++eSnD32XXl
	nYNTTQ6/EkYDKCSOui5uUoftq2t0R/E+6Dhw0g+uivYO6JIke46UaUapDyJMV
X-Gm-Gg: ASbGnctrzqpU/88Rs5PVXSJ8FLMab2Tc4HfhmCBNcV8egLQlPSlhWiK2c0FZoq1i5ZM
	CQqRXHkuQtGYB6B76NVxgVYNqYafrQrBnK0U9ooQuTlXYC2PPQJ7t1FgiI+ciTmeiaC7DaWqi6b
	qBbjirMNnRRtcy05LHnSmJpWSAQSpChqgDTrsYhGjkEfAnDN9FcKUOittDGpLx8UN6palwR6fuz
	pXISmqKhVrw2XwjVEIHeRskeDVL1/Yuu0IRYBGh87yUlPUsuUX0HydIz9msGw5uuzS1MKVxIzGe
	LXjWU8rlVkkrMxHuImW5ZWvY2V2/9GOkcrICqjQmovMj1+T3fqXIRuCax9zYeFeIu6z6GboxG/Q
	=
X-Received: by 2002:a05:620a:2901:b0:7c5:49b7:237c with SMTP id af79cd13be357-7c7af14b0ccmr1859507485a.27.1744616596721;
        Mon, 14 Apr 2025 00:43:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPTDvjXIU4+/YUQdJ7lFbDzmq8UiSQ+ZiaVzIf5dqB0Tzb8PIW8irySrnFsWhJsN4u3ncKaw==
X-Received: by 2002:a05:620a:2901:b0:7c5:49b7:237c with SMTP id af79cd13be357-7c7af14b0ccmr1859504585a.27.1744616596134;
        Mon, 14 Apr 2025 00:43:16 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30f465d514csm15946351fa.78.2025.04.14.00.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 00:43:15 -0700 (PDT)
Date: Mon, 14 Apr 2025 10:43:13 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 5/9] phy: qcom-qmp-ufs: Remove qmp_ufs_com_init()
Message-ID: <sajcoh34gyfcvhik3yairil65guvp2rt2xdmbmlpmlcjvst5ci@qojbxhmrnrxj>
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-6-quic_nitirawa@quicinc.com>
 <zvc3gf7mek7u46wlcrjak3j2hihj4vfgdwpdzjhvnxxowuyvsr@hlra5bmz5ign>
 <4557abf9-bcd2-4a06-8161-43ad5047b277@quicinc.com>
 <CAO9ioeXyDWOhe1cbGO_tR=ppZd1aC0GSdeMzQjir4XmDRMQ3Jg@mail.gmail.com>
 <64216a90-e2e0-435c-87bc-388c72a702c0@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64216a90-e2e0-435c-87bc-388c72a702c0@quicinc.com>
X-Authority-Analysis: v=2.4 cv=ZIrXmW7b c=1 sm=1 tr=0 ts=67fcbc96 cx=c_pps a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=JfrnYn6hAAAA:8 a=COk6AnOGAAAA:8 a=IG52YttmCyEg0bf6y1UA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=1CNFftbPRP8L7MoqJWF3:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 9NOhE7bDYqIT8g4lHvNzB5WVNxi7SjPV
X-Proofpoint-ORIG-GUID: 9NOhE7bDYqIT8g4lHvNzB5WVNxi7SjPV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504140054

On Mon, Apr 14, 2025 at 12:58:48PM +0530, Nitin Rawat wrote:
> 
> 
> On 4/11/2025 4:26 PM, Dmitry Baryshkov wrote:
> > On Fri, 11 Apr 2025 at 13:42, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
> > > 
> > > 
> > > 
> > > On 4/11/2025 1:39 AM, Dmitry Baryshkov wrote:
> > > > On Thu, Apr 10, 2025 at 02:30:58PM +0530, Nitin Rawat wrote:
> > > > > Simplify the qcom ufs phy driver by inlining qmp_ufs_com_init() into
> > > > > qmp_ufs_power_on(). This change removes unnecessary function calls and
> > > > > ensures that the initialization logic is directly within the power-on
> > > > > routine, maintaining the same functionality.
> > > > 
> > > > Which problem is this patch trying to solve?
> > > 
> > > Hi Dmitry,
> > > 
> > > As part of the patch, I simplified the code by moving qmp_ufs_com_init
> > > inline to qmp_ufs_power_on, since qmp_ufs_power_on was merely calling
> > > qmp_ufs_com_init. This change eliminates unnecessary function call.
> > 
> > You again are describing what you did. Please start by stating the
> > problem or the issue.
> > 
> > > 
> Hi Dmitry,
> 
> Sure, will update the commit with "problem" first in the next patchset when
> I post.

Before posting the next iteration, maybe you can respond inline? It well
might be that there is no problem to solve.

> 
> Thanks,
> Nitin
> 
> > > Regards,
> > > Nitin
> > > 
> > > 
> > > 
> > > > 
> > > > > 
> > > > > Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > > > ---
> > > > >    drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 44 ++++++++++---------------
> > > > >    1 file changed, 18 insertions(+), 26 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > > > index 12dad28cc1bd..2cc819089d71 100644
> > > > > --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > > > +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > > > @@ -1757,31 +1757,6 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
> > > > >       qmp_ufs_init_all(qmp, &cfg->tbls_hs_b);
> > > > >    }
> > > > > 
> > > > > -static int qmp_ufs_com_init(struct qmp_ufs *qmp)
> > > > > -{
> > > > > -    const struct qmp_phy_cfg *cfg = qmp->cfg;
> > > > > -    void __iomem *pcs = qmp->pcs;
> > > > > -    int ret;
> > > > > -
> > > > > -    ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> > > > > -    if (ret) {
> > > > > -            dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> > > > > -            return ret;
> > > > > -    }
> > > > > -
> > > > > -    ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> > > > > -    if (ret)
> > > > > -            goto err_disable_regulators;
> > > > > -
> > > > > -    qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> > > > > -
> > > > > -    return 0;
> > > > > -
> > > > > -err_disable_regulators:
> > > > > -    regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> > > > > -
> > > > > -    return ret;
> > > > > -}
> > > > > 
> > > > >    static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> > > > >    {
> > > > > @@ -1799,10 +1774,27 @@ static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> > > > >    static int qmp_ufs_power_on(struct phy *phy)
> > > > >    {
> > > > >       struct qmp_ufs *qmp = phy_get_drvdata(phy);
> > > > > +    const struct qmp_phy_cfg *cfg = qmp->cfg;
> > > > > +    void __iomem *pcs = qmp->pcs;
> > > > >       int ret;
> > > > > +
> > > > >       dev_vdbg(qmp->dev, "Initializing QMP phy\n");
> > > > > 
> > > > > -    ret = qmp_ufs_com_init(qmp);
> > > > > +    ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> > > > > +    if (ret) {
> > > > > +            dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> > > > > +            return ret;
> > > > > +    }
> > > > > +
> > > > > +    ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> > > > > +    if (ret)
> > > > > +            goto err_disable_regulators;
> > > > > +
> > > > > +    qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> > > > > +    return 0;
> > > > > +
> > > > > +err_disable_regulators:
> > > > > +    regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> > > > >       return ret;
> > > > >    }
> > > > > 
> > > > > --
> > > > > 2.48.1
> > > > > 
> > > > 
> > > 
> > 
> > 
> 
> 
> -- 
> linux-phy mailing list
> linux-phy@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/linux-phy

-- 
With best wishes
Dmitry
