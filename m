Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA197C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B590764E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBGEsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:48:07 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38668 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhBGEr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kVo3168284;
        Sun, 7 Feb 2021 04:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=JeDAF4nGELxGUQm+8Fd5e/qGOb8xIaGT2awBXKZd4UTcsvqRuRhMCBwvl6B3zDaXpeks
 0v6yT/dlyc+9HCDfCqPjEBLJAWMVnsnTeE7tl4gJgXmzbV28IbEVl9mY77E+FP7rcdhj
 aReXlzAoBXRUBnJy80VuYtCIdU8G7d4s4zGMbsEB0bmWawZvBjIR1xZGqabK+Zo3TbZ+
 mQguq6YXmqnABQnSBMTVra0awyqo3u8qovVlSgt8KisjhTboX1Hv7WQvD4x75YbjmvK6
 RNLjr1fkAtisUdwLKlQmmSB6cEYMZXL97fbSNGMiGhrrQFAWabyCLjsQin90iCmhj20O dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgma9fp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174iovc004149;
        Sun, 7 Feb 2021 04:46:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3030.oracle.com with ESMTP id 36j51tcp44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzbPyTfuzRhfE8S39pmzVsuqpNetcKzBJnzYFNvjWnzzC7bFXySeXPPQo11e2WTaMtxIKnnBgZwcVLC+7r93rSmXqQhPGZ6UUCVaF2FAf04gP44Pnmo98/5028Ig4QZinmocZCNTAnS4/9RXz5eL2bCuYTo+mk/NEjmortfLTpqE+nOXBtDHEcliLpSbafDKGqpdImxNgAyqVmDA+1r8xSdq1VdDeQAzbrqvysiUxSkfpiAWXXxN4x0wRLp/ZMCOItcHJ8OxaELlwDQHPLMU/gZ5RzrD+EqwhNYeQlZ9UHxDolJntnA8SZSQc70/eONvdeWdu7HRclN+mvok6A0Xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=ADGHe4rBxqZm/sAmJyFONNGtOHdtEWBldyCw7b7MuBdyMffjeCeyPjI/Hn1YroyEdfWPpjlnVRt52CLdOLUInvvQPQMzMMZfo8bURnJHSJ3rVt5dbYHjlcNYdivA3uDAqzqXljNqbpSjPI2bC7DwNuUrlhvaMSAHKOYn+Rh9TPDDpMmCF9qf/ryvSvGK0Kr90/XEe0/g8xwfLYIDf0CVCMEO+Kk/4yavhQ7S28H97THoyDlxWcYIi/u/mjf4bd3jddPf1l+I8ukiUnM771WoyqQVOa754L1+0kDzW5rM1CCcTJTJ20iuZ64oV/PSEtJ9+iMaNXfOZ94AFlvEA1khRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=TDByf+aVZnU86q03NxxMjxtDbP4OVQhFY7uN/YpiHrDBOw+EsCJufSpjbDqJF4F+AIHQj6Re6QA0Sjdx3aPrv0EX/Zz5aZurnpOoy6Np13SWLQb9nlsDq7p5o4GS53c31wgeu9DZGQ2RboToZH8fPdAI6VarN7cOGCT/EmsVeyY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (20.179.63.32) by
 BY5PR10MB4324.namprd10.prod.outlook.com (52.135.53.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Sun, 7 Feb 2021 04:46:33 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 9/9] iscsi class: drop session lock in iscsi_session_chkready
Date:   Sat,  6 Feb 2021 22:46:08 -0600
Message-Id: <20210207044608.27585-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75befb56-1cb6-456c-5097-08d8cb2357f3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324AAFF68C0D5202C42B3BEF1B09@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSS+n79tuRsopv7QX2qzNClVQjVq0BW/PvCtVw2vseD9lt6OMzI2xroSu8zv4fpyJjmKkQxRoI4gZgncKZ5hWaXAXdTdKGf56PKourThNq+KmIfBSSBAsdhBaMcS3x8c5ltS9oID87sFbtXEhb5HNljTdnuvpZvlH4JXN+aZ6pMEyurgNo8E8TcC+gNImUBfmodwo6YpHrU8LmtK94ToaRbZtJWAwlxRztmmjQcHflLuTvjbAEiHjEcHl1YeHmz6V9w9e18tFwwVlXDLv3cv6jFr48RD74xEVaa1xlN6GRRI5wdAzAJrULrdcSZiBGk/TgKyUGuwqMAoylGJrWMpNmVVf29OnAhGT7yik8euntbG9DM3KMTaMvUwCF5QCyTi9vjhPGrjHmXsPxCmPtL7jFjeDEUyMHH6tPKSTtUYaWaJjxB49FSTaOIHDQwg5oME28FiQEafCpiUNvJW2ot9ZYdWZtLaUTNrs6FGdKFhI54DFz0btKDya6UGfHwiLHNTQDQrIwCCMmAyRsa0+/bvxBWpvOBMrh+ulZoj/rviQ080qSfZ/633XfJB5Lawc/D/Ihpk40iMZGNPBANmuRlF2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(66946007)(107886003)(16526019)(4326008)(186003)(83380400001)(8676002)(26005)(8936002)(6512007)(69590400011)(2906002)(2616005)(956004)(86362001)(6666004)(478600001)(316002)(52116002)(5660300002)(66476007)(36756003)(66556008)(6486002)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Qs1naYebJt2YOWOHwzZVW9lkbqWCrPS7GB7xfMWEcjdtWjyUbDb4VHX2re91?=
 =?us-ascii?Q?7aEqr971q4BsEsrLDgqXKKlFbzB9MpZyu23YptbuJrhugUr4WtavUbAw+ioU?=
 =?us-ascii?Q?fmn1TqAUM9wNQIjMHtw6QgWDciSKNWiCt2+fgDK8F+vRPY5DYmlTnN3R0/EM?=
 =?us-ascii?Q?AVE5UsEQzGWwrcZhZ8znKH6KcqmJ6cBWZhN4KiGzsDgjAQwR5YyDwOyq5VUE?=
 =?us-ascii?Q?S/SkLnac0jBIUPR9iWvK+Ry2nc0y8iVgQ4PuGswJpB3WqI9SM0CCiATcC1xE?=
 =?us-ascii?Q?6WoxcRZzE+DIx0dq3obnVVqLvKtQH7lL3BqeEVA2MnVmKWi9fmXLsGtc2aiG?=
 =?us-ascii?Q?GYGrn8Y5AxOOhCJvdMeyX+XtnActx3RPnxdlGEaeEKYHHyBGAX3f9RnGg/Sv?=
 =?us-ascii?Q?au+CdEhuK/Mxx0wyJh8a1m+1Q3hUcvPa6CSBy39KHWbkHnaDyGCE0nF8GGXX?=
 =?us-ascii?Q?TTio9TusRZbqD1PUr373Dll6yggEsTfmbnKH4jK1g/ESBGBDYwIYP0r3Sfp8?=
 =?us-ascii?Q?vgmScDVgeRxF0r6tnFyXidEIaeFZBMZeRIGR+s4Gn+Gvbugb80MXB1sqqO/n?=
 =?us-ascii?Q?9RIe2mY3gGqhpYXDLStRS47Z9oQSNc6Yfu2gvG2BhHs82y+1f6HRUUxbUtVA?=
 =?us-ascii?Q?51tl7rBgunQOTMpM6r+faP2QqUpZDSQUpvSdZzsK68iIVwHbuwaV7RU+MVaM?=
 =?us-ascii?Q?yP/kFYdG/dzytApH3utsvVwvmCtziHGt4ElFV9TViO2gILy4sdwwtPIK8gXC?=
 =?us-ascii?Q?7kRoDq/X1JlAsRUkN/XuQUBPTTdhBIwGui3QPc2WvQOWaevgDhoipWBlCJMQ?=
 =?us-ascii?Q?K7dAzkNabkEzWFZL306l9aAla19VyUrVfmZEyhejEv7BFjullBMae4Ny7Wwv?=
 =?us-ascii?Q?kWClXeWaxomTckd76fymYdyHQgQBrzMY5cjPdMXqmmttHnDVkQnv9yZu/XQk?=
 =?us-ascii?Q?RbEftHoPEIpJ6QiYOQsamyUstaCdTDGS/k9Z4Id2E5ctanT+guZnm0A5pNCI?=
 =?us-ascii?Q?aFaHHwtwsyrAN8A5+ev/MCfZG3XfVMrb77kGeFz+HEtbjrd1tDyu42+Jw9zm?=
 =?us-ascii?Q?lkBUD72P0UQVnkuwuMbNOuLZF8igLtpna8+YE2n/DY3oFcUezoh6OW2onbuy?=
 =?us-ascii?Q?A72/q1lLptWFe7GRMdI0SgVy8e8hkgPbZJjqOV+hcw2g21bg8jW/0k6nP/z4?=
 =?us-ascii?Q?pgwSZwC5+B91b+pA6b6LB18uSEx8tXBNN/+L097LcST7atpKGPU+2WuYvuTJ?=
 =?us-ascii?Q?hz1CVKp2ZGyC2p0P+LKAOjMUWLVZwgiug2eXe5FUA8WCTZ4dt36/djK0+iud?=
 =?us-ascii?Q?s6fZVX1R2RI0JvGVdfZWwmo0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75befb56-1cb6-456c-5097-08d8cb2357f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:33.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSe9eO9CJgsPGhjIrp/Qg+UmoIpNlsB39PNCgLEQmZKFhwkijCkvAQzoFA81RJQsUuytnURsmoQ9qjaSpvNuMGHDHyUzNpemcAk9d+PL+R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The session lock in iscsi_session_chkready is not needed because when we
transition from logged into to another state we will block and/or
remove the devices under the session, so no new IO will be sent to the
drivers after the block/remove. IO that races with the block/removal is
cleaned up by the drivers when it handles all outstanding IO, so this
just added an extra lock in the main IO path. This patch removes the
lock like other transport classes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e68c0a87698..969d24d580e2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1701,10 +1701,8 @@ static const char *iscsi_session_state_name(int state)
 
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&session->lock, flags);
 	switch (session->state) {
 	case ISCSI_SESSION_LOGGED_IN:
 		err = 0;
@@ -1719,7 +1717,6 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = DID_NO_CONNECT << 16;
 		break;
 	}
-	spin_unlock_irqrestore(&session->lock, flags);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_chkready);
-- 
2.25.1

