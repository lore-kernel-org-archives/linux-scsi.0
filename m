Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC65C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA5B64E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhB0RFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:05:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Gwl079327;
        Sat, 27 Feb 2021 17:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=B2nxDLf4CzMT4tU98TDuv07IKxxR9MHGiaD8E1CtesMogKVvbPkmWg900xffExrZVQCP
 5Al5J6zA5MuaOvHdETVM9fnklMtHO62G+RCAuYB4fjXqjaRyfjg4+Vz8P7fFvPDtpG+P
 uJ1mgMJsfLsZ3wARgYL2zJJkGhmAGpaU8z+fitDGv2yHzhhd6hp+//9kTeCfTYA19b2R
 RC92D+zk2mTmY1h492zIQucx01lKaX8akhOiDvPSSIH21tC8V362yPJZXNu1oTEskzPW
 LG5pik5pWz5e6WsFQpatoSqLgZU9GpkzojolfwBvyEa/ZNsSOpWmOw3LiqxCsqi3cHMJ zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36ydgr0rs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGsmD7041731;
        Sat, 27 Feb 2021 17:00:29 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 36yb6sam7c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9liO+wqjs+VVxob8e2RZItgS5dCWMz6bCZhLeCDqs2FlDFiwIxHZ9p9sHZm321tftFR8QhKnAt0MXj76E/tmYOrgEKIiCyoN9E7bRv+V//uMJDcidHW4jkOD16Tp/6iCBwzs5ltwutS4T8lTy+87c1Be6WNdmD+qNShHPzmz0OUS9DeOMVL4tMvXye/QUhe9vWmHwqTR+9UcGU+M2a9KUz2xXR4h7Z8ak2TgZS3VOVthW54PooxQzoy5S9lWT2Jvs8BVULSerh1pkgdXZAgCNCKVAnSOIDA4ZVlDtqTtZ4fiTyqIb//yKZQ1KVK8XcqrvHKrZKiHmppE2LUwFADHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=P/T/ST2s/U50LIbsbxTf0jIdA8BZnxHJuWyjjnzs+tgQONdYVrOHScg6dmGnEL8rv4TdTlUEQud9YGaZMDH0zbqiYBnix3l1COjv1Fwsgzzlxb8wIPSxZD31Cr/Qr4wkHWS1aav6D63SmTfMhSF47K2KV2v9DgsDcQfbRd5p4E5ZjfH55JZO4s3Vl/Ukkic+jrI9gwI4IYfjqnFdoL71jzEgnPm2DbcUsNGrnXgrfRLrfyRH8PlC4fq/vpX6V3VOIRiq1OrxcU0H6OjhQ821AGgH3FIpdAOH70Xpjzbh9aBCPjhboLfSI2Yqn0JVUl5LlHldtIr+o9ue9DagE26vMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=O/gGg7AJ5WDbDDojtMFrpKRXo7GhV4qSPU+nHM+mNwFDfPBP3ID2Y5nQW/fyZZ4ETIlJ2YBA7CcsF6ikTGfN/8M2039HuOaneGt+kb/cnzwoFMon6/SBAcJaYjVYLEmYqU7xMvGAfAgQz4jnfWjkkS8m0DqiC7cG8yoSIj9fpiU=
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
Subject: [PATCH 13/25] tcm_fc: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:54 -0600
Message-Id: <20210227170006.5077-14-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5f3d5ce-3bbd-48d0-29f0-08d8db412e42
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499CF702E1F0A5B849BD244F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiF8ph5/lN3dEzz9oZpCiehJNBKViu52xQlbhP1Qh2eG1tVGolsmOiWXQxRopUSwuRcpve2JCYsmumSzrBH9YS0bBEBOx82mMvXQJ8qdCgQ98pX2TrhusMd4hkdwy/nnlL9qxRsbLnQdMQExjXL7I86JivY1YCM8uG+LobyPpYRbWsGLWF4Zgow+BrEDgo93MoeFQ4Q5BCEWBX8llRjxyXxRQoFIQ/KozwnJjsRzA1e1pXfD9te/lPwHTG8cJHDv5jIDOXbl74qTAvp//UlEo/FYMkIdwA6K6bGbv+O+nOD+wQf2SrdyZ8veVuMvGeLtkl8ENZrkbXpC8eO6KclH9HVvNcVjRDGDvOJ8P+9fWRxXJsBe6syITmnwAhPQ9elwtWTP1b/Lx/EyDcKszcv7JqAvrjg7nUxrEIHzefcVzYvGs9nMOFNETvyU/3agMLEh8IwFG//nzXrrDwBZnuz0MjVhqmsr+sCq7IlFLulUqY7wjX7hQa65XBFcDSBzjklQq8O+ZD1shiQ9lTZjsNqmW97qIVXIrfBSgH5i+EtiO8VJD2rUMtovHpKRfrcM+RJAHffjv1HYUmICAJC9YMAd7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oX4DTfjSvvJVi0hJCa9EQpmI3OU1UGcetNQTxfPm3Lv2X3NweDkTgqtSZM2W?=
 =?us-ascii?Q?M5gCIaK7F+7IJNyRL8LRYXNqIMLAYUHrUYggZjgYyhYfTFsnAgqg1PzhmgUT?=
 =?us-ascii?Q?b3O4Ao54FqjoTXfzd62sl++uaFA2tBbwKJaKQeYMlFQM3hf0UJBe2HW6C/xy?=
 =?us-ascii?Q?XCzcVF8Q/nL1B0wYpiFyfJZE1mFZ7H0qw0+yVKHUdYkryuzpfJgNa5Zsf9H9?=
 =?us-ascii?Q?a2+U+FSojWZQjWfcmMZ3HZStqQmHBJT0dKs3Z6IgE+sIaS66DKhEevu1T6qb?=
 =?us-ascii?Q?LgWHQehgU4CeBPbpDlOUe7dbHBydFmdPVr0iiwRAfD7HhTM31LGXJAiElDYm?=
 =?us-ascii?Q?NOMPJ/SoU6Rpk8xBNXFnJD89MY9Szmq/SDZM0Am188DZIq+B8+uOCDxnRLe4?=
 =?us-ascii?Q?IjH0V9wo0m2iZuvFvsyaKoOr2rTacs+1e3wr1ZFpldIwjjTB7zOhPc/7phm6?=
 =?us-ascii?Q?Bm0FgctDXDr+hgf0lXndLbkPgWU5xo1yAtsEjGZ7EnR+FYz2H0Hr1Qcl9GOL?=
 =?us-ascii?Q?YQc1z2C4W8MIUsPJWsfdUrVrIjKQC9rYlinqVPMdbbuS5TV+r20L6ZR2smF1?=
 =?us-ascii?Q?BXXdL6a7cal0RcDkGTK54ZUlzHnE32FN2MwxlPo7Ztli108vVEZEObldYuUF?=
 =?us-ascii?Q?Cahag/bS7YcW0XFoawamBr4TRzoHgZ0j8IyzRWksM9c5MV0zZMZGeM/ukoDi?=
 =?us-ascii?Q?nqtrdFgBbrehCV4MISDiJ+o4r+OglMLn1J9U+m6csFY7MTT2Z8tc3OYfHCH5?=
 =?us-ascii?Q?wv5CamtuzoAx5RhelFd6SZNPEiCkVz4unsCac9GwopSp9UOEod6oloQMnhG9?=
 =?us-ascii?Q?mYo5WNcL3MzMVODDupdKzUARjEVSL1+E/55Mikqp+hcZ6G+AEkgjwN+mDfrJ?=
 =?us-ascii?Q?iT4FC/wbIB66hqe2MWRUA31oDDH1F4A942KPwWO2roCFcS8b7+XC26bIPzts?=
 =?us-ascii?Q?8uK9AfADzRwGdetaSL9LDLTSdcpEzzIOF3NdjKhJyTZxcOqYqTC5LaZ/viVn?=
 =?us-ascii?Q?Xc6ZQmaQEqNJs7DLdUuu6JMh1eubPKSZZNK4ZSqoVxm85V9I1Y/aMTvDI3eT?=
 =?us-ascii?Q?GyFVckdO69f08ZAUnuM74mz4+PtgirIA4y8IE1AY+rZkaExGIsVy6a1vObQ0?=
 =?us-ascii?Q?oj14mYD0Y8HZZUUUtk7lygxMrzi2Lnkeol+7mDndjLTh7mKjog+3/ZYppdbN?=
 =?us-ascii?Q?rpTsPZjQIVS6H/UsvM8aMMxs1ntyj5W/IEaEDVlSgSlEgb91UVdvVxBgvORC?=
 =?us-ascii?Q?d+MdbWVTtBR4gvRwe7jvgOiQGAMOuGvmU/yKle2UyzxX1Gj2Q4txQJnUuFQF?=
 =?us-ascii?Q?ui8IDu0gBv+38KYMg3/eymUE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f3d5ce-3bbd-48d0-29f0-08d8db412e42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:27.0289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSDZlWDo23+9qGi0R4419MxVPUzRLQ2U/8ZDlzb5LaA5LUx2gokXqwvH0Ktwbr1liE5MQ0KjGiC3DOtYq+gXEtRklJ37dfzvWoW+e2FFbU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session,

tcm_fc uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit,
because target_init_cmd will now detect the target_stop_session call
and return an error.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/tcm_fc/tfc_cmd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 768f250680d9..1376501ee3d0 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -543,16 +543,22 @@ static void ft_send_work(struct work_struct *work)
 
 	fc_seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	cmd->se_cmd.tag = fc_seq_exch(cmd->seq)->rxid;
+
 	/*
 	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
 	 * directly from ft_check_stop_free callback in response path.
 	 */
-	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
-			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF))
+	if (target_init_cmd(&cmd->se_cmd, cmd->sess->se_sess,
+			    &cmd->ft_sense_buffer[0],
+			    scsilun_to_int(&fcp->fc_lun), ntohl(fcp->fc_dl),
+			    task_attr, data_dir, TARGET_SCF_ACK_KREF))
 		goto err;
 
+	if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
+			       NULL, 0))
+		return;
+
+	target_submit(&cmd->se_cmd);
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
 	return;
 
-- 
2.25.1

