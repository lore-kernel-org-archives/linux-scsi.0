Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5860FC43381
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 23:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 303B264F33
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 23:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhCRW7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:59:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhCRW7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 18:59:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IMo0qJ086723;
        Thu, 18 Mar 2021 22:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KaQZyZMSQBb8DGCgzAtOpsgr4LYluK6KVg/DrnH/f/I=;
 b=xyu2qJfbXIb35iHmMr+YglTd9b9yX8Av+bVtaJITDFHGBqzgKHFaVrnJXYDyfLo1IPfQ
 sjDYOI8vE0djeRg6VK10vR/dG2SAxFzQPKrNnYFrrInM9ijvZtuPlC/EQBBG1XdyDLc3
 jyPwD7MrAlVELjmtfiqhS8/lz1UYCyBqZckZ+0bxgzxxF5TC6h7aKwQko4Kg1CsGHLK4
 eO+Q48Dj5yE9nr+zUxIMeRcASV4Nwy+07O4BywQ3f6lRRUYe2O6mNWj1EOe9kVgefSrf
 Ap9rLS8hw+7RVWZPeW2g4lSkOTptLjsIGOMEmaHojiW1npfCPp0SmYR7nGY0KwgJ+jie VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1p14y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 22:59:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IMo2K5131332;
        Thu, 18 Mar 2021 22:59:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 37cf2usk1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 22:59:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aR/rNkIVJTYEvk26dkaD7dZKGJIDZNWNccnxTz+WSQPDdnWyk1Ph/x50lvmEpW6eKhtansnbVVZeQJ/MiFzSbKl1U8cF9B3c7VYfZLkvtPLNburdXpzavlq+a7+z850ybkuKoEDSUfpg23xm/FSvAXEDwA0FgpwGuWC/zDektpinB84zDFoBHGXI6IUZioLUkfaNqUBU0soS/NjVOyTyNHkxyuNm78KAbRqvGog407t10r3NyYK0T+lU0g0tylsg6IhCF/fDqQB06vVDgDA0itb/1owAC5aKOJ+biShWjZ5mFOT4yH6UdtEpKHlSQXGzkN+IxS5rbUo1C3Ex9Qhv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaQZyZMSQBb8DGCgzAtOpsgr4LYluK6KVg/DrnH/f/I=;
 b=BvrAn4PKO/k8cSgqiO1G5nKdagOoPnMQzC+1JeeEIycCXnONqQMr9KFegIpyDQjnQBdI4VqGVo5I/HPHHN7aZnnLd2r7o2tTE+CPGYA1dWv31zoEtVdQeKRMqZ3gVtrzVASSrQ1CUxKcZPMhfncbM2AH8cCldXkQRy00Z8yzYwXfGZwlWNsgySdgOxA5vsK0x+WaNXLNl8bcX9OIsDsdnH9yaKqwDdVUFbHCArLSOvhWxKqFDkNR6jgz7jyISdekzaYjYQKTu2NKuZN/xlOEIcroPv5TO+6PnJqsJ62uZ/dpNKHoI8FfDirRs7RmsFadO89NyWXJevPusuthNVxOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaQZyZMSQBb8DGCgzAtOpsgr4LYluK6KVg/DrnH/f/I=;
 b=CIRhUUM35VxgIHtnnl+6kwVIlyYujmnCLNd7GlnqyND3EpkhTcZA/LaTG8ko0hE6zr8IQb19rS0Q66KeDuL+5uiuZOWUBvMnpW0IbFS3c8IPrK7zl/C5L2Tvio6tZFMMvoCAWmXyIeQ58hSh1OfXBLwONVT9NV0iSwjJUhqnzHc=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3844.namprd10.prod.outlook.com (2603:10b6:a03:1b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 22:59:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 22:59:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: fix htmldocs warning in target_submit_prep
Date:   Thu, 18 Mar 2021 17:58:58 -0500
Message-Id: <20210318225858.11863-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:610:b0::31) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:610:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 22:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58ad8be1-c914-4d1b-681b-08d8ea616f16
X-MS-TrafficTypeDiagnostic: BY5PR10MB3844:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38442C74843337DD570A36ADF1699@BY5PR10MB3844.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmxIo9EXGr7OzuxcyzNo6UQHbhF3XUhSnIvQ5A7lNQyqX5cQj3gno0397vuDsPxbr0Hm71KG5AURh+sdD2ThScqFPGdjhfgCgo/bAlg+NUQxxeMjuICTY2jHHWYSlCbncO8sWDHfhiXAoNHNpQy9M0hh1uiMNVLISFilKXlxrYQrZleJgB9pVC2gR2YB6Ajh7rFfQE/EJnGH+6TX2zUsP7GkJ02UVl9l05BXNyJapCWz3jkXir3TuJaAHva2izDGoPxMRHhUL0d+a2Pnm7GQYBfJxDOVhT5FRiq+sc7MF9z88rzijGE5pHEk+taxwIBc7cZfwKLK+8CCH3TmswiXr9Jq+r/OEGfWAJSNE9+KEbf3x42KNi4dh0qGdKaZWUVbDcoeq9v+81a7Gowu5HT0DMH9FrQLMfORbylkejI/Wqip8FoGYzBSMXGLagLKqrqkD6R4Z8fAASuBk3eP6mDTN7HMGQQW/oiO18M7EzFsWVdCqUMHUX/IWE2oY4UDkz6rOdOzR7CVctsLdv3czmnzqgxcBu2fZJOWmu24c3TIDJzYfrLL7fBwmY6T9uN51UoCG6Dw+CugL558oIcVV9xrhbgGGfx0Hch4pqN2pKvH4bfgXXT9Y25xgUd2lfxUWBuFjE+Pb9kGV2lH7uekdP8iYeIteBwfNkUkeGco7upuh5YpAcGRw2PEMAMqsDqXorh9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(478600001)(86362001)(186003)(450100002)(4326008)(66556008)(6666004)(4744005)(5660300002)(26005)(107886003)(16526019)(2906002)(66946007)(956004)(2616005)(6512007)(1076003)(38100700001)(36756003)(8676002)(316002)(6506007)(6486002)(66476007)(8936002)(69590400012)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Z4cw/0jvmiBOdaazSnrbxC5KnTZ34tujk2xyaVmmiB2vBYQ8CE5aQf0IzmBz?=
 =?us-ascii?Q?tRdM+/uyUqI5HMWcaUHyW/00LNIhuOAF6kN5RH09FOv6kJkZVDH6XcmByd82?=
 =?us-ascii?Q?TbXOYcd0jrLaW1zx+5DZ2ZSRC+zphNO8kuGg0MiJX3Asu13uaxTuI3V2NB+n?=
 =?us-ascii?Q?5Sw4FeB0W8lNd4O2pHX7hiBtKLwAyTvPw6Ob9GBBa/zcd3SYWTM0a2mFh/Vs?=
 =?us-ascii?Q?q4PzA2e1vlof0OOuvPf8RG5DDDDEDg79iMgun8GsgzMz4gSQxxiR6oJH+McR?=
 =?us-ascii?Q?UzfXBiNKTb20fD1zKVRBqyKthl1P8Ds0Pe35+e78+fftNPuH4iJhkYbVu06/?=
 =?us-ascii?Q?rMSQTkosfa5pYUSmnV3v9gk2fgVIJeW83HMTPPHo557wiMZW+M7mI7rDyQvl?=
 =?us-ascii?Q?PNY37BlETW1nyxpKpkuF1/JzF3UFRAUfGtEOcv/h8HVbJgzhVR3YThSw3Cbl?=
 =?us-ascii?Q?VOhGo7BKVUWUC0uQPWrYPuQuvfxeoBD9gKDhbeNq5CEL00KVN7zfdW5TbiME?=
 =?us-ascii?Q?j51B2i0QEc1EA0sPnzSYSCN+YLTbEoS9UySiPdIKrjBVZ/XoG22B1X528qjQ?=
 =?us-ascii?Q?OnHHd+Gt5KQ1geDKBO7QGVOImR97b4G99EkPPU+FEt/xbmQPrBtMqtCmMild?=
 =?us-ascii?Q?DfyAOKv0ZDb/vYWr3aPYM4TbWQHGlL5wmVVq8asZHOkxHAidll0fhOhNdUMG?=
 =?us-ascii?Q?7ibvCUeLU8SFZupSM7Xs4FzIo5M0K8+LvSjAe1XlivROKvLY8bX7XsHwOJiL?=
 =?us-ascii?Q?7n31+47B1Yquy+c+P0LQFSajgYZVA7voJt3xoYRRvJmm6GDvVKEIm1bLkurW?=
 =?us-ascii?Q?AwJlpQb24vRcAYQClW/leYdYixrkH9Uq0yr37qLDjcpYwFezLo9PS8ZCu4ex?=
 =?us-ascii?Q?tQcOVzJwGQrF2sY5laXkMeNonjTAf4Lfw88Q9ALGQbJSev3mN/QHG4Dj/+s0?=
 =?us-ascii?Q?owNMsK9sOsFvi/khr0DpRyfgjrcHJSkOQmq/5gAPOPazHa/N57JkpHrSI+yh?=
 =?us-ascii?Q?N7mHBVaxKVQkJsEFgfHSHoBcac8kLS4Z8VMBfXaeSVL2u1Nu0BAoiCUwMXr+?=
 =?us-ascii?Q?mGfPwXn0fuugHpRuxGhXfRfAHF0IXIXkAVQzqYI0ErZAeDtHmUtab9CiBOHR?=
 =?us-ascii?Q?XcEcPb7EXvZS9E+YyqHxLGCp165OayzufHkbAAuKvXCDftgO0ZbRYE5NFTDU?=
 =?us-ascii?Q?bJre02WViq0z44siEwcdkYPpoy8rcy/lqzht+DrIzMganJDqTfZPsH1hi8iO?=
 =?us-ascii?Q?cvSdmEYCDyGmnbuJMcTwQtE0AsPiis/f4GmHAFztnD3DD8vaR2qXa7zJVxIT?=
 =?us-ascii?Q?QDh2yTXVGTULHNCVvcucLYKD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ad8be1-c914-4d1b-681b-08d8ea616f16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 22:59:07.2050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffwO1MsKtFEMq2V10RYB7rSQFI9+xNdEOEVXb5Y0s4eOyKGfZta/QOtIhsYlUVpBmjYfmU5T9LecpPkYM3uV86iW4A7ImEtbc0g2WroIh0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3844
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180164
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180164
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix warning:

drivers/target/target_core_transport.c:1661: WARNING: Block quote ends
without a blank line; unexpected unindent.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a75591c929c0..8fbfe75c5744 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1659,6 +1659,7 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
  * Returns:
  *	- less than zero to signal failure.
  *	- zero on success.
+ *
  * If failure is returned, lio will the callers queue_status to complete
  * the cmd.
  */
-- 
2.25.1

