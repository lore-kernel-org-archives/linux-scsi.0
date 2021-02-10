Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED88EC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8EC464E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhBJE4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43246 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhBJE4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4ruIF003701;
        Wed, 10 Feb 2021 04:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=sd+iILC3h0zyWu+f6Vh6n+FbDOtxkPI1Zg3j0pT4htTisnSQDbvPOr100RYGCC7upbHZ
 0iB3HXmoMiaefBEJjFWxRw/WaX18d6v4qGnrDAur/umA5K7+YmkVlDs9tRZJ0aCBcuyH
 3+G3KT6GVnjtL+PALjU3cTTebQC4Pc72GC4HBH4cmg94ywdJuDBAZwOWnTwRehsDGSRK
 sqy2PyxRUaxEx5fc2eaoDAApMMaEMLAJrxoNMX7Sc9QlOUi02qa6+NoQoQrD4YFWLPPB
 1/iixhYwY8U1IT7mM5VC9jzE9GlxoQWEtqfX0ElwFJm++vCPI0Z989/17UZZTGD+rYFJ dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmaj0tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB3048727;
        Wed, 10 Feb 2021 04:55:32 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuKqOwPvuqzCriwRdlKNnmVnlTE9WTTkfMV3IEiT7VTFqkQvYOsxZXh7VZNgJw6zsPeQVeG5Ycfxjd9XcTvaNg/w4Lbr66Tj1WtodFVeoBiw5TOwn2JyZvP5QbRotarSMN4fArTolNAExW0uJgt00ofHKTZZFb/RJ6ql65qDwmQr/rIG22F9m2TBVVNqBT1JoAQMdg7WuNxy1seOnAYA3Q1Zgrh3LdU2y8RFi876+5TZal+6O4uGJHzhoGCJdap1jEEPs9AGlJ7+skXT8FHAeZBqkkMKrJfueFvmG5y1ciXBvgwep4TJUiRHKZFhy08d7AohIKyenrNyPTxfBwav9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=d0cBiJvTqNwoen1S3AiuhYTGTLjnxF7L1c7ksMS3q7KI13uDdF1srLsmMwBQ6XtQE8FUZyC8zXqcivGT3hfwmMCQxdAaOsa90LliDJDOq0tI7tM/UkpskuLR0ny4/PKd9S103c/8oB7q6O2vSL0CumU9LMNPkyFYiT80InRlQB6CiQOQi+w4b5MhOoDMb6sbMaE8jSOPUPnGRh2z2IKqa9K9P+BOPX7EivngLhTrhfS1dX09MxUuAwGwTL8BiMk4evFh5fDX0+JJ2WZzIeWCNSAueKewjvX/g5kURJbQCja00s0hOxFuy7OoqcUqhC30zAvQn3q8omNkcKzQHJAmpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=RShrE5J6qyi4769K6cLt+aDfBww1y6nn6JW7YrrFtY9XyooaF8wMmUxj5RsS7wDSfhXdpps8eAg89o87qD8FHEbT87cco2BAZSmAFhTrV3qmf4mxge9IqYqfTe7gVmL8D2UVxvWVil28mCuOWAt6KNLozgofqUGwqpPdtSr4xT4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/13] target: move t_task_cdb initialization
Date:   Tue,  9 Feb 2021 22:55:04 -0600
Message-Id: <20210210045516.11180-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 895a9596-8a3a-4677-e511-08d8cd8014f7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33664F7682FDF22376409470F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irV8xJlWOUyMrlIFwZR1JnvkwJWszVC0HKn71/9Au57RlEBTF7KQSBpLI1mjlL0sNf6raFh3LsfCMi7/fdvGVK3WIBGwvZgV9CmtErkX/zZg/Lx7r7pennydB+/MbBGGwXNqT2d2al+IPfO9f/R4JHPlubkmaMgidcwfmS+wJPAez/rL4+Myhc+1J/Ukbv9fUr9vLRYE3PuJTdeVxmZ4qj5ruW9joTwveP2N9YA+itNyBv4rmpko4gfRWra5/oRHXwaJf1WUU76PjFsKKlwEk2lwURrr6beLu7CZ5oppxiBX/Sfz9FFRUedbddsjEKM73kyPigsCkXGZNQHvb/BUKja0Lxcjx+d+10tyAt3MyPzykGjbIjiTfyOODIqqgNU8QYLEodJ9uWiBMc/Wv1LhuhsjjgcZ0li932pvllxi0dYnQr+6DZQbuU+07tg74mMwKvEgYZVI8Tr1PuqstR6C8YiRiYJc5NwD68XH4IY35g8ThzZJ8bCSFcAqqIt6SVLL78A+GW1qOHDRPVBNAXxJkCKxJitW5yk/QSEh/qHrtxpgGLK0wN6sxcoPk3yPqRGu3SikGCOIikZ+RUaRPVsiPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1MAheIYwQDJpciqHbe13Uw0pHKONlVO+sZADImoaNmW8g9S9V+ehKNC8aN4h?=
 =?us-ascii?Q?h6AAVWKstCNDSZvuS5zSlMSc6LFOq+XyZ7aIX/fZ353o/HwA3WM5SejXJWTc?=
 =?us-ascii?Q?pPmSOzBVd7YBF6gXFKbfcYSpMrFts0nK+d/gPKyyfoJJG/Vag4UlPRmhjCoc?=
 =?us-ascii?Q?kjlDVad9l3iBOQI3BsEnwkm3Vtnz5696yT9Tv9RtoyrRtksfHIWJNm7TAC9s?=
 =?us-ascii?Q?1y0KnQTOKCSbJVnkaGtt5MLCw1IqA+nkXSyCx4kzQ/z30dxS7MPa02muu05g?=
 =?us-ascii?Q?txfqatKH8HElciXUXkeyNSrMJPG+ftn8wR83fKErWNQSWm1NeMSqebZqHJV3?=
 =?us-ascii?Q?EBVk+G1NKCcKAKdpF+85mG8P1pBWZAEtk98ghfOwYsC5GLoH7F6AgHoePFum?=
 =?us-ascii?Q?fysYvtsL+aap5BMtBhqPplWarzYWs06MuLwLW+ZqHx2nc+VajRYa+alIuE4i?=
 =?us-ascii?Q?2y0Xac+GkYgRBLNSuDzu2XWnmeI5IRMq1LlDUeqX9WckT58BBXPAKtEfDTUF?=
 =?us-ascii?Q?ZaHu+yNluhSQ0GqhRJxsjxEigd44H8yEoK3Wt8OMIFIomt5r9Y6SwOkcOC31?=
 =?us-ascii?Q?2tL/FE06+a2ptWKqSCbw6q8TWM7Lm3r5aT3Q1Pp0eiyKOhu+oxR++fOZn+8H?=
 =?us-ascii?Q?MN8HfZryn6/xEOI2WvPdJRZ1ZtT2ElE7HP/y0frnKo/LX8NJCr9T+QwGmVtt?=
 =?us-ascii?Q?BTiSDON5U73zpF74BCQxRcl89JO1VHujPwDs01nio2BOZZv6TeBPU+mACDtQ?=
 =?us-ascii?Q?YXCvdBFmCjMQbvsn1VsQb/oDvYOTxRUOjbePemPyD1w3Rfv1wLrtuxTC/NfP?=
 =?us-ascii?Q?do4Ge823VM9Q11wrOn8EepJw/ffkGn7LRhRPc3zapPvee+9Qg7t6kUZWb3ri?=
 =?us-ascii?Q?qmcIN/qeoPJoU6raLs3iZLqsPh7wtq8y4nAeRY/6a/KsNugDp/DoOMzWhJA0?=
 =?us-ascii?Q?/4HM/YmejRRxgRw3Dgi7PJI1jCNG03OhxWymrHVIuxH63fZ64vVqHx7VuYvJ?=
 =?us-ascii?Q?9eDgpe4zsUHEdcz1NqHRvhqD4oNcwLUMF6NdiSN8dXi50DJS3DKrFMPQAooE?=
 =?us-ascii?Q?kh3njMZvGV3Ix4Y+03zCcirRjweWwppBJQ8rylrh87arOf0f2MtmuBMXbH9H?=
 =?us-ascii?Q?C9I7YIzOxgB7xnc8yP/kuXWIBbe/tNtcWjxJggavi6fx5lcMr3SlIX9ao1RJ?=
 =?us-ascii?Q?WrWWmX2PX4z0ht9B/WtJBWd6uCdveZWwz3EWuc+88oVnrX8+8T077iFd3kOQ?=
 =?us-ascii?Q?4F3Vhv0hFXa6dCmIcfLxHFJybnuBS7BVB0iipFxy/BiWvGMenBg8Hlajyjq4?=
 =?us-ascii?Q?QEta1vR2nvvyHrlNA64wXJGF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895a9596-8a3a-4677-e511-08d8cd8014f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:26.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADvEBevN2liMbKMftce4rTEYqdOrJvS1fBFM5S+aQ+WMwU66m6MvgC9FJK+xKB4EOmMe9n0mFPnjIeDOMQq6/aiey/v1hZuIw9jG0BJwtbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

