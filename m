Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BB8C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA60D64EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhBIMkW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhBIMj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CY7U1047664;
        Tue, 9 Feb 2021 12:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=T5zSD8qo191UlsCAuxlAcPE/y3JaSiRJjIgMFsvXhIU=;
 b=SGSU7K5PYdPDmZhdl+YWDcY2pPxLMm7CYYp9clGCIseNurocuX95t031/kB0EVhq9guo
 I6VXUC85I2m8H29ThigdyofvjJIqEz9b0BPj6L8pXIMhq7zXCElS4RSWoqPnPmyPoIRf
 UsrvRyVxEwxuuOKFei4V6uSm80Os8EMHBd/R29RMcZ9CreMmPUyCixjtsYzTcvBXsS5I
 +a2JmGTGyyhq6Hzp7O6SPex4i0x4v7f/A6NhwOGm6bPErfVtqKRuEZ8So+G2dD/zxhft
 jckQdDp7wU75ggvFs/2BWF/Wpv36x9UhAiVsln5+H1z4Ayl9Y2v1z4o1ClcCYlnsOFKK NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrmy8cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZEqh034098;
        Tue, 9 Feb 2021 12:39:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 36j51w15yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gf2CCaMDcJxDBMnfbudXfn018jrqkqcUUaxUp3hpIOAfJOsCRXLvc7T9AUV5sQIXKtwo9YKwdcyUXYp/KNA2TdbJ2ntjKndmErRmn3N9u/EoM00O/wW2XJAg3HAN8vH8KfHgpYbrlpRgbze/vabCKKStJISPC6fuGV0klZFU1nFmHfSPFUQlvUwy1jE9zJ9Blw+6MpfBgVqY6pSUFdQTCxu/vqyIBeSpyArT1zo71naqzy2MhKjc45gUxbsCFtY14tuqGT3YhPV3Udv1PsdWuigfvpOWIfD7WdrQ9OyZGy6xfg2biSbfLvArsbh763cgds/cStUtarJCQzou+QEqoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5zSD8qo191UlsCAuxlAcPE/y3JaSiRJjIgMFsvXhIU=;
 b=QC15mOvue3X1qoNT6W+fuQZNrIBNC8UMfhQ7zjQWAU7gxVdMChR0rpUzY0cGBMqspr95vwD/IXMuj/lXjxBi26a43O/EI0Bba0f78sdLUtDNiYb9hAtnejWz0Dq8uDe9KETi+MV7sldRAeImdnO9VlpJ/riBG6gZHB/yEsFO9SUhpi1NZYLdNxTPLr/BiYJDqANReWF6n2AGKeUyobvSwpy2+T0nd0BCJ+TKIs9wtarOFYLVozGg0I5fsrwyMtAKFw2ZlTKiynlN0EE3D2t2QEwXIUUKDWiyEQmTtiGYhKL7VoCEYR2VvfyUC0cNEhQ/dMrw11dAypROUEzjvV/AAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5zSD8qo191UlsCAuxlAcPE/y3JaSiRJjIgMFsvXhIU=;
 b=EF3EhD58EeOyUyS0P72esegUTdDC9/xlrce9WeX4PDf4m0bFeF22S9Z02muBNl2ds8R1LHG7QRVxsvwMuP3nmMM2taynK2l6FlCejZeN4L7xWOThyqbnTBL18tV+BnCQc030Uj3QN8hkO7axNFDW9rUQW8VPUPs5JyUTfudQ9l4=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/13] target: flush submission work during TMR processing
Date:   Tue,  9 Feb 2021 06:38:45 -0600
Message-Id: <20210209123845.4856-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f922750b-e646-4d8f-e316-08d8ccf7b274
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600C2B8ADFE9C997FB48113F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOmcC8u9b/00dXrA2hMcTceAEeVfUw02xtOIE320htcVaHreyEfMYR6dmZ5Oo5f1LZiauNMEkpB1hgNEN1OjkkXT/q1iNLjzjIxtvXXgzbF4jchQezaq0H0fDw704hsTCu8hGqNXUNDWk9MlzqujZ6IR/RLJ853B9Y+2R0l05spCaDzLFatBm+zFdrp/by6pxCkyVjmjwtW8QgHF2/gfFiUapdlfXW2mVrQ9fzwUYXmIlYyTOpdkOIORxw/lPDAKwEV7eI4SsqkT3gSaja5kSQg07jYxK6JMaGB7IOzW2L9yAhd/KmXJ49T61c2JSgJIcoHIncEv4ZZSwVhT3Px4/243vdUAlruy6PdqeVDrZEfh1i8kjqRen/0CTyaQkXaIS/dVctVS/E/BMI2qhdTsHlZZTgVDZF1b+wQIOYFxiowQmyfaKgvBj1aEcCKv3XCqefkGzNHLNsyye+oVngv1U1cx3Ee3UvSXdYvtJza6QhTO39a/efb5mfYDA/fVTkQJcA2UAOFG0ZQVINWFWxVcTm1n8XT1s3UMRWtiJ7CfbRpoESyvg4nXw2simWniPXDN9MxXYX8/xqwvJVZLPtriog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i5Dop7nDRLfhzq6WUV+0LzHtn92LNBMC4h+H01mQ3r0wgUn1ahRyPLNlN4+2?=
 =?us-ascii?Q?6usSbLohJQLpO1FyrAs6RCgucFim5opLC4LhDHvGRWwZz3rEODkSItZZEis4?=
 =?us-ascii?Q?olPTWWTM9wlQjUBvT5qdAvXm7sMu00lPOKnNgaVG82jg/IwZxPZ4Zm7Vd2Fd?=
 =?us-ascii?Q?q/eZHvz+Eucy5eSnc4mANJQxQMlw8qRHQtQ7/7f/KgrMC8X6oWTmtYjX76du?=
 =?us-ascii?Q?LpLHe/97koeIfIv0Ss1vZ3CCx3gW+/1Xw59fJqvPPpE7Gqi2ifu+C1DTPRz3?=
 =?us-ascii?Q?H/VzRVfnqrwPUmANAVkktHTJMvCjjVXZeODWONmJmLg3AihNvD0v8a5S++tl?=
 =?us-ascii?Q?uC3zdSYc/5JANZt0UzNfPmLxqeRntCHKaB82g0of4CewzcF8QGldY7nNRoZx?=
 =?us-ascii?Q?tehCkQEaiE+f0a4I6qdgLlXrnfzPp4ZXhcYIEo94jAw7UN3Ndu/wH4a6CrrO?=
 =?us-ascii?Q?vIbuZqwRDQ28W1aAs0CMpAazU2Kdt42EV8Np1Ioz0oyROZta5c0QLcCNfHaU?=
 =?us-ascii?Q?OlXPywYkaBMD8SO4XD9w9+++EI11kTbAMVVl7ZmCaGxERsChNjSq2r5P1j+A?=
 =?us-ascii?Q?87xHo7nAftBsjD49Yyutad8IQvFnW0Hm2FmVnuRRKCgaC90X9FKNg7zBh0zw?=
 =?us-ascii?Q?srCtpKiU3qQz0fn0HADZwkJewFkx3XOhGxe7f/SSGivyVclub/gpkO+VEHSz?=
 =?us-ascii?Q?acD1pcc3V95v3q5jN5A1/HCsFimbrAhq3dFD9CaczbBOpRUVSfxLpnxGRt5M?=
 =?us-ascii?Q?nDGxrMoMmZ7mX7KE4DAg4pyk4hJtL2cUWORsiBEZIlOkjGhleCx/tKE2kc1u?=
 =?us-ascii?Q?xFaQy88f3KSGHRd3f51vIEj1km2w1C4m2RYLv0q8VqVhp00UgvtQQbmrzsHk?=
 =?us-ascii?Q?9a4DiKCyMsCY3n2O9o4Dq8Jvet072wjQUXlw1gkOufwHjCNLdCLuzsuCxy89?=
 =?us-ascii?Q?nh8HTOW9qsV7X/rxYL/Iv/NGmlZjsrdJycsrouZ/PdVGSQoV7/BCpXDBcdd6?=
 =?us-ascii?Q?T+g+Y3y6P7998z7oCdR0jxjtjrDwm7ZYVUWiwTCdz4Y7nqobDaqTfZvLc7bN?=
 =?us-ascii?Q?cBsdUDkyZy00/Z1AONf/6lRkAtpme9sDgWzL4ErwHbZxiP1BbClAWBQ5GoF6?=
 =?us-ascii?Q?ZyNCaN4fqTSdD2t2FmDbcEhsRCkuOuci5qkhvOuU/qKESNX4gWlsH4XQRzr7?=
 =?us-ascii?Q?0YulcLMaqg1RUFk5UMzaWuXIf/vhY9FDnf9jXLODwgLZUO17OiZq7DRJZoT+?=
 =?us-ascii?Q?dwZrTdM1tDnAIEP9IgZ4Vrw/ZCVqCKfgEU7hNhpFPmQ4nHRLe6Sh026zjoH8?=
 =?us-ascii?Q?0qWt+ZTgKtx/UZ+0HewOv8Uz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f922750b-e646-4d8f-e316-08d8ccf7b274
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:09.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1FmfDFEXfzdypVT5vsG1c1ctjSeRMAFRdje4/7hBHcY7NMcFoIOKS5TyMn8Qwr5qd+8eMuJGSIkXWMLHC9o5EBcnJbN6MOHh5J3a3cfyZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a cmd is on the submission workqueue then the TMR code will
miss it, and end up returning task not found or success for
lun resets. The fabric driver might then tell the initiator that
the running cmds have been handled when they are about to run.

This adds a cancel when we are processing TMRs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tmr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7347285471fa..9b7f159f9341 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -124,6 +124,8 @@ void core_tmr_abort_task(
 	int i;
 
 	for (i = 0; i < dev->queue_cnt; i++) {
+		cancel_work_sync(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
 					 state_list) {
@@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
 	 * in the Control Mode Page.
 	 */
 	for (i = 0; i < dev->queue_cnt; i++) {
+		cancel_work_sync(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
 					 state_list) {
-- 
2.25.1

