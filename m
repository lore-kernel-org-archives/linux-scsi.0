Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836CA20E309
	for <linux-scsi@vger.kernel.org>; Thu,  1 May 2025 10:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746093781; cv=fail; b=pLFeLywNYbpyh06ausSc+PtBzb+O5vKV0qwiwd5fjcdDDgUX+J8Ljj/4q/ZWr6rbP3NuuWdMEH9TPOwx1ov3nh/BCNslExWSp3PiPv1F1mm94Rt9lhxBI1nUpuMSWwGVWpk9pUMv3/qinLpbTrcj6jOXLQacd0PoN+3XpZsd2TI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746093781; c=relaxed/simple;
	bh=TK4w2Md+0Lz/qq1cB6ZIEoJ8/vjtxHuZ3EFoI0/qylU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pUzxS8sHk5yatrp2iMtjoLqtX9YkOp75FXoeAesc/IoVjngSHBGPmoudTFNDyMonytQboIdMXaJdq0ViLswT/7Q7onq6cUWJwgtgLMosZPCxCoBYoJhDeMx2wA7YbAkXcTdvEUdet4bGnwDRVPk5uoFUC53us/92TmcdrVm99/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ayh2lxkU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gLimMtX5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ayh2lxkU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gLimMtX5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5418fvD4017360;
	Thu, 1 May 2025 10:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=R3KcQaqH+/ucvqqo
	lGcHza6LPWdAFVGrdGeNNcF+Fac=; b=Ayh2lxkUyR/IK3BPLi7W6oJMdK1qc+2z
	/0wpGbOiIPzBXHOI0JzaaG/9/Z9LeFQe+wsraTlC6oteT8w0MQ3UGCvcyHRzmThh
	xwDOkN4isT43OrDIHFfU44oMihXxA+vg6b8s/yPcgWTjMaaHXtJwMb9OjvU9Ia2K
	TPPU1O+2k17TBiJQJSJo3A/TByj+J3bNtcW/6CjpOLjGPIeXsOtIOWElcx23Klxl
	mxE1dGMVYibEtEMPKapdI5XYpPWELHDkkQqZTPA90/5ZLKX4sRWi/X5OkP4wFWzy
	fAZJVoOgimcPreJKADK2hsqzw3LnU76BfCA3S/sfEk6GPtBwpYF54A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6uujuam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 May 2025 10:02:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5418j2Nr023740;
	Thu, 1 May 2025 10:02:56 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011030.outbound.protection.outlook.com [40.93.13.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxjmrx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 May 2025 10:02:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I2jFecDyVgVi5NJYIPoCIkBDCXHz4Ld40RKsTGdpPtIgE9cTKiNBLw9pljAc9uafrE2Aot3kLPoXgO5Iq1Oqid0RVUmjZDXuziyG7eIozSl1BWouwf+6q6AxW//Kfq2r/DdQRhjePwvuuMaMpNvJ2K1ILwyx4Mdk1m2NsVS5u7FPRVE5MZ/aFi+4aNwFAMvfQX/UOIh2giHA7tgiH/U0ZY7fm9Ub1QZHbFdU1/S7Gf6uVGNDHYLoK+CMUL1tqXk+9PH65p9nOHhildruzHZk8XO5GbZuyLYMMPkUqVqvOvQbIUAM+1cI5iPPCTFwPqDsKH64/D2fmUam+6ZJVNnMKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3KcQaqH+/ucvqqolGcHza6LPWdAFVGrdGeNNcF+Fac=;
 b=iJbspUPPK4TrlxuP/iHyS0NoznJLqebeG81C6yVcWglWcch4nI8K9kRQ0H2nP6oH/OjZgRJEmVY1qF88XX/X0VxS+T/3xXUR4ir8IJP5WvZa169hTAFgekK/qrdhrtGQ6Biikcshs3K5upq3ie/5hcnp9zyJA6uavF3sQ2ymHGL2JSYQrJe/cYbpNDl362jghGw7VTg1lwR+UFCm4BtWVOvNMS6bhZnqECTeLdwxvNmXQCJtNCsQwmJ+mo7Mep2Q5btI5dGkflAhGV6OF1pyo7jgTOcL46U90vCtCTJ1H0xFNc829RbGvX5a/CdaOvbnt3S1TmRwXPGKavzn2TJHfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3KcQaqH+/ucvqqolGcHza6LPWdAFVGrdGeNNcF+Fac=;
 b=gLimMtX55CanaWNffytp2wMZDIdXVHYUmc6dfTGEpE8M5LoEU/I91Ui5F/RfL9VEWP89SSYWNcNf7OckQaBBcNKbmM0FMxiVzRlOx8MxK/dRmvF2mQzFW6/4X+0TDW5L710wleyikXHAfu0vA1kLr1zczPXnhBHtIhdBKcaONmw=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by PH3PPF54C97C915.namprd10.prod.outlook.com (2603:10b6:518:1::79f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 1 May
 2025 10:02:53 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.8699.019; Thu, 1 May 2025
 10:02:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: scsi_debug: Reduce DEF_ATOMIC_WR_MAX_LENGTH
Date: Thu,  1 May 2025 10:02:41 +0000
Message-Id: <20250501100241.930071-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::17) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|PH3PPF54C97C915:EE_
X-MS-Office365-Filtering-Correlation-Id: ad38e89b-0695-422f-5300-08dd88975696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hbx9Y8oDewrhd6EQOhBjB/CLoI7MzmjfoSa5h2+oAk1XLOt7AUm4DtCnsgtA?=
 =?us-ascii?Q?e0EgN387eoRV+hSerLE1LXnuY8Pc0t7lByawxNhcnLCepIfXix8RPmxaZ9ZG?=
 =?us-ascii?Q?rJcFA/XDhu0YhQa0OxGjf0x21TN0Ni8cXcpLEQKu8gzgATg4uXUW9xAIp7Rq?=
 =?us-ascii?Q?JKWgrTmC9AM8viw/EI4qWE8p1zjpTGrXJDdnD3LHo9mDkaFuMRKkMFDq2659?=
 =?us-ascii?Q?I13/WVUvOOOKpm3ITIYdGFHNzDpnBWSR7pKBo8haFgl0M0TYWjnWk0T7BBbt?=
 =?us-ascii?Q?Y0LgS/9EvdLQIUOmG3uvEVz86tIMLiqj7oaUbFuepzh05EyrzpKvXmtha5Iu?=
 =?us-ascii?Q?0qhAB+LsT8xNURUSFF0FDWhIm6TgL1BEJdJKBUDibJXM0X/rlKPCscpiZi4q?=
 =?us-ascii?Q?YqNNo7iedpBfOysY7TcOUtMN/CyDG0LK6D2ZmZOGH2u3smZncFA1agCa4GZR?=
 =?us-ascii?Q?4Nmla9jY6ZbtQpMra3MAmr5YUy2TbprUaE7qF7Znxn7aWX7uvm1iPi/29b68?=
 =?us-ascii?Q?z2rlwgUhbZN24NNmbKhoI+P0Rr02jrqWGtvVO72dk5MxnEZR0ccr8p2N1dMk?=
 =?us-ascii?Q?nB08qSH+4bA8BZps7qyJho8yNKvN/2/pDhpVmZyvF4V7g1RzRsaUgrdWhf6e?=
 =?us-ascii?Q?lkV72i2SfH7K8iNXBk0KMAaLSzqa3UC1L7HYr9qa11CYGujsX9ANyipG0O1G?=
 =?us-ascii?Q?8WtLQnblfzHzINl8Z9MG38jngVNG0VH/nf0YTLN8YzfVg1Rx6tqVh47ib8UK?=
 =?us-ascii?Q?6FXkqDYEZql/vrWY7Bih/QPTVffoa1Vzrmqa262WjyTs1c8UDbiwhXBMpy6G?=
 =?us-ascii?Q?hxK4F4FqlVWdW0GadAP6C6CN4+GZLLNZjHBjs2qB/iiapprdUwYzjBcALY2r?=
 =?us-ascii?Q?X2fV/nZDaMkplRgJLA10lDrMsvfd173+cxH9JMFlkhsMcrwcj6rLdqOZxU61?=
 =?us-ascii?Q?bNZJP0ZBi+LEnjIVKIsFQjHTh29Ch+k31BAIIPOXGACj8t4t/DxBCEkxdwzi?=
 =?us-ascii?Q?ivTsE2XHeNaN2WY2kmA7+2Me4Xp/rL1+ufhbwPhg0Xie4AB02kued8DM1sz8?=
 =?us-ascii?Q?v4WENF7+FJFEPwUXcu3q16XMCfGW/4h3kU2RLm1I4Lv8lcXsSL0ndh/k3ohC?=
 =?us-ascii?Q?JM3hTsiUxNBEN5mGWAbR8LIlrpJDhz6ayI6m+ckANtIixPn0xIybzzsHpqPy?=
 =?us-ascii?Q?2SnGTLiS/0LThGtDwMi+iHX3vcyiq60bjqgpQHhCN8/mJXvfEYmnTnQQomTy?=
 =?us-ascii?Q?JdjoyktEcGfGHmpfTVTh0ugqWtf/2xMAllBh4uI+bpAzcU/EkGt8gea0gmBB?=
 =?us-ascii?Q?avKIMfJLBwP926hnVi9a0gkjypufPkkqKApKKWXJX5200YMve7VNn6dGgYC3?=
 =?us-ascii?Q?iUoxnhf+PDFRD/6bYQxHaOa52aAMtT+WeKD7RTdgKW+VP7W0c9g4kYI8OXzG?=
 =?us-ascii?Q?ZOaBTUYmh9s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?73OfbPxcPCr6e8HO7z3Ylu2++RP/ipWa9R0UCHErH4X8wOBPSFu0fzPRkcoB?=
 =?us-ascii?Q?feIud46ugQYG9J7ErHHUHdossf5i6+BLIJIrF05qCueFzdy2XXNf782gG1Uy?=
 =?us-ascii?Q?aSvZBiauRa6KE+KcJI6LqB1209T7YXp2Wae2wV4H06YALjipM3o6cvgnSaBP?=
 =?us-ascii?Q?gt8Jl8C2KWCuraQsIvTSGlXrLa0scx0EGx22uph5SPLLaYPvHl6shofg9qo8?=
 =?us-ascii?Q?+rVESE9XU3iJUN9Fn5jGG0SnT50DB011dn1rJ+e7ZemBNXr+A8vlZwD9iCd3?=
 =?us-ascii?Q?FF0QJTvLdXRkva3hkvhxlrEklENDFldQ/CRoWDhjr3KmBkOe57Uh3YVlNu1W?=
 =?us-ascii?Q?7DMXfsy6M6oHWgx1wCbkihm8hijYQ2ObsNo/9AWITmVp/CnzdF51ALzqDHNJ?=
 =?us-ascii?Q?tyeLUv1Y0B/VTcbUwmSPIadoK94aDkxYVuZmyVrZd5wYPFoJ9U2fZwIzEEQw?=
 =?us-ascii?Q?LhReO03zusdtbRQLestQG7SCmDjA6OqAxmAlsD0nLWhm3SMgtW64rJl/4lGW?=
 =?us-ascii?Q?s5NZ0jDKp+aUdq3sb5d/F2LMLiPHO33PlWbZL+VPQWbIKSoagMqfPbCnGwea?=
 =?us-ascii?Q?WEnndVr2Eh2aR8VGV51DQz5wdm3qHQF3S2jQwQb2qeiI5OMrS7p09EyKy9y8?=
 =?us-ascii?Q?1xXgnJCDrjdMV3VItjiIEwA0J87MYZcH6Cep0l1IPJyXaDgQUor3s27war4B?=
 =?us-ascii?Q?vPigMapuH3+bNk1ntl7s/H7jwgEuLKZqKx69DzKBjddllsjO5CjQrmxKWksf?=
 =?us-ascii?Q?o7n4r9I0W8ewJCtIsMmrErq725d+6XcDiuk/x6jFOAyaA0eroFJq28tyjPTS?=
 =?us-ascii?Q?E0oEW/MeY/VlPgxE0aQFoPLKG/1rixmZBcrQJqCLAx24wllAcUxigAXx7w56?=
 =?us-ascii?Q?8lSduADWNHHYZhGJe73wm8p5SnGRmSHBL+ZnkR6XhQFUxxu3PnHTUIs8F3cg?=
 =?us-ascii?Q?xVwBkXsWQX6EX/M5ecu1nS6D7TwJknIGEE8Z9fsY2UDM8WAS+lFyJNxU64Z2?=
 =?us-ascii?Q?dE0dxJlgzbrh7IAgAFzoE1cRtH9yzonO1dnMcT6cnHxzpaXvuDRyEWXpwnBH?=
 =?us-ascii?Q?uethpGc4O4R1K6u2+DSPc79ROpCW2SFOhIEfcfJZjxpZID+pBQUDmkhpaW0E?=
 =?us-ascii?Q?umlPEaEEV+9jX6nag1ug0NYDmW18HbeHVJOrXWDEnUsoHGe0acrKorymXM3+?=
 =?us-ascii?Q?ZmRJK2zCL3RSvvs1nUHKgB8usAM9BwsnDa9HN2SP3cQ8NM5yaiMAeZ+74rsG?=
 =?us-ascii?Q?d0ONnSGG5EZBbfScCg7booTKnE1nbWC19fwwJv4tFQ5BqLMYkJtqds0A1bAb?=
 =?us-ascii?Q?qWNBylNdx3xPwSrwH0toPztbqZ18R8ca4YMnLcOUVwyChIYeB2l/m0kSx0cM?=
 =?us-ascii?Q?VwFACu4ohEiXWBJZw7epsyNhiLJzswJzNPqUHz5oHXwQ4QLtogbLTL2jfe5l?=
 =?us-ascii?Q?QI2P5WWL0SQBv568IJ80bbpn8WycLTa9ycL3ML6Sq4/qh2vGpwhCE2GJQPkJ?=
 =?us-ascii?Q?x4Wu+JkQy4vDmU+Hki79E1Ksq2t+1CBvMfw2JA2GXN6beFqqJaet0sO5CH9n?=
 =?us-ascii?Q?DW7ceObJxvG/m/3Q25r3mjPLqHojOn+6Z7UQl+VDNhSKBND1XWcXldFoD+tX?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hkHETp6JGYPwDmyVMiaZ1bG3F2Z1Q6TiqzFObYevaR54icbgThMYHN657GsYtiV+p0C+gzomjQV93SzFR6EE92qdE1aekLiJ1F8btU+HGHt6+xib0jy83wlxRznl641aqcaTc4KnEc/BKPBjbhcn74Q0LKqBQw4VyH/4xK3Yw9cFlnF2ftDKfkjx1Ndy2t6FIsDRRjsLSUD4tai9xFOjExfedO7TLheJ8jdrAxhJ0kQE0lcVNsDcrdzv8u6vHgz0GRnp2J/GPHkWshSHNd/pfg7JhSD2ALzLtfMKcVfOEH3F7ExSbejrrKtugvcV2ZLJOsracWznOLXqXBAEpOifNagUI9tz8Rx+aHb2LdweajmbKFF+Uyw6xaUYw3RG+Nr/oxspU0vrd7RFzeK6zlR4K9Rb/FI7DU5g3rrMKCzhoHdKGg3smWfKbTcG27reCIV1DN+rkD8qf1KGmjVkSRqOXvd+jmHB2sFEaVKqKKc+j6ebblY8taQFyY5RymDLHIRBoyOOSAsCltXuHDr0leF2eR0mm6bPPhVYKElInM9Sr2YDLlNl8O/uCdeFrXRuulqVq1K4gXaq0aT0QSXeFFhxoOmqxupchBXVBeR8Bs4/hEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad38e89b-0695-422f-5300-08dd88975696
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 10:02:53.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyaybQqaN2vsB8CnGzMi5SFEGC9W0bRy+UPD+dD93ghXalEA01R2bqCN9ZAcRA0Bm2XnTyk1qnJg+y0xm6zNDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF54C97C915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-01_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505010076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAxMDA3NiBTYWx0ZWRfXy7sJ2A4kFanx w2suZAyZK0NVegO419LFXIM2+LpTR6CxH6DNVupjPPtHM7b07MiOzcDycOS1b4GDMN+1rsJsPhA /vxZdBVzjGi6rQOFLti56gbR86rP2xYObr9ZHH+TBuJMZO5foKxMwtlROogmbLgnzSarTnZaIAp
 76KfCHLBwsd3mUmPFzz90IJjdCovH6woMD3OAUUS0OwquRFQIeGR83QyokH67mUrdWVYFATiBbL oKlYqsBHCvkKApGlXy7wSZaTVXi3jp31XMMdnOtcHU0yUZaJCi2fBsU5gl9UvIGuP2WIa5H01ht jghFAPQgw63xKhS7ihOVVuir62eOnWNtGj0isrEezlMXP0aP5S2LrWQSA9D+6zpyzVS0cH4qKrB
 TPAb3dbLGyzTlvXkOFLhk8q8tHJRwDXBHKRGgBPy89jMY9gwOgUyBnwqaBbvJS2JjDTZxSSX
X-Authority-Analysis: v=2.4 cv=Ve/3PEp9 c=1 sm=1 tr=0 ts=681346d1 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=SIcoLkqEEUpCqp7oTWMA:9 cc=ntf awl=host:13130
X-Proofpoint-ORIG-GUID: cLctBgpYHregKWBuWMHD3GJBysHdpb8U
X-Proofpoint-GUID: cLctBgpYHregKWBuWMHD3GJBysHdpb8U

The default atomic write max length in DEF_ATOMIC_WR_MAX_LENGTH is
excessively large.

For 512B LBS, we would get a 4MB max, but due to block layer atomic write
restrictions this is limited to 512KB.

Reduce DEF_ATOMIC_WR_MAX_LENGTH to a value which would be more
realistic (for a real device supporting atomic writes), 64KB.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 241a76761db8..160b7488baf1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -163,7 +163,7 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
 #define DEF_ATOMIC_WR 1
-#define DEF_ATOMIC_WR_MAX_LENGTH 8192
+#define DEF_ATOMIC_WR_MAX_LENGTH 128
 #define DEF_ATOMIC_WR_ALIGN 2
 #define DEF_ATOMIC_WR_GRAN 2
 #define DEF_ATOMIC_WR_MAX_LENGTH_BNDRY (DEF_ATOMIC_WR_MAX_LENGTH)
-- 
2.31.1

