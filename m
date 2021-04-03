Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD14C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D56F61361
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhDCXYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45092 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbhDCXYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKJiK097412;
        Sat, 3 Apr 2021 23:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=UUD07z7QbguOgdelNpJw1RzE1qxtr9WjpkTD6DTLl/c=;
 b=sz93juKkzjxK9SPvyugq8WGhtMwPLz5f4FfDMcFIr5oqFyEM7jRrhzqGWX/RGiiefSO6
 nQTuP7bQr7sn6sRcROM88a0jASKPX6nXa9jBK5GPv6FXlWK9V0wncY0MQvHWgxedg2q9
 vk0OqH9jLcETAyD+frUqb9zu99ahVx4ZE0iApOGqfjZ0OJfsbdHrM9MZqwTB+cmxGmrW
 95yryJF+9BlxTtCwMvQixjtCNiEYDJFbDvVZdIXEhvd1MKZYLSYq1BpZIYTwb2N/84Af
 MjnEPLa4pmmFMGLY/GR8wOeIUPsQB3Ws5ZhSgznnd2Eq1eXDc9EZfg5Zx7EPOU1nxCCH qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtWl117032;
        Sat, 3 Apr 2021 23:24:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbsrd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0DN113trwd+nUAvhksXjynoqtkUVSPm5vZj1l+PG85O2xEvqaZU+adZxW9y0pZxX9STViPhKBfk1ekn6CbkwoHfslAdaKK3g7m5qyArDkhpwpVgc82GFtIMFuIfL9d36TTxrh9jACUIy6GZX0rx5WuPNZXqChY+v4etCvL2aFmZSMdX7QcxwZ5FPOJ4B/CoNiFkaBJqUmQggU8zlcvlkVaK4r5tjcUqymgfo/ZpTusLWf/1IVEnYYHqCtm+7ogV5po3110qr/Hua108/rYTvWFjjpl4EwjAJT0dRg0L+75qsHKFCMfnIJ78yQy+MqchXPWsIF4zpeeOzLiPhGS3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUD07z7QbguOgdelNpJw1RzE1qxtr9WjpkTD6DTLl/c=;
 b=XbcwgqzSv6ZhGBn7UBZVELxwtC7blUuo9ZWwVSNvmNzimRRKHq/eCLx+mnY8lSkhj2h5mzJGXO4XuNQwWO7S1u8TJLrzrZ37rTViNo/IzNpdntyJQ+zhH0yxnAqNLNxHv3ofS1qvgM7NZXPDZzS4v1DlfhQGcE7YxCoHWdRYC43bSqW64sd2+y2ofHWUtUIEmrtpCwIXpMLHbL95TTYMGzznuzgIIYniRp+LEcG50gxabezg4RUsUVOw1Cd+vh19kpPCTh4h0xiT2nsBrYwK1RJWBMIaIacV5llLMi0Y75Ro/ARTuDR7SYIn4XLK42XiUibSqVtg/yRDfQiJQXTAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUD07z7QbguOgdelNpJw1RzE1qxtr9WjpkTD6DTLl/c=;
 b=uC0oKGfHjiw7n6cvss/b+1XRU1qpgqiKunfhAZWrYYGTb4MS1jmXARse3x8MQaxTd8OV74K6ueKD3y+6izYNJXjp763o98vmHVRBUZm3JmrhONNqJ3IYMaiFR2uQoL3VeZdiVjUiQQxiJiFv6HfNRkMvr4HdhYFUTRe2yyHFWeU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 25/40] scsi: iscsi: add mgmt lock
Date:   Sat,  3 Apr 2021 18:23:18 -0500
Message-Id: <20210403232333.212927-26-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45903a4-3d6b-41bf-e927-08d8f6f799be
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34315EA3D002855A32E79C53F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oN9P5lnut5a5kFonnmPUmRB0yetxgthbWoyv31k0LQIMLiJew2JxbHWGgTyOnuJaSdWVF3Xod/6I+5ErMGX/mClM9/EjsY9J09Uj+ZYaBPQ5GD23vr3RjsqLtjSFVwThzUs+H/511SnvTV3o+czLrYoGLYxwYIOnXmXCaNPR2wh67ogHaFJF3iGXwfjZUCQ7Fz3KGtED6dmNTtA+NmPg+e1Ji9wvz+WnwocdV0iW2sRV42gaeVV/feR7XFBFk5nH5losQX3PSp5tXKr1ioK6IaN9zT5BnRLgkiSO1WkmTsxNPHw71jbOCTeLYC6KtqhMmbSE0qy/6E1DobjFtYRaLSzcr+lo4Vl94Pz4fzV1NQ/zCwT68cc0trvt3JC1k/ylFbc93D9Gf6NBOqiU3kdOTYkGuIJFlP/EH0Tv/f7cDNKHi6oHG3Y0ihj+Xqfx97UpoREcL3nVBCxMmBJCZW9ouWclei2oo3tOsGoaQy8s9wzY25UAoV/PwzZw4vvE1hkixbvBWSXvHLUV97jhNmqJrcbV9aknFKLjwlFaFMql8UoyHsGvoGYOf4b8KltfXEVYiYbyeujnJiskgQQj9zq+IXzzBFi32+MgRfAHS64eBu2xbRsPnPEo5YJCgZPK3db8m9Hr4M9J70zsF/IRQJitwRmlFvZxE7tq1DHEr+eLATnn235IH4UgEmV1wMRbL7b+RrWfoXuiU9qxUQNTgsRgPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(8676002)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ndc8ll45rayiNaZJQ6MtUdgMG0KoZnqQoWhIaFkZ9OjzSjKosMMRF7oAVdfH?=
 =?us-ascii?Q?rzvYn+TNqE7nok8qkk9Bj79bsTnIwW633s+pPk+hthaZ0vpqCYYTH5bU1E2J?=
 =?us-ascii?Q?S1rmm/XWYZ1Ls7peKYbekihw3O8JsAqoy2gXspIt2DyV0W9r7puaNUS5z4O1?=
 =?us-ascii?Q?0swG5o1n5iMvIlhj6q1w6u0nLZac1WowIgrVChPMlgF/h2iH0MJhYHFVOSWD?=
 =?us-ascii?Q?2Bado7hmJwCz1CgDlGVwROqo8ipxeydmxsUaaFZVDo2YSWgGKUIU5dI7hZWX?=
 =?us-ascii?Q?iaepYdCf2MKW7EEjdlk6mrwTX0Z1UHdVflGvDEavpLByNYOSxhJjiDgRogU7?=
 =?us-ascii?Q?Fkm5odJfCBx+WJXIv884tUUNNclOPwu2BjYur8ctX7dwLwV9vvc/JmESABvp?=
 =?us-ascii?Q?rpWVw/Fkv6udaG0C3ItlmzfExyrbpYLBc9PkvSzuMmfn8ZhFnSDuUbnBwLj1?=
 =?us-ascii?Q?etVAQe4j/8t/BNtZqSf9c3aHAi2q2jdrvyEYTfgOP57xpU4p6W6SW1n53rNd?=
 =?us-ascii?Q?/o0AaOtyc4ZXL1gwNMRI5hB7764sMebeMXG/LRsaJqJEgsub83O/EKA/m2ZT?=
 =?us-ascii?Q?Lij3UiXqNKad/7zhQEiXVs2S/i42wrqizufYRWPgIVU5YHFKqOMormK60as3?=
 =?us-ascii?Q?B67phLSi2EeuQ3Pp5VMo5PlmH4bon6/ZU5ZpHQiyZjQWl1RBySwnZGTvp6Tg?=
 =?us-ascii?Q?ZNRNpxH8wxlS+OeCBaraU0/xnM4UScUod6OYKNpz9Q09Bk+c/reTGQw5fZwp?=
 =?us-ascii?Q?s70tE1ZNOX7ybkUmLZzBUlu563WHKh1BUvh/WBJ2ctfgsGop8r9yASZ93JTQ?=
 =?us-ascii?Q?swxG6ds4omhB6KOxVm+sREPhPpjjLg2tD6vcQaj2kmuHAMXotQq3potx0mKO?=
 =?us-ascii?Q?xp1btAHtOl1OPVb8ITHRhmH61OGTq0sWc6ErL6tmxVz733ByjUeml/HYUHbu?=
 =?us-ascii?Q?Q5qa1AF/hJTXXMS3I12xHu4CUBm8gxSWlySPxMmQX5gGnoo71wX+BOpbzUS8?=
 =?us-ascii?Q?uvZCOQHLyVcHV5P6N7lj9wxfCKJg/UaDLIR19aMWSr2FNaiRpDf5TDBdwN/m?=
 =?us-ascii?Q?Xqpo53XkG7Nuxb7zuO104p7v9tst/+k0fudauC2uEVovL7zTEbyKCt0aOw/A?=
 =?us-ascii?Q?6YyuYNgxoH636jFgrDLLlVR4dlspfNAIAYZQmV0cy0CxTNk4DbHxoxcLgfFy?=
 =?us-ascii?Q?a80T65FYNQV3HlWv/ixBKbrK6/YhANpXAGA3kpR3Q7WMW8LkACLckjbbacyF?=
 =?us-ascii?Q?NDq7pp0b3D4cgfGw6siJqjZNdUk8V14tInucgUK/V4a2YgCCE7Cm7I67cxOV?=
 =?us-ascii?Q?RtzZEOGNI2Vq2C1+KmJeUtwG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45903a4-3d6b-41bf-e927-08d8f6f799be
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:17.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ebe7GfzeSjunINbttPzp4c4G+1MDVRwr5Y9rpp9mUzrYPEy0NLl88JyXd9HaoLN/JPI9NyWFpvFxVp7O7ikNZDcp7ojoIqlaLtQsgiBt+7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: eY4qI32CPpMRWyvDOKIKeyt61qcM1ywb
X-Proofpoint-ORIG-GUID: eY4qI32CPpMRWyvDOKIKeyt61qcM1ywb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a new lock around the mgmt pool, so we only need the back
lock for the task state which will be fixed in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 30 +++++++++++++++++++++---------
 include/scsi/libiscsi.h |  8 ++++----
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 00a25af9eb98..f822c0cd5927 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -462,8 +462,12 @@ static void __iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	if (!sc)
-		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+	if (sc)
+		return;
+
+	spin_lock_bh(&session->mgmt_lock);
+	kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+	spin_unlock_bh(&session->mgmt_lock);
 }
 
 static void iscsi_free_task(struct iscsi_task *task)
@@ -716,9 +720,13 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
+		spin_lock_bh(&session->mgmt_lock);
 		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
-			       sizeof(void *)))
+			       sizeof(void *))) {
+			spin_unlock_bh(&session->mgmt_lock);
 			return NULL;
+		}
+		spin_unlock_bh(&session->mgmt_lock);
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -3017,6 +3025,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
 	mutex_init(&session->eh_mutex);
+	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3144,13 +3153,13 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
-	spin_lock_bh(&session->frwd_lock);
+	spin_lock_bh(&session->mgmt_lock);
 	if (!kfifo_out(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		       sizeof(void *))) {
-		spin_unlock_bh(&session->frwd_lock);
+		spin_unlock_bh(&session->mgmt_lock);
 		goto login_task_alloc_fail;
 	}
-	spin_unlock_bh(&session->frwd_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 
 	data = (char *) __get_free_pages(GFP_KERNEL,
 					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
@@ -3164,8 +3173,10 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	return cls_conn;
 
 login_task_data_alloc_fail:
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		 sizeof(void *));
+	spin_unlock_bh(&session->mgmt_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3206,11 +3217,12 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	kfree(conn->local_ipaddr);
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
+
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		 sizeof(void *));
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&session->mgmt_lock);
+
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->frwd_lock);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ceb01ef12002..8d1918590aa6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -348,10 +348,9 @@ struct iscsi_session {
 	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
 						 * cmdsn, suspend_bit,     *
 						 * leadconn, _stage,       *
-						 * tmf_state and mgmt      *
-						 * queues                  */
-	spinlock_t		back_lock;	/* protects cmdsn_exp      *
-						 * cmdsn_max, mgmt queues  */
+						 * tmf_state and queues    */
+	spinlock_t		back_lock;	/* protects cmdsn_exp and  *
+						 * cmdsn_max               */
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
@@ -363,6 +362,7 @@ struct iscsi_session {
 	int			cmds_max;	/* Total number of tasks */
 	struct iscsi_task	**mgmt_cmds;
 	struct iscsi_pool	mgmt_pool;	/* mgmt task pool */
+	spinlock_t		mgmt_lock;	/* protects mgmt pool/arr */
 	void			*dd_data;	/* LLD private data */
 };
 
-- 
2.25.1

