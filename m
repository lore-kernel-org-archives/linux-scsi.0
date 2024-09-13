Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540581DA0E4
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726230968; cv=none; b=H7XijY0yZ8RCRPumh+TwaOXkQkQd1palFDE4PbRaMIKSxh+4ICIj567DlBR71dc1KmVu9QNlR6newev6VkC0OFGvKRphuSXIckCTyjedc9TcTZc5V9xgSFNqPB0ruUo+R5bEzhIxWoTBFETAFuIuCZxCvLN/llnzTdW/TT0FDMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726230968; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ksU0qKPbft6aTUbWqXWggIBstDQQY+r/vZNUCi7pkU3wWMEA4en0cttmlg6+d830KyJ1nDC1jv8NK2fWlETfd/coF2XyqFm2yTKwjJIP+23/Pi86jcoqP9d5Ubs54sChkMYwhzMkFsQu0C0nYJPJSDdbEF9i5Tn+wK051+rT8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JpMToKZ/; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JpMToKZ/"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240913123604epoutp0312b622c29b63b4dccd222255a0511bd2~0zep8LQtU3198331983epoutp03N
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:36:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240913123604epoutp0312b622c29b63b4dccd222255a0511bd2~0zep8LQtU3198331983epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726230964;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=JpMToKZ/9MC1YBuSnnr2sKuUENDIg04bbCqHZQ4SDCuo/3nD9XTRFxavBsUCnD7QR
	 tvFmgNBtTyQt/xm3HcS7l5UDF9lfdrhqmPUJUhbUPMTr7EKoPFkn32uDh8/xKo5xsZ
	 6xA4aitcSWpD6hPix56azpe6WUnjeXxe8qMwxVKo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240913123603epcas5p17e28ee5d1788b3de8fcfbd7faca8066e~0zepgRBUv1494614946epcas5p1U;
	Fri, 13 Sep 2024 12:36:03 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4X4v1G1c8Zz4x9Px; Fri, 13 Sep
	2024 12:36:02 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.B4.19863.2B134E66; Fri, 13 Sep 2024 21:36:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240913123601epcas5p481f7b43b2b6da457cd9809cd3a37a953~0zenlTQoT1633716337epcas5p4I;
	Fri, 13 Sep 2024 12:36:01 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240913123601epsmtrp2d0bb6ef22f35fc1667c945d6cff9a2db~0zenjFiZo1685416854epsmtrp2T;
	Fri, 13 Sep 2024 12:36:01 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-85-66e431b2eef3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0A.FD.07567.1B134E66; Fri, 13 Sep 2024 21:36:01 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240913123600epsmtip2acd710ea0852755d81334a8d3c097280~0zemPqafW0760407604epsmtip2C;
	Fri, 13 Sep 2024 12:36:00 +0000 (GMT)
Message-ID: <5965d703-4cd6-ae96-45ba-e7b3b80786e7@samsung.com>
Date: Fri, 13 Sep 2024 18:05:59 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv4 07/10] scsi: use request helper to get integrity
 segments
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, sagi@grimberg.me
Cc: Keith Busch <kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240911201240.3982856-8-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmlu4mwydpBs+Os1qsvtvPZrFy9VEm
	i0mHrjFanLm6kMVi7y1ti/nLnrJbdF/fwWax/Pg/Jot1r9+zOHB6nL+3kcXj8tlSj02rOtk8
	Ni+p99h9s4HN49zFCo+PT2+xeHzeJBfAEZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQN0m5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWn
	wKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+PUjqVMBUYV1+b2MTUw6nYxcnJICJhILDjaw9zF
	yMUhJLCHUWLLtmlsEM4nRok/OzexQjjfGCUmXJnPDNOy9O5hqJa9jBKLnm5jgnDeMko8ajsM
	1M/BwStgJ9GyvgakgUVAVWLTm90sIDavgKDEyZlPwGxRgSSJX1fnMILYwgKBEv8WTWAFsZkF
	xCVuPZkPNlNE4CSjxI4JVxkhEsoSnT0f2UHmswloSlyYXAoS5hQwl3h74R8zRIm8xPa3c8CO
	kxBYyyHxef0vdoirXSS+v/zNAmELS7w6vgUqLiXx+d1eNgg7W+LBowdQNTUSOzb3sULY9hIN
	f26wguxlBtq7fpc+xC4+id7fT5hAwhICvBIdbUIQ1YoS9yY9heoUl3g4YwmU7SHReHQtNNy2
	M0osPtHDOoFRYRZSsMxC8v4sJO/MQti8gJFlFaNUakFxbnpqsmmBoW5eajk8vpPzczcxglOu
	VsAOxtUb/uodYmTiYDzEKMHBrCTCO4ntUZoQb0piZVVqUX58UWlOavEhRlNgBE1klhJNzgcm
	/bySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpg0BF+a+M+alPO+
	yqw6rkmBe969z7b70pMdba2EFebOV1jqw3R9c+310OIvLvND1vk1N676k/zh64Xt+Tellmtu
	s+Y+PPW5uE2msgxjgpiAYUOs5L8g85viP2+rNZ3g3yRVKyHp/mlTqGIIf/SXxYcPnoz6uGNe
	9pauB0ZM5xS/Km9Yu+b/21mdummc5u/bJul4bY87I73CuX8m6xEPEc4TCrUHv0hut+tZGPRt
	wr7PibsFDokYvEhvfeEbEHGzolvaj+nD709PH5vknyzjCfZZrBAqpS/LuEzfqavxb+90u2mL
	lHg//dhvcOuFLcfm/T/aapPLH5jqmuc/WM//mJ1tT2jPvynpxV0+Fx/231JiKc5INNRiLipO
	BAAKOv4KQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXnej4ZM0g919ihar7/azWaxcfZTJ
	YtKha4wWZ64uZLHYe0vbYv6yp+wW3dd3sFksP/6PyWLd6/csDpwe5+9tZPG4fLbUY9OqTjaP
	zUvqPXbfbGDzOHexwuPj01ssHp83yQVwRHHZpKTmZJalFunbJXBlnNqxlKnAqOLa3D6mBkbd
	LkZODgkBE4mldw8zdzFycQgJ7GaU+HLvHzNEQlyi+doPdghbWGLlv+fsEEWvGSUerbzJ0sXI
	wcErYCfRsr4GpIZFQFVi05vdLCA2r4CgxMmZT8BsUYEkiT33G5lAbGGBQIl/iyawgtjMQPNv
	PZnPBDJTROAko8SzL9+YIBLKEp09H6GWbWeUWHr/EivIMjYBTYkLk0tBajgFzCXeXoA4lFnA
	TKJraxcjhC0vsf3tHOYJjEKzkNwxC8m+WUhaZiFpWcDIsopRMrWgODc9N9mwwDAvtVyvODG3
	uDQvXS85P3cTIzi6tDR2MN6b/0/vECMTB+MhRgkOZiUR3klsj9KEeFMSK6tSi/Lji0pzUosP
	MUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYJrCJCQ8lTPUPo75bR3Hhz93n+jVyQi9
	/7ZlV/GTqUsMrwv+mbxw889m7tthFuty3Z4YiJqd+yprLvS86NhNA68zPBM2iHpMfdm7es+d
	3XWa64+6ykyvmv/nkfj9FFV7G6XSkAcbHj9apPU5hF1zhna/jY9Hl1nHrA3JL/qNv+7vCp8b
	FvvTsd7x6IekWQsmHjS1ZGarNNr028tqxgfBtNQZMVWhs2Z92ByQGdZzdKbFsompR75uEuxJ
	7S+eGtDSa92fp95SfON92I0Df0T19I+t3rfyyu2L02c2XP40X3xB3V25O7K3BeI+MFyqD49f
	aNsrdX7RJpbgSEWGu0+utc6a1pl5RP/Jm7jCJZzOy0KUWIozEg21mIuKEwG7ZfjVHQMAAA==
X-CMS-MailID: 20240913123601epcas5p481f7b43b2b6da457cd9809cd3a37a953
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240911201422epcas5p363aa1666e6265a59d316bb6a10e7e3f4
References: <20240911201240.3982856-1-kbusch@meta.com>
	<CGME20240911201422epcas5p363aa1666e6265a59d316bb6a10e7e3f4@epcas5p3.samsung.com>
	<20240911201240.3982856-8-kbusch@meta.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
