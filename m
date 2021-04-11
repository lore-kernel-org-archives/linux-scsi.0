Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCE0C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B21610CA
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhDKH4m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60068 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbhDKH4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7o1up179520;
        Sun, 11 Apr 2021 07:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QAjOPHUMMmUGGKV0OMoYuS/XpEFuLGNcqhmkDWaccL0=;
 b=uJqFfRNLgIoOIRI9aC0TmH7cfajesLcSsRVOQCjtBiiZZLp6MwliHgqqs5WCYw00EhY3
 vdo0tJK+Rj6l4AoVdeR+3P0j1SDdQZ0Jc7waE765ofakMauvsUzqOGmSCvQIwK/wG6c4
 yNE7RXD1Qi0I0guUaAHZvi3tQVqMwizuZ2dKlbpwiMqRYLBSYmlJM+ekqUYcq7hBTcI+
 GPojp3/SXSgbLIlN5uDR9Hy+OYJqoYDRsBjRzu8vhpHqvZyYn81XPSEy1do7/FrHBiRz
 3HgrGWrs3mgXIRP4+fNOWo615xY5Iz/B4jPuhuuSzw+j+So76ohAWx6dvHEQHwCoO0OS tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er9am0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbR017877;
        Sun, 11 Apr 2021 07:56:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMvcy2c9Iwt3fjtcQZL8i8Clo7G4Af/uVQ7x7Wqk53fKQzO6JuTEp1naKkEHaPNKRvB6C6SYz2SuBlvATMvg9ccpMssXJD2M32POv7bTPDmXy8GQ8Fbft3qwZuWYGZJEwUCo53VlnOFqQr03HwCKyyPfp+6X6yiBge47BtkHyG0/xtEW/zeFLaMS6GeLcvhGDcnjGDCrqIeV3pJIsqxir91hld1oz7O4pln/IbQUlOtafo0bN87YITg8blTg9LNYyMQvX9U5M0ush9pXMTw1OHTsPOsNrtnswfol+2IppFf1U1NWl7HC0qNddW0zJ6uoltf4qzvDmluP7lbBRloR2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAjOPHUMMmUGGKV0OMoYuS/XpEFuLGNcqhmkDWaccL0=;
 b=FVkPFGcehFb5zZsZURnUQFMBeHbZI1E+Od0W2YVv9zB0SE89AOtbPnBLiTiLN1lB27+Hrcaij8PzkDT9owMD0uMheNtegFVUqdl4xsjKhT+LmUWeY6pl9F10UdUtqLPk1f1FNA3UIsazkHgZe6V8qaDLS1CS2HmHYRW74JZyjnZecyrCpm+rDmuXjmUVo1fE8L+zyFKKqcTbu5O4J5ra28/CTW3p5utuhIh0bkBLr9qbHbGCplrRC0kTvVW2Gs0dmYMk9kJlbFoRDE1CmNkXoQHGfUT013+ASgoqoeItgtCoqnAMe58wlB9Y7wRFBcysUNAA1sdSvklZgeWnyHXiXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAjOPHUMMmUGGKV0OMoYuS/XpEFuLGNcqhmkDWaccL0=;
 b=EYX3AuV1crgqwAA6wb85c5rMip3C6I3nDwuemZIWNnAD42ZjsbX3+o96iCQFWIn45PljUq81DYN+4nLe4ARS+4eVSQ409H4Jui8cMagFMN6WXuj3if3OA0vMtg+PN5DyUmhhoSkXZ+wJOryOmaQ6040GIp+5wI5TFYW99ZS7PzY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 5/7] scsi: iscsi: fix some of the bugs with Perform connection  failure entirely in kernel space
Date:   Sun, 11 Apr 2021 02:55:43 -0500
Message-Id: <20210411075545.27866-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0469ea3-ffee-4f1f-b258-08d8fcbf3e25
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842AF7BC3AD45521807AE72F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:147;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3/OvmH9k1kgS0T6ZDzwAwlGHBxkF6E+XOH6gcAiGby8APQoU7hJ+rmokiA6YAlTIu/NHWX2+XhEn0RRxbHCsNniIqxXVz3Ei9IYPUGJ6mFmEqNEPWkTbFILE4J4MbqJvH2MHqAfTIE7mHFOdfI++edmah7cWoxL8YMz1Utu48F3VC1KvP4qMtofc87HoYAqTMGCzg66PJuxRFKHNP92tg5fB3k8R1w/dxI/olKeHR9gT2ncvzuXZUkgua7Or9obToZbBHhp3UdzDgAywHKlJ1+tHm7BDobt8Fls1C5t8Fz/2Pngwxi053yDQDk3vNOCxEGiTvTKEI+E83/EqEvyPRI1fArlyUvv7e5IttIZjRDpfzEMs6+uVTAN1rRFjpQes1K4iR2FZURG41zu/SjRyGJeJG+46fW7aKwYd8LjENgaePeBhBbN0PtTCMc4n+t17zhxaYvFYOTcLSegv4b6176lKPGiZzj2xJXoN1og9gUUEEKepv5zyeVWqhUOVH7FLZ2PUIjgOAwscpanwMKsl5m3uBdqHJ+/G8J0wjIA+WbtfBPD3JdOgvSXjZ8HWsmIrOALAIGeyW3s1IA3MnTi5ralUgTbthqt2mi10NbysoPD+k6QXd6IFD+E4Fq6KJRo64xglzNxFlp7wJ46z+yQLrKsDBPfaNvWRnOrxJi+N3OmCNGZPcWWAdYPLMpP6chW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(30864003)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GSNAdrTWlRAz3FGSsOY9XWTGROkqIuRV7fNs8QStN7G3HmPV15V9xjCi1V7F?=
 =?us-ascii?Q?cO9xSR1kWKbSaloR+0OgViNJNkQ3DcqPrdMI3O/zCc9Oxul4iYwOqpAWpufw?=
 =?us-ascii?Q?Nh2WeK82shOG/xFqHMugBDT5+trrm/GCZ57bhWbML9EVqNRAPbLuYNJgOl4A?=
 =?us-ascii?Q?rNkBU7+MoB2oAJ2ouF95Tk/qufzOb1e2+RhchKxBLc1aYGtiJjQyMThe6sUg?=
 =?us-ascii?Q?SIUU6pjPpuEztRr8Ipv6vapepfR6jVCIu+APoNZe+Cle1jFGPaWTXn+1B3F5?=
 =?us-ascii?Q?T2shYbZuFC/EP3oRA13QU2NexqJViYaxN/nmfGAuxbBg8+dnGal3fInBRgZj?=
 =?us-ascii?Q?XogPGpAM68L2J4MWnBkttAE+TQqIzTL28eZK3ywzgsB4UKxRf6+rvh3SzDFQ?=
 =?us-ascii?Q?596FPGjGMLQQxyqyZ8yxSX/FLsGwlK/eMD+HuiqsDY8kevyTFIKG78ByeQMA?=
 =?us-ascii?Q?ZvZRCU9jYSZjVjgNpwj8mY0M+l5i8V74G8hlPMhNADIoObhFMtdSxsiqjd6D?=
 =?us-ascii?Q?QbaC0O+EL0L/GDltFu/S20vBi3t4nt1OEvGjzhX9FefrVkAYVSStgPSujOVJ?=
 =?us-ascii?Q?kcLgRV58TKf2mG5GWaPa6Q6l2ZAJOXuskAi7VBg9DSMH14EGiq5fzobMVWDX?=
 =?us-ascii?Q?POkodTeorMSQ660eq8Z/wJurwQWyp4q8ziQjfG60BtRPGjz1VJssDD6U+WCY?=
 =?us-ascii?Q?TcGJR2TCokbKfXp8PwXHqYg8T6dO8AtpaRZUfvfXqMp7ffeoM7X5F7EpcBrt?=
 =?us-ascii?Q?H1I0YpM+q+ZaQvZJoBsLzfseze8BIlrTHyuPoy5OSMvY0DvQK2NY1qkUrIIV?=
 =?us-ascii?Q?MBTkXF5mpJs88+OE0UVJyeuF1pkk81HBkoovRgrvF6ahRzzHKv+z/QP9HXFv?=
 =?us-ascii?Q?9u9EbMoA1rM8907KBI/RQYQaiMT1aTryJYvNaM1yMGOKYFjoe7Y2TYhKSQ/z?=
 =?us-ascii?Q?yA2Ev9tXDONGIyUCk2ZY70LTHKsyIQMVzYUR18g3Qif6zqLv+8PUOOH50kLr?=
 =?us-ascii?Q?kmU6E+Qoat4lnvee8ZuvuDdAjwYJ1rx6NYM6OleDafuf3LpaKw4Sv5m8srXW?=
 =?us-ascii?Q?G38wctMmsrEe3ejq1OXorAFbbG9pSSEbC/7Tcu/6Yz+zE84aaZDovZny5nr5?=
 =?us-ascii?Q?qfuRMsHsDDHKbkWxR+2ciu+Daq4PiVQQvgpdpb4cUsUWvnx/D/IXkGnKFUoc?=
 =?us-ascii?Q?B/WRXDsNSiOBGd9PoNl+fo6QsnaLvVM6nM0nxr4imyNGaEQ6tfGKj9FQGgQf?=
 =?us-ascii?Q?cusMPzvlXLCxUxOmgpb+/+BDXTjIirb/+9mGCgTSj81OBTduZcNkJaumUKBq?=
 =?us-ascii?Q?VXWgr+Hj5iFbrL/yv8A9azxH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0469ea3-ffee-4f1f-b258-08d8fcbf3e25
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:58.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRh0s8K3hH/jEkp5X4lRXHoISzW6q1xnmt7l81NR7wJxXMicA0YhFUyt3SZvRFxIvRr2l2DGIgMI2j+PJuxAUNZS5bZ2fbE4uqskOWGgMyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-ORIG-GUID: pA4gZ-0ASIEdeDqlaJ3GQwNQgAaEppl4
X-Proofpoint-GUID: pA4gZ-0ASIEdeDqlaJ3GQwNQgAaEppl4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
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

4. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 214 +++++++++++++++-------------
 include/scsi/scsi_transport_iscsi.h |   6 +-
 2 files changed, 122 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 036486310260..da9fce1dceeb 100644
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
 
@@ -2247,6 +2241,92 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
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
+					     "iscsi if conn stop wait on kernel cleanup.\n");
+			flush_work(&conn->cleanup_work);
+		}
+	}
+	clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
+}
+
+static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
+						   cleanup_work);
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep = NULL;
+
+	ISCSI_DBG_TRANS_CONN(conn, "cleaning up conn.\n");
+
+	mutex_lock(&conn->ep_mutex);
+	if (conn->ep) {
+		ep = conn->ep;
+		/* Signal to interface calls we are handling it */
+		conn->ep = NULL;
+		get_device(&ep->dev);
+	}
+
+	if (ep) {
+		ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+		if (session->transport->ep_disconnect)
+			session->transport->ep_disconnect(ep);
+		iscsi_put_endpoint(ep);
+		ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+	}
+	mutex_unlock(&conn->ep_mutex);
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
+	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
+}
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -2286,7 +2366,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
+	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2343,7 +2423,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2458,77 +2537,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
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
@@ -2536,12 +2544,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
+	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
+		queue_work(iscsi_mgmt_workq, &conn->cleanup_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2871,18 +2876,13 @@ static int
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
+	ISCSI_DBG_TRANS_CONN(conn, "Flushing conn cleanups\n");
+	flush_work(&conn->cleanup_work);
 
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
@@ -2980,15 +2980,36 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
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
+		return 0;
+	}
+
+	mutex_lock(&conn->ep_mutex);
+	/* Check if this was a conn error and the kernel took ownership */
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		ISCSI_DBG_TRANS_CONN(conn, "iscsi if disconnect ep. Waiting on running cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_FAILED;
+
+		flush_work(&conn->cleanup_work);
+		return 0;
 	}
 
+	/*
+	 * This must be a conn/ep termination/shutdown. Prevent extra
+	 * disconnects if the conn fails now.
+	 */
+	conn->ep = NULL;
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if disconnect ep.\n");
 	transport->ep_disconnect(ep);
+	mutex_unlock(&conn->ep_mutex);
+
 	iscsi_put_endpoint(ep);
 	return 0;
 }
@@ -3765,9 +3786,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 
 		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
 		if (ep) {
-			ep->conn = conn;
-
 			mutex_lock(&conn->ep_mutex);
+			ep->conn = conn;
 			conn->ep = ep;
 			mutex_unlock(&conn->ep_mutex);
 			iscsi_put_endpoint(ep);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 165e629fba02..bf5e23a0552a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -196,15 +196,19 @@ enum iscsi_connection_state {
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

