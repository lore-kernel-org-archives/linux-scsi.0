Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF12CC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CDF961158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhDPCFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbhDPCF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G23vdP098673;
        Fri, 16 Apr 2021 02:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yrI/KxAcaR5Ai3Q3MPK+sUocnXq3/ia/hnQ5tLHlq7o=;
 b=jSskJA/qsiahoPL9yAtfd9xuUay68HItM04e/9LoMUUi+SSiATwDFeQU4lNbO0f9c1dQ
 gNSj+4T81YZ0aoiR68Sqmd2j/KDqrPawg0+1jmuCbTTkW9HMkYhlVXoHykycGVAvtP28
 R3W5IJx+NNR+WRNEB8TnVgP09fDbzMWreavBxN9siEDU7de3fXZPa+yG2JxjRp8nsPN/
 /ZTjDEkpFvZ4I2oI7m0NcUaTyRDjft+j6zYwwbGOr1019o5ObK9VnNuRNt2KsWPb8um+
 URykvDM3GdCHoaeMSBWPn1CLhjc4nuSQilqg7n7XRtRlsaRz4QvOMf7ZL0Wgrv5JCkvp +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xor1008605;
        Fri, 16 Apr 2021 02:04:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 37unx3snxg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRFVWk9fn6yiBa8A0Junmn7EWW/5ZmJ5iuuFi2+WSkJd8pkVHFZpH5kf8NMOgNuZsPsXftOKpI/hTZEdPQ6IVbKCpXH3ysxBt2K+zQSoqK7NeE6kYGl90M2TZdjLb3DyqmSuGhuRG9vr32xYJIjFrkhGVYEJ5CYK2epo7ovdDFTsiOHD57aAFAhJD/BiYLE+kqGQl4f8iOg7MbVL27cbqSvforPPmddxOqJUm1mZRj6UKTqHsirZZQlvjnhlEPgLqowJNDemDuVvGOGM87F7k/pYU73oSnbzL6qT0Dau3tjMV7ERq3LWcTMZxa4PuEuE+bWfZa2U8oarQgAloTu6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrI/KxAcaR5Ai3Q3MPK+sUocnXq3/ia/hnQ5tLHlq7o=;
 b=N542KIHviHp32arRn3Q2EarLAI5ZfGXfINnC9OoDNZEGMeLvn82PzT/a5vdvllJUgAt8G2gJ72FKjCZxifHV0FSJsKOhD06pxryy0yhEExotWqfyKZ+6+w9a/mWxroiPL/BBYLrKrM8f47iFgn+rGYvkQSlpMUzu5xU6u8dhC9+Xvwu5NPDhrkYo1K7aecOctPm4Zym8r/yNfUqGwKWJWOjIYfb1sc3Iy0mWChX8wpV0vmV1G4+/1ISMQcJPEczueza69zyJ6ndIAhdsAlxv8RlZ1+lnqcMQMeGz5Kxv/HetxurzFakBsvY5lpdFm/+WhAOQ8a2HQtPK92U5MjcCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrI/KxAcaR5Ai3Q3MPK+sUocnXq3/ia/hnQ5tLHlq7o=;
 b=TEmi+A6kZaWC2+7VKJ0AfZOEG58UxkmnEthhra+V189/fnlHxMwmDql8grKOIY2Aar1TtBS8qtf9ynIMTGHYSgkDmRBPcwgwmT3ex/rU/4v2XgieWFBrkyEACZBzPdfq/KP69Qt61nD1DsLa+Cs6hYqmJ4u89qCAw3PYrYDWhio=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 07/17] scsi: iscsi: move pool freeing
Date:   Thu, 15 Apr 2021 21:04:30 -0500
Message-Id: <20210416020440.259271-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e9c2c9e-046a-48f1-3d9b-08d9007c0865
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB242150D33C45FB46E511BF69F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWZ8JT228GzeWfUJM6Cw1zFuNArD/FDMSsiBYR0xj6qIn68U/VH/Vxt8xYEtX1uY2iFjn+5ONVhSXhXut+ce/3o0ZiZQTckijV3dvDuV9HeMWQMPBJSFKqL3dPs2ZYualxE+AmfdsG9GvOwMWj6eqU2dKurjJHo9Zw1rGeVoyHM5KsoMaU6fMT5ZgY1ytuJnG7iW6Y/kACbloRCDS/UVnxrd9iC0hnUdm4DPxBHM9LccZt6Dwzx9qVa+TLyuWvDxAZAbOfhdxYFQ+1NFoNq5fvRkb0PB7GgEfmr8tX5LhyvIPYSzpoon8a32ukg6Us9ua1BusgZCgEV9PiZbClWITgujDbVqQPktdhdrZt7pShf0ldJNzorg3zHZkNCsDPvdlmHaV8w4TeEWgeexJW70VZ+g9fbtubE9+xSDaa9aveJXcBX8hfmckoabnBuPkE0haoBHkhHEHFibqPFlbXhbDQWp5zlWy1jWLK8L2AaG66CNfXTtJldt/a6bntPnF4najRVu/UyAjXK7EqcSSf9lSo05pu8+4tYKP99mrp4+pCEx6uGFKfSIId0b4xYa034UFTR7cH9sGUQTMapcbHdo/QNuugGSebyFfsVfP1HMlPKYlz+lr5VfoYxAFAEwPNC+/48AH8/4FwKm4Kqh+062UnjeuFY6DgxnDy51wZnpI7KhCkWWJUAJ6k1zW2+HTFKD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(4744005)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tfb+p9OaicVkdCpHT6/vizXikUMVgd0j4uoV23+UvS3EP5kfvkVGHf3HiMGx?=
 =?us-ascii?Q?CTwGQ68IayxL5v6BcMoql3qaDQJZbuK1YwDDtimdsrc9/O0HVU8NC0eAqjT7?=
 =?us-ascii?Q?Zkx5UEMNm03Jpmq5PjZ6KN2O46ckfjQQWpesTAFqncHKyhDqM6ovinsKPzlt?=
 =?us-ascii?Q?n5g+lpanv6GLsHD33hiQ/QhJL/LJNdzDm0+rZwJEHmDi02NeNzI2tVKUcoJ5?=
 =?us-ascii?Q?g4kQzb8PebmSRhqoisG2Sg2U8W2QAyijt9muoK7GsncVNwJKg5Qjmd+j6bvT?=
 =?us-ascii?Q?+QEWU+PXirkqj3X1XenEN8Lxch5tCvwD2PBRTiZO6DQQvvdoWxG4T2kNAjeQ?=
 =?us-ascii?Q?ey970cF2rFz3r8bAC18MYs3yAbw4e4ECPc1S+PIw1D6CtOjeesVWQVKE3clc?=
 =?us-ascii?Q?IggSqvnTjJNxQ9sL7nI7cA2qzYR8u6qF84sPMxKgo6vebz49S+cDMk3KVivs?=
 =?us-ascii?Q?3ncyDDJtyujyQodDWjJUNsL1zaBZgm2ZBBChUtbC6X1z18yZRPQuWh+kub4i?=
 =?us-ascii?Q?tBvU8B+47CI1o8CtqwS/i3ORw1phLl880Q5x1L3q78AsEwwTuaptE7dxApPy?=
 =?us-ascii?Q?KXZldbN2UfgISCWtAIVQ2+GZXzGIrw3Oz05gMqkO6a+N5MJs6tFvdiXmqKeo?=
 =?us-ascii?Q?yOjsHYZ/ROHq9Kxl5ULELmnIfWPuNq+D2CvNOyXloWa3yWEJt2szWaFxannX?=
 =?us-ascii?Q?gYUIi2tbZmAG3YqI37xUdgAq1Hi6Zdv9A4v1RDdMcetiApXZlfoZaJEJy1l1?=
 =?us-ascii?Q?xDVQIcHFx6F8Lzg7q62+qde3lpMrYWqREJg7CzCSf2zQ5CqxzLy/hL/kFo/B?=
 =?us-ascii?Q?6j9h0cyamfO9VGPLw3TAmxspQB8UiEDNMZaiZ3zVbjwJfDUU0NrQutA2n491?=
 =?us-ascii?Q?7BflBLiqbB0R8/6Rxd5hmg6WnWXmR70uTqYPiA1htorqOGjHNOsyX3mbZBMw?=
 =?us-ascii?Q?T0YyEmnWHJ5J5eATyCkkvfDrf0KoBafuO8Azi9OI7hB6vMwSLhuWtK4H/0CL?=
 =?us-ascii?Q?2lZHtC4cPDP6+a4K13QrQtWmzRJIFaxUhSLP+/4zQ0qFmYnYJCFlA6AjrcUg?=
 =?us-ascii?Q?e6oLzYH2psaaAO8NH0p3uVxo7WhjdQg16gyRGoLAzaic4IanWH09e2iMRIzs?=
 =?us-ascii?Q?0+ydnwjpVKkqvTI7IUDVwwdDoHdhHPsIyN1KPvEFAUn3aEnWBnpwtjw4uGgK?=
 =?us-ascii?Q?t99zDUT4ifq3ERUaqQibxXUu6Eu87tGHkO6Wwa3qRC5NfN4GGy2CkbUeK0e8?=
 =?us-ascii?Q?mABrzLX9rKxj6PW1+pJ112SGUrcJKGOmduE2pea/WkCmdQOVNJUOYrcWru5O?=
 =?us-ascii?Q?QQcp2o2jFNWx/CFeq/TBFvcO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9c2c9e-046a-48f1-3d9b-08d9007c0865
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:56.9071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3s4lRByiJurGuyPXvjtZnh8aC/Fifvc0xZuyq4PrsP+lUjbeq0Af6086oWMLssxm8dskAtw/sm1aEn5o0qrOnxlWNrvxDmybpQ7jrj0nqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: iOKqMKWPMLWJOCVFyaeTcc3WsWF7b9mJ
X-Proofpoint-GUID: iOKqMKWPMLWJOCVFyaeTcc3WsWF7b9mJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 56b41d8fff02..b2970054558a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3025,10 +3025,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
-- 
2.25.1

