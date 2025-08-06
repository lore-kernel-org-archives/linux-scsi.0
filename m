Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210223CE
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754446955; cv=fail; b=TA96SO/INdTDKzDoOrLSxpRaVpVZ2B7FMm3G+NALqc85+kxiTm9hGTBpbNk17fqQfkQ0W8t3rXFeKk/WS0Sh0Skr3VeYnNxK2N+7/0bsswEiu57tGBSX6kXORErrub+oPvxDYvQbv9lzydWwhK8grBsb0rycEA5Qyl/H4UzZFcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754446955; c=relaxed/simple;
	bh=+s1eqUb6MiE9UpoFdNKJcjvXS6yZJvF+zYU6w9zDr8k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=g7dLzgEVqcWzv1LuZS/uzHNFZJsjtQAinBY7hMnsjgBFbq5UTXatmBxQRa7+XSTKW1LSwpN61Nv6oDNO+YkDXKvrf+uZ/TRcmv/47P6AArsbL6oFJIpxxbQgRgXCzNBLzDND0ql3elsXWH4YU0NA4uXBGkV+5tcJ8W2JoM0olrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vzz/npqo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y4fEYATs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vzz/npqo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y4fEYATs"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761u1Cu018462;
	Wed, 6 Aug 2025 02:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QT4z86ZduM51Vbagr6
	g5lIG8605GWRstdNZU+Oj8PZ0=; b=Vzz/npqoNuGGh9oLruJz/bxLvklWbLOJVC
	ElG8M67y+Ral4GNvoJLpHf9lPuhH876yzHj/1JiXyVx3bDV8EOIapjQipG0wojXn
	X04HI2XKARrd6IlKKLaxrZNVAC1MP4h+kSOggzP9IUkVqTDjT4y3SxKttKC6r4kR
	ndZYts7aeQUEnRDdV+faZlnLQdjl+JUGsQhfAfcuc6+9OifSoKKJ3zZF3mFRMjbw
	BKm89QjI0lIDoN+G5or8Os77mI52Ba+1+BncwlmbOzHXiXQJ4bh3jNtBa74iye4a
	Ee7a9HIjT2cQA8jgPRk0tGYBKCsXR6zmVUBmsjubluR33RP7888A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve0m1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:22:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57620eFK009764;
	Wed, 6 Aug 2025 02:22:30 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwkd9ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OC4UXWaX8ODYz4m6rmG/gRggaZ3Q+wjrk7sconhGyAoCAukGWPyUj45DS/geqO+iSlSLlESW3dPCR/fAX9fb0elyKQKg/tw/nDdiMqPcP6d9g9NdDCSmCLpadbYDajcTDfcBaVyFEkhH1JajYaK0Q38SUJXabofpSeDUriPBRxGRvgrsQ9BczFbJmp4m3RpFtsVhDdno3Fy6wDiX44XAZPHyN211hoctnprKWh1/oPqT7X2b94nBNBGx1j6gHC1nTYmgfL55odGyc9NiqH+aJm/9+BCscVDScj/IG2fiO0UV2AhSDc6wC2TZLrRiYKaAEJ3jPxiSFb6nEhNegeGiAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QT4z86ZduM51Vbagr6g5lIG8605GWRstdNZU+Oj8PZ0=;
 b=fIsOJpM7wb3BNeRa2oWvDEhgZqWYV5Z7H3BEz2txZD0+3TasH+MRCTiiF0yZtq//zkKqOBkRdDRD/XZ7naWtH/japVZQZfu0U24fcwzbLBg3wKeiRXWstUgmtfH2L9cNUFqgV4j1Iaw54nz5HitacOj4TjCwfnQ5KJNeTz1hU8CJnXKHsO6zrdKfmy4gouWuvgYsxJIyEF7EyfPWQxsmC5q+C5aEHGmeVrA2Y7uzbnQ9cbSJM4a/c3B30pfVMB2zUGlnWwglfp73/52InQVp9bulQc7h2EDLB0ZLBWj+Q3fqS3CPFgCNDC/+hgO9T3kePnlHWDf79hQLKglgKDk+vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QT4z86ZduM51Vbagr6g5lIG8605GWRstdNZU+Oj8PZ0=;
 b=y4fEYATs+61dV/zU5yeAetCXv9sjHlVUVRue6ajGj4EhAbN6iu45reQzcrmuyuZQOrrz4861Op2Mu4VA4Aes1ubprAGr68QIdThJ07DEASu9K8iLglY3mJknJfnsLhMm7lQDaGFr22gnoHWSH5Y8fimq77mAMUtGE/lskusJYeE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7671.namprd10.prod.outlook.com (2603:10b6:a03:547::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 02:22:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 02:22:26 +0000
To: Ewan Milne <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] Retry READ CAPACITY(10)/(16) with good status but
 no data
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAGtn9r=7+y=QyAS=uVwMp3uVJ_y0Pheepi30eMsH66TRbpVVoA@mail.gmail.com>
	(Ewan Milne's message of "Fri, 1 Aug 2025 16:51:46 -0400")
Organization: Oracle Corporation
Message-ID: <yq14iulb392.fsf@ca-mkp.ca.oracle.com>
References: <20250716184833.67055-1-emilne@redhat.com>
	<CAGtn9r=7+y=QyAS=uVwMp3uVJ_y0Pheepi30eMsH66TRbpVVoA@mail.gmail.com>
Date: Tue, 05 Aug 2025 22:22:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:510:33d::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f825004-9e4a-4fb0-e1fa-08ddd49015e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WGRkMUZEwSvxabJFOsg1mBQ7tplySYR1W3AmoAtrspouS1BbLONSF8r/yxIu?=
 =?us-ascii?Q?Cp4SXWwpVUNg3L5yO7+IhntmDljutMdGusAbs0f5IEJH3PsuD9QOsY9cSd5/?=
 =?us-ascii?Q?HN45JOqeUMVS8Foi7hTrd36eGAGiQAWGD1UzkrPCYGofnrrN/q5YFDR+K0c/?=
 =?us-ascii?Q?q77EWZolV3zvL6CzBg07dT0+UV0+YqZM3S2cNnEt4TxQhCuR/NYVpb0lb3BS?=
 =?us-ascii?Q?OD998rWsKVNWmRz1ntJ2k+lZkQ2e3C5NdG1JEBapvNnTZLXsXSCrd01BptJ1?=
 =?us-ascii?Q?bWOD5dkdI4qqUZKasgjkOe60ap/tRxHM8YHPblEzof2vDuplHwmjR3eL6YUH?=
 =?us-ascii?Q?MqJ20iSB3oxcqZuLayh2jqVks/ZzUf69Hg5EvEZqljvAccXQAQFo6Eakv2HO?=
 =?us-ascii?Q?RZW6Ukp6rWfe7dT/Xouw7OZet0LBflGsZbXQS+gi7mvapFMhENvNw8kVgk4x?=
 =?us-ascii?Q?jorM7yJyW2a4Qv27K61aBCTDT2xILD3GPKEpsM7aEDd77zOiwP3whSUPWWfl?=
 =?us-ascii?Q?GUqeTzM9VZufXE1o6DlDpX0ajtDxqkZTtFJ4KVnBvXuSeWJTYLcQttvYl1UM?=
 =?us-ascii?Q?9VjTmRnXXkVunY48uWSXbSvzsS9KFYZGBFtHRQ1j9EBvdxjQDwdmBUv1wTFR?=
 =?us-ascii?Q?bCP4TCdLWOXxVC6T4yAA37vT7UP0dvPTiOI7oYc+ZbG4ggOl04k+nLxVefRF?=
 =?us-ascii?Q?bBVjqYGbqFLHsW+jxpeeHo80XbvAxFDmkLDMp4PIntIM2x5CpXKmJXeQKhdZ?=
 =?us-ascii?Q?hrJtCiJQ2bQN6U9I9i9H/Nb+xvGn5ODI3YnbVzTM/t650BjxskbfvBaLbjQy?=
 =?us-ascii?Q?LW29s73NLVeKnQLU0BMGVf9jNjL4ZVoj2dBvTo9UA9AEXSc7cDXrrgRCnC9o?=
 =?us-ascii?Q?wfQ8EMrCmrJxmZj31+iz6dj91FJ7wD76hMuQiPYoUj+PTiGIJRSfJcwsKXqm?=
 =?us-ascii?Q?6wZzSCLYk3ErijPZt+5A8gOXBRXXrLzmHNHBjIfrhEM06O/7izZX3baddNN5?=
 =?us-ascii?Q?WzQhE2HOIoNkaL2kUY8InvsN4WQ6uPDypS+M1ZT66hlEYwidfKBdu3ubvqWm?=
 =?us-ascii?Q?kBR5e8XdkCXr/SWZ2SRlHtjGnjSzGiqAMMXvf/tQlrIG/6g3jN226tQ8TS2r?=
 =?us-ascii?Q?mvVNX9qxN3vFmmC/+IjHdaD2KqWAoxUFEaRcuKaXfJ89SP7BIw/o8+D+RAnL?=
 =?us-ascii?Q?u3OZtE+5WC2RTN5VMXkid1MYKapKc4tgAQoi5mki780e6pd4sI7Zpb45V/km?=
 =?us-ascii?Q?RtvM+izK69afHAaulpfMg+kI2aL50fxHbaxeB7X+PeA4DkGsUGbVGLML5by4?=
 =?us-ascii?Q?gry5W+3Kgx3YuEFaij3V/PzIXUZboITmrEnOALDUzLvmSz0F7CshIu5Zw9D4?=
 =?us-ascii?Q?vzR1Ai44iHMOMZrDefcwhzx8wJ2XkEofZekX2L54GW8Hrhj8GybjSzHs4Sui?=
 =?us-ascii?Q?HIRjz/KpBck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+/uDehs4NpWlif1Js5iyvo/tVndzLmYjUFyl+sXVVXVLKKHKj6n8vtlvGOg+?=
 =?us-ascii?Q?wZrVH4Xt6RYgqhkGWCniDDrX8sVWJK5o/shuZ/d24Jpzgq1bugunL4F5sMUc?=
 =?us-ascii?Q?sEW6pXPh97ciFCHDKg6uzzywTUM6c743HqHJ8flc7agLSy6PRefBlYClsK3w?=
 =?us-ascii?Q?N61iCn9tolwDTd+ZJggZPn/Q1H0+Fmpb5oO85+QeDTINN0LObsRTnKSyoLyb?=
 =?us-ascii?Q?9JhYC4Wc3LNSDgpK4cWi4vQt5nDNHb+maHAtpO2BnMyWtlZSahCoa7Ob2Dsw?=
 =?us-ascii?Q?IvdC28e/QssHOQxhQdPeULxB0YXQIWtJo0UwvqvKlpmxdhHJgSC4omruHGH4?=
 =?us-ascii?Q?QNf8ms9Uxa2mp1OgCOFR5AiiMOAcYPGWCGAoVrBBD3uE7DmxLwylKcNwGbru?=
 =?us-ascii?Q?8veUW3hEumq96+NIaoefzESB8C7PVSYdLX5h3EFByPujuENweJsZmk03iLRc?=
 =?us-ascii?Q?AC+67CCVBn1gq/0loml+pm9S9Lc7sa+fvY2/+OoWgyHcAisZQnHS3/Ce8G6I?=
 =?us-ascii?Q?ZuZjsieSsqlg6/fFuBUJ/61D5a/Mqok6xcdr98b/VjeNCjAx0C6AFd8h70+K?=
 =?us-ascii?Q?Q/N/4OMW0shoIiLf+cEw1LMF+NorySA583k53Iq80fGECAHtlgco4sJ6Oq1L?=
 =?us-ascii?Q?rxFK/jLJS1xgwNXaWXnrgJaP1+tfj25MPD3GXExMm56cIGO1YifpIHode/vh?=
 =?us-ascii?Q?cVt+qRRXZonnKjuS5YiyEKWQdnqCO5BuP1wah5lgFUJb2IdDcLjWGJXNa1aY?=
 =?us-ascii?Q?7w2UTT+KaB/Q+5wuuVug7Ah2zkxo4qI0ART+N3S2cNaGHzqC7584r5coeMcE?=
 =?us-ascii?Q?oZz5XkWI7rTzZcxzSG13Zz4gbzsQz57jwBC3C/ehK6K7+WeaOWmyl70+ofWt?=
 =?us-ascii?Q?jIsBo1an48q1bv54NM3+HNUyls7Gnjwjyurj6tlU4k6bgkRsK+RW0jljjoca?=
 =?us-ascii?Q?qYEnKCmY8rccvkIoBElas2tJJT8Kq5YtUhyOxspB9dElhtAgLf+MCfIlET5V?=
 =?us-ascii?Q?TOG04Jy275dcTM1jMGMC7UEUtJPA1xCmS2Y/CuPDwNxSP+tT2t9vGC0Og2Oj?=
 =?us-ascii?Q?+SojebsoP67uVSaKTvPhEkYbsnIQnyyUYtqMU0qc4G/eQbXt9Hz1IAclDF7y?=
 =?us-ascii?Q?793pwnVY/uhTE4/e6LapRVOklw95l87GNhUlsYSiQnJDyaX+LTcyqIT8QFA7?=
 =?us-ascii?Q?ex1oOMxkxkYryRcUPdrQqD/I8T7CQzoFKmoYY9sdxPD3zdiLJ873jy4mJApA?=
 =?us-ascii?Q?hw+0izFp+sUC6AdSw99pxXcprZD4CmaZMfSRGfUKWFkr+YMAABNwraoBcnB7?=
 =?us-ascii?Q?h++6basWTpNXaIdHV17eXez6I8boXobVjV4bCpDZ9rB5+akVU/Tej39AcKf0?=
 =?us-ascii?Q?RxsndeGlxvXaqnKszEGJYp0xD62b4PKNnHJs8iQKIcpdj0fyhWfqQw4cAs4p?=
 =?us-ascii?Q?v3Yq2SkeM0HRrjjdxOiJ9pETvpts+zoLq6uSuC2tzfPFqRsGKZaZBrNO9KSi?=
 =?us-ascii?Q?AH+IKgCdT+8A4XaGvOo9wMyYDU5g+Bt8Uk0JF84oOafOiUoDCCpRmIjUkSPQ?=
 =?us-ascii?Q?VUZuRxoxRUG+MWtfm8c98OsA3bRxH+P++rB8NKcjrkk4uAf0xIWJJiBxAEt8?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0NnSY5CEI/Fa0Mr+rWxeMRPEigPnm18fXZ6drSgMehvzyMjc7nmr6sxg6iQ8QNOt1cRaEM04fAWz7K0hlFQj1AsapYfH+x30nw+M6E4KqDPFgBPw1I4FJ5WaOlOb/gDF6dY8639eCwDI6gO1CoclZeF0Sfmn6Sgqjuf1V050U4idhVPfUrUGpuO5VGTfO95SXZDxAtEzPVEilHDi61qiIWfta9FLU3+klDHMa9D1wFqjG0CDw3+jsd0DQFKlz0gD31qIm+jeW7KETjD5CxqMTvLqk52Q4I3R1ClwftWoYPz0hB7bz5JPmvflJgzciCkpsPFfk75ETl1vjZp6YtJoBRrj7PPs3TToPwS/TgWE7eTdUdG4A9x6CRaMLDAt6fG4PSJJle0E/ArkVMmt79BowKmYk1eKqRly5u5CAA3BtMzzIPqXByFFxUgqtLWNB7HSypJi2R/ZaIbdldPCp0NoRomIHc59AT/yF5IqPzEHNcghRUk6IVyoE8Q6sIoSsz+ruGbdFm/8OHKoAukzC/cVskTXmfn9OlJbyl+MY3Toxy1zN47uvB+qkmAYXZGUUWOBufcJco/sWRDaFoIgvmKVBpC6PuKV590SmqXszMFZc+c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f825004-9e4a-4fb0-e1fa-08ddd49015e6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:22:26.6327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWj9Jq4OPCReo/JvUqJ2YX36MDbfRjVhSyU2htfW0oCxR4SdfOfbVzH+p3QHC8IGa727mN+xk/fYcitvsF8QhRxCrv3FDNNSxs2aO6DeT+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=932 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNSBTYWx0ZWRfX+CR40EEBjbKQ
 ygCw3ZbuVSzzBQxlhGNxVr2tICtkw9LdtSkDuncyPdQnLSRbjpzriKtyMUGs1R4n9TxUQMRmJ+5
 rBTMTXVdJsW1moJ7M1ZaZhsOGiC939kLegwj+LxHDlZQJKoQarYF5WWWnvHspHff7iLEhcSyPP/
 rS3n0C8bqFTHg66oudZBXOKzIbcwkB/yI5dudUfvk1RrjIEILxj7UsO+fq44vNdzOthLpNwkuVy
 hB9BZaJNXT3hzp9w0qhBcv+nb4Cx6Wz0WB1sk71Bk/f2CglrBUnwyybvHY8MqdPQcPhD1Nn26Vh
 5oAQNxKEwY2SxBomPROKblLWoTQd1yWtczHggSZD/Mp6CyjeomUZ+7fhLWilHa4nxNQi8DS65B5
 f2LBlEgFBYIuRBuqo/SdNrSqpt8S66XHDWnFJX/3w4PVRX58thCe5XVSW/pYlWcEFXTx90AY
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6892bc67 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yJgPcOQNZgUr3Wl37ukA:9
X-Proofpoint-ORIG-GUID: uVByT6scrBMzkUekt2QD1zjdQQoyVlKl
X-Proofpoint-GUID: uVByT6scrBMzkUekt2QD1zjdQQoyVlKl


Ewan,

> Gentle ping for reviews.

I will take another look once the merge window has closed. But no
objections to the general approach.

Since this constitutes a core change, I would like another reviewer or
two...

-- 
Martin K. Petersen
