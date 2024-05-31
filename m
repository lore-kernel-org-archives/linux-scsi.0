Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2178C89
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191272; cv=none; b=gT7mQdXpDmL/pIzKZw4g7+Uk977AlsOs6IQChjAYCOdnZTXw6Mlf5qcogk5kQvZu8E6Pn5SbAnzQYIHOSupSJQ6BO4Ex4m+nEg6U5IkqUQHT3IXkviN4M4x0r68uO/FZt5zfyNaD8mA+IfPOtSZSVZo8h2Yc9kF3B9j+x6yRZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191272; c=relaxed/simple;
	bh=Y7uG4pwdtEkmmnK3J+jlUy6sLyQYuEF3zOYH+EVSXTg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=aYjegEHVWG1auym9d4ePEs/RzoOcLxj2gKMAH6LpPEAOxZBqnCJxgD3QbtK/YnDZZnQSvG4V94HFd2lvPwI/fmNXGe07Esmf3glu8xaSCdsL7CkzWyMEgSJXvXCB73/MQD1QOGrrMe/FadfQ2PGTDivQCwDiIsLM/xfnbuCLKCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tEJLx/Cj; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tEJLx/Cj"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531213428epoutp03ebfef3836d8da2a72cbe514936f93ff8~UsFw5aR3k2046020460epoutp03a
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531213428epoutp03ebfef3836d8da2a72cbe514936f93ff8~UsFw5aR3k2046020460epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717191268;
	bh=4UCeOpS2gxGOtZ2m/Twam0+uQamLCIEw8CzQlgjVKts=;
	h=From:To:Cc:Subject:Date:References:From;
	b=tEJLx/CjtPh421bp7xcbwpwM7KBoD7UMjHnCmGlBKTPAHdND/DX6oNqHG9VbpWIH1
	 sLYWV/X46c4FlCc7RitzOFEx0stlIAlv/va61Vr9VcNgfRMz0ZYLbxAYBJ6YAP9+qe
	 RaBSqWsMwv0c544vQt+oVXw4FjC+NYLPQjdln5Ik=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240531213426epcas2p45e00bc21be45a7c255f109d8351b3f61~UsFvzXVGn2198821988epcas2p4D;
	Fri, 31 May 2024 21:34:26 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Vrbwy128pz4x9Pp; Fri, 31 May
	2024 21:34:26 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.63.18956.1624A566; Sat,  1 Jun 2024 06:34:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3~UsFt8gW2M0661106611epcas2p1m;
	Fri, 31 May 2024 21:34:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531213424epsmtrp12e4929d5edf65f4217a98411789c6df0~UsFt7wCIA0490304903epsmtrp1h;
	Fri, 31 May 2024 21:34:24 +0000 (GMT)
X-AuditID: b6c32a4d-247ff70000004a0c-d6-665a4261e3ca
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.F6.07412.0624A566; Sat,  1 Jun 2024 06:34:24 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240531213424epsmtip2add19db3793fafde8f2204283eb68324~UsFtucPsp1505315053epsmtip2s;
	Fri, 31 May 2024 21:34:24 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Minwoo Im <minwoo.im@samsung.com>,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH v2 0/2] ufs: pci: Add support UFSHCI 4.0 MCQ
Date: Sat,  1 Jun 2024 06:22:42 +0900
Message-Id: <20240531212244.1593535-1-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmmW6SU1SaQcdeZosH87axWbz8eZXN
	YtqHn8wWNw/sZLLY2M9hcX/rNUaLy7vmsFl0X9/BZrH8+D8mi2enDzA7cHlcvuLtMW3SKTaP
	j09vsXj0bVnF6PF5k5xH+4FupgC2qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkF5gV6
	xYm5xaV56Xp5qSVWhgYGRqZAhQnZGW1bFzIVvOasWL/8KHsD4xf2LkZODgkBE4mrl3YwdzFy
	cQgJ7GGUWHN/GSOE84lRYsWy9awQzjdGiSvtJ9hgWrpXvIaq2ssoce5UP9gsIYHfjBJXt3OB
	2GwC6hINU1+xgNgiAosZJeau5gNpYBZ4wSjxbeE8JpCEsICNxJS226wgNouAqsTn581gcV6g
	+IeF06G2yUvsP3iWGSIuKHFy5hOwocxA8eats8EOlxB4yy6x7NxSqAYXiWlPzrNC2MISr45v
	gfpUSuJlfxuUXS7x880kRgi7QuLgrNtAvRxAtr3EtecpICazgKbE+l36EFFliSO3oLbySXQc
	/ssOEeaV6GgTgpihLPHx0CFmCFtSYvml11C3eEi0nu1ngoROrMTZRx1MExjlZyH5ZRaSX2Yh
	7F3AyLyKUSq1oDg3PTXZqMBQNy+1HB6vyfm5mxjByVPLdwfj6/V/9Q4xMnEwHmKU4GBWEuH9
	lR6RJsSbklhZlVqUH19UmpNafIjRFBjCE5mlRJPzgek7ryTe0MTSwMTMzNDcyNTAXEmc917r
	3BQhgfTEktTs1NSC1CKYPiYOTqkGpgQTm8ovk7V+fMu3t1JdXNM1ZfPN4qJ9XPv3BBrvUXrv
	Jf9+on2Ss07ptqufqlvPdZwuqWKe1eDi+Xan9pm8BQxHHLIef5D/UjfB/dfsqS+kc83/Frza
	+Ij1cpnik5t/j3+u3hrwSb9Q6ZWadoj87i2nfHjPrm0u4eBgXCBquvj6ZZHsW5I6nWs4e423
	XwxTelW0tfjpMofE2L2dbGXr9flcn4Z2vH2kEs69eU+L1Y0PNteTlLYl5eZN8E47dOjoSiH1
	xMev/h/9ohLGVCx8KedUavimk/MFpnAaLZn18ZXeMjOm9aUGfOomm9cea+2bzfEkN3KD9IeZ
	TSL+XQeCzx/okUvzUMzyPaR5VFj0jRJLcUaioRZzUXEiAMPibdonBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvG6CU1SawaxXxhYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUVw2Kak5mWWpRfp2CVwZbVsXMhW85qxYv/woewPjF/Yu
	Rk4OCQETie4Vrxm7GLk4hAR2M0p8mrSVGSIhKbHv9E1WCFtY4n7LEVaIop+MElebnoEl2ATU
	JRqmvmIBSYgILGaUeHLuDZjDLPCOUWL3nglMIFXCAjYSU9pug3WwCKhKfH7eDBbnBYp/WDid
	DWKFvMT+g2eZIeKCEidnPmEBsZmB4s1bZzNPYOSbhSQ1C0lqASPTKkbJ1ILi3PTcZMMCw7zU
	cr3ixNzi0rx0veT83E2M4HDW0tjBeG/+P71DjEwcjIcYJTiYlUR4f6VHpAnxpiRWVqUW5ccX
	leakFh9ilOZgURLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXApFP/yCU5cPq1uy5rOTqfW70z
	jKlr9/U+/Y+pquu2u0jbnDD/Hwfjj/R9DTWoym3bUnJr1WbW1y/1Pf2/yW449exBvoHz1TBf
	n3kf6tqn2cZVrrywQsBatSRN4/GGCJXjy2aaPRH5MMnzsf/kmDtmTz9uWVlZVMMzc9mfX47O
	974s0tvEf2jXwb4UzYpU/RvyUq78bxhur1jL3Hyq+tmuQ90B59vfd12dfc1IUaX6Q+S3eXP7
	ZM/cCFhT1dilVJx/KrDRW3nz5GsVsyRrlh+Zs3vDQ4ULhis+n9z8P3fenQzBM5Mj8jknP+w+
	XR56+dLTIFf2F3M4Z/xymMTLuyslwfN5Uuz7VgaO5ZmrbgWk7lFiKc5INNRiLipOBAD95WYI
	1gIAAA==
X-CMS-MailID: 20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3
References: <CGME20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3@epcas2p1.samsung.com>

This patchset introduces add support for MCQ introduced in UFSHCI 4.0.  The
first patch adds a simple helper to get the address of MCQ queue config
registers.  The second one enables MCQ feature by adding mandatory vops
callback functions required at MCQ initialization phase.  The last one is to
prevent a case where number of MCQ is given 1 since driver allocates poll_queues
first rather than I/O queues to handle device commands.  Instead of causing
exception handlers due to no I/O queue, failfast during the initialization time.

---
v2:
  - https://lore.kernel.org/linux-scsi/20240531103821.1583934-1-minwoo.im@samsung.com/T/#t
  - Not separate the newly introduced function from the actuall caller in the
    other patch by squash the second patch to the first one (Bart).
  - Rename ufs_redhat_* in ufshcd-pci.c to ufs_qemu_* to represent that it's
    for QEMU UFS PCI device (Bart).

Minwoo Im (2):
  ufs: pci: Add support MCQ for QEMU-based UFS
  ufs: mcq: Prevent no I/O queue case for MCQ

 drivers/ufs/core/ufs-mcq.c    | 23 +++++++++++++++++
 drivers/ufs/host/ufshcd-pci.c | 48 ++++++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h          |  1 +
 3 files changed, 71 insertions(+), 1 deletion(-)

-- 
2.34.1

