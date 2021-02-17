Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C679C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3950A64E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhBQUez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:34:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhBQUby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKT4QE122959;
        Wed, 17 Feb 2021 20:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=RADSiTgy247b4heXs3WDAB428MrpmRqtBp/OVbROoA/RhUHX1rfyHF4NKJlbIibo9rz3
 kwonGSareSKNjj9Y/pNpaJYiAv128ulb4uZ7cV5A0FSvY38UFbuW6ZYDSF00PUh+69A9
 BufzzJsyHkUdW3EL6PF7UM8W/Ck7mMzWnW761BK6HAhOoabFI0W2oaruep9s+TLMd8QR
 4dL20hvyfhBaoptPit+V95HwhvWckzck18FkeN3JN43xTEBY3shwufqdn1iGyWebOYo0
 ZJunK+RCf7oTgoBd71vbYmMHes9N7V2DXgGIP81x+Wpsrx0N4lEwuakRzO/YfV2WtaVI Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r3sak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPbbl113321;
        Wed, 17 Feb 2021 20:29:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 36prhtb5x7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6pF9u8k5thzbYuyUBqR/eeGXvHQVETMUssutE/QqG9275E1cMRpW4/Fp39IjlnnMrS6LCIHPURbfm+6tbt7thw3PpmcT5LGH2VZCoxSiFrojIwMkXYjNRJJyUgYlda7X5In6RV7nOONhJpYwJQrIFFXS9vlnoFyuxTbaM/eicCqLoRNgTFMbNhTDotLMQhcaVgkXl5A1j4PT2NpXDnWSIlVeQvTzS96INM6WJbZzYirGB41jAzQOp+uRUuBR9uvK/XVPeXNZ7CZqXAIj95K/RHGwqurGDLLorAjlT8syiUysGjOS2FDz38qTo9t2xaxTsVpCVAv72eGlaTnKJf0Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=PQzwJb2SyeHMmR8cDQlXQ5MOusxqGNNv5Qib2EBsk5uqQYviwrUNecqbnlTQkxUxS7osRebnJZqvYouyeHaI1mWchOpLMBGZF/JkIimMg/sir5qpDl1bdBvbSyO+fiquX7XOFrVjkV1vbIor3Uxu++m9Rn4emtBa0X42F/Gk47DRStHvS0bKngGS6R9xTnk0qYBtapnP5ZAewlJ4kIic0v1bFYTaMgfApUkasYnWRnYqAp1dCO3zSKdvWitdb2ErG6So0uZUUsQrEuGGtHbARqWjqXP1c1firY7GhzLHvcL8VSy3TsIifoGzAFAIVjtLIe27upDY/2wEI0ZVqGkGLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=shkebcU0ap9RWqiPrfoclXgQ/VKEUpzt70z9AHeIS3aILulS4+N6zLcpSiZyvbCdjjPP2ksmd4c8XJdUvWEp48Io3zAJk5GT9+5ukLWdDdmeCgpn5sPCqx/RepeAiB4T50jncBno6nNWp8YVp3lAmWgybRdBAPpb7GOx57YTsJk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:29:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:29:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 22/25] target iblock: add backend plug/unplug callouts
Date:   Wed, 17 Feb 2021 14:28:08 -0600
Message-Id: <20210217202811.5575-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:29:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 660e98d2-e01c-4dda-3d22-08d8d382a9c2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3940DFEEE0D8305F884F8C93F1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGOyfvMoGzc124xJGBIUUA8D4PWZfrlB9VMrHQaEER8pECtkOkNaz9DjZsLvPgkhK2zMXd+KVLXyn95HG08u//Zp3RyJE4GLcFHK3t/UjE6JqLODXFhaj20FMdGkp5m+qk25nLKEqXDmKFciOfq87DSRfMytr4ppgULvYT51kRxQsP+3Fsqi5J1rkxc/ScyUyXzhGyCrSkPsYD1Oj4fF0kxsHzlpHKrzvelU9IWfKeDgSKhw+/q3NEXsm/85l3BJCpuqgfQHz+iEb/77T8jZSipHbZ9kixfopxu2Mu5yp5Ape9jJE0MOI9uX6vBOe0kDaUtjysV3EonOSCHuM7iWDPKlSOJeb0O9ELpnhRYYrrth9lb09oVQmztFiQ487tkQG/kEuLHt8JPo5apm0XKExxR8iuhBqMl/qJPYNtwgB57Cv/nBAVE2Kd0BkgQR6+Xn7Mz4l89e8B6Z95cU905DfKQfcAXizq030dFGsexsrv34orYvlQoNWa0Y52N6BefRSYlL8sJZ6r0ZzCoGuwPtSogr2BoKJPMO6wdfze1195mmZ2SbUzuBRJJ2n4rBb4Hb3zvym7VfFAag6VO7Gm8rkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eE4f4PqMK9pTKoG50suNoHrkmGcc+TSAwasjWJC+J1Xy4LndUEw+j3V7iGxE?=
 =?us-ascii?Q?0e6GC8RlAskoVDdEyO/BmYUtUxVZx1tQWcY6uhlsqgNdF7AfgxpQjOeEEaSD?=
 =?us-ascii?Q?DIEuZWv110GwW/CgggtB28fPkyKDiuF7nm5hgxGUjUX40lwKt8gyhkl3S3PA?=
 =?us-ascii?Q?H5KYPqvXXjfoHuxn00E3UEpvx4gN/SygKTYwu7TCbSzO/Xj5EA4pQ60nstz6?=
 =?us-ascii?Q?+CpvzK3tOUe5GuXaE6LNpyeyEKwT5gyG4Qjsi8iIjaSnqCQUKxDlw/6CwNhB?=
 =?us-ascii?Q?K06WAegOqpjgbcxA1NoBPimgg4PSyE8IoPU8o6fqu+mUv/VWZ0fxlryIzl5y?=
 =?us-ascii?Q?xqwS9EqwOMts8zW4ifZ00U7v7EjyLWtfCQDN8Ou71o268JtO443WSPxWy4EO?=
 =?us-ascii?Q?/7GcZ68gCWMuyJ4g8aTbn5rYtqUSOy+JvoIe2nS/7FWKvji8NpbyN98CW/1h?=
 =?us-ascii?Q?BoRlOm34H680Rh4QrsY8+dgEuPD5XD4pYfkDBnClwHqK/foB5AbYdisQc519?=
 =?us-ascii?Q?8FQchaXuRjIhNiTIC05cAEmUYsmNv0FYPt2OmsHy5mJXTowyl20pZ9MaADaR?=
 =?us-ascii?Q?GX8l161J769Hm+Ovro0j/sVTJbvcAzPAASM4LJD1yw923p+ktmuS804HsXvJ?=
 =?us-ascii?Q?Uv/TkovorOBf2QyG7/KLj9Apqd2sdzl8rg1YfmZGkpUkUpcrRwF77eB7ItK7?=
 =?us-ascii?Q?QQ3YIIVuRy9v93zXbovhqDPE00EYG/OENysW8cYjjB9Hb2coKnwEt4kU4kxH?=
 =?us-ascii?Q?VLMYzvMKuxpCctXr+m1X252HiWgT1CeCU9M5P5OkOTm1/+JLTkBOYfz1MLmF?=
 =?us-ascii?Q?oOZbnz5qhJj+66a0zFYEv2gpbLumSwTXZbp6DrOvVfTQtVM9O85FaEtcEf69?=
 =?us-ascii?Q?K9TdLxSu82oE97WgeVS/tc0IDcKLTB1Qwy3OESj5FtbT9CzdECvzJSxp2LkP?=
 =?us-ascii?Q?M303ouoIah6YcEMJ3rTiCsYtYyilwjl1fPWtDwSclwr5Xpo0rCbor52RWJAp?=
 =?us-ascii?Q?ChVfkMtiJa8GrTIfgEI7g/lL7d1Zaf2Q7YhOnPw1FIxytfJ0ok7acl4mVK9u?=
 =?us-ascii?Q?Hu0UOoubFF4ErXOT0ob6wvso/4MpYkfXsIc1IpPX6jCjylyrv1dznrX+rsSU?=
 =?us-ascii?Q?fEDc6E/rVN3NrjT0Je7P7oI1m63inJ885ui/wFWGJoXbqg43sJXyGWzQ5mjc?=
 =?us-ascii?Q?/s3nXR8PkRmxsXW1UMlrCLKDWLm5He9anMT+2o9w0mCgBYd0QfOadtekaZ3w?=
 =?us-ascii?Q?xf6qkRKMjXu31W6V5El84VHiGmieqvIGphSSG5JSDLQBxS+JTh/x6xfnmt7K?=
 =?us-ascii?Q?B3wH/Iu96+7o46gblevtGLfx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660e98d2-e01c-4dda-3d22-08d8d382a9c2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:29:02.2502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u96NpmzAgBZOm1ORvNOU4Us/69IybpMzfb4gXFztxzdPlwVVh1sOPaHF/CYtBrs9QwOXdNbyFwK9jji3/QE6qQdKuhYkAn9GJhrGVENQSj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds plug/unplug callouts for iblock. For initiator drivers
like iscsi which wants to pass multiple cmds to its xmit thread instead
of one cmd at a time, this increases IOPs by around 10% with vhost-scsi
(combined with the last patches we can see a total 40-50% increase). For
driver combos like tcm_loop and faster drivers like the iser initiator, we
can still see IOPs increase by 20-30% when tcm_loop's nr_hw_queues setting
is also increased.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 44 ++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h | 10 +++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..33c88eca090f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -61,9 +61,18 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 		return NULL;
 	}
 
+	ib_dev->ibd_plug = kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),
+				   GFP_KERNEL);
+	if (!ib_dev->ibd_plug)
+		goto free_dev;
+
 	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
+
+free_dev:
+	kfree(ib_dev);
+	return NULL;
 }
 
 static int iblock_configure_device(struct se_device *dev)
@@ -171,6 +180,7 @@ static void iblock_dev_call_rcu(struct rcu_head *p)
 	struct se_device *dev = container_of(p, struct se_device, rcu_head);
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
+	kfree(ib_dev->ibd_plug);
 	kfree(ib_dev);
 }
 
@@ -188,6 +198,33 @@ static void iblock_destroy_device(struct se_device *dev)
 	bioset_exit(&ib_dev->ibd_bio_set);
 }
 
+static struct se_dev_plug *iblock_plug_device(struct se_device *se_dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(se_dev);
+	struct iblock_dev_plug *ib_dev_plug;
+
+	/*
+	 * Each se_device has a per cpu work this can be run from. Wwe
+	 * shouldn't have multiple threads on the same cpu calling this
+	 * at the same time.
+	 */
+	ib_dev_plug = &ib_dev->ibd_plug[smp_processor_id()];
+	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
+		return NULL;
+
+	blk_start_plug(&ib_dev_plug->blk_plug);
+	return &ib_dev_plug->se_plug;
+}
+
+static void iblock_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct iblock_dev_plug *ib_dev_plug = container_of(se_plug,
+					struct iblock_dev_plug, se_plug);
+
+	blk_finish_plug(&ib_dev_plug->blk_plug);
+	clear_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags);
+}
+
 static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct se_device *dev,
 	struct block_device *bd,
@@ -337,7 +374,10 @@ static void iblock_submit_bios(struct bio_list *list)
 {
 	struct blk_plug plug;
 	struct bio *bio;
-
+	/*
+	 * The block layer handles nested plugs, so just plug/unplug to handle
+	 * fabric drivers that didn't support batching and multi bio cmds.
+	 */
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(list)))
 		submit_bio(bio);
@@ -870,6 +910,8 @@ static const struct target_backend_ops iblock_ops = {
 	.configure_device	= iblock_configure_device,
 	.destroy_device		= iblock_destroy_device,
 	.free_device		= iblock_free_device,
+	.plug_device		= iblock_plug_device,
+	.unplug_device		= iblock_unplug_device,
 	.parse_cdb		= iblock_parse_cdb,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index cefc641145b3..8c55375d2f75 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/refcount.h>
+#include <linux/blkdev.h>
 #include <target/target_core_base.h>
 
 #define IBLOCK_VERSION		"4.0"
@@ -17,6 +18,14 @@ struct iblock_req {
 
 #define IBDF_HAS_UDEV_PATH		0x01
 
+#define IBD_PLUGF_PLUGGED		0x01
+
+struct iblock_dev_plug {
+	struct se_dev_plug se_plug;
+	struct blk_plug blk_plug;
+	unsigned long flags;
+};
+
 struct iblock_dev {
 	struct se_device dev;
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
@@ -24,6 +33,7 @@ struct iblock_dev {
 	struct bio_set	ibd_bio_set;
 	struct block_device *ibd_bd;
 	bool ibd_readonly;
+	struct iblock_dev_plug *ibd_plug;
 } ____cacheline_aligned;
 
 #endif /* TARGET_CORE_IBLOCK_H */
-- 
2.25.1

