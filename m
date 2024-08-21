Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC53B15572C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724222520; cv=none; b=Bub9rjavdie8dqGN6PmNE9Cojoqv5BVQoGOF+JeopsSlCSsDTnJd7I90+xATmr73zzku+seie/+LmRKXoj1+Tbl9E8aPKnKQf3u8mYlvTEYMZF46ZeigSH620WKUS2emw7UnY/jjTO0RgknXY/b9gJh2YtKI4sZLXGs6IyT10l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724222520; c=relaxed/simple;
	bh=s3kW2g5CpnSLlQ/g62tIvzKvDFkcVRz9w4azflRx7vk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:References; b=lE/0UZ2leE7QJffm20Er7PWWk+L0abI8wWCXPZ4hc06fGscKenM7B9AlAMz7ol33YQYS6wiHm06qGeWLzyGXodvu+3CPrpE/TmS9sIxmK3ii5mIoAUD/2A3yd8kHNLtUz6Pg2rAPbuyBp7iwkIIoYZ+FJZMde0kxtjNQ0tRIIe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=luaT87Gq; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="luaT87Gq"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240821064154epoutp01a5c52cb70dfb495cf9a1b983e1d5bb8b~tqz3d8Ahy0380603806epoutp01T
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:41:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240821064154epoutp01a5c52cb70dfb495cf9a1b983e1d5bb8b~tqz3d8Ahy0380603806epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724222514;
	bh=wk4A2m6/YO4XwSwfN0YTK/iK/dDOpMfyEpzTBLdoRFo=;
	h=From:To:Cc:Subject:Date:References:From;
	b=luaT87GqzR5ePhsS5EykiehrcrsqmSej0Sam0yL0tF3/D8E5bF/nbumi4D8SMDUVG
	 FCnXIWMhiCPvOUq1B9ivQOnhs7OkOmR0/3T9L5EIMbTzn06TxQoDZILBKzzVpQAe7g
	 qxlK2aWb1UVMe3/m5JOtWvtCdsYVIYhVk/mj/FL8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240821064154epcas2p22934083a26a0cc105aa4f0ec3e416f79~tqz3H9TQq0790407904epcas2p2y;
	Wed, 21 Aug 2024 06:41:54 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.91]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WpcFF2KGRz4x9Pv; Wed, 21 Aug
	2024 06:41:53 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.FD.08901.13C85C66; Wed, 21 Aug 2024 15:41:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240821064152epcas2p2552e92767564272fb7e172fecd7ade3e~tqz15McSU0917309173epcas2p2N;
	Wed, 21 Aug 2024 06:41:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240821064152epsmtrp10aa9432d6b3a6c7c4108d80163323233~tqz14G4rv1068010680epsmtrp1Z;
	Wed, 21 Aug 2024 06:41:52 +0000 (GMT)
X-AuditID: b6c32a43-2a4dfa80000022c5-2e-66c58c311094
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	23.1C.08964.03C85C66; Wed, 21 Aug 2024 15:41:52 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240821064152epsmtip2ddeae3c16fc62d806d04c706220c69b0~tqz1p5L4F1962519625epsmtip23;
	Wed, 21 Aug 2024 06:41:52 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 0/2] scsi: ufs: introduce a callback to override OCS
 value
Date: Wed, 21 Aug 2024 15:44:34 +0900
Message-Id: <cover.1724222619.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdljTXNew52iawZ6zPBYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLVYvfsBisejGNiaLXX+bmSy23tjJYnFzy1EWi8u75rBZ
	dF/fwWax/Pg/Joul/96yWGy+9I3FQcDj8hVvj8V7XjJ5TFh0gNHj+/oONo+PT2+xePRtWcXo
	8XmTnEf7gW6mAI6obJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXmBXrFibnFpXnpenmp
	JVaGBgZGpkCFCdkZ7WdnsBVsZqm4u+waYwPjbuYuRk4OCQETiU0PX7F1MXJxCAnsYJT4/Osd
	O4TziVFi0+ZWZgjnG6PE3VOf2WBaGpsaGUFsIYG9jBIz/zpBFP1glPg9/z8TSIJNQFPi6c2p
	TCAJEYGPTBKb529jB0kwC6hL7JpwAqxIWMBfYuGR16wgNouAqsS8ze1gG3gFLCTmTvjBCLFN
	TuLmuU6wMyQEGjkk7p39zQKRcJG48vwFK4QtLPHq+BZ2CFtK4mV/G5RdLLF2x1UmiOYGRonV
	r05DJYwlZj1rB9rAAXSRpsT6XfogpoSAssSRWywQd/JJdBz+yw4R5pXoaBOCaFSW+DVpMtRp
	khIzb96BGughMWvLNyaQciGBWImGZZoTGGVnIYxfwMi4ilEstaA4Nz012ajAEB5Jyfm5mxjB
	iVLLeQfjlfn/9A4xMnEwHmKU4GBWEuHtfnkwTYg3JbGyKrUoP76oNCe1+BCjKTC4JjJLiSbn
	A1N1Xkm8oYmlgYmZmaG5kamBuZI4773WuSlCAumJJanZqakFqUUwfUwcnFINTPvW/1L5oZny
	doVBb2pWuZ7G6sQNN3dcsZ3X+edp8Kydl+b6vwt/8Wbq1qtNWa0vmszOLZrD/7xRtvnwm2OV
	uauMV265yMosnPJ9bVoaSxD7tQdFAd8Nv2ybGjfvq9B+p4i6T0UL3SOuP77/zGjZqc/uwk5f
	cvJig/Uy7mRtu9i9Jef0s8+xa1V5fV5lhrvLRLBselEfpRMjt/BiT4jvhpTErhdqDy84sFc5
	r4ly3Z/n807j1ZFWeant++av9T/HpPD3+jRBLdX6+XwHmx9Htm5XWJrJ2b564cP35qsnfggz
	b9Xf7pjjdENH95juYtO6qV+Vnt47O5Ph4IvpKm3TZxXpu/YpiHQtPVXkcCLmmbgSS3FGoqEW
	c1FxIgCFARQ6HQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSvK5Bz9E0g9bX+hYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLVYvfsBisejGNiaLXX+bmSy23tjJYnFzy1EWi8u75rBZ
	dF/fwWax/Pg/Joul/96yWGy+9I3FQcDj8hVvj8V7XjJ5TFh0gNHj+/oONo+PT2+xePRtWcXo
	8XmTnEf7gW6mAI4oLpuU1JzMstQifbsEroz2szPYCjazVNxddo2xgXE3cxcjJ4eEgIlEY1Mj
	YxcjF4eQwG5Gicm7l7BCJCQlTux8zghhC0vcbznCClH0jVHi/8qfYEVsApoST29OZQKxRQSa
	mSX6muxBbGYBdYldE06AxYUFfCUuNk8Gq2cRUJWYt7mdDcTmFbCQmDvhB9QCOYmb5zqZJzDy
	LGBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERy8Wpo7GLev+qB3iJGJg/EQowQH
	s5IIb/fLg2lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUa
	mFa3WUppSOXuYd/2+97cXOvoqPwZ0/SWZGxUmvxzs2CM8KVe9bkitzbudN9iI/prdn5s86n7
	qbO7WVVfvUjd38dw47yLIdf1wvsSfXXpSbvi/R6LvtCfb6Bym+/0RKeWn03qi+uZkrx3KYmG
	Bjb/ClE/qiJ1Nrb8R3qk6+KkOO1ME9emOd3XhL63HymPtAhmmXtp4f6vbFmPkqINSp+Yqi86
	dHGd+a7JOswTZhT0xB//5dGzNWid7EIJCa6LqZm2dvwlwdNdF9kmzX7LepL5n7XugvjfRYvu
	VnCKZalvkbzJNm1/6x/TOkXDI3G/NF7tnRljs6SmTe3gxRNvxLO+fwqXyPrXvbt82SdRtdN2
	SizFGYmGWsxFxYkAeOPZps0CAAA=
X-CMS-MailID: 20240821064152epcas2p2552e92767564272fb7e172fecd7ade3e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240821064152epcas2p2552e92767564272fb7e172fecd7ade3e
References: <CGME20240821064152epcas2p2552e92767564272fb7e172fecd7ade3e@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

UFSHCI defines OCS values but doesn't specify what exact
conditions raise them. So I think it needs another callback
to replace the original OCS value with the value that works
the way you want.

Kiwoong Kim (2):
  scsi: ufs: core: introduce override_cqe_ocs
  scsi: ufs: ufs-exynos: implement override_cqe_ocs

 drivers/ufs/core/ufshcd-priv.h | 9 +++++++++
 drivers/ufs/core/ufshcd.c      | 4 +++-
 drivers/ufs/host/ufs-exynos.c  | 9 +++++++++
 include/ufs/ufshcd.h           | 1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.7.4

