Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D057C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CDA26135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhDCXYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbhDCXYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKHZG085514;
        Sat, 3 Apr 2021 23:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=KbcFnul8BHDnoY/3HGL3XfPZUV7AEC5QmF8qvwNFHbk=;
 b=TRWYRIfuAt9xOAquSDrANJg8GjHI/7O/7pZLAL+kKEEC8exDdYmPm7YzVwEkq3SCcAbr
 E4Mw7/CehAVJFjXUo7iesC1h3p73l6PdbxhlzKsPGyNVtpw2tk4OMzvSwYn/gIYgQNna
 Bs9a8EigImR0LL3YYPohcKSu7qpCofjNOJ+eTqGw1shr5tY/HkmpPSZ4hCA64qA7ZduJ
 8ROZmCmbF9qn3OPAmkwi6dZFIdXnnJZaB696gaL/uGcL44PHSCssRWBW0t/V4Nsd/eOT
 pFwW5ewPquKEBharuVzfo9SqsUrGWjU7hxN5Ubx71AsZxAWDUL24enYE9jwYE3ovESbV lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37pq66rcv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtWk117032;
        Sat, 3 Apr 2021 23:24:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbsrd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn1oHTihM7eQ3OgSv6ECT1lmJaFC6VpWt7SWuUZic3KqALMxeDOUVJpGHU/yFtRkdVf2MhaQQ6n8VQoDOzQeA5V6U9Vr4+fwNNVKvEAW4+DdYhIoHtPCupk+beZVOmKL1cc+zQs2Xh9ZJnhfHMwnp3094BCq8ofR+u+XDOIZtQ3soG3GgsOaCvs9t/yaCwsecPgC9A2QowOL0behMAE7lVagjF3y7TzHZfsVJbMTb9d8/m4lUvDeX+5YVtBQs8N5yaroTtYo7eZxbq4iQ505HUzv6sOv55iogwthlltcjv+NTSLtK/xIZON8NYkH1E4WmD1qWd9XjXC48qYcxsLGMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbcFnul8BHDnoY/3HGL3XfPZUV7AEC5QmF8qvwNFHbk=;
 b=idkGsk8N6l2UvTiVF28+3oTcLST+BNsZEW8OyTuXrV1EwqSCMWAdQ90cdOsoVo5Gn+91ISt9vlO08rChV6gNzRfFN6UC+zNjCaM/u8qN9wPtAN7SbKQb39ht0RSzp6MnEYO5UVUwMphbSPJqIeQu20xpCJDQUGuyl7lvGw3XGwfa8LahfcRlKvI2rNN6fUWYjndXJSFBBzQCVvBN3A+xyYwq0forYaUe1+mfqtlyavqu/yVm/p2hIba3Waj82QpA144CniKMT8fF8OF0EAQ61WGtG44ppD/efBfySLa7RGUe3rW+onT4a71289Et3gmo3kQaM0+gszfbmVxRBkCSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbcFnul8BHDnoY/3HGL3XfPZUV7AEC5QmF8qvwNFHbk=;
 b=nTm//mDXQc5wy24nEDqDqEvSzw7u9Z14XTBkhiaZ2V6aMP3LqCEVSWW+C+NwNO/1qtsnN6s+F1Wqm+UaABXaLtQ+oYM3ixuw7WDDuzRjDcercm0g4gbiIN8IbJpr+KyizaHF6E9vlF15VBs3geYYKwv/6Y40wakbGDn/QbIWEAg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:16 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 24/40] scsi: be2iscsi: check for running task under back_lock
Date:   Sat,  3 Apr 2021 18:23:17 -0500
Message-Id: <20210403232333.212927-25-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05e3b572-bf65-4e95-e118-08d8f6f798f0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34315C1AB1AD18E7142981FCF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtUrQhjxtebWcbj4RS4nStNrC7CyeB+Mfp7zT4glteK6Gelh1Pt/PQLC7WCjl7C4oTnCpPX7oMu6gPFRtZ9y1LrklCXZ1wYQ/Fjn65v0a6tUHAI+pf5p2e7d/AKf0IlTuL2R4fC2A+3fRxsNylxpVjjfSxUA2Zs3l/nFAG8voDxpH94WmZrXdTbkEU5Jv9kRDluaZ/PwIgkV3ZPDe4XYNpLFfTbe3e71bL2l9h+hx5fp+V7LwR6b8JI9u+YoOJWVvUxVJ26eACTUq2qSkUg3SaMgreexCyDevfRJuU3c2P+9fCenkSWEdZ7r6zbUwYoJLA2Wqxy9LpgA7+ueIUg+lydkC2SjcpNr+wiX47jVNWEwVU/4Y9YmbxnYs6g1cAp3iYIC+NBjl2tkOz4VRxiriWN9uM5QY0G9FVpFFmpUxO+g7rJRVFTAeovtbdWtA38oMMHK2xYPES100Hx4KojktqptTg72jDrSiDL5k7hc67CuDHQrkid+MqzBGmT2JmvLNeTNMxoMfSb4k0CtzrUXCI+snyoJSYrsQQec8CWUN9+XhTlcO3ryBXcQ+WTjEQ68MMe0sZCWEo87YZA1c0bIHKeT2vktM3TPUG6H6hjwScwH+wXytMKtOQ74Pd8eku8e4+keMcA3P11SQ4s5FTrfLJoQPNpu4pZX7RsjQRf+2M0PZAKG71d0DsINZFn2DhTx5iQmolKsB3bKV0yDB2T5Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(8676002)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Jc7cz/NebZsjghcMZdeICTm+aYlT+8wfJt/BcWMENlGmPMcEHo7/uajqVTkm?=
 =?us-ascii?Q?7czOuLT/H5U3kPdH3o0Z3LUR6/AdANmPCLQnAPeHvYZbuMquPYBUfco2/z8Z?=
 =?us-ascii?Q?mcmCqOhwhtZnJ/Ankd1aRsG3cRX4J9FwdHmM5MgVI5FCiaQUvnVlnCgY0Bdv?=
 =?us-ascii?Q?l7vSO/Z2b0EWzziNLccN/a+aOxtb5GgZjE8Dq9a8xq76ppEmAX65cU0Zb93R?=
 =?us-ascii?Q?tu/+iCL9cMOgGTwSbmjbmrJ67qYsVdu0Onrds5Ze5iAD0B1f4FJyFis/r1oX?=
 =?us-ascii?Q?lMbKVj/IGBPu8Ok3qdaVWgcXP+yUgodoOJB25hiloUj11R6LFeyH5m5pxIYT?=
 =?us-ascii?Q?iWtbJN1JGxoLy4L/jXJpCTWKFxZQtz9+zN/vGAI/k+MLpD+WVj2Dn6/LJe6F?=
 =?us-ascii?Q?IhdsICdVC1gFAq9znzRaiVSnrv4Njk4H0smEhBV8DdZKRN355Trp9U2c9aOL?=
 =?us-ascii?Q?EvZVcxiyy18q0PRHZSVknU5iBfJAJ4RZpXhKrnkf3R5cnUpLRH8udHG+ScJe?=
 =?us-ascii?Q?PCPwA5Arto73hhvjCVT1IMTxL0gV3cFUNUIaoZLUdysDBJPAi4jeZo/38IOj?=
 =?us-ascii?Q?MZnMuynWVUVJx/Cixd/p0qRFpCV+oapPrMh/mqcZxHi/ldgT4toD1PecH2fd?=
 =?us-ascii?Q?cwWnjECn06gk3dRFewPhXqjSJC7iSiO1f2TQeFazWKrUdIlOka2ucClm7eMi?=
 =?us-ascii?Q?1/TbL+lujzbgclf3N9RguUFIn7ltGCZ7Xc/8r1+UQB6IyN8DkU1Hxv2g521C?=
 =?us-ascii?Q?gTVqcOUxrHPn3NM+JiuMfY6kY3QXKUzad2aNyuFwQG71XXsSpHPa3eMmqQYD?=
 =?us-ascii?Q?NyJSS+CVV5Yeh2KMXflTWW+BsxFkwnscRFtI+DmtPo1i4qimGDXVJGpLTnkk?=
 =?us-ascii?Q?FJIp/EO/y4KFYjC3kFw9/lgdWYkHrAIe/R+/2uaE4z7Bnm0znY+69mJ3S2Nh?=
 =?us-ascii?Q?fYHL44s986Gcfm2A2KmnAu3ZeBjm56JS4PpBfUnYEGjvC3MjNjBibuygGk0Q?=
 =?us-ascii?Q?gXrotbdzCbK9axCALxQPU1rg1++ZhGjxk+QU3W55X9W673SjZJjhbb7QOnNm?=
 =?us-ascii?Q?mg76ZG15uKJq+ejXk2gwqpS80jXTLMYhCLr55deQKu97lrlPzUO8icoiLfEg?=
 =?us-ascii?Q?0zEwrvLyG55NkilXkTgNGs8KKVMHcMYXHOIAQBe6bSD0fiiHHerkO1fag7jf?=
 =?us-ascii?Q?5SRVql+oZ1FizsF6VPFAkWIm4D11XZQGLGXrOGRcfFWAPsKsKweAOnGfPQzJ?=
 =?us-ascii?Q?o7+tU3G4mRkAQjLDUPXNk5m/o+kPiyWCOcVe+fjmF7ymKvjnQis4FOHsxPE8?=
 =?us-ascii?Q?MVoiO3sV0/KYWmI/qBQMznyc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e3b572-bf65-4e95-e118-08d8f6f798f0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:15.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KVpzu/WnK6GP8f1ZckIaDItX23K9pwsHE3S8J6lP/KOh3+iGGd/4KJuIfuwDN7PfFVrvLFlqcZ0eIPVGfDfT7fEWhCiy/zZXJXqfahujDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: gAllCpQ2vegZR3sRJP5oFVET_cVQea-y
X-Proofpoint-GUID: gAllCpQ2vegZR3sRJP5oFVET_cVQea-y
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tasks's sc is cleared when it's going to be sent back to scsi-ml.
This is done under the back block in __iscsi_free_task, so we must set
and check this under the same lock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 99eae2add8da..4181769d7303 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -216,12 +216,12 @@ static char const *cqe_desc[] = {
 
 static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 {
-	struct iscsi_task *abrt_task = (struct iscsi_task *)sc->SCp.ptr;
 	struct iscsi_cls_session *cls_session;
 	struct beiscsi_io_task *abrt_io_task;
 	struct beiscsi_conn *beiscsi_conn;
 	struct iscsi_session *session;
 	struct invldt_cmd_tbl inv_tbl;
+	struct iscsi_task *abrt_task;
 	struct beiscsi_hba *phba;
 	struct iscsi_conn *conn;
 	int rc;
@@ -231,7 +231,8 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 
 	/* check if we raced, task just got cleaned up under us */
 	spin_lock_bh(&session->back_lock);
-	if (!abrt_task || !abrt_task->sc) {
+	abrt_task = scsi_cmd_priv(sc);
+	if (!abrt_task->sc) {
 		spin_unlock_bh(&session->back_lock);
 		return SUCCESS;
 	}
-- 
2.25.1

