Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C122DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244509AbiCTAqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244498AbiCTAqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:46:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A148241A11
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JERgAV012483;
        Sun, 20 Mar 2022 00:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=E+Cfs3OtyNAKByy8By9BOxk9zf6RL10vh7kZ06stmDw=;
 b=v3XiDISxRGNohh5jM3ClTEWexJroVYkpDjoScH1ibbb+T0P4XhRCz7nGIExDS0D7nu4y
 SaR7b7AV4YyfWmwlp1KUtVkzQe6fHGZiufq/rX9n3iwhHAQaj1SXDuT4/pe/3M8iHOtC
 dhRpyxX3UKbZdj0tpfzyOcrYoHV5E5kGsva7srEw21+9FC7Ag2zBQRzFFyNBF9FY/5F0
 fk9NQavMsuam2Gk//R7s8seLVKQ0M1grNJQzXqitKS5vctvEyP88bH9VcN3ZQqs3GV9i
 tj1WJ7p2+DPdTRqo6WPwn6oQHWF1uMddZWuTn/J/iuKu48igfJ4wiGEMi2Jig8MbjCbb tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss0ux0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffan137063;
        Sun, 20 Mar 2022 00:44:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGvd/2OKTcVpuW4ffaF0tXk44eopQoVukUJJIITJ9+NxbLbPajw1P1iqVitFwhlyBaBuvyD0AnSvVUT330iLvRYp0xDGNDGbP+2fA0Kij8LSA6Vy5BcKeSKuticGJTOdILaBZBHxjaWGi5YQ6ZUoNKT8AIVdMteagTN0L9NBsMjul9v0owmeKqtsvBS/aYfwuWSmMlbzgLp6iNS0yR/JEZYMT3TGxrTHdmYXI0JtE56fHgoz0po5QN3bGSV5QOYUGwABxzLeUrkpjh/IPhC6e2otTwhaas6R4RCc3+2jFXnrDUV8G4Mgc9DOcY4xBWJ37RcJvYKbKMNaZC9jNi3x3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+Cfs3OtyNAKByy8By9BOxk9zf6RL10vh7kZ06stmDw=;
 b=iv6nQsRosX15IRwrIhQ7a08uYjfexYTawrjL/c/fFO2DhSFTPTzlmXnx9oZdDAee/cLObOqXal/o/ceyR8kCvzN7y71wEFY7Ra50mpLuFq2qrn4kjFGYxYkDCHJUf/OA6ghhxUDT1gZN61dwWd6rr3ejLvppa20TC5JwNoq8+PbZt4qceAHCXVnkAvQ5JuWrPZ7v+RTsjM1+dk+Jgiwo5pY2jPSY6FWdViZESAhVDvf26Z5DNzIYptf3RMRNyOTD+7s7cRcfxyC7a7mTht6vMFTbBlALKdQSJGoQpwcoRBPQmSIAspFbxkhwpdmFpNzdIsc8qODDOhVS2lH8SnPOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+Cfs3OtyNAKByy8By9BOxk9zf6RL10vh7kZ06stmDw=;
 b=j19adlYMhqhk0gI6OHNxgxz9g2yQs7C8gaVAaQ3NHMbvJS5eiYiELQ9gBoUSwz8qqDO5BODnH8dr3ClpNORi7FbhqIHs5Rn3s8X1zUnMWPYDmbBxctc2m5vuo2bAgTsgohGBwAbMB1M1P1Mf1OPh+d4giaxeSpPv4AxY0eKUKZs=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:16 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 08/12] scsi: iscsi: remove unneeded task state check
Date:   Sat, 19 Mar 2022 19:43:58 -0500
Message-Id: <20220320004402.6707-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caf5843c-9fe5-42c9-7944-08da0a0ac2d3
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB399217FB2E011781023D4A46F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egW3eYW0hT/bCNDTYLUKjpIiYrqxNuTi69+gBv2IsMllqnS//HVrPkinnPBbRWoQ00pxMyVMMuu6/ICBpSvH/JUh3RyZGWZcUZxhqR1Ckuw52sPXxj5pNwTNiiQHRbbgcxj1pzhAi+UfgPIdSdzPqiuy3cSh+lJtWECVU/JAfvcbTsbNgphPgdVb6vG0NOKsTPKTb25dpaOa/mSsZjd4Mm3BsBfmrWhL1DTj3S5h05nt8Uc8ZyOhb9IBXHhzuLYIO9fBnNKYGq8m5XhSjiueRr1jagomI3YU73fmb7d82cDIS3XX0zmb68YvXhbl1obUAHdTltJkC+grzbYTGgaOSjxQ5nv1oNGaTtX6g52sgLQ+2f732USQq2hy7IFifiG5d+pYSpfoWCHLkA7M3Qf4Ua05SvpYtsQaTkrl9BMXLzaUUaQsvdv9AmuaFJZ8wbStXLn4zlzMFWd54sj/jSpF++UuyfOzWyoIul/Jzdut85Fm2hA1lzX/61h75yxQxERQbslIDJ91tui8fMQVolZRGYs0mKg0U0VvcAsR/4CXHVLYrpMVsVh2uJYhPYlugP0vck7jxXnqCGS2G8kB1LBl3rfq10vsVpTFLxGN0JL3OgPVf7JV/RsyxFqeiZkcsXVdBB/U4tu4Q32BTjJpnJ9HtW1bgIAgm49qro/aU4moQUCDXj82kY0vER3YyV9OCmmsA35r+ig2bW69Pc89t7XkzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(54906003)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?75BQIjtODnooSYKns0Y/YP6zQxoyscY8Bm1Zw5zHl0mpjNdlPKjHcKYP5IfP?=
 =?us-ascii?Q?mY7FRELJaDUbnz83/pIBKCM2anHeefWIYAdPm/6bl3XBASHnG3tjEyLtpjHv?=
 =?us-ascii?Q?Pk2zSoSnPwWfUkOHJALijpNJm6xqNL/rrPkIgAvbvE01/+wpolf8sKTx90ou?=
 =?us-ascii?Q?F3kNXXCLpWgZ8VupOPrBGtgW3gZ3pzo9BRFudEQbu6KWA20F+wEQXw7XbFS+?=
 =?us-ascii?Q?ClPYMNOr/f5jTcozaXxNPw1zZfWV/c6nDwNSY8b5ECdBtJVsjmlDKY1NBwNA?=
 =?us-ascii?Q?n+nozrJyDVhyIdoqHEZtT3+th2iraKWP4uOqYJ35m6vaZSxFNkbrOw4ULGRI?=
 =?us-ascii?Q?br126RrGQ6Wsw3X2PDx1LwOoKZ1gQw0PBSTzJ0dE5opF2m121XYWz3oy+7zF?=
 =?us-ascii?Q?T0Me8LcGmJ1y7XilVFyVjEBHyKAlVXCaQcSK44BoXzP8sF2amY/Zp67fDEdq?=
 =?us-ascii?Q?V7G+w9FBGrhPAuvLVkabr+/34ZubgrXNWSjTmVD+8UdX3PG42tIT93iQdh9R?=
 =?us-ascii?Q?oF8043tZ8zl9IxBtp4P4wFTLvQsNWp+QDLd3EzKRrMPDEZ6xU9AdID6Lig/O?=
 =?us-ascii?Q?2bWDL9GjTQ3Fn0whbSboWyLVYpYWTG0OdsGRg9y69JullvosMKfDEsmvIUji?=
 =?us-ascii?Q?1QmNZJUkBB/poeqbVaXtcR6Jr9tcBH6dYJLNdLA0gGvJlMHeV/7I5s6XDjSV?=
 =?us-ascii?Q?H+9ZQ6z8YViFPt20lHkfxi+RNDyOC6fibvo4cp3W9YUhDfcurMSQWPH6Jkqz?=
 =?us-ascii?Q?PeONWXLf5Es7+HLmETJE/ef4lHSY6zo0kEHXtDNVgr3F9cmDchSKr3NJi4ML?=
 =?us-ascii?Q?a520EpSgmE1A3r3i/uW4AarT7Id4ZpJafO7kdOZ/9NVb5T5UG+DkA2KEfTYS?=
 =?us-ascii?Q?3jB9MSutoXAD58fhtrUSWy1ZO9WmStpjzWITXwMd12s9fsOtbYFOyCHHahhe?=
 =?us-ascii?Q?0G4PdNPBgBvhJdE8fzRxAFTpm4eMk6EG8G9r+EGabB0IJzNmyNq0MC6emtOV?=
 =?us-ascii?Q?BMHcv0Uno+76g8wnEDsTdp6S2WTt6IBscfWFFTrCbO28aSF9iAU1q2VHqMn8?=
 =?us-ascii?Q?PKbSwlCxZaORulRjl9JuVVc9rJaywpGtIKF5kADJ1dsAV3A2/6K9IKQ99Y2a?=
 =?us-ascii?Q?hKa8oyumcc7frN6xu3mOf2UaSd1ClQpZkkLvQxapqf5gCDvqv6cohzqA5Pdx?=
 =?us-ascii?Q?vEQQbK6q9ve1sNGh7W0SKskgGQXxCe2jtn/Y70qb849dDFsecXdOmeWwtGHo?=
 =?us-ascii?Q?U9Ds73XZyx3dUxbiGlSxQO28bZdpEj4TIC+EZhb6NksoBbZqWYmGJ4+9Thi8?=
 =?us-ascii?Q?f/ZYh3a5eTKWx55PzrztXQ8geAxG5/0029B0JmQp7UwnGMW3wNwGBxrCr54V?=
 =?us-ascii?Q?JLKSJgjohjgml26N5AtcBl56TY0y2lP08DcLh16YrJbBtNZHuvIOxsHMwYBg?=
 =?us-ascii?Q?i6z631OoR6/+L7qYcjuilQ8PyCRSDpzOEV5x6WtdWYzD4GYwMBuptw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf5843c-9fe5-42c9-7944-08da0a0ac2d3
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:16.3123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4t6apwZkjxprqml5b2CNrfpTiOI8XUppijxrH40r87Em2ONJY1pdg7IdN32vt3wsBWr7vkfTfLSqn0iKHrbgC59cbMmVJZ2rijs3392Bnac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-ORIG-GUID: uX3PXJBK0j1Ly-8qL1QtciFL7opP0mEx
X-Proofpoint-GUID: uX3PXJBK0j1Ly-8qL1QtciFL7opP0mEx
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

Reviewed-by: Wu Bo <wubo40@huawei.com>
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

