Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644064689
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840153; cv=fail; b=YzWRWQB4fZPKdUXAhdeFte3aWHZh9Mq+GORMWRx5DpXRkDmNS8EDQyxmsvwCT1DCaDSMtF9ovFKLOoq7mDKj/0gDeao9MPMLIN9yEL1frgtH/udMmjgStGi9Q632WEelDcShHNqwh0KgqjNGBIsHLjpXNy5N33n3UozdllYMeUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840153; c=relaxed/simple;
	bh=hTQEbL+XdxEGuZmNX9Zlosry4GiIRBuigRqQVwESeu8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=C48JAJ/5NRI+xZELAW8c4eixBBJQI0gjrNmmyNRYTsuDwGa1tkv/PmdVJfqam33V46FngxpL2ZhyB4OJfnjT35JCauHdwjftsgrxVewfDpn3hkOa9Oa7AYxd8qDzguww2Ww1M5sbue+B7+cjwEXq08t7aFH/aXA7awPBiM1bfrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DYv46IXM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wuD7IFLp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DYv46IXM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wuD7IFLp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXort023845;
	Thu, 2 Jan 2025 17:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=wkAF3XOBYOOEoGxvLK
	qCgS+JSFKzR8eHp29XxLQMNWY=; b=DYv46IXM6EU5pw195mP43CeZ+0S++u3xqT
	G2uNi89rnUgJpRb7rdOtHEl8EpkM1NZIIn58z571qn4DiLBawfxO09BrBX7NnxM2
	cykgwj0cABrILwo+YO51qkIEknvKvC71oNJpfPVmui74rZ233CQbWJM2IgMqVgjL
	DyTE/pgMgD47QDoym15XBAcBg56kMZOLitghkGfRe7l/o9+hEcmOi13h0lEkgA28
	NzW51D1BJvZRfGgFp8d/2rLPaKn3tAQqVm5f0eQLS8Bzc/tJwWue1j5G8Ccr14N8
	OJ+zmEEZT2mXidBm0qPhLTCFdKkWRAmCkxsqkZj1gy/+Rl+RvgqQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9che5ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:49:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502GXoYT034084;
	Thu, 2 Jan 2025 17:49:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8kjmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:49:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZu9d9RC4utjkdACpdj9h+Om0TByD5oXHEvbNGHbGGQkXn1bUjvccU0WINuT39o/Ru1m1ghuHRaClgadk53y5SPwF24viBeeS4okXPvQfrSY1eiYgH/WioNxugqb8Hcmm81/00hAHs0977Aj7a6Ycten5Rkj1qIFGbYZ5RhoD3Ne5A6oLeLcRuffDftUaNTiaKkURvoCiwxCb+93LumLq4pa+/udLytR/sqGl2pKMRXVvWzSzIiWI0ne5DXteAETJFUiRnO0b3j7TDGUPFsvg72hGlu3zaR+FyxVOvcjmWNYZ+04nHv1bpB52NGlGnmbUvw/pmbFdn5ULsjg3Uo/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkAF3XOBYOOEoGxvLKqCgS+JSFKzR8eHp29XxLQMNWY=;
 b=t7RR5459EqGy8t4KW+c+U/odDj1bC9y7H1sAmmxTNI90t0a8kqw5fkZPWGsEGTDROtwUuYAE+DmAbVHnrjIbMnncxPlX0XRpoXFY8bepSSO/Ld+sVvzlV3s8okznkYUpEw82B5AeN9fEeojtHU0vH9iL7/wQ3b6yqNwqqMpa/eVhZNMOBAkHAQFbLJRl4CIq9nFWZPr/tBHmzCV+g9dzOHOFWPCN75pNk8cDfhYXNxjqSFbDCTQZCFDl7vu/eOG5zAy0InY2cdRPXbD7nB/lWG8+jhD4ryNEfsG9E8vZ4aWoqO8tEaWAalfYkV6ABEfbRZsVH7l80DXVwmRqd2DKFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkAF3XOBYOOEoGxvLKqCgS+JSFKzR8eHp29XxLQMNWY=;
 b=wuD7IFLpLptnU8KVHJfcY4s1VltGPFlZxeDTea9txcpM4qnyQ9GAKKdK8tDiwT5iwxORQfahjWPkHRWRHTShXYeHyGVZj3ewDCn/P5+J7S891toH0tZhq2t32qbONhDm/fcWEyjDswMgE0Gg+n5pADHvsRj7w5Qw7NkefHACkDc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA6PR10MB8133.namprd10.prod.outlook.com (2603:10b6:806:436::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 17:49:01 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 17:49:01 +0000
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as isci driver maintainer
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241210113028.13810-1-artur.paszkiewicz@intel.com> (Artur
	Paszkiewicz's message of "Tue, 10 Dec 2024 12:30:28 +0100")
Organization: Oracle Corporation
Message-ID: <yq17c7dhzvx.fsf@ca-mkp.ca.oracle.com>
References: <20241210113028.13810-1-artur.paszkiewicz@intel.com>
Date: Thu, 02 Jan 2025 12:48:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA6PR10MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: ceb068ca-d71c-4082-2c23-08dd2b55bd8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXt310yumKc/hTvvZayTb8W2aQa8L/II9M1V0wgdh3M/etlwv1HSp6ZbIKNj?=
 =?us-ascii?Q?tMYvvseZrm4yEjm1ISOg1LrAFISJ1yGz1rbXGDkQvKs1OwRYVl4G1L1guNGd?=
 =?us-ascii?Q?X8/+eVnsi2UPxX/OM4R6pj0n5AwmigywBIya5PGw5nSBi+kKDS0BoH71GwZS?=
 =?us-ascii?Q?n3N1Hjh0EGTSoHt7+v2EdFFuPvq+DZH8fjhWrFzj0Z2HGldjP+wFCVwooKw2?=
 =?us-ascii?Q?m9zZk1EvJ547E+KWPl56pXt3x24yXexkQ5PFsWgP+auca1+w0nkfIfur9cpM?=
 =?us-ascii?Q?rrxw2TzJNuyM9OPGxgo8NytmWQbHdjgQlTTMdFiAbqsKcP6YiSCpgqRCHO9e?=
 =?us-ascii?Q?4MH0yHzVt6Vb5RgmqqZsW3isf96Ql7ANgRAI61/Nd+AJ3I8NcTtjUkTpWg60?=
 =?us-ascii?Q?u4AEtONp8AndEWcuLKIaeEiNbfuHZMb5R1fc/1ijSzzoVQjtQLdX4tq+4jkt?=
 =?us-ascii?Q?PNpIHSUfKVPpUIHMACiabQN/mm1+/EKNmmwBBHl2/lriFBZESp18M2LuI7Fw?=
 =?us-ascii?Q?pyw8rtBCE6zWXrOsSSiDZhUzIvR+a5arknBTHSMDdVGjGPZOWQGkhwlBKjoK?=
 =?us-ascii?Q?nfiM7hNG6ROGmCRbUVXeLOokNFyY3jP+9436KE7LTchx9MYtguocuZP3yHqP?=
 =?us-ascii?Q?Fnbntka47TUq4DLH3jWdnWvyIa6jY88HsSCnyfx2rknoJng/hkpMao8aWPlW?=
 =?us-ascii?Q?9wWdC2r3t/0xvMMK1LWYIINZ/YT4Up/A3+gNLRlsYcUbHrt+yj9Af2nCK2yI?=
 =?us-ascii?Q?Fhc2XCsvY+JzEhcKXD/AkgiL0zMBe6N7ZnTKCg9oGPxFqWDHIcxJNK9es48f?=
 =?us-ascii?Q?c/cRUVfAX9Fgwou3/z2B2rorHURjhUIEOQ5yqFLX2ZYM3xtxnYn1nkOfsDfN?=
 =?us-ascii?Q?nan3dNH3rrVH1vwchSLTJfLWTo7C7mpQmUlEgaQj53JBDCjvWrwJsAZ8yPQo?=
 =?us-ascii?Q?ZMuIWwBDEz4kV0H5IfP65hHOGFXyyVPklifHH5iAfB4hkHp4Pa5VvWcVDVp9?=
 =?us-ascii?Q?x88p/z8r+qGuCmxaOGUHNbnqypUCOG1k4Ga//XKJls0ORCKaLjWyK7NOsiM8?=
 =?us-ascii?Q?OtkvBluX6Zx257bR6vtzDetVwhOkEb0wDCOHvc8yHMZeZp6hO+3Ps8VQVz/J?=
 =?us-ascii?Q?YmKlYiJy1pzWU8a4maw6oTlpwd4GOMnZQ2CBN+JLW2sLjDGePGxwwIrLap59?=
 =?us-ascii?Q?QB7iTOjI0/DHmZdFyL+NKQONVf8uioCRzZZQkjkCl5H/0Of/8RKbxUfmsLis?=
 =?us-ascii?Q?f+94jLDx/Q9d45yz1hQGXM0qudCM2O8Rl52MPlfNvhgQgAoPRD8iHgTrNGxB?=
 =?us-ascii?Q?VZCs+jE1PgYFz7SrkcDoUvrgA8hpN779JGZHTZMjPJY7sDRlVHUkLg0EEjbS?=
 =?us-ascii?Q?xd+hr8mQ7eChc8+Ndv6mELdZXHEs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?utbBPWC7x6gWoXsNP8DQsC/iTpZfXBUVkcVsC4XF8GwCBA5YTLFJLEtZyr4n?=
 =?us-ascii?Q?ogNRBeANoEquxLC8BLdFUizBhMtg/8hk7l7cirkCsNftyAwmB15y8VZso2J2?=
 =?us-ascii?Q?p7s39tzE48+n4hQ22n+Y+RFtPhkdjMHXCFKvZbgWT6ejgEqpOUxCBxiAtoUi?=
 =?us-ascii?Q?JVwkupWkwSJoMiTjkSVD2QoIr17GqPyvVqeshSiytW3Yz5SmbJhMDVsMbuGk?=
 =?us-ascii?Q?BuDuhq5XO3wca7xb7cMBcDSETespkRZxWDl45CAvkBiVc7dKZwNtejExK9ZN?=
 =?us-ascii?Q?Z33T2b/ksHw3kPdwzj6lmos+YzRDZSpx9mRzGdABLYyagESuENkLFf3zgJzd?=
 =?us-ascii?Q?8vTIgFN5WCtBwBuCHG5XoY1xXY4LEovy3Ac7VJAJtRa/GYlHWRqtPI2vH3HB?=
 =?us-ascii?Q?X2/iztLa4qcX6GGBhv/ylmCt2+JCVZXU2kVOzCmKpQ+sskZ2sVWRM7lEb3gX?=
 =?us-ascii?Q?jaLVlWVHRoBnHy/wpCG+RaSG+LtCg/vx+JksDNgxrOZbxHG4EB6rhbU9lRsW?=
 =?us-ascii?Q?GiWMsiI2hjDmpA5Dh4flVUZ1tcxKLArz6zGjL7jtTu37aWzXaD2raBb9u38F?=
 =?us-ascii?Q?JqLZBFmY0LBADXnexFRRXwswipEpEuVxOjfWf2oq9ZM0M0texEuC8U6VsXFD?=
 =?us-ascii?Q?fDZHB2vdntLsqgclSdBRHJsJGLG0gRRi8vx/0+4BABoWjorWxEHxrlpaFMW/?=
 =?us-ascii?Q?AJRTSG7vJq/kVk6XWAfMtQVIiYEHZvmfbpIR+TvmncacSRFHiXwEYtTDoNcC?=
 =?us-ascii?Q?Hn4Ke4Pcj4MIHPtM8irbqr1JpYkm9sal3OK43mmuP7OgUB0/ElS+SfIKhqET?=
 =?us-ascii?Q?FM44sEYaMgD7uW/MwWZcS7WPcwpXWDb2pGd3QBgLARPDd35h+CXnvPctMPeF?=
 =?us-ascii?Q?MFHWwdCyfb7GZO7J7EEl0b24F2K7vmsPFUACuCu0k3YFfPIQPEwQwEc+baSx?=
 =?us-ascii?Q?UMXg+kjjcCybYVO9bAbhOF/RfSm+pbHiTU074g0oX5gJkMTAcPIFIOkyCuWH?=
 =?us-ascii?Q?ij9OZZSbZvlFOgado3ce/gUEEKPtT0zk93fnC9ZKQ6ArjucYk8Jws8qPsfx2?=
 =?us-ascii?Q?MuJfa81hDSKkviGzrhcp5hYjlnhpZ3QHK0GFGViFhx34ZzAxkr9+c55uqBhp?=
 =?us-ascii?Q?RdFNv8qGXY5FkGMcMqGok5DA3VB0xb6bWoqaPU3yxhjGV4PKPydDcbird5VT?=
 =?us-ascii?Q?Ryd6XNmiSyGkuTkq2cPHOlE0kDnovQCufoN8nLYp2MO+xU7CpPgZmfwjxZab?=
 =?us-ascii?Q?A9AN9pV7EBhpsMS8W5YCdor+AUDUVhaj4e0qLUToRYSpYtKJCgxcdat1RP9l?=
 =?us-ascii?Q?UWJdnndXB6+OzyoKob4XzB6H4n1QPTCr4Vs0X5+9xx23MEfB5Rcdrqalfsh/?=
 =?us-ascii?Q?j7DjNyHmQVw2YGErH5KdFpTIVXr91cskGV0G0x/t68Gx0u4gzw/fS7tsSiGH?=
 =?us-ascii?Q?JbmGTzBfK1fk/G/w27wv9Cif/obNvdONZ+4haVQi9kYRAFHUtb+cB12Ahsc4?=
 =?us-ascii?Q?9dW2O+nP4uMr/Y5HwO/Rfzn5XtLjkmMFnG6/SM8Lntw/MQT1V7OJd9S7LXfH?=
 =?us-ascii?Q?JjSjsdW91Alkqi/UChksh+k4Yktm0YYVjImmllgh8R+MbFYj/QYky3pbH4eq?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D+U4ou/qsKyPf59gyOq9YFR6l8ZtS0SdhMngXBfqbyaWT3E2gbolOj6YENKKm5yWsnX5k/609nSVwwnGLFbLBcsADjxhuF9D1ZSaiwKQyPqAR5TRqG1ND7RZPJNLZIy9vwzcEAmrSVu5FTnVjJyUpVomW2JcbsoDPzzCAh/KJO3+BLlgOWj3dwrRZ8ZECVORVvnmOtkk3h0DBUgxYkrvjxlt5uuxiAj6BEwBr3dDqbse2PBLdXBkEarq/e2XMHCeL3Gxs/9cDdxS93KaAIk/uEHB6IxLEOumZ6zypLEQlBStG5gGyzW/r2B+eAj1N2glxLbC5AYussGz0WcGsMlj7C7S3r6vGUQ4wLDkij1ejLtxw512fapBvK3RalMHq0aO7XIbMpvMZn1DuLEtiOKSAD6QuIvq19mpKDPv4ddXOcv90uyWaR86xLvo7dVLYiM0iqO1IU1V962op8CeoKHu0Cj3+auB1qDVnub+0zV/5y1HRE5Wp1GStOwzvB4e/9a/QjtzBiHIbih29Zhcza13J5AjFZi/Ek0OBFOdy7kvOv3OMN7y0Mhz0yd04CCIU9twpTfjodLagcjD2Ahm5OSnVd2iub1G4jaFHPwte/cGOR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb068ca-d71c-4082-2c23-08dd2b55bd8b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 17:49:01.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NR5estvVLo4VFqUBrhQHhirFM4TR0p8ro2hAW4qEk5gfqHKHhj1RVq6QZ0OHNDEtAabT4VfdJPNdEnKusv+aZb9915EDX/WK/RM0oKeBk8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=690 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020156
X-Proofpoint-GUID: yuEjylIAnVh6uWxUe4pS6JBiEO2rHulh
X-Proofpoint-ORIG-GUID: yuEjylIAnVh6uWxUe4pS6JBiEO2rHulh


Artur,

> I'm leaving Intel and I could not find a new maintainer for this so
> mark it as orphan.

Applied to 6.14/scsi-staging. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
