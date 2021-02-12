Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8C5C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F33D564E6B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBLHbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBLH34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:29:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PPuC171158;
        Fri, 12 Feb 2021 07:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AbZIrydSjLMvWnuKfg9p48xvW3INdg0yTB/7oFfvMKg=;
 b=MlhN01H/s4oZGkEwJ7bpmYqTDur8i3hRL0RtYzaak7vpNvv3lPT4hcu/3iUEtrExiJJO
 sOw+eVjvvwW2i3HmzMg43LMp0HOoVYk2N8nKZWx5IZdQLZUS9PtShLUDSGAdSiZkrIgy
 ARirrdiEOSRHgA4vB7Mojq6EfHKp8AKbd4v0XDv7dVvUjme56gKSiyuiKA2QDWkouOvx
 mLbKS2e0PxwyWF0kydyKanAXVyGIHhpb2TwERv89lcKo1kjWTlN+zFCqx1kwPCa4FftO
 DT57Y3u5mjff6yOJNFWr9BfKQvfCcnqI5b/Yx/D639fZ1kQVtIk1VFKX4s0muNm1NJ4W gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrna557-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BS090048;
        Fri, 12 Feb 2021 07:27:09 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwaRkKNnT5uf8EBpEHMHp+A+0mPzy+P3PsmT+ViICknuOpJ5oKfumSHF704sBWvXZ/pohAaFa4HQjZ3dZ9etbk1zO1H7Gc4v+asvUs0snY/gQ2JQFRWardbFZGqaYNTZQmuVFUFzp5IHSIU54t22EANKMPjdi/o82fvLKHE3IHlYKw4I8pB8/iBOl9plW4KQ+PQJSQ/FBwR/TXJI6NK8Rb2SYN0N8LytbgwB/n7laOI1SCFg3Kx/JRlvZDjRecbNrEEW7LLIl2ZV42fQO8khi7yTE6uKAg2Tn8FWw+kcMLnVqqK2POPO5yAgGvxdKqIpSIl+OBtsW8KRNNXhm7TQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbZIrydSjLMvWnuKfg9p48xvW3INdg0yTB/7oFfvMKg=;
 b=JX42g3aP6gMLIHcl/hI/A95DLaa9mTtb9dVJpKo9YXKXqy1+XOOT9tZWt2si2CHV0j0yLEHdio1c0SXNqvnaIIqeSyNIguNcQeVq8jYy7GVMZJrTaAAB9dmT0rlWJcT5hiS2vCOT5rUwRzT044ZhYAKCTwWhtCP22zPPZtHRRUhpiJE0DNaHg8pqLSFUtOaQWwxBP6RlUhwJoFcx+SjweXocLPB4ZeyvxYRDXm20ussot33Sv6NtpI6XRR8XgQYAhtNE2EHd1M3hM5lVb4C/YvmSBLlqtXfbLxeYU/hCnZcusZEdTlhul949iO/01WmXoWIMZ3A+l4JAbg3tl/HFLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbZIrydSjLMvWnuKfg9p48xvW3INdg0yTB/7oFfvMKg=;
 b=CRV4pFBfeO7GOnNYcA4h8MAFrTLaLCPL+F8G91UloU+MX49pgXw20ZUk3mYXanLNOfQyC3KZwYpa+K6bIW8ZmsfX04XklbbsveYzegrMaEREkXlOc5PyjTVQhHhvzmmkJqwX1FMg7LOIi5jQkb4kVmV3LiJwgY9bL2xeNDNqKHc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:07 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/25] target: remove target_submit_cmd_map_sgls
Date:   Fri, 12 Feb 2021 01:26:31 -0600
Message-Id: <20210212072642.17520-15-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2402ff99-008b-4183-9d87-08d8cf279a00
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254B311DA9A799632EE984FF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PHn+RuWfzrG6m4xWW7BO4SYic5jBbMCBO/Fu1CQMmpqeYsT2zBgmPsBD/lOFVzg3PhFIoqoo7tlZO3st9mabepf8Y4eMz7yereSGCSleEnpt0u+0kUowTHv0MIQtmjeu1rYJ7SfJJz4GdAhiXH2uhw0QdlEbgv5Cf3iOU6dw+kh7CdzFy262+PFfr0DnVPr4nxguTFO8j9yciRF2wtuG9M40zty8pTc2Fv+HtI+IMufvw6aaNxX2xn+fqZLLxEbwwqt8kP3bJ6uUFnCfycgPFSGmltQdbWJQ3PgyMDCf5irsYtKLAy9GeiLSZ05CEMsJDRylFSTj88JAgFLhfVeQh+fTpGy4HeilamxFP+F+PooP1exaqGuZ9bnnARXts5UDhfAjLmSMEcg8IYaZxxnWmhXj+YyESSIyFqSfDoJXLR80/U0XqcUz/WNHyG2F6besTuNeacJdY3nt0dfVbNKitcpvPd8CirHXpsShVnxKA7SHEn8geo2XWxXT3gO4n92XjdHExALli/984WIjXoscWxA3ug1ZNv6jARWcb+huehPOsuT2gVTm51JIbye62pzRZctwg28rqopYMx9l3r8PgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sIhxIHqOH83ahCzskrUM7SZ3Ph8yeHYHaX8vGlZS8fUrno3Ju71LnMnNGtQA?=
 =?us-ascii?Q?Gg8lhxijb6JIg1BVm3bcUBR/pLCUFbEkpt2PKl4mb2R8N39VqSltJOEBzW6V?=
 =?us-ascii?Q?UX4dgKGyQ6SPGZMr9ItI835qXJdwamuPRd9GxVqgPwFabwhQ+VLHBAvbnbCn?=
 =?us-ascii?Q?O+/IMutjpgpIF556Tnacdq7qL25psm8lVgJNcHcCZAsNnC1NgtBYuZjWsLda?=
 =?us-ascii?Q?1gsiN6EdYTeKxvdqwIu87Rp6oI+yZvOXVgRsvcjRrLtFieq82sdoEU8XGEUf?=
 =?us-ascii?Q?Pdsk6SDRTh3i7SGeUi+9X58VXzbxIUcCjPIEH/rK/FHkL2bxtxeq70GU558G?=
 =?us-ascii?Q?B2l8Y+jvj8jZ5GUrG8y2gainLqfuOsrKIz+iYCLdsjmQM6EkC7Cx/CNmDRqd?=
 =?us-ascii?Q?ByX1gsirgvM5zZuP37K80Rf5wKVh82UZAoNoTltUcI7115qXi2Phzy7Q3rRs?=
 =?us-ascii?Q?d16aOaQZfp0g4IzaT2CWR4AitrHcuF4WGvv4PC/BUfNHt5SrKHmafncPPRds?=
 =?us-ascii?Q?HhglHwe6bPwRGoNeL5j75PpR3IV6yfTys/QLwz+LXMk0dsqFSuAQgz7DMOHI?=
 =?us-ascii?Q?yWrIicyKiUEpSLIFL/8aY6fPxzMQBDWxc4q9P32cnal41dCprSYZ+bUBfaRV?=
 =?us-ascii?Q?OrN8RnGrQ4bCeEwJF1w/e5qPEVn9AzMbTXdyatLLi6e90+G0cEsdYIGUWjTc?=
 =?us-ascii?Q?VolAqQFFZFu3mwUHamoRus3qqFbUfc0GA3erjsQGk2ZueCNDwZoWC2DqCsat?=
 =?us-ascii?Q?ueElKtW4k/pkIRjr2uK+UYoeivqT1CLYgbcSikkY6rQNrmFtea9RegeqVIDg?=
 =?us-ascii?Q?7VC7IKlaGe2h7YXHKxqY1wr/GKkFwiXsPl/wJdpkRWAugiiKQ+nJ29C98izJ?=
 =?us-ascii?Q?TAxpLDB8AisY5IWlbn1cnlV74Yp1diICsrBPUC3Q647RqyQ4vwGp2Cjr57aK?=
 =?us-ascii?Q?Ei9kLNzaAl0PkLWKHFSIQwXGQWVfAWeDCQHjCSj73G/HT1ax6fHd5Tu/O9O7?=
 =?us-ascii?Q?BBFPqpe/rfAIL3CjZSdFZTZVUxDcdV2FNxKH/zrKvwAMG4QBNrD2+xHSpSlB?=
 =?us-ascii?Q?tszpKr1FG2eBlMP/3angzjeXJDRI1nJ/UWMYf8JxCjN+A4YGMn1ZLi8jTTeF?=
 =?us-ascii?Q?RUMYFUdin3qqw0c1O8gdJmomRvAv/a4U/b6qAVXDKYSwuFFzQh8sQVtvqdWN?=
 =?us-ascii?Q?4qTGBq8bf0eNuq4D7tYuw2hkqLIcOY3h3AoqDEZRH6F69U5ArXteRCu/J/wE?=
 =?us-ascii?Q?Cmpe3kg4VINerzwpf9yr7mS+5BjnOLCHGrD5Ey4emLafCG2HI8gieOmwWEIV?=
 =?us-ascii?Q?FDi3id6PrU6wg9G++T4Q6vFs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2402ff99-008b-4183-9d87-08d8cf279a00
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:07.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJVLT+n1qOoSOy7ri9x8yRg+Kqu3w1XJl6qUY0K3oH3Z3gsVRk6x28KIzLvMBa6urXie14w6/ZGNdHMTt+k2GlBGl6s+OSDpNXUgiQ9DZHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert target_submit_cmd to do its own calls and then remove
target_submit_cmd_map_sgls since no one uses it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 69 ++++----------------------
 include/target/target_core_fabric.h    |  6 +--
 2 files changed, 11 insertions(+), 64 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a82b7da09872..ad30a99a5cb2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1751,57 +1751,6 @@ void target_submit(struct se_cmd *se_cmd)
 }
 EXPORT_SYMBOL_GPL(target_submit);
 
-/**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- *					se_cmd + use pre-allocated SGL memory.
- *
- * @se_cmd: command descriptor to submit
- * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
- * @sense: pointer to SCSI sense buffer
- * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @data_length: fabric expected data transfer length
- * @task_attr: SAM task attribute
- * @data_dir: DMA data direction
- * @flags: flags for command submission from target_sc_flags_tables
- * @sgl: struct scatterlist memory for unidirectional mapping
- * @sgl_count: scatterlist count for unidirectional mapping
- * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
- * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
- * @sgl_prot: struct scatterlist memory protection information
- * @sgl_prot_count: scatterlist count for protection information
- *
- * Task tags are supported if the caller has set @se_cmd->tag.
- *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
- *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
- */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
-{
-	int rc;
-
-	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun,
-			     data_length, task_attr, data_dir, flags);
-	if (rc < 0)
-		return rc;
-
-
-	target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
-			   sgl_bidi_count, sgl_prot, sgl_prot_count);
-	target_submit(se_cmd);
-	return 0;
-}
-EXPORT_SYMBOL(target_submit_cmd_map_sgls);
-
 /**
  * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
@@ -1817,22 +1766,24 @@ EXPORT_SYMBOL(target_submit_cmd_map_sgls);
  *
  * Task tags are supported if the caller has set @se_cmd->tag.
  *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
- *
  * This may only be called from process context, and also currently
  * assumes internal allocation of fabric payload buffer by target-core.
  *
  * It also assumes interal target core SGL memory allocation.
+ *
+ * This function must only be used by drivers that do their own
+ * sync during shutdown and does not use target_stop_session. If there
+ * is a failure this function will call into the fabric driver's
+ * queue_status with a CHECK_CONDITION.
  */
-int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
 		u32 data_length, int task_attr, int data_dir, int flags)
 {
-	return target_submit_cmd_map_sgls(se_cmd, se_sess, cdb, sense,
-			unpacked_lun, data_length, task_attr, data_dir,
-			flags, NULL, 0, NULL, 0, NULL, 0);
+	target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
+			task_attr, data_dir, flags);
+	target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0);
+	target_submit(se_cmd);
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4b5f6687393a..86b0d4a7df92 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -162,11 +162,7 @@ void	target_submit(struct se_cmd *se_cmd);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
-int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
-		unsigned char *, unsigned char *, u64, u32, int, int, int,
-		struct scatterlist *, u32, struct scatterlist *, u32,
-		struct scatterlist *, u32);
-int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
+void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
-- 
2.25.1

