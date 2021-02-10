Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6AFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC97E64E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhBJE5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhBJE43 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4riVw025873;
        Wed, 10 Feb 2021 04:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=aCMC5bXAPAL1eMwDWGN98u+GpghLdGNZe/Em9lHFEQQ=;
 b=vvezbDNyvt5OnaijcamUjq6eeyQfDzX83RqokFNZ9A84hhP2hyrJrMlB5U+Jrmmz9uZj
 E0vglyAPekBWtdm8GSR9+znfzohiik/2meCE5eLBBA0gfuRtxaw6ZULpi3wpMgE8kbgT
 JQEsveoyPuOLo6+v9EGGOG/jmQr7txEm4oiaihr0FIsWFO7h/FRXTM/EmK/+LU/FVZiV
 zQraMgTtwtDXXJOKGvXGFTGD0v7Rzd9vsyVQsgyMKZ30gTrbfFitvYG0Pz2VrEfpHQhN
 3AjaE2udGZAuB+N6s8jth4zxLEhjKgADw5nl4JCmVGF3nlNFpkFC70H+HRnWeEuRGNVo mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrn1uan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBE048727;
        Wed, 10 Feb 2021 04:55:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z94r4fdYvup7BozDBJjDT2f631+1zGlpzO4N640ouybfjLJkfOzyLUEg11zL/4C2syDHNYWbCcP7LzOOgB/uHvwJeIL+ZrAQSix/PtajNFDYurzi448nl1vqXVzl3nqydfImc8Qy5AJX1RqSkMpq9f55dDBVa60wkQnjQa4sLR5A4BAPJFxtjxd53Z8LmuLp+O0H6ciMAAy6PzarNcAskG0EdLX3RfA2zO+OGF8JZ3k2/GzhV185UeavSk+0wgh9mFA3zd1aIHpzJ9lxTWE81GpIQXq0yXF0TgN3KlucmePBKd6goIj7GlaaOc+muxD5ljLybO7Qzx6fLb0N1iq/8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCMC5bXAPAL1eMwDWGN98u+GpghLdGNZe/Em9lHFEQQ=;
 b=KgSgcwp/jOj3/jq9cEZ7n0RcWtLWK3IsPUppN7PP0mJ4aNuzY2oL0/PebhDdG4Sw5MgXXZGeuzOrGWlNCaLnpQvn566SJKdf49jRpVajS0aUQ2LoTL0sYL73NHW9G2NvBs/2sgw8KzvPlj0cUAJxGzVL8jA7fYYdMmdLdErEpc8wX34dSZ33I1LlAYWTdjHi4xXy6n4caqTnT5YrxO8vNNjTs0Ms/9jpU/PE3+Pzf4gSKKbd0ZJm57f2gTypy/+0v3OjQlQ3LOgIzffmbeiRXa4vdKWlcui0bSYWdoQRNZnZpm4KVrtbfaiOU2Uttj/QFOsZcctLGmxIhqP7hRCRcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCMC5bXAPAL1eMwDWGN98u+GpghLdGNZe/Em9lHFEQQ=;
 b=k1sE5Vko3ijjbmU3QhL8R88TqgATs9eQwPlC0rKyLYkwyMusrSCjppeNI66Hys54jogo+tqmW1jGYXfkmabB16ZgV+joL+ijWEDbnwEnc01aJt9WsJDpiOQI6Gi4A74slIstLJokVYXs3PReV/XsAZoAqR18P6AP8ODmkkNBwVw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/13] target, vhost-scsi: don't switch cpus on completion
Date:   Tue,  9 Feb 2021 22:55:15 -0600
Message-Id: <20210210045516.11180-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a169ec4d-8c84-4e97-e601-08d8cd801d25
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33663B86C98004C6BF41FC4EF18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLWljq4WA8x8BsCl0vP9sC8DwB9TJznbMQuNWZZiAP9eaqA7Ugi9XsMifaliWJWnP/gtNEONUEkV3LE1FwgFa4pXfQ41AVlWX1igFmWpTse5I2wthsQ2VjCQNpgmjHnm/McrSmWNa7zMmlgj9lbbM8lcABRqfcC2AMk6lZRdnQld0PCjchnkQeGjh1DADMslA6uIBSTdaM2XuL67emlwiSop3D6BSbvFLNaaNCmRAna2+pZU9JMbznx/EfSCb2dd7g/cLFDLSTozQlIMCj4X/FBteP8Glxa5oyWaoeH4F4WA/8C22Lb6TWR1AKYGh23bwCGN6jM2BG91YOLAfkyA8trOBkswj3dMlx6BHY1zX+Gn5DY6pxcmgKKgGe15j7z75JJmv2o5cT+xwW3dFnz4T0TUwQiRe3/BeurO87HQd9c+HOBIQgAMO3PJivCk+w0bv7K7rXcIOf0+pQawnYIszFAMNkAdR7tO6n+32s00JNP7DchJDNTKa4fbsDTslwRr2sVCkYPHgBsF1GJ1ddnSl6sNNgJ88KDXh6cIBDSLxXqBHNB3837WrDDZvIXDE1oYXLYTDo9huKsYDNPR5BZ84w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0kfYrHHNVkjrU8jBkKpiUK1mGoBdiuDTe8GRGRqDbc1bRCNYgXwxuvypvYew?=
 =?us-ascii?Q?WjTfkk0tkjcsH49EmDQgptB/bPw1AvOslPpP6heVTU9BSyJGMvQ/rZknEDSy?=
 =?us-ascii?Q?FBjsusY3Ey1IelnUWnPQ+DVMzG1MTxbETfyI7vFDIXeXICqlsQ5UjWtTp9Pc?=
 =?us-ascii?Q?a/8fV2KH5TWTfM3KQgpWe3yUXKEfrYl52nCBhFnQe3zLVKXhCFpkVmReDsWd?=
 =?us-ascii?Q?ZIE+WDkvtZKSZR4P3Z0MHbjSnx1mGPcNgqd09UxI2Mi2XS3x0WyCp2lZgion?=
 =?us-ascii?Q?VHfgrjkpayhfq9TFBqn67UF0SqXTKKeLP1unb95QV/ouHyDtIpUfhWQZKUFu?=
 =?us-ascii?Q?dScHc3BAJF6WBNOw21bf7GX/srq+h3D+HqIJWQYcBI1Q+Pj5mKG5kDYa1OQZ?=
 =?us-ascii?Q?+Eg1AoNK5Oq1aQsHWflnyPlfEnhAQJqHH1YSB/C2ROZWU8OY9P5x6xZ/9FGO?=
 =?us-ascii?Q?XJYX55mVuMEr2MdonVv6lGBMLsbWbSE5Cpa6dq7atZ2t9/W/lUAbZsqpbuGd?=
 =?us-ascii?Q?Y9z6w/qBH6hTi+s0+em4F7IZPnU4ZEWIioofs7OPVzVqf4fqHjOACuhxoyVY?=
 =?us-ascii?Q?T8zDnTPQ9nqujpx5gLqXPNzsWpC/OYC2sUo2kMqnuJgUfphDdKsb7nu21v06?=
 =?us-ascii?Q?GaNCnjSEPcC3ZiO7L7kJrNvDMKkcXNx2i89rLDted3+6+kc2lXbQfp3Exi4t?=
 =?us-ascii?Q?iBMXrvD95qj6xG74N50ImicNeM319ejuYAlNRBFH2pnfK4AUVbgdjeEWYzAb?=
 =?us-ascii?Q?CU3d79IDbSf23hcUFw8eNOVENZV4MdGVrxxUL+BjC7T/Lt0z4H9wfIQbNXN+?=
 =?us-ascii?Q?wyZt5yxLR3SNWgc8B4MSjjs9Pn6PB6NH9/hzXrKU8dxlsarlUIquCfBRTf4q?=
 =?us-ascii?Q?qJ0UFfLtdYissjkg8WVvCna5WjLNrtAz5OMxpdt2+qiaQt5VKoLmhiStLDSw?=
 =?us-ascii?Q?yujAfHfSWd0Q1E0d3GIUq6mXpTKbymPCvWPWlkIOlipgEo5xNqLQGEuciIg9?=
 =?us-ascii?Q?CQN6CHoGok+EPCcC6TDEg45peFr/seG7VHIq4eu0Gl0x9NNicE5l/+q6fJ6T?=
 =?us-ascii?Q?erGI8Yq065iUAvbtaquhm472926Ta2Islqa8dS2A+FtN3KdgtjqZZiB31ac3?=
 =?us-ascii?Q?nXB8Xc54RS4NPSGWoSOx7eLtx7W8m/hNIc/YVxCDlIOXix8WFZohfnqnYpFs?=
 =?us-ascii?Q?q8i7g4lewF73Ie6WgaxKNbmiflyRFRitGAJ0qzyqqLtmVI79zuLuU6/hUVgO?=
 =?us-ascii?Q?PnF02Hv5xjEm8teETCiIWnBcjU0pXJK8tTWuGAbWdhzFBXx6XAyKYK2XpDms?=
 =?us-ascii?Q?/MBG3N8lNkXr6/eClgwDWxHw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a169ec4d-8c84-4e97-e601-08d8cd801d25
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:40.2935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90MFq09WbKlv5mBvCbPg/o8WVlZXaDW1fJx3zfdosNwTXgyMvlrNop1lYc3Y2W5CMa4tKV3y1YeMd/X6kU4dg4TDkXULF7VmrYPJzH6vIXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO wants to complete a cmd on the CPU it was submitted on, because
most drivers have per cpu or hw queue handlers. But, for vhost-scsi
which has the single thread for submissions and completions this
is not always the best thing to do since the thread could be running
on a different CPU now, and it conflicts with what the user has setup
in the lower levels with settings like the block layer rq_affinity
or for network block devices what the user has setup on their nic.

This patch has vhost-scsi tell LIO to complete the cmd on the CPU the
layer below LIO has completed the cmd on. We then stop fighting
the block, net and whatever layer/setting is below us.

With this patch and the previous ones I see an increase in IOPs by about
50% (234K -> 350K) for random 4K workloads like:

fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
--ioengine=libaio --iodepth=128  --numjobs=8 --time_based
--group_reporting --runtime=60

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 drivers/vhost/scsi.c                   |  3 ++-
 include/target/target_core_base.h      |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 039016ab7a77..0f5f8a2d101a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -828,7 +828,12 @@ static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
 static void target_queue_cmd_compl(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
-	int cpu = se_cmd->cpuid;
+	int cpu;
+
+	if (se_cmd->se_cmd_flags & SCF_IGNORE_CPUID_COMPL)
+		cpu = smp_processor_id();
+	else
+		cpu = se_cmd->cpuid;
 
 	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
 			      target_completion_wq);
@@ -1609,6 +1614,9 @@ target_submit_prep(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
 
+	if (flags & TARGET_SCF_IGNORE_CPUID_COMPL)
+		se_cmd->se_cmd_flags |= SCF_IGNORE_CPUID_COMPL;
+
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
 	/*
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 99909c6f3960..b9addd5fdd28 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -803,7 +803,8 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 			&cmd->tvc_sense_buf[0], cmd->tvc_lun,
 			cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			cmd->tvc_data_direction,
+			TARGET_SCF_ACK_KREF | TARGET_SCF_IGNORE_CPUID_COMPL,
 			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
 			cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f2ba7de59da7..bb4ac7e6f560 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -146,6 +146,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_IGNORE_CPUID_COMPL			= (1 << 19)
 };
 
 /*
@@ -195,6 +196,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
+	TARGET_SCF_IGNORE_CPUID_COMPL	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
2.25.1

