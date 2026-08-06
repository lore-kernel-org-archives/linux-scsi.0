Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70704D2ED3
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044908; cv=fail; b=KDZJnkDmzYIFSUODk0ktldtFwAiFXNgUtJYG/sg3tYuGLc3iXPwzThWXi5lnbOB2g0AxrTS94YPOZl0CNsH9o99/KDKXs9R5F6oq0QSkyIw55sk5PACIiK7PksGfRGl+8IBnAvDBzOjwhleK1GHeclAlILrlprRsr5EZe9mnu4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044908; c=relaxed/simple;
	bh=JvlhupnizprX/VTSe7XwkATpOaROgo0k0SAegGF0Nw4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ATqWQKcH7RjBPQysSRmHqw/yMsHI2advjrVRkEIHa9A8Uip3NOMn5+09JN+cjSktCsdPcMbFV6jfrsoTk6wTvMr6C2jW8iEReZINDChZjzzlU5aBnXP4Vlg7LKXgldaoK7yEqO3wIupOWueM2bMjTpZbY7qk9GNpMCYUQSfcqjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NBGTqYIH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CBpCctsi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBGTqYIH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CBpCctsi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FubkA3081878;
	Thu, 6 Aug 2026 19:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aorqheqKhu5AeeoxMw
	deKV1zsg+PtZP8380+QtYjhEs=; b=NBGTqYIH7dCmZadMq6kqtKwIwLstrGzJ0t
	gDc1my4jDm6etCp+qH7McApy2Ig0DszoLO2ob+r/e9Q5WgNCpwfREo2Vuefr3r3r
	xOReiSUBCofneb2SguoDcpAzDygzSj1SXCnK76IGW1XUTgvvjczEb0HByeg+twz5
	4JXFD1pZigwuAIc2YtIxsqS6/rgWRjalj+xtzSLxqNTKISYbLvUvOK4fibKt/jgT
	ROpc3Yiyi5GGG5dD5opb2CrDxpaHm9eFW9sCJvgCLt/W1+dlYJrHrSpyjuYDCuvH
	zEZDiv+V0EHH+Zn3Nh5UIVSWrHBgQ7NgPYmWyGnDx0O/XnQ5ovAw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cyeuc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:34:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676JPZsT033405;
	Thu, 6 Aug 2026 19:34:57 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w60hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 19:34:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t16FF5M9dq6zfZNKpzAqyP7c/adC395xIXhqvyjXE3orGsgwVYkuluXX9C1QKLNDJIHWoA84fHKIgU2KZDvMtGQCYvZgkNU7j1uRLHt3CG6Ysh5GfcywbwxR81it+ju4rsLow5QEfFxds0Dt6d14PmNIASulwA3hlibj/0K0jmpfJjWLAcOqjUXvYzUuog84K0++yBmyvU6j1nNlOClGbq3L0VtA5avTtZgLVCD3wHXsBczQtxHOPgXYsft2doU5dD9c6OxXnnNP6y3dzzB34hkizG0F1VmmEk6CXv8JQ4FcrKwhCk59O6quKSAsrOj7fCR5ftmaPQxXnIF0fw/yCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aorqheqKhu5AeeoxMwdeKV1zsg+PtZP8380+QtYjhEs=;
 b=ZiAA0ZvqeAUzSJpfg398RAcamXN00SypP+LKo4QseWta1/uO0VDn/XLQwxGrmrekWz+PHiGo44jtqQtDfzMHb/HN985Ax10DcfLXj47HguyxqorhpKorMVUrpAS8RmlGTYU3jH6GVwIsK4mNfACYqLI//p71ad/e7TBcgqVhequjpWZToX5rCeFV46k4ZMHvFPCJDnrcEgVDjOSgLbfs6GEzUsqJzkcw/o8nZJeRR/tV2c+nr4uhgriQUP1juLHKBdNsqYwwNQE/B3We8mXPw9uUzhi7SHJrGtv4dDDeYOH6tAo6ZoiNycegD8Fu8bJRw1dfUNeQLf0mpjo6CrrTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aorqheqKhu5AeeoxMwdeKV1zsg+PtZP8380+QtYjhEs=;
 b=CBpCctsi87IHvnRKUCkZdftKTQbsjjd0aq8+kvSd+EcVNx0xYiWax0OqpZlQOHZ5hLJnVyQOkZbWcv9z+EcAGNcpL8mdhvZRyfpUqCsaDVV7CfB4vhZGO/AhtjqxgU4huWnq6mdJZOnQ6X2OeZTrjAnmFI+Qz+5c3CmfNO7EOfs=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 BN0PR10MB4901.namprd10.prod.outlook.com (2603:10b6:408:126::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Thu, 6 Aug
 2026 19:34:49 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%4]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 19:34:49 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, Li Qiang <liqiang01@kylinos.cn>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/6] scsi: ufs: Fix descriptor parsing and invalid
 input handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <25919cf5-2e3a-4baf-a362-748d40f956a7@acm.org> (Bart Van Assche's
	message of "Tue, 4 Aug 2026 21:59:11 -0700")
Message-ID: <yq1wlu33v9u.fsf@ca-mkp.ca.oracle.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	<20260717153914.26321-1-liqiang01@kylinos.cn>
	<25919cf5-2e3a-4baf-a362-748d40f956a7@acm.org>
Date: Thu, 06 Aug 2026 15:34:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::10) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|BN0PR10MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: 12530bf3-2d08-4e06-fbb5-08def3f1c73b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	k4hqUciBYEa+nqHhzgv0zIYONFdSMuiGb+QkS45KHMkxpPU+fkcAETA6fgTCxG3AbG0NmG3v6ZVe2N7E8+dXDGrGTE1cNRGqsVTEGD/bn0zDoiPftEIJopCDGkf3PrjXH6n2gL6qg2TSB4MPHwgLeRoWHhcgy0LRmru/XTXRwPh2PMF0Fm3JMaeS0cIk/ISNMVbtAjNSLi2oRb/Dzba4kRG4eebq1TG68GQYslqwVe3tUDOC70izC9oCeaaqfNoNlG82Bblywq3pB4bXHUDx7NH3o6/bXruXvL1QCVzk2xRg9iE6hgJCp140j9K1HBRyRCf94pf8M+eKxlzmG/NFLlPvoKMJfu8coz+56+PzIznFYZG+VU6GGT52yYVUlHwJdhLsa16hsKNfiFrbNaIfYvl/toldIJRRaVJeHLu216flkYKb7hvRyQfjk6Wkgv2LxxTX5vqssMqC7TLAcSUtdJ205huyhIy5xSOrNblQZYEyTJKbzlXePJvr2lYSw3xXYKhLL7qTHgoKGu/SWvjTJu7U3EpeD2lv6ZmDmf4SgYNs0fSlqikmHyQiVFow7U80kyUhBJ+7RPfTbEz0QS6er4yEZV0CetiUHB+mcKhw8zLZRYYu44+rAFNCs6i8FKPZiRNI6ykdYhxKz72RUr2bG7ChMvjsO82C2NMzAqzzv38=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LM3bj4FdnNgkmm7UeXxzAXhVoDg6PnrqOVIVJV9A/ehoDrsZksAI9+RY9keA?=
 =?us-ascii?Q?uXoqMCzeusK4HPY4DFzHF2EG+3gMMkHf8Kyk+THhy/7Bj4jEIEx7+q6qCduv?=
 =?us-ascii?Q?622Po6RDQ/fFeFqTH2bpHvEtOeAj42/wPoz7+AdMpPQKmeoR85LMloYmgn5u?=
 =?us-ascii?Q?pCgzcJpC0L/WUzf8c0XNI5AEiXGcnI2CL6HQu5XkKxfShVn/zZobgYDuTyZR?=
 =?us-ascii?Q?iobvr0bz4YEppqOZ8b6RmXr3yj8ctLeXoAVpMkC8cuhEBQ6f6h28gn5nNk2q?=
 =?us-ascii?Q?BiyGorgKUUyMvlAdsZYTsu72YpMEoI6oXsUvHPVeFMtG39iSzUXd1VkWfGmV?=
 =?us-ascii?Q?KD9KtvTO/B0R5v9zie2M54Lky1B8uiadCRKXywMciXfV/Awk6UG0nXRfjibZ?=
 =?us-ascii?Q?V1Dt/Oa5QeL410IxCj6U+gOBBrIcnag9cGvNS2biLpst0O3D4G9m7ImUQjKF?=
 =?us-ascii?Q?JT68/CqrI5nJ4JLEUTjHafyXPKUDQVx3GRHXdI4sZAaVviQxnlSLAv3PbDEj?=
 =?us-ascii?Q?4qsYDyWAxopkXP6h7wHS4Xxmbs0SOgSQysRxXBlK+H/YdwPgfJQrNOZNT0nD?=
 =?us-ascii?Q?beqw4i5qo/Bsq35VkTcaOIumP3zodbSDpxb7LBxjEp3PcyVuhgjCslNtC6S+?=
 =?us-ascii?Q?IiCK7Pj4+WAC9QwtLhAv/NRKxaiJRE1GGvw6D5tOpRlZWNTJOxfwBWRz6EWy?=
 =?us-ascii?Q?BTXOjJQqT06aS+XO2xvbukUSMAt7gDahPn8XFxYXvlkCxpLbrV7cSW7BGyoL?=
 =?us-ascii?Q?yI7EQ/SGRu0t7OxPzLT5FGlydvM+JbNRsZ2aF73rE+BL5n6eFvcoaeNBFU+y?=
 =?us-ascii?Q?IEQe9hWXJM5raIuGWtXhsGs381oqmTu/W2ckoMnbs3Fy6xKUHkzRjssQTBoc?=
 =?us-ascii?Q?eeJw1yCPGyUvoBOT8anbZHNv5FUCwQgJAhTC8EEPpP7n9zDlQ9F/KDyyXKnm?=
 =?us-ascii?Q?86lbgtW7ndAh5jO/BrzisfF9+yqDmHJmd2BJp5961ujpwF/YWnSKJwLrluf0?=
 =?us-ascii?Q?NznnCY2mXpSDJhjlSWQmiNSric6YbMB6OVZdJUERjw/tmLkE9YiwGafOVXYO?=
 =?us-ascii?Q?5IL+rAUTvIqj3X+UVNVSbfERIH/n52EikwbDXPbpfLbYdnTPW0vRZVxulIe3?=
 =?us-ascii?Q?+GWSlUMOW8IQsWc8z5KtgZNATMocotO8DPADpkRoDqTakg3ij5nTpezxSDYl?=
 =?us-ascii?Q?IFkRL8zY+Z62CQsinz4qerLk1R3uJGPg754xGPNVVbl2J4PJblN3ewTYXDe4?=
 =?us-ascii?Q?PMTxvWpRjNRqHfKZIoj1afmIFiOpsGBy2lhKkk7MH2sUkeKz+CU/fqo2p7QX?=
 =?us-ascii?Q?MOWvYrO1t7/M6A6dOna8Obc56sXwOGJ288zSVECSQFtnaIijeDwy5bv5m1EV?=
 =?us-ascii?Q?9dbiKvZZhPJGd0U6yl+8E3KxNOrIQddOB15NesxLAigrOV/vfSW5ETbJU65j?=
 =?us-ascii?Q?avTKuV7TKqIlKWMSeO62SjGTx+xygB1nbzonwuO7HtpuzwS8z7MAIElb7FDW?=
 =?us-ascii?Q?dox7Jp5vpe6Sj1to7Y8FjJnuCJN0BVfNY8r3gPWqEbN//IypeeAyj4/iEF+l?=
 =?us-ascii?Q?9Zxw0NBEmvsqtS+j1U0xGGvX7nZ6MWGHKozgefFjpaMe8n/F6CKK6un/HRll?=
 =?us-ascii?Q?AOmjB9GcPGtLN4WTAYXcZ5M3g2N2uO+EpRBRxu+O5JkxG+zP6nJ8VqC4s23a?=
 =?us-ascii?Q?iORy2DU7aguEsUdJXe2QvhaZEowBOiJGthKthBcaZ6oYTbmNSUiEZOePc1Pj?=
 =?us-ascii?Q?7wbR5eWdFmK7WhyLJ4i6Eg3qw9ZxOKk=3D?=
X-Exchange-RoutingPolicyChecked:
	I5v1gRdvh7hP7ipbOQ7FmgRReZZ+OJMKSP7e6Mtujkazu1iFQqkiNrzH3K4m1reVlI3x3LvvcOuQt7b3GUmqZB/EC73XPeSeKI9+I0fUdv34M6VVsZ1bJet2v7pGml88tV6JpLamrv787ktdirOGyH5KO4pHGP0+CKBhq42LWxzjGfaPNqBPAUvmzwji1x8TTad4GQxi7ZxJJLvp7MTsfIbaFNY3/kCvMmruaogc8ykQjQG/qw36blEjuneSFwzknfvZX4kVWDhROZsAXL+4Gq4RsD6iR0xsjDHaAU3yyI6JemxApg3I5QXi8icXOqhlBCGJrBInnflu/EmQt015QQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4qPzIq/DjnFXgvJldnJOGibkRIL7XOdG8qEi99MB4lLpM+ycpgUPAdgEsafDYozE3YrjQZpHb2L4/NP1mXHKAJfasniC9w430d/iIYpESw/ylGGMd05JR/TqAAomkShlVGyVJWKb8/NRsFvTsJ0xpuN9CoQTic7EJvErV6mBIWUaWYBmINl+J9lcPyPGmWsrQLg4R/Jx2KLT9DBTTG4/4fRELzouGBxYxTQhVudTI08pGwh6QieVVq+F8NwiPphcNpuYH+TtkZbKSfFCLQ6UQ5h1M7ahlGtP48TEnAlgvoMigI/eOFWi1901M1BktuHIlb0nX3LP3Eh1xrhvvRSA7jpMOW3ao48V2fAJpo/sbhEccI+b2Djvpwvbq6lNHo9BkMbZhJVXs5orgMsGAWsgIGSF+7gXSKJyr99k2g8pj6KENRFvEzZHR0Yq2k9550xv0PfopSzv+XtcdUJAqWj7r66YwJrBOmYlR+h64M4gkIydvy9KX9auIxrY19hxN8NHI7WrXFWmliVFthqkOC3GqWv+rNfqooz7zuYbqDPp30yoEVyDMapzufpx5YzI82dSqpg+WW98O6yHHs+S9F/8LGkNXdn27e3x7iKV17aXLPo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12530bf3-2d08-4e06-fbb5-08def3f1c73b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:34:48.9977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5Ns9JAIk3qO6VGL1JysWthAaP6jjaKjSHTLxWFir0X9QMro153Wl2a7FvgeifuWuU9e+ZxMwT4D/7BxvE90eWoAVx1axoR/hjbUuHCI7Ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4901
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=558 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060152
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE1MyBTYWx0ZWRfX6CZzs/Lrkn9A
 wC2GfNH9pOpEroUoVCMbMnIbxGHZRgv8NcktjUZSo/I0hY9rw+VVr35JqQR1bcbihr4TRWXNc83
 bBvzXOn+myT5Q7peIT/udz6mPTRssAvvDJLapsHJKe+qz9EmE1yf
X-Proofpoint-ORIG-GUID: 4b40ZcK9qss0-FwJywuFjhyKn2pUpBd6
X-Proofpoint-GUID: 4b40ZcK9qss0-FwJywuFjhyKn2pUpBd6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE1MyBTYWx0ZWRfX/jaA++IaUyFK
 Dcmtqb6OM0MNBwIG5xWxzHaj0RreWD9arNEdRTwAzQ2k+RlkukWZIZG7w7ep2om2Zp1Psi/Jz/u
 RhZtglMU+uoqWhhHw9UCUwd0q6BI9Wtb9sXyMgvuI+doV/VV+fBp7prYWLg1R7FWqJH/oYm1xaP
 ASp1bZ2gZgpuAVNvjEJXBG7Og7Qx2AcBUSmd1ND8oj/cdXiWEpfSohtd3rcxTIJvm7FuD69adX+
 DTLlL0OJWFREfXNiXpIB5G1kxCGGZqXZsA/sYanxtebGgSldTAQIqUb4iEsP+T2nDT901eCYiNU
 ZFz+B1WgcYSVSIwXFU8Gzuoia1HdR7MnUAOCBpCrMmCJiS2sByVhv7FGmdYEI3i69/UeRQ1NTwq
 IqzOeTXtyNm2NjIBjg3e2RlmN8sTQtuZVgi8MHiAI1isfoQagrvxCfDIEhwPwCyVAUfyog3lDeP
 v1dVS1Cc2cwEZXOM6RYXLR48u8eG6eNAermSo0oQ=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a74e1e2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=xnfHQpDgT-4peQc-a34A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510


Hi Bart!

> Can you please take a look at this patch series? Patch 1/6 has already
> been backported to an internal Android kernel 6.18 development branch
> because it fixes a buffer overflow we ran into on an emulator
> environment.

I had already merged this series but must have missed it during one of
the many Sashiko-compelled rebases this cycle. Now re-merged into
7.3/scsi-staging.

Thanks!

-- 
Martin K. Petersen
