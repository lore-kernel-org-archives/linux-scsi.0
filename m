Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097B4C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE0964DDF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBLHc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42472 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhBLHaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P3HK016717;
        Fri, 12 Feb 2021 07:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=Gptjn7KJ9N7PszkHE1dggjs54H23vhlxJp7xjxpm3pWRUgkLQ0wrEWfhicSDCJrGVXBC
 /OvE89gHI6dAeqBespuj89QfLA/McAK8mHRSVtE9UQ/bFAooeQJe7UARG7LgyWyrU/Q1
 4GclLagKTz0RlIfW4A5wu+q/8qkDJD5rVlMIQQjewkR5dGk7Pcn1Cc5wCaAXorrf2uc/
 7XWGfIE4Rr8FNXlOQGztVOfg7JCAczaUWLgdiYLfLXk54xvIIBHqeTCQ/6SGYQ7xU7Uj
 XX23IibEiJU0+DyJZB/bC5SyQQtzu9jeRFuXXT/+d8gJTAET0V6J+DSaMCcK55RTS9NP ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36mv9dvcuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdW022757;
        Fri, 12 Feb 2021 07:27:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 36j5155aeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOfk5BlkiTP3Saj4QdBlUujDTPHI7H+Moj0b2p8G9ggSsUrcW/LRfOCos+v0kNQXUSkSp8+VA7jp5IZO55JW/Fj6LeggGCaOG7NtHdNcyEvV6/929MfdsWg/9KwFLbam+x8NcsO/PDkIY18SlsKDB9+W9Puf1q2MK9nlhZJ8PCBURBIl88sr8Kghdxlo6bse9Pbt/FJ3e0DVLbGJBbbIeLrPlQf2LfYiwxftJ0slpvq/t1HjaviZUMF5aUBnRundOzR9JvmY36EVCw7z+54PrvRizpoG+IB28Ujkq4t8K6dM8fMdU2iACv/3IgKSRiTobY6O5mIKf/S0P4AXFbo1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=g8SY1d659TM3ojVSiIkxAyR/9GIDXurW96NGbcInm7mDRJdWDHIV+I9mGDR/keL2xjhCcTkXUYT/B63gmH4jlcuHUm1Iv3oBKMMmcHYJPWDH0bFAGnW4cYiFUFA6Q7vBQ7XePgZW5SNAu2Is4MulwMnyPeA5IiMrJbDqN0rkNVRPjAhoWvKkSfsTMS52aw4mRudiUhn64jl1qQNG6JBI8wN20xK6e9fStMWnG0WEVH1tsrSZokPV0ZUmsFGv/fI55kLBbUk4cXe3mMPV36WoLMYPIV8ASKFMBkWi6+Lj+0uhlB302SsE6OE5B5u8Y7IJvyaTf1tZAZq4eJw43x33iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=rpX8KYuAOmO/Z/sN9piVK9JsfXr9tZl90DhqCJbJAoG8VwyLu/MPahX/W6R/vTGrlcvLN5qotK7fDaVmiKVdoJRAVYd4HT0HAIkcKQ4Y/xY+wO55/K1q58EJ6W/up+366tXmWn1PmsHF59/iHwvlqWghAr0YQKnX0+OigQcD9AI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN6PR10MB1940.namprd10.prod.outlook.com (2603:10b6:404:ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 12 Feb
 2021 07:27:17 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 24/25] target: flush submission work during TMR processing
Date:   Fri, 12 Feb 2021 01:26:41 -0600
Message-Id: <20210212072642.17520-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15345588-e9d7-40dc-da00-08d8cf279ffd
X-MS-TrafficTypeDiagnostic: BN6PR10MB1940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR10MB19400AD1BB2D5676D1FA1610F18B9@BN6PR10MB1940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNly+06Y3i0LDK+ICFiz/GmqqGfCOvyIihkcJ3dCDjBgrKL/z8I+RwhWsAB00j8ht8f9HN3Yz1Ipt53Fa7Mei9WGN1A306kvZC4gipKuRfvrtAS3duOUmc9LWBsH6dnoEwTWYMSwn1/MNFGhWe9wpfw6gMj+wXTYBrHN/hAsFBlxiyqMVayH7Urk7YHXvMDZCymqeAjtSTo/blgWpoh6h5yTjplIkdMZ7G8si02nJyi/cKt0LYd4B2CQjTYlJE12WO7kl3o2EQePVZODNwrvhwe/MBVjpSlFg8ES6Y2mDblDWkCu18WHwKoXZr6VoMBJzL4OqvGlMQu9H/fB31WPkMwFMHtVjxTBLXfta/JOYh0Gzo1QQJQsgEc1XPaf7YFXm17IeeHLr4E1FNR6pXmsza0b/Zuc1iMIoWNzW98G2ii5MPt0DHff3QC+wHV/roTy2GUwGHk6duiqC23FxlTmWhV3nwBN893x0ouIsiZqKKQuyh8W52oeCtHAEYvdbsh21vm+7gca+BSH7t6FNHQ946jW/+27bjYq3e8ayYiYay9n+z0RNUed7U7SppOqVSsTLhfZtMlHCf4Ja+OVB1uAUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(66476007)(66556008)(69590400011)(6506007)(4326008)(1076003)(2906002)(5660300002)(86362001)(66946007)(2616005)(26005)(8936002)(6666004)(478600001)(83380400001)(52116002)(186003)(16526019)(36756003)(956004)(6512007)(8676002)(6486002)(316002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ianREo9lIATaImCcltiNG+yS0afkf/tWjl55NC7pba4fg7gWazIKghSSvFvJ?=
 =?us-ascii?Q?L0nSAgp0xo9t+Qb8tUT4EgH2itPDJtrT4Fyubzl8TZajvmVHAsDPNEH3scox?=
 =?us-ascii?Q?MB/dhELaIUmmv2jQNS7dJVUpe4FWRljIe0pRClGkigu2CLjvVagH5FHuj390?=
 =?us-ascii?Q?FF6N8QR88VYnhX7qTW4jt1uwJr96FspGEMM6TJx4gzbzaBFIv0U3mNAhzghO?=
 =?us-ascii?Q?OcvxzOGmoANGT893ltJEIgktLMMwwnUWVDH1RJMowzeC2432oHCd0WJuYaD8?=
 =?us-ascii?Q?VEphK74WoaIU+ZzeF060CwKuLdt9lGYJ9PkoDt8kDj2cv3BR9BSQUa1FnSe1?=
 =?us-ascii?Q?23wzG9EgwmRYAc433gZ4r4dN/XRplc583+Jl1wM/27X5hgk8VOHkt0f+jf2H?=
 =?us-ascii?Q?OxyInv+XPpDXf8ADAjusknyFbowu+6mLPDbBNmsvetNX0khZ8KTcUeSqZs7I?=
 =?us-ascii?Q?6Np0RZ0dy4Ur4Wv/cy0ayQW6/hUsQJEcXvP5jB2l9DDgpdDJs9H9k6UADnxi?=
 =?us-ascii?Q?eyXA+7Y3EqqREuCBKS1RL1ihtATRuSlHm6kUxArAqeDf0DIJ6Ad9pb6RBnGy?=
 =?us-ascii?Q?icSJuwc3oVqePvNB2i0oNRhdoTaTi6AYSpIxeYJReQ8AX1P7ILlWTN39cLLs?=
 =?us-ascii?Q?c65puRfGtOVEOVuz7jXo4xB0RCi9OYvZWeMKHng+6V/3jblU/ErMTCQ7hP4v?=
 =?us-ascii?Q?KSuN1zvXALy2tJt5aH9ZnxhXec1TZGw670zknDf0m7fANn5MceWeizYQy8nc?=
 =?us-ascii?Q?Uo9RM18DNgCVANMCp+awzUIvQVyvYa7okTDaWbQZxFo3ZK2jxg74nFR0OWvR?=
 =?us-ascii?Q?tGRI34t1rdqeqpPjrjLNy7ey1XrXYn1jaPWL9eHvggFwL1XgZXOIMPq13Ivl?=
 =?us-ascii?Q?nbj260vG5XPQyD7Z0l3BTPirKxNVMKIhZkH7cgISmq1vGMv6tJ7CM/cimes1?=
 =?us-ascii?Q?pW8jHykZMmkc0LXxLrVgVvnp/tQnU1Z79FRh4P/+maolS4nXpXoluaAW3ruz?=
 =?us-ascii?Q?vn/TjHf8VN+gdA4E+fZxPCkF8xMdVT/1R02CsVc+HqgKUzT32u94ETaenr0D?=
 =?us-ascii?Q?KU5OF//JswDgh/QwVDVdVa83c+j7LRZkU+Dd8hDkcM78DWptaYIFcYbmbY9r?=
 =?us-ascii?Q?8WlKX8n3fy2tvQdBucExpdpJJwELy/M/jQQFGcKbBRLLweKl75zRxeKyG2Th?=
 =?us-ascii?Q?VUfSGihL79sWCo5C45stuNbyouo7Fd5hfLEBU8+ye+5NQIHocYZbpzfsbKPr?=
 =?us-ascii?Q?DNCwM4rGKpIRB3NApnMSVk8rlt0AdvAw6QP25qBBzHYQHhE/WXhoVBJ1IyEH?=
 =?us-ascii?Q?l5HPEymG/Lav74j1B8I1XwVP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15345588-e9d7-40dc-da00-08d8cf279ffd
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:16.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ybge9Oeg/gWhyygbYtn7qDqOz4QT31O7B8P2tuTDApnpwPas5u1MkJO1IkY9uc5qh+QVZgve5EuMW5SfRfuUziE6O1vmpV+1eCa0Ya+96w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a cmd is on the submission workqueue then the TMR code will
miss it, and end up returning task not found or success for
lun resets. The fabric driver might then tell the initiator that
the running cmds have been handled when they are about to run.

This adds a flush when we are processing TMRs to make sure queued
cmds do not run after returning the TMR response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tmr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7347285471fa..e7fcbc09f9db 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -124,6 +124,8 @@ void core_tmr_abort_task(
 	int i;
 
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
 					 state_list) {
@@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
 	 * in the Control Mode Page.
 	 */
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
 					 state_list) {
-- 
2.25.1

