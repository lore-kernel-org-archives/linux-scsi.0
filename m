Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7692F226D02
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761209759; cv=fail; b=NTjxPHBDRz4zg/NMpq4UJ9MHFh6z4WDEIn+En5beKyht4T2oQ5/6iIYFkNhwolSLJHq5WWTxGiucx7GSsxAOIpV8JKQ+4/V5yBbPmP0wDaD2nZwp5gfnaxXmzzJFE83wycP+1ixAZOkuK72DZ2fdc5UqZZaQd8/AgH73mXXg13A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761209759; c=relaxed/simple;
	bh=BBoQI1D2XwHPEIYPPZkInnW/2O1ZnorDED1llwx3v6g=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qWUd72gVr48BxdGQNjbcN0yxKCgLHFRCHioc7JGiaWEFWyrWVsjPVcjc4VyYKtj7mV/3uL6GQJeQQ43LKS31zGCwZUX5DAgLiGexoTAozQAes+0y0Fqe/gctw0RqYVaNhxMtDOV0IZbVlefX6CgyKDvVu3ZAdnxLTvAR/jnRFwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WocqIysd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TkXCxTA6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WocqIysd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TkXCxTA6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7uNmh008403;
	Thu, 23 Oct 2025 08:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=hcpWVDHGFmlGga4K
	bFwOAnYyHQ6SVqIZ6t5NoMejNW8=; b=WocqIysdiTzU2mm+QuXJw7QRR4zG+m4t
	9eXOwIGpKMlO+1EDpv2gi9pdHYJUy+JCYdPFRlXKpMGzl/zl5LNHpRn7VTs555aU
	9E/Zr/Gg8Wwy8+tbfv9c2rOvldMKLSXvWeQ1Uo+UXDg3vlJXnJ8rSvprWe7x0262
	RYiXvmTzy/gpDdB1jw0N0FObwjrer6dkfhf1BV7Lqql7kBVUZApinvYT3sLXoI/h
	cyDOrh4J8buV93wqJ7arw/GZSbwv1isT7lF42K+jbHFOdPLToFWogac3MkctVnFz
	jJbRtXbVZdE8WMTpOG8USXjtrgv5jYJeuZhlGyJJYbWZFVYQG8AsKg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vw1b8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:55:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7rREJ012681;
	Thu, 23 Oct 2025 08:55:43 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1behsd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:55:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fgwoe17Z2dXJjjeg+p3DMiAE9men5g2V655wOrbsUKal2ArU/J4a8b7x1pitPeXMQU9qp59QKDgM5fErBbapEIw5NN1ZF/A+DWQjA78SMfSJ6o9MHahVgx60+xPOyk+px0eIhuQ5+3sP1WvP3Fwy0DffnGrS1ZgGZYyzz6Qb72h2oiUdX6kbWwcepY7s+B/IEN0zLy/7LyMgZInSHd/v4jigMH+z7DZ+Dy+y/9DQBpGiseuXWDDi17oxuujl7o6PDk6X9AUuCnWAj0Qr1LUYqg27lhh2a0cEP6XDtBrqxQg5Hbr1qlAhlhnayDiTXeQe8W8XxhBN0wUMy6u29KaK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcpWVDHGFmlGga4KbFwOAnYyHQ6SVqIZ6t5NoMejNW8=;
 b=xir5rfPQpyFtYLpiaKZLzkpCYu8Diw4uknisNihDSR6phVPXgYLgcZ0MlJUnvcorDLXE0VxHaC3Y9yNg2cLASh8x++us871t3oxvcf2vcT5zYRT4zO6ayZBiuEtE/rAA0pR3oJzQgoo36mACeMnLAOBf4KSSU9qGoceNUntvfhtxQU1gyTtKc37fBbfVxAx906wLM0KKxk7FbHduY4A9yTFH8RyIt41oJo+vOuoR6UuOmcRs5/mTfOUQkLS84b2V1gg/qdh4Ca0JcgZucVUdLmA/RZHin77xvycZHMj8nIuPXZ2TDdsgXaIviD+kW3mG2b5a/DCpi9QnVtSJ81RXrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcpWVDHGFmlGga4KbFwOAnYyHQ6SVqIZ6t5NoMejNW8=;
 b=TkXCxTA64HXejkUzzd5rzDnT0ZebRPRfqRNY+g5Poo/MxS6JgUToJaz/ruqBvnZ4Hd9FPcPSO7GXwPCM9nOGoUoT51r/BUo8hyfsMcwCflI/2JFcv25KKowktMCxopieMjX7cfnTO0VduyqRq50q1UK42uyddElHuhS7WFyo2d0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA3PR10MB7096.namprd10.prod.outlook.com (2603:10b6:806:306::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 08:55:39 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 08:55:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        willy@infradead.org, hare@suse.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, ming.lei@redhat.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: advansys: Don't call asc_prt_scsi_host() -> scsi_host_busy()
Date: Thu, 23 Oct 2025 08:54:51 +0000
Message-ID: <20251023085451.3933666-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA3PR10MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d4f80d-3eb5-47a8-0198-08de1211f03f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kIqKGMDQ9sp+FVwor/WOrNBNlo28cGU+1yb7nuAjESSLviVCsWHLLDiIdbKr?=
 =?us-ascii?Q?vNHF0C9unOC1CXgZmXl1uPMdOkOyOuwmpe8m2kEyykT6qSsGwY4Hy+2FKieE?=
 =?us-ascii?Q?YYBxOe7oQgKkB+iz5WgeYKSfaryuoCKVax23Kll4DROvnOiTUgPpC/jCZIoo?=
 =?us-ascii?Q?wNIbM82ziPg84WbKqtVl9LqvL9E8nfTsunkg1Oy6oTLGx+fjuY6fVnZnLD3T?=
 =?us-ascii?Q?WAJTVgZthPNrIs6ksOGk7fIzaDKe6Uw81dhRUKGfN5qaQK5e6JI9WE1hTynm?=
 =?us-ascii?Q?A/1wOK7QCrgJI2XKsYu29iJKt/luDy8cxypX4v+h+tIbudSvQBKs2d+U5vQS?=
 =?us-ascii?Q?kNq1suc3FTd1PNVfR0x/nnCRWVu7zKcRPKu7Pdq++dyp3ujRWgtw1yC6+JGU?=
 =?us-ascii?Q?ER60q1/f9oqSpQYRb5eeYm+wUacrpauWxUOrjJpSEDm0VzIhsEvNYc+fcKmf?=
 =?us-ascii?Q?tSFZr/U5o784IB3oIzOutKyEnISK/QATn+OUlxyIVtpG7EAtIYjpnUaMjJxO?=
 =?us-ascii?Q?sngGgVTceRndDF4mmUHB/uGP3OaWQ5YwjkChxbLUwGa56SCu7WapnkudbInh?=
 =?us-ascii?Q?qyHB+tnIYfeUjFWF7MwoxRuKjiV1qkFE2yOdr++/9E/gSdsC0pG64TsgmxMi?=
 =?us-ascii?Q?ADOVjb1NRh9zE0b/zMYhyGmDUpQlHSrnf/RU8GcAuXKOfNK9W5BHH+U1wjh5?=
 =?us-ascii?Q?Pn/t1tXLUxeAB+oFZWT1hEBD9gxhJ1w2vnsYYgMIQBLUi/il1QPd2oydo73W?=
 =?us-ascii?Q?wQlyyf+urP80a3ambFKdy5RlzklrYEa6Pu4J2w6lIZc1rYAF3Edl4lMv6szT?=
 =?us-ascii?Q?vbRANwt84b1BmdTvzqNy4Nrsv3nn+eq4zUITUr6C+BB2hlCCaMc2XuTWweDj?=
 =?us-ascii?Q?Or7wLZaBazACpT4lZB7qpA4wv5IDPVegxQriidi34w6Dj2nB3hb+h9keyX7n?=
 =?us-ascii?Q?0NRcpGFN6j3P5XnMj45WmmSf/GUDx4S3K2YMAWQJr2V5F/nmaZkOlY/OlS5x?=
 =?us-ascii?Q?hNbMIsTf/eRPem+uSVejy+trsZRAj/mPNilJd7UY2iDstPNbRrOKSCKE1AUm?=
 =?us-ascii?Q?0UtfX47gxt4qVysoC+HhxkE1G/oSU9xXRWSQPnY+cDCiLfeWSMwQUvGooxVS?=
 =?us-ascii?Q?WGTXW88slRm8miWwThiO7psOWAqbT0dGly7nB/6HCbsOgKEUZP6KKAQYDuSw?=
 =?us-ascii?Q?GXhfYp6TdKSqL8ApBDDyOcNP2Wrl8R39Psx+EdzrY5JgoxC1VL5ecEqIUslI?=
 =?us-ascii?Q?mF0uSl0c+KJjSroGDOiuw49/qoSLYf6gSmXWBHjCPlvBWvJnJSlIMhGSrV/Q?=
 =?us-ascii?Q?bbRXz5cpMCNO03X91UYFbOoKW6OQoVdFFzs5A7ADNGPQoXCG6mBq2pm4XgXh?=
 =?us-ascii?Q?Sec/mRMmrSI/MS3GDEPmd4dSDxTmCc9j9JsV0aMlE4cSk59qGxWwnXwv3CGt?=
 =?us-ascii?Q?Kr77gdDYAWucb9BTN7yyb80jVCUZO5ePywt+tiX5MZn79V+d/cO32Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t9/qvsr2HgBHfwgAyBb5LxJRAFoHam4+fINL7FEZb2bX3Qam1lIkJWWUw8pR?=
 =?us-ascii?Q?FfJbHWaU2Lvtn9tL5duExzOokUd8UiY0eMOTKY+8wbjkEySIGOl/hClWEsma?=
 =?us-ascii?Q?8N47RPZvU2De38T3lEHMLuBXOn8KqSkGOH0P914zODyq/PyxuVK/zjqguws4?=
 =?us-ascii?Q?UpO7aIg6h4pVaTO6PiJbjRYBYWyGZROe404eao7QNTMWbQl/K3/riZfljMA9?=
 =?us-ascii?Q?BVZzTUM2nGTVo7ZqTzdk36E657zQevgLBfJ1sIHR6OTvzdLCInV2Ptan3wCy?=
 =?us-ascii?Q?RnuuldQqPUP3Zdn3epY37rlyhUDuUh9bOEFEyxHhqK+mV3YCFMyzwQbXQ834?=
 =?us-ascii?Q?F33IcW6OzO6tgRNlPWd9DIvrlCRU2Plxfrz8kl3DgfbhCiwKMCrDI8dLXzYb?=
 =?us-ascii?Q?6v+9Ns4079tXzpeGw1HGDbbZiixizWPxiBrRcsHMNIvAXSe/uP1RZ6GthZWm?=
 =?us-ascii?Q?hFFdZ3OBngnfX6oTQtgQQ6HFzm9MSsXQZNF3uUiuxCCxSVhdDsrDQcZkeyJ1?=
 =?us-ascii?Q?+IKcz76QIAwzPHLNlgVA/fqKH7+ueeuLYvGACLjAQleKnKMcEA6zByXSEwMg?=
 =?us-ascii?Q?O8Ll6WYph0POj7Un8JVc8RbYqq9BN2SylQpQzZ3EfPj+HhhmtONkqPSdYkbc?=
 =?us-ascii?Q?3uv2cYzD4j0PXahfE+DAj4va2p6IHzBxUUWKweh5b9Ja8aH8V+7DYvPR924o?=
 =?us-ascii?Q?kQkMzv9C9drft6u+y4efKFb2THFrZE1kkjpAkfOqqaEg5Z7aFwW4aHJiz+FP?=
 =?us-ascii?Q?SR+k3O5xyjzD4lALZF50yrUmTpHp4PqiGNoOEiH2/kjCOvbrnA8muPHCF49T?=
 =?us-ascii?Q?tuAqQja1nsq9l4ObG2L6bJPetKhNDv1uL83te4jfhlOKbg5CC493HfP48mU0?=
 =?us-ascii?Q?ABub8HUvu1GfDUr98SbGHeFTgfDzgSNHwm2QPXvX+nwCz0LjhBag7ahhWs1v?=
 =?us-ascii?Q?30Z+muy6/6zauXBxiHI2rlZPxAtRrcE7IEjgMIXdfpP0LAZ2oAs8YSkadhNX?=
 =?us-ascii?Q?+vfzqmKynVH6vH8OEedt1UKqcE04QL6SBaZ1vi9k9FwEd92MvfHi3/WaNIy3?=
 =?us-ascii?Q?TfjyEWfBE8z4HU5yitAnGo5kKR1JMksVc9P/1oQwTLqvm+uUdolr3OzY5F+o?=
 =?us-ascii?Q?jxKPgu+cTsWrpLUSl8qEE3Ktk6cqacOkjOLLHqEemsIWWlb7kOH+Kx3tuQ77?=
 =?us-ascii?Q?bqzjoV8wb8+BKmTKtT816JezxZAlfU1oPETUTrhEaLcNU8qzRKqzRoZvs6yj?=
 =?us-ascii?Q?cFMyaWiDlue7cPbp06k0lrr7D5GTiYBGaYThDQ41APm9Z4U7RgPsGoiRgOia?=
 =?us-ascii?Q?2cWR5D+O4XvJIHCRJNK/H6XqVZgKqeUDixqsnAQfxeU837glsHFTen8JaL/X?=
 =?us-ascii?Q?OTVMVJnJ4HEag8SUbsKObIclq+Vu2Z/YJ8H+o0j8DUcRW4TmwE7K2K3MDUMd?=
 =?us-ascii?Q?zycta8VxpB2SE1SCP7jSyiIBD2F2qX7cnHXfJzvHyz/Bh1YAQvB9kb0pycy1?=
 =?us-ascii?Q?HarkfrmVD/gf3QGOVPo28BJY7txR6Ir1Bb90diNAUY4159R3Cbx7YMh2PmQJ?=
 =?us-ascii?Q?KUqVodB2DIuMxoh1R4NvM871IzqG2aLgAS5W/4X0AjXQmbONp54zE9i04Xsm?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gXpjocnDynnrupKkqkkirS1L0cV1KfMd9QjWrzx/X2S4HLZKW96XBKhDcLcMf0sAcaCf7VPrI9ZREQB4vQ5chE40UiLZpaWsJtSe0W31Z0MG2WWMTxBLv8JOkgITtMhhng3WIDTWW7SHvhpA60a4ReVGp8onCnTN05+aad0umcUMq6SAbvo5bcONcBU7cbuuZY6rrSOOGYKg4UoNy1M8kw2LUwgDk2tBHiBh90HW6Gp/Voon18udAhGwgw5KETEISyi4IqIRnV1neYSRdgHSeQTD1Qv+8UXNxrmichNz+05P+BQdMgca6OTyiCFJsHY9gQSQgGACXaEOe2jfayCIQFgxL25n5cSvWBiHOafELevMrr2NPI9apEYnTa7M4t0xRhMbLEEO4SltZ66cZVtEFCUe6OmGT8FKWVufGtZYLz3Xb4aNWCDL3hzYFcoBpRHGHwF4ZmLlAqVsYaDd32EcLCfi0lADi9ejdpsiwOax5EmiggP0/F1ysksbx1x/XCEiA906OX0f5F3gM/KpXMBzZ1Kv+fcKM41Kl/b3wFiKTZili7dDAv/gxQaxJANfBm+GnBf07QuMp2XcBkzIs+wPtVnGM3gS8RWixdYLc3TUsFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d4f80d-3eb5-47a8-0198-08de1211f03f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 08:55:38.9187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTGSqknELZpjx76Zlt/da9Dvl12X1CWmBrHuKc1hBcPk6cuTWb9s7wWN2ye6DjxVHn7kIqUdenbjYbklUB/2JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510230079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX8xV/4M5DmJtZ
 DYL6Myo3dqkigyqJj83p/RDVUl7LxqEzw66mzC87K6qvyHrl5LW8Tf1HVr7Oxx4au7+fRAPKvC8
 u+bSxtQjGEtcyquAd0ChCCdnhKnA1LyOvqWWIX8GK0daRYd6j2liLD27M2nOPKj6PvH3S6/P546
 B1YGJx+E7uYamI1xVXeuNa4AkG4Ul1yvr7sbiQ3oEIy8vPFg/2LjmiCP9K9/pSLLob4h5+cc0Oi
 eCUVmWmJyxD1WMbFdpWOStnbvcuzZUw/2ijn8SQ1vIGAZSrDKyxmsmpq2LFu6qsZc9c5wVosjnB
 zwITlFWTnn9VX7LhOIFu/qvJ06rAY0prLMDnUctZoF7Pi0iM1n6oLdo1DiLAsJ1Mim+OKveBOjw
 IRcfxv6XJb4b8kRmW2QzDonOeKdA6g==
X-Proofpoint-ORIG-GUID: fvmbWfKO73ENbWi0pSiOsUvmDaOAQEp7
X-Proofpoint-GUID: fvmbWfKO73ENbWi0pSiOsUvmDaOAQEp7
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f9ed90 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=FFGeWHa8hMtwLphhqRYA:9 a=cPQSjfK2_nFv0Q5t_7PE:22

The driver calls asc_prt_scsi_host() -> scsi_host_busy() prior to
calling scsi_add_host(). This should not be done, and has raised issues for
other drivers, like [0].

Function asc_prt_scsi_host() only has a single callsite, as above, where
the shost busy count would always be 0.

Avoid printing the shost busy count to avoid this problem.

[0] https://lore.kernel.org/linux-scsi/20251014200118.3390839-3-bvanassche@acm.org/

Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 063e1b5818d34..06223b5ee6dae 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2401,8 +2401,7 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	struct asc_board *boardp = shost_priv(s);
 
 	printk("Scsi_Host at addr 0x%p, device %s\n", s, dev_name(boardp->dev));
-	printk(" host_busy %d, host_no %d,\n",
-	       scsi_host_busy(s), s->host_no);
+	printk(" host_no %d,\n", s->host_no);
 
 	printk(" base 0x%lx, io_port 0x%lx, irq %d,\n",
 	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
-- 
2.43.5

