Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEE2C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8105B64EB1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhBIMj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:39:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhBIMjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZFlq048534;
        Tue, 9 Feb 2021 12:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fOS1NCKuge0pO5LPozjq1i+tEYEZOZqyqx9RH3H2gd8=;
 b=PXOPIBOeNavBZvW/ZrrfpaxFbCrXXIKAF5D/A+IdYMpd71w5qC8XXoA1eBXFHypNODDZ
 M2KPhCspgK//wmKvxV2TrYZgABdr/wfTvUWIeQdt622bzZqkXNtHvsgj2T95jgtm1FJA
 R9LGqCwVT8Qw/SV5spfI57cXqwjmcpNCRUW6bTPzRafcurtKbIMezbIAhgJN7Lf52gel
 PIJ76JUTcWa4gYGP+VuOJpdOyiIeU/BhZtU7G8modgArE2JIcIgIEFsZQLTXGNV+AkIL
 eN9lc2mtvY9RwIvnKk6fAsADrbsxAAjw/CS7k5z2pQtD1eks6jg6YY8Wrq3wyz+U13o1 xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrmy8c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIG178533;
        Tue, 9 Feb 2021 12:38:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 36j4pnn07j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKIzj5wXtP2yB/jqtIBkaV1nE8EujUtjlX7ZKUIb9zag6mRCXx1m4bs57KhvxQxkUxzczT4HmwRsc84TcqZe6+2EgdeXzQ4p7ajgVuAkqT9jGX0O0AbJbC8EwLEmmhkdWTvujiUTT68Plf+UxZNqxLs+9zHnR3XbXqKpg0W0+KyFzcAVjUhWYuANzcwgsug6Y8Qb+LdoK31ESLZbnJGtQ4qQ3ZKZ5c+PZ/HuoqDvjaDGBxq7MVxScwVu02pvKJjpOpn7Dnl2gy2BQ4pu46nvDJYd77wsJdR6zW+IMqZQO9ZZ2wF+uYSCbp3rXYAqDDs4OrWr2gaKfSwuDkFSqIxnZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOS1NCKuge0pO5LPozjq1i+tEYEZOZqyqx9RH3H2gd8=;
 b=J6KcrokKWdbuCGssylZC7Y+X6ClW285GtVMBMTdkqg8QnnPhc3hLCVEe/qyI6uExCzqIOWtMVXwyBrctfViIux+VcQ8LC1uW2nRZZQYrDpYywaMK5M8il++BWno3GE/wQ8n3MIlpfwkI/eMXmSlGIVDL/+wpfwekNx2dbQ6cMUAdtak8gByknjCJafejETJLG1HcHs5YcxGAF7PFNKGGE4pMBAdEbxvL+6kKO0yJDu4UfN7AosVhuPib59uK7vUmDsyavSzl9ZxkqdztGjWBPPdpm2dGkeAjijorjT5VEiuTp/+093ffWgnn+ppdRFSndBfPg6/N/4rqXi+cUWd/lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOS1NCKuge0pO5LPozjq1i+tEYEZOZqyqx9RH3H2gd8=;
 b=qqadSXhr+3WvSql50WJVJP7TZlTAGSPPOVofsOavX/1yPJP6ZGQ6zNXMIX7f9M7g9D8OFQcPL5WuJfrEkga1ItK9S29YKNxyzK7q3oK2aO8ugHKh+GBIaIw4T9UCGORROfSvuhQM9P0hmZ8cOr03im5udd7N/dXJ032X8ZSOm+U=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:38:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:38:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/13] target: split target_submit_cmd_map_sgls
Date:   Tue,  9 Feb 2021 06:38:34 -0600
Message-Id: <20210209123845.4856-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecf90914-b6ee-4c2c-5368-08d8ccf7aab1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600D15EB30D767A00201D6CF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PGThId7bYh/Ftbno3bd1tYfs7Z/twD3vpxiFbvukSxuru1Mp3o/JPledBmc4dsUgC6CJwLO5exdZn52RQyYm3eoPT1W8gN47KqUdkvQzsVvd6z3NgnV/j14EUWeEasdLUNgwGYyDV2J7BPkibtxy5yeDZYNTHRdKPkFbvHDJqNIVXC4S66+vNAX+B4JZCJdbGlSxOJR/Atnks2Y18y3qMl/ecjmEpzUeZXaX5ZskSsJHVU53YW8oyZVSwyuDCH7vx9sEBKwyiYoi/+RuaiXYaBXMAuQ865KJSSC+AiPD5QpvXFNdzdp3Lo37D8UboDInh0xgEFE6RiyeytaIcEA22uYbbTp0+Twtg8vZHEOonVycWlQxCC1L5atVnIL8W0H4Wph5J/UITT4RU9+UDWhxSUeOFCFhYiYteV96i7wLuGc1oW4PWkiLp3iPhWas3tSRkBJMh9TuVAiMoozqdDHjrWPMImBVHITQ5TfQmVyXXHaFmjoa/xafzMPNSyxhKlcTs2W1L9GQazypiwkoP1rSdJhtW3AOFdFB6A1scNQxjr0hqFY48n/QpdQzZ0bLGdHTcj7v61QaSYqJ8KRbotSbkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2HKg306y7PuGrg7cRyZ/05F8gideUcqAWJpioj/1/kGi7PMtYRRKhIwSlvAj?=
 =?us-ascii?Q?RwzP7nk1u6chURnZJkXjJfAfDt46Lw8RoxdUr14BLyMBoqOsNLWd0rIXvy0n?=
 =?us-ascii?Q?eg/x5LRa7z+w7dz899LcpCjo0TkVESUDEltGES7gwOsRqPVNmRI7+7COdNAw?=
 =?us-ascii?Q?sftd4C7EyIzYSqfvOHSBRhO57ybfm8XV7l0rXa0u/Uw6dBuWX9YpVu82vLqH?=
 =?us-ascii?Q?D5xixEl5/X5PhrIVXGEoobMYWV4GZmorlFy0KORw1nVIDLs7QlTl2oe0ehzG?=
 =?us-ascii?Q?FDde4Pw9vVH7ij8EpMPF1mbpilOE3SERyk1Yiqgch8u3k5OgN20yUdZyWadH?=
 =?us-ascii?Q?8FIm2qcPGi2NV0Gp3I155k8Lh2bT4T7n2CnApK3yYI3OCEw4xlM+iRbnAYc9?=
 =?us-ascii?Q?7Ep207RhZPRJAsUwV4yNCz4c8buu2AiNIKJFzpULdZd2bz+nXtyd0FighsDN?=
 =?us-ascii?Q?zIh0uojOBBzqbx6lf/LMCOi/oPLEMZHG1eHMudA9MVD+PjSKk622I3nrsWgd?=
 =?us-ascii?Q?dgJ1y3X9i5BDMp0bdrY9E+Qv0hG2Har4WBU4lEiBKhoQ/5GU5mUzoVKRPdMP?=
 =?us-ascii?Q?JdgDfcyj67zcl5RlXgt4BQP3wU88xTckhArynRThy434BcoSmORdal3cZKOO?=
 =?us-ascii?Q?simJZLPzgTaYSsD9rXovYH7BWo6OX2+7XOjlcJwx38IyRd+0mEBU5TIp7JTY?=
 =?us-ascii?Q?3MUKcywi39BpCPAvkhjQLoYOpotDnY0iKaKMXzBPjxbH1mKd0RKp8Xmym4RT?=
 =?us-ascii?Q?to6KZWEXhr16oAQsclwLkfrK6XpzC6DU+Jo2+ZYF1GYLuV+er1aIzkmBGBUD?=
 =?us-ascii?Q?/j5sm6WpL41UUUrNKtTJmqLa+p+zv9GOGCjMktAgTvGkRSqt2XmiRUEIe7ru?=
 =?us-ascii?Q?joVfCuBeSzTf3u2o56KIn+WJdczpjS1RDYwKa0ODOOl6ybs3qvWA8BVq9Ah2?=
 =?us-ascii?Q?xhn75GUgJR4yOhAS6qVde2fAgdvh1RS9Up9s7LeiQDKDPmtoVmuceARPXNEO?=
 =?us-ascii?Q?TwIOhgPZpArRaLhQPZCC0acw0A+6BoWE0o0mS5bK+D9lSKWtQx77JfFl9Lpt?=
 =?us-ascii?Q?O6TlN5y1/XyUDrsmcZpRXG85bU1oia79R1sEcVKFYG3q5TttP1ktFqfy/jyW?=
 =?us-ascii?Q?YfyNmlmgagTn3SJyumKiY1YYKDFYQkGp9VzAQpUOUfTaZ9Ac+VkDP5//5cXq?=
 =?us-ascii?Q?AEt6SDFDAuDBQCuPKenUvxEa+FWp0cj5XXqvkiYj5+j9bdN1X7ACPP2W6lcU?=
 =?us-ascii?Q?yMQkThLiOcIWSQda9hNIai8PukFSb1ym+huSw88A+mNAOsz/RGNYIgI/2NcE?=
 =?us-ascii?Q?hQAzqw2DgVViLm5YZgM1jIxj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf90914-b6ee-4c2c-5368-08d8ccf7aab1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:38:56.7310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxht9DPTNxS0XVr+1l5ZdxsaDtgVhnhcdvNlBVfZW7llEg/9Iz5rn5YzKojSxbtaENNpQcwDvS4ndNct0kE3Tb+HhSdvsE8hjN7tHJ0m1QE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Separate target_submit_cmd_map_sgls into the part that does:
- the initial cmd setup
- will not sleep
- and gives us access to the se_device
and the part that:
- can sleep
- handles the actual submission

This will be needed for loop in the next patches which needs to add
the cmd to the lio workqueue and can't sleep in that initial submission
path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 149 ++++++++++++++++++-------
 1 file changed, 109 insertions(+), 40 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5c4adde96d5e..71b0a862608b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,12 +1571,9 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 }
 
 /**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- * 			 se_cmd + use pre-allocated SGL memory.
- *
+ * target_submit_prep - prep cmd for submission to lio core
  * @se_cmd: command descriptor to submit
  * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
@@ -1592,26 +1589,29 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
  *
  * Task tags are supported if the caller has set @se_cmd->tag.
  *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
+ * Returns:
+ *	- less than zero to signal active I/O shutdown failure
+ *	- zero on success.
+ *	- one for all other setup exceptions. The cmd will be returned as a
+ *	  SCSI CHECK_CONDITION response in this case.
  *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
+ * This may only be called from interrupt context if the caller's
+ * queue_status and release_cmd callouts do not block.
+ *
+ * This assumes internal allocation of fabric payload buffer by target-core.
  */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+static int
+target_submit_prep(struct se_cmd *se_cmd, struct se_session *se_sess,
+		   unsigned char *sense, u64 unpacked_lun,
+		   u32 data_length, int task_attr, int data_dir, int flags,
+		   struct scatterlist *sgl, u32 sgl_count,
+		   struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		   struct scatterlist *sgl_prot, u32 sgl_prot_count)
 {
 	struct se_portal_group *se_tpg;
 	sense_reason_t rc;
 	int ret;
 
-	might_sleep();
-
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
@@ -1642,14 +1642,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	if (flags & TARGET_SCF_BIDI_OP)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
-
-	rc = target_cmd_init_cdb(se_cmd, cdb);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
-
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
@@ -1657,13 +1649,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (rc) {
 		transport_send_check_condition_and_sense(se_cmd, rc, 0);
 		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
-
-	rc = target_cmd_parse_cdb(se_cmd);
-	if (rc != 0) {
-		transport_generic_request_failure(se_cmd, rc);
-		return 0;
+		return 1;
 	}
 
 	/*
@@ -1684,6 +1670,43 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (sgl_count != 0) {
 		BUG_ON(!sgl);
 
+		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
+				sgl_bidi, sgl_bidi_count);
+		if (rc != 0) {
+			transport_generic_request_failure(se_cmd, rc);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @se_cmd: command descriptor to submit
+ * @cdb: pointer to SCSI CDB
+ *
+ * target_submit_prep must have been called on the cmd, and this must be
+ * called from process context.
+ */
+static void target_submit(struct se_cmd *se_cmd, unsigned char *cdb)
+{
+	struct scatterlist *sgl = se_cmd->t_data_sg;
+	unsigned char *buf = NULL;
+	int rc;
+
+	might_sleep();
+
+	rc = target_cmd_init_cdb(se_cmd, cdb);
+	if (rc)
+		goto fail;
+
+	rc = target_cmd_parse_cdb(se_cmd);
+	if (rc != 0)
+		goto fail;
+
+	if (se_cmd->t_data_nents != 0) {
+		BUG_ON(!sgl);
 		/*
 		 * A work-around for tcm_loop as some userspace code via
 		 * scsi-generic do not memset their associated read buffers,
@@ -1694,8 +1717,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		 */
 		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		     se_cmd->data_direction == DMA_FROM_DEVICE) {
-			unsigned char *buf = NULL;
-
 			if (sgl)
 				buf = kmap(sg_page(sgl)) + sgl->offset;
 
@@ -1705,12 +1726,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			}
 		}
 
-		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
-				sgl_bidi, sgl_bidi_count);
-		if (rc != 0) {
-			transport_generic_request_failure(se_cmd, rc);
-			return 0;
-		}
 	}
 
 	/*
@@ -1720,6 +1735,60 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	core_alua_check_nonop_delay(se_cmd);
 
 	transport_handle_cdb_direct(se_cmd);
+	return;
+
+fail:
+	transport_generic_request_failure(se_cmd, rc);
+}
+
+/**
+ * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
+ *					se_cmd + use pre-allocated SGL memory.
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @cdb: pointer to SCSI CDB
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_attr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Task tags are supported if the caller has set @se_cmd->tag.
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from process context, and also currently
+ * assumes internal allocation of fabric payload buffer by target-core.
+ */
+int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
+		u32 data_length, int task_attr, int data_dir, int flags,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	int ret;
+
+	ret = target_submit_prep(se_cmd, se_sess, sense, unpacked_lun,
+				 data_length, task_attr, data_dir, flags,
+				 sgl, sgl_count, sgl_bidi, sgl_bidi_count,
+				 sgl_prot, sgl_prot_count);
+	if (ret < 0)
+		return ret;
+	else if (ret > 0)
+		return 0;
+
+	target_submit(se_cmd, cdb);
 	return 0;
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
-- 
2.25.1

