Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2EC78F5E;
	Tue, 29 Jul 2025 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753762133; cv=fail; b=AOXX1T+9nSHsMk5ruhQbSS+EFrXr8zgHfE2HFD5qhp17I6rhlGosesMk9fSnc20dHYsfIZfsRE0L4ugY/gsdpOA0imOlYYrAzg1ahYmlyecblDv1uUpTzVjTJqhXYnTd5JWCXgu+lQAtUnh4e4c/GYfS9h7yv7d7aytn6igdaAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753762133; c=relaxed/simple;
	bh=0rRu8ELkFEQGJlWAnWgyTP7usgDaDMIPzY1Y08P3rhM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LDBnr+Qd7J08FPj2ZCgvIT8Y9NDd/WwATjIH7PSioVK0kFXt2ANy1GP++jCrEMyvQbwL5CToyCs0r2pP20FGZQiVMCyAv6YNtBrva20cYiutgmj5gQZH5VUEaj59Tg5rLQ3xgGsWxxP4/gpnMQR0O9F/3knwZChVQlumMIJ6aJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gH5jQ7ah; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kMMa+4ao; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gH5jQ7ah";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kMMa+4ao"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLftbv021033;
	Tue, 29 Jul 2025 04:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a6vZAUEdkIT/krKH2Y
	YXLV3+1k3gNFC/vy+JnFd/inc=; b=gH5jQ7ah6NfV+tmzwGmK55SmxvAmhCSEp5
	WUNgaBFO0yPqwuq/T2EZPIDu4x+b6Ypd0N4V7/nqvQC02a8rMBw1xpEGS777TsWi
	0a4Se1g24dqpMgOzBSWQI8trz+eR5g593ZvQyEaCfYqj415I3L9rsJGKKvFtZYAO
	Lu5avxjVY6r6p5/PXagTLlKfBpRYXxZFquB7BFCGEnJM19phioSg9nON7TFX/d6D
	IlbjH2ck99iX1rMe0zYAWybSaHQZCMLlows7WZLAokPxeDI59i7Ts+wHUaaggx5p
	8UfVvilUs9i68fNVPekBK/ISRvi22HjvhXqYtdfCiMyB2k/WB14A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wpnx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:08:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T3evrx016818;
	Tue, 29 Jul 2025 04:08:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nffpecp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7JAFbMdGip+PvA2EcP4mTGmwXDIRmIrd0Kmm2WEve/2ytx9C5eagewFy7iUK8rqhTC4ryNpZwKFgx786otRMxI+CGw3kSaqYmFO8+lMNoVNFBp+KteW66f/dhslGn7syBufP8IuUEPbfVijqDMP0zPvFvHtS0YPYCoVKeSZODZf4ue1Gqd+1TrCbWy2VcwOw1bxSre8GVGx2TMzdv32HjPP0BtZ/6TOdOrNrXrIlc3J4W90L/jtfKosGa/5d10erkWO7Tr2GyUTWQw8wiVW1iQJwWDCJuLmbQZFBejxdXl5q+YgVaSeL5lcvWy/iNOcD7z19kuSWBKdqXy060cc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6vZAUEdkIT/krKH2YYXLV3+1k3gNFC/vy+JnFd/inc=;
 b=dBY2Q2ipQWzWRXZUfZfVcMVcz5IHZaa246MFdZLh/pdH7q6AgPY8GQ7HLan0luo848SpYUDk65lcapYRddOaSSSPDTydJcmamfn825LC7AVdCKqCcljKEYie+DoXY/7QE0T+SbCERzZLKtNpRed2/GVHYHTpFOHS37IwyAG+fgCr6CjWuPF5tcQ0O7pyUoYVd6HbY5YInF2JzxURvYa9uEUBjsSY0xDDVFBNpysbOad8sR7J3a3xbDYlp1fJ/ChmIDiV2gp+WL6+BkygwtHEzMmWZFfi2q2pFpR8h43cg9H7KoYAIE9gOQRF+6EmcZObVk5pkShnqOO9F8zY1CkNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6vZAUEdkIT/krKH2YYXLV3+1k3gNFC/vy+JnFd/inc=;
 b=kMMa+4aoe/je0G1zvHn3+M3L8KenQFd+TDrhPxexIxcGq1K+n5JZiIg/trfbV81UAVvJJonvZM5q9/F4cU/tT4wM4lnXmy7mJZXCxUJ5SjdUcnsHoUQoZ6QzLgYZ3CYqvUKFwPRixMTyl59QzQ9AmFTOztNLDdLe+bcDI2lWNLY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4395.namprd10.prod.outlook.com (2603:10b6:5:211::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Tue, 29 Jul
 2025 04:08:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 04:08:24 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
        =?utf-8?Q?Csord=C3=A1s?= Hunor
 <csordas.hunor@gmail.com>,
        Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: Improper io_opt setting for md raid5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org> (Damien Le
	Moal's message of "Mon, 28 Jul 2025 16:44:14 +0900")
Organization: Oracle Corporation
Message-ID: <yq15xfbmz2u.fsf@ca-mkp.ca.oracle.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
	<bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
	<2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
	<6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
	<655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
	<4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
	<a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
	<9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
	<fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
Date: Tue, 29 Jul 2025 00:08:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 44754822-cade-442a-507f-08ddce55905d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SknIY1/fZANyfg7gyj1oU6Vgbg0I+z1iFfwCl6a40NapO2TWbJeJWg0zICeD?=
 =?us-ascii?Q?75LN7hz8HAwNrAJuLLpRXzFxXCRx3/wHJ3WBLgbPJi28gmf7F47Tun35/IYv?=
 =?us-ascii?Q?UQblPei5G9V3+ur5+cBXbdiNh40mGdcoTJsMGraEYrq80IOuQcsUGIxzktKY?=
 =?us-ascii?Q?6AafgeT7ftj2LoRvB7Yp6XiFN/fwL0GzMkbUgMFETlaeGhS5FDtqI50HV2jc?=
 =?us-ascii?Q?h4AFNBV+3hFB4P5qzhe9ce3WQYNGMm+wbjvCzPUHNeZaaHcYLR7+t9YKcXdo?=
 =?us-ascii?Q?22/pLHSVUN3SHVRDJXc+WlreoiEmZD20wH3y+nSoNrJc4p8pfOMj4jzfiFJv?=
 =?us-ascii?Q?LZJ2aCg6DsT7N61Oz5OWlP0i1s0xbUZUdO6TcoJBb+ZRVWmjBXndssg3ICKJ?=
 =?us-ascii?Q?bpSgYjzRq8lMFf8TQNS61sPhG1dp6pA894QW28ZXTbYttOtzh8xejfBB2Ca/?=
 =?us-ascii?Q?MkxSCZzRL6nBuEB6p7c3KhIzuo2gHLXyWSov+Ph2EJ3/6ea58MjD6I5xK6hf?=
 =?us-ascii?Q?qMpmiPj9AJOTmK3q3F/vvQhABoORwUnvQRhT/kDZ2w8RE2BZP+Sd5OXV7VEM?=
 =?us-ascii?Q?rmp4lf23w5QTSTQ/N0Q4ckcNmQiBs8XMVx85cY+31OKJd681nyIwbZOdzBw/?=
 =?us-ascii?Q?XfucFm1VEddLD3V0Ou/Iy9q9rDf5weZYiHupGxJwvsLEAm90k68MVlxJFANZ?=
 =?us-ascii?Q?JJ/NkvxpPjB9BPfklQSZ/pS6PGh+RAN4FgGFvqLKldpMwitydAAFBZ+lwqwm?=
 =?us-ascii?Q?ofLOan8lb7eklSiMZYEBiw8GCrEK6N0YT24A69EeQemx94i8kHGWHqKLu2k+?=
 =?us-ascii?Q?h2iqsW09TKMGNKpGL5FylW9GceUvmS2IJSob8w5LD9h2mrlwGC2v5WZI5KNr?=
 =?us-ascii?Q?kIvq/ufekFhCbHw+e1uVbdCQG6aVn1g+wzW+eKHh+MBKhtmNBJQ2hPG3DK9S?=
 =?us-ascii?Q?a+2L+zcpJ6AJK1NBispqqI6WfXMt6hHCxDyAFpn0MmYWlS+nQLWaYYCLtRZZ?=
 =?us-ascii?Q?NXN2g7ErajaKhWKC3exkJI3nwVjZzo6imBxq+1R4tNFNga+EpIjIqW04qQo2?=
 =?us-ascii?Q?9xFJ4/LGx5sHEVcCaiaD/8b5fsoga1eZcN47WZEIz5pADBsMCmCWZMXF+UfR?=
 =?us-ascii?Q?/7WPBYvAIpgZgDr0uG0Vw3J+zxVPNFPTxAIiSPQA8AA1NNwwOkh2/njLYXf2?=
 =?us-ascii?Q?hqMnOdf57ol3GDoE2NUUM/gJzH1XfoGZwHc6NpdC5S0x5oeVZlF/qKQfdA0N?=
 =?us-ascii?Q?gp3AaZuecJoQWzppir5j/Y1Yj1S/lRLYx9LA5mAebthX2sKg7gzxHbob/5t4?=
 =?us-ascii?Q?sitC31xHCYxS2vD4toM6sPKYZdSGcMR7ITHbhD438cwhpICoZHjcZO3VFaR/?=
 =?us-ascii?Q?Xuj5qzprFDNbTxfdlOZAz44R96ecTwuBdlWCbgYQw8NPcv3Pgb1P53MgQ/5w?=
 =?us-ascii?Q?aS9CaMINJuA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vF1ANbTEU0TlPn3mH5MaVnTTgNWu9IxYV1J1ZZfQvwCq91vlx4/H4BbLm4CX?=
 =?us-ascii?Q?8GY9CkzS/aG6jHgmtLhxZBgOkkbNlIhe627T4/KniRQILMpYn2N+ILU5F07F?=
 =?us-ascii?Q?t3jPKqG3rxouvSEkCgJ4IEBrwIk0uiWpWbYAETejC+0NQ1RZwDgr+kx0mPLj?=
 =?us-ascii?Q?VC8dSOtxPcRduD7B7X3xnCen8Z8r8Z+EwB7vgsOkValUI2JhtQ8qCuNU7TMc?=
 =?us-ascii?Q?eepigZagEp+Oa/VCLYeDouggMQ0nj3J5LOA8Lfnts1KVhxzNeO3Aor6+Q3iQ?=
 =?us-ascii?Q?V4nuSTICpqSy0ZdnhAQp9VauMBpXyQ1IUJPCpffK9jHeHHAurbqBC0KjfNP1?=
 =?us-ascii?Q?ywdElgejkDfsj9COP7/eOCd/x2LhF1T/zj87KaU9gKA+1Ixs26R81U4DITmr?=
 =?us-ascii?Q?ymj312fit3htQ2apmYCvwIUeNehjHZES1VtvkywpU6BgaTMQebEPJcbxalOR?=
 =?us-ascii?Q?7Eyrsv9DUvi8FLz3QRe2g/IVciTHW6oeZ+RAHWiF2wQauYvLrPI0mZFCncDL?=
 =?us-ascii?Q?v924KysmQyJgDVShotFT86o9g5m4aSVwbmN+i1oeytQidF7vpT/YuXwnRXxh?=
 =?us-ascii?Q?n6Q1iecUIv1JT5pIzONnYF8qB9F5AkCNhbDXxF14fKS/heDLjLlcyAe/fGN5?=
 =?us-ascii?Q?eiqAzr8r+gt110F7R31iE25/tdgZcz2ThmL8XcQ/pF256bxW+CiAqr4fuSoo?=
 =?us-ascii?Q?joA4p1yvsBtobBxP1+Vrllr68lhorIQlyQuJnbQbw1BCKsalnmwUzOrGg6N3?=
 =?us-ascii?Q?HtcakYwEDesrQeszPusbzahpiEtACJy4OdEThkhVPOT5+VXlLFDnKM4h/jQf?=
 =?us-ascii?Q?qZ2PfzpmKT2o4auTVm35kkOH+3be7zLCpci9XdeuKznlZh3BHwczqg+gLMLj?=
 =?us-ascii?Q?7HusjnZTKagijZYFXWbd05Kq+tONXvIBXhCNHulU2+FiQxzSl93eP9bktGj+?=
 =?us-ascii?Q?BTAuuvTSCW0E65157w0ckkJ+cYoC7zRPXRGszmKSDZZYthq7lGCY+wkO7vZA?=
 =?us-ascii?Q?x/wkkauoxT6JDC/BqC2UKhObrVmCVeP04oQzKMGn6iZk5KzuCOlsHDLTQ3A+?=
 =?us-ascii?Q?weKHqz3FKSWsSeFM6G42sZ7po3WMN0qfuVmgUeaL5B1EbyZgqkXxSzQgkIW6?=
 =?us-ascii?Q?qYKGk8f1qaYA7kC2ncqEUT0rbcCJdImJXYAr0bmiQPzvJTY+mArcNw6LkdwH?=
 =?us-ascii?Q?1HOdYatffmmcJjbfRu0PYfsZPHsTrNQPqVp45r3VSpxJIdq/ECq8Im2fK9O0?=
 =?us-ascii?Q?L1EZgu9CCj6A4ZBWeD2tt/mhq+mpnXDJIsKhOTjnYtZyw7MqdfZtKUT6KcHv?=
 =?us-ascii?Q?C8WCbsjjS3clCCWdVPc4+PBNv7F0qR19nUphfuYfGxFHlUKiwOYHalAZrHgm?=
 =?us-ascii?Q?mopcBXK6+c74zu/p/WpWEtfIPoKbFn1oirC7XDS3D71JBiynik8fBH3rEKdO?=
 =?us-ascii?Q?Po+yr3WJy0NxUjzfSXyogfXl8m4wWyD9lMlIimWR6RrQNMUtgpWfEum4h3i6?=
 =?us-ascii?Q?TkKw+6+mDI+r67+OFqsIMh3culL4HVhaykdsiYz55r9is32FjkR8Jw4prwow?=
 =?us-ascii?Q?5PUtRAN7SAAFDiAWnKggqEywSa0P3fwwr5Uw5gkcyCOsMywTWDTs7XurRroF?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CvIWxNGXla0nfgBs7pQmVmTXW3dc0Vy7KCZuImmhqsJlrw7F6564zZbjw9iKRbK8tMwbUhoMZwPSNMt+Cf9oMSeVaKYbtAhLVwwGVfLDlHU2/9clUG5Ykxc4mdk1UidcmSvuzwGqvcOIDbcs2PPTyloL+opPlMt1JWkkKZsEISvaILN97s4Urn7xHS2ssQjHnmOSH0PU44VWFYN7KrvNihdLz2QZ5yVyK8uxJHdVPx6lx369bYkWMOMJHgGEzTQRMyheQqy1ckw3I84b+I5PxVdanG4pAloOxwaff/iPWYyPG2+A1HbTLvO95UTu8C3xCDo/1ju6UXXJ8y1uDXqDzzcEPXmsWVrtQ+QTN+JSCBWbJh+9AiBZDd+MQbvqs2DvqxVIXYf0HNBiaJTcY2zsMP9nuJmeX7O3gKJBcLIXkr9a4g9psyhX5pl3as6WGjsziJorGDPFL7x5JUg4nxudnpmwjzmYHhlPaTAFLGEeQPqm7obxxRNw7nMZWmKcTQfDnIFLjmKDQZHkHG7lBtjtSbuyLPLzymO5lz5BEbFF8EeLHrq8XsXC5HYwI+ClRB//6XpOg1NCLCmoHB9Y0GBsswByfS4NwHcQ8dCcXaeWanY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44754822-cade-442a-507f-08ddce55905d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 04:08:24.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: di+EtDKklPY5FKnZ4Hzgl7c6yKfYQAirhGkqR5aFgBa8iIgQ/jPBGXVmeN1O8NcmO80u56p0vQGpikueFabS7kcaew1hBtFfRLu/a6QQo48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=980 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290028
X-Proofpoint-ORIG-GUID: F1kuRFGfaNLyGX5eGve85trF2OM4O19k
X-Authority-Analysis: v=2.4 cv=LdA86ifi c=1 sm=1 tr=0 ts=68884940 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=b9we5gFtQRnb6FQepoYA:9 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAyNyBTYWx0ZWRfX8Je+y0nzphNS
 CYbFS0l+jfEyBmQ+4EOyn4JlILRk/abaRbfWc8A9v1rYl2EGGF7/qUFJZiy4/xSHUvTAtLlG8w/
 insYqyK/AqvAHo3GvLk3JuBA/mzd/CtFLkjy/jiXGr9PPcMl8tBrlvmgFs8tqjWHJ1C66keT/ui
 s8+sOiBhoJjFdMsjEC2wprbV2J0qVxgnOtK4VOivIEByqt6Lh8ffY4uaNG6ARroonel+MESOCIr
 G3YiD+aRYhP7RCoT/j5d8UFQ3iATCCOXL0ysaFaY3MxndQe3ih44EHOb+fHkTJuONb8u5eMKgKW
 JbasOv+caeo9mTCtcoFIA4KhKbHtQC+ntLxlWHNHqrbOwZb7s50MRX1x54fSYm7CpvMF3ifjACj
 yCf4Ot4r5QKsdG5y5Tkt6l9MxiL2aCG3haxpooJSzu7VulRYY7J8hYj3OC651jU/Yjplo6ET
X-Proofpoint-GUID: F1kuRFGfaNLyGX5eGve85trF2OM4O19k


Damien,

> My bad, yes, that is the definition in sysfs. So io_min is the stride
> size, where:

Depends on the RAID type. For RAID0 and 1 there is no inherent penalty
wrt. writing less than the stride size. But for RAID 5/6 there clearly
is.

> stride size x number of data disks == stripe_size.
>
> Note that chunk_sectors limit is the *stripe* size, not per drive stride.
> Beware of the wording here to avoid confusion (this is all already super
> confusing !).

The choice of "chunk" to describe the LBA boundary queue limit is
unfortunate since MD uses chunk_sectors as the term for what you call
stride.

> Well, at least, that is how I interpret the io_min definition of
> minimum_io_size in Documentation/ABI/stable/sysfs-block. But the wording "For
> RAID arrays it is often the stripe chunk size." is super confusing. Not
> entirely sure if stride or stripe was meant here...

The stripe chunk or stripe unit is what you call stride. Stripe width is
the full stripe across all drives.

> As for read_ahead_kb, it should be bounded by io_opt (upper bound) but
> should be initialized to a smaller value aligned to io_min (if io_opt
> is unreasonably large).

In retrospect I am not really a fan of using io_opt for read_ahead_kb
since, to my knowledge, there is no guarantee that the readahead I/O
will be naturally aligned.

That said, I don't really know of devices where this matters much for
reads. With writes, this would be much more of an issue.

-- 
Martin K. Petersen
