Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2C1C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AAA610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhDJSlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhDJSlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIWu8A112884;
        Sat, 10 Apr 2021 18:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=V3+LBd0qezjTbCAlUzX4aWqJlc/acx3TMfcM+Mg5w3aLLFwplUlHpIoi5RNTwBGYg2J6
 AQVBafaisNis4Yk8J/AD/uZ0pKfLFgQfxPQeUj7n6UVQa5zYZS8EZfyccc6L98QVk7z6
 ZToRocqoh9bv2BeR+noNDgtpztRadIhboVen48svI+seFYPjsNXV8QOX12K+PKbDtzZC
 LeIFjuLE0UQfTxCG0KNNmcVxRASkRaKFHm6s927bmQDIElz5Vi1jvVdI+VbR7erFAGTv
 I3IYZc0YjdWIFbU7covFxa1NlykKzsEYmZcJq0uStKSs0W4LB1haJ1/IfrAjQor07Nq1 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ym8s2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIUY3q190235;
        Sat, 10 Apr 2021 18:40:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 37u3g0feb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fk/MI4kvpNDwGHXTqvUIHXvyNlEGXBqa1IlZeHYWTvnaYi6R73KVbkIMDQwrvQfIYlz+2IWgrvPA8S/SI2QH765rw6aFg+XhlhcpIYAjSTNLOISfzTRH+HEZqffxm4a/NtujepDFKzVJfHBiW6H3Hjw+jrVdEfdxsvok6Hu+5sHx9j8XgtAwpU+NlzlFe475wJPvFYD1YBRXv9A+RalzxiCtx/9KWgqQh3BS+Ox/wD3+m+ejVZ7Kt70YNaURwJIy0l9U4WGSQ5buUn0HFSjzBThtjr6qe1EEWipUNox77JFkvyIx4z0nCwkxRXfk13G6Dfg3hYvtFfPV3MRGk0YM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=Z/HRq4PXuvkI4K8GcPOkQelYN1MeGlBA3JKzOs5E6lHtEBDw86kODPx3m5Z9jzRm050dbatlnqFPp8jBoIjTShwWdWpwdmITNcSLBc4kUk5qVOyzHJF2oDh5au5YeRcQkVwygachpiYpMJP60lN0j4qq/oXN0z08Zf5CQONuXgana1kPcXVcdl22kAxNDemmU1/9ehGOjQPD92EpGvbMCGJC0cVsXcApbKND5dC1tJkjcx7AH+cu4BM76CS+HQWr638TTsxhLx/6q1Ce+l9NAIlDbI5YdMsjy2MFNC53bwyWcbQUWfdrPYSZ3zKrR7rIWl6nHI6dGgWyjq8XXK7cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=oiKdjsHdkJH80LpEDFHO8sXbOiJjthkLYI6u6/dK7yCDfsI/JlkzYddg9XqHMT8KB342RzIfa2YQDtJwt8f/3EVxPG2/g5W35rbHhlxZz0KaU/svWWguRBXVOIySmmjSHC+VOdBVuTRMvE+KnRyI6b6kPEY5OKJpzIE+3uLT/KI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/13] scsi: iscsi: add task completion helper
Date:   Sat, 10 Apr 2021 13:40:06 -0500
Message-Id: <20210410184016.21603-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11e2214b-4945-4ddb-2550-08d8fc501caf
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43242B120735A0249F130220F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiYkyJeOAsyrNyAGE13QMpkhnwkXhWmRx5U4xo+Yx8cj5k2XZ96UvWAi54JHwMbfAozmsRBjG4olICjCRoh5Sbulb6IXoikclQ5+AMRd2xplGCI+1YYi2Fc2WN4KbjIDMw8P0VBkat7d+pI91tP0Q8lgbkj14ZAJp9tecjL3Au5R30ONSCZv9AwsIAZH4SgUoh/YXlzvsGzA2e6cB/518Z3r3Pdvk14q1J8CG/70I4ujBzfimjD/mcNxf0ThxESxJta+DLyV4moe+TXWOqurYqqshbCVzQt6mm7I/FTJoaApopsuBytJSolftArEU5WOftRATwp0N8RBde3LNj7KUfUZfMMLBx5PvB15+9ltdo8I82UbYECRAVSLwVpzQ2Ns5Rx+Nlw/Nnjap+sCgO20UHI7bqEpmZnxvbzkfG/NJWDOW1/ir8t5Wv57jwQj1RZR2RxIQNh7Aujqx5V2YcSpqlJwQg/BRDbwo3FOgtpj2By42c2Z9NtvjUp3ccPGUI+8JV4O3Qy6mRZlcAaLpdtWGTS9XDJnKrYRhgtGC9ulmSMP+gdWi+iUgniR4WLCz3A/gZ65+svq+gMjun/5NoCMdRGiG/9YmP8duSLfKVwj1CFQ2N/ksCJnVUeKwA8ZSoRkFVM2gIaQ82E3C3jEz+4LAZbH+wbpcdzZNYdNZhQ3RyfsgEWWn7wkX58kPXBBS92v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(4744005)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vegd57w+Srvh9kMK3EF62WOZ79IT5xbl36JdAs7HoyYvLLh6LIfB0ck0xjuM?=
 =?us-ascii?Q?ag4npnS+8+mnnnZG8i/gIc6jboMRb6e/ezZ6VxGAS9kPHcfWDzx+8cTm55B/?=
 =?us-ascii?Q?uEsenbQL7J6xDbCFqiYUPNdvxVH2xULgI3hlzkhYM0D3Pp+LtxGfpjBXw7tK?=
 =?us-ascii?Q?cjx5ipW51lpmFxOcse6p1sygz34r7j5PZAs0D2OtDA+DozcTgQkeig5Gix5+?=
 =?us-ascii?Q?PnLMs/Y2xqjJVgpNoVScAP8G3XX/NG0eIxhiKRlX63Hh22dPaH+pzf+Khect?=
 =?us-ascii?Q?TAVbDSIvenU2vZajGUx10mQJWKJSaP2tZ2oy1FHXaca3+J5LMeS+dKoLEZWB?=
 =?us-ascii?Q?HJLKLGQn1BR7U2eaCRwGiUEyoDjdTHjc5S6OLhUeaSy9snkCiJ6YFwPc/pwE?=
 =?us-ascii?Q?BFJddlUf4uN0hnrX2uCXa42AXO8kzkEWCleT6rvoJs0IJ2bj27pmz+VxPe+g?=
 =?us-ascii?Q?duD57JaFKO4E65frsH1Pt4O1l/MOeArwE5auofR2EhB64sh56dKTyavESBVz?=
 =?us-ascii?Q?M9DEANuVjS3OLBNK8SfnZ+zrmMHyX8ui5TnlNwEjh5i4TbvaMz5FjrgKvEoy?=
 =?us-ascii?Q?r6XiDOQz+8fDN+AXSKSJTJyM1IMfyiaJNvwgxaD1ylAU2aVYO/ASLEKf6dWE?=
 =?us-ascii?Q?i4w81SYiSfehfcP7scDylQZm2d/wC1Uyjw3VHS08ySpb8zYQZNEV1p7Pjgsk?=
 =?us-ascii?Q?sGa9dP7y21wxYG5Y1ahcFoiEBoxd5SdDaJMQoDwHb22rgAepciIlCfLmkJXb?=
 =?us-ascii?Q?tgF2rZRoUJReL8fhtVEj3UDMylCFTr0smyYvqMZWbX2qHQQpA2ExFSdkIzTO?=
 =?us-ascii?Q?Wk+Jhv+tanhqg1+I3VB0+4cQ/zOq7031B+IBxQk0MO/I2LAi1O864pxqW48I?=
 =?us-ascii?Q?TKU5XMcqdEwbfr9sxgIkjD7wlYoE0eBaY7kwkn0jfsB4H1/7/8LeDmtcLZQ9?=
 =?us-ascii?Q?h2jLrnSztBmrkNcDEFooIMUwqCzSEZihxDy6zQMqxCBRFofE4+ibscTJziJe?=
 =?us-ascii?Q?e0PwRqSB0ojBDyk3JnoRSHAKLX/oSsfZvvP7RhV4nD1L/tOHrkiLnuSxykiL?=
 =?us-ascii?Q?l9vgt5WbhHFFvwNIeQkAid4qCXwSX+WxBRqXiDuOCEpXcZNV475TuAsmGObT?=
 =?us-ascii?Q?WRmpGSr5zMsVVcz1oKNp6pyhrLiqGmuPl99b3Fjmyxm3YeUiXnxnx1pxwoSJ?=
 =?us-ascii?Q?MQzLnE0buyxEpDO3F2zlfP5IC8aBmpTlOsaZLnAruwP3eFpP0avxJfR1Dtog?=
 =?us-ascii?Q?7A2956o6Nq833x21cGnupt9J9qcEUBYROPHVIsI+s4qP7to6Afe2tk4sPxG/?=
 =?us-ascii?Q?ivkQVYiJnxaGMUR1W42Res+X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e2214b-4945-4ddb-2550-08d8fc501caf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:29.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nct1l44uIu9BHHSYCPMEgFAWfxkjonmGBz2vc9jnl4d+1gtvw+9j0wsSh1G1yHGFmjqFJPSxKL0WY/lucchXqK7AF4NwGJgPDSkmGU+DIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
X-Proofpoint-GUID: kmOO8nNxTYUkvx1Sdkzbyzcb8s8pqJ2v
X-Proofpoint-ORIG-GUID: kmOO8nNxTYUkvx1Sdkzbyzcb8s8pqJ2v
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to detect if a cmd has completed but not yet
freed.

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

