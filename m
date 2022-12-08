Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7956AC6370C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLHDKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLHDKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58667614E;
        Wed,  7 Dec 2022 19:10:12 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NNehO002203;
        Thu, 8 Dec 2022 03:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=USiJSaGzY3DZonIuycbV+3cob+eNJv+C6IwgcYmV1GA=;
 b=o+or5IsK0YAklY1/JAKuALrTHseNI7TU7xampFTD30hXJ56FSkGGw8cEm6m9Z1J0xI4n
 8ym4eS7yLlttJ+Xod7idYGiVxA59ZLMywX9cD2ZL04gzW0uworllHwfp6dttwe37zdKV
 RB8Ru5flLSB+TX5YpLtzYl4LUeW87K0/oQOk/cMUj0axsEJ6Zmt+ioCPnxMx6dWAr5Nl
 1qwQkeNL0MSofJpcVrFx9qBL98uc3JHjBzYS5+GVLYrNtvxJ2zii7JtIozsDMLdqSX+X
 HIF7HwX2Onm+2siF2RrqgaNv2TbdZoV7Tit9nKs2+2KNw3ATSwqpwq9F6F0EgD68AdH+ hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudusugc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81ulYX009791;
        Thu, 8 Dec 2022 03:10:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6a37hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+xZ68oeDcrEpXueGIic6obUhgyMM72cWVQm6Cy1DwFTq36TBlybQ8f89Kkjb8t89PdxIBEdPPwPQ+upkNpx7mBobmMVbmAOKJ8V/MGPgLuRfayImEDX6ay9or7j9TanbZLgoQ6ToRc3Us/pZhpEeg5HySaoqI0dslEiBeZYZXk/0HuvIoQR5sSEXI+3Sz/jqdkJJ8YEgQRD5MfgGGBpcSokVya9jiiNnjCXrhovQMDmOB+DPBwtnxman4FU6ksiFRiLj6qWhFXLO4DTxfbwX/IgP1okN89o9vRIwpEmWjfQNityxPChv1REMc2McarG+NzhLdOOHQB9QPbFXmgl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USiJSaGzY3DZonIuycbV+3cob+eNJv+C6IwgcYmV1GA=;
 b=l6bZ4hHdkOQIrCLK8GjKyXbARmf9kYupApE015CEj2kBlrHGfXJxSN1ii6i04c/gQMRoQJljNfZnS+ZtTcVog5a9Ce6bXa7qMy3REVoEuA7QiqT6a04/5micM48AJn70WjU/goKL7eoJM1TovctmoheJoO4sZ/kn2EvwNu2yr6KolyZnSV1R4h5bqcbLVx9ZvDmftNkQ/UKQse/EhyQWBSnqNrtaWJ2tA5ZJPHeV1hbFafgXbVduWwdqwUkVLk2lpu9YZoKxie5CyWMOlIsQzZjPrmdXNz+6MqX6oQLQCrOyu601vx76zK354rb6ELGL7mfotbo3KNQUflI9yj3gug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USiJSaGzY3DZonIuycbV+3cob+eNJv+C6IwgcYmV1GA=;
 b=Fb3oA/W5HC6JVCJ6yoq3SJmAu3AWuA/8uKfp47IeXACzRIjd90cbAfLMOR5L7FWD9pBBVgBZwa9uD8OsVC/Y9ZEI5hZcRaisfD3FJSt9gjP/Larvlv8yJzOL1ADa9vgm+3xxutZrCJku2v5Ix2sYJU9Dk2A/Qd/oHY9XPEWNmH0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/7] scsi: target: Move sess cmd counter to new struct
Date:   Wed,  7 Dec 2022 21:09:56 -0600
Message-Id: <20221208031002.106700-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:610:4e::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 469d02d9-8d97-41bb-361b-08dad8c9b56d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QSuegqWe7KdRkwGrAhuFXqmpEu4zdEetaywUtH65BqsAUxuUDI2laVSVcvo8s4Z3XMs2/BJ6UX0Jy6QQeoPIgeskRzZjbt6oxfxxysG4MPvCM3sFJnIu3EOOj6TMCOkhowQzcb+HDeGpSdpn/K93hJL+r0HaPW8TJWPpCUocIwhKCTOFjZ7yWL9VYnbI5jUNGhB5aNzZaTZ8SktApL8p34sd5HjsLbi2c6K2q/t96X9zbFZFw7wjMaq9SOvG1RRk+toT6oRitoMqpVN1fWJARNtLVBoLyWfuLjKFrmOGKfSyQceeNBKY0ZvSqgY9THgGzty56CnQSlwt+Z7rIPwvT1GtK7RGllUZTa/+lMjMq+a7ww8XVa2PzA7XjYWJDd+LswgheebSUVSw+ysteYmmk1z/DgBQvfv792N55KSajzBpdzMzPuz1TNTQbGGoQyjsVEWcGmnkoUMyw7arwX3njx3gang3r70xqANx0+8l0yekNWhXxGRhkS8PPHO9Zy5GEWEmoXBoGMQYuEEsQ1uk5kpwekDXazaZ+v3V5CGpGr9JxrH9RfiMCDBbmteOs9xUru13FBI/OMZYEd/EGSaJRJFXOJRQc5ZSKXUpzcZjq6rbSUSjumaCKMYy67Y8gV/qLC0t/Rj2+n5Ea6P3KOzK8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?81DxMAPiupVCAhIvrjB553/dGY5r/Mbz5B3awPo0aFUcb2D/QcIxRFpBt7Hx?=
 =?us-ascii?Q?beMjhxFpqUUBd6Vz4K8O7zwLAJj3D33areWgMpikOunUnvhp4CQeVUI9gDSW?=
 =?us-ascii?Q?QBHSGuLx7XUxaj3FSiUCiN7SiXOj21DjGjQ852RNVQPN8+1dwtFrGH5HWfcs?=
 =?us-ascii?Q?GSm1NEzsrmTcsSkXFeSRDRWm+AiXRLt4Zv8ep3KWs9N/e7SpZZhtkbN9BpFB?=
 =?us-ascii?Q?cpwbfCFI+kGMRyiU1YSADmWFv7JetC/hHkWoMxkVe0iTR1izsWyCjkUekjCW?=
 =?us-ascii?Q?SHz4Ga+t8F9vAtdms3jYDT625qhVvmD5jdGD6PiYtHzK5RhKC0M/3M6iC2IM?=
 =?us-ascii?Q?a11b5AFZST+feaXqU5UNyt8ajKZrO0MluzI+tqhZrmk7Ws/Wa0V1GtW+kcl9?=
 =?us-ascii?Q?CdeSEPYaV7c4WK1C5XAv5MIJ1ulwp7uWn0eoL56ajFASa5PBNaEg+ZbNwswl?=
 =?us-ascii?Q?Nb4wrIWkQkWGeVxQ7MGVO3CJKx4AG50oaoLJtxnFSRGGF5t47OCzj3ERK7u2?=
 =?us-ascii?Q?cj3sA3X/rfEAEGpm0kRMImkEqhMpgzfuEuzNDvuknS8AYNzjKg8nNxvQp49y?=
 =?us-ascii?Q?L7bD48Cc7JTrdAh6WEo3Dm+44CGnylJ23l1vbbr4SK+mH7aKs4Hz7Y+xhPro?=
 =?us-ascii?Q?FD9OteHdvlj0sYDDJLPNsGOOXvrrq/M81rRVylRkXhl0VmntlghdsmzAFwL7?=
 =?us-ascii?Q?mXnEwI3KtgMwsQ/OSQMXNhbf1EuU6mTZVHPQAobiIIUfPYXZ1B5eckpP7SY6?=
 =?us-ascii?Q?KDS9NPPODppaDdPaVfGfg1dZc8lu1hK3QAHIP5EolyWNIhl6AZUt1zqZSwKt?=
 =?us-ascii?Q?L/Bj6UOGQgWyKuv5eLPZ1ESF9o5x6O1Msg8aOHAtjCpoZRVdiNiKB6EYAedD?=
 =?us-ascii?Q?/RaE7aySLt3XXBHSoYTNATBehFkOLa/qvtlSHgFHo2WRmKffT98y+h3FbcWh?=
 =?us-ascii?Q?MHlbiP+M/ON+vFV1iNtmzLk8Q132oqDK2AFxY+oYzmNs/z8hSnGRHYLC9Nli?=
 =?us-ascii?Q?s8KL6m8UjiJIp80edfX1n5rNFceyNOu4vaAO+tMYCVKP/432IFTgpACLaqRe?=
 =?us-ascii?Q?CnTqRb326S3M89MiyCww1b0GW1yERXG/ZIKwcOnfNUU0BavTgkf8OrIAw2Zv?=
 =?us-ascii?Q?rLimIiv8rYBdLud/BRcVkjekROsjC60cFsYjXcBUHCnFIXepsHIzd49gOSd9?=
 =?us-ascii?Q?cF07SoHroGW9AAm1Xx9cdN1iZGBGfl6iFrxBpOOzrEq7mA86Azq90CNwFBzD?=
 =?us-ascii?Q?F0lb4Vnijt25Jc7pRqozdkNMXinba7RSJEOrSBf0kRuU4TJFWFihbDC2gaoU?=
 =?us-ascii?Q?ZUWrLyR8M1ip6GQipx6vT+Yq4gddjeP2Ch++KtSp7VCkb2LSx95DhC5Mg7cy?=
 =?us-ascii?Q?+CHJyjwDTF2zzO9rhuQBVPgg8ZisGgniAOlWD/JT0To+CfXuFJ/sR0H+oeuw?=
 =?us-ascii?Q?cn9H+xNOPiHgquKgknSPP/pVgr8fHHsDK3abQT0a1LI8uUdQ7kHJaaN9Px0N?=
 =?us-ascii?Q?1wP9F37pZQWg4vfgIfqhxo8X5sYWjz2GLJ3DzJgZTNuzl/C+AJQGLRNpMaoQ?=
 =?us-ascii?Q?p+31ZJ+Uz7PSVd943imYBQhGznefQQyj4KYAqU3EMJPZTjnv2ss5+YSSOcPY?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469d02d9-8d97-41bb-361b-08dad8c9b56d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:07.2393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owCRR036TZ7mDS/Z4kp1veb5EJ11NIBL+F/pqrX8TuadEy0JCUxOOxRvJqNd10tUg6rjToU+e0JIW7DF8fI7qJUN9/M4/z84oPmgHrtpuDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-ORIG-GUID: 49hAcVCj6dE_Nd4iarPbxLF06Q6FAji7
X-Proofpoint-GUID: 49hAcVCj6dE_Nd4iarPbxLF06Q6FAji7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
drivers do. It can't use target_stop_session because for MCS support we
can't stop the entire session during recovery because if other connections
are ok then we want to be able to continue to execute IO on them.

This patch moves the per session cmd counters to a new struct, so iSCSI
can allocate it per connection. The xcopy code can also just not allocate
it in the future since it doesn't need to track commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tpg.c         |   2 +-
 drivers/target/target_core_transport.c   | 141 ++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  13 ++-
 4 files changed, 112 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..8ebccdbd94f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
-		if (atomic_read(&sess->stopped))
+		if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped))
 			continue;
 
 		list_del_init(&sess->sess_acl_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7838dc20f713..60fbebe8c675 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+static void target_release_cmd_refcnt(struct percpu_ref *ref)
 {
-	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+	struct target_cmd_counter *cmd_cnt  = container_of(ref,
+							   typeof(*cmd_cnt),
+							   refcnt);
+	wake_up(&cmd_cnt->refcnt_wq);
+}
+
+static struct target_cmd_counter *target_alloc_cmd_counter(void)
+{
+	struct target_cmd_counter *cmd_cnt;
+	int rc;
+
+	cmd_cnt = kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
+	if (!cmd_cnt)
+		return NULL;
+
+	init_completion(&cmd_cnt->stop_done);
+	init_waitqueue_head(&cmd_cnt->refcnt_wq);
+	atomic_set(&cmd_cnt->stopped, 0);
+
+	rc = percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcnt, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto free_cmd_cnt;
+
+	return cmd_cnt;
+
+free_cmd_cnt:
+	kfree(cmd_cnt);
+	return NULL;
+}
+
+static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	/*
+	 * Drivers like loop do not call target_stop_session during session
+	 * shutdown so we have to drop the ref taken at init time here.
+	 */
+	if (!atomic_read(&cmd_cnt->stopped))
+		percpu_ref_put(&cmd_cnt->refcnt);
 
-	wake_up(&sess->cmd_count_wq);
+	percpu_ref_exit(&cmd_cnt->refcnt);
 }
 
 /**
@@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	init_waitqueue_head(&se_sess->cmd_count_wq);
-	init_completion(&se_sess->stop_done);
-	atomic_set(&se_sess->stopped, 0);
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!se_sess->cmd_cnt)
+		return -ENOMEM;
+
+	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
-	/*
-	 * Drivers like iscsi and loop do not call target_stop_session
-	 * during session shutdown so we have to drop the ref taken at init
-	 * time here.
-	 */
-	if (!atomic_read(&se_sess->stopped))
-		percpu_ref_put(&se_sess->cmd_count);
-
-	percpu_ref_exit(&se_sess->cmd_count);
+	target_free_cmd_counter(se_sess->cmd_cnt);
 }
 
 /**
@@ -602,7 +632,6 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	transport_uninit_session(se_sess);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
@@ -655,8 +684,13 @@ EXPORT_SYMBOL(transport_deregister_session);
 
 void target_remove_session(struct se_session *se_sess)
 {
+	struct target_cmd_counter *cmd_cnt = se_sess->cmd_cnt;
+
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
+
+	if (cmd_cnt)
+		target_free_cmd_counter(cmd_cnt);
 }
 EXPORT_SYMBOL(target_remove_session);
 
@@ -2970,9 +3004,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
-		ret = -ESHUTDOWN;
-
+	/*
+	 * Users like xcopy do not use counters since they never do a stop
+	 * and wait.
+	 */
+	if (se_sess->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+			ret = -ESHUTDOWN;
+		else
+			se_cmd->cmd_cnt = se_sess->cmd_cnt;
+	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
 
@@ -2993,7 +3034,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
 static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct target_cmd_counter *cmd_cnt = se_cmd->cmd_cnt;
 	struct completion *free_compl = se_cmd->free_compl;
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 
@@ -3004,7 +3045,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (abrt_compl)
 		complete(abrt_compl);
 
-	percpu_ref_put(&se_sess->cmd_count);
+	if (cmd_cnt)
+		percpu_ref_put(&cmd_cnt->refcnt);
 }
 
 /**
@@ -3123,46 +3165,65 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-static void target_stop_session_confirm(struct percpu_ref *ref)
+static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
 {
-	struct se_session *se_sess = container_of(ref, struct se_session,
-						  cmd_count);
-	complete_all(&se_sess->stop_done);
+	struct target_cmd_counter *cmd_cnt = container_of(ref,
+						struct target_cmd_counter,
+						refcnt);
+	complete_all(&cmd_cnt->stop_done);
+}
+
+/**
+ * target_stop_cmd_counter - Stop new IO from being added to the counter.
+ * @cmd_cnt: counter to stop
+ */
+static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	pr_debug("Stopping command counter.\n");
+	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
+		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
+					    target_stop_cmd_counter_confirm);
 }
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
- * @se_sess:    session to stop
+ * @se_sess: session to stop
  */
 void target_stop_session(struct se_session *se_sess)
 {
-	pr_debug("Stopping session queue.\n");
-	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) == 0)
-		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
-					    target_stop_session_confirm);
+	target_stop_cmd_counter(se_sess->cmd_cnt);
 }
 EXPORT_SYMBOL(target_stop_session);
 
 /**
- * target_wait_for_sess_cmds - Wait for outstanding commands
- * @se_sess:    session to wait for active I/O
+ * target_wait_for_cmds - Wait for outstanding cmds.
+ * @cmd_cnt: counter to wait for active I/O for.
  */
-void target_wait_for_sess_cmds(struct se_session *se_sess)
+static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
-	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
+	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
 		pr_debug("Waiting for running cmds to complete.\n");
-		ret = wait_event_timeout(se_sess->cmd_count_wq,
-				percpu_ref_is_zero(&se_sess->cmd_count),
-				180 * HZ);
+		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
+					 percpu_ref_is_zero(&cmd_cnt->refcnt),
+					 180 * HZ);
 	} while (ret <= 0);
 
-	wait_for_completion(&se_sess->stop_done);
+	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
+ * @se_sess: session to wait for active I/O
+ */
+void target_wait_for_sess_cmds(struct se_session *se_sess)
+{
+	target_wait_for_cmds(se_sess->cmd_cnt);
+}
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
 /*
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..229118156a1f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -600,6 +600,7 @@ struct iscsit_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsit_session	*sess;
+	struct target_cmd_counter *cmd_cnt;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..bd299790e99c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,6 +494,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
+	struct target_cmd_counter *cmd_cnt;
 	struct se_tmr_req	*se_tmr_req;
 	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
@@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
-struct se_session {
+struct target_cmd_counter {
+	struct percpu_ref	refcnt;
+	wait_queue_head_t	refcnt_wq;
+	struct completion	stop_done;
 	atomic_t		stopped;
+};
+
+struct se_session {
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	spinlock_t		sess_cmd_lock;
-	wait_queue_head_t	cmd_count_wq;
-	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct target_cmd_counter *cmd_cnt;
 };
 
 struct se_device;
-- 
2.25.1

