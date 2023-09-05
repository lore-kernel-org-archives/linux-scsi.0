Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FE1CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbjIEXVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjIEXVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EED2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtXle023737;
        Tue, 5 Sep 2023 23:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=YUCRZJoLfc0wZenya+ki9LarBfioXi21pMCSyP3OYFo=;
 b=2TjPFf7vhOOnlAs5ojr5gvT0hGXY4Kiu0rSpVQrliwBVGZqBgDfB8Zt+wQaQ5yml1D4r
 RKo3n1f0GqD4PH2gDGN0oPZti6w6u91BmmXeA9oYZLZtV57ipqEW8rlv+iEtLXytcShg
 HHfYdNQXr1iYlXrwNGMqwScFttOWS4/T1exu3zj3g99VEbzsCddRdQQgsVcefQ4zB4qV
 QWHCyo9EZkDvjzyXrT6+dTsR9s9v+ML4uBv25mwNmwq/0SFww7FlCvqIGnpyjZi2eWBS
 XXQsu2027G9lblRm2US/mQTcD6CWZwXfUWZQ7IwAdMDgzTDtqP5LQLI07DGrtioTNn5A 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg81js-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LtOOo010429;
        Tue, 5 Sep 2023 23:16:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbp36k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTQ4MZAPU4zmQU2mBWLaw7+BI0lqmRwXKNus+gQjm9onBffRIpTSwGYNHImR2BFHVgybfOomBi4tR/+2ZOL46PngQw1LZzgnhfkKl4F45vCjhl64p2d0Fc6bQMvOs5UOhwrOHEK4MqpKACmam04nCP79Tm4BHtq78BH3SrB7aTEG24hdjvhtw32hnrvThHyx+TBsqX0IIv2WCLTAlrI16mbGcPOYTUAhhKOLTV+3rtPnKObFAjbLnzGmqmhmEj/bhPKLcB4KvykTQBMfisH15msruyMoCiQBIOQpODAeJsSzqvcIPqFXQA4RwdTzxeDuy8bC7z8UttoTCMOUK0uoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUCRZJoLfc0wZenya+ki9LarBfioXi21pMCSyP3OYFo=;
 b=F+Oy996V8LhZTeM69ONADmyLjt3jJdgw7wxNd5YnvYL21QtdQgh49peHl1bZPLGXUYh0ovOp/hQtbmnd7n5e0KOZZ/1zPk5b6FjCMjMl8Ty7maFDEGyqCv698Xz3iJfFwy58lyO78gMBfsJvULle19n+/16k+H2P9xg5M4aXCOKA3B890g08zDYieWAhAXP2+3ib2Xi+WkOYfmj0wc5KZYE2zwYs89g3PKvSlSghycit+Oop5vvx75AbkmgmRvtFtVHyIrKkET46Cj1WaHk7ejTmQykyEssMN6MxH4F94a3k2oUDrFOucccEpwup8g7Qj+x1uRgOq0eTw7FwRy2ZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUCRZJoLfc0wZenya+ki9LarBfioXi21pMCSyP3OYFo=;
 b=Q3g/yCFUOFLMzoRymMw9i7eVGnoL3TixcQ+EgSa8LPOZkNILLF50i5WSiQRqiIpsgBWP5dcKIZPuDIiIu++7JJE0uYaLXNKFULAsO/a8nn3VP7kuXbj5mpTmMuMKknsJQ27RiCyPl+hu+kscA9iFp8KPtZBI5s23+x5j41TAufs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 23/34] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Tue,  5 Sep 2023 18:15:36 -0500
Message-Id: <20230905231547.83945-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c9420a-33f2-4f47-c1b0-08dbae66248e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgtcREbrxD7e3Dnw31SlFrVoAKJZ+g26uReAY74nNbFwNDfm24+4FnBP5pFJyxmiew3lKBrAa+uBdN2KStMiDnSy5lt+CKHJFP9EbNFiltFgwHcaDtoaTQPdXsrgr6BIevbcrKeRRB+NVKOStuV5T1wabZpXxacY8UeQIKNMECfGU5DcyH/S2G5Y5aXzOVmZSxrFnFQM+nyki/Nh8sUFHBFqHa6Zlq70Pfl+qsb7sxwUCwauEKP+kHzpodgITRZh/RZUDbAQFiVJlxUNkPn8mEvcNmAcJRdClSJ2X2UNq7BEkZyY676a/x6D2/1qTMqNjw5I152npRWKTBZtE2BfUMLp4ZCE+jrJOrJPRWeGFAiLgo82qeNkcNOd++I66JOc8P176eRXD4ZY+qC+EI9HKfNq7nhtNn4mKiRsE5tEJ79xN1MnpNy6LggeoUGyF+Zm+3bycJdFkalO6j/983LQ5jjSSCbfX2RI3Ukmrvy5DN/NQ0u6kimBiIzCf4nmA0pHKamDONcNhdJacSr3wc+t4MAfUICfcLBhoo6T5kEtO1CbXo7BQV1pxR1NEcfJxo4B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iVTMr99Qm/WBBUTqeEBRm9kHd+4OiS7V6F1dqd9apYgXryrZR7cIkdfB+0bw?=
 =?us-ascii?Q?wfkduNnaamp3XDzouIN0EKiPoYCa/Ocih/l01EjWtnD7AeXhlMJwyrsk9aQH?=
 =?us-ascii?Q?qKUcF7MBR12jt+wKWpTXNDpzlwRdkf7tKv9SWr7DXlB9cd/brQzRtBFLOyXT?=
 =?us-ascii?Q?d3UNqLX+jlcSsUnXaRPJPGCayQeh/nDNdab+UF/a3BWHYE+qHzpmeOAPU7YQ?=
 =?us-ascii?Q?xLwx28X+TlghnGRV9COvPzHoZDv9Ca4g3cqcY3zUN7udKk7swOn1VnURuRzT?=
 =?us-ascii?Q?tIBtx8fqir9XuWpcU/MEv/C2XwdXx2uS4bHRMFHkR2fqHysNcZi3fy1BnEG6?=
 =?us-ascii?Q?97sjDj6zaPsPxSJ+05c9vmB9SJMZqTRrI+JgJdRmxzldUUWvF5qn1iyPtLRD?=
 =?us-ascii?Q?oozjI1AIVcd9x0PRS4bl6jEv97WUbtb4uReb9RIfYaIuOHI1DVAP0l2sgqO6?=
 =?us-ascii?Q?b862INPRbArhaID/QfXWtKrL5kD0SclcYp7ZaX+M7Ni47eLBzIcTec9r5pPs?=
 =?us-ascii?Q?9Ce4AmPZudQO6eho2VqyAMQiiiBImKEQCP0x/XdOMxagwQaFd4NVCgNJZbtZ?=
 =?us-ascii?Q?icMik/y0Uj1YXX2ly0OL6e0XlBmgt8jSLWAeAPLM3hiFWISfCqoblomlE/lJ?=
 =?us-ascii?Q?XaMae6wQBIw7DNbbZW+b7Dq6DNKrQsdtTAqHtDCKbszmS2ZYhTs2+jLRExS3?=
 =?us-ascii?Q?B2je/jL+0a8OMgBHHsD/cOXgzPLU8ndA4/e5tVXOVE5sFoThDz+XX3/mETI6?=
 =?us-ascii?Q?eBSyzWbfoIe06z/ZDXnjD7W044l8A95DcvFRNPlP/jT2siR5CFfJnS5qUAXJ?=
 =?us-ascii?Q?tEdV/zr/N3LR5BBXJeyopul331K3LeTBuX6zw9pjmJTopAWtGFDtCG3aTdGM?=
 =?us-ascii?Q?ftAHJd5aqz84EJf6YIioPAT43hg7gNSvHJjMUr6/JNiGHaI+btkV75zwvPL0?=
 =?us-ascii?Q?tHoj4dyFOdiqFxKEIuezvxOWDdXImwMKf6/pzULlR93bpTgLOprqYr4o02sz?=
 =?us-ascii?Q?cM8nd1p0R07r545rteoa2dEc5rwaoXk/Y9YNQxEbHYDCPua2P0uaeLYV44iR?=
 =?us-ascii?Q?tFD3g0DP3PIsXK1gPgGXz32sQ389R/gWDEcB+UDsRC1x8TCuh5O9JZiotCcv?=
 =?us-ascii?Q?6mhX2CSpU2vMssvP69e75NfZserNRq3p2r9z5gOHoW2HH9Uq8jVSf/0DnFLW?=
 =?us-ascii?Q?grNAA42gimlNmwPoqX3M3vyk6cYpqz6JYiLuuIFlQg5qaICkDaETTuaK3uwO?=
 =?us-ascii?Q?PZWshsrBpv7ONm/k3vgUSTA9IBcm3OYrc7vaHBsDfBn/IfOX3OQzPQF+XNgs?=
 =?us-ascii?Q?J0rTnxX1MQly2dg3QLdnbU4YS59JWLr9LJ7O8JcDqyv1LlgNGP3BDnQzRgLS?=
 =?us-ascii?Q?9z01oDeEMKBzB4N09qWY1rGBSu6H/JOPl2HagUujr/CesPXeRJXpLiC2+1RG?=
 =?us-ascii?Q?lX8wyNv8eCe7yk+aiYznj/4b+HqqH+B61r3xhsxPzxeGWQwiBWXyVSHkSVhd?=
 =?us-ascii?Q?VTZOvAeU57J/1dZ2N65VVb8hY7Sfble7Mi9CDtGTDR5IUrbOCt4CS0E3KFwu?=
 =?us-ascii?Q?AO0vUqlxG8EPPgPy8sOyD07stkLB+FnXWWA5IS8f9pIDamqGskjK//DWfQRn?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HITcUhJAGXt1EQAZ5s6xhq337/WPECkqMyFqmccHOCcqyO0UoORxPvDGu+b0gbrggvp073OLk6YefelbZfDminNsZQpW4t8xWQcZSYYIka5rqekDsoxgLFm1yuO7erko+dRVjilqqboKzDUEHsdbaQd0vERQE16nzV0TjRY+VXQynl6XdH4mg31sxThZBHYcPJ6Rr9zjq+TzT1sdjHbo3bvR+ouy56bWE5pYpCFjfEvmczxmXizRknITUGkFOEksn35/iPDqrOjziCxeRCEJO5WPGm9jkP34jjlyZHnXGIbIH6UhjYJzQy6aS0j+2JBoBs59kP5skY6vWgAhNIY4D467hVFDbPmuy9iv8dUqlXp9d4CZ7qL57+cOOtNfRNjdq3cNz865pGchn82/WQX79rbKcNx1YZiI0gt3lVAagFD/eUIPcf2SoGp4TJywqB/DLT/NB6M+GtI9rbj0f/9QGAIUv07LYIIK8EjlCwAdPzlAoinNt8Qw+5Q432w2ELTebPMsYgPfPeC9wHJwqj0Fhu0diHmIhvUReCJgsUaqkzlLCZue9JLsS5e3G4e4N7rnureZqIz0rms59HyWzIikA6FZO4iZHrifZJUiSyKZrn/cagqy3YCR7x9l7Va9c6sjaBYINsUxsrjD9a22mTzGKvu0bcZMPTR4Yfd/lKT8aaQAHFT0xhOA/iJeJYKQPFRvouF9YB8Vh44b/U5TbPkj4QdI2CjvNmrakp7BYE1t8RNxS8ZU3U8OpLyJ5gARER+VYzV64IK8NcYamAjG1bM2m9DAkACcL6SxdAukDLf38mhiG3wcE9L6MiZXRMpjVXoTnaXFQ+Jr3SHMUQKkzgQm+E1S+JD/u6EdExSv/m9JSle/XrpvfXA92gosVnt+aqnF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c9420a-33f2-4f47-c1b0-08dbae66248e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:32.7484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vRD/JIG8MmQZSyt+6W+XuFjVpLlAASoyBjCa20NMh7xNmSYC1/f4i++E21WsNgHXTmPWC05P8mr5LYtxYDrce8zk/s8zIpRqkduLENNak8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: 3mHnKHrGWam4PdaGzbekxfj-vx9316fQ
X-Proofpoint-ORIG-GUID: 3mHnKHrGWam4PdaGzbekxfj-vx9316fQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only initialized if
scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
good statuses like check conditions to -EIO. This has scsi_mode_sense
callers that were possibly accessing an uninitialized sshdrs to only
access it if we got -EIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8efd5d8e46e8..6dd2dde75354 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2938,7 +2938,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -2986,7 +2986,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.34.1

