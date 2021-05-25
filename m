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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F5FC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BEFD61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhEYSUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhEYSUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFNxq121918;
        Tue, 25 May 2021 18:18:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=TPmcXQEoukcnwhNAdBJ13KWacviGJhwOK0DP4i6cDrWL378hys2kL7ZiCWSVM5vzKRjP
 lors/wbqk9zCT6VRPRWkHAfHCn8DW1ATqvqtNqP0sPfNPLtkZYx17OS5sZ36OrPJrHwR
 14/H8o6/dcmog+rv6oMDPQeWzC3aixp2jjTEVK79yCmBjrIzUveEs+TW4PPPZuF9UeBM
 XlnYjT14/LB86+1HvQ8ok187q76MmQwzunbl5yR5nHT6+i2YSk+wxHzmLsV8wdN4B/gm
 ivcWPzOuSyL02vkJ0CutVS7JpPZWfvErmnjapxnCs7H7xmFKcXovkDU8EJPJEtiF9PSV 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xcvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEule166263;
        Tue, 25 May 2021 18:18:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eggpDnM+bvbQxVi8b+OuFnw1aHEZlFbbOA4ITidLYQukWr27VA5PMpB8ilho9p4NezqsuGKga7sVOw+CrfiP4ThgpMB2oqF4+NfSIQf7bPGZrRQa3+xuK0C9ID6Du1hKiAki1b9htdLUnZ88RMIg6d+8KkurUqEJv536rhmcSTiZXAoU4zPHT5+PhJksx9eKKkr9qY9PbbLTAi0Nfdx0bNu1stn7BJ+qrCyrykhVuJNP2pkIT3Ly/Iri5D9dzkKphkWQ8ouuNptxu9Y40FpMF42T9Sko/Sp1BRldfsFkNodmulRitcqASeu5CKOnGGfdeJFnk+tSW3HkhitfxPtZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=U9nLyyj7FIG5+d9wIDTzgORaYbmum5q85Sahw5gY3IEtw+14B20LAbzjpCGh1bFjEid2TCfbjoc4yy69Tv6T8JFRRts98z4LrPfETCozMngJiB7pTEZJABIGBi42eYjz+4oHU78j37t6SVQl4zlxaZ5lC2S9Swa8/hw3dzuriNM3e85RHDW2SF7cPnLnO+b0wojPHre13jR1ZwFbbXt25evwjJQgaGp7q+dO4TAYn5u7s3D4oZzgIiAo4hnMaPesUX88VjVvfIumF8CqOm0jhwHHHpFMdqQt2BFhlfZV1fuOzQ+lHzO6m8k2znIRyQEyfdVzsV7Ptd82XEwZKPLjSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=dUVkcsy621uU/jM7u9IrtBT7cxJOXAUI0Ru7GQ29Mzk/sYNqczrQsR12gAcx2+HeIwhrRzC1jWnLAuVHcncdO8GbTLNIVHiAQRX9kNodajWfqYFwRg7S0UXI2zpGf3Vx35IRL3isib5ly18cG6oIaPNjhthnfpt63hGrD2Ny42s=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 19/28] scsi: qedi: Fix null ref during abort handling
Date:   Tue, 25 May 2021 13:18:12 -0500
Message-Id: <20210525181821.7617-20-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7a4d75d-022e-4143-af7a-08d91fa98b2b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891B5FB27A42BEC84162262F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM23idm52MwxTYuVECntGaMO2VxwV3y140xWYkZ/63j39trxWuLSD2O8519lMIGc5ycJ0uY3h5KV2aFnebUssJdm98A7fpSDQdFbrT4wDMuxV6doqt40vcl0PsFAmEiAwVQlBDuFNuwZviinQSe0GggKMsO7EvS57Ss0vXd+xY87RCwadk30hzITBEMBwMIL0Uei+ORyqGsK9Id3/YWJHXP5idXH0WWiNHLhnjAxc/YSGTxVFUWuqAFX2YVbgzeBGWzWkhDP6PzZEGdfiaZYxWYoxNQ/AGRy3vo1vtzrX1HiUiehWBUZ+WoAkqUHtugD3KgxBVGgZ1KmUKhtU6SdFRafUh9lyx9Dol8vw/eOZ233S3uFmwZkLh4nPXpLfWpONoyd8KKtQXp5chZamNO5lAcCK/tK9YzAiHmxBzj3D7tCzZBQgcM1xnSZBj9Imh4T4iDeKE1kZAFwIkl9mCx6ZQBYYyWVWNyaj3ytbgTQVzSIYwRD3cWBMobhs3R94NNrNSDUlQEHND73EedQBiZdtZQNAHFp3vesRJS58EWz7AJDDwbGUuzPC5dTA0/xriQbxiPx19sySAtcITHtqqLdl0A2f40NaZ6/GpPAktpw1GTFISivzICaCyNFuF8iVuN9Qz4KNczDyy83CKUtpZs6qb+tn+hmQVVahK6B+aWGXr7WQKym0k/Xhlt2vXkpSZlu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(4744005)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pFW29A9kv+VPA83t1KGnX/E9AYt6R06fKE63wyOkg78t/OWKtxsCmi9IYrI4?=
 =?us-ascii?Q?NFKtKl6wfLfFKwNj8BjM4A40QWWA3ofrVHdOpvmGPsWRIxqecMUNPDqkPjXf?=
 =?us-ascii?Q?FYzV68dppW06+dwQVHiA8+kjQLXWvIjojPLeL7vg5fa8WIHhCIkA+5afq+Al?=
 =?us-ascii?Q?wwRngma9iv0Zt40yiE5ojEcQutwBPzg2fFPwWpZDaxAj1qRpd9Vaem+mHAsV?=
 =?us-ascii?Q?5iye1ExKzeSSCjfsLt2CKyIchD/LjoRQ09uSftZ/3Dmo3mpQNZWnn0lrZog9?=
 =?us-ascii?Q?v/+3cpTUhCNa5BrD4DCGX8FtmILEJC8k62oqxkbkgINzO+uZcHORUygXqLxK?=
 =?us-ascii?Q?tV3ZYVhfcQ953x1Xe17Fud2I5yXZpTaM8OL6tWkqoi5ySIU2Soo5m9DMti8A?=
 =?us-ascii?Q?7asqWwPjiq5fDilWK9QauRuTDQ4nYg7364MTugDd0tdJo/7z6NH1KjPXRQxK?=
 =?us-ascii?Q?E/xsfSoiGh0nrbwIDNt6AIT4ZhxQIaIvVvMgTAc34mA/+4dZSVxLW6z5VO0t?=
 =?us-ascii?Q?1bTfmnGfnay3glsYdWYQuDl+dS0fEgS2E8Jqed/I8HEkFQJ2ScQFENwcnqQq?=
 =?us-ascii?Q?oXhuNncsiW3UMlQCYBl6upqN+EEcBSFyktDDVCy1TDNmLgfRJClfhvi/UT4F?=
 =?us-ascii?Q?worr6jCiqgZsixlnXSbKfSAlGVUBfymFfHEitj9CAVGS/XxdPyXadE1yymJh?=
 =?us-ascii?Q?qFlVkyPGdRLQG6ObZyITW5fVCqDqQfkvwuUx92cG4I2GgJFW0PbCrb+N9w6X?=
 =?us-ascii?Q?bozl/20HJyK6KcKQJ5URPHROoopkVaCMK3gOdI89+CPSY4JGuRAvyw0WObuW?=
 =?us-ascii?Q?P5RaXrNeQqLg9wm/oiorSYlE3zpo3eF3+VmTqSy7c7qoMCu0uLhf09QTXtbh?=
 =?us-ascii?Q?q8eBlWC9/GNiUtGnBqGHWa6RDVLakp1M4e1L21dMCsoKNzF82ha98tgRO1kl?=
 =?us-ascii?Q?i/aNh2bWKXZDV4UVv4WhsNNEroy9WKE4IESMYkH7Pp4GMMHmTdo6nONerDA3?=
 =?us-ascii?Q?D00hcNqB0vgf0i38UtIpPHcWqa+vZHpFACF4HjwS3hW8Z2B0nM/bpaAa0ZxO?=
 =?us-ascii?Q?7EAhBHMZEumbDjeaqJfEgWc/bbjOMmTggOFMQPrr5fOq8j2dwpETTRM+uAb1?=
 =?us-ascii?Q?3LKk+PgVxXYZHFB4VJ8pOTrGaV6koK3A1+/b5awuAfrZN1Pe+5TFj9H4pDw0?=
 =?us-ascii?Q?0FllDmZYFx7m0NPTGAkk+j2IWeM11pSLjWYjg3LMM1dDzGzX/uFQcpOipjNt?=
 =?us-ascii?Q?rk6pkgkIA2xy7zqUn6UEzvro5I/9t9FoN28F4x5Qg2S0RXz0+KM1UsX1isu+?=
 =?us-ascii?Q?HuM48Nvuj3pr8AIXEvqKljLK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a4d75d-022e-4143-af7a-08d91fa98b2b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:49.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFHaqMPAb08oeBhlkgblLwn+eGOhfxrkKZTv6G5KylZ1HKzMPSb+TXCEBr0NtJ6IpKzNLlIgOKkkWVJeHYOri4npD7eJGZQkaFY+Mbw1OUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: B3GR-m5njXZ6VovUQYdyQHfp6h-2bwJG
X-Proofpoint-ORIG-GUID: B3GR-m5njXZ6VovUQYdyQHfp6h-2bwJG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.25.1

