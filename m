Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DC34E323D
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976834; cv=none; b=tbSrVvuPemZqflIEvUaSbuT62RRg93edjC0ZAFbNz8ApxlDVJU1VlfJFF5l509CndMWfeRfaYEv03kE3mvBJD4U6rpQjIlVo+HTCsk6Rf1Ziw2Bo6VclXDYtjYaoQP8uVaX2XXrq58n16b4DuAWbn7ghHUQAjK7U/NhatDuar+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976834; c=relaxed/simple;
	bh=rzS9vmx15fJ4T2makE3vbQnf8L/sVJo1y8k+j/gnwY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Op4SlZKJonZoJRIwWc4HrtEd+2zz4tyjPakLp1HltVgkwDtU3PDxGSgvEFdKe6I8PM2q8QjuCx1RSwEhuvdW3p4hYuWM6HKrVI6dc1lNUF/iCIAOFt6mTZcwFfoNa6yNcbcidtOG0Fl7ba/Qk9M5B+/oeXnMCFl0hC9lbxbfjH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aJJN1dOa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Dx5qsGny; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aJJN1dOa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Dx5qsGny"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E7kair3017705
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MASKzKLwGnsoqQoHSDALtQYa
	IWeFXubP9J79KlMYkjI=; b=aJJN1dOa+/bJS5zSy3vQCjVG9l6+1xy9ZGVtH6d4
	U9mX9Wnjn2TXlJ8oG0I3odzWVx7pFUItNyiXnwKw/WFyufmKlzY+LfLnxyZlGRq1
	Fqloo5JyiqSopTCGjpfrAbfvGcpZljOcjWa90qdpu8xK/26Qn7mdn1aRS9pj5JV0
	uXwbifh69QOSulms5FJkqtBKLaOrXqyfQ8LmQpPMotSQy1qMjsoVLeJRWwp7W1ew
	Tb/HJAu6aILiCIA9zeeseIUPG8tIhtQ1LMzxMUYLnmmUuh01H3lnxelJw2ZrBqho
	qrIC2MTVoOYWZyJXc/8FP4fwNu7DaAUEWsrjRkg30acYVA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9s2b41eq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 11:20:32 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e93f67358eso5405465ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 04:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791976832; x=1792581632; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MASKzKLwGnsoqQoHSDALtQYaIWeFXubP9J79KlMYkjI=;
        b=Dx5qsGny4zdi+D8LxuDbmSePJOatvWDNVAcZ7jTsuLwALbmTJ+7E+2f3h3nVk5fIPH
         e1raT0byG9NxTfDr201QyG7pvd7LCeg1ugI/HaMy+tQhR47O3/JdfCuJxyGDV+0WvSg+
         JTF7/1q5pUuD8xtJfH+SCvWnxAPq107EaK0J/wCsJY4BhdCVI2lEnpj1Oci476S/ivU8
         qnK9axaQyRky1wzziGI0wr81NDK7ntoQJL/PHEs9TiaXSwI5d5Uh9NrU6EbYOI/CrVsr
         FrdXdMFa9ro6nsZ8VnFfcRh42P9v8kg5QqDbGVMp0wKzdUVSmJeVcOh/1IsM9cswvk2M
         vdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976832; x=1792581632;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MASKzKLwGnsoqQoHSDALtQYaIWeFXubP9J79KlMYkjI=;
        b=dYESOcoDCCL69WyahcUQ6KRZfrZg1/M6uMUrBXi5k/7BTQYoZWUkwSvTCbzGQI0EaS
         MpJvPAMasT7OjFr0x11wzywl2EbRpXAZP9/8+Had9zW9phYt56+0I8bzoTP7naZgW3o5
         2E2imS0q9I6rhfg+CWW72gpbScnD1GS9zLHdtyoYX68ihwtSy7wqyYmravrGuV+H/9sL
         9/1XBJ9+5FGfSWRKAVC364RAynoRNYqmNo28iaj98M59zm0g6uMy8p4xKRNVzN5v//xT
         4wk8RWKW2mh+R4MKD159md0rS5eWGwElJdSBFNvFFwuqt6tZK5wbPZKcGG7CNW0MhAgo
         ZXYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2O8Y2ml7Tgcf4Fraa4FmQFT9+PPcxF6mCqALauuSG7/T77avB/aWWniZz4CfTb5qdpyipKOxL/ary@vger.kernel.org
X-Gm-Message-State: AFq9FYKEsTcR013b/4qUpMcDrlHyOjyIfSLUuSEemrcqhkSufIW4S3g7
	I6NZvEiiWp54u1QqsjrYwJg14nQ2TJDXYwdqOvulzlGkP+VSQINCNcLPQYfnDM+uLxWb0/sqZKr
	rbn5DlgRHLAbkYqCBy3qBYZ+OdNHECAMQHOQoTDGujAXiA8Myr0OY3HnTupTeG3Fl
X-Gm-Gg: AYBFou2m9GX/MGwDxmf/Jd/HDH6GyXsHPcnQB2dCkfKe4Czl7KSjjr4Zv+jzjbNfRxk
	Nx3ddCS59V8syVOXKO1FtSzXewKsUtE/Z/wvZzLIvPdxD9GKT5RSxgeS0z1WPeFFm6nHi92RkNy
	npZSq+dXn5cswuNRqLddTNP468fJQmEktUYQxoUga/qtXBTnCob71LAn2nUWenmuAt1qAcSpoMu
	CC/v2pv7wBTYBpAqUJqeJ6qZsiK8EvK3FzbSgN9FNTD8eGgqJ/zEfypP7QPUs829/ZpDWELzYWG
	B+ctoFk1eOX2ic7wIsxNGhsobQdCGmO4r4Q7EgM+Ql+iZPX7HXq7ncMc/z4vE5iwgbZ/Wu/0cQL
	Lnm5CYwkowrmxhoVd1CF3Ml2UM+Rb48XcoI/b
X-Received: by 2002:a17:903:37c3:b0:2e4:9fbe:f72 with SMTP id d9443c01a7336-2e842cf91bfmr132144375ad.44.1791976832267;
        Wed, 14 Oct 2026 04:20:32 -0700 (PDT)
X-Received: by 2002:a17:903:37c3:b0:2e4:9fbe:f72 with SMTP id d9443c01a7336-2e842cf91bfmr132143945ad.44.1791976831754;
        Wed, 14 Oct 2026 04:20:31 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8202sm65198165ad.51.2026.10.14.04.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:20:30 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:50:22 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v12 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <as9ldk6a/44u4IB3@hu-arakshit-hyd.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
 <d8304387-ecff-42d5-8cc6-d3b4526fb294@oss.qualcomm.com>
 <apCoDfzaQBGgJu4K@hu-arakshit-hyd.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apCoDfzaQBGgJu4K@hu-arakshit-hyd.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6acf6580 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2_FpPSLQlo5LL2co86MA:9 a=CjuIK1q_8ugA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: VYNOSQJFeNxKD9Z-wp5IhWs9SlzjtlIL
X-Proofpoint-ORIG-GUID: VYNOSQJFeNxKD9Z-wp5IhWs9SlzjtlIL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0NSBTYWx0ZWRfX0IlP3OC9r6h1
 91WIjEBbAlor7MwDBX+rGqNyWJKIlE15AJMufDpDhH1DRqpNHbcJKkdvACsfesLXA1eREVgSVCx
 g+ftMotKiJQnfH4wqmJrgPs1xRQdsi1h3Oxw4tWUvlN2b02G3UYBWFPnsFoWSBndjoIHcCpHeEf
 ZIvCyAUnMMm12dEF6uV/pqvpNPngvvGuJ9J5gyakM00VHgyYQZziUBRM261EjTfFO8XHleGv7At
 fNkAjAxkzmsBQqUZMlk1qLlFtSuSgQx2uuw/81VhOOGySBd0AjFWHkRwH8Ol2l/PLSAKFYdJlHB
 s7nCPGhX1tkLZMuLa1OY6pASYxFKUv2gKL3vVi4ZjWlL/rn7Dl5+t9kME5l2RiiWKQNGNivFk5r
 90HTi3pwFJgUc0gg4dB1rcG2WknWGZBAGISBtyeWnCATnRsKK8LHfA9FvLgPSevJhcJdqEkI3dM
 HR8et2200SEiDqrsEfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0NSBTYWx0ZWRfX4QHRJn0AaHml
 QWhMLUABSYrAdvhv7RP1+qg6jvm/6eyLlkNNfQ2+R5HlOq/LLmFezVZv/rj3HP0lZCvtl8Szs8U
 k+Uyy4vraPOXgdcIU6X10BlkNquSPkI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140045

On Fri, Aug 28, 2026 at 02:41:50AM +0530, Abhinaba Rakshit wrote:
> On Thu, Aug 27, 2026 at 12:17:02PM +0530, Kuldeep Singh wrote:
> > On 24-08-2026 01:17, Abhinaba Rakshit wrote:
> > > Register optional operation-points-v2 table for ICE device
> > > during device probe. Attach the OPP-table with only the ICE
> > > core clock. Since, dtbinding is on a transition phase to include
> > > iface clock and clock-names, attaching the opp-table to core clock
> > > remains optional such that it does not cause probe failures.
> > 
> > iface clock and corresponding dtbindings are merged for v7.3 and your
> > change will land post that.
> > We can drop this from commit message?
> > 
> > I think we should scale only core clock and for iface clock should rely
> > on ufs/eMMC controller maitained frequency.
> > 
> 
> The idea here is to scale only the core clock and I am achieving it by using
> dev_pm_opp_set_clkname() API. However, for that clock-names needs to be as
> required property under DT bindings for qcom ICE.
> 
> As the comment mentioned here: https://lore.kernel.org/all/b32c7091-b2c4-443d-b58e-759b471f67db@oss.qualcomm.com/,
> the current dtbindings supports backward compatibility with iface being optional,
> hence it is expected that driver should be backward compatible as well.
> Once, we plan to break this backward compatibility and make iface clock and
> clock-names property as required, we can say its out of transitional phase.

Kuldeep, I hope this answers your query.
Can you please let me know, if anything pending in this patch?

Abhinaba Rakshit
