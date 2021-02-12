Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6D4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FB664E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBLH2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhBLH2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:28:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q13W171560;
        Fri, 12 Feb 2021 07:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZUJBODL1IXVQSYFfl92SL6pxemZJ3XrNJ7gAgMaSyYE=;
 b=P58TIr4ooYcFC+a6A3BKyE7jQqhXy8pshKfeIppjhpBy09QUhSp4z05tMcgkg14mo9DY
 7EBVaa+dsgpdTHBb97U5ogxbPc8joID8mvJuOTwgXuKBHs9EkZhp/I8iZfFna1GoLWQl
 fVx8r0sYrGo4WL0/GQxvHZZuIetDIFPU+QFDlfo218BjHTtWNBCMXrYGDYiJCeHrIMDJ
 zFgclDQc7Cc7bthzb/DCAXnrsIaOzBADz8CEEtRJbw6X7ue4TxYgWghjbn8xfxZQQlOP
 ifnIDmO3lx8mMWvSJxRnOhJm/mcuMNevNIvgHHMADODIBo1rj7V9czEqvEsdcoGw3OCs MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrna54y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuN012963;
        Fri, 12 Feb 2021 07:26:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgUVKcvXHPzf/ve6ZY8TT0VutNHlWwMa4+nhV+BE6/kTD2URWbEFqksVEYcHP4axgl15AhP1XrfEyHPK5TNS+EFvNuvQ+8hfMIaJuYtFfShFEeR+jBsTsrxjpWW02WSHuDG9RcZFa7PgIB49d5t1O8iDCrOvz8oQ99yAFyaSvJ7pzYA6I//g9fkoCdc9MehJQo0Eio8IhnlWnSjvPTGMsQPZe8PdA0WQqiXpkhlZbb8DWhXyQhg+lI17Qznwq/MaUaVRuSPNqPCIRxx2KgthLXQb3QoJ+brf3thRTfzfvz+JUgGD2b1hFoTQ6++upuyKifBp6uX5Y4/02dp/Jq7dnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUJBODL1IXVQSYFfl92SL6pxemZJ3XrNJ7gAgMaSyYE=;
 b=V561QaTUu7XupuiVLjFLv20AShwiNx7OeHmhgnnVIBS5D7/woLoOFBtJD64864jDC/7de3T6vmWbbewFlE7nwk90xJ7SjYBNJ4llZJTz0FtTMhgX35bEZNlUXyIM+nJ/5yRfOUUEMKKzg5nXRJhDFE8Op/Yaih/yeVQo4y6ddbP+R0ESinxiFMXSgejDYUqyWUSdiR5l815aHyb9unv9lwMv9UqMs3NQFvBkJReh1iAu1/SwGQidjhHrxhXqr6fcxtonY5CNdFeSaiihMJ74117OjptEkoQFWS6khL2Qj4KwgHuSispsO9e05nl1VrwAtttwMBN6i/I+6aCDnt5JIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUJBODL1IXVQSYFfl92SL6pxemZJ3XrNJ7gAgMaSyYE=;
 b=xiHVzseNDPYAGK4zaF0eHeSDc8IEoEDDVpu/xyYTx0Mg0FTz/ldeqpujE1+NAcbAloicJXREmq1aLjMKjzpzp6AO1BC2JP9qmtvaHrXzvX3bPgJTvNuNhGPCB2sKd+6rCBLA4dsjsrIGRDrIshyw+sI+ZMfHHTiNhPpvct1F8f0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:26:56 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>, Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 04/25] target: break up target_submit_cmd_map_sgls
Date:   Fri, 12 Feb 2021 01:26:21 -0600
Message-Id: <20210212072642.17520-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c66f10e9-eb59-45e6-fd41-08d8cf27934c
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254F54525F328D08F103FE6F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUgetz7SYkr2G3wq3HBB3hvBYEou5Uk5t6QxLg32WUC0FFtuYhkdReQ21FDbnIXBkLkofrQq0/GGoUL5TFvJKjS5i1/ea2e8oEh2MHE2HCkw8xVvn+afRfulLKCpSzp2lKzYslMhgODW9o0irKOVKkzk483mtVJiUs8B0DvHmLy/o3ES9KMWuOzFkusXqtmy3rEtdXDyry61xolM+4VCS8GyMVEu2lWKt6O54WDB8qVwjMZs/kgxvK+2+nLOImNIoxFbxHZpjGo6Mpqjby6APdG2JOLa3gdbagYYzfaNBVNDSQxz1CuTkP4HKfRx+zGrEpG1MRtSrDCnAvNxz9nDcQ2d/b/lDi0U+pLQxXybRgtFmtDR90d4Pz/yZeimGEBhmh1gpB3vpWRnIAKOOlrQvgr+q3FZFQVH98nK//nL/bAvSokCSsxvkpdPOVs1H6a8dCrlyWfmZfNlm0ZFfATZKVrx21czMkDQw9bQ7RUPEcrjbQC2tT02YRo/O0dN/5AAV4EVcyPvkQ6H8jOPazngWIn6LSV9+OigrpVepqBki/o29wa+AvcN+w2SYQI8CtC24qkknCIkAoq3LhpacFT48g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(7416002)(6506007)(30864003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rA5+Vwm5i8w0PXe2K59Re+0ZE6RgDD6nkZlXmYK285XZmYtTOxmC5VfJLQlQ?=
 =?us-ascii?Q?rVcwHJEOjLmRhQMSJFFLmtSaEZePpDgEGWWwUzMZ9AIr2xnww2LDKinFxhh5?=
 =?us-ascii?Q?eIgTNtD5qLohPJZh4DvOo5O42Y+vo6ni6xsARi9qXxCHenwdlpKlIbc0/EsD?=
 =?us-ascii?Q?iGvRIx/1WrcEmYrDXZqnQtx4fE4SIt6HFlvQPYzKEaSOvxKPiBYU4dzGfRza?=
 =?us-ascii?Q?bFkhwlV3lQw3qrVeEG1FexP/aZLpjfk9lWKwqgVd5KCHNJDOe+ICDqCQ1IHE?=
 =?us-ascii?Q?9Yy588ZD4RvYLZDDNS1g8rrwEYoVCxg0VfKkOSryudKTYSHaBPD0avl4t+cX?=
 =?us-ascii?Q?rOKD+JwjU+K4qCgVtHbCBGoA3R7LrVeFjqeKtY++5ExWdUL+Hpwp2I7g5xbx?=
 =?us-ascii?Q?3Z/yvB3R21P9x6rZN8QFjcp/EbDOb0F8E/QH0y8sOoG3tjBSWW7BLUUaWDUK?=
 =?us-ascii?Q?ePXfXFD0eU7pQbQrFlrztMwwtF7ZuMOYiWipUNjWU6aXXCNlnyjU373iTv4y?=
 =?us-ascii?Q?d5DRL9lw9ieCehLOR1YOVv7HHO9SBnlxuZNRXsnDH+WlkDB2P2ZZGYaM1Zky?=
 =?us-ascii?Q?b2l8XxZCOvMX4gWd+dPrQVg8BMNaLktnuvrWD5xwNiJlIMXKK284WZn/PajN?=
 =?us-ascii?Q?q8xaprnnYOpTSotRyVROMiO+jN+MDvfS+P9qHMYKn7qDrsRE6S2KiFJ2Lbxf?=
 =?us-ascii?Q?6hr+1N0iByC4uCqZlIHXBqibEfzF95PI+m//k2mLuCtswX6OK9KJ4Qc8Rswv?=
 =?us-ascii?Q?WrvfFfDoqCheOTF8iYxMhV9yZzJLiEmz7zlIcg3ydOwvc6H05y7dwEIcHeON?=
 =?us-ascii?Q?IbHAqgsxYqp4phEop+VfnAftgRO3DIFHvX8kh3ZinH0FwBohXzU3X2SgvnVO?=
 =?us-ascii?Q?q7StkbL4R4UMPLRdTW4vDJkqXVRsIn6/1UDQYd79fkgecX5nYKSvixiJu0S/?=
 =?us-ascii?Q?McMS1pKIvElcOTkSDxmblNs+bG7fBh5GfrdDgVAR97E+n0u2LVLm2VTNRNSh?=
 =?us-ascii?Q?5ib078lqasTRjsUuD9j2AknURsJo1pPGsV2NyAMyPUd2um+YErmln4mhZAt2?=
 =?us-ascii?Q?Xn1fgSrVk9dkbCI3IO6ux50ICfPNQD6pVcKYCe3Cdobbsg7Ieh+gxpzTWC4U?=
 =?us-ascii?Q?CR5t6mXCMrNC3nqNX0C/LV6ekPYhQJHPANbsPvh1MgBgL7Peuy4el/Hcve4T?=
 =?us-ascii?Q?VYRHQNR9AmdCh9s6pVip/GUQjpjTcCFY6wE0NWSKIuqRnVna+n9Lf03lNH+e?=
 =?us-ascii?Q?xVL+H92X5FMuiDeVdah7qe9FZscMNOBgdC2zCyuC3n1NkKonfY/AUT8odxb7?=
 =?us-ascii?Q?IrFbWbsxfoE2Wmhn2oNNoK46?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66f10e9-eb59-45e6-fd41-08d8cf27934c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:56.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+nXB3nm8JfyraJCWPpKBZwOCROckV/9trjk5cORZyWgaawgbMB0k4M2AgoHtocScz5InqcEr14VsW6MNwUPK+7FiIDHP1jiR9bUYpbalXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This breaks up target_submit_cmd_map_sgls into 3 helpers:

- target_init_cmd: Do the basic general setup and get a refcount to
the session to make sure the caller can execute the cmd.

- target_submit_prep: Do the mapping, cdb processing and get a ref
to the lun.

- target_submit: Pass the cmd to LIO core for execution.

The above functions must be used by drivers that either:
1. rely on lio for session shutdown synchronization by calling
target_stop_session.
2. need to map sgls

When the next patches are applied then simple drivers that
do not need the extra functionality above can use
target_submit_cmd and not worry about failures being returned
and how to handle them, since many drivers were getting this
wrong and would have hit refcount bugs.

Also, by breaking target_submit_cmd_map_sgls up into these 3
helper functions, we can allow the later patches to do the init/prep
from interrupt context and then do the submission from a workqueue.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>
Cc: Chris Boot <bootc@bootc.net>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 200 +++++++++++++++++--------
 include/target/target_core_fabric.h    |   8 +
 2 files changed, 147 insertions(+), 61 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 013f4a5e8972..a82b7da09872 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,46 +1571,31 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 }
 
 /**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- * 			 se_cmd + use pre-allocated SGL memory.
- *
- * @se_cmd: command descriptor to submit
+ * target_init_cmd - initialize se_cmd
+ * @se_cmd: command descriptor to init
  * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
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
+ * Returns:
+ *	- less than zero to signal active I/O shutdown failure.
+ *	- zero on success.
  *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
+ * If the fabric driver calls target_stop_session, then it must check the
+ * return code and handle failures. This will never fail for other drivers,
+ * and the return code can be ignored.
  */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+		    unsigned char *sense, u64 unpacked_lun,
+		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
-	sense_reason_t rc;
-	int ret;
-
-	might_sleep();
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1618,53 +1603,69 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
+	/*
+	 * Signal bidirectional data payloads to target-core
+	 */
+	if (flags & TARGET_SCF_BIDI_OP)
+		se_cmd->se_cmd_flags |= SCF_BIDI;
+
+	if (flags & TARGET_SCF_UNKNOWN_SIZE)
+		se_cmd->unknown_data_length = 1;
 	/*
 	 * Initialize se_cmd for target operation.  From this point
 	 * exceptions are handled by sending exception status via
 	 * target_core_fabric_ops->queue_status() callback
 	 */
-	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  data_length, data_dir, task_attr, sense,
-			  unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
+			  data_dir, task_attr, sense, unpacked_lun);
 
-	if (flags & TARGET_SCF_UNKNOWN_SIZE)
-		se_cmd->unknown_data_length = 1;
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
 	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
 	 * kref_put() to happen during fabric packet acknowledgement.
 	 */
-	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
-	if (ret)
-		return ret;
-	/*
-	 * Signal bidirectional data payloads to target-core
-	 */
-	if (flags & TARGET_SCF_BIDI_OP)
-		se_cmd->se_cmd_flags |= SCF_BIDI;
+	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+}
+EXPORT_SYMBOL_GPL(target_init_cmd);
+
+/**
+ * target_submit_prep - prepare cmd for submission
+ * @se_cmd: command descriptor to prep
+ * @cdb: pointer to SCSI CDB
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Returns:
+ *	- less than zero to signal failure.
+ *	- zero on success.
+ * If failure is returned, lio will the callers queue_status to complete
+ * the cmd.
+ */
+int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
+		       struct scatterlist *sgl, u32 sgl_count,
+		       struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		       struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	sense_reason_t rc;
 
 	rc = target_cmd_init_cdb(se_cmd, cdb);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
+	if (rc)
+		goto send_cc_direct;
 
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
 	rc = transport_lookup_cmd_lun(se_cmd);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
+	if (rc)
+		goto send_cc_direct;
 
 	rc = target_cmd_parse_cdb(se_cmd);
-	if (rc != 0) {
-		transport_generic_request_failure(se_cmd, rc);
-		return 0;
-	}
+	if (rc != 0)
+		goto generic_fail;
 
 	/*
 	 * Save pointers for SGLs containing protection information,
@@ -1684,6 +1685,41 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (sgl_count != 0) {
 		BUG_ON(!sgl);
 
+		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
+				sgl_bidi, sgl_bidi_count);
+		if (rc != 0)
+			goto generic_fail;
+	}
+
+	return 0;
+
+send_cc_direct:
+	transport_send_check_condition_and_sense(se_cmd, rc, 0);
+	target_put_sess_cmd(se_cmd);
+	return -EIO;
+
+generic_fail:
+	transport_generic_request_failure(se_cmd, rc);
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(target_submit_prep);
+
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @se_cmd: command descriptor to submit
+ *
+ * target_submit_prep must have been called on the cmd, and this must be
+ * called from process context.
+ */
+void target_submit(struct se_cmd *se_cmd)
+{
+	struct scatterlist *sgl = se_cmd->t_data_sg;
+	unsigned char *buf = NULL;
+
+	might_sleep();
+
+	if (se_cmd->t_data_nents != 0) {
+		BUG_ON(!sgl);
 		/*
 		 * A work-around for tcm_loop as some userspace code via
 		 * scsi-generic do not memset their associated read buffers,
@@ -1694,8 +1730,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		 */
 		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		     se_cmd->data_direction == DMA_FROM_DEVICE) {
-			unsigned char *buf = NULL;
-
 			if (sgl)
 				buf = kmap(sg_page(sgl)) + sgl->offset;
 
@@ -1705,12 +1739,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
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
@@ -1720,6 +1748,56 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	core_alua_check_nonop_delay(se_cmd);
 
 	transport_handle_cdb_direct(se_cmd);
+}
+EXPORT_SYMBOL_GPL(target_submit);
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
+	int rc;
+
+	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun,
+			     data_length, task_attr, data_dir, flags);
+	if (rc < 0)
+		return rc;
+
+
+	target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
+			   sgl_bidi_count, sgl_prot, sgl_prot_count);
+	target_submit(se_cmd);
 	return 0;
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4975c4d2a933..4b5f6687393a 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,6 +151,14 @@ void	transport_deregister_session(struct se_session *);
 void	__target_init_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *, u64);
+int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u64 unpacked_lun, u32 data_length,
+		int task_attr, int data_dir, int flags);
+int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count);
+void	target_submit(struct se_cmd *se_cmd);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
-- 
2.25.1

