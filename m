Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAC428688C
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785290377; cv=fail; b=SrPi9AKAoJ+7OW1RdzK+vmXDVylY8legF/JEaQ3sdQf/2fNjCiRVnlle3qo3W8yzhitolD+Y+d8OIbhmEk42rM00IyhTu2gEG7Xdcc6/DXhQdQmQ7jzWz9jvKODwpbg7B+QXWuGJXLg7iVjj+GfviNqU+r5xgh1YPD/BeVS9gfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785290377; c=relaxed/simple;
	bh=AVDzO83ZMNn7Bu9YIXO/JkfuEANYe0c+02S75n2HfRs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=soxRTamtdGrbakK/A7nEUoVIuS9BL17K9PxsEp5rWv1xmfxOLDYN20SKw+BZb0kDUdtCKTgRQOjxxtL3MjNnn67i9IDPQUUFhW7aPN6kbFC3BPeFyPieMdPSQ476/TLijFIUdW6H0GNYXs1d2qh63nID8+8k6h/9Dq/WRbyu8SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UheN9qdW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dpmCyql2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UheN9qdW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dpmCyql2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYrk1094325;
	Wed, 29 Jul 2026 01:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n6vg1OsZt+nmijrN4E
	8YM1PMN696HeRUcirOM6v8qMI=; b=UheN9qdWEo+ZWrvvCN8qJhv8rRPNzeuaGf
	4NNX12HaiaFvxtWXh93Uje96c8GfgVYxWcv2VlD7WOnm5PiLqxqyZdrOcQJT+kO7
	JrGY3AF3isIXZs52GqyDrvl9SNzhbw36WAQERSzD2m38g35491Rohu4MKOTFnjux
	dNqJDyO0NW2LSol3q91ya+Ym/J7J/f2OizKGSI1RVh9VJHQgEHEx079dwwktq5kl
	Snx83l1xxxRKenJ3iy6D/mH6ACXVStlxQuouA8UFjVASY7lTZ/VDWYdgs4jf86gz
	pvnWmt7936d3GE/2TZNu7wvMLeCmhYkoLERBibTl0YOtyvY5v+9Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym52nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 01:59:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T1tVb4004803;
	Wed, 29 Jul 2026 01:59:33 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qcpxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 01:59:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYdHRacC0GRG4aIg9Fdea9zVXhzAF+4zMRoA8qWTnILBngd1sgEs5nW3DkMWC9jEs96kJ+0F5JKDAzzSrBI3Ry0yksQ9PpZGDJwXZcHg+ydVAx8pziwMMVZl11dCPmWvJlI6WOwzczNwWGosA0s6hu2xfQ2beWaV8+PypvvXLoSTSq5dtrvh76xGmfN4IEB4d65Fktt3O4l6Z5jHz69yOU/M1j+5+RTaIoXf3vDmMTK87akUXkTrYIQVbsS83rq0nYGKu2x8WRDLMz26zfsprCYDz6W9rkNOulryYEkFvBj2sE3zl6+w2MQRLzfLrO/7wGOS63i9EWH4m+1nVORtZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6vg1OsZt+nmijrN4E8YM1PMN696HeRUcirOM6v8qMI=;
 b=XrIaX2fZZ7V4oxqBYiXsICLMGxXyTpVM05PnpN1m+rzktTsSnO63AiytEyUfFWvq+dPoWL1ZzA7gylGHkRouT7Ng6doP4jBO4zk9PkqoCuf9+ZKTq4o8cq2RTpV2imFOluhvedIcmmNdMh5STGaWNF2fhzNQpqDwqh/EHIV8N+JDDkxVaqYQ+Mcj3V1kI2unT0WfWwGJXwFFPoZ3CVu5xANKizFvtrd25vCntrYdtcvSetLWKMsxxVs1m4mx7pfn3vdeCZZpG0JZcKxrvNq3j5uhPNsiFa/qwTzV2oFEranUmcUZTEpUK0YCUoBFg3TETmvObK90BgGTvqNIualyvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6vg1OsZt+nmijrN4E8YM1PMN696HeRUcirOM6v8qMI=;
 b=dpmCyql2jsezmFZ9nUnGPn1PekOKQ02CkSSdrm3x4UOQZAhho2VO7RSQjeNxGJkVsHKu8FwCU7/QI/JR/VWbYTMbPQW0yZBEgm/FrhhJ7GEuMrOe4TpB/qqozOodgGtQhMGST6WoD/bbN+VyHnAlCb6GVAN6CW/orRCyCh4a078=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MW5PR10MB5873.namprd10.prod.outlook.com (2603:10b6:303:19b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 01:59:28 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%4]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 01:59:28 +0000
To: David Strahan <david.strahan@microchip.com>
Cc: <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] smartpqi: fixes and updates for 2.1.42-011
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260722220401.6357-1-david.strahan@microchip.com> (David
	Strahan's message of "Wed, 22 Jul 2026 17:03:57 -0500")
Message-ID: <yq1qzkmwo7g.fsf@ca-mkp.ca.oracle.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
Date: Tue, 28 Jul 2026 21:59:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0249.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::7) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MW5PR10MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: a03e81e5-42b6-448a-4eba-08deed1505ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4Iolt9HYvYpa3sBS/bWsOnfn3HSpiwUJSSeIZunIfS3ca6iz6i5u3ZAPpgh4ct2It3TMjc8ePWoba3ovfaZkXa9cVLo0jSvVHIUZRNqQm4rwiLUNA88JPklWIpwojDJaDoIGFoNP2njPfyPmjGY87R91aTjXyVJjd3AuykwJkvHB5Im8HkAa40cZgJk9AyINnurfAOzNclp3ZqQLwj2pVdg4hHDLP/cYp/Na0ZO6ayRFmrLpySVljsv1+/8BcGlV+R+aPFL80E4gMKE+kpjs6yFolbm54cQWrqJt88XToZKc6vL/KJr0mElPmOmOO+gSkowS9o+1dAZg/VC7pD6sUSqPP0iLvQDdcdtbSk5ZPyJUO/EWDOylC85bFiN8EYBY9bfyFHftNagmmSPZewS/EUCvVoRwLUtBW0/6deCwaL4FZQVC904gH4TtZ3M7NOTqDfAa4xPQtHmlGG5KOzba01/Q2+bhVku9hZ3b0qtQ/+zoxkZaQuajKjZSTYk/wkvZO1sMGZEGRqLhjw89ePpdy2aXgsgvmo5F/FPQqeS/CAaIrPUQp1gonHM01IQMKO8kOIDwPFpg2WWXSzl5ts+ooF0ltW+CM1rIrw1bXPK3p4Pgzxq/QiyntMQueHaSGG7ma64rIV1itRT2GebEQsrwQ63b03tNbSQlr5/bCHBEZjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CWZYkPBggFAkio9R1aLjRQDi2WrqfWWKPWYHLMyFI37q3O8cMspTCZLFQE3G?=
 =?us-ascii?Q?Vv5wv6U1b9KVZOBmshFPAjJemY6bZwMCrnM5udCfzhGoxUazAIn2yhLEUGV3?=
 =?us-ascii?Q?pClm9AguIncisjU3cPD0i4DlQf5D3zfazmz7gBbngWDajDZ2fxtTRV0ZU8fL?=
 =?us-ascii?Q?H+SNz7YTi319a3p5QFZb6TQ/UkS5ToDfCvZYB9kgKqfn+fKY3Qf2RcS+OPEm?=
 =?us-ascii?Q?ukZw9gn6KUyMH/9bRj1nHu/RJn5wTpgsIse6wiTP6PAVdIztw4ZGEhMQEGwd?=
 =?us-ascii?Q?/1hW8BoeoXnPtMO3eetsNMk9SI0doVjij+Ze2IaVNfC9eXrCZnGm8UIBr1MG?=
 =?us-ascii?Q?1NtfV4CtURj8qsASskvexBEV7cps2bDm7lWXyWwIqKxaZVfjx1hnn5hwgFlw?=
 =?us-ascii?Q?D9A+jDbSsi7Y1enJ58fkQezCSQLvrHKLmOZtcySIxlQCl9aUfv3n4ECpltje?=
 =?us-ascii?Q?LKB7OGfuJm+z3pJW55TyqH933wV10x6bTbSX861qcvy8n4RNH9sx7E2s0XVR?=
 =?us-ascii?Q?STJ/tq7mxHA5U3m0kifrXOQiBaPmc9XyoM4/XS/z+Q3z4/VWyrvTdo77lmM3?=
 =?us-ascii?Q?8rLt+Q6eXsZSJakv+lB3uIkX1OY2Hhh4ahlLl6kJsQa0HnDrVyaUI3KP6dh0?=
 =?us-ascii?Q?W2Oc8M4BWED8rpVkapO0Vp7KY6eq4O15c3iMQMBQnqdKowR/r92MnqCVvKl4?=
 =?us-ascii?Q?lc7Lr/iFp2lJJzr0Yue3D6E7oqwE5VR6Ki5XokERTpHFKbehNX5A7Qja1K3b?=
 =?us-ascii?Q?C7SIyu54VnmV4axC/nx9EtJ4EgHKsZbl6GchgfeVptKqGuoSVL4VE91XUmjs?=
 =?us-ascii?Q?j5Ms0SMHWNKaGg01dTvnhlCsFjmtb12gJkxIFkTw+D79FdSoPhYEuQlAyZk6?=
 =?us-ascii?Q?Pu66e52AV4Cal9TeYWawcC0vlSazW6oC5XRx8+c/osHGd5NRCIUbTk4SjdwE?=
 =?us-ascii?Q?HqXyjm3kTiZEWIPqR6saOvUHaw3arxHD/LQtE/mN7w8OzxkMfwUN3zdcf9aD?=
 =?us-ascii?Q?5ibkHI8j2zLvP9f99al4KGy/c9URBUXMH7Su6S0E6ths6RgikEBYSQVp0gjK?=
 =?us-ascii?Q?uIKJTgpIhXxwGBLQkTMzB4QUJ21VNbYEOP03MgJOvuK3QqkgE4bN7jw9G/Tk?=
 =?us-ascii?Q?/tNUML27DcgZjJ8Oo6j0xBS2Q8kPHbXn44zWO5EiVStvB+MUP3h0Jm6vV/Tg?=
 =?us-ascii?Q?APrVq4Pqt8k6rNHXqPErvPln41+BoI0BDdnV+oPS8DQKeOdRL14RJHwBEdZp?=
 =?us-ascii?Q?fVDiUcoWoYKxLkobhhLDc3m5SEwZDPPypdcu7EII3HY8rX9jy7idKC7Wz4Q0?=
 =?us-ascii?Q?QeGqYTgoGnV3q31mg9A3xe5oaBVK/YnkeI+FmcfpvhkbXALe/eYDhvnMtnnF?=
 =?us-ascii?Q?4CAZJx6F6zsouO3aNZqmUO3nqpBbDBWisx1Ihh+kRE/o6cvDkfLS639LluNK?=
 =?us-ascii?Q?2LIvq5ENDkmeP3EGTXMboMl4aCc1chKuBSgZ8ArzSYvqF/lPaAx+TJXerOhu?=
 =?us-ascii?Q?ZvtqnlcPbPBJWATWmoO09s6sWEZLVDBjba/FIgPGwPJjuevfm/hM0+xcAXjQ?=
 =?us-ascii?Q?BsCpDxP7Mp5Lp6zMwvcQvyPWGkUv2+6hq7BzeGeUJcKc0NDAKnQUUhQdoZOk?=
 =?us-ascii?Q?6J2yT0rOOHsQ8w37prTLXpXtljqQnQ7Mn6nRkzuwT8gWJ+9MUmbSFsOa1QaW?=
 =?us-ascii?Q?9Lm0EhxmUlzyWp2wt8aGDF6amflYOxRlGqYNLtP/NqM1xJMNZWfAGQ+bkpZH?=
 =?us-ascii?Q?72VZgIfXNH0u3FX4u/+1R3Df1sqnE5U=3D?=
X-Exchange-RoutingPolicyChecked:
	Owt3CbkBaa0HIxtUbYz7s4wMJUFw5i5PucjYOhPxpoyh8rcQ+rs5Vsewy+c78aPK062ofm0wfgPcLzAxJn4Tu2UxgKoUt/tB2djfsqUqNk9B/Jn7D6H9KdMAFz6ypI7peR2xoBXxkyBiA3XL22rn0H8E3kvO8UneR30aEWGmg+QRF3/Chac3ANPU+v4JWvKgVfY+l/dHXAO8TlPlP3JuLhgVjPMXzOZba/j6dpg8Bphw6LsBYKsv9TTHkgNIby9vm+WlGzA3I3qKBXyWbsqiWnThOawk+pcv6ksnW5EZm3ZwVWqBPTDPCWwLvlzYl1EjmxQjeNysF2DESbax3+cfmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gm/YeP9FetjJe33X6XpguzDYfG16OuWBXohFRcFllavzvIBjojoTWJM/7Pb+FDqUlZN6iY3RBb3ivgtMpTEWlDF3xyhmcOBNIkEDwxdDIP0P61jCV3mmYfqlZ1mHBOz6fw6g+yCM5b6x1gDASPSR1e+DjqfEGUhmTLmT5vxdp9O+iNQTloiOeICIdwNX9R6GkNkSYZ43KzAL4p3jqiSFlePK+A4Mf+HJoPcHpSVLdPm+FdsNB7M3pGMsiUxh7xteBpCg1Um9sFu/WW9nRpAs31OpMDPyekVj8VcGQBfmfH6HRyYbm6j2wo2Ju0nR718mZXSQjE5eQhSrufiKsbwYqBhGFOtfSaNWFRRUNjxGdzh+eNkyRSwKfa1/fP7FI//2rRdRSqGpy5nWcd+53qzXyCME6Ttqg6yZGB9x3WERtLi8pQBJDyYaaNpj0NZp01cBqF0XF2a+SaMTGHsQucEIT3nFP6jq48NCMn54WoRjbt8+Xfc+wN/4t+kQAonRupuPIXw+rIkZuxiNKJ0hUioqYvJOP9G6YoAc8/EnGYpdt094ddrwn3fvalanaGbOamML/mnesORv27cdPl/on+S62bAeq7W2b3vwaGOuzuknV5A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03e81e5-42b6-448a-4eba-08deed1505ad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 01:59:27.9567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFK9HLWz9mx7ZLHFLcmlvX+/QN0kPJtaq+5M90hZ8Y6FjflnDyI3wKK2B53g0+uYVpHp5tuKrHnHn8c1itWWK5lbiImltb+kDbU+9h1QkM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5873
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=780 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290013
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxMyBTYWx0ZWRfX7gsYPKp/Vx4U
 vC58VFVitzCxx8QSqC94Wuc2LFpat5D7t63jxAYj22wl9JvJDdydN9eWUKNqOoyW31smagbEhfo
 2R/VS5JY08NWAVCckELpaWCPxuPCSTvIvTK9nnOsx87NVOpKeiNW
X-Proofpoint-ORIG-GUID: 3u6vKkkTGRzlzYnqRnSLOkvdad6PC_WL
X-Proofpoint-GUID: 3u6vKkkTGRzlzYnqRnSLOkvdad6PC_WL
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a695e85 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=ptqFKU2y6YcjoPtt7_8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxMyBTYWx0ZWRfX9A0kSboCYLG/
 oeuYX9kBlPSbuasmXlb4Y01a33HLRGAwFWxIEU3G1/L6DLTHkwvibaw+acQsvDw0oExw5iin5NK
 wz+EIbNNEZFJvGiJ/fvBkljkdu1taiG01C6fWNEPhQXkDNaemq5F4yeZBfZTgH68C0zVY1ixvJz
 GCUom9tCurQQtbgzfY4BaMFLAdgRW6zaGF1j4ug14/9mfzI7M5etBzmzvL/mRX4/M5BSLkwjTMN
 Y5tLi5QbR0fymSmEulgw8hNdGrY/SruFUoFkfn3NF1nOhF2AWqPcCc8q6AAWuMR7SZgP69GlEZ3
 LJuCgdu+cJDGNxEIQGoaV3mjn8+3R1chne4cgMt+mLdDRV+OatT3EeF6Uk9ZH3PKhy7j9RzClsF
 pKmwmV+BfmHLc3HjTZLXOd2kQtpvQp0XVGnzo57VOhFfCosZLFfLalfmk7GBmJc3UY+oSvpFnM5
 yt7Gmaz34ll9uqluUF83p2Vt0SExXFywujW5aiXk=


David,

> These patches are based on Martin Petersen's 7.2/scsi-queue tree
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
> 7.2/scsi-queue

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
