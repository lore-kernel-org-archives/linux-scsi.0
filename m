Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539C2C184
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 05:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724738363; cv=none; b=p4TtqX2ihD5Z8ut877ZRSy4VkANyWhA1X1jj7L08CKRhPsebYdPmslaXUQ7HZ3GvhBf8e0CGPtqZ/XExtGR4iOrPiNwrKQnQJNJYi/EiWiJDHgwP8B8V2fzvqEfU3kKh7hkHn4xy4zLMWCnv8qHzi25i4gACzvrrZaXIkWUAUNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724738363; c=relaxed/simple;
	bh=Hre8wBYDCVvotXtnF97F24g2/2YR0iei5Labiz0Unow=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=p0zoJqtHdwHqtmQLuoQkiTjEME+h4djQ+fyIs52oLcWn/2WomeriaVAjUZRwGjQAmbp+DT5UoDeo+I5HCbuj/yDU0yp6WJ+xYKHpHESs9ptED80jW0CZkfGZgV1nY0XDvDzfKyRbYpybK3ocriX6xJ/oMvSOO4cw/t3Vk6gZ4Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LLXifWvs; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LLXifWvs"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240827055918epoutp01e77fe3ec6a864b29e201f743c0550dea~vgGY9gOE91878218782epoutp01o
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 05:59:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240827055918epoutp01e77fe3ec6a864b29e201f743c0550dea~vgGY9gOE91878218782epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724738358;
	bh=fM2ZZjUmZEqvHp27jF4mHYFhw6+/7R4l50adstiCFsE=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=LLXifWvsW/UTlCzBrFLr79sICeEl270ho19okaJsQyXPl9YxyoeJyzBkHcJp/eUQA
	 NJvygaz6IBM8cLbdPEq9+dy9upQ5uAISDDiaoYp600qaGGcFHCaYHq/rpcvuSfJet5
	 BDDxNBV6a0MdujzJo2dETwUYs4LPg5df2qKss+T0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240827055918epcas2p295eaae3ca664a7feadd8f38d72edd7c3~vgGYobTyr2692026920epcas2p2m;
	Tue, 27 Aug 2024 05:59:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WtH1K6b4pz4x9Q4; Tue, 27 Aug
	2024 05:59:17 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	96.E3.10431.53B6DC66; Tue, 27 Aug 2024 14:59:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240827055917epcas2p478481ff43882695feadcbccc8a3f717b~vgGXeav7n2942029420epcas2p4w;
	Tue, 27 Aug 2024 05:59:17 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240827055917epsmtrp2f34f4629c8494a8813fc0290021a5200~vgGXb8RQ51041210412epsmtrp2D;
	Tue, 27 Aug 2024 05:59:17 +0000 (GMT)
X-AuditID: b6c32a45-da1ff700000028bf-24-66cd6b350ae5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	51.14.07567.53B6DC66; Tue, 27 Aug 2024 14:59:17 +0900 (KST)
Received: from KORCO164647 (unknown [10.229.38.229]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240827055916epsmtip25c771f2299472e6b6f1746ee8a52c87b~vgGXIpkt93243332433epsmtip2h;
	Tue, 27 Aug 2024 05:59:16 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, "'Bean Huo'"
	<huobean@gmail.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<beanhuo@micron.com>, <adrian.hunter@intel.com>, <h10.kim@samsung.com>,
	<hy50.seo@samsung.com>, <sh425.lee@samsung.com>, <kwangwon.min@samsung.com>,
	<junwoo80.lee@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <0ad83cb2-3835-4438-a7c3-398b1ff5798a@acm.org>
Subject: RE: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
Date: Tue, 27 Aug 2024 14:59:16 +0900
Message-ID: <011901daf846$401be4e0$c053aea0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMVAzAZ81RvDzfQ3MBmGZ181G9RyALYKPinAXreuMcBjvnKx6+XdaPw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwTZxzee3cch654FqbvGIFyzA1QoGW0PTYxLn6ki2zWkbBFstQLPUoD
	tLVXmJgtKeIHYDJAphkVDNCwZTBshgwRZvgMn2GZK8iHMiGCBEwdjlEGo2Ythxv/Pfm9z/P8
	fs/vfV8CFdrxAEKrM7FGHZNB4duwpq5wWaQ0fShVPDghoftnfsDpqRtNOD2/OoLTHdMFGH1t
	cRWlXQ/uedHlQ2aErrNOYXT1WBNCt7jyEPqnsTsYbW8px+nLo804/V3vC4SueeHA6Fu/ObGD
	pMI+fExxxzLprbD+PI8oiqvbgWLFlo8rns9OYIqvGmuBYqkhSHGp/TKi9DmZvj+NZdSsUcTq
	UvRqrU4TTx1LVB1SSWViSaQkjpZTIh2TycZThxOUkUe1Ge4YlCibychyl5QMx1HRB/Yb9Vkm
	VpSm50zxFGtQZxjkhiiOyeSydJooHWt6VyIWx0jdxFPpaQNOjcGMnPm1ohsxAzsoBD4EJGPh
	wkw9Ugi2EUKyGcD5gXFvz4GQ/BPAJx1hPHYCWH4v5KVg9e+/cF5wF8C8rg6UJ80DWPoo24Nx
	ci+8Nt3q5SH5k70oXLM6Nlx9yPeg9X495sF+ZCJsrbZuiDFyD7SdX3dzCEJAxsHrK596ygJy
	J+wvm9mgo2QwvO0oR/khRHB19lsvD/Ynj8KevAVvnuMPrxdcRD19ITlDwM6+aeDxhORhuF57
	gtf6wYXeRm8eB8ClZ3dxHnOwvnkE4bVmAOsWBjdJ70DLk0sbPigZDm0t0bxlKOye2BzNF+Z3
	ubz5sgDmXxTywlC4dqV0c8+vw7Lxh5uGCjjYNwmKQYhlS0jLlpCWLWEs//etBFgt2MUauEwN
	y8UYJP9ddIo+swFsvO6II82g1LEY1QkQAnQCSKCUvyDI3p8qFKiZnLOsUa8yZmWwXCeQurde
	gga8lqJ3fw+dSSWJjRPHymQSeYxULKd2C36/UKEWkhrGxKazrIE1vtQhhE+AGck5l/xLUvty
	UXXKo1sD4fEykj5bUjUH/8ktHat5/Kqt3b5De/JC0lXlTtvaNw97xp/2/RE9tfSsZkeFet1r
	SNzATca9EZCwlLD+wQh92hH4+K2ygptBOX7Fb4sm6lyCrNGQ7uPnWoM0B3+knhaOdiQOV6UH
	hyFEbeAJKFf2NlZc3Xt81/u3HaqGj/dUxaLbM7PBvty5L20C37bcSOWpJPOK9tDwmaqSwO/z
	PiSQnq9fwW2VbbrWT+ITfE/rK0YXI5aTxYbI8jflz4OLrkyEuR5MWT9f3q1BK887B1XiUOnc
	jUL17P2hZJ8DMdmMxRHhr9s+5/xsSmb5qLCtaGXfzdQjX1AYl8ZIIlAjx/wL6uhR1WYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSvK5p9tk0gz/nWS1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWsw528BksXrxAxaLRTe2MVns+tvMZLH1xk4Wi8u75rBZ
	dF/fwWax/Pg/Joul/96yWGy+9I3FQcDj8hVvj52z7rJ7LN7zksljwqIDjB7f13eweXx8eovF
	o2/LKkaPz5vkPNoPdDMFcEZx2aSk5mSWpRbp2yVwZZz6ll7QwFRxYe4RpgbGy4xdjJwcEgIm
	Ej9/fGEDsYUEdjNKPJnvCxGXlDix8zlUjbDE/ZYjrF2MXEA1zxkl+n6sBWtgE9CWmPZwN1hC
	ROAms8TerW+hqr4wSmz7/5wZpIpTwFpi8bW1LCC2sECgxNr+T2BjWQRUJda3/GHvYuTg4BWw
	lJj9PQIkzCsgKHFy5hOwcmagBb0PWxkhbHmJ7W/nMENcpCDx8+kyVhBbRMBN4ljzK3aIGhGJ
	2Z1tzBMYhWYhGTULyahZSEbNQtKygJFlFaNkakFxbnpusmGBYV5quV5xYm5xaV66XnJ+7iZG
	cNRqaexgvDf/n94hRiYOxkOMEhzMSiK8cpdPpgnxpiRWVqUW5ccXleakFh9ilOZgURLnNZwx
	O0VIID2xJDU7NbUgtQgmy8TBKdXAVMDm4Vp4u3rD+2vvu9hd47b0nYj62Owy9fimdx2f6m+X
	b3UU4AqXL7337XRq3UlrrZpNitenCVb8WstrVnbopb0ZZ/CW8K+9R2c3e9rLP3Kytt9YrxP3
	9nStg+u00FhJud8Ha3OCFBbtcKiMPnXG+fNWG4ZJZWf8uhY7tSR0fijtZFZ9c0G6MmxFv59g
	RN2v3oWbF/gqRfnmiNcHp3myVVwJthPI65d4Vc23Q+T2hgVbsg+V7QllmzNjZaISI/ddvqlq
	6x6eneIzXXG9x47IaCGvl+URGkX9iqklVbaV3LfVSibZJTZtq/Vfv5XLqbn2qe6BU7zi3bx/
	pF/61fBJbLULdpPZO6N63yutE0osxRmJhlrMRcWJACIsaA9JAwAA
X-CMS-MailID: 20240827055917epcas2p478481ff43882695feadcbccc8a3f717b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111247epcas2p2d3051255f42af05fd049b7247c395da4
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
	<cover.1724325280.git.kwmad.kim@samsung.com>
	<ed370c6355dee6a4af15587cdbb3b06a1fe0b842.camel@gmail.com>
	<0ad83cb2-3835-4438-a7c3-398b1ff5798a@acm.org>

> https://lore.kernel.org/linux-
> scsi/763ab716ba0207ecdad6f55ce38edf2d1bc7d04b.1724325280.git.kwmad.kim@sam
> sung.com/
> 
> Bart.

I included you but sending the patch set was blocked.
Sorry. Let me fix this as soon as possible.

Thank you.

