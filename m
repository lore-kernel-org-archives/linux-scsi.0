Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E623F429
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041036; cv=fail; b=dqCqt4+VA61RUKKqleyskAWHafPTUzRwtI0ZgFFcWnzsqreWUTGX5bhhvAVia3ymljDCxBDE6+RxDFNkiycxmCg9LYtumfQ6A7IRR0cCsClV4aSkcowFDNCyxOPSETkCtmj6ZaSIIORvkqTQcD+Fa8NpfBylfOiWbG8LZQcCTCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041036; c=relaxed/simple;
	bh=8ensRFr7XN7X00WJOceatrLSFb7TJnwUwNpuByoKsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LxmnJIIIUG3jCzd7cFtGixmp6FGlre1tOl5Eu427R3qYPmYN3XrU4avchJ1UUC7Vze8HrK2nbc2Pbg7pIFp/ByAbIapmGcbwCHkqx8qg/SIEUcUlB83gm6SCv147B2/bd+qlYFrijoRVfyWb4EWOBKR6LA4AYy4u+zUa2dwoii8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rJOmDWqr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Nk/PY1ur; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rJOmDWqr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Nk/PY1ur"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCG6pd023286;
	Thu, 13 Nov 2025 13:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c5GBAdYnUk+7ow+UZXxEvescjYtse4BkdIfQhC66urQ=; b=
	rJOmDWqrRG297XiHac9rcHJP/GUoldML/lJtK4c2z/0u+4qWe65dqBF4iqrwPL4f
	2D2XuPVuXPb5FBsMrgtYDqKKM9a1Womvu8XRLPaE2X5Zc7PL25haYeiUeW8quJtA
	igANzdjDYtlVBexg6lgd1VSnrCvEsmFKwFdUnBPBx4YwwzrxO3oLO9tZ6cEtjefs
	tImyKdbDZcb65ih2mCJsNT0vpz57VzBxaOf3O/V+jSoI7xV7IMOe7tdLYnRWhKKl
	Qrev+nnjRrFh1BU0Y5sjtQHDqRq6wHLfJ1ZOpGQ3Laz6IIYaqOEX5TElzvXgu3mP
	7T/wEwc3CbRxlG9KOvC2yA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqssup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBsLhM039422;
	Thu, 13 Nov 2025 13:37:01 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac40u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+bEuHC5cyk1fTmKNWqDzdm/LmtpAwPBXnDsGBrSDHnynApxWJwQxaicjGNlAuKBBsIVAsin6NB9QCd3fG0vWBb804p0LGWUBEjwC/RNXXx5dUHqViBGppE/Ybq+4qAKxuM9+hpNpawdCMbzBxZOsNrnwDlGSnKtt9g7WUBgF8h0RO+mydkHvCrVBDsWHuRLKBPjt5CRoiC///4n1eiH0TokbyyRYsPRpSoSIPlInGzRYTuEML1UpPn7xtSaj+2HTrfQNymP56v6q3YiaIJC+qAHQSZTzzvlhACEGfJPtnxMG/rPKdTJuFOduBwUUXvzr3AUNeOgElIW9txBHyfGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5GBAdYnUk+7ow+UZXxEvescjYtse4BkdIfQhC66urQ=;
 b=l+Ul69949pVfMGi0FPjK1qCK3aBQHOaW10++ylxwJWfHow9rGoy/LsiKdqAIsuNM0KKGHI6G+Ma3Frnmumw1OyYkq4svbruP3CRz39EW7RUbFW1lZ92/mu1zZKba0tbC2uG7wOpgIZQSr2rUbiqp6MJ50RBlRLzwqzDgRGwuQ355CJYOQgvz4mnJsw5kp+W3Wx+3imus0zlGSsNq/wyS+T3CMwil/6LRXykCgrBVVlOlk+16Qi5vGuYCxhJajJiTFX2BWshWCzClmwh6/A9gr/U1wEYlQYWqw3huKWXAmAJsnZbIlYnJsk6z9jDzB+lv8+smgc/ah/INWzU1h/d4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5GBAdYnUk+7ow+UZXxEvescjYtse4BkdIfQhC66urQ=;
 b=Nk/PY1urfVvJ/EmmJw+ERqRV0k4T8VrK03oeJ4vIM8urVT/j4JQzAGqQAYBlVhaQ57KkjZsY2fUcjg0gfFEhU8kHL03r4JtJy9+uoNy5qKUjcz8i2Hf8wFW3qxDAXRXTVCi9X5WWQlM5xflh3zeQaNQAnfREA7FmSyfGPUPEXPY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6252.namprd10.prod.outlook.com (2603:10b6:510:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:36:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:36:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/6] scsi: scsi_debug: Stop using READ/WRITE_ONCE() when accessing sdebug_defer.defer_t
Date: Thu, 13 Nov 2025 13:36:41 +0000
Message-ID: <20251113133645.2898748-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0122.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::28) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: e2b4840e-02de-401b-81cb-08de22b9b748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2emTnEg1uG34kRh7VGqwyW4RnwFdpoXREj1XSOrdINwHsJdbznc7MjlZAkTI?=
 =?us-ascii?Q?yINn4er1lqf4ZtjgJyReovfNE4a2pLuoHxKSJCpiADB493VtbcCtdeGUjsoo?=
 =?us-ascii?Q?W/afs6bo7cbahikPEkmZCL8B05amhTF3rYFyLU0MzoDb2w/y8HDdNibhIsw3?=
 =?us-ascii?Q?2Hy5RNBQwVate1d8csyhl6M8k543Q0YEpS/1CURqaLkIvoEqU7aien9rgANG?=
 =?us-ascii?Q?QLX2j5Xq9w7PzLPWm7QN74gJhBmDbv0bY/uvDNLJygo7V8suaa/tJc3KCKWn?=
 =?us-ascii?Q?4nYTbyBfST17bC0/4gmeYhXjkzJex2rp9838ryrIWXqnmmZBK8uYTR4pqUg2?=
 =?us-ascii?Q?fqcprzfRKhhCkmfBjbRAOT5JVDKPNZxmhCKTc6hTadbYNOHBZ5dKP5u45SX0?=
 =?us-ascii?Q?pJlX7OFj/Lr2qmihcE0T8dKHDxdzRGb8YvfhBkrrRupW+71aQk9qPZ1fbG+8?=
 =?us-ascii?Q?X5a3SKjxZSXgFXRF8WhsqOv1T/pz1nStyOPphzTjHcbAlxCauiJQMEWYdhX7?=
 =?us-ascii?Q?ACx5UJckjMpSFqSL8vmCJPh5QaM5i5vBbtBEagu/jenj+RRyg9J0fyPwe8HJ?=
 =?us-ascii?Q?sDsDKIRndBKj+FdkBf3UM5gq+6PX6c5QSXghoCotb+ofbfU03xSGz/x6YjTc?=
 =?us-ascii?Q?EYhPbgdyzDhIoSl+Sxb7FwEW0XQZfi5bpPbi+2dBjcZ/1xV5SZm3QH5/lnDf?=
 =?us-ascii?Q?qL/R2r8M+ELPKYCzou1yegXV7b0HJ28AFtcc6x8wR1K9VHi3aN4fbfQB1c6M?=
 =?us-ascii?Q?scGx5d93MMniAurTKWbwkNPwmWswo6VZH8loeYENcO0A0gxXKzV7oklinEJs?=
 =?us-ascii?Q?BJ5PIBvLdc98+BkXqSlHfY8jxPLEjOhOzeK9Ky5keZ3/ETMn9YRzQFqtc/MC?=
 =?us-ascii?Q?G7mcv98mMFDZSIY4k+vItlz+Um0j2AMggaG5ZLvprt68Jyz34aOTnC42BonI?=
 =?us-ascii?Q?h0Xg9BwnKr5rtZiczM9xXzvZR5nkJECTVTd5EAhcHobNQlbpvq8XC0rWjQ2F?=
 =?us-ascii?Q?miEX3BvPqee8xUIAgkIOOrgEK4pus4kLUSNpTy3QaIm5h73wsq4MfVcpAD4K?=
 =?us-ascii?Q?PR/mnJ3x1TYhoobO9NEZYNOpoK8RTP5iTmjplLwr0cKLDQ/A6j4vH6tmdHi3?=
 =?us-ascii?Q?6h8aiVeh+ygWmbGvS511LfO236gBMh4HbpOCTZRuLTl7d42ZTxhl0o/GAiI3?=
 =?us-ascii?Q?0pXElJ/C8Cu010X5lcGxIwNKels2PHiSwz6LOaK+5KLzuoqlLuKgKbmLb0LI?=
 =?us-ascii?Q?4GTw3zu8CGTJmSMSniwXYT2rLbopvaxQ6pj5TrqqWFo+ZHQ2oNsAIo6zYjmu?=
 =?us-ascii?Q?t5Gz6Hk85jfYP7nk6DbTtIo566QxERXP/CW/tC6TAljglkTekRe9cZQlMNRU?=
 =?us-ascii?Q?ZCfMqKn126mntG5gA16oX2uYTvA3tdT+hx6soeRqxMkCSstIohz1hSprM3hx?=
 =?us-ascii?Q?1K3udWjk5vERzAjp8c78RhQfw34q0MzE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OuOS6Uw/uuraOTKbol94apakQ3U+u5ZRGfz+64vPTw47+k3/MzQY4jTvRBrM?=
 =?us-ascii?Q?skWOK2qxo7TjSmMyfk5t1WNQI+BC8rHHyK9gq6AUvg9JjTu3Yz+GwneosfzM?=
 =?us-ascii?Q?URmFOMpLj+I3LJk+0g0nD7heWdHppYClojdY5/HVmknCKazLBwjBO6tBa6l6?=
 =?us-ascii?Q?jBrfo3b4L6vzkxSd192u5xpmAmQfIzGz2sNLlE4utuwFBs4ibQCCWO9kJZnU?=
 =?us-ascii?Q?xzEmLf+dk5TjGXv5+5s//YCEIsTHS9pTtFcCKwuwLQO/+aM8/0FlOgF/t+cn?=
 =?us-ascii?Q?mwu+Md2HLGNcpcAJyQJIK6jl/GDm9/ac388+o5mcfrLG3Q5TSs5hPJn/rdIG?=
 =?us-ascii?Q?Y3xSl/tYlmng0gR6gsDptEKmfZNcmbczg85tMddkoN6QXL8zvRHx4O78BVOC?=
 =?us-ascii?Q?nk033ez2PDutuHQxxFgergthIN/pmiRAV6+8Veble2TzDp1xV0DdPW3PVVZN?=
 =?us-ascii?Q?O+lxGiajug5tEIe6IbmUzfUqEVT6nJZOMioApPWKzRLtIPJZ8+iHCVsmeuTw?=
 =?us-ascii?Q?L/y/tqu8zYx22d+hafGAu0CO96Nw1YbXBQ2rZsmxZuUoeEdN3iVEi5JcLUvm?=
 =?us-ascii?Q?SXVOugpRY38W8ijTiG2DKt0db1+LoYP/gxaZgzyC+g4+QNL0EN8ZWk3SXTAA?=
 =?us-ascii?Q?ae0kcSEneDIqhKsaexb3cNMIydC4TWwZWx6aKkq7RYGBjztj8rOqt1Vd1cGo?=
 =?us-ascii?Q?EflAq1/jS8pTUsCeYtM8WQfHuxuXzQdC8DJtAlO4HZ2HfpNKdlO8obeyHQmu?=
 =?us-ascii?Q?WKw/LPsLGGtPS/RM/gd9b3oQ+V5Z1arIMTSxFDjPnZ3RFqIrm8s+FB3vEevd?=
 =?us-ascii?Q?0YniXyaTMQaY3bBKpYLFDICsnwwZ+0gmLHe4ubtQerk3nCRSH8UZqvKysd8u?=
 =?us-ascii?Q?w5jAaJ4kswtnnv8SMdwZEbvBsUom3DK+ytdTkGpQXfE9lYoLVbYEMcpQ1EQo?=
 =?us-ascii?Q?hdNQSUAo1Aci51W8L0ujSYF/tv6qbOYakurUimhUdyuwep2idSYfQPCRZfcb?=
 =?us-ascii?Q?7soLN86Wl6jJuF7BiteP8ApJ9QZA8VKtBfZrs9RXOpIo30I/kqBxCgCt0OP0?=
 =?us-ascii?Q?oOvSLfFe7IdX+tSA4AP2yieJ6ntlBIRxvecgqub0EFKBLKkERFuiVxjH0S9U?=
 =?us-ascii?Q?aFFTyI/3YEHrz+eBOTcxrkPbyqux9oI4kqAkBNT6wX4Z9Kk9iB3Mk9lyIbYv?=
 =?us-ascii?Q?Yu/OjozIEitCNFnjCTnS3XcevmmxpAhCEXXVoUJ9lHqQ2lfIrkVdacHWs51r?=
 =?us-ascii?Q?JYKRHn/8z8bxt81QIIyd7IFOceWp2U18qBiDqr6YJ4QgzYiV4tlZXkeOw4UN?=
 =?us-ascii?Q?lt3nnez1ob91+vqnAIIKRnYWlyeiESHknMjrxNGiCBv9lGpQ6TSfKteVvooT?=
 =?us-ascii?Q?LfXGsEtCJG0qfPndALh3o+EiKPcsvb0C6J7hSte/qkEKRbz9uA7DK6J8foW+?=
 =?us-ascii?Q?QobXXt4hvDNC2FWJ/VxXT0Se946inA8fJ2egwswyRp2E75XvrXgkMlbQld7g?=
 =?us-ascii?Q?zBiY8++zEk+fLbKhI73F0v3J2ejpX5PeOv092iqG3eRf2MgrFe0BLiu8SE8H?=
 =?us-ascii?Q?duE2YmQ2/7lSpukKFv/xwPn7FYXm805DXDqHlpgFN3YPceEYIiYVZIUjejJe?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YENkfTgrLYBJ7pOZPFmsbOBDCxjKftUqphWe6bbMEr56YUCuti6pOd1hq50etHafyqv200LcAB7HfgG/D5Qiuu54qupeuMaTcJ3a25gh0zhX0hX2jDQCpRk5JyxrJihtMjTsUPbF/+dkpF2s/7M6rWDoGxBUy3XEMBPJqcCYHqgjCT7OIjQQ6tgqOJABT5aJ+Yfr7arsg/xrOshtWmaJgboc3tnaInAYzeN/+VD10Mcm5bFcE5BWQvsBQMqztDhZ/sicrXMxBMP1Q38OrHnBzz/f/xFg5IzB57/09vlRxxj4zZrgI1DDgsSCospRpQIRIrZlKrzvS1VKr3n6Z44rwcnO+jXfWGkpfpHLVJTnJY3iNSrxaiusMmjyEH9u8EnJaWW/yBHgV0wVeKluZp/69VxpcbIrOYqsFvTJTKw5wLgRxKJjvQiYRLZMAb4kGVBfYkST5pMMvVE/gZbHu86hEhrWqmBO0wrN2lM8d0HsROLD2/aGGRNAgJffMV6BCKnjbIv2MO7wi/JdGVxXtZwQycQtOGtU7yT0aoTlZK0ncU2w1Z5ByszSYoeLjgfrsfATJuFDEwqJoW/dHjfrFx0WUnSFxIqe+mQGOZ6iXQ0DNBk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b4840e-02de-401b-81cb-08de22b9b748
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:36:57.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMku5ER4bsDpGQxuFw/nidPfIghGsee6RlWr8oi3Rzb5oeOswfn3PWm9k9TX2kPEWWrXTMkbBgKxme2vIN/BdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130103
X-Proofpoint-GUID: 6B1Sf6XpCMTxMNUPp2N-IHHgwwD0aWN9
X-Proofpoint-ORIG-GUID: 6B1Sf6XpCMTxMNUPp2N-IHHgwwD0aWN9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXz2TW4eRK3hDb
 yo6P3M6qxv+QNlfi2Ac4dmIRHJStzlLnwmmPbsaptBU1As553uGJK4PddHojgxG8vjgWskXnI2p
 CHr3mRWfA3i3rtHmXjSpnqJiQKSETP1S4XKn3BFgA2ooOa2dU82mTpmIL44WnCKvlbtBB+ZPXsV
 82+hB+hQZF6jVusT4LgtuxP6qxInxKokhs505FST8jUPNsLy4vlYLuuBUgTDtKwk08ebcIXUv4H
 713jC7Dql1BaX47EGwFfqMDsN6liuE/CMVDkZHjbNNeBk/BsOP4AlEq3vjVNrYUacMLU/z1F5L3
 1yRmjwfGAi7po/ZG43kr01vtGgb0ugGhYt3Lzg+kgM5a5rnQZDuabC1/SkBRDB9doZLkSTDmd2d
 aYvEuHTVggIEjiuWB8AvXR6Ju+Taew==
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=6915defe cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Dh4rwsumbFlucIE4n6kA:9

Using READ/WRITE_ONCE() means that the read or write is not torn by the
compiler.

READ/WRITE_ONCE() is always used when accessing sdebug_defer.defer_t.

However, we also guard the access in a spinlock when accessing that member,
and spinlock already guarantees no tearing, so stop using
READ/WRITE_ONCE().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 243a440feacce..e4994435ae514 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6716,7 +6716,7 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 {
 	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
 	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
-	enum sdeb_defer_type defer_t = READ_ONCE(sd_dp->defer_t);
+	enum sdeb_defer_type defer_t = sd_dp->defer_t;
 
 	lockdep_assert_held(&sdsc->lock);
 
@@ -7278,12 +7278,12 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
 			sd_dp->cmpl_ts = ktime_add(ns_to_ktime(ns_from_boot), kt);
-			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
+			sd_dp->defer_t = SDEB_DEFER_POLL;
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			/* schedule the invocation of scsi_done() for a later time */
 			spin_lock_irqsave(&sdsc->lock, flags);
-			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_HRT);
+			sd_dp->defer_t = SDEB_DEFER_HRT;
 			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 			/*
 			 * The completion handler will try to grab sqcp->lock,
@@ -7307,11 +7307,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
 			sd_dp->cmpl_ts = ns_to_ktime(ns_from_boot);
-			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
+			sd_dp->defer_t = SDEB_DEFER_POLL;
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			spin_lock_irqsave(&sdsc->lock, flags);
-			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_WQ);
+			sd_dp->defer_t = SDEB_DEFER_WQ;
 			schedule_work(&sd_dp->ew.work);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		}
@@ -9115,7 +9115,7 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 
 	spin_lock_irqsave(&sdsc->lock, flags);
 	sd_dp = &sdsc->sd_dp;
-	if (READ_ONCE(sd_dp->defer_t) != SDEB_DEFER_POLL) {
+	if (sd_dp->defer_t != SDEB_DEFER_POLL) {
 		spin_unlock_irqrestore(&sdsc->lock, flags);
 		return true;
 	}
-- 
2.43.5

