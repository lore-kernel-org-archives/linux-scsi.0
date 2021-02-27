Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BC5C43381
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 227DF64E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhB0ROP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhB0REI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH01pL034101;
        Sat, 27 Feb 2021 17:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=eezqp08w8pBwL6SGoHgccxkJ28lPG4kjR46euuk9a3I=;
 b=ZtXQxfwepsZKCw7TyrYkLm0FPdIBmhg4o7rmvIh1D56kZyKprQXfRq60uSnuo1TJIYTT
 aYENfdgn0odnmInrPi6fI3j/rZwKG9quRApYDh3gB7FHtzNwCVXaXKoQrCZ8TTlyg+tO
 /K3fn9cQbkrw15eq0k20jkj0Nhj4aZUU5toceYyov54lhoNnXUNlorLyNoPkOteaBsUl
 7tB6xOPce3NMhoxPUSQjJtjQ0go9wRjk/l7yBv9RHXIZt6xdoSePaUQV9S1f937HPV57
 0Dyy08ICPgpTYP72n6tTUXQY7mmk+rxutlSpjVidAPvsb0ItXeOyCilwWslWT5yN5cTf 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGsmD9041731;
        Sat, 27 Feb 2021 17:00:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 36yb6sam7c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBELIsG7t1S8dtTanzReiRdn/BLJyKX5cNX//W43UtjVbRS8yQM8QCpEs6S4mI2I2GYjCR8T3uxowpZfUTwDLPzjbw0LaPsW8cgvBGDr9qX2BQsl1XCAUlVG/4TH7DNtLuOwlbBu0KKnCzsLOQKKcwHo80iPa2V9dsQDSpDZiuaMYIgOlsJVsRomEYdQLbYP28E5pDpo/1DAzJn+C2yXleM0Nnml5yeNd/c4FnuKR8Kf//lxAyTO7SK/Q4gRCh4DlW71kHaX2jvfuA8JQZW+DlO6H0HJrx0sZZ4cipXbse+klIr+j9qP2lSyvecc+UA1iUA9qWgwFPGZ1jEeMWQ8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eezqp08w8pBwL6SGoHgccxkJ28lPG4kjR46euuk9a3I=;
 b=KhaHJxhxGlIq3HEn7lyD6WNC5aj5TWQ+qRyPupNBSPppy2hx/HUayNMbtED1rBCCvVplbbxwu821CouE1FOjH4Puiper8s/OKnM4SGXU8RYwddKbGNZDVB7hidxzYs8/WISipnRm3m8o3yaD4+mmY9/sC+t2HtDbKJvOTRl6DUIqxKmS4XDwvQQRHdhvM37TaNJj/w6aSqmBNrCiuYJQu56R940snjFBWrg165VkCbvRm0RSLsV7N/owlj4qne5/7L7suKUq6bvS6K9Y3md9rFNpKmJExzAeIaim7M/0un8chdD1huivKCMpAMUpYGUZDdQW2PvVRXiO7v+dfZCUTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eezqp08w8pBwL6SGoHgccxkJ28lPG4kjR46euuk9a3I=;
 b=Jh6P8WQ3WBm5CGaPPjgOq1BmOoJ8WBNesYwG4XP5+QAFnxP7ZKSCp0QaIF6+bC/HsPmjSuNZ1Xl9QRX+bWW0lZ7osnYFechdr1Ry2OUeScqU+SDChD50wO8nQjn+28aWfImuBVEN4V053tA6DnW6UY/eow8CP9jLyaw+DDQg2xE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:27 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/25] target: remove target_submit_cmd_map_sgls
Date:   Sat, 27 Feb 2021 10:59:55 -0600
Message-Id: <20210227170006.5077-15-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1de28dc-ee7a-4e0c-8d63-08d8db412ec4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499ABE7413EC7130AA24ED4F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uMVjjDLau/QLY0J86qjwh5bz3swv8pzsI3LLpNNA37ElerhqhNBYlUJ0gUJB8wjV1C7gjMiGbxCIAjZzy1WhiJ7I1ayAal/q8VX1sAkY2M9eW8jn9IRBygeMy0GpkE3E8WF7F5TXE1ePZo+KZsTeH8U3bGv5mPJ6S2JXW9qVzwjyhCzFdpPSUg1PHKmBRo0I487H3hS++wL+haUlYeFErwTxEzmXh97YkwXRnkt7bILgtFU0ty5nBMkXyqh5+BsaaHXcXscnmI7p697sjq83S/H3DUySaN1k9ueJQSOlnwk/yVCSKTyZLlLlKPoh+CaQjM/OLRG1GZajDXI3ANdF//qpGp7fHAzoFUzWw51IadTTCvgJxSNurJbQSuNfarBO+ockFlQnlpW4VxZnKDuUQPHwOmHaxeJFxL7AUp2qzcG4q9X2lOuLZyvX5kSv4Kz6FZ3USaKydEHUykLfz3N9OSNv0yZF6Eo/iz/hwQ+Vx7rHR6KJICkYHcPOD+NsK82rTkO0JFv2C4+lOqxoo46al23VBaA6HxHq35Qxj4kAmhbTrIbK6ITOUhNcMDCq98qhlEcvAoEl1Etin6sZE7KHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s7AYCDRzFYAzdr8KyedovpwSJdU7yB3e9BYy1ybg8s4RgrP+FMkq76v5wIYJ?=
 =?us-ascii?Q?PgR7WMYH9rXeHCMDwzPde000jVBHh6r6LIPO43Z08Hl3hGRdbJTSJX8p9rcE?=
 =?us-ascii?Q?O+L3jyeFN6oPg+948kVb+NdlF6zhlsNzU7CRzgyp7GoH1O11TQ/u7iOX/U6Y?=
 =?us-ascii?Q?bp/xzvfAbWQV0yYBeYwiUh+89Kgo+lvAozwT08Unih3UmVDr/yUgND+86xTh?=
 =?us-ascii?Q?MW1Iz43QjdU6CtpLLXNtp7dj1xdQrfaHt89pOtbR3mj8dRdmi2YynjUxlg8s?=
 =?us-ascii?Q?pVF2lhOHS1rj6iYGbXIlIOTH6FheeYCgNv0A57SZR4RnDjoZR6hRUbmRj6rD?=
 =?us-ascii?Q?lI7H2JBkdOrLabtyO97NbCci1qTaBIbLTkKMHAybHc1V1VtAqLumeT7zdre+?=
 =?us-ascii?Q?bfzpGNaCAszZjSytWr/+IjjvzfZEKqNT8V3OPxulwvElW3TjNM9Vdb8i68xH?=
 =?us-ascii?Q?hm+JRNCwdDJ0FU5ABSdYeitEpFc9MeO90us8UPcvHaQZiYQjTJ5i2u6eXRtJ?=
 =?us-ascii?Q?DLHOsy4I2deblDTcPUBTnjyYA5DQqVqSTZNVyQQu4XcvtwwZKMocNfgY4JF8?=
 =?us-ascii?Q?eQNRqDD5Nl6OxunOXpxC9Le+HMItPmzLFLK4tyjzNyBUJ1RnbxtLpM7jrsJe?=
 =?us-ascii?Q?i4JTRHSkglFO77AtfOw1mBLKJPhHD4H6ggIRyJppHmGmgQo8gMAhEHjsH3JJ?=
 =?us-ascii?Q?20E9rNvbRVpHENmujUOywd0SZcO1GHvZS8SoEMR2rT8Ye3r+mP3/+ca+tK2P?=
 =?us-ascii?Q?9sOcJ1ebJwzUMMPKD/OYCzL+L6KMkMF2KRY1lm0HBMA3MbaEDBVkARagcH8d?=
 =?us-ascii?Q?HthgEGWnUhVqZG5N3NQNW81KcrYkMAA4gcEuycBoJu95iQVGRw6dJPniCW8e?=
 =?us-ascii?Q?KkIYii9q8R3EoJ971i82KKYzQjGBnjxat12WNei/Opn/+H4+2soFgpE5a11X?=
 =?us-ascii?Q?8jMIeV4XNs7t7qT17CA87kfRffmvbZAX3FPfxp78s0Qle6slazfJ3kNGZEwD?=
 =?us-ascii?Q?i7ttxwqAlvdtm2YZO8iWNzvgue3Xx4FhcIQ7TocmGH1RdxIf3W6TTVxG2sI9?=
 =?us-ascii?Q?RMmCIPC5DBAayGKj/l2xKbTwYX52nPxRdWzKJRKtDAvLVfwwR47n4lKUJrhF?=
 =?us-ascii?Q?+Ov5ROQqpecDvuNS/RAy82nW6HuPF1gghRcMxoz2g7D0GY2Fk6O56+88y093?=
 =?us-ascii?Q?q+h2Iq1gbdvkubloh70VjSyNh2NhRCVwKJQiOYbGdKqpH0bCELwaFi6kd140?=
 =?us-ascii?Q?IiamkMhGdWcnCVxSGwVZBF3v+oKrj/90rnyAXDmkc+ji9qpbi0ty6PrCgn3w?=
 =?us-ascii?Q?iLlxVeJylB63NS5XVBv8cGpW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1de28dc-ee7a-4e0c-8d63-08d8db412ec4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:27.8724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMl456wEgrJNGs8zo8VzPIfyCpaBUssHaqJvoFIOR/ef/VkHcu8EoXWvk3MzWl3cN2mygSfRKuOnG0NZH3UIIed51fbif818NCKTs8s7+SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert target_submit_cmd to do its own calls and then remove
target_submit_cmd_map_sgls since no one uses it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 76 ++++++--------------------
 include/target/target_core_fabric.h    |  6 +-
 2 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8b2b805316dc..1f35cce6e92b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1752,8 +1752,7 @@ void target_submit(struct se_cmd *se_cmd)
 EXPORT_SYMBOL_GPL(target_submit);
 
 /**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- *					se_cmd + use pre-allocated SGL memory.
+ * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
  * @se_cmd: command descriptor to submit
  * @se_sess: associated se_sess for endpoint
@@ -1764,76 +1763,35 @@ EXPORT_SYMBOL_GPL(target_submit);
  * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
- * @sgl: struct scatterlist memory for unidirectional mapping
- * @sgl_count: scatterlist count for unidirectional mapping
- * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
- * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
- * @sgl_prot: struct scatterlist memory protection information
- * @sgl_prot_count: scatterlist count for protection information
  *
  * Task tags are supported if the caller has set @se_cmd->tag.
  *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
- *
  * This may only be called from process context, and also currently
  * assumes internal allocation of fabric payload buffer by target-core.
+ *
+ * It also assumes interal target core SGL memory allocation.
+ *
+ * This function must only be used by drivers that do their own
+ * sync during shutdown and does not use target_stop_session. If there
+ * is a failure this function will call into the fabric driver's
+ * queue_status with a CHECK_CONDITION.
  */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
+void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+		u32 data_length, int task_attr, int data_dir, int flags)
 {
 	int rc;
 
-	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun,
-			     data_length, task_attr, data_dir, flags);
-	if (rc < 0)
-		return rc;
+	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
+			     task_attr, data_dir, flags);
+	WARN(rc, "Invalid target_submit_cmd use. Driver must not use target_stop_session or call target_init_cmd directly.\n");
+	if (rc)
+		return;
 
-	if (target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
-			       sgl_bidi_count, sgl_prot, sgl_prot_count))
-		return 0;
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+		return;
 
 	target_submit(se_cmd);
-	return 0;
-}
-EXPORT_SYMBOL(target_submit_cmd_map_sgls);
-
-/**
- * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
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
- *
- * Task tags are supported if the caller has set @se_cmd->tag.
- *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
- *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
- *
- * It also assumes interal target core SGL memory allocation.
- */
-int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags)
-{
-	return target_submit_cmd_map_sgls(se_cmd, se_sess, cdb, sense,
-			unpacked_lun, data_length, task_attr, data_dir,
-			flags, NULL, 0, NULL, 0, NULL, 0);
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

