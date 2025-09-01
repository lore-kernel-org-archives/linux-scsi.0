Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777B115E8B
	for <linux-scsi@vger.kernel.org>; Mon,  1 Sep 2025 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756690295; cv=none; b=P64wEnHLjIkc1U5tzajZ3s7KppO1XIk6MVkzOtCn0Ra/IF7fFn71FqnIpW5N+32acKciGJ9nu3GqxsQWpduD2WLHAvKFij73Ifitrhjd6v0Xyl1mp/gmS5OoQTRtLPL/1xPQRqD4aZNNWG93GgzeBztASLxkhjogpYeTLDa+YJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756690295; c=relaxed/simple;
	bh=k2yIBHeetjvIe2eMsGwblYzWcuhy4DxsR0y7wG7BIis=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=O+y/GBLn8gZEZxVktnRx8A0xVp5fKcdXUjaaJfY+kPPHmTaXgedkqrPs+35lHAMN4ua0bUTXJW9o7jF2RafUvxoQWvk2uZBkSvjQRucAWqS/4lFh1wud/HaDIL7NxZJp8vPt9vX+DxvsHIlpkAXsHw0TJgk0xftLij+eJt5BVxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Te+0EPpe; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Te+0EPpe"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250901013130epoutp01adcd007bb8745b771db577edbf9c4ba0~hBIMF7DIJ0047800478epoutp01f
	for <linux-scsi@vger.kernel.org>; Mon,  1 Sep 2025 01:31:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250901013130epoutp01adcd007bb8745b771db577edbf9c4ba0~hBIMF7DIJ0047800478epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756690290;
	bh=qEQukgl2nisoCJ8UWKyqaVr+jS40V1s8aqemUXAu1rI=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=Te+0EPpeoKU0Mtjy5czxZjs3wqLE9W1xvGUH0/BBtc/zRGl4/wjdHGv/3q83DmIVS
	 C0d1R5SvehPNdQVFa8l2ZLQBC62g5gQJ5HuG47JHCR8F2cp34gh4Cp/EcZEjFkTk6u
	 yhykp1yo59XTgF63fsMFnvawcT9RslHWLW8CjB/M=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20250901013129epcas1p3b6322e441267fa862de9dffd227598c4~hBILVJwzJ2586925869epcas1p3J;
	Mon,  1 Sep 2025 01:31:29 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.36.224]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cFWYY1Rbbz3hhTG; Mon,  1 Sep
	2025 01:31:29 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250901013128epcas1p43eed1b6be716dc182920ec93476a2854~hBIKXlGAL2416324163epcas1p41;
	Mon,  1 Sep 2025 01:31:28 +0000 (GMT)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250901013128epsmtip223e40759f883573dea159c4dc387b14b~hBIKQx2LO1772517725epsmtip2N;
	Mon,  1 Sep 2025 01:31:28 +0000 (GMT)
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
In-Reply-To: <239ea120-841f-478d-b6b4-9627aa453795@acm.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs
 cmd error
Date: Mon, 1 Sep 2025 10:31:28 +0900
Message-ID: <093601dc1ae0$2389c460$6a9d4d20$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEmYeTjtFjYRI1QNWxgWL0Y7ybfIwITLn2gAaoUPAICiJScSrW2zAQQ
Content-Language: ko
X-CMS-MailID: 20250901013128epcas1p43eed1b6be716dc182920ec93476a2854
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

On 8/29/25 8:15 PM, Bart Van Assche wrote:
> On 4/16/25 7:34 PM, DooHyun Hwang wrote:
> > +	EM(UFS_CMD_ERR,		"req_complete_err")		\
> 
> Does UFS_CMD_ERR stand for "command error" or "completion error"? Please
> make the enum label and the text that is displayed in error messages
> consistent.
> 
> Bart.

UFS_CMD_ERR stands for "completion error".
The enum is converted to a string in the trace log according
to the definition below.

in include/trace/events/ufs.h
#define UFS_CMD_TRACE_STRINGS					\
	EM(UFS_CMD_SEND,	"send_req")			\
	EM(UFS_CMD_COMP,	"complete_rsp")			\
+	EM(UFS_CMD_ERR,		"req_complete_err")		\
	EM(UFS_DEV_COMP,	"dev_complete")			\
	EM(UFS_QUERY_SEND,	"query_send")			\
	EM(UFS_QUERY_COMP,	"query_complete")		\
	EM(UFS_QUERY_ERR,	"query_complete_err")		\
	EM(UFS_TM_SEND,		"tm_send")			\
	EM(UFS_TM_COMP,		"tm_complete")			\
	EMe(UFS_TM_ERR,		"tm_complete_err")

Thank you.
DooHyun Hwang.

