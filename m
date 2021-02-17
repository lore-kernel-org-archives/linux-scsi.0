Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE6FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D087664E79
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhBQUd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45076 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbhBQUbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOEIE190344;
        Wed, 17 Feb 2021 20:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2f5zpFFRFQNuRa7UaHt8wS2qH8PVV0E4Gv6yWX31Xho=;
 b=sgcsTVZfmu+VtgwVIIooR+KoT3a3Gvb9uEa9jttha+le4P03WYj1T/t3elYZJRkRJqXh
 TSCNufezBCeI2aOTpKCH/qrkUxnc/QhWeP8CWxl9LGXdxl+tCOlRG0eqNM0dLEv8ZM6g
 OBJR/RPty0RyHEjVRNi3TQKb5CMS76edzLYcrNFSIn2glFMTQ+Nuz1wd4e6ZNIz6E0U3
 ftEmLgigm5jD83+VtsFpwjy6SWVj60mjWAT7HHlIeQcCavjCBENp4dYk9jgNUH0DHvNi
 lAada+TiAYtAu3lV5ducZDZQnz6GaiLvdfeac04dQnAqzybbWICUkmw5A5EkDU6PNH1d IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQCcB191586;
        Wed, 17 Feb 2021 20:28:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 36prp0p6cr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpQnY3gxdcww5fsm6c7hMPNjDR5ZZOrkqEQqUnIxO15UxQ78dLvR6SG9/xWu1LsArluRDCkdcui90F381nwJ1I7cKDawFQBTFE4udBf1zQ6XpAam68kMJcRenAps3hnuCTrgNCUR8s0YP3XpmI3BvhylC1EY95zJeg9n8TjPvVj+1YBHuwUNQDs0icYTux4ruX2aqTNDguXfT5xlfxto7G0nqvCtr0vAVLGipDVqjoFMWRqOi8+03f0wf+whEBQtlVLWlDiNIomBBq8JjE1CKRtstVZn/8hy4ykAYcSB0NpCQOLxDwA1FjNmLNxDRaEZJehgal9Vew3jQzwjqXk6QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f5zpFFRFQNuRa7UaHt8wS2qH8PVV0E4Gv6yWX31Xho=;
 b=HFUyUOoEMpdBr3EiuugjzGs3hnKtN7NW4+W54sAM0tVlYlUKv41er08f1WAlWxaDaMnttBo2XEahSJHjfz5k26N5cp48x4PcbRkKoJdIgzrcpILg+SU2P5VWf8ayXWr8zgb8A3V904bSEdIRA7JS4gJo4F0GPkW3hxVHj+K2YC6gYZZjw7XKw5LG9XFrndhmoo5wg5gSFa7e1uLmC2dI/fW7Nr9HNbPd1STnNxIFmpkz+DanZGeKvvPNvMaUhqbY+w6tzgU/Qz1YhlB8IpUKuVDJgjhKx2j0zYQZ0xE8mLpagt4B6zKHTKfl2jPsACzAxQ2pfqUjXcAeA0eTWVdvAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f5zpFFRFQNuRa7UaHt8wS2qH8PVV0E4Gv6yWX31Xho=;
 b=tJvMec07YpxfBTqAvkyU5P+ZP5RzUqaQH/D87FjjW1kJ1lJrfi6lMrsv1rk5J0n99MKRQ+ZCVhNJOzHxCB5WO7wMCRqYy1CmYB715IxXbI14rlgyOphJCpCUV9KBYOwfzIZJOto9Qi7mGbWJ9asW7DomKE5YnYErEbiciCwhhfk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/25] target: remove target_submit_cmd_map_sgls
Date:   Wed, 17 Feb 2021 14:28:00 -0600
Message-Id: <20210217202811.5575-15-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a125b09c-782f-4ceb-6e5c-08d8d382a1b2
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB41017A57AFB422B19CCF4E80F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 18cHG/8uLxAdzd+2sc5Uz0c6LmwMF8h+IR4DjYi8+NKrctvOmVWBolokGo/eKQp4l4/1z4A71nXCOpR6CnVaws8MkAKLte6Z3pew9nx1EL+sT4ouXZhXBZtN1oqpQCIv3XV6OEI+ozboEN2UDS5YlGX0UXn+OhF977qKCc7mMdYMw/UfO6pFC+azR11V9t0eA+KkhYH0cso/cYOgZ6Q8ZjDohr06FySOFWNc5QavWcNIIynXHkK8ARv+LZwNoAir6QMQY+489UgrmjcPXFkd72InQHk0KEtxAuJ4mum17MudYLNjhdLUektHTsPO7gQ/0X2b5lpB0C6bSjzWH2k934aqR5I7FCOxG1agc6C/L+QNI+T1TmJFXPzUasSI1qtKw1kG4yJysqdeTX/s1MxCXBH68cWlPmFk6qmNv37ZYzNb5GmMONl6xNXZrBW1oIDtXgrFBaOXkBnPHb/Jyg1C4YP7yYHJxT32nI3hWEkceo/nQIAN9StDVSG4r5xLICdOrCSpYk32eOUWEzmnrGV8F0b1+45cGVuN+dPkDEmuvAWCHkR9vJRVng/C8v1MrlgHAFn5Mr3w22wrzv1++Xb3rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c+D96yDE7f+IxNF71QuvleFt8WjotZY9glfHI4UV6o+p6M0INOZDIF5iy8do?=
 =?us-ascii?Q?FxHhAhIUzqbEwVQGgpKhRBOhhch8aasPqsUDeR9cQ4L9ZjH+B9MQZTGaPzxv?=
 =?us-ascii?Q?OSrSY0qfDFJtZkEvb7XnJDMMK1AUUaPmeKZTSaNWpj590AV/ukmGm0m6300G?=
 =?us-ascii?Q?PIdcW52ZVKrpex8nV7TnPEpV7qijyx38Lw1BdRDEj7j/6KLWgZ0eipGdBQmb?=
 =?us-ascii?Q?M922Lo0YJoQd9VXrgjZA0W0G2rysTsBwxTWwFCtq7UmPhzEb76UtzJXGDYlb?=
 =?us-ascii?Q?GzvT4Lyq4vKYM4DficJyC7E99tlwuNumgL5y71CZsbH7scZyG4jZ67iRvmwn?=
 =?us-ascii?Q?FNnr0iGIyuxpkuAmIp4BnuMlS0aAFWra45lqoe34TOaMpb/+2fFkq6S6TqlQ?=
 =?us-ascii?Q?1MJlvUihCIgjN82CdyU5+M3ejsIzUO/VfObOLCFiHFgu4ZXOvauyC2pHsD2s?=
 =?us-ascii?Q?uD5N8OZGCWjRPNHFd0TFYL6PgkpvaVSBQ0OPemGkxqAMaPYOJDsqXZWacBBo?=
 =?us-ascii?Q?w46wiWiDcgAQerlWyVB6KseOrNnVn7gqwv9akhPetIVxS4+IrizaMpBHmA9W?=
 =?us-ascii?Q?CkHcP7yx7engGoUf6S/iPqxUIzdBY8goHRbBgjWgSsmbBE5BQ+Rznh96Fy4L?=
 =?us-ascii?Q?jkpUUi4fDqxckp2z0jlretBK1Pnt4z5a9QPJptExajX3eBTWr3oLsHkxm/Wy?=
 =?us-ascii?Q?3K1BNEtAXufz52hr1dIFvsQ1qBJuCv6TztcV0A/Wpg+zivNgjHe2Yy1jQ1iV?=
 =?us-ascii?Q?ntwTPL2oZouLREP/QGWL0eKh89knZasSV2JPCxYwfk5e2xPD9nSy804tC1Z8?=
 =?us-ascii?Q?NmSDRZxh94LT9n+U+QzRwn6sD+/e/MkyiC1WFB9qfj03YlBNls71vb35NrXE?=
 =?us-ascii?Q?dl5JRDNzF/qWeuIB2wa7gxl5v78p+w4jxBqDw3Kz5nU0sMO1YbmrLj7/xXaG?=
 =?us-ascii?Q?WLVStj2lK0tcJQng79wMKulyUZjmsMc/uR9jVhcExfaETTzIh46DhkKCwA2r?=
 =?us-ascii?Q?ypRF2OiFD8EuNlBnzhwkIicKxHrLSyijn7F4ZQFbmeHouUV6mk89nPiTYODC?=
 =?us-ascii?Q?lVAcFcUmrv4DcPPmdg11TRH8qtyJEjkiSW3DURwV+DiEaUagnIuDlUjzZMSY?=
 =?us-ascii?Q?IwHjsxQa1yB5xOmoY9wxjBKDhPPhbEcS81PcRJ6uW2h6Yev+ZOSvYNivjTwB?=
 =?us-ascii?Q?sAIUbOoP+cYfcaJ3bSB9FjTLr0GD4Uc9oriMqSFOLVOcaDJiKdvAAMQgyvpc?=
 =?us-ascii?Q?XM3EDALSy7Uc341pg69jgb1nHkPLsXkZdC24mXxU4W5VBq50WWrIfSCCHtNu?=
 =?us-ascii?Q?OvTGawL6wl87Ub/z83/DCZ5W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a125b09c-782f-4ceb-6e5c-08d8d382a1b2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:48.7468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHA01RW8XjRKQbw5ev/qkZdLHX9ACsaPc/YXlxmOGj5l8hrvusHXyuRPU/2HMQJWeR+DiJZO3VzRkjMLDM1gyfRShG5rwNMrP3v5EzpQvKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert target_submit_cmd to do its own calls and then remove
target_submit_cmd_map_sgls since no one uses it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
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

