Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215DB37EFFB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 06:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751812; cv=none; b=I5SGZ6egpy1q4KYRzzwGMgpSOr/knYXiZRWe0jpwAdiqe304AaqjeFS/BrZcBs94Pqkt0AzhwbpLGsZb8L+BmWoVTnvB7rqa7OCdGPj+5KOm2b46zuGGb9mCRmT+d829y4QTomXHdBJ/7/NG5tYqcB31iA61kEf+d8T5chZcx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751812; c=relaxed/simple;
	bh=DU09t4e01tb2Dg5oxA0hYoS2Sw4H3Q/MxB4hZIBL86c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiFE3hTsA29f+I3eNXFbEXQzx6EPQX5/t001vWr+WF7wj4FzXiOWYJ/cPj+QKJLdPPpTFidMKBQJem3pNdsFGWiEY5/pGMBfIhhb9guX7UQ4pOZt8ThCRFz6Ayiv8Cew5afWU3DN0wRNVxszz1TWiIN4aFZyIvFTAUFnvPVMrFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ss0fIIkU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FbQU6f8P; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ss0fIIkU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FbQU6f8P"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63L3Pf8q4168293
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 06:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=1guwVUsMIMD/Wpv/IcScqQdd
	RIpEXoJdanKvBpB1ZJ0=; b=Ss0fIIkU1dxb5Xy/z/S+TipJ0qapF+MW2z9RlxuI
	seJUYFSYlo7RfNQIndELCdlXAo1Yd9KlKN58BlvPXYli0tHPDRUnU0j6tz1JMRDB
	qZvE1oDA9TTDSum0vF6ztWcUdvSSFEHahRBX0eVMV38DUk41RhLEVOYJz6iqxU+y
	WBHh7ytR25fEZZYhI4bpvYJxJr6ueOhVxwqE9qK5841XW/tBqVwUQQR+ob2A1gsR
	ew66n2e2nNYC5JWPni11CRrl4u99iZClicgK7oKxD3UM6PD4+wQSR3bKVwYMZrHd
	WFQOVVY/rcvr63ZaGTSQ7mtU3V72eVjC0OI1p9lmpNbBIw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dp1au0hey-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 06:10:10 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c797efdaa9cso1539238a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 23:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776751810; x=1777356610; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1guwVUsMIMD/Wpv/IcScqQddRIpEXoJdanKvBpB1ZJ0=;
        b=FbQU6f8PZ8kFklrctX65ahrHIsvl9OvXziHclG+3ZOAe8LZhEUA99ih0fk/CzJ75Vj
         n9QHQ977Igr1ywGo3Ui2OcL3h37IAYiWu0mFMM5L4YdmERGnpKbFZrZBH/7J+ayd8DPt
         n8w6byR896bujnERBnctK8hT+RHufNs3o3LjdV6/lSFyWrUmPD8fIz/kZZeiCHdnUCvV
         +nwom1XvpkResTWolzobFZ78CKyQg8AYzoWRyqSf6uE3BvJC4yHkdFt0ElIsueVEQKjP
         DyMSiQWcPLvPkrI/+uentf1klBgepkqvpDN7cY7LdLMUzD7DCrch9S9BZWdnwuaTRhWA
         DSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776751810; x=1777356610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1guwVUsMIMD/Wpv/IcScqQddRIpEXoJdanKvBpB1ZJ0=;
        b=Shz00iqn89NiW9L81L0GTv+W4d5tw3nrd8bEGd9IGvcSu6oxGZJKC4XMyqfryWa3Bw
         Y03b/jJ7/G0mQnKBNYIzW88ZvmXL3PhhM5As8FpK0PAO7p1HLeXnAuKSDscHDIwrY7Gd
         KFLLukpSH7hfhWe3D528bgp51CuFyMfDO+iDL20CBYgYG5TFoSDmGOOjCw27yAajAC/P
         AFAWII3hlMyDMDTsFWf76IGFUmPyOOa26wJ6Cw3AqrNrZnLFHG4BCl924H3NnF4cPI/6
         dUzuA3m9PJnYHGWLzlnc3nGHVYtrQJGihVDOOVN0FpD+AhrY/3fd6zu/HNe2SYlTULzL
         3sAw==
X-Forwarded-Encrypted: i=1; AFNElJ/l5OWWlQgrEklOcVwnKh3hqqnAyzg5PzYwG2gUZp1ikbJQe8hA7l9FVh4tA1bqAdjvVVbA4YbTa8Y6@vger.kernel.org
X-Gm-Message-State: AOJu0YzUZqGfzaLUQ2GK5WpZKNnnVJll/ZL/0bpxSFOyeRYCuQqvoFxw
	1Z/7D3DFKnXuQtB+q7pSaFuLMZ6MHPpy0ZKzdqdRrDPfg0UaWBUAznyCgiWjRV/f5vkPSAb4gD9
	cIO8L5JWdJKiK+C9b/1yCQxdjEOq+FWWv419K0m0reSnUNb+EX44bY9Ms/g5qG46v
X-Gm-Gg: AeBDiescKmFtpJ60GmDeD9NtOTZHbBs3GjkpqbRgPOCzFTSAlP2o95y93Dgzi+7wa47
	UByap9gZA4sXpIQpNNcFmwDNEyK9wupEQ3YVeGd1S6hHHDg4kagDdSBuIdPta9HfrKJvn5/3Fzi
	26PUT+iJVD9nIaSPjjRXBj6Toc4rzGgwGYwp/+iqyfa7sza5nrfUzJ/yOZE2SikpBCM5yXnZXkU
	YFe0hxPn/uG8rVIsz3yeAhAJHu6BbsFvD2ZEUE3FzJhQa2PGKpMTm7pireluCAyg076bOQJwmfD
	ERcqUTxvMZEMN9n9L2o59pisBflXKIAOVHMg5+gycMth3Nu8CapS/nzRQacnnrSRK2Xlc14ekCs
	BMweUUUuoX0NsMwNzlw/zWjrggZ5By2WLuaTfYMfUweZHz5rg+g/aJtuG/Vw7rJdOFQX3Iw==
X-Received: by 2002:a05:6a00:1c9e:b0:82f:6b6f:13ec with SMTP id d2e1a72fcca58-82f8c9427b4mr15422853b3a.34.1776751809491;
        Mon, 20 Apr 2026 23:10:09 -0700 (PDT)
X-Received: by 2002:a05:6a00:1c9e:b0:82f:6b6f:13ec with SMTP id d2e1a72fcca58-82f8c9427b4mr15422812b3a.34.1776751808982;
        Mon, 20 Apr 2026 23:10:08 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebe68ebsm13905438b3a.47.2026.04.20.23.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:10:08 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:40:00 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v8 3/5] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE
 init
Message-ID: <aecUuK5nF/hjV8tX@hu-arakshit-hyd.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-3-ca1129798606@oss.qualcomm.com>
 <a432b2c2-475e-4833-9225-801990cb2d34@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a432b2c2-475e-4833-9225-801990cb2d34@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA1NyBTYWx0ZWRfXyeZLW2jvEOvw
 zB9kqk8skubwzdZUU9cLlgpOBbnTfcMlYPM8BUOZcWbt7+Nl1dLqUY1Roscf1WKKGhebUqcHqzI
 IhyPbbdjHAcboxLJS3W3UVupR+jgr6/EvStQbAHcXdb02GHHQn+el51NiyfRmvpMLBFxKE2fMb2
 n0CQbb5lvmuwOxm51RpZI5hDZhK76hzeqzMYl5KUH/hGQWTDANZ+5m+7fhHhqgtXYC7Pr1usu0E
 bdcXfiyQmwStXD6lEC8pLBU3105m4l0UQX1oGBt617ahOPKP1Ez16DjynR9LE2evUauI49nCpR6
 tOdlGxPW9KjHesDOKYlYnBmDESdqkME/NGZ2qTIUj1uVPUMbwTAwiLksKcNgH6iNa7WfB+j5QFV
 ENxot7HIwTyUxPZiGO4ev03ah1pYZuc4f73jlPryqp1k5JuVc+YACDoTCv/7Epzuqm/KR75HU9N
 IRMP1Q1PqHdD6wN2w9Q==
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=69e714c2 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=ciROkYvXyXDSqN8Q_VUA:9 a=CjuIK1q_8ugA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: YDMTw3lyFCZeIU4hV6e752XKcv7gfH-I
X-Proofpoint-ORIG-GUID: YDMTw3lyFCZeIU4hV6e752XKcv7gfH-I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210057

On Fri, Apr 17, 2026 at 06:59:42PM +0530, Harshal Dev wrote:
> 
> 
> On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> > MMC controller lacks a clock scaling mechanism, unlike the UFS
> > controller. By default, the MMC controller is set to TURBO mode
> > during probe, but the ICE clock remains at XO frequency,
> > leading to read/write performance degradation on eMMC.
> > 
> > To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> > to align it with the controller clock. This ensures consistent
> > performance and avoids mismatches between the controller
> > and ICE clock frequencies.
> > 
> > For platforms where ICE is represented as a separate device,
> > use the OPP framework to vote for TURBO mode, maintaining
> > proper voltage and power domain constraints.
> > 
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/mmc/host/sdhci-msm.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> 
> [...]
> 
> >  
> >  static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
> > +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
> > +				   bool round_ceil); /* forward decl */
> >  
> >  static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
> >  			      struct cqhci_host *cq_host)
> > @@ -1964,6 +1966,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
> >  	}
> >  
> >  	mmc->caps2 |= MMC_CAP2_CRYPTO;
> > +
> > +	err = sdhci_msm_ice_scale_clk(msm_host, INT_MAX, false);
> 
> The 2nd parameter is an unsigned long, do you really want to pass INT_MAX here? I would go with
> UINT_MAX. But still, why go with such a high value? Do we not have an upper bound for the clk
> frequency that we know we can't ever exceed for any target across OPP tables? If not, then maybe
> UINT_MAX is best we can do here.

Ack.
The scaling functions along with the OPP-helpers clamps the requested frequency to the
maximum supported rate based on the clock/OPP table, so any sufficiently large value serves
the purpose here.
Frequencies are better represented as unsigned long values hence, will update it with
something ULONG_MAX in the next patchset.

Abhinaba Rakshit
