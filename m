Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3E181BA8
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724325179; cv=none; b=DPgJFarXvAafpUThho+4critbVEqTZLSYwPTaTjIJeVTn02OM1jfuVWSjU5HqmEd44w+D4hk8twf87VSPOlDQN28lRlg1SN9uXXxTGNoN/t6KlhzfQoXa35YC/V7TIiJxqgEPhipFPYyHSH1957rkGFXbaq1LsO57chX9ISvejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724325179; c=relaxed/simple;
	bh=SuZrccKzCSPQqQLqIX2vs/jH5qQtYOvtGQfvs/Z831A=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:References; b=Zx7Oa4asyP3wfg+Fnfjx286u0UChW2CtTd8BlxEOgbt6rsHXCU6FK00pyx81o3SZjSQmt6syQ+FU3MABdbzR2oPB42Zy9Iolwln6yDzGonTesA+6InYNW9xXPAJTUX+qHRbSSFwsqstP+vqky63x21Nx7K50HrXWPAbEVCD77wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Qds/ri7O; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Qds/ri7O"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240822111249epoutp030f84175a9bbd90c9198572b9e3f8f116~uCJsVzs3N2702927029epoutp036
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240822111249epoutp030f84175a9bbd90c9198572b9e3f8f116~uCJsVzs3N2702927029epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724325169;
	bh=7wJH0ruhvIbGPxyk4vcVYDrWfQdZ2MepAtstQEdVnno=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Qds/ri7OKu1NBnglD2UORGxkwaHa0hKN75PpGLIk9H7hrBpm70FASByyhB54hBI7z
	 vg9ScHUMRojKOjZSkUB0oKdhHLlB13SzsFLu9HL2KdLZUEjmVbSWPQSZO1L7dC+i1u
	 2F9ihDBhE8MgSvOSpcMiax/qiFKb+T0I+ix5OCs0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240822111248epcas2p4f7c8325f21944a1d07ee4f4c80859d76~uCJrunEtH2325423254epcas2p4c;
	Thu, 22 Aug 2024 11:12:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.92]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WqLCN07KQz4x9Q3; Thu, 22 Aug
	2024 11:12:48 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D5.09.10431.F2D17C66; Thu, 22 Aug 2024 20:12:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240822111247epcas2p2d3051255f42af05fd049b7247c395da4~uCJqcRXHg0251202512epcas2p2L;
	Thu, 22 Aug 2024 11:12:47 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240822111247epsmtrp1ed1ba7e848e58dd5251b7f65ee83ab46~uCJqbOj5C1127011270epsmtrp1t;
	Thu, 22 Aug 2024 11:12:47 +0000 (GMT)
X-AuditID: b6c32a45-ffffa700000028bf-49-66c71d2ff98f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A9.03.08456.F2D17C66; Thu, 22 Aug 2024 20:12:47 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240822111247epsmtip13670b75d2e0b1a54ce0a6f4bdc8eb177~uCJqLmjOv0588005880epsmtip19;
	Thu, 22 Aug 2024 11:12:47 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
Date: Thu, 22 Aug 2024 20:15:33 +0900
Message-Id: <cover.1724325280.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdljTXFdf9niaQcMqI4uTT9awWTyYt43N
	4uXPq2wWBx92slhM+/CT2eLv7YusFqsXP2CxWHRjG5PFrr/NTBZbb+xksbi55SiLxeVdc9gs
	uq/vYLNYfvwfk8XSf29ZLDZf+sbiIOBx+Yq3x+I9L5k8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0
	+LxJzqP9QDdTAEdUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0AdKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnALzAr3ixNzi0rx0vbzU
	EitDAwMjU6DChOyMtytvMhe8ZKlYuWcdewPjY+YuRk4OCQETia4TExi7GLk4hAR2MEqsOrGS
	CcL5xCjRN+cjM4TzjVHi5LlNTDAtC95/YINI7GWUmPfuEFTVD0aJzR+/sIFUsQloSjy9ORVs
	lojARyaJzfO3sYMkmAXUJXZNOAE2SljAX+LsrGuMIDaLgKpE24cdYM28AhYSi9Z8ZINYJydx
	81wn1LWtHBLr9tVD2C4S/VN/sULYwhKvjm9hh7ClJF72t0HZxRJrd1wFO0JCoIFRYvWr01AJ
	Y4lZz9qBFnMAHaQpsX6XPogpIaAsceQWC8SZfBIdh/+yQ4R5JTrahCAalSV+TZrMCGFLSsy8
	eQdqoIfE6RN3weJCArESDVteMU1glJ2FMH8BI+MqRrHUguLc9NRiowJDeCwl5+duYgSnSi3X
	HYyT337QO8TIxMF4iFGCg1lJhDfp3tE0Id6UxMqq1KL8+KLSnNTiQ4ymwOCayCwlmpwPTNZ5
	JfGGJpYGJmZmhuZGpgbmSuK891rnpggJpCeWpGanphakFsH0MXFwSjUw8UvYK+Y5Trjq8/r5
	2rqSyksOhlIdv2bp+TJs2qHV59G0cuKCI4sYO5Lbr9pl679vm1MSWm1yVSkwoynr8+6LGh9P
	JtwP2jpn1bda+YXqdqxVd5N/vJI8qmJ+ombq99MJPIZRrgyK3W+bNzNPvHToSt4P55csWUt/
	lDe+WvR90uODxvImHZ72bMUpxfkPP/+f8GtF1ispTzvpuU3PQu+/ncp/IZg/Njd9b7Ja6EzR
	g7Pfye1geuz2bptX6gMbd3Y5xgUv7h5IOKVhx9/suGRJ3PqoPRdFD9yK9F3M7Zj9bP6LNMkd
	B3dXKV322RAsv1ctLPL17NVGlo/4Z1b4KswKiS962v4lut645PbHBTO8lViKMxINtZiLihMB
	uJQGMR4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnK6+7PE0gy2nRS1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBlvV95kLnjJUrFyzzr2BsbHzF2MnBwSAiYSC95/
	YOti5OIQEtjNKPFlwxtWiISkxImdzxkhbGGJ+y1HWCGKvjFKTF/fCVbEJqAp8fTmVCYQW0Sg
	mVmir8kexGYWUJfYNeEEWFxYwFei4egUNhCbRUBVou3DDjCbV8BCYtGaj2wQC+Qkbp7rZJ7A
	yLOAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw8Gpp7WDcs+qD3iFGJg7GQ4wS
	HMxKIrxJ946mCfGmJFZWpRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbLxMEp
	1cCUPolbZkFp9+tLqccajfffvlYudG6Vwo6Lyawbts1O3z61+9iusp37va7dkdF3idg655vx
	xT0z1RJ3xS6qfK7am1G08c6p6B9hETuPbZo547URa33S2oVsvP791yzYbsoYfvDVEvnF+vvF
	n/Wn/z7ut5tncGfvzu5elg8GuTJB95zef40sn7n5YevVbamlUoWMM/+a/e5INuEMnsW+XOrb
	pjqDty8ZvFY8fGQRUcMyV75X02yLo8WXB29djT95L7354G3lbLUDHNw1wpJySfliHDd9JU5c
	TXv5/jb3rknFE655Z4nd+Vp4a8evRK3vd1IdOS9trVjhf5dR+V3b3X4WhrM2cYevn5yzPNJv
	yrnIaCWW4oxEQy3mouJEAO1AVjLNAgAA
X-CMS-MailID: 20240822111247epcas2p2d3051255f42af05fd049b7247c395da4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111247epcas2p2d3051255f42af05fd049b7247c395da4
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

UFSHCI defines OCS values but doesn't specify what exact
conditions raise them. So I think it needs another callback
to replace the original OCS value with the value that works
the way you want.

v1 -> v2: fix build error for arguments

Kiwoong Kim (2):
  scsi: ufs: core: introduce override_cqe_ocs
  scsi: ufs: ufs-exynos: implement override_cqe_ocs

 drivers/ufs/core/ufshcd-priv.h |  9 +++++++++
 drivers/ufs/core/ufshcd.c      | 11 +++++++----
 drivers/ufs/host/ufs-exynos.c  |  8 ++++++++
 include/ufs/ufshcd.h           |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

-- 
2.7.4

