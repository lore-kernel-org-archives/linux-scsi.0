Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB892904
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740460318; cv=none; b=eO37qUGc6IFBqika+pvr4WWwMur5viaONYWqu/f5rcf3qPBL2P4bTH8QmkuHlImn+GATwm71EBrPnxH1gTPzdszgE5BShPgQrfIGsvgHkk/lhJJciGlzhBSp/lVnO9ohJuOX3nXMxOK8G3BWxQQzz3Ds3VbWcWQN7SfHTqMrbQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740460318; c=relaxed/simple;
	bh=kphX4k5pqUGaVs091TWQOLrtiwgg0fB1uYTwigLOIY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=B1Si9sqBwuwJ/AuovoLJNCJ5r5pDPHeezHzAHreGLAVPoNMNApAxeTnZhkHZQLQzSGleIHohCO1dipVQqtillxa1CamFMbZpmrKrRRvqL2tA11TG6YwHv/mLYLhTr1nyoVKIX6tZWw0t26HStmyXcndDl1h5ApgLUnp4wY63WUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IeIxIpi0; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IeIxIpi0"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250225051148epoutp01952c6785fcdce8dd7eec7c83b7882f73~nW23aWysm1510615106epoutp01d
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:11:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250225051148epoutp01952c6785fcdce8dd7eec7c83b7882f73~nW23aWysm1510615106epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740460308;
	bh=2r92ciUBY2SnVgsPa0EtIWfKdtjMBZP3ueWBbnw9/Gg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=IeIxIpi0YdiY9aO3UyLmwARbHGCyQ1AiGBvbeOar/uNg5Su+xdhG3kH8Dg/h2j+54
	 y2Cez7w9zVbXfu2Jko6PITglXF75a0/b4kdqZuROxRJCkvJbGkNS2RKL7Qh4Ah81Bw
	 Csq7OlUbrE+mURHNmUmh+IQWMrBX8bufuRuMOqqA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250225051147epcas5p155eb8be1e3aa6a0390a34c8284eb9fdf~nW22_PXYU2430524305epcas5p1D;
	Tue, 25 Feb 2025 05:11:47 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Z25LT6pDVz4x9Q7; Tue, 25 Feb
	2025 05:11:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B8.6B.19956.0115DB76; Tue, 25 Feb 2025 14:11:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250225045511epcas5p2d89efcac39b6553317e93e8c7fea3f2b~nWoWkp9r03105931059epcas5p2M;
	Tue, 25 Feb 2025 04:55:11 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250225045510epsmtrp2da18208b263a5cf9df99f360373429fa~nWoWh8uu90367803678epsmtrp2o;
	Tue, 25 Feb 2025 04:55:10 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-ee-67bd5110e6a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	19.4C.23488.E2D4DB76; Tue, 25 Feb 2025 13:55:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250225045508epsmtip2159aaaf9cd4b7baf7f550d48eea8a48c~nWoUmKFZZ3049830498epsmtip2K;
	Tue, 25 Feb 2025 04:55:08 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v1 0/3] Fix integrity sysfs reporting inconsistencies across
 NVMe, SCSI, and DM
Date: Tue, 25 Feb 2025 10:16:50 +0530
Message-Id: <20250225044653.6867-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmhq5A4N50gxenWS0+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8WkQ9cYLfbe0raYv+wpu0X39R1sFsuP/2OyuHvxKbMDt8fOWXfZ
	PS6fLfXYtKqTzWPCogOMHpuX1Hu82DyT0WP3zQY2j49Pb7F49G1ZxejxeZNcAFdUtk1GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
	4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM6/vvMRa8
	Yqv4fSungfEYaxcjJ4eEgInEjGW/gWwuDiGB3YwSU9fdZgZJCAl8YpRYuLgKIvGNUWLOpJeM
	MB3fd/cyQST2MkqsOP2aDcL5zChxrvMT2Fw2AXWJI89bwTpEBAIkZp2+wghSxCxwllHib+N/
	FpCEsECixLZlS5lAbBYBVYlTe7rBGngFLCSmLFoJdaC8xMxL39kh4oISJ2c+AetlBoo3b53N
	DDJUQqCTQ2L53NVQ97lIXL3Yyw5hC0u8Or4FypaS+PxuLxuEnS7x4/JTJgi7QKL52D6oXnuJ
	1lP9QEM5gBZoSqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsZUk2lfOgbIlJPaea2ACGSMh
	4CFxaS03JEhjJdYvPsM4gVF+FpJvZiH5ZhbC4gWMzKsYJVMLinPTU4tNC4zzUsvh8Zqcn7uJ
	EZxstbx3MD568EHvECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGE2BQTyRWUo0
	OR+Y7vNK4g1NLA1MzMzMTCyNzQyVxHmbd7akCwmkJ5akZqemFqQWwfQxcXBKNTBNDBI3ZHWS
	knwaHSP0a8afkAU/J2Y9+3vms3lIpHuh8oQPTNHvtOpz717rnfUs72vYJh8Gk0hFpdTCGQfN
	he5xHWJ9PeP0fa6F16/H/Np+hzXj9dZjLzsjlgulHGlzCU7e7XJ2t4QvMwOj8HGrp/JzVt7k
	y7u6qujnxT+uMmZZkS962T4KrrzM55j1LqhiyasVOSGvf3vUy7/TYvSTdE6Lur2d8X9MBffm
	kjWz5EW2bNr23OvRsdOBSmkNC5hmHV3Sfl3Hzuj3kdqaE8yxsuYn3q/+/NZzQa1X3sLblVWz
	z+2X6og2bLqnoWH8vUj2Q3G+2t77q4Sjdq8J+Bd+P7c3+/obrqMuWX8P+HHOdfmhxFKckWio
	xVxUnAgA2iMDgj8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvK6e7950g5kHzC0+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8WkQ9cYLfbe0raYv+wpu0X39R1sFsuP/2OyuHvxKbMDt8fOWXfZ
	PS6fLfXYtKqTzWPCogOMHpuX1Hu82DyT0WP3zQY2j49Pb7F49G1ZxejxeZNcAFcUl01Kak5m
	WWqRvl0CV8b1/fcYC16xVfy+ldPAeIy1i5GTQ0LAROL77l4mEFtIYDejxIZJjhBxCYlTL5cx
	QtjCEiv/PWfvYuQCqvnIKDHp3m82kASbgLrEkeetQEUcHCICIRI9R0xAapgFLjNKTHn1BWyB
	sEC8RPO0d2A2i4CqxKk93WBDeQUsJKYsWgl1hLzEzEvf2SHighInZz5hAbGZgeLNW2czT2Dk
	m4UkNQtJagEj0ypGydSC4tz03GTDAsO81HK94sTc4tK8dL3k/NxNjOCw19LYwfjuW5P+IUYm
	DsZDjBIczEoivJyZe9KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8640jEgXEkhPLEnNTk0tSC2C
	yTJxcEo1MMm5CyfXewWtYDleFxV6MVa/K+y4qS+7tvEllVblGYcfX2zdPp3nyL5L896+erm5
	SPNgxmavv2m/X9dpNJT9mZEa8HhxmfDqpW+//Q2w1L5UKJHD0m0/6fK57lzv/J+Bdr91ZcOD
	TpXo6iTOkZLYqnWv75B+3U2Wf1YzT2kUMn5w2T3r/m1HyXxR/RO8gdeS911LUt9YsH7C86qf
	D+tjj5d9jossVfZpEQzf+3j9pD0GWQf0V2wpXnLy8jm5xnln5kacePjyjd5eL+7+8jWfViyu
	qbFxE7siecPsO3fBvhsHTVae2rjYWyKt5P+z3lV524wq7683rOX7IJvRrPlaepFwdrejRuur
	3N+PgxWLg5RYijMSDbWYi4oTAQ0G6cLqAgAA
X-CMS-MailID: 20250225045511epcas5p2d89efcac39b6553317e93e8c7fea3f2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250225045511epcas5p2d89efcac39b6553317e93e8c7fea3f2b
References: <CGME20250225045511epcas5p2d89efcac39b6553317e93e8c7fea3f2b@epcas5p2.samsung.com>

This patch series addresses inconsistencies in block integrity sysfs
reporting across NVMe, SCSI, and device-mapper (DM) stacked devices.

Patch 1: Ensures DM devices correctly propagate device_is_integrity_capable
and properly report read_verify and write_generate sysfs attributes
Patch 2: Fixes NVMe integrity sysfs attributes for namespaces without
PI support.
Patch 3: Corrects SCSI integrity reporting when the HBA does not support
DIX.

Anuj Gupta (3):
  block: Fix incorrect integrity sysfs reporting for DM devices
  nvme: Fix incorrect block integrity sysfs values for non-PI namespaces
  scsi: Fix incorrect integrity sysfs values when HBA doesn't support
    DIX

 block/blk-settings.c     | 9 +++++++--
 drivers/nvme/host/core.c | 4 ++++
 drivers/scsi/sd_dif.c    | 4 +++-
 3 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.25.1

