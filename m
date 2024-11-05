Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010006.outbound.protection.outlook.com [52.101.128.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FA51CD0C
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730773929; cv=fail; b=C1+MbUgYlpEcU0coiww2PvCM/KistIyolD/nBfo6a3jsjAk2fnIBpI3s3a6qee6MPj1l5XCoI5rE95X49EbeC+1kHeLIkutmlNZAf0o8NFS2ZZaqAdwhud4yTtwMHy63GWQdGWbs279uUvXIBYcd1BoYcmWSbNM5/q7isWufF28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730773929; c=relaxed/simple;
	bh=/+/mwjTXlEuYeCgO5OaEAVsotMl+z/wj2FnUeU5N4lg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RlnsX9pziqGeVhaJf837NlEeGRf5f8TuXugs0JqcR2csUoQIK4XKqyr15U/ZeX9A52scfw2uZ3pDb63VGUI/Y1qhDuxLv8wAHl9K1t1h7EcIlR7wxxWUecZfesy0vxEOyHDn+NAWIVp3EmIB28ZL62G4mRjx3EjTXddTI7MY9AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nBXxJYtk; arc=fail smtp.client-ip=52.101.128.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nBXxJYtk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oB3aH20zmcKBZhoij/w7Ay7FsV7tEwKUON2YaOg0BtXs9N6sgoGyMU5F8jpKZxSvPQdFCBxxRSu/JQxWLdJJNJX9gmhpoSJ5YFGhdKwEGMV1HZjmqV8S6Pgzg/805BMmvM5xijYfu+DJbk3b28UfZr9hGQeWs8jxTLBy88qdR5HQQ+obK5Sf/m9k0wcan2u5LK5+nJLyJbi/+qU8yPHlhIT/ard7+rVVSe1kQwfa0qgBTAOSeE/5B18RwMRBgPW68L3njvSmnvAxixEauSp+3XmKCbzhtkqkFJGJ6hXA6iaL0uzrfVk/PGz/hGkt860xwnRc9vjbi1Xxw4DYUsR0/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+/mwjTXlEuYeCgO5OaEAVsotMl+z/wj2FnUeU5N4lg=;
 b=Q7txYjKzUNvUMEi3bEeFMNEj21F8MlSJuzL8xA4OD6gPyE0JlWyFTrlsm0brYmFvFH+25dgRKz+9Fp4uIz/th5zsbr1H15uiYY9Ntn17CuHSu6NIXhaSfGGOiLhhzQWnW80ogxGklYw4Qhhd4Ouh7rZtCEMUyJdgu3giU+qq3P7kvh/sDUU94GD91RkjdTfoi6R9O1G/m+5LRPo06dq1uKeICAaZztew5sZWQSdMqsFYf429m2NPhh99NntR4vofSghHGHDptqXD5l+tEYGtWnl0NuSHj2nlGfn2pBr0Yvf4ZbCTPMPzfBtdtqlLiccVdKvCu6mfNMQVtg1tNNbfHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+/mwjTXlEuYeCgO5OaEAVsotMl+z/wj2FnUeU5N4lg=;
 b=nBXxJYtkaqTFdEAdlawTbVYomXiONCRueuAkXNLo69Jjb3wXl1fDb3MGBKgWJW/+8y6LP58vqKUxD9cxpRLyozTE2Ih+ugqrAEmQznVPPv/eo8weDHxIlRDsU0yLwtEaKevKdCBoBCZJdaOfIdNaUYgnjtWMiCgc85tq7P0JJdJS23w53yxuwRAZ27LmvuvpTHfYnfKFrvuNe2dlJ76BrjKFs7A9EJp4Yl+ZbxQwE0U0uEtB/NMCCHdxpyLBh0hdRnpZZA6ltNcQEHveNyXtwpV/oxgyIul1Dse6qkc3AHhlcnWrIA/fVRvCqo/O1/58Myjf7Vhv1I9qOkQ0TT5smQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com (2603:1096:101:139::12)
 by SEZPR06MB7175.apcprd06.prod.outlook.com (2603:1096:101:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.15; Tue, 5 Nov
 2024 02:32:03 +0000
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a]) by SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a%4]) with mapi id 15.20.8137.014; Tue, 5 Nov 2024
 02:32:02 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: cang@qti.qualcomm.com,
	huobean@gmail.com,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com
Subject: Re: [PATCH v3] ufs: core: Add WB buffer resize support
Date: Tue,  5 Nov 2024 10:31:52 +0800
Message-Id: <20241105023152.364-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cfba8202-6578-4100-8b95-773ad318f325@acm.org>
References: <cfba8202-6578-4100-8b95-773ad318f325@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To SEYPR06MB6279.apcprd06.prod.outlook.com
 (2603:1096:101:139::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6279:EE_|SEZPR06MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 90006af7-949a-4bd1-6eb9-08dcfd4207f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aYLfmUGr5Qf/kx68bq97rUqHjjZfPArd9OTA/QjEa4GByhU2ZYe29ZKuoPV8?=
 =?us-ascii?Q?GS3GelW2iU4lo9dYHYf5KTBNz2AA83Ornqe0Bv5RTwwV3pkNgCw6HRdxN2vI?=
 =?us-ascii?Q?6CTvuD0yeQCL5CCvWhAHyMnAWxTD4lgBeSlin4gLWvbwF4n1LchKyvJW9K2P?=
 =?us-ascii?Q?iVm31+bMXLxZ2S3yLs75OF23378CZqAnvHtInQcHTBb0L8ZVL09Z/83z7k03?=
 =?us-ascii?Q?V4LEHGWVZ7ae5NL1GTOjD/aToVKGSiF4NjhywEhf4qEoj4irqEtwkugf94Nq?=
 =?us-ascii?Q?wJi3fV7tFM+rAc6QZ34oZRB1tISXuereC9JOlWMN+wjP/7mQ2nlwJJGwC9bc?=
 =?us-ascii?Q?Oen1rXLd87Vga753Gh8fLluX/kS6J8Xw0BZgDOjUxTYBUSiNzAU9EDFEIsyf?=
 =?us-ascii?Q?P2NEP/ipoo9weIAnuHeAcBcjoDQrLXK2nSLuPSOIglSLyrEP5QaeFPQS/R3P?=
 =?us-ascii?Q?y+zkJqYzBHGuUZzLhXoPo5PHBG7wm7ZOSP58WI+hSP7PBkJGVVQuiu5NOYAk?=
 =?us-ascii?Q?b2ZIJY99R7veqK+DwNmZjV/Wg3ZHM5FL4JK/93JFbpPQ55O72rfsbla/qxjU?=
 =?us-ascii?Q?WyCqaFmqN54EOMXr7Z5dDGJv6BWB7pY8KKgdtV527vS30SWcQBA1VF9EVO5N?=
 =?us-ascii?Q?v84Y1yvftVlz3IimBkBedMkXAu9rN/ftyh1GQq1rzaG5ybhr6/glXkMpYEiV?=
 =?us-ascii?Q?SjnWAQBn93MKujic4g8kkt0yTHLQVQu26Ovlz/N1lWt8pp8NpXzNo4MAr2q8?=
 =?us-ascii?Q?Gnwn3M/Wy+3w27VvmyS5o95mBeJbzytsBvGuZN+YjQjX6tLtqukEZ2oZpw67?=
 =?us-ascii?Q?d6rgVaEknO/6ncOyZxeZal0vSv9SVLvFVsZPeADPkrzsio87Q0AJJ1l7Dz1K?=
 =?us-ascii?Q?EDNrVeFtBsBI7iuvYAAu89QW0UR0hi1KrUGXePS9niRn230rjW8YxT4+kiXy?=
 =?us-ascii?Q?fJCaZwdYbPiQtQxCPqqx73y1RkOz7gVx+pA9TkKOhZZQRIuJ00b726h2Wh/I?=
 =?us-ascii?Q?Prl6735RVo88LiUmcJiRqgvQe9qCpffxiON0s6lU9NzPU4C+ZO30xWPHouiy?=
 =?us-ascii?Q?ZY00AQB1i+FqWa+SFlbBw2/TeKmyRKO8vFfZDUL54n9zTaoI1HeV+vkxOFCm?=
 =?us-ascii?Q?lP3HInL6RhUqZN1yxIVGbj6KInYGahUH+WGYdExGFm76HnbQnlccKikmUbcr?=
 =?us-ascii?Q?KvYrn5RmFkFSM32LP9m3xTqUB7Z5zz2k/ehnyKSv5Ts2CMSlB2UYeF6B/LOC?=
 =?us-ascii?Q?jGr32t7NlQK/ypBIx7ekJf8JkTxfhibXB5wWwpmoV5VbXuyPdtOjDbAP8cvN?=
 =?us-ascii?Q?PRDXLVMvrEQnUGpQd7UO3A2CMNjsD19z2qFCd1gwsTR8zoysq94DegUQIeDs?=
 =?us-ascii?Q?fg80Kiw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6279.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vv+QLFQD+EoIsNpk1L6YsMgu58EiVqQqvZuxaHH+ybYpsZwytQacbOgx37Y1?=
 =?us-ascii?Q?emK7MlzIxhKyNMkKMwideKg8OkZh5OZhH5UFPNxTWr6AOKbkbCRkGVF9yulg?=
 =?us-ascii?Q?5mSGYvSValeYdOOnokMYy74ul+UCKtDTR0km6u5EGW75CPdHgMPHodsr371G?=
 =?us-ascii?Q?Iw+YctR9t5U+S1XpFhgyQl9KFir6InWu0lr8qgu++xEox4bXTDmd3jynIUNT?=
 =?us-ascii?Q?2RLJco0I1VYeJsFQczuPfG6oZL6eJpeumJ8W9r4SlwjF/aMXPrVZOcJ2CvIt?=
 =?us-ascii?Q?wDKaR2JahYUSO1MRDfawL2k4vYscEJczHTr705rSJWHhphMkLdtkDBr/3JRD?=
 =?us-ascii?Q?tEBNwrMUQTOs9hB3ecUDsCZQYpXBn9cKXVsN4+YcT0117cHQ1uAOADU4y5+A?=
 =?us-ascii?Q?Quy8Rgznkm/ljjBbjTxDfrTzasc/MjxetqIBp08X5BW1Yx0puYH7MMHP4Ps5?=
 =?us-ascii?Q?wOQcPJNmPOfd+RTOl6dFdmFtXMfXgU09/QD/cQc+Mm314zV9fGFbdu4lJ0Z7?=
 =?us-ascii?Q?fZaJRFXHyvQFB4BeghollqszVh/kp9wOY/hvZ1a2UCM/ojiFUFT6KgR8pjcP?=
 =?us-ascii?Q?IGbkTXmRd1wow0Na1qah+FeSTwqFM6zQ2TrGM/VpkTHYnD9VsLVg+rm/8ALJ?=
 =?us-ascii?Q?giTBtm7xokpB53N+DdvRRyoIGDdvlRAaDRC+DoHNfDz3HiXBnQMZWCVBJoIw?=
 =?us-ascii?Q?WRq6Xxo0tKu1YWp1neJKG48/te6QTIqfZZwM0kCJryg0DJZDNzOyNxKfho52?=
 =?us-ascii?Q?XWeQt4PZLiWB3orGR6GyJ4ccLj67Tbs2yFpR0V/edcZlSURwOgFDc8QodOSC?=
 =?us-ascii?Q?ChF0AKZxv6NveGMfzsvd4KeRlS6P51Dspsd/hhdK5uQ/0te07Z/qN3mBTwn3?=
 =?us-ascii?Q?3h4I+/MTCA43ag7nmbV3kPJ8QUiGfcr7zLJfu4auf/KBlGy5RiT6vo30ee24?=
 =?us-ascii?Q?LJOu5VlnTmqciUrATOqufSMfWRyMm6MasjBDZJ/Y7oqPUWdZr6EBfWdoelwa?=
 =?us-ascii?Q?Jbvacs5XMukfBdv9NzNYr5JdMALdRVFte6DETwdNFxoRvlnjiJdL1G3gjGMl?=
 =?us-ascii?Q?I6dy8SQi2/2E+henkFLw6an48iqRdd2Et/NQ3tpRTVTJm7t+1l0MOiNt+Q+F?=
 =?us-ascii?Q?ZLuWH2gnmRbtimdeYtH7gq60Edy9C4WS9BWZnAullMFZh/4yLyQ/GTdCurd5?=
 =?us-ascii?Q?7t5+ZdhWSfIwdRrCSg9JWHmBJgG2LiBBuKRiDBhECDz9V6tqfXyMg/hTUoh+?=
 =?us-ascii?Q?0C7og63NDSn7SfX9te+oTlEHk6UOy/KqeWn1xLz1Ggl/v4lyTUOFk9qzEF91?=
 =?us-ascii?Q?YUAsIysiUvwSJDCIzBL7xDh0DdTe5wPdGArxYkiK07J6yf7MV7r0EsD8vVj/?=
 =?us-ascii?Q?PliJmrm35tfh3yScZJasHDCL4Ws0iYi/JVy437G2Lkjkij/27RlEPd+cb+9A?=
 =?us-ascii?Q?pvrtQvhg3AQdffqOkGcbBt87yxf83JpCSeRTZjIj5PpshFQezg4pmAYJhynj?=
 =?us-ascii?Q?6wFK5bO1DvcfA9cK/gVJ3dmvvlnr8YMkPzrRs7AUL4cEgw3rDWI2ur9Xil5w?=
 =?us-ascii?Q?es35cVpJMQVJtqj7fZF1OSWR2qUFhW4jFFNaL6l+?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90006af7-949a-4bd1-6eb9-08dcfd4207f4
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6279.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 02:32:02.5977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4l6EVkT1SQ8b2lJlW8tmE4i3C1WmYSQTFvajnqkOmD1Nw5MMusxwTQra7JwRSRwarfeFemX65kssqA+V3aHVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB7175

> The WB buffer resize functionality will be included in the JEDEC UFS 4.1=
=0D
> standard and that standard has not yet been published. Do the JEDEC=0D
> rules allow inclusion in the upstream kernel of functionality that has=0D
> not yet been published?=0D
=0D
=0D
Hi Bart,=0D
=0D
Thank you for your reply .=0D
Sorry, my mistake; let's wait for JEDEC to officially release it before con=
tinuing the discussion=0D
=0D
Thanks=0D
Huan=0D
