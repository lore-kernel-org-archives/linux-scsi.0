Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D921A5B9E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041349; cv=fail; b=jlMxbo071bY5G2BEuz8yJa2XyStNCu6wSDFPPHC3vhPvCkii/aIAPsMiz6M2kuDkvJAp2scXrUMAGIYUI1zA89sdi5fr1OViB8YPVcRV2S/JDX5tetYiaaFUPhnuruq4iFYHXIcjY7PsIh9k13vph8+eHYlkHqxwpe7YAKrGqqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041349; c=relaxed/simple;
	bh=4gAumkn4V+MXKLphhSdw7n8rppTVifr+9K0IzPOoGtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z5AWsv0jnm1wju8TPqGNmIxVTysZTxLswqFgr8AeJLOlvwhwbKqd/v/CYUs8BF3WhLfrAHc6ZlExK5QRf5xpMnvFUYMnq9i6gmz4ZXRvvFlfhse9Zd+OkpeeEQqcbu7/Rjm+NKLonLfF9KdfEobHos5bcoO5D8JrrG83Wr4TpME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GDXAgMB8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sbfppNJG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GDXAgMB8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sbfppNJG"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCTwfv022742;
	Thu, 13 Nov 2025 13:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Hh1A8KIOHwWq20U1175NS4dR6Nptj7ZHXju+FmnYNgQ=; b=
	GDXAgMB8TeU17uPaPWkHFzO3GXiZWIXo38WIeJeJcFXWAlaDzCN0pE7KFKhYxRia
	emV+vmA1xaODx+VP7ULcm9THYHd/keiffD5QsD40ezgVkBe7itSGfr9zDBKnLk8+
	o5+k1ud5XJHNJHBKK7/pNdE9iBvbB1Pwld4TvydDxay8bVIeCIN6IrVSk7f2y2aM
	s5EqnmgU2Wd8zmrpuDDrqi3y7XN72izyY+tDQfNV2C2DVmROu5UWSqSJTHLqvDqP
	A4hGiW6Ya/DKi43ZZOXSZv7EvE9yndFtld2jGypmeCAz4UwIVKqd+WL00TUpD/cl
	1O3rOIsmx70qdz8vr0QyAA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpnhvp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBt3sl027724;
	Thu, 13 Nov 2025 13:37:04 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vag6bs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nzf7DV6qwQgNHxyN8JXKmIU+YW0MdAItHYB7twuHJfdi6ilmQdv4bfCfluLDdqxwtnI5GIBiwhhQUas99iBLeRKkS7UUb2OMLGXWGEVtx0h2ie1y0mvVlLVllyuPSzQj8eDEathl2I4l5v4AbNkr5CDzIZbXan9+P8HxWxNTEQ43TcN/z95wdTGAnypYr4YY5SlA5u37UQb6n7ZGbeULE0Z9woEjzPTXcRdBys1AYVK6myj9im1qE2cped55UrZkhwfEkVMUDG8znbLNFX+CdwBB92ODjvgpBZlDk2/KaCn6Id2Nex5nl4bE5vKelPBUXwZrF6rQgrKRzfA7PMdiYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hh1A8KIOHwWq20U1175NS4dR6Nptj7ZHXju+FmnYNgQ=;
 b=PfANvEPYKV2SJEb1TdaLoq2hLM6k8GV88Pg9X/cVpJR0FPURivCr7Mg2ofPJEvrlGKv6fXgPPo63DjoTexAtLJ7DnE19jyofBkO08JU+exwcAAUTGzQLCeejANQQQd7nZTligAHpRPJXaghFOihIlbq++Ic90713I7VVly0l20tCMjx2wuWVtFYD2cXY4blQ9TVTNouE8M9C2CrVtgPHDVaeZZ5AT7dwV1aaEVRIwcC0LM9wQwrDqImVtehIcFbkiMc0Fe4bimv0mAnKAadLvYTDc0uo23emxElVPlGW6DJwbb9EkJhoz6DwDS0DJcGj1ANa5P3bz6crw6LcvlIcQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hh1A8KIOHwWq20U1175NS4dR6Nptj7ZHXju+FmnYNgQ=;
 b=sbfppNJGYCaGNvMN4i3nIIITiAYFyKOkn3p+cCvuaaNvBISyxJkwOqoaqrXxGUpDGX90AJgYh7K6uy5z5imTbMRvJOFH2Rvsyra7KsY0kdR1ZbsmkmNtmIeuMRkGQ3mdr7NvmVjXlq5FhNRMYoZG/9t41oCmcBF+0VshyLLqe6U=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6252.namprd10.prod.outlook.com (2603:10b6:510:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:37:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:37:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFT 4/6] scsi: scsi_debug: Call sdebug_q_cmd_complete() from sdebug_blk_mq_poll_iter()
Date: Thu, 13 Nov 2025 13:36:43 +0000
Message-ID: <20251113133645.2898748-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd63ae9-910a-49ca-2e8d-08de22b9b9df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7o8IJyun4Y46TtO91xXgJhmRM4b3JZlc1b2rwcQRJh5yR0LJrRCfwCG3FvyI?=
 =?us-ascii?Q?sjAbfxVmXuRJMXLrQczhBfJE9V5qze9FXKz8Y03oLbzLKs8Azfhselc6dR3F?=
 =?us-ascii?Q?YdC8+bfGitqMyKN5RQzxDtZPLmQayZbgI0EVMZsSrr6Zu8C9yKfNYieBja3z?=
 =?us-ascii?Q?2ApYsqPs1Hip0whRqpNo7XSyOt9yRHBeJ+UTA34Qt0rmD40eArUdD1lo/usQ?=
 =?us-ascii?Q?Btv0zJnT2DylysZ/UwMT0I2xuL8vwvfjl7gae4pfmkk9hDjmC4VIm2S6IqqC?=
 =?us-ascii?Q?jyLpofdYI+PH5ujX7GvJL6WUrKzEPUi48R5Cw8lf38Au2NjJEhvlQSZwq2Aw?=
 =?us-ascii?Q?KCqgpwn6VZQdSd8KE7oXHvbMooLz9JG62IrTA1BNW9LJTISU5jQ6q2ZNIMqO?=
 =?us-ascii?Q?zXNv7CtupVv9DVIQXAX9a87DwmunzpssZiUUe+d1W+2ZbmfRen10h1t/qf1k?=
 =?us-ascii?Q?Vdel4dhBgXLwPiLD2Y0iA8qZjm69X4HCJ7un4VHn6RpERlZepJ3E5Ijxl45t?=
 =?us-ascii?Q?1M2WrYnk0COuf39MSYdWMv8sAYmgUseQmIvBUaKN1wCcNKqsrti+n21izH5L?=
 =?us-ascii?Q?wAN5454OKQGh6D10//0tPHlrfXgt9szOkDRvYricMwst2WUo2EjpamG9ddxm?=
 =?us-ascii?Q?XdsX9weATbuQEpre0/e9h8Jb9OL4YFScSLFs6/Xme512dtWrOlCj9y+fkA42?=
 =?us-ascii?Q?ZwaFVpZR77mfFYVf1GoOd1WFurpxg+GkPkY9VeRNs7Ko1jq+mw/EQlRjbFKv?=
 =?us-ascii?Q?izHTiMRt85M8U5EqAiPuloBgJK4iK6FSOrCpTvSrR9UkROFPAUvDOMbcm9kw?=
 =?us-ascii?Q?cyKr5C47ybZBH0+IbP0c91wrx5D7zTthrLLlO6y9krmZfjqXULP5IJmlYZdI?=
 =?us-ascii?Q?baZzijGxwjalkpwqFlmGuWstzP111V4oeTrH4SWU9/15Z0mlbKZQ9M5fmd7W?=
 =?us-ascii?Q?SiBxO0+PU7+5NKks8xCkNw/qpwnXTL2kjc5s/htTQinbOR2Yvl/E8uMIPxGt?=
 =?us-ascii?Q?1CGCnDScovEeEpHECA4Z1smgp+dkd/OcAsNOOGtlVgaVdF8oxEbWItAIRnjv?=
 =?us-ascii?Q?QKKxYeYjijY5Gx+C/ji613ABcEh7aZEw5QMvOkEmNMVYh6Qs5mc4/NAgWfSv?=
 =?us-ascii?Q?ZfRryX54tq8X7hkiff44g4CbQXojQvapAe4OaQRB7GloxB6sHHIT6kqtr5sQ?=
 =?us-ascii?Q?+ZiVp23HDLuiCMTUPLcQkOqmts/gs0SjsZhOQkF6CyGMyYz0g4ag9VJs/FWV?=
 =?us-ascii?Q?J5s5/P/AAcvF2HGpwA4vAIE1JHtoSS8loUUGg94qdAumzna/JrzBlxhPZRiL?=
 =?us-ascii?Q?Zd56fiiQxP+fW0utmLOy1zdbAfIS4GT3/a+4gg1t6l+IJKfZcy3UB6e0tz7F?=
 =?us-ascii?Q?CSnYst8ct4Je9d6lf8AMlWwYAPo1pqpZUrVh5l3rEHILFy1cNyjK5Z+ew3Sz?=
 =?us-ascii?Q?SJM6iV6p/bTyN24jNCiM8QOq5dJYXsWD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mMwOF9BfhAj2y7VBNZeHGirvyrRupAAMF/X8fm8ZBEGsstahULXrwZwSO+gs?=
 =?us-ascii?Q?Ivv1+ONpDp10+RzaZgQrNV3n4xNQa7d6trxm96auXrCDNSTbGw3XDWJv0vhO?=
 =?us-ascii?Q?xsq+8ino7ge5DZTxFjwuyYlstCCVf5a+KRXi9P6BsHIuL/fmLLckwRQxJpEN?=
 =?us-ascii?Q?5lsiTX4qLn2d9Ici0qGGpCIkeX2yay+yH5mwouDUfWvPFmBPxdl5tFd8cpcR?=
 =?us-ascii?Q?CMMPtL3WBYk2GEPwY/dw8rlZ0YLY3jhDQpuUvrFTcDsJPlM395InetJwacG1?=
 =?us-ascii?Q?PTiF1BrHqz15qCVj85yEav6anakyBZ0KOL0z/4/ATQvJlSsvl5EmsQHFvEdx?=
 =?us-ascii?Q?vSxKbF+eNelK5Fwgj3D6XliTTwOJjXDdXpmUxWW8/KtmY09+1V64N2fnz8AM?=
 =?us-ascii?Q?/nkW6emXn40hfRlJfMbj6d2HO2SN64Nw8iwaW/ikhRH0Du+Elg3n85E7aoc3?=
 =?us-ascii?Q?z+6kum17GZJ9acG7OAiOu2m3v4J+9qgVX1tY1+jNzShwj1KoPqnPKClUmK4t?=
 =?us-ascii?Q?wT76e0jh+BCBUluksVogFa2WYcKwxgYBpj492BTJWFtxGcUIUhAFidWWZTZJ?=
 =?us-ascii?Q?klCJad65RJxLZqlfJLHrhlb1oZ6p97KsCZ/bz6fdfjqhMWJZZzihbVvHy9j+?=
 =?us-ascii?Q?MYMm5rL3SVQcN9M5bzYAZLSNjOL3jBT6ql7/LzHpxvco1G/MNZAsTDhJlMp6?=
 =?us-ascii?Q?wQwmzDztFmbqPmWtRNCNNtcGwD3a4ImCp1KxAbwCcGocr9lgiznGDmWigiUz?=
 =?us-ascii?Q?eBFDqK78XBwbhcB3YJO3Kwq69vXjG5W+ClCbbyTYjIXojy4Y3aI0/EKLS3IZ?=
 =?us-ascii?Q?Z970f46IdiTP3oAImpWd+vKuCXSAs2foc/u3giqfJ+xM6OJaQSnXWbb9lDRh?=
 =?us-ascii?Q?iwP4FoinS1zX2UfyctIuwwj6u6HNzF0m4jNNN6k0ymqkuweQ61WkMh4Sli8e?=
 =?us-ascii?Q?DEE1aG/Bb/dsvuZ1Zm6WpigOPmGWuf+sXJ2EwDcDMprbPCuFCVLOB9OLuOcP?=
 =?us-ascii?Q?6mUysJ+ieHFqqGWo3aALbrrk9+RVsWL7iCuH/be13O0OWsK2DQX7plB0GWo5?=
 =?us-ascii?Q?QNkUHei8Hz+mlvtXy9hrDNxWCY2tCN8mOu01mUo5UwJcjVUufAr6DNsFaUxc?=
 =?us-ascii?Q?R+dq6r2naj+iaqBXiemaHu37aA3l0SsFjqEA4E+V/NMR3CLUUtQg8aGUubeP?=
 =?us-ascii?Q?k9q0F8ZOGyeIrlsIdbSHrK5aI8MccSLERXPvfH+KDZrGQqJwBBK+IpMHpRSq?=
 =?us-ascii?Q?MCQFvqU1p6yW0/CuMVRjhzhi5fa8XgAWkZ/ylMup7Bk0XhFfyy4IuoZW2o+q?=
 =?us-ascii?Q?QwJYkkOxdHd+pXO+Oe1Uzn/RpCzu7GuzAgFMVKf4iMLHCoZCNOjdZ9UaTxyR?=
 =?us-ascii?Q?gICF0QFytLdk5c3aFe6AyWH1YBIgeTjueBSgDeIubbv5UZRfY5J1QBcu/QYZ?=
 =?us-ascii?Q?Ur6taNQN/EvWOb9mTsRA/uWPQOxAXn++AknO2RPgQymCbTgqRugZCPUbikXa?=
 =?us-ascii?Q?ES0LiTzopemYKB+GuITjncZeZgpXds/yvKga/04HCq+2XgsVvs8oOGl/Uwsw?=
 =?us-ascii?Q?xkWVSSR+oToW0XjNlvxqLzGgpA8HFNN9wGp83lXa4Ieoe4955/EZsONuWJjw?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	elVvXYqb9ATYhyCqRT43fYe8m2/vH5fK8jTHoaAxSjnZvkscfi+hZBJPHGDCDGrxlMdZiBEEFm6kpNJ5UZvTjpz2YrUuBOmj/MdVs8ZGIv/qSWjiVMAhzO6ScsOkLUsHsbhY+EfKFLDYHtuc3o0qfQ0S7mTnQOOAKspyUAjzC3u0jtocwGA5A9hu06UCxoJW7dVp1XuTHcNXNYc305FIbl/lSH+h9cZLMcZ4XVG+5ZVEo6yVM0V1eeOYzGMkA2diVEXljTn3zEE/D7Y5gVDrqbxs1G8875B/yQaBmCRvVON+r5QTOpBwa0pcNT3QzfV7+Dv+oj2/bsraPaBqSvJAxUc78ECBHeGGpmpSY7e1vFBaa4Jw8eamYOzaHI97czbHCDbn2k4GqfGqktWdmyKY15EMCLj6rGU5sG5+E3IJRn3T4pXRcY9PlIr7KLZ8n0T8W3xIAbykAA3NgaldsXgF/KQSLJ76Q3fVnWwfepcR/74KCCD3/VH9W1L8S99xlLjiBLIuQCZb27DmkdmUZ76V6+wIBiHOV4Y2lA5GxQ8KxWvAsv6/lQT1Lw+NHFm7HQr6c4v7+NDLj7XgjkrOs9kOm9Z81/ICbVNRN0OHEJwI3W0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd63ae9-910a-49ca-2e8d-08de22b9b9df
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:37:01.7707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Y8nOtWo0IPX3GZez5Cs/XKRbJXE5wHiEG+NJiCQ3P7iC7oKf+el8COyV/z1byeeWDjN1yMiUBUxU1fbqhzL9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130103
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=6915df01 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=SerWHMupLtA1yOfQQ0cA:9 cc=ntf awl=host:13634
X-Proofpoint-GUID: 83n0Fz_Py8yqk6vOP8lFg3_saVpl8ZF0
X-Proofpoint-ORIG-GUID: 83n0Fz_Py8yqk6vOP8lFg3_saVpl8ZF0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX6obHKnB77/cd
 SUZVKBcxzLxHdre80no76OHQ9aQNLIi6qWh0QXFrVGZfDIiZE6XFTE6eWNxzyNEUWSNpP7lPXcd
 ulrQx/6wqib8xWH1xfzxN9vx0zKOtm1VWzfg33K+HcmctuHiECnVn9bj7w4v4frUPDG/Ivw8ZXn
 U+0uGPzEKOOZH6SHvtV4K/Wj+7+GH8eIg7TXylEidHZzLeJdxcv6qHexGBJGS2eziWCckpHvTK2
 m3AHIdyA3THZcckt9h1GC0pAdG1ly0LHUIVtqIq4UA0nUXsaskebhsEY7WR18L9WycpMBtb8FvK
 x2nYlcPhk9incVW70qCW6sPew6NFo0LzytVi0DNBFHkJcFmG6q0h58aDxMn98H1Ofyg2t9gRjT7
 SwsRLG+WZCh6T9fgGXLJBzmynmoqsycr1QEgDWrGSTAGiRznvDE=

The poll iter calls scsi_done() directly instead of using the common
helper, sdebug_q_cmd_complete(). Change to use that helper.

Function sdebug_q_cmd_complete() also handles sd_dp->aborted being set,
which sdebug_blk_mq_poll_iter() was not doing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 25feb0fb898cf..093124c38d28f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9121,13 +9121,8 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 	}
 	spin_unlock_irqrestore(&sdsc->lock, flags);
 
-	if (sdebug_statistics) {
-		atomic_inc(&sdebug_completions);
-		if (raw_smp_processor_id() != sd_dp->issuing_cpu)
-			atomic_inc(&sdebug_miss_cpus);
-	}
+	sdebug_q_cmd_complete(sd_dp);
 
-	scsi_done(cmd); /* callback to mid level */
 	(*data->num_entries)++;
 	return true;
 }
-- 
2.43.5

