Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877912135A6
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569747; cv=none; b=sNx2lR/TQ+ahahHPixEFdQqfSyUJq7ZTKOg5DWgbH+p7bMpxCraNWvCM5R7Z8dy5aQ+wLrqwAwfVKBUgmpBU3AvyB0NJafwAbX1P1nfSZVuVLIivb/eKopl3lY0jLv74dhM+TwLQ/G48xRlbvtFk/lT3w1vURreU13hNvdo3pkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569747; c=relaxed/simple;
	bh=HReYMgg9LwBhweGV2Me8FeHN++Xz/on+AMz1xQfZXCE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=JK4fDwBbyIX7Y0mXZ5G8N547gcnS+ddwRw7PVeIR3N6LwykFf1ZtzeVDvzHOlJoXkqE21/LHv624QAT1Xy5FIBvEsjpQSISSfrH603RzAVqQWslUgzgG9v4R9Agwq+Zf+oz6NNrS1blVf4LbE/Qk+pp7+go3VL0Ei8h+i3wpo6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fup7pU9D; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fup7pU9D"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250226112927epoutp040099db8a0d1d8da01c06ae9ce545753c~nvp4te21C3225432254epoutp04z
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 11:29:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250226112927epoutp040099db8a0d1d8da01c06ae9ce545753c~nvp4te21C3225432254epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740569367;
	bh=mYlgMANAA3/12lPDPVDBmMvxGDvs5skYaJT+zjvYVg8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fup7pU9DYOY4ikf5gTsVY33fY0x4zAQoa5c2tMO4Uzdk8Zm8uiybYlruNtHbOIFSv
	 VwzFry0KbmI4AYmI4ii01jqiuqFzpXknWokQshB2BOB5PeEUcjtuG2NRhzdTsGnlDR
	 fAn4/YaLczh3cXml+AlkJq1X0u7yjq1ziS99Bvfs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250226112922epcas5p190c013ea4bad09aee59696e3431204f0~nvpzg_reI2155121551epcas5p1y;
	Wed, 26 Feb 2025 11:29:22 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z2sgh1Skpz4x9Pp; Wed, 26 Feb
	2025 11:29:20 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.27.19933.01BFEB76; Wed, 26 Feb 2025 20:29:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250226112855epcas5p330a1f2e300a44ddea5189ff906de7788~nvpamDUgx1479014790epcas5p3t;
	Wed, 26 Feb 2025 11:28:55 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250226112855epsmtrp16f0b74908e6bcf174d407a437d511e6c~nvpalW5mY2293422934epsmtrp1v;
	Wed, 26 Feb 2025 11:28:55 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-91-67befb104f79
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BD.60.18949.7FAFEB76; Wed, 26 Feb 2025 20:28:55 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250226112853epsmtip2bc828ba372ecf4dd6b3c9e7ddc173556~nvpZJtslA0998309983epsmtip2d;
	Wed, 26 Feb 2025 11:28:53 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v2 0/2] Fix integrity sysfs reporting inconsistencies
Date: Wed, 26 Feb 2025 16:50:33 +0530
Message-Id: <20250226112035.2571-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmhq7A733pBltb2S0+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8XeW9oW85c9Zbfovr6DzWL58X9MFncvPmV24PLYOesuu8fls6Ue
	ExYdYPTYvKTe48XmmYweu282sHl8fHqLxaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzxse8pesIel4l/HKsYGxmvM
	XYycHBICJhIN0zoZuxi5OIQEdjNKfL/9nRXC+cQoMefeJBYI5xujxNIZa5hgWi6teAbWLiSw
	l1Hi3ZRoiKLPjBK/2iezgCTYBNQljjxvBZrLwSEiYC3x/rU4SA2zwFlGib+N/8FqhAVcJTY8
	WMoOYrMIqErs+P8IbCivgIXEmVtfoe6Tl5h56Ts7RFxQ4uTMJ2C9zEDx5q2zmUGGSgg0ckh8
	fL8UqsFFYsnkpYwQtrDEq+Nb2CFsKYmX/W1QdrrEj8tPob4pkGg+tg+q3l6i9VQ/M8jRzAKa
	Eut36UOEZSWmnlrHBLGXT6L39xOoVl6JHfNgbCWJ9pVzoGwJib3nGqBsD4k3v2awQgIrVmLu
	ygbmCYzys5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCUl1oOj9jk/NxNjODUquW1g/Hhgw96
	hxiZOBgPMUpwMCuJ8HJm7kkX4k1JrKxKLcqPLyrNSS0+xGgKDOOJzFKiyfnA5J5XEm9oYmlg
	YmZmZmJpbGaoJM7bvLMlXUggPbEkNTs1tSC1CKaPiYNTqoHpgLCYU0OYss/1uF9hZxZfdJ1c
	I9rtdmzdglO/c1YsPxr3+Zf+KVtz6XdMn2RvHWLtfrq21KcrJOLit+nWsk8OXZz1m/F/TV7P
	vZOljopLlu7t3eZ951S55bzddaf+6M4t5zin1nnwycTHblmlu3y3Kcpozyvdf3nP1OYTvle5
	Zu17fdZn7lL7TfV3Dac2qxyvaDt//QzXw72l0ysE14dWcroqlW/cMUHwqPlxzUk705ftWFBw
	42JI9o/lynuX/+Q2avV5XmlkzvfBk8fmVZN9+eN5fnaZXE7XpFdclmqL9T60uOm16Y6WmlX3
	Jix+rr6dm6P0lLHl6Tb9lRfWVv/necPDrmMZpbjh68cXi2I+2CqxFGckGmoxFxUnAgC/YZHx
	NgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO73X/vSDV4c47D4+PU3i0XThL/M
	Fqvv9rNZLFg0l8Vi5eqjTBZ7b2lbzF/2lN2i+/oONovlx/8xWdy9+JTZgctj56y77B6Xz5Z6
	TFh0gNFj85J6jxebZzJ67L7ZwObx8ektFo++LasYPT5vkgvgjOKySUnNySxLLdK3S+DKeNj2
	lL1gD0vFv45VjA2M15i7GDk5JARMJC6teAZkc3EICexmlHi2tIUFIiEhcerlMkYIW1hi5b/n
	7CC2kMBHRomzG7JBbDYBdYkjz1uBajg4RATsJe79qACZwyxwmVFiyqsvrCA1wgKuEhseLAXr
	ZRFQldjx/xHYYl4BC4kzt75CHSEvMfPSd3aIuKDEyZlPwG5gBoo3b53NPIGRbxaS1CwkqQWM
	TKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKDXEtrB+OeVR/0DjEycTAeYpTgYFYS
	4eXM3JMuxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfb694UIYH0xJLU7NTUgtQimCwTB6dUA1PB
	Rte7zYrOewOFfH8FPlFQiV3F9Sf2mtTPT7kqLK6nhHcKuu+eFxTwYeM/ofdtSlc668ziuo4r
	Cnq+kPt66t/WWy1fdiq2rfn87nrgZaeel6ufnTaM0uT/aBqlf7I+WaRPfM46ow+bwmdlcu1e
	IjvfUaBKxe3jg6vhbHyPK9mNXFe1hVhkbHMJP+NjHLxWJvXloab1TGdfMPbtCjBbE3Li0y6/
	JfUWX/qy7Wy+Kf4/bnlV6tLkyspOFf1wNiu9UhOOHS+qC18vu/R62vPkyj2CNmePZ3B72lTv
	/Pope/aKfz8mcjxs1+JLWfOi90RFacV2nzeijRHzOQJ9Vny8uYnrp8aype7TMxVOsW3dVqbE
	UpyRaKjFXFScCABNdJ7t4QIAAA==
X-CMS-MailID: 20250226112855epcas5p330a1f2e300a44ddea5189ff906de7788
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250226112855epcas5p330a1f2e300a44ddea5189ff906de7788
References: <CGME20250226112855epcas5p330a1f2e300a44ddea5189ff906de7788@epcas5p3.samsung.com>

Patch 1: Ensures DM devices correctly propagate device_is_integrity_capable
Patch 2: initialize nogenerate and noverify correctly

v1 -> v2
initialize BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY in
blk_validate_integrity_limits rather than doing it in the driver (hch)

Anuj Gupta (2):
  block: ensure correct integrity capability propagation in stacked
    devices
  block: Correctly initialize BLK_INTEGRITY_NOGENERATE and
    BLK_INTEGRITY_NOVERIFY

 block/blk-settings.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.25.1

