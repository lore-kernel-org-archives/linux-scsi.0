Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3FC7E9
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 00:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720138844; cv=none; b=mHc2LP2iigSy2ilWfugqFRQhvederPUhSkEzbRW+efnc8s2U2Jmu8OkflIruMnYpCcj0/yAguGmFmxR1CCHRUE9barSfUFe+zd1Ef7V254ZTb4NOJgt1yfT0dm1GlmjgEUNUtYaH8xuBBiF3FIUzV9zt2PGHZIvaeu8EThUZ2cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720138844; c=relaxed/simple;
	bh=J97ZBU7cyOmn9X4h3hI71uE0Po2LAwr3Fvm7oBg9an8=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=CHlEqrm/nLx6imWz5SL9Cg7o117slkXXzmfzm4BhhGP8FgWLdh0asIy+UEz/HG6yc8vHdImsZX4EaVwtjYHh03xzLRC8jbh/9VxMCiO+H/62y6x5ckcTmv7cWiQJZ21qjvz9Xeoo8ihesVvob8BGbG8voqDl9FPlqyxmH+tOVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b0+dggqL; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b0+dggqL"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240705002039epoutp012c25193410961c63e42bb45f27ea5131~fKSkTUKzT1538915389epoutp01Y
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 00:20:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240705002039epoutp012c25193410961c63e42bb45f27ea5131~fKSkTUKzT1538915389epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720138839;
	bh=J97ZBU7cyOmn9X4h3hI71uE0Po2LAwr3Fvm7oBg9an8=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=b0+dggqL6t3QILgqoS3IxHYg/z9Mj89NrPYuOXcKvDzCVq4Dy84xxfocUnUZ400nY
	 a/6msBqS/r1Chdnlz8cso2TTpBpmysq6U9fK2qDnpcuYXBV6I9Mcv7bMXf0hRR2nMb
	 3c/rSDUE+98L0MUWmFHmsu1GG4py17dGnztuWJJE=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240705002038epcas2p2670fcc0c1394d44d4c441cf9024a7089~fKSjt3qpm0287402874epcas2p25;
	Fri,  5 Jul 2024 00:20:38 +0000 (GMT)
X-AuditID: b6c32a48-5cfff70000018d5f-8b-66873c56bfb2
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.AB.36191.65C37866; Fri,  5 Jul 2024 09:20:38 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Minwoo Im
	<minwoo.im@samsung.com>, SSDR Gost Dev <gost.dev@samsung.com>, Kyoungrul Kim
	<k831.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <16e65435-4891-4b5b-966d-15ec807702ca@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240705002037epcms2p56a631f5620bba2f37be3884fb124a873@epcms2p5>
Date: Fri, 05 Jul 2024 09:20:37 +0900
X-CMS-MailID: 20240705002037epcms2p56a631f5620bba2f37be3884fb124a873
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42LZdljTQjfMpj3N4N5VMYtpH34yW9w8sJPJ
	YmM/h8WUTV8ZLbqv72CzWH78H5PFs9MHmB3YPS5f8faYNukUm8fHp7dYPPq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStj6e0p7AVtOhW7ex6yNDAe1epi5OSQEDCReN2whqWLkYtDSGAHo8Tl
	iROZuxg5OHgFBCX+7hAGqREWcJZYeLiFHcQWEpCTuD6/mxUiriPR3fyBGcRmE9CS2Hh8IxvI
	HBGQOfd3rmEHcZgFNjBKXOu9yQyxjVdiRvtTFghbWmL78q2MIDangLXErlMvoeIaEj+W9ULV
	i0rcXP2WHcZ+f2w+I4QtItF67yxUjaDEg5+7oeJSEm2zfzNB2NUSVxt3g30mIdDBKNHS+pAV
	ImEusXL1JbAGXgFfiZ4LU8DiLAKqEv+W7IIa5CKxZNduNhCbWUBbYtnC1+BQYRbQlFi/Sx/E
	lBBQljhyiwWigk+i4/BfdpgXd8x7AnWCkkT7tqtQWyUknk28AHWyh0Tvt9XsExgVZyGCehaS
	XbMQdi1gZF7FKJZaUJybnlpsVGCiV5yYW1yal66XnJ+7iRGcXrQ8djDOfvtB7xAjEwfjIUYJ
	DmYlEV6p981pQrwpiZVVqUX58UWlOanFhxilOViUxHnvtc5NERJITyxJzU5NLUgtgskycXBK
	NTAtXZMRND9Fftmci3wH9z/sMJmirL/l4oXdWgLf3x5drnF7tbb0sy5Libmzv7svvB9yfvZd
	vYM8iu4n1/yauO13QlBCtxnHyWvtv3Z8Pei4121rd7BYmWn/5kidrNwbW9Xvqh5xvVAW+iri
	bqLG/YOsq40YbtUwC87c5zMt4K9X9my16iv9hV+b5Fkf3Ljha79z879D2sIas25Nb+jck1Y/
	v+ikp1XWQeclOow83Jlp/pOnp51njJ41ZfnWlbPlpn8JTGPjTF62Zqv4vzoXFcVlgZLC7yu1
	bsXv6so1XmwoMjVmXlHqRH8up83eMt3vRababF+2e17Q3gVnt3/X8zyxds4p+dNTrzpsv5gp
	vuJPihJLcUaioRZzUXEiAFVSgpKeAwAA
X-CMS-RootMailID: 20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73
References: <16e65435-4891-4b5b-966d-15ec807702ca@acm.org>
	<20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>
	<CGME20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p5>

I apologize for the mistake in the allocation of LSDBS Bit 0-1.
I plan to fix it, lsdbs value 0 support lsdb and 1 not support lsdb.
I believe this change will not break UFSHCI3.0 because LSDBS bit is a reser=
ved bit and its reset value is 0.
=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASen=
der=20:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=0D=0ADate=20:=202024=
-07-05=2002:41=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5BPATCH=5D=20scsi:=20ufs:=
=20core:=20Check=20LSDBS=20cap=20when=20=21mcq=0D=0A=C2=A0=0D=0AOn=207/3/24=
=208:38=20PM,=20Kyoungrul=20Kim=20wrote:=0D=0A>=20diff=20--git=20a/drivers/=
ufs/core/ufshcd.c=20b/drivers/ufs/core/ufshcd.c=0D=0A>=20index=201b65e6ae41=
37..c706645c0914=20100644=0D=0A>=20---=20a/drivers/ufs/core/ufshcd.c=0D=0A>=
=20+++=20b/drivers/ufs/core/ufshcd.c=0D=0A>=20=40=40=20-2413,6=20+2413,7=20=
=40=40=20static=20inline=20int=20ufshcd_hba_capabilities(struct=20ufs_hba=
=20*hba)=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A=
>=C2=A0=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0hba->mcq_s=
up=20=3D=20FIELD_GET(MASK_MCQ_SUPPORT,=20hba->capabilities);=0D=0A>=20+=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0hba->lsdb_sup=20=3D=20FIELD_GET(MASK_LSDB_=
SUPPORT,=20hba->capabilities);=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0if=20(=21hba->mcq_sup)=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0return=200;=0D=0A>=
=C2=A0=0D=0A>=20=40=40=20-10449,6=20+10450,12=20=40=40=20int=20ufshcd_init(=
struct=20ufs_hba=20*hba,=20void=20__iomem=20*mmio_base,=20unsigned=20int=20=
irq)=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A>=C2=
=A0=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(=21is_mc=
q_supported(hba))=20=7B=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(=21hba->lsdb_sup)=20=7B=0D=0A>=20+=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0dev_err(hba->dev,=20=22%s:=20failed=20to=
=20initialize=20(legacy=20doorbell=20mode=20not=20supported=5Cn=22,=0D=0A>=
=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
__func__,=20hba->lsdb_sup);=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0err=
=20=3D=20-EINVAL;=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0goto=20out_d=
isable;=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=7D=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0err=20=3D=20scsi_add_host(host,=20hb=
a->dev);=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0if=20(err)=20=7B=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0dev_err(hba->dev,=20=22scsi_add_host=20failed=5Cn=
=22);=0D=0A>=20diff=20--git=20a/include/ufs/ufshcd.h=20b/include/ufs/ufshcd=
.h=0D=0A>=20index=20bad88bd91995..fd391f6eee73=20100644=0D=0A>=20---=20a/in=
clude/ufs/ufshcd.h=0D=0A>=20+++=20b/include/ufs/ufshcd.h=0D=0A>=20=40=40=20=
-1074,6=20+1074,7=20=40=40=20struct=20ufs_hba=20=7B=0D=0A>=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20ext_iid_sup;=0D=0A>=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20scsi_host_added;=0D=0A>=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20mcq_sup;=0D=0A>=20+=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20lsdb_sup;=0D=0A>=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20mcq_enabled;=0D=0A>=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0struct=20ufshcd_res_info=20res=5BRES_MA=
X=5D;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0void=20__iom=
em=20*mcq_base;=0D=0A>=20diff=20--git=20a/include/ufs/ufshci.h=20b/include/=
ufs/ufshci.h=0D=0A>=20index=20385e1c6b8d60..22ba85e81d8c=20100644=0D=0A>=20=
---=20a/include/ufs/ufshci.h=0D=0A>=20+++=20b/include/ufs/ufshci.h=0D=0A>=
=20=40=40=20-75,6=20+75,7=20=40=40=20enum=20=7B=0D=0A>=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x02000000,=0D=0A>=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0MASK_UIC_DME_TEST_MODE_SUPPORT=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x04000000,=
=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0MASK_CRYPTO_SUPPO=
RT=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x10000000,=0D=0A>=20+=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0MASK_LSDB_SUPPORT=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=3D=200x20000000,=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0MASK_MCQ_SUPPORT=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=3D=200x40000000,=0D=
=0A>=C2=A0=20=7D;=0D=0A=0D=0AThe=20LSDB=20bit=20is=20defined=20in=20the=20U=
FSHCI=204.0=20specification=20but=20not=20in=20the=0D=0AUFSHCI=203.0=20spec=
ification.=20Has=20this=20patch=20been=20tested=20on=20a=20setup=20with=20a=
=0D=0AUFSHCI=203.0=20controller?=20I=20think=20that=20this=20patch=20breaks=
=20UFSHCI=203.0=0D=0Asupport.=0D=0A=0D=0ABart.
