Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012002.outbound.protection.outlook.com [52.101.126.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829842749FD
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 08:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396829; cv=fail; b=oC2EXZxEY/67DApPu4zNT/q6fIcB3WeWEB7iOoo06HRBqGef6thqCnLEvg0IbvI2OphC9r0oKrpQ/v46bOZA4ehWn94yUzr3xEg19db6Bh2E/MQsDUnTSqVQ9GavRg2FekTg+cWpydjQ6TMjJDLlOEfio4ZmjvQIY5ACgRua00I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396829; c=relaxed/simple;
	bh=C4GKWdfJr+7XG4Xw9kfsKs88EApb2OnX2SvlHaMxroY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UZfCkuct4Srg+Wt35rUYlbGeql5y08H7h7B6jWfvnbWtnnEIHUiMIfxEn+k56znAXv3airWQZURQpH8VM6tuGagJQUsi2rBakblNROvlxTKN4WPGxe6q9p5AhxvS1yMcf2R4c3xKJbxraQzLiMMzIU2qcidWgNj1SP/p6EZW4AY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=bh9TtT/l; arc=fail smtp.client-ip=52.101.126.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="bh9TtT/l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QQ7bkX2ElD+5jYKKRLuIccYFDSsmRTB2rhu81VUlORimO0X8kDDIhUVrPhVIvnvW2fs7OhVtqpRKaH5CStBJyIrS9afrmWQiTTZtOYXisGnSTMJDwCZ1ki8Zv/vI8l1jZNVtJIeLYULsoF+QuaEHHcpYUrMJSmwlmGAysrxqzTtFH3Gp+SCszNJQbguDufyfrnO6ImRwFaCMkjs+xGOjr6GaIQBzC7oKGCY3ddwr/w2c8uVCQvIGZo4aBTtmuqum86SN6kFEhPH5u4mlNgmzGW4RCzF+3hfWHpJIlEn6lNBGi2u5zMwFkC8jVxJLPJP6tZ7wPWQaq+fzhjvcyRQKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4GKWdfJr+7XG4Xw9kfsKs88EApb2OnX2SvlHaMxroY=;
 b=V0UrrCrgKboOaFz0kBwtXM4mv0R2fn1lt1k2MVDynY9yJ+lDcV6otfi9rWgS+cvaks7aP/ZFWypbQqWmitqmts+g0hB+7YjAu1HI9qm8+e9vcLBu6rdRkxdb2nm7c6Ou+QipBVjJwb/Li5ymxuY2HvEHgDHdzKYpgEsuQ0UD5HgvtstodQq8ax1eq00TemwPcErQ7RiLwfjDl7Gku6oSKOq35PhvMJWg8gZI8Rr2G/p/W7JpwrQuZB8wS0Fdeed5LPp44IrMjomOi9gn1Lxg70iCkpB2I/3Q/PLCeiU3hkQS1GDhoV+lu1kWIW9APjYNqlN9898zQTy4BZxelP6PxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4GKWdfJr+7XG4Xw9kfsKs88EApb2OnX2SvlHaMxroY=;
 b=bh9TtT/lLnqLZ4j4p5FWtVUo9oNvHNc9+t4jYeReF3nSZbNKEAUwHhON7YvIl8YKgOB2kxaQRR2GDvDvzpPVKL+fznn1KZvQCKHn9gCRHev5WlhpIOUMMEFh9HlZHwL7F7Q1ywdpBcxHfpOzLikgwTXEonHmUgFqQSsnSX2EKmBcZa8mdKOkFUIrJlwIBCeFU5iX09MNelecGmYBfxMoUtHmVbwXSmN5AUBNAtdtTGOaeI94gWXTbtngYa6zo2mDmgatY0k3F8EDaPgfTJK0/1nLkloVhO1Rbesli9VTb3ighJpV5r4NwO41wEcQEfN6LibLMVRRX1r5HGFf+tBezQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SE1PPFFDBC8F9D9.apcprd06.prod.outlook.com (2603:1096:108:1::433) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 23 Apr
 2025 08:27:00 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Wed, 23 Apr 2025
 08:26:59 +0000
From: Huan Tang <tanghuan@vivo.com>
To: peter.wang@mediatek.com
Cc: bvanassche@acm.org,
	cang@qti.qualcomm.com,
	huobean@gmail.com,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com
Subject: Re: Re: [PATCH v11] ufs: core: Add WB buffer resize support
Date: Wed, 23 Apr 2025 16:26:52 +0800
Message-Id: <20250423082652.966-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7ce05b28f5d4b4b4973244310010c1487bdf4124.camel@mediatek.com>
References: <7ce05b28f5d4b4b4973244310010c1487bdf4124.camel@mediatek.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SE1PPFFDBC8F9D9:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a153c0a-7f29-40eb-b3dc-08dd82409dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nXoECwF8gccP7hSsY5yskSiovZlixdsns+zBowYaGPzTfiSnUSiYTOlEHWJM?=
 =?us-ascii?Q?a0bxDhVDrFO93TJBTcvQNYHAZXE47SrqMGdc8TD5kRWLHsd2t154N21+MYIS?=
 =?us-ascii?Q?ATC33qItrsthCOlkZde2yTozIV2rMEXFZh3iV3dyOgcis9FyXOsERPWVNkTe?=
 =?us-ascii?Q?7RdTN5k+iNwhOK7QANWlDejFLojINB/6uoJuR7zvLopqCa2rxzz9iMZrZwPh?=
 =?us-ascii?Q?oPBeJVYtVE9pVMwLUfnTlTg9fPkehXKmGwZd61hR+deOsZWHQWJp6iMdPv2+?=
 =?us-ascii?Q?Ltygr7MHz9XlMbyYOItZKSVbxtcZ9vxCrsvu3ymq3F01UPhaikz+BqjT0cpX?=
 =?us-ascii?Q?U1MZm+eFjdQJExhlxifYLpmRcyKkqXIlItKxAMd08Ap9cmuxUDtPV4T6hF2Z?=
 =?us-ascii?Q?mcRokX4YtGRp7ICWGPoMMDqXCKzPL26xKhTlY9llnJPjRNIvFHMFV3dOl1Ie?=
 =?us-ascii?Q?zmh7IQ8YyC/0k80XDlKBw0NVf2JyJ3v21uWgxKV2weBnxid/c+ZOH9Dm7rzB?=
 =?us-ascii?Q?Aw2vfZU1EcqSBjDppxVy2bwwNk38akXZD4TRURnnU6dFoGtbIQBh0U9pLDcA?=
 =?us-ascii?Q?YgzxqCGK8BKaUcxovyyKXBpuW+K3WQfz0xD72YTe2OvutnKPJ1PxyvaptQfX?=
 =?us-ascii?Q?olpDXzPpZ4ErffvwI+BfAmxkj6ljA7nDby+t7q9+X/MH4efopB24qRrwfxZE?=
 =?us-ascii?Q?ufAfYyBGRKyJNRrBcKdqK7AWm3X0dezmD2Kkpz5FQDvph6WZ417PhWLSB8aP?=
 =?us-ascii?Q?mgeJee6IteByQ07aDork26lHanHRglOei/MC0HwgIfMYVEV5S8Ai1JiBzj7f?=
 =?us-ascii?Q?ytDDZ30a9kCXgQoADRRtgLfBHGl3Im83hvfGyqB0iWQeplX1Y208X1rIlhSR?=
 =?us-ascii?Q?z9MguVJYuKo1Fnt3wR04UYejCYKovHF5Lbs54jkdI+TrFicfjbq8Kd5r/OJ6?=
 =?us-ascii?Q?p2nk3Subx2aqTCIpP/Q87pi6Lxa5G5QEP//mFbCzUgnipd2NDCLc33d1/LbX?=
 =?us-ascii?Q?KFmfc6s3vE5eQeexgMhbgWtuZEPBMpVrD2nRhuOfJ/cm+AJMUkSHntbnJ+Pt?=
 =?us-ascii?Q?R93N6BkU+M8NHeRKSeSfOmFeTW9teqr/ttlHwzgiwlihqtyEzt4iLhK2UzH5?=
 =?us-ascii?Q?bkoG+cT7XImqihhnvsq/xZ+BzXiKBADRcvR21EWX1IZnx3FAbukPoRSvtrhF?=
 =?us-ascii?Q?Cm3nta7/yx+JaTqclfZsa/KCFHX8EF9q7OEHFNalVFbDz9wkxm2Ll0ApMLvK?=
 =?us-ascii?Q?c/kTHz8AhQtHPEZ4ByEho67vzfdKEKKelyBT9BERTA+yU+ASBFzqKc1F0+XL?=
 =?us-ascii?Q?CWc3U6tc/qOz8gHkfLPXGVqvEQE6/wPHCAYEdMhXPKzXVghK1AY+eXlWHzp6?=
 =?us-ascii?Q?yYGOdiOdFCuTIdoS5qc40XR6Attw0u9Efk8qKKGWOjg3r2B1bS3fFlL64ULO?=
 =?us-ascii?Q?IEBNQZa6L2Iv4l4Bj+6Uy/xQR2J5wHlWYswSlCZLyM2WchvGIQ44BQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uqBywfZjV4lZrB3JGcf7LaxSqEiLWbfXacQX7Xjd2BwmqyiSn3IatoNxDFwG?=
 =?us-ascii?Q?sFk3u5kc4pvHsR9D4ConeQPU8SeIt2i0NI5FEMjE5vlKCGSq/Mdpl5ynwK/0?=
 =?us-ascii?Q?UA1PEUHOJNtXA3qNa0ryNsLyp3/qWxAubAgQ5gL/hFCXg3ijJ5nkCLybfjO5?=
 =?us-ascii?Q?p/VZtltSYaoEGsUnms3Ox4Xc5MJ7qepzZL8SSvYHVgXyfrVXSzwatZKgI0+B?=
 =?us-ascii?Q?2AnMfOH3twJaGvbYzuCLrreJfSRx5mjz3TnUukBaXK7o68rpxNc67fgXvE9y?=
 =?us-ascii?Q?33KOPqus4yvVVXnmN/WsQf0nPWQmbFfU8fyYfjKR69QHm7CS42Kv1QE79PDn?=
 =?us-ascii?Q?j1YM4KYHOWkNuj9eArUEa6XJwLuGGHn6dLlfBXL1Ozy7zOM2UD6Gyo25xNup?=
 =?us-ascii?Q?lGHU4fiUuk3KMaVheFRZVSVMXH6rVrPOhd3lI9q3aXzFNidOmZF7UxfKa01e?=
 =?us-ascii?Q?pZZEoF6+Ah67jKAefXVS7EZK4pUaBXCbTxqy9DogE5sZvozn4Bv5tz/cOXvK?=
 =?us-ascii?Q?+qatdlNXydPPcDNlbyTeF2WdEoeKxPVye5IX/V3MnFBWi0CKVMynkdJwCoD0?=
 =?us-ascii?Q?58nn4TR4OYP6ob6Elg0bchycYOH9bPSeyvugt6g/GglntQTSINqlTLaJRMI1?=
 =?us-ascii?Q?P5899s6C7eCKwwiaZgCsPXYLozgVOmFY2uetXhXCh20q4ib83Um9XKbMKmKj?=
 =?us-ascii?Q?+/WV5GURUEKdy7LnZRt6B+y29+/4dNDdNs4YMXC7JWzKjiVeSXJEPx1EOFRQ?=
 =?us-ascii?Q?/m4ubxm7mASf9jDzuq3nER8UhoB33yKJgpP7njvoDYf8ba2iiVqFivu0LcDB?=
 =?us-ascii?Q?C/DiuL4GGKdOTQftovHGXdX4D3ecCp1QjjItlfOO8i8RdsU85cOtyEIzasLr?=
 =?us-ascii?Q?Wnh42874DpGH2KYtm0E8KuiD7X3FDTgwnoOEmvBaJIA1Fzh0HjRRWk2nEgsv?=
 =?us-ascii?Q?aD237iijfguB2+mV2AOVyU0UzSkojScHnbrB2x9We8kzeJWmicenmX7bpa5Z?=
 =?us-ascii?Q?n2Mo/L8DGBj20680pBRtxdQ3PmwlWyonSav9D7TWYN9F0MBwdeiaReSj1W8X?=
 =?us-ascii?Q?7hQyZectlIwrQxUbMcE8dfyeGR4soTARyLx6B+90y0zVK3rI+Rfe9J5iw65e?=
 =?us-ascii?Q?EzfNYglsQbkZi1jxTU94tzBrO1bvgsHUG8gtCRmSFKJuAh/B0pAiwp4P7asJ?=
 =?us-ascii?Q?JL4+a/k8KCDYIvyUBcSwG6Oi3i0TnDjKcL9hDSBtktJV90ZuUfSU8OtnHlm6?=
 =?us-ascii?Q?BJqqPVAMV+OowxKWRlAROfLisB2bE9YYQdbGG5vsUP1Niy8VI8JfPDUxz6TY?=
 =?us-ascii?Q?41U4k5KAVPeF5A+yNSsac8oRwDabB1oW2U+U6IKmEt2yu84vosCk136VYxgA?=
 =?us-ascii?Q?nqAP2eoZDgLkOrNz8xldHI0sJvwzMRtmBfmbo/zJuw5CoHj1C+FJt4UXQpou?=
 =?us-ascii?Q?j2Vlw1D2OZKQO04mEUou27Z46wpLHABuacuzET9lXPjY41diDREE6/cYLp7G?=
 =?us-ascii?Q?YG5/vzjSl15Ko3XPj9x+lR15aEYB5vwNks7YsnvJt+ite1LRraplNndGv3fj?=
 =?us-ascii?Q?IDyaI8QkPXZ+qyyVCfZ7xjc+LCoFByGhFflLSTc/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a153c0a-7f29-40eb-b3dc-08dd82409dee
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 08:26:59.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gy+ed74yd2TZSfMVV5FJZ2DsTVc3vVPigmANnVAPl13z71QR5blp9cxRsw1ID3+Qg5Gt4/710/Sf2JfbbIsBZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPFFDBC8F9D9

> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP seems to be incorrect. =0D
> It should be DEVICE_DESC_PARAM_EXT_WB_SUP=0D
=0D
=0D
Hi peter sir,=0D
=0D
Thanks for your reply and advice! =0D
I'll fix it right away=0D
=0D
Best wishes to you !=0D
=0D
Thanks=0D
Huan=
