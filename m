Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C929BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKDXY7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKDXYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4A328713
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj8sB012149;
        Fri, 4 Nov 2022 23:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=OS11MxWVF1VDa0XHt+OX9H9BTPC3yANJ1sfzfz9CucKppyK5Pfr976EuHlqbGABm51bf
 hoRy/8fYHxCrokECma0JAemymaX2SHBsEb5PTflSlnaTkJJ8gW/ACGs7aoR+g7QYCyzz
 Z5DMeJnGdBIQC9plN0kMNwrB3Np65loaZ1vo9O6XuJU88ALp9XJ6gm0F9z/WEQFyRnuz
 CmQ511C/Hct7PDB0BGEJIui9Lm7Nt1Tr6/c/HoMy8SSHjgLk0gndcX3VQ+nQs19QhB6P
 HDer0cKu1gxDuqcFJwNg+MM8oP50WckKY0P2oh9qumNHyuPs7ofcGbrHxepCvjHupkt3 vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JjItR028686;
        Fri, 4 Nov 2022 23:22:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a9a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTpQOOWL9o4kDlt7WMynduZPPv39SamCs+O+uoSonih17jD56JnuzLlis3oZF/7NYosZnHRcSqw96fcnrNsbmTczHFFUq0ldew7Mn3xEJZ5xjTRJGWXFpKp8AJlYTy87sxZhwMtN5I1AMn/uRnnDsaPXJCqaij0KJLZ4j1ZaMC+ID4iHBrWKK1OVWdGe92GG7Yssfr1JV7KzYRKRlomGsItHXMT9hw8nMUGpcqvtjqCnVqIB6nROa0z1fLsFaRFzGW8Zi5nuadegFeMjaPgb/95cqSsRDyoyRYqV/z4famb+qpwnZCqgeKxUxyYBz4+4e5EFYM2O2IhWGOjh3z1nCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=GmoYjrF7zOVdycc78reO3l8m1sQGc5IAwLHQ3WhWgqeMDPpShRGd3852HyFfN+O/zG3kph2t8a+yO7zKAvwZM8zOMj+ZcHkE/9XYGzjcFNacSr7O+XqwvirOLGbXazsHQf2hT98gOVycdqTGxvp/ffEdtEBT2lZZiOYWyVc7lL0JClJWxKxELwkW8D55defKkhSgHlqzNA9Wmv8b9tTuF0dg74ujv5flehBjTU3JkZlp3ogZ8cOoC0r+Aq3i/QpYs/X9cmmB3fIsheKvU6vrfMYxOTeQKClKuf84vcG3VFf2H0XSenYLYYwN55tfj5rELH2sLQnGc3FY6GWkhgczSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=PBca+K9fL2Z0Qulj39F3I53O4mcgPqtEOAEj1K89INuvoz5/8sCyfpQVOs1REdsWJbXS6bsO+HyB9H51/5/It93IJ3kt2LnrfuV1YyqfZtz0PDMOyzHz3f6xbcZUJ/RESXiNvR+JDXCG1HEwnD5gZ/nYy6mLD7ihvZnJeA+B2/0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 24/35] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Fri,  4 Nov 2022 18:19:16 -0500
Message-Id: <20221104231927.9613-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:610:b0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af89a12-8c37-4b7e-a46e-08dabebb64f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fd2feBVAQndn8OIwlPnE/RBYNahH4XYCj5jf2qTxmEHZdS95OaEfEiOJX3MRlvmuGckzqbMPzr2/eW5AOtbLjVxMOl/Oh1kNcscs+usv0oBQImPqv9OpqJ5xzaG6JM2rTv1wD6w8ac9cDphnkDzdggCFi9t6PmeJBnbkfssZNlwCN2smmqCrVPHEwHv07t44Dr7YNNlSemvUqyf4SYzVnhd6s5nSmhyhLJ0KieeO9k7ogfe/sG09C6Jl2yMgk+aV/58Iq0YRM1feU6qAQdTl3QWdjYmR1ZNnosTq4Fu3QGzp2QBkM4CLg8aCqlGfCEIggU9hSsswOeWVxfxluBXgmSb6XTdbBaoXr9pKycvw/QROwHmzqZg0X6hNTv0XJ0DOQtLTsl6cRm2cM8T9WttMY5tkEYnJy61iF+nRK3M6onwzDB8+TZ8ewP8toem4J8Vio0VFFzVL+nbbJNOhl0/6ZfnnQ1DWXGtVTDj/jIaWDtVHPEbI02dg2re4vp6TqOO0uFzBa7h3RpCNekJGrqTCoz+lgORDOXw/X89bF4UlzLwN2b7+BrmOHhVn8V83WDVwmsK9L7bj3Dd9ED+1fQehL2QmfcFGr7sLjuE4341+sN1NYYQF8RHIdijup7K200X6D1KF6DhP5ytuVaHTdhc39Ewt9dBrYYCenflN5L+GdDcQuKyzSAZ7BwKk4fphyxHBLXKXZMCy01mctrhhB193Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MwUrCgJzFOlDbBWwDs97PmnXft8z9aj5zbB49BX6M55LKg8aH+tGd7ScG829?=
 =?us-ascii?Q?NTyh8EwKQcHkSYFOloQQWukvjNrWRW+y0jOG1VVbDvU3eGfdw4GLsbx8p/9R?=
 =?us-ascii?Q?48UqkMbqPRhYVGM2WkgtEmCdDURnb7hbAZUeFEQS++UEEB3dZPKOboj1XM9b?=
 =?us-ascii?Q?HuP4L87mDrCI5P9rik53+j1/XDX06s5S3enpQEuO64FNL9AVwwI2Dy7TM0JL?=
 =?us-ascii?Q?gSbYI8m0IanELOWl8HmS+k/hqDP6l5vVbTDRIZFdUhhJrzfM2S3dNNNypG1d?=
 =?us-ascii?Q?wn9M569smw7ZqSpho2E5ydXVOQqkDYuOq6fHtuVB39vydUp/slmNxYvHQm20?=
 =?us-ascii?Q?lNGdQ9Srt/QxGGGcBiphJOGzU7+FWMV669FEXoUyWqK7wkUTCwCf7UxqY8j9?=
 =?us-ascii?Q?7ra21ESOLN6nU17Nw5VMFClWh7Kv0IZ6unNkvSb168yGGrmN4xZOk5f3vcDD?=
 =?us-ascii?Q?5MD5SJhBS0TcE77JWUSA3z+Q0BRKIQTHcSZ6geP02K/f9ESeM2VoLMFFWDOp?=
 =?us-ascii?Q?vjcVqp8g632NvB0DfGCM0DN63CA+Ji3ghNawXi+8bAsPR1ldIF3YS4kHQKLI?=
 =?us-ascii?Q?gxTqlp5bjEgSAtqrT95Oi1RBn35MFQYcaFGDMwMQByybo7i7DwSMUbXSoVpz?=
 =?us-ascii?Q?fWzJUagop3slF74CjlhX8XUdc5MIgaXd0OlaoUXng15nxSZVpyntAgHiOxxE?=
 =?us-ascii?Q?Y9CseAGWS/ues4qFlVENGZwmr4UvOLkkaFbWZqO2R9JfTdb0w/chCH0ahSD6?=
 =?us-ascii?Q?+4tgx7n80d021kjWv+Bq4i4rvN20in2fDpnNxcAyFXkTThZ8aNDnutR5Ob6a?=
 =?us-ascii?Q?PO2xcyn6gItgOf8yPd3b3ayaMazYiYFkqaZjbMX7CBjOQfXIFV6EWycXgT3B?=
 =?us-ascii?Q?+tW5InAo9Cj6nf6I2sU7YJJ4OCY0AwB3JxAG0tX3LakS15IlTt1GR4SyfIKP?=
 =?us-ascii?Q?2N3amMgqbjoFEgICh9euqq15fVUUI9BA52e9Fr3YwZLm2+/QIINDkX3mja8L?=
 =?us-ascii?Q?Nx9WOf6gLeoJ6Y1NWgtko9cUvgb/NzA3la7EEbP8l9PRHel32a3xxTM6JxKQ?=
 =?us-ascii?Q?HRV8pkOdvNGzoiJcPMYptP4Ss+mg/xsKt4T+gFgoZ6spFMYQ8pfPTnNDNMpT?=
 =?us-ascii?Q?iDv5H1Lqba1eLQ7+QtXsb5XhfWalHYVsHH2WmQoLfqVMsjngpRj5CpbyhesJ?=
 =?us-ascii?Q?QRDJrDkr9Ym/6pSkGx/EhqugKlAp+dmNBxGbKPXsbUMwfjSnjiWx76ncTqcX?=
 =?us-ascii?Q?Sf9eTPkRauTlG8hEi0JIgaCkPgiP0SzqqxykS4VGWXn7G6thRZ+z3wghyEjX?=
 =?us-ascii?Q?l4/gvhP/83/jvqBd/NuyZ/lMYqC4DDTyCqwVykcauBUwG5yQRjJ3Ml3WVkyD?=
 =?us-ascii?Q?EpzR03KuPals2L4aeIvhJDXftPixT2trab+m9bbBh+dTPAuLkFWLFYTrQflh?=
 =?us-ascii?Q?a+V6ZwNfeg3L8u3/D4fMP/45x+ogWuCXG0emFb/aNNa2tk6nFJ2qK4jW5vZM?=
 =?us-ascii?Q?axaiQdTogqwN7ubeqceWd/iaoeKipK9WowEGB+v9hpUt4On1LXH44WSF/DGy?=
 =?us-ascii?Q?V/nR6mVeww7daAXxwFKEjNw9WenN/Uu1xN61j3A1HSxyH+0uNfF5X5PdsZwy?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af89a12-8c37-4b7e-a46e-08dabebb64f3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:08.9290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CzcKK3EM/FsMy7Uaj3gXyKD7qNlMInQaZ7esGJKIxsmkokQrOoktfdKTuLsnhBBvqaJe2CDCw33VgxLIuLSAdAxeUua6e1jeQu2CQI/60Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: zeUxOSB5OFZxmOmc8zRYpkfPuFHzQ8ad
X-Proofpoint-ORIG-GUID: zeUxOSB5OFZxmOmc8zRYpkfPuFHzQ8ad
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 109 ++++++++++++---------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c4d1830512ca..953fad6ddd66 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, result;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,7 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
-	int result;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -546,33 +562,28 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		"MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	result = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cdb,
-					.data_dir = DMA_TO_DEVICE,
-					.buf = &h->ctlr->mode_select,
-					.buf_len = data_size,
-					.sshdr = &sshdr,
-					.timeout = RDAC_TIMEOUT * HZ,
-					.retries = RDAC_RETRIES,
-					.op_flags = req_flags }));
-	if (result) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = &h->ctlr->mode_select,
+				.buf_len = data_size,
+				.sshdr = &sshdr,
+				.timeout = RDAC_TIMEOUT * HZ,
+				.retries = RDAC_RETRIES,
+				.op_flags = req_flags,
+				.failures = failures }));
+	if (result)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

