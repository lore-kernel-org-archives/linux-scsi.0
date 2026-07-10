Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6B23C39A
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 05:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783662368; cv=none; b=Yr9hTicjGWyNFuETwi1V9O7OXpR5jCn2GPC7RpQDxDPdP4UmkUIC8xiOiHDvfTZlH94DNs+DCWe43zILgdL074dYA/aXdSJ6kX+4kTkLWoSyyhMo+pa4ZrzYt0sAa6s41zETcEOXtUVHRscL5LUYQP7fCCstic/hF7QgNLSRot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783662368; c=relaxed/simple;
	bh=e3+kr2zi+pibibEpTe5Ah8tE4Vb0dpA/Fuua9zW9abY=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=hbScGR9Ou85++ANI/SB9gwfx1Ug7pn7d1WlLjoJufmhYHgNGLjFtK7A0rMu2ttGwYbo0wX/T6N5iF2lwGEGC+Q6Gd4S6jogYTwnA80Gvk12crFvEzfiDA5TRQAZXEaJ5jPbdloKft5OGwrOrea1h+atcWvy71UjuhZlq5DTw6eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ES1xdzPz; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ES1xdzPz"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260710054557epoutp031a4b7c6e3dd3f11640c3aa930c081616~A13bUzgWE2040520405epoutp03G
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 05:45:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260710054557epoutp031a4b7c6e3dd3f11640c3aa930c081616~A13bUzgWE2040520405epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1783662357;
	bh=e3+kr2zi+pibibEpTe5Ah8tE4Vb0dpA/Fuua9zW9abY=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=ES1xdzPzmZ7aeteRu6dJ+M0FCgOUTDkP4bozB0Jmz4mBvMpz1PRf7U+l0OZ6Royhf
	 A298BRfW2+4+fpuzMZqr6R+rWr0SjYoTnc8LrGC3gQjM4lt0e7rZFURh1wawKll1g9
	 JrJq6AyhSHeGf3T9WKHHTDIzjW0CNImDyAFnWbJk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260710054557epcas2p38105a1e45e67b972164bdc79cf7af928~A13at-DMG2584025840epcas2p3m;
	Fri, 10 Jul 2026 05:45:57 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.208]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4gxLR860dRz2SSKY; Fri, 10 Jul
	2026 05:45:56 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Add support for the aggregated read query opcode
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jinyoung Choi <j-young.choi@samsung.com>, Dukhyun Kwon
	<d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>, Keoseong Park
	<keosung.park@samsung.com>, Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon
	Seol <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>, Yunjae
	Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
Date: Fri, 10 Jul 2026 14:45:56 +0900
X-CMS-MailID: 20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260710053524epcms2p82121eba4240c37112fc5669430035442
References: <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p6>

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet from the device in a single
query request. The packet may bundle multiple Descriptors, Attributes
and Flags, each organized as a group with a group header, and is
returned in the Data Segment of the QUERY RESPONSE UPIU.

Because an aggregated data packet can be considerably larger than a
single descriptor (up to 4 KiB rather than the 255-byte descriptor
limit), the response UPIU buffer must be enlarged to hold it. Introduce
ALIGNED_RSP_UPIU_SIZE (4096) for the response_upiu=5B=5D area of the UTP
command descriptor and program the response UPIU length in the UTRD
accordingly.

Teach the BSG raw-UPIU path and the device management command path to
recognize the new opcode so that user space can issue aggregated reads
and receive the returned data segment. Descriptor sizing now honors
QUERY_AGGREGATED_MAX_SIZE for aggregated reads.

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong=40samsung.com>
---
drivers/ufs/core/ufs_bsg.c 16 +++++++++++-----
drivers/ufs/core/ufshcd.c=C2=A0=20=C2=A0=207=20++++---=0D=0Ainclude/ufs/ufs=
.h=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=202=20++=0D=0Ainclude=
/ufs/ufshci.h=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=208=20+++++++-=0D=0A4=20file=
s=20changed,=2024=20insertions(+),=209=20deletions(-)=0D=0A=0D=0Adiff=20--g=
it=20a/drivers/ufs/core/ufs_bsg.c=20b/drivers/ufs/core/ufs_bsg.c=0D=0Aindex=
=2058b506eac6dc..176fedd496af=20100644=0D=0A---=20a/drivers/ufs/core/ufs_bs=
g.c=0D=0A+++=20b/drivers/ufs/core/ufs_bsg.c=0D=0A=40=40=20-14,14=20+14,18=
=20=40=40=0D=0A=23include=20=22ufshcd-priv.h=22=0D=0A=0D=0Astatic=20int=20u=
fs_bsg_get_query_desc_size(struct=20ufs_hba=20*hba,=20int=20*desc_len,=0D=
=0A-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=C2=A0=20=C2=A0=20=C2=A0=20struct=20utp_upiu_query=20*qr)=0D=0A+=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=
=20=C2=A0=20struct=20utp_upiu_query=20*qr,=0D=0A+=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=20=C2=A0=20enu=
m=20query_opcode=20desc_op)=0D=0A=7B=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0int=20desc_size=20=3D=20be16_to_cpu(qr->length);=0D=0A=0D=0A=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(desc_size=20<=3D=200)=0D=0A=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0ret=
urn=20-EINVAL;=0D=0A=0D=0A-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0*desc_len=20=
=3D=20min_t(int,=20QUERY_DESC_MAX_SIZE,=20desc_size);=0D=0A+=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0if=20(desc_op=20=3D=3D=20UPIU_QUERY_OPCODE_AGGREGATED_=
READ)=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0*desc_len=20=3D=20min_t(int,=20QUERY_AGGREGATED_MAX_SIZE,=20desc_s=
ize);=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0else=0D=0A+=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0*desc_len=20=3D=20=
min_t(int,=20QUERY_DESC_MAX_SIZE,=20desc_size);=0D=0A=0D=0A=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0return=200;=0D=0A=7D=0D=0A=40=40=20-35,11=20+39,=
12=20=40=40=20static=20int=20ufs_bsg_alloc_desc_buffer(struct=20ufs_hba=20*=
hba,=20struct=20bsg_job=20*job,=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0u8=20*descp;=0D=0A=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=
=20(desc_op=20=21=3D=20UPIU_QUERY_OPCODE_WRITE_DESC=20&&=0D=0A-=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=20desc_op=20=21=3D=20UPIU_QUERY_OPC=
ODE_READ_DESC)=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=20=
desc_op=20=21=3D=20UPIU_QUERY_OPCODE_READ_DESC=20&&=0D=0A+=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=20desc_op=20=21=3D=20UPIU_QUERY_OPCODE=
_AGGREGATED_READ)=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0goto=20out;=0D=0A=0D=0A=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0qr=20=3D=20&bsg_request->upiu_req.qr;=0D=0A-=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0if=20(ufs_bsg_get_query_desc_size(hba,=20desc_len,=
=20qr))=20=7B=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(ufs_bsg_get_q=
uery_desc_size(hba,=20desc_len,=20qr,=20desc_op))=20=7B=0D=0A=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0dev_err(h=
ba->dev,=20=22Illegal=20desc=20size=5Cn=22);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0return=20-EINVAL;=0D=
=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A=40=40=20-161,7=20+16=
6,8=20=40=40=20static=20int=20ufs_bsg_request(struct=20bsg_job=20*job)=0D=
=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=C2=A0=20=C2=A0=20buff,=20&=
desc_len,=20desc_op);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(ret)=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0dev_err(hba->dev,=20=22exe=20raw=20upiu:=20error=20code=20%d=5C=
n=22,=20ret);=0D=0A-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0else=20if=20(desc_op=20=3D=3D=20UPIU_QUERY_OPCODE_READ_DE=
SC=20&&=20desc_len)=20=7B=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0else=20if=20((desc_op=20=3D=3D=20UPIU_QUERY_O=
PCODE_READ_DESC=20=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20desc_o=
p=20=3D=3D=20UPIU_QUERY_OPCODE_AGGREGATED_READ)=20&&=20desc_len)=20=7B=0D=
=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bsg_reply->reply_payload_rcv_len=
=20=3D=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0sg_copy_from_buffer(job->request_payload.sg_list,=0D=0A=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20=
=C2=A0=20job->request_payload.sg_cnt,=0D=0Adiff=20--git=20a/drivers/ufs/cor=
e/ufshcd.c=20b/drivers/ufs/core/ufshcd.c=0D=0Aindex=20d3044a3089b5..a366224=
462ca=20100644=0D=0A---=20a/drivers/ufs/core/ufshcd.c=0D=0A+++=20b/drivers/=
ufs/core/ufshcd.c=0D=0A=40=40=20-4108,14=20+4108,14=20=40=40=20static=20voi=
d=20ufshcd_host_memory_configure(struct=20ufs_hba=20*hba)=0D=0A=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0utrdlp=5Bi=5D.prd_table_offset=20=3D=0D=0A=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu_to=
_le16(prdt_offset);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0utrdlp=5B=
i=5D.response_upiu_length=20=3D=0D=0A-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu_to_le16(ALIGNED_UPIU_SIZE);=0D=0A+=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu_to_le=
16(ALIGNED_RSP_UPIU_SIZE);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=20else=20=7B=0D=0A=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0utrdlp=5Bi=5D.response_upiu_offset=20=3D=0D=0A=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu=
_to_le16(response_offset=20>>=202);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0utrdlp=5Bi=5D.prd_table_offset=20=3D=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu_to_le16(prdt_offset=20>=
>=202);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0utrdlp=5Bi=5D.respons=
e_upiu_length=20=3D=0D=0A-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0cpu_to_le16(ALIGNED_UPIU_SIZE=20>>=202);=0D=0A+=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0cpu_to_le16(=
ALIGNED_RSP_UPIU_SIZE=20>>=202);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=7D=0D=0A=7D=0D=0A=40=40=20-7638,7=20+7638,8=20=40=40=20s=
tatic=20int=20ufshcd_issue_devman_upiu_cmd(struct=20ufs_hba=20*hba,=0D=0A=
=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0/*=20just=20copy=20the=20up=
iu=20response=20as=20it=20is=20*/=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0memcpy(rsp_upiu,=20lrbp->ucd_rsp_ptr,=20sizeof(*rsp_upiu));=0D=0A-=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(desc_buff=20&&=20desc_op=20=3D=3D=20=
UPIU_QUERY_OPCODE_READ_DESC)=20=7B=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0if=20(desc_buff=20&&=20(desc_op=20=3D=3D=20UPIU_QUERY_OPCODE_READ_DESC=
=20=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=C2=A0=20desc_op=20=3D=3D=20UP=
IU_QUERY_OPCODE_AGGREGATED_READ))=20=7B=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=20*descp=20=3D=20(u8=20*=
)lrbp->ucd_rsp_ptr=20+=20sizeof(*rsp_upiu);=0D=0A=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u16=20resp_len=20=3D=
=20be16_to_cpu(lrbp->ucd_rsp_ptr->header=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=C2=A0=20.data_segment_length);=0D=0Adiff=20--git=20a/include/ufs/=
ufs.h=20b/include/ufs/ufs.h=0D=0Aindex=200d48e137d66d..01bf9a8c8bb3=2010064=
4=0D=0A---=20a/include/ufs/ufs.h=0D=0A+++=20b/include/ufs/ufs.h=0D=0A=40=40=
=20-25,6=20+25,7=20=40=40=20static_assert(sizeof(struct=20utp_upiu_query)=
=20=3D=3D=2020);=0D=0A=0D=0A=23define=20GENERAL_UPIU_REQUEST_SIZE=20(sizeof=
(struct=20utp_upiu_req))=0D=0A=23define=20QUERY_DESC_MAX_SIZE=C2=A0=20=C2=
=A0=20=C2=A0=20255=0D=0A+=23define=20QUERY_AGGREGATED_MAX_SIZE=204096=0D=0A=
=23define=20QUERY_DESC_MIN_SIZE=C2=A0=20=C2=A0=20=C2=A0=202=0D=0A=23define=
=20QUERY_DESC_HDR_SIZE=C2=A0=20=C2=A0=20=C2=A0=202=0D=0A=23define=20QUERY_O=
SF_SIZE=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20(GENERAL_UPIU_=
REQUEST_SIZE=20-=20=5C=0D=0A=40=40=20-464,6=20+465,7=20=40=40=20enum=20quer=
y_opcode=20=7B=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0UPIU_QUERY_OP=
CODE_SET_FLAG=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x6,=0D=0A=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0UPIU_QUERY_OPCODE_CLEAR_FLAG=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=3D=200x7,=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0UPIU_QUERY_OPCODE_TOGGLE_FLAG=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=3D=200x8,=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0UPIU_QUERY_OPCODE_AGGR=
EGATED_READ=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x9,=0D=0A=7D;=0D=0A=
=0D=0A/*=20bRefClkFreq=20attribute=20values=20*/=0D=0Adiff=20--git=20a/incl=
ude/ufs/ufshci.h=20b/include/ufs/ufshci.h=0D=0Aindex=209f0fdd850e54..682104=
fb7390=20100644=0D=0A---=20a/include/ufs/ufshci.h=0D=0A+++=20b/include/ufs/=
ufshci.h=0D=0A=40=40=20-18,6=20+18,12=20=40=40=20enum=20=7B=0D=0A=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0TASK_REQ_UPIU_SIZE_DWORDS=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=3D=208,=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0TASK_RSP_UPIU_SIZE_DWORDS=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=208,=0D=
=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0ALIGNED_UPIU_SIZE=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=20512,=0D=
=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0/*=0D=0A+=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20*=20The=20aggregated=20read=20opcode=20can=20return=20an=20a=
ggregated=20data=20packet=20of=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20*=20up=20to=20QUERY_AGGREGATED_MAX_SIZE=20bytes,=20so=20the=20response=
=20UPIU=20buffer=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*=20needs=20t=
o=20be=20large=20enough=20to=20hold=20it.=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20*/=0D=0A+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0ALIGNED_RSP_UPIU_S=
IZE=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=3D=204096,=0D=0A=7D;=0D=0A=0D=0A/*=20UFSHCI=20Registers=20*/=0D=0A=40=40=
=20-497,7=20+503,7=20=40=40=20struct=20ufshcd_sg_entry=20=7B=0D=0A=C2=A0=20=
*/=0D=0Astruct=20utp_transfer_cmd_desc=20=7B=0D=0A=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0u8=20command_upiu=5BALIGNED_UPIU_SIZE=5D;=0D=0A-=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0u8=20response_upiu=5BALIGNED_UPIU_SIZE=5D;=0D=0A=
+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=20response_upiu=5BALIGNED_RSP_UPIU_=
SIZE=5D;=0D=0A=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=20prd_table=5B=
=5D;=0D=0A=7D;=0D=0A=0D=0A--=20=0D=0A2.25.1=0D=0A
