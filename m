Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6286EC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLIGQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLIGQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F72A0F81
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:16:04 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B94VB3s010444;
        Fri, 9 Dec 2022 06:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Lb01574jtmHeVeOjj3W5NsK3bd2px03I5bVsWBgP/hU=;
 b=UaelrfNjNBSRqpTfHwcIWSQAu4bTV7pyMX98eACGqw3kWNpat6rQT6zXc4L5JAZlkUOU
 n2qNbMK8F83CBuZVOL63NXb5RHM0owGy+hYZ3z0YAHEdkytmaFnkHywVXbW12U6lsZ8d
 tocFE+bpAPCR8j9cuHaUzRE3V1avE+sHCBRMyEtWMjYP1/FZMI1fw6nFhErJOjVNULNY
 StywHDWNe1etoyxZ2eOw6PFQ4vYrCvvvykxb7L8YJo4v/O6uNFe0qMyBv8VQtr5PPaIk
 j8kGlQnb6K1hy/ZRHvqS3iyId1jSKQwfq7ucTiOi5dYVvy3UUfX28v5YR2ZbOjpnu8n8 nA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduvcpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B93pomV019651;
        Fri, 9 Dec 2022 06:13:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8jwbnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUvIlWz2DLjU9fgjn7K1Esfw6YpVsEp38wmOoZ8s4xerqaU/9utNicxkIYsTtnC4GPxjdL63RMYHDaMGMK4o88Uug+Ryh68wdeyTIB0mkhY1SsNALG0PCQR5VOcCJHGjnN7LljLv+4zZBDJLE0YzcmmO/ma8L9HUf6ES0o7JO8T4yTviWU820liEsn/tcC6NL75g3vFjxRQ5BXFBT25SxYx7U51UB2zB0440g3qeF1/fS311pr4MX9undgIqjX64OikZ2UrBViDvW0nNzCBBV5lvs5QjNSjqcz7pgtLZtHmUJtIF76HFGX4WkxZEDgUyxectUJlP49+SilXhco2vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lb01574jtmHeVeOjj3W5NsK3bd2px03I5bVsWBgP/hU=;
 b=E3axdOC2xOaPMEGWxRrL4VM4iv8VAfwpw47npa+aCVTwfRMK5vS1EpKxXARx4LerONVUrx1vGeI1Oy0Hmai41Enj0UfLINMLWNq7gFkvVQW6M/7zNyqHraJQsN5X04Hmk17P02mIQNd1qCvYayoTS7gphW0cXfHwA/TlH4YuywQRw19kC78fnp7mZsXDcFhroV3FMSZ4/UYomKWM2RIWQWrEwmYM4wvg2y0CbIbDQlDIWLpkNCbHIGTCACKTbq5ZseQFLs7LIWQaBEdlzYjK09YKxhYYfe+/NQPm6rFiFIwDslvuzGw5SS5DJdhwWOomWdb5YEa2SRq4+C1EisM5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lb01574jtmHeVeOjj3W5NsK3bd2px03I5bVsWBgP/hU=;
 b=yvTTuxhT0fOVfDU9fljwSXuszqSmDd9b/JJZg1sPdvCV9JVwAKwemgJLjsCgAASbCI37J1NkSCJEpU020VMenziIw6ehndW3Lso5KDBri8Nvv5q1t+uGS7kSqLp3NO1193L6vkaN9r8ybzgHn3JtQFnqoHVcm11ud3635DyxFPE=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:53 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Date:   Fri,  9 Dec 2022 00:13:22 -0600
Message-Id: <20221209061325.705999-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:610:4f::20) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b8c25b-8b8e-4891-f5a6-08dad9ac8b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4ZUY/1P8TM/2hx8x89AKDi8lLZ3ul2JE5xjsBgvEpg9MCh8k3BinVnpQchYIo2cTfz0ayRvnjyW29uQopSdyqrnY5AF9TmfSbNUM4qT0S++N2tjHuh4+ZBh7V1pEpecGuqV13Ok1v+hDawWRyElLLs6RCw+nDmvBN9JY6Xijs/RuavvVv8Pk8x2qvCpiVNMl8uste8HfH0xvNjhYojVM76pgNjx6bdH80wCTkiyYlSbPsxrluEXd9jkbKArStXlA8UdV2H4xZdz/5l4KWavkfGW9aHf1gbt/q83/iBU5uQo7PptPqjxR7dOyBSlf6t+58ztOHgpHePyZguRC6mkXd4Aj8cmrGdLds0qDkxTCo8qDTLz04+Rkr4RQ1P8MgoccNfGiu4iCEi6v1JQTruzogrSi3twowmDur5/TQoI8dy0fasf3JZBlofMMvCvtryjm59I7OaLHGTJ0oVN63FINi/U6aQcPrj8FTTeJ4EbUliQZzAlxZ3nQb319/IWTRKqA8ruBI8PkiFyKZ3RIsQ0KHGJtHMaQU10CSiMD4uw0e5bHYU2DpBxRHCd6nI+dEOCGuo+5KjmOG4DqTFSCun/f1CDnEeQNj3oQDU8i9qKT6h6s0/mh9UDsLRki9tCXYlZ8mCPktzZNaAWiqM+bc3KNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(4744005)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z3yo3LxqgV6WlKfs9j7apQjw7upQ7c3Cj0akhUu1SZ+9KUEyVi6NzsjCea72?=
 =?us-ascii?Q?dGRwgfD3XpxFq+eP4zR+d03Nv4IxUolq0kJz80Ejwqu6krVYLpMMYkPf9XVU?=
 =?us-ascii?Q?MDqABUzbOyyvxb7jVFLlz9gCTI8TlxKU4IBtQgJ3Pvnl6YPRMp0RluAyiVx8?=
 =?us-ascii?Q?py7mF6Pvmem3lLS+LBas/EA2U12m64oNc4usdjNnyiJ9eAWR9J72TbdT8sP1?=
 =?us-ascii?Q?Z/K2v3i76Zonghp649TYrXotnhmrzGCKWuZEs3jYG8bHl5nIHA5qBzOogj/U?=
 =?us-ascii?Q?p0rjZwz1WnQ6pWzp5/Rt7Xb84AGewNzPIiWVFDXTPk/k9GpvDvYC2ZOp6yVD?=
 =?us-ascii?Q?57YgaskniF8Z/1BDX4jQEY++pyda4/Sc3yuQ5rsJv0juYPYRM3jFyiJpThSO?=
 =?us-ascii?Q?DgzkZc2OOrF8yGjiXs9KHZt/RRYI3Mgicnps+t198pCiYuZnpOo3BisR1Zy9?=
 =?us-ascii?Q?O1JWEMQm2RAxfiP3AbB1gXikle+sPaJvwtUMeHuaJzqLbvKAElXouRFU5hjE?=
 =?us-ascii?Q?lLg+cPUTr5p+SpjjE+vDotuyD+2b8aC0wEqaecLYAIDs5qpzTPiKKLWDJg8Y?=
 =?us-ascii?Q?3Hu3FIfUmGTjDoNaPG6b2ORWGh6CWxAxVit11a++PalqgwcI6ZqgDRTa/iXv?=
 =?us-ascii?Q?K7OY0nsc9tkhm6+DBx7gE1yL0CQl196ZayHwucQh6BxhK6Uw1QEQ1NaJ7YTJ?=
 =?us-ascii?Q?6ka/E0w64o+pOmvLeA/oEkhivcYg7GcZaE20x5Z+HEvma1ARjAPXxeSjjIcP?=
 =?us-ascii?Q?TBuGldwMIPJgx6BLGWIu2rrgYDToi4Nlw/cLVfLdNWkzmPuZccICgIlEM8WF?=
 =?us-ascii?Q?YhA4nl32jlk1AJab+Xblt9Ay8lJ9pb60juPcgrtvMBkbKSlvP4xaBw9JUdy3?=
 =?us-ascii?Q?QeLN9D8o5JSGcJAQzahlRpTGekBPGNOm3ZA05Nh0n3MCk1IpB1OdS1OcC7uy?=
 =?us-ascii?Q?8dUk27Lu7mXkm8e0QSPBzVr25Wfw7jHmfArPRnZ62T1VCDxJM2IIfA8U69W1?=
 =?us-ascii?Q?876A6xYlfyYPWrvSPzNjPD1RTjlCblnSJMygLr+TDWWirJsRfM4SQMz0qWEN?=
 =?us-ascii?Q?1r9tsqtc2NIFg4hkV04HaJwj7IhfBhfUPV4mWZ1q2bddnlP8Vqhp7KXOTSh5?=
 =?us-ascii?Q?hmOhGH6/yGo8VdvLcBFvnt42tLGkSHCUM5jGS5JkabUqYKSOHCY0rYseSZtF?=
 =?us-ascii?Q?faPR3Da3k5EbUla14gCiDO+kmgOJG7hO3ijeBB8svGkJPzTFqBPg18vm0a0j?=
 =?us-ascii?Q?uWJTP9KcEqp2xN8cAl8wWvLYF/QEMQuSrsi3TzOmeOO6MZ4Q+0MtTirwgOJg?=
 =?us-ascii?Q?OxsvTfEssfsYpwQc/bxso0DUneUq61wbjoYDFshxFgxPqggK2bgQ7TxHu3rQ?=
 =?us-ascii?Q?1sydRycTXWCVdsoQxxHjUwx231J6J9XrxGVJRkPE+dBHxjJUPyN7YnZPLH+S?=
 =?us-ascii?Q?svAdNuIb1ROeBHbOwoq11dDsMwn6XYxMfEZvy/d1VLTyt6NSMFT9Q5JE4hcq?=
 =?us-ascii?Q?Kt3q5v0tINE++gB2RpqeuiiF6vyM1SMzzEsIFz1YBO9Uqd/JPWgsj8V3JJ6q?=
 =?us-ascii?Q?q4UzQq2Pw/bCRD5uYK3P2iQus29vaSmVXRzJCLHx/82A1u4twR/vISdqKG73?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b8c25b-8b8e-4891-f5a6-08dad9ac8b7b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:52.6292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vm1sC+CjG+hL4wzGkUo5II4hYxaPpX/A0IerN+XR93so+9nSBqiDxX7rLakCPm7+nQmHHcM0+MJqo2hLlkjFtAX3cj5+H5zVKFy97MJ5/7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: BRWUH4Xh2Yq03gdIBZXrdyMvJnpu98ek
X-Proofpoint-GUID: BRWUH4Xh2Yq03gdIBZXrdyMvJnpu98ek
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert virtio_scsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d07d24c06b54..cb5f465950a2 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,9 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					  inq_result, inquiry_len,
+					  SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

