Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877F621504E
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569747; cv=none; b=OIAri/bhEu97J++R80j+lPRvCqrrwkm5W5EEphbzuC25DUTo5ECRft9Kh/ZiQuBiCFsBsrqGKuko0oE3XYDZrAo/OMk12pZMiOZSPiHxnPYZffti27/vfZjCDieW39dR1J3qoic2N+UWVdut4WTxTwNaPVLxKZ4MR8/Z7pjHObM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569747; c=relaxed/simple;
	bh=OO22PG7Gvf9nzlzRb8I9FCyuwmfc+9U3YUKWUC6LDkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nScFJMvjPGh0RzvrbnzS5Ak+ZXcTiLPAE5mjI5VsWAC9tWgzK+oEuo8LT9UkGXHtb/iOOyCRlAPdDNkZQALg7ImTeM57Xytd7O2Tsv26IZYQ7TNuMJywqxZF5Ikps79srOZIZz0ha0RZ1+ZAQxP5tQFNapcepvmLetB1D+tuLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GaVvvIbm; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GaVvvIbm"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250226112927epoutp04552e34c5f0643e180edd331fb5a340a5~nvp5BAuCJ0099500995epoutp04j
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 11:29:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250226112927epoutp04552e34c5f0643e180edd331fb5a340a5~nvp5BAuCJ0099500995epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740569367;
	bh=mqgBPc87/veZwgYQ39rtpd2Wha3wUtr/2HbfNGY2nfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaVvvIbmGUbAH4niVnY4UHZ4xEEQALsRPQV9LYmD6bHDwqm66vSaxg0R031cI9+E4
	 d8H08xtWIdqG30GqCcY+ol+5EXDXHCFugGp+5rGK4KPvxhXbDqBNRnDOwQ+1tuTmD8
	 A5jPixvDhs9oV1vX6ekQisb1fxRZr7wibalQN86A=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250226112927epcas5p2cb70d4a075b7c2c496490ff391976efb~nvp4YM6Yf2550425504epcas5p2N;
	Wed, 26 Feb 2025 11:29:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z2sgn2ByTz4x9Pw; Wed, 26 Feb
	2025 11:29:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E0.27.19933.51BFEB76; Wed, 26 Feb 2025 20:29:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250226112859epcas5p2b97647182f58b4c6514326cf497e3fdb~nvpeGCpGc0272102721epcas5p25;
	Wed, 26 Feb 2025 11:28:58 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250226112858epsmtrp2f9555b3484131139f2b8cddbb06de9c3~nvpeFS6Td0959209592epsmtrp2Y;
	Wed, 26 Feb 2025 11:28:58 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-96-67befb15147b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A0.C9.23488.AFAFEB76; Wed, 26 Feb 2025 20:28:58 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250226112857epsmtip2b993069096e73abbc96687892d393a4a~nvpccxNis0945909459epsmtip2A;
	Wed, 26 Feb 2025 11:28:57 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>, M Nikhil <nikhilm@linux.ibm.com>
Subject: [PATCH v2 2/2] block: Correctly initialize BLK_INTEGRITY_NOGENERATE
 and BLK_INTEGRITY_NOVERIFY
Date: Wed, 26 Feb 2025 16:50:35 +0530
Message-Id: <20250226112035.2571-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250226112035.2571-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmuq7o733pBueW8lh8/PqbxaJpwl9m
	i9V3+9ksFiyay2KxcvVRJou9t7Qt5i97ym7RfX0Hm8Xy4/+YLO5efMpssbP9GKMDt8fOWXfZ
	PS6fLfWYsOgAo8fmJfUeLzbPZPTYfbOBzePj01ssHn1bVjF6fN4kF8AZlW2TkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SrkkJZYk4pUCggsbhYSd/O
	pii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE748N+lYKTHBVHjp5l
	a2Bcyd7FyMkhIWAi0dQ0i7GLkYtDSGA3o0Rn7ylmCOcTo8TMiz9YQaqEBL4xSqztr4HpOPrq
	DBtE0V5GiWsTn0A5nxklHsw6yQJSxSagLnHkeSvQXA4OEQFrifevxUFqmAXeM0q87u9iA4kL
	C2RKzGo2BSlnEVCVaJrzDOwkXgELiebGc1DnyUvMvPQdzOYUsJToWLiCEaJGUOLkzCdgq5iB
	apq3zga7WkJgIYfEnf/PWUDmSwi4SLyeJwExR1ji1fEtUDOlJD6/28sGYadL/Lj8lAnCLpBo
	PraPEcK2l2g91c8MMoZZQFNi/S59iLCsxNRT65gg1vJJ9P5+AtXKK7FjHoytJNG+cg6ULSGx
	91wDlO0hcfrqIVZIUPUwStxrOMM4gVFhFpJ3ZiF5ZxbC6gWMzKsYJVMLinPTU4tNC4zyUsvh
	UZycn7uJEZx4tbx2MD588EHvECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGE2B
	4T2RWUo0OR+Y+vNK4g1NLA1MzMzMTCyNzQyVxHmbd7akCwmkJ5akZqemFqQWwfQxcXBKNTD1
	Ldne9J89bOaT99eP/OjT8Epv3/HnU2C2muVbz2chdqt+/lurHvrXU2GfmkLKs/M7w9drMyTW
	O5z1EWT6IuX8zWNGcgVbuyP330+L5h1xOF/Fp72c4XTM9XUel4SemR06t+3SzylK7EwnF92p
	nj67oCd644bi6n1mW1cr7PTafDTZZSnjX7H3CmXy8+/bX196TmHWrtJ0s4DtZ9cy7UzgtqwI
	WfHwmKqEWe6u2dlaCds235R5cOer+BOdXpsdjVZKFi1PtEIYlaz+p20+9HfO1hTNpVezQhoT
	vrT7uh03Vmj5yzvh7bWL7QsDzheFibJPi7j/jjXFu3QHc5cw70cTiQmp2copa18t7tbSfGio
	xFKckWioxVxUnAgAkgwUuEUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO6vX/vSDZY8NrT4+PU3i0XThL/M
	Fqvv9rNZLFg0l8Vi5eqjTBZ7b2lbzF/2lN2i+/oONovlx/8xWdy9+JTZYmf7MUYHbo+ds+6y
	e1w+W+oxYdEBRo/NS+o9Xmyeyeix+2YDm8fHp7dYPPq2rGL0+LxJLoAzissmJTUnsyy1SN8u
	gSvjw36VgpMcFUeOnmVrYFzJ3sXIySEhYCJx9NUZti5GLg4hgd2MEn8mTmSGSEhInHq5jBHC
	FpZY+e85O0TRR0aJmwuvsoIk2ATUJY48bwUq4uAQEbCXuPejAqSGWeA7o8SJlutsIDXCAukS
	l46cYQKxWQRUJZrmPAPbzCtgIdHceA7qCnmJmZe+g9mcApYSHQtXgC0WAqrZuWcLE0S9oMTJ
	mU9YQGxmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brJhgWFearlecWJucWleul5yfu4m
	RnB8aGnsYHz3rUn/ECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeVca
	RqQLCaQnlqRmp6YWpBbBZJk4OKUamBLeN0Y/+rCrme9AgdPOorru4GUvDV6E9slxqxz50XSZ
	98Tz7x++bMhhXbHoH6NkKY/CGVMnp7yn/x6uDZT22Gq0WfHuw80Tzp5Ju2k8V2vP762tMyJY
	NJJjlvdYPX7qtnfV7tvMnskcFmu3tB+ff/dcv5PkxZo/JXpCM+yVfQ86dIa86jmm4LXbMJqr
	8N7MFV/vd/uWiG65HWzUOEH8QIqg5JpMiQUcMX+61i5gUVc2Liq+ODVvA/8mCVnTvasVJFe1
	rLx8cM1sq1xr0ebly77K9HzTP33j9eyoctPDb5xWLH2n8K5835pZnHaHUjyi20rsKosubH34
	UkXmw0+JN0yBT1QVmxOr4sOZd76TPKTEUpyRaKjFXFScCAC4uFMB/gIAAA==
X-CMS-MailID: 20250226112859epcas5p2b97647182f58b4c6514326cf497e3fdb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250226112859epcas5p2b97647182f58b4c6514326cf497e3fdb
References: <20250226112035.2571-1-anuj20.g@samsung.com>
	<CGME20250226112859epcas5p2b97647182f58b4c6514326cf497e3fdb@epcas5p2.samsung.com>

Currently, BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are not
explicitly set during integrity initialization. This can lead to incorrect
reporting of read_verify and write_generate sysfs values, particularly when
a device does not support integrity. This patch ensures that these flags
are correctly initialized by default.

Reported-by: M Nikhil <nikhilm@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: 9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-settings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8bd0d0f1479c..bee4007b2eeb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -114,6 +114,7 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 			pr_warn("invalid PI settings.\n");
 			return -EINVAL;
 		}
+		bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 		return 0;
 	}
 
-- 
2.25.1

