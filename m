Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8C1D7E2D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726231042; cv=none; b=Xyis9bTkKoxQXjo7kKhd5US70W8mPxyhHZlB9hEdOFSTiMgijL6LcK1C2zEZ1ofNOq7h29KKIMLfTag2BAJgh29D/2ipHapezQEG8nhX35TCRGWxfzVGplJAYAdRPlBay7Ls+zhxO4xNASbDtSEEcG/mA88UFPPs8h1s+a3js1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726231042; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ueqe9pIKfW5tbLe+kvMR+e4alfECdTjtrdl79FZyg17VRrc40y9fYtJZDGlFSYNTqFHtNPIYwNu+R7QjLAVfs3VQWWBElmQLYRcABmfsrgtQ+vZQkyLiOKltcw/ihJ1zMsoFrpCcPS+FLg5BBLErBRdCwRQF7VVMBqwpP4MgwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KBJGUFTU; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KBJGUFTU"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240913123719epoutp04c17d7e2b9797ab8c42ddfbf777c29b35~0zfvske2o1936719367epoutp04D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:37:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240913123719epoutp04c17d7e2b9797ab8c42ddfbf777c29b35~0zfvske2o1936719367epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726231039;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KBJGUFTU3yu718W8MSFbbWST+QlGeHOQy6+x3YkkGYpDJyrGyYH7j/4yic6kpHqc4
	 34Sr3d9kuHWwEXTVnPVUn9ys8KTOUJTCDTcngOq1D4XeegC0txp82qz3Exzf2fHLGD
	 y7CP+llOnBpdfLqy4YYv5sMUfcm0AsmhRRKCqezg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240913123718epcas5p37b7b9498a251b23c18ae2be23c5d49b3~0zfu2saAe2105321053epcas5p39;
	Fri, 13 Sep 2024 12:37:18 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4X4v2h6Xz9z4x9Pw; Fri, 13 Sep
	2024 12:37:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9C.C4.19863.CF134E66; Fri, 13 Sep 2024 21:37:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240913123716epcas5p3d4b78a180b6aaa94a56022abc138f850~0zftIIuDp2105321053epcas5p33;
	Fri, 13 Sep 2024 12:37:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240913123716epsmtrp15585570f7957e30ee88d6806c30acdbb~0zftHbatx1470714707epsmtrp1e;
	Fri, 13 Sep 2024 12:37:16 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-f8-66e431fc2557
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6D.0E.07567.CF134E66; Fri, 13 Sep 2024 21:37:16 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240913123714epsmtip1b1f382043164a354f15901bc16cd4c24~0zfrXHB_H3163131631epsmtip1N;
	Fri, 13 Sep 2024 12:37:14 +0000 (GMT)
Message-ID: <443db159-684a-9b0e-7b05-ccfa9de2e032@samsung.com>
Date: Fri, 13 Sep 2024 18:07:13 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv4 08/10] nvme-rdma: use request helper to get integrity
 segments
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, sagi@grimberg.me
Cc: Keith Busch <kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240911201240.3982856-9-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmlu4fwydpBg//GFusvtvPZrFy9VEm
	i0mHrjFanLm6kMVi7y1ti/nLnrJbdF/fwWax/Pg/Jot1r9+zOHB6nL+3kcXj8tlSj02rOtk8
	Ni+p99h9s4HN49zFCo+PT2+xeHzeJBfAEZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQN0m5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWn
	wKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+PUjqVMBUYV1+b2MTUw6nYxcnJICJhI9BztY+5i
	5OIQEtjDKDHj9EpGCOcTo8TE1h0sEM43RolDv++ywbQcWHCaFSKxl1Fi4dY/UFVvGSU+vuwG
	q+IVsJPoefOfFcRmEVCVeP9qDStEXFDi5MwnLCC2qECSxK+rcxhBbGGBMImF19uYQWxmAXGJ
	W0/mM4EMFRE4ySixY8JVRoiEskRnz0f2LkYODjYBTYkLk0tBwpwC5hJHFt1lgSiRl9j+dg7Y
	QxICSzkk9hxezAhxtovE5wXtTBC2sMSr41vYIWwpiZf9bVB2tsSDRw9YIOwaiR2b+1ghbHuJ
	hj83WEH2MgPtXb9LH2IXn0Tv7ydMIGEJAV6JjjYhiGpFiXuTnkJ1iks8nLEEyvaQeH/6LDR4
	tzNKvHu2nXECo8IspGCZheT9WUjemYWweQEjyypGqdSC4tz01GTTAkPdvNRyeIQn5+duYgQn
	Xa2AHYyrN/zVO8TIxMF4iFGCg1lJhHcS26M0Id6UxMqq1KL8+KLSnNTiQ4ymwAiayCwlmpwP
	TPt5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwGUj8S/lQ9v3Z
	hqWbz69/9ao4veSHvuahzU1/zq0LWNCu8Mf0+tJjU/b3zgnnNLt07LlKwTvvf3MVAtwWa85b
	bPFjW+G9Zccz+9XDVnlm/vWdcnXvlIYX556mJ2y565h+1Enmkg77rnoBA98l7tfmBWpK6H5d
	JHl/afACif4vW5N7Hm6w/T+VW7ZnmlGoyszszO4tFm91l//dnj399tQQswUdij4+p87M6fn2
	fGf+t5P997/qramdwuZR01z2/crtv1ub12+xesuV+dt6Ycv8i3Eb3EszRFp8LtgcCRA7Jn2f
	IWzZe4Ej3WH7VWssz+h2W/lXhd1ierhbjO/+ZJvnS+un/c/6F5d/dmEh85P3dtOUWIozEg21
	mIuKEwGdr6YOQwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJTveP4ZM0g0kXuSxW3+1ns1i5+iiT
	xaRD1xgtzlxdyGKx95a2xfxlT9ktuq/vYLNYfvwfk8W61+9ZHDg9zt/byOJx+Wypx6ZVnWwe
	m5fUe+y+2cDmce5ihcfHp7dYPD5vkgvgiOKySUnNySxLLdK3S+DKOLVjKVOBUcW1uX1MDYy6
	XYycHBICJhIHFpxm7WLk4hAS2M0ocX7+TxaIhLhE87Uf7BC2sMTKf8/ZIYpeM0pM3H6HFSTB
	K2An0fPmP5jNIqAq8f7VGqi4oMTJmU/ABokKJEnsud/IBGILC4RJLLzexgxiMwMtuPVkPhPI
	UBGBk4wSz758Y4JIKEt09nyE2radUWLxoXVAUzk42AQ0JS5MLgWp4RQwlziy6C4LRL2ZRNfW
	LkYIW15i+9s5zBMYhWYhuWMWkn2zkLTMQtKygJFlFaNkakFxbnpusmGBYV5quV5xYm5xaV66
	XnJ+7iZGcHxpaexgvDf/n94hRiYOxkOMEhzMSiK8k9gepQnxpiRWVqUW5ccXleakFh9ilOZg
	URLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXAJHhKs0U/0HKq55qHKlLrQ2ufr1C9/N1w60pX
	Z8NiqRo3R6k9P5tOTfzCYZ93VCGSuUzqsCnz/Pl3n1Zan9V6EVqVsd7hY15Irqz1Ya290wTT
	tkQdONR++qStBccx55a9k1X/fl4yTT21kGW91uz0WXuNNjIKVjz/yXj/xmSZ9JhfKXekFI7u
	ZGUz2coVGP8nX3Hmx5hig83b0y8UFfK1H7vGOOWO9/PismXH62KEJEzdH5jOnLKId+qTtSv3
	vZbcefTN0muM/f+bb9mYb1zplXREvVb7P2symx2b4boHpqsemC1dxGzes15C4uphp0/BTre3
	iXiXtO8TE37gM6dr2wo5i6duGbdSbJ5WyteKKbEUZyQaajEXFScCAB9Jg5oeAwAA
X-CMS-MailID: 20240913123716epcas5p3d4b78a180b6aaa94a56022abc138f850
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240911201416epcas5p437d397b7ad0e863b4cf334d864db199c
References: <20240911201240.3982856-1-kbusch@meta.com>
	<CGME20240911201416epcas5p437d397b7ad0e863b4cf334d864db199c@epcas5p4.samsung.com>
	<20240911201240.3982856-9-kbusch@meta.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
