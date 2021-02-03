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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5716BC433E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 04:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2A0614A7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 04:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhBCEW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 23:22:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55382 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhBCEUp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 23:20:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131Xfp6175739;
        Wed, 3 Feb 2021 01:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=cNo2YZSLVFsHeWMpEQtcwFkO8metTQlyG6HkxB69hnmht1HhkOpykFkHMhtEyhxO8Hsj
 qLUkY6HzLnLW/Sqrq1dxvnxF3RYy55+YiJ0zmjtg0hItytNHpPEHbt+7zE+WoUXIowg9
 uTRnQGUZFMDNNy6bl2K4LglOgKYoTKAkivP114HTWPl4kyH6y2P2VZg2m6jMRoX/LKTy
 CaF6nrg8T4gONKTk/wI1wR4ajJ0NMNt2wOwEasQvN41aQIy2dnfeCb/j5N//Q6ei12JH
 /AVi9U/dXUeTbt2/qrMZubYWsf7Q8+obIwnVwXTOFHBf4JfnxCiJ2mZ3e710qsJi0Uwa Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36dn4wkggc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QD2O045065;
        Wed, 3 Feb 2021 01:34:13 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2056.outbound.protection.outlook.com [104.47.44.56])
        by userp3020.oracle.com with ESMTP id 36dh7sfwqv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMjNlc9xokalIpWqFX4z+lmk09noXnWCUhcJN9vJC7YAE6f671Gy+6IX2pi04/hygszOM2q3tnNP5HnOS4pANwDmCl32HveSOdeVI0dGMAUI7jfJz4nABPSjC7CPMzUzYO3SyqAcUm3URThDLoXY3CH/MF+RaXkj9ZPsZJyaXgy3gE6xvb8vdYnPc6+4HxILLEiV+hfabs4OMoYT2TTkwxY8gOnVdsCQLdj7VrozEMGDUx4/sZfiULNnkBxW5eAQ4n/AcBv45wn5OyNfzWRgvRYCR1Imu7nSFtavliNPb4lg4ITRSZuED38N2wReL3T/CfyfRZDFQlmPX8xG80paPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=SxwmoGIVhmOUrFBtqzKE3MVKRy0rQlDLzlPEmtgBEj2bTdUKW3PNJtcJZ9g51BU6UT2EhOzFfXefjZGeZMWGvzbzYOUuCxwGE4ptWjY2lPOJ3/MxQp6sMsz91ka2OvO78ZYh5/r7yuEmgerBv2oLA1usGeBv9ij4fauQjVBINNfq9TSPkjYqKCqvb+mZJVw62N984Hw51NNzdFHkCo1QeWf9MCJSUy0d6/ufNzLI9AdQgovZewB05H9674fZ45NQ6tYX07wUX/vAUx5/zbZAtK39/0IvdB8pjB1FpuSanB/RQAYlL5+VOCy6koGAikpztCTzB7zP4iet0YLPRfLnqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=w5IVkynkTcwIrMz0w067qaDU1BaW9UlFB4C6TFu8c8KoO5QLLAGvwhqjbqYoMQyd+IcXJXf1IYpNr5Hc26gfP/9dP7R2qdBvrmzoAsKJgerFdAFXigeS2kRK3eP8o7HF6WG7khgG2e8dCHuApS6rVDZQYAkjmyLkeuXBH2LQQuM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:12 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/9] libiscsi: reset max/exp cmdsn during recovery
Date:   Tue,  2 Feb 2021 19:33:54 -0600
Message-Id: <20210203013356.11177-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9174f71e-1b5b-4225-937b-08d8c7e3cf3a
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5320C2A3CB2DB734F935DD11F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMsRC5L6qdlMVp6EIo7kIDdfb6BPn14/r170lL1DxczyWN+jJakBLqQTkZwWnmu+K0esoY+lH71cmwgQrnk4AxOrFOEhRzyAz1BniA9QC2vap+AgriTEv4rKZrIQBJpQirrKcOEu2syTylEkZyPOO7Ad5JAg/UUbuY7M2+xFRnGT+J59MLqdyL7HnEQiRWufN+CppJdvIueKmWgTJW1OEjiNfGaFujIzmPSxCXWGmpLOzf4uIc9Xov+uIltWiN1U/en+nKngwJGGt+kgoQUDoAFoMSJaOwal1DI6xBDLWvsNECxKnQ1zFzuy8WzG+LcF1lVHKLK6dSS51oDWjt9z9xt0eVhgAEr2OfP/vYxCusWcU0Z5pvfJQi+eehsE0NZHka3KpDnY2QJ703DmiOBCeyPfVnFo6Qvk1pnh0bUuHm1zmn8nooliO+cJ1ihTVC+N+JINJx2houazcdTFxPZnbtJx1Asfr2ODEGmU6mOCMZHTgMdvukHghAidW95YQAgo/lCqIVOIa7rqk9XFVfKYQ0dlunXRaq6JhriTNMuzGTtmMKv7G2O8amV5k+oNzRZvuRYLiBLmG61flMEwzfGF2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wbJZkSUIpihzYxaCjlpUKJMCfEdDTEFW1bLqfZ7XfibjvXtVH38IplfkaoGW?=
 =?us-ascii?Q?Vgm8QZ7WlYzKuWEjW0fubjEvL153/FBAo53fiOzKREvhf45wrxsVPAtfTQaJ?=
 =?us-ascii?Q?fWdZJKDlplzl0SPCamB8IIYWVcipKSIFnC8ir2OLIErLNGdrtu+LMWiTRxYA?=
 =?us-ascii?Q?hddA619rIswk0nMQka0o49Ap8gOObwuicxmMMhSCb//E6uXZwe7JaLmhRg6e?=
 =?us-ascii?Q?gvxBoO+IxnSuvEbsoya3hdw13+aP6uJ0EhGxUTsgPuhRwOLmzlxK62LsZ67+?=
 =?us-ascii?Q?z1KnnNKKlUeESFSL6n8IMt8E4ixxu7BZevEz90epHZ0Q6Hd+wyXcrJIDaL8f?=
 =?us-ascii?Q?sexnMSQ+yq5HviajXxkI77E2qHWU/eUQFu2fSloVH+kbz1nB5Oz6Kgn3IBUo?=
 =?us-ascii?Q?cbjU0xM7+7NfmeSXQiuSaz1HLDaUW0ZhbrFP1VAt/gZPZP18Gz0dlM/q0/I0?=
 =?us-ascii?Q?UJCc7+HEs+c4HaHWBPVFfKic1ZArmAsZ2IUoM0JoQKLKkeAf0zoKLJ6xH0my?=
 =?us-ascii?Q?3QrI2WOmqEqy+tfcusfXwI5BLzc1L2oad+zoPJikC60DbLhajCv5DiuOafhI?=
 =?us-ascii?Q?mXZeqHIBxDgQHoWHlOQOPVJCrQhW9jM/JGfe5pl+NowfNOW1PdzFWeousCIy?=
 =?us-ascii?Q?G5aUIKFv30hm3SqHSscwNa+dy0utEKe/3HrIUJAoUDyvsfbjjsVXOf82wilu?=
 =?us-ascii?Q?dpxIHpvO/wNZjJ87l6LgmHUdeNFhs7RvHq3t0at0hAbiHeQWPVlRM4aMAa+y?=
 =?us-ascii?Q?In4HXqqU7C7vdQYXExkvmxrCMr+6QGnLspHlub2CPwXvsM1zGQp5WIj4uIsz?=
 =?us-ascii?Q?dG+dZoX/JihlqtpEgWS/iwcF+ouINTmJl81Oay4D6TsJzeZwS3QIofhgPnj1?=
 =?us-ascii?Q?YGI0nJWDoM1zGpL3OnPUyPWd1kAJOhS08OJ+gdmoX2+yMRGQK4BWF1SAn1B6?=
 =?us-ascii?Q?uX0Jz3a1PiLKdm+BH/LmGfyiU+fAKdcQFMEaSlYImb/Iac+OXXwRDhaO/6bH?=
 =?us-ascii?Q?MWyCAMuLnU75WMtGEAiqVjaYacuwlIz+HNA6LUALCvryFzrX7uMZheaku1Lw?=
 =?us-ascii?Q?CZIUC695?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9174f71e-1b5b-4225-937b-08d8c7e3cf3a
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:12.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8s2eKzwxU3R82X1yNLR/CWgJCh7OZL1Sn1UzjtatJSmckGbBEE4aAzXvm7fHH3VfVv2VDGUC99FJPw5CDo2LTMWr3ooZdqDuAsA+oWRZn9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we lose the session then relogin, but the new cmdsn window has
shrunk (due to something like an admin changing a setting) we will
have the old exp/max_cmdsn values and will never be able to update
them. For example, max_cmdsn would be 64, but if on the target the
user set the window to be smaller then the target could try to return
the max_cmdsn as 32. We will see that new max_cmdsn in the rsp but
because it's lower than the old max_cmdsn when the window was larger
we will not update it.

So this patch has us reset the windown values during session
cleanup so they can be updated after a new login.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f64e2077754c..7ad11e42306d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3273,6 +3273,13 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		session->leadconn = conn;
 	spin_unlock_bh(&session->frwd_lock);
 
+	/*
+	 * The target could have reduced it's window size between logins, so
+	 * we have to reset max/exp cmdsn so we can see the new values.
+	 */
+	spin_lock_bh(&session->back_lock);
+	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
+	spin_unlock_bh(&session->back_lock);
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-- 
2.25.1

