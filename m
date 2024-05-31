Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70C156C7F
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152593; cv=none; b=UeQRZJ4izOw1ZZc2K/UEqitKFI903LIRvmdctk7m8vWdmBzh3BLakw8cRKF7MABmq1UKjKgnSl7YUL3ZNekId5n9o8efiU/01wwMZbnG2CMwCQ0FPmPJFeepsk5i9l8t9gZDG1LSewUDg3EkHdI7IzLmHuv7k8EuF41KJRxpHFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152593; c=relaxed/simple;
	bh=PVahwFJO8LJfhi0Pb1DQm5Wbf1qUqfCUUYbU04fLMbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=QVHYBV7JAJp4F+3D2v663uY1ZdZMVz1v0kgLpBPEePAWsIbnsxJwa8Wb5p8czLuksgOrMF7TUeB8Yrivz4NC8pD+0KK/tuX5LdZQAGkrHALBYjkgdhWSMyqM2+eQMPXdGpddEJo4w3Ww42mA7e8lSQm3PrDAr5L3I7u7hO6tASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Jw2SrlVB; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Jw2SrlVB"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240531104949epoutp045dd3fb9737a8b29714921e693a996f03~UjS7E_bKr1362213622epoutp04w
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240531104949epoutp045dd3fb9737a8b29714921e693a996f03~UjS7E_bKr1362213622epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717152589;
	bh=AcrbxBR/K7PJ3gXtcaqiIgnaaJyMH+AxyYG1HcE+KEc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Jw2SrlVBe96l0VIwTvUvimolEx6xfoRrnxJpCIeeq+xahLWuXB1HPTfQXB2aBXnUk
	 jcczoDobfJdoFPEPi4GqUcV0n0vIF1eXI+Waom+UsQ4kv4S/ASNzbBzsG0fyobFtBy
	 NbNEVeS7gqHq2n27rZr+znmsUD2b/4Zo7gOsh3QY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240531104949epcas2p4242f84969dbb7efad96611fb0989253b~UjS6xhCtb2486524865epcas2p49;
	Fri, 31 May 2024 10:49:49 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.68]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VrKd85ysrz4x9Pw; Fri, 31 May
	2024 10:49:48 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.DC.09806.C4BA9566; Fri, 31 May 2024 19:49:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epcas2p31961bda5ee0eb313c0d9a7d63d5461ba~UjS5Ovjpm2726827268epcas2p37;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531104947epsmtrp1d4c5ca0f6ab041d6598a2556963eaf39~UjS5ODm9R2848028480epsmtrp10;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
X-AuditID: b6c32a47-ecbfa7000000264e-24-6659ab4ca463
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F6.83.08336.B4BA9566; Fri, 31 May 2024 19:49:47 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epsmtip1417f875e98bbe3be84cd9d52aa6dd9de~UjS49lsm00934709347epsmtip1J;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im
	<minwoo.im@samsung.com>, gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH 0/3] ufs: pci: Add support UFSHCI 4.0 MCQ
Date: Fri, 31 May 2024 19:38:18 +0900
Message-Id: <20240531103821.1583934-1-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdljTXNdndWSawYG1WhYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM+6c+sZasI694uD732wNjF9Yuxg5OCQETCQebJHpYuTk
	EBLYwSixcXN+FyMXkP2JUWLn5ufsEM43RomeSYeZQKpAGub++ACV2Mso8WjHRUYI5zejxLTb
	95hBqtgE1CUapr5iAbFFBKolNrf/ZQMpYhboY5Jonz2fFSQhLGAp0TT3EFgRi4CqxK7fi8BW
	8ArYSCx72MoGsU5eYv/Bs8wQcUGJkzOfgNUzA8Wbt85mBhkqIfCSXeLhu2Z2iIdcJCbssYHo
	FZZ4dXwLO4QtJfGyvw3KLpf4+WYSI4RdIXFw1m02iFZ7iWvPU0BMZgFNifW79CGiyhJHbkEt
	5ZPoOPwXag+vREebEMQMZYmPhw4xQ9iSEssvvYa63UNi49YDrJDAjZV4P2kS+wRG+VlIXpmF
	5JVZCHsXMDKvYhRLLSjOTU8tNiowhsdocn7uJkZwwtRy38E44+0HvUOMTByMhxglOJiVRHh/
	pUekCfGmJFZWpRblxxeV5qQWH2I0BQbuRGYp0eR8YMrOK4k3NLE0MDEzMzQ3MjUwVxLnvdc6
	N0VIID2xJDU7NbUgtQimj4mDU6qBye8VS94NkdjCaRvjnp2++LedlWOJur54+7zv9wvCd8z6
	+Vf/Yxir0sPziocCkhuqZbNeVu6aq2HJ9G7Rqh/bhJ3nqUUvO1z/kKEkasHGbEabLc8m90St
	Ug/tu+pyqLXhn6uVm76KTTy7fY7eNxfTH3KJ8hev+n+MX5A5s2b6xA2nmvtWNcXMD8tTyRHf
	1+30LcH+enLnNoPJL2d94uy4KLeHwzrs7dw9P7wW1SlOlU7et3KlxprzFhvyOHbG7WCKfnTO
	rDp5qcy1ee9kHn7d8nKRgUoJi2Zq1KfW0AV/WI+oRPGVVau+LRM5yfPXQyAtw6Q/OmFW43fl
	LkU/+8rb2WcyLzYZSN/7eC+9YG6mEktxRqKhFnNRcSIAkmwgtyEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnK736sg0g7XLjCwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgy7pz6xlqwjr3i4PvfbA2MX1i7
	GDk5JARMJOb++MDexcjFISSwm1Hi0YStTBAJSYl9p29CFQlL3G85wgpR9JNRYvekmSwgCTYB
	dYmGqa/AbBGBaonN7X/ZQIqYBaYxSSyaBdEtLGAp0TT3EFgRi4CqxK7fi8A28ArYSCx72MoG
	sUFeYv/Bs8wQcUGJkzOfgNUzA8Wbt85mnsDINwtJahaS1AJGplWMkqkFxbnpucWGBYZ5qeV6
	xYm5xaV56XrJ+bmbGMHBrKW5g3H7qg96hxiZOBgPMUpwMCuJ8P5Kj0gT4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkziv+ojdFSCA9sSQ1OzW1ILUIJsvEwSnVwLTj54eVMx7mRrsLFwlOOtO3aKpH
	73Vvo6v/lzS/Yb6XvTy8faOq+4yPupKzd8xe+1fZ/fC6Of+53+xru3JuwxsL49U/S/xXi79N
	nSL7Y3+AZM2t+w+lSye/X/t07cNlzAVKzw4emVRyt8+HQVDvps6GBQ7lfolGTp/Zpa6lOD1a
	d17m595IjzaRO3FTdNV+3etavlK1hq/mX9GnLUXBr/wiL+6Qen5S0rHn3LoV6cUHpn4LObSu
	eeuFB/52wSrhE69nKonPliteeWzrlRv2C1s4z5b32PJF/fGcoTGp1emrQeOybfUTdKID/s31
	t7/6x7KzeREj24aJfoX73FfYPfe3uihdGXK0Svh4nNf+bv81SizFGYmGWsxFxYkA9Bl6mtUC
	AAA=
X-CMS-MailID: 20240531104947epcas2p31961bda5ee0eb313c0d9a7d63d5461ba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104947epcas2p31961bda5ee0eb313c0d9a7d63d5461ba
References: <CGME20240531104947epcas2p31961bda5ee0eb313c0d9a7d63d5461ba@epcas2p3.samsung.com>

This patchset introduces add support for MCQ introduced in UFSHCI 4.0.  The
first patch adds a simple helper to get the address of MCQ queue config
registers.  The second one enables MCQ feature by adding mandatory vops
callback functions required at MCQ initialization phase.  The last one is to
prevent a case where number of MCQ is given 1 since driver allocates poll_queues
first rather than I/O queues to handle device commands.  Instead of causing
exception handlers due to no I/O queue, failfast during the initialization time.

Minwoo Im (3):
  ufs: mcq: Add ufshcd_mcq_queue_cfg_addr helper
  ufs: pci: Add support MCQ for QEMU-based UFS
  ufs: mcq: Prevent no I/O queue case for MCQ

 drivers/ufs/core/ufs-mcq.c    | 23 +++++++++++++++++
 drivers/ufs/host/ufshcd-pci.c | 48 ++++++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h          |  1 +
 3 files changed, 71 insertions(+), 1 deletion(-)

-- 
2.34.1

