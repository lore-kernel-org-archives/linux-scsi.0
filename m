Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC969C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379197AbiFPWqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378493AbiFPWqd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7548262217
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJQ3rk029767;
        Thu, 16 Jun 2022 22:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wEoc7WaT6Vq6Gz+MGT1GF/5W4+b8emHnddcnziVQR6Q=;
 b=bnpUO8aP1b1itMFbQqxY9XZgTtpbrNcwq/cikLWvVMkw1lGeX1O0XjO/vutisfnFlFNb
 tN+17mPUYg9mKKuLZ0NChD8M6l99ZQaABT1ReveHhU+cZrXYP7Tmo8XhnX6vj7YvnfAW
 sc4TQW4GGpRAOfVNOm4+yLGXDJHRAIdDRjv/5y4WPC5TPXUdDoojTNrNE4YERytGCWQq
 ogjKJQOrxQKp+3hueES3iYONWMigDqp1KlwmNdGS+p01Ahu2tZCUZv8I1d3G7wG9KQI+
 GZ1P2FArm/EsDVBiqFlKCYubnOYLXSOvNa0DxPc2apxtlABpQcXzVOrw236rz6spPOu1 sQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9m8bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaOYg035621;
        Thu, 16 Jun 2022 22:46:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmq4-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xphe46OViY85Z/SmOmFRhK5Q8N4qLA9QlOGK4wXA1BN+38187X02y3vxAp1NghUBfZ4JszTJFr66LX/BtgRFM8MJpc0+0W7h3EQag/U85ZpUiQ7wFXyGjl16ceBwtbZjZ1o24zgAjEs4UuzXZ7bwrQwNej1MzAIFkmiwciGrk1GjfE2UuV1I5dZBAvF60OL4IsD4wbfVAMvmOEwDxGwIyoXboWSBE/NWwrVo7Z49qZzt2nJ2AxSkHVnyRnUNmbTqeEJDaSCdQibQqyfKixVJy07ndsXKSgjZsW+wmImRejoq0QkNby3707w9YWSJMHnHTWN3wakoUZ6thLOVE2CNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEoc7WaT6Vq6Gz+MGT1GF/5W4+b8emHnddcnziVQR6Q=;
 b=DfxE0ix4IRhdbqEuCvLYXZ8QWqkC1eER0q1ojMPZ5eVOzahJ0u2bCzv5XV5U8ca0LHpCxbR5S/4VBGP9kbiNT14wjbb4BD25QlbhTD0v2fK2tbUH7CRzYgwVVp9DCorHntAG2gC5MmYGWW8a7EpmLFfwstuhAv2rHQFov7CGOxShaT8dv7Dz2j7VqJ4QsB7A56eEUtL3yexQ1rlQYLrjiyt+tVtCDC090v0dEb1Erc4sWCn1g4aADdtJgWZLebqgNlM+Xl/P0xhVG1fhG+DLe1lE+O9pGU2m/9pdGfnvbsewqNZI24mb36ILAMYEmlE9wQEz/lDn+8Httzw2dOeyew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEoc7WaT6Vq6Gz+MGT1GF/5W4+b8emHnddcnziVQR6Q=;
 b=UxB7CaA6FGDhMvn2dA6K4svl9J3zJoyelrtf/1frQx21ZBWutlJo7AWOE1XTVaNRdGACe4b2vwkqJmBn4vfBDvgsqosfwnQwBcTKAXzsLAjvFxNmLQv6yXjmGsMVQZQIo09cce52csa9tCTtVrnr5+YS8WUISSsoLIGo2mz/ezI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 6/9] scsi: iscsi: Remove unneeded task state check
Date:   Thu, 16 Jun 2022 17:45:54 -0500
Message-Id: <20220616224557.115234-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eff73f7c-ab9b-4567-e395-08da4fea0149
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5617A45E0433DB42AA8D0BEEF1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p1V0RLZRImcgCF/Dey2Zv1AtJT/UBDiQbgVBLzG/1M3iehsNHy5gPID21ZrTzV4qBIwCx3qX41gwRzD0DxjSoP3bqHm+GqcKfGXM73wBFn0dWVCCpRvWxG/VrrUQ3+h3ksYI5ll2G0XAz1pCl2kaxdfy2mlTK74bFs2HKKxg/NT+W4/tdAQf9+afdQjWghQkG5LM5oHqyRw1WZfOb7oYw3MIZIFoD2vB++zW6WkYOlJNH8B9NP0/dxrL0WgDNyawei+z5kdzXtlEBcVsUuCNGI30/GNVcbeW7LljIt2Hx+vMx7EIepFPF4fgbaJ/8hm/A4oEGxtyQzxyM2pJAXE5tTOmr5Jmbh5+5AG9bqzZ/0PUTS4ZcF2VZ3jqNE2bHbJbN/hwO2PW36LcAbkldW8hbXHuiDFwDBPT6i0O8zdnVBXXHesQ2OmO5HprX/tEzB3nS30WwyyIfPhOjYuOGyHIhLMG5JhKCZ1bx6n3eXEsFn9bVLzFZsQ4fBVLVx4/U5JlqJueyKw7biRbsJzyM5zhEbBV5Tdr855rz6XelbP6Q3WI9+SjuTp15L0/x8dMWLSgYMu4cTGEjKq9dFdTw0Y7CkzeWCuMz3oFTHK7Td6zOKoXvTdljqYf1Ol5kcGfbgnpxFf7usA4bCvtD8LksL9xEnPjawrd1h+/ARzbn8f86WE4viFAeibB/n+To6QaoRRal3y+FYt4a6hZxcyCfgfpVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(54906003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6a7IjglotNvLDNQkQaBTtLaFef7u3BwlyPApcyLKiyfUF5F+g+0vrJeqZbXy?=
 =?us-ascii?Q?0hEb95tMQ2WotHDHTWplSyYTIvWmafgdpfdJm/x578pREYJBFb9pEpE5372f?=
 =?us-ascii?Q?miTg7d7W8WBH0tpBVrigAop5LTYtoTPeLaGS4XhWX3s36YJ10boSdk0KzViy?=
 =?us-ascii?Q?HkpaISqnetWtTfJG9c2FURmqNDUn7kgVb5vwesseEvgXjlZ0scUdclYFFGc4?=
 =?us-ascii?Q?BHG4wAMf2vj4mEwOIsUprwXMuCIKPwf5nOo1cQH6tdPqHhOR4FhlVkR3ihN8?=
 =?us-ascii?Q?OWyoK3N5j76Ol2Ymn9iKn9b9a3QPFTJEOD/0VlK2XlaifO7wSKCrPLqaYk23?=
 =?us-ascii?Q?rJIXhGFdUyzWKon33HEXzrQhI3PhcIbVG5fL3czOruL8KiBlGG3WlALwzOk/?=
 =?us-ascii?Q?HzbxpR56oiqTuqlmuwD+E+uX1C8b0BcS2vBUC7kORUxxmw95Swxg9up2RieR?=
 =?us-ascii?Q?JvpLfaQs6MkOhWkWI795dQg+H7ra9J2/QYZvrDjjJXDyzSdEXGLjZQfirJC0?=
 =?us-ascii?Q?cJ4ddn/GPJfRqRi+yL5Xz6T9cWRVwCPlPsPudYIFHPRSEktUmGeub9TpnDpt?=
 =?us-ascii?Q?AaJV9opSwnvotNEzQIJTsPFowDuMPpkQf2Xa7A7Vy1JfjHvtLWSXYhnn7RjC?=
 =?us-ascii?Q?G1IqnE6QS4mCwOtZeptldBKaivOW1YfSGJGufMMFMwWmG90U+UaDeguNah7e?=
 =?us-ascii?Q?qU6PjzB7xjqzj/6CjEtgLMVguwxNnI+hJYAUX4U7usDVg9Z4H450wt91z3wh?=
 =?us-ascii?Q?yevfig/674KQx2c+8qvuAwjcXoyNfiybcni0aKpRg0oy/afFApq4/TaXubOO?=
 =?us-ascii?Q?y5A/iaU1RPlme1UamuhjVaQ0Nn7MkhXBWTcVMH7NhGljgIWbryrXe4WDWuQ0?=
 =?us-ascii?Q?0SRhL5Byx43IhIuKR34kvHPPSn/vIFtUL/8AGTNYRMI7o4Oct5W2k/9/09L1?=
 =?us-ascii?Q?BTi1aP3QqV2JhYXLJw9vt7J9yR8RWOWAbNve9sUS/wzn6TZmshJGFhWQ9Pfi?=
 =?us-ascii?Q?7rGTBz1Oyzhzj85suH9bAWfNjidlj/ebeZVzwTywNGTyEkXzjCTlmfxOBfka?=
 =?us-ascii?Q?0KRdb3nELrGkZc6nz4Jnxi+G/f8LioiFHBvhBVnLB5jdC1FQjKdbqTffKwGe?=
 =?us-ascii?Q?HtFJ6MfmXo7PvjSQaaSHRf6vzSkJeME9V6JFjRA28hr+LjfNKsXAKEXvIDJd?=
 =?us-ascii?Q?CuvB9Dj1ud+44+jZOsmNuyg7Ub0M9ZHyh25PGMSsSplTcTaSK6/TBsIKZk1y?=
 =?us-ascii?Q?SNw0EwJjQNGNj5yPxmNGgdIvvaeLZTgIGJAGu65JNCwcZqkeWfGzAnE04iys?=
 =?us-ascii?Q?O1y9U0AywP3mmqAaDWDt36ELBHGhmuWE1kL44+hh+QZ+O1YPtLi10zv7oi4k?=
 =?us-ascii?Q?8B9U6rzHBZ/po2vjd7zxY1+87DaTCepV/fQKviq+LLv61kccB13uwQTxDYq3?=
 =?us-ascii?Q?yTfLaWX4DH7zrDpTfNzmmDjLLGC+MR7J6DwjMacp/LX7o6RARLZMCdWygjIg?=
 =?us-ascii?Q?EL4GGEydSA3T3++fDYOLcXE442s50t1dhUR41724EEW+ouwPrbuVjJxq2e7D?=
 =?us-ascii?Q?9qqoyhoE8ykLEQuzhmbs9pNzKw7oV6FdanDRvLwZNTjAdn18FmV4FRcWcWbP?=
 =?us-ascii?Q?ehMVhwi0h80K1+6VMgJHI0o9kvSRDcMIg4YqyvL2dYoLajDfbN2zIWvJGTaV?=
 =?us-ascii?Q?QcRjVwt6K23BTlVHFAKUSPlJeg3UbSaVo2Yca92uSW/9CdoRtbm825m6wnQ4?=
 =?us-ascii?Q?C3ewskaBmjI+Q+zC6naJ+R8dJ1QW76M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff73f7c-ab9b-4567-e395-08da4fea0149
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:09.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7azU8BWGSfNP7/5VPPzArKPHOz70Xdfen1tuLUrGKMakqALI7FDjeu8NXJDw7gRO5A0xlDRFqNbKmJnCJ6PRjhmsYZoa1ieGmJs5eMr3bQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-ORIG-GUID: p-BfmPzyvMUHEqCRPA69ETaRSg-6M74p
X-Proofpoint-GUID: p-BfmPzyvMUHEqCRPA69ETaRSg-6M74p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock") added an extra
task->state because for commit 6f8830f5bbab ("scsi: libiscsi: add lock
around task lists to fix list corruption regression") we didn't know why we
ended up with cmds on the list and thought it might have been a bad target
sending a response while we were still sending the cmd. We were never able
to get a target to send us a response early, because it turns out the bug
was just a race in libiscsi/libiscsi_tcp where:

 1. iscsi_tcp_r2t_rsp() queues a r2t to tcp_task->r2tqueue.

 2. iscsi_tcp_task_xmit() runs iscsi_tcp_get_curr_r2t() and sees we have a
    r2t. It dequeues it and iscsi_tcp_task_xmit() starts to process it.

 3. iscsi_tcp_r2t_rsp() runs iscsi_requeue_task() and puts the task on the
    requeue list.

 4. iscsi_tcp_task_xmit() sends the data for r2t. This is the final chunk
    of data, so the cmd is done.

 5. target sends the response.

 6. On a different CPU from #3, iscsi_complete_task() processes the
    response.  Since there was no common lock for the list, the lists/tasks
    pointers are not fully in sync, so could end up with list corruption.

Since it was just a race on our side, remove the extra check and fix up the
comments.

Reviewed-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 44283014c4eb..1d646f02d516 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	bool early_complete = false;
 
-	/* Bad target might have completed task while it was still running */
+	/*
+	 * We might have raced where we handled a R2T early and got a response
+	 * but have not yet taken the task off the requeue list, then a TMF or
+	 * recovery happened and so we can still see it here.
+	 */
 	if (task->state == ISCSI_TASK_COMPLETED)
 		early_complete = true;
 
 	if (!list_empty(&task->running)) {
 		list_del_init(&task->running);
 		/*
-		 * If it's on a list but still running, this could be from
-		 * a bad target sending a rsp early, cleanup from a TMF, or
-		 * session recovery.
+		 * If it's on a list but still running this could be cleanup
+		 * from a TMF or session recovery.
 		 */
 		if (task->state == ISCSI_TASK_RUNNING ||
 		    task->state == ISCSI_TASK_COMPLETED)
@@ -1485,7 +1488,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
-	if (rc && task->state == ISCSI_TASK_RUNNING) {
+	if (rc) {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
-- 
2.25.1

