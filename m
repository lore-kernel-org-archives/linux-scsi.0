Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBD73F823C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 08:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723231; cv=fail; b=lIWKJCxOKS8NFDYYi/O3Ynzg17VbcSHizjZX4Bm+PUIYQxJZ+y0Z777PTnY7VQzU/zgXwIoXReDIAXZnTmDMwWGlOpF1wD51pwhYsmcC1kEBB7qeLB5pq6q3N7qISKZ4RozpKVYNXRyVLLQ7mPIB4aDloDMLAGwUO12xC0f3cwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723231; c=relaxed/simple;
	bh=d4Zim3qWvfKoYvnva8bNYKsG21BiiL9o47njeUWfgpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nx2p8Y4O2EAfHMc3zALbZoBzZseFCPc7oHsU3PPbQMlpSpxVWqPVM+Ff2PaSVaTy/Afv1nYpmZf+DgQ4DZ/FrRCrxmmz0SsR2d3qP9HiEcBZ7yYFaZMO6t4JH1A/7osuWKQblWVpBAFPVsYqHlm+JXc3/DYZhT3szWFJvIOc4n4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f0Hhzsv1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iO8qiJ5o; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f0Hhzsv1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iO8qiJ5o"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T018UQ544223;
	Mon, 29 Jun 2026 08:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kjtZgou/QQ/kiYq56PzK024tAGr4LEMFt6UifdXuMwQ=; b=
	f0Hhzsv1Tl7RkZhblR1ypKtCRhIARBylUp390J4IriqqK6VaBE8OtIct1AzHTE6j
	PIipXc45foUIcWojzEJd7qhDTpxZzybgE8RxRSmUC2IrRqfSZN4B6ZFUYpM4TDEx
	0IRm7n5IT++MhbIW8EbrDjeSeZoGohX6H3tOU+9PejPVRkvTKWi8MkaRjmzUpiTF
	+nSgzE0kg6MR/KlKqQLpkOztJKuwjM1pKOACa6W9EXtf+xFJ5M9G1x39UsdwGNc8
	X2xaxZf+5GG2BfvqR9z0KCvJNbUXz5u0gZtmNIVKZv91/180D70ru9AgRO/gXtUW
	9EPqf+cVScB74FW6BUKY4A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qhs58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65T8m9Pp007227;
	Mon, 29 Jun 2026 08:53:37 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24ycv533-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2YbpR8F9Zf6goP2xEmaJhWvCFtD3PfBz6nIWmjYv9KsM2lJqpkJ85kdF48z9rl7x8jeIn/jS3WqQIliipCfkZg7/rxmk/7f0CrUjungFLTe1W40GBGGPAVtb+eRN9SRBA5wOnygHnkxOYfg38Gty7Zjqkp3ojpZZa4H/5LYczmZpT5oVyA6bBEys4Ey8fpDomi9VZQ5op0ctGYZeMtHx7n9FsS8L1wJCKg04Yc+HNFj7u09xfg5xogOjY0yCUTCyb+g/4Q2/eKmfBb7o2PqIlHJLtyV/WuIYtTF5XoRfD7zPTlxRNqKNaThSWgj9CPs+F/FQ4qdRo/sqPDxF/OBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjtZgou/QQ/kiYq56PzK024tAGr4LEMFt6UifdXuMwQ=;
 b=NUCSB2CLYSBrK0Y/Mi0NXUMNrR89EhnfJF8tgFs4XooBpYPZtfPB6tSZQ17w6r60l+cNeo5oSkCo/glSOvMBJUauigppN4+60T2NYQy+ukJdVWhluTpNkgZZrMxOgj2CuFLMpWCabF0OyfnsY2KEebnAyVpUbB6u3fhntKhBn7PEtx04qH3qD68iFQqwVLqtk+BSYr9miKecvUeZotMzk4s2YtB9aOD2lAC7dgR2Y7yAmeP+rOkYo9xAtbIQa9LAThEYSen2pU55t4dWTY8D8leokgakiPX3E2AMJRw46lFdinVFAKElrZgEKaIdCKpFpBHoJXQdcgoZiI9o3X1Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjtZgou/QQ/kiYq56PzK024tAGr4LEMFt6UifdXuMwQ=;
 b=iO8qiJ5oCsR1NwcO8Fwy8XD6Zptcmv2sLufZJDaeJzNtZAUsDfa05LHoGITLjvTcqyzJUGxlNO3I15Y/sHkW8s+4Ali6Kh2lz/NvXzX9cj9qTSLl4c9FB98T4EofKVuWsu4o4TxwqQPgIqKvzx6VTBAyuD0udTZWRdEeTx8qdmI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.19; Mon, 29 Jun 2026 08:53:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 08:53:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
        ionut.nechita@windriver.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0 for no DMA capability
Date: Mon, 29 Jun 2026 08:53:09 +0000
Message-ID: <20260629085310.2298552-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260629085310.2298552-1-john.g.garry@oracle.com>
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 618808dd-1884-475b-74be-08ded5bbe71b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	t1/vr75BAntTzy8rnGN7dCWmfSbfP0baFkCybHya21dSo9rxVe+2vj+pt7eXOy/io7txuRtEEJdbIgNoEmJX/FZsG1r7JlX+osLGh4Z+p8DJ/MlQAbj6RPmFaqe7tmLl8Jbe+wiY4ua9PHgrXrbooOk+xLNQkdiYQ4ooW1xYQ3U/RjicsbBxf+5aTeWX7Ul1QICiOghOD+zybV6kCNTKWYf/Q72zzsZUs4tFWKoPo1ODqUXJ+of/jypUisJy3o4yj1BRDKNqcXqsrxsNmw09yghpxSbNLErE+YlEHpGGJl3nXQJNxkf2uGDZ3FwvxeOh7kXRcimteHzqdd0T182ouqCbYMqAnSXiaxLas1b7Yz8bxWLe59HN91PcXBybef8M7MtwZpPoWrhvL/Eshk4GNOJlKUFlkmBtPcr69Zj4XYdj1ijj4k+Qphi9QlE/ukZF8IWTJkV9ux+TVryrylB3JRx625EmiwCd6NB7in5pwfe9DLjQhWvAzB0f2i7ap+ukUR5aJZvJYKhQzWSDQx4G3zE2wO3f299ON9ub2BbKOcwD7k18XFrEiwWCxWFnc+NqgFzrt/5UHQsMuCggWEKsmxvjZgnTD7Z6d3gcQ7puPxa87rP/S9hU/lS/4Xh8l2Al0nesMnYV5vgHLwHPJ5Hu7P5z9kPGMEz8ri49FqftiSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eLWDD+34h267DHWXh91QMW4n7BGD61SNaxd4ldzfFvxt+WvVylBVRt852nM5?=
 =?us-ascii?Q?hL06U5MNNyIOTAbqA256TZM/JcKpjrTVT2Xi3Y8Lsniaxx+FeDKygYxtEJEt?=
 =?us-ascii?Q?srMmh3JxtM19lDB6nI+AS9KWliS8J7uk4Mp0lxPIAQicFnaOsH3fzfhQ3G+Y?=
 =?us-ascii?Q?GGgnHtuIB1OrtSD1gjDDq5ZYMrTyjMwMH7e4e/La3oNjDpn/IaaovYQ0H7L1?=
 =?us-ascii?Q?Qo4djvl8BNn2vvKCYYExUHJryH/xUphJgsdpnqiYvFGshnM/5l9N9a2BAIMQ?=
 =?us-ascii?Q?ec9UPb9H88ILVkNdiFt5tDSvRmGIw53XEu0+uWXqA+l9tlaDyg10ubnIhacJ?=
 =?us-ascii?Q?9Db8Y46GGLNC0wP0qtBGJGHeEBncC73wn0jkiTFcc8iM5NKL6HsjhbaaB+qx?=
 =?us-ascii?Q?rPZI8C7+jPKZd4GOdIxOjapp6EyOX8h92yLhctK8y3qBieGyh7QOFOSme6B6?=
 =?us-ascii?Q?lEXFDyvU8PzaUAUeKvhdCohormsk/kIXuikAEEGyim+EcioAw+0zTkUKkjXF?=
 =?us-ascii?Q?WDuEoTJbLE2IUWGiHUfn4QFU7r8trDKxYGjMf6qwi2EIY/60ThiyYgl8ewEH?=
 =?us-ascii?Q?C3gUQ2Ea4vJpRPWHv5hfwOwMl7FrsWnu8+NEPnLKVWgLDfK7D84HWx1TZtQK?=
 =?us-ascii?Q?0sRWvT2dOE2KfFvKyp5i85I+N2hTr53/bo9NMxn2KyYRI5Jch2jiKLw5/3QM?=
 =?us-ascii?Q?8aWaTz3ZIwhv0WTNYREya67j3EVdsgLX22x0kXbsbMYjhV4bY5bWiUoaOq1J?=
 =?us-ascii?Q?8sKQg+jsLhYEwn8mxsdrKjQFb+E3FHUaIDS4+VVDHjkJ25PIAW5ipR56ZizX?=
 =?us-ascii?Q?Juk6MstL2eRURqW1CSv7cZEtmoizIjGZrBMO7FJzdOCjlB1rqsXFWjlye+r1?=
 =?us-ascii?Q?HjzgUPMEOa8icHaG60cBZj+XnPRvaKgGIolz6J0PXjNBtYQBqxO6n63UyM9U?=
 =?us-ascii?Q?bQF8/JB3XQVIQmsnA4147gA28egw9EZcrLy87Te3nl7k0MGHJ/67gjVPC/Am?=
 =?us-ascii?Q?2uzCU9qL7dV1foUz0C4vFJlSTF66Uvz2l+4wdsJ4t1B+k3c9KmoLAsJ866J6?=
 =?us-ascii?Q?OEQkmTdV42V/ntbVAPjqyIkZx/jFjdsogwoEiB5+tQjJUg1lQzWB9QXDeF8e?=
 =?us-ascii?Q?TPJ04BDJnVEQz3xJ7DOyktIiUxil90AUzfwioQpt3gQ61f+rjGJn0y7RpTXi?=
 =?us-ascii?Q?spp4AVlOMSx7TvxpDog6TAtdezA36g5fUOacgMMR/92D7TF4x4iw+2MVaxJB?=
 =?us-ascii?Q?tVmftB/aEnlwr/4mjShEFjF64v/rasNY8jjamIoumk8HEIQjsO2xjTgCco5a?=
 =?us-ascii?Q?TkQU/16ICAZePsAW2wbknGS0zqyCIPzlPvJ6ZgPPhzCpgVTGuv+2BlOT70fP?=
 =?us-ascii?Q?3hIssUQu1AesTJwsKGCL0hgGnwMKaDgLqNLJn+LCX6/ea7YqULBbSGE1DytM?=
 =?us-ascii?Q?Y7bck968ZM1mWYyI+cCMIwbJfKtjhJ7itf/ZzR/8EEexg9YI6RB6altei/w1?=
 =?us-ascii?Q?gBwrSZzJs1xX4FEcn269UPcbtgKnBFfO7HdCUUDe9ysRq68vxwYOTAUAUvrC?=
 =?us-ascii?Q?v5XsE7uwKexuF3EZBQqCcqh6JOFlJhqzqvXEcHmmuplBr9WqsNHa6E70fXix?=
 =?us-ascii?Q?CzRvOQGlMTQ0ArUMJV4bJ2WnMvAr0S7/xNavcCdDBva+fi4HyV0lsmOs/tLf?=
 =?us-ascii?Q?9AZ5l7j+z6bSaRvcqA16t2Nhwiaz8FiriGeuzT0HFRc5I/RZuLnuoUWjlPbX?=
 =?us-ascii?Q?jtRtZ4iVuQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	ERYtcFArWHG3S8rxDTDd1astFOjLbiLPMR1R9YXU3Qf1QAHh2ii3IH7u7wtpE17OQFIHPKVYYra2V/NWI+pLmtSWh8u1Mgj4xeoSmKw0hMsBdJnkv7oSv1HgkgSqjKWoOOWspPcSDGXkh0pwVs5OLiYHJpIHn0+zShpntu2v5TUGV0ivu7bblnORFXblmCwBiUgIYDADypbEkHSpuS0Xq2VT8WTLbgiu1XEWm+9utoH2mcjVCWU3xHkP26gDEkskUXE0LMc9zRR1zrw8pPSYgg3JO+WQtdNnPPf3MQdKYmLStw6UfsD3RlGGykj3TNPeIYZdmTmWsG2L8XN7/k7MVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fU2staN298y0YYqlgwI0rrf6gCS6OXpXYbQTxlk55Ke1zhBAPERLIhut1pGDjEd9lpcRZHpNg7CdRUlVnQ8OIoEUS1yRB1+JzrwlBT2e0P6m9pgoNCZ5nOQ6ZEpYLOxz3e2KC1AeVFRmC20teNe1FDmvfqFzM6GaMYrP4F6RQHS2SOv18+KKE7qd45FtHV5R+Mcq1w4/lzfADOcOxv0/j9949+rW3ZlsHPgRzROwO5tvBHUyg4RGCrY5I+gZrIZb4TTRc2J1fL6WblTarBjHi0boSNOKOd8g5Bv/yFJ3+LlgdYLmMqgab3m8rztb2oifXEhos4Ok5B8+lFT469hpemhdqMZqBA0qpmMZ/uf6I5P9KENrAq/bzcqYh99zIsIL4qUiv5Z94U/3SBYMZ7RmDh6FAKxBXwkc4HpzybwhWgSSvL0FC5zMcWzYZT1DYo38DLPSAbStTDg8F2i33IzrQCGKcrQRs1NiyAwe17sEPJsAjBaRv5mowPhDYFFgBFOv+fQw1+QWkfin7PhmcKjPWxIAo7LGgnQLOlYInAfeB1fHE91kaJq9O2YRLLHWZaZSBeT194mGvXaEBY6bcSNIq+6DsskzCbSEUoto8lCeVDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618808dd-1884-475b-74be-08ded5bbe71b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:53:34.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OoGJishbC59xOoevIlTq/sRWUZR9wFI96s0QClM25zP/8YqmxE8CfzCy+KXPOEHuE35zkdsUTP/s7TfiW7Gw3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606290070
X-Proofpoint-ORIG-GUID: 4klh1sh_QdftltfJhE1Ci_2fOpolQoqY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfX1v3SButssBPo
 Y1RaGcy1I5CsPZm4wNXcTRW6TOR7eCiy0YGJ76+d6loXLdhFMGp37AWhIyusvJkuKv2AjVzdqNx
 BWqxtm/TTl9/yEm5NZGbkg1MHJWHqUN7bfA6Z/1P40ffS9wiKjiLuwnK25xW5rSIrHMoxi9/azZ
 zmiM7ZYfluInrISCFLs/NFDU6Cr6DglgadB2xZdkD4cpch4j/CAo5IzVT3aXEQdfiHvpqQxu0Ed
 OsnInDHTR0hVUQgEqpFGLcZ44xSRonhBTYLrIf8qN1Vym2WaaqU1+ukb1Y9w2g77lE/HwV4VLOo
 XG+AfRyUP6wt16KVrBLOSGsUq/FB3epijgc6BXpeKMljzlRyeWUKg4nM//o/w7WFOfOquhl9IRV
 VolekEbsiKXO5OUMYv/y0Vkm2Ndp0LG0j4WGD563Qpi/H+wzw8RvZRAkdwKqTYwpGy6uADQjFxi
 Wbw3EPwtJvXHTItd+aw==
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a423291 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=FZgC7P5AKXK6f97ZDNkA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: 4klh1sh_QdftltfJhE1Ci_2fOpolQoqY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfXygw4cHCXXYLo
 fXYKpeXiYhByQ5V0nKcNlryPKoApMU9bVKXa6FtGsyKO6+S2bSvo/JAAJAq1hUhVaMbrTo7E9Kx
 IznTUtgPvUuyb6byIPa4XVdconDLgNcZy7TXJMWmiasUHz/9e5sW

For when a device is not DMA capable, the max mapping size would be 0, so
make dma_max_mapping_size() reflect that.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 kernel/dma/mapping.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 4fe04669e5e66..7e576e5c6b8be 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -979,6 +979,9 @@ size_t dma_max_mapping_size(struct device *dev)
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	size_t size = SIZE_MAX;
 
+	if (!dev->dma_mask)
+		return 0;
+
 	if (dma_map_direct(dev, ops))
 		size = dma_direct_max_mapping_size(dev);
 	else if (use_dma_iommu(dev))
-- 
2.43.7

