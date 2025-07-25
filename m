Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D4418027
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753410404; cv=fail; b=L6L9rLbFYBY+rx6wAdmT3BB+C1socS0WA0PmkV6rX5gd3lgR2h+JSYlrrrhqRpsS4R5PPDRhr9XBr21McgoAEZNE0zP8gDyyevGTNP3omEjGwb5ratUgc+BDeA5AYtY/mPlPm0RFkg9hHZryp3NdgoHurRJ7T06vLOR6s8Tdpl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753410404; c=relaxed/simple;
	bh=XtxPZXbEwa9jtkONgJCKdkH2Nhtp4tFvJII0V5zPQy0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nBIt4rl59ESHO5SLgm3x3TluNgDrAZmw3FyrW72JZWxlZgFlcUmQFYyyGWqaKPAKfy5+a7q7i65oiGTNqQKK+26r1MYMSLUjPGqc5lZ3pV+s/Ym6LqXSUobKF08rnfmEJz6UvGoWvElpsNNWyBnp077xmRTykAhHX0XDAi3oRG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j93zzK5y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SKhvM6Re; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j93zzK5y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SKhvM6Re"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONvea0002515;
	Fri, 25 Jul 2025 02:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qC0gMlh2BJXEf2aTk6
	S+Cx+k+nbjZB1k1Agdhb5Y2yA=; b=j93zzK5y+Sq8Px1scxmSyrJ7pymN+vI29P
	CqhqJPFr9EMeoAgZfqvF6Xkb7GtOdmm0cQpjb75Faji9m5OJ83z/9Dsgmg4XwQ/0
	vdazdBNVggzDWbKHJwT3fHzJQ0Fiuhl5DAyyUB/Avy/NY8PdrkChuIWwZLs3QK6z
	AY3glLXjcmwvh0Q2RHiAFN2DGrKEuWEZMiJO+rWsx3cETbTKmap0N1Aav0dQc2r6
	UC6g3aBwkEqn+5LoFYNatMCBAaqx4uv7U1hx8QV4B9U3oMAXPEL9/2Az21Fzj3Jc
	w0vjNoMr+iMFf9PIpO/U5WP5s4Yxbqq6XlceMkccMANYNELq7WmQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jg7ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:26:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONkI9n037748;
	Fri, 25 Jul 2025 02:26:31 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tckdua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:26:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVzBcXDzXExx9vpkJS3dRhQiaWtcuamQlw4hliCJg71+6qmGDzwMWWqkCm7NDSSQRXWGGGZxgM/Qq8Pzj73zvZENYsvOO/qKRwCFfqfOYhEj136kGk36WAP1rTsOoFcpBZGJfLn79C6rXGX/cxN1a8iC2AK6gvbWLgthukia7UxIN5asKZVMrACjcr9a8ZuOIVxqyhApnDADNAs9TRmGIvlAdHSBf58i2rd9FYygZ+bO8d1YoWA2Jxw3M5giKujzN0y+W4w7pWOapOLuDKkltN6Tuwl2SPKM1DkDXsg2R6EpCKAgBuxtHDf6AYz4NoAFqgd3NpVa+lxEME3STG2Jbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qC0gMlh2BJXEf2aTk6S+Cx+k+nbjZB1k1Agdhb5Y2yA=;
 b=NkgyeYnFoZJo461wAvVpMeGjggPQWo9WXHHK6cE8gVcI+zwovzCb5RQlLPCL5s5u+jDWI8zlOOTNILj8NDo+LRNUjRetrx0RrtCk/lZ7haHnBbK48L7GJJS4dhrygySYjN6rPoYOKvH2AWvktP8t7bTe48xbLuCB1Nz8cE5QT5aD10X8rEp7xe//MxquSXKWBRY8I/Y633BZhJLvq4q28qVxRGx/qurwUGjh3kukOEdy8qFYFiXjlf9JOAJRdFyAuupWxCMq0OWuWdbx+tsiN/O/u+K1F2RnGVD1mYofAUQTQQ1bkN2yBbdl3d1pLAB0PGmC/JiEYEAtrIg2SkjtSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qC0gMlh2BJXEf2aTk6S+Cx+k+nbjZB1k1Agdhb5Y2yA=;
 b=SKhvM6ReRp8Dhkytomd/GdJYQ9ofdt/+aTYs+WyaAF3HWgA4LJXAD0MYeHfy86jzhIk6S1S8Z69NZxZ31Jsq0ROeGzS9Xng4ngoFE9ysNeudMspWBfdu/d/Ema7QXSR9IfI4m7CazmQoQJ3Ir0hf8YflX2i4E2+ZjrYZn3E9UoM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7694.namprd10.prod.outlook.com (2603:10b6:510:2e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 02:26:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 02:26:28 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v4 0/9] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com> (peter wang's
	message of "Tue, 22 Jul 2025 11:07:15 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jz3xqa4f.fsf@ca-mkp.ca.oracle.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
Date: Thu, 24 Jul 2025 22:26:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:a03:255::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: d506d8fb-a39f-44f1-0fbc-08ddcb22a90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?thuiZMbvYEbR+6r4/cFmG8qjudtmlqFhCunN4cKzHM90NLCgNZC62c7I8iZt?=
 =?us-ascii?Q?EeGUe2O/4PZbs9pgtYZlmZhTrWjXRVJQkIAZCwJsPum/o6TNQLDFaUVHQLQh?=
 =?us-ascii?Q?LbZOkJZcKFiDeWVp3LBTM8waauX2eFDdZn73M4TWIlcxwHTeSVX7w3TP2MhA?=
 =?us-ascii?Q?WBEDl/3z04veAijXZXE/Dw8zqP3/GDL8mcg7CUwxGqP2Dki7b2bCqxXx0QYK?=
 =?us-ascii?Q?QDpKL7YECBxhWLiwR1h+Dbo+N2vWyL5PX9ISdoihMECXywkzl5k8F/M7j29h?=
 =?us-ascii?Q?ILdqyL18Ycqn165iVueF0dDOsVDWABlm8fEcdzfh6h3KUvdcsPubVUpteXPt?=
 =?us-ascii?Q?Fj7ZNQviLtzzjIb/VgmEy+xSar4w4I1eAKw3jjSIhg2c96Y+Ppwn8Kr3ui9v?=
 =?us-ascii?Q?O+FJHfXl9EtME8xO5qNmESvgpMC6dEIxyHXY2ha0K4LJhb/OtfBcz6/tm+5R?=
 =?us-ascii?Q?yt2lwpbeRpcc/DhORa9cpiG1IoO45+M6T/vYj++7KyE2p8vZxRLmGy3frYS6?=
 =?us-ascii?Q?N6O6ZsYSdpTYxKPXF5fpPp3I7EkPJ2o06f7libt7dYOdJ+nJW5CsjH+WV4cc?=
 =?us-ascii?Q?FSuLjkBAZ/TbselcT3IVaayCn5fA1/MNMpd4rnXvzEAALGUAZ0s5/yv8WyTo?=
 =?us-ascii?Q?nB+J11EbfY9Px3K9IUFx4cu/D8et+vX9TnzF/r58nbJ5BbRHpr6HP8u52x/H?=
 =?us-ascii?Q?ut+7vxV5JOIplCOOlThyzEXrhjZg7YomMdqwknNuabtHv3hbI8wI+b0ztHIG?=
 =?us-ascii?Q?o3r7ZNHpvEZWFDUkoDXsGxDwj1DarxdzNQNirukLLPXJ57Yt1wHmxW3OnLmC?=
 =?us-ascii?Q?qr8SKF9IKk4KEeXUIt7NkyvQF0ft3JPDQI9NQ3SIGUdKIGDj4ThmMBKUbOXf?=
 =?us-ascii?Q?g5OE8zB4f7OYFEMl3e+xeESom/BrZTjVfFu096VaO/knHu3rc6bgHK+7H+V7?=
 =?us-ascii?Q?Ic+sCJh6OVCPPIV2b1gZUNibBM/omZITj1LIVMPgRmorDecrfeG9OvRCYIA+?=
 =?us-ascii?Q?1CgXwkqCNlSuT1KEstsBv1Va2AvNmuM5fzZ7XSYBNhJgCi62pifpxTPTU4Ee?=
 =?us-ascii?Q?p4YNIX3ftV/4vUZ863ZERBfrC9A+973MIPaXmRcNisYCCnStMDXEzHOQYWPn?=
 =?us-ascii?Q?XP6gM0ohgUm5Wbp9pPa5npPV1p8wqn12XFh4meG9XvcVdvewPZ222di21YLv?=
 =?us-ascii?Q?IzeNSqY+nBEYhk6bjTSUr6+I83ggppyUPK6VYKLbcKRaDjqFtsEDsBL2AqMf?=
 =?us-ascii?Q?38Qwrxgd4SRWuuDIHspCjaQMMQuIrOj09BVbgQJnmU0TOygqQ9a5DymbE727?=
 =?us-ascii?Q?+9n3CFqpPiNl4jrd8eB+KPnwHCpbrVPOivbpH2mvqegD9LTDgDkRQf1sEvWW?=
 =?us-ascii?Q?KljgDNQkA+LpY6UC/ucZXJysSrpsvVMSH4UhFidNl9AjRPXBVW+nFkDag3w+?=
 =?us-ascii?Q?7evy9JZlM0Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q7MhgkWMn13N4KNuUUXNgH8TrVbysqRNQqD7xK6HkFAhqJIvfxIUwRm7cOYH?=
 =?us-ascii?Q?btGYa9VNqihZpF39/ROEaNHziDHIXRgRCVsA3+dB5Jq2ZY9WAqpZSdkChuSS?=
 =?us-ascii?Q?yeo+SXRigB2aMKZDREqnxR6tQdO0Xwj+RjNxTcRNGibX09Fl7xbrnK5Yy2Ww?=
 =?us-ascii?Q?IKwiEl5NIEe22wV+HetweBrZx3lhHN7aykxU/Uj7ItbOnWwBx++Bv9nkyWRf?=
 =?us-ascii?Q?AbwrK/PLq+YsEmQwJ6uyoXz1bfHwK8qCYQ2YkEIMiAc5F6R22ejnGsZVkovT?=
 =?us-ascii?Q?42lfZcXt4aq3R0w/U7fEjeHI6ggrxqDg8kDhmAKyc10rWwnd9lweLMIamXjA?=
 =?us-ascii?Q?g/wIBoIrCf3YjcYUSVlBYOpzP6W8xBC2zEP6dT9QghKWmSlfAD/qTuSKvWys?=
 =?us-ascii?Q?UTpHIyRb/s3vO+1eSw/ElyDNhSwNTkZlH8Jg796rnr1xJUAIo1A5HCttuARV?=
 =?us-ascii?Q?ldY87VQyYV6l9XJpPYkhRD8EZ44A4cvbbtRC9L60StT5nN7I0wOMz6FURBXg?=
 =?us-ascii?Q?NGQR0HzjsbjveQuEvGSDbo5cK6U2b2AoBix2kdqJQb9HYqjZQC7/QQR3S5Pf?=
 =?us-ascii?Q?gNcTdRTWWf4C2/cEywQj8QlkGOp5i70ZrZ/j2WJ0giScR23XyFoy7CQcYO1E?=
 =?us-ascii?Q?x+BpUkctOswVB3hDNrqCZbq4BxKVchisiTRYHqTqdTxesnzw2e8+XBmgzXZG?=
 =?us-ascii?Q?cO3azwUm3BtZc5MdHaBckY2KvtJITdqoPAo0wYU4nuhvPz9vPvv3eY0eSTFk?=
 =?us-ascii?Q?UqpiJKm48YcfAgrLiGMXY9s89fl5nw/lb4nRqbgsiwAJwJNrzVOKLAUJIP3z?=
 =?us-ascii?Q?lL91u/qO1b3fKEaUzB9Ri0NdveWsk6yWDgAbNd9LlC6/0HmJ0HUIMAvdp3xw?=
 =?us-ascii?Q?L4Gt7/RwVNmPSe2R8oknPzu/85fnzfp5ZvI/nlVVNqVKGUkoGOoE4mInYHJC?=
 =?us-ascii?Q?jTnu12nxfP8uxLzGq0Yq0v0CCjXcXuFOTrcbv/SKZBU1XE6iAxzzH4r1RqcY?=
 =?us-ascii?Q?XEIsKA9N/HQf5uzW6sGXY4kMVbl1WR13eXuVXxxc53uTQCErLQOMVVZAVSXQ?=
 =?us-ascii?Q?nPcCpFScvocoRnqPr40gUXltIJyOPNoJSeb3RvzjZaeZATEU0q2iAz2ljXNZ?=
 =?us-ascii?Q?ZoT6b09i150kwy5QZgkOtItGIJyTtHTFZmnwZbdiBIr28Wumu73/wPtyqHp6?=
 =?us-ascii?Q?+6g/C4MfTsswip1bw/E3NfnZ/+bKNSc/nKHK8ZYjoweh4Dti2AR1mNaJ7J1y?=
 =?us-ascii?Q?+CNSphLI1U/TrNeYcnSonDrWDiIsM894SEml8tAjwHDSTg/AcZ/gNIMUlJYb?=
 =?us-ascii?Q?T5r1CXxEwT7Cf3ZfQnVn3rfTbOHN3Qx52GaNLl37a9sbMVPSNoe0TWHmQ6Bm?=
 =?us-ascii?Q?rWzogM36VcdCB87QRjCoSHVpM11Np87U7cSyI5h3WSGPfUXde0Ie0BfJSlTx?=
 =?us-ascii?Q?hrFhvHtBIqObYusVwteYfzS7Nf35oZ3U0s9qcIbmRcOxjNGzSiDcBner62iX?=
 =?us-ascii?Q?whFKoWVvOy4sY51YSkvHwvJLYss6feECuSgnWKL0Z5E5hf/+ELipu5K9uSr6?=
 =?us-ascii?Q?7wH94pUc3sX+HzkQFA3uOoCPMggqKfbYkLpr9NZZk9GHqxx4jVMUrUku+9UU?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	03Gt/xBdwP+svAi5IcQayHJhmYBeA/02MihoI8SU7dpvsR2Yyyn+ZnT2DA1J9JyPIAkCmOAaDo/sWMYnlburthlZayeBRXB1HIwpLD1ozIKJ5tMcOA0fY3vMZqRJ4U4rYK/9zVbFQOoySUdP/ZzTR7MsxHdrAQHwQVeClG8FEaEBL5L9xPnODFkEUO6iwlN0Aqy5jumO9nqXUmwrLA5JQt2P1j760rSJhA37Q3pjgICX9jU07Xzhx2RZ+asbwOFA0Qd9Zkl8C2vJDi4WcUHHFiB+tHpQ3T5v/+CPK9kYYTiD8uT5+68DcCu3osPZOooz9FC+/ZEodgw4YsBmoFmapSwGEF8lxeJ7fRtcfDWwjcPfp+YXU7c2/T7k0D3EE1Yek7DwrVR+chyW3e7FoUntguoHkAcBj8OxD8K5Yh1mjo8wZ6xoD6sKaj1fTkdbIbj9hWms9UCvFPfokwQ9csdqS7mDRenDHK/cUgLjQwOFZftQdR1tLdc2if80Xh6nvxWDiVDURmVzrGbt1heLsRPSmdtfteAYkGM6PP9EvsytXMyjCq/x1DllSpYz2tlw0t8FQ31T1zmWac9panNyZrZ+HMumQ2td3MFi8ps7lcNBX+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d506d8fb-a39f-44f1-0fbc-08ddcb22a90b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 02:26:28.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Us7PBBkasgnsTtpYAaddm/4BegGXdqJCau2ySpoqIt1roAYKSV/vIj66kkdRakW22OkicYtudLaLeOJZ9eveQ0rDG6+DOrdMo2PIQZ5SGUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=730
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxOCBTYWx0ZWRfXzYyOBezklKxr
 xweay1vbEwueKV74lvA1zzP/h7JVigi9bBGo9qQVr8uNksZvQ7Nn+CVLuoAQu2srsddzyrFHUYS
 9RQmAP8kXYyhPj3A2T6L196OaWgiRDR8jofiBRwgoDnQDRaneIdSvtDoDYvNgUr6QFHvQye3RGB
 JWwCGM1JcMt2Kn3a9IklY22+P6CYNj6WvTSeRR1yXTUMd/rJyZcddV2KBqEaeZvOVmMj6mBAAOs
 kg1bquxJZKXbmfnl8QmLz4ZmELBu3A0u57NcByYhWuQRYMEFjBQm3s16HI3OEyNoxC/eHrOoTqH
 KIpFIzdIHR56A+LBk5IzxONbAO10WLSANSFXz2OCM/Z7Y/jZ4cMVqF8Mvz95aWvVKmwJB/WJ8M9
 j/w2YDETONQH8Qld7IZz0H2JNnqdMCS1zCyQ5+dfE1RnRNUq7wywV0YqgrWadiQFIz2TvV5z
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=6882eb59 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: UeBhKpSLFZGdIwxi_Q4F_vpUwfY3d0RH
X-Proofpoint-GUID: UeBhKpSLFZGdIwxi_Q4F_vpUwfY3d0RH


Peter,

> This series fixes some defects and provide features in MediaTek UFS
> drivers.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
