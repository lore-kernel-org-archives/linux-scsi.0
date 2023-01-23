Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAC7C54EB4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjAWWML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjAWWMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120F039B96
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:38 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhqW6010181;
        Mon, 23 Jan 2023 22:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vZFa/DCZob2soIs3HDOIrsXCTWasD/+VR1h3elb7I+w=;
 b=DgBiHqs3azp1V4+iKCe3c8ze5nny7Z+Zm+0k2yxRCCogxDs+kxisOBcsZeVCUPdEutBL
 fjiBfBrEK2M51uVcQS+1IP/p/Hp88h4GpIjhAF6Z0J6PsMhf7IUPxHLVP+BCO7JztrEd
 IQvdDUr4f+5h62W+slo4lD64LujduLhVYS53QFtOPmLqpBVqWT6ZY90LSKvROP11r8Gk
 wPXa6eSRDpHW2p8V31I1g9cSKGqVvomXACzpj1yH5y7JBq5RV1p+DoC7QvxiVT0OJqQt
 AXU7q/TV00DrYNJEMzugvPcpGk55eN9ghw1l7t2bNEP0fYqKowWSORUNauFWO9otuDlo 2Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2v27w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NKRmF0040303;
        Mon, 23 Jan 2023 22:11:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4511n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gec4tuSDqrLOP/KkcaDxavx6a84yf5Q7eSjNF4QI2NHZojy0mVyl6lxNpOTFQj1UHEluIp2Y89g3HLHgZLRnwlr4LKOgOomP/Wtr65THRrYdbhJ1HyeioLdGoYU3KHHxxM8FslSGWGI3WL70fRdIyjJKDlpdaxrVu6bVluvxhzgvNo/aaRyDe+OeFoyB3RI6J5/BULLUSrdBAjDPQw1pEu8yoXXCBJwJJBz88l1O5kL+zgIa+hQYTzTNMYt6x2nvmaszEE5t4OOiaWE+KYNrqPeXQ08RBCB6WCZ2v5WsLD010n+3vaDUinDPdZGaN384D9IM94f/gQH3c9xUzQheyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZFa/DCZob2soIs3HDOIrsXCTWasD/+VR1h3elb7I+w=;
 b=URDWbgEIs5wSOVFilpHDy36rYNg5ua3S9hFCPq2GSy4QtKGXtNBvYyux0UiUCqiG/pF/U+wtAHBw/gx+pVdXWj9R6S+Bi02E25pjPOgu3Kjr06cNlquEOqIngjONqeUp8wR8TDSedDmZzBnZhIWpbq72GVYy67cA1b5OX7UL2fMOLyLS3s036jpq3pbMc2dc6ZDfDe2LiqM+SKYRW0fNCFJYWseu6DvhvkzGrJU9oFgEPPSCHzKAmm4U7GlGni9VnWep9KP2eTji+2gNNUqjYfcK/l0V/H1G1YTnUJK73731KBpnCAd2GajOOlsKJTTRL3fwibalOzercvRcyQq7tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZFa/DCZob2soIs3HDOIrsXCTWasD/+VR1h3elb7I+w=;
 b=xXTRbREAdnTgOnPtBIAWIVMDw3aGdngd2NwKkuXOZGR3P+y9v6Hfo5bhWdQZjhQjqUsDZkUoXqdInCm6wddnW7Vfjjmatu4HH6NuYXpbthEUB14aQ3zKrvFHewQcqKQBrT+APFzq9o8Rs8h18fIUvD9DPmnxe/9WDicYUzuqIhA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 11/22] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Mon, 23 Jan 2023 16:10:35 -0600
Message-Id: <20230123221046.125483-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0134.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: e109bef7-45e3-4a85-e130-08dafd8eb9bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUIOu65XXg8TZGFSsMvtegYji0clZNTimQekWhNafPU3PVDSk5T0pm60WR0GQ6Ihyqp5NNkfnqu+J2nzL7qJqnI1RLqxyFKfFcZ1ZkirifP3Obc3XWdk99U3ZGhMOSEw9qbaOX6wzbj3x7DYtMeL1wnxg566kLRhnu6HNfQPukR8SnNkntF7OJ/FcV3cEOE5du3bayaMa4rR079/8JzPw+eqZ8unN0oiKbzOh2vIyDMhfFsCKFStLvKeXCHz2nHyCXUH/JqIKD4vbYm1DxKh7ThWry6ci4/eMCR0QRPsgE9L7U9vu3xOphEp1BnRaYu5QqH/Dyhsla5wVvlLs5XMkddMkZNbygb9sdzNCoBNIY24hDHhQdYYhGwyfrimFBSggAmlZLU6LwssZr3OFXi/twdTdVg+v3T2yI3kjJ0QOOAqiu9lfaepkQeoepHj6iELZ3WEmpjoimIVD1eKLllBZ3037j4mEaRLZ5LksdQbtmOJpIpVP3+/GJCCDqwpWjdjg56b3N5vqfvNVA7AK3AzXJjdbaAvET7z/lpX2Ebzt4UC2a8uN3nKS0srAnIN3S3Ubkbrp3KYqn7MjxBA9NrbxqZ7UqqC+1uko88bFkL2jrKzAj7fpe+N5akgrOyppw+E3ln+SQCP+YDuJltKcZA/dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1pDJ6OTdqISw+RBbplr7ktXhUqdaYAvPnhtbk/D2SGNf9R4wdYdjbt1Fz6+l?=
 =?us-ascii?Q?u8MqR/SS3Nmnxb0mf4Ycu7ap+MGOWZ7Ukf3XqnD/dvthR0K52tkJ6SMQEmRz?=
 =?us-ascii?Q?xEd4vbkcZYv8SUmFCka381Ngq3312fSV5ZPj3IytyQkmHZI67XD0Yj3NpMCF?=
 =?us-ascii?Q?oElghRkNgxQmuo00DEi6RWeShjqp/wNbCvppDPRVXmNyJZ8L5juOrgH6kQ7X?=
 =?us-ascii?Q?dUwkJUZO+dWxpJswxd2o/3UoINdMy3L2IFlhivvHlfnfWILML5UcxYlS3GqF?=
 =?us-ascii?Q?CH1a/lggz+QrfgS3nSuWOgv/04jmQnyehk+RnFitQTVXaPpbGAvu0JixZRjf?=
 =?us-ascii?Q?RyFwE671yhO5IEuMiMqVTcgAUE4MjqOx4d2ExPZRkPGarwiJo3fmwzLDwx5l?=
 =?us-ascii?Q?X0j9ekTlpNs5nOmBKTes6ExymQBRIsYhcVtBT38/GlYZGwO5MAX2ja13II5R?=
 =?us-ascii?Q?REDT9Xs2Fzi9/ZXkyxrzewEotTc/eMb+LnEgKew93tdW73AVL2l44f4oYOhM?=
 =?us-ascii?Q?rIfywpxAMUB6jV2Jymw28xJ/hJJ/1cJ3Qr6x3dK2QuZOhTNfMyGOcBFyPFDR?=
 =?us-ascii?Q?Nh3+f158tTQxoD4TwA3nOv6IjMB9BbdE2IRnIf+smr1FdWmL27VMh2ZmPtpL?=
 =?us-ascii?Q?JifoAgbxjz53kiWfZJhJrBbe4yXHZtgLpSl+nJ9iPyccVSfhwHGEwbbjSq7p?=
 =?us-ascii?Q?f6rI30i/hmWySjYrAzcGDM+jA9HyT2XeqFXxCSDwlQtj/IZx+3is5Kz9LlId?=
 =?us-ascii?Q?T8YOKR2AFu+uCiHbaLFpr91lqYZf0/eE6J8/cQ0rHesAIX+5a2Ws56HWKZys?=
 =?us-ascii?Q?G8pvifhLW4uLNG6NI9MYCHJ3rVzBaWITJrHST04dv/NdF63cvHPVkzvZVtVE?=
 =?us-ascii?Q?yJLDWwdMh3DnOF0LxA2BlGHxNKMjZKCqdJRO/fEE5fHqhghbNqjJrzN+tS/K?=
 =?us-ascii?Q?zlREeinzo3Yy/mXQmMSO25WrI/z+qcWBIfqRb4L9hHLKb1C9Pz6iD19txllc?=
 =?us-ascii?Q?5Sn1RkI+29P2P4emPzvY27poYksoZVAkNEpUm3jQE8tjqUl2qgXMlFtjhxWh?=
 =?us-ascii?Q?9vcr7YSwVeXKzpzypMWTeXtG/Cvgc/qjVcqO7WGQ5+4sgAxswm1Bw2tWnKUS?=
 =?us-ascii?Q?V3x++ky+c6imFZ7zCa7XwS5ptiKJneMrPL3MxotoIpOk0p2ogLgLodINF6x2?=
 =?us-ascii?Q?85D29Z6bThl3/tkqhnxpb0CP0Wd88AkdAz6Z7gRgZiY7e5q6bnlvf6YGfa3h?=
 =?us-ascii?Q?TakNFvI8mHqJjAcZe47CZZB9n+L1KzovRdjnuFDH8yas9cATLmvpf3e2ThYn?=
 =?us-ascii?Q?4Llbeh72T99C4lr1YUHs75QNk97LT1O4gKjQ6Ksl4qNuSHEeKDEQ3hgjDQWo?=
 =?us-ascii?Q?ak2sG70w6DbupgHEhr6n9ykCCHRNccX+4pDOw/5UKqzoNqlKZTdr+/wuSq3o?=
 =?us-ascii?Q?RMh1aisdc57Qwy75cdUYWJNwqkBB6FMXdjnnq2kbJSRGMl9ZEonnm6HWPrRu?=
 =?us-ascii?Q?xd2Ux8ugpMWxoHzNa5iQNJnGm98Dv1P1pfbYYf3nLTGhyAHDh2LmHYkosDLP?=
 =?us-ascii?Q?Gy+DU6741B7GyzK1zBoOWIRBBoFRbzunnshSOBm0bWY2BHWuseiWH686tS8O?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qme4vtwllKpfBZ4rZyIQukDspu/nLSIYMbVtvwJ4GjyB9mZTzB/VkXsnuu2vVXKT8ERNPwDfvQOBDR+hbrqcWsnH1kN+4IN+cRdG8iOfifKeXWiSdb09XtsMa6Am2Mkv1k2cSaMyNjDS7ukvalyaX+uEzjHLCiX0HhsLyG/R3CjzrYeCuRE1nqZqYHsdR2vwFbtpmSYpCnVO68Sl1kVV1QhlTj9cOgNOfNtPHIsCgOcNSMaKdJyjlHFg/tYPoT0W7L3SmPkO0N26nllLc/EHSmWGTpxciWYDjEerXmE2GRhm4Fzt1Zy3If4FTWxJ4KY1o8vR8YAVYEUESFLUcoN7zNxHBlq/XBXa+Xo1b74DmNNs3cQRr4UVqCvkWx0XC1YVRg2DbKX9vUEfzrl/paUf8TSC5Y/BU1VckChz3AYcLz+NB73hov3NOGrZSoKtUzdbLDzZv4e32+YyWqoHUpMPFHPHFG4J0Sjv8T+G7Lmt6B5ri7WzjfnTfusuz4EAFvB9NCm7lCeg7Rn6G5VqH8qXGJuW5h3E8GMPAhl9dq7/UweGZmbcnRVJ7ok0mt8f2yD571Y9XlW3373ZAvqxfg8pxzrBtTWStEZQerakEUX/xj8W54la/QsQDoj64EewDKW6VAInZdgLgbTdwAbtte05SN2Ut6aZPcYL4CHukbh+DPeiuN+YfNrhyxB8ryJRu7MRYmg4d11T6LztGPEHhtXG8gL28QrgQTAyOtMlJLoZX7vT6SIU5SUbkI/ephJYjW21d8HBRCxPrihUxm23SttbEP8UVRxLJ9G1xUFWWLYO4D047a6kXWjwvw+ZT2GqzsBCd5brqfCVuY+9aOOJgNjrpVFciwoiOb9wWXoXzsIti9i/rHCjPOMe13gII8zrib7h
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e109bef7-45e3-4a85-e130-08dafd8eb9bb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:07.0877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeViLjCTVepF2XQm4NM2UtwGvkUbPA3M6uSWD7g2irbL7WfYBQm2+a2hejk4oD7O7c+TlpyzNQ6ZkhBziyg3Qh1RedqWeJ8ODaazPhyYM94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: Ukx3Km6gCF5MMmRT2Up6c874_eh3ZEzJ
X-Proofpoint-ORIG-GUID: Ukx3Km6gCF5MMmRT2Up6c874_eh3ZEzJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..b269144dca3e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.25.1

