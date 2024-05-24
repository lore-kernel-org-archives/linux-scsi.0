Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB12570
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716509929; cv=none; b=EytoMonZSQMJRbLZ4kTlbwVGUbrEDTVsQSj0KN8tbCwcBJf4oCaoq23KKbmdfLbgJk4EHdmm9IpMKBqLEEjrT9jewl6BtXdWQQoID3T3oP5m2C3q+/3sojD7sDCgWezNvamvZvZKdlyJVFujCK4PzYpKioHvDVJDFCJt8akUqCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716509929; c=relaxed/simple;
	bh=/LHAMDUw9dxA/AqHsxp2TqEWaMowWilYcYA0HbO4XZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=t4l0G9PSWFmMtgdhM6l5HPGXk7VSbGW8F67LY6WvwZs5QbklSFmerdZM0M6E8VBLCuhySFksc1yFf2pxUzuxyoElr2RkRsZH1VaG/oG6WJuCQ7t4TrEtgDmod0JiYQp3LF3UfewKmFjLLgZ5JUY3942QA8boOr6zh90AbdIE23k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qHUloJ+L; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qHUloJ+L"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240524001844epoutp02ddc8ad94a8393c6a0be366e99dfec712~SRK6YDD3c3093530935epoutp02R
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 00:18:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240524001844epoutp02ddc8ad94a8393c6a0be366e99dfec712~SRK6YDD3c3093530935epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716509924;
	bh=DSC7gwpMSFmwZdZRot6AskcvnEqlG9tvIb88IW3wBJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHUloJ+Ltslw5mNSdlSwfQZ5n3rmTh5W26qvxzN5TaS+WCNiBXa6YUaucMXV30cv4
	 4fKQpgMgeRC2Gxhrl5cbEJpJRnbPKblBoAA2Yh4kqz2OiSkHqcrw3BgGtxD9sOnjDc
	 4lkzDRtjGQubbwIs8+1ShOtLcD6K8tJEbVlQuw+4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240524001843epcas1p11e0bf5a73842f4d8e5e007a1b0bb18a6~SRK5gUgos0690206902epcas1p1G;
	Fri, 24 May 2024 00:18:43 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.36.222]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VllyC2PrYz4x9Pp; Fri, 24 May
	2024 00:18:43 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	80.25.09696.3ECDF466; Fri, 24 May 2024 09:18:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240524001842epcas1p3a66b301f7aad3a8da28869db634221d1~SRK4kXOKh3249332493epcas1p3g;
	Fri, 24 May 2024 00:18:42 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240524001842epsmtrp111403e8bc3ceca40ba072cb985fd208d~SRK4joEF11318113181epsmtrp1v;
	Fri, 24 May 2024 00:18:42 +0000 (GMT)
X-AuditID: b6c32a36-7a9f9700000025e0-2d-664fdce3eeac
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.55.09238.2ECDF466; Fri, 24 May 2024 09:18:42 +0900 (KST)
Received: from lee.. (unknown [10.253.100.232]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240524001842epsmtip194f05718e7e4af5f9c0509df59c4baec~SRK4We5Tb3056830568epsmtip13;
	Fri, 24 May 2024 00:18:42 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: cw9316.lee@samsung.com
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	powen.kao@mediatek.com, quic_cang@quicinc.com, quic_nguyenb@quicinc.com,
	stanley.chu@mediatek.com, yang.lee@linux.alibaba.com
Subject: RE: [PATCH] ufs:mcq:Fixing Error Output for
 ufshcd_try_to_abort_task in ufshcd_mcq_abort
Date: Fri, 24 May 2024 09:18:40 +0900
Message-Id: <20240524001840.1104839-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240523002257.1068373-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmge7jO/5pBk+OCVg8mLeNzeLlz6ts
	FtM+/GS2mHGqjdViYz+HxeVdc9gsuq/vYLNYfvwfk8Xbu/9ZLCZd28BmMfXFcXaLpVtvMlq8
	azzM6MDrcfmKt8e0SafYPHY+tPRoObmfxePj01ssHhP31Hn0bVnF6PF5k5xH+4FupgDOqGyb
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCjlRTKEnNK
	gUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFZgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGVtb
	etkLnrFXvGzqZmtgnMvWxcjJISFgInF81yXWLkYuDiGBHYwSs79sZIFwPjFKTJ7UwAThfGOU
	aDryFq5l/qSNzBCJvYwSh7bvZYRwnjBK/Ft7AaiFg4NNQEvi9jFvkAYRASmJ2Tvmgk1iFjjB
	JLH6+1x2kISwQLLEpMYFLCA2i4CqRNenl4wgvbwCthIH3yhCLJOX2H/wLDOIzSlgJ7F+8QWw
	Vl4BQYmTM5+AtTID1TRvnQ12kITASg6JmfMvs0I0u0i8aH0MdbWwxKvjW9ghbCmJl/1t7BAN
	zYwSC98ch+qewCjx5eNtqA57iebWZjaQi5gFNCXW79KH2MYn8e5rDytIWEKAV6KjTQiiWkVi
	Ttc5Npj5H288hirxkLhwIAUkLCQwkVHiw3/WCYzys5C8MAvJC7MQdi1gZF7FKJZaUJybnlps
	WGAEj9Xk/NxNjOCEq2W2g3HS2w96hxiZOBgPMUpwMCuJ8Eav9E0T4k1JrKxKLcqPLyrNSS0+
	xGgKDN+JzFKiyfnAlJ9XEm9oYmlgYmZkYmFsaWymJM575kpZqpBAemJJanZqakFqEUwfEwen
	VANTwa/SmnuHxYrtS7Y+YFD5dei92tlk9acpKelPi9J8ZC6otZxZWXGFzfbLLoav54M36+Ud
	3sldV5X8xcctbKd/4eGiE/t/3FtgtmDanov5dua396/1y3RdURxUmGq43JMvmW0240RWM973
	WT1Ce0sY65ZUt0z7FW8UW25/6uHlPwFPJvnkZ76L2pXbKNp39so7yx9punpdyz7/mTzzyPFN
	114IFD63Y3Kud/I8eHb9BdU837nPbT7P8+/YOEd4gtOvqL/mXRy3PlmrzpjwUeaQeXNs/Id1
	kjpJ9YUha3JMAhc+4/n4i/u/ZZDeFK3bRhMtFeZkdWsFtWT1nb36raju5+zSumklVa7OhUU7
	D4UrsRRnJBpqMRcVJwIAkrxGLEEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSnO6jO/5pBgcPqFk8mLeNzeLlz6ts
	FtM+/GS2mHGqjdViYz+HxeVdc9gsuq/vYLNYfvwfk8Xbu/9ZLCZd28BmMfXFcXaLpVtvMlq8
	azzM6MDrcfmKt8e0SafYPHY+tPRoObmfxePj01ssHhP31Hn0bVnF6PF5k5xH+4FupgDOKC6b
	lNSczLLUIn27BK6MrS297AXP2CteNnWzNTDOZeti5OSQEDCRmD9pIzOILSSwm1Hi3i8piLiU
	xO7954FqOIBsYYnDh4u7GLmASh4xSnz9vYIRJM4moCVx+5g3SLkIUPnsHXOZQGqYBa4xSRyZ
	NAusRlggUeJYbzRIDYuAqkTXp5dgYV4BW4mDbxQhNslL7D94FuwCTgE7ifWLL7BDXGMr8alx
	BxOIzSsgKHFy5hMWEJsZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQnJuem2xYYJiXWq5XnJhb
	XJqXrpecn7uJERwrWho7GO/N/6d3iJGJg/EQowQHs5IIb/RK3zQh3pTEyqrUovz4otKc1OJD
	jNIcLErivIYzZqcICaQnlqRmp6YWpBbBZJk4OKUamCaX72Zv3h6V2hTDNOnGpEL1Y+wCkm8u
	PhJeoFbWtamZ0TDo9fGupn2KadKz0r5sNIqUmVX9oC06N1vv7rzDkh58zFk+SsY8N4//5an8
	vP/m0wdzQzQNHq++PvHNxosbEvcFyG/xUks9++7+ww7fHh1z7xnhm6Q7JrQXMcnN/+N5LOZA
	8Vu25eJ9fKozzF8pVc05uCWl9bqF9ul3guGx7+RXPsiyEJdjf/1bzOrFD975vbf/ry1ceShu
	6WT3hAmRyRdOn25/fEdlJ6Osu4asAFOYeHXszSMztB2OzZNn9krzyBfoeBOWeFtju0h6huWX
	Tyl6HnO67WZ1H52vbnz/drSyxivWBK25J7NO238zVWIpzkg01GIuKk4EAH0mfccEAwAA
X-CMS-MailID: 20240524001842epcas1p3a66b301f7aad3a8da28869db634221d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240524001842epcas1p3a66b301f7aad3a8da28869db634221d1
References: <20240523002257.1068373-1-cw9316.lee@samsung.com>
	<CGME20240524001842epcas1p3a66b301f7aad3a8da28869db634221d1@epcas1p3.samsung.com>

On 5/24/24 12:08, Bart Van Assche wrote:
>On 5/23/24 16:56, Chanwoo Lee wrote:
>> I thought this patch would be appropriate to "fix" the following log.
>>    * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
>> If "Fixing" is not appropriate, could you suggest another word?
>
>That's something I had not noticed. This is indeed a bug fix. Please add
>a "Fixes:" tag as is expected for bug fixes.
>
>BTW, I think that ufshcd_mcq_abort() can be improved significantly. How
>about reworking that function as follows before the bug reported in this
>patch is fixed?
>- Remove the local variable 'err' (and reintroduce that variable in your
>patch).
>- Change all 'goto out' statements into 'return FAILED'.
>- Add 'return SUCCESS' at the end.
>
>I expect that this change will make that function easier to read and to
>maintain.
>
>Thanks,
>
>Bart.

Thank you for the good suggestion.
I will create a new patch and reply with v2.

Thanks,

Chanwoo Lee.
