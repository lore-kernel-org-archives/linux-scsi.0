Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63175155333
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 06:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727247306; cv=none; b=E6FKFZmzGqvCM8gAvkK54mYPMGII1y/dYdMt2EyffE9GSbTjLhhRwCD8aFfe8Sd33/lhURfmGzU0gFa+n6ZM9TFKNXrpzrrxph+kkLAGk34DgTCuPR+5hZnSeRxXzs/Xsz6qg7TrTfureNp/yknRjHeI4mMPtQ55JeuDl7Vhi0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727247306; c=relaxed/simple;
	bh=4gOKKEtz+0EI6rj3HqZT27xWK2qDolfvA8v4vKsZ6RU=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=A3a3pgmjFwu0lgZF2BhNAZSZswoG1F/aySnBR4RIsAbeZbL18W3P9YLFqHwYiZXRCM2Vwcy9EjLvewVu8AP7D7DD0tn5Bq8MOSJfHortLYQ0pHTj+TncLpwn/GQsD+Ch70Vpch0BLu8CGI0bT4CRYqNtAZalqPKJyb0KvUO2CKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TSFhwR7W; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TSFhwR7W"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240925065501epoutp04d76b99a25aff3004c4b5c2ea77bd81af~4akToaoYG1949719497epoutp04K
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 06:55:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240925065501epoutp04d76b99a25aff3004c4b5c2ea77bd81af~4akToaoYG1949719497epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727247301;
	bh=npWzJrPmcJ7bQMNX0h6hcxv6OusSwWpLI++E+L4EUvU=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=TSFhwR7WVS85pq9Zo++PTL//bWIhraLamMrsIFsALm8sUybNg2gfxb5fqTomEiZb/
	 Hu4dsUxgx4BZlKXk0APs+J/xKwZh1RblcB08Mdmz6c1Rbfti9i4MXt8f00Km7qG6aQ
	 ZVrnwnInkr4oaTUdSRfCZFtSo98NOosOcmexkpwA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240925065500epcas1p230985f5aa54f41a5df2549418f732a7c~4akTDSehl0821208212epcas1p2e;
	Wed, 25 Sep 2024 06:55:00 +0000 (GMT)
Received: from epsmgec1p1-new.samsung.com (unknown [182.195.38.243]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XD6tD3zJkz4x9Q1; Wed, 25 Sep
	2024 06:55:00 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmgec1p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.6E.19509.4C3B3F66; Wed, 25 Sep 2024 15:55:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240925065459epcas1p3b8e701fd0228bc2670f22cf253a3b02f~4akSaJnxP2690826908epcas1p3I;
	Wed, 25 Sep 2024 06:54:59 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240925065459epsmtrp2e39f8de490b2cc6f2afb472e175b4937~4akSZP00F1786117861epsmtrp26;
	Wed, 25 Sep 2024 06:54:59 +0000 (GMT)
X-AuditID: b6c32a4c-17bc070000004c35-0a-66f3b3c4a89b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7C.67.08456.3C3B3F66; Wed, 25 Sep 2024 15:54:59 +0900 (KST)
Received: from sh8267baek02 (unknown [10.253.99.49]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240925065459epsmtip18e825fae86b1134e725dde1488ddc4da~4akSHH87I1980719807epsmtip1w;
	Wed, 25 Sep 2024 06:54:59 +0000 (GMT)
From: "Seunghwan Baek" <sh8267.baek@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>,
	<linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <dh0421.hwang@samsung.com>,
	<jangsub.yi@samsung.com>, <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<wkon.kim@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <1845f326-e9eb-4351-9ed1-fce373c82cb0@acm.org>
Subject: RE: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
Date: Wed, 25 Sep 2024 15:54:59 +0900
Message-ID: <08b901db0f17$d6a20b50$83e621f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQITd6wvsWq6bg+5ypABxh1kBxxfMwHy7pIVAtyJc3gCDAIdKwI4d05OAHuLQEuxqsQ7wA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmvu6RzZ/TDJacl7F4MG8bm8XLn1fZ
	LKZ9+MlsMeNUG6vFvmsn2S1+/V3PbrGxn8OiY+tkJosdz8+wW+z628xkcXnXHDaL7us72CyW
	H//HZNH0Zx+LxYKNjxgtNl/6xuIg4HH5irfHtEmn2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAtii
	sm0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFegVJ+YWl+al6+WlllgZGhgYmQIVJmRn
	fF5nUDCVs2Lzvz72BsbD7F2MnBwSAiYSZ5etZ+pi5OIQEtjDKDG/dxMLhPOJUWL3+hvsEM43
	RonNbzczw7QcenUYKrGXUeLIxLuMEM5LRonT7YsYQarYBAwkmn8cBKsSAUns2HIdbDAzyOAt
	f46xgFRxClhLPH+xgRXEFhbwkvix7QQTiM0ioCrx4Mg7sH28ApYS7/9sYoGwBSVOznwCZjML
	yEtsfzsH6iYFiZ9Pl4HNEREIk1j69TgjRI2IxOzONmaQxRICdzgk9v07wAjR4CLRuLgFqllY
	4tXxLdDwkJL4/G4vG4RdLLFw4yQWiOYWRonry/9ANdtLNLc2AxVxAG3QlFi/Sx9iGZ/Eu689
	rCBhCQFeiY42IYhqVYlTG7ZCdUpLXG9uYIWwPSQ2rtvPPIFRcRaS12YheW0WkhdmISxbwMiy
	ilEqtaA4Nz012bDAUDcvtRwe58n5uZsYwQlby2cH4/f1f/UOMTJxMB5ilOBgVhLhnXTzY5oQ
	b0piZVVqUX58UWlOavEhRlNggE9klhJNzgfmjLySeEMTSwMTMyMTC2NLYzMlcd4zV8pShQTS
	E0tSs1NTC1KLYPqYODilGph6Ex2DmA+tieu/c/dN80/+9iOT2q8d383+/Hfi2qI1+/ufqMnM
	eBxa/jBW4fB3xkPXVphZ3/u0bsqLP58vp/ytPHlIveSFrGXwW//HeZLfrBlNmjh4jHN2vudc
	pb9gUtth/mvFlxJr5nD8cS1aHBrGt1+9xGy2YwTbTIYGR7XLtyfebtVYcNw13k12vqrbdNfT
	PKtKT9y+7tn/37MxdkbKJNHgkxd/3DCaEujWMm+/32G9hbXhEkE6Yee2XRd//MlelFvm7wIm
	kaX5hxaa9y7Y37JRSbMnz6P7XovAyS0+qd/0J/il8h27t6fZ/2fvPY17P9Ls7vzTmh+u/PlS
	enHiDhVLoUUsTyZHy0kJFHxWYinOSDTUYi4qTgQArUJSXmEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnO7hzZ/TDC4dNrR4MG8bm8XLn1fZ
	LKZ9+MlsMeNUG6vFvmsn2S1+/V3PbrGxn8OiY+tkJosdz8+wW+z628xkcXnXHDaL7us72CyW
	H//HZNH0Zx+LxYKNjxgtNl/6xuIg4HH5irfHtEmn2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAtii
	uGxSUnMyy1KL9O0SuDI+rzMomMpZsflfH3sD42H2LkZODgkBE4lDr0BsLg4hgd2MEpMmXGeD
	SEhLPD7wkrGLkQPIFpY4fLgYouY5o8S9vQ2sIDVsAgYSzT8OgjWLCLxnlDj+Zx2Ywyzwh1Fi
	zrnJbBAtJ5kkXk19ywTSwilgLfH8xQawdmEBL4kf206AxVkEVCUeHHnHDGLzClhKvP+ziQXC
	FpQ4OfMJmM0soC3R+7CVEcKWl9j+dg4zxKkKEj+fLgObKSIQJrH063GoGhGJ2Z1tzBMYhWch
	GTULyahZSEbNQtKygJFlFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcMRqae1g3LPq
	g94hRiYOxkOMEhzMSiK8k25+TBPiTUmsrEotyo8vKs1JLT7EKM3BoiTO++11b4qQQHpiSWp2
	ampBahFMlomDU6qBac8Xx1WngyR77Tpf7nyc5hixz+2eSlrlzrm7PqmH7hRmOh+4dPb5vUrh
	uQGueSkSgkJz3moptBwzrj67aV2lcovr6e0WrIz131Pmct3VC9NfsPytzB3l9xv/75h/UOWo
	XizzYZazmhc3sOw72a05Y8diuyKm2tNs684cTt+d7+xgdU+rjavlaqmqh8PdK8b313ednHYu
	gMeWseb3tDt/Viq+W2bzT4P7YJlfycGTb/Vqrnr11P4L8f91LmXzCk/NOoYH2RND5h/OYD9y
	ud/kUKC2MUtz3+R60bV/duQGfltyfIpA+vcyfv9p2y8kRFpd6pmQG98/5fN/f6PGpblzFlkm
	BE44zLQ38b/as4vNXkosxRmJhlrMRcWJAFEqB0ZHAwAA
X-CMS-MailID: 20240925065459epcas1p3b8e701fd0228bc2670f22cf253a3b02f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
	<CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
	<20240829093913.6282-2-sh8267.baek@samsung.com>
	<fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>
	<003201db0e27$df93f250$9ebbd6f0$@samsung.com>
	<1845f326-e9eb-4351-9ed1-fce373c82cb0@acm.org>

> On 9/23/24 7:17 PM, Seunghwan Baek wrote:> That's because SSU (Start Stop
> Unit) command must be sent during
> > shutdown process. If SDEV_OFFLINE is set for wlun, SSU command cannot
> > be sent because it is rejected by the scsi layer. Therefore, we
> > consider to set SDEV_QUIESCE for wlun, and set SDEV_OFFLINE for other
> > lus.
> Right. Since ufshcd_wl_shutdown() is expected to stop all DMA related to
> the UFS host, shouldn't there be a scsi_device_quiesce(sdev) call after
> the __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) call?
> 
> Thanks,
> 
> Bart.

Yes. __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) should be called after
scsi_device_quiesce(sdev). Generally, the SSU command is the last command
before UFS power off. Therefore, if __ufshcd_wl_suspend is performed
before scsi_device_quiesce, other commands may be performed after the SSU
command and UFS may not guarantee the operation of the SSU command, which
may cause other problems. This order must be guaranteed.

And with SDEV_QUIESCE, deadlock issue cannot be avoided due to requeue.
We need to return the i/o error with SDEV_OFFLINE to avoid the mentioned
deadlock problem.

