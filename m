Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F541F03D2
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160470; cv=none; b=d1SxSlQ93gx3q//b03H5L4JvOr/va0/Ek5PCMOlLtQ3Z1sbeiYxUQH0rQGArau6lBQYw+7HjnLS95buoQf8dqDJ5UnYE1lkRbEAD7UPUVl6m/kqUN5lqavILVXB4oeRECGYrp5OWsswq6nyDiVuKgVdMNxL9IZpsk9KLRIiBgvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160470; c=relaxed/simple;
	bh=+0v9asLaBPRNl7EokrcaYWNtIFxIhxzqEMJXvGxnmdE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Kgv573gJsCBgShnkJM7A2WeWgtmPnWZHe4osdXvQK2n2A8q2cQLCyt8UpSIzJTwkUaqtpfZYyfeoDDXFe+J5yJI2dCpgkFIcAp6j3uxys+QECFbyslh8haoZLDziWYx4OjzWuXko9R9SFxHrGqeJHKoP7wkq/nOwtCrjFVAfvos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BCUqLNUg; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BCUqLNUg"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250305074105epoutp0349bebedf2068ccb9042dcf2a3841f8c5~p2Dfs050i1930219302epoutp03E
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250305074105epoutp0349bebedf2068ccb9042dcf2a3841f8c5~p2Dfs050i1930219302epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741160465;
	bh=TqTMIzOu/gxWCqxo2RhLijjV18qKrUTqkY9kGAPDnjc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=BCUqLNUg3AQK+eFt6t3zq1DmCGkSiH2rEkVbmJo9nlExtaG6GgbD/D8NotUIAPcq1
	 eoC/j+cPhBEaigpK/lyaqE9OsrWr+LjUk+9hZaS5mw/DmqMwwPxUAFfWUOuabBWa0t
	 We31/fyZ+gyQyRuApQfOEf6jcaqGFhMcq2otF7bc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250305074105epcas5p2ea7197f1fa88dd7766f2a65ad5139f88~p2DfFpRxB3180831808epcas5p27;
	Wed,  5 Mar 2025 07:41:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z74H33PL7z4x9QD; Wed,  5 Mar
	2025 07:41:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	58.1E.20052.F0008C76; Wed,  5 Mar 2025 16:41:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536~p1NSb-V4G1936819368epcas5p3U;
	Wed,  5 Mar 2025 06:39:00 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250305063900epsmtrp2d7a9c79c37c0042a29392c21b8b0893f~p1NSVvIPN0758807588epsmtrp2B;
	Wed,  5 Mar 2025 06:39:00 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-0a-67c8000ff15f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.53.33707.481F7C76; Wed,  5 Mar 2025 15:39:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250305063858epsmtip1ca541a816175f86a904b65b74ee49cf7~p1NQ6wL351091010910epsmtip19;
	Wed,  5 Mar 2025 06:38:58 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v3 0/2] Fix integrity sysfs reporting inconsistencies
Date: Wed,  5 Mar 2025 12:00:31 +0530
Message-Id: <20250305063033.1813-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmhi4/w4l0g4MfJC0+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8XeW9oW85c9Zbfovr6DzWL58X9MFncvPmV24PLYOesuu8fls6Ue
	ExYdYPTYvKTe48XmmYweu282sHl8fHqLxaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ5zs28lWcI+14vzzI+wNjI9Y
	uhg5OSQETCS23dvICmILCexmlNi03RLC/sQosWJZUBcjF4S9+/9LNpiGuzN/s0IkdjJKXF15
	ng3C+cwo8ezMN3aQKjYBdYkjz1sZuxg5OEQErCXevxYHqWEWOMso8bfxP9hqYQFXiX9nl4Gt
	ZhFQldh47ysTiM0rYCGx/uBSqPPkJWZe+s4OEReUODnzCVicGSjevHU2M8hQCYGv7BKTtnUz
	QzS4SFy+v5MRwhaWeHV8CzuELSXx+d1eqBfSJX5cfsoEYRdINB/bB1VvL9F6qp8Z5GhmAU2J
	9bv0IcKyElNPrWOC2Msn0fv7CVQrr8SOeTC2kkT7yjlQtoTE3nMNULaHxO5ra9ghQRor0XXk
	F/MERvlZSN6ZheSdWQibFzAyr2KUTC0ozk1PLTYtMMxLLYfHa3J+7iZGcGLV8tzBePfBB71D
	jEwcjIcYJTiYlUR4X586ni7Em5JYWZValB9fVJqTWnyI0RQYxhOZpUST84GpPa8k3tDE0sDE
	zMzMxNLYzFBJnLd5Z0u6kEB6YklqdmpqQWoRTB8TB6dUAxNLn7Hor/8zNW+nbpNn/JFi1rfx
	su/kuSL3s/0efViY1vDoxu/prNdnrC/n/CcpHXhuEW97uNGe9Emb7pfc1tF1E+X/4LPQfcPZ
	Iw/SbS6kPFcOYu/wP2az8Oj97S3HJz/8kvBxsdKJ951/p1ny194M2yLFG5+Rf3sFi2RWxOI1
	f+pvGE37wX0kxFRt7+Ir6oGp346qWzxtf7IqJLyu/kexcXDLvrUvfTlXpf5huZrxbYq67xar
	fqvg+AMuHz5o36ic99apaHZaWuvUC5dj56Q0O0ilLmTap/WBT3FTabn+qcSbFQE3i0Mm3Kr1
	jA+pO2DTGJzRpLnoWeDXWul3imbr5izdkOzHfkfmySuTlulKLMUZiYZazEXFiQAmnHv6NQQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnG7Lx+PpBtdXSVh8/PqbxaJpwl9m
	i9V3+9ksFiyay2KxcvVRJou9t7Qt5i97ym7RfX0Hm8Xy4/+YLO5efMrswOWxc9Zddo/LZ0s9
	Jiw6wOixeUm9x4vNMxk9dt9sYPP4+PQWi0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBlnOzb
	yVZwj7Xi/PMj7A2Mj1i6GDk5JARMJO7O/M3axcjFISSwnVFizuoWqISExKmXyxghbGGJlf+e
	s0MUfWSUuDLzCViCTUBd4sjzViCbg0NEwF7i3o8KkBpmgcuMElNefWEFqREWcJX4d3YZmM0i
	oCqx8d5XJhCbV8BCYv3BpVDL5CVmXvrODhEXlDg58wlYnBko3rx1NvMERr5ZSFKzkKQWMDKt
	YhRNLSjOTc9NLjDUK07MLS7NS9dLzs/dxAgOb62gHYzL1v/VO8TIxMF4iFGCg1lJhPf1qePp
	QrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxSDUwq7W53LHep
	3w2aI7Z3EQfjvbNiCYzN8xqMP+o93tfk7XTL/gtD6bUMufnhATv+Ts4Q+bOs8ir/mYLT6X8W
	z/QXnJ8jt0wo1+WNvnnN5+xEyVf70nL5BMTPRh4NSHqu+LFnQr7hSk72+pCH+hYGUcId9oy8
	JX98ulw9inidSs6IbnOrWun3o9Kvb//+tva23BMa103MlxbpWj1fp/t/8rFLM/i7LhUVTjrF
	o2Vi87z97ap1DOJGsXdnF2tcimkIqd5741vP4YM3frcd/K28+ip7p71T7xzRpdxLFJMnmq6c
	HK+xUHjWu+WrmG44sN/W07WdYijJ2lmY+qHDKCZV8+Lx3hj1XrtHNvKz7grdVWIpzkg01GIu
	Kk4EAJFyOqTeAgAA
X-CMS-MailID: 20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536
References: <CGME20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536@epcas5p3.samsung.com>

Patch 1: Ensures DM devices correctly propagate
device_is_integrity_capable
Patch 2: initialize nogenerate and noverify correctly

Changes since v2:
Ensure that integrity capability gets propogated correctly for all cases
in DM (hch)

Changes since v1:
initialize BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY in
blk_validate_integrity_limits rather than doing it in the driver (hch)

Anuj Gupta (2):
  block: ensure correct integrity capability propagation in stacked
    devices
  block: Correctly initialize BLK_INTEGRITY_NOGENERATE and
    BLK_INTEGRITY_NOVERIFY

 block/blk-settings.c | 51 +++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

-- 
2.25.1

