Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410DD347C6
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776819572; cv=fail; b=lzrU0U2LnMT/lAuELYoC007r0epDJsocw1QFNwf7hA20t9z3O9OZT/BzUKOzXGTJ4mBeU8C8/Nzfa0Sm19vKZEuXIELVb6lMqIs9VXlig9CzV8KOvNbc1Drs78rnJZWtRezadf0O44xw3vd+wNRUOckuSL7hrQhwOViyo8qTpKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776819572; c=relaxed/simple;
	bh=k1hRW/YOsc+W15LvPQh8yY9B9nUrWY+CKE4USbGGXxU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=F2Ka1ARLJ1sWsam6sq926xMgO+9Ed86xJkR3Pe2SrwwS+M/huLZI8TaxLkJTDNJ7PykwEDLeCbMZX0AO6m6W4VDUrtwFT8Dqg8iWNLDQbEs2RAAWkyFDNgaLrkgR+nAUCwomB91pbdHl8dsbVt8+gXYmP6+zAFgo6MoawwWe2E0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N2jgpjcJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hEMUOXBT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N2jgpjcJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hEMUOXBT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIaJY63475097;
	Wed, 22 Apr 2026 00:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wcWPmD+B5jS6hldOEm
	FPSFzgc/A1X5wh/7H9ZQxGkzw=; b=N2jgpjcJIXLs7YAZi4JPRgXVwCkjPL/m2r
	OBuZPAHjJk5H6cysqNCnV+o8KUF7ffRKlY9HemR747m+lXbu7pzAqTy8vKUcop0O
	jOEbyMHkZD3d5uE6zV1N6gozsl65gTGSyJayveXCar6PhhTuoXXR/bI9vuWbs4Dt
	t2s86A/KCUSRlHnlY030wxcLuONZmiuLCIcz8bniCR+FJph1E1bGARZ1SipLz6Xi
	KQJk8/A6v6l/bcDAHskMGxJkGapIKetSrPjJpSYa76iY8d6KzqJ5VU/UkSzBlNht
	hjDloB5C+Oa4kxlc2rbNsorQCzxf1MhpPP8pbPcurk6g8WusCMgw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenm0e1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:59:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M0uFas027822;
	Wed, 22 Apr 2026 00:59:15 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012035.outbound.protection.outlook.com [52.101.53.35])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjnjuj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:59:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqr+8DlMieW30KNgtEYXztlwBEk4dQjEmlZTnDQyV8moZ4FxGkLWOjih2ajSh96ZQSz0pV6x2k2pvyUe4GKqI0s41Q5Srp8QgICM53RSun9BS3art2jCIHvDDjecAdwHHlKiIanfBxmytLVuWA352XZ2s66uTIPTl+TfpeR+UnWveMJJ5/SkgteihcQnIVwB22AEO86TjR0GIH81CohOb60+Nqz1KtivGkLSxWT7aB1wDygM2yq+ewyhGnsrGSsahIa6Idpm7KW0LkRbUo0/6ZODTZZ/v6l0TNgsEH3wOHC4xYRO/UGzDmu7wpUxD+WHXvseWlm0R8eZEHcMtAVpOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcWPmD+B5jS6hldOEmFPSFzgc/A1X5wh/7H9ZQxGkzw=;
 b=Mf9czw031ZogN+w5CfFZJwwsX+a6xhoj+wAZvrsiwgMxNrR2Kp+/6BxQsvnz+htXUsnmiNIMu04DVzAIU5nLtGhr1Dt1+BdDaWW2hh/2qIaA7tELGxnWe3RaQH7eWOugabI1ELVzpvcvcAILFtCjtbbb+CqKZwk90xR4PiltHj597gWlKs0d8sN4rhi+zI3/rEE0gDZ6ZWO3EFq4duAPMM3ulGeHwuRCOcfQquldaWwgN6BMHTgP+rQ9q2rXuwBdwjW9rOzUnxvjaG963uAa9LOZHJAtuZwt8QdwzRAPpm10lYIdPUIHCQhnQy1keKbwwkrtwQNuPu9aSmtmDlLyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcWPmD+B5jS6hldOEmFPSFzgc/A1X5wh/7H9ZQxGkzw=;
 b=hEMUOXBTwNA4BbF2v8dMUxhlFEH7+jNKO2BAT1xI1b6Mevjqj+Auv7ZozQA3TjWTqU0xVYKSYWIs4EqnpfK1jaTV0RpHBWnVm2fXZOb2hG3WjJLbiiteZvzTDzWCZo5CKFt6CZKM3WbjBZNThmngrNT1ul9uYsmUIkh3UlkUM8A=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 CH0PR10MB5210.namprd10.prod.outlook.com (2603:10b6:610:ca::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.33; Wed, 22 Apr 2026 00:59:12 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 00:59:12 +0000
To: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E .
 J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>,
        Peter Wang
 <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>, <linux-scsi@vger.kernel.org>,
        <wanghui33@xiaomi.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix bRefClkFreq write failure in
 HS-LSS mode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260414033718.1459540-1-wangshuaiwei1@xiaomi.com> (Wang
	Shuaiwei's message of "Tue, 14 Apr 2026 11:37:18 +0800")
Organization: Oracle Corporation
Message-ID: <yq1tst3lsja.fsf@ca-mkp.ca.oracle.com>
References: <20260414033718.1459540-1-wangshuaiwei1@xiaomi.com>
Date: Tue, 21 Apr 2026 20:59:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0307.namprd03.prod.outlook.com
 (2603:10b6:610:118::8) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|CH0PR10MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: 199a64db-0872-4f3d-2a3d-08dea00a5e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YIC2U+jHiKDqO9MkalRyIISKJms9mcY2IapEOU6hrXNsAOO2gXZDjhIxhMR1+1pGoqpaOA8vEYTpoXpdHnvTcNgFXLW7udVxx51e4LOcYzc/Jzk6EBu9fSdXQfLzNe68OqJKgvx71S0VlTh9DKSQlwBHvQ4WIQ4tIusOEBFXOrpQX3hY741neU1naA1auqvEUHk4NaMC8aCc0Z158TPRCjSaQOfXdArogxTukNJBzCsrIX98eQJDB0VI6BjJMa391yytoniBrb2YPKLO7N6cW/C4b+QvUSdrJ6kgLXUT7MaTbHzzIbC6TjoT2j+fWYzIXo3CAK9beW2tL6RCasG3D3Pyo/2DnNFI1MfWb8gJR8dUP71aW5u0B0X4Uj3d8gL9cHh2B16/kGkkLCjf1XlrkcVCC4Az89/p7x+P4Y3a/2zfupILyJ++xnn9yWkg2zqqd7T6CunDeXgQhEgSmB9sAQ0F/rqbkHY3uF4d6BHFngM0UjNW5giNUuRc7+wnYvhfnhnxaspY9GcEXpEpN0Q963fIsye3If9j4rsJIBHos6tiHSAmiqdLMheElmuBP9nXLhvE8KLoIk2Kfg2jNXNJ1XnL9vnsM50fFyoKhopuDtajT2XOGhtPjKfgPfgU88wtpLEG/FqnHDdP6j6ZtKUF89nm1i5Q+xPbjXCofVX5fT4LE52PgJGNvQMU9JHY7qwzm99IV4Ya0r/5ENj8ygW0dGAcUTSNIS8cOA1rEPVeXlc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wrFwZuXy8UGtpHi/nLw/74akhMTzZl55MIzM4srJiZDaZih8Y7npWVjbvzbd?=
 =?us-ascii?Q?2bQX8vk1oQZHj10V/AzL+cm9Pn+mNjPoRp724leKtu6v9vIkCnco+f5sEPwK?=
 =?us-ascii?Q?P2VRvVm+X8nak+1OUUOj4x0KbPHai8L/XaoUpz71NUz9aEhWV3nrKZxh2H7T?=
 =?us-ascii?Q?I5JOy9FiCchGtx7dXGPSB2Leudn8iceT8iSrVqcI/TFz/cMjyF5hydMBbaPm?=
 =?us-ascii?Q?tbMxG5Rw5n6cA8oZrnve3c/UhLw5BsNvky6DR66Oy37Urlj5ed6YFIszrjgl?=
 =?us-ascii?Q?5srYFK8x14Mm0boT8ePdPncMGE69Cd4P/mbgPvjFc3znJD7LPq+xrXmyvl7A?=
 =?us-ascii?Q?xNg0ZglAAOhIPfchIB2aRJMj1/zegSszEC1+el6ipkcOZiRTkYBtLJiivkee?=
 =?us-ascii?Q?jVgQNGedpz0NCD5MBZC5+GIEOn7QEqNg/10k/EuLPCeK/ioU9xthRGjif8ZE?=
 =?us-ascii?Q?Kw8jfPA2avpV5fciPGifX/9fMVi4fblr1uaaLTxrw7HVtFiuL/mR/l0+b8ZE?=
 =?us-ascii?Q?ZjWxNzarZRjRTzeM3cmC/Df6mYEteSV0MdxpFzTLuAo3A2QA7SdqwI4vov3v?=
 =?us-ascii?Q?kjBsagwzruHgcSG+iXhQAVGAKMwFXRcUFeFD7Hydt+fRRrblC7uD8oMWxUDe?=
 =?us-ascii?Q?c9W7/KhSS4IqI96g8YkcjLcYHaonk1I3ky4jA8FEdsWQmFrNHTnaRW3F9KHz?=
 =?us-ascii?Q?bM/bTozjAh03A5q40XGPa8fKxsOywSOvluL8gLhH1qEOS/Cjm9fhxL71oPA/?=
 =?us-ascii?Q?ly1A1bfjhljjrXA6w2i1IgytVIFXu/WaSYPQAGgu7DJs9SYxOfeUg7Gyn/89?=
 =?us-ascii?Q?E90Ni9kPpKrp1osCOVr788s54X9YkBxPNvY1w2Hg5zTdRgpfHwjxfVASUbzl?=
 =?us-ascii?Q?UQwPo5Y605+ultcLXNYENHJoo0lUwEGsq5GB2DRERPlC0EDCge4E1UEZNlyl?=
 =?us-ascii?Q?VpvJnRFH+Sj8CwLoks2lIeDa6VtGC/WuXMWEVBn/Umkwm5FatfdcCrL8kLhz?=
 =?us-ascii?Q?k1Dxg1X7DCND8evkjQxkqFNAosGCMXS1P87iIsl0k9VrKMTsGK2DWy0g7Q2R?=
 =?us-ascii?Q?FWB8rNRcfDuPsWuOTlHMnU9Ilegg5bQ0yOCA0sQEyDL2ZJ4hLt2T1t/YjDx2?=
 =?us-ascii?Q?5zNeDtSzFQgdvYwHPCsl8/+tuqqsN5TLYEfPhCcEKxPRKJTZQpk/f5SjwP+o?=
 =?us-ascii?Q?zF5NIxE6HhOIcvDwM4BOGhK/7jd1QfrvhrpJHAYryWoVPOrFY8N8XrOLbjCF?=
 =?us-ascii?Q?RUosFy27KdVuOVJjC8L8qnGXHA7wJaAwacpS4AzPm8GTJ/0siscOelP4M0ON?=
 =?us-ascii?Q?gDPf+PArbGvYoPPB4C1YBHWp5CJxyDNhpT1c/vSwvTy+zvpvXZlhdshaLyS4?=
 =?us-ascii?Q?NKgwlnX0p7Djut980T4Z6A3q5f0SdJqjFh1Ornl9cXWkK6XKwo5e6jZjE7eS?=
 =?us-ascii?Q?VXe0RvyrYD5x7gXR+g6Q7LIgeQA9QbNeypkwrO6djzS2rWj/nWZDXvU6OFmg?=
 =?us-ascii?Q?KbrTVmmZ8PtEXBkqaVQK++MGcvIE/ElJbnzF0oGOyrbj15qaJQnNwgn2nLuz?=
 =?us-ascii?Q?P9VHz1dgsBZrpFyLVcTk01ypMZFEQwktbmLxONgwG3H7/WGXXHWKajOdvGV1?=
 =?us-ascii?Q?wmiPSMZF3UYgx8UXFMW3UQA79HpsqLKkpzBvKnPGKjGMkyLj/P46BEqlWFr1?=
 =?us-ascii?Q?OoTnN1VNl3vykAbPt7Kg723S4apee3UvcsgcT3UlhNATeiVIxXF64EnXJXfR?=
 =?us-ascii?Q?8ByKUMpdqs3x9tWU8BPvNjma3Pl8UkQ=3D?=
X-Exchange-RoutingPolicyChecked:
	cKFppR2ao4YU6Z5Dk6PvHtWPto4VugLDFFc1uihhD9wKr/K3Mldo01N0o79a2ndbLPXbA/CS0Ld8Htj5KODRKMj8tYejHUYnhGT1JafLdox+0EbyAJ/JzD89uA6XJSGrH8Nli9CtOLTsgFJMpKGWqaErbppMYRyysvlLWX9Y14UPXLg7KDJDrQIFhHmWYIg1g0fcdnSf3SgeZ1vKraLpp5FmX3FxaXD7liskWq1DzeoQTMJiIqdes9+2KKGrw5Q7P6msjltuVShsXqg9PcPYIrCqQbrzybRZ5NrqgVajSUb7GnNYWrcWdtley+scuYved1aI42u4FsUPODGvYWMPgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7SRT5QBMlDMnap9iqj9wZ/oMEdLmfhtz4eaSlTF63H0GE6WsSdQ55A5ziA4Mp8b1DRpbGSEVL7LLXadZaSJcXXqQof1W57vLCwM8PHnV4aCpBBUpkefF9Z1Q0ohLZ3JgogZT5xuj2lmK9dIf4kMefqlTHjd2NpfvaxixO+DFQY1QgBVXIYwdd6ZLP0EKpRX7qJkpr8oFGxN/EnF4wVY87YjfQEvBSkIhDsPg0NVOIgXmWg5CgQBLR2389OHeP3sV+GksbOvJc/1+K2SfIf+1ODuJG4raJO5y08vxL2v9fa6hciht3d6shZV++39y4g9NqfPU/x5FFaj6PyuYb9DrrLv5FAHyMmZrTJlH8+sEuNHVYbksrsmxlQMUf6tjtI56JICFzpuM+mLzRA6nl1U6kOiJrIT1VofJ2DeYXVuvxUl+nQxJp3pjbRP/08hpQ0FCN7eyqyjATgM4e32D/ORdH7RScq8123CW5tr4zPcx0bUlQAx0VJTKcSfnJ9+wTZYF0Himq7oc3CECUfHRJwmTvcO9H6Rj3KPwDoLMpYpKJjNXbZTgxnjV3zPeLwlcKp/xFX1OtthkI0Xc+U8oR3elKR5LjwbUTumwYurFY4WdZ3M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199a64db-0872-4f3d-2a3d-08dea00a5e04
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 00:59:12.2489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrKZAHg2bNz7CX/ZT6WvdCQseRxFmVY7hA6KxqeN/HZ8+ucyd7tYIbkJNh7aXikpFCPIgbUTkrD7EW5i74O7jTqZKUePcpZL3y9LUferyII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=799 malwarescore=0 phishscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604200000
 definitions=main-2604220007
X-Authority-Analysis: v=2.4 cv=Xbu5Co55 c=1 sm=1 tr=0 ts=69e81d64 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=nlWIzMlcSzFcEpfx2W0A:9 cc=ntf awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAwNiBTYWx0ZWRfX+GZ/BtzYE2KP
 fj5WdyaniQx7z4UZioG7eH5AZBJLrMiffuLBML3EluY/X8+uANYKhcNjBXWW2F5eiPOE5hiMQji
 1bUTaQ7dF8Yem4Tb9OED+0muZ3c2T6DnleTUO+I16/KkXYy1Et3/415Xi0BuLX0U83rekVR9edq
 x0zpgCwqKllgZfkm/+UUCNJNV9ciPEKBnFiAkxPInIDvWGdrhyD31jfSj3N0CCDHB4hxABElKKE
 9mAGrcqOKMFynYgR1uFDzTEedGzEkRzcNNEQny0KCwAMfaeQt28kKzd1zvbhnW2Ksa9EygPpX25
 S0ZiVpdl7+y+8crmnekEf196Gc9OEzuGVNKDeSzYLnki7sIaG5sT4rnnHMYxuDB9RtDUdahG8YX
 LZbT2FWpkIdx4tuJVU9v8Nnmquod6ceHboeAea9msbnmW2RqBGUuZwa8X2DA0Aw1NzmGebQuWf0
 CtSWbp9J2iiV1EM2mOlK77VkIJYWH+vqBiOhkGXw=
X-Proofpoint-GUID: 0P358bIvJDUZSG6H93vZDumPVFgSCcog
X-Proofpoint-ORIG-GUID: 0P358bIvJDUZSG6H93vZDumPVFgSCcog


Wang,

> According to the UFS spec, the bRefClkFreq attribute can only be
> written when both sub-links are in LS-MODE. However, in HS LSS mode
> with resetmode = HS_MODE, if the UFS device's default bRefClkFreq
> value differs from the host controller's dev_ref_clk_freq setting, the
> write operation will fail.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
