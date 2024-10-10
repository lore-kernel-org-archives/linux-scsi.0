Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022691925AF
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728539233; cv=none; b=IMRDORwOgXoVx1lo2+NmfptEYWJRTWuzrUDfh/yOtZuI/K/fCp20Xc0+kD62plsfqrVLCcJXOxVRgkT+JHf1UpZxIq/sMF6AGk97bYnHMdQNKQltxqPw2Jk+KBYLEPJEgyvNtOJm61RQCdNKLBRXG+LnKC7NuCbcT/9/JPj0u+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728539233; c=relaxed/simple;
	bh=jGL8zKvOyMlgML4JIbc28fpjZwAaH9lvIYLew7E/IQ4=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=r0keI+F27TOhAHD/QQt8S7OXPlDg/NKA/DsV2NN+c+dbaV1/0m0TEtSzN1Vw/HXLj3qRyHce1kXNvvLxs4Yqi3ddUSDSpCyB22DZLddlsFDOIos+dzhL1NZcdktcIY8SDFpkCM1sspqcXTnJzZv50l7nXPsjVDwXbOaxnCaKu3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CJdmmHDN; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CJdmmHDN"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241010054708epoutp02a98264415846e47a0cf73e05e74b0a2e~9AUVCttSi2862428624epoutp02Y
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 05:47:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241010054708epoutp02a98264415846e47a0cf73e05e74b0a2e~9AUVCttSi2862428624epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728539229;
	bh=BDhSr3UtrCq/7jL5Gp0c6QINts7kQkiI/80OXlIgyXE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=CJdmmHDNhBR5OF/cMLCfz7HgHAvQVRk5ZyBlweFWhOkINde32vhJw8IVPWIRAsuV7
	 e1SGjG3wRlsjpWV8mVlk3HuwykTVTBpluQ4jjTNJIH2dQ03EcIui5/FbZT5EG9Lo0V
	 To4PaucX/lzvOU5QCZrQIodZcGJpsCSHj4wDy21Y=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20241010054708epcas2p3dac062372939aaa9fc5575670896b2c8~9AUUkzhy00500205002epcas2p3t;
	Thu, 10 Oct 2024 05:47:08 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.90]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XPJfz4Twhz4x9Q1; Thu, 10 Oct
	2024 05:47:07 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.A5.08559.B5A67076; Thu, 10 Oct 2024 14:47:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20241010054707epcas2p28601eafc8da3c666f94058b1055e5943~9AUTQ4AqZ1367913679epcas2p2m;
	Thu, 10 Oct 2024 05:47:07 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241010054707epsmtrp1afba8ed9435a421b1a6af69886c5a18a~9AUTPqZCS3061030610epsmtrp17;
	Thu, 10 Oct 2024 05:47:07 +0000 (GMT)
X-AuditID: b6c32a43-ff266a800000216f-f2-67076a5b87a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.E3.18937.A5A67076; Thu, 10 Oct 2024 14:47:06 +0900 (KST)
Received: from KORCO164647 (unknown [10.229.38.229]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241010054706epsmtip1111541d3ef4530e02089ff31f02e3b39~9AUS5z_Yd0549805498epsmtip1e;
	Thu, 10 Oct 2024 05:47:06 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Seunghwan Baek'" <sh8267.baek@samsung.com>, "'Bart Van Assche'"
	<bvanassche@acm.org>, <linux-kernel@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <avri.altman@wdc.com>,
	<alim.akhtar@samsung.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <dh0421.hwang@samsung.com>,
	<jangsub.yi@samsung.com>, <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<wkon.kim@samsung.com>, <stable@vger.kernel.org>, <sh425.lee@samsung.com>,
	<hy50.seo@samsung.com>, <kwangwon.min@samsung.com>, <h10.kim@samsung.com>
In-Reply-To: <017801db1942$ba6a5bb0$2f3f1310$@samsung.com>
Subject: RE: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
Date: Thu, 10 Oct 2024 14:47:06 +0900
Message-ID: <032101db1ad7$d7039a70$850acf50$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQITd6wvsWq6bg+5ypABxh1kBxxfMwHy7pIVAtyJc3gCDAIdKwI4d05OAHuLQEsCcDBpNrGuwlgA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmmW50Fnu6weO1ShYP5m1js3j58yqb
	xbQPP5ktZpxqY7XYd+0ku8Wvv+vZLf7evshqsXrxAxaLjf0cFh1bJzNZ7Hh+ht1i199mJout
	N3ayWFzeNYfNovv6DjaL5cf/MVk0/dnHYrH031sWi2tnTrBaLNj4iNFi86VvLA6iHpeveHtM
	m3SKzePj01ssHn1bVjF6fN4k59F+oJspgC0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzA
	UNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6B8lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFK
	ToF5gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnZG86fEgvvcFW9mb2FrYJzJ2cXIySEhYCLRtuQQ
	axcjF4eQwA5GiR/rnjJBOJ8YJc403maGcz7eecfYxcgB1tJ7JgYivpNR4vffy1DtLxkl9nU8
	ZQSZyyagLTHt4W6whIjATCaJ/c3dLCAOs8ANJonZD1YwgVRxClhJ3LvSyQ5iCwt4SfzYdgIs
	ziKgKnHy2lJmEJtXwFLi7PQ/TBC2oMTJmU9YQGxmAXmJ7W/nMEN8oSDx8+kyVoi4iMTszjaw
	uIhAlETP3vVgiyUE/nNILPn0gBXiBxeJLzM9IXqFJV4d38IOYUtJvOxvg7KLJdbuuMoE0dvA
	KLH61WmohLHErGft4LBgFtCUWL9LH2KkssSRW1Cn8Ul0HP7LDhHmlehoE4JoVJb4NWkyI4Qt
	KTHz5h32CYxKs5A8NgvJY7OQPDMLYdcCRpZVjGKpBcW56anJRgWG8MhOzs/dxAhO6lrOOxiv
	zP+nd4iRiYPxEKMEB7OSCK/uQtZ0Id6UxMqq1KL8+KLSnNTiQ4ymwKCeyCwlmpwPzCt5JfGG
	JpYGJmZmhuZGpgbmSuK891rnpggJpCeWpGanphakFsH0MXFwSjUwNQn2Tn+9Zsu+93NvFlX+
	2x7yxN5qclHm9e06gnxX7zCXSHFXxS+bmBNQ+3NyfY+yqNTbSwbt647V+zvq1+wV0Q1mj+hq
	n7XzX+LPWaeE9M/9yy3X87j/JmE6d9w+jeuXHJgcEg7qzl/3cP3URdn/2s+LaEt9n708M194
	84Ll/veOm7b02gUu3VPz9ZFMvZ29x6uOUE4F0fOvo8RsP4iyNC6WYDnkMnne0+aWHQsFSjZt
	8VbrSpjL6rilZ2m9f+CjXZu05/yXXskX1LbmVOuNn3Jdz4TCvy/ZwSA3TcgvMYQz4ARnVHT8
	jSiv9FtzFl251Z3SOlty4b7uTJ7qCf2z7RZ8YXofe+L22TirCXvmK7EUZyQaajEXFScCAMzE
	ZgtzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWy7bCSnG5UFnu6wdlpphYP5m1js3j58yqb
	xbQPP5ktZpxqY7XYd+0ku8Wvv+vZLf7evshqsXrxAxaLjf0cFh1bJzNZ7Hh+ht1i199mJout
	N3ayWFzeNYfNovv6DjaL5cf/MVk0/dnHYrH031sWi2tnTrBaLNj4iNFi86VvLA6iHpeveHtM
	m3SKzePj01ssHn1bVjF6fN4k59F+oJspgC2KyyYlNSezLLVI3y6BK6P5U2LBfe6KN7O3sDUw
	zuTsYuTgkBAwkeg9E9PFyMkhJLCdUeLVZnMQW0JAUuLEzueMELawxP2WI6xdjFxANc8ZJWY3
	LmMHSbAJaEtMe7gbLCEiMJ9J4sjZw+wgDrPACyaJvkufWSBafjBJNOzZA9bCKWAlce9KJ5gt
	LOAl8WPbCSYQm0VAVeLktaXMIDavgKXE2el/mCBsQYmTM5+wgNjMQOt6H7YyQtjyEtvfzmGG
	uE9B4ufTZawQcRGJ2Z1tYHERgSiJnr3rWSYwCs9CMmoWklGzkIyahaR9ASPLKkbR1ILi3PTc
	5AJDveLE3OLSvHS95PzcTYzgyNYK2sG4bP1fvUOMTByMhxglOJiVRHh1F7KmC/GmJFZWpRbl
	xxeV5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBKNTD5rufMSMjVuyGQKN7XvCQn
	1XD5p/yG0EqjqNkZNsufy3/wZXoWpD9jkoBCibG/SO/18wnxMgf2i6x/uzNwfnuDa8M0Y5Hr
	/dFvuV+ktCydLNZ2//NZw6h7S6V4/n9hP3nAP5X9JJOVkMbjbAn3oPnn6k7c/+6udtv3Y2xl
	4JqAc1z79VXWpnRY3Xm+aOfvDg79ea6CMjmH/G/sFHZ4/NW9R8uoecbz72LJKzbn3Uz7y7xh
	+b/H0iF7xS75xIfM9++9sKha6N+eHyccba66GmQKJs3m0zT/4yv4Z+HtQ44dMlycDzZ/nsxl
	mP4+LW7F04Z3Wc/f39sRztjLwsbA/ZLf441P/meZGX456gUP1ZVYijMSDbWYi4oTAU431Bdb
	AwAA
X-CMS-MailID: 20241010054707epcas2p28601eafc8da3c666f94058b1055e5943
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
	<CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
	<20240829093913.6282-2-sh8267.baek@samsung.com>
	<fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>
	<003201db0e27$df93f250$9ebbd6f0$@samsung.com>
	<1845f326-e9eb-4351-9ed1-fce373c82cb0@acm.org> 
	<017801db1942$ba6a5bb0$2f3f1310$@samsung.com>

> > > On 9/23/24 7:17 PM, Seunghwan Baek wrote:> That's because SSU (Start
> > > Stop
> > > Unit) command must be sent during
> > > > shutdown process. If SDEV_OFFLINE is set for wlun, SSU command
> > > > cannot be sent because it is rejected by the scsi layer.
> > > > Therefore, we consider to set SDEV_QUIESCE for wlun, and set
> > > > SDEV_OFFLINE for other lus.
> > > Right. Since ufshcd_wl_shutdown() is expected to stop all DMA
> > > related to the UFS host, shouldn't there be a
> > > scsi_device_quiesce(sdev) call after the __ufshcd_wl_suspend(hba,
> UFS_SHUTDOWN_PM) call?
> > >
> > > Thanks,
> > >
> > > Bart.
> >
> > Yes. __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) should be called after
> > scsi_device_quiesce(sdev). Generally, the SSU command is the last
> > command before UFS power off. Therefore, if __ufshcd_wl_suspend is
> > performed before scsi_device_quiesce, other commands may be performed
> > after the SSU command and UFS may not guarantee the operation of the
> > SSU command, which may cause other problems. This order must be
> guaranteed.
> >
> > And with SDEV_QUIESCE, deadlock issue cannot be avoided due to requeue.
> > We need to return the i/o error with SDEV_OFFLINE to avoid the
> > mentioned deadlock problem.
> 
> (+ more CC added.)
> Dear All.
> 
> Could you please update for this patch?
> If you have any opinions about this patch, share and comment it.
> 
> Thanks.
> BRs.

Looks good to me.

Thanks.
Kiwoong Kim.


