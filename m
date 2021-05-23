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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56583C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354E561244
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhEWSAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhEWR7w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHttPh181508;
        Sun, 23 May 2021 17:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=0iIViU/6YGC+PQgLD6uKwD1SW5ePybSf/rrSoq+62UTJuVYGlEcZDhQbLDbJFOH39OW0
 ZI9KqP0INzm1nh1Q/NRiIjVFEDs8hmiE8dI8nQMPscl3pt676O/BkdEpf2eYFdo95LDX
 JM/o7b5mVIq25iyBmZ0PhzIrBaEuwfuDV3DJ1LG7ChH0FkybzmNOLC+OZHAqwVhwA2jQ
 4mVBzP+AZbQFAi5SiWU2kzmHE7tvwLbZ827kP4SCInjk0/Ll99cDmH1zFL0va2wBLxO8
 Pmb8/Zy5hg97bV3w/eP6mQQkPuthdc+qWoYpiAchCfbb6ke52Mraxm51tSTEoX7HWmaU tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8ryy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDr161766;
        Sun, 23 May 2021 17:58:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KK/l2vhJYe2lB2S4bx7p4HbBhFuhkrj6mtD9Jusfj/VIj7SNVtdJNuAzHF/Ui7JnA+DICoplS+f+FeAoKuM3MYGziK+MKPvaaqguIG3y9kD3M/xwBAruwCsDFZU65t51DiLauMMA1X5WJnSGg7HYWypL8Ho+Nd7Lg8vCO5o6zbGvSLShu0exxLBoehthj7xN5jlQgvAlStcMEQTHnlbgehhXgmV1WoNK4ub3utQjk+wFut+84b6U1RQ/4cOHmhGkPIcZJDEJnxTkmda05+OAbBSgub2Dg13Z92HKqEM6T5HDNNZs/KJk/tdfEzERDTYUfQHnbJx7J859PM2qWwZJBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=WQcCmTqwwq1hE92tGRNg5+XGnG9LYzgUpYht5HqWKuohBDpA351kXzZgn5PhS9aHyWxg/Nefa0kkRDizzk+G2DhkOkBCmah/K8Mp12t1LPj9gyTGRNJJCVnkx5CbCgWITgwGTP0fvwlXfsbpjkcwxnwZFG4gchuE5GSTaIKysXd7TbYQZReGTcTmN/EYjlHiLCM/FQMiLUc0F+WIuc5HsXFesNzTjj2su/vf4yOXbkW4/yhPigvh3bU7EVPM5veB5KRJO4mUzGAptrKRxX8Mt94chjg2OGnFymqBaBgExFkgLRMsD8sOIVdUxWjYCd4to6qQuPkrNDg/EGBy8gNk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=tGxltFssTtof00IHSq9Qhdlm6hhyNrNT+37QnGGG28dWsrPbTRb0wCV5efcYrtBt+uOtxyp6WyQ4CL5nboB3YOawg6xW3xczZgOgz8J/rT5XgSk7fY5WDsFvHbe2HVHIS7sruE8cZyBCfeWsDfX6YEakS1ti+pafyvgBvvz6YgQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 23/28] scsi: qedi: Use GFP_NOIO for TMF allocation
Date:   Sun, 23 May 2021 12:57:34 -0500
Message-Id: <20210523175739.360324-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28d936ec-dbb9-4508-7681-08d91e1455e4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32397DA6C38F071AB4E221F8F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTIR5Gnu4soSibNJW28MaGWJYYum9PoutehkiR6v+4mmwDzUcOSy1rQTsQdWf2TyrevzgJB2DOIIwxc1gpgynBB2rzxXY0DRp35jYyTXXQFWNvfz4eN7jgbl/D1efJFdx0sODX3W+3y99aLzUM4/8zlGVrD1/pY8IH9XEMRS+4yB2qBPyvrkLpwfoKGL/jldGaSx96sf3UrcDz1Fjv34CgL70n8aSnVa3WqACfYzpM5BwfFr70/VTzXO66qKYgvJ4cBNd2jmH1j81UAec39ePzFs8Fso72LBxSgp5Dg3JUGbTbTMuGdRgmqce6ZvFR1WUajn9DNZLZA9XBFv1NvsbcrUhgUzD+d/CyOob3s6hN/ePJpphTx4QN5SLrqQqDOWh5Jx/7P9YBbJLUtG+fsgb9j0dG1n7Deo4AxtaIVWQSjWDnkz6MoLFf7JCUTrjQqxUqESbKpGeOXYrAU5H3nmHR1sRmCbK/c6iwuJh1aM82BtGfLx/YU89GHJ8Ne7DFxL+zjlGNUFBT1sJYJGLYck9BU2gh090/ZhWLIb6KsH++Z9eqbIzyfi5Ru1N0Np9H6jVHq42wLhG9ryOsWULTWa2Ci49eIspJIsliMcQ9apT1s7cfnVURnZHdqn0T04hkUdEQ1OTlhuc2qIlF+2EnRPwe3PI3AxIYCJbnaIy9RsB4BEvtytdrF0qCXspgtxsKyE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(4744005)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Uxa7Vo55acQ+BOz2QMxMV7rADwttg9m9xqYnt85As4HqUN/vuSkuQuy0UIzl?=
 =?us-ascii?Q?Q+dSsALmxsD9wt1CWG52NEaacRhEJUxO0lXrDfJM3HUj8uQiotKO6KC3j9Sd?=
 =?us-ascii?Q?RKggVbSed8eSXYKrmp3SYu1Uu4Az2Zb+BjZU8i/glxiIBlSWtZtEwJhdTy9K?=
 =?us-ascii?Q?FPlI0Tf0lKw+z/9TdFA4Yh3C/Uyh/8IEb1FefjE/vRHrRd9ejRZ+d1h3KTU8?=
 =?us-ascii?Q?49JB+OAkPHVdRwc4cru1ca9tczCJNS75cVG3twnQba4yAk24LbzFHQfC89bq?=
 =?us-ascii?Q?TFW5lJgjBuRm7Ethf+GOOGS/KCPr6+bvR4tInZy2LFVE56d4ssmKRhZVaTot?=
 =?us-ascii?Q?6QwmVhq/d/O0w8KAoYfa8hpJT3430VbXZk6A8DoGvtP7NiSb+fgSIwu4jpX5?=
 =?us-ascii?Q?uf8dvd/VpWj0VTIUNLqnwbcqRWO8Oc9Kq0upLhItwp5BuJxXgTQsLohQHIVC?=
 =?us-ascii?Q?zREDOtU4fmzC9g6EbWWi0xNgEsVbjL2OxH7Iv8uQdstPQTPqyvfnObsl+04+?=
 =?us-ascii?Q?V9/IxZZc+ZwmdnQLgoQDdMkKTOBpFnKXYwu+HbJ+Nik32aPqsT3AtKx6Ky2W?=
 =?us-ascii?Q?pAPwPtHYQ6B47ToSujpVAxDfLYbsdHDm9u3NyC6dNW020igY7steYqOnMPqY?=
 =?us-ascii?Q?K5X0EiEs1LOrJMM5ZwHtWMIbY/mgRIMevD302SimfIZIcuY2XExuyQD6fWFM?=
 =?us-ascii?Q?sGE/d4v2xlPoJSHCnLiQuJ5b0qYMN4qUFW9PIRD2K/r5/+jTAy5+xN1I1rDB?=
 =?us-ascii?Q?8i04IcOMuEsKRuIPQP28l4vhFS8yYZLiT7YRVDeSc80Qat8AtAIofwTFlPsM?=
 =?us-ascii?Q?lydGpSmC1fvPVnZJKS+F02B1n1CjE55zqst8au2qw+UEQ/CoYbp8veqmEZ92?=
 =?us-ascii?Q?4z9tNWfiOeDrMf8cY6HSHmVbLxaLT+UO85I6Q93X2fvnxfQoJIGw75q4aDpX?=
 =?us-ascii?Q?OGJSRooE2TFGX7jfc/Wy/m53rmJotcFdxQ5TEbAtX0StK4fUEjsL1E+gdYys?=
 =?us-ascii?Q?uDN5NXy1D/NAeA8E4LhM4mro/3gAstin/jIJeRS6hUedgl7ejCw04rYWUb4i?=
 =?us-ascii?Q?MEfTVdZ7DKtB/cDesZbDKPQh/1EdmqKtvSsz/JjHxGQqxrmTMWAvnr6J7LGN?=
 =?us-ascii?Q?CWO7+2QX7KeqfJrkCxt9fwhQpDyaQiyYV6zwAMD7PxC5a1hXwgfct224n9xZ?=
 =?us-ascii?Q?tlzerlDZUvY/Tv7IYpM6VUCq438Cra3DF/bHSa1GBqrdhCAdtw5DtB1bTLHT?=
 =?us-ascii?Q?viCu6GwVZiBNQnp3f/S/7hRma2dkWWhQ/cCoNJ8cQA5qqSEHnGE2Gmn6pIu9?=
 =?us-ascii?Q?8hJEl1Os5Z3YAXmIR6UZTyjJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d936ec-dbb9-4508-7681-08d91e1455e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:14.0729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uL+VUGUYDNSO62vBtFK/pvjlB2+MMo81MB6OAj2YX0ixpgg0tOOAx0tWVqyduqX/yx7WeX4P79OyRm+2UK134O2WJC9iiFFBJByT+JxJNKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: F59vOxfhs-4u7neX2aAS6uKOK0DJxoWk
X-Proofpoint-ORIG-GUID: F59vOxfhs-4u7neX2aAS6uKOK0DJxoWk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 6812dc023def..e82c68f660f8 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1398,7 +1398,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto clear_cleanup;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto clear_cleanup;
-- 
2.25.1

