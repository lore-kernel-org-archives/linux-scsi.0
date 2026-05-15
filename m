Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A03F4114
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 02:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810597; cv=fail; b=QOdV1FTmXnt1NIyPVVdxEadhOqkQm/ETLEu9AEguBUcuKMiSPcJ1myHYd1cJJ3iQWbl88YFmbDynR31IObUvY8SHHHVPEXfL67Y9E9uIkg2X4QSfeggIhfM+dK48PLfWmczE6x83gQRoqrrXPx0T4JhQbVM0qUUTCpVBRr4Inxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810597; c=relaxed/simple;
	bh=Fb9twLVenHhIsCM1chrrYpFQI9wBQQ5Dgr//p3weZFo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dj1OPvnHAnrBOxlNSx30y38474FX3053vPExdUJYerarIn+IVagdNDQ1ZWyVOftWkbi+8V2ZcTXcO96/LbWaZRJO9Ro0IXcsYE30q8hntgpoRprOOGs0x8UM4LuasTwKmVZDMKuzs4Z1D+5hCW2lBsGN8M3qvGp/jfLbLZuETDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mwuafzug; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B3QCuuwE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mwuafzug";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B3QCuuwE"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0VCx91779787;
	Fri, 15 May 2026 02:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nHF6SbudsdLvwNSpy2
	DYSO7GSxb+GYHueXQAPqWzfBA=; b=Mwuafzug7WvMyIYsblTcnhAQSztoYiez43
	ZReLfKBBvGShhFzlRTcmogljT2JTw2ZPwancbwRNFZf6QLjFsMdmE9Lr3Nf+FiMF
	lZqdcC3Hykg5mieJhNmAYitMEzvOYE/DZkc356riDxVsQI/BaVZYyPff0JqwdMYV
	LokQYzJfSUP/Z2k92taZOy0Jl1E3WWpEdsl7Lm4YLuCidPSnFrFhvB93IB3/B49f
	5tVFRcDKLshPSBlfxNQyNtEFRoh2FmhKiL5DA9xoRy+6rgxtvYUkQGyw/vj/YXMu
	0ea9PxUWQFR53t8+OrUhsrg3+9bJnDQJIKxDv+x2gfcYjLdIbY/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rrdma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:03:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1ngkC006772;
	Fri, 15 May 2026 02:03:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw0cj4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:03:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zT3ofWDpMVrYBt0M4Q8dnOJT2zg7nPmNBgjNXTg7pJEJGhf423nfRso2CkiBhfj4ZsV5b8UmK0HvZnO2KuqRB/4m4VDYNu3qd+laz7zQjlW7vgj3szEEDS+z5PtiWf/hbQmu1z4BmR0YrQbaPT3BlQIfhzi1lV1d1vVa7c1GnoBNq16bbjzCNf91DLyF2040CIP4jeV3P9U80DIXb15uhoO3nOfUN5W2YHH7SmDUwaCFkJMZnmBZMAUKVnDq4eIF/tYrzP0SbYaVLQkaqJ73sumypHjgXuHq/c1SdUOm0lzLAXtaUwjqXWWAnZOwvdhVYni1TNYa6eUxxOzUm45SPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHF6SbudsdLvwNSpy2DYSO7GSxb+GYHueXQAPqWzfBA=;
 b=Pqf3jJLdsUYTUw05GktKcw8mAV0iwQl2QbTQfxjP37k1q0DIGOT/88FBli/w5CMtCzJWireQzd109ZINnWhYF0yxZxY+mwAHj/wW8fmYZxEmgOUtQnoYlJiUSqTFy6t+Xla1f7o/N/nFHi2wTlu12xMG1MOvkN7pZad3zp5a1NDwG716d5gByBdqIxljdWWo6R76vyK37moRwGn7T7SZ/gtw1RwnLQ5MCpy8pv3pA1DyuOHI5iFSjggUcDrSYdc53TmQ3RH/rOq5xVTbrWgoIcj78d+jvhB0+KXbosP3gUPWJjc55VH8jTYTFNI7cI12IMHou8++NCrGGu6JVeyyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHF6SbudsdLvwNSpy2DYSO7GSxb+GYHueXQAPqWzfBA=;
 b=B3QCuuwEGfd2pEZDJIn4KvRCFsys3v4IJtM9dznigORxoILtXYQAwqe1FMwELKGEWvmGFxOvN1QNmmDClRGtexLiwFte60JiXQQj19brKb2qAsX06vLA8YeYvQEKFzX3db6L+Bfrv/L+DldVsMslEPt17vFcm4192d/PB2XKr1o=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:03:10 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:03:09 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <james.bottomley@hansenpartnership.com>, <error27@gmail.com>
Subject: Re: [PATCH 1/1] scsi: Fix return code handling in sd_spinup_disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260511175317.114007-1-michael.christie@oracle.com> (Mike
	Christie's message of "Mon, 11 May 2026 12:53:17 -0500")
Organization: Oracle Corporation
Message-ID: <yq1pl2x5t0t.fsf@ca-mkp.ca.oracle.com>
References: <20260511175317.114007-1-michael.christie@oracle.com>
Date: Thu, 14 May 2026 22:03:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 046d8ea5-7f16-49c1-d958-08deb2261cd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	OV6yP445KSO7hCRiZLG7aNQMsY46gx85zLa06ulVRaxLobSbIJ/fRNgPQUBIVb0lDRhwiALhezz+FY/V44t2q2M4IZjSl/bZe7iPzvTo3u/pgVZp8wiCCQjbPmh6SBXVhWaMS76/geIcIvI5yKO8uAU3cDwQxH3aZU6n0ZqhbrSqV2K5FyGIs+pUQuFzgutq+JyV/Wt2fxAumMrKUwDlE6/R5R/VELFbQagF7vsf07Xu/6msza6OYTCKMUnvFs4/MX8Dfxdjst7vijoow1KxnqOElFX3rDroAAQzI7DRjE8uZNwt3ArnZE96nIpLc0l0dyAhdGgoRtHN4jojVdFRPug6mDjZVEBvAubwr1i+FXjC/1uLesB5B4Vret854LfRQK6jSuP01FomRFMQjIDDXMnwXsMKU8wuh1QlE2XYO5tl159Vyn9JVr0khiY4WvCeLeQzf4kR1dk08J4mhOTV7b0sbAySfjWVKX7zKzKUKpWdRTcATd5rnVgIwVcyA1tniRLFodaM9VvoefpSW8nfm3Y/QoxLTDKbpf4E3TTyLBnQX3Yl8ir9tPTJfkz/5wMcgOnj1qOOa9jtXhGeHd2IvyRi5fLbMZKulTEefE7q/92hTDuzHy3Cd5Qv1cvPt8QCEkP0FES/hNrZ+5IKTDDfEq6xoq7M0CMLUdIMas0Wv7UlAdh4bLteNcXGTfu73u64
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?llq5EgOahGtCkZA/0YQaZuNdG1x0vR0WxpJusdhsbXCz/D4MKeC6ENG67i48?=
 =?us-ascii?Q?QJnq3g+avOcOfnk6GeIItkTQl2lMgN/sLOxtO2vmqn7zT1JcPdSRjiiWhIBr?=
 =?us-ascii?Q?W9XUVBSUUzGPduIdYONh1F1afRP4UbtGRTd7T+1GEwWsI8ShZaTZ7xHZqwCe?=
 =?us-ascii?Q?Kjy0HOywn91z/ya2aG59xl94aFerMAhhWh95co8aLbTcZVizU239BzKmZWyJ?=
 =?us-ascii?Q?4p3lXJWWEr3teqJCcMuvlXdGj5E1TOqpXANYD3iDozvo/rDCtna2ZKN7I4JF?=
 =?us-ascii?Q?pBi18H3AiQc/KTs9/niaL0HllM6iCfaxS2N/pny19WCtFr+5F5HpeMi11NsO?=
 =?us-ascii?Q?6hUPPPLfwx/wB9pOw0vmwBWMZCgTjTMA77TFy+pvxsoBEnhYNw0hOrSmrbvV?=
 =?us-ascii?Q?fq7sDATO8W7PKxhsquuuP0Z7bIUMbFrtDdOdyLlury0LYOtWTlkEhlkvKE8j?=
 =?us-ascii?Q?SluTPgw+1rxfPY66NpIYRVjQoxJcEG1kB4vqZcWOwvNg7JaW7qWmzjYVt84d?=
 =?us-ascii?Q?fJTsnGbqsjSUMGCA2x7ebyWkMzqptNfaOCFhNQPGNufJKWzBSTCzMe557YNi?=
 =?us-ascii?Q?tK4W0ESN2MVhG1lRNkcoWmEcWo3JtcH6aj9gVVRrTB62htMUY63ppblebLzj?=
 =?us-ascii?Q?NnKlGIk9kVQsboa5WLIaQDPI1mDn6qmQDB+A7Ef7XMPbgKMAa+xB0H839zlm?=
 =?us-ascii?Q?V/CBFBtsG7u/Z6qXxF5U8uTJLA4adfihQRL0Crr1tfDBjwV3q/AwM8UiJXDq?=
 =?us-ascii?Q?ckcyxYqXVzswynbQNWf8PJrvk/+7532QuPWVDHQpjwP2/EGnyCFS8jIzlvAy?=
 =?us-ascii?Q?wfYSUwVlM+R2+HbzM17OY2+veSU+IQ4KQLxVLLCav8IirlDRntWzTiGaSQrT?=
 =?us-ascii?Q?JzJ6a9UUu1IXefns/JlgcHk4Jl6M0ZK1pcMyLqxx0OsVVoHsJTfuYIxD9A0+?=
 =?us-ascii?Q?oPACfHus8mB0V/ViSEqhoffO60MM21ZUeHRm7WrWoL/qhQqqFsNCeGmt7ogt?=
 =?us-ascii?Q?wwyN2f8EJoLyB0+AifFO1uQsrLlht57DoSn9FGHxSQhg1NjEC9ZJFZQ8Tqbm?=
 =?us-ascii?Q?jmsKchRHV50Jo9A2hqXQDjXGr4fieXq7TvmYzrQzZWf+kD8jXY09Q4M2c1c8?=
 =?us-ascii?Q?+a14cEnmFJzZa3PZP6yJoL+Em4twWTDJ18kEVG3E1VsiKKZMdFqoH9E+IIkl?=
 =?us-ascii?Q?/1hjGzyoKA7THqX7RaO+wfkY5vLKh5WMmNGPa3zhDWwkeE3ALWSHMT00qqc6?=
 =?us-ascii?Q?DOoiRECGAUrc+GN2/cs9HlJnwvIwTl8oWBg0CZkx0h6EvY1EgVSgtX9O8B+Q?=
 =?us-ascii?Q?ARkZcbN/xrznwQ/ejMJS9d0ZmElV3nSza5uFuTgCWl/8fwV8sqTKZMBfLUYN?=
 =?us-ascii?Q?B7eJGs+lah2KDV0Od4ZccxoaMUhen67g52vyv7C+ZfbMSROWWqX5g6h8FzQk?=
 =?us-ascii?Q?FfOEGfFNudiwi96856YVBm7l9ut1SyULfjgLBrS+j/IoCFSm72UDPIkfAtDu?=
 =?us-ascii?Q?TLo+4I2PLjGJXyVSyyn+B/O6M6Pxz+t5+UmtiwA0AZkBtd/W9dKG0DMV1rWg?=
 =?us-ascii?Q?1PLdZTHrf75yv4OiX574IJtJWmjOqmh1+Ow3uxTzG/F7WYkDNLZo4KX2cY68?=
 =?us-ascii?Q?sxED9jywrEG7ct1eXq44tmmPDgP46k83H0H/xu32sSDbO+yCVXkgc+2o1JEn?=
 =?us-ascii?Q?TDZoGeyhOW2qSQVxPSlw9tbZQ4XxJ2IA2nFNzKwsLokCloqgBVbLPRP5eqX/?=
 =?us-ascii?Q?a14cg6e1cTEAcJSjcF0ReF8tWaV0ss8=3D?=
X-Exchange-RoutingPolicyChecked:
	nc3hoQ1i9c9/HnFSOqIWN7OdieSua/S5tf7JYmZBt2jLdYp3WRGYuClGBKBxxWAhxv7w4UPUqRN9dukcM0sS/EG1EEknH2vKQi4lZ+Yn8QcbvgAor0kq1sqJAmzKwVtBkjcKidEGUtrGamkFeIO0ENP4ALpIXZFGoKKjRqehwpHh0W8KHrw/L+0AdGZtM93VT3jIhPDhnCCO62yO4v07Y+ttm9nYL2OZQz8EPl4xPlzH9+YoLZO24+m4NodHGUibmz0JABcXJrOAljWDdYx+MPQcYxZ3ngybbXpyaS0gXGQ0tVXAUJdfREA0PVpRMHMwRRarbxjpB8lXUhDoFw2XMQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wnoUJ6uyF7VJiz20ZSBnUsprzGdIgCpjipFPbIwSJ5Ed0fh6whiXpWViiDsfNyvFPYkwmtAw34jSyqGWqhn2jWmV9LtAkCSyc0sV5Wuymq6hSv4R+Sc/3PXI9q7odWgnJ0EKKxPV9+hFTko3f9pPnaSVRHqjbh1nNP6NnuanfPT5YtpFRGbNFFbUIgEEgKkH4qDrJVLC7KBvyOE5ehrDHevxJbwm5of5u5upatXrKIFZ0fJxczDhduepyfZQy+5hAUeDFc6n6lSc6S3AeQlR0t/YP5XJxsEZ6BUK+C8dvgvw2clTIwrKZgumuyqneg8JhS/pt1330YXjuk0D6P6Ck33G52vJ3Z9DXEGEMtr6ijOOmc0UE+mX1xx+hUAGJmtE7MHULuKOdEIjkW3InjTsYxsizwfF6YaYppL18E3YMr4Dt1MRb2GMw8Q3/NZE0Xrsrj4k0ew0sH489q1yRLDLg7UoC+XnAHnBtozubOV7fSha/6FVUW++KcJjoHOAm8oZk5Mn4SkonSh7gxDNozcSD3aq4LL44Ge/Dn5Ob8s9y7FSbeS/EpQWPJo1R7Rrqua4G1AxQSfrQn8BOIE57IjvoUPLvcWTlKzaTESPeUsmTl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046d8ea5-7f16-49c1-d958-08deb2261cd3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:03:09.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lZ+HSwoq8cVpjqR2sIyB1dSkJ3Z0KNW5bdDh6I0S9S9fFroQx9/KMh0XMcjL8FN6SAJkieBa5RW89a4RX2/BCXHINdRLoXfb1oL7sD3Ktg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=817 suspectscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150016
X-Proofpoint-ORIG-GUID: g7p7SZwN_D35D4pGgpmDciAtacZuvBkk
X-Authority-Analysis: v=2.4 cv=YcaNIQRf c=1 sm=1 tr=0 ts=6a067ee1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=wbtOme-P-aslnI2EuNcA:9
X-Proofpoint-GUID: g7p7SZwN_D35D4pGgpmDciAtacZuvBkk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfX8gBxfLd6gRYc
 evkMI/+0l28v+8gMbInKofZmVjzi3V88DR0Kx+Ufqq+ua8KdMqG0EiFjz1ahwJMNXtRKeO5hThl
 BTKwXq2eG8/bTUqc+4V7V9IEYIAwtTv9t77F+B2qaW4J06q4M89/24ctK4sNfk1Fw9K25el/UyS
 V2my89VTzXyU4zNmrCJ02LshdJ5Aq6BdG/+E634bL+k015K9Zk/sSiCLLDfuZUVgl81wJKHD/lS
 /0HiolSlb6plkHEZdkgpsXEni3xlKy3XiYVFO2lxQiPCFCVvO8Hh8F+YxAe3+VPuNVm4S+i+d58
 zWSMiOiHI42bqsjahstVwaa1uupKUEGdV/bkHxfrRxZzx7hS+XXXkrQLEjZUpDwJYps7MVl97Hp
 DR5v6kaT6UxqI6GTBo6Sh2++mGri27yB6EdFTBDEOSbEPzkj8ROIFUBqcC0hF9womD5OCQ6PJ23
 znW4897t6BzgxlT3SLw==


Mike,

> As found by smatch-ci scsi_execute_cmd can return negative or positve
> values so we should use a int instead of unsigned int.

Applied to 7.1/scsi-fixes, thanks!

-- 
Martin K. Petersen
