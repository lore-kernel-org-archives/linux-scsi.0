Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBFAC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C74361404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhEYSUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbhEYSUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFNjJ121927;
        Tue, 25 May 2021 18:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=txjKhjchZ84cNutWecS75GiUKDFkWwioGckXksklzmzfmear5F3Thg9vqco0nnFMswz8
 7sq34KtKu5FyTboD3Ha+yqWu/txxJP3gT6Nzx7ZtUKv94kZnEOHJe/J0BqMwzNsOFqml
 KxEU8bYck9LaqyarXXTlnyupdcWNrFjpyW9/6DfP976YB0qbXbFqXm5Tx2yTgCI1WdmC
 fhsqIlAiooet54siSGvmiCVylTz7S6wybgMTjaNrB+xEqYA8HGesdRyboDADY1wYJnVi
 KSoe4zjQogvq6KpuCEViTE91WjozvdcaqgnmeKMzSnBve+X+6asplbzytxOE9ArBfpad IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38q3q8xcw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFGMn104688;
        Tue, 25 May 2021 18:19:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3030.oracle.com with ESMTP id 38pq2ufk67-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E74I/KqfzxI9KeFDk+hU8d9VeL1u/aiz7fI7aTHlAZn4/r+fRxSTILmvkLoQO+SsWWXRXyW8NBav3eB/cHX+d/lu1dhYuAWDSlkMnV6raXJv2eliEW7HNGJD9pp5y4JSPbA+FVlAOWcUExSUv6RvWEtKRR6uJTes+oVHfWAnyS/8+CrpvHRYF/cdFwsdcXou/GMd6neZLSvcJNTLCIldLhDqZDdODVwW9J3Dh6DFgcwgO5DTFMXLdLvQMrg6MnjRIj5PqEhMAZfLHr28lKuvcJLZg45PsdBN6phBzP+ZYGBjPh81hES7axOyyctm05/e9W8qCmIzAliyUJE0ZO45fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=l4sumKuwWPfvB5/sVLP+dXXNrbUyl4LinAnBQEDdfANClw1JkbYqFCISnyfBxAJhDg7yyFpKfl1tExDgVis4N1NYQWPf7Amn5+4ET8xhZV5Hva6DsoDUEwwjrSB6zlODalgeDRMH7/aL1G2r/jvObej1yBcQPV52doCcfFZU5w6NvYSXlB2cOzxzpzItJD3o+Bq3xrf8d6wNtMg1Jhwgx309x964YAUIwRCwiC93Y/zih/d4W73sM6tL3pzCp66AOo6wTpPK5bVYUIXOsBkek6IJn/4g5vX9e6j+fxyo0tJY8RgqpN8kYWoNHC+OD94/CAynHhPajvgMGtZcLhIk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=SE8Gdd6JDLUIjNNojkrkc4ztbW6ARLmLeLYxUqPTWYIgLFLakBeGtS011io/CySaATvHpSLWeX5XJl8O7YSnOEfSIc5q5lUYgJnH/1yKwE4EKHvUm6TLLIoraM3UOLXPexACqkA64tQ97aZeNI/cb2wxQ7aj0xJFKVVcLnTos20=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 25/28] scsi: qedi: Fix cleanup session block/unblock use
Date:   Tue, 25 May 2021 13:18:18 -0500
Message-Id: <20210525181821.7617-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43d5cff7-53fc-4a59-4058-08d91fa98f2f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB389164F5E51AE0C3CA7A0855F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWcJGs7SVqx4UgwVhOYUQcKX3xqeF4CPHaE+tRhBg1QFWGL2U/B/roeNvax/+NOX1vW78TnF4weGl1ad1apoPoS5jryIIdxZVpMncS5X0pnaw1AKYYWa+7OjSwsc1nJ3a6kYkY4sgsZ46vYC72NBFHm1x/Qn6/0YAtyXHO8onlzwSWiSKP0G+lSlSEm/F+UQgBUe09ohhclNM0yRY+E+AKrcmCeammMTtUtZcnoJ+8NCUo8TECg3OCF9m/L2SVnd6UZ6uwF6R6YoRltekOAEb7dI8xKx/0yQnwAbXl+sjvK5tJQ2LIo0gpmJY3zN8v5Q9ZKzJH8UnZFVMcCB15y4WJ4XTucde9CCtuG+DZE/4Z+HWBb+CV/BdwLPfReKFV9YeNtEXn+B8ZiHHfeGDgOvZmFrK5IIY2db9Jhp/qFWeAK+1R8doOVlMGfpmW8LqnyHfINgG60N0eUahP7EUM1578b2ZL3OPuJ02Y0WnBMQk2pC7KKyo3a9xv2PWcY/dS+px2nez9kYdqbdUOJYQ9H04ocX18n6bbycOhEFBf4iwF3Pk7MrYG5UJAWB+cR+kJLUMG1/jOvMrWuricRHe9Y/EsIHVnUTQntZ5iwzkONX57skBfGjIn3f9bQu3VVIeeYpYma/HBtkjuj+FkVeF+s5a8sypLK3Q9clwi7hJUBGwSxMf/mu2O5KN38WIAp6Yn1q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e8THxUN+o7yOKAkJSMOaxp9oYvJNWl+370vM6a+XOSqIcmJXR9cKyxyQH72Z?=
 =?us-ascii?Q?3OqjPN0EGwokb87FYxxAQHR1Er3BhHw6Q7cYRocBcWzrvmu9QrA8Tp/euvKL?=
 =?us-ascii?Q?cnD7Rc4na/UUvriLKJNP3Qy8lUR5+RJiPIbw1IHxNoitU+GWhs/Z9GAVBFmP?=
 =?us-ascii?Q?IGd08unYbx4kuIVNlf5wAPDHSEsnUqjVqahtNJtbtyOib6HiCnTA7VTXGZOi?=
 =?us-ascii?Q?dHrA5aW95FW78jTELoS+G8hOPhd3j1rf85AUc0YCj9FJd9ffPUIBmNqQHTpI?=
 =?us-ascii?Q?TQ+JQgfzcQOKUyX5Zw1zQccnbatgaadNJnIcOsRXz5ac7VC6iezEaWRcwk70?=
 =?us-ascii?Q?l5egU6/qxqwkspqJ1EIDp0CsDZ56XwqbMWKeL1QV7kHt90s2ygwn5T9EGO/T?=
 =?us-ascii?Q?tI2KeyIaXakObJ7aU3YSAHtYtIdBM4u9BvxL38pMESDucuZBQarXzZfFcVs9?=
 =?us-ascii?Q?dnFN9+A99+llC1+/HEq/lOFy+gXU3e1eJJY0REAwrFW6OqIf0zDCRWd2NjIZ?=
 =?us-ascii?Q?Ol7UlkSzMg6936RQsukP4Rs8Cw8sOzE44jS8qDFRWCfBpLpVXvVQeZ4yNzAD?=
 =?us-ascii?Q?ego4suNeCz0KeP1dTO6+UjSjSPkVyv+ngJJkoF3jCMhSrGCYCKPkzVt3muu/?=
 =?us-ascii?Q?D0lE/s6kwxsmFH5SMx+SJFlMzn9idJZnciAJsMhNKnQnFrECDg0JqMRiUE/0?=
 =?us-ascii?Q?bzqgyzQ+68CJPdzwFC2WsPas3sQGfI1qJt1n0VhkTOdLuC+vFGhJr9KTlxdU?=
 =?us-ascii?Q?/TC3xtB3qqidxJ0B1z/rCHsr5IpJiJPWltuAsI3BIIiCWJ80zoxHpUO1K29Z?=
 =?us-ascii?Q?sWmH0v9g+fwxkLO2FKB8PUD9bshVnTni1bn4YLoZwjkE/oWU9+WbtxK/bvMw?=
 =?us-ascii?Q?FNFzCQo0QORkfKhWil9ciHG0FiVbwuQi3z03EJo9CNwX2MCJcCzPTN+g2dQt?=
 =?us-ascii?Q?SlkcrXahftybs7FuV/hQK6dbAaxGoydl0VjOSASDkVjyaxGczhYzQyUT6E4Z?=
 =?us-ascii?Q?FhFbNQAqMyj81EiRq+wsw2tedqzGmUZ8uQ0W2vwwkE38cOFfPSuT4gFUhDFT?=
 =?us-ascii?Q?2xbEFI4MT1iW6dQlxppYdfHxdeQq86BW7Pzqxjg3eGNNv9xyaPPkL2kjI+pj?=
 =?us-ascii?Q?qBrL7fvp6nloyFp76eOgQELMd2q7ssagb0M8zinArbSx6HyxQgLu/3BohVmB?=
 =?us-ascii?Q?VKapuAn89D+DRPINrHMJsYnSWZvf+HY8qz7XqAGnuyX4NNTgt2nK+E78cMwo?=
 =?us-ascii?Q?EvHkbtjyKOWw8PNB28o948v4R6me5wfp7FtWbItHXM1L1/1tj9dwVCanFA63?=
 =?us-ascii?Q?Nag12DIRx8g30VLICaleRhpU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d5cff7-53fc-4a59-4058-08d91fa98f2f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:56.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOzXJdgYWEn52ss/m4m6T/fe1ZtgpZonF61pWjlYWTzEyetR3klDGmckdTrwSl/MOX1vm9NAFJrFLgqfl06AggzpPKij3tI+YGXblNxP29g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: NzY6ceihR7sR8372M3hkaB2L6aAnjh2k
X-Proofpoint-ORIG-GUID: NzY6ceihR7sR8372M3hkaB2L6aAnjh2k
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host while
it drains the card.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi.h       |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index c342defc3f52..ce199a7a16b8 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -284,6 +284,7 @@ struct qedi_ctx {
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
 #define QEDI_IN_SHUTDOWN	7
+#define QEDI_BLOCK_IO		8
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0ece2c3b105b..ddb47784eb4a 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session *cls_session, uint32_t cid)
 
 void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	iscsi_block_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 void qedi_mark_device_available(struct iscsi_cls_session *cls_session)
 {
-	iscsi_unblock_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi,
@@ -800,6 +810,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
+	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
+		return -EACCES;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
-- 
2.25.1

