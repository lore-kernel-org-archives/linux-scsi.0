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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07262C4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC9A661404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhEYSUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhEYSUc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIG6ME122195;
        Tue, 25 May 2021 18:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=qtsXpH1jK3OfE+VxUDxHasXwkBuyw7plPs2MoHHogV0=;
 b=Hzay13a8BDpUHUnRB4+VLU23rsK/FH0lBdnpGSx+f1jE061Dx2bcu8XhB/zSslzNWT25
 frajIj6vZZCSpyoWTVxV/Pr7AEqTEceH2Ib4DN4aeGAr3B8ium98jpVIe29GANXNNREQ
 WYjIu3qaEkHhCzFBZ1kAB/rFv6zDVXYWX+e6xn9Ua2UPF3iDDDTMvK0YKSiN3kE1tEZK
 yOEBnipp1oQyFU2a8GVOjLZydJCIUvsgHI3HHOLHceshzv/vl2eu9vkdmjdZZunqg4z2
 q6scCjXaU7qAVPWeq8LvFOi5cTconojwrzL8v5mq/GWqy3Nrj4ZrnYrydY2InD1kGhfq zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xcva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGDX7010869;
        Tue, 25 May 2021 18:18:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 38qbqsgh0g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDlAJaEjn11jNKfB5qhtSLUPbVoDjzT9YgeYLVeaDeeugG6v2JMjqAr9dYbL4mJ+9AgbY9MN2NZpqMoLvSMRgkdC1wmOKxfJe4R/TNWO8C0WHk4qEFj/g+ASKaKtGK1EXBeuOQjJJhi0S8t4qu3LDGTu5mL1LxKOOKU+LLJqmTjZsKz9+2ljVnn8uHr6toCqywtUcnUxk9aH0LLkZepTRqc5S6KGgnrbuZroOfzbWlrYrvKKWS8aTjK274EMVa2vvr9ZEA5nFIrBZocBxfg7z6m8nTWhm2bcab+oP0D+GnorExwgy4yW6QWWvZQP4pbt4MAYbDOtvEz7q7yccEYzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtsXpH1jK3OfE+VxUDxHasXwkBuyw7plPs2MoHHogV0=;
 b=ex4LlimC11BF/gNq7tKKD9RzpMj1LfUUPCCBRiFg3liYc4agE7kvU+XJb4OLnh2afKtqdSYy6u2yOuMPraaEi7vRlT/bd1GoCl9ny6eZUksjQjRpGis0w5QkCSsDYa0JuF56qS3sXbpJmVfL3TjlD8qEfpJQ4cGDVT6+JLarsAKyhvzifzNCJUWabyk2N4RE8x9FqNqQxiyOM8g2XZEE6BlkEgYDk2ePkKaRL1nBvVx9o4h4NGfbQEPIKiPxqMPBCvIGkCj0EeSWuZvZ0qoFfReyHvQCSrg0Js05nPJWAkx6txS48WNK9F+gIiEpWkyM8n+ApzL6a6OzFE8qDUF6Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtsXpH1jK3OfE+VxUDxHasXwkBuyw7plPs2MoHHogV0=;
 b=NXwo5k7IIsPb1NoWBSRQiII/2I1v93k0jEj/miXXDsYVntcqyr6lKjvbBklqCUY+vwYP3gvKL3uzc//c0vTR2PelzUK2irsVZo146mf9FqEbJozTGqWubDZAB13P+d4m/jRkIyi+ccw8rV9jZPKuQv0dMJsV7BV4T3uuRFbDPFI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:46 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 16/28] scsi: iscsi: Flush block work before unblock
Date:   Tue, 25 May 2021 13:18:09 -0500
Message-Id: <20210525181821.7617-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 495e6e76-0d24-4f30-7a3b-08d91fa9892e
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB389172BE0578D46DD344F75CF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRv2+9CRUrtrltXIO+1wEidLlJb8d5+uxv5FxVKj/HHyXpTxIEn2mifhnuni0cW3YQ4y7NxsZ++lMMsEtGmDSx/hlQdvcZl3fR6NWFKo8J9L96D4goILfhZWRYsuA0WZcoxs4FMZPYs3WBsfXTbxOQZ4EUxXZflxiC4LjcsnP8Smj9I6GZe5RlsJIfgo2Omy1e0n+wjL0uzyjrghe89iFouYrub7MU3uNQN/dmaqUQPv8XliJbgHEioQZkJxmmpsqsExv1c1ZX2tjWi5LzxGMvCARX1yxvyma6XsF2YFz/tqUtiV5jgd/XQXqLGIeVbQVrLPl7w224G8ooP1TPYK4688b71BLHwc2YdrkXj5ABU0NE6omMAhf/KL9+1RdlGbvuDvuKy4C+ZmrMhIY7GGueDtz6y6JS+A81tllXlRpaoNwmonz2opYm1AwHz+v/ptnSsSaHaZtIefoc9rSZkDxAn8x2WYfChGrtSxU25JVsFVJp9BoMAhfQVVWC2A4DNwYMSORIxm7fWq9x0iWGTYRlE3bmt/JNnndoqubJa8T8HBgA5YOfSvMkRPJk2pVwF9QSBZEz2BUVQ4jdC/HMNPaYXscI/6mlbhB8a1Q8MpekZisPkSw8VhiheM2pjKawY7Dy68vE8eWJN3EErTbKh8OEyYN1xUbZ/EYFvpSDtFUoCxiJRcW26gNSytoohn7rkk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5QAnSkn2hix+fGOjGuN2aJF26WjoLcyu5Ll5UTTdYBdRumPFjoZcGsPmLUBb?=
 =?us-ascii?Q?sgxTT5pZyDHGQQuOQdD55LeJCMS3wxKE7LxEaB8CimuSdtrACOiCKGYTYB1F?=
 =?us-ascii?Q?w4eR5kSc7VQ1PcHhB74nzIdDAZFRHF+g7kj+HoEnMhHQWeUtnE6LxSuOz6xB?=
 =?us-ascii?Q?M/k0Z1zMmIySDCzrfX1mx2Pk4oBoseCGGxsb89i3yHEvBrPV2ngcm6qE4F95?=
 =?us-ascii?Q?PsfXfbxQ8fpjfRQH6SpnxkkItJ/GvblClRsc6qI8AiKjNz0qLN/rwUU33gPK?=
 =?us-ascii?Q?+0YPrCRV6a64x1zBqikEqgSlztaGWmz0/zku8C/xlG1lcoMhW3ns71l6ghQT?=
 =?us-ascii?Q?qxS4nl7iRdHdpMp/p30lfdqxp82RF5iMdPaHIMdS6vtgsIcEDQqylkuuMOnB?=
 =?us-ascii?Q?A2yv0jmctpTdGKU06XAt5j1hMZFIUI+NQsa9BuufPPX7Zs5SvLPguk51osSP?=
 =?us-ascii?Q?FgHBNKPxK99qeGFIH9HziuhcTtD9ef1JQItk4efXOzQ8P6bT2UKOL+V8i2r3?=
 =?us-ascii?Q?txGwF4/QJ7vgcTeQFzYi7g31JRto/UarlKOBDvrmhqrjRJecgrFzS47Dn9yz?=
 =?us-ascii?Q?HcfuLE1d6Qw+f+maAU/VO4B+Uk33loE7S6nv6haYIkfvRj82f12SQdINd6yO?=
 =?us-ascii?Q?qh9Z1ZmB3orVJiugO0/A5+KnQzsBpxxO79GAIAnXKMTeW0GoOiICH7kctvfb?=
 =?us-ascii?Q?/P2GMcG1FJmaukejtRK76A0i1dNqv6cFOkNkEI493ua7g2B5PxLzIgJypi/F?=
 =?us-ascii?Q?qCBdiTPZQB2HEI/Z3bTRkgUls1K8KTGLrzzfQdzqYNwsU0Zy31o5uQ7XELCN?=
 =?us-ascii?Q?mqxn1U7louL4nXPNn9lI2vjGQKUW6T6furwFCo+eTvqCRzET4pAdvG2A4yvH?=
 =?us-ascii?Q?L7LOGLakQYqHkgZoD4DoV995dCSA9jy9mRyP4/yzgzkyG22wNSdSdBvsjLzL?=
 =?us-ascii?Q?puL6wFfpE9fZ+leWwmLGc6HJHX5p0xukskrsgA+HpFV1dRVPPeBPXs7jOHR6?=
 =?us-ascii?Q?aCGf6xArl4gGYw3sKObXb9mqri62QYyIBkSS6LuasgkRNPY4VxTpOtoYF5RG?=
 =?us-ascii?Q?es+784iOP7omWo6TPk9VXXYD6Rrc08b30KLOFIz5r+1Dpy+TVkS3yGEO0s05?=
 =?us-ascii?Q?wZnBPzlpXb+I1Z0o8z9zs9t1s+WgACtKxJe3jZyIZNnQX2LeRGhTxUdpPjQT?=
 =?us-ascii?Q?WhyBs/zVIw0mt9Ns6GoPAsiGrK+Y9OJ6VibrhLGzyCCP0/KSplc8G5E9xs7P?=
 =?us-ascii?Q?Mmc2HpqfONKwj6rWafhJeRsH0hwdEWA72/7ZHMG7+5klT5nlUa26kfT9OT+s?=
 =?us-ascii?Q?NILYPEKjc5K7XL8AqPZIs4fl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495e6e76-0d24-4f30-7a3b-08d91fa9892e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:46.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0JZ3avI8bCdVJhDU3gcDPoS4swF022KT0jzEsAIaqDPdJOeWiunBBjOjqBrM6hyq0v6d3kqrh3mLdPxWv3rWgAQN99A3N408uxydtCSang=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: 6Y2Sw0XYL0FWFKL9NpKgcVKzviltGoWi
X-Proofpoint-ORIG-GUID: 6Y2Sw0XYL0FWFKL9NpKgcVKzviltGoWi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We set the max_active iSCSI EH works to 1, so all work is going to execute
in order by default. However, userspace can now override this in sysfs. If
max_active > 1, we can end up with the block_work on CPU1 and
iscsi_unblock_session running the unblock_work on CPU2 and the session
and target/device state will end up out of sync with each other.

This adds a flush of the block_work in iscsi_unblock_session.

Fixes: 1d726aa6ef57 ("scsi: iscsi: Optimize work queue flush use")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 909134b9c313..b07105ae7c91 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1969,6 +1969,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
  */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
+	flush_work(&session->block_work);
+
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
 	/*
 	 * Blocking the session can be done from any context so we only
-- 
2.25.1

