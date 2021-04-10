Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABC6C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A4E610FB
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDJSk4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:40:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49856 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhDJSkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:40:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIWGAt167501;
        Sat, 10 Apr 2021 18:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=BuZ46RMQmFLVlY0N9hRVWy2/HAn/qB2ILyIh5aO05w4=;
 b=l2V3XzLHjp1lHyMI401tO8d3ek7fiVdAmdciE1z7lx+ka3Olr/2pjAi8AjAU9nzrHYO1
 aVNRH+ZKQ/A1WkgTqs1iXnfivmicjN16PMxEElqOQK3vMNkRK/RWR67KoTePil5NHo9N
 Q1XlQZy7SGZtQ1mWTOrSlTx7JP6YRiSAoQEIb4EEQmf6hQVVAoYMuwcjCAN3rpr0ZJ1H
 TZbqtNPYPQJaKcaU6RW2LkgbFbMRdhiGuF/UKGytMVqcK6m1rG3XaUNi3WpODzxqm/gk
 b6dJLDAddkF5x0CvAsEuf5nEzc7cdbbPunZ9h5Y2HZzN5KLhOu1eRSHO7lzXPrPH1VLY pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hb8vj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThCR176756;
        Sat, 10 Apr 2021 18:40:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4cu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFNjuy8a5HdR7V2MLln8fdeJQyO6bB2pDgNl3LIXDqdgEwalWsK75Ts9mnNqesG6U39ucfXakRnkQw23M66X8OCe5tVmNiCH5PjZIezr+iconskX+9I/v5yTr1bTWcAbP1OJNgM3ft/DYIxHC6GSNoHw5u4IsncHD9jWVMNJCWvmNPlypKBHD7HW+/h9jyZgD4u8eElnlQUoGY+Z+yRleZuM1nnNWuc9hXKu1J4jGudtXT6MwMrbKGgzwSd4PeGZM/ti9L4F3kl07VUptfKPPYTyshEuDKdvIpv8lDQBSOQKpqLverfnDylLnH2TxjvsSZHdlw0mr/dyIFJL7KqIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuZ46RMQmFLVlY0N9hRVWy2/HAn/qB2ILyIh5aO05w4=;
 b=Fu6ouIgrvb8mjpaFWNloU6YRsJzNf5zzRaZUmynPEmd/pr0f/fcKtt0GUHclNCKyXkKenQ24XTExUeGPwpqwR2N5DmKEkdTeh9tHx8Yd2EEnK/rkippWpr00ka3BqVOK3jEaVSn17BxgZuQBsM1yPvNbGkqZmGGJI7FW5rGQSYShEy+LhXqaStD/9HSPbK13LedzNnDdUridw48oBuAR2X/fVskgRhtUWzs7rvVH1WdKbglWaKB2TBl0PyHtj8sGjC/aa5TZAdS8HZ63ddpCkhvvywiQn9YwasDgXwoZRPO1xSRoR5LAuplabpwj9+PrQz18aiRJgDhID5Q9L0Nq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuZ46RMQmFLVlY0N9hRVWy2/HAn/qB2ILyIh5aO05w4=;
 b=A0W95+fF+okQIN9ap8Cln4OwxxQCqFKKsPxJRjPBIiAsd2RxGQetN+vbtCCmpoHRs534qMBKyQNcMRgKkvWHyiZpbbvYCbPv8MT61+rbw3xBq5lAUT5mC2ZqNgJ6G5CZ8xTJ8bVZhYSxdcp5kBVQmFUMMUcrZ3KutmvH3N2iT4Q=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/13] scsi: iscsi: revert Perform connection failure entirely in kernel space
Date:   Sat, 10 Apr 2021 13:40:04 -0500
Message-Id: <20210410184016.21603-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0bd29e8-9e8e-4caf-ec99-08d8fc501b73
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324B10C673E299E19B5638AF1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QlvsjdhKzMBoHwWlgEAIAWjJlMHBwfhiSuOjuuw9Gmbzm+D8JoQ/tlqiZUFw4v2lPVYGdIrb9ZXXpiJgeVW/SwDYAz4ezSOZWkfmGD9i7u/oks7woPKOB6l/f3cr8wJN+Rj2K6uoOGpiZR1f68j8ijMiUbEwS2CX/pdBVonp9YT+GLuPu0FtuE7n763JvUDEvhEFtrDfxKe30Nu+5Na1R7emakrSqwheTeHBgFCOEiu1KD2pmPPAv6Fw4HXitVJ+bUj+Tyn+AgAX5GXlCcManuoyE6Jx7aAM2go0ifcfCNYSCeZNWqECapp0lYnr6w+OTgJPjKucyrSJoGasaujA5xUOY0WMB2nTntFFcctLcEEUxNRE3FuPEI1lp/QZj0XA3/Q2xYL1Czr4klE31p1mmM579rL92cOMXHCZzOP+i//CmXnsTqjMg+znjk6tAfcf8BGjfFgaSyVeKOCSqqrZyI+dYE0Ukn8BNTzrQMPSDtVEpcOvKm+o1O4Zy3G9QKykEkrTFGWfT8JGkjqMNqZFOmzUfrnMRUDafJlQAz2QFA+Q0wDPCeLdx0oafdmGAhxvE04KkD7inzL5HS8lofGqgqlvyAVmd9vYK0tyBfHK+P0UGaMSqOzLAcB6HPdyBlXGswgka6XwJCooDc3eyVSusNVUbNz1J9dB+W313sWKZPb8TSF2oLH56le+PgQQ7D4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gP2ztaHlhhyEjYusCwjoENlAJ7gQzj/yFL6iXMqQf8kLZMIbcURBXI/qhfn6?=
 =?us-ascii?Q?Fhsdl5U4FPeieJ+kQ96xcqULC5bj0w5FuHZpbb39QEqH9Bbk/BizHJrh4eVw?=
 =?us-ascii?Q?yUks0BIMlkUvx3GBcfGuSSV/czmCvkPOa2T6k0bAoH2U6SJBY7MVtujmaCbE?=
 =?us-ascii?Q?NqKsUw36bvkHFRfr8c2AAaLzSvFkl/yEkbNMV3WWWg3XDzeaahn105A3Qhuu?=
 =?us-ascii?Q?fT2LelyQ55nZQ0QFiPJCWW02GJDYlV5WnpWbU+p87Ax0oF/O2EXNPLIyYu7D?=
 =?us-ascii?Q?UjUggqB0bgDlInFqZOg1Uitiv0bvxEcgdc6JBAcS1Dphh547o+ZLuZwV6MlW?=
 =?us-ascii?Q?VDJV5fQxlEBwmyBKXQSHg9sc9Gu0ZdYklQfYNAvKq1u28MCuRAbu6Ae34Gpi?=
 =?us-ascii?Q?HzAKkXwx8OtTyugwMnJzvZzQzmBUqcPWSqdMDh9oJ2zmbj20SMOqD+J5kV+d?=
 =?us-ascii?Q?AEL063D2V8a+6+tk0HYX1XBEA8/SbDjuDy/Xp6QbPhY3EO16VtQYymZ7HZpT?=
 =?us-ascii?Q?1cVu0vlbZy1UoxxGpffNCTkMB5gg+dUIDKBoZ2Tz3UWpt/SWtaxd26Jid0az?=
 =?us-ascii?Q?Bk5lboaBgtGvt59qCTYio9gK/AR+HtJgZq4CC+cQs29UOKk0PA1ahniFY6Zk?=
 =?us-ascii?Q?D0JZasVBkh4qb7ZZwbfvDxEnuzhO5huh/V6l7v4GAzfzU2RtkDWqOKFW7uIy?=
 =?us-ascii?Q?ik7BwVVUKI0VHZ25faBeoYefezBXnc4Z8m7cRBQdOEXTD2+t+OsiAzchQDTV?=
 =?us-ascii?Q?G+wpgAZEOTN0KbUhVqaUbaJcSrSNkkffhhsrSDG5pOBmzpju2oPwWsvSEwPi?=
 =?us-ascii?Q?JzCUAcBBpFPvKOkA18fzGhdJDZHaqF9nERWpJtEM9npW/ioXvRBPsWP1qgIx?=
 =?us-ascii?Q?IpaMezmmgvJdpsXal6LPAKefoONSbseFeyK2VfjRfDR8GL8pxvVYL7AmzK4W?=
 =?us-ascii?Q?juVs6v/6ku+bOavKIBcspOXVp1LPnoHsPaU/SJy46DWhL/lsI6Tzz8uz7O2g?=
 =?us-ascii?Q?R19BMF7x6Zw9Iq5QCoMhRHbvFvU4XzSF9sAXq03gb95/w41hZ7lgwgYc7IzR?=
 =?us-ascii?Q?fyhL0NkAOkXmw9AzodkJxPxLTilX9ukh9uxZwi43YHQV8kuJsG/OJUMQgL4+?=
 =?us-ascii?Q?KFqo6cRxHhVNfiflurfra4wp7UYURwCUKNnomdn7lcNwruBx19QmoUQrtip+?=
 =?us-ascii?Q?4adaWA12VEEze+5LsonKFze7S0JPP31JOHDreNUiY+eFs3ksknfwkFSuluq5?=
 =?us-ascii?Q?n6zTugk6wawtEU0CPy+pzXiVDLFkBCbhX3wn+QS/ZukeegYJskZLniV5OHWK?=
 =?us-ascii?Q?Xs6yFNwtAMidzVt7CZ8YDPQa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bd29e8-9e8e-4caf-ec99-08d8fc501b73
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:26.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0c8ZgKpWJOUSnZ9kjpWjr8pH/ERmulb/R9E4pHJWuc0o+YquYVokbH9JnfUt/y1plmNkkiGPdHHgPX0BM7irVDGlwpvWgTk6xuYtqgsyLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-GUID: 3Cmn7fE2OUL-48aa_C1mZm34yaCLiEQs
X-Proofpoint-ORIG-GUID: 3Cmn7fE2OUL-48aa_C1mZm34yaCLiEQs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space") has the following regressions or bugs:

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new IO to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect.

And for iscsi_tcp which does not have a ep_disconnect we need one to
close the socket so IO is not still retransmitting in the net layer
when the upper layers are now retrying the cmd and sending new IO.

2. The drivers that implement ep_disconnect expect that it's called
before conn_stop. Besides crashes, if the cleanup_task callout is called
before ep_disconnect it might free up driver/card resources for session1
then they could be allocated for session2. But because the driver's
ep_disconnect is not called it has not cleaned up the firmware so the
card is still using the resources for the original cmd.

3. The system shutdown case does not work for the eh path. Passing
stop_conn STOP_CONN_TERM will never block the session and start the
recovery timer, because for that flag userspace will do the unbind
and destroy events which would remove the devices and wake up and kill
the eh. We should be using STOP_CONN_RECOVER.

4. The stop_conn_work_fn can run after userspace has done it's
recovery and we are happily using the session. We will then end up
with various bugs depending on what is going on at the time.

When we add ep_disconnect we need to make sure they only exec once
and exec in order.

5. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.

This patch fixes the following issues by just reverting the patch
because I'm worried about the possible data corruption vs how long it
will take to fix all the bugs. If reverting the patch is ok, then we
should look into doing this properly and maybe redoing the interface
because there seem to be several issues with it.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space")
Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/scsi/scsi_transport_iscsi.c | 55 -----------------------------
 include/scsi/scsi_transport_iscsi.h |  1 -
 2 files changed, 56 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4bf62b007a0..2821cd3ddbde 100644
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
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
@@ -1629,7 +1623,6 @@ static DEFINE_MUTEX(conn_mutex);
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
-static LIST_HEAD(connlist_err);
 static DEFINE_SPINLOCK(connlock);
 
 static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
@@ -2281,7 +2274,6 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2338,7 +2330,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2480,38 +2471,6 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 
 }
 
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
-				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
-			}
-		}
-
-		list_del_init(&conn->conn_list_err);
-	}
-}
-
 void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
@@ -2519,12 +2478,6 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
-
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2854,19 +2807,11 @@ static int
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
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
 	mutex_lock(&conn_mutex);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..36e2c1dcb059 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -198,7 +198,6 @@ enum iscsi_connection_state {
 
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
-	struct list_head conn_list_err;	/* item in connlist_err */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
-- 
2.25.1

