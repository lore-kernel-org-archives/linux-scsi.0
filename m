Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEBDC433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E77BC64EB7
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhB0ROE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhB0REm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGx3wT032483;
        Sat, 27 Feb 2021 17:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=WWFTh9C1HUXAIrn0i0totpd62YVKitXCq2mmiWk1aEUE9cCv6OWw8YIWyCzYaMSYmxkk
 2D3j2IfjLDjDbavBLSa1gSCyY4m5+uRMBDKhzusi014JKWGpbPG+zkXY9qfW9mx3/8rv
 qqNbnVl818QpaKsxYo0+0pxanwv9mOGf+J3jG4El7WR3GUUv3rkKtsvTuQFKq+m+gagm
 4ey7xrKg9hR49XBuNWiae1Ia8v65qjBRgIktHpaPbP4Scd3a9+rfWSn3HPoEpO2pQllV
 0o8fvAyh/OZSyRj0WlC704o61i6FZcjqbZ2EAiFpa9g13L6DOsPOrZ3FRe9Y3MkwUvOG pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmZ115709;
        Sat, 27 Feb 2021 17:00:22 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4Aig8mOs/yPIewASUSQQJILPbmszM/mEW1rlOCBc3boJHPhxcMwdjlm69jxlN/ed7KhcSOVcUTj3JTJjeoBy2YDea08DTmRuZt78yX0IuVACKwiUpMCYQyOQ0UL2GTZHNAbDrQIpcux7z9hbsdpqGyIEpuDmWWRR9pVVIXNAa9eUMGvDDAQ1O2o/Yoh2SVnQD57vdnKe1TrqjNMBsjIkV79TmX0bZPuqQC+vY+0Ny/6rK9tb3zlrh86cKhEK446V273dxm5AhrMHk2ziSPILGKlgxXk4lTs8sfTt/EQs7iQVBu/lCH4fvVW4CipBg64xQsotm+KrxH5zLDKuwXZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=YWwwTnWxRAas4VIkKLnIeyKtvj6QAvSJPGD1/5RMj0L3jwDeN5uO14ORWTP2mk1Qtx7+zxKUg86a9a8i1JUUh1XoEpun6sqL3T+RCoF9lFnBWg9UiPlq2ABt+9NWKrS23Z9n/TGI8/luj7ZYp23fAtqE4MLbhHBGh38gJFH8LYjq77IKlF7N+YezPDyOY52XWGTDEfe0z3u0aMouHhfcqhDnjnHaUUQo9mYCWVkv0j58DJ7T2mAbl6cFgqqkdjkiVvvOHu2x2K+mdroQh0w1CQnCpOIdhVoRZ4BjD1GQgU0eU1PP5PIaw1VFHfrpksYSk1w/TAoEF6mMFVDcTZTGUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=ygVfCHeAMAyYlXenHk8CaFGiEmx/kG1ZxPJVbQAxjXOalSwAmVgTwAasNWza8zK3+6u8RpFhC+K3qd/JE40g9LqJRXnW1vebbUVGjVvq7ljkhgd9UFNpH5DYBPa31o309jkfrz/9ePdStA8f53ucoWuxiwwoBTYl2zUt1R+0kuA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:19 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>, Felipe Balbi <balbi@kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 04/25] target: break up target_submit_cmd_map_sgls
Date:   Sat, 27 Feb 2021 10:59:45 -0600
Message-Id: <20210227170006.5077-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef7300ea-f44c-475d-e770-08d8db41296e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB349999075160B9AC039DD778F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AD1mkyVBO0XUXRZecvrXwWrNSKPRBxRFaK+yxrsWHcAh91AwmgvVZfz7lOSV1reB4eICBrGbOLsxTA+aEuWN152p8fZy9rLghoOe7g/YvMbNKlsKInqgBIi/NOhiDgtRUXb1an423va9s2rAg0XMOvTuHioaCKOPlZiwgQKe7tAxsAP3cmAjBiuGm4gSZihdBHs3UfUfY9G7qMt/wIFhZPX821Weqqhhgen5JsukL2JQK9PwXHRnGoRFxTFKwyB3Z7oKGKzvSqRGHlZ8C7M25gtROTFs8srxMBtKgrELhXXtx4WAfEclc40GHPyNuo/Q3pdJaUoMBVdBLRqwsvPate3JGxNURU6Yq8mNoi8e6QficBpJIuIQLjIguFG0wVXwwJ0M+1JY0kEMH6DJXOAWbRh6dnrekI8eOVHpr1Xv/wgmLkVUy29BNYmaiJ9X6vMKOY+4ZM0esHoH7fq9CUuW3UzxhI69r7rEDjV2myeB3CeMwtuJ8Mp3CuI7dwHHyyo44cdyRaKe0hFjITfaXy161j+n1awmnlg+u43r4UfdjxOiXtDiXBEIGU1eszB6ViOLynjXeLr0X8/AT0RMXfj9Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(30864003)(186003)(16526019)(66556008)(5660300002)(66946007)(7416002)(6486002)(66476007)(54906003)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qF4yP3LqJd8BINDlQ/0JcY5hSpTJ+6rvXxANWlO5cNLQTCXOuywUTwS1maCE?=
 =?us-ascii?Q?uETYR5Gp8RqZDz+iUo8hFlkuo4olvqKw564XxKbrtbWK4KcFElkQDLuc/REz?=
 =?us-ascii?Q?1YQc0wmG2GZZiAebDtMXJN7SloxYw7JR2M+0+q57lNL4RbVeWiNV4BilFHwT?=
 =?us-ascii?Q?eQNCVvQ2D+ODVGJAHnQAK103A7rxZkREWfVKqhZVCPmGz/CWvg0wuGjRBEhC?=
 =?us-ascii?Q?RqW5D966Bae45NfFKu2GPJFMl0CAnCtNVgJ8LLIboUuEvK8TJXSEfn6NXEIr?=
 =?us-ascii?Q?zgUx1fzpku7sR7myX6JkknzRvPnuCuOHeEkPSgSJVlEodWSyDI7fJ6mThGQW?=
 =?us-ascii?Q?wVjb15IOjwqldxrBRtyktQK+MZyw0m8+6AS6oIb+LopQVi2lOeynu+/AHFuT?=
 =?us-ascii?Q?getI9lUrdXDbF+rl/XeyTpezFpweO+tOzElqN+NtphVaGN3WBfAHMtBRnuE2?=
 =?us-ascii?Q?a3wPQBqFzkGfZzA9Qra1y7AikU0dfrbSYYKZteX8PZrxGI9qZDV5phAVACL+?=
 =?us-ascii?Q?jW3WANEOgpQF9yano+Vn/T9m5CIyQrv+f2YLFtjoJtbIT3G3LWfMKYtXHtDx?=
 =?us-ascii?Q?aq7+hcCdRMalj+bBPTuEpipnD+IMo/ppYRHddWCCuAZgJKcrZb6G9jhZ/vkJ?=
 =?us-ascii?Q?ub5DHqUPZJ5IHAxxqpTwS1UqrgPTCkhF/jWY8JQMZaJl4kCID6HOTqmOj7GI?=
 =?us-ascii?Q?d0NqWWgiyFCM37xuQxto2tatW9aN1s86peQS4DTi0M3udFkJWiprZCkGu4hx?=
 =?us-ascii?Q?MTVVwQvFkLbP2zz42A74fPu0tP6ft6OTp1eVTN9TlTEOLrb8a8Tv3iAqVgFy?=
 =?us-ascii?Q?6iJ0pAjmnc34j7JCjq6a8By0kRrFmpqliBREZE16RYJfckrCZq5eaiR6VZhW?=
 =?us-ascii?Q?2joJkEQhlKRMjRWfj74+lS8GQ3aizDqJIgFEsIPnH90sFBFVhDipbaePJ4lO?=
 =?us-ascii?Q?/clDOH84Zp9JiPGwWC1e0TxEsM9F2NVzNMghvYRZVQ5NbNllALOFUw/BW/xU?=
 =?us-ascii?Q?C2RLE3GjwNXd0TRctEM3YQUOpfOVFTMlBu1TazRsRCewe1c5twUSO6AilkYW?=
 =?us-ascii?Q?7p2JxdF6NcvOUj/I6D8rMKQwL+y69FwaI2YdBXNBLOPlF1etbmTb1U3MrDFL?=
 =?us-ascii?Q?8cMldfsGxNr02oOjF6F12ysxSaWq3EVmxZiALvyRWGq5Nxnmm0Q7augtEsoj?=
 =?us-ascii?Q?gDdOaJ8I7g5WHazBmoNQkan4tc7QsTkRdBX/z12RYw0W6Ir++vTL/pFbmQA6?=
 =?us-ascii?Q?RCSeR8SMPvNGM/J+cqeaF+f1BcOdZ+uJtM8L3Q+fgcLNcm+ehjbJWNziaUS/?=
 =?us-ascii?Q?Llnau0t7SxYncf7DjF39fOm8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7300ea-f44c-475d-e770-08d8db41296e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:18.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmaVXY2o2kzkvAC5nKhSJWhm0z+IK1Y8eKjuaicqzEzHaZiBnAXH88YqFzOQuPbJcqBkY09Lot7A07JTuE6uhtrPn0wxVelK9XiiF9EUOfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 201 +++++++++++++++++--------
 include/target/target_core_fabric.h    |   8 +
 2 files changed, 148 insertions(+), 61 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 013f4a5e8972..8b2b805316dc 100644
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
@@ -1720,6 +1748,57 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
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
+	if (target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
+			       sgl_bidi_count, sgl_prot, sgl_prot_count))
+		return 0;
+
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

