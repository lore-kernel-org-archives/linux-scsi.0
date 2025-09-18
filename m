Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1529BD90
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 05:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172927; cv=none; b=jAJzO6FSUBnR21n2RO24Qaj7yvaFsrv/W7j1Gl8D0F/rwv+hVbxAm8jaMlUIlKddeficjYM9dyB5BM6vvT6agw3kI/5p1D0toLOVUAQ0XZb6YxDgEWDPyl+UvZy3NIyzXVpB7OssVIFM+afCZx+lWyXa//Hcw3ZXaJNonzHhOnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172927; c=relaxed/simple;
	bh=KUcCexFEbCDMXaMBUTpgROGMapdiXsN4o/IinUg9NQU=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=lUp2AbSKVOYaZKfOdHMnlEJo8toI5ENC/7xFm7ZVDyIPYv8P5x9Y/XNdmYg2JKSrjWKuz9ucp0MYyLTdDmVXN7WrDYhA1G3EaA4oQicD90iW+580lfV5K8CKpZ/zLjTcSMx+UGDCg2P1iY+FSN1oTuyEuTib3y6H/5CsbFbNd5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=L64GzKng; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L64GzKng"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250918052204epoutp02106f621503ff61d4dff950d5202f7acc~mSPWTKcC72853428534epoutp02K
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 05:22:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250918052204epoutp02106f621503ff61d4dff950d5202f7acc~mSPWTKcC72853428534epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758172924;
	bh=miH9oPHylJR7rAEXE40TRuXYzTxBfP58QKYbk6GkLcI=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=L64GzKngS7YlSt4WWYibkSSA0EHeaeAMF4xfHmzkjCra9RPbSzqeOyGOdzjvEAHY3
	 P8e/WKfFv6wydXCK/+ufzyC9tDpHYLiXdNcYR8EmVQw2gJkDu/4L1pIcKqPt+2jgZG
	 JQVJNywD5oCLUyvCnP0gjImiL5wYa4tltc8XjErk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250918052203epcas5p4155efc46a73e7dd8832cd87915560575~mSPV2urv61929319293epcas5p4i;
	Thu, 18 Sep 2025 05:22:03 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cS3sk6sDnz2SSKk; Thu, 18 Sep
	2025 05:22:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250918052202epcas5p4a32a896d2f6a0e42142480b823868def~mSPUu4Ywl0771707717epcas5p42;
	Thu, 18 Sep 2025 05:22:02 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250918052200epsmtip28e7901f8ee796c304aded6f80c83cc5d~mSPSr5asu1966619666epsmtip2b;
	Thu, 18 Sep 2025 05:22:00 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Ram Kumar Dwivedi'" <quic_rdwivedi@quicinc.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <mani@kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
In-Reply-To: <20250917140933.2042689-5-quic_rdwivedi@quicinc.com>
Subject: RE: [PATCH V6 4/4] ufs: ufs-qcom: Add support for limiting HS gear
 and rate
Date: Thu, 18 Sep 2025 10:51:58 +0530
Message-ID: <06fd01dc285c$2a0141e0$7e03c5a0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJRoHUYa79wgWtyawBlQOaHwFj68gHuslinAamlZ6uzkLSUIA==
Content-Language: en-us
X-CMS-MailID: 20250918052202epcas5p4a32a896d2f6a0e42142480b823868def
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917141028epcas5p10a2034f660037186138ef0f4c5be0aa9
References: <20250917140933.2042689-1-quic_rdwivedi@quicinc.com>
	<CGME20250917141028epcas5p10a2034f660037186138ef0f4c5be0aa9@epcas5p1.samsung.com>
	<20250917140933.2042689-5-quic_rdwivedi@quicinc.com>



> -----Original Message-----
> From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Sent: Wednesday, September 17, 2025 7:40 PM
> To: alim.akhtar@samsung.com; avri.altman@wdc.com; bvanassche@acm.org;
> robh@kernel.org; krzk+dt@kernel.org; conor+dt@kernel.org; mani@kernel.org;
> James.Bottomley@HansenPartnership.com; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-arm-msm@vger.kernel.org
> Subject: [PATCH V6 4/4] ufs: ufs-qcom: Add support for limiting HS gear
and rate
> 
> Add support to limit Tx/Rx gear and rate during UFS initialization based
on DT
> property.
> 
> Also update the phy_gear to ensure PHY calibrations align with the
required gear
> and rate.
> 
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

