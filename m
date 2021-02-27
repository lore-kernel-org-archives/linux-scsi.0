Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0ABC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2435B64E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhB0RGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:06:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxR87078351;
        Sat, 27 Feb 2021 17:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vlX6xTkUTzqjxWOhaywa5aYgPBH03VRJJE2/sySbgOk=;
 b=hzdKZyyBLI/ZG06xZb4FuipT4PeJ4ORKL/w6xM+6vsFO9MBzMVBtXbtdGSkNcGYbRhSu
 Cpk+rh8pdFhDpzdQY2+VlhTajNWFQKMJEnMNPUx5Y/9sYrjGyPfGNojpC3gi+4qSUbYy
 3gvA7Vtx6GHRAtz8QhIzvyUJBNZW/v04ehBUFYN5PCiUiMoUOqIO+NDEOcY5cj0ickKY
 uJElUr2upbVOK8fC9os5QwCV6zf8xyTznzaOxGXeeJKD4vM+6kKL0XrulUk9wVD72Ndj
 yHZVJ45g+7dlh7nGnT7AX9Dnk16CdtjSxiLBdax/TmvS1guMYseHiREKF4HxRoK1b6A/ 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36ydgr0rs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbi173209;
        Sat, 27 Feb 2021 17:00:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvOviQC1YGoObEG5x7p5QZE1qO6Vvhv550Emgs4GQu0QdFcQ+oeacPP+QiZPjLCl7vFJqXtxVDMbRuhnuOONpfA48P/7MNE3Ig1zS1BKI6CNEsuhGUzNJp4eb6iaHY35bJmyJqA+aWtLgAbL4+Eq5J1yQsQnl/6Zq2v0Ude8o3ekOQnIM3pyOizauahJSf1emldoE57YkxG4Zy12t/ABOzyWC5Yh8Acz0DtXIY5Phjn32TCaigrcDjX3nYP9LqEuoiPOPNbz+8Fj0ud+9hLGhF/uwnJ/5WqPx5bBCqoTGLuuHlgTuVIZcfpWWwqcgYSdC5jqBkiuUzZep7mD0wH57w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlX6xTkUTzqjxWOhaywa5aYgPBH03VRJJE2/sySbgOk=;
 b=IZe/NmZy+umh/RTs7esQ5tjTiF8u8KIl2Tiqf6VrUV6ZI1Z0heqSbib3j59aSQoVeuquueuhcnFW6q3sep4/ykZaJhhZkjq+mDzH+Xywy4AKXnt9VYq0IiOp6ejrOfz2Ulj8/q5ZCMrQ465KXFufqATc59YVaFCvWABlmFG6A0MeCJ/FrFD5euhuGvtIPQG6O6XeNwAiSe7Cm69OsHeTKYvFDWEqpTyIceDnVkdgD3CPSsvoQCzp+7bktkv6U2S3KxFXedNCp30D318gYmd7Ye+AN+ZG/CdYiow7/mjDntgjCyjYvJlFdcP9ABO0qkBB1035f84RmO52i6lnt0RuEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlX6xTkUTzqjxWOhaywa5aYgPBH03VRJJE2/sySbgOk=;
 b=bI6tVWkt0YBXEVS4oSBDeAaEKk6OqHqDPZ1DbugLZCw4JOz9cghu0Wq7aZC9MmsSi2qHQZkggCmyO1eIcrJqibJMhgN5WxB2bbLciMLrVJEN22efWztjkPFQjtkmFY6lZ572jBgUvIjJpQlKJPXzgTT94GzSLW3Z/ywmw0tNXFM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:32 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/25] tcm loop: use lio wq cmd submission helper
Date:   Sat, 27 Feb 2021 11:00:00 -0600
Message-Id: <20210227170006.5077-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b393123e-8333-4856-8aef-08d8db41315c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB2538F122E5A60DCADCE7063DF19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E99IC9DCqFSQgN2KUQIY2mj/1L3wTdSy0DdB04nK8gUsHNtW3V9dBfor95J/N0tIWKO2ieIMDmv2BtnJG28KBA4P4yXDIyw5T11JefwlI3U/3uFxo+epsDVPzrVxycxYWA5taTdpNfDSKi8w9PNkIlKVHAYMDU52ubqPhwm77nG5quJQkyaQGsDXeRmBi2Z6GyEGJ+G4Ke2F3/FuitKjNkkGUgdp6JiiA3fq893x8R9yFlnL2WuBFayOse6cp1oguV8KCKSR0ZW8GM/CwO/O+4ey3Qb2/YFuwgUTvIgwLTXnDiwRYxKlMnjljm8qtLyCiuDyAat4I9wWi2Jn5xyjg0t7k2q6/8D3rBnvJsbQN8tv4KasUtetFUZ08vhM2wLxZEhwPeeCG0HuKZqLwqyb6Qwl65gfqsNXllc+fejxwmuCd/hODcXUVhpBF3JU2Td9jB7CS/dhYeD1fK1+9td0/N4ZwVdc4eQcCuqkwrQ+enPFUOqP5VifJa01JcWRQXh2RCyujwbh9m3zuJSI1F5bWToPSzqJaUN9tCoqtiIywFK4gAom4MPAG7wj9PD+ZSc6jom77mg+PBfdM5EMprU+pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jQWDriSfZQahcEUCUSnzHYlzN7XrzxyuKB8Xsp5y2Nq8X8PzJ3C/6+nDLFNS?=
 =?us-ascii?Q?jic9cZJkDiIWXsS+Cx+ILe327mBbb78CRwwzy960A0KB4x/WCJtlYgaj4OLa?=
 =?us-ascii?Q?vSIfpZoUhRPIYq0nztuJsvQRIVTDDbcO/wS4KSs/3s+6/2BHv8VhwJ8EtXGi?=
 =?us-ascii?Q?WbPYOHXjZKiY8TQhINpvgWgPVA2hytB2W2dz60e2IxYQm+lK/ivRbL5JSee6?=
 =?us-ascii?Q?qPvHMgEzAA5w5Miv5d0xXBpsmZuVLA39uGhvdCcPSi/ObrHZA3oAps7wQzmF?=
 =?us-ascii?Q?NZ9lxcLl4SklO5dVtB3c6mU5ZWifMD7E9p5oeukCb/dfL/UfmpLrWw3u2Of0?=
 =?us-ascii?Q?tPgtAdRRaUNdfGhodw3nLyfY9uUwIYxgwSGfnMYtYlF3NuLiSgqwiIxwWkvM?=
 =?us-ascii?Q?M+pTJRlgUkWc9f88T3isiiCL7tTuKOEKmF22N/CiZsAX/raUS5/EL8B8SfZf?=
 =?us-ascii?Q?1rd5O3AAZENUfDqj7sAdKg19IYaz6xl59mXd+dqdjIL520WwiOEDhz5MOS+l?=
 =?us-ascii?Q?l5c7XyZMQtlxfAjuNtX5LGflV6+9b4+Qv00jA01lgi4e7n3xLjE/vnpA7vkU?=
 =?us-ascii?Q?9UQm1Qdf6Poj8qf9bTe0QGwCLRfqj9wAIfBLjSmcNO+ivnn5z84SZM24vDgu?=
 =?us-ascii?Q?KXOoC/KTsaMxsPRlTDjD7y4I2YPw+Pt7XzCPaH+rQp3KG5jDMtEVKMTO5eKF?=
 =?us-ascii?Q?v2MAY4aWWq4H8sAE9qfHCTY775vR0QiFv92sqUsSlhkfz8IAhxPQ4fFkGzYK?=
 =?us-ascii?Q?IPaUkbSa69YRcA7iKUuQ3YNYZT13+Lcy3GFRe0Zl4l/wFcKKpVL6CEjLt2zx?=
 =?us-ascii?Q?k2mlqkFnzNubxTCbycdPStKlkLoT83O/WpFW1Z1ooEY3CxMM4UZfta2sMG6A?=
 =?us-ascii?Q?od0DSG8Oi6L/+3fOO9nfYldQusMCC2LPbMQLrv1NIZBqiW2/cCTwOodfZzFr?=
 =?us-ascii?Q?Em+siLwTreraxKjBtlcDT1I349qQOtpBOcuHdg8EgzGaXQvbtmYaRireZp3Z?=
 =?us-ascii?Q?IJLRnIYf2hNpIIokduOA4RJB7T1Z9bpJcba2Xp1Y5Un/TrV0KGBBZkYTNXVL?=
 =?us-ascii?Q?3pA7IfS/teriUvNoQ+9Ji7a1MSagwTPgf8PM0yrgALUxuLqYeUgd5TcXTzZ6?=
 =?us-ascii?Q?sRERajlg2CmUVu/kf0zv9KpAQkU5Le/Y/ndyl3fkyIInPzNZE00ORw1SRzA0?=
 =?us-ascii?Q?uZeSri4aqhP2hLeLVjIILcRzfK6cZSK+6W0LdPKlOIUaorpvRTZRs4ehgXtG?=
 =?us-ascii?Q?SlnYAIoQP4tiwidcrFsXKx0S3wpFddASqZ7dbabcGmGFPKdBqBxmqNFIFT7X?=
 =?us-ascii?Q?z7DNZtv82OoHFvE+Ow8EL+Ym?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b393123e-8333-4856-8aef-08d8db41315c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:32.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLc5f2uUtUcUyB4Q7xdrYW5+EUVLu4XSu0Jh2i2DY9fAjvfYE1byDcuf1maX/5irPk5Ym62cgPYHK1ok7N3mWKxDcYrwOzg1PZPEh79fnbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++----------------
 drivers/target/loopback/tcm_loop.h |  1 -
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index fb877aec6321..2687fd7d45db 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -39,7 +39,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
 static int tcm_loop_hba_no_cnt;
@@ -106,10 +105,8 @@ static struct device_driver tcm_loop_driverfs = {
  */
 static struct device *tcm_loop_primary;
 
-static void tcm_loop_submission_work(struct work_struct *work)
+static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-		container_of(work, struct tcm_loop_cmd, work);
 	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	struct tcm_loop_nexus *tl_nexus;
@@ -161,10 +158,10 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
 			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
 			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc),
-			       GFP_NOIO))
+			       GFP_ATOMIC))
 		return;
 
-	target_submit(se_cmd);
+	target_queue_submission(se_cmd);
 	return;
 
 out_done:
@@ -187,8 +184,8 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
-	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
-	queue_work(tcm_loop_workqueue, &tl_cmd->work);
+
+	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
 }
 
@@ -1160,17 +1157,13 @@ static int __init tcm_loop_fabric_init(void)
 {
 	int ret = -ENOMEM;
 
-	tcm_loop_workqueue = alloc_workqueue("tcm_loop", 0, 0);
-	if (!tcm_loop_workqueue)
-		goto out;
-
 	tcm_loop_cmd_cache = kmem_cache_create("tcm_loop_cmd_cache",
 				sizeof(struct tcm_loop_cmd),
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
 		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
-		goto out_destroy_workqueue;
+		goto out;
 	}
 
 	ret = tcm_loop_alloc_core_bus();
@@ -1187,8 +1180,6 @@ static int __init tcm_loop_fabric_init(void)
 	tcm_loop_release_core_bus();
 out_destroy_cache:
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-out_destroy_workqueue:
-	destroy_workqueue(tcm_loop_workqueue);
 out:
 	return ret;
 }
@@ -1198,7 +1189,6 @@ static void __exit tcm_loop_fabric_exit(void)
 	target_unregister_template(&loop_ops);
 	tcm_loop_release_core_bus();
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-	destroy_workqueue(tcm_loop_workqueue);
 }
 
 MODULE_DESCRIPTION("TCM loopback virtual Linux/SCSI fabric module");
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..437663b3905c 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -16,7 +16,6 @@ struct tcm_loop_cmd {
 	struct scsi_cmnd *sc;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
-	struct work_struct work;
 	struct completion tmr_done;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
-- 
2.25.1

