Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFD3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201D561158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhDPCFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46176 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbhDPCFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20MCv179756;
        Fri, 16 Apr 2021 02:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5gI1TOSgO20BBttbU798A2iOzPPtcoT3OI5k1EmJPBY=;
 b=YmGM3mcM2e/UAkkUepzMZz1ORcVgny8674kJP5XRRVxtxTdMorOFLbPU3NAaiQAsePxP
 a6UOKcq/PxbwyS+5vlpeMS+sgIzejXemt0trjKjbE8M9u2ha0hDGW5fZ75Q3B0BbupLq
 gBw+q0TcNMsG5bsNFl4LkNMXNsZLN3fogKAnMZFRL1RV5SjcQUvZnzokOKFC81IDmD1o
 8nRTEHxk9AXlp+LMnOVcGMd5lNfZzp426/xYgSafQIRPCFa/FhTuVZFOA8O8/VWlDMNd
 kJLyhJLi7BOrHhnKbOtmGQ4diKgw9YDiOq4McMIrV+gKbqLJOp9dz4rkoy25O4PRVEtn Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbqsbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xvXe009178;
        Fri, 16 Apr 2021 02:04:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37unx3snvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2j4LdpYArzmd6AfuV/7chaEWSOs29oeO5ChhI0y2pjseHfIN+cNnAjCCJE/FyNwcxNQoU7nyC1nvsWSHwp4NuLR6+PLW/5EavaWNspYh5+aT7BPNYdhRfPOiUsh8rGeHL0Iuol4MJkp0FOsVBhbsDA4fW32XQgAHi4VUdRqO1LD7iukfchfjcU1YFvbENgxDZcO6+YfX6z4Ezbf9Q3ExWPIJ0SyAlEHiLTbXb/Zpw3DXTcFfWEZGWhL481njNGEyaL31j74cKa9Z1feTbv/CTfqMHb2/7N28BTEOlwZ/eawISGnTS0xUjYO+iE+wRorRqhQIfdEo9+SpF4kml6LFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gI1TOSgO20BBttbU798A2iOzPPtcoT3OI5k1EmJPBY=;
 b=DzxFV304jKPUhpy3tmPI7HpvM5edZed9wIZi6n1L+FNDIoardVZbDQBE1ehf+I/Ec2i5veAUcF81qilrQicc61dlUEsDqwxAjt4ZGu7q3xiUL/WiPXMi6PzlwX436jfoVdJXRBJMf/aGTg0Sbv9rYn0sVY1nFdKAd20vUxmZAJUiLKsWMXaXnkg7f/yZp1GYYn93frFKoam9t9jqmX5/O5cxf7qybd5lwdCwVHxoQEphOvARWakopfj7HB7NNQBMFIDK7kvU27db22CVKq22TyU3CdCy2hNULBVo+KzYQgMb1/cVPmkcvQ/K5edyJXadVfIVV7a7rzdrdRnW7G9/5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gI1TOSgO20BBttbU798A2iOzPPtcoT3OI5k1EmJPBY=;
 b=Vy/JM7v4C4p5kJzTqhxmFM6WDJo7fNKrUfXcOMj3cpYRhOTzwSgVKXl6pRdBSpNeAuS1Yhxyk96fqfmqmcBgj+CKZW0ISIXQW11EKviHIlGjo16tR6WmpOF8r0dF1W2/bFSyvUpR5//IHlmbBhB8zM+i1kuKklFLm86vCvttLcs=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:04:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 01/17] scsi: iscsi: add task completion helper
Date:   Thu, 15 Apr 2021 21:04:24 -0500
Message-Id: <20210416020440.259271-2-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4ed9dbe-701e-463f-f977-08d9007c0497
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3318A368C535DA411BEC2876F14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWeC1JtDUlNNfse5GrQSEVS1taYRUmwNteHZUe6gjBp9F0ZG++5UlEeqKa7YMhbeMRu1cKMKa3/lfb5FofaSoSGQLLDNPmdxr50VXcAF3BSY3VHJOismNH6+0ui6MoAGoVP2kESzyhmrSVEG1+Y7TTKpWypuzLOqnmHany+R5SpDz/U7rbn5EhX5451jQySYPPEGVUl7c4TgKs2DPdSf7jblBS00f+rjOwLxm7kP9FZQ1RZ+mlyx3XxuOF2T05Crjh12EM9Wgo7s7MsvCZ7cS1joDMqwCZ+EUXfII2YrNYDoKrpHuLlufbmtJrUaWiyZDadUSCkkW28tTCuuHQlj6LMD/z1vcsv+L0spxdJbQVOAxLhPU8B3ReuYNnsDnh5o4a8hJEKVCIhnUHJQR6pu15ZvJ9PjEQPpT0SjtniJ8MAiZUiqQ4ieLTDovwPke9Mi6NRFnKAd6botHy+43Rok2GsM28B9gjmAtGkaX8ZHM1kjR7fbJ+h7fJUy/btvTy9/a1ZOQiyHBS8VgpYZBVBZh3IaeJRcPRdzq2kFvIP8kWjxtAdwVhOKD/po7D/HcCCdzNuuhxa0nUJcb6eXv0+izi+ZKEYlE89Gq1ujj86eClDeuKQpw4ciBu9lPylFfrgTxeVguCELxg+5XbGkj0P5tPuG9gJsv2M3c3/R6uGBexzfeSVNzvgRgG3aoqlwFH17
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(4744005)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4ayISVFQHLsdW+bbzqlzDIIzNxAbJywWdHsLaZIqeiHMYmhzjfWJTTPUKEme?=
 =?us-ascii?Q?pyhb4xH/bFSUGZhKwIxUzihbCu0OvpsO01i1hkUcryg3+iOdSE7Ytt/QjCYq?=
 =?us-ascii?Q?+ovIkef4v4mgzfeCbWQXDtvPs9d6JQ+JWZv7qURv8/JC4aBEJ76Gqt8YdlAO?=
 =?us-ascii?Q?IVSyjQXedYCEqJ39OIRJuzVpVOILDK3DOFVrOVfMwHY/uXoUmIlugINtHB8c?=
 =?us-ascii?Q?QdUFqDFqx4MletIfEwc5MNqP3K5D91Qo/g3I/RTLXIengRx4AE9zRZ13l/Yd?=
 =?us-ascii?Q?tV/HejGU+wkmNoSO89aDgJQ6NCBUE+qRVktFgxtWixmE502Xkr0DTlQEIdEZ?=
 =?us-ascii?Q?XGL5FhmGDsWRcQjkY7mXljHob7ounS2me/jvv95s1n5nWLIuv79hq8ie9n9q?=
 =?us-ascii?Q?CGLjc/jGsYjWDgBjhb5ytN/3pCGb0xNu8T85WZsNUcCIsZ/Phm5NVD7OX450?=
 =?us-ascii?Q?qzi1PEVV0DkLO0j7XnND60VnoUoNpOAs2073tBem7ldBz9hLRkXr9nIReyfl?=
 =?us-ascii?Q?J+hFDmsyxfv6dGkbvFKOBsJudCgSBIo9ytK8G1DRlVP5rTGXdM23H3m7+0fr?=
 =?us-ascii?Q?68icVCO1U8JvORf9NHKCblzLTWZ1A7ibLk384s4B5+7joANhPlfmA+kvs9Tp?=
 =?us-ascii?Q?ywWqkeAje2PJKQsgeSjMQS0oER8gtSDQCsv4vyawps3ESlEiyunMbOoX7Wbf?=
 =?us-ascii?Q?ToCO4e7b98g9+A8Q78wjUkUNI5p7JlLibn3aCKI872N72p+/WQf3hL9qQt7V?=
 =?us-ascii?Q?pcuvSQhCEKiGl7dvYdL3nLsMC0EnK86N129IqLZIuZzl6MGZ6w5xCGpE2P/j?=
 =?us-ascii?Q?+SH/6iWvfYGAEwfZOaUBmAB4OpWzkAVk1VpIZ3uzD78hqDO5FBQoU6QjeeoD?=
 =?us-ascii?Q?P+Is+lwR1ukfeG8lNtwQSiwje29WgQVtEDW8F8XHEUlaJ4WA84O3UvFZrC3k?=
 =?us-ascii?Q?+eDzjIbukJqQR/4ToOnc6QmLMrh4CpRbFQbcBAXPuDDPbi3eOUHTiZLACudt?=
 =?us-ascii?Q?b0QC2+wdjagx5MSQ7FI/TBMt5KodQ7y1AsWcAX5DekwkXZT0G/XMQFrIbzdb?=
 =?us-ascii?Q?CSB5b3kkby7RKVJKZGKIfrrUMy+P4lCyOkGvJI5gTHVa/Ys+VY8L3IByHmXH?=
 =?us-ascii?Q?rQKF02f/XkzsBcZf43q6s/F628T6s9vThojTPVasOdTohy9i9+FlmmpoJYAU?=
 =?us-ascii?Q?2qFlaTlKeEK4rPW3HvFHrTDPQY3OVmLhhmfRqC+Ql1kvULHGljR1Uyo4ajgc?=
 =?us-ascii?Q?/iQVgCJwm4C+owT1JhHKRDKkn6jPumCW9RFtxJMe4QnVLZ4OroqRSVzPjQj2?=
 =?us-ascii?Q?qPwyfmc5pWF3TvN4KeNxMd1J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ed9dbe-701e-463f-f977-08d9007c0497
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:50.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgUYwGqA6ILb484Sg70BpD4OS59EEdI8phqTVq+DfWd8th0Bf4VTUu+4iL/xZceznXFqF0YZ/SYxG5H2gHfStCZf4kXSOzNOji8hgKobYlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: f7x14UWP81zPuwRi__H4saospDLlSBlW
X-Proofpoint-ORIG-GUID: f7x14UWP81zPuwRi__H4saospDLlSBlW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to detect if a cmd has completed but not yet freed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/libiscsi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..8c6d358a8abc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -145,6 +145,13 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
 	return (void*)task->hdr + task->hdr_len;
 }
 
+static inline bool iscsi_task_is_completed(struct iscsi_task *task)
+{
+	return task->state == ISCSI_TASK_COMPLETED ||
+	       task->state == ISCSI_TASK_ABRT_TMF ||
+	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,
-- 
2.25.1

