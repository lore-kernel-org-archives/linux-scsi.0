Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25431C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCAE5610A2
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhDJSlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDJSlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIbv0T065632;
        Sat, 10 Apr 2021 18:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=O0+NfpKK2dCjXmpUhwt4656fIwdjZodhomcBJgH8SaU=;
 b=qFQNTWlDtXNnRmw5hWZxeoFNnFl+hDXa8uD70xnzATus54r8KWEVJXj17cdPYRKLa/eV
 Kee4w/Nuh29piRKoIAi5j6VpqTHbhnNHxhjcEifNeT98HKuurjjrl5yZ4p+86SAYIRql
 FR3Mok4y+5gsuccR8AERWnVrft8wiuvD2s3TWC2/Hfp7cxQjFnDSQIsq6OtxGm9bSMB9
 y6jIXcFuIRcOSX1y+5FApUWAwGSDwoFAWugWTKAL93pzT7/U1dc7HtHMJAMpJdFdEXXx
 BnlclB7p7WS/Q8MqFwUfXuYR1nxa//IBVw96zSAinevC1dHymVv0e9z03GDKquUjvtGz uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er8str-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThie176766;
        Sat, 10 Apr 2021 18:40:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4dr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7EDi5e0AK4b+8+r/0KE08Nd6v/m+s776j+48fiJNF4Y5lwJChq9UdfUxRBBsxzz+7HQKqm+4VfYMm1tpuyjw8wlKMYZiRkiBHoyhv2wQQafkqK4X3eoVYBadG3ero2Z3p2v5uaM6kCVVqYzPnZ92m2JbN1xS8n6dX7UTMuQbv/tA7v4fRxtkRidFUFZh5Z12msrfb1d/irH1HGAITNprlUpUYdt1Lc8YmaTiWaWWR9vNjBDjQ/8G2iYa1t11SOvAqF24dp9YfWe9oGyT7m2/NpLVYCxb2MfYbavHHY0w8LUOiK66jMSIVqt0Iu0N2oJK3EPcioSq1VD3ikFKSjaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0+NfpKK2dCjXmpUhwt4656fIwdjZodhomcBJgH8SaU=;
 b=PnU1Etsp2QQ0nK7VpvZ+9mC5wHf1ej9apqGJ5HFGWbT6bAEwK0Hf27x+YuTVRurtdh+YHuwgSTa3kuP1AJTecj0OrcC+KBcHOEea8NhQ7djQ+4qhCGTEfYdmsm2FRoFOylAN4MjUkQctukW6Ogcyl0uGLD+0Er5KbupSk6tTcAwEDGi8I62Iu8DAiFGZ+c33A5/r6J/Ola9SAD/VlFtU/5ftch30OxOBFEfEEY9lxIvmjgZVPFwrk+G+FZhL58HnJKZZiPgQBoPA0+kLwZhB4Kmcw3KwW62xJcT54qZCLayst3mXc+UXj6rx5gqFmzAeQTg5PqPrU6irua92w23k5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0+NfpKK2dCjXmpUhwt4656fIwdjZodhomcBJgH8SaU=;
 b=QY94EPfN/Oif0RvVo9bTnAapKIjSBVs3WyYbFg49vkEyhQC28AS7AvxKiD+siYwiEA9pRZJRWj/CfnBANhglKvJ71lY20l+fqAl2LszJdyhKERb29+WsG9nKvZScxwY3AGJ0mG92sFeHrBQgVM1P4X+shykTSiWfTLvpLxdt2aI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:35 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/13] scsi: qedi: fix session block/unblock abuse during tmf handling
Date:   Sat, 10 Apr 2021 13:40:12 -0500
Message-Id: <20210410184016.21603-10-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5018b7c-387e-462b-ec7a-08d8fc5020b3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB432487D0CC955FB538ADE5A3F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8eLzU+x4VmFJi6mpaMiXnTQTkqg78xGvLpqFT9XcFuoFvjlCjZxI4BGTNPYldPBbQvpWqY2TCRdVG/kf+EyxtwAAxQPHBs/iqz88zw/MAWYy8S0uwkFrhUxU+aRvPcj2jHZ95mBGNIkmj5Al/UUTrQHOXSEc22YYxzop1GCOUa9mcg6dzitBXcnNJdwYKB1PZQQqJ4eoySkReQzJ22pxex5ekPGfXOE17eIHcARkaPNnD0XTpFfdfGP3gfwhuVkb+alNEUB0DOcOFamsaEgnS3LYdgPYaWV0dfsf0RGyb/mk10Xu3AQWoEQtyhcVhKKVXLnyvbu95IwwxjDCniSKOdrgraLgTKxec3sDrwybmdVNKcvkK4KCNlclqOZpw4ptIbGmmg/FgKW5ASmYyoEbe3Qjr9cYQXu5AI0IkCvjtKwnj3fX+s01JQhKizOVdIpLTnNcOTJKbJilLKGGGWR2LsXYyvhTXKb/C5s19i1u2eLl1ri13aGdNrz0MjdyYNOT65LcEdyOnD10hGb9Myj2mtFNGdAr85TkM7gfe+24jcVvGJC8N1XcgKOLDrVJ7OPfmNB5ks+O4VECYOb9lUGMNGQrunQ+QhGt5HDOyStWTL9PZsGqZU0Cz8JsVBrENf2bIYhQCGFZ8BkPn/Asxn4MsSNSzqvBR+qfojg61TUIDpaWDgfPuC8SiAupMcn8gGY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ukL0vDSYNR4QGxKEvuEeskcPV3LT3VBeDdXFmN7/j//HQtWj+kwYNi8mWxAw?=
 =?us-ascii?Q?vweRe2/cr4dbPGB4oacffd3dhhOJF1+PA8PTEmVrS0xJZ6NaOG8zFSvL9SDy?=
 =?us-ascii?Q?/GTMrVFYDuYLZrMeWaAvLrDxrBmo8ReGUOu6PXGKfTn/nL0QWdMSHsKH1PFm?=
 =?us-ascii?Q?YclgBG0Tjg2gdBS2o2BN07qd0FznSqxwcQI2N6eLlrsWAEio2FlotNPlEcye?=
 =?us-ascii?Q?RcmbDzC7FVdLhk7oT4pXs/Ue2ZSuTPZGfJFcSQyn81MfvvM5imGE/vnPVpwa?=
 =?us-ascii?Q?H6JCov9SzMszbVe87zjL7WKhY89O9aR6LynOsnS5VMzTQA2uQwCyCLs5fdZn?=
 =?us-ascii?Q?fHmquB6HAaWXI0WtVKjxwc1Cnwu+uFELT3Nl9hV/j4eTLvzhu3+p6LlfrYtF?=
 =?us-ascii?Q?7h7xMZKpg0PnaEGDZajERc/5Z0JsxPyhf6GVuhx09OZ7Pb2bWlvR+p3+p1lm?=
 =?us-ascii?Q?AkU6ARfHb0SbiYz0tSOSp3syCjDCHmqQp72r4JzHj86N6hcaXLyS8B1L1crH?=
 =?us-ascii?Q?OUzqsCyZsZqd1M2AnOPJ6gyM6ixzf9yPZ+AoETWPQq729ofF9uUvQhjgKxH1?=
 =?us-ascii?Q?XZZOAjnIlLq6TlUHIan83+eV3vSQGufMb4xtIDN3Rtc/8CM38LEhyXqwX+M7?=
 =?us-ascii?Q?L2cCfwb7tgHEWKznc+rlu7uhHpYzXllXEbGvTonMui1bqEOHIeIuyDGNt7pi?=
 =?us-ascii?Q?Q0hWaJNHeaB5EuXGaODXwegmTp3Yajqfb43z+vFyXMu8hznQ1YlaOm1+q7xp?=
 =?us-ascii?Q?5hr9QkyP4pQnWDI6+OTx52iacl3cMBYSUhNHyLnDKlqqKiuwmIjsFxM+UAx9?=
 =?us-ascii?Q?ipXr1JJZSdSUFiqyZhUy3CNqhACkASVLAxQt6Gf+YYLYGWibc6I/MMOy6mb2?=
 =?us-ascii?Q?StGWOP1ucehafElFfN7xeFaIyuz0jN0mn0QthfNvbyGz0XfYq/Q9sHH7Vxue?=
 =?us-ascii?Q?7FWJ3jNYpv61Ue0UjqzsGTok/213GXJZc1rcfZgPPTygEV99MuNAWJhr58nW?=
 =?us-ascii?Q?ETDAkTke8UJ3DHG1Ev/qWjKmXi5OM3jhDlmiQV/5x0XzyLb0tOlg5rcJbhNZ?=
 =?us-ascii?Q?RsSzH2f2Of5xKkJSptox5RaPfLSWvJxowm5hqnC4O0VFsXPr4VxPLsQuCRSx?=
 =?us-ascii?Q?CiTF88XujHwCPf2K5Cd7cuKerVoeROYw/CidgexQSS4xnlkwjONyv/UtyYvu?=
 =?us-ascii?Q?/i2N2RWuel/LtCX0CEIrG/Xb/dNyrKAkRb20nIVPymERtaETHPySuF1xRE3N?=
 =?us-ascii?Q?SBbDijITQvtYg52U0S3T9QepPvVaf7yEy88YOxjhsil3Rb00QTgekkQOGCvr?=
 =?us-ascii?Q?gUKl4IkGoWAoq7bixltrGgAO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5018b7c-387e-462b-ec7a-08d8fc5020b3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:35.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLJEU2uimz204JlYqVO3UEEsyeW7tg3A/p5XWJETezgZZRV+BR2sQNV61k7BkYml3sbbIOWhDec/jdKx91ZGnf4cubt5TrfCbEcnVk6GNQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: usY8HImPDdP1oCA_oCghbK97JmY77X7c
X-Proofpoint-GUID: usY8HImPDdP1oCA_oCghbK97JmY77X7c
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi.
We now block the session for the drivers during tmf processing, so we can
remove these calls.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 84402e827d42..f13f8af6d931 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

