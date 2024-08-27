Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291E27A724
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 05:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724737908; cv=none; b=ebzxxD5o4hFtsi1DXR7nKVyjaah1tOxU/3Yv2A08NqYl3q7Kewv2D0tIX3XJyGdPjK06rU75EwzLixROV6Cf4C4qFR1L9IXFuFQS8x8kK4FlyF6Fr6dC1Cea/2Pt++EpgP3nkL/0TYpAn/0OPNqMsLFNpeEnA4g9+bQ2ppZZBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724737908; c=relaxed/simple;
	bh=H4SqrKxbbms/TKR6VFH2CjRPGaupZXMzHQXudJVoVnQ=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=a04K2HtPHh/oq57cbbYIl4KzFE1jf5FrsHhYaspI/P2BPRFi3v/YWNgsTw5IucST4mPuBNXZR6WH/qJo3YR1coWxsgaFY2EDNXUBIufWhuXYB33FBrYJx+IUmC8yB6JlkgLpudHDnW9d36d4odLDa9yomzsJgsh0vNVIBjqaCqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VnbD3Ia5; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VnbD3Ia5"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240827055138epoutp02e72cf0f5c0189de647fede70788413f1~vf-sFjtP73271232712epoutp02R
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 05:51:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240827055138epoutp02e72cf0f5c0189de647fede70788413f1~vf-sFjtP73271232712epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724737898;
	bh=aVZJQ6YVRI3NXzm7OS/VeDi/Eu2tzJcO0QF6xhHFQvA=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=VnbD3Ia5On3B6/eNQCPEIutxkpw9QEcMRRB5wqKWQlbl3YVsCeyPeyV9kUndC1OQr
	 8G5+nCuzbbN2CkwNOKxNCeZQ8EheBcFaqYlPlzZe0x2F28fwYT9YbrLJcThsa8qipY
	 bnkeJ1sVAuItpNCkgkrRoVheLUAogtfBdlvQn4VQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240827055137epcas2p3d496bd4408f94f90c18d6e015f3530d8~vf-rjqJhu1622916229epcas2p39;
	Tue, 27 Aug 2024 05:51:37 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.98]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WtGrT0Hn4z4x9QB; Tue, 27 Aug
	2024 05:51:37 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	47.C3.10016.8696DC66; Tue, 27 Aug 2024 14:51:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240827055136epcas2p39ea31d48a51c38e855440eb9c81a4302~vf-qPQT-i1622916229epcas2p35;
	Tue, 27 Aug 2024 05:51:36 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240827055136epsmtrp1efc5518c066d0f427afef44ec6af3656~vf-qOQg7h0833508335epsmtrp1B;
	Tue, 27 Aug 2024 05:51:36 +0000 (GMT)
X-AuditID: b6c32a48-4b5ff70000002720-d0-66cd6968aab5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8A.03.07567.8696DC66; Tue, 27 Aug 2024 14:51:36 +0900 (KST)
Received: from KORCO164647 (unknown [10.229.38.229]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240827055136epsmtip1cb813a425e03e4b76a530d7b1c976134~vf-qAb3gC1617216172epsmtip1O;
	Tue, 27 Aug 2024 05:51:36 +0000 (GMT)
From: =?UTF-8?B?6rmA6riw7JuF?= <kwmad.kim@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <beanhuo@micron.com>,
	<adrian.hunter@intel.com>, <h10.kim@samsung.com>, <hy50.seo@samsung.com>,
	<sh425.lee@samsung.com>, <kwangwon.min@samsung.com>,
	<junwoo80.lee@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>
Subject: RE: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
Date: Tue, 27 Aug 2024 14:51:35 +0900
Message-ID: <011201daf845$2d7846e0$8868d4a0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMVAzAZ81RvDzfQ3MBmGZ181G9RyALYKPinAVEwIPSvpThKwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJsWRmVeSWpSXmKPExsWy7bCmqW5G5tk0g38dZhYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxeVdc9gs
	uq/vYLNYfvwfk8XSf29ZLDZf+sbiIOBx+Yq3x85Zd9k9Fu95yeQxYdEBRo/v6zvYPD4+vcXi
	0bdlFaPH501yHu0HupkCOKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOA3lBSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgX6BUn5haX
	5qXr5aWWWBkaGBiZAhUmZGfsX/+BrWAea0Xb8s2MDYzdLF2MnBwSAiYSGw9OZgaxhQR2MEr0
	tuh1MXIB2Z8YJY73r2KDcL4xShz7NJUJpqP/6QVWiMReRokZxz6wQzgvGSVOXJ/FDlLFJmAm
	8fzOX7CEiMBmZokTt96BtXMKuEusmdIHtlBYIFhi96LFYDaLgKpE+4TprCA2r4ClROfheywQ
	tqDEyZlPwGxmAW2JZQtfM0OcoSDx8+kysHoRASeJZT3H2CFqRCRmd7YxgyyWEHjCIfHhyz82
	iAYXiYPPvzNC2MISr45vYYewpSRe9rdB2cUSa3dcZYJobmCUWP3qNFTCWGLWs3agZg6gDZoS
	63fpg5gSAsoSR25B3cYn0XEY5GGQMK9ER5sQRKOyxK9Jk6G2SkrMvHkHaqCHxOkTdxknMCrO
	QvLlLCRfzkLyzSyEvQsYWVYxiqUWFOempxYbFZjAYzs5P3cTIziJa3nsYJz99oPeIUYmDsZD
	jBIczEoivHKXT6YJ8aYkVlalFuXHF5XmpBYfYjQFhvtEZinR5HxgHskriTc0sTQwMTMzNDcy
	NTBXEue91zo3RUggPbEkNTs1tSC1CKaPiYNTqoGJw+Qm82HJVTlOF8z1XHv2yVgf2VTr0P1b
	L/ns0Stvmtc6eon+O5F6UPPUvRU78kS8V1ktTCpSeHrtDCPn1gqVpIvNbju1J57QFIudN6ds
	p9rrppMXe/4cuThz94Wr3QtXulr4aT1+qpr2aMExgUc3il7cOiNZwOAikndn59Lty0/c85+V
	lFVTF9vBFrnr97MeD+t6ZsP6yUbfs6Vm9mxb5H2otO3r9WmCDJO67F7+5pDfN7UztOe1jUST
	3I7cHU6Ntz3M68vnc9y17tpf/vL/uxe1e+MrjtkXlJQyOfN/ddf7l7ZflulR5oFWQdd15zvM
	FXyfhTB/4TmgNO3UNAPejDbvH/0H5rCbrZ3ozuWixFKckWioxVxUnAgA+41zgmsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWy7bCSnG5G5tk0gx8fhS1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWsw528BksXrxAxaLRTe2MVns+tvMZLH1xk4Wi8u75rBZ
	dF/fwWax/Pg/Joul/96yWGy+9I3FQcDj8hVvj52z7rJ7LN7zksljwqIDjB7f13eweXx8eovF
	o2/LKkaPz5vkPNoPdDMFcEZx2aSk5mSWpRbp2yVwZTxePJe1YBZrxfRdm5gbGNtZuhg5OSQE
	TCT6n15gBbGFBHYzSuy4Jw4Rl5Q4sfM5I4QtLHG/5QhQDRdQzXNGiZZlP5hBEmwCZhLP7/xl
	B0mICBxlltjXsJcFouooo8S7L1PBxnIKuEusmdIH1iEsECixtv8T2FgWAVWJ9gnTwWp4BSwl
	Og/fY4GwBSVOznwCZjMLaEv0PmxlhLGXLXzNDHGSgsTPp8vAekUEnCSW9Rxjh6gRkZjd2cY8
	gVFoFpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgRHrpbG
	DsZ78//pHWJk4mA8xCjBwawkwit3+WSaEG9KYmVValF+fFFpTmrxIUZpDhYlcV7DGbNThATS
	E0tSs1NTC1KLYLJMHJxSDUyCwca1ktIHGN5MPv3nhHmN3fkOt8zkOYlONwy0OM91nbHRfyI5
	WfnCf+OgGs1rW3db6eZunx3fXsDydvYXrkclLb9q8pQXSBZ92NG26HLfNb9lmf3Vq2T65ZM1
	e3fvNd85YVPbV3O9JBNX8ekak2J9zT9Y/nm/tv/Cw5kZfsWruR+KfznXeS3ZYvGbmBn9b+w9
	7Bn/uF6KNr/ppFyTFHLxtdaihU7//SRn77+i7M8W+slj2+RpqwOY9iycETd1w2pTRqZ3vVlH
	zXWtmjeqsbVmZ2TtPj5RPMGt27gkdiZjY/ITgWX/Zuyf+0F8c/aqyN+bjVw1r2YuZBRmXeof
	XnOkReHG/vY9q9VCFzGsE1ViKc5INNRiLipOBAAafWlLSwMAAA==
X-CMS-MailID: 20240827055136epcas2p39ea31d48a51c38e855440eb9c81a4302
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111247epcas2p2d3051255f42af05fd049b7247c395da4
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
	<cover.1724325280.git.kwmad.kim@samsung.com>
	<04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>

> +static enum utp_ocs exynos_ufs_override_cqe_ocs(enum utp_ocs ocs) =7B
> +	if (ocs =3D=3D OCS_ABORTED)
> +		ocs =3D OCS_INVALID_COMMAND_STATUS;
> +	return ocs;
> +=7D
>=20
>=20
> I wonder if you have considered the case where the command is aborted
> by the host software or by the device itself?

I mean by the host software and Exynos host reports OCS_ABORTED only for th=
e case when MCQ is enabled.

>=20
> If you change OCS to OCS_INVALID_COMMAND_STATUS, there will report a
> DID_REQUEUE to SCSI.

Yes. That's what I meant, in order to process them properly after UFS initi=
alization.

>=20
>=20
> Kind regards,
> Bean

Thank you.


