Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948F228FFCD
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744315208; cv=none; b=iDZW1Qy20JQdz9WHiGj1PPtYSoAVnjDZSc0T6y1RVFulcz1+LIc0bvJflTlV4lqiRw05AGQHbzTuhdctDZW40BWE8fC8/fAw9pCXKul5W/A8LkA5fdM1BGZLI4eIKkMAmXOdfrAj8o5OPatu3QraSX8HWLLfdxfbgvvjsk3GL/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744315208; c=relaxed/simple;
	bh=4rkEoKO7cOpPwalBZQ0NDwQXAXKjo95y7RRThGYk3HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTJ/32vwsVgaBHOhlIE8CsCvnqkxWlHQGggGd7lMC1cm7wbg6WQX9LdboBqjPUXtLFe9pyP9VT4ECr4F1i1qaS08rNLzladv16PIjCXoKuvd0le7Q9CjnZSSxlHCS9YD6xE8bJa+JIqXLdBpTHyboB9J1eQ2vD5QlzYLhLAZyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A59ek5qx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A59ek5qx"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AG3pW7019687
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9wNOMTHHhh84q2ykF2gFHwWOs27+2UZ+5K0uavlTb4U=; b=A59ek5qxIIWSti7h
	nWpKemMgWinIJ7C0yo08N3L7BjrHadcpKO7HlTORiHD7e4RU17C2TkohpaO3L4O2
	R9QQEk81o0l/DNTFE0exm2YOtwE/AeZHjKlzS7I8doYJMEpJGsGU8s0fDSAzMt3i
	7KORbelMo51s887ncKQwLslvJE6Q2YTZUtoF+e6MBgNib6pWUMvvArdMRbPB3YRJ
	3MZPZPPOio/+JTGGYNjJWj99ztiVgO/rJGEc9dRI3E+hF9jhIQSDEvscUCMT72ev
	1MWlc8gxap997qb7onH7knhyo3mWmiWUqGMMN1eowCmAw9U2WdMdMtfkGkXzI4LQ
	5xF5rA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twcrrbhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:00:04 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c0a3ff7e81so237184285a.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 13:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744315204; x=1744920004;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wNOMTHHhh84q2ykF2gFHwWOs27+2UZ+5K0uavlTb4U=;
        b=q5dRuIO1h3Nku1cpvSdNC6QfLYnAF8mtNT5oU022UVvhWF2Cd+O4K4QPHDQM7yk0Zx
         1BwHQTO27RydmexrrwXApaRDf2wxFPwkSUqy03WN2JRtV6XABJEg0l0oLQpmIPMeH8Ty
         VwQESbZwVX9vFDlJbBGizDEOIt2WbVsruPr5uoZqoMdHRoCKGpIo3uN9gvI8+mx50mqR
         7Y3UHDwi9jRP2H3uV/2kH/ZAyXrL0wQU408Jeskyf2cvhgAJxV+d5KP/4rJg8m4XID8g
         khIxnofHm/3z24Tpyijb/4Zf8e5mj3J5Y+x8Uezel+7aWg4XTRDynWsDvd5jTNVVcHlB
         5iCA==
X-Forwarded-Encrypted: i=1; AJvYcCUlyJDu+8PyR/GpEm7vjxNoQ/duZW1DBd7K18iZTULyg7KoGriTtusGjWmEAgpwKwAA/JtkrNjwIe44@vger.kernel.org
X-Gm-Message-State: AOJu0YzyXRZh4bWAXimVZEQpmuPshGYj0sxoQK6ErS1oQZZdTx3VuPF4
	ar3pdy5bzvzg0DMVuMqn6pGiBSghqjbDwPFKvwXr0HyVdbVMIr9Hq/iQzA/4aq++aSYMAqGyYEV
	/E0Looy4wLiQ7qg6C9E+l2KFKiWVI1cTkfvFKIzf5zsbzgYZaWN63a6OqxvxW
X-Gm-Gg: ASbGncvTQt8Cpj2ZV+BhdLtLJr0Z9qmEB+bYJ7l39bCN0bbdAY3FFV/V0zG/m1qCizT
	CQicmzokGzw/FJcupBnL4H4XLFrYrL1tMSlYOGBbY+x9M5X09vRUceyqhDM3ZTyaCnTAb6Lb9Rk
	LNcgZapSbPJeyy2HT6QF/nGU2iXgFyLcpnHqWmUIenibYOoTcB80yB6Hg7vSGMKtpJ82LI4UpJB
	TnFViO0dpsUw0N32Eptki6E5lWS8MtdFIQqiQTPQ6FSwX1QB/Hljv3tf/H4MqVZ/7x5M0SEJrrc
	OgG+25QugR+kxoPbKwA5hItPhZA6k8PHzyPFnfyY1T+k+IHtvJg8SvjtUIYcKuTh995QaphDwLg
	=
X-Received: by 2002:a05:620a:1a18:b0:7c5:43b4:fa97 with SMTP id af79cd13be357-7c7af1db11cmr41770385a.53.1744315203706;
        Thu, 10 Apr 2025 13:00:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK3o7FedoTJpZFRy9lS2yc7XNbDtrGzgkkOWmS1wXzrIetzjvuwh9/WyYeycYPnX4h4dKBnQ==
X-Received: by 2002:a05:620a:1a18:b0:7c5:43b4:fa97 with SMTP id af79cd13be357-7c7af1db11cmr41764285a.53.1744315203328;
        Thu, 10 Apr 2025 13:00:03 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d3d50facbsm233911e87.162.2025.04.10.13.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 13:00:02 -0700 (PDT)
Date: Thu, 10 Apr 2025 23:00:00 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: neil.armstrong@linaro.org, vkoul@kernel.org, kishon@kernel.org,
        manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH V2 2/6] phy: qcom-qmp-ufs: Refactor phy_power_on and
 phy_calibrate callbacks
Message-ID: <xn2oexjb6s7pdh4lpligc47jlyuxvwvuuh6obvr5z3ggqi2qsa@xjttnszx5eq3>
References: <20250318144944.19749-1-quic_nitirawa@quicinc.com>
 <20250318144944.19749-3-quic_nitirawa@quicinc.com>
 <ab3639e0-61bb-46f0-9e54-f1bbd034b939@linaro.org>
 <c35c37c9-ff5b-43cc-afdd-fff509415ca6@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c35c37c9-ff5b-43cc-afdd-fff509415ca6@quicinc.com>
X-Proofpoint-ORIG-GUID: foPJ1ukcngWGmehgX4L8Y4sYNu_VumqC
X-Authority-Analysis: v=2.4 cv=QuVe3Uyd c=1 sm=1 tr=0 ts=67f82344 cx=c_pps a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=XR8D0OoHHMoA:10 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8 a=_dewA8zSobTcTEY47J8A:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=cvBusfyB2V15izCimMoJ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: foPJ1ukcngWGmehgX4L8Y4sYNu_VumqC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 clxscore=1011 phishscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504100145

On Thu, Apr 10, 2025 at 02:43:52PM +0530, Nitin Rawat wrote:
> 
> 
> On 3/18/2025 8:39 PM, neil.armstrong@linaro.org wrote:
> > On 18/03/2025 15:49, Nitin Rawat wrote:
> > > Commit 052553af6a31 ("ufs/phy: qcom: Refactor to use phy_init call")
> > > puts enabling regulators & clks, calibrating UFS PHY, starting serdes
> > > and polling PCS ready status into phy_power_on.
> > > 
> > > In Current code regulators enable, clks enable, calibrating UFS PHY,
> > > start_serdes and polling PCS_ready_status are part of phy_power_on.
> > > 
> > > UFS PHY registers are retained after power collapse, meaning calibrating
> > > UFS PHY, start_serdes and polling PCS_ready_status can be done only when
> > > hba is powered_on, and not needed every time when phy_power_on is called
> > > during resume. Hence keep the code which enables PHY's regulators & clks
> > > in phy_power_on and move the rest steps into phy_calibrate function.
> > > 
> > > Refactor the code to retain PHY regulators & clks in phy_power_on and
> > > move out rest of the code to new phy_calibrate function.
> > > 
> > > Co-developed-by: Can Guo <quic_cang@quicinc.com>
> > > Signed-off-by: Can Guo <quic_cang@quicinc.com>
> > > Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > ---
> > >   drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 18 ++----------------
> > >   1 file changed, 2 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/
> > > qualcomm/phy-qcom-qmp-ufs.c
> > > index bb836bc0f736..0089ee80f852 100644
> > > --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > @@ -1796,7 +1796,7 @@ static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> > >       return 0;
> > >   }
> > > 
> > > -static int qmp_ufs_init(struct phy *phy)
> > > +static int qmp_ufs_power_on(struct phy *phy)
> > >   {
> > >       struct qmp_ufs *qmp = phy_get_drvdata(phy);
> > >       const struct qmp_phy_cfg *cfg = qmp->cfg;
> > > @@ -1898,21 +1898,6 @@ static int qmp_ufs_exit(struct phy *phy)
> > >       return 0;
> > >   }
> > > 
> > > -static int qmp_ufs_power_on(struct phy *phy)
> > > -{
> > > -    int ret;
> > > -
> > > -    ret = qmp_ufs_init(phy);
> > > -    if (ret)
> > > -        return ret;
> > > -
> > > -    ret = qmp_ufs_phy_calibrate(phy);
> > > -    if (ret)
> > > -        qmp_ufs_exit(phy);
> > > -
> > > -    return ret;
> > > -}
> > > -
> > >   static int qmp_ufs_disable(struct phy *phy)
> > >   {
> > >       int ret;
> > > @@ -1942,6 +1927,7 @@ static int qmp_ufs_set_mode(struct phy *phy,
> > > enum phy_mode mode, int submode)
> > >   static const struct phy_ops qcom_qmp_ufs_phy_ops = {
> > >       .power_on    = qmp_ufs_power_on,
> > >       .power_off    = qmp_ufs_disable,
> > > +    .calibrate    = qmp_ufs_phy_calibrate,
> > 
> > Ok so this will break the UFS until patch 5 is applied,
> > breaking bisectability.
> > 
> > Make sure UFS host driver calls calibrate first, and then
> > do the refactor in the PHY driver.
> 
> Hi Neil.
> 
> Thanks for the review. I have taken care of bisecatablity
> compliance by making UFS host driver calls calibrate first
> in latest patch set.

_latest_. So if this patch gets merged first, UFS support will be
broken.

> 
> Regards,
> Nitin
> 
> 
> 
> > 
> > And either all would go in a single tree or either PHY
> > or SCSI maintainer would need to provide an immutable
> > branch for the final merge.
> > 
> > >       .set_mode    = qmp_ufs_set_mode,
> > >       .owner        = THIS_MODULE,
> > >   };
> > > -- 
> > > 2.48.1
> > > 
> > > 
> > 
> 

-- 
With best wishes
Dmitry
