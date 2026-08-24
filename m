Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C624719E7F7
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787558648; cv=none; b=rg8vlyhzHckeZ8e0aqw5SjK6dYNO9DCBdwesInGkA36G99fRdZwqAUCDSQE0Kf4GQjQopqTOtoH2tPPVcRUcxnah2SSsPff/rFVd42VDlzA2cblgMTWdeCF4yt996Q910Ge8UAi+OGOqzGCyGEB443bdz58up3YTIM/KjY8vG4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787558648; c=relaxed/simple;
	bh=tNXNFInFtmjIVTfZDXHA2QtrAnA9EoL0bq6M2Q0Z0Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7OZEglDOA/pIhycCAtdCVVsfydRnILqWQ63SOSMJP+4FJN6nk9AotvfAEEyzVqZN9Oj3LOEJLyoLW2cibPmGjOtC9vK6yMJR+YYH1+raIRXXQcModInWHzmNMCeU8HHV74c3bVJSJyn9zJgHFnEnmq55SpBI1dpJCGgvgx3gkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WjCK7rvo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UKyztt9O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WjCK7rvo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UKyztt9O"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O5RHnA3067025
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=p+iiVLgQUpLKNZ/Jy5MphUmL
	qcg5NHgyrWhQqMjhGbc=; b=WjCK7rvo750qdpeKVOSdAUtbnr3VMr3upeax8/Hk
	huHCJ4OOdBOYdmGXJ5Y0fjZqE+pYc2CoUoVjFJa2D0JUmw/cuxUiyVhAA020ZnBZ
	m6MBHx031IBfifJ+IFV84H2v4v7NlMQfsCH4K5WA0qAtRno47W+jzPiqQ18XgTWr
	K4j+vocIZ31ELB3lr5713d5iMjETDRpsCU5C36BMFzHwNsU3Oc16EHOxYdkFGoIM
	cCXFT0C1DrCISTc8jQ49JlWZGtSztKqEATYGEP5TvwLQzua8FNzM6gQ4rD++1Hjg
	PJqhrM1FxBQz1xt9kgzecdCVelIhDyRvLLKw+VuUSdcZqQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g88jphk07-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:04:06 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c19493ac2so38634791cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787558645; x=1788163445; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p+iiVLgQUpLKNZ/Jy5MphUmLqcg5NHgyrWhQqMjhGbc=;
        b=UKyztt9O7WSC9fe6MRG8+41ddyoAhHH12TNgnAVCumC8IGAS07ZRpKfaTTjtJa2aHK
         xszSuho4VGELQDeYGGYGMyK1afpQYIfQjRmOwRSsZ+ePgdFRG0Q8bczRjosvRlLkps0E
         mlStUoozA/jKniJ3klJ1m9asEiduAzSgGSw2HA8k/uxUEgVCBtzwi0pbhMWH8AkLcyqV
         Cn7PkXLbzjCup6AknWRh7WYSRZd7jkTdCYsXIC6/pjenY/Q9GINlG6vV2YYw1egkA7RQ
         oZXnLggVBFj/L8d6dvpL3UK3/BCQU0PFwxzH8KCJPq+HubaL0GAYY0hk3xrqUS3CUm+Y
         zffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787558645; x=1788163445;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p+iiVLgQUpLKNZ/Jy5MphUmLqcg5NHgyrWhQqMjhGbc=;
        b=oM1mRGzrhI2COHJLAD9FTxzHVMqprXpEXlFvgpfdzInkVU8xXqo7cdAHuq/TK2nxVq
         /u9P9WbCyHbF1T/nxsXicpFifg8vZQLuT0CHnquDSvUqDI90CCmJYZccUSAlQtpwCSAC
         r+VYykyxeOzOGCn/U+Rz6+JW7gOoIypSYMY2odl2VW4zexEqkzvC2MnteMzQoyuYU2R4
         SeqDarGIPlHsj+2r5FRVe41HZgAl7fVhzwgoNyK3yNkbAYDJhaQM8nMv1LAlelQJmA8w
         9aSJE1gafu6x2iNKPPRjsw+/W3kNhfc/is9QLxsGNVloCJnEhaA1ahYkWgP+CDO9ZqhU
         w8lw==
X-Forwarded-Encrypted: i=1; AHgh+Rqr0SEus6RtBrYWclIBQk8mbcyIxvaQVv9eHZKco86pRWWBFI8b6yEQ13Rk+Hutrzvspi4qATlGxGRO@vger.kernel.org
X-Gm-Message-State: AFuF++nnIJWYC0Q1viT7TrPrO9sLoGhllrqttiwvYOFrIZTII8p4U1yP
	BcpM/t0mxwTvLqdNJa68mgyCbnMu332qePyacg0FTmW+3KxdY/5ZpZLU06fiSHZe62zm7ETigOq
	hk+FsGtKQbHSPtlqjTYbDURmKq9mXhkKvDcLQOSZ8alKtIGRdBYzVS9tjGoZPVZI6
X-Gm-Gg: AR+sD13rcE0VjgAf3blfnw0IXzrdZoTXEoroo+Qhl9BaG/PDXOBdNG+dXco89bktkBo
	SAA+OVyYN0rQu3I21qWZ4QY4X5fAxkNrknN6Os2mxjuVds4XQSH9Ymea+iOtktqIMn0vi5SLob0
	qvo0Z+XZMrkDiPNj4rqlY+/XikQ7hK1A/bCCqVVkbI4PxW3Mw+1zKVYqEEnE29sSpjfBVydDvXZ
	C38DZexia/hud5GzWYy2EVoJ0NsLxccO/Dymk8RMOQHYTcTha31HglUQuIW+1L8nGcEJw8tUwAt
	CMrzBArjE9dYKB5LSITJCADb5fc1Rj9XmzOz3HoR9NsjK27ttM3/iaccqYCri/mwZf4OUhySMgL
	fmBvPoQf1XnmWAHg=
X-Received: by 2002:ac8:5848:0:b0:52d:9222:f476 with SMTP id d75a77b69052e-52df5bcf443mr226201861cf.37.1787558644895;
        Mon, 24 Aug 2026 01:04:04 -0700 (PDT)
X-Received: by 2002:ac8:5848:0:b0:52d:9222:f476 with SMTP id d75a77b69052e-52df5bcf443mr226201401cf.37.1787558644376;
        Mon, 24 Aug 2026 01:04:04 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b60asm1046585766b.9.2026.08.24.01.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:04:03 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:04:01 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v12 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <shqrnwcclocbs4yrbhra5k3tixn3zbmri5pa34cib4t2zsaxix@a3i4nquiafua>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfX3yn1nlRgVjU9
 QnsRlxwnD5ZM/NrP0MuoHskqJCDa/VMit9cxmlRzuVPwFMXcQVnKTN92HaSmklkktN3Bsm9zj6N
 TvgYrybo/VigoRHjeh+6kN5eaOO9ZtY42GBsabXOFxW4ehQuUgDifcGxneIWaIb/Hzxf5U18J8v
 4SXGNjwYWgU6UZlXnIVeF4MlyKPN4VtDIBW8EtvQxXHRf/B5L34Y5yDdY6oFotk3IYCm9jgben1
 OahDkm/f36vGDxd2ph4VQPbUwZXhid1wQqPY+fg4xDmhr0ivgJrP9Rur6qs7tjnBnj//oaMprCn
 E1UEkjE6szLp0X2OCVb/NIy/aFVGsCjpZE4U+p+uuyWau9Furhtb4g2WG2lwVfVkT/OOXOEmRaf
 gcMCJLalNKd/1HreGaQ68Ax2SZRrw7TTsRrplrv+T2ckT9A336WIxQGIlb9iYA2zCt6NSLimLp7
 luvDrbjCwIG1LC0NbQA==
X-Proofpoint-GUID: zpjDTVo5z2oqqkdqKfXrT11KsI9AWWjp
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfX+DZhO+FYVRke
 4YiU/4gNNseQquH2fbDXAxpi+PKkP8GfPYvqcIIc5OA+P63RmmBED1wxMg5GIfPybm6fIsPoUNB
 kOOivZlAZaxdlGpEgv83JIsxKzYmQpY=
X-Authority-Analysis: v=2.4 cv=Xey5Co55 c=1 sm=1 tr=0 ts=6a8bfaf6 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=wUpz7uCjLrEXi01cjX+DLw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=nM57NVUx0yqqE4FGInsA:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: zpjDTVo5z2oqqkdqKfXrT11KsI9AWWjp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608240070

On 26-08-24 01:17:38, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe. Attach the OPP-table with only the ICE
> core clock. Since, dtbinding is on a transition phase to include
> iface clock and clock-names, attaching the opp-table to core clock
> remains optional such that it does not cause probe failures.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use round_ceil passed to decide on the
> rounding of the clock freq against OPP-table. Clock scaling is
> disabled when a valid OPP-table is not registered.
> 
> This ensures when an ICE-device specific OPP table is available,
> use the PM OPP framework to manage frequency scaling and maintain
> proper power-domain constraints.
> 
> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
