Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4EBA2D
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2024 05:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706247101; cv=none; b=feMBahZEYrjPL+7lvAJdMnWb8CNb8Ti7ol3no/DWqR5+UErR4N+6FNg98w9llWtW/Iy0AjlkbT63R1ADZ1CUXYMIBBRCkr+MspGrJZ6AFRbxT1Fig6qVNmMr3Qj5iJqiHKZXDvRi7IHW8j5aopwtgb44XtPKx/VuemJvBwyUaRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706247101; c=relaxed/simple;
	bh=fQ48kdEW9X2m9z9H+vI0v41YJ8fjVirgYstXNDTwNZg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=Hlsi0hUW4r6u4Sa93VBYeeIn3OxckjQVEFk5NAXBY5PLb1pWkQ073s0676mMy+mRBNHFkg8JKaY7KcR/K46fjhJlUGwMf0368R1GGp2H95qbsJcw5YhOvi2pQ9whK7SNjHKp6gK6Tx3XX+GiIzlAAtLnqIpuDPA0DYiqVr3ptTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OqUMP5a6; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OqUMP5a6"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240126053130epoutp04b4aefe734e8c102af08fb502a5dccbf6~tzrBFwWcY3080730807epoutp04B
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2024 05:31:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240126053130epoutp04b4aefe734e8c102af08fb502a5dccbf6~tzrBFwWcY3080730807epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706247090;
	bh=x7ULaaTvXq0tDDht37dmEc4GMIXouclPhV7jlV0ZiJY=;
	h=From:To:Subject:Date:References:From;
	b=OqUMP5a6mlcnIdHPrZZYHfxnYMPDNHIda0jYfdPniFcP6sh4JbGBwhFMmED/2F1tD
	 tN2dxSA3mzALx08feGMY5Pf5HQGevGdgFrUD2FLGK/6oVKSXyXCptEPFXkavtr1lM6
	 pKWFlD9vwNExkypcsqLCCS7zCTDzXuWLJlMaO1rI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240126053129epcas2p26974bc11bcf4c92568949dc528a65534~tzrAc4gFt1928619286epcas2p2K;
	Fri, 26 Jan 2024 05:31:29 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TLmX10RrXz4x9Pv; Fri, 26 Jan
	2024 05:31:29 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A4.39.10006.0B343B56; Fri, 26 Jan 2024 14:31:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240126053128epcas2p41cf6ee4ff361ff89f7f1dd2f190aba6e~tzq-bpufv0303503035epcas2p4n;
	Fri, 26 Jan 2024 05:31:28 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240126053128epsmtrp2e107ba13e93a7cf3e0fc52057cca7ba1~tzq-a2v3r2067720677epsmtrp2S;
	Fri, 26 Jan 2024 05:31:28 +0000 (GMT)
X-AuditID: b6c32a45-179ff70000002716-48-65b343b04690
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	19.A0.08817.0B343B56; Fri, 26 Jan 2024 14:31:28 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240126053128epsmtip205de091ea5a66771862131da7865e477~tzq-NBYUM2867428674epsmtip22;
	Fri, 26 Jan 2024 05:31:28 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <beanhuo@micron.com>,
	<adrian.hunter@intel.com>, <h10.kim@samsung.com>, <hy50.seo@samsung.com>,
	<sh425.lee@samsung.com>, =?utf-8?B?66+86rSR7JuQ?= <kwangwon.min@samsung.com>
Subject: Query about UCD allocation
Date: Fri, 26 Jan 2024 14:31:28 +0900
Message-ID: <000001da5018$e9506c10$bbf14430$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdpQF4Sme7+LXoijRMWzH5BRC/bwfQ==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmme4G582pBvO/WlucfLKGzeLBvG1s
	Fi9/XmWzOPiwk8Vi2oefzBZ/b19ktVi9+AGLxaIb25gstt7YyWLRfX0Hm8Xy4/+YLJb+e8vi
	wONx+Yq3x+I9L5k8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUtk1GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0LVKCmWJOaVAoYDE4mIl
	fTubovzSklSFjPziElul1IKUnALzAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM+UemsxZ8Yq+Y
	MWkzYwPjbLYuRg4OCQETiafHsroYOTmEBHYwSmxvLOhi5AKyPzFKnFz1kQnC+cYose/EX0aQ
	KpCGdX1XoBJ7GSWufnnJDOG8ZJSYdWU2O0gVm4C2xLSHu1lBEiICl5gkWp71sYEkhAWUJVbP
	ecwEYrMIqEp8O7EBzOYVsJS4NuE9M4QtKHFy5hMWEJsZaNCyha+ZIVYrSPx8uowVxBYR0JPY
	+/0ZG0SNiMTszjawKyQElnJILJ24DarBRWLJ+dvsELawxKvjW6BsKYnP7/ayQdjFEmt3XGWC
	aG5glFj96jRUkbHErGftjKBQYhbQlFi/Sx8SYMoSR25B3cYn0XH4LztEmFeio00IolFZ4tek
	ydDQkpSYefMOVImHxNp93JCgjpW4/eAi4wRGhVlIHp6F5OFZSB6bhXDCAkaWVYxiqQXFuemp
	xUYFhvC4Ts7P3cQITsdarjsYJ7/9oHeIkYmD8RCjBAezkgivienGVCHelMTKqtSi/Pii0pzU
	4kOMpsAomMgsJZqcD8wIeSXxhiaWBiZmZobmRqYG5krivPda56YICaQnlqRmp6YWpBbB9DFx
	cEo1MBWmyaR89RMsSXetNp4T1hsQadohcEjk2TfHdYdfHTwplFGVp5TwOv9uetviL6v42yV/
	XXt40mKmG+fCGVdqqx5fOdNwTeMSf7HJsml8V8+tS3JNsr10inPCE42iy+dztW6+nNRlFbXB
	/+O8H4seiPeFztIQ+eaxUOWeXBXDE65pVT7r9n4+y9nyoDZQ9zG3YWrFC56b07dVh216UHx4
	7yO7Oc4vr6QallmLtKv8EVmuEjqj4iyT4OpDX7bq8TNenHZp82Xp/NVpUR/ubxXu5v/XvY5/
	V+Y8+4J/H6d2OMgyNqmt+Fq0dNk7W7fsZ8qMXRMUdlYYLnlU/SciWu2I8xWhxTNZtrwRKC5+
	XVc0c50SS3FGoqEWc1FxIgBhaczmUAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJXneD8+ZUg3XvpSxOPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWW2/sZLHovr6DzWL58X9MFkv/vWVx
	4PG4fMXbY/Gel0weExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCOKyyYlNSezLLVI
	3y6BK+PllfeMBR/ZK9ZvusnWwDiDrYuRk0NCwERiXd8Vpi5GLg4hgd2MEifaLjNCJCQlTux8
	DmULS9xvOcIKUfScUWL2wjfsIAk2AW2JaQ93gyVEBB4wSXxv38oMkhAWUJZYPecxE4jNIqAq
	8e3EBjCbV8BS4tqE98wQtqDEyZlPWEBsZqBBT28+hbOXLXzNDLFZQeLn02WsILaIgJ7E3u/P
	2CBqRCRmd7YxT2AUmIVk1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgVGeanlesWJucWleel6
	yfm5mxjBcaWltYNxz6oPeocYmTgYDzFKcDArifCamG5MFeJNSaysSi3Kjy8qzUktPsQozcGi
	JM777XVvipBAemJJanZqakFqEUyWiYNTqoGp0kbr6u07i88ybDCvlF9wSupxUIrhhMvFM1ZF
	l6xYFeNhx7nJ6PyD7JLgoHvPY9dqOvmZTjhXoHTLzfJSTuCE79Vqj65JfMv6HnH9Q/WEBf23
	fl2OS7+86JyyVuKmwl2WH5uaxXgMS4WWfvIOyN5ybPoL7o1n0wrFl++9w7qssPRpu2Zi16Eb
	U45fWMCxvvr550zTbpfTi5Ywp+/tmHGh2yVQ/dXsNYz+7xayij1r+VFld7hF9EpqwZxVx4RU
	138pEQv9uaAtQ2u9Sx1P3lk/4bSol7OkN929X9oZfcpucebuSccPKneKc69ryJ7NVfp/0UcZ
	nRdSesv4uC/YbVUTTXyw/8HJvOQbr3iy+tY1KLEUZyQaajEXFScCAJ0dWfsaAwAA
X-CMS-MailID: 20240126053128epcas2p41cf6ee4ff361ff89f7f1dd2f190aba6e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240126053128epcas2p41cf6ee4ff361ff89f7f1dd2f190aba6e
References: <CGME20240126053128epcas2p41cf6ee4ff361ff89f7f1dd2f190aba6e@epcas2p4.samsung.com>

Form a certain time, UFS drivers set the value of 'max_sectors' like below,=
 meaning 1MB.
And the size of PRDT part of UCD per one slot is decided with SG_ALL(128) m=
ultiplied by PRDT entry size, 16 bytes if 4DW of PRDT is used.

If there is another knob to make it smaller to split a request, it seems UF=
S driver can receive 1MB of chunk.
And when 4KB page is used, 256 PRDT entries are necessary to describe data =
area.
Thus, it seems that the driver has been allocating less than it needs.

If my understanding is wrong, please correct me.

--
static const struct scsi_host_template ufshcd_driver_template =3D =7B
..
.max_sectors            =3D SZ_1M / SECTOR_SIZE,

static int ufshcd_memory_alloc(struct ufs_hba *hba)
..
        ucdl_size =3D ufshcd_get_ucd_size(hba) * hba->nutrs;

static inline size_t ufshcd_get_ucd_size(const struct ufs_hba *hba)
=7B
        return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_en=
try_size(hba);

Thanks.
Kiwoong Kim


