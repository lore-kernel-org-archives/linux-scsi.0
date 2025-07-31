Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D75021D001;
	Thu, 31 Jul 2025 03:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753931856; cv=fail; b=NHNSWalVM1tdQeB9+7YOrqSLrHEqorFLAkMAhG8oJ2U2PziKLarZObePJRjJRNtDeMFPDPcJ7cjmvQVQhh1T08M2XsVb/Q6/3v8NgpsEvQfWJDPv2Hn/hsc8dob9h4F8S0VnjoTZcIrFUepd6EJfWRmrp5SZpsLeaoZx5JO9lRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753931856; c=relaxed/simple;
	bh=Jxk2Zu+voddJIApmxkxS8zv9QtlZhCh9UTEaKU8rumQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=h2V+vxLaIwtQGeu8db/j5rcIzT5Ij2TYX8I7XUqTE0tcsG7Sl/vc25UM46Oyfjri1sqkkxpIjfRTUgLGbR9MSqvxtqXDUjq7jB+k50eljffuO0kdsO/xFTVCmgSN89PBBzllH5idPYnHqk2arjOhuEBFdvtOJjy0MzNIW3crkRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=siTS2TaM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b+uBS8uB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="siTS2TaM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b+uBS8uB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2g2XL026897;
	Thu, 31 Jul 2025 03:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wClmrsE595c0c4OknH
	ldpeOsWzlIvri4/3E6F2Cssko=; b=siTS2TaMWhjhy70Ioa4EZxf8QMlYQEqIU7
	uGXVD8xM+G4U5xtPFeKsYoRusCg0YXNrT3fQOJEtBIsyJNumA1hUQ3ypjh19HvWB
	Ya5g64PDOVFV9QxKAHkaSoLISmKf2k587vz3hzg3yemj3BiOkkUfv7AsqGl+Po7c
	+U+VO1s7aI77RMLxtXzQkaEJotZnYmVVpCjUxoDuQTPhNj5DS0yXGPMcswTkKXAx
	ikeFmDrHAOWK/0mVq9PmdC9t7Gauunv3delImv92bgvjpp2IVYB+TIRei+AoH1CA
	8SuG8FrGdSafMP1I3uVsrfnmJmCyo64s4RUREXMbON85jsHm9IBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5x316d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:17:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V0Do0G020789;
	Thu, 31 Jul 2025 03:17:27 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfj91m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:17:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=saVS/peYZhsnrbCchw3fMYNkMAkiZp+9g12jBhyHWX5Qxaptq+POkVPH3Kqw6Ev+JPbPMbcH39C+xanZp+IzTzE9/kZ9hT5WudTIgwsr76NkIz8t6jpUfZpyZk6rlPryBX1VgMbXdTEyi/0L2iONRA24bp6DbFlCWBBcQ7ekJRyGKSumKTsxwDUApbDFZjqGdnlouhW7Cv4PaTuxwHuPcxfKc//4JI02OcSvzQeRw3zK6L+0EkKhczQmCNo5Xsco9GoKFsssSt/NGvh5r2gGc0EndBuCzehrfid9F7d4Qq2W9DPBOeyvzyL9/grTUPk40w09YRtobh3v5faVzrDsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wClmrsE595c0c4OknHldpeOsWzlIvri4/3E6F2Cssko=;
 b=Ptg1a6GPTEdIq0y7mMYyiHCOpiTsYboW2SSLJ0hEAWeAQsoVm5T8RRWK2xvyDlcNg/TbbEOhWb3+FyTB6CSBMDB8/Om8IzS6EW/FCw0cQ01IwxcpQEnKf5DbW/Tkpi/Wd7mrNzIKJfFYObjIBzjhxe2yD3a05mZf64BjDdFTzOnHk2oxqXnmV4qeQxiCrH9zDkgTsBsmhUyCjAUeu0V6tHNrCpwidyn+aGGIH61vVs8Ukro8eAkFkS1gaBUVMkbUJSkxQM4M1uPyh/l+HF8IuaX+cmUvEB9nZtqqEUwMmMbBDWc8ig+0tK6F7RkGkKT6gKmcaunpp/6c7zfvN5plug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wClmrsE595c0c4OknHldpeOsWzlIvri4/3E6F2Cssko=;
 b=b+uBS8uBcZV3N3rtHrFeW391zba9yMUr60mNTTOVf8QOSKkEBtJMHhQtv4xPAOrNGmRf1qc0ost7YQ+OD6IrgsheWSoXAdr4hmg7cPDu8CXfgA6r7kBTOVDZgvTbL2P8y/WB3kgOSva1MqkQlVMzLkTzmBcSrXuvq7LCu0Yu4ws=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8662.namprd10.prod.outlook.com (2603:10b6:208:570::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 31 Jul
 2025 03:17:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 03:17:23 +0000
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Chris Leech <cleech@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qla2xxx: Fix memcpy field-spanning write issue
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aIqivJeq8kxRUX0N@kspp> (Gustavo A. R. Silva's message of "Wed,
	30 Jul 2025 16:54:52 -0600")
Organization: Oracle Corporation
Message-ID: <yq1y0s5gicq.fsf@ca-mkp.ca.oracle.com>
References: <aIqivJeq8kxRUX0N@kspp>
Date: Wed, 30 Jul 2025 23:17:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: 341b65e7-f701-4d97-a3d9-08ddcfe0c4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xslVdNvC4tKxBXlNh28kYMRbePhlh8AnVkQd/rlTVG6gCB+uDZOmLs9lwdo5?=
 =?us-ascii?Q?uogalzLJ0vGX5N1pIrVolyEyeD5cOWc6di2n75Q0NO5ipJyAFbQUg9+6zmGQ?=
 =?us-ascii?Q?Be8IcwTxo/rySr1Uc7H1h9z2tKxr/tBaOo9cI7BhH6shvR5nOjCqDFVWmCBL?=
 =?us-ascii?Q?AjOdzUsgkcAtdwTZVt0pzR3aX8tIC80yzX/8izBF5qh4vRKV3pU5kgtBxBgB?=
 =?us-ascii?Q?p38rRARcKUD3WQ65soOaAS5noyyfrNuxOTnHt3DGeiXbS+5TV9D33fMK6el1?=
 =?us-ascii?Q?n0pdk2JCMlQ5QdwQpYZE1QXAjZkK+bqbj40svBMwmvJq2i2rKJoc75s4VEeG?=
 =?us-ascii?Q?8f7Mv8xDIDSP+UYNSJUh3FlAitdU5pRLvm4GPXpgXhVAadyHQenGOiUVEO6l?=
 =?us-ascii?Q?U20oQVZ7p/5cqTNyyuFi32sibPZ8eNUdwIvQ2Lx+F6TLstVtk3AFrCftyLio?=
 =?us-ascii?Q?AcFtfgRjfj+0ChPyw61rOuvdF5cliOt2L1cRpxlvXLVsH0gvNWinWnrn/one?=
 =?us-ascii?Q?2tsHsDGWtZ2tMWet8Al/K/Qo5v8ls/7QVNC+zJWsIkcjcAORakYZYjqlSz2k?=
 =?us-ascii?Q?A3PK5EqLoykKHD2jdE/n1Fyd9tpP+ngkzVEMqcW+PaPVA9C6XyhHviOMgBHy?=
 =?us-ascii?Q?KQgyo25SCRlfTU//DUhRpdsuj4PzJpN3NVZmTTriSiYKhMptBpAMWskjFrfC?=
 =?us-ascii?Q?/ZRZV2qOSHvltZyUK7IP2tE3kWpP3fZP1IL0moiTG9l9muqrE53f6MfPnLto?=
 =?us-ascii?Q?4NCgGFZ0yzHuE40u4CbqDfx7FocMeWw1aKQh3ccWeaKneDezmhnLQHJ+ncBt?=
 =?us-ascii?Q?hAUKslxp53SCCZhz+eMdgCtwKi4e+trJrVlDR0vHr0061r2eyhgL30D/Y1V0?=
 =?us-ascii?Q?suB30CSuqc4eDM2uh/r+ld6/qxMEKgfbkvZUmUow5qtHFo+FvKFAfHIhUVq2?=
 =?us-ascii?Q?s9Bu/1hrGvzlH/zJ6CE3cwBowejjXkPAEUPFmnHWws++HvIB728ZsVmol0I0?=
 =?us-ascii?Q?WQMQpj3WfKbsvWQNQ52mLjyI/hwGEAnS0G1klaz00E5U6mRhY6BRWgaLSvtp?=
 =?us-ascii?Q?ONPRUPRG1L69FeQ9D0/gO2/Yq9adQu7v+D+ye7Oq4HgNiL25R+oL05uHZV9H?=
 =?us-ascii?Q?pQi2TpQI2q+Z5G1sms2AxJ8YaBbS7vUmKt/3NArP9rrYtsV/hNJ1QlUSZZAB?=
 =?us-ascii?Q?bYbC33QwAEC03y4OfVD6kZ/6GXbYrTV/Aay8jI8DWHAGAa1wQGMlZ3zaIFEk?=
 =?us-ascii?Q?mYzI9sHFL1QP7cgkYiddmBjeSzWfvSZqjl6D5n9lm0kXM27uf5rrzGdDxImx?=
 =?us-ascii?Q?SJy6rFCN1zNJ/FIiVKL7quXwVDI1HVFGr0yRdfph3ViTtpoGWfbIvq9AJIWh?=
 =?us-ascii?Q?bWy31nv6j23cPb6/rSRqqYh94SMDdtvBcenD9H8XmkOxpZhRg1zQfgv9r7KI?=
 =?us-ascii?Q?akaXxjxTWDE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1pbmqE3BKuE+HgWLa4Dy6jMqotfbAWsoaEHOq5TjcOtW3tEWE5hBfQDOv62o?=
 =?us-ascii?Q?bCRfSiAGSqzmf6715re+jayqSHWELfGVUNdJFR1ytOnt4/ylYOnRqQ4E1WsD?=
 =?us-ascii?Q?9RaxcGCAT5qZWk3tYC8agajAoUqb16uXWe3oBcBq0rotzjh04bp4UgokjSLL?=
 =?us-ascii?Q?KP4SjjjCrm9A316kOIimkkaorS0VN8TdRPO9gBRnl0kNEw3Dx4OpXmlqIunN?=
 =?us-ascii?Q?I4jnOJoRoWHZ7fV05dNYYF1si92EK6HNvE/xsPJKhbsEP0e6raLFeb+4oR06?=
 =?us-ascii?Q?8EcGysk9y/8emLPe5aCeP9NhZz/kKYcps7U0T7G7J6OQfYsvq6ybLkM7D0rh?=
 =?us-ascii?Q?KEdZvED15OyCAWsxXVBQicqzdveUcBi3t9mEgy7BruThzNTG7ZNSPQPwQuA8?=
 =?us-ascii?Q?DlWpgVdk9knOWvJUPoFSeKT04GV+MPQwoYFh2v/bNGnJ2RnLRoXleWhXXSes?=
 =?us-ascii?Q?PrPt9rfp9ObRa1YyuFb1Dg9pe0IJhzk10QTBQIpEsQSEv6nryDDjfIj4jmq3?=
 =?us-ascii?Q?68qwoxDOnMdEZZjQohwsbMlIsk9Rx7q9J1sqmV9x9B7Q3wiHP489bdfX8kcw?=
 =?us-ascii?Q?wu8UktPesfsNmNn8l1NZQ+P70E4vwm5ZwG/CJ0xvHVWN8D672+tvn4hTTMw0?=
 =?us-ascii?Q?OgtcVUl5BoWBlCnagYb3to1RtafUtypqtv37NcBVfwxocYtt7sgwyQjSfdsK?=
 =?us-ascii?Q?q9gYgvdewKUjItPE+uxcgRnG4sGxOaqri0go/DUlsz1D3FZsraDPbD2+fYNk?=
 =?us-ascii?Q?KKB5ougXJBntMRDHANK2skAZ4icV0pQjCoY7S7KRN3kTlKlyA3+by+JOfBQe?=
 =?us-ascii?Q?kzhqcMMCkXy1Vig9698JrlmSc5BoH2u+I6CjvCpymiz5VKJIpm6ltKH7aEwo?=
 =?us-ascii?Q?HKyA+S6WQR0DABA4c0iZ7wIXQDf53LdgkLBkRDnWuCYBV5asJfJ/pSKrjwnS?=
 =?us-ascii?Q?SJiMhA7UZ9ewUVLVPxcQxcG2EG7E5AXeRXUGROi+3/BnMZ13lecZfGLlHFVs?=
 =?us-ascii?Q?/QTe7oPro9NKEn8ZQZfW3TET9S8f/pf/aMVKBssMnXwzLBCOaHIUBhbViR5S?=
 =?us-ascii?Q?T6b+Cl4WLbaMWzE/IaQGmWkXwZ8HceTxQX+ZBJE2w2mPAqfB0Hc8R53PS5Pj?=
 =?us-ascii?Q?2rKpayvWDdsHSj0ZIH+NT7I7lzMqU0Em+JSXInlw1uy6OxKfq8PiGiqoZWwA?=
 =?us-ascii?Q?+WUqLYbnjp7cczpMZ4PaNOdI/PMFSZ+CtDHCX9TWHCaeC5fNQ7y6rRO8uWrY?=
 =?us-ascii?Q?aBkNBBDl0lbzc4x7D2B+uLpAMhoGpI1k+i1zuajxj17xiz6fcsH1lXpN38oJ?=
 =?us-ascii?Q?9Bk1kkBXfW1/BwyFIzbcg03u1SrJbxfCzmmx6sGAJTcJLPtSDsQJr+lWHVIU?=
 =?us-ascii?Q?kmifRC1zEciOnrTz/BpdINvN2jY9Jq+XxdNPpHjXFpuPSSGXgpdt3j/R2Uo4?=
 =?us-ascii?Q?unJUr9cb1AYkgyOyc7SdVujWFqo+bWCWPy14ztH+qIDTLTRinzz0z0JA8dII?=
 =?us-ascii?Q?MD7kf9YCVR/bESDPgznY60SW+Ra6dRXzGH8fprIggsBX+5A6MZrjmlhW9vjQ?=
 =?us-ascii?Q?o58sQHBmx8G4601WqXYkLsTDtxI1Y9cGuTdidBIp1U40UCWGTGuFUw7SfGXR?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Egj/0yPtWH2Omo09kj12Ns7pZkzpAaQrZfC2/T/4qCChBHy92EKbyJpZmw/0OyMTBTX0te/koKjzXkqAX5fQn6fYGqlMniunhC3ax/eDAUn1v4q8VQwe0TK0zi7kFgUAd7/jdLf0ySqYMrsxiiL49i+ewoQAJxbaf7qhJob3QAlLJ8+l2FIKdl3x3EReK4IofaK9tKxVcrO21WhnE3uhXMZQrwdY/viNRc1n9BZW8i3w6ZLg4NyGnIC5rPI0j/wZBQizIFN2zQfCT2BqBhumDJ3WOGrSQX3f/w9spAVkmCninGzMz35Tc9389q452VpyvtHuiy7Aq83IK9+7uZxpfnHsDZl4Bn++v1V7knJikE0Lx5ttL0TTe/zp4zHXPRXObRRzN40761nz31nEAMFav0sWGEaMPWaCkhHOJv51zGaaJ2vs3zFIBqXVIpHzows7OZGSSmzo2ZOXu1/AmK7YR8aqhpqz+KKexYQARU8aL+UJwIzKNX5Jr4MpuQW3M5ARigAsXuTYSKQsflYZSPQdDl3La3lNCflFPejEzknObP4madNtbwwXXl1cQzCrk1TLESvCmhFyCSKvGrjUN1sYg8tLW5NaFyG1Oneh5+BnBtQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341b65e7-f701-4d97-a3d9-08ddcfe0c4ab
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 03:17:23.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbG0BBeU8LEhTjLPJ8flkCUlrcfcwL+quzTuBOGgtUnx8l6jMli7mk1MP1piGl4+cI4EqmiU30jUMv141QRwha248n5/CnWtIL54pzKMC6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=760 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310021
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=688ae048 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=WK-ARIxHXy12RYDgS4YA:9 cc=ntf awl=host:12071
X-Proofpoint-GUID: CM6T9cYPWuZ_QexGPE84fdXC3r7fFr9B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAyMSBTYWx0ZWRfX6FRDyrvltciE
 gkYca8DcUu7r6rergoHqhjSpRAI7QdGolcGO52XYe1iOTUSlZ6e5XkTA5ZzJnBb8KqDJkAxZX3x
 5GYwPuInZA9MM0oNChmC8Ph1vmbAJvrpqkRNq3WnNAVZPVfZNcdXjzgEIrAVK3ZhshiKcIKukJv
 D169D5iRXCr5IJ08tBbJ/V9viVMSUGHuLJTdDT+vPo27R7AGWdoymezvX08pDF/Yo43+AY1Pbda
 UYBA3/8epeonRLDHsHPvaHVsNk0AQQy5QDWxQtYXVQ/LB4EXSQb/S2uicm0UaqddGMM1uTtVa2X
 kAh0RmdgtSJM02JjLoJHyBVDxMabTOs8KzxuvA8yuWbF9msOXsh+5TuqqHST+nRhIwMCnmUJebb
 eT9zJc0SQqtpYj/Wx3kXm6q0Fs23OcqHIcR1oOu/AX8ktoD1K+XECQpu+fBCRd8BXu1z1r/8
X-Proofpoint-ORIG-GUID: CM6T9cYPWuZ_QexGPE84fdXC3r7fFr9B


Gustavo,

> +
> +	/* Must be last --ends in a flexible-array member. */
> +	TRAILING_OVERLAP(struct purex_item, default_item, iocb,
> +		uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
> +	);
>  } scsi_qla_host_t;

Looks OK to me but will have to wait for TRAILING_OVERLAP() to land.

-- 
Martin K. Petersen
