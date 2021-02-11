Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA621C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14C064E05
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhBKMde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:33:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhBKM2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCNxaX139125;
        Thu, 11 Feb 2021 12:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=+IvQR5zqlrgeoGPiEmEK6qTv1WxOD4Xt6+pPgvpzIWo=;
 b=WGm290YhZKQg3VjY5E8zk2Dju7AhZ8lCldke/NWLXgubJ+a8rqzTJIyNHnBEz0NxnyBk
 qnUnw6yUQIQ+eDGjUrUE7YIOlL3EYyKySFCf8rIUD/5VtVLd68xrhyX8hQn0KCmdB7Q2
 qrqt1RRj8T+ZXMVM7/wle6TsiaeJbMNpUAheFc7Al4BXKp4M4zv7TGy3amrFtA0AtLXR
 bFOvSgU8lueD3CqK3+Rb7Z6s+lQ2kLBV4PJKaehRkM8nJFuU0xYdeOvPApi5Zt4eGPUS
 rwwvpQlWt0qtHNGQj/2vPdJF/m8L5WGXyPfT8G+7zEq+DiXQ481kAk384VIMi0GuTeyW 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrn76f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ2iE193594;
        Thu, 11 Feb 2021 12:27:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36j4prg59f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k62/e5S31BidUppTZJyWfRIv4wRFstSRfVAsE14AwKIRZjN5cFg1DUWbfkUx9HOEORgYYZ2Ybyj1sASnO5N+da+q346XRvqxcI60HvgDZkCBaUeo+kjFQfnojgOJUt2MbiNXt+dITyVZkYXaHXtUbcngmvgniiXct3mssWYNkZc7CXHFt9NDoEJU0OvoHxblS0sY4mssRv8nhxiKzSh3UdCVBX9v5FV/d7Qd2rXWgyRRs/YIhl7x43E730bGcOWBaxI3w+YnR/MXjpphSfWbcA3AifpVGODfkOsuIjr6iUyAGdBjpd683W1yDL7tJAUAJ0rI9JYbwy/IU8CQ1QXqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IvQR5zqlrgeoGPiEmEK6qTv1WxOD4Xt6+pPgvpzIWo=;
 b=KgWFlYpL+Lt3ineha389HcWVgplF4GsML/hO8t1nMGLMSjQCxyL+hbq6gfks/GccN4oSeLY6b0ILt/ZMpRL8xKjnvB22mDOM6DLBbqKQ13sqPLy7vxFkWgmBloqYI4oxdf8XKr2PcAcs2uXfkD7GbmqC4RlkTek6bp8wG6FBQG1LZB7m+rfXlWZQ03SGnh0UkK1xQ/YgkY3EeKG1TQMbKHRmCSBsJheVh8xwBLZ8xgmYpM1Q9DwGx41VZjSxuWRdxbvBeGjsfCrQzQ+4zauYGczmqfgRZJ3hoI09ZZuR8Mzb6JvRX3BF8upoezIQNgmoX5gK5grF6v/lnyyJx/8RIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IvQR5zqlrgeoGPiEmEK6qTv1WxOD4Xt6+pPgvpzIWo=;
 b=AUNX/lFGWuUsm8s8friD5zGcmioOGoeNNqBx2+BATszM31n/orfFx5hShB0MHYd32zKPFQIih9DvTK6z+eDz76N0Bb8yvLZOkqGCPeUKdzOPCfqVNjxMs6a8221gjZCp3an8qoVzaAiid+n83dcxBVyDH79RYKIAeva6KO9wj2M=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/14] xen-scsiback: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:26 -0600
Message-Id: <20210211122728.31721-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d27c5ee6-1ea6-426e-5bc7-08d8ce8873e8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43394644369EA6D8EDCB6A7CF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f4/3wNj8K3h1VrvL7ryrUDqUg6AQFCJekvh7gPgucOUl9AESA1Q7pN3tiICbu2BsE0wlzzCCsJzsCTRiynzgKXsOyWxGKapiS/JAl7CSPgl8FyZUXsZZRSGgHAiw7S1lo65YcxpjNWG6XDIprT5H4PR5t/tFzRndbKvT9XRmWhtmGKnEiGNEc8j/HhNQ+IS602z0GRplnPk7ZVrtVxVGgOZAKctvgMwc+kR6y6GwRlIOBWKmtvlUw+0fwej4Ex9rlkFMjvplKT/g6eCqkviFHPiCJxFN8HXdtTd9PxeRfwFE2cqVkQPkhaAXgf52QFFMe/rfsB1jFtHpLUBlaRt6C+yLmoX5P7syddAjvXhIceqjF7wIY1XpY/chT4hxpKNI4GzKLpBMD5/sX0LjDiULETUJAz5i7zRTxNNFynJx3pS0qshCKg7DmUU1HRBHm8eJo8l6HzLaqLxZJTsP5DPntiQ2InBV0Uyn7dvt5VX9J0kwBwYr1Y39n1P7AB2J2OgG9uD7wmqfNsZQBTz4EU871pwCP2dHI56D1nF15fBhwV+yRPy/19xKWDPL3ahnqW+bny0TmOPuYu1cD4SfhE+c7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f80awwCajoa5GURkqTOy9StPvxuyLyFFc9yoXOzAUj+TsOD+V9343+NaLyvX?=
 =?us-ascii?Q?Efiy1UzG5bi6jv9UGWoV65Zkbvt/CqCEnnGRxSYYtEHRfb3CoSopASJYsFd3?=
 =?us-ascii?Q?ujF5Rfa8Bl5C6AhhESRAe1I9CVKYqZDfvvrquz34KYqPm2Wq6QmnPWpo2SaT?=
 =?us-ascii?Q?T6TCBeVgk08eVauH8UPX6UNwpw1Kl6iqYlmn/cJ6kc2FhRUgATj8BIiYNjDk?=
 =?us-ascii?Q?XLj3sm+b2NTFqwNJ0OyEWwY8N+SdChvwR3+EJBwfgdLwRwCrR4M/QUwMYYpH?=
 =?us-ascii?Q?ZD7MsrxFy+vsYWo81/nu7UBaH0uCi5VXAYZ184IjavB0b+f3HzAZ3JErIahY?=
 =?us-ascii?Q?G583w/XO3uJw+jW68FgTjBDV9Ok2J1ZOIdzzuTZCsvHU7oNCpgtgVQ1EZ7oN?=
 =?us-ascii?Q?QUAsXw7PzqUyt5BNC+8R46nOiwxf3Xbh/EGXHm5fC9ljEp/FcZtP27nAuVEI?=
 =?us-ascii?Q?4g+iF1EvSm9qSa4R7d9MB8tyd10VvhCKgNp9FcYn0mrlMyRIyy0AKV1Ws6Ib?=
 =?us-ascii?Q?eVtXTCUCO8lrlLiNE5sK7w+35YoctqYE2HGoW7A/LK+Fg9kwo5PlZzDZTuAo?=
 =?us-ascii?Q?CaXEap1MGbPwrBNAOkYUkMHL13wGJK9NBGhbSAZUPoeTPEwzYDtAe3o7ehmn?=
 =?us-ascii?Q?40jV8CyKUjoG1jW3ZS9fO3zFRn0iyH7B8CGfLg8cSz5W2wHSC0KRB1/7UZCQ?=
 =?us-ascii?Q?mzZgmQwzXZ7cNU3JoULzKD55xYICCRMVtiFMa+/1Ydv/B/Jsl5h7Xay6ZeYk?=
 =?us-ascii?Q?W0aFYdrRoqfo1nzzhJUM7w4BAo52eZdI5u6Pver8O7IKyAmp8vL7/ExqCJpJ?=
 =?us-ascii?Q?Az6uI0C0KJ35OUMeThxhJGsYGvOS/dGuIp710O9mvWu4IP2DrrqI4aATqU59?=
 =?us-ascii?Q?Lge/U7ANlfbfGEmIreSEUtIkBkZH96JO4i0fF+x5JQOtwkuCEnKZpXZvsqUC?=
 =?us-ascii?Q?CWey0pulvbi918wsxlVOsJNYBtweegnwCKM8HA+Gw/IAoEfDAcV117eUixgm?=
 =?us-ascii?Q?DOImZP3Syyu+QOzzsk8rCKh8c/toSgY1jsX4TanPcnBfbuFiDO8VhmaRnwhz?=
 =?us-ascii?Q?lt40xT/1myl+e9aGRnh/GUbnXuHKe9JTD32nJej4lm9qqirRfHE5cL9ny+eL?=
 =?us-ascii?Q?I/uUHEkt3PglK7tEjyKGmnt9R24oV5opkyOwF5cNY/3z+2sEY31oNc8iFRft?=
 =?us-ascii?Q?iI3b9FFq2JkYPtT752ZdnscYHQa90e9ZsUh4tWBDG0sfetODd2yhQlMqogs7?=
 =?us-ascii?Q?3cxZpLJkzmuJHguELCzbb7fD1PYqNab64dUmHQhxsuxWMfR4g7vlfytPhYdo?=
 =?us-ascii?Q?0KxRQL+GSOB99BvY+Hd5DH3b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27c5ee6-1ea6-426e-5bc7-08d8ce8873e8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:53.0735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RvhDXMsWCQrBTHL6ouU4qVo3bYJsBchywuxNPp/7mzp5ufD1MLcDmTq0C67Eu2XQDcPG/O/v0E7kvXg9kVs8xOzA4sB8tvHjZdITFnbr/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert xen
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep.
target_init_cmd will never fail for xen because it does it's
own sync during session shutdown, so we can remove that code.

Note: xen ever calls target_stop_session so
target_submit_cmd_map_sgls never failed (in the new API
target_init_cmd handles target_stop_session being called when cmds
are being submitted). If it were to have used target_stop_session
and got an error, we would have hit a refcount bug like xen and usb,
because it does:

    if (rc < 0) {
            transport_send_check_condition_and_sense(se_cmd,
                            TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
            transport_generic_free_cmd(se_cmd, 0);
    }

transport_send_check_condition_and_sense calls queue_status which
calls scsiback_cmd_done->target_put_sess_cmd. We do an extra
transport_generic_free_cmd call above which would have dropped
the refcount to -1 and the refcount code would spit out errors.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/xen/xen-scsiback.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 862162dca33c..cf6d45f2931b 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -360,21 +360,18 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 {
 	struct se_cmd *se_cmd = &pending_req->se_cmd;
 	struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
-	int rc;
 
 	scsiback_get(pending_req->info);
 	se_cmd->tag = pending_req->rqid;
-	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
-			pending_req->sense_buffer, pending_req->v2p->lun,
-			pending_req->data_len, 0,
-			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF,
-			pending_req->sgl, pending_req->n_sg,
-			NULL, 0, NULL, 0);
-	if (rc < 0) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-	}
+	target_init_cmd(se_cmd, sess, pending_req->sense_buffer,
+			pending_req->v2p->lun, pending_req->data_len, 0,
+			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
+
+	if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
+			       pending_req->n_sg, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(se_cmd);
 }
 
 static int scsiback_gnttab_data_map_batch(struct gnttab_map_grant_ref *map,
-- 
2.25.1

