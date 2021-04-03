Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB2EC43462
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF066135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhDCXZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhDCXZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NP2TJ088104;
        Sat, 3 Apr 2021 23:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=65jqzbwLvfQYj5//EyEY0w0SZCXjqEHPn6Sjs5GZ+F8=;
 b=Yx20doQRimv8PvTZI/JcI1uSH5zwflPP5MNLfdDKHRP8rPxOvnmn7KI6f++UqoWXj+xD
 lg5GiHDdMqNBt+6Ng432ddhPaPYyb7MJ6t0e3WrltHnrK08y5eDbpG37MbK+matqSkQb
 K8wc/ZuBaL0o+HosJQmyiCU7CquLfxB++YNl/hqfuRZ/+gjDV6Bu/KZ/yKnU2lgAqgvB
 sIFr7gh4XeysiosK01i0ygCwIE8OpAYlzOuVlHyhBHiuzg4LtgIb5Awndmb8Bi4TqAnS
 eMl1iZtp5muDwTk1ewrF/Jv2EJaoMDVeY3JKcX1eI2xfJaGBL8gPBXJ4cvTzijPtnsdj XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37pq66rcve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBY117020;
        Sat, 3 Apr 2021 23:25:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C66kCMmZvuqZ3qWbEgmGcYmNNNlaZmukSfZVcSOK48XDxt3WGpoyP/ZjZ31tJrDNCw6T2TAJtDjDxxDsMhX6ji+gV5tBk9Bl0ctai0LsGbAI90piYdMvRLwntzJKRiOBJ3A/ltfYCWF214pKeoHtbhLPqUANNEqQFNR+zPyUf6G3kdRtyegyUf+39L8+xXE5qOVNi/SNBKepJcXj5Y+/rrpVznHjXuxlbWPAzJgDd81ScqzI9XpIW3PMGuKyZc7vuPsQWzOEMFHFsLFXUg+caGCiyedo2T1IZvEuDn+L7YUm0KhnuzzZ4nXLuwJW2roTf9ksF78qDria49qHzm8ntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65jqzbwLvfQYj5//EyEY0w0SZCXjqEHPn6Sjs5GZ+F8=;
 b=Vr82fiELqx7xONVreodybeE00gLZ14kMEiXGP6vuxmfbvOhGs7qItcPGdCpNpqCvLNsWnhntna5fkTBwSZDzwCAEGKszVI/bbRNIOH9AfL66LD55Vq5uG4uunozSABGqrM2MLI+JnGsYFgoM0/w9nmFHRcipDFLdHFWg/y7VYm1IQZeaXg5BMP9oiNhwJSaewkO1HNPTNxffjaIBFE1gkU7eUWsiZ138n7ad14us7XBmQZE1WULKTMuWyfquKhy/LfM7zvkW1rXvQ1E/9tRdYPjAASbVbSqHC+9L/xB8lQfypuOsjAnj3RzDFeq0xGYy7oHhH3mzgblsHMY7c//WUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65jqzbwLvfQYj5//EyEY0w0SZCXjqEHPn6Sjs5GZ+F8=;
 b=L4aJgF/+AwNRq1ktNPC+VgRJefK1M+inpTbyhUN77eYUx1eN+vs0kPM+qE0Hv6pLizOkEJ4WPhwXlBW0QX/Ug/qoJ0RXcTMTraxFMBnBqxTRi+g2C1MaeQu+Pi1p8iUaZhOdeHswJnwNXfry85pPgO5l7xACL3uJB5YvdE52TjA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 37/40] scsi: libiscsi: add new task state for requeues
Date:   Sat,  3 Apr 2021 18:23:30 -0500
Message-Id: <20210403232333.212927-38-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f95e3a5-67c5-4e38-cdad-08d8f6f7a34f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431B2A5E20E97351402F635F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOTXtgulMlxTZmogelQmrhbxgILDybs8u2vQDqtfNyTftag10Qvx7L68xeikwcpHYGA01SwmJXd9x++EpAcGFmSmQ7K6JkS4IHeZWGIhzxLVFK+t+Tl1zWgU1kvhlV72Ns111aWZm45HE+d3aYFuoP3YqDku5uPZDjWBFPzbjNGLFAH0NyjLPQ33K75S0zCrmS72zXHwLK3sp6DrTGQAjZ7xc4oWMx1Peae1CIKgM8lHqaW/A+93H5cMkF3P6vm+j7AM0KiCtf7N/mrc0eL7Bftwl3wvnkJQlUJZolNPiFK16argla2d0ykUUP3QFjWDkZ86D+Dqw5Mc0zaUUgPIi1q23PvDVhhKGJgZvkYkGPK31+EpZTTKJnE9SFAMVnlZauMIK/W3vTRbGyOHmZSFllVEciPyUlNY8iVRJQ4XG//fpPLJHAf9sDQ8Q8mRk2QySbwb4VHWdkSRVH9AM0EJW/q7jRupy+BPzOPqT6paezpcy2No7La/3ubOQaIgarxeSmTJ2yRxOGdmToBHH6Rui4VUK3eQ518lscoBgsUW5dYKLfh+o3ky1SzEileB1maXr2WRfNgkE6nsqnO1c02suVMzjr0bEPeah4Y6XOckCe6cPa6Prn5eSMxfJOTXq/ZUO3Jdn9eTEzZ5fSJnjNA6TimNIJ0Glvorf9/S4DnlTzpyMgN2Dgg5FmdgpsptWtZzQfVyWzjvx8F/ZCL39WXmCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xZWWXNdZ6fs7gRCQuw0gEaO1HvuRZX57z+mFeOMu6SmTUyZ28BmqL7y84cLL?=
 =?us-ascii?Q?/fP+NZjX0a5GeOuV5dmnHL4lmS3QIMk8L1SFCAOg/48kRFrtRHScC3ainQKA?=
 =?us-ascii?Q?IMm932CMidsVBq0CGFiwYid+u/tV2/xjD8sJDXx1aM3niSWW0ZVorgIvdT8c?=
 =?us-ascii?Q?fOTf4zJyd0okrUzVKLsajEjeoE4GPmxv0/suNTh0lysAMObh0Oyu2gzEn47T?=
 =?us-ascii?Q?JIh740d/LxBmpkTWlhmlee4BGd2SyKEl2lUlFShBfTP9kulxaohm1MqyGYlv?=
 =?us-ascii?Q?x2tQKXHkZYUjOnj/B+DHjLpMzutPRJuk2hNZCyykrwvQ+zdhvgxkHhClVFYe?=
 =?us-ascii?Q?IoCAfkckS9KuEm9vObHN8m2Aj3UsF5TY46mKDTMvHeCSDeSIllB3ntal8j3K?=
 =?us-ascii?Q?w6K2jh9dZhwX0BTMss+D6WaJIZM36p2SEhb8WVOgum7TJEdbYp30eQ+iUG7L?=
 =?us-ascii?Q?XKskgii+Ozi9Sqk0goD3AsgvkZyIBEZfqonlkg0CfOKygrAQsx7nO7Tf7kS0?=
 =?us-ascii?Q?X9tzzPLBgUwUB/r7NmcfA+498Q5H+DrUHxYg8fCfUWOujEEfV1RF9APLYKf6?=
 =?us-ascii?Q?BtJ2yU6Rj5/IZ3IwFNDw6RocC+M4289Ew5QfF0KxcuCaN2DZiZQIoe2n2yJl?=
 =?us-ascii?Q?GMWm8hC0Ts5K66QzbEgOly1KtVnJ2DA0uDIc0cXZPp3B9l6OAkDg3/WzSorh?=
 =?us-ascii?Q?aGYclApAhMyIncJzke/r12oQwWwvPw7e/Xv1vhTwre88xlr+W7PPaW+Wb7nI?=
 =?us-ascii?Q?niZWMMmmdl5sgpxJfXReJ7vQJlaR+yQVdGv4Ej0zzOIJQCRJ+Sn0jplffUPi?=
 =?us-ascii?Q?CpiLrEjpYcIJl2gwynqewmhQKkzKdk4lWLdzmw7wJIOr6p50CanX6uRisCxC?=
 =?us-ascii?Q?gdROt4p22QNu7a6zhfQy/NcAcotp91gb/MrFlH7sMqEHUzuPF6mQ+a14nAxr?=
 =?us-ascii?Q?1lnVRrzqyKd71h7uyPBnvJm3mrpiSe1iiwI+NLo/+2P+2upuy8v8kkB0seW4?=
 =?us-ascii?Q?aWw3ysdOmZ63EkSHKV/pB/5ilOe8baXWzhPS45LRqIPiZxUw4gjw0IP4GbcB?=
 =?us-ascii?Q?A+ncswzqLg8QTOuBCOp2+81AI4HiCyNRCRUc/hdou+VLFBMin/MAFX1stn3K?=
 =?us-ascii?Q?3I5Q6WE2dVNiWtMgldCmQOXJu3Xh6qGpMJ6CjGHDC49SROBAP8tL1gP4Dc8I?=
 =?us-ascii?Q?0J+upFZRDU/uLlG1ESXu/8cu7bJ3Iiaj3982FTzczc3Km2B80/0JpCfgpVFK?=
 =?us-ascii?Q?fjkL7KbWuqwu488ro7y83Q9Pbc2uHW/K+XBghImsMHWEsQcKd3fv2Dp7PPyG?=
 =?us-ascii?Q?9vOTTe1gHJS2e1T98b1EJ+9T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f95e3a5-67c5-4e38-cdad-08d8f6f7a34f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:33.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtxEp+bxn3DViFBxXFFMdmy99nEjbNeiqvopq90aL3dsNYDspv1aGa89MI1H0TWs4FYA9UGqK1BwB9G+74JAulu99mgpkT7rjBnBUSm7f4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: Zm3Fn9md9IEy65JmScfyLljx39omaGcS
X-Proofpoint-GUID: Zm3Fn9md9IEy65JmScfyLljx39omaGcS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a prep patch for the next patch that removes the frwd lock use
when adding to the cmdqueue/requeue. This adds a new state
ISCSI_TASK_REQUEUED so we can quickly check if the cmd is already
requeued for R2T handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 16 ++++++++++++----
 include/scsi/libiscsi.h |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 136531200643..1c134f721a56 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -574,7 +574,7 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 		 * If it's on a list but still running this could be cleanup
 		 * from a TMF or session recovery.
 		 */
-		if (task->state == ISCSI_TASK_RUNNING ||
+		if (task->state == ISCSI_TASK_REQUEUED ||
 		    task->state == ISCSI_TASK_COMPLETED)
 			iscsi_put_task(task);
 	}
@@ -1565,15 +1565,19 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * is handling the r2ts while we are adding new ones
 	 */
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (list_empty(&task->running)) {
-		list_add_tail(&task->running, &conn->requeue);
-	} else {
+	spin_lock(&task->lock);
+	if (task->state == ISCSI_TASK_REQUEUED) {
 		/*
 		 * Don't need the extra ref since it's already requeued and
 		 * has a ref.
 		 */
 		iscsi_put_task(task);
+	} else {
+		task->state = ISCSI_TASK_REQUEUED;
+		list_add_tail(&task->running, &conn->requeue);
 	}
+	spin_unlock(&task->lock);
+
 	iscsi_conn_queue_work(conn);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
@@ -1639,7 +1643,11 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
 			break;
 
+		spin_lock_bh(&task->lock);
+		task->state = ISCSI_TASK_RUNNING;
 		list_del_init(&task->running);
+		spin_unlock_bh(&task->lock);
+
 		rc = iscsi_xmit_task(conn, task, true);
 		if (rc)
 			goto done;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c053de831c2c..358701227f7f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -95,6 +95,7 @@ enum {
 	ISCSI_TASK_FREE,
 	ISCSI_TASK_COMPLETED,
 	ISCSI_TASK_PENDING,
+	ISCSI_TASK_REQUEUED,
 	ISCSI_TASK_RUNNING,
 	ISCSI_TASK_ABRT_TMF,		/* aborted due to TMF */
 };
-- 
2.25.1

