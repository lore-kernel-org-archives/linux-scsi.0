Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA31B963
	for <linux-scsi@vger.kernel.org>; Fri,  4 Oct 2024 01:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728005779; cv=fail; b=cfA6t5R7QzO8kHoo/lE8Rm8lCmx4VuSpCj7RWVDOWGZyXB6Ew5oBThdrbllqvB5XgZt24ZaEdg7EivS7HaM0ve3a7xVtvsFt7F2GRUJrb46pJgPLBv8mQwNuS8MmXMxSQzPvg4lyEgDci3HEJkJU4kF2FMbrPfgVx5itMzM8fuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728005779; c=relaxed/simple;
	bh=ksQn7Xb6EVPqZ2d+l9qLfPNzMtHa7d4+K0MzgBj8d/0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cMxFY9/ioDL976BBazCaZTfZw77DF6wFL0YHfNnbMULAdEP70k84FOXm4eutefayqnhOxPdB3s5fEkHYC7eWXwzbrR723SbTw6CSoMWZjxgQmfnTHBsfpzGMl3vM8394BUCuEzaqSDLyuQ7L/xazjte4emWVSK40gSE6nC67ipA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mpVL2a0W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XsOCEPKt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mpVL2a0W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XsOCEPKt"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tdi6018014;
	Fri, 4 Oct 2024 01:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=XeVDw43/e3n+3W
	8Bxt17Uf6zcFQ8OU4RL0gqjYGg1Gc=; b=mpVL2a0WjYJgM+7rRKeWZS4aqa33YS
	gwApJnodE69ji8ZdL/7UReQkW+LRmNSOQsTQLTE75ZAO5mQnt3F5xaoFSrNHx/a8
	AS2BYH6rgTowgsyaUp2W9CgjT8lpmzxvvrRZ/oZ5nFIONmDfcw36Tk1Rvo9wII+j
	0mG+2h8sgVx0pucx6m00ETkMyjIRrPcCAydTiPdItcFJKmZAIvqtlYiDrst3OqbS
	sZsi+4gXC/9yhW5uGPQPQHUS+/jL7P9m3dvRElc2J7UWdxotAArMlRlhVs3SPiUY
	cS1MmRYOCH6OJ2IYM++M8zAWCXNA1kYvGHmkwxwW2W3UrC3QDi5Msnag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204ern81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:36:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940DUit038458;
	Fri, 4 Oct 2024 01:36:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054nq9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:36:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/+qW6CnoRJV1+zD97qYsuF7TEVxkcslHeKAXHTKS571375XA7h7JFMba715+1rAvcbQW8yQahHOUohzJ/zi0ALk/bv9hsyl0h+UmpHXm/VAcm8N4ISr7xipBiZwtfCF5uwAgI3gO4Ts2M44tmQMev1TDnS4b/i5Nr5ilElsI6WL7onLaKN1wWbNQxMEe7Lyw59DrHuH6miPqHsSPS9jePu2khyym0wfagXWzcjmiLB4u0DZCpC5sEETAv8vGMNX2Il++crJk++PGCiwNpSyhmbMwJjd/T/Na7Gtfv6zslZasGSNhNStI/AeLXqu/IEsesSvwZ1x/j747YrH2u0J/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XeVDw43/e3n+3W8Bxt17Uf6zcFQ8OU4RL0gqjYGg1Gc=;
 b=Im/EhzwF4rwj33dRD3WoGc+FIZddfUnCLMi2TB6uq05TMEh6klWz0VziORbQIuYAeGyYPDsD29NsxSBjQmVIU6mm3MpMzIIHm6Ozad4U99t7MgenDLXftbSU47ygKRvIwjpkHltdhGK0gnT0k56o40oQtT+KJlzyYIas1RaABq3+Nf/Pzspc4xSwe6FyKxpQYI2Pb57IHDslPrgYYDuHzBmDKMkRHVEkt3eSsDfmcO92xvAejGqvI+/8tvNWCHKb5mEq+10vB4pU4vRWux3xNO/CPmVMg9sI0j7kjLt789kwmAo8tjov6jEonLAApkwd4EJ9EIjyFCu/AR507QWuqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeVDw43/e3n+3W8Bxt17Uf6zcFQ8OU4RL0gqjYGg1Gc=;
 b=XsOCEPKtxbQKQX6CdmXI3FXZpIkpq8OdKd40s5+S7GmfBZ2Jascpb5rsMtXET3ZThd7dxynlvGINj7zTi+fWbUzqCozgsOi2e+6gUOe4sfAcuGsP2GBC2qC3zKWopVX1kBIh5AwgSOnwTeyRJCY9XchT3weVC7gVx+FN22TueuA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5855.namprd10.prod.outlook.com (2603:10b6:510:13f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Fri, 4 Oct
 2024 01:36:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:36:09 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Clean up the UFS driver UIC code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240912223019.3510966-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 12 Sep 2024 15:30:01 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7y83b0j.fsf@ca-mkp.ca.oracle.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
Date: Thu, 03 Oct 2024 21:36:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0324.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f385b9-f70a-4419-4d75-08dce414ec13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2TaJ1vWc7TmPScuOcNhjjjWKhOppVSplIErY8txlbE/mmlwX53MjL1478y+1?=
 =?us-ascii?Q?aTK9HeEvortY6PioNXYksXxT2UWXv8qTzZvKcocyTiQmcU4/TgZ4/n64Am0G?=
 =?us-ascii?Q?jaRYWMaFnIDIC/GyRK/fwbZAiUQkp4qp/RXbAZCZQFSG4nA4YPlg+K1uANm7?=
 =?us-ascii?Q?oub5naFPw56JkDAzR2Rv76w6ni3ebKhFDDHIDZcUbvZiBZ/L51sOwas+s9zh?=
 =?us-ascii?Q?6ZK8XZA0cKHOVITYXNYSwcuV9MGSocvENEUrvfaAgW5C6O9YJlrAiCTKqzjw?=
 =?us-ascii?Q?YkUmEb+K1BJ7vwBtERjLJyb2PT0X27TWaW/0pQTAuWabJssv39NbMQm/FCoP?=
 =?us-ascii?Q?jUzJjFulQq3YvIzzcGi99WPiKecMhVSjrUJ8R9Pi8u+WIukxUeLNcQewr7Tv?=
 =?us-ascii?Q?065Ronrk/y0JvQ9LBZi1JvTkFL6dPJAKN3rluhsoI4G0207JKOFigGqRlRkE?=
 =?us-ascii?Q?KI+uJ4mypU4CuHZTZhFFQBPuCg7GAiD2TG9BG8Aw6wT8N7BQEazhR4ZFTKGr?=
 =?us-ascii?Q?Q21IQV53Xai3LrbJ0r4X4Vir+Uxk7q+Fm+Cvz3hCXgm5bI5ibXx87/Nj/HBf?=
 =?us-ascii?Q?RZLvekdr12Px5I4tIoMVIzD6o10dcmucmdw8VYuC94W/Cwh9RtmfOECXeFKp?=
 =?us-ascii?Q?eo5XEIoBqNh1hGWqHv4xo6aqds7auThw77qMTANxGhYboSAcu35Jr7IfKscb?=
 =?us-ascii?Q?2nBF9fpgJVk00NhHKjd8tsrIZ4Dmm3sogL0BPlmbqH1yNQ1X3P0erYjFF7Qn?=
 =?us-ascii?Q?RPUxgZG3WZnX1IvEmPQxsniyQX2H8yQoTS/xWUKvgLldC9sygAah8zhl8wuo?=
 =?us-ascii?Q?Y6W+BgRgI1hzPkZTGtoG+a2X+puzmjtxH2iR4Y1LfYDpi7oAbIaJZFyKAYyA?=
 =?us-ascii?Q?E3YaJrp+GZOuJVIZE5jvySxDKh7Bs8CAu2+PPzb9jeDR5jDIaw1kiWDmhTeh?=
 =?us-ascii?Q?ZM+5/sR9dw9amoLjKMJHZUoF3JhvidcRGz5UOhvzzVhPbzcQA5p+QeliLEBb?=
 =?us-ascii?Q?dc3qSPmFkoE/K3CLQ5b2RcMNl47lHcU9lPJVXU+/sCSv2O3WSk1V9F5IGimn?=
 =?us-ascii?Q?YHfA1yIy5qIYohCyvLGQ0xHtkPo4Z0Dv4TvOGIHsWuVi0Tns/OpoFIJu3pC9?=
 =?us-ascii?Q?Q+CkMMhJp5YVpWcX3IGIU9x401pxfWwBl+Vinf8DTDlv15gTnEX84DzblnB6?=
 =?us-ascii?Q?+61xBKh9hwORj0zwvFKWK/0YJeTbrAvC0p5zm1UWP6i0krNQdDUaMtXVcb5R?=
 =?us-ascii?Q?a0KpLNNDqziAtL4Z+zAW1N2rIi+VjjjJ6O4HA8pWFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UdsvfMwE+NLwLqndpeAyrVSZTySrZtzqdmA+XnMDzVoMH2+1602/mHxT1EQl?=
 =?us-ascii?Q?ATnvtJJS6gt0b1bY7CXgwoyn/JkW04ucIJiWJao2Tu6+FogAt28Kzn5SheCk?=
 =?us-ascii?Q?2b46ILeUlLT5ZBG9KvfbP1iUQ9ze7aIC6K2YGL/itO910wnSLAsh4HiCNIKS?=
 =?us-ascii?Q?BJTfVolBLLsoaLYBpvwGK8qzWmb8EX4J5JBGfub92MTMMMVUvjK4uHi0kvwQ?=
 =?us-ascii?Q?3Fw1s1WqE/7Ew63FNd+pzP3dlt7IDDE8rB0lvXqEFLSoJtg27KYVdhQp6Zvz?=
 =?us-ascii?Q?39mu1Hj9C4Vt5Wj9fZLhkpgsMEO0eyo7aYOOCTT+4kmaQBR3FQYkkwBdqKOC?=
 =?us-ascii?Q?g3z2olAzQSistx76KmCB1a4kIq1i28dsvR5FDKyE++Jm3eDq0C7X/l/q5q75?=
 =?us-ascii?Q?RzgvNyNUuUkrWdl5nBGAeg5Hjbadml+5cYDdPXz+20LIqMB/X8GkP+y7q6nO?=
 =?us-ascii?Q?oc/EPeKatNHEW8LyvBgSsryg3uVy0BnWmqZH23bYvcMLtsySntfZehNG2CUj?=
 =?us-ascii?Q?7vu5NXo0hpOwLYohYyLvwmdNn/Ermt3KVt8KPnxg+hC6LbOhWmQ1dTnqiKsw?=
 =?us-ascii?Q?fyT+QmMeq0lKhsnfA/9IBT3dVFloi/nmNEagxvqP5BCf7x1+0bWP2CwoqNCl?=
 =?us-ascii?Q?QOnN9tt1mtZijDtNQjna1jtjg9mopjxR79Q4btbMvVJRmhpR9ePDKMIcvPbk?=
 =?us-ascii?Q?jNB4Igs2mwynncdcMvKpgyr6C8wUWxOoFrPYQfJ35+ohoa7EfQFCY/2AqpIW?=
 =?us-ascii?Q?WhfIkTQSbQn1/cBHO+svj0Yro1n2vlLsA7GsOUtgBN9kYM3/Tuy1uFxxp6z5?=
 =?us-ascii?Q?8HhHRR3rA4oBt1QuSWwC/iJ20seYE/8QEICzGIYg2AZDE3pSyZ2aD/kNlZxE?=
 =?us-ascii?Q?KZlufXsGXC53wF2oGOKL9SGj75NYIr/S6sp8WbIvKnZXpCab4XLUOzGsF5D6?=
 =?us-ascii?Q?aoQrBi2Gc7yNnvb/buaW20QaPGhhbvKpNiGja31eKYxO6DwL/awhLZrJf7Ti?=
 =?us-ascii?Q?d53S1pvv78pGjNN9KrKQoakxqpbdVeLLr7H5819K3de/K4FbBREGSQbiWDsh?=
 =?us-ascii?Q?VdtcHmHt5GXddZ3jWYhxtUps01flqg7nRBjv7+Bj+fGEGN06goAt2tNmQtAP?=
 =?us-ascii?Q?waPVYrYkQxshYh+7jOHjY860l9fL75Vz597m9QGCJmIWQyWGiK5OdMXahlKm?=
 =?us-ascii?Q?f9eCygfA86VjLypKE7hJp9pLsuxozxGH6jICS3tmIY16Jaoz5mX61gpG+Wem?=
 =?us-ascii?Q?NEvodADXWae2B1GEJdHubcRQT/YgmX6sEtihkif6qlWp75WTq4TScs+OqjY2?=
 =?us-ascii?Q?O/44QiDa5JWsUJky6cKY0Ic5uIi4r7Huz5q8YEx8Pcod5208gnEIIjxgwiD1?=
 =?us-ascii?Q?dByRyd1SG05jy49f6BoDDUUL0FalBC6ANU9evbY/BM0VQDGNMhP0T6SqN9en?=
 =?us-ascii?Q?/XzQtcmCd+8ON+DuzJ7zEXAZenw7f42SKlx4lQZzNtvqKoEAEpVF+n205oLj?=
 =?us-ascii?Q?2evvyspldWIqNtWoLiXa5C8OZM5PE/LG9zKTz39Pk0SbejrKvWi+54U7LGG4?=
 =?us-ascii?Q?5E6g35Kum7BSsTbWwb4lzU6kvt+QtOLT0n1GbB6zUWtMT+mQVCJRd8NEYAmu?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8elqX9iap4DmY5avRcJKxkSgj36yqdiEm2k9rxG/J9qEynrc4uEIAZGaJGXEuTwce0/+tExdTLdyWGLzRt6/maCAhb1vhgEGSur6eyfkLYwJ1xzbZCQr+fxqD4fYfMe8fYHWoMqF3o/ZFsKt2cGkeISleteyebIlnomGQSYeZzQmi666Uwu8jrc4LvDnUsTX22nZACa3ZWlLqS3VNrcEQgZVSnU9SwbATWlRWqYDnbx6pGHxAyGembpLHwNttNFwSnIbMBULOgNjFpPyEHMMtmOCfaLZIBxIYZ/tbuegH58eZTKQf2c/19Fdl7621CG2NpLnRP1dtY9JTyllKQbU57GDmm3u2YIXUju+8DpIXwv157qeJ+AjJYtC9PjIPkDcRDvfeLRCC4fg7DOkK2eqV5UMn6pfHpZ3wB4FhRck+wJPGS1P5aoZKMTFCEJ0KpjXAl7BdjMgGc+JcXjTRRNY9xCCcg4WsurwYQFgqQY4TMWWTZZoGF842jATKikQVEmGunVV2i3S+rN3GGWyCcAtaSQLkvucEXLyrnI+3k+xIPIESXTR5D6lZPrrhR+uVrxWUzNIPrYQ99OIQQgthq1g+bO7MinPtfPlR8QUw9TWVgA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f385b9-f70a-4419-4d75-08dce414ec13
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:36:09.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWD0WFXaiTt73kBeLDdIBTLmi2zPUdAA3oFmVR5aJ2FW7nmuhQt2jXu5YolWT10lYy1zZafbp7i3/mP3ekJRJgZgyIFjz2wCELrbu/shwRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_21,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=720 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040009
X-Proofpoint-GUID: HC-42V9SDRrGHZGJSYLAY1imYb5VtMFf
X-Proofpoint-ORIG-GUID: HC-42V9SDRrGHZGJSYLAY1imYb5VtMFf


Bart,

> This patch series includes four patches that modify the UFS driver UIC
> code without modifying the behavior of that code.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
