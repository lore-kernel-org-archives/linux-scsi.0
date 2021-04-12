Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68229C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377866120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhDLAvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbhDLAvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0ifBQ070028;
        Mon, 12 Apr 2021 00:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=JN0ziAYtAIe6D+srvcyzf/NJ1jiroPgBih9e/KGSKE0=;
 b=Y5mb+jDbRj3XiOpmvVNi+DoUlBr0TFH8hIZGVr6rv0otYAq2tGFT1TcqPWdG/kSo9rdz
 AUdaXxdlpw+/mZHSpBBWdPb38hQLvhZLIVWRtsFRWOJPdFdBDlUnoaZT35xlFU78zQsI
 +xYv5dd6WC+SJEAyo8s4NYtfXBYZhPbMUFxCJutUhruqHXISZjmLWfCkUE4ALkVN3PRq
 VG7e+wc3cCfLapmoGunSBgijjHl8RtrnKmNTN1C6UseogfsGxvVWaMtxkh+7xF5IvQfk
 3MEAakw0RI4CZYzbnFaWmlXMM4nJGyRFee+cHNgHC1QvjaSF/iPpF7RXtnOsg9V8onL1 Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nn9ypj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:51:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aGvG037388;
        Mon, 12 Apr 2021 00:51:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 37unxur477-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qw/IQOWuyLDVU7HX4VP2c2cKF2V1s4PCnDxFz02oto0moRnUaXiySme93mnGnfA4A4++LMgGSCbsmqHCouPd96amv+zKcp9BeOdxykl9xPAyxnGlrKsrAfSoMFnTCLloLQyJdFmnnoOG/PadCfdZY76ciS/1wdpwUBlIt5IrgT1ef2w0xTXAPtalSIIW5NDOjnMyy0zw1/1si8d8o3GB8FHMXcIcC+VddPr+N5BiOk6DsWbgeMp10Luok6dEipXw9bAdU8nsacliST60lf+YIebRcYeVQ3M42zoKUicXrwlQEUOige6AB5Z60kZ62ITzSXVoEwK81j3QKOKGhasOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JN0ziAYtAIe6D+srvcyzf/NJ1jiroPgBih9e/KGSKE0=;
 b=FwoO/FuYOIcvf+/My6+SY73miztG1gHte9Di7qkY50tE0zdytczcb2h3y6TnnLBjCJTrZHoOcOdQlWc249dO9yaDctrF+IqWlFtnnDMnM2RBZSItpU+yu/z6DAf6BsxU4nUFffnw5Wk6jXgAJ1nZHYRyE9JZjwgC9WnD/CLHeqOdGDjYoQsSwWAd47qQkcuVJrfDF78mAM7ZfMPBnzMGe/HW+eQtO3oF/KqC+jPy5rHHL6i2TPXj3bh19Mu9/cy+1f2Sect+OMmkv8UplIbovsaTY2cvXCyZ/LkHLtr00voEX57a7fNbeUDviDZ/0xn0V64ak69yfBG9gMheL42oSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JN0ziAYtAIe6D+srvcyzf/NJ1jiroPgBih9e/KGSKE0=;
 b=JMCwsfVadzNTMabjWEXsuBog+SDDPDuPsXe3txALgLEmbNaQReWBRicCx9q4G9R8sDfpvO3qOdzuBpCzZxo5XM31ZkGVWbONks3MtwGGwITxNk4hBa/UyQHsidszyYLm5HOZRlHCXiwWVNkU5IKnwoU3tWxrVWiWr+SRNAs+61s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC v2 5/7] scsi: iscsi: fix some of the bugs with Perform connection  failure entirely in kernel space
Date:   Sun, 11 Apr 2021 19:50:41 -0500
Message-Id: <20210412005043.5121-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412005043.5121-1-michael.christie@oracle.com>
References: <20210412005043.5121-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:5:54::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2559200f-7d3d-490d-a4c4-08d8fd4d08ba
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43078E147A770E283DFD9321F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZyZfEb/wEd9yW3SWT14F8cqPHnVXF0no7ulgDwh6OFmHt/uSBbgnsLmKWHk+95qQnFh7LrSirHwmoplOSdDeAB+8p9VQfqbOeAnu12CfqL4joH61A+oM7Dk7xi1UH1a/AtQxEjkwMWZPRmdO35nhjDM+1QIQrIV7dawa9gZUS0vVlAfHrCKXTJJhxYpn2xhRi9UpDuBUDBdtJj9oAU+d3oUzTzXyuhJjIq6P7zxhVoXjGh8IGP9kZEmJLfpqhSQ5w+KMXXrg6HqewK/JdM2Q/SFHCGNhjWCCnNgGaUSGe3MCsKicZ419oCERWvtvNq97vKJNwYwixiBSNpPFIxZ0YkU86IgY9z0NKazxLLOvSovbqmjNUtEkdM6pl4lYyb6CdCiDvWjyJLrz15NpZscAdeGsnQm9g/sYiqlZuej9d9KRqUyTEyYh1p6ey7NY0FEMFUrgO7Fi2HNJ/Yj61wfDF5DOQS7riWfumZsEjWq0AHFAmcXdQ8trwRLrIR6ZhBHzkcoVNpwbsCS7I85ItmnGdvV0KRvGn+3NNrdHu+d8EoYApelt+dJBNseWTdwWhFtg90guFeKV+4OowFWD4x1bl+lnX1lfIoaHTDrYpcMMNu3L8Ds75eeYtAFFUDBroxCgJx2M1oW3xaM9/gsyp4wqrGaTXDytTSDwrRneZy5NBlJv9PiGowBAnzic3NHvxWqU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(30864003)(86362001)(83380400001)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OxuWrC8uH9ks7dMvBg2VzVMowKIURSFtO7BnCeq0fa2gNS1EJbtF1DMLgYyV?=
 =?us-ascii?Q?UfV5+j4udijJUho3D97aFHxNN9aaldYB/UI/EFQpegZ5E748PelutwoxImGW?=
 =?us-ascii?Q?xp8dkNtIcL/YQevSSSiW0TV/ftXovbMG9Q/VI1jAb2IzkXvuLzAuPxXFW3bm?=
 =?us-ascii?Q?aI4rr84hMCVx/rENGs9Rni3FSazuMRsEO9MQrX5BhsdjVx+SZL6PLsxMDiEX?=
 =?us-ascii?Q?KVG+yMCrpiH8axlZzeYVBUXHEm0AlNO985ULGFcsR4TpVugR8a3Woj7aCIxA?=
 =?us-ascii?Q?mX7hdW04POiJZTFxFmds28CdFPZnryszK6o+mlOQ45kOhL5I/wmNbNqUZTSx?=
 =?us-ascii?Q?x/8NQp7JLQG0lAPoAULxAcG9irC8Ehw/3TjNhLEc4gIfhU5H5CCQk6VBMEGQ?=
 =?us-ascii?Q?EV4cS3TsXSxoRMyfvyI0x1lQSFYEnQJR/Qg1+iqCsv4d2Vn+8/58ULSMXtQj?=
 =?us-ascii?Q?FtdcPtekeRoEVkFlbge94R4p6QrpZU2oQAvv67f9dvHUH1IVH4f/5Ro4h6r+?=
 =?us-ascii?Q?CR8im3u4bhgQo4iwsBswDStbCf3Ap/wqYfkvUYr0v7WV+IbCh5eHTmAKhqT1?=
 =?us-ascii?Q?Fx9Cxu2jul7TI5dMSOKH1zJ/DFcg/wK7l/gUJIiFGD6FXRdl+867p9TW6xWQ?=
 =?us-ascii?Q?Y4CqD3tgPuPnQ9vVS+6OK2inzK4jv2UdmoMgNrIPzQ38e4gm+7pZTVdDqZF1?=
 =?us-ascii?Q?TOB/VGl31cbfDC6gepddAIVM2jvFA6k8irHsjqREpdsN+9SQRoRHxknO/Ozh?=
 =?us-ascii?Q?nSq1ZeXxmKkTE5rPk2iaEWCnrd2wJ3qI5ESM8EzBdsWsjMVsQMIsD+0PvSa/?=
 =?us-ascii?Q?/uwnBmALd/2TlqibUg9ZYdshKCtz23vM4YntctXVN4JpsLXbFbP6Ia0rhTmX?=
 =?us-ascii?Q?K4qi6hUOgacT8dLUWjkZZ7RaoWIVYjEKNNhoufrtbR3s6yE0Je9ehXylASJ1?=
 =?us-ascii?Q?GIVBzxo/Ky+jf3qQLEPSerf8I5C9+GwhgMrJdwtX59xZQRrt+yeNna6RzTgx?=
 =?us-ascii?Q?dXuVeaNnQVCJFwUxlp4QUQTou/wNscrR6dD81ouiMhTF1nh5htXTfB/TNyDS?=
 =?us-ascii?Q?XlNz5J5fuTNkpM7sLhDFaQDLUdS9gNeML74rwBD7lM7uu86uPNNKgDXuLeyT?=
 =?us-ascii?Q?FO1CoW6kAnZfheoXEpVGQwpe7h6HbGcU0kgo3LGVzpDXWzoJilxSUiTJuF+L?=
 =?us-ascii?Q?4+r7eNkSjeCa62HZJ3rD84yki2TMblYV28uQ6OsFS5MSUuSen4yz/QH3jas5?=
 =?us-ascii?Q?WaTBOJAzgLq2SAAIBp5CRXEEHxoQ2pM4vmar4t/ffIP8uctkxGgXTEJQHv0z?=
 =?us-ascii?Q?TWz7OcNx+3mxVRXpouzcfCbR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2559200f-7d3d-490d-a4c4-08d8fd4d08ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:57.6032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FH+pgpG35iS362DeBBrflJcOpvCTpgrBb4iXmnrE0l1uX7nS4/kOnJ9FcgwRiidLMvMd1CpPrNi4+ztmfHMcG8qY30GKTs/l6dfdkHPLZvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
X-Proofpoint-ORIG-GUID: wGo2HI4k4_GhYB5SbZiQUFNJG8Z0R5c7
X-Proofpoint-GUID: wGo2HI4k4_GhYB5SbZiQUFNJG8Z0R5c7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space") has the following regressions/bugs that this patch fixes:

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new IO to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect if userspace is not up.

This patch only fixes the issue for offload drivers. iscsi_tcp will be
fixed in separate patch because it doesn't have a ep_disconnect call.

2. The drivers that implement ep_disconnect expect that it's called
before conn_stop. Besides crashes, if the cleanup_task callout is called
before ep_disconnect it might free up driver/card resources for session1
then they could be allocated for session2. But because the driver's
ep_disconnect is not called it has not cleaned up the firmware so the
card is still using the resources for the original cmd.

3. The stop_conn_work_fn can run after userspace has done it's
recovery and we are happily using the session. We will then end up
with various bugs depending on what is going on at the time.

We may also run stop_conn_work_fn late after userspace has called
stop_conn and ep_disconnect and is now going to call start/bind
conn. If stop_conn_work_fn runs after bind but before start,
we would leave the conn in a unbound but sort of started state where
IO might be allowed even though the drivers have been set in a state
where they no longer expect IO.

4. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in kernel space")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 440 ++++++++++++++++------------
 include/scsi/scsi_transport_iscsi.h |  10 +-
 2 files changed, 261 insertions(+), 189 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 036486310260..54be1e9a845b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,12 +86,6 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-/* Worker to perform connection failure on unresponsive connections
- * completely in kernel space.
- */
-static void stop_conn_work_fn(struct work_struct *work);
-static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
-
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_mgmt_workq;
 
@@ -1625,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-/*
- * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
- * against the kernel stop_connection recovery mechanism
- */
-static DEFINE_MUTEX(conn_mutex);
-
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
@@ -2247,6 +2235,105 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
+static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
+{
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn.\n");
+
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
+				      flag);
+		return;
+	}
+
+	conn->transport->stop_conn(conn, flag);
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
+}
+
+static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
+{
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
+	/*
+	 * If this is a termination we have to call stop_conn with that flag
+	 * so the correct states get set. If we haven't run the work yet try to
+	 * avoid the extra run.
+	 */
+	if (flag != STOP_CONN_RECOVER) {
+		cancel_work_sync(&conn->unbind_work);
+		iscsi_stop_conn(conn, flag);
+	} else {
+		/*
+		 * Figure out if it was the kernel or userspace initiating this.
+		 */
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_UNBIND, &conn->flags)) {
+			iscsi_stop_conn(conn, flag);
+		} else {
+			ISCSI_DBG_TRANS_CONN(conn,
+					     "flush kernel conn unbind.\n");
+			flush_work(&conn->unbind_work);
+		}
+		/*
+		 * Only clear for recovery to avoid extra unbind runs during
+		 * termination.
+		 */
+		clear_bit(ISCSI_CLS_CONN_BIT_UNBIND, &conn->flags);
+	}
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
+}
+
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep = conn->ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	conn->state = ISCSI_CONN_FAILED;
+	/*
+	 * We may not be bound because:
+	 * 1. Some drivers just loop over all sessions/conns and call
+	 * iscsi_conn_error_event when they get a link down event.
+	 *
+	 * 2. iscsi_tcp does not uses eps and binds/unbinds in stop/bind_conn,
+	 * and for old tools in destroy_conn.
+	 */
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
+static void iscsi_unbind_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
+						   unbind_work);
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+
+	mutex_lock(&conn->ep_mutex);
+	iscsi_ep_disconnect(conn);
+
+	if (system_state != SYSTEM_RUNNING) {
+		/*
+		 * userspace is not going to be able to reconnect so force
+		 * recovery to fail immediately
+		 */
+		session->recovery_tmo = 0;
+	}
+
+	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
+	mutex_unlock(&conn->ep_mutex);
+	ISCSI_DBG_TRANS_CONN(conn, "unbind done.\n");
+}
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -2286,7 +2373,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
+	INIT_WORK(&conn->unbind_work, iscsi_unbind_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2343,7 +2430,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2458,77 +2544,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
-/*
- * This can be called without the rx_queue_mutex, if invoked by the kernel
- * stop work. But, in that case, it is guaranteed not to race with
- * iscsi_destroy by conn_mutex.
- */
-static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
-{
-	/*
-	 * It is important that this path doesn't rely on
-	 * rx_queue_mutex, otherwise, a thread doing allocation on a
-	 * start_session/start_connection could sleep waiting on a
-	 * writeback to a failed iscsi device, that cannot be recovered
-	 * because the lock is held.  If we don't hold it here, the
-	 * kernel stop_conn_work_fn has a chance to stop the broken
-	 * session and resolve the allocation.
-	 *
-	 * Still, the user invoked .stop_conn() needs to be serialized
-	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
-	 * it works.
-	 */
-	mutex_lock(&conn_mutex);
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_cls_conn_printk(KERN_ERR, conn,
-				      "invalid stop flag %d\n", flag);
-		goto unlock;
-	}
-
-	conn->transport->stop_conn(conn, flag);
-unlock:
-	mutex_unlock(&conn_mutex);
-}
-
-static void stop_conn_work_fn(struct work_struct *work)
-{
-	struct iscsi_cls_conn *conn, *tmp;
-	unsigned long flags;
-	LIST_HEAD(recovery_list);
-
-	spin_lock_irqsave(&connlock, flags);
-	if (list_empty(&connlist_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return;
-	}
-	list_splice_init(&connlist_err, &recovery_list);
-	spin_unlock_irqrestore(&connlock, flags);
-
-	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
-		uint32_t sid = iscsi_conn_get_sid(conn);
-		struct iscsi_cls_session *session;
-
-		session = iscsi_session_lookup(sid);
-		if (session) {
-			if (system_state != SYSTEM_RUNNING) {
-				/* Force recovery to fail immediately */
-				session->recovery_tmo = 0;
-			}
-
-			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
-		}
-
-		list_del_init(&conn->conn_list_err);
-	}
-}
-
 void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
@@ -2536,12 +2551,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
+	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_UNBIND, &conn->flags))
+		queue_work(iscsi_mgmt_workq, &conn->unbind_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2871,26 +2883,17 @@ static int
 iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
-	unsigned long flags;
 
 	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 
-	spin_lock_irqsave(&connlock, flags);
-	if (!list_empty(&conn->conn_list_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return -EAGAIN;
-	}
-	spin_unlock_irqrestore(&connlock, flags);
-
+	ISCSI_DBG_TRANS_CONN(conn, "Flushing ubbind during destruction\n");
+	flush_work(&conn->unbind_work);
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
-	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-	mutex_unlock(&conn_mutex);
-
 	return 0;
 }
 
@@ -2980,16 +2983,31 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	ep = iscsi_lookup_endpoint(ep_handle);
 	if (!ep)
 		return -EINVAL;
+
 	conn = ep->conn;
-	if (conn) {
-		mutex_lock(&conn->ep_mutex);
-		conn->ep = NULL;
+	if (!conn) {
+		/*
+		 * conn was not even bound yet, so we can't get iscsi conn
+		 * failures yet.
+		 */
+		transport->ep_disconnect(ep);
+		iscsi_put_endpoint(ep);
+		return 0;
+	}
+	iscsi_put_endpoint(ep);
+
+	mutex_lock(&conn->ep_mutex);
+	/* Check if this was a conn error and the kernel took ownership */
+	if (test_bit(ISCSI_CLS_CONN_BIT_UNBIND, &conn->flags)) {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn unbind.\n");
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_FAILED;
+
+		flush_work(&conn->unbind_work);
+		return 0;
 	}
 
-	transport->ep_disconnect(ep);
-	iscsi_put_endpoint(ep);
+	iscsi_ep_disconnect(conn);
+	mutex_unlock(&conn->ep_mutex);
 	return 0;
 }
 
@@ -3646,18 +3664,138 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 	return err;
 }
 
+static int iscsi_if_transport_conn(struct iscsi_transport *transport,
+				   struct nlmsghdr *nlh)
+{
+	struct iscsi_uevent *ev = nlmsg_data(nlh);
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn = NULL;
+	struct iscsi_endpoint *ep;
+	uint32_t pdu_len;
+	int err = 0;
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_CREATE_CONN:
+		return iscsi_if_create_conn(transport, ev);
+	case ISCSI_UEVENT_DESTROY_CONN:
+		return iscsi_if_destroy_conn(transport, ev);
+	}
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_STOP_CONN:
+		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
+		break;
+	case ISCSI_UEVENT_START_CONN:
+		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
+		break;
+	case ISCSI_UEVENT_BIND_CONN:
+		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
+		break;
+	}
+
+	if (!conn)
+		return -EINVAL;
+
+	if (nlh->nlmsg_type == ISCSI_UEVENT_STOP_CONN) {
+		iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
+		return 0;
+	}
+
+	/*
+	 * The following cmds need to be run under the ep_mutex so in kernel
+	 * conn unbinding (ep_disconnect + stop_conn) is not done while these
+	 * are running. They also must not run if we have just run a conn
+	 * unbinding because they would set the state in a way that might allow
+	 * IO or send IO themselves.
+	 */
+	mutex_lock(&conn->ep_mutex);
+	if (test_bit(ISCSI_CLS_CONN_BIT_UNBIND, &conn->flags)) {
+		mutex_unlock(&conn->ep_mutex);
+		ev->r.retcode = -ENOTCONN;
+		return 0;
+	}
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_BIND_CONN:
+		if (conn->ep) {
+			u64 ep_handle = conn->ep->id;
+
+			/*
+			 * For offload boot support where iscsid is restarted
+			 * during the pivot root stage, the ep will be instact
+			 * here when the new iscsid instance starts up and
+			 * reconnects.
+			 */
+			mutex_unlock(&conn->ep_mutex);
+			iscsi_if_ep_disconnect(transport, ep_handle);
+			mutex_lock(&conn->ep_mutex);
+		}
+
+		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		if (!session) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->bind_conn(session, conn,
+						ev->u.b_conn.transport_eph,
+						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
+
+		if (ev->r.retcode || !transport->ep_connect)
+			break;
+
+		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		if (ep) {
+			ep->conn = conn;
+			conn->ep = ep;
+			iscsi_put_endpoint(ep);
+		} else {
+			err = -ENOTCONN;
+			iscsi_cls_conn_printk(KERN_ERR, conn,
+					      "Could not set ep conn binding\n");
+		}
+		break;
+	case ISCSI_UEVENT_START_CONN:
+		ev->r.retcode = transport->start_conn(conn);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_UP;
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
+
+		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
+		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->send_pdu(conn,
+				(struct iscsi_hdr *)((char *)ev + sizeof(*ev)),
+				(char *)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
+				ev->u.send_pdu.data_size);
+		break;
+	default:
+		err = -ENOSYS;
+	}
+
+	mutex_unlock(&conn->ep_mutex);
+	return err;
+}
 
 static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
 	u32 portid;
-	u32 pdu_len;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
 	struct iscsi_cls_session *session;
-	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep = NULL;
 
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
@@ -3734,90 +3872,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		else
 			err = -EINVAL;
 		break;
-	case ISCSI_UEVENT_CREATE_CONN:
-		err = iscsi_if_create_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_DESTROY_CONN:
-		err = iscsi_if_destroy_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
-		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
-
-		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
-
-		if (!session || !conn) {
-			err = -EINVAL;
-			break;
-		}
-
-		mutex_lock(&conn_mutex);
-		ev->r.retcode =	transport->bind_conn(session, conn,
-						ev->u.b_conn.transport_eph,
-						ev->u.b_conn.is_leading);
-		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
-		mutex_unlock(&conn_mutex);
-
-		if (ev->r.retcode || !transport->ep_connect)
-			break;
-
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
-		if (ep) {
-			ep->conn = conn;
-
-			mutex_lock(&conn->ep_mutex);
-			conn->ep = ep;
-			mutex_unlock(&conn->ep_mutex);
-			iscsi_put_endpoint(ep);
-		} else
-			iscsi_cls_conn_printk(KERN_ERR, conn,
-					      "Could not set ep conn "
-					      "binding\n");
-		break;
 	case ISCSI_UEVENT_SET_PARAM:
 		err = iscsi_set_param(transport, ev);
 		break;
-	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode = transport->start_conn(conn);
-			if (!ev->r.retcode)
-				conn->state = ISCSI_CONN_UP;
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_CREATE_CONN:
+	case ISCSI_UEVENT_DESTROY_CONN:
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-		if (conn)
-			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_START_CONN:
+	case ISCSI_UEVENT_BIND_CONN:
 	case ISCSI_UEVENT_SEND_PDU:
-		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
-
-		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
-		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
-			err = -EINVAL;
-			break;
-		}
-
-		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode =	transport->send_pdu(conn,
-				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
-				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
-				ev->u.send_pdu.data_size);
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
+		err = iscsi_if_transport_conn(transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(transport, nlh);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 165e629fba02..16efa4c6534c 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -196,15 +196,23 @@ enum iscsi_connection_state {
 	ISCSI_CONN_BOUND,
 };
 
+#define ISCSI_CLS_CONN_BIT_UNBIND	1
+
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
-	struct list_head conn_list_err;	/* item in connlist_err */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+	/*
+	 * This protects the conn startup and binding/unbinding of the ep to
+	 * the conn. Unbinding includes ep_disconnect and stop_conn.
+	 */
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	unsigned long flags;
+	struct work_struct unbind_work;
+
 	struct device dev;		/* sysfs transport/container device */
 	enum iscsi_connection_state state;
 };
-- 
2.25.1

