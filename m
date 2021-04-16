Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA46C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C0461158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhDPCFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46292 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbhDPCFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20YIc180069;
        Fri, 16 Apr 2021 02:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=PMadTDtjylbwkxeaFp/fRKmLDEdhxpqJT6zmt3/oT4Y=;
 b=o63yKnpx/jqer6Eo4e1LvbKOrWPlVTPoGkBknwD/8fziPstCYPg91MOyF6/Sv2+CJdmi
 FlgYci2b5mrHp9nVev/UeUUzY+65W1NI/eZE3glZDcA0oWnylUN3Wm6+/X5QjAqwQwHI
 hUqNvaZKCthMLN74Stm2xp2Ai0fuxhzjipxBOMoruZK83ZQHIm3qPxdrJXjzI+urJXs+
 FS5TuyQOdbC4cQv4M2j4Sfu3gyvy6fti6hp1gGkE7TE0tsXxQP9V684BF8FO5r9ELfII
 jJ6T7GC5nR0wU1Li6vUW58C8yH1eNkxUm8LZ3X7S9gDT65nWSsHemZIT5MR4xim3Cm0p Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbqsc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xofO008598;
        Fri, 16 Apr 2021 02:05:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 37unx3sp47-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HePBZmtT1btSyVNZiQYk+TGwjFlcGXGFHpWpDz3iF0I1RV+At4FnM2onriPdf1iMSGaJAdHaFt/6UD55iIUE9Aj2zIlYqyIkpU89aphndFYLG/xB1YDDDWbox7+pE6E/R+y6M2BmLl29XWPdJy+0+qOek6YitVyrcNxfSsgTNs8VzDY1MEjYd9g8u9ng+/FcmoYVBXPcaNEJjDUlPWiQmK6j2AXkcNDezLcPgHx9epSUHqqMj//07VRGG/nN6IETjflohkzToM5NGGlTyGOJGv7gTT2Qq3c6ugZFpzi6DDfvE9WGt2lk8WwVGbOASrErzLuhvCAvw9F8ocqy5eIaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMadTDtjylbwkxeaFp/fRKmLDEdhxpqJT6zmt3/oT4Y=;
 b=J6kznplB7PKSo02Yvnm0FMhqHxcu46F7gS/KMpiBn67ZIRi1v9/v8pxZ964ZbpAnYOPhNpg9DCArecnrvUjEcGk80Qby44tob7MjSd5L6st2lMMWtCSp98m6lNzEhot/4wGE1di3Ee2paHUsStvHgFL2694CANy4z/9dbDSPq6xEEdlI32FkEIaHpxS3gfOvFQvHPKulx0L53ptsBM8ZzhkGWR5D5r2YL4+VkeZClrKEGxX/pHiKpml2XlaKQaTPPqvE6fqi0N9x7Q3z6xr6u6Ni8Uxs7Vc+meP1IAW32ymTdMgqHdjeAVE/lCAmSyInY5/UUlHiGR96tRKvjpqiGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMadTDtjylbwkxeaFp/fRKmLDEdhxpqJT6zmt3/oT4Y=;
 b=JFmS8tZzvxOKrcBh/FH2fDbymrFnmm8wqHbM153irpG6iLm5gIErZEnETQwIGw5W3NC/ViTF8ZrRQ6kjFoLhgladHocqw3uTOA61m3Z3Qi2HRgcpyOWw5tF2at++QmrWe8HhpIVPTKbJX/oYQjcqw/uJjnrtip2kcbPjhqt6MHU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 14/17] scsi: qedi: fix cleanup session block/unblock use
Date:   Thu, 15 Apr 2021 21:04:37 -0500
Message-Id: <20210416020440.259271-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd04646b-ac3d-4cd7-6eba-08d9007c0d49
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33182959A1D9C250C27AAD3AF14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/zYMv4eohvKAsn4OBwS9wGQJwsMJWayWyhn3trkaWtmsYc0EtJtDbmyNuunTknEwv8XtaabobaAq9XFfozC0rUpjHTNkKR5c4t0D6TRLrL2lvYX7t3NWfTyXJKjJe9/Dmg4bbNpCcNS2j88yLCa7C0WT+D7G9ITLYqIBuB7VsKtLAqoxm1WILBoSl38Q2As+Vz0zibXb5sgXmodNeb5tBDrdhjx7Po6EfCrEpYzbuGNoxYTT2BHSjIwcKNEBRTw+P5r3xECIRmFPGerHAh028EFl300DD9Ele4sH5tK4XqmshRp8HgThJMl12pLcswBn3kpgjlTtcJyt4qFvKGkQZIjb3zAv7n4PpLSWQP50ABAcNTXLVj+lrwNcnU7eXN08v6RPTCCKR8PxLJcU/sFoGtmFrd+NpiCZ+akoMg2eXj7nOo1Jb7n2IpKtp8bfzMA4VwJNe8ImhvX5ueUoYyDFFOEPFcQ5SXnCrd30u7QykjQboTvq2Z/By8x+SbamOMbJ8TjVtrmm9U1ZQnHiiwu+ktQ6WaKAceeq3KMnRbACcik5rDeF8of1FGmi/fnVeUIGQy5EINvh5qOslGL3SH2nYI7xlUKUlgxQgufjKOnELWQZAEdfEBCJhXxJTPzZDF288keWV8QXHnHec0UeqOEXOYNIxp+uOea0M+JI8bcioR9PTmMAw4M1K478L799G6F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Dg9WVkk0sUroQP2xuLEpFAan+UbHHodYQbchlzSCbhPDPJJITnHNNJwG7MY1?=
 =?us-ascii?Q?xjn5+awj5fObcYTd2sxx7m4zjKs4ouQPNpcTdh2mPP2Q2TuFwX8WyK2AG68t?=
 =?us-ascii?Q?0am0fUanZeMz2RdIW6FY1kdGfZFhZuCCypgon/hdhNbYmUHcooWIPC9ZJu0a?=
 =?us-ascii?Q?xclw5wuM8QB86v2SlcTJfedUtP/Qt6h97IP/57X7guVFh3DOIg5+HNAnorNo?=
 =?us-ascii?Q?43z/Pj0rBJG0HhG7qBcclxY/Lki4pf9EvMiPnP+GuNRaHqpuhwftlpv4vaL1?=
 =?us-ascii?Q?AI1uZrRw9D1eNFNjo9jqD4sBbwSKbNRsSt/cGvc61Wtzy4pXcDIN2fAp6rYo?=
 =?us-ascii?Q?zdPLzHWYRNDTC4I+3K34DrWdTS59bQpcdOPEEfRU2NOqD+CqwV94P7Z4LJjx?=
 =?us-ascii?Q?sD0EasDHshnY8gjN553bakwWkQ8JwSykMq5HRs8VTKx3iWYkmlK3sA4XcZ6s?=
 =?us-ascii?Q?UUK0r1fFhll7ENyLyLDaQuIlrb7wIkuO3K9L8d6dPRAWqRrpBBqeU/vqPNwU?=
 =?us-ascii?Q?8GF1UYtnNTxi2DMMiR01mJZIr2b3Z2cupF2EHeTmCLAuieFOLsO3u7HADQfN?=
 =?us-ascii?Q?wG39xVRRhRWfClhtO717UWTWqpzEXMaLb+Efa7WGk2vu5KfN7MLyAZ41W1Y3?=
 =?us-ascii?Q?/SzSfTib5zRSEmzxmkEuRVEwOqW8Vc0sogInKgzhfNBa5gE2S7lnIoY4H/Q1?=
 =?us-ascii?Q?PqLZgMtKKvHzt97UlHql9Y6khyx9J4k7mQ9G/XBPTMplS710HzRBquXk8kk3?=
 =?us-ascii?Q?RwSLq2KspEBGIdHgTJ/ur3ujCBoP1/sSGpgwnZfhUf2wGiw73QztbP28Eqx5?=
 =?us-ascii?Q?d912V5h/cZ7Akyd05bEnRgoJo4m2HaEThTt6wle3v1eIcjza2enC0aes3kJx?=
 =?us-ascii?Q?W5kp8OL9ZJzZ9BI5660+3GO7PnRXbHUMrd+N4Sw644vfN40BeEdZBlDmE2cM?=
 =?us-ascii?Q?M7EEmexvsjt66Ql7o40mEwzPayfSTscAp1pN6uA632sYMSp0f5ju2V+ldZBM?=
 =?us-ascii?Q?IjdWFOb7+att1V5VHbult7+mPS3SLi0AxcnzrXcnf4KDMGe7cZGLG31FRJXJ?=
 =?us-ascii?Q?KZhAtnH2EaWepFtSNKvbWJR+egUL0Zp7o06yDYsLIGjx4depmHDEoFcNpCGg?=
 =?us-ascii?Q?L0d649hSAj6HOvd10T8nwgsPeQli0Gd3Et40jigAfsW5OXiy3YVoAbLR1Sn5?=
 =?us-ascii?Q?WMMB1KRrcbJyS53785rZrcqFniXyDJkIykxLf7iJljxq4HOoA7hLfBHrKeQR?=
 =?us-ascii?Q?xdK+KR7u8PSwPaTGMrzpazmM2GvCzosG/dFmg/FwaoFDeY+efeaDi5qwzxzB?=
 =?us-ascii?Q?in3oGhNrYi3uFQwyQnznAp+a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd04646b-ac3d-4cd7-6eba-08d9007c0d49
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:04.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4vWIXDB75x6YCjuIDl8ik4DvjaoSCJAjsBZdIwtReR6pgArFlRUFPD/98YEuqYnaM9F557KK1l3NTULS5R/hq1jdSuzUk3zv0VFnwHdykY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: dKG47Xe9hQaQqrV0SC4A_uvDwVvp61M7
X-Proofpoint-ORIG-GUID: dKG47Xe9hQaQqrV0SC4A_uvDwVvp61M7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host while
it drains the card.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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
index 0061866614b4..6e4f7c427af1 100644
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
@@ -789,6 +799,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
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

