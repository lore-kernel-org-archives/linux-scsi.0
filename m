Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2061.outbound.protection.outlook.com [40.107.117.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6D018E359
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730450; cv=fail; b=BlgbfKaEXanithKnSNMu++5j/4FaTkhTBqi57mSHDvcxEDCRlMw8SnmkKLU9SntxJ7JhWHJzCu+9GXyUb9faPFcm47B6H1P3vC56e4PPhA9w0PwpgwqOJh4T9sYyb38j2eEr9VRg2qn47zLcjFiRVklh7PD3jLfxNOewfX1FNzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730450; c=relaxed/simple;
	bh=+N35ohdQDvVLa2/hXy40nLo/QL0RQu//gwp8nN1S4+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f9jeusx1+UxftrlvNYcKvjLMAj8V7ClxqRNBgn52zE/4PuCXv9PKvdQMhaYxwd1cQaYjK2j4KrEGjEZ7QwIxBvFsdDw/2AJe4I/+QKhX3twGX/K9+CMtgGDXA2Dc8zuwx+aNTUhGe3rTYyMXgfJxmmCHhKeC2BcPU8zDIqtjaDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=YwoCyw9V; arc=fail smtp.client-ip=40.107.117.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="YwoCyw9V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6iB19W9yVWz1zGoMU/j+1MkesL7Ii6SXPAW9roSjPWUrnB76Bqtt3wLymaqBiDQoVglNtwc2KS53MwmEMM9U6Z4B0tdZCQuQH4xnEYS55uhHeoOsuHQqpRyAIWE344qS6OwoJIeU5eOyM9u9NJjg2B62TKwfjxaW/Pzl7G81+gSFBaC0Z6WjngIIRER3HNn72e+YrgyVk+AJsDwz1ojmLE/LePxd5fs8UNzLwi5Xa8fyUEKFz6Oor6rbL8ZFZzrxq5x+TQg+cU7QKElYKUIQs4Cf7VDQgowwFouqeh2DoegFzhc8tRLKBFzHn6LC+hfr0+QeKhhIMclkn/nebPKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+N35ohdQDvVLa2/hXy40nLo/QL0RQu//gwp8nN1S4+M=;
 b=ZQWj/ARNQ9MKCMVUpD71DAhK9YVRecnIvzUi+DjcRZ5Zh1ohDyUcBI4az/6FvKBDjOXO3C85ANaOMyRR7JYtLG3MDKqPMl8QSmL6GSVXORYxCwkwlXHM9cc4iQKQCe2QV1D6DF7tQ/azOUVdpOyt/nJ7bBG+K1jCXufu+9UcWxA8/U3tncR5/4Yu9yiBfhGWSMUfeMB2wERsQ4ZDZYHYteSopEVrcb6lMb8+WGONe2XDGmoNUP/RcWK8mn73xC3KAzhpbYDh+SPJ0BZMd3UMJD5m2KPALwLJlB4UoNNayMPSUW+lw+Byd9Xj2vetolUnAuHtb8KgwxthcE7cPJYU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+N35ohdQDvVLa2/hXy40nLo/QL0RQu//gwp8nN1S4+M=;
 b=YwoCyw9VYFZUe1ct7XBO/oH7Bi4kLAqj4L2+SG5wpKnu6vXN5j61BeCGtmKukaDOIkRNcB5P8vOLXJAtb4bSSjjzNQxLGZsoeva1dbb9AlCYBehukfs4uQ8ii4vsRsJzPGitnbPjKKsOlbl50sesdJ00VE8DPqWTy7w5i88KtstwdpbXDLbmHzonTes17OwEhbqJsvvmZ9ArsFJK/InVTOPwojkky49UzWMBUPipd1mTuwKiAMeWWz9Qeq9vY4lDJinaMuUuS5YUSi1FV79yXMk57I95J8n2gaSKKZH9eoQiOJ2AnUEdPCwY1VpRf52/yTLe0GkZlJb3m3a+91z/Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB5502.apcprd06.prod.outlook.com (2603:1096:101:a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.10; Mon, 4 Nov
 2024 14:27:23 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8137.014; Mon, 4 Nov 2024
 14:27:23 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: huobean@gmail.com,
	cang@qti.qualcomm.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com,
	luhongfei@vivo.com
Subject: Re: [PATCH v3] ufs: core: Add WB buffer resize support
Date: Mon,  4 Nov 2024 22:27:16 +0800
Message-Id: <20241104142716.299-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:54::18) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB5502:EE_
X-MS-Office365-Filtering-Correlation-Id: e8e28522-7f12-4181-02e2-08dcfcdccc51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vpD/MCKPC2cFZsjDvFHTU6o0w+Q+c2sW3cPn1cR7JayWpSlt9D44ikwLYgiX?=
 =?us-ascii?Q?woMxnQlsdHHNdOSFXV95ilmL+l25Do2ax+GDg/wRY1ET9EO4NFT8JAdGdyi2?=
 =?us-ascii?Q?1OnT1KCbg3WHYltk0pjrJtiaVA3s1Gwv9838MegocXQdjJsiJXE+RWtSqfxN?=
 =?us-ascii?Q?gp5VP6L+K53ly+ZFRccqPhGoNyuYy5Qx3LIHEktKNDSMnLvN9t7CzHRdEB7A?=
 =?us-ascii?Q?YLBuO7gWUfbV0t9iqM3etPXvrIA3vdpwlh1mg0BxFgBzUWjsm/MEu1kS5R6p?=
 =?us-ascii?Q?2HEwMGr8vbKYXx2GSW2aI11XvfONsgzpBPfjujHd+7cnVKJlC+X2URP/IQ5R?=
 =?us-ascii?Q?LGyDN8vSIRQmm82LXN40Ioy3hVT6mWgympLD9DfGW9UJjuSK9TT+ewv8LINd?=
 =?us-ascii?Q?sHdC/rN8nxUgwgorV+s5htqMhT1EjRWE1gWWNLmdQ57CL98r+OFDlzTl2FUa?=
 =?us-ascii?Q?SjiIpOylzV+SvqPUim/BQ01qXGiVDnMKtI9kfP7lzwMHbEv/79I8sQ+ZDbQY?=
 =?us-ascii?Q?7dGuRdbXd2CnJ9w2hEw5nHgoGsYIPDC5gCERDZ1y/zNeo+LgqMj8QAyUZpuU?=
 =?us-ascii?Q?3u9DBxTamAiyplLcLlgEW3Vyf5iizC/vP8AAOywq9evw2nGtRQh0NMeXi1ZW?=
 =?us-ascii?Q?dznWiBoFZ0QFPagB+v3v5GbH0GnAOaMHSFAicsW6Byo80IUANNHYS73rqgJc?=
 =?us-ascii?Q?0NMOYn1ebQP0mIGuRqUmhLTINRdaKT1qY3+7esDQ87t+i33sdRxy3qlHRcMk?=
 =?us-ascii?Q?H/ghby8uWeRBIIy11LNibHmAvLnUBwYUOEboqvg0Prfta9Dp5UMLLncrNDzV?=
 =?us-ascii?Q?eoQj+P3owO1t6+uG4RaKyO5kWCVP3CSprmha2UMKWG4+brNhqzvWOQkicJNl?=
 =?us-ascii?Q?3I/U2i2RmhHgPftlEqdjmpjhtWdza4a3Dz6DZTaoZqIwh+Eqd8Xxgwgv9ewV?=
 =?us-ascii?Q?tZLT9Yx//uT2+ZVAYE1tOFkZ9RYrdo/XKO05t3Tap/oa4mZKWermhEU3bLZZ?=
 =?us-ascii?Q?An5KbGxL2/F4qT/6s8JaScuPQuxzHem++07Fa++Skyb61lkO8t2z1M5Mt/iM?=
 =?us-ascii?Q?hFVtd9vacoFw9DsVhTTJEiMUjhto4EQh0tJuV0n3pxdkqyydKwM1A7l9UnvG?=
 =?us-ascii?Q?YYuZYMEGWL/vMQhdHPgFZcyxBCa2x3Q6YbyDELSRW1wV309cW/h5tEBS5ed0?=
 =?us-ascii?Q?scs5K9zea2msiCM8WWnwfsCxtqyvNLIRsrCYqWM7stJ6GrUZzAoINEq8gYjP?=
 =?us-ascii?Q?pnfuhaiiJW0HZNMR2LAMvlpMeFmdiDgJbxGkVxZHzsfwt4lBLLLmbKC3yq7d?=
 =?us-ascii?Q?snbPq/eNisRtKXznOypFJdRaAAKQ3u8MwAb4OmnbDNTV+fF/LGHuLn+sOOSu?=
 =?us-ascii?Q?1lqXaPG5em5c3ZlLjynUYRNCHiLw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tZ6HxOvQBUGWKikoxSbTalJHpqESYc8/RyNqgzQ3wDYNlzH3VQURTXSgPpU0?=
 =?us-ascii?Q?OX7Db7AQUjPcNBcwhwEerhwAZqHublh1QWd2ceV0Y852hZ0T2YAuyCAnACOe?=
 =?us-ascii?Q?9MmLdXFzV079/p7uLA9u/IBcVcbUob1YVH1bQpBQh30FctiojKvY6LdZOk4C?=
 =?us-ascii?Q?nrsnuSDBlrbnx2H6+kiSsHKUanr+SCtygoOgzQbdwG5/WS3q+RmE7ZOmbM16?=
 =?us-ascii?Q?ba2V9X6CuAd3wYWxKTGFf6ZZlnmZhto06lk0bI2TS149Myre3ukf0sVwLHFs?=
 =?us-ascii?Q?QctlTZ7M5pzXCFi9cj+kUjtygG0VBI4lxI3zrcbykkruda5r/aBYsTeDTcHm?=
 =?us-ascii?Q?nbNdZSLa/IOKyJRAF2G6ZC23xMZ92xZFUoNGhHnKM9vUypuZP7BsCHk/SDGP?=
 =?us-ascii?Q?fUutqn2hHxiXHnZeFxpD44oz33DlfhF1/ich+xzMJPUoQjB6T8GCCpCKeCeo?=
 =?us-ascii?Q?7xSLr3ArGA8RjvegquDawHNz3vEDlv36ndi+tIvo6AnTeZRKVoMhVXLCLjrK?=
 =?us-ascii?Q?55e90LfrMYMmT4gXpywU8f7qXPW6KKHJa9nnXsQYTMRnSzMPUq3m4UtibQ0b?=
 =?us-ascii?Q?NFnQWHz8jVgfH6sIB5qAvkkVucMeC05vnZTcTtM7brkoSDZGuvkquiz2P3/P?=
 =?us-ascii?Q?HWwQ0Mnl1ojZKT9fjy1pxcVVlr7lNVV/8EIb4cQUk+lcN9kKLEVSbsxSAxyc?=
 =?us-ascii?Q?/L5L/5MpdmKBJOPhTQsVWPO1UN7pamGstvM43trm2MAmb4f9bp0YvmwdDrO+?=
 =?us-ascii?Q?Eu3xFQa2A4M58wbBsYFGJ7umsx3lvY22ftWG5q9LKSxtmTcFyohU39APyBmq?=
 =?us-ascii?Q?P8OGR1C7kmWNlIJt8ZlOZZiVtwznxrH6l5WIhjlbX/OvMRtbx0mmYDsDRFFn?=
 =?us-ascii?Q?04q9xKgJ/r1MPEn/aeh7NEBZy3Twr5Z9K/0EZ7daMIrXssmZDY9033gHXc+N?=
 =?us-ascii?Q?6RAMEUC3B4q/NSfWR/wiTDayHNJc07T+LWQh8PtU6HdqItvw8/Vc7R82fnG2?=
 =?us-ascii?Q?WcgFbaxW3zqadtCD3RjqnkTs+VvuCimlbn1FCIAY+EVtf/z2Gr62itQZcXIh?=
 =?us-ascii?Q?XgBYjwlvhtS9oW8VYiCaUGjb/zvmCn6N8FicS3dbWMCufRJTEhAyhrX8UOYj?=
 =?us-ascii?Q?lvKzxNbBmF/JMvgbiMo48IEca1Q6QAo+3flGD9LR11bIa+kZtutgipylb9df?=
 =?us-ascii?Q?bFNI8QTRXEiJ4wyvB7b8mIaGHAzBl0hJvm1Kuz+vmO0gU9YO0fmQS8hZmquU?=
 =?us-ascii?Q?NMSl2CafSXh+thGBLTR7bNM/2BAvujK83JJWYt8wppQi/K6LyQL8iQ9XvElK?=
 =?us-ascii?Q?hd7h2ngCUbJwS7z6J3lw01nhytZYAjfPOuYrK0SrgnNJ+ZrqwpTS8wsVFFU1?=
 =?us-ascii?Q?UmfIURe0tXUczT5Ny3oUwP1gzL9L8Whud35ijH9HiPpWL6pA/1dlNvVqHz44?=
 =?us-ascii?Q?/NiqRAfWvmb4cbBLVqkf0zOBGfyXuhkV/Bns+gF5OpPzh8ejwOeYC4X0GcKl?=
 =?us-ascii?Q?+6qqb17eupqyNVfTcyGq5E21YbQHxbpt/JhAIshMZIIcYCuAXTT8gt9ZCo21?=
 =?us-ascii?Q?57lAx/oCCH86oDxeKshxE/81jlJsS9c0fxAP3QRH?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e28522-7f12-4181-02e2-08dcfcdccc51
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 14:27:23.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BL0JtSfghHvNd1qSEh/Fy3+49I1WSS9jLiSHcVjC7YyzbiSKBIQ4RxFS5sDHqayVobhcjnl/ApksXQCE+U7+ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5502

> Hi Huan,=0D
=0D
> Please modify the implementation of sysfs attributes like=0D
> wb_toggle_buf_resize such that a string is accepted (e.g. increase, =0D
> decrease) instead of numbers (1, 2).=0D
> =0D
> See also how sysfs_match_string() is used in e.g. drivers/scsi/sd.c.=0D
> Several sd sysfs attributes support writing a string into sysfs=0D
> attributes and that string is translated into a number.=0D
> =0D
> Thanks,=0D
> =0D
> Bart.=0D
=0D
Hi Bart,=0D
=0D
Thank you for your reply and guidance.=0D
I got it.=0D
=0D
I have submitted the v6 patch according to your suggestions.Could you=0D
please review it again?=0D
=0D
v6 patch:=0D
https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/=0D
=0D
Thanks=0D
Huan=0D
