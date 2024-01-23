Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825D12BF34
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969359; cv=fail; b=AqjxBf2fgfeNKf0m1Qld64Dv5nNYM7IPdki8xwcc4/6X3kcqDWe8Z7LPmPR6lqEnFLXk9wG/5lQE5Hb2Nv+WeyWw0GJmhXR8eYtw9k3rJWGGasTQhr/TZXJoi4WxvH4LSHrJ+ZknBgzdjk7LsOa4IrHjZyM8/Byvuq5TuvGwZAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969359; c=relaxed/simple;
	bh=7dGxnMr4qhPcoaO0o+QE9HK69br35JRuY/cvFWUhUTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AJiaTu4Vv0yJPu985BsbrXYo7ovFTG71phQo63k1CO60kCl5n9ZhHFq1m7o3US27lwKUAw1UoX5udKH63E6uD5+t8DwIjaH6WUK75NILUlEYCmWinDpKSsvLQ9ewE0xcUZ3QvjWc43FNSv0Us6Y5pSKSkYMK9aeaWzehXPQX5UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M6xs44K/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GYxkDm6S; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M6xs44K/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GYxkDm6S"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMolZi004027;
	Tue, 23 Jan 2024 00:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=xIzVfUi1mtGZoxWxdY70LpgatEyNAeAKA3gvZz3w5R4=;
 b=M6xs44K/CwM/y6SU6Gs6Z+QuybHrH3KSLxBS5ZIiO+jJvH28D90hBtz7DwgqK446Cz70
 2NPBUYraH+GpkQQukl3drgi9UDCRL4av3tTgQKBet1OgPdoK/vzUcnysbucNj2eB0Ebt
 pjfLfo4wnjzTX81QtaX3DaoWCr43/gSwOHkmBipi9tjDQYvxbV71BDAqOXKqEH19cfvE
 ETSNW6p/TaeP6cVYaGf/1+fTrLlAnSfdKTlehDcLvvibUhLlxjtVK5TmxDC2cf8yg82B
 R54B2Oi9Vt9+qLegZ/RzujXG8UfbvZ7ya0SXIrSQ6EkP0Vv/wp7pLhrM8HeKNuPAlwtx Xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cxvw4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMluSu025289;
	Tue, 23 Jan 2024 00:22:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34k6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2PLA9q3PRYhytpM9UD6obY/MlHu86SNFSb7vyi8FqI6MX1MgUiMP1bsN87UOWIs1LuVpZLZWe/tc7jmVoi7Zydc6BaSGFURnegBBBg6t1DYpkWXmZ55kGnkbcJ6CsXuAZUBsZzSgcKIx9jtsBb9QpC64jQ4vo+5Nzy4yC7P3b1vE6k+PzdaoRWOenqI9bMyf8wB1GGhiOHaM0vu/1AfLzNcJ4PtxGgT33P0nbezNGxY/wosYsnQzsEdMDctnYaiwEQOSlWQNYCg5+8UUIz+NXZ4AYplrMcN+3MvDOatFmNBP843KRNP279r7NMhUnWwYH0s1rEVnQZNUARoczW+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIzVfUi1mtGZoxWxdY70LpgatEyNAeAKA3gvZz3w5R4=;
 b=QmPFbqyxVc9TscxF6wjX4bUJ/oaLr15fcz2QlD1iREAGsPZ4bRdMzaWpO77zJtTJlBSRIznIjj4O0Jw/fnLMagfaV8aoKKzzZt9Z7dFkwfnPNyDUJMloHVq6Ngmkla3IE8rMYt9xhhhRZIHFkMomRycENYewdVmuN/3WChxyD0dtOi3XIJFzxkZ4fwB+vv4/54hRK3HwytO3U1FptwpMOomiO84eJLs8kJbg2l2sYEy6/gPngSvQYMBDsdwUvRF39ncE2wbGk4lLON1zWeomBmhn4OozA+Cbilm1wLiasneFh28qhWMcRGHJcIZs47m1X+4b+q0G63WOYxBGDzd7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIzVfUi1mtGZoxWxdY70LpgatEyNAeAKA3gvZz3w5R4=;
 b=GYxkDm6S3G88Ft9vVPdk7SgzQ6vFKw7Sfc67D31N3yJ4evH2gLji3E+V5tmdEkwWbytHs2DKQhjOk/ysficNHeFMsSL2eHQCtBw+PUj0HGCACRPuMTODageAqvh9SQAqc8HeNZOTm32PqpTUNiH5v61v8K8OSZsOoZ2VZGrkS7s=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 23 Jan
 2024 00:22:29 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:28 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 03/19] scsi: retry INQUIRY after timeout
Date: Mon, 22 Jan 2024 18:22:04 -0600
Message-Id: <20240123002220.129141-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f486b79-21fb-44e2-af9c-08dc1ba96172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vSxRSWoaPqgK9WT1o/tn8ru3ESF9glsJTse70pUy21ilEDxSLAkDxfzLn+LF9b7QDo2xGMcCMpoxI6BpZPzovNvZS23Qe1zksAIQQA8+HK4MhGWLhh1vCY5jp2hAIKfmJFZxUxzbi7G8DCajWes8u2AMyeRka0sa+NxFbEsC9SjTLRK4RM3iOFZNc19f59HOM4XpnVAcH8VO3r1h3gyTDmWsfLYCAOJWvPJxPBI5KSwzy/GoYLfobZXX968qjnvU9AFwBrz4WcATETvKkyMoI/IDwsP92Kp9cSWPQoJbVtQHOm/n4nNXC/Nk1j2c6lgsUZqgyBwUl+FYk9UEEO+VR+OtuVfYpQeMt4lfgLBwQ/KgF/4JbE3wGzSYylUZoaWKvu/3OxdbaPU/yVpt/eAr4KEnCFTTpP5GDLo2nBBQc4FMhRjdqVhpKUqI1iCe7rsU//OP+C7jVWoLTHIFdPIJXqEP6NRftgRbO/6cOF6BKJy7UljeQbjTCvIE+N7eBmRGubTzPPTH7gpp8xYz3UC/GiZzwU5EfIk2l4jbqxZ3Df2g9BY45bCMt+X+sjDQMEkObhj7hwkSeYwNQ1vUChKe4MlCMlalMFyWDlYvmAHu3kXaDV50gVs/Yx7KG5g92pL5
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(3613699003)(36756003)(86362001)(83380400001)(1076003)(26005)(107886003)(2616005)(316002)(8676002)(66946007)(66556008)(6666004)(8936002)(66476007)(6486002)(6512007)(6506007)(478600001)(5660300002)(2906002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?frsd3ymbgPYckS+XffiAlRhuLMKeuv5Z+Ok4gWY2pv7mYwwfkS60Q4nLeQw3?=
 =?us-ascii?Q?l+W7bALFEzQY3U1VXhae7XIaEFKhgv+FQ37KT5/4Dn07scqjL/yBtOnAmt5U?=
 =?us-ascii?Q?fbrxd9etbJqZUny8JdTJIbgujNpBCyiQNtmqAmx/DCNhmJxZc9qWOc2PHSXZ?=
 =?us-ascii?Q?tVgvhfIl5Mmr0aM+RyYLjoG9mDNXsdAFONsdI/V/T8sF68S3gOgOnAdUAqHY?=
 =?us-ascii?Q?ef3/y+fUVLteZfD/MFAud/KR7dOUxilOop3WhF4q3AclB9rTRb0GVlZTPILF?=
 =?us-ascii?Q?JAqL3p5Wq/4ryzOcDWQgDHiqyvYhdzYcJJAiKtswHvUUiU9LG5NGHT7rmxEr?=
 =?us-ascii?Q?RcTmpH9mOhbNsNXLem0M3LoW5tXD4iuoBoO1v7Wmw8FH2nfk9/G5hrFNlJyF?=
 =?us-ascii?Q?jETM9MBSQLGXMxOkbQmRoGg4UoIlgtePSN9BV7Ggw6ScxzdCS+HGNuzW3Gsn?=
 =?us-ascii?Q?hEd0/BJ15BUb82laL/sZ2elTz+tD1jpcNI2pThG0Gyd6vbhaI+3iQrEM8BLX?=
 =?us-ascii?Q?ITdEZjCt1T9tpqlxjj5TJzVysfhWuEXVZ75PbRKYEXUWcUofUFHGoP0f6ISk?=
 =?us-ascii?Q?Aistu13/LkGjhrz7N2OEGnoMzxUqkxVnXH58B696jopxvHlcpiWN4s8vikts?=
 =?us-ascii?Q?mJMXwoxnplSnbfh/MfaPtRmJ6PSPp4pImm2Gr/HEjE7JX+pJfnksonMJGQhI?=
 =?us-ascii?Q?CLLHit15ETF/CG88JOusM5z0BlPA1U27VaQ7CEHQARWOdsjtKVibSQMMiBRF?=
 =?us-ascii?Q?3jwtnoz09Rm7QjHNkJeSRtIdBjlFHtTzi6KvkbdoSO4yAn869Bkh7Y0pqD9g?=
 =?us-ascii?Q?Bm1YmlJ62GLfhc86//+34yssmiPRai+wiQM3VrSyfafvfPOejnoCoFF5WdDd?=
 =?us-ascii?Q?/1FojG2vhe/B8ggiTK6TiNShGKB9qmIeMlwTMOdyRMIvnUzx/BIXpgzU+VkT?=
 =?us-ascii?Q?YE2doTEdVuexIfw+O6xbBoQbnz8vEWqF7B1Qi/j46Q0VfInj5sNqcL4bfJEX?=
 =?us-ascii?Q?2Lqk+XFnlbeDxu4EkzogeFWvUhOzcODxVqNydlMPm1fiQlTa+Ramiz+80CIq?=
 =?us-ascii?Q?8GH+/TJ+EFHBD8KmeHC0edCW82Mzfp37PON/ZjkcfYxXUd0YqRGZl7WDbDFH?=
 =?us-ascii?Q?kvEbtKV0SLUAJTXQVC4BYMBvPPCvs82trQL/XQEydJFdqCTwD3IzolnQfVaf?=
 =?us-ascii?Q?DAWQBWnL95WjTGBpDCUChdZ1gcsGyCSfGZelkDve4RIhOlQjzodDzsfaUBxF?=
 =?us-ascii?Q?G0tjA0RddqQ8xOqcd5x48IPmJuVnuHgkfPGfZ4cWQ1kYOoC/O8+xyNjufd8t?=
 =?us-ascii?Q?9NPLsTdAGnhi3HDUpO0fPc4z01wfHHDgnzExCOH+QFMC7a43VuV/+rRr/Bjo?=
 =?us-ascii?Q?l1+PUiyo3cMF3oNpM9/QyQL/v0ARPXKevg9ejTGjQo6xLt9d64NvTV7FUPhb?=
 =?us-ascii?Q?zgHJxMSPopVD3Ojt4p2aeeczQRGKx2lP/z4UBasgsvevYhV0B8RC81qTHAja?=
 =?us-ascii?Q?PHGX/s4uyKt21TZFJcgsEky/dZ45/FOqEKLetb4FwJM/yDBnhviE0FW5LGJu?=
 =?us-ascii?Q?YuZmCdQ1wD2TE629HzM69QyAF0qDMgLN0KRENjsaZg0pMl6JKRYLzHyt/7yh?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MMYC1myS4Ssqt0Z4Se2W6rrY0ZDz0tQugAnlPYnEyhSay2pFxVB2i8qnXfPOTvsShP+n6IrcEwYkdkFauMidR8bd9FHx8dKQVBHJ3L1EGZITXRn1LTUWjvXkJgASQLELLNxtX8cMCe6OxD7G7c0u4x3eoO+WAu+ua2rweaGFODqTxa5Df0O2iWigVWy22M77GRNyBO27rR3lMmVYAFOPxvY7QaluIVFpjHrJ+PEeK5SwewyaOUwnslRiy93aZSNRRpFweLcIqH08RbqmcGRPz9GDS03f3DtmWIKLstt/USS1O8RDCwa3N7Cbq57BKF4/9hf+EuIrR7/Tad7c867SowMsAtCt7zYS/+VjRBcrLDFQTvanBTtDQCmT9dFOWZ1O2Cr5ZFBVhZytcs1gncwynd0RYTiPqR6/30wnmbDYw2wdhaEGd12lJ6K3pCw2Y6dGbH0/MLMIIBToVDDzAoaXccVUX1eRoWI5yBEjpel/JwtGAVtAzn2PmhZY+QkJlIBfG/z/lqsrUloqlhjLCWqLMd5noxxZLsk5c0jearcKVdXg778kSftUJH4tL8wM8gbUPk/2ZZbuaTY7sOtGHSx6xcuio7tzUwurJBOfvPvpGRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f486b79-21fb-44e2-af9c-08dc1ba96172
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:27.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rJFEJbaBc55tYq0/JlvXEnZJB9u28EixCfGb/b2JjgTj0qLLvo4TkOMIYyRjgJGIJxnOjr5z1qeDL8H5MP34lupebR4zo/Nmv00XBYyYbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: 9RLQwoFJ50QGvb4LYdrs8npWAMg9xwA_
X-Proofpoint-GUID: 9RLQwoFJ50QGvb4LYdrs8npWAMg9xwA_

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a2bed0dbf996..8ded08f37337 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{}
 	};
 	struct scsi_failures failures = {
-- 
2.34.1

