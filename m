Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9EAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BFE64E05
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhBKMbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:31:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42028 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhBKM2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQLJg051499;
        Thu, 11 Feb 2021 12:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Y1wyS6xzoLzfxeFA2GCG/qtoPnZNLF0qz5NjTir0KI4=;
 b=nLet5o2iKr0KHGhbL7L0RK0FtrzR8HlyuSakZ/jjmHLp01XZhVocSkcTXYEchKu3fArM
 VPLwr4kRRU18bAUlvjpQ5d9VC/h6LdABdXHA1hjr+CH/g7Zbhm9LyI0M+ewsWeHOjqaP
 F64hjYpJU2j/XVJddBvh5zXVykYGduv05DzLZmw3hoCN9RyGks0OZFyC2XV2xHXXAPsg
 s8+VcFMSft7rMkIPqVMI2/2HthXhrKizGnkFtQSICsHf7tRqq72tbRpx/ZkRleZmBuvv
 vygdLa0/5gcuQu0m4qBrH4+JF5UaDdoCq4QgZ3q1o210/U1qYo3PURlY9oyv6rs1KVMX 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4upws4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCOn9t068569;
        Thu, 11 Feb 2021 12:27:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3020.oracle.com with ESMTP id 36j4vu69v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9AvE1R8N2xrNYlMtwFKVwcEZLyqoK60SebVyardMHBRAlq0vcdsKoTciZiEIsTywuxXJWqAsYBRGd6C9vJOL/KjD7aTenmLSisFZzuj9wq0gDvR4X7AjPlD6WuCYENWEU3EClRehLE/mxA8RN+d5oaNszFhEOSTAIvD3ah8HF7iG7snwtovf/AEwL96OFBCk+WXxAOEaGvwAMhxgG2L1Z8M3CO2ag+xnccdg7vh2Gvzc6UyErNLnqpKB55wDGiAW+tNo7R/oYMDE2AR5ROPF/pKZbGe/J7rOllMHH/PnEQlo+77qERAA7+1MzakA07MP2nxlONBV4s5018bvS2pDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1wyS6xzoLzfxeFA2GCG/qtoPnZNLF0qz5NjTir0KI4=;
 b=TFhrpEzuI5RuQWyf35xnybiGTA24Id/BYQj3p8Ag3gl+ItAu0VpxA9t1G2psycV9w5RP2gqlqOxMnrLvfHQEsbeSDoRpbRVkoUWUSNuIztBMtUaqYQUBG8bLSOC4B+M8Ab5fTJ6mkZuj4+s8KCY0hHeVkP8ZoTZEFDaD8pfsfQa7N7PCfR7QGzs/9OJLcZeNIMN4XZCJ68BuF+tLSPpGavtrjl9WVxDhIe6BJOjda34tjIsHMFUcsy8/IPOFwvD8MSrV0dJUkFg6s6pSmciclaBZA1CwoTElEWVNNwGmCjuaW0NgvnpM69vrRLkSjxKzKwRv4agGS5z8Y+PnlRhh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1wyS6xzoLzfxeFA2GCG/qtoPnZNLF0qz5NjTir0KI4=;
 b=qs6EEMUgALeYul+F376d31YMSvGsQIi5BEbNE3fTTyabfg/noTA0I79STntrH+nxaplF3pSJK7aY3F+md6hSYkQMr2imnvTpWBemLjxJtsYbERe5fScROyfPfJ0hzmZDRC+NwPhW/UidUIcjpsx712xxBT4roj2XkZWYRSH2WwA=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/14] target: drop kref_get_unless_zero in target_get_sess_cmd
Date:   Thu, 11 Feb 2021 06:27:16 -0600
Message-Id: <20210211122728.31721-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9418f8a-caa7-40de-13c1-08d8ce886c54
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339782DC1B630AE6AEBA84AF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KXV65UamKIrXSsWlZ3PCv7nWmuoR/ZJveUOrtkDKkiLG8XxPKX4rlK2MMVAWrwg9LFdonw1MbKxzbdbepK0GT8mE3T8fwK/yR1RXtrRdvOZMH7Ux6mt3OcrwrGtNfGwUL1/VC51QX0ZozV2R8L5gQ3Wt1VuZeOsomV71Tcqx7fhGYX84MoVTIZFJ540OypMY28XqC6nJSr93sV0PuT8Ypn/l3RUUnNQBHKg96RhJrC/MXrekYZNtzlrWrNcKdfeyDqt4RdOyf/lrlzp6qW3vBs411ux6h1b4oeyKeLKNrT0YuSIf0n1sEsWU9YoMNyBgDZkUGBxecLUZHiwfa2OuH9w6fLkWZROtqvAzi+1a/8y7xIjvxLR0CFhJ3swvOw8L3W7ojwOv24L3Ygc7rRnnE3vfogdNAd1zbvjomGAtLFjI+MES4Y3Yi/pIheiz+PPdxIJG8/PIsInwSYpz17qhZm/QSbRWoX8eJvHhiIJoQaZH5nrSKiy4e2XKXm9te5ALrUxb5JQcS11j4/7w2Lc8I/k+7PhPeo5tKzIn/rvwcL4o0UhnH8mb7r0aUDso9WrESY2qyJ827KMrdbT2PbuL1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aTE0Amq9s+WpwpHAKidDlAJIswDEol4iRiQGKlckryuLkhF7oYiwTJ9v01vE?=
 =?us-ascii?Q?PFWihf2/MJ1q+O7oB7xxLkviLYZT3ZA5rTdC3BMn43MEuJ/EIuVscyv54LaC?=
 =?us-ascii?Q?RGKO0PyGM9d4bnKb4SnoiJ9RY6owamutaUu1Iui9gYZQXTpOpHIGO6WMMiO5?=
 =?us-ascii?Q?4b5gXfqG3yjdowvp+Bl4VoIuU7HV1KQHaHjzFzXnRyWHNo29/23BUjbhC3w4?=
 =?us-ascii?Q?H9HtqdYd9PY+dBn7b+RpGagrZr2ktTMCE11+RZVvwTFgLcfIrzd783fSMY62?=
 =?us-ascii?Q?go1lL9UJ9i4BaHJyhG+cHg9uHcU563Vjl721XJgKzQ2Op/4s/+JFN6pQ3rIv?=
 =?us-ascii?Q?l+esNW7cVgOrfovVVvivz2XcOjsGC4kcHGYAZmi2RKAM587Ps8XQZ4gRzyGN?=
 =?us-ascii?Q?6fp6m016Uicme5VNgG+nsoT5JMpdhL106sO03Ufg2LAEIzr5JEO/kxRPSU6k?=
 =?us-ascii?Q?UsC2a9m+KMK4R1xe2ygXDNS+VdwszncbgJ19I6oky8PGqJlQy6EctARP2bYp?=
 =?us-ascii?Q?By3/hzhsZkXkJ3KnzIR8xzfvZZWBDwOX4AmO9MaoLUWS79K6giqec+0L8pRP?=
 =?us-ascii?Q?vb4/ICSt+LgV3e0hKKMGHQq2Fk9Zu8H8+5+peNfYflfGeMKcsnJfGjDmYS9L?=
 =?us-ascii?Q?drLcLh3KjZ1VVW6iSrnFvpOVi5nR72Jd3V2qiWA3MWrjXd8rPdAK3CgPCXDq?=
 =?us-ascii?Q?CNBALuIBHTha9mBu33CrlHc7f6/z5vJswByc3hzGiT0/LegQ9fBzJs2lsE31?=
 =?us-ascii?Q?6GVJHWFRUVVG+vOxJNkMDhQbtfE/w0hvoIJzh7xUZTyE0rctVCQLmaSIYDCN?=
 =?us-ascii?Q?OTxdVxAOIlKXYtyLefpRgDQxMTNdLprDKqUVXY3acr+9S8qCncDEAWIVEkKQ?=
 =?us-ascii?Q?WXCCU3uEL2oIatzT/VU3X7kA+y9F0nwJ26KaOhiB5o05gPfrKuRD4sHJxpCw?=
 =?us-ascii?Q?qKjky6b4LMksMUbdQx25HUV/Tcnl9lzXk8CYj/pzIhUOPUlLJaWxJF6iLvy0?=
 =?us-ascii?Q?sd+pBr/EGz19BDyQEaa1gH0KaQpEAw6cnNI3CXYUgWJY9R+XLCbLLXyfS5dH?=
 =?us-ascii?Q?iu2JiCwKwolDH1jiX7hPGOadGWpaoKsCZCvkBwdYali3V1TpkC0L+64uGBTb?=
 =?us-ascii?Q?No1Q5i3aqI7zS9En9wa1QXurKBh/tRY7gsFVUFZ5WB/l3jGkGcVJ/DRjqcAk?=
 =?us-ascii?Q?/Brln/nwh+apyYYXI218XfBZty3kaDzFUPb++znmRX14FlLxy7wqpwW+xtUj?=
 =?us-ascii?Q?wYEaOCLP4bUTCwQP1B428CaX2+Os55vaHKrViIDKW2XgulUHHjF0LY6/JwWQ?=
 =?us-ascii?Q?rjaQiBqU4o+8yXXx2MskJ95V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9418f8a-caa7-40de-13c1-08d8ce886c54
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:40.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHSsLnjUFUECSZPX8pLPF7rR3N/hcdIiE5UaJ+hTfomfLXDJGFdWRHunw+75rJotsHdEKqca4ZqgrDEifeGSkVz/RBigLENjA6Pu5pY7jLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kref_get_unless_zero use in target_get_sess_cmd was added
in:

commit 1b4c59b7a1d0 ("target: fix potential race window in
target_sess_cmd_list_waiting()")'

but it does not seem to do anything.

I think the original patch might have thought we could have added the
cmd to the sess_wait_list and then target_wait_for_sess_cmds could
do a put before target_get_sess_cmd did it's get. That wouldn't
happen because we do the get first then grab the sess lock and put
it on the list.

It's also not needed now, because the sess_cmd_list does not exist
anymore and we instead wait on the session cmd_count.

The other problem with the patch is that target_submit_cmd_map_sgls/
target_submit_cmd callers do not handle the error case properly if
it were to ever happen. The drivers assume they have a refcount
on the cmd and in many cases do a target_put_sess_cmd on it either
directly or via transport_generic_free_cmd.

So this patch just changes the kref_get_unless_zero to kref_get.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5c4adde96d5e..b5427e26187b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2775,9 +2775,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * invocations before se_cmd descriptor release.
 	 */
 	if (ack_kref) {
-		if (!kref_get_unless_zero(&se_cmd->cmd_kref))
-			return -EINVAL;
-
+		kref_get(&se_cmd->cmd_kref);
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-- 
2.25.1

