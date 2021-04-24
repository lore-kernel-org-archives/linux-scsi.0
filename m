Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E70C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C971A61462
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhDXWTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:19:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51950 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhDXWS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMEvPN066590;
        Sat, 24 Apr 2021 22:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=NuNmrEtx1BmIOYGr7HpCFTzFsJlV0MhQ8YoanYp6mMk=;
 b=pe1Kks8KFc31qF71I0PqUrOVVJYpJhTvLDFYhIZrlSBX2CF/J0WMTzO6b3HFM5mIK3CS
 h8Od+ztimu9Afgchz+TZw9B1JrqPtayiJOLLHKNSEiw2PKdPtFHob/qahZxPg+bi+uwT
 gHtTGf/YcSeg7yXoZ8yL+gxfMmTShMOUdJ7r2tWiwGzZI/5XBcJcokYlGw+5LNN5T6LU
 dUPX9ILtOtkYHBzCKGKAF3XU1sVge9s+fWCI3YNgEITT+kWoiSK76o+CLnHIpvL2koc1
 IIhtD5SRPjaGsAg7Z39aY+8BHWZ0dWbljHgs+rXRK7y7MGmzcqI5fUBKAmoLa2h0qKWy KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3848ubrvj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPiA148236;
        Sat, 24 Apr 2021 22:18:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScXzJvD4GusEAZVNA+sx1dN/EVbyhKe5p9sKyxbmp921A8CZYZehjq/3mF2VCnMTKOJc7HQDmCNet9P7mcM+B2pFw1i2xTvRL7OCpElS+LyRySyyZBf/XckviaqkB4FzLDhSXTf7TASEa/2QJQjEpna56xS7Pa7bM2rEK188Xu97R1YhP58OuKy6EJJY5t3VN4Xs+wvt4MubHLuaouSpIJUKRgnC/0/5u+C3HqMQ2sdLOXFqHQsXo/pfv0Lq/TVGw4xUSs/CXd5ZWLSRW5HRBE7f+HBqxkAzegaC+6jXEi+ytoYTnLgZuvsROWAqVJOIT9hR0p3Bmua1JyZyVVhewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuNmrEtx1BmIOYGr7HpCFTzFsJlV0MhQ8YoanYp6mMk=;
 b=cdhVhfOy3WVpyinprbIbo7TqOlUklFeu8Qhl4kHhWx7FNxbwuWisd/pVhX3OHATOCt6ePS08X2+ELlg4o5IMwdTA6RVydoJerzFnDHEPk5RudGn+TvbdIoXr1X5pT3p5uFmoZw2QuGcKWqNdzYmphVqFvRDX7M2qGYmg+Ie1yerGii4eZyq/o/MlLwvehVPcTLAuHbC5tHkvLvdCVoiLI6DdxIhTXj/ts8LsVB8xq7gLb3+KmwakqoZutpw/L7pSwkHp20De8RHugATd0X33jG9A2TgrdgFBGCHqM0ZT6lq2aDP/GyDYIfNCXh7gwti+5wgKxjvSfu32M/S33fNIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuNmrEtx1BmIOYGr7HpCFTzFsJlV0MhQ8YoanYp6mMk=;
 b=Jk+nBZZhic1crH+7iowcyQvvas1uqU1buDNB+7NIg4U4cwR9SPli5tnc2cXYJ5/Oat/QHtpvjkIyVkANEXJFWz4vb8a5v0sSF95q6tBwUjaGa9ukE6WH2PkJQU456I12wNoEfiE6fMhOcV5yUBJVajYODf6mwAY+vzIROnoVEyU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 4/6] scsi: iscsi: fix in-kernel conn failure handling
Date:   Sat, 24 Apr 2021 17:17:53 -0500
Message-Id: <20210424221755.124438-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f78971a-bc39-4662-971b-08d9076ed611
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB288516426F269DA77CD5407AF1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FO3Ku745JMjPKcgserdF/Q3kEagfQ7ccoasDncBT/T3dw87lnq+aajqIsboGE7FWlBpBP3B97aO4Sb+eoZ3gsLdvOE0mDxjFAKm6zGgfqpguExB+p+5kD1PNZcddooYt7lRDypBOJDIgEXwhZsv1lZt9VcGIiwBNN3JK82325+FX6xLD2GpRqjiAdzd96cZjdjZ4tHS0VO23vOlDWjqrLeBd9uBOHBizduAKzLGHOwtDbt/EpP4dUjYIQqk6zdL/H+wC9fYPlFepmW+kPvDUERkqbkq5MgpXfyNX08WhgmshWHF3MI0iXIJGGzvDMeZo9KJ6+K1yytfp95jkoyAsq2r6OonqibZuxejJ9HmKi3wGnJ2RKYFbvaKsfSVN8pCLK4StYXqyeTl+CBX5DFy/4jua3aaNgAT+A2JfgNRqtejXges75Z/JiMxzfqyJ4H4xNDRq1+cu+qTElykI9DrMqMDcrcWn46oDqX9UGPLImsb8MXnrLwSr2JAwehGcsy3GBzxyolrNqIyPbVOAfqXDOiCkXabQvTLiyu0eFVOklgjAIKxlqP/pdygAHU/5coiWHOc2UMCx2oxksmAQ70ykQz0jqN6GdAUuGmd5Yw59X5Z87zGJqWUe3vToTV2ACqxVp3McZNPJX20TBExHSMBNc0nOM4MkGQ0CGFaxPTlmLFOKDcf2gTfkX41D97f5yljV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(30864003)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LbZxVK8RS50lAZkUfv1LNH1ThaE7IOqCCAsCnuoxwj5pTcPH2EIDOjBJwHcq?=
 =?us-ascii?Q?KiP0gZOB9rTcKgFzRNmWhPht239S0PN5OduDqc447dzqEUvQ3ULjkvdFxDDD?=
 =?us-ascii?Q?cmVQIx8vI9DjRL7nRhx8oyiPlcuqIgJoGLN5kpUSkAqwublogcKJSJC2XiXo?=
 =?us-ascii?Q?V9GrybCUuS71T0kEAQ9lFHw+eG0nKl39y1vV7yk0VlYT6Kn8TrsrqsBdShNJ?=
 =?us-ascii?Q?6nyDLtMisqa5fqsI/yVpMnML6QfaDR5evnapx1TRNwYufD69FLPas/w7/B+D?=
 =?us-ascii?Q?ybhAbNs/yuT3SR+jTyyC09le4cJn5V2NL654wun+L7ToWkuwce0uqPXfJbcy?=
 =?us-ascii?Q?BD9P++qdaeXVwaFjoyVCeHxshXzFqM5jh8LFMgyJrHljwTIDy2qY72DuULWG?=
 =?us-ascii?Q?xR5/1bBJG90skPWLEPXtC7XUGS3lnCVTEa8CqArBfyr41dRL+swTTykCwzUK?=
 =?us-ascii?Q?6I9QbwoL23GF/3u1aoMZikdVXsygWA9DN09ABfxDrPAkeuaWuZB7lOwY1hKr?=
 =?us-ascii?Q?F60thoPqAqEx0u0nbCAvhk5lvmcIVAPPN7MR+rD42tGI8gv99jqFy84+dmof?=
 =?us-ascii?Q?5r+JDj+vvNw90dDpvR+dCuAwbhEuuGugs7EEXlStrzcld4Cvrtd5RoOvRbRU?=
 =?us-ascii?Q?Ii38Tw6O8rzVtZQz5qFPmCpmE4ENLS5dQynqKW8ZletkwvrSpqFyi2KKffWL?=
 =?us-ascii?Q?Ad+Z1l9RRqu810Z9Ur5YHxjZVKhtKuQg9IqWk/ElbRy9FbGYYLz783jmoNAe?=
 =?us-ascii?Q?tJ5MXIEVUE3cHwWOwjuqIrz6e7/m06zV4c/wfus7iPNo+/1paRnq/qBqRT17?=
 =?us-ascii?Q?sOrOOq3r6/VEHpOesE32eRgglAlT5FCWbYBD25L71FWx8tyWDcBkPZD+ywsb?=
 =?us-ascii?Q?oorQYwvUTanwpWCmjH+MQtVEdFnTOtexCUCvIwX25uakkzBuQ+TK6Wg2OVzW?=
 =?us-ascii?Q?Asooz0rZLAaC71Qs22jWUXEXmWb3AuMRLZ6nY0xP5ZGFA7VN/hljgIe50x/K?=
 =?us-ascii?Q?ciikuSu1VX6epVCiwK/xYZ22epxasdv0CJIFt/AGdcgNhuMptOBpw+DeYxsP?=
 =?us-ascii?Q?L7RluR7E3Yjz7Q1MJrMADYzOBmBw3QKNzQAT9+wmPDiN88eLZitLGfme9++q?=
 =?us-ascii?Q?+woz5mnR+OwPOU4Pi71UYyvH/K6MPDXFHoTOBGqiuREMY7KVM8eGyD6ngYcD?=
 =?us-ascii?Q?k10JhEl2nlkTGcwdWjQiAMc73C0DYFm9Tq+W70ngh6saS9CuH23EpsPRsk09?=
 =?us-ascii?Q?hIAoks/0+qNna2TyDTqx3i9TUALeivivwNBEKwlmczVH0R0rR7cmL+9oDtcu?=
 =?us-ascii?Q?5t+n65+JsT39rRQAHRJ16n6b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f78971a-bc39-4662-971b-08d9076ed611
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:07.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWm2JK2UCOxmFRW4i6LNAOGhUc/+CdDtIY/9UdZ++Y4+wDbrKzvF8QKHTglhuzHv5BIcHUBHK5+w+1eyoX1GQqkR9NCfjivEs9bS/0JFpbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-GUID: VO-wwCod-bS_nONCrA7lPa8sC0oOT0Vu
X-Proofpoint-ORIG-GUID: VO-wwCod-bS_nONCrA7lPa8sC0oOT0Vu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240169
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
 drivers/scsi/scsi_transport_iscsi.c | 453 ++++++++++++++++------------
 include/scsi/scsi_transport_iscsi.h |  10 +-
 2 files changed, 271 insertions(+), 192 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a61a4f0fa83a..1453b033b5d8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,15 +86,11 @@ struct iscsi_internal {
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
 
+static struct workqueue_struct *iscsi_conn_cleanup_workq;
+
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -1623,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
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
@@ -2245,6 +2235,106 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
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
+	if (flag == STOP_CONN_TERM) {
+		cancel_work_sync(&conn->cleanup_work);
+		iscsi_stop_conn(conn, flag);
+	} else {
+		/*
+		 * Figure out if it was the kernel or userspace initiating this.
+		 */
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			iscsi_stop_conn(conn, flag);
+		} else {
+			ISCSI_DBG_TRANS_CONN(conn,
+					     "flush kernel conn cleanup.\n");
+			flush_work(&conn->cleanup_work);
+		}
+		/*
+		 * Only clear for recovery to avoid extra cleanup runs during
+		 * termination.
+		 */
+		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	}
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
+}
+
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
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
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
+static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
+						   cleanup_work);
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+
+	mutex_lock(&conn->ep_mutex);
+	iscsi_ep_disconnect(conn, false);
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
+	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
+}
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -2284,7 +2374,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
+	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2341,7 +2431,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2456,77 +2545,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
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
@@ -2534,12 +2552,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
+	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
+		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2869,26 +2884,17 @@ static int
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
+	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
+	flush_work(&conn->cleanup_work);
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
-	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-	mutex_unlock(&conn_mutex);
-
 	return 0;
 }
 
@@ -2967,7 +2973,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle, bool is_active)
+				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2978,17 +2984,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
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
+		goto put_ep;
+	}
+
+	mutex_lock(&conn->ep_mutex);
+	/* Check if this was a conn error and the kernel took ownership */
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_FAILED;
 
-		transport->unbind_conn(conn, is_active);
+		flush_work(&conn->cleanup_work);
+		goto put_ep;
 	}
 
-	transport->ep_disconnect(ep);
+	iscsi_ep_disconnect(conn, false);
+	mutex_unlock(&conn->ep_mutex);
+put_ep:
 	iscsi_put_endpoint(ep);
 	return 0;
 }
@@ -3019,8 +3038,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle,
-					    false);
+					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
 	return rc;
@@ -3647,18 +3665,134 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
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
+	 * conn cleanup (ep_disconnect + unbind and conn) is not done while
+	 * these are running. They also must not run if we have just run a conn
+	 * cleanup because they would set the state in a way that might allow
+	 * IO or send IO themselves.
+	 */
+	mutex_lock(&conn->ep_mutex);
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		mutex_unlock(&conn->ep_mutex);
+		ev->r.retcode = -ENOTCONN;
+		return 0;
+	}
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_BIND_CONN:
+		if (conn->ep) {
+			/*
+			 * For offload boot support where iscsid is restarted
+			 * during the pivot root stage, the ep will be intact
+			 * here when the new iscsid instance starts up and
+			 * reconnects.
+			 */
+			iscsi_ep_disconnect(conn, true);
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
@@ -3735,90 +3869,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
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
-			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
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
@@ -4821,8 +4881,18 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
+	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
+			"iscsi_conn_cleanup");
+	if (!iscsi_conn_cleanup_workq) {
+		err = -ENOMEM;
+		goto destroy_wq;
+	}
+
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4844,6 +4914,7 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
+	destroy_workqueue(iscsi_conn_cleanup_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d36a72cf049f..3974329d4d02 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -197,15 +197,23 @@ enum iscsi_connection_state {
 	ISCSI_CONN_BOUND,
 };
 
+#define ISCSI_CLS_CONN_BIT_CLEANUP	1
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
+	struct work_struct cleanup_work;
+
 	struct device dev;		/* sysfs transport/container device */
 	enum iscsi_connection_state state;
 };
-- 
2.25.1

