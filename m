Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F9FC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0675D64E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0RH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:07:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46620 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxiNX033057;
        Sat, 27 Feb 2021 17:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=f9zcMFJApVwiZUeoFAHVbAObJuFIJ33kCDgaWrB9g6kouRnE8hh5d71/9KavXUyOyzBa
 n0uddyTodYuwGElOo906UUOXRufe0brjVc3pFBPCbYfwU3c/e4C28Iw5XupEgF+pypYn
 G4qSGM0w8CcdIqeUPFaZAmKOswxF0tkT/uojYpuqw68lLpS1yyqHP6/D1nrQrtTiG2f9
 loZWOm5ozckXwVWMAUzrAphq13YRXWeBMMVRlj+AQs2m/X3cis/FOlgdPaKaRnyLII8d
 53ea/auWqSE8Sj5pLos8mEHOgGdKhqIepG1wR3+UQHQ3WIf1pTbjgKD0NRg2Al+EnuoI cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslma115709;
        Sat, 27 Feb 2021 17:00:23 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4u+mqCeh2rdNubStj/L++bny7x6/FrBBwyA9p2KcfRNydvrahpFFggFzJL3iM1tckaE01dUVdNYUq7MOR8JZFN90L5pW2hmHK9VeLs3IGnKtCK8kCn/vP2Whsm7PuEwPYzLPjGK992RfK5SqTy7DdgI52fjAFQqa4op582Jb9DnG2FbOtUDW6eotIVgVLo6BoNCj4GJPHgZ0kiRneqBzaRqKY9RNvQGyedu6Xd6qHySajPk/EFxlz+UgjkO4JSdXj9oJZB271McktDZ08oph/NZNli9OMLKq3PKsDJn9tmYrOti+jMoYg+BsTj65SxAtSJJjrf7riuaEd5ieFXqrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=UFGO10L0IdiKUiD6Xwvcyd1LKV5PKylD8Pt0Y8uQ00svrWxfvQPMWbAZSdYCK1/e4KyEmKhMhmBPeuYJl+B31wQlGjSvxbOaO8BiqVabduPFglNwR1LsQnqzTVphvwMDdEdPm6xOnnW2XPvjlb2opG3BFRlm2EdfE7SBLq7xnxREJHDtePca6G3zNTxmMXo2J/4I6MkMB1KLYRdN6NqS099CIZGoR3V7GkB0TDoyH/Yy7Jvv+PXm4I9rQ/Y4pahNTVOaxpwquTm+AZ9RBlqtzDwy7YG75AQ507qsSsnITr8gM2E4pMKu23IpXG/u9jckE9RWP6/EUzFQ6+LYQEnI8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=ntYmpVG7VHm66TO65Or1GlOhRz5D+sBX1Uui5h87mUYlE+L5RPZzLCCZbA1BSJArBc+QOO5mtVDIU2/a9vW0a/QLiiGPR92qswcyWmnb7SSOje5qO5FfVhNyCIlEzvI8OhpK6N5yDeYK3nFf4BNOxUwbEL1PuZtX5xW2rw5obfM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:21 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/25] srpt: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:46 -0600
Message-Id: <20210227170006.5077-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f86892-d377-4d74-dd79-08d8db4129fe
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499C8D8865B62400FFBE741F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcR1CJWPpDmWEb2h98lCbu/1xUmoHoWDcxCHxsrw/rNKGPvisyXyM7RCqAc6NakOD9E51MidvfSKA+XlaX/4bZeud5TBxUH+JMeeU24Llsf0pjsN0unz+GRM2UMz/XGeMTbdw6pTpb9B/WnM8m/kIlS3/ZZEaQLMitdIcRKy4olN/DkiOzw+PYP/mOZGvKQigQE7B7ZgcrYN5bKvGJTjkJMzejS6p+JLOpGBAuPoeS0vwr3jAajmI+SiHpwE+p9djrMNtM2wfjvRgpQcAx9F/8SERIlDgg/h/ySLpoXTPFLh9utIpolbjJEa/9OIkOI3aoZjPS8zQGZ5BGm2TLALTjx5DM4m5qnrNONQmuGcxlFXaDKbHfzE3RArBUzHbmmGBohsSa9BL3JmLQ/kCBpdyAfpiNgOOT+NtcepYKmnio/DSTNue0WhQTKEgEJ4oJ4OmNcyHgFtKaPw+y+9156IfZf2+IEmgiufjSphGwpfztkrlMSnV5/1ij0btUlwb7eOq+XwEufZy70YMbReaa8YeFvG9lgTv6GK7BRxJFG/Af+/lX1KtKnRGrhU9AH3VHOY4l9yxrc1b7LpLNi/ZjFUTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2GUC+fjpUZyonBc+xbH/oDdz+xWm9PUbltgeTAQwx9V9R0Me98EAr/0PJV0n?=
 =?us-ascii?Q?ggRlFVhgwOxra0nnVHlJUT7+/CoOS136rPyD6ib0NV3onVtz4eBgWXiMV2Dp?=
 =?us-ascii?Q?nguiX5KU5Gpe/gTSJriY34D/P6waSvS26rWtXiCOZj0Cah8U6JMzVT5TS3B/?=
 =?us-ascii?Q?AAE6n8hCxKCq6xc5iCThyAmUtps3QqMVy6efYp2bbqd+ET76yaTVlFeYf45O?=
 =?us-ascii?Q?egki60QF6pkEs1MUr1yABmgerCeNCXAhmiZRADFiihLBLXc5ler1Ch4DWjXL?=
 =?us-ascii?Q?SR6siuZDhWLTZ6uBfiA3XKWtoIGJb2fBElrmvEfz9fZV+QNdIsDScCVYzOt8?=
 =?us-ascii?Q?FoffWmPuYj998PWFKHz4IBndEunZwWzzFtAOOtel0LJvDg7SCiuKgSeIaFfR?=
 =?us-ascii?Q?0tZpCcFh8hbpS2ZCnDHfVCOX8saobnShoYOxtp5EBq2lJCKoEZz6ULt+tu5V?=
 =?us-ascii?Q?wlHGi8JCvSf3p/tn/6em7KQ/Tq9Rk1+I6mMOZ02L9YYBe9PlAW8N8mmRCfch?=
 =?us-ascii?Q?x8xDpvQShiAJpDd6cUG6kMxusIcQOZintm2jQJZD2qjO8uALA7EebtoWxLQU?=
 =?us-ascii?Q?jQAPti0w6x/SVkVnARoyOuPnpkOpmYA1TVJ0B3+93Gl5wuLGM9Qr//VNZTL5?=
 =?us-ascii?Q?osQBCyeNDbPnqUF3KpEsJCqUBB5zMXUDxKypJJ75+9v/DDipnngzBxbOmf+J?=
 =?us-ascii?Q?dk3pFigGwen5ptJNGkyWEX+fKCtWAHKfJ5IDn6+/uR3jQQBtuqGOhT0ERB10?=
 =?us-ascii?Q?yfRe4L3OBEe99mzLQM/68TwK5Tmuq+wwzIGBwRH3xt3BMq6UdjO95DvJH9WZ?=
 =?us-ascii?Q?8S7SxZwCema1FPpcVqAnOsmzW4Pd8HdtrdmmRvXfcqC8blk9hcoa8Rhv6qdE?=
 =?us-ascii?Q?H1i6yn98/px4YhHYeVYBgulQcKJbyTFxAQKcvmQYB172AsZYtU5Qgq2wzQGH?=
 =?us-ascii?Q?sn+/xoE7VQ4uDMXgc+m88ddqaVPeZPPJfrdETN6nt7Z7pJi8FuVb5C+VjL16?=
 =?us-ascii?Q?faIx5NU4j88D/xuuHmIp4sATEuuApeDtdv9cDQ5aoQuuCYWC5C7oYgXz3vrz?=
 =?us-ascii?Q?29FxQXtD/LJE+TKgFrfAWaarTKQf5ll88ihv8iXi3UfOIpn/IFUnRDx8ZOAo?=
 =?us-ascii?Q?LFOuHnar2JbrlmyRQqLnlX1ZETadiKCLU5dLLXsiy9y9kInsKkWksld6QKIH?=
 =?us-ascii?Q?dj35jmM9TZntDuaZEqQJNF3B9wXcOdIYW8/C6bJ/DwafQWOKHVz7YClU0vgM?=
 =?us-ascii?Q?gFwM4VaXThZgpFOitOgWg/J4UqRjx5s7/BeWSnkv69WtS2NhHWFG9AsalbOi?=
 =?us-ascii?Q?m4avGjIkJWKZICRQ1lmIc4Wa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f86892-d377-4d74-dd79-08d8db4129fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:19.8550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRY2HtYRKEsZlTLna71+W6RvzNlB4/U5eiVSXJ6Wglf5qLy95bGUbLOdZVWIcYdW275Jqf8IFbsRLiz5WfVSkBt0XFSfBvFMzvlV6X1RtFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert srpt to
the new submission API.

srpt uses target_stop_session to sync session shutdown with lio core,
so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..87741e0b4bca 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1528,16 +1528,19 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
-			       &send_ioctx->sense_data[0],
-			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
-			       sg, sg_cnt, NULL, 0, NULL, 0);
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), data_len,
+			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto busy;
 	}
+
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(cmd);
 	return;
 
 busy:
-- 
2.25.1

