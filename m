Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300E482D98
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2024 04:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731471731; cv=none; b=MbdfmX23s7g7j7uefkFcIvBXnfg2wmtjOv8N2og9w7zwgwg0IIvChFEkBLc9TTiSZ/OH/EzCazdlX/LZEI63XuaUbP6zc1PzWV6qXxATTyG93VPt8IwTDkbuxtIywXUHdqBtgihhsjVAlHpWvfSZf01cTGD9xmvpiYE3zMY+50E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731471731; c=relaxed/simple;
	bh=q9R/DTzH88eDeoG6jUbTuaEnX1sa6+QdvUZnMNserYI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=cLvsMZb8FoKl4fB/PhLlvnwV5Ko+eCJsQCgQ4WZXVQNfuN2Er6nxjEV5QR/QKrS5aJDcx5tiBl+lerArfWN/ZlWOn0Xm6HJ8hJZMGDy0MnDtE6t4PuuHR1E/591SIjNCE1dGsHCb0xre0sc+HUQo17EdYy0w4XSyiPugJA1VjVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hBPY76NQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hBPY76NQ"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241113042206epoutp0249026f76085bf53cfbeab090a2968588~HbFxy7UD72306523065epoutp02K
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2024 04:22:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241113042206epoutp0249026f76085bf53cfbeab090a2968588~HbFxy7UD72306523065epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731471726;
	bh=xAjZDWveay+STY/9uc+J7ivhLXMC5O7nHhCRmgSOse4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hBPY76NQsITVC6N4b/saYt/pbnbXAPsjHRAz0IQX+Kz9d/kFDQq4oLPglJB92WHjJ
	 WOx76ObxYRO3R3QwPBj5lvPeQizLuY5SKqUGQB76btp4zwf52HGx/FaY8NIAMA2MKd
	 f49TpfI/uIs4hF7AUD/oxEQ+mMDE4/iyktuIAJhU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241113042205epcas5p195b0f1698b5d478bb61adc7b7cd84c30~HbFw0AQ9W2749727497epcas5p1z;
	Wed, 13 Nov 2024 04:22:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xp997223tz4x9Q7; Wed, 13 Nov
	2024 04:22:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.86.09770.B6924376; Wed, 13 Nov 2024 13:22:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241112183746epcas5p40dcbbbd42a0f0be597193bf0808f8e67~HTHlnPWOf0159301593epcas5p4j;
	Tue, 12 Nov 2024 18:37:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241112183746epsmtrp27cbebe5839299ba7a5e8e2ea7682af9a~HTHlmuECI0915409154epsmtrp2y;
	Tue, 12 Nov 2024 18:37:46 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-4c-6734296b72be
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.F7.35203.970A3376; Wed, 13 Nov 2024 03:37:45 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241112183745epsmtip2c54646103fb7103fe1aeef9807177d88~HTHkvdhoO1071110711epsmtip2w;
	Tue, 12 Nov 2024 18:37:44 +0000 (GMT)
Date: Tue, 12 Nov 2024 23:59:59 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: remove two fields from struct request
Message-ID: <20241112182943.sitierdw7awtonxh@ubuntu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241112170050.1612998-1-hch@lst.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmhm62pkm6wYct3Bar7/azWaxcfZTJ
	Yu8tbYvu6zvYHFg8Lp8t9dh9s4HN4/MmuQDmqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMz
	A0NdQ0sLcyWFvMTcVFslF58AXbfMHKBdSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSC
	lJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjH3TG5gK/rBX/Fn3nr2BcT9bFyMnh4SAicTx
	z/+Zuxi5OIQEdjNKbHjzmAnC+cQocezaXVYI5xujRM+jZqAyDrCW24/jIeJ7GSUWrToE1fGE
	UeLeqdWMIHNZBFQlFs64DdbAJqAtcfo/B0hYREBJ4umrs2AlzALREt0bZ4DZwgJGEv8On2EH
	sXmB5n+cNZsVwhaUODnzCQuIzQlUM+vvOjaQXRICx9gl1q7vZ4T4wUWi6eQ7KFtY4tXxLewQ
	tpTE53d7of4sl1g5ZQVUcwujxKzrs6Aa7CVaT/WDHcoskCHx4agKRFhWYuqpdUwQh/JJ9P5+
	wgQR55XYMQ/GVpZYs34B1HxJiWvfG6FsD4mZX5dBQ66VUaJhzhnmCYxys5A8NAth3SywFVYS
	nR+aWCHC0hLL/3FAmJoS63fpL2BkXcUomVpQnJueWmxaYJSXWg6P4+T83E2M4NSn5bWD8eGD
	D3qHGJk4GA8xSnAwK4nwnnI2ThfiTUmsrEotyo8vKs1JLT7EaAqMnonMUqLJ+cDkm1cSb2hi
	aWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5MJ15LOC/kmu74u8fE9cnza
	tcLbzxI+TZud3HE8cCL3hPXsB6yun0zWnP3mdFMyP5dW7aV0JyN/6/1zdI6Ua4t4zjo4Nbj0
	SGOzVSvfs5UFKsXyLx2P+cgzbOxdH3XJhrXyoEzRqdlyl9NcmbKr9re8sQzvumFQv+fvsT0T
	ZhXyCqg2VcvdlXg0N2br1L99ec5F6Rf7lYMOtIoyzv566q7YjxM99UpdOv/O1szTVfeI3Vdz
	qnXD0t/yDjNEGZ86HShyFk33c1bSuGz8+pXiJunaO7NN9I5vf1M1PUpl6oKUR8s3cRhZKXbx
	VN9Y4jjvt8U0mRcid2Zc0/Qp1fUrFviUuvzI+RC1uODXX4pn31diKc5INNRiLipOBADMJuL8
	BgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvG7lAuN0g+87LS1W3+1ns1i5+iiT
	xd5b2hbd13ewObB4XD5b6rH7ZgObx+dNcgHMUVw2Kak5mWWpRfp2CVwZF9efYCtYx1oxr6uL
	uYGxm6WLkYNDQsBE4vbj+C5GTg4hgd2MEj0PQkBsCQFJiWV/jzBD2MISK/89Z+9i5AKqecQo
	cW7KT1aQBIuAqsTCGbeZQeawCWhLnP7PARIWEVCSePrqLCOIzSwQLdG9cQaYLSxgJPHv8Bl2
	EJsXaO3HWbNZIfYaSpz73MMCEReUODnzCQtEr5nEvM0PwcYzC0hLLP8HNp4TaMysv+vYJjAK
	zELSMQtJxyyEjgWMzKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDVUtzB+P2VR/0
	DjEycTAeYpTgYFYS4T3lbJwuxJuSWFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6Yklqdmpq
	QWoRTJaJg1Oqgcl3w7ZFHb9TV04v+z71wL+JJXu4RB6/XF0l8PB2batrl/kM/Wf5r65+/B7w
	/HXs9IXJDxPLhTj+/GB6PFeh+MXLIuWGuv0pB7Q5xAJmnfAwye9y9fgdHv3wpqjVHWmlyAlh
	0Zr2BeHTal58+bLIeaPim7sbLiQfqNpaGdjVHfRv18z1y2ep8SvUm1bY9ubPUNlaKe6ytGiJ
	QMSm3s3Na8W3WObztQYcNNrCfvkw36ordx2MVv3ROtSTapZwbMrZdvEj7EY8W/435+moHzAM
	fqNzWiVps3323vS2D8HCmY0H7X5UyM5aVvu1a/5zIY2AGoWT0pfXS+3wSvW9U3LiY//XUxP2
	7JkVlcR+3bxE0FiJpTgj0VCLuag4EQBAJKvRxgIAAA==
X-CMS-MailID: 20241112183746epcas5p40dcbbbd42a0f0be597193bf0808f8e67
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c3082_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241112183746epcas5p40dcbbbd42a0f0be597193bf0808f8e67
References: <20241112170050.1612998-1-hch@lst.de>
	<CGME20241112183746epcas5p40dcbbbd42a0f0be597193bf0808f8e67@epcas5p4.samsung.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c3082_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 12/11/24 06:00PM, Christoph Hellwig wrote:
>Hi Jens,
>
>this series removes two fields from struct request that just duplicate
>information in the bios.  As-is it doesn't actually shrink the structure
>size but instead just creates a 4 byte hole, but that will probably
>become useful sooner or later.
>
>Diffstat:
> block/blk-merge.c            |   26 ++++++++++++++------------
> block/blk-mq.c               |    5 +----
> drivers/scsi/sd.c            |    6 +++---
> include/linux/blk-mq.h       |    8 +++-----
> include/trace/events/block.h |    6 +++---
> 5 files changed, 24 insertions(+), 27 deletions(-)

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c3082_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c3082_--
