Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21996C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 21:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3A061159
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 21:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhJDVI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 17:08:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233226AbhJDVIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 17:08:14 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 194KLH6w029400;
        Mon, 4 Oct 2021 21:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JcFyqZjxBImQt38yVnPq4codf6LFPAfI0IUMw5POhXo=;
 b=09+eIFA8eN57eCZYzPiHWKR1+NAmV+C/sblPrSk+iOklRMQBSzWndZbLN1MQkOC8mLME
 MIuPIkC6M8H+OcCbICFnFp5gZXu1hox+oBWiuoUY0h6GayyOAe63UHItGAe33bDYAVO8
 bJuFlAc1Im9/bQdPX6tV1rLgD+tCz7x8vJg/iyVMr73BkzTv8a18gdbOPFy/sgwT/JvW
 ya+OoBci0sLAfAolGOvAHcFwweyqwAucONW5rzOa5mbxuuDxI7o10jybvHLZTAGIRx8N
 CsPzn265PAW/P91CdM3UXCbLYvsmtGJjio5piAVhIr2mQ+l+Olkyh52bilDlyT5G8mOq cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kjp8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 21:06:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 194L6Gcm128348;
        Mon, 4 Oct 2021 21:06:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3bev8vrbkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 21:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb8KbrsV1uF9VdSyvQiYymJqkjOIzkMcyP0fQduy+NnCeM2TjfQ1mz1r8ARnfYuvwKm9Ugx1JqE073Xlj3+rPB4GHWO3hk1Nt+YbhVkP9avS5SqrkgFizAl5WS7iR4zCGNPPuRFBxSnzm7c/hPdngHR/V2Z+jmw582od1cVepbUaNEvqrDMvbus8GObgh1RxVjCBLqTbPN+xYqxu8RYS6C34eD3GgJPEbF49r8M+OoK157XilfDDkgE0eqZLcykLqvQkfViV2kvoo3jBmAG0Vy27HhfeEC7e7LSKibK5MQbYJB5GLdZSA5DHItSFfwNWct/mC2/N9W7+skO1CMNjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcFyqZjxBImQt38yVnPq4codf6LFPAfI0IUMw5POhXo=;
 b=fzkK/+sdXyuaV6YFpHu+fiwYBXsbsQ4KRMGN4lLiylc2DWXGTP/nV3eGomOsBtduevPoJ/iX0aZgBRsucrb6RT9zha7ogyPlILtbpN0FfDWxCVq/0bK5WC/k1EAwK6h5cZgv2uhR387MMgPq7HhaexKEPLe6+rMSJtueRASvDxR5WUKA7PKsejf2P4GrvqsemNp3nKKsi6P6aRZQl/cJtVcXBt8J9LOoMq8IL/FvaJPpExyFRK0FvpIjaGuUKW3A/UC+xdD/uIynRT0DOMrPCVBJ/315livTKyg+T/w+Nov/sEGf6J01Wtfy+WLQyR0/JLaHjIaVAxJ4jOOA/s+dHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcFyqZjxBImQt38yVnPq4codf6LFPAfI0IUMw5POhXo=;
 b=l52tJi5ZmnTnWS21fqdSOX8kIr5VIu5PkynjVboJXHsHI4Lo+P7olk1pbP9e8/ttFU6FNsMKuhshDaop06WKRiKpZHGp4DN6sm4uy3v5kkApxiVOlwE9HdGXATNFwZrrawQSc1kBmO+8HdBxpSaOSFG7MF7LZ9tEee+LE43xhJo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2668.namprd10.prod.outlook.com (2603:10b6:5:b2::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Mon, 4 Oct 2021 21:06:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 21:06:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: iscsi: Fix iscsi_task use after free
Date:   Mon,  4 Oct 2021 16:06:08 -0500
Message-Id: <20211004210608.9962-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:5:190::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR11CA0026.namprd11.prod.outlook.com (2603:10b6:5:190::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Mon, 4 Oct 2021 21:06:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e234b9-eb5c-4e7f-33ce-08d9877acd1b
X-MS-TrafficTypeDiagnostic: DM6PR10MB2668:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB266828092B75AF0F090C8A21F1AE9@DM6PR10MB2668.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9e8f9ksTPdX3lzPfsa1egAUdPDgNeHBdQaG42z31von5LDm81hpUET29Z6j533M7o0EFKZofh6WTRgbztlbxMJ+VOY05QDmgZoW2q6c7vzOkGNlkRjcJaNTL1rYBqI9rbRr90fli/RU+zWKNkOXkZClpYBIHMMNbzIwyPt7bbnRWqQih9TdX3xYVoSHYh7s24i4PGMKzCC7d3CbWNWhOfQehXMzjhDK5TSEORTVXEexQJXS/BGd+TqlcVmEYGOelWHu+4UC5aumLTXwf/TXO3S4fx7hMIeXcXnetkcUYKPH8opYrFwQJiQ3rEkTt6+en3+39ys91ksSeaBVxnvBHKcbZkso3nWgVEbFZFFS3WwivCUiv7TiofxxKtoVrWB2/TPEewIQv4fIYIkoIfzVeNmJcqYDvdgaEX1C+U+iNDgAnwJ7Dd15StAhdFvUkaoArK4Xu3QFoPMLUikzUYJ1uNNbpoydB+proEzzkVB2FTb+hlrGou0o6zpSFY4E2PGvg8IgMVZGN7Zppr8HzqgzkNFdxtAi6coE1r0dVCqedhOEu7c0moXq3C1NSXi+j97aeRmhG8O6mmhpmhy3HEBE7FhIfTiGEFAHkUom15p5EtmZQVqX9W6zO4qv4EfUeVOvqP5w8vQ5RNPGyCzbKKFxKoNDy2Y/S9XzZK1UrSydvo//rgF0W1DGbiNDp4dsTEucxWmHYlTe7USeGYAf60H9k1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(26005)(6666004)(508600001)(6506007)(2906002)(6512007)(2616005)(956004)(52116002)(5660300002)(36756003)(66476007)(8676002)(6486002)(66556008)(107886003)(186003)(1076003)(86362001)(8936002)(4326008)(38350700002)(38100700002)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhUo+nO7a6fCwXNwq02/VQqSHW4uvfr+xZh3OYWWpm71cbM97jBJs9qDqQ7T?=
 =?us-ascii?Q?tVK4M5hNQ8MFzoCdD6gTJ4yJzHLUaLR/dE3cadjGbOedo4vFuuLxuup7jIuF?=
 =?us-ascii?Q?rh8bFsly8P+AkVK2+IUcjg1ZR7FLAUsv58qvhhTF6PiKJdI1KtFGq9La9sjJ?=
 =?us-ascii?Q?m4l9lfTBNtV9wPV+m+42/aChU5z26glzJ7lkyUR8mShIUfRkkvI9qVIAuNIX?=
 =?us-ascii?Q?9vw/Qh/lPLdIx0Mp6ptPxICtZQYFsmzPW50ybqvHzDRwjzcFvIs1Zk8uwKwx?=
 =?us-ascii?Q?L1vzuNHkJKGKFH9J+n8E3yrN6LXAxnI8o7HtfL0v/1Z3HVOqgxjcDwp/9HAE?=
 =?us-ascii?Q?da/e4lepRQpVcDKuGABS6gjmDT902r9qOBBdTHmE0mmnnJ0bqs98+/KcIAmE?=
 =?us-ascii?Q?VcatGORHlAb8iMfx1w28fGbxMxw0li4XdLn/SplmkBKe+MX2AbwKsUOdKYyF?=
 =?us-ascii?Q?xz9gcbu4S2z6IyC2m1O12ljtodhRAQlbv56P6UuE7Dq7btfroEDSZTeMPyus?=
 =?us-ascii?Q?iw3IQEA5A2JtMtMUzdrZwHGZYKvfKdfB5j5pCGiQF8nmqWHZ+4sHMfeqPWtB?=
 =?us-ascii?Q?ASpoEgarDMdb0AdU5McZnz6Ud/+/ypjmOUXOSuNwaUkpxYQPUmJqYBFHpO5G?=
 =?us-ascii?Q?/XEUOwdvL4PMTgvbCQZTOSSLwlQe03ea9u6I5MK7/PDSwmJdLZSFa1zbjN60?=
 =?us-ascii?Q?33ZoJsLHIHBLhkUORPSejkdKzV8i/h6c5pbADxLyiRaBiOJmjdaz1KA+npW+?=
 =?us-ascii?Q?wllTh1C128oynO4O6FN0j6BbM3Cg9bWnpGx9ztecUG/enAtuXwFCoXiXpMLd?=
 =?us-ascii?Q?en1Y0pn+nuu5GrZC7j0ve4+7QyHzLDAsvx6bKum4TiO++04C4zUx+hN/nuhW?=
 =?us-ascii?Q?KQMJ9zQtAMaZIjJXFPB1VU3Ot2qccdBb1o1ibx3PJMDyDNbIpFZjbN3yS4Yi?=
 =?us-ascii?Q?HWyTROAL1JlZntMsTyAJ1gBI7Lo4zWYB7UTrOs7D7OARmIMoxHEShMDgxTd2?=
 =?us-ascii?Q?0w3Y1nOQ2yQRP1wCtWLKg8DbCE95HyexrTYJQi3Ag3LChoJFajI5p7I0IGnf?=
 =?us-ascii?Q?RRstpePk+ov4AXCla7Ig6d8nieeZEmawh9L3Qxz88QXItqUaZ/amlFzQHE1X?=
 =?us-ascii?Q?j7LjF+WHqZZmnOBVmxbNz8K8OanBbR9Ls0ctMlVxr6ON4ta/CvmWrnKgVZLf?=
 =?us-ascii?Q?2LPGKTlr7h0E1WPz+/beztS+PJbi6IcKHqf12ojBtTiDYYJLdxPC2cMgxV8Y?=
 =?us-ascii?Q?kV8xKLgDpzr0M4t3xPJYhmnKXsibXlvCMm3W8EBQwle5T2XZp3Mo4hPt4kmt?=
 =?us-ascii?Q?+6jNm1UbDiG2FzZJsVpjB+TQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e234b9-eb5c-4e7f-33ce-08d9877acd1b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 21:06:14.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xoYawXFegLzq+dehe5wyKlb5O0zjDsosLxf1qLwZ1GiMkygEBwbqMRjb5dzxq8kXTovg+Csvyb6eveWjenNfgg2gxtxwgpgkkkqCCnpgpbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2668
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=752 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110040141
X-Proofpoint-GUID: v5Z5kIemZMD9sOuG70EnD5m_92ZEe7FV
X-Proofpoint-ORIG-GUID: v5Z5kIemZMD9sOuG70EnD5m_92ZEe7FV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch:

d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")

added iscsi_get_conn/iscsi_put_conn calls during abort handling but then
also changed the handling of the case where we detect an already completed
task where we now end up doing a goto to the common put/cleanup code. This
results in a iscsi_task use after free, because the common cleanup code
will do a put on the iscsi_task.

This reverts the goto and moves the iscsi_get_conn to after we've checked
if the iscsi_task is valid.

Fixes: d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4683c183e9d4..5bc91d34df63 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2281,11 +2281,6 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
-	conn = session->leadconn;
-	iscsi_get_conn(conn->cls_conn);
-	conn->eh_abort_cnt++;
-	age = session->age;
-
 	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task || !task->sc) {
@@ -2293,8 +2288,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 
 		spin_unlock(&session->back_lock);
-		goto success;
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		return SUCCESS;
 	}
+
+	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
+	conn->eh_abort_cnt++;
+	age = session->age;
+
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
-- 
2.25.1

