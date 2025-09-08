Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A52EA494
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 07:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757317437; cv=none; b=LStB9lS9j2pT7XR8wj+0eAcrciGhZ9YSpWxq7lpqcuDEjsOQ8fsKE0fiZj84dd6OaaRjbLYf0yu14UIAy+VS24FFlrDNHClrD4AxYEo4wYrBMXXhjtSOQSGwgOrPFALSQJp5XUeHmWOH+eHVbJU48VI94V5WPtPfEK4jw+fGBBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757317437; c=relaxed/simple;
	bh=wpueAdzFOsR+CPJDx/2e8jBSy3XC1zxVf5fsbWUrbso=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=Wh0F22wroHQvG08Oja1N/l+eBRpWch5IxKsOJVWPW8gl9qMdUXkrKVztsRjahj6moyYW4Rc8hE8mrVBhaUaLmkaJ7AUDZgpp4iBfzTtagOoCHlkdAKiAjwaL1dVA5OCVkFFVtJFHyIDyLOM9xfUOu8KxRvwawE2Wo3LYsL/qcgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BtyDee5d; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BtyDee5d"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250908074353epoutp047e23f202b103dde24b233580466818da~jPuUUP5To1009010090epoutp04J
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 07:43:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250908074353epoutp047e23f202b103dde24b233580466818da~jPuUUP5To1009010090epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757317433;
	bh=fMu6m4Myk6rvvwL0qen9upyk1beh6Sb+VgXqEvbruYo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=BtyDee5doGflxun6TXx2AkPXdKsk+ewiQQOrGfIRWT/rmO+JGuW4ODbzKrEE/F3rc
	 aXJJEP7FbrMjcSiY65PN76+XBO7X781pD9PQuU+f2njhT2dRdUmH95hfJVJT3s5Xxm
	 rVW3QCu2ypbNusa93ER4iyD/cmmoWe1LJjdrgIMI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20250908074352epcas1p299b9387b7f14b9e9c25fd129987bcee4~jPuTpJENu0257602576epcas1p2V;
	Mon,  8 Sep 2025 07:43:52 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.36.227]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cKzV00mKBz6B9mG; Mon,  8 Sep
	2025 07:43:52 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250908074351epcas1p22e354de3ace0e8e1a74f3991e6221ddd~jPuSfDzo70257602576epcas1p2L;
	Mon,  8 Sep 2025 07:43:51 +0000 (GMT)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250908074351epsmtip1d6bf1c2323c1ed4bfc4f33b12622a331~jPuSYmobE1120011200epsmtip1o;
	Mon,  8 Sep 2025 07:43:51 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <854fad23-e7f8-42c8-b0e2-03460f481366@acm.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs
 cmd error
Date: Mon, 8 Sep 2025 16:43:51 +0900
Message-ID: <561a01dc2094$51b24b00$f516e100$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEmYeTjtFjYRI1QNWxgWL0Y7ybfIwITLn2gAaoUPAICiJScSgGs7ud4AZvu8PIB4FCAbgHlrZjyAhv1i+YCmdARLrVkDxOg
Content-Language: ko
X-CMS-MailID: 20250908074351epcas1p22e354de3ace0e8e1a74f3991e6221ddd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
	<20250417023405.6954-2-dh0421.hwang@samsung.com>
	<239ea120-841f-478d-b6b4-9627aa453795@acm.org>
	<093601dc1ae0$2389c460$6a9d4d20$@samsung.com>
	<27882582-58b8-4ac2-9596-3602098e7c1d@acm.org>
	<17db01dc1ba6$41d37350$c57a59f0$@samsung.com>
	<6e854090-a071-416a-b7a5-cc8ee0122a90@acm.org>
	<2add01dc1c9d$7b5cba30$72162e90$@samsung.com>
	<854fad23-e7f8-42c8-b0e2-03460f481366@acm.org>

On 9/3/25 8:57 AM, Bart Van Assche wrote:
> On 9/2/25 11:39 PM, DooHyun Hwang wrote:
> > Could you please provide some guidance or suggestions?
> 
> How about this approach?
> * In a separate patch, remove UFS_DEV_COMP because it is not used.
> * Call the new enumeration label UFS_UIC_ERR (UFS UIC command error)
>    since "UIC" is how the UFS standard refers to UIC commands (these are
>    called "device commands" in the UFS driver).
> 
> If anyone else has a different opinion, please speak up.
> 
> Thanks,
> 
> Bart.

Thank you for your review. Your opinion is truly valuable to me.

Based on your suggestion, I understand that the change involves
renaming UFS_DEV_COMP to UFS_UIC_ERR.
Would it be acceptable to add UFS_UIC_SEND, UFS_UIC_COMP,
and UFS_UIC_ERR at the end of the enum?

I am aware that UFS_DEV_COMP is currently not used in the code,
but I am concerned about whether it is appropriate to modify
or remove existing enum labels.
Therefore, I thought it would be better to discuss the removal
of UFS_DEV_COMP in a separate commit.
Additionally, I considered adding new enums as needed.

I decided to name the new enum UFS_CMD_ERR and add it
in the same type's position, which led to a change in the enum order.
I realized this could also potentially alter existing enum values,
creating room for controversy.
Furthermore, I acknowledged that the label UFS_CMD_ERR may not accurately
represent the purpose of tracing UIC errors.

Thank you.
DooHyun Hwang.

