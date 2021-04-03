Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34577C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020FF6135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhDCXYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbhDCXYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NNpuS087662;
        Sat, 3 Apr 2021 23:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZhM6KTE89lAF2XOjY5pwVv/csaTmIanjvosnILSNhVY=;
 b=cZdjWTeEYOhR4Burcv5m45lfI0MawiTRItbHSHDrSHS4m04j+mv7MZkW4kq7apgKWS+S
 y+NNJX6Ietw8Hy56z44n1KPk06SWvEyLSsb94NGyxCUQPPyHNPBypNZzdqTjbu72K8cT
 lc15wI6Ez5rAisTFnvCr35JsF7kecnMs4fTZ2P4v5J/BEPwn6dUvNIFrA5vlp85jLddI
 F9KHCz1JT7ga4nNtuP2oSDs7Ubgm/APfy+EYi0iyoiFGzctnRuleuxAcJaZZ+JM7Ywya
 4wI4EPOUloXKoU1TI6Uu3GCB5EngrCSTNMDItZTTLPgRGyH6JVmcV6jtArahxAkOnj/n Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37pq66rcv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJsFk132172;
        Sat, 3 Apr 2021 23:23:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 37q1xk81gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMB1NUHCUsc26e9vUpPB+rxdSthPhsRNleC+endHeVulyg79zsLXgX9htro6C1+Whdc8fZKfLv9dmgv15U10yElrVBkcDC4+tN7YOyffFLWuEft9eK/1AR4XnziUsRh0Mn4ZDXPzHyVdkh3MQ2/iZSDfK1Kw1EcjQ1QdB6xA1nGuH58aZ3tfgj4vbDmS6EpFtLEgExfKi5rDwJduhYuuShD5ezo+dOs3TZYmiNZyYemeMDiGnT4bTC3rDV/Jr1t1VMw2W9F5hzbFPzh5tHt5uRD/5h29yJCq4N0+WoXcxzyw3g/cFqSS4iP9Ee37Q7g7EWdy3nCyZzcbOgXDEPRlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhM6KTE89lAF2XOjY5pwVv/csaTmIanjvosnILSNhVY=;
 b=DfNll9gfWWG9ZOozJCndeycXIyvw9lbNi0BGVARS5eCHI0gwDMgMs8rEzcXAsshSrKZ08oT5z1bjXfv4HW3CGctGcmZRmLYeN3zEnJqwrGjiyagaxMVu8znTSRKP7Hc7Jijg5yrnTZ7B4+OTW54Li1AKKtmwW/HQNS+dqsuPQlYQ7RaJiWAKKMFA15U9CyaWou/YJ+n3fZjaHOEiE1td57VIkEO1fKW5sbnGPBm285q3aDYmgMZBYkjW14KY8WJbln1q47FtZZAXBIaBk412klonG13W9JujQ6w1/ZlTzZwxurNCxcHpLupGqdqmqzrE1thWvg4KvuwcNBUYhjMX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhM6KTE89lAF2XOjY5pwVv/csaTmIanjvosnILSNhVY=;
 b=ECS65exddA9PV2nRNdsFxX+MtzfwJElS8Ct9lHGsDrQsXNTtW5er7gUiueCrSHmViEE10e/XhRx5ZBq1ae9fp434opVGCIf2t7mboL5tGWTFRiRTzqqMdavmeELg9NtM4OgFZD04bACODiwcOuqQYiHT7nFT6nPQxL7sn53J6To=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/40] scsi: iscsi: remove unneeded task state check
Date:   Sat,  3 Apr 2021 18:22:56 -0500
Message-Id: <20210403232333.212927-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f55d26d3-f1b9-40b8-7872-08d8f6f78881
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35263E3766B16AAA4160C217F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2TkAXF8eOMwVoJP57Wdyzt194NXyw1Qp4e0dd8M/EcBOWH8q5wUddre+cdbZDijkPe9w9vCxanDY+FVoWBygpzMd2BC3Sjk9fTzrnM2CKIT/bqPluJEnGzUfafVK0iTkKkBNt8ddcO4KuHzZpGawjK+urqdjG7k9c17YAaC9JyY2SQnupNRYE3WYy6iZUGLS8f6ZX2AkiTk7oXm6TaQHCSqdwh5Vl4L4NvGre77oy870H+xLrVuhxdj/jCtRACGcmQeADgzSZJlrGYRspZ40W2TZJBKV6JFvhnr+tdVZyv19r5o0fg+V9w1HNu+jlb19nvtFJxz67hyPA6A/5mXx+A+w2Wepmug5i8eBGK6SymOwrcDxyABoEqytIG7CU5JvDsvsfXasb8EI2K+3qnPIWw2/RlqaG+REIP4Rh9JQh1eLeAr1UMj4bamLX8R4/Zl915PsKArvj8ZO4cngDhHk8XKEis4nZU73b2qNuDAHgkBYRPifj9rY0g7dZqkXZ5kd3yYrG4FZmXgoDvCzPkJ9XmqCt3Q3QD8DeGA4Tg3DwpdYvA1MyOrAupPyKsCNS/NLX8rcFHf4BGGoO2VqTPMpJISPSuI9zSo2JwnGdtlsbGCHXibu9wM8r1oYXaq9D3hF+3IBqOgn0duEpjxzJetErm9fev0NHObwWwZq9BPc/pexrdPbqhzo0D2pIFgOSnpuCACwIRYNoHdm6fv6LRPfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1OM+Q93vkQFwqqOY0BEA+MfGTpWzTFk43qoUSGHf8wTVAfFE0ZXK8gKSYCWg?=
 =?us-ascii?Q?U+u/XAiWMRnn7wJS+OP8JGPajegTKauhEKHjnQOSWaks7HO4h2gVBI6hf/Qa?=
 =?us-ascii?Q?qG24DAoEKjzPlkKOFKPFkZrS96UcHmyHw4GgKDlwIEw0MqN6yPG7yz297XyD?=
 =?us-ascii?Q?f7JdOlQ5k9oOVFRVd0eorMs0lrhccLuLJ/XcvlTYEbjA+9Srrvx9jevyHOkk?=
 =?us-ascii?Q?jaqhzuUjoT+PgNdf49Ccqt6OM9Qlv/xosLPbjakItOs82IC86UY6OqwIGlwj?=
 =?us-ascii?Q?dhVfjizYiR39u3lTvxCzJ7KM0uox8JZxCWObcO45/8TrrBTUIqXylZX1NQ3p?=
 =?us-ascii?Q?gxDsn2KfAvvgYpz0WvmOKUVLij1eX/bvMWxXil7yJ8fOrOE7A2kdYbIQY/2p?=
 =?us-ascii?Q?qeE8wiz8BUf/iYHtzAFPEDx2tXCvPG42gJ44AJiisOn9J2i9OwlgVaAJddaS?=
 =?us-ascii?Q?DaN05xO5baZxdN3o8ThDhe2m/1KBklI53gE/0ltWgwYKG0eHVTy3PjXRAAHv?=
 =?us-ascii?Q?VUybCx8WUy8AH3dLKG5jFaBS9hV2r3tWrSYv1Zz4chS+Ri4teE1jiSdJD9Zj?=
 =?us-ascii?Q?9uIrsx/73ESASkJ0iNSZrLTWtZ5jA1blpy23Ftm7nJBQy/DOgCCdmTLvr6Ti?=
 =?us-ascii?Q?TpTnSge7qtEmyObRH2hSYm8YSssJoKxq887vcZ7GfZ9VeqW+R9rJb3jeQkq3?=
 =?us-ascii?Q?TCWXmMWVPwoS/MAxjbphMAE8hW8MSnftAi8yIEIeLab5LMgqWbk9SY3NlOb5?=
 =?us-ascii?Q?edA5Zk5jkcbimgtZli5PGPT8n25uoCCMJC5StDd0lc6ylghBqIpFMKRJhlSw?=
 =?us-ascii?Q?Iz58IOfflEuuU6WUJJVaKey/TNVvDsVFilHF7AoapJjRW4nlRSTk5fuTQCjE?=
 =?us-ascii?Q?v96nlV3QwX/d/RWkZXAn/CrgHRpY76U+mBFd7nXblbe14ndDkG+Dw44XLCC1?=
 =?us-ascii?Q?4buNKY5Akv6qyXFf4qbjrKYs6RFtPXKo4v+yDi6NaIKl4ChjsXV7a0Wbexcc?=
 =?us-ascii?Q?Cov48aOk8M8GsBrfdm6RquKPJDpjM6dNxvO1D7W43hTe0ZXlEw/Uwp+8+Ey7?=
 =?us-ascii?Q?A78EuIw1w+h0gbkkiCj6wAEWA6uLwDU/OYFt4f0jiD7naKC5rPcOcfk/eswN?=
 =?us-ascii?Q?j2bVCF1aU5txKwJkO1cwyN6l1XDOu0+7r4NnvFObfwoYqoxXEgUjEldA/63e?=
 =?us-ascii?Q?O4L+5sqEjXPRuBHDy0Oz8hg/H5uvkZ0/aI6Z8LjcUSkYtnfDW7Y9805RwHnR?=
 =?us-ascii?Q?RSPk8SC1mCdQdeVDCnCHdr3vpF5QBpDGaj+r5rA2sQWgE4vpMeUehC6QDbC3?=
 =?us-ascii?Q?rv9jMv45vBc7mRr9SUoeeMLY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55d26d3-f1b9-40b8-7872-08d8f6f78881
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:48.2265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBjZVy2/Xa9RwUI8rOBIJv7deq5k29sM02sIguPzc+SIenZio01CGCD2oiY+lnn0cUsyxDLFe9Lf6B1Kh9Soltp7luRBT3Ws8FVMWcMxRZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: -Ei82_Emy3z_OlK_d7vkRgw9JR4Y0hQM
X-Proofpoint-GUID: -Ei82_Emy3z_OlK_d7vkRgw9JR4Y0hQM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
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
sending the cmd. It turns out the bug was just a race in libiscsi/
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

Since it was just a race on our side, this patch removes the extra check.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 643edc4eb6fe..94cb9410230a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -562,16 +562,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
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
@@ -1470,7 +1473,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
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

