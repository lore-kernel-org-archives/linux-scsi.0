Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05985C4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC9AE61244
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhEWR7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhEWR7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvocI121474;
        Sun, 23 May 2021 17:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=OQkl+eOFHJgtyvPLVHnAsHCOJg6UvYsaWu09bCbQlub997HzJ1g6NAWYudsZUHPz7Jm8
 tSE982YkO3bqvj/dzC5D7+uArco6MCP2GrI3UvCnUSQANaFEELbtOL3ELPCqXUpnpub2
 E8w3XGe2A9WowXtDo6tB+3vQ7NX52vTnRu7+SatiGa9EvwJdQVqXdPHSrIp4hDs414WO
 kwK7QmkCCLP2f2NSOavFjM2GpNHwpCNwMgA8unQgZdduy0FtcVpGKndBRgd8Te8cyK7q
 B+QnrKV4GL7TPIUax+XpSgsDLHA7CPZfXCaXA+llWNjSVS4mmyJ0+Ib11DvDcY+67m2L og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp1erh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu0G9119789;
        Sun, 23 May 2021 17:57:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg5b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANXN0vfi9nb2hyYr7xCBo9wevtoRHRZk+T9FbSiFKvP8kzmxz/e8mhqkD5qY8MXqPwYj0DpqXTp13D3Zf2CPXe88tMXkSyy3p3eMWSdS1xgxwM6BYPs40PuGXWLTcD5COcs4z4fPFHy7uLtJDH8K7Fnwyn5n6SHe6jmgNJNNbWXxXmhQd6ei5qwDJQs1+BP7c+0Scezo/t0AJhJC4kOC1jSm1S+0KquigCBx97zYhiDcZzYgG3gJYla5c8XaXOFYQKQfdi9MiMJZcqB5unchi7Xu9caZkIorzMCHQHf17z8q3k/TCdxFocmqxk1tDOIwbyxzxy/MMn+K+IiXuY8SPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=IBiJt1MCao2/o+SUHqjdBTdulHxAgMAbyKVkFKApzxw+dhvP4fl1KbkQ/hIUsn1qdnrLdSYqvmV8tQHepUYAZAiPjX9uF5Xu8q05iRwYGz3IF46I8FWPe0e4K+1l0/nN9fh1bb1ik+goxaPO3OGa9Q5WwQAxvHQXgFag+4WcVkETguWmDTgF5QAV4FRIuxSM3X8t3IYeAJMDZ3kXXoxFm4o2b6oXNPSefuYQykw0H7D++BMtBbVsAdhGDao05InhanynY+Oh+7L8CJxWSGcQ5uoiUAJ8+yv530G9lkTnTnQZPdEtKlcufzLHDZ3UEiVzwNJIgKuEsep2UpB3Xbo1HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=lY+ilAnb3tDOGm6R/t8ym+hRLwh6+a+KBhpppRIY1jGoDDE7/gVvJskFERsb+3xbSfF0D5uG8f+KSv6B4wpuxwIcrJhm/DxRfOWuzIVJU+Ep0mdXNWaMxb4KCrhJX0tUstJs3707KGLjzogwMM+pAHHZfxVtkqYiqV4u7Rvrrp8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/28] scsi: iscsi: Use system_unbound_wq for destroy_work
Date:   Sun, 23 May 2021 12:57:16 -0500
Message-Id: <20210523175739.360324-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 439521e3-b74d-40ff-c690-08d91e144a21
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB400478AD7C775171287DF9E7F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aw51blHgijBn9HB3M+aEGgJaftgVyNV/eXwSvIE2PuqWSCno1XWN0gNVjKKeJMB9cfIZLCd8dJuflPuOWty+u1U06qWIEXAadIEQzaLRtREOPRY5MDQbRI1/aSKZFMhFuCsUvaT4CBSw5AYbf8APOvmC34VF0//+Z+HFdH3NUG0FcitGT/hldzh8d6+2rNjeMijaZO1PUZgA1fdAQiwcUgca4d08FV1yYmKfB/U1jdvbr+DzXNYDk4XSW3NM2UxGyLeFyP+hVit/ItkhuNo8WXj8+Us0+9A5IQ5ulHUQBRk7mKQSLRtmvqG9z0sZgVKVyxHhNQfEbSzZ0btPDOL6JsT1eKEBq+MusQZa7DJtajX+po5+NSC+AicsdcLKFEqPIoybGyCfS9EpPX3DKyIjbsNi70eH3BZ0y1O5OtDm2YjjLudEax3D5p6aqCvSFzp8BfPu0GCOeE3N7fFJ7Wtgz/TG4Dmantq9hQGIct0GEBiD7PVDwuqlvJXQlGymyqk294f4CEJ7guMAjjfBqw8DquukHOxVJ2QfeY7H3ro52LO6oozGmwe21B/iRFNdK1TJqGN6uPYfcpPhTU/AskqGnsT/toqf5A16xO45GEid/vorwUzkiDwyEOZiil+oKPSjOzj5pxdJRJAWCFmSguQhbZzFZIynRFkGeDOkuAcA4pZddjwuCKMNwAklgNkbrZyY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cS5flpdEZ8Rk23FHbwZJc1le2w8j5Tz8Vgpk6cm+0JFMqYVW/qZVtvK/Y+wT?=
 =?us-ascii?Q?TWhU1EOtoZIJ2RlYTQobzg5Ps9ztZKqUwrZwZoxOOYd+xWiupdKM2WbBzTdB?=
 =?us-ascii?Q?4R+LlOLE6Cfmqv7rRwmFvyZlfLFebvsAtrJ00QYsWPTrnlB6wbcQm+jGavFK?=
 =?us-ascii?Q?m16yanbqRzkAvg/M2mzNtzyPbrYHtoQaJ58CXyAo+TY0jkelTkdxbxCKKvog?=
 =?us-ascii?Q?MWwI1ZScidlvHE0ckBEFPjsvw9iSiEpThj9EKizAWkZOih7S/Dny51MzFVbl?=
 =?us-ascii?Q?ve64I68r+VgTMnOalnxr/k3ofQ1oX+SteWaCHNLeFA9jap6tW8wypXmuHf94?=
 =?us-ascii?Q?Z15mzLLEi63woocGFA1W7SSl3Agk/LQ8+Wj343v1fGu5wnsM5n49pj6v9RnC?=
 =?us-ascii?Q?llLEVvwIim66WoNTSptmrvFGwetP0fAh0VC4JkHNKOUjkcmNlOR5Njcq4G6e?=
 =?us-ascii?Q?P+bRE9U3XHijB8TfjiL7ve0DJTj/EeLAe+D3h+/kJFaSvuMOyKK7YcuMHuSQ?=
 =?us-ascii?Q?lg5/voNV46la2Z7dOHgcxOKiDnhE3HqaoKm7GNRoj1stS9W5M7CwEl8Q/W9a?=
 =?us-ascii?Q?cwv/z1hNHEJqzk7N6nMb0PvNbNc3rnslcwSMj5Lp6JX5xUYGC0VLV1C2F1Sc?=
 =?us-ascii?Q?woSCTZG+3z73AjjFaTnKwzktAgcyLUsEfWnhWR4PXtAl1g2XOuCDGvw3lWSP?=
 =?us-ascii?Q?DbULthFJ+yXwrkRWVAAz1ie8P/SqBJeSaVWuUAdxh3Hoki3LDRTFYnQpDjPP?=
 =?us-ascii?Q?H7up8R8bzdXUJZFz1BRhMZj2JspY+pvkQ8KsJlN1DjsPsbA1eNLjNwFv7/+B?=
 =?us-ascii?Q?R28kGTeJTAYkTwi1PD/fV8Ych5tNjl7z5tGMeVjvHf6V9jtTLWt/DQ89ekhA?=
 =?us-ascii?Q?PPRcAgl04OcZyBProwX68Y3joqfy32oEwQcd4myxbk45yE2cfQZGh0jvZpq9?=
 =?us-ascii?Q?/YKbE3aUzEtffVXH3EHTY+UqmJeB//rfYASPV+v7RY+ndXDgmYeXrjCb0afo?=
 =?us-ascii?Q?NpHWIWU0LIQy5IRGoNgINgkE9v6CXgzQCeN4CcXNlMcT4FLXalpGslZvQ1tQ?=
 =?us-ascii?Q?E8u5IIsgFZicvBm9pL6Wd/CJPJCbMWtGtBGhq8FANKRqnWVJOD541NlQsrdT?=
 =?us-ascii?Q?QiRffNUWFf7T66XQdGXLp5ydx4H2PSw98w7RkrD0zcSEwTbXeEPRQ4VhT7bE?=
 =?us-ascii?Q?/rZgBZWmpGDOXgV042WGFbp8BttE79Y1DCs8agCiOdTfuzRrtcubbTIub+Lf?=
 =?us-ascii?Q?9z+xIFSfTl0UwMN08eRvIX7TPXReqxPMsbcfFk/B3xeszxet0IRXvfJKapAI?=
 =?us-ascii?Q?HB6c4VoZSFINFJDb47+wpuX/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439521e3-b74d-40ff-c690-08d91e144a21
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:54.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHChr6Q3qGXt+MYRMBj39vGCds3dD4OODtyNORbA5R14mCA4vSCG73ILNbQuyyP3Sk4pMebF00GAY6p/uAzx0LXQqXIWc92RPvRSOsC6dG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: 24zlfuTqVTHqOs-WGd-F-fma-H3meVTe
X-Proofpoint-ORIG-GUID: 24zlfuTqVTHqOs-WGd-F-fma-H3meVTe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the system_unbound_wq for async session destruction. We don't need a
dedicated workqueue for async session destruction because:

1. perf does not seem to be an issue since we only allow 1 active work.
2. it does not have deps with other system works and we can run them
in parallel with each other.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d134156d67f0..2eb77f69fe0c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -95,8 +95,6 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
-static struct workqueue_struct *iscsi_destroy_workq;
-
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -3724,7 +3722,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
-			queue_work(iscsi_destroy_workq, &session->destroy_work);
+			queue_work(system_unbound_wq, &session->destroy_work);
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
@@ -4820,18 +4818,8 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
-	iscsi_destroy_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_destroy");
-	if (!iscsi_destroy_workq) {
-		err = -ENOMEM;
-		goto destroy_wq;
-	}
-
 	return 0;
 
-destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4853,7 +4841,6 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
-	destroy_workqueue(iscsi_destroy_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
-- 
2.25.1

