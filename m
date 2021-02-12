Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB460C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B05B64E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBLHbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42408 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBLHaB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QtM3017743;
        Fri, 12 Feb 2021 07:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Ex2GluAq8WqejZjlnAkklhC4NkokkfCGFh3SuxU4/ZY=;
 b=yrOWbscFYw56OqfRkWc35EWnGx+Lohyu1aMKaxlPGmRPJGqslEos3AZBitWXo/IErlN6
 t/n59RFHQi5DQYQ5rYagTA6ZviS0v7uerKcl4un/0MQ5Dk11Ep+MAasvzP6yuQySI/z4
 WwUJr6KLWhanAGStKMs3PgERd4el6GwCjce22vFUpLruFLZCo7vAvu0998I1j8eVTA3T
 IYh/lInBKO9HkkwqiHtQ6ofgGMNBc28xMteGrwWOLD1Vr/xfK7VkfNW5nlS7zZY0xLSv
 vDX1+byeEeEkiGGVRbiV1msT/XenUrLdJjzTnXHgSeO93oVNSRRIfHJJfiavJB5uEVYe VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dvcur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BY090048;
        Fri, 12 Feb 2021 07:27:13 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrH2NUr8HJfrFUgC+MTI5ZfahVOcJzXj6iRyEawzaQYR+u6qdbdeZ4b8CLEaVTpuOD2qV1FkAcTzwt/+OD/ShSWcIJbtnu+3lwxA4BQSwQmF/OFAxpK0FnmRzVxvbMChSuBdp0IQnB5luaZnvwODdT/2zyHnykOHlpJ6C7qBAd4eD5FNNmRQYU0KotB0LoqPh1X9DbE2NDwJeJ6CoZ9o8mMz6TYymHwLo79S7Z2tME5sty1+LWZYK8G1IdB0se8BX2Q5eXM2y3yAMgIl94OW4MMNmewZuBqNmFleU1k/5wXJm/Kd/C5+RaprCUbdplfaXaPHm0/sAjCXEoMayimgLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex2GluAq8WqejZjlnAkklhC4NkokkfCGFh3SuxU4/ZY=;
 b=ONKbwYlYfG+MVeDabh5IeZxSKq5oLoNa8VYvdmkIsfJCn+pe5e+s/SyijqOA0EEK8NyZyPJk1aroRrQwS4+y3XiUeFzuP9Opvk8wZMv+7NqjzcxdZgKw5YGMhKVVNoTn0s7JBVSws6lkqbkmJslC4iINMmMdzE/NyzwGu8Fv+fPHDUjPNErkZaqqwdgKBWrF6Xko2LdNhmzlkDoRrU8o9lKJ6fBOdxy91XV8iwQVr3jBVxWq/om3yazKF4diV5sRZN1s0ua44qV4QaocUjylgQ9oi/++swZ1IHAqD+Yj5kIZkuKlW+hx1wkgt6Wx0R3oRiLBJyIFs0KjYxJqj+8uAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex2GluAq8WqejZjlnAkklhC4NkokkfCGFh3SuxU4/ZY=;
 b=bvotWRPwecI+Xl1jzKC29PkWj+JFVoym32zcJZn78oetPf145iIZKWpHfQFmjkTvw1cfvhhJjOqYu0tqSqsULYd7pWay03AzVpIM1OAngPQloszFHZ6ZFotlnGYHyueE3b4oZITOPp+6SHrIHsFK0sw+gtAr4vOxoZu8Cj7/YhE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:12 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/25] tcm loop: use lio wq cmd submission helper
Date:   Fri, 12 Feb 2021 01:26:36 -0600
Message-Id: <20210212072642.17520-20-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d5a009-5964-43f0-66ae-08d8cf279d06
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254B4C9C6F964266ABA108EF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4TkR0RuxiK13MchnbWhNbW/x4nzYjRXvKFmiH+dgv2AL0dEPWzAkAeT6vv270vD3rokMrZCf1OHqJ8ilASVTMNCmbcwFDEZ/MPK2qOs8PFf0VLOC3bZ6miwrcrtnThPkMKLJGjTwl/JFn1zf/wK/H35c/gjz1ztLU8fnS/Gp+kEZDLeDUCIiwk1CNfzDv5tzYzeVMj8VfoLN/CBYogpBoshsw0C25vgxaFZORquo6DWwmxmJwmjxKNWccWSHMCL/tTiQ/VMXJN4eqBLsMpNOy14Nr15PqQhZG+ATiydZ7ATgjsHX867N6Pdnhxe0Rc/CchGE+pL5N93ata3jVOahJOl9916bN60Yg6iStZp1k7lYeINi5i93zM7cq3gSBO2wkFtyH/660EVuzQnM9Z3jg+rhUTaAAwhUg3Lnt7tGLt25mbFrbO0OsaPUNZQGPU2NYIwY62osRcpUPvhXPI5CKTEt8iyzugs+L/ao0QdipGwtA1szp/zIDW1KaEMu2TPmByKBZx46RlLkxk2jxa/DzllglyKcQ2r9J+z2IfRRbORoTabZK7Yl74miRH3XF+kUfPGydnwuZN7Haj2ghc2tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x24nKjTAp3Whc6hGrzIz24FFdHCGsH4f20/Fh9omc2npvANjU5lWsuTFj/Rw?=
 =?us-ascii?Q?0s3EH6MHN1hiEUgK0pBKABK5PNeCqYTxltrixvG4cg7hh5i88eBklK+Ar5nX?=
 =?us-ascii?Q?LxCw24z54TH42I9Umh0PYXfGY0nZOWooFO2Jn0C8DMkrrbXgXo5Yua10z7D5?=
 =?us-ascii?Q?Yum4VjG5I/aoaOIOer1pE+14mXNnS0eJV1TzxyiobvMZwsZfeGPxk8yxw9wZ?=
 =?us-ascii?Q?/WXbDX4sGXG+9kmlA0f2suSHu915lSQOXsYt+kZ8nuoewMD147hiJPl9FH9r?=
 =?us-ascii?Q?gUAAtv7hrZCvjpFaG98NQHtvY1HjDOTKNg9PuZakYp7+daLeTnlddkdw9M0y?=
 =?us-ascii?Q?5ELQIff3dAwXs62p9LRGnwaVEzO9uPM5W18v3tw6Zz4ajL5Dw2fz3cMSUJ/D?=
 =?us-ascii?Q?M/QO2Er63+eDMjVMwUG+eKIdQkG/XJOahF74QdlBGmeOGKtvS0nPwM905Onk?=
 =?us-ascii?Q?iucyztz2tLmVhIiCCVA+TCtc4meZInMzNLTG3eL4Jrhl4teK9VVeAmr5JY8+?=
 =?us-ascii?Q?kcdcvPwZx5YyoaUKLmObkcuplpKsL3uvQLh2pAN44YW+XBFy7hxGYqxttTbr?=
 =?us-ascii?Q?UkbsRzg97gHeErWGWx+kK4Ir/lXP+nZDfWNotv69p8QwLkeMOikIhCxKVRqm?=
 =?us-ascii?Q?++6Jx8OkPrW/VjKPKrfBaDVm2F4OubvWBob+f1owjhjqGp9DZR8/hwqhbMv6?=
 =?us-ascii?Q?2LGe6fMi2bIjCKirnOuHO/xflJe9N3PrMbErxAJKT95kM1hcmMLafzSKyi7D?=
 =?us-ascii?Q?TEIcg0u2BD6AILpO+rQi9lRmkZxa637vNiMnEPOMR6725C7v8VHZEhYimjua?=
 =?us-ascii?Q?XLAn7uA+ZOVUQ6shefBUH6R9vq6uw/RoragjIeTkoYHUip1GyPNYMJVXTGHc?=
 =?us-ascii?Q?PEsc5QPmSNt6AeySJYI75wMOA0KkxY1scImDwaR5QgR0pu8vHpaEU+C8C0p0?=
 =?us-ascii?Q?k0aVKM5g7Lv0H2lQw+wFSuzvEf9oQ64zrWumvbNrE9FxZ8UE2+y6mqppf9Vq?=
 =?us-ascii?Q?X87EM+9Qpb/UpwCzSm12fH1SToKyg9bdq3AlNUc29tDsQZMHFh9xXxdohHBc?=
 =?us-ascii?Q?F89DKqyCs7IkUwi0dXGNa2SFVVjeIS3xrWeSSXIY5Y8RH4ntqFNzXD0cWoye?=
 =?us-ascii?Q?q/EfH+KEHJ5lHiCjHsRh4KGBI91V07QYyPosw+S171Wrh9ykaOptD2SrZhT9?=
 =?us-ascii?Q?mbULqOKNGUib20UTcXQOmnoPylGJORuB+Sqp5j8aUO+lSh0GeH7Zjde1IUC4?=
 =?us-ascii?Q?i68snRpEa4jNGHZUsvhB3nTd6Fz1xIZr/GFE30TaKS6uopb4G7PwIfMQMPeY?=
 =?us-ascii?Q?6QPx8KrI5KFbYidUwQGs0UuA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d5a009-5964-43f0-66ae-08d8cf279d06
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:11.9850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Fb/YhR1FlbZFwSvviLf+EMk+nDkB15t2dlBU9N3fix34aVQB97OZHK+/HnwMtt2BZE1+u5p3YkDJkyoHNeMcql130T5uYIDploWzpKIhT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
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

