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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA174C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7825064E79
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhBKMfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:35:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhBKMa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:30:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCO18R139515;
        Thu, 11 Feb 2021 12:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pmZfKSFF2u9HV5P4RAb6IslzlbYKwVdkQUe53+3I4Ao=;
 b=yBvgZZFnCpTIV3EOSbpGVaXgjUMpfINbE/HaZcV46ANf4UOfwgxpVDMBG27fGJvXW6Ip
 at53b3o4g3yv2wv5LKBDC+qxc/vIF3rvwht2ONwj8M5sPh2mPA/ahrV4QYOIXL0tLZQp
 ORWDXJHMEFBRCMyA2tDOAIQJoEeSLGH2jzJ77Ob1D5p0ao+vvVCy7VepVrD7iIU4kd1w
 JEkitzt7fumk5T2izbuE9tV6RkwK39EwgzNODtThvXrGVgXZ2zKiaYEOHnJpNeTm1yN6
 3CP2TyJMmefLaKQHOUvolp68Z6V8APPC13eEv76PsR7fV4yZeN4RiXMk1rCySG/5X1kF pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrn76ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP7qM052228;
        Thu, 11 Feb 2021 12:27:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 36j51yxtx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cN0r0WHEt3t+bdsAOeSs/7ZDta4uwRpl9z10iVDIqxIUI6Vp4vTWhF1ZpySvY+ZyuWXJht3/u9zgePUDJfAr69rIIK6+61MJ/qk+JLxUHHi/V5ycHpDys6gbEHIjvMtyJSnTAfXLwvvtUoyludPNkydEWRiI8CfuqhmcMks+EcskbMGXMJszmuKFO9O9PcSApff0VJfTUWCWqcLY/JM+8cLjgMtH7V3V0eVjn4DAh5IUSlrMQYD++7mlA5O054zhloFHYLrGSNMfIGFJO8oT6Zst9tfyytTidw/AiNGAk9vyYXvQ79VK6+NIYZ+kF1SPgjFadSgMrw3LTwywjesZlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmZfKSFF2u9HV5P4RAb6IslzlbYKwVdkQUe53+3I4Ao=;
 b=X8bdmO+CTj75cNKajl83LYeZJ6k5N0MxMsrcBr0V+/ecsushLVyP5xIgFRP1BzgR7tV6/hxziEeQEi1RxzlNB6lJBkAYmzQX2ta8NOeMoicqma4Ckuib+oyYo9hsx9BpWwnF64RXRoCVp+hkZyV5KPhz4D8MfbeBvwTFy14JAySJyaFuweKoMwFVGruYACqF35LZWCuhg0mcyE76a+e/pU8g/nzVhTS+Cpz/BLOrYFz7/9MBWa8tun7Dl6PNQVbB2oAe/7qqXELn8yinn1Z5McpICvNLtPOlnqbPY0ma2Xik5DJszPio4I7hD0g1JK0pbmo1F5gQfn93bM9hqH/6Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmZfKSFF2u9HV5P4RAb6IslzlbYKwVdkQUe53+3I4Ao=;
 b=Yua8jOP5Uh+VTvQPRTiLYPfSMeHKf4lC6vQpkGYVRdvUdZtARZoRBwf/KjDUOrokRvPq01e65eIJI+2WBtm0/VsK4DIWnVxGY1TDUDHwsRCN/RCIpQBMv4M3Tuy5IQyuOw4GxSg8QYJ/ubpMnCpLb4gVhf3R0EvPdqMiMNnaDFo=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:43 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>, Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 04/14] target: break up target_submit_cmd_map_sgls
Date:   Thu, 11 Feb 2021 06:27:18 -0600
Message-Id: <20210211122728.31721-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1affbcd1-67fb-4e91-2797-08d8ce886dee
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339D2C9FB78F07F9AFD898CF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gW6B32Ve3mrpC94ysMqZmqLqEIss7RXOd64yUR57H63BFzPNRFIbmRSOjjUDFFqcyjqO6VHD1yCN5+ZtcG+UNEw4OhvUIIhDXNXCztmRq2HvKKUIds+wH6109WamBRx+usA31h4GtrYCqm+capLUy/IQUyY3xaXVP33Pi7oPtpanC0o6CvbOmnnLcwmUScppOHwEpl6BXKGBQfAKsbl8tNIos4isVUvSCGqBI99OvIVyejTT+/QcaqRU2wY1LwJM/bd+1K80ylONdLDmoEpcqZoMsRnbmq+M9C9EuG440Jhe5TggNYUW6f1S9slLC0HvUpSDTcwmAXXyJFQppPVSu8Hw1VBwLTZgB+fSOu1UAS/iPec+8uhLSaBg8uN512juRw89zQ5L1IaEWGiXNVlRmuwT2hRokHHBTRVeWlNTq19FCNti+HLoqh+I3BllO/FFkPwTaRXIQBXJCqxWlFS2Ftiu+HrOwf0WSIVV0rXNkGaqdz04ciG5LT2xS7EKUjlTc0ZSZzSlrjRxs+7vNUusDovH+I1iYErUTy9qnLP47rFE5tbPfNhbF14yFpCtH+7wCoDAHTTd4Sj/pLoiSHzQpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(30864003)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(7416002)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d4aXNf+I/wJzxTUNeTE6ZySsT5sQbm+KZzXvWkss050VU0Vh4RbEfMS4a3nK?=
 =?us-ascii?Q?gXjQt0rAHJVPx4lDWS1CPKQ0+1gEyib80Cpejh3rz83BZ9mXCjLq1oGQkReu?=
 =?us-ascii?Q?T3YhsNDjkCrZmpT7UxF3XeuyBftZFhllmiH6Q0HgrVBKb+rX6/SeeopYYDs9?=
 =?us-ascii?Q?59IUgBHXY7wtas1h/+0ckP/KqEkDqQvT8pmJibScuwYi5FX3d53qZFHvL902?=
 =?us-ascii?Q?giAU8hK1q4wsGt3yDfMMU15qt566n+2Xm02HlAeBqiqYLk7hzJNeJ3+YxFV8?=
 =?us-ascii?Q?qm02hO2Pnpc/XwQYfhLiMG2B/qNqGDSAqx53uIZWFckPqvJMplS/j6l+1F0u?=
 =?us-ascii?Q?AY34yJfsxxV2mUMAScns0eMRonYxN815cO0w2EMMlQVyvVJIEfNkGo3VD6gR?=
 =?us-ascii?Q?O0rYkRieQLcKNReXTy0HmA/Ky9IXhdFkzIdQ4V7ESh75xExLMamY/+hpctQa?=
 =?us-ascii?Q?uPWJqTjfMJIVSxYksLgotim2l8HhsfBJ9ycmT+S/cvfvk4kTnTLZ/db0LbUO?=
 =?us-ascii?Q?wz+WISBFNf0g74dPnqIraVFOP5S1ASPIszIFbZbyTsHEJuiBtp4+sD1Wganb?=
 =?us-ascii?Q?RQYgoq7Xud9oJR7A2GgeDVvBDFZmNJRVXR7TARpt+vvQokO2j8fNOOdCy70Q?=
 =?us-ascii?Q?qAtmtKPzQewOZVlZSAxhrNAikVnESD0yb8gsNs7Ut6Rv1MfgX2meWDwB8dkp?=
 =?us-ascii?Q?ABRBIeAGcHXujeoJqlNL4GnAu3COnWxo+lOxzxrJAY/Tsh4xjS6lt5Pv8lSZ?=
 =?us-ascii?Q?hfb/dWc8jznpaPEFz+eAlhVnUcYtXBL40wBiw7TanDV1ERJWpkoPuimEcVzE?=
 =?us-ascii?Q?MS/epRXrwq0Y+2+H0rVXQ89DT8x+Dsq9Agl6JDWFfyrtZffCAdVlScYzd+O4?=
 =?us-ascii?Q?gPTZgQsyUGa8MKARg4EkCRD7rzdzChZ1mp2fMb+CTVhApmLOkyPC6FFhh2cv?=
 =?us-ascii?Q?BN8lAxvSfvejBvhpAtPXcuZlsyDcLqMYWSiOHnwvsW/DkCTJkzW+PRKC2nE5?=
 =?us-ascii?Q?QKSN2eweGWJw2Fyz5HnUXF+eEVQNg7bcCYAV8jkBaQgW+0lFcB2WdzINQ/PH?=
 =?us-ascii?Q?esxdO6Ye+n4dhnKjlXlym1deufBfX6jc+/7yp3Veai3KcuLvJqfpswqdJ5h1?=
 =?us-ascii?Q?zTmv67lXIcjvzMCZHKnUkCMgb85WBHBHDnMAXKGUu1IExXjhCgsiozminXyg?=
 =?us-ascii?Q?mv6GF3NPBCoGEgPVpfz5tfdXNE4rgB7UPr7vBpamJaEUo7LJ3ol+Z38ww5Ct?=
 =?us-ascii?Q?YZKL8LrFSmKIqqt3pU61CvROq/O5+LT0ELspJyvyzZs+4xhcIvHSyZBrYBTk?=
 =?us-ascii?Q?gb1A5d4zMko0yW9YVGhwBTJk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1affbcd1-67fb-4e91-2797-08d8ce886dee
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:43.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2l6iqwEowrfbsUL2Q1pb+hy78MW/ZNhtx9gxvqcMdf/9r9ZG21OnCQbY4jpvi6xHeJ52HA0aMW21CLio3R4UO50cD/tkrkISgENTySX4/Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
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
helper functions, we can allow the later  patches to do the init/prep
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

