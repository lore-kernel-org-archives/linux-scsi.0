Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5291C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 803796120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbhDLAva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47230 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhDLAv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0lmZq137482;
        Mon, 12 Apr 2021 00:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=KZZu0gdB7KWvTDfoeWb3LMus6EesaDigwKpLur4t5bQMM33tN/N5yYPMyNRIbfWm1swG
 75AgQZWDSyTWCYUhNzJyNpjchIVZgslijE8W5rCALE+kITcFSbMYqK9cfKYMeh2JgBeH
 Nz06vRuSLBO9iivA/1svllcucFCPxaF0eUYRcauhgJh/q2ZBnlJrMiAo6WGRH3fKZ++I
 UZYJEYq9xfjM4rg8xLuqYbPFISCUybCWy8buoK+wo4kYAlsQ1z0OORLqBuWX0PR0veFt
 4iEoFjistdpv1dtvjaOB5dnBqL4skqDka1nR37r0arscvcmi1RoaGsv/YEN63tpfrFG3 /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3era14d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aNP9051826;
        Mon, 12 Apr 2021 00:50:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 37unkmf7xe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOxQWI1l8k3uLSPUCx3dKyLgPF/nRbMpPvI04KXrwgQSlFGI2Zg6bUXfZEezx6jqdPKbuKghhpHn1C6V+S1lYfkKNyW3iyFALQAltQKNHdrcjJZBtFl/7GEgb0FNP9nCDEvIPODseaYUrVYcIuuFhU295hS6ACE2uowe1Kojaa6IzG6fSYXoq8OdBOLx2x7IwPPU3WKORjrKd+Xoykv3R88xG3HZN38ULKRMQfPB8u6gcZ7NwO/UC8RqGxAvObYHhoGnv7ezyAnQwzI4tX9I2/uY9nHBlFZ/DBNgijGz3ebIHwpI01RERhtVUYbu+NORJbvj6Ti0Tc3Oo42owVEEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=djwhdVYtRU9I68skNvqR5Zct/vC8vsX9ldVJTX/oPmqovcZQJQPpQKcuUsIcYFEEUIzF03qqpKvLpgCP8xGxn9A0S3am1sxhnGBpDqmZdbQdShsgjdkOMT05RoC15mj7QaSqko7XSVIoYqcMFfNKPSS0Y3GTJpdDj1xxLSzdtFVllEG1Qm45nEOFP77CtUGfzygWuV2XkDAnpWGl8Xntzq8z647dP/4qRgOlEtXL/peGCxRXQQ73B3AKEnpy6rZejvgWJxo4Vz2rcoKV/dSHUTmzoAtjY3XPs+OiTUsvwRl55vgu8LUwwb76oGe2q2XrUge0S43bftAYImVGhA/CqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=PGUgvKupyDvUfR7Jgo/V3htzoC3CNE/agTybWrD9FMvkyubGrjv+ZeohEzIsN5fWuKpyyD2l2mM5hE3UidjmXv01amOppQ+cxQkAopPu73wqmFq9eDA7aw5xSWd4MAK5tHE9BXK6E1tJ35DOni/De1hItG/chKA7kcsEJXriBg0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Gulam Mohamed <gulam.mohamed@oracle.com>
Subject: [RFC v2 1/7] scsi: iscsi: fix iscsi cls conn state
Date:   Sun, 11 Apr 2021 19:50:37 -0500
Message-Id: <20210412005043.5121-2-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6031438b-b1d9-4228-ce72-08d8fd4d0656
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4307549985B1A84BB04B8333F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPyDa7/m41eTtERtZu5tWWoGLM9TgIkFpyab30U4s94ENbCCF6RcIT3RZG+7NWyPPZ9nuVoyXUOmJfQTRdK0gWHT8K5GJl6UVH5vLuIETs4IZ82vWI/ji2U4cTwEp45gFCpvmo9XpenLpI29Wyg0NkUfJGxVmq2qSIH4JZ6+tBlHfXikIpDi8+HHf99HUEEDc63FXvuViqnY8lYQMaGimKB2svUvjV6e4l5esEdxGdoAbiomqntQZ0GiXB3FJrRmJHU0xDKEEIFbFqy8EeKwr12348ZIJPc+L5jzk2j98ckLD1rU2J46jp6gVTTVhuYdMBaxfobvC0n4TARtbLFqHvYIF3G+KDZ1vqrzPKiKXTaoorqyrLYSp1YsLBiOQoiXJkUp6dVJ4dQtmOnTXn++gl4UhMB3q7Rre+cniMpndH+S4kREXcfEL00WnUljMkdM8Cm/sEvctJfArnnDq8IuGIukXN1jyKxeyGoMxAY3MlRvD4Gx4SosEZ+19zCcTtPMhKuHlUe+475XddwkVznx6TUiOq9rjqhr/1lkVyTQQiAHVxb1mjowSJH4wUXCNM8JbaWjhKCw3GWHG1EmeWgW90Jn2DXlCJH5qsa4TGnfcrx+RkZvT+jr6CfqpAm7uOXloEX/gHU7JNSMQ34HCoAINy7lxm01Ey/C/HiDLAbVPIdkGoNIUL4tSrYuShEflCWV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(54906003)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ufcxOV9ECStvDGeeCrLbvRqBZMSnAcQ+n8gjAzP/GM51c6y409DDX8ECjSe9?=
 =?us-ascii?Q?lt5Y+8HxC1AIg6CaLWZq31hc8tIIVBBsn4NaSCySM1Fyhbxf+KK0WlYhz8K8?=
 =?us-ascii?Q?6btiP417q6k0fJo/Yfd4Un1jz+fwOSKdSVeqbtB6ixNmVNDlAWN4dUAnlD6o?=
 =?us-ascii?Q?kyPXC/5mvrYACWPcGJbL2ZCD0XDkq1dLb7WiaNDvUjKHmLL4XkT0/nj/ZUs1?=
 =?us-ascii?Q?vnLp8ODWr6NIlBKuAdRXySJ4O2JmhHKPVRKDXfRCEefMxJFNtt5jlun5THWX?=
 =?us-ascii?Q?ocAkLQ/Hy1w1uJ47d5MVoGB71u3DGdTFUVUbOVv+53CxHAfQu1yIQ1QjFBQ4?=
 =?us-ascii?Q?LGczouPqwTWFMgMK4wzMPQOFSQHcZJtWagFFNcOcZl/91i4wL0JNF2rp0fkV?=
 =?us-ascii?Q?rnU95s6kN2wECttMgpSiKbqnwaOJKwJsCR34cl2UqR5Z6AzR0e3PmRlZkIsI?=
 =?us-ascii?Q?V8dSgg0GT7KvVyWzAjHNAB7/d7P2TjWXLIXc1IF9C8wy93UgfA2MDtA8sDdG?=
 =?us-ascii?Q?PuJQfJ+6tVRpJK8jS2V5/XHHdZo2ZMWXVchyOOyVrmt+q9EadMZcVPziJoSK?=
 =?us-ascii?Q?F8jlxEVuXudJ2PMn/tZUBgTEJQ9SZMvz3EEdUTLI9lGh2b71nbhm+im3hU75?=
 =?us-ascii?Q?xYQrPFPKuINWUl8wyP05iuHmdy1P9bEUwnVsqI4bpnqMsf3YCqEDgIzcQqBo?=
 =?us-ascii?Q?REG3Mssw1ayMEPPXuVzaUEoXu3foyu0mSD98tDaqkPc+BCb9IbLpiw8KMwV6?=
 =?us-ascii?Q?eoCJi/Z+FwlyZGhg22zFK3QAlxIW3UYspzJCf1MzEnAReexZGRl6QgCHXDG/?=
 =?us-ascii?Q?XQaPxxPFAYx/zK1wpSOY8//SSqj9FY23u84XDGzU4tbLRCDAOJhci9egMR9F?=
 =?us-ascii?Q?ulB2MhDOisA7AXrouqiwuaJdLpebFzBfLkIY1DdALQnpN03OSQzKbIP8QAKa?=
 =?us-ascii?Q?kmkIrgeiggSikSF3MKRIJ2dLb3pF8Yawe5ZQQAk5jTOVQolcNfIKcuGkwt6R?=
 =?us-ascii?Q?9fIW+4XV1xblrp9NAC2jeyKbN4gupbPf/sndUtG1SwNqwfTAfuErgKQ0Xr5u?=
 =?us-ascii?Q?TI3xGGlcIghFom3tR7531cZxZ4ZymDoBKGHf9eZ3zIGB+tS0OzVEvyjIqqfQ?=
 =?us-ascii?Q?zlDAeY4LEY5eLEjNKNYxtrFaFci2/omiqKiPW3wlZvgsWaFl9ELrAyHaJhXU?=
 =?us-ascii?Q?1ssX0H0/7uvn/KxAZyqFOaonNfONfPjdzzpPSmG0bxmvPBvpdBwW1oAownHN?=
 =?us-ascii?Q?YTzGmEShVNzhspjczdz5fyXlExLiXWx1fDAx/msMXoQK3/CEtDqMJfw1rR1e?=
 =?us-ascii?Q?FpP7R+7ybF3KH6k9tgn6nt67?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6031438b-b1d9-4228-ce72-08d8fd4d0656
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:53.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdx7StArFsaJjJt0KqYljNmS+zrw/2vPzvBXM1fXHqtJby2LnA8+RyuZd4+PsrgFSxRZzAcCZJ4M5Laf/mHfxAJRHewv/1ZWC7/x5zy3VOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
X-Proofpoint-ORIG-GUID: avkV_IU7iM53GXqfRzJKF-7x1I90B-o2
X-Proofpoint-GUID: avkV_IU7iM53GXqfRzJKF-7x1I90B-o2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login
and sync thread") I missed that libiscsi was now setting the iscsi class
state, and that patch ended up resetting the state during conn stoppage
and using the wrong state value during ep_disconnect. This patch moves
the setting of the class state to the class module and then fixes the two
issues above.

Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and sync thread")
Cc: Gulam Mohamed <gulam.mohamed@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             | 26 +++-----------------------
 drivers/scsi/scsi_transport_iscsi.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..4834219497ee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3179,9 +3179,10 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 	}
 }
 
-static void iscsi_start_session_recovery(struct iscsi_session *session,
-					 struct iscsi_conn *conn, int flag)
+void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
 	int old_stop_stage;
 
 	mutex_lock(&session->eh_mutex);
@@ -3239,27 +3240,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
-
-void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		cls_conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		cls_conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid stop flag %d\n", flag);
-		return;
-	}
-
-	iscsi_start_session_recovery(session, conn, flag);
-}
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4bf62b007a0..441f0152193f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2474,10 +2474,22 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 * it works.
 	 */
 	mutex_lock(&conn_mutex);
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn,
+				      "invalid stop flag %d\n", flag);
+		goto unlock;
+	}
+
 	conn->transport->stop_conn(conn, flag);
-	conn->state = ISCSI_CONN_DOWN;
+unlock:
 	mutex_unlock(&conn_mutex);
-
 }
 
 static void stop_conn_work_fn(struct work_struct *work)
@@ -2968,7 +2980,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_DOWN;
+		conn->state = ISCSI_CONN_FAILED;
 	}
 
 	transport->ep_disconnect(ep);
-- 
2.25.1

