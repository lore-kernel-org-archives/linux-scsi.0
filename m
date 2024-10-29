Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2084.outbound.protection.outlook.com [40.107.117.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7155E4400
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 02:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730170407; cv=fail; b=lk6C0ZTsQuNzm4l08BwoydruL8/Gd5kpEw2GzHrKhLgCHhxha6Jsg1k7tN6HSSvUR1nWdDAUkdfR48zQ3+h8Yj+v+cOR2QOGNEy3VBqxIpGE0dMHn/dvU3c0SGFQ0NmhrYXSRyxV+PzclIrELs1CM/lpfIqeEgEUqeHczharv1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730170407; c=relaxed/simple;
	bh=1mfOaOZMv+DWf8bq0CXD7MF49Ne40cxcZI/iBuwnQd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IWvlgms8A9iJEKZlrrmcj3Oyx4Yw44lVwAQDvb3KtNkq3XnyufLtQ7Wr0+oB29JTHpKeoSEKSqtCeIOu+nEevpzdRfxcRAJZg0LljuRh5Ivvtzt3fAqOkMzVsrdSMgMYK/lMcGCVAo5PZK2s70F1GidDWELXMJZ8NbPQOVhhLqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nVyYIsHU; arc=fail smtp.client-ip=40.107.117.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nVyYIsHU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsdcZjml/7NfCgwh/mQJaHiLxZBx/laMRIYofGyQ1wVDzpH3fbHGQt+sJgt4OUA4+yop+lZ5zj+xjfk7u9LdEH/wIuleitipfmFlomluvavSISmC46eU2TxqzuALr5oqy88qA3adTl/0pfU3CU1Zm9MyVD0vpRPURv8W9o0y/JpJbk9FmdC9XksSJVeWdb9jJ+xwEWEQqqyM8xQ116Ed+9OhtXCF4UCbUBO7x1rv89P7B1IKHC4to3GHxisxgpi7ArhgNu20zzf5qzY/Y1hDfbeyZXTQ+FEydEqBxKFlZ/9pp62yMfwVSHxbnprWAdJk1K42p1rhtPYW/UrRTR9k+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/lET/aHLy71VQl7BXLTWkcvyp0kL9L6sSePZ5uCqco=;
 b=eNBjxt1F18+UgwJN1QthzQu1tnE/i32lnhPXY0Ybc/PgSTbuD5qEdX5U2lfEQ9OZyoMjDCyYTHgTnrpQiq0Xho0Ui8CWhfUJT7q9vGUKd5MZcdXGZoM+c63aATDzs8ZEjDHY5AHr+hEM/X+/I8K2mv3gYq3GrAoufP16PR+1BbA/QyV0z1/jtIfDpW3W7BQVdfG7ZJ9rb40RkejxQURDkxZBgM380Iz/6QEm68KvKkW1kiRVLlyb7e4cH/qvYanj4QFghDoynrA/TEqyiKlTE1Xvh9zr5f1BEwoeo6ZfFDueOlS/LwEnCbpsxnR5m2UAE41E6KM43LEXSxGYRx9mxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/lET/aHLy71VQl7BXLTWkcvyp0kL9L6sSePZ5uCqco=;
 b=nVyYIsHUNuqgUKEN9LA8MNOedD3fdQgQ/RTe6emRMnMnYYtcNy9nLC6Xkr0fm6L4V30OlAaJ1Ms+CPu47KAuB70HitGuGxSfem6ocmzEV5QfeWBl0Ke/pMnvWQB/j7uyW6XURDI+xGhqTBQEmmbElmuPeK78mc4wzAyT3E8B4awSiDJjbTzQ6FceX7HXw90Dx2Yc7HTB97mdz2kuWpslcbAIZJGQelYRJPGAEHCDPR3JVZYI3YT3b1EyfXOKNQy4FmhX8o2jgPVa8yDv3M51SYO8NouQHXwn3rmjjyrVDvvqDVPhrECZ4s6OB8y5Onbo3sMptjlauYwwJ8YgKwpqvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYZPR06MB6096.apcprd06.prod.outlook.com (2603:1096:400:33e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.15; Tue, 29 Oct
 2024 02:53:20 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8114.011; Tue, 29 Oct 2024
 02:53:19 +0000
From: Huan Tang <tanghuan@vivo.com>
To: beanhuo@micron.com
Cc: bvanassche@acm.org,
	cang@qti.qualcomm.com,
	huobean@gmail.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Date: Tue, 29 Oct 2024 10:53:13 +0800
Message-Id: <20241029025313.324-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0215.apcprd04.prod.outlook.com
 (2603:1096:4:187::14) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYZPR06MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 6386843b-075b-4fac-9dd3-08dcf7c4d84a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B95/mkPy1dXKkQsAMafMJcAGIUFq8TQCoF0eQSNmrNLA8QNzgQ9BygrnI/7t?=
 =?us-ascii?Q?jTW7S9eAO40NoLauWos1xcYwrkwwGb85LcJGWWr+hXnDMIaeAcT6Y1aXwyAp?=
 =?us-ascii?Q?oZCG2d0fn9GPcY/fHVKHhwnKfS5qZLd8Ep5XKPu63cA5kAAXgmr/qwpHRWXp?=
 =?us-ascii?Q?hoigOzY1z8s9CQ/mFkU/g19FyS7X9Swf9XdCTnjk5yyinjyWowbqeNY6JZY3?=
 =?us-ascii?Q?yDxvgP5g7alW6IIMBBBFDG6poS52y4/rKrBH0/BQlifVq9Gdy5rrWl5MUKiY?=
 =?us-ascii?Q?Dh9/DB0HFOSILrF2gvzEYz1LfZx7eCwtZ/p0FEzhJ2ujU+LHwMKtzyv/uJdl?=
 =?us-ascii?Q?7tUEMJePI/i2lL6JXbnWCgEcF8P9h0Q6mLykg3KZ91vyqaHjhKalU8N5w66I?=
 =?us-ascii?Q?uMaAaPwT6s8yh2/Ve3wPZ453HFbyoK+0Yyygq2Q4EmNyKqxA9om1SvW7KnQb?=
 =?us-ascii?Q?4RYnOPEUAwjR2BeHGK87pl7sMJHafH815TcOrC62i7IhwPo8++5amsHB3zqC?=
 =?us-ascii?Q?N7WBswYgysO6m7dOF3NBvVPm3h1Yv5cEj7Xu3jBxOFmIKqBp7bjfFBKg1Ahu?=
 =?us-ascii?Q?y3/Bz68rCirr1BJxOaWpDUKKN6SZhZvK1UTImBzxBzdqZgQfuWTJOIL6TW2t?=
 =?us-ascii?Q?6AYo20Ke2E2EQUwUMtuX1oPCS8ksbJJplsL5cs4k/U5I2JkKlewfcCGDoSl4?=
 =?us-ascii?Q?6f4tGXCUC3uOMml3OUJ5LA+ZWVNwo3P6sn2EllsOTGHLV+Xldn3mMjOJjxeH?=
 =?us-ascii?Q?UXkTlR8iUvxCBK6v+QeCF05jIVecD96c+lEXPaxUiTrD2OmNQDcXuWakAHjQ?=
 =?us-ascii?Q?gKTwtbiMU5NTWqU4vMFPyK6QMAjqcdxrt/Urq+uTuHsvtubcnpNt5Eq5VJ0N?=
 =?us-ascii?Q?b8lEScNqxyOCpRycJ7qdosOSuq5tN2CEWdDDJJiXc4yf4sfAx1cC2m+ivm4p?=
 =?us-ascii?Q?BHNgnwKVHhV5A0ztBFxHY8GNeyl+wN7ugFjANuAUeBUxQbm2KEprNsGwwMmR?=
 =?us-ascii?Q?supM07ob1Pj5Knhob5PyazxsS/QJ4ODRPVb05rSSK+Z6ZA99B6HLQnaWbadn?=
 =?us-ascii?Q?2upkQNSS4LRqwipCXAnlw2o4N+qRcVOSrLN0AFV0A1C8AuWSngYKBFEfHVmg?=
 =?us-ascii?Q?i9Mg1xEdcWPuEGFkK2HNY/rzLCHxyD+yhbeuayCjDdJUzMdCIJmzjK/AWToj?=
 =?us-ascii?Q?GmFNAadqZTIVVqx2BlA/iiU96XNc/hSDUa29h/j7fcTTyV/8ZUTqXQVBrkvm?=
 =?us-ascii?Q?eVFl9SHIqTbPsfnrvdxalFfo2NAB72GvO/TE1QFWm7jIISFdhDMU4LnK4/6X?=
 =?us-ascii?Q?AQS/a5npTjHafra28ZD+Ozfk/lpCKNfKFlK+GP5z5vuG7yyy4mIOfzOVfvgZ?=
 =?us-ascii?Q?OXknuik=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rYD/iIzOdJ4M2eQ5EPAR26gbn4cTH09Q96tHxfdNWt886kQmLl/DnTAjMSd6?=
 =?us-ascii?Q?T/Hm1aKlMSzrEy9LX5lF2bclOYSqHP61ip6e/K0tfTIPse5mj5UvpJJEfK5X?=
 =?us-ascii?Q?C6qInJnsc9YZ/9755xRN+ULo8wo7gNxG8RuvaPvyYxVdrr21YhQvkA+mZuGB?=
 =?us-ascii?Q?fGK+5EnjdSMw3WBEkeJzUoydA/yv3SuebJfxmnkTc98RXY+kGoCglScD3tfW?=
 =?us-ascii?Q?UjE2QWpCVZyVrlCrNalwHJD0b547T7vR7eonxonujRM48goRLO6N79oDV0Mw?=
 =?us-ascii?Q?wwFqMhD+Eary2rc+/nLiM2LWHPT9v3gG6hPvW8B7uJykcB1A2pxWAH8OoquV?=
 =?us-ascii?Q?V3AcsQHrkbEGaSjtUvJsXhPwP/WQevZLkF/81krlC+lwd9rrI7648y7+uKyM?=
 =?us-ascii?Q?DOmpFcOZrSO+V5ldUn8zefv2mx8plHzbq+eSExcrWlQ6GDgaWGZS6bk8Le8p?=
 =?us-ascii?Q?4avY/FJS6h+MUtBStK0J0HFKgbTVyf9VXCRI/f7guhMSOf8FVGrmzMxr5Kyr?=
 =?us-ascii?Q?ET8rl2WOXjkqbiT6pASasps0HFmtiakGKG+kF+LUo+VNKJFQGUrvwnFJcPss?=
 =?us-ascii?Q?O/4Blt4IqvGxUUmw0K8UkN7IqT6bHKBcIS4TGCV93PITi5XHs5h5sJ+erT7o?=
 =?us-ascii?Q?WMVHloHvotFDze/QVtkssRzuFydS6ogmZcdpLpGRYnl8gfRPwUcD7DeJ4AfI?=
 =?us-ascii?Q?J76/X9J4qJqISC5HbBO1pgU6yDGB5YhwocJOAttdFsjwBKTieCdAe7tOPpnQ?=
 =?us-ascii?Q?86LJ744i3IKSF/dBKith25rTX/ANvRw3L1dmfXfBsbuTIxQ43CJB99y9mb8g?=
 =?us-ascii?Q?iQy3y2vA/V5RJknouesIz1kUo5ZSNB5PzoXQseEf963DwV7iglkDRJ9ptqDp?=
 =?us-ascii?Q?jMdIR7JnhkPYxUAVTfoYIXwyR1JQFCoyF9gUDXRRlmHO3PYvshr1eotiPJBr?=
 =?us-ascii?Q?p8/+DeuRhGI6IJ1xMVi+nPtkghvQLWaSnVVR4WjlRk+jH3cvkMFdqCj8ZckP?=
 =?us-ascii?Q?WhtzH5sMGqqRtdsh933pjBJI3gif+zyx97eKWgVKqZsyO7LhPPY4ESlVUA0M?=
 =?us-ascii?Q?zXcoM5AZXVK0toEBhM3nhNgC3jbQaUz1V0css3HAaJAgzba7fVQQdjT9apYo?=
 =?us-ascii?Q?FH0hzf7vNpd371Ozscl7VQ1fJm2RbvuHaSmFyBZIqcYYls2R9/ldIzRAw5RU?=
 =?us-ascii?Q?8LxI+dwHGkNR6bEDAIUAKwbiV4Pjj4xi5+FwwiOuCtr8dbtM1xNThIg9fNXi?=
 =?us-ascii?Q?J9pCvWNFa2iEuUFsWSRpPdCeev9t/uS2V+43KDPdl64YECL0zxdys+R1QUjw?=
 =?us-ascii?Q?3oDqMyljSb6Ts5hzqBA7UvN5O+VTp84fkIMdxQkz62lz0wzBDYFNH8VCyp68?=
 =?us-ascii?Q?cxkxlDtjFKPR6dxjVhWv3dqE+9DWdcQsyMxWT3Dg28FO9qUgFJsPdiWYasOV?=
 =?us-ascii?Q?v+GMzH8Qfpor4T4p2Us+MznAgMd2D5kQjnjWDahKe+S2pVY2rnAr4D0dztHX?=
 =?us-ascii?Q?Z0ZXX77Gp0YLEDaKgOXhs/sryFtffScaQwHEh3Q+vcEBZH84dILy+t8Vbh45?=
 =?us-ascii?Q?lDrLzc88PBrUDwwFpL9JhOIulsaulV6GiBZZsdQb?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6386843b-075b-4fac-9dd3-08dcf7c4d84a
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 02:53:19.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sH8TfhjPDIHYBgGFBIKKF1YcKDKslUOvGLxa73Q0Bd3UtOEZfMaU0LvW+rRgf3zYmICbFU0Gz6npCmN4ZSQLBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6096

> I would like to say this actually: committee approval of a ballot does no=
t give a company or individual the ability to disclose the=0D
> feature outside of JEDEC.=0D
=0D
> Unless JEDEC has published details relating to a particular feature in a =
not-yet-board-approved standard, these details should be=0D
> considered proprietary to JEDEC members and not revealed outside of JEDEC=
 until JEDEC board approval has occurred.  For UFS 4.1,=0D
> which will include the WB resize feature. Has not officially published ye=
t.  Before that, there is no public information to release to=0D
> the community.  =0D
=0D
=0D
> Kind regards,=0D
> Bean=0D
=0D
Hi Bean,=0D
=0D
JEDEC expects to release it in early November this year. The spec for this =
feature has been confirmed. =0D
Do we need to wait until the standard is officially released before discuss=
ing this submission?=0D
=0D
Thanks=0D
Huan=
