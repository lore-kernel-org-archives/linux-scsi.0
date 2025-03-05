Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40631F153A
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160482; cv=none; b=Bnd2Zs3KWnqwrmAeQkLmga4TBMF+4/PJeWl6Osrg4Ynh+mnnnKEWMAHAWaHOAfdL29KnGc9wVH3CgiTnJ4ga+lxVsGvKnLVcbnWPlIBX1sdGjPoW6EpgcOqjcNuDJ03zm8l86FbYzX9ImlzJCNK9UcgDDu1aDdoSzNqZFGweNEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160482; c=relaxed/simple;
	bh=gnt9jmtrbPVP9N4xNFbqyRGyqo8qlPs6vEMuPN+5aAY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tDwy3m9wRPjpT/0B1tafqMB33JSIX3yfl/iGX8GjrUQD5hNHz2A1KKnix7Bnl1BuqaQDg0Q/HUH5kjBdG2yLY6/H1ttZ54I+H3fEU6/aidvZi5EtVmdSZ8B5evxO/ZPNwBoMQ6chRgoPw254GOFeh5CMStY/+bhiP5tBmpZwZ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MbbHBdCD; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MbbHBdCD"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250305074117epoutp0407f478bf3252b02364648130a94ec322~p2DrLRgKA1564015640epoutp04X
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250305074117epoutp0407f478bf3252b02364648130a94ec322~p2DrLRgKA1564015640epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741160478;
	bh=Rapm8PpxKCMln8BPsT/78x2XH1Vus2Tmowr2iKgf18c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbbHBdCDD30wzmbJyavCUBYHB8yjHgH1eeNdDlFgkkJx+cH5a1PXWuMzOABDxhPsR
	 7vobBMIZEs0XdE49apBi25Obgb1Mz8l0USqerjZ7Qq/BGeMwG8VcTsvwp/TDImOGz3
	 ovC/SOr8/JooTpryBGfJLBXY6u+cDubvY2NQtApc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250305074117epcas5p34744f7055f9917573475476be1b53648~p2DqqOgaB2096020960epcas5p3B;
	Wed,  5 Mar 2025 07:41:17 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z74HG59npz4x9Q0; Wed,  5 Mar
	2025 07:41:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.B1.19710.A1008C76; Wed,  5 Mar 2025 16:41:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15~p1NVfvCZa1303613036epcas5p4a;
	Wed,  5 Mar 2025 06:39:03 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250305063903epsmtrp23591450b4b388ff249873f5ee48260b1~p1NVe2cOS0766407664epsmtrp25;
	Wed,  5 Mar 2025 06:39:03 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-e6-67c8001a6787
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.63.33707.781F7C76; Wed,  5 Mar 2025 15:39:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250305063902epsmtip13d9cf281c7fa3c5fee5dfa632f99d727~p1NUCq3yv1100611006epsmtip1z;
	Wed,  5 Mar 2025 06:39:02 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v3 2/2] block: Correctly initialize BLK_INTEGRITY_NOGENERATE
 and BLK_INTEGRITY_NOVERIFY
Date: Wed,  5 Mar 2025 12:00:33 +0530
Message-Id: <20250305063033.1813-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250305063033.1813-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhq4Uw4l0g5WvNC0+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8XeW9oW85c9Zbfovr6DzWL58X9MFncvPmV24PLYOesuu8fls6Ue
	ExYdYPTYvKTe48XmmYweu282sHl8fHqLxaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzScX85YsI+jYtLEf2wNjAvY
	uxg5OSQETCR2XvvE0sXIxSEksJtR4t/6iUwgCSGBT4wSOxoK4Ox9O3NgGrqmHmeCaNjJKLFr
	4gxWCOczo8SL9knMIFVsAuoSR563MnYxcnCICFhLvH8tDlLDLHCWUeJv438WkLiwQKZE84k6
	kHIWAVWJX0eOgy3mFbCQOH9qP9R18hIzL30HszkFLCV+bZ3BDFEjKHFy5hMWEJsZqKZ562xm
	kPkSAhM5JF7f2McE0ewiseDHZ0YIW1ji1fEtUEOlJD6/28sGYadL/Lj8FKq+QKL52D6oenuJ
	1lP9zCB3MgtoSqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsZUk2lfOgbIlJPaea4CyPSSm
	zfsEDaseRomWP13MExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3PTXZtMAwL7UcHsfJ+bmbGMEJ
	V8tlB+ON+f/0DjEycTAeYpTgYFYS4X196ni6EG9KYmVValF+fFFpTmrxIUZTYIBPZJYSTc4H
	pvy8knhDE0sDEzMzMxNLYzNDJXHe5p0t6UIC6YklqdmpqQWpRTB9TBycUg1MBeY+UfO4Oicb
	Prl7Y4m8o+GOJYWcZYbH6zxOno90/nptxcsZtTOdtHimbV26YtGyi8fl7pmdmlv/NHWdeLt+
	cZqmShynftT3E69L093t361/Ez/z2RKnwpS7/iKp8bKTwhcWtzN88d7S+OHCno9XhM/yiaj2
	/nMUePZuk7A007KSK+WSTln2uy9tD5y2b52cZunP9Tz/z16Siiw6K8VzaOk3t0lPLbc95rm+
	munMHpON091dNrU78vPWstZMsLfibq0VsKrnSzzmvPCAVsipdetsK2LkShwlReR5btgtYLX7
	5b/wxAvDozL/fruLfE7UW1Kpce+l2P/d2npG7pe4pkRqLNt667eM2yX35QUFSizFGYmGWsxF
	xYkAodxOLkEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSnG77x+PpBkv3GVh8/PqbxaJpwl9m
	i9V3+9ksFiyay2KxcvVRJou9t7Qt5i97ym7RfX0Hm8Xy4/+YLO5efMrswOWxc9Zddo/LZ0s9
	Jiw6wOixeUm9x4vNMxk9dt9sYPP4+PQWi0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBlNJxf
	zliwj6Ni0sR/bA2MC9i7GDk5JARMJLqmHmfqYuTiEBLYzijxpO8YE0RCQuLUy2WMELawxMp/
	z9khij4ySlyf3gJWxCagLnHkeStQEQeHiIC9xL0fFSA1zAKXGSWmvPrCClIjLJAusWzKarBt
	LAKqEr+OHAfr5RWwkDh/aj/UFfISMy99B7M5BSwlfm2dwQxiCwHVzFmxgxGiXlDi5MwnLCA2
	M1B989bZzBMYBWYhSc1CklrAyLSKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzgetIJ2MC5b
	/1fvECMTB+MhRgkOZiUR3tenjqcL8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwREkhPLEnN
	Tk0tSC2CyTJxcEo1ME1hW3Ij0dFK1NzNfU71B+/oKWE7ikr1X3Vcll5n9PnP3g9Tc7wyV2p+
	vLt7/qbJ7W+N30/Xn3rtX1fvlrOJE0yZ4mRZH6yOtOGoSu7ds7t04j+VOTKG5VMn57IcCs3d
	3KlwhCFGy0u/gkGrU+pT1eT0q3eyZbZyBpck8FvJq5zfLBrMcPd49odEvcqpvg3z50QeMq4Q
	vb7pR+hV743igQ5mlxnMWma9/vLr3ES9FcYu3ImPY4SN2Iy2PbTbfsQ1v3HJfaY3Uj71TtqB
	uSLTy1qSG4WfbXifE7v14+kru36ZchmflN2zq7T5+NYFXtGrO0+c6zFiDA1M3LmYtU/Foelx
	G4fhLeGrER1sd7VjlFiKMxINtZiLihMBzbswIvYCAAA=
X-CMS-MailID: 20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15
References: <20250305063033.1813-1-anuj20.g@samsung.com>
	<CGME20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15@epcas5p4.samsung.com>

Currently, BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are not
explicitly set during integrity initialization. This can lead to
incorrect reporting of read_verify and write_generate sysfs values,
particularly when a device does not support integrity. Ensure that these
flags are correctly initialized by default.

Reported-by: M Nikhil <nikh1092@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: 9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-settings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d0469a812734..40278a28378f 100644
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

