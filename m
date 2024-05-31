Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560B41581F0
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 11:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717155478; cv=none; b=VoADl5ZQovaZ2qtsnb/oTj+V2DPp4Iuvr4Y9twN/2Q5WpRmYgSRLQalZS5k0xx/o/Pl4kTd5qpPqOWAWuAznf3DgKoo1HV3jPUi4wxiv+bWHH+wHhyA+wnHdywhasRLqSWgPBKy+jJd84nM8on9mSoKMQ2+JIAN8BublVmyvd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717155478; c=relaxed/simple;
	bh=THrE+/sZtzSDy9OBDWLrHreDPEvs8+hPGcLMTvkZoCM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=LtM8zmt0zA+8Io8yKt8nBdlhY4FdmNE4+tECIvzWipKSywg47dsQI4JM+h+nhlLPQLBP4ZWuGCduvXcjqGJ6gesF3JBKJKMUOyKNcx/GmEks4vyi22vWaNwyGbTuid2QDXGgkb7ld88KxRq7cf5VGh1vP9cNC8U+fKf1ks8xnPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sRleW/Ko; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sRleW/Ko"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240531113755epoutp0433a4baa3d5936eb41046b22882331c8a~Uj86t23e42451324513epoutp04T
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 11:37:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240531113755epoutp0433a4baa3d5936eb41046b22882331c8a~Uj86t23e42451324513epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717155475;
	bh=Y0VkJe20fMinBlmQK31o7n10A9UqotHuj7Gyw5qxaTQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sRleW/KoTf36lPqWsVssBbgWRUwgJKB+m6Dbwqh+uMUhgrg0M4BXwNNDnk/cUHi8I
	 iVmL+eUijzT1lGesNcZ4YRq1L/gz8j6q81Q/1LsogkscxitQG3Bi/mzIOAm2DtjXXu
	 lU0IBsv3w3WhomYH3Tr5N8omlXy2FkNMIAVlKOsQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240531113755epcas5p271b8ac6d7e7f1402241b70b4a7ee73b2~Uj86NVzG_2148421484epcas5p2O;
	Fri, 31 May 2024 11:37:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VrLhd3fPBz4x9Q0; Fri, 31 May
	2024 11:37:53 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.E9.09989.196B9566; Fri, 31 May 2024 20:37:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240531110559epcas5p1f41d7d904ed46260837c38a57fa32d86~UjhCSqWw21511815118epcas5p1x;
	Fri, 31 May 2024 11:05:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240531110559epsmtrp2e32c4ef6effff2d97c7dd8e4c00c8f46~UjhCRz5O50896008960epsmtrp2m;
	Fri, 31 May 2024 11:05:59 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-ed-6659b69163db
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.22.07412.71FA9566; Fri, 31 May 2024 20:05:59 +0900 (KST)
Received: from nj.shetty?samsung.com (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531110557epsmtip1d7d4153c068ec15012f898a1f6bb80b2~Ujg-zJJlx1968819688epsmtip1t;
	Fri, 31 May 2024 11:05:56 +0000 (GMT)
Date: Fri, 31 May 2024 10:58:56 +0000
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Richard Weinberger <richard@nod.at>, Anton
	Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg
	<johannes@sipsolutions.net>, Josef Bacik <josef@toxicpanda.com>, Ilya
	Dryomov <idryomov@gmail.com>, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, Bart Van Assche
	<bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 14/14] block: add special APIs for run-time disabling of
 discard and friends
Message-ID: <20240531105856.nkr2gbyhwbzoqycs@nj.shetty@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240531074837.1648501-15-hch@lst.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTdxT2d297ubCUXSrLfmBk7CrJxAAtj3oxPOYg5G4QJFM3N3R4pZe2
	AdquD3FbNmDYOFh4yQbYMKaB8aiCWh6BkYYNRcTBWATH6CaCkaDAttYyCI/BWloW//vOd74v
	J985OTjKX8J8cZlcw6rkTBaJeXA6b+57Lai8870MQdcjb2qh+gaHuvKgFKMqLSsoZZm4gFBT
	vbFUZe0YoJqv9CPUw9rzGGW9/oxDrU8LKZN5P/XleBdGFRuSqMaBDYRam2lBqIruBUBVj9Rx
	qeX2CuR1Pj06lkjPNjeg9HxFGaB1HS/Q3foHbvTosJY2Ggoxuq0+l75pGePQPRN5GD1R+yFt
	nTFz6PtLBShdWtzJocvabnBpm9EvhXg/M0rKMmJW5c/K0xVimVwSTSYeSYtLixAJhEHCSOoA
	6S9nstloMj4pJShBlmXPSvqfYbK0diqFUavJkJgolUKrYf2lCrUmmmSV4ixluDJYzWSrtXJJ
	sJzVHBQKBKERduGpTOm9tUU3ZQd+1tzyI8gDdW5FwB2HRDhsGOzhFgEPnE/0AJjf0w+cxTMA
	68yDbs5iCcDvikeQbYt1sszVMAF4a7KF4yxsAG7038YcKg4RAKe6yu0NHMeI/fCnTdxBexMk
	nJkb3hqBEjoufLo4t6XfSZyG1k0T16HnEXGwseqQg+YRXnDw4mOOA7sTYdBQv7g1CxLn3eG5
	yT9dIeJhd9VVrhPvhHMD7S7eF9r+MmFOnAObv2rCnOZzAOrH9cDZiIW6u6WoA6OEFFavXXaZ
	d8Ov77YiTt4TFq89dsXnwa7abbwHXr12yTXAB/66nO/CNLTMr6LOrbQCeN1QgZQBP/1zifTP
	zXPig7DQ8jlXb18ASuyCjRu4E+6D174PuQS4BuDDKtXZElYdoQyVszn/nzldkW0EWw8Q+FYX
	mJ6yBPcBBAd9AOIo6c1blRzP4PPEzEcfsypFmkqbxar7QIT9QOWo70vpCvsHyTVpwvBIQbhI
	JAqPDBMJyZd587pvxHxCwmjYTJZVsqptH4K7++YhHSer3wno4e0eHD42qes13DF278DiUh8N
	FwR85hXvY17dADtqPrgvMY28KZAFno2KzIz9Q2+NIzMSjtj89giDE6QPiW9tu4zJMo+qA9MT
	fUdVw/+shsyOHq3R1jwdvNcEBfxjo0MliYrb3XkrQqlR2LhUkJBSWKFV0L/s1Yz//vfpIpnn
	cVHUiaaYn9enSwrMVP18v2IZv3PSo58lLlcmLOTWVVvnRg79+8OpTzdtQ8FjI7Nvn3j1iwut
	mDwsp3DtE8+2lVtuTKpgInkqKWAgn3fxTC5oafCDEbNPyqPEpld6X0z+bTT2yfpsUGP74VDZ
	u/mrlqCSN1K1GUO6wJgNr0WSo5YywkBUpWb+Axp6BGqJBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnK74+sg0g/P7lS3ezNjIYrH6bj+b
	xbQPP5ktPtycxGTxYL+9xbR5VxgtVq4+ymRxf147m8XHDZ9YLP48NLTYe0vbovv6DjaL3lU+
	FsuP/2Oy+P10LZPF5J1vGC1mnF/MavF9y2QmByGPy1e8PZ6vXMbs8XryBEaP1q3cHjtn3WX3
	uHy21GPTqk42j81L6j0Of7jC4rH7ZgObx815hR4fn95i8bj6rZnZo793G4vHhM0bWT0+b5IL
	EIjisklJzcksSy3St0vgyni1eC1jwXPWiua1U5kbGN+zdDFyckgImEh8vDeBvYuRi0NIYDej
	xKknx9khEpISy/4eYYawhSVW/nsOVfSRUaJ54XuwBIuAqsSDHROBJnFwsAloS5z+zwESFhFQ
	knj66iwjSD2zQC+rxOIfP9hAEsICSRIf/+9lBannFXCWWD7dEcQUEoiSmHKID6SCV0BQ4uTM
	J2C3MQuYSczb/JAZpIRZQFpi+T+w6ZwCxhKrlnxhmcAoMAtJxywkHbMQOhYwMq9ilEwtKM5N
	z002LDDMSy3XK07MLS7NS9dLzs/dxAiOWC2NHYz35v/TO8TIxMF4iFGCg1lJhPdXekSaEG9K
	YmVValF+fFFpTmrxIUZpDhYlcV7DGbNThATSE0tSs1NTC1KLYLJMHJxSDUyKXO06JsGVEbsN
	/lRpNHncfb3f3UvXvv7y/cfXXtyZrC3Q9fFlgfhNZy1ds+drd0Zrs5s/62esPHHEVoJ1Edu7
	DxGTz4mfKVtYVp1fNneh4IZtJW9WV76yneTVHmvScyg41//yK91jFUwRYo2mYamCkuxKZuoW
	Ly3mMSquWMZR8CnJvZz3AEfBbNZix1bD/XEpwYLT+p4Xm788eOvjNO4Fisb3+Tj2vSvOYCgr
	Lz9iLqTsdJE/hq+q6m3zx7LYVakVfPU56iVxyql7Jnn/3yKkf0a65FdYWJtTw8m7Jxdav9bJ
	Pfpo9+b7x9N/z3Sr4Ez1zOebG9xpzS6n4tXvfshMLlHSif/fmSeqZRxKLMUZiYZazEXFiQDh
	esZKRwMAAA==
X-CMS-MailID: 20240531110559epcas5p1f41d7d904ed46260837c38a57fa32d86
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Fualeei1.f5fhWGYL679EBd0hH5-OLgtfrOtH6wInDZGwDEe=_482db_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531110559epcas5p1f41d7d904ed46260837c38a57fa32d86
References: <20240531074837.1648501-1-hch@lst.de>
	<20240531074837.1648501-15-hch@lst.de>
	<CGME20240531110559epcas5p1f41d7d904ed46260837c38a57fa32d86@epcas5p1.samsung.com>

------Fualeei1.f5fhWGYL679EBd0hH5-OLgtfrOtH6wInDZGwDEe=_482db_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 31/05/24 09:48AM, Christoph Hellwig wrote:
>A few drivers optimistically try to support discard, write zeroes and
>secure erase and disable the features from the I/O completion handler
>if the hardware can't support them.  This disable can't be done using
>the atomic queue limits API because the I/O completion handlers can't
>take sleeping locks or freeze the queue.  Keep the existing clearing
>of the relevant field to zero, but replace the old blk_queue_max_*
>APIs with new disable APIs that force the value to 0.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>---
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------Fualeei1.f5fhWGYL679EBd0hH5-OLgtfrOtH6wInDZGwDEe=_482db_
Content-Type: text/plain; charset="utf-8"


------Fualeei1.f5fhWGYL679EBd0hH5-OLgtfrOtH6wInDZGwDEe=_482db_--
