Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05801C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJCR4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJCRy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C57636DC1
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODek015444;
        Mon, 3 Oct 2022 17:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1gJGGD09wn4XgCupqSgJ8AtiebueNWGHQUweI6zfebk=;
 b=LzkWkregXJAwKiydI+FNmmwu4pm1YSR5IEj8YNh9iAgRjOMHyEr7SBADETKZAU9hTHa1
 N7RudgZynCkR6FNZnzCLUpUcmFJKECVCCB+jX5dIbCtZbf7n9fYpR1obmTVSEOW13W1V
 1hkd6eh94vB93dmdKgP5u4H3sIi9VqAVPqqlMaJVRHBO+0gRyVqpLT9Iq8Li3tOL43Ru
 KUh1gz1JJUipaDtvmL+Cf10sFmr6vGeIil1Hxum8KoBwM9/o0UJRftbrz3iEjZzyTBl8
 bJ5HRq+bPvsKxa0evw0C8FliWwb5G6h6iLbqNhfJ20EYvifJlMMBbPsbxLbuyM6F9Iob pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xm015519;
        Mon, 3 Oct 2022 17:53:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNi2UO46Kt3TlFnuIA2WEn/464C2S9o3/WWE104YeMXO5e4qo0eY4+o34Jql4iDNihJABXAjbEmbWaEHWgWhEfAxTaTOK/cUK39coMYDLjsvStY5YqgPFr9FrbzEIqRKBIfnneLGgWR7LcVgm1tACcx+wK9jM64+KRZVDkUY4vR6aSCHv5xSbkjPdhkxlyD64alaZanxS8oMRhq0ofvpE1N2qYviQIOJYm659BfSwxhzLzzVd3ZvrVgAz5qY6UeBwMHj6cJbOFJV8X3BkJNViIir0hW+T5KiAdmSJPUQ0KhHq/asH62WNFh9f6RGrqLAaNWemPUVkV51TN1qPL2XBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gJGGD09wn4XgCupqSgJ8AtiebueNWGHQUweI6zfebk=;
 b=jfORDbS7OBlGtr13hdXjBhGtrz9L2Lui9D0TQTw182KjbO4IEzKjSiJALU5LKMf0VTk47cFst3/7etNO06AnF2pG0PKFRP2nSETwt+pV2kb41s3375u+YiX3liPwUhmZWKHnmPM9FO578WXRyCjn9MkTC5prIPDywEXbnMig1QDVSN7Eixj04ocQ75gGvnjQcSXWuaf/L4M2+vXwH2LLgUmFHRAhSPR3U/fHF+4GxNaqj+Y6NkaIfdFdp7Gj8+GYlK8YdkNVFwVT32btghpVpNcKAARXnN1ZY2mgnPSwOtIH0I8vODzE0+TjlyGFLEUGXk1ciMhAN5F4HceaiLP0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gJGGD09wn4XgCupqSgJ8AtiebueNWGHQUweI6zfebk=;
 b=gCTs70ammE+sWOLDtxXZz6PCekO+UElhPZEiogyzfALqcyWMNJCbApe1U4YplPpzs1+2RFFFhIxSV8SP+hSthKZDJ+4WealMXzc2SkmY1yW43nh+fgwxEZx9qhQGDe1IRv3evqBrUUhoRW8XIljXIfYervCPcyNHIeZUG2I5Q1U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 10/35] scsi: spi: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:56 -0500
Message-Id: <20221003175321.8040-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:610:50::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 215661db-7539-41f8-9f8c-08daa568339b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXput5dN5cAjMDaZtyPCgAL7M6VOG1FzjtiQGoI1SfqpwWnV5adZt5eouMFCuoqsNLjINRwuOnYasxhA8JxjuSc2vKbbhafWR1mTBBcDbkzlZPxMUrpOGy61OnX4CWQ+BbeKUow9q3mxn2ED6AmRWaWwwn46TEc6Uco6n0TEp8S5R5Vd6byRvoh3chFAB0K1DTWDTlFRG+/kY6llydUUJVImjOdcT7COy7809bN1Ue6gxEgZJ23G4aYS7EWpRljoVa/i9O7Bpb17bW+nsso7h/6VRBxxEtO+uiojZjicfzCPiMQ90tTLfsn93pyoQO7fTd2Z/UonzIEiBtkmsTnbo/pUEfc3+/xsWjwI5xSsPhJ3FFZSQOaTmaCOgbEHNf3bDYYZgeaLOjOrcmuJq8zjh0gzmuzdCZoPMhMJaS+5cgSbwZrPvQq2jT5r7xYrhram6i/C+fsZGvmG+4H4fk6QYsXT7BRWyL1/4AfkeWb4iNdwv1pbMoFNyRAKZLyu0d5W/iCh2RmpV5tFcp6EcD7TdwGPi8XNwCCQVPsX/nWknoYA6u/mDddheMnXxk2g1wKbzUHZ1Xxjfhm6i8870PD4KnARqFBMBFhU4rewsbTuBNELWN8I1jfwWpcJmMHnYHrVjDlWMpR4R1i2WFsbhw4vBFkJIWAkPHhAavCham7700fJFM2teL2x6FBV6ij/p66dIaoRbCY8BK6ccPsw0d8APw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSZ/uvmqYXNKGj55obArp0dTKvKR4b+TMI2Kb28xMK7OTB50S3HxRJZvYUl5?=
 =?us-ascii?Q?nYubKESAyavWVJ1qYy1Xw5L6S0R7IDpWvpUFLriy/QX1/Ih9g4FYOF231tPT?=
 =?us-ascii?Q?qta2nzbyhVVn04tl3wsGNFMsV5bRfT/FJRAYhbSrQLRO73hYml7qownrQrrJ?=
 =?us-ascii?Q?XZIbI1p/7Xt1e7lb1qCQeyGeLEyGoq9UB3LG+773WtZLRQurNQJNRSbdkpyX?=
 =?us-ascii?Q?yi+F8Q6unqZDD5hchlmp8lIeGbbBYmfwSANhT3lsc2js9QRzsN60l/Y4n+JT?=
 =?us-ascii?Q?LbIRClIKOyt5XxzR5gHNnGOQ1LY3tMQqlMIlx30MP0bnwUh6vy5jqQiW+NUw?=
 =?us-ascii?Q?QlQ8nVEYNdEA5Jrhfh0UxMKVtmcyLlU3xIOTBbsn+u/WJvWulaQzBAuNK9Wx?=
 =?us-ascii?Q?uEFSpA0aTR8+k6M+zV9FBQt4DC6sKSLCvHiqsItaUKG7gTS8oNvuBjxmNFfl?=
 =?us-ascii?Q?w90Vc3jYW7T2ALUdJWiCsLnoixAgEloCcAumbSNW7u3OJKj+YQEYV06nYGos?=
 =?us-ascii?Q?77YLtQEfNFvYOg5Hy1cnmH+hzHrZ1c/urd2TSAVGvQe/nQyJAgHjGIlh0snw?=
 =?us-ascii?Q?Yl8DwT2sSU0yesmC0ec29/atQfiFej5+rCIwnDpCd283agSO0wWyFqSuM1kg?=
 =?us-ascii?Q?1bfvHqEYUG7q2pZ2e3w9zF0JibEKg5OwGlGjAiKg50wzbIAJQDOeR7T5/P7C?=
 =?us-ascii?Q?tlplHtIZIL5zWWjNaaHZDMZpkQqfIplJTTDjXnOZU7bmOhNK/n62gwKlrd8U?=
 =?us-ascii?Q?+nkyte56ZKZVRCsEy6YuvC6tB3gRLV2ME6UOM8Pf4r/AwxmhhLdVTTn06ayb?=
 =?us-ascii?Q?XSxN2eNvDOzm11HvFen6Z5ST7M50pTyo5PcRX6vqkPIZ5pxARbH8QDjkARQv?=
 =?us-ascii?Q?eZbQWidKFKK1QyrTzj/q5/Uj1B6nmm40MkTSYuhoe9IJbrl6KZYUtpCgvRQa?=
 =?us-ascii?Q?Z50pLdFhxF8JrqNeDXMc3plIqdYDcAp/Jh5jhZ8X7eRuF2PZBl73vvk9UDIU?=
 =?us-ascii?Q?z2JM97dX23A1M4BgkkoE7XkSSn2HjBmDYYJDe3N1Qx1azT+fBGgOTcqrZZYg?=
 =?us-ascii?Q?fDRUGJaGGFWhjy9N/VnouuT41DyyfxGtg0iNn3p3kH4aUEznQ3a1UF3GECNF?=
 =?us-ascii?Q?z/lqSYUJsHM0GtSWfKAG+Ta4uyxcacI8sS8Of9bMG2uYUN+aVsWke96geuRW?=
 =?us-ascii?Q?a9l5QNNCdB7VkAzQBCK08UMq9X7XFd44m6ck6RLvnZYr8kraRN9URj5442aU?=
 =?us-ascii?Q?Iflu/sLao7nrfN0M4+TeEz+CovOSlaMxTq4PgyuBF0adh6PYgLMMtWvG5v/x?=
 =?us-ascii?Q?/dtvNh1MCEc2U67WW4yv5NNbxvygSnpNDR2OYg2YgxuadGV3J8TXscJVH0zo?=
 =?us-ascii?Q?iJ5mTPGlou3kDB6u7F39qMWA00Xwe/VqbUcwl+N7ahfnoTwEdbjurLfD13Vy?=
 =?us-ascii?Q?odzMHnjroN6BLjg6Az+n8AVcV6Kv/1C0Sp9Ymi8bBRehxtWZxhJ0p4Jsmy2t?=
 =?us-ascii?Q?cIjJD0SCDqqzilC+UyI9iJiV1nEqssBI+01uRwKE2/qkwDxeu3IW6UKWfGTi?=
 =?us-ascii?Q?v7wpHAfRt1UZ7iaDU4Jzvyynale692uozi3bnbXyBxErGIzZ5sbK0bc4P6qy?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215661db-7539-41f8-9f8c-08daa568339b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:38.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5U0IhwIsDqa63NfiUC9oGzl0TMZmnZugcdrvUgMBGKYMAgyH8cxIf1pM34mJJHL3jFprySzjHnW/cn3Yx0b+ZWp+Ghk8GOJj10Er0AJswBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 4Py5UVb0M_UyWFIa8gb7jEd3YcjAcyy6
X-Proofpoint-ORIG-GUID: 4Py5UVb0M_UyWFIa8gb7jEd3YcjAcyy6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_spi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bd72c38d7bfc..55d9b13b2f8e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -121,12 +121,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = dir,
+						.buf = buffer,
+						.buf_len = bufflen,
+						.sense = sense,
+						.sense_len = sizeof(sense),
+						.sshdr = sshdr,
+						.timeout = DV_TIMEOUT,
+						.retries = 1,
+						.op_flags = REQ_FAILFAST_DEV |
+							REQ_FAILFAST_TRANSPORT |
+							REQ_FAILFAST_DRIVER,
+						.req_flags = RQF_PM }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
-- 
2.25.1

