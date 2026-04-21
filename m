Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD73CF67C
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776781733; cv=none; b=EpQOwmIsh1A72cHTwNlIKT6zafuOrBZ59xDD38Eq163MzrOEquXGRQ9vXJHKgdvRbmjVF3n4tNuBE+gbophztYq1w0eIpUjkWwXcBockebYdepiLfv0z3rFhlcY0FAjJjg8D0pY4I/N6tPuUDasyhKtwk7GYhX1cRDNvrlGOsmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776781733; c=relaxed/simple;
	bh=uFc6vK8cMc3GvLEZihdxx3in0TjxH4dzqtGcv8+lVBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/nCitZKsYu9qJ626f/cio/uVTYl5iqOAx24o0nYjr500utSBimNNxnbTTNtY1yMRD+Ft4RXlAX55ucT7m+I+Tis2MedPnpfclK/MkJ+63ysOoLGPPnrRDMIWxdb/0FMoPoQiJUK//2WoaJYH42U6TaqFoob7CKQGfIcxokBTvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iDyBuV1W; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A6iuF/1c; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iDyBuV1W";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A6iuF/1c"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LBp5SR1014344
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 14:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=sMygVlHzO2UzC35b/tkjIvaj
	Jh5YLbqgv8z23f0T6x8=; b=iDyBuV1WAW3UBhGYGM9Qgfo4F06MOcTNv0hGhTay
	TTJr4uUC1fHYpF92bj9ZijBFinu6GQ6prtDsv+pLQVHs5k4S7bl/U+jrLQJoTUAV
	fbarr3fPhCQ5j7T0cFC+khrGuFkOMJYGPtY4GfPlSFHLjx4KvhHRK3fAjrpp70gq
	rhS/Ema68weXwbFlUyMxUybFTqSzpNqWF6hrZBsmmlXCHXv5ukzdOK4ZolX7jz/0
	wUIVD+3/+1HOFlsANBb4KMoBcSsM4P97mlCir1PG2DXRYAXY49ZAVazhx8bBkrNq
	k8nPrgdHsv7zKwLJDB+jQMzfThbIQLHto8uEH+E4RjjN0Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnt903jb7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 14:28:51 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2bdd327d970so2810524eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 07:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776781731; x=1777386531; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sMygVlHzO2UzC35b/tkjIvajJh5YLbqgv8z23f0T6x8=;
        b=A6iuF/1cHNrQIpLem1p3bKGdtuKTwbed1Mkn+dOMt1uCg51qjs2E7sDIeSo5QecDbX
         Lx4M5w7GD7jsNyjyi4ui4FQN5uWhOSOfx2RL9zjvR6abJnPBJvZ/2U0pVdKkMTy+uWqV
         NPHEfkx9kfLlVmZUXZ0zkXJ/pAE9RyhsDKuV6ptX4R/MzVnB2KVXjhB+XgxN9S8DUQoR
         cu4PO9YZ44nkwiheu8O1pW8+SqgxoQ+XNELS1/qA4tNCQEIomqzNl6xHBnNI6tXNlFA7
         fuCXVaIXAgg/PWmWXYLRPS0mp5BZrNc7EIqkNfAmpzUF5hZnn9EyAFNwjdp/7cMTLqmN
         savA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776781731; x=1777386531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sMygVlHzO2UzC35b/tkjIvajJh5YLbqgv8z23f0T6x8=;
        b=U5XHjofZMYXwmrzuJk23O/wXHEuBg/9h2RIpjq/OjT1nr3fu64siD+9LHu6SO8wyZG
         gMa7hBeD1+J/qtjWKAOo50yi7j0qi6xlJTZ/rZlvc02z/+3wPEyF81p+PrFe9gPBMAol
         g/1M51ydrXlxXRCB7bIEhJFe7qD2et9qi69mVMP2ObIjzzDfiMqamUYhP+V/N/PQ3cb6
         CRan90ir3AQRV1TzR3My9UycWlygaXoNMNjnbQdQdXKBDLbEc4p5GXayPNjpJe/5rPY9
         MaKsbzbelTp73s2oEQyPRIzQXMbVEakLLopAt8gOUztuz5F85OcC+Ocd8u0U6YWy6L1k
         lQ2g==
X-Forwarded-Encrypted: i=1; AFNElJ/pWnunNss8zszc2VUD3g025k2bxIs+1Q0t0sKoxaD+4xVSBV+QOne7GnbP+xuzg6xQmrKF2lHvu2PZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwlHGG/hMGQ0z5DmxNLhQ29b3ZC1/dHkIhyhvIDXU41AKAaWZTu
	I033p/cTVqdT8Tf08UZcEKYJrLpnD2+A50Sg434eRlmABFeRt0A3XC66O8mFptVvmKO2nIcCWFf
	7a2qpsxm0iNnal39dH8D9eIpGJts/0t5xMbTYFHzAYG9izPIumcb/CWHAmk4xCRBo
X-Gm-Gg: AeBDies0vrbHNqRedSTXq9tAUD5l7El6jvsq5S03sbyPmA5/8cNgUjcG8/2fA1ZjYpp
	3by+VOfiPqrLeSt+ycs2laqfKVcW2RyURbOXoX+Bq+55B8JPGFsRJyKFNupx6sC8vGFKBdT6FWb
	0LQi/4RWkCCIr6eK/fzcgZ4d5sD9W4kjHYumC2QyJT21xxg+JVZPb+sT/6K3emHye20dUaMobpt
	JhABUWHCPpBzDjU2t4RYVuAKnjg1zFBhiGZGS1kNAO6W/x4XhpcbYTVjeW7M1jXjQSC09M9F2eu
	uUGhk8/MONS+l7AzWyRlbj8uy7XJ0K0Dx0SZFQJIieFDkakTxw7PQ1X72Yq8PKnN1eZc3Zv/SDu
	hS407zjemQdWA7Q9yi2AvdyPsDXVMTrTTJBt62HXG68VeA2OF+2qYWq++IRovVuyi4CR8/UvlNy
	Q=
X-Received: by 2002:a05:7300:214e:b0:2d8:4705:aa19 with SMTP id 5a478bee46e88-2e42c848ef3mr6597315eec.5.1776781730431;
        Tue, 21 Apr 2026 07:28:50 -0700 (PDT)
X-Received: by 2002:a05:7300:214e:b0:2d8:4705:aa19 with SMTP id 5a478bee46e88-2e42c848ef3mr6597295eec.5.1776781729570;
        Tue, 21 Apr 2026 07:28:49 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d9b056fsm25298900eec.29.2026.04.21.07.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 07:28:49 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:28:42 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: dt-bindings: Add compatible for SA8797P
 UFS Host Controller
Message-ID: <aeeJmk3mGn7-SSYS@QCOM-aGQu4IUr3Y>
References: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
 <20260420100416.1252983-3-shengchao.guo@oss.qualcomm.com>
 <20260421-tiger-of-pastoral-potency-d4502e@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-tiger-of-pastoral-potency-d4502e@quoll>
X-Authority-Analysis: v=2.4 cv=KfbidwYD c=1 sm=1 tr=0 ts=69e789a3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=I3NryFtDZQfIPkP-tIcA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: MHCbBcoQXPRdHsHeLNZ2OznzifVqyWbV
X-Proofpoint-GUID: MHCbBcoQXPRdHsHeLNZ2OznzifVqyWbV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE0NCBTYWx0ZWRfX+2RMaNlDbdEf
 H7nhIQFy0vrMntGff6RKRRMhlom6UARz1omyVEC+Hj8tx6LGcMC405PVtR21j/sC0EjHFSm5mXX
 aa9hsPiQpCgaCgfmAew5QP6HDrol0X8ISBmhpIvD6kArju/7SBFA4kFmp7LxDRy1VFizELFTErU
 kvfndEoH1eQGFgYTGWxOpQaoI+jfeOtxhFvvDobJXkqj2ElvWfRutHfUXak9RxozamlgTvMTYuh
 zk7M9MOz8scEZ2QfrmJ3jT3exMtesWLIGrAJJZVfo+k5QpKXVIpuhZ2dot8DNT2gqq1/dyFh23/
 kC3NaK/BqGtOX5Gwo4gIa/WKLuwWHX/+R7HqyY23uq3yihS17eqGi/OjlxpX14I7HjjtPf7xq1+
 gAFqnzM99zmJcEmUcHvTsB5J/OnXdcOUC8H+39KstTZCyPok00kE2NeOs9pntD+DiijIEgo6h5p
 zwyuVz2Jyr2OK4Vnv/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210144

On Tue, Apr 21, 2026 at 12:37:31PM +0200, Krzysztof Kozlowski wrote:
> On Mon, Apr 20, 2026 at 06:04:16PM +0800, Shawn Guo wrote:
> > From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> > 
> > SA8797P is the automotive variant of the Nord SoC.  Like SA8255P, its
> > platform firmware implements an SCMI server that manages UFS resources
> > such as the PHY, clocks, regulators and resets via the SCMI power
> > protocol. As a result, the OS-visible DT only describes the controller's
> > MMIO, interrupt, IOMMU and power-domain interfaces, making SA8255P the
> > appropriate fallback compatible.
> > 
> > Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> > Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> > ---
> >  .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml        | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> > index 75fae9f1eba7..f2f3bfc73216 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> > @@ -11,8 +11,11 @@ maintainers:
> >  
> >  properties:
> >    compatible:
> > -    const: qcom,sa8255p-ufshc
> > -
> 
> Do not remove the blank line separating from the next property.

You are right!  I dropped the newline accidentally.

Shawn
