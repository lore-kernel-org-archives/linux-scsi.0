Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10622D299
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 01:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514401; cv=fail; b=nsHzRC0iT7OX5YoCDVYcxsFDLZkM0pQRfDQEwmzXHaOLJolglsQQkzoA80zlpe7ih9aN1IrwK2kX9GkGsfZX4egMDYkMII6NRBHWluuJkblEPOEk9nD2t6PHFIRfS9CL3uyhOy+VFQCdpCZoIxU+kDvFRLqrV0NWoN117FeEqc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514401; c=relaxed/simple;
	bh=EJy6/mchAETZuTgJJ81aoInn+6oMueI8MzUOBo9KlgA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VS1wr486gwGBGGtPDYscbUFaQvA67tCxGJS+LOb8W/tMjI82khJCX9eL48Cxb48pex8T1UrzrXp7T7eQea11MIJxJqKDJz+qxsqUj8h5aSNI7GfPv/XtSbTM/tQKLvAplVB3fAjI0tJUT6EzMgECoTqBiTt8h1ICJapi26mERKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fJohAraO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jMpsMfkE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fJohAraO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jMpsMfkE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7HMm022039;
	Tue, 13 Aug 2024 01:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=5AVCc0MjHthhxx
	5WH9nVQma7Vuj+W4lCMJygiLbsUOU=; b=fJohAraOlcNyj096/n3g37g0wHd4wS
	/nK37nxBh1VaQSNSsmNp6KbY1ElIQ/2sUDPjYFnMmMNNOVlbGxA5e/7ibcUUTdHy
	q0c8iTJRNlXpZ8OBA3YCr8JJwdohS3/hMgd6Pqs8dEre7N0DXzZesmB3TtH9HGnp
	dyJerXqjr/YdiLlP8v37D4pYUzx+hxOi2/zu7tWr8ckM2rpIuy3eIdBoqfuBLx0N
	DDc3VTpeRorhqYtQFS1BUn9Z3si1I7TeFtUgq94XJ4bbnSDGIn7DtubPZTfAWpbo
	SbyrrZzGP4b5ET0IfkA9lEiJ0OOfBPv1gke2EEQijMMoIVPaWJcM8SEA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x08cn1v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:59:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D0GuTB000684;
	Tue, 13 Aug 2024 01:59:56 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7vvkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:59:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTAgm9PuBQYyM44ybm3AS3P9L4Jolq4ydybVofkDpfpZiGx4aRqZc1BwsAqq9r0Ak2p8IBPtx0M+DUNCZLkIvLZDwyPLsIhGdx/8UEpZXRn5zYPqGMSHVvc58JrGQErYhmnY0zJVyHanJaSTYpAxjCrKjwGZliNahuZr6giPNExIlRtA8UcNf2IxYSLRd6hbURKnSPVe2ez/njtCONVAPXi8+rwL3bbWpEiAoGni3vjwKntFuLwYmx8xWEVc3amz3JQhLKGsUfwAMPGfSknGn+U+1v4MZg1uKNdhdt3sikJ+ud8ChftmlUPkMqy82a6xo9UsVYnnuVBz4naD4/NXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AVCc0MjHthhxx5WH9nVQma7Vuj+W4lCMJygiLbsUOU=;
 b=yo/S4sMHpPRXVEs2cyHCjmsT4kr0P1NteavjaIAFqwUG8tRP5nQcbe7hTS7T4muQ+zUg0XZzEXV1ikvil6z9omTQVIJOtSiai8NH/Gyvi0bxfI+QekEu31J+ZCCz10iKN5gHWsc3mQh86Gu5wgku9t58WMpqJzcLrVBm2bO0uLGTC3KWLFXcBJ6ai+fOf6yTLavOGFI3WrOHbLKQfgWjJPAkdp3cllq+IPo+xKgJOgkifvmcBALYXZubYPDxza5m/HT6Xr9s3ttLEW3NOquUatAt9ecpNlgRif+mvN5fkgK5/D2GCnx1pswO54GszeOM3jzwIxp9QknIiy0AvjVlww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AVCc0MjHthhxx5WH9nVQma7Vuj+W4lCMJygiLbsUOU=;
 b=jMpsMfkEa2yyeEvZtDLLoL3QqSZbCqeUMffjoJ/wp3B1C5k8m6RVP5jnQoUwfwK1TexKSlGR/NNdKepJQ3Nh+os7jh1Xx+Nr6EJj5eP4SbpRyuOHcg9/M85Ufk0SvWKFheA4KTQdMZTceP6Eajkh6zOtMSO26s8fJQM/Luxl0Jc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7289.namprd10.prod.outlook.com (2603:10b6:930:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 01:59:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:59:53 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH v1 0/3] mpi3mr: Critical bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240808125418.8832-1-ranjan.kumar@broadcom.com> (Ranjan Kumar's
	message of "Thu, 8 Aug 2024 18:24:15 +0530")
Organization: Oracle Corporation
Message-ID: <yq1o75xw5ca.fsf@ca-mkp.ca.oracle.com>
References: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
Date: Mon, 12 Aug 2024 21:59:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:207:3c::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: c64ac62d-537c-41d2-1a4b-08dcbb3b9fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vL51K/lbUJFMH+Uen68gA9wso16+WeTCzjJYh/wUCpJJNCD3rKa6028YEcgI?=
 =?us-ascii?Q?kOJ6AiTpy1HvCMhszgKmwF1aeJORrDJ4ps9lsXzjSvyoTJO4zjBt9qTWuuLR?=
 =?us-ascii?Q?SW9lWc749BdPvTI0Hvl9imF1Va1p9n4nEIpGTaOp4k8DKQi3nwe0suA/YSdx?=
 =?us-ascii?Q?Ty/1jtXlz2zRX4iutcQuzRtVxhDO5MwYprStrFROUNmwLB5IyAA+C1b2cKMy?=
 =?us-ascii?Q?hUQZ/MskAimqE3H6X7WO//1Gptz2Qzs6ZkIueyDZxWjubUS4hgnXZKJADHOb?=
 =?us-ascii?Q?POEkGaVK1iTgTcDdzcN5yPHqyju1Ys7vqOvpoAKNLs4Mqww19TXIiTWawQV/?=
 =?us-ascii?Q?jM8QDz5SaC3dDVoAOWQTUWEPrbGZXyAe6w4KFhAOtY0GmYftqETyX5a0SiHP?=
 =?us-ascii?Q?BZhgrU5jBR4E/E5kaNFKDblzQgY0Y10y6Bp7sexWKrXs8eIC0v5ru7shg4Hu?=
 =?us-ascii?Q?7bJZGWYqKGfMET6hcGGRQuB5W7pT8z+umENc7m/RBQrluiVwDgyfk/ilbNpD?=
 =?us-ascii?Q?TVaytfo/6guQVNT3GswCGHB5h5lvWJT9O9q9KPhRAYmfR6xrLGJmiJDvqzOm?=
 =?us-ascii?Q?soxKR7LJ4Sk8aRrMe1zk3F4XZ22XmL+/uehb9Pyi0aaFhUZ2zmT4aUEaBhyZ?=
 =?us-ascii?Q?0Efs+6Rg3O+IijQiXXQWL7R/VEtR4Eq6LUIE/vI4Gr/JrNllt0JssEeEf++d?=
 =?us-ascii?Q?AJukljY9A1rgUxAyNONyVTFgR67o07L5uTnv39PPlSktCvCS14C9BGi+wZl9?=
 =?us-ascii?Q?d0VsqyKjlT6bn/KiHFluvUaIouLf4KccRX0OSl90R6XRXF4qO3II//DlieQC?=
 =?us-ascii?Q?8m45jgjI5HiC+K6z7VKD14DjtqJ2JBdvgq2A6Zn0g7X5EyetonuCk8mWMiuY?=
 =?us-ascii?Q?xIYCkuGgAxwO3fn0K/JK4eVWOu4J2LGdbJPYe43+E+9MW/RWCW0IBbppnXi2?=
 =?us-ascii?Q?e4v2N8Vqd6GPdOvKNkWkt7nX1ERHCj7PRgN06fLOWtG0mYelob3DlJRdVdyC?=
 =?us-ascii?Q?Z+gFuhUch+2lCBvKf/BFqZQbCoM7ob1xyitc19sLYQU+/q9x8bW/VTud4p1d?=
 =?us-ascii?Q?NhlYj6tjjIua6K0mRtft86y4K58TTJnow7vR3pqv9lceHKNCzV1lo43N5ohN?=
 =?us-ascii?Q?6OBnZ+ZHget4xZaV/1nVFEiXbdjnTPp00d11R9blSULlRKdbDrGcz59b0PS6?=
 =?us-ascii?Q?JCd5DZiYCnKjd46/9xJCSZAvTwlU0fvhM1uiELezcUMCEAT2tFhqutwTFUts?=
 =?us-ascii?Q?TLf9IRbKLwGiEFKevWcSwWKzVkcXuX1SNLO0vNG0oJkAb9pH91HCk9U6ktu2?=
 =?us-ascii?Q?89TLyJnZbyZsn61b24orXvHNhysoAb+xrvDP6qwAn3YFyQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p/9egig32M7Cet8jD0pGSkqrsCfXFNtyxrgM+/O6DJ8APN5Iqf0xadKTUEG4?=
 =?us-ascii?Q?zGQy+pA2HA7mBbY3W7LsRDVLXagCX5COIYu67bqLe51nDdq9LCa2BQQHwtvw?=
 =?us-ascii?Q?cnGAoIN1jVmLfJtUcL578d56f0l5HPFCjYFORMyOuNqrtLfjfwJLQfqPUQKw?=
 =?us-ascii?Q?3TqOgV2hWp5cX6+N4N1tbFetFWFvS6nexZPLFs0TxI8P/zv9A+ESgVBedT2X?=
 =?us-ascii?Q?dF23YsZfoaksZWtjgsYHqXGbJo0Naac5f2AOlsp2uHOqkH09rW/0K0mYeEeQ?=
 =?us-ascii?Q?NYWSMK87w7wakUJ0Rw11b2SFv7wk+rYOpfMmVNqQyMNLwZSODuVPsB8u8fxM?=
 =?us-ascii?Q?tXGR6mE6tjzZtf0jWyArnW0Gx1s7QTLVKPLS2xWQsTZY77Nw7amQrJCAznl1?=
 =?us-ascii?Q?uighEz1DPRRQnWtdQ80REsMjPZLUNWGyt6G6qdSC6fCKjOFxxUpIeL1Ckkug?=
 =?us-ascii?Q?EDIv0RLHKpUt9klKSoSyUPp+7mDyP54PYFfh+zxTE0db96uDwATf+4vsXiWq?=
 =?us-ascii?Q?OCTjMM9D9nMZzL8rcO15ts3jmoLMi044JI6LamzeSEjPBF7c5lGpQkJuCkTZ?=
 =?us-ascii?Q?cclSjhU+JkagFtvaZxoQFasfLMnMTkfSxS54Z3LJPE55a2iqNRa3hD/W3dp6?=
 =?us-ascii?Q?cBOe79s+699EvB9FZTeiovFBtHPZfNiu4NwP8r5r6kArHn2RDtF0BUXgRDzc?=
 =?us-ascii?Q?UnQfpqNYLmalsObv/PQv1naQaP2iQINGm/fmGGBdupuo9YFEzIeM1dQ8v+Q+?=
 =?us-ascii?Q?5te5ZNUsU+uudT1+zry8o+/0ZJEgJ45V2bItTDDsvT002gMhFTLW36M41l4H?=
 =?us-ascii?Q?l+bBCFh0Cwjg+ZOeN0rlfdbTuqDg+jHxD4IApLNIQ1tQnm7ubNGzq6PpNyDC?=
 =?us-ascii?Q?pye0KYNLSXtKgk8xouJsbP0n4X+d1ChlV5EmJA14BegP9pE35Dxuu2eA53ly?=
 =?us-ascii?Q?62WzeUw6QwBOKcoVVOHxPkVhgM2iGtWUCR1EGlOu1kD6Unk0QR80t4BU8wpm?=
 =?us-ascii?Q?oVOh5TPTQWvSfUFDa9iwYqarBlZFTBJTKja4+jAvaMTXL1rJayxg8stBAXKS?=
 =?us-ascii?Q?2rzsFJ+Wvg4bdo2g3XYn2FlpBmS8OFfO9a1cQ0loxI+5klMmIv6hy4Tlsezh?=
 =?us-ascii?Q?igJJOXP+Q36+tJontzj754arU6Wy3Tl90Z78uQztj45Izh93E8hmDtNzxaCT?=
 =?us-ascii?Q?4wW9U4WocWkeFSFmGrwwef7Fw7Bg5vvPnjR2gSDFZforWvLzpyKS3m3PPDy2?=
 =?us-ascii?Q?7KR2d9aix7W6BE+btDUVWgQ4CrgCxVVYEhGqDUyQ6A3pMtwR8JUQQcxt2RAC?=
 =?us-ascii?Q?aWn2+4RcGu103JeGy15nPSrGUz4TJLP3VABuc7BnlSjM6p9Hu9g2d99POm3h?=
 =?us-ascii?Q?amEtF6tRQ4CTn5B9OBVMgOdD05EBdO3GSH7Y2ttBycnNsNVEtiqmbdVuUYP+?=
 =?us-ascii?Q?CsGpJrQnTpCFcfQeYFNdNYkwNRCmn2FHCorWFieORisI4WqdnHVXEQscU+kv?=
 =?us-ascii?Q?r5NlBHV9rfjUrN6qh0efHtVisKgR9yin5FjLfoxVtfMs3q5NQwakiewWgbOG?=
 =?us-ascii?Q?RWxjNO8VlPzN96guaKvbuHqFZDOI1HBP9NDx3xfsl5xIPRQhF4Ba7B0MIgxI?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BJ6w1FH9fTfGUh6l922vcepI6tNhAUFF3BuscenlqMWbAt5O5Mqh/s83MlS6ab8pFdPKiE/rzK4FjMvi5jlpV/pb2EikpWArWWdk8oFxn7P3jFMU3YOtru64SEL2KLC3m2t5RqfP6KLpjnEq8TJWcRDcZRkO5w1rMlNredHPgDBAK8Kvkr6WXLEYWWpxSRpHrw30srAX/dNuB1CbvkR/b3itQ2iXQ8DZsL9TH6NtV00XMJp+nGx1WAvi2uRTmgOvZttx5OJOGutmJFbrkwWQOdJBNOI9H7vKp2ZbrOYRORX81ExjARtBgRevyH/DoIh0u7Ph22RDvMiddiExs+iwJ5Y5lh3jIOvsOIZgwMLP0HdS2r1T/EjdDqvb8JSZJTq92hH6PIw0S480ZhAlcXagtwNL4dQyaaqEAOCxBithtx/YiwMxffy87HvP/GPYJksCI4EPppEzdFmG9DI49aUnMPvIgcevhSUYQLAq0O62i/84PAiWkMUb3H0lvx0ok+5v54uAYd05ta6lWsi49R/fRIn4WCYTeCDESr5JVPH4lOoGfm2Vvgf0ZXWAbbIUUygZiGEc16G4Cn7sVe1eE7mJ8TumRZtUBqU2lZQAP595ThY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64ac62d-537c-41d2-1a4b-08dcbb3b9fcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:59:53.8946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nDJ5j9OhIbz+IrE4KKR2/c/P5tChjHfVh/D3hVQp8z/DAYsz+Sx1N3aSs3jPuCLhWl8cpoYbf+gGFYCFUlaLVYqihh+WakmkeNrHiZ8loQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=713 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130011
X-Proofpoint-ORIG-GUID: h3GzbGCNflD02kxKNM-p1FN3XLExo-AI
X-Proofpoint-GUID: h3GzbGCNflD02kxKNM-p1FN3XLExo-AI


Ranjan,

> This patch set contains mpi3mr critical bug fixes.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
