Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060B9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEB764EBA
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhBIMkS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhBIMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZKSr038496;
        Tue, 9 Feb 2021 12:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=kdgAUNG5jwO4SxRDy5VaZFEvV0i4DmeYmZbMwRrGGAA=;
 b=P90y/BPdW7dbMxUm3Dbu9kO/RCMucgKNLoYkpAfDBbSiTVlCpV28xoI7Bp0rsC/JtL1b
 +aNk8qSJpFGiCxYjwhx6UduZZtPG4z6P4Fv/6PdU/39G5WODI6mNJlEsobzYqVifv2TM
 ZBakrZXzezXF/g0ZC168uk3HPxp1F8n2lN/VIJb9OgxxixmQsmppEaNlUvxED8g3L0Cj
 RsouJBZhdWFTUdsAZGpJQLWdOmrI90QtySN/3uU5FcpXWNbY+0/sVHi3n2KfM4raYwKD
 ox9nPgDiE5TkQAR0puiWIaAFDqNeJhEV9wwn8gHC1coZbFuTy9iIOu5nBgwfzQ8LGuuD Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqqagq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZJId035198;
        Tue, 9 Feb 2021 12:39:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 36j51w15v2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYFyGqIzI6aUX2XR0UfiW4gS6PNAcOJW0A2LwrNNYZ9lv9qH8CWDdeJhIbOnxACqaI6tkihyTbESXBmxc/U1KLzB7VMW04RLjffDstHe87sCBmq8Mnaz2syFFTfAaS8I/eZLSeZetkjX7YB6urTM/CJ3E0eOTrfdOKONfZ+VRWzrVRz4pPnSfCpgKrQlxvhbNmENp2rWgRZGEt/sCj0oUopTp5orCTJPDj07mj1YopStu1jpMHOTSBAJFeoM8RTAASzjemxawUgskLqGezqftIAGc5/7DHGbm3gjifKTtZVNxKbLbb66qlyHCrPwNvzU4CDRHauY8g3BQ5ZeRIG/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdgAUNG5jwO4SxRDy5VaZFEvV0i4DmeYmZbMwRrGGAA=;
 b=hEj4QPiiJq4csQDPIm0gmmUgRz1Fazm+AwryAE4ycY1JmeYz8E52TAkoRyMXH40PmW5ucYwLwEo3p5ZCUx5FyzRSxhM4umZ4LljtIkiYUHwvUmZJMAfA9LYbWcfZ0XWO/9O+DmOENkNUVMlNN8e2/6d56RzbVDLoc0Pk6hkGBM+pXkeIRZz/jExOA+Gid6qm4+oXzSzDhS4gRtPmwd9gYBJfEdL/oj3SdAl+QBZy624EQOg3S3oosrELtzp+7oeMiV3Bpe+ONSwOrE2dPsUSDrIghTsJiBojHwYYKMeQWyFBlQPH6GgDGA41g3hReRQJmzHClHqxpxk23kkvODvjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdgAUNG5jwO4SxRDy5VaZFEvV0i4DmeYmZbMwRrGGAA=;
 b=g1nHAgWvC2t7B2kQxHOzGv9PiniOeRGSEOZJ22Ley/2StRAq27BOqsQsOCBgeSLY3FH2fhW3szKClUqRxBLIG8lZwcON4/kxn4DcMwuISfUehZqmB9niHx+uFTPS6c165lOrHjFEIJdQ6pxKjnOdG0xqKbZS311yCgNuKgPLb3A=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/13] target: replace work per cmd in completion path
Date:   Tue,  9 Feb 2021 06:38:43 -0600
Message-Id: <20210209123845.4856-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 962cd03c-5f3e-4969-fac1-08d8ccf7b115
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600D1D56562869133521FDDF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuqsPJkTS4FtD6VOQ40N3QTeAdA/3lAwi7p3s2QgX1TwaUkV33aj/gI158DD2RIVjSqGzM1+6LypZC7yC1k93MXKP6gM90FzXGmXS7cGbuiJ+6Nx7IPjOyv0h80GdWiJzxfhijvUU4yY34kLOK+PeCb7s8VGHkH3yFjGTHsU2uDczKtbXPF8wzuhUfyBtVLtyupLp2YCPjSKrFUiM3b2AlRalQJ8inKaz3B1kTTIHZ9X7QiGsxIhyrjMp9CfFTQ3v0zvvH9/TnNpAmQP4XY/xatKQYXOx2d2Q+TQKG8rAStd7XJWblHriYOjAPSitJ+BugnGVj24MzCFQKf1qzD7a5O4+USDcR2JOAN6dCSHdsyHZKeTidB/cLb7vB1go9V1upETSoNuVuDKcKj0lD5jf1cgPmSYaDhPTQ75rtS/Lbped/ah2d7gEmcLHIn8t/aiY3ettCqCDrpiPoXH5eVCbrTVOPSauzOgCo3mkw4IxCzS7iJaS0B82PY2VXVf7GLXrCpA3lLD+a8QWk1ZrTNmTGjbktxSPL36uuW+uZ6yJ6rlZ80tBLkCz9+kawcXdZT51dcJyKqq0Vy9icR4ZWtR9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?li1rVKHsHu6Og4kt+X8d4c3HjbtRaSGmcdCzC5ij4qGMAhszLFyLrlmmXzM/?=
 =?us-ascii?Q?Brbeo+bMyeYF+SaqrjqGcK2uTSpqPimP1CFGigrhxBCVCDZg56MKdSUQgNkZ?=
 =?us-ascii?Q?CtOw7lKIgQkRJREiXnPaRKzr3BNnKzAX47lJK/8gk33XEvwriMXzfpR/JTTg?=
 =?us-ascii?Q?i8rmHvTuHd40v07y1gIGhyolpqAXoY+HnK4dN/IYDGlkcFliD3JE6/60qs/p?=
 =?us-ascii?Q?CVOoptr0RR+t5Fj5mOWWDvkeIWRE6kcI87Ccl2HirX83ZIF7M7ffM7tjDHWr?=
 =?us-ascii?Q?f3dgKCif4CDKyksSK/fcCUPHijNMAI5yhROV5GwEXpy6eazY21gzIooGbCkW?=
 =?us-ascii?Q?Gt9TjraV9hZA99mb5KZUNNFIlk1KMWgq/p8PW9QfTcYd5xkjlgYciHGFfAum?=
 =?us-ascii?Q?LaXY1Pk7hUtc1Kausfk0hK1YIrJIJ/BWA7zyIGIdwRHlIM0LF6V8u7MvIzNY?=
 =?us-ascii?Q?zimm1tkynLj3FecE2q40P6Wa52mW+dVEoPlzbX4853rohOsJ/5/GbrVnC1uV?=
 =?us-ascii?Q?sN8gvuif1o+jwt8EEyU2iZAVZGWJADkSpT0h07fBQ1SDw3KYMcJzyTsQcBj2?=
 =?us-ascii?Q?WcP3SYpLrdTRPPh8k/OSN6lGWVXAq7C9002heUlBt5Y4nm+DbA5GVSnJAUMY?=
 =?us-ascii?Q?LgAREYy2HSmypmy6FGJlu67nQB+go+RsFurw0+Pbae5la7h8zoEKSoycrh9+?=
 =?us-ascii?Q?qeq8lNdehnZrAYuTfRc6Z6D0VH8bJ244LrzPrkAT0VjJz7cdLXN1ODDCp7eI?=
 =?us-ascii?Q?0g5PxkRPSKJtIUQbXhR3WmwPtKPDC8dukaw0vvyUzE+3Gq4dqJSdZC+1ozc5?=
 =?us-ascii?Q?0ObkeZ1ZK/iZzTiwTNxu8WfyXygowrjXS3ypqnWzHMp1SNg/wJzLYFpD7AJ9?=
 =?us-ascii?Q?Y4rzdoVx+YFq2ruzSoZ+lBFqLIaErZ5bSj3U7gFuL0e1drNnwtsd785mcyUv?=
 =?us-ascii?Q?gj9gXrSHrljY0dzedZ9IgseOgiNdffV3bjWh/g81VXYiBKy/18TFYyiq4mFT?=
 =?us-ascii?Q?6RgARGXETkGA1iDGnmd1ocvKswINPUNNm6IMvZzWqDROtwpQWvuIt0MRTbeR?=
 =?us-ascii?Q?AQYZO6iKwx6I45tW0B9mEk5YqECQjhXR7UksAYTyifBbMLck+MMUjDuUBLyQ?=
 =?us-ascii?Q?PsUKAz75kFj73CqcUQjglDdNoZROEdtx8aDWEVmGnwD9uEW9XT5a1l5d5wZw?=
 =?us-ascii?Q?u8qxCma0NckhqZNJnulKgQCXFEbPlk7ENl7MmWeeRm1nIGq02rPONc7A59a5?=
 =?us-ascii?Q?LkF2Q/hJTzerhYtvgbJWXb9KKrBr8SZicp7fQSgnVFwp6YnYtmsCMpLl7ODX?=
 =?us-ascii?Q?y63ut4wO4GPOEqkmqo0muIC9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962cd03c-5f3e-4969-fac1-08d8ccf7b115
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:07.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z05Ga95RKoAjVWSwJOaV3JrX7/Ooun6/raMwbJ6AQ4a/YTqZwOGpAY8y0VdCwuYypy5kERs8T1yLJmwWLzlKVICudsmAgvur8zqYZbrpLj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Doing a work per cmd can lead to lots of threads being created.
This patch just replaces the completion work per cmd with a per cpu
list. Combined with the first patches this allows tcm loop on top of
initiators like iser to go from around 700K IOPs to 1000K and reduces
the number of threads that get created when the system is under heavy
load and hitting the initiator drivers tagging limits.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |  3 +
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 98 +++++++++++++++-----------
 include/target/target_core_base.h      |  1 +
 4 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 74d3a4896588..eaa2323843c0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -743,6 +743,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 		init_llist_head(&q->sq.cmd_list);
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
+
+		init_llist_head(&q->cq.cmd_list);
+		INIT_WORK(&q->cq.work, target_queued_compl_work);
 	}
 
 	dev->se_hba = hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 56f841fd7f04..e54d05ae8dfd 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -154,6 +154,7 @@ bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
 void	target_queued_submit_work(struct work_struct *work);
+void	target_queued_compl_work(struct work_struct *work);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a90f20222894..b1f920c1b816 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -55,7 +55,6 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev, int err, bool write_pending);
-static void target_complete_ok_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
 {
@@ -732,14 +731,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		percpu_ref_put(&lun->lun_ref);
 }
 
-static void target_complete_failure_work(struct work_struct *work)
-{
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-
-	transport_generic_request_failure(cmd,
-			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
-}
-
 /*
  * Used when asking transport to copy Sense Data from the underlying
  * Linux/SCSI struct scsi_cmnd
@@ -827,11 +818,20 @@ static void target_handle_abort(struct se_cmd *cmd)
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
-static void target_abort_work(struct work_struct *work)
+static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
+				  int cpu, struct workqueue_struct *wq)
 {
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
+	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
+	queue_work_on(cpu, wq, &q->work);
+}
 
-	target_handle_abort(cmd);
+static void target_queue_cmd_compl(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	int cpu = se_cmd->cpuid;
+
+	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
+			      target_completion_wq);
 }
 
 static bool target_cmd_interrupted(struct se_cmd *cmd)
@@ -841,8 +841,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 	if (cmd->transport_state & CMD_T_ABORTED) {
 		if (cmd->transport_complete_callback)
 			cmd->transport_complete_callback(cmd, false, &post_ret);
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+
+		target_queue_cmd_compl(cmd);
 		return true;
 	} else if (cmd->transport_state & CMD_T_STOP) {
 		if (cmd->transport_complete_callback)
@@ -857,7 +857,6 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	int success;
 	unsigned long flags;
 
 	if (target_cmd_interrupted(cmd))
@@ -866,25 +865,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->scsi_status = scsi_status;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	switch (cmd->scsi_status) {
-	case SAM_STAT_CHECK_CONDITION:
-		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
-			success = 1;
-		else
-			success = 0;
-		break;
-	default:
-		success = 1;
-		break;
-	}
-
 	cmd->t_state = TRANSPORT_COMPLETE;
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
-		  target_complete_failure_work);
-	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+	target_queue_cmd_compl(cmd);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -1894,13 +1879,6 @@ void target_queued_submit_work(struct work_struct *work)
 		target_unplug_device(se_plug);
 }
 
-static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
-				  int cpu)
-{
-	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
-	queue_work_on(cpu, target_submission_wq, &q->work);
-}
-
 /**
  * target_queue_cmd_submit - queue the cmd to run on the LIO workqueue
  * @se_cmd: command descriptor to submit
@@ -1951,7 +1929,8 @@ target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	cpu = se_cmd->cpuid;
 	se_dev = se_cmd->se_dev;
-	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu);
+	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu,
+			      target_submission_wq);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
@@ -2054,8 +2033,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+		target_queue_cmd_compl(cmd);
 		return;
 	}
 
@@ -2480,10 +2458,32 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 	return false;
 }
 
-static void target_complete_ok_work(struct work_struct *work)
+static void target_complete_cmd_work(struct se_cmd *cmd)
 {
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int ret;
+	int ret, success;
+
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		target_handle_abort(cmd);
+		return;
+	}
+
+	switch (cmd->scsi_status) {
+	case SAM_STAT_CHECK_CONDITION:
+		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
+			success = 1;
+		else
+			success = 0;
+		break;
+	default:
+		success = 1;
+		break;
+	}
+
+	if (!success) {
+		transport_generic_request_failure(cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+		return;
+	}
 
 	/*
 	 * Check if we need to move delayed/dormant tasks from cmds on the
@@ -2625,6 +2625,18 @@ static void target_complete_ok_work(struct work_struct *work)
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 
+void target_queued_compl_work(struct work_struct *work)
+{
+	struct se_cmd_queue *cq = container_of(work, struct se_cmd_queue,
+					       work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+
+	cmd_list = llist_del_all(&cq->cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+		target_complete_cmd_work(se_cmd);
+}
+
 void target_free_sgl(struct scatterlist *sgl, int nents)
 {
 	sgl_free_n_order(sgl, nents, 0);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b8e0a3250bd0..f2ba7de59da7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -777,6 +777,7 @@ struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
 	struct se_cmd_queue	sq;
+	struct se_cmd_queue	cq;
 };
 
 struct se_device {
-- 
2.25.1

