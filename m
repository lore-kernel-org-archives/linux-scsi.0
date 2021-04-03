Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87177C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E2C61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhDCXYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbhDCXYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NNrvp041494;
        Sat, 3 Apr 2021 23:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Xa93Ay03GcSgd2wpFs9Aa6h+jReE8oiSY496gDiXKEY=;
 b=njiEQ1or5Yv3YnxqsozTWgUKKFO7kSyM3+zor/hx5nRlPhDSNbj6nhicgWjG0eKQjQum
 K4PnlWWSat1t/mA5mTVOkQB8jAQ4tLqy1PWjQdCY74lZQCRmYygP/j1eu6Y/FZ26oy6c
 ON8L9jXDLAis/Xy9Vb9TrDYz2wB2v7kfeVoetaENZQeZxAD0w6fxVimUsvWDZdY0/D2P
 q3Svi6wOUmLbJk1dNJ3Ejj8vF4xcFX3qRJUoB7etSwXhig87OUQy5RYu4/14A9MVucdJ
 PidhAxTZLmjo/3WYjn6Y+SwHF9WfcIPF436lcAAdWPbO7gX5FZUBaAuf9g6WNvjEiEv6 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJsFm132172;
        Sat, 3 Apr 2021 23:23:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 37q1xk81gr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVxw7bVWBPssK5KtCnz4lYlnjYbR1wKAFuIC7W+fSUmNHseld1QjjfWUrmuURBW8S2axWyDc/rzgwk5LYOG/PgigFtHl8nlO6tTXDeW+/8LN3Sg2EduN+3H9Fct48Z/wWoSD8N/gjejpQCXBqhc8zroIuIX+PdOxdSqHZU/7eM3RsJKElI4FhehKETCqIfyvXUVlBeSIS76cEV2o7qEOQ7ftrVaDfc4xxqQmqK/HZJl/0Pg8YTNgezVuxVQ9SIAV4bRdCm0wdSgxKuRQXgNf2ZSdOmDvfl6QmRE5l9g/SEen79cuSXvtPDvT/JQJHJCUN+9MsaszoTMxZQ2I9k06Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xa93Ay03GcSgd2wpFs9Aa6h+jReE8oiSY496gDiXKEY=;
 b=jbt3+t3GZaaYvWp/bIWe8zl3Fdx8uI6e4Ec1KjFK2f1tuLacyIlr1ajh5NWIvQZfiWbZQ5vcAE1wxMbAWMK9IyN7FG7VgGSG3tUmJurE5EJiq/yA3YeOmk79d8pcFOzdAOsUCXHlZm0S+SL7CKquTMsvF9JdyjAd5S85s96Ryk2GhL0gI95mGD+myYJ/jrgqOA0L70dqVB4nNmh11q5IUMejzTnCoZL9sS55Js8Xx7djgNvgDAE/PEn/5LMZYDVevYnSSN72QnqSNm7hON8XNqWMF3y1mFKHkt7kDMrnnNz1X+a84SKbwVCFT8R92NsaAL29eCohjX4bDMa+59UJBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xa93Ay03GcSgd2wpFs9Aa6h+jReE8oiSY496gDiXKEY=;
 b=bzt1X2c0UHDzhZDCQHDWymZnQU+qXoAnVlf0zCqq6f10IJrcPACSv4x69e7QDvy1Vjniyasdmou88He2raiKZL+NH3YrnssLM0agvzX+JQ+usI9bm0Ej3APPfUnmXCK6RiQANhdWqs+CqZvECIFjg8piUvnYZHy5tHU5Vf/iizo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/40] scsi: iscsi: add task prealloc/free callouts
Date:   Sat,  3 Apr 2021 18:22:58 -0500
Message-Id: <20210403232333.212927-6-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 803dab62-2241-4d9d-10ed-08d8f6f78a04
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526F0F7525BF027EF01ABBFF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRv5NABftcVLmZAuTnqKtvTd/s+7VF0aP56T9kBkHLCA0KXWEfWgfjDX8xxYOTdvOWUdEBrdPboKVCtBb5uIUPyuyQzZNPDX7O7UxE2NkrmbFYTE0iVGSaa2I625JT7oGPFl1rjPODZfJ5gXpDMFO3QD6jmMJVvtI+30Jt0r2v8pC3AOgqLbByPsdPbKXZdDUqwjbKJZiMSXuZsWBVgV9WnKJwvaEU/mSYLb9+Qo5fUvdbM5kokI+CRwEX9481S0R+uNOnk/lDk2IweKh8B87Z5qNZv+B6VFNUlj6gXgBElvz2gwzvgfsLetQzDa7re/R0eCf4FipPfa6vJ4OLXNT+TyT56P5fD/Jjs8K3IJPWerCqZjO9o6YpkkAoy06AHKgKDFsWYnMhKbM31InjaZ8kpcZCswt5E0hGuZStoHUJyi7Bc9tOLrIe9m4Z8HaVB5IpWSUPO1C9du3+azA6Og2+iatlHRO8wCafyoXBR8aMxu4rSBevHtgQcgVrO04J99snFwNgcaqKZvZtuTk6EbhHIQFHhLhv5Qo7rAt/NqnZ4CqdXp1/329u9yB4CKoCg7647lKYAdzeg16z/3NDxzUA4fxlYU6n84fNt6RYj6uhXAWEPG4QOOyEMK+NjpRc6bCdaT/NC2qd4U0r4znsN5GOTG6iEZygJf8j+9dFrbXjQ1HCVmt+NyK4c7O8dVkUKWhyYicqCsnEyWYkrWoeGMMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jR3j+Q6INu/SGXBvgTuLmJjoR+SY6gRJAcsa5xnPmkcFJ27yp3wiaZdPe/tx?=
 =?us-ascii?Q?LwS72Mq+OAECo5dBQkXnGI470B8Lre/TY453KYI1K/ZEMe5wdfpzHEogPdpE?=
 =?us-ascii?Q?gegkFm2MGXuo0fRpBKeubf10Q+y3Yumq3Kpp3DA/8oFyktl5m4sWYWRtPUMc?=
 =?us-ascii?Q?jnW9xWCntdc4WrkXlxsQbfEWlmWaoAI3RijYABevz9Xp+6ekh3+fv4dkfpfi?=
 =?us-ascii?Q?6UJA9R7WhnpUiso+ZlAnVs9Eiv+FVOhARl4jLYOafX/98KAh+Y2540q9/gwC?=
 =?us-ascii?Q?GM33t/HTjrQGUJ6Sgq0w3F2ogEpCHTudQXMzb/bSi3vbzx2VTWJoWpAKO4Vl?=
 =?us-ascii?Q?u9D1Wc3IOu27iZM+tXlVFUMjPgC1vk84+stnDxChP+y4wj46CC/9mhBT7ZMJ?=
 =?us-ascii?Q?EFwYVAai1omv+JCuBYp9DsGlKvO+SqGrDyhoKGZqq16p+kDJRaGgDmDa2HOr?=
 =?us-ascii?Q?2aIZFdVpzaO1YDLvnpaQN2xRDyrJxOvAy8GFZxYeGh20kG0MNtaroCtIf9GF?=
 =?us-ascii?Q?5QDVAbsOIQbVEQy6niznkKNg+C421UUT62pIM9LcSk0TuMqS/HyNURScNsvP?=
 =?us-ascii?Q?nH3XPE0WYwhBNTtofmm3Mpi0kiLCnr8HKtqppWjxm7OIKPL7eNtX+N3GdLZW?=
 =?us-ascii?Q?En5hCV2g5keyiB3TBEai6cYGrgbHMLT7Mv4a4zMYSUmFWRFrC9p6yMSv+JIo?=
 =?us-ascii?Q?gz0TvbYzR9XO5+N8tvwiH+D827srCa8JJpyn3un5ufokdCOAFcHoLPnj0B3+?=
 =?us-ascii?Q?KVSKbF8N4YOjPH9Eccp/56pnOqbStpxmCZ9LH6IAilQt/WSnNE4fSi6Zwizw?=
 =?us-ascii?Q?/qOuW8iPFRj18yF4ddV03o60ygQF2FEkmUBQRWMEvrO0bFX5Xk7IICVLa7by?=
 =?us-ascii?Q?pbzATNXLD4MYh7j/lqf1YHsl1hQIpWEtYsh33yANf5E+jFdVawthjDqQA5xx?=
 =?us-ascii?Q?Jmy7jaEMC8I7SY+H2IupxKYlgbOyjn/PvIXXwKA2bDR3+wCk8cRBtKezhhGs?=
 =?us-ascii?Q?ueVjyID1V0CNc/Vd/nckTnEgztxEGXD0kPrFVMz7tV8QYu56np8DSH/MtNpg?=
 =?us-ascii?Q?1iZDXYKV8p8ixDUWEc0A7U/KcDcFkGHA6k1/y/ZiFNhs+RlID3rYDl2af9ay?=
 =?us-ascii?Q?ffRe7W6l+cpbB3sbvqCR3GP3kvixZYzf6yZML2Txc/YH7aE8q/2fPP5GisRa?=
 =?us-ascii?Q?vniMQDwDW+qE0GrhCU8746I863XzsfCQJFUAtbib/1eN2OZr4uq/Fg/dXgmZ?=
 =?us-ascii?Q?GV/0TlG/3e/ZSVa6zeec92QwiNwH/Yc82PCQCXcKXbAcgAEYDG8ruUvqrUlz?=
 =?us-ascii?Q?C0C5WBlnp+kJ5iPakw9u8oig?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803dab62-2241-4d9d-10ed-08d8f6f78a04
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:50.7421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oa7NVXoa8MHNHrP2o0L6Bke2rDjgoBMIDHzydxNG1g1ya294W5Hy1v+1HPwcfZhrTZUV0DuidmytMSwgJlD/tBY25Ak52aY8U6Jmo31Xwg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: FhMJCb5r31G5dEL2Dcd3qRMm6x0wQWaV
X-Proofpoint-GUID: FhMJCb5r31G5dEL2Dcd3qRMm6x0wQWaV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some drivers need to allocate resources with functions like dma_alloc*
that can't be allocated with the iscsi_task struct. The next patches
have the iscsi drivers use the block/scsi mq cmd allocators for scsi
tasks and the drivers can use the init_cmd_priv callout to allocate
these extra resource for scsi tasks there. For mgmt tasks, drivers can
use the callouts added in this patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             | 21 +++++++++++++++++++--
 include/scsi/scsi_transport_iscsi.h |  5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7b83890aeb7a..926d33b2c9c7 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2931,10 +2931,15 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		task->itt = cmd_i;
 		task->state = ISCSI_TASK_FREE;
 		INIT_LIST_HEAD(&task->running);
+
+		if (iscsit->alloc_task_priv) {
+			if (iscsit->alloc_task_priv(session, task))
+				goto free_task_priv;
+		}
 	}
 
 	if (!try_module_get(iscsit->owner))
-		goto module_get_fail;
+		goto free_task_priv;
 
 	if (iscsi_add_session(cls_session, id))
 		goto cls_session_fail;
@@ -2943,7 +2948,12 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 
 cls_session_fail:
 	module_put(iscsit->owner);
-module_get_fail:
+free_task_priv:
+	for (cmd_i--; cmd_i >= 0; cmd_i--) {
+		if (iscsit->free_task_priv)
+			iscsit->free_task_priv(session, session->cmds[cmd_i]);
+	}
+
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
 	iscsi_free_session(cls_session);
@@ -2962,6 +2972,13 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
+	int cmd_i;
+
+	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
+		if (session->tt->free_task_priv)
+			session->tt->free_task_priv(session,
+						    session->cmds[cmd_i]);
+	}
 
 	iscsi_pool_free(&session->cmdpool);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2ffa952..cdd358e20a97 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -22,6 +22,7 @@ struct Scsi_Host;
 struct scsi_cmnd;
 struct iscsi_cls_conn;
 struct iscsi_conn;
+struct iscsi_session;
 struct iscsi_task;
 struct sockaddr;
 struct iscsi_iface;
@@ -106,6 +107,10 @@ struct iscsi_transport {
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
 
+	int (*alloc_task_priv) (struct iscsi_session *session,
+				struct iscsi_task *task);
+	void (*free_task_priv) (struct iscsi_session *session,
+				struct iscsi_task *task);
 	int (*init_task) (struct iscsi_task *task);
 	int (*xmit_task) (struct iscsi_task *task);
 	void (*cleanup_task) (struct iscsi_task *task);
-- 
2.25.1

