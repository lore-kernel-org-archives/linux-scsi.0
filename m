Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85BF1DA0E4
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726230847; cv=none; b=Lc6RG2zlw4yWUbGE1CyKTFILLDImHp4xnrklz7dj7oLeo0WF1bPxpx0JWe96iwyUiXKjCdRjx2HxpxyDIPtryqPxO0NRklGomS/r15yH53V+rdS5v9RhNfRRC4kMRdTPV8/hw9VoahO+VnUH8lHbXLKyS6zMSYEavgSuhVajLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726230847; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Lz+o5PehAGnChj+EJKealhoZHWu8bttQFNrv2TqHiYaqmgI2senKz1XqH7pbZJyraw8EC7tEkUMkutU9HEpl322H5wJqWnoEDaAUsiMHQkDvYxy+sfj7QxVfhDqBkz8yJo9HgGJ6xhuK7vqpIDYOeauAIwRA57EpG45sJMNZFY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MBRb6g8s; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MBRb6g8s"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240913123355epoutp04abd7b733058a538fbd4f5119564eaf79~0zcyOZ4oD1644616446epoutp04Y
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 12:33:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240913123355epoutp04abd7b733058a538fbd4f5119564eaf79~0zcyOZ4oD1644616446epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726230835;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MBRb6g8sT1ktQyi4DmncwqaE6fSFrjnm8Ga0VO+xCufWCWn8hqYC9KW74xXwl5dSr
	 h/d0D+lQoNbijpm70W1GNXW3usbf5rfotwMO06YyIs2qj00nrkI5VlKhohuyNL8maz
	 oun2EeOMREP38j2wDiPh1rKoVLnEqkNYeUYFBU8k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240913123354epcas5p4bb058553c09e6883fbe141af0b27f2bc~0zcxm8hbc0204402044epcas5p4L;
	Fri, 13 Sep 2024 12:33:54 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4X4tyn5Jfnz4x9Pw; Fri, 13 Sep
	2024 12:33:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.F7.09743.13134E66; Fri, 13 Sep 2024 21:33:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240913123353epcas5p4976f0b6db7bfc557eb7f6b7630122e46~0zcv_Vnru2094120941epcas5p4R;
	Fri, 13 Sep 2024 12:33:53 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240913123353epsmtrp2db5accb13158447798a731232e2a2673~0zcv9uf6X1555615556epsmtrp2d;
	Fri, 13 Sep 2024 12:33:53 +0000 (GMT)
X-AuditID: b6c32a4a-14fff7000000260f-a0-66e4313106b9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	7A.41.19367.13134E66; Fri, 13 Sep 2024 21:33:53 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240913123351epsmtip15a51dd22ee25357c93be15e0231fc13b~0zcuq2u7W3163331633epsmtip1E;
	Fri, 13 Sep 2024 12:33:51 +0000 (GMT)
Message-ID: <33cb5c6b-66cf-3c3d-774a-5d3e40032368@samsung.com>
Date: Fri, 13 Sep 2024 18:03:50 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv4 05/10] block: provide a request helper for user
 integrity segments
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, sagi@grimberg.me
Cc: Keith Busch <kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240911201240.3982856-6-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmpq6h4ZM0g/fn1C1W3+1ns1i5+iiT
	xaRD1xgtzlxdyGKx95a2xfxlT9ktuq/vYLNYfvwfk8W61+9ZHDg9zt/byOJx+Wypx6ZVnWwe
	m5fUe+y+2cDmce5ihcfHp7dYPD5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAG6TUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJT
	YFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXFqx1KmAqOKa3P7mBoYdbsYOTkkBEwkLv75y9bF
	yMUhJLCbUeLFqQ/sEM4nRol/K74xwTn7/i1mg2vZ9pQFxBYS2Mko8XKfPETRW0aJ/W/fsoIk
	eAXsJP5PWgDWwCKgKtF0aR0zRFxQ4uTMJ2DNogJJEr+uzmHsYuTgEBaIktj4RxUkzCwgLnHr
	yXywxSICJxkldky4ygiRUJbo7PnIDlLPJqApcWFyKUiYU8Bc4viWHhaIEnmJ7W/nMIP0SgjM
	5ZDo3/adBeJoF4m5xy5BPSAs8er4FnYIW0ri87u9UPFsiQePHkDV10js2NzHCmHbSzT8ucEK
	spcZaO/6XfoQu/gken8/YQIJSwjwSnS0CUFUK0rcm/QUqlNc4uGMJVC2h8SfC+8ZIcG2nVFi
	e1PGBEaFWUiBMgvJ97OQfDMLYfECRpZVjJKpBcW56anFpgVGeanl8MhOzs/dxAhOtlpeOxgf
	Pvigd4iRiYPxEKMEB7OSCO8ktkdpQrwpiZVVqUX58UWlOanFhxhNgbEzkVlKNDkfmO7zSuIN
	TSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpg8li1dD6P4NrGB0X29n+T
	MiUzPG7yO1RXZS+b+2dz49uXjf9UmCd315vtkCh8bvz80GXTNyutluh2bRBT6DZdJrxDmdvr
	S9ShM6cWbduy12CKL89sOxVR45IP/2vbf6Ur21kLq8YbGKxTvtCyd+2r9F/2jp8fBZy6fvBv
	nnna2TDNOcrbbX999BY+8Mh3ShuzPGvlo0SmTTLKTT8dnhgu7b0uutxRsLe/XUytfqLwacaj
	xxavnr3lZKfLkYOrnOZnx/8/L3R1TXApc9eau6muM84tOhJ4Z+6frY8lb2y9YXbgxHEZVp6n
	S9JOsEm0KNnHuDx06PLf0qRoPHFFw5OZZ58Vp0hH7bm84s+lSgb9U0osxRmJhlrMRcWJAABB
	Jos/BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJTtfQ8EmaQc8UDovVd/vZLFauPspk
	MenQNUaLM1cXsljsvaVtMX/ZU3aL7us72CyWH//HZLHu9XsWB06P8/c2snhcPlvqsWlVJ5vH
	5iX1HrtvNrB5nLtY4fHx6S0Wj8+b5AI4orhsUlJzMstSi/TtErgyTu1YylRgVHFtbh9TA6Nu
	FyMnh4SAicTFbU9Zuhi5OIQEtjNKXL7/iQ0iIS7RfO0HO4QtLLHy33N2iKLXjBK/z75iBUnw
	CthJ/J+0AKyBRUBVounSOmaIuKDEyZlPWEBsUYEkiT33G5m6GDk4hAWiJDb+UQUJMwPNv/Vk
	PhPITBGBk4wSz758Y4JIKEt09nxkh7uoq7mHBaSZTUBT4sLkUpAaTgFzieNbelgg6s0kurZ2
	MULY8hLb385hnsAoNAvJGbOQ7JuFpGUWkpYFjCyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3
	MYKjSitoB+Oy9X/1DjEycTAeYpTgYFYS4Z3E9ihNiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9y
	TmeKkEB6YklqdmpqQWoRTJaJg1OqganxZF/xigs5cx9c3rlIxb5s2j496Q29M593Sd+Vnh2S
	/FfLSOB9YNm1HGHlzcJaj1TdE4sULX+1e5pbyzasyL4ot++WlNcqx50tXK49K6008qOUXff/
	Z1rC5e9l1Wm7SWd6W0EhL9skzX8L3BgOvl9cVFlU0MMof/iEeOeeLbypRZkq5RvfJZck+umc
	ujiBr3D9llf98nddmY4abBI/2X1Tt86au6ODpU+ypprBN22Hzdc5yzwtYh9NPrn/Xva80OUN
	PZ1+sktyIrW3HumIWz251eVyIUvnJPV1Kzf7LONgFbZb7yA0p8DezugV15O/CaZda303zb8p
	pB2pIvd5y+zdp5bEtPUlGLF6GyopsRRnJBpqMRcVJwIAoHouxhkDAAA=
X-CMS-MailID: 20240913123353epcas5p4976f0b6db7bfc557eb7f6b7630122e46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240911201420epcas5p1e1a323b12f168dd6bed0583d58938e69
References: <20240911201240.3982856-1-kbusch@meta.com>
	<CGME20240911201420epcas5p1e1a323b12f168dd6bed0583d58938e69@epcas5p1.samsung.com>
	<20240911201240.3982856-6-kbusch@meta.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
