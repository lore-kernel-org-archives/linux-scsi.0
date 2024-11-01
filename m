Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2057.outbound.protection.outlook.com [40.107.117.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251F515B54A
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 09:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453848; cv=fail; b=Kb9SrBPMFVDS3B8dmCCJ+ZhCg0Douvbh9vpWgheIkVhIsgma4AkkFG76u3eB+pXCWBCgKf34O2GfYIKvrrG/AkfTR3HtTaUtJIWSM/XnSPMWIsJ/7zg+veyVfDIvgXD8ZBRemPWg/NXMrtvxQQhhJXmfzTzI59+kMmOvcvcrZaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453848; c=relaxed/simple;
	bh=ptTpNnTase77PfCYTP4+X+N3ei5MdwjFF7Ns9ok0iME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sUxHaorxXosOL+XBRBRbu1OIXi+L10cws9xAkMv5C3ej5hwrmZwLnHgpkMc3yE8QQ+nbXT7FGAnOfZ7Nw5VBATydg+QZ3PFPS3MeRst+aEh/oqM85pDZ2PJ2mgLqCQn0btdaLuBCsKHYmZ17SQIVspokFnn/uu268ztySLG9JVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=X37jFIQq; arc=fail smtp.client-ip=40.107.117.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="X37jFIQq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJsG3rm46OlUYeCzq0B2zOwNdAMnkc2JHlQFIQP3knvr/G8yyOlxofHbKNbkXWNPYBDBzyO9DQ6QJUXH7qoaZDoVXEnBzy6S655VOk6RFW17uKG0vQCZc4OBYdS0iAVtsvBzjnEU8BzBcYPSwCfuMf6XWNcmVlM11j/9oHHPtHnLkDkgX48FX+FsjBc2hJtsg6clI4HDQlWqgSeEcz6AYVkZTyNRGVgUmh9S/6osLMcFkvrEzXnCV4s+C93NRiWoWjQwlIgJQNJ99roMyKTz1AmjWm+5uY6U6DI1UFynVUTJxMATCJ1MDvudDEQu8vMxhIGphI8B7Olu6kpDN+zraw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptTpNnTase77PfCYTP4+X+N3ei5MdwjFF7Ns9ok0iME=;
 b=TFRZF1LkCz4Jyd1O77+zuHrLXsAKkjc9Odo4w328QdrrHBU8AVeKIDh8ZzVQcV++8nPA3rHwsRhlU44ljcfHqpOhzaXPjC22NQoYVPsLu9bQKlFPFQJLqTGEwtp17dC8/KkppqnRlKzYYfnkCnB/c6xb31rOlQxjSSJ8QbeuIgPojEFiW+1nQZqAW8UDiu0Z1+qHPBcWPjDeOVOXk3anyuoAuVCkV6OEsx9ZUGptVjmemTvQeoa22PXTEbrQHUIboIZtbY19XVwnauqDHtI/OU2RBBk3hQ7nS/DNia9C97xn/zbcTiIdbm5rpVBg26BZFM1grqonAMtiRGw0fJRccA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptTpNnTase77PfCYTP4+X+N3ei5MdwjFF7Ns9ok0iME=;
 b=X37jFIQqL+bB3iZmSyDrDFdSbeCTfH/7L4GRoQK4wDwUR79uCTayof1HL4AugzuGVNPX2tyYJAEjfvekcoD5tqn7JKhAwUH4dcUhYPVvihEvfQmMILwFdfA0IvPuh+C8pTDY+RhReCvqkcXV/vOymFijdV7Q6LF9QBalM0iSGQ58n1iw3BZShOslO8NqKcop+H8tqn8C1HN5ADxVoWFptvGyFEPOzdn0mP8AkqhbB+VEtQhplrAwHlcEFy4eCTEufa9xpKoF6Mcla25resWJej7RA5dXzdeeP+IdFOnF1fkKF5mww5s5Q8cwmW8GegMCskgRAmkxqJ0p3Fbv1BHlLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYSPR06MB6923.apcprd06.prod.outlook.com (2603:1096:405:35::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 09:37:22 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8137.008; Fri, 1 Nov 2024
 09:37:22 +0000
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
Date: Fri,  1 Nov 2024 17:37:17 +0800
Message-Id: <20241101093717.893-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <13aff452-0ce8-4ebf-986c-dd3bb7c322de@acm.org>
References: <13aff452-0ce8-4ebf-986c-dd3bb7c322de@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYSPR06MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: 722d3d2d-9432-4405-78ab-08dcfa58c968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?exuD6/lHF/lMiH61YvMewpR2ZEf3Hq7NBHW03BUqg37twx3z7h6+82pr8vbz?=
 =?us-ascii?Q?3qRVC0ya+CDc4nfEpDPtHgWFmiNtUKRcOYuNJECAJB3S4ato6rL0H6yoNzJX?=
 =?us-ascii?Q?V48O8kt+ia0s92tNS1sp1Ty28kqoG78lFA1FqzYJvdG9kDqltSzhskrjYzGG?=
 =?us-ascii?Q?8KibE366zBFwC5FaLC+0Q1/DfAK0sePZapqPLKnWMCyhFhendg2nVqNXgflF?=
 =?us-ascii?Q?lbT3Cf3G3iqepP9l9PsnXwYvOxnKNOwxhdP6vZcrn3QNa3X+aeTMpbqL7dCq?=
 =?us-ascii?Q?SFoDot1t39xYof/YCCHvlKGtn3RULyf40oyb9Pi/D3tuKZoDHvDpF2djfpyL?=
 =?us-ascii?Q?NIbZmomGwTV3CO+ERwyNzHQICcdmuPtqG0DlFFucgAbQYYI4r3E0+N7/GvHd?=
 =?us-ascii?Q?4kIwdwexpJSkZ3sKaxRE9lbzNq7jiI+4TqwX3CFHUBB3TlFwyEdba/xln1LJ?=
 =?us-ascii?Q?hLwdW6VUyBjM5zu0jJmoxNLsgWbR00Qmaza+B/+5kbto1SVlgtw10B8q6YHS?=
 =?us-ascii?Q?+pKN5AZUhfg0ASemAY0svFYhPcsjQLR7DrqhGwnqdSJtsv7KlBsAgfyATREx?=
 =?us-ascii?Q?ThdJmj8cnEw4FrDJf59DxPcCXqWrptVyQgxyL9h9sflPrQH31qGBB6pKCEXE?=
 =?us-ascii?Q?x1dELva+vFBYWjouDV69rT8dFuOXoUgmZ4LbharaVdLn9IbBiMoW+88Dook9?=
 =?us-ascii?Q?ucsatgmktN6yCU3pQN3orztFrCrWGCUw/L77AfgjJUtc67kSGviPZBq22yvS?=
 =?us-ascii?Q?BqpNXE+ZDeHHTTMShsp43OalcRjYMjCirHC6TMz73+BMSiu+X2dVIPx087+r?=
 =?us-ascii?Q?7QkVEGv5IPSZ1kl/i/16baE3unkPeOcn/8SzncrbZGOhg/QsofmZ0e+wy9/T?=
 =?us-ascii?Q?OcD9VUahw8yXr2sDVMqSGxV5Qa5exzmWJ2h/IAibjJ+88ZXFWNw3K/SivOLa?=
 =?us-ascii?Q?XiF3xdJ2HDJgALn9Hndp+Tq0/tQYDAykrgsvr0W7wlXZ5o5zCenl+nwr1bB1?=
 =?us-ascii?Q?7Wq2sP6qN6AgTZcBs3JoObmCpnu1NX2ObU9ZxZXGLmLHFTcGeA+nmBXSP4Gp?=
 =?us-ascii?Q?foUHoBaVVrrnlsLHAg8fqsM6IW+siPsffDZJkC75I6b7bZsdIYYzwNSAcqL6?=
 =?us-ascii?Q?deyfdWtn3Lkcu6j7gAFbPhiDMIdZtm3d4cdvoZtWo0BmeEdRemagOGRCyUvf?=
 =?us-ascii?Q?PdP2/8pTKHxOw+S+KHk9u4yBDTrBniIEfpiSjd7D+ZS3FKBd6McNqNCZ81YD?=
 =?us-ascii?Q?z66rRs1DVQ0cQ1hit4Qmp3rwwiOVVysj91IG6yUYBb7yzLZFSNUCpSMwr6h2?=
 =?us-ascii?Q?ApxBZ7CKQ/czxsRn39wBuOqeJEJovx/B1F9nHzxc6v7YgR9HU+WHRMa8G6Jw?=
 =?us-ascii?Q?QTzVP/JTW8WPWV20pF0AXxKdtNgS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OGsM9OuuxQV16GY/Gg9BP2HzcmTcqKjasStyaYlkH6xFZI9cc+mblmrIfMnT?=
 =?us-ascii?Q?czWi5NqSgnvShzko+krRqjN1hT7B+c5HjAJzGABL8tHj2nJUc42431pO7rFh?=
 =?us-ascii?Q?Qm017i3x/yTt2Jbp9HOxoVr39x9yKpXGB3YyqcR5E66rQKpQudSeyfDscAoZ?=
 =?us-ascii?Q?vAcwsaUbcqzrbNRVWqWMfeT0E4YHBFUJFkc7HQHN5J7PJSadlS1VXiCdrcKx?=
 =?us-ascii?Q?DFPbVnZqmSTEZ1hvvKRoJQn/LJcJhRGU4KmDTQRw/SSjef7VIrGLAgg7/TSb?=
 =?us-ascii?Q?+uCjEKDTVkgAS8sUWhOI3UJLCUyJQ34ocCqTZC2tR5G5H6d7tDOThMNyROEd?=
 =?us-ascii?Q?yMpss9WwsEAf7BiGy0OuhVBfJSrzVzrdTUQMomCPrB+SVl+0ehauB4XC4CFg?=
 =?us-ascii?Q?8mL+sq4EWs4NKGvhKJvJrtIzXZhIf3qwimvp4sJg05XMbLSwCkDNIzD4krQu?=
 =?us-ascii?Q?OvjhwoQgja0g0IjJ6ENHYSvlG2/IWkURjbpYg95FM1zA4JjZGDfn1aqQw0lc?=
 =?us-ascii?Q?tcnn0nq97vCTyttFH0KXIM0XR7d8ZoKa8dKVkBQiA2jPVp9kJzToZGmlTIB/?=
 =?us-ascii?Q?Vt+LsPqLqy88c1OrP47+Y7YoHJ7ey7UUpSD/RMIgLuUZ4qvXKiDtov1khUky?=
 =?us-ascii?Q?drLRXsYsW/oGeCpGc6uJb6fn1wK8832W40+l+3nnoyDY4ORD/3Mkp1GY6SCl?=
 =?us-ascii?Q?EBHBzR964OI4kOt72bKGZz7YGLIqPzeZs+Y6NEWR6RklCHGLThL9Co94Aqnz?=
 =?us-ascii?Q?0RJl7hxutd+JQ/gDOebdxNQasEFESqJ5R72Aw/EA41zfEmrz01CSgLWsmGkT?=
 =?us-ascii?Q?QpSqxOvPOTrvTbEGpaQyEXu7bGMXXC9rnWB56E4Hv+8Mhyk5xMGiQMatiTh5?=
 =?us-ascii?Q?EFhTpqZbRaRRYB3fFIyo1B+jaazmJx8bwAEurnsISkNlI6HJUxFdS9AzlA5z?=
 =?us-ascii?Q?nbp/mIh+ObTNqxLtXjO+b7SmLjbT+vzBrmZ9TcZkBc9kHKup0b5WtYpY67dz?=
 =?us-ascii?Q?QLjjV8Daj36JeBuS171PkABiDViBmI16lc+t93/t2/47qQ6iahsC8thFb5PO?=
 =?us-ascii?Q?owX7CZl65Cfu7smA6BYzmw6/k8jPWI6MmjHkiS29ylX9GXPKgxCPtRVait54?=
 =?us-ascii?Q?rQC/BSwksNOPbw6UQqrOk+dBBaRexxQ0DFCeE6VwuEBO+1eev8MqfkQMKvS6?=
 =?us-ascii?Q?fCtjGzfHoUu1AB4bpD/S2yWcFGwmo4Z6v6vhBWKhCwrPGdC8Hnb5dUA8wbAp?=
 =?us-ascii?Q?c82fjdXFeKtQgsXGC2vzPGv5001yrjHvvvojQFUcL0CTzGkWihtt1lDatPXP?=
 =?us-ascii?Q?NLPWy5nVG5jSFgovAh+xWrckWuTjwgjXv876Ex0rlDO4y8eg8YZqXb0E6YfB?=
 =?us-ascii?Q?oiqr8HUI94oTfyal6fyFP2DJckRtR1MVx6kM1BvWngsinADHQTK61DO/6339?=
 =?us-ascii?Q?9hN9BUiEQI0sAajul8U7v+HUDIj6k/bh+jbM0JcWpX2l8IlXCDbOwRsjBHWo?=
 =?us-ascii?Q?Yaqiaw25sv3YciT5cK82psiVVfgDUyfWm742BVpIiSnABQ6YXR0yF6bYJ96o?=
 =?us-ascii?Q?Mqh9mI8R/NRjCx7DVHhviJPsmjNiZtuHzsQ4/rRe?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722d3d2d-9432-4405-78ab-08dcfa58c968
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 09:37:22.5476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO2hKa2m3wU11KeJBkwBbCwkLaRnKo31LWZhBfCBfwSfQ3ig5j5/fmlMcl9H8/QHNv+rfotIZqGPMalhhhJy1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6923

> For the three new attributes: please use words in sysfs instead of =0D
> numbers. Using numbers is not user-friendly.=0D
=0D
=0D
Hi Bart=0D
=0D
Thank you for your reply! =0D
Thanks for your suggestions=0D
=0D
I am confused about the above sentence and I don't understand it. Can you g=
ive me more detailed guidance?=0D
=0D
v4=0D
https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/=0D
=0D
Thanks=0D
Huan=0D
