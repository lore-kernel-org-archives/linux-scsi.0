Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC202222D8
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 02:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761100059; cv=fail; b=NwhCL9Ut4uWW87VUZsjTb2Rxhsd0KAYarYdK9S+NXXJ1UzSmbeHJjeJdBwIkhRwdCXAiZjxVoaScPh9MV5GSNRxHkqvhgp9E/p6E2/jyE6RvxlYXzOUmajTI5NHyiZE4M0sE/VtoXn325Z4OwUE9wSexMPyU45exY2K3LY1RJw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761100059; c=relaxed/simple;
	bh=tixs6uITtrQTB3oXC4/2xYjwWx6ZgmxiIE6hlgKnft4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W7PEwLTf1RqlQnFVW2jT+AXKzPZdiEWKuJjgnls7Dmaa3fXTIwcqjbI/H2B5EOd6Dx6M7DB+tphUHxoilxEN+b0h+uB1sJQ+G1Mx72UesEJFfGvy6PFzcfr5A3ogUFPM0M60JqPX6/IfBkFcw3sc3/XWAj2dHsAAf3jqR2TT4vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YRDaQLEH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ebm1qtA7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YRDaQLEH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ebm1qtA7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M2DIX1001742;
	Wed, 22 Oct 2025 02:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GFg9qJiggRYlAIG1+O
	Z+V9lyt/KJHVB0bEqNIkZ0sJI=; b=YRDaQLEHVELN6Vrtk/DlOMqsRizxLVkgpW
	Xt2QCwKlCeiuzuIX0EL62jqcZR486uwM17M2yjdBqzleYI+Wq6qtIZl2A9t8aDfm
	RnYzXpPAs2txSMIP7JyYlRcPqbNbEiY6bLthhS0IiwvJX9fLan8KlrdiFoO0fevw
	oX9+/LYZ9IjwlDZa5UVL1tLwhXZyVZok8bs/kjvGxvyQC2xr4DUW3SbFi6rob7dU
	kbnXH3Qy25mYuaLcS5hMCGh0BGUAM9VxMap/PHjaCLFEH7C9Irzq59SyarYG3/df
	2uA8Y/5aEEEvjoMlyzzlJjCWCX9qX+Hu50IlOFBf85IdQk6WIdow==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2waxty0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:27:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M0TDQm032463;
	Wed, 22 Oct 2025 02:27:20 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdkn9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:27:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJ7hS2vOzCcI0S7USBRfXEVwA5mjOefmRG/nWHoy3R8rq6dZ7a4cRWklR2BHvFCYxWcGpv/8bol5L95j71ktQmFqhHKnWKY2P2hyNBZduhTGoMszB44Xa6WTdAfetImXP1qRrbyq1MQ7n7nwqEH30g8SzDTVl97s7VwSa65QXxpwr3+mJS1UgMGIuieXhZ7vNsUb/RN+b9WLjGWjqKcbkrl8fFH5zTgslNp4mwC1++JeIORGQlTShf8iqCBOmj2WvXlQTK9a5NIUeSFlxwjkGw5haYy+nAFQ3k6ISV0hRoGFDD5hxAbPVc0IpJnOldYnc7AgPaVPOsy4K8pnNI8XhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFg9qJiggRYlAIG1+OZ+V9lyt/KJHVB0bEqNIkZ0sJI=;
 b=J2Jai78Aj2ILlFR07IjEvnE6I5NvYH88tjKAycPeGDCxtchS4y4bcRV+I6+KkeFyNLiJ54qwsP07M3PXvNNgZEoDm5pSA2jjXBWaHBfBRnwaN1GLnmleEu04LNnQisssV7CENbjkFOfhBqfOwxRZmeWEkinuimFmD/dO6lFjkWJctOmL/W/WIlXMCEfpKC8pfa8a6bnMDEPzgkwqalPu3g2qqxocFBhAE4Cll19DlzKf8V0qAlEPPmWm0WiVj7RU+btrvsn39SvtVWw2ACoLUrMMQbRvV/dr6/SMD/Pdy5A/W8nDQ2KweRqcfC48uXWVhLO9wtSj38u12EzTMVzJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFg9qJiggRYlAIG1+OZ+V9lyt/KJHVB0bEqNIkZ0sJI=;
 b=Ebm1qtA7ob2qHEkWOKNIafp+6fWgJWwTiGVVK+CAl49EVo5TaivnN22aic57lX+W5oXMKbFJ5xMF1uvrqKa5iIT1NVpiCm1nQb4f0p9a92+hZ3pm9P2YBIl/w1c6WOQOA8h4H/By8213T7G0TrLwFWvTnak5cXIQrCCy4b5h6Yw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 22 Oct
 2025 02:27:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:27:17 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
        <dan.carpenter@linaro.org>
Subject: Re: [PATCH v2] ufs: core: Fix error handler host_sem issue
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251008065651.1589614-2-peter.wang@mediatek.com> (peter wang's
	message of "Wed, 8 Oct 2025 14:55:43 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjlz4qoa.fsf@ca-mkp.ca.oracle.com>
References: <20251008065651.1589614-2-peter.wang@mediatek.com>
Date: Tue, 21 Oct 2025 22:27:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: d86a74b0-def9-4c7c-545d-08de1112854b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?14Pex5svLu/SlxVtVqQb4ecqnzGOtVU+TEe/Pf3892sPgEBFEtDYo6jPjGdt?=
 =?us-ascii?Q?x1wVbwV23OhH4a75iyAspeab2IqkRYbb8ipaUWNfVWceQvAz9a31l02Efx00?=
 =?us-ascii?Q?Dn3aZutWgFZ07iD0fqxEfV1KssSnGzVe7Qoh2dVLD29e3Fjn4ForT3FMfPSc?=
 =?us-ascii?Q?UrBZ9oeebGwh+j/gzm+HEp3PSqJT9s7Kn/JHJU8HQZwXfaKmoD+T+FV3CA75?=
 =?us-ascii?Q?h41PmHOTCqsOl55MggGabX22V2XE8ii0wLCqOM5aFf6XWfZnUi9Nbeu3Rz5O?=
 =?us-ascii?Q?rBDvivIj6I6re+ZhKjiTLvEJ49yekVahIKSEqhxgrmFmz1J1pom4gRpmhpsr?=
 =?us-ascii?Q?/nJx0tX1Pj40bsCqLN2Gw/ccKTphmp7o78EYODFGMb4sToDcuQGPxIkUGGfW?=
 =?us-ascii?Q?EgUEjrJYCtW4SITSU/e60j5XXM88UbEAxBj1s6X3BjBqxzdI42l7CWt3o7q4?=
 =?us-ascii?Q?NQlRBvjm2Ly2ezpEdfwv+6Yp98wt9h5IjjnawMnhm4cQtpr5F2XKpSTxJOrA?=
 =?us-ascii?Q?/o5Hfh3nU6usHh7weTu+Kh5Dhk7jyhIV7i2DkRVuMUj5uvBeE3hjpLKIlG0E?=
 =?us-ascii?Q?N2RqpLFO2dpaw/HJTOjjuQ6By2HertIN8DB2basCKy+qSWt0m/BeQ64HhX0Z?=
 =?us-ascii?Q?rEzm1ARs111N71f1UeTyndU0yK+KOfSy9kEIhQaXH5ZcsMxYQfZ3mVN2yg5W?=
 =?us-ascii?Q?ngc5ps7C0h7jPeoSUofdOV+DkF/8WaRWhOFCsN2uRWWJ3R6mlbXf+7d83e6g?=
 =?us-ascii?Q?wJMHREAK5UPxnRgI8buZBXF72VcV9GV3hb/W+nd8Bt7BWS1+7yym/jfnGA1o?=
 =?us-ascii?Q?S7cOOCpPx3eipC+lM/UfcET92Qql4/3hLhZSks0Qx6lDMic1O5/txS0mpQgz?=
 =?us-ascii?Q?MWyowcBcGlRc1WEGPDn6+Vog68mWK8oqMx/GyLzapSUn2ESKQbpXcktlk7cV?=
 =?us-ascii?Q?IsbNS00CwbocTx15Yqr5LLE5KuJw1tH56jReGt78Lk6FJzhqhW5vAEWGEXY6?=
 =?us-ascii?Q?zYEB2SQnZUyjYGYUHKrixCa8zHd0sjh2TDonhmLI/bVWM7q9SAaiUmc+APcA?=
 =?us-ascii?Q?4uy31v1+t7qcHwkIKXdzBkA2X5H113Joi8XPl69CRf1Wu942+sfsszsLZW0T?=
 =?us-ascii?Q?+w5ei+8COm0m5iXoEPeQHqf9lcIMJiYiGCybRSYFMiAxYuIYHA8f8B9Nfi3l?=
 =?us-ascii?Q?Lyzj3rhDFUTVvkp9VmaqzGEcmRXqFuOleqdwTXgQowYmEhHCAMBXCJS5aVYi?=
 =?us-ascii?Q?gVaxarL0jKKgc3X5i7Qjf7KOw2jNRENTeWIux00cS8JNvcD+tdGormoc4Cu+?=
 =?us-ascii?Q?u4LAnYKjQMyUqp52yrh9mGX4KYXnnyRPsnhg75BklflD6bX6G1xxOXvTQYxT?=
 =?us-ascii?Q?YxxZalPuSrZ9F7R7cLx+T3ZM3sOvcXSVoFFUk53Jf/BEZtC5VVlWEaNOpxeL?=
 =?us-ascii?Q?TbUsoe9ea0asBwR5LQIu5eJomXi5+VTT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vS+Vz8bXanehzz5iIZVteYUzyjDji2aYhkEAeLoWxE+D5B4cepfQrnfgWb3v?=
 =?us-ascii?Q?DJKlgBwnI5H3xuAdCfRh8ume3yDqbWHc6x8V7z3GRa0t6SZSL1RzhZ2zK9mV?=
 =?us-ascii?Q?c7B45XNTlWc6j2hfLRJgN7K7e9egCaK2w/SIlVniQQMgFibdwkTVjF73sL5M?=
 =?us-ascii?Q?7Bh1nkfCjXxUisp2t1H0eqUpURxwryfQYiULmizJe6CID+JPHRsb2LSomm+/?=
 =?us-ascii?Q?stx4VSSmVaoF1MLzSm1Fh03ttG4CJkvgrm/xA7LLhi7q4Xprw5iY0vHsNfXF?=
 =?us-ascii?Q?YEmYVaBaoFa0oZgwp3gdtSZ3aT8mu6cbwuL8Vhi1be15eDkOPBTdXR19y7/t?=
 =?us-ascii?Q?HchfEIlRleFrprGS7pkGaIo9ea73zw9rB4im9dYp1arzrLYdAXl/oz4IT+tw?=
 =?us-ascii?Q?sjkKkEgnWk4KzxWTpdqwzZI0WMK9Xmi3JGt9WATJi6hHqQcUvXLsEkADSXPK?=
 =?us-ascii?Q?vZvEigOyzHAYsNCtrI/1DGswQNM4o/375ZdWdu8gWP0+3Vh9YWSm5Blfq3TI?=
 =?us-ascii?Q?mTL5ZAKn3H4gS6THGOnlsfzd7EGIwiU5GvWRcTOcAtXjnLK4pEvwXFXMmojM?=
 =?us-ascii?Q?hqq62rluIXrO8i4OHiAjy/E7A9ZG6tLZptwcgJtd0Qyh+Z21ZJYTDEAEn9th?=
 =?us-ascii?Q?oTBh8MkzkMQFWakgkuMscIcreYur6Jta5aep6D4EmGFfONDW6TgUyomurvtU?=
 =?us-ascii?Q?KAgpxfKTrICFJwFgHkDHw/xWLE6Z5b6Y7uzqVpJPb07YGLd5OPv/pHbd7ru8?=
 =?us-ascii?Q?ozcod4APtNvcvgbo8wMPXFBnWVfhGvVL2MPOncU//kViqBkhSgr/qPVk0UD2?=
 =?us-ascii?Q?ovbxBefshZ9iIZY5I9iDpRsnMvWEzO6q9heIQkSlb8U/ybroL1nOceftHfg3?=
 =?us-ascii?Q?ENN22KHjRHv3V60tZLGw1UZtSPT2OwwR9qCWAhZTIQle1lkYKuQwJx6ISHcj?=
 =?us-ascii?Q?jCmNUGgbnkw+SlnenXgLoKyf5BnJ+MJF7pYWnLSjXOc5qRhcKuE4cyllEdVe?=
 =?us-ascii?Q?tADQL9Lg3ksiiHO0h0Wuq2Uui+aB6QUX1cszytfMaJ632/5giV5xyyTNBio6?=
 =?us-ascii?Q?xn7cFZJH/TxaAngobmZACgxzAyjZhlsyKOstPCD85tb8ZMWdCC6lYH1ShNsB?=
 =?us-ascii?Q?ziCr4w9nb9B77z2o+8M6Tn6yFSDoVtIobuTobjTsPM1tqGOvaIBpDOhGARZj?=
 =?us-ascii?Q?RBPNqaPp0XthpYniZLEk3FloF0Rfb9w0Lbv750SwuT7XzqiXJobh0dSoH2Ht?=
 =?us-ascii?Q?DK2KZMWLzfuTmpa0LlFbo5bJtu1ZjFdSGIqm3hjs4odPNKl14el3JVBq9bxw?=
 =?us-ascii?Q?di7wnJUCGN+VWjrfSPuIGoxBRl54pGJ2/TZtGdGC6tFaCJR5z2eCkMPFXkH6?=
 =?us-ascii?Q?E1nIHwQajAn/tvKSdmgivLuoFCi8/6cHb58D4C4rzlf64g349tDq7kpGfmPw?=
 =?us-ascii?Q?vJAD7jd8aWQ7+2m7iCUVBcQMnTaEzflGlEjBU5s7JRIZ5bv6fyQ7vHb0qoXA?=
 =?us-ascii?Q?vdm/ikZrdScffBp/wS3jpdR5BvTsOsY4+rHyH4qvOtqcCb6kt52jW6INxEnu?=
 =?us-ascii?Q?w1uF9ZkABL80UtJ9go4urwAWLM0FszMhER6pucocnPef5iJ5zy6u0lP94EPw?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tlyU5LsDMBlDImpb7DkH9J26IkwCmDCsV+JXP+eivl7jUcRFXEP9kBq4YNru2o1vrwF49K3Tk4YUbvJyt5RRuaVbFjqyAChFM+1V9vfZvLcGrRWwYSB7L7nOQWf163LJT5dMFIwtSGk1MKIAPSO/VequIA9mxXkS06NKYT50eZ4uWIKCml5fqkA9DOpMc/BsCo/HxoIbLmSfpWHklHUAJqvB0sML+89yqLuJ5TUfl9klKC5W4IkGyoDoAj7dYdHmTy1aYxMF3KliwlNNXcbujdUZbXkO7AQlkz9mNB2mE8EEpoN4UTD8X0yDe/br3QTyKChOvB998yj5LsSzQa5ZIdGknkuTj/cHm6PvPqpAYA1VCwuBR0XySr3uNz7frZznoQSFYz3HREudcPs4ERr03RLCO8QUGFkOQgavwNWoU9Z/0/5SBRaoVTbWv+DunzvLc0+jrIduiPvdH+42a++G+0h9k4fFZCeR2SU/KymKwPQC4zrAlfv7Vd0QGlbnjrrQn8BC7ib9KPWPBrhghmB80sYNgoTGgsW5uhPk2JKA8wKLPessogCDzOPDL2KjB0fks4T5QU/FXIlTn77qLxxunvU0Z6gECsKOJ360Kf2GVUw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86a74b0-def9-4c7c-545d-08de1112854b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:27:17.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGTQmlA9HUqjK4qmjIZZjvw9ZIGf3UrlreJhuVCqcifFz6kQVATcuie2ND+xOPXqR62fb9RZ3eQyILNFTyPn/HyN35uJHNySsaC155Dfj/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=922
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220018
X-Proofpoint-ORIG-GUID: YJOeYZpeC81QYD9B90-9_TGI5ZFIP5xG
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f84109 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=ISYUnfQZF7NEDgfrLmwA:9 cc=ntf
 awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX4H9Z9d8nkHom
 gYLZb3pV8kivnFSuqpIiULWUiaCd81zCMFA6fcTh/LaAezUPyS7Xj6RCRb3zYvA4ujKwK0i/s/+
 5CFeKOa031lfaO7kGpDxAe/hqqDxckpTzyhR5O6451/keUDSJMgqHFt+YxOfMuf6fZyQMK6f7wm
 bJ3tfM1F+0kJrQaFzzbBBhU+Q4Cr+5WYZTuUZuwGTxnhERj1DIxElfFItQYwzRQrC3wg4XqdB08
 B+0bDScS3zltP4VDboNpB+ZnKc62VIpNaYQ8UK03TmT0kRybUMSGtQZWV911tWXNAzFy2FD2pB6
 Q2HRVB6vr3816HiyJwfwHkt/VHOSiqEq1K6+kqHBicDWRISpe6wDzN8oLqPbd913+m1j0aVMM/h
 GFoHRVuSbebkfm49ss3fPZpjHWOGIb6o+b+bP7KGKI5pbeVi1AE=
X-Proofpoint-GUID: YJOeYZpeC81QYD9B90-9_TGI5ZFIP5xG


Peter,

> Fix the issue where host_sem is not released due to a new return patch
> in commit f966e02ae521. Check pm_op_in_progress before acquiring
> hba->host_sem to prevent deadlocks and ensure proper resource
> management during error handling. Add comment for use
> ufshcd_rpm_get_noresume() to safely perform link recovery without
> interfering with ongoing PM operations.

Applied to 6.18/scsi-fixes, thanks!

-- 
Martin K. Petersen
