Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B60AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223D364D79
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBKMeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:34:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhBKMan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:30:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCPwwP050964;
        Thu, 11 Feb 2021 12:27:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QSXy+u4wfxMoiI3PlQFsQTziZQjSgeni3stxI0PcGdE=;
 b=YYfR6Oin3/O7gwSZFZdf4cqZOLVkfOwI/ax/70tXd4JKUs7WB8M/FGyYm665nqigGJDq
 CBzXIG1G9s6AOZHnmR8gX4S8W16nrVQZTWMX5Ps91aSa/+IqFeSOftC/dhZ/sZw+OpsV
 zQjfQzDVy64a8GGIN2DP2sWifGiTil8DXCGF8wC9XGscJtrK4k3tg6jjvGuLkSxmAeqg
 AqApRqzeHm26nBYWMIQIO6Mjnj2QdAUd7aos1J2oGXIW30kbnfo+vskYzgbqeuMxAFqk
 qK4qME2JXnjVZYiqLtnj285KAXs3ggz74WL1LqSU+Tq9vPZHbFa7hLBzzLKEDUCfsq5F tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4upws4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ2iG193594;
        Thu, 11 Feb 2021 12:27:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 36j4prg5ak-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8kjf84axy5SbsmYLWpQ8KOw8dUPSMx5MWhCEOnUXBFla2FHq/673jYXqtvQ6PfF4LrJWoxiGycgHcHWwYlSms8vw/BrIpIXj9SFvLKgeo2Fo16Qt2bMnPAT2gP1RNhGsdvFa3JiQ9pVGVbXt0hl78J27oHTLA2n3FBo1tdVJ0Ae1XcizmUl2KLZijz4tdefhLq1LcJlnHVNtfQGV+BwECLhw72kzJ8tEMgu3/cfQF9WmyiUeI7Pv50vYodM8IxvVZEo1MdeVbmshFUnyOqU0R+AnMiS6tn3QSWv//xpaXbhR/Y3UIRcMfq21TyCum+3cGxFBxVEQD1BdQo1gr0RdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSXy+u4wfxMoiI3PlQFsQTziZQjSgeni3stxI0PcGdE=;
 b=eBPE7HcYqgwy30dNXbWoVrZ0uZqhWrQO8s66U8WvZHOaliw40VNBqvjVtw2rcYOVhotzE/mMjGVMD1q1a+w9DLFODIPC+EhD5lx9Tgwa/AsBnlbfFcrynFRt9Lu5Nu5sscWlX364dHXhYJkEkewo/dI3lSosYrWcOw+kDnY2sRaAldUWJTtcSRG4qIfUbK8nCEWR9SO0Wtt9M0Sbdq0QXxdQqwf3L00i7DO5JB239N58AMSC7KF2IcUQOViAOmLjhaU6mcwG/RyvTS03fC4fhuhMMTQDaC0G+dpQtynLSfZGNvi0YY/Y5PKt5BCPC/Ah0BMmetoELnZHhSMMVDp2hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSXy+u4wfxMoiI3PlQFsQTziZQjSgeni3stxI0PcGdE=;
 b=KzC3Kg81ghkImhUO1u6yYWOpK6lnBSEhviRy2WVWsDXMEXxegD2QAqfvRLUo/A3CfM6UEvuqUPM2OfPVEXZzR/rC/dfFdaW7dtHdQjal+3cVI+z4F0msRzJjA1xFX/pWlpKojtVQ7wMSjiBSTD4+b41zRJEjfpYapCrD0ewKROU=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/14] target: remove target_submit_cmd_map_sgls
Date:   Thu, 11 Feb 2021 06:27:28 -0600
Message-Id: <20210211122728.31721-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48a133f4-0ff6-4660-7cd8-08d8ce88753f
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339B57F74FC2EA27DC83854F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+UtDyH/BRZo3sNVfpC3sqIJ6ZzexeRZWZBWvRqkJuxLSLCwCpGS8yMm241qTLVqsrHeukdxmeuIbEYbnGZJMtRd56CGG4MFIqRQsf6U8KEVIfjX1xN11hDsdLnZUCDYf6Sne+z8FCDfXsiRYr9fuNe33ZmWiracVwHAAqW3TDa8AllLfac446d2bstyY/Lc9ot61T8LXdBXEm2ovIZgIcLyEQrzeZiC66Ibow7gQ+x8O1zgIP0z4nUZoh49VmIN+TTGDbnDqn+ru22Q74TK10QEVAYxGq1xJ2t/mbx6hQnNAifNPuZUseLqjY2kXz9zYser4SPx89KHZY4jsaxYJvc8Idanrv0p/EukVZeOB2EEN59CmkFO6NVxPjQ6Ng3iqSDW2AnYZhOdsIBxGmNOeYyuClP1hU3gJM4MZ01YaFRCMzIbUJNIwsWWv+PCWtXLXJrtjnblsGJjGh1pFZRCrfJoFxekQU2/gF+nLyDFF4ec3htcIxBcgbEBhkCKmSVXUWgp4P/rZnRSJ4DuKeXMGTHbLvI1Hnm68eLIsMrPqNsMkww8QbM+wJy0Is15glb802+Nn8pvSb40srN2PKH7xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fdJLrVr5UwBK8qfKhQbAodlCSAVWkr0TE6s7F2cvoqxzCuMo0juqZHzG6Rla?=
 =?us-ascii?Q?D2K80Lega97q7iym9nTfrAlhcFP/1JtBVI1KTOj1KUt6GiFSKLf+oq5wZlva?=
 =?us-ascii?Q?SVRrRbuAkgqTRteoZnoqiBMdizqLmTJ3eBqgZQNCAus6Mq+V4hFFU9RPJfrd?=
 =?us-ascii?Q?AOHsn5kfAYWZ53sJ7jL7QLNyhgl6UVoOzCE/YRnNA3tJtk6qGHs5mUIK3/ja?=
 =?us-ascii?Q?NXkF8/tinodv2B1ySHimq3/bMmRF9WGe1lq8NHhGqQhIq4acUSt4PhrVqcQ0?=
 =?us-ascii?Q?wZnrnmvmj1MwGJqFAgGFA6qKUDMyG8ffWa3GnfWLtnNNJMuVyH6EQIUZGC3w?=
 =?us-ascii?Q?09I6Fz9b+ybef3WU0XQH3o8x7HolmQIg0X+hLH/hhQmQezUmtmVWUdHjEx0j?=
 =?us-ascii?Q?+CGNuf6gXwgxFTy/UPsvFNzOEG1S4XIudFt/ZygyG1qmS+w0kT9NDIjTNbe6?=
 =?us-ascii?Q?AP8KvCZsQXKpUJ4Zck5/1+C/dmMD0nYHbpFu/mJvInYM07EYmaj5VlvUENoa?=
 =?us-ascii?Q?ezdydpluOwTd4LV4HZCXc2UoMeMT+tE9uevmOAnSXRrJoLkdZJj27XsGMtdf?=
 =?us-ascii?Q?mIJhDHfKfdqqIq99O9MwVwn1uK+Jo3yEiPTORljPMJNZcICckPTcmBdTd9Er?=
 =?us-ascii?Q?659eGnarrfZt3PteM3eR9M4cDZ92iJoE252r9zTl9svT9FFeF8pPk2i9GwmQ?=
 =?us-ascii?Q?SUdrckX1N5TA6KulMl2ACmvEP0tPuYO0ajhvjxqnlgZzKLkZEmNHAvh/1U3b?=
 =?us-ascii?Q?wJLHsdpcs1djIBCY/JppOz2oF9VwmyC6Y2+GXgUwmYlpdwPOMeKnva9Z4HQ9?=
 =?us-ascii?Q?IrOgtScPbNS73E+gfpetNvkqzepkqVW/xTdfy2GEqrwaqkWHuBuZ8GH0UATi?=
 =?us-ascii?Q?/wF58oQ7MrX9BcscVmPWpJCd0NRZ4iTVFmRlDORloZDYnKbIdG/WHigldIeZ?=
 =?us-ascii?Q?F7ItsmsdfxCOYPbFZomCoUVgKYJ+TZzo8fs3vuDxGmA/7HVV47s2sCSa030a?=
 =?us-ascii?Q?L5q2lum+9I+aOXW2w2TNiqJEK4jDoI2vPLORQETNLad1gd5oqnLjCwrPGtt4?=
 =?us-ascii?Q?Wd1z+Fx3TtsLjGX5VS/kZoPTX2TZQAbOdzqrXYQx8I5FWJROo3wZPZ1XNpQ5?=
 =?us-ascii?Q?mLudEoTiIdV16m8z/7zUFgjX+DMxvG+W1WRUv+Uk60xYi92ZPdkiDzxUbV3E?=
 =?us-ascii?Q?PRLKlf7Cdxq9iySUcg7XlaMQBO/Y7C9SgndLWye/Q5iRdyF0yTliC+eBMYOz?=
 =?us-ascii?Q?XZ4WSAIazjHvyxE597Ifrfu4Q7mmfwRwkpEYFteqMjOnJBoWxfn2FFzPf/C8?=
 =?us-ascii?Q?qcvn+UoeZdEJARqmgXPI3OlH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a133f4-0ff6-4660-7cd8-08d8ce88753f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:55.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhDYrCWvS56abdnSAYpDJBJhx/iZLglHu+KVvYegwpop4muEWLG/Qb5qudnBsSuJb5pDRwYRjinA/zKDLtfS64ylZM3MrRJ87d/OTZMfFuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert target_submit_cmd to do its own calls and then reomve
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

