Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923E4C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiIVKIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiIVKHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D30D5763
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3roV018118;
        Thu, 22 Sep 2022 10:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wY9R52dM8+MpM/Jd1dWI9HQ4xFm76hjJXQpmNrytkFc=;
 b=jRprhN6Mv/iVPUtzpROaJvypNoy2yjvbIJJRMY0XHlqdpJkIm6Ll/LWsc2ha0+koxHfL
 7gEg0IWu4+2/uXwXiK11YSqXcgOd/tME7QEbOMZPOTyBCaqq0UHrtwYK69MiVMbDZZl2
 8iGUstXIemeoqzWVvCWdO1vnFDMM/pGjrQ5485hV3fsYZ9GSVyLYrIN/kd3oBAnI83Ux
 Cv6huDoO73uHsY+U4z215Ek5RN+CDU15wQoJ7A1hXrGX3lL8QXkwYIamkRpW9pCt7l4z
 Vx7eY6dLEevChDnf85g6btWMjNKoaBVGLAaO8adevpqY3guejxxzwOQQEwo+2KtsBe9h 2A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3WY007436;
        Thu, 22 Sep 2022 10:07:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sm21a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnVIzMpeiPdqYt4mamCNID5GTp/efgMNPQX7ZOF8fs8hoo4juzF8zDHShvwEmxoXSXlLfGIPuJd1Kr0gJQCxjeesWykx3mJQaeEg3hZcpgw5J2OTS5I13btIfHBaSqI57F6NKl1EigEiw9mjXftMuI5LpJCauu2DmlKDZ6762k6BjZhm0H5rsumUTYuLYPTX7z0j/xkU/pXnHDXl/pWaTRm/+nN89XdndX1O4WPk8fW4KFh36Jf8Or5qz/EeeRmGi4LS34SwmH27DG2M7XcX/KWLb6Gv5Z97NelhHaM4fXY2KA2n94odZg5qsbuVxIKEuOpFKl1XkaS1RML5fdBQLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wY9R52dM8+MpM/Jd1dWI9HQ4xFm76hjJXQpmNrytkFc=;
 b=Fxfx0mKU32ZqzHG3A6gQi8+rteEsGZRIP0nMEVtLegzkPPmFa9T7qU37QwPXPvvO1PhDfBzH1GzjPATrA3kQpEQvj+TYiMeVmBuQjYNMwRQVlYlLgUFRZOZRU0noddVLpYk0IbYJw1D5RI+swPdOsUnQ4j0vWB6+42m4H3NDuLfJ2lC3k2oXxlNRxLbEnAlyPLFLv+RZcvTjLYt9BNJdattXYKZ7lH1mevvWUJadVj3HpUUQYgJOJn6CBuGrRx+nd4l+aoDsmTyp677uJL86c9DbzrZLRKwY2+5E1gYD1qSbESRr0lZUV2y5gIbE52YmGjWVXrWaKv34DkSgX0Qa5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY9R52dM8+MpM/Jd1dWI9HQ4xFm76hjJXQpmNrytkFc=;
 b=xnKfRBwWuDom30i4Q4ewoUsB1TBj6N3pZq9oZozvNBLHjHqCL+hQ5Es2eZxKOLqHQHd0bsNlu75rgTYcLXGnU2FTSbSH7KDLHDwXV7gRCmGfWo4z3JoWUhV5gpVInQEA73rqlF0hcOOgKW8a0KJ1eQtbQE73W1ppOnMEvPRpJwc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 12/22] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Thu, 22 Sep 2022 05:06:54 -0500
Message-Id: <20220922100704.753666-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0007.namprd12.prod.outlook.com
 (2603:10b6:610:57::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 78bf3425-7fb2-46eb-40f0-08da9c82401c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzI2uMOufsLQXNVnJFWBiXZ1V+8aHBU+0O3zPtkI+dTWQG04j9y+RYh7HB47oG4HvOmyuAgl5urYwnVQmij9KFsyl4rvL/NNzSmoJy+87CanTMIgvI/CfWBRmCahDUO65nfK9rxOp8nAnsr3D0xqH5JFWVpMR591iVarpKZlJqeXUtEGsEvS9ldd7U+x45Pz1/zbg1LgiTqzqcvsVBflbH2MKLY3wBGHCLH4eMW/VYKITKnZmGQJcB3UHkoTgdT6ih4rq9RNufsbJs9MTjasf0/mUPqwFyLmYAR5xWvWwBeYGpwKFxRM5uucrLjx+fuwo3l97HNBp7gs2cfNGaiMh3SKKD/6t9lYseZ0hZaKseJdKXR3a2Q6nXLSzJq3AtZDhC01nERxIX71Q5oNbfCNz0tFAgXhDVJenNiyUQiN9m/94TB/ApplBtUFLfiFCmXHM4l188VnRiu0k03kX9GiEUpyFLAn+d+n0WsU4e8nrjz5HG9IQ2O5F6FwHO96ahdWowwErstkFlR2YtpgMjvYjOX56tVy98rk+QL238GKcrLYQn3Nu+5ZpeInj9t5i9kObjhSEQ4/LzQ59/q6n1vli/0dz5H8YvVPbbzZRx+N+FzNf2zzigbmEoqb7lxuV8M9czGT4cCRdrBeiivFUX4hN9FqgMVfd/RwZ1uDOgFJyBDRytRUPcReQdISj5wv7pKBDo8RW5sXbLcKXVQtSX+U6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JW0hHUlOIgjLf8eflmO7jTbGNLlkqLZMgk5UJQzhFuvfVh/iNxVa+UwWExRN?=
 =?us-ascii?Q?oI+AsILKWfGfNp69QbgAIavzoamxyC7JjzJ26dkK+qYXrjFW/kD1Ksg+OGgx?=
 =?us-ascii?Q?rryNG9n+UMqIXyWJA47ANxOqxmT6CEN+uJGG0bR1JaGlnKL3Z+8xYpk2NJoT?=
 =?us-ascii?Q?1YyggdbN4/3ZJgRL6t0cooizQaCuJGUDmsFAdOHKkKzuA7Csdv6/U/7JSxJI?=
 =?us-ascii?Q?QXaGcaHX1FAG60VYUEfgrDaCMMaWga80xgoRkS0Q+mUBdAT5+19KeymUwUb+?=
 =?us-ascii?Q?PdL3dKw7cxnSPO/kHy2lCwXDI5782CjS/dqOCAsleAliQ7U9tQNj+MgKS3+T?=
 =?us-ascii?Q?0tjxRSZAJDCRRAyoBCtsI4anNr7QNcmVOSz69987Ea+fuYrds52XnNJF9lop?=
 =?us-ascii?Q?k/CC9IQ8znnVsfs7DLcAMnb/z6x7viKAuL95RRBKn7g688WVN/MGerpj5FMT?=
 =?us-ascii?Q?A7o04BeIvmFkyTWmwTlywG7WsZWnYnFTDvAUlW/IRCrwFlxKWRalbhwEqZjO?=
 =?us-ascii?Q?R/qhnaw2TZ6bVqLE153B7B+83XLjfrEG2GB+dks2T7AoE6ETGA/FT/qUvOsi?=
 =?us-ascii?Q?pcN/VHffT50XbjB1CbT46lZI3Qbv+yFFnu9KFE1uPInRNkoRUcY8Ag1ocfRL?=
 =?us-ascii?Q?talYcVUOpwGle4y16SIyLr7Fcz/sFk+I7VLOg9mYTMiqY/3JOXmbWOefRz6E?=
 =?us-ascii?Q?cs43D1LdWbtNwEg0y+7nF6mm7coMY5k68bhomOFGhCHHIf3dgTQNI01Y8Oe8?=
 =?us-ascii?Q?8mbjCkCFqSSRVeOve+muOcF4nYcKWJvkmDpqHXUZLHAyZL5J8J+szG8Ny9hY?=
 =?us-ascii?Q?9zbvFO/X2SwZUNDLz+01g5k/OrRPe9EOuXR7HDhZoEEEPBRft+YO1N8m0mgf?=
 =?us-ascii?Q?G3Iq8wGtbNb4WYc2mz36KC/8ZDhRfes2n11lSn7RiLkEHVgR0TYxI1dY52Nq?=
 =?us-ascii?Q?2nffn8GJ5aVIb8bqA3b5qIAvOG3Dqb9ngLHulPBa69/2vW367cG5v4fO1VZ9?=
 =?us-ascii?Q?KWDnmTDEl0zv2DTbSCg+3XKs37DfvPLAC2b6Oe669siLsYYMfs2RDWwSUHNo?=
 =?us-ascii?Q?5PSxCPhh62eH+xWoPupQ8xkr6K/htRjysBSFJUyTCKbH9WA++I/MUDE8BvuC?=
 =?us-ascii?Q?Eht+XsOCr0oHFFvZOvAfzH3HYyqvo1Z6bkZjvHX4vsm98wLt6RvOzlAm1/7y?=
 =?us-ascii?Q?LTYuEIh6SfRk5TX8ZeKsr5JIUo33XFjqNwLbqCPJRnpdTat8VdHq0S2jT5Ti?=
 =?us-ascii?Q?tZFP9arCqVNPnNU9XbtP4OkwFyq6qTIba44d2TUk3clTi2+uirhHrZbAi/M0?=
 =?us-ascii?Q?zeOyOvb/h4hYw1lm3N2/mj8Ifo1wA3SZFv2OgxTgT2Ivq11mhnNMyN6+pAJz?=
 =?us-ascii?Q?Hw+LumOmTGIhvMrR4oTXgNAL17vnbhBDQEy+EUg0cyOW+qxJUpQNJaEp49ja?=
 =?us-ascii?Q?87VZVRpzXXqYLDtancIElvHa6T8ClBPIo01pC04IwTuadbwTQ3cX/tz9kGLp?=
 =?us-ascii?Q?mmY1GA0WELfZpnqzNP2K69g3yaqFjetkzON6ToK33nTieo66OdF0xF0aWlmw?=
 =?us-ascii?Q?IlXYiZG+xyA7MFbL7NrtAdrFqtWat9yAQhkbNNqnM2w4PwUN6xeCDdhYN1tW?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bf3425-7fb2-46eb-40f0-08da9c82401c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:26.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQc3k7HVr3IGwe0sRtjKCxBqv1Hsr4jy1yHGakv+1uXhN/wVQr+obRAt/Fy0dsNUuRBQxr/6bm9Fnu6CGdpgZz8aoE35uG8R22CQ5olS+h0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: 4NLDMiQ1eB3kUIVyL4iLDznaZXH9wJps
X-Proofpoint-GUID: 4NLDMiQ1eB3kUIVyL4iLDznaZXH9wJps
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 87 ++++++++++++----------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index fce6886b8319..cedbc13af6ba 100644
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
+	int err = SCSI_DH_OK;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,6 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+			},
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
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -545,24 +562,18 @@ static void send_mode_select(struct work_struct *work)
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
 
 	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
 			 data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			 RDAC_RETRIES, req_flags, 0, NULL, NULL)) {
+			 RDAC_RETRIES, req_flags, 0, NULL, failures)) {
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
 	}
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
-- 
2.25.1

