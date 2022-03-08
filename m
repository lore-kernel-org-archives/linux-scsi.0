Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9D6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiCHA3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiCHA3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1104F25C6A
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L8EUf022315;
        Tue, 8 Mar 2022 00:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YrcQoe3lxoxJAaVOC/CZP6kOtAcgVi6LcgYlA6Uryzc=;
 b=XPC6t15NYJ9Qn83S6p+T2Z3KHicBCrEP0FqCmScoL/gMeC8e4yqystPByOTwJvGVy6yY
 s89A16r4a8bYo+9IVINxuGQfg8DKvC4PojE4A9EnaCvWMyW6hZpOokDCzSIuSoECXU2T
 IIs3XLl1EXUgLYekugmSlJnxdfz9EtAnvaJpDV6UAfNHibUNEuXH21DwElenPPufrYOj
 fO10AMcgwFf7jRT8MHb6AB9b5XxffGPC0HqB0o8qJEHJhZhuIWqe3G30XTgy0C3Qs37U
 BEui+e87BcW8ZqTBZr1E9S4J5zSua5HHK+cnO/JkY+y9ZR9b8Q5x+D0QLAOR7UeTIVRH Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0njg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKkx134578;
        Tue, 8 Mar 2022 00:28:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajp96IP8z37K1qZGLa5JGwG8DARHnM/GHGQjNKLV5wBGiEDt3KKmWmv/Wd6Aeav1RcCxIulGZKzZbSwT+DuQs3HzYJdHi8Cx9+W3bN8nmQrTZv09oHT2gJR1EZEFPoLc5rU2MB2pm/k3I8P5BD5kab5kzRYXvhMM+pEY8UzLJ9K+AnZl1qFHSCHcqbhezeoRIweg7INyEaG4rM37n+oO4McH3Mt7ON1pkx/VBfLG5rpZ8RYxvqr93ek03sDfeHNp71Joi693qrJdRYLn5KwwkQqtwXFcFwuwloCiIpjjTIB3XsXEzaOeB5QCDcPyJybz3qSlvvPe5mgxDK3PZ/ydfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrcQoe3lxoxJAaVOC/CZP6kOtAcgVi6LcgYlA6Uryzc=;
 b=RCXzXa02AvSpgHUqBMDVcuI95n70QdHKgtWu0OkcPxlrtmEae2VmbZWfymM+agdj3wHcDXfQlK2Ckzu6h8ZL9BLz43KoVb8IVJEWWVBrWM++PIxw6fGQucMYnqQ3R5wqIy4uZRks5Dj7Y5r9LBuklV8qJ4b2Ta7sITJJKn8776ekXq3oRt/9ysvwUBOjHOFk96vLCMq85N5m7e9njcDaZtKn6VlcxIU1H8fgzFz/A1Q3hjD7rnxLghYoUABTk3ANoYp2354QPeFDJWHmWMsviG/pn1jnu9qDkQLgrs/b+IWTxLUi3xN+GJwSiC+Lfi/J2vTBZCyy9XMbAhNlxOOfkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrcQoe3lxoxJAaVOC/CZP6kOtAcgVi6LcgYlA6Uryzc=;
 b=c/xD4LsvhQKF2QUJzSqcgqI2ZuQo494mceebS75DWxdJ4pNAPlMlRDaRvabuLVMEwfg74XdPC4DzLrgb8XBOZI1Di3yIfvNBVbkdoS80Y/CPkGbe3nharyQOfv8XzWxsl6Ns+rALJUuqvKgcmZFy9NIGomdXIZwHJustN+cfdio=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:28:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/12] scsi: iscsi: remove unneeded task state check
Date:   Mon,  7 Mar 2022 18:27:43 -0600
Message-Id: <20220308002747.122682-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53952de6-b5f9-495d-b2bd-08da009a7fab
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB280940C8BC0C008EFB7491C2F1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXdCRE9NE3kYcJ0zfTRsHAfB0ludSRF7kJOJbp7h6EbY9zxqbg0xLfFePlnLobRcoRpjcN1dngJ3XKFZ2U/a1x3A/PBqOiV5F1w3gKlaIWh+/EH+I+wOeqQvnO3TfUk17BkVidJIywPYSUk9dg5we5Y0FCyLbR4wwzXzdCHRTDs9Yf8CQoMrj/UBDYeyC8brbJYMkxoXwbZ728k8rkUnjrUbJ8ng4w/383GU7d4j/BcIPyG0CWeTKVxMenk3EjxD/KHtC5tYYMaO6BjVsTOUGDEceF2KFvPXeYEQaI6SYnwQcgGlerjjSw0i+PanDh35ObB99tVaIRjsf/XARqKeScvFI98B9aQDW5ON3sC8r6SeI+5SjitwOjirykUaB3yJxnr7izwlDmzby6Ail9Qywwmagv4GBKVOl86Y7kU9cgWtv59bxOis+Vjh65HqnaAiXEMWj0Kgxy3UlQT58sf9P2J6fpYClH2vTQUAmc+1L8nTZUqodePMGFtL5n2RHpboLFWSQp2AI8LOaSdXj28Wwagv6X77udz0EyiA3NJpNFMH/bd6XetBzPdJT1FHEYXqnVRO6XdKoh9jN9L/kfAydwESr2stoHG2/ShKnTvW6Y4hrvZZ2AZuDgpOmVw9wcaT+H6RDDkdG5bx/3jNU+2SCJXRF7QTG70rC47+scnsffyCxqQFce//rJL+NrZOWI54++OvVJjiMYpc4n+Q8FPBIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eBWOWWInIQED0d59YiclzzGcOtqvc8iD374lx+PzCFTmFht76N7LtHZY8jVA?=
 =?us-ascii?Q?OrAGF7/ymI96kF88CRhMyGPV6Lg0CyM+oHbz5u7RK1X3rk5wgOdv4gYKuNhr?=
 =?us-ascii?Q?0v5JI7KMb2b6fBjYaAll6adMjaxtQOW//JdaT70xCOqyUB6X1sdJYuXNcK2f?=
 =?us-ascii?Q?ISiJMxcWnc7RgOL8EcKcIrWq/OlyUavhmOE8o4ex0n5WO/UUzJQgBk5zPD00?=
 =?us-ascii?Q?iB2iCDnmm0hZJA2ObTM3u6gOtI2U1mhCGHeVHVBtLmVO8GzYl3m/FjVj6TPh?=
 =?us-ascii?Q?fPemA8jZcadQi/OL66dF3qzn+A4N73fpCa2IhPrn8pH5U/a+x0aoOFxPrnF+?=
 =?us-ascii?Q?ddvmW5FEo9pU48aMZ1YngUH0dm9mgJsXYXsUVxCs+TlxxNJ6Nrgo/HKdPreV?=
 =?us-ascii?Q?C8gKfCvLhC6YLYUBz7DMEy1IZEgdq7SMWtNBgchYezffxvt0M037W1egDSTe?=
 =?us-ascii?Q?pxczwGqT9qkWM3Jy6fsznMxo6AGTK7MbZtO3VrnhUNEsxQi3Wl2P8EboZQD6?=
 =?us-ascii?Q?h1sbaEccOsQhWP5x1NMYLcX0cIKy7HpwnnSMu3EIsadYgEE1BWFcXl+hhel4?=
 =?us-ascii?Q?3j5VorXCYEjMDQc7cpH9A+J7g9mcyQ8t/UZNOs03NHZy/OlcmtL5pKPd/roO?=
 =?us-ascii?Q?hWOPwRq/25fNCjmqTDt0aVzNUlT5w9kKKRm6Zh5PQCCRsSiYBs5ye/yuTBGh?=
 =?us-ascii?Q?WGtJYk4rdGWbXDncXuDWKgrDPQWgjoWfzXCw/H6KqPBRy2IViy9ZnMKtuBCk?=
 =?us-ascii?Q?vWE87Z5pcH6b8oFYfGd8KkgIy4+Sg9tgJYUwkHkxc07nfayl6oZJXz+SGfG3?=
 =?us-ascii?Q?E/PGEeohakA3BqruwA4d1vr+wd3vAovFG22NTzkNsvon3pAInC4efM9DRJhL?=
 =?us-ascii?Q?9JveCS2py82tZMC22Z9NIzImvlfim+N/jUZ0i2riGCS3eAhiDkhPUW+lud/j?=
 =?us-ascii?Q?bjAofS+jv6kWZQEj0L+2aZgHNbVYz45FXStNyZVgkAp9q58NPMcMm9h4KT2y?=
 =?us-ascii?Q?y/7PHEmAGbHgnrmteUzs3KEFky5EHn1DahkR3ESKCSjlHB6Er5GeVaRBc3G6?=
 =?us-ascii?Q?r0fB8EmZ7B4FrVFU7vvTEGANsvFdt+s4HjkbDEE8hL4mYT5proljht+y583L?=
 =?us-ascii?Q?5gd+/3pPLtOJuo5OCkeaWN1JI1POohhudPZC7nSA7f55Qdf5X29S15YIOeEL?=
 =?us-ascii?Q?oOxxGyMRdPYQ7l2l6vDdKYdDlZMFReBicgJlETvLC8F/Pfpqi1SRr+xhZYlU?=
 =?us-ascii?Q?2FrgCk7H9Zt35yF64UBEhf5HJfoEH2FxWqjXK+J2Y4k6cBXg6cyYyALOfYkV?=
 =?us-ascii?Q?kotfU8tX/XcuAXG9O07ssTc7VEtKHDRkTzomLUNyFJqohUZU2VwPPP4uVwjT?=
 =?us-ascii?Q?CCOO4dj7zEgHSxsbbbLzZvvFIA/RIAujL4JfW/1NkdYnnHroJtSelZzjem9w?=
 =?us-ascii?Q?TXh1USM+aqbLcRGcbPPO5ZFV/dwWysdPi8E5LvkrjtMDUuZsJNh5YLfQwh46?=
 =?us-ascii?Q?w0NBW3qJbXPGkSlmW/7p97Y01xfRUuP5W6MaQSg4KH1pSvaCddbh3c4OzN4J?=
 =?us-ascii?Q?4Z15ggNIWm+aAphif4l3UtQaQBL2w4tA91YVYQ9NVMExvZ3KUstS43222LQw?=
 =?us-ascii?Q?msSqtqIpUhOlSbNqs9Zof/7ZsRcNUu55nqqS3DTormcLGSO9ooR200SRXFnt?=
 =?us-ascii?Q?ZwHQ2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53952de6-b5f9-495d-b2bd-08da009a7fab
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:59.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyzu53WnMxJ4Zubhw4b2VpeNY2CoyBLO5cPzJdzF7YH346gnd6MJaNNZEERmjWroJlvZ1foXrSkKLnaLBWLFSeXWI7eHi/fDrOCHvfjPPOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: XTQbcyllOQQqR9ebzTB9cWWKvGZCq9Vx
X-Proofpoint-GUID: XTQbcyllOQQqR9ebzTB9cWWKvGZCq9Vx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch:

commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")

added an extra task->state because for

commit 6f8830f5bbab ("scsi: libiscsi: add lock around task lists to fix
list corruption regression")

we didn't know why we ended up with cmds on the list and thought it
might have been a bad target sending a response while we were still
sending the cmd. We were never able to get a target to send us a response
early, because it turns out the bug was just a race in libiscsi/
libiscsi_tcp where

1. iscsi_tcp_r2t_rsp queues a r2t to tcp_task->r2tqueue.
2. iscsi_tcp_task_xmit runs iscsi_tcp_get_curr_r2t and sees we have a r2t.
It dequeues it and iscsi_tcp_task_xmit starts to process it.
3. iscsi_tcp_r2t_rsp runs iscsi_requeue_task and puts the task on the
requeue list.
4. iscsi_tcp_task_xmit sends the data for r2t. This is the final chunk of
data, so the cmd is done.
5. target sends the response.
6. On a different CPU from #3, iscsi_complete_task processes the response.
Since there was no common lock for the list, the lists/tasks pointers are
not fully in sync, so could end up with list corruption.

Since it was just a race on our side, this patch removes the extra check
and fixes up the comments.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0a0076144874..5c74ab92725f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	bool early_complete = false;
 
-	/* Bad target might have completed task while it was still running */
+	/*
+	 * We might have raced where we handled a R2T early and got a response
+	 * but have not yet taken the task off the requeue list, then a TMF or
+	 * recovery happened and so we can still see it here.
+	 */
 	if (task->state == ISCSI_TASK_COMPLETED)
 		early_complete = true;
 
 	if (!list_empty(&task->running)) {
 		list_del_init(&task->running);
 		/*
-		 * If it's on a list but still running, this could be from
-		 * a bad target sending a rsp early, cleanup from a TMF, or
-		 * session recovery.
+		 * If it's on a list but still running this could be cleanup
+		 * from a TMF or session recovery.
 		 */
 		if (task->state == ISCSI_TASK_RUNNING ||
 		    task->state == ISCSI_TASK_COMPLETED)
@@ -1484,7 +1487,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
-	if (rc && task->state == ISCSI_TASK_RUNNING) {
+	if (rc) {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
-- 
2.25.1

