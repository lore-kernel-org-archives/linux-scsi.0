Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C4EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiC2SKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2SKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D861ADA0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsmNZ013396;
        Tue, 29 Mar 2022 18:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VY4UC6mIGEs4VRceGuz9ez5DMpd/gbKhhScaXvYEkaQ=;
 b=wejB2GZ3Vp9CG7zm7rDFFpBscSLbWxLEMp66M2TFdFH5PiOWX8/hlciDeJg/cPmutSH+
 9sSHl4MnSPvFqPLdNnfmBzZmGyz7UqNEbvScBF+yqmbI88kqWZwppPbMCCXGwiBYaXMj
 wA+xGjlXBDXNYT+ejDldq4KP8O81a+B8/Exn3m2gid9TC+x5eckscPiGnlwv01delw0v
 3nx229jf/w5AFMPjMseDIZx1lkkwrfmV5jv8moFa0Wa3t8clsyDVIf9EfniR5urm+B13
 jJE5UcF+KxkUai7viEHfaEqVq7d1iHfpI4CDzU6ugdAH1S2a0L4yGwm0tfdziCWcffCa vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1uctqf6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJH048570;
        Tue, 29 Mar 2022 18:03:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IakrvfKy8Ph+Amnuw0cEfK6QU66SMLXl0c7n5m6nmYU+e3rzNqQJKndxYCHh897Q7rsi1upXtZTYRkqCj79luyPrEE8+Gm7V7+odw+Fz4wYI/FhjRJy1xMSBAnkpqtBQWNqIXXHrK8e47ufS5HEg/PpFrO0nEB0LuSY/bBWzSP7gxoIq1Qi3fwDV7tFTuWLBLsCEbv/iuSCYm0TdW187UOUMVjMDEVPkJsFYYdHprH6LCEqyRM0e4Hh9ZJbDxCEVHSQo2PBkuaV7R2gyMpCJ6Az63doqv3LPQusB0a+GNT6bfeNikKakTCuoMvNogVw7w6zoV8fPYsYPA6nS3Kbm5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VY4UC6mIGEs4VRceGuz9ez5DMpd/gbKhhScaXvYEkaQ=;
 b=KsC/wKFQS3DOOOHDFfj5EEWXR3vf7DUzdCRs5F1gRaBnIQN4hyUgCWTkr6fwIa8ryYtWOWXCxkTdjRTJ7a4uYVMg1PxZYmx8wmY2C9ifBlEIkskPUe595mWOLvrdnIsQdiwz5kLYdpVJrETdWWE+rT5BlmeEgps4ZWHnnsoMZxVzWAvUhpgtfKIdR3cNqn31yjE6TvHDX0fGuxeaN4qLxSoxyRxa914gq0dXQwV5ok6rJRr3An6VH/D2jvViySvxog6g1trtwXfD22SSvIEaR+AiLszkhOGynXdJFt5JWSrrhB4fU08Qjo21/YUMvz79SEcXL9BsIAO5nBq0WQ2waA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VY4UC6mIGEs4VRceGuz9ez5DMpd/gbKhhScaXvYEkaQ=;
 b=i8cX9bpgk1zXS6Vlo2SYqK30wRM/vS1q581HcnncyprrvyT6lZqnwsxRI0ICAI0+kRYu3+DiVsRkH+M8i/Hu0Kqyi4GgJBqlp3bJDNEAxADpYwCqdQYoAdR6EcmBOmwBcuw7CgdkbGZQ0CujkynuuI2ItsrHHqZJSUr+7IM9OBQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 04/15] scsi: iscsi: Fix nop handling during conn recovery
Date:   Tue, 29 Mar 2022 13:03:15 -0500
Message-Id: <20220329180326.5586-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6785f0c-896b-43ba-4a51-08da11ae724d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584EFA2ACD6D3C68FDF56B8F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PBT5Jf42EUdTJvz2pFGzwGeA2YxDhPMd7A4eE7ZgMq5AmRuad4vqO0l4YhG07Pw1YQZ+b+oosXKIoH6/bNf1tSiDU35cyEz1LOrGqhOl2seXg2YWjt+1/JArx6U4d/iiTgAs9T/ZEsnv966kaZ5D1S3WS8cyJn4ha56BfXBNwX0WlQjC/i10uEgZztySdHHifTwOn2pQX+vLFGOhdommk33Bpksolzis4wpUpveDTJETEYH2egYD8qI3ly2GQ7Qgq8ycayXwaem6nSd5IzfWc/iCukVrohL6VFAw7pyBzADFAXsw8rH4e0FSkOhE6qoK0yYv2aFTvsegzBWCfCslKvqugqLnYO1IO4ufIF5vSP5x0DfskvMkzNpCVMS0uxZlE8bWKZjPYP2RJIwvGIFQOumTjTkqRCLmJ+shNA0aeKgndnibb5yJylbrb2P154ccheQTqg9FMFO5Ko1EEJcObJH/59TDTQyLBsRtYrVnrKa4v6J8yC9HdLuUMuVRVWf7hGPKqEcls3wO+a5SFAzrKAZ9sGzi5otfxsfXovy9p9Noor/RntXHc3bs4EWBWZ7fc5KDYO1pmvIPmZuzmmHf2wKmsvF/N6nHPuEpmuS5DyFvBWGneq2PtWKRRMigFQgMxAWyakkhlV77VTk3vz9cm3gSurLzOjMtX6WAGwN0Eim90wUGQ7sfBQWI5VJVa3ztWqQB2QVPkUT0NPUNFPAdcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lsM8kqo0D8zYnm+9PvRjcLwLmotn7h9rzpMu6GeZqoBpVhmkGb8zszpWzMp4?=
 =?us-ascii?Q?ExaASF4dWPrNxtnag7jEc/c0bO0pn/Ve1rw2Apxr5nBOlEoUwirOoiT8GgAR?=
 =?us-ascii?Q?nYjFHqlEN0OxZylMZTeuEseasR/ql6/KD6OQCkQLDYDyBUJniB6dHp5MG1ci?=
 =?us-ascii?Q?eNHdx12yzXkIv1TmiUIVm1gmL0/W7pRNJ2LxkTKOlhzZcl6T0reW40qDxr/4?=
 =?us-ascii?Q?rdXDn4LhWOfmTrtgcVpDdZnObeIuAA1zqWbyx0Qo6xMWo7sVo6GxzvfRRg3m?=
 =?us-ascii?Q?eyNyFaD5KZ6rg4EVxTZWCEJt/DRSrNHrSOgMyaHf82VPcaLw+x3NaX61FXEj?=
 =?us-ascii?Q?McQJ8WtaQCVtTKLQxuEyiZsMSxkUl4BX7t3mIbaZ015NWftbLzk+8Q3B9JiF?=
 =?us-ascii?Q?U/JulE7GGqqUGKhozHcIVWnHKF0tHD4Hcw7Z8MYvSYHIW2ja8Psf+uTwa0R2?=
 =?us-ascii?Q?G0L534jXRsaiUkNsdPy+uPhMplAmzGrfC2k0q9OKA5vod0i8NkMFnMLmX99x?=
 =?us-ascii?Q?Td7la543hIi7WGt6fyyNrZIvXL+5WbuHqzBIpFce3w0hmtPIhGeZA7qQWNys?=
 =?us-ascii?Q?ApDGpVrWH8ivTuR3BW/ystoT1b9VFM8I1lcpWkLunNgmQYm/YSb/IJAB5G3Q?=
 =?us-ascii?Q?I0A7aDbCgbNU17m5hgpymtcDuwnrM1TE3eKv0vVCW7f2nKg/RlkkKikQp1rW?=
 =?us-ascii?Q?Ur1uMxZosxdk5oxdTBChQz/80nacqblu9M82bipd+8trBY3g8sIWrXSPsKP2?=
 =?us-ascii?Q?kJ3vPEQ5Dbpd3gQfR4nulPTU1YvxauTDNk6pYuFyk6M9Puvjlo+B7A5Sxr4F?=
 =?us-ascii?Q?pheASdAqIy9Bbu0XIAmkl9YN58B4cn7HCVejKVtwO8dw9YXhrW6vj5KH2+FH?=
 =?us-ascii?Q?dqe6GSXi782IoDBcUW4JNuOUyAXlzmOU72tvqjRUhsTqpL7dRTut33FJHd+T?=
 =?us-ascii?Q?/6GTfLovL9zQW7tMxvrbWvDaW7UxnBx2+FoSCCVom1umBMWKVO5LgSdtwLq3?=
 =?us-ascii?Q?9YV/P4XO+JT/VYtfDr6LAWAhULKtKDF6beZoNIIRrXHY9Z8vTcQdQ//J7ZIv?=
 =?us-ascii?Q?k18vYWGQfD1wQjmDNKsUFgykRSU3+2CZQ73CPJJ9J6T9CTvSDF4Du2QLcKU+?=
 =?us-ascii?Q?xTZ/7MGN4rwrhqs8C4H8kgh8pZpEI80q9E5UzcsaABfWoqQcN5LjTc58vT+F?=
 =?us-ascii?Q?McwYkbQSERFh0hviFMQNH7sSrDjS/GLXeFOs6sxskZLVxQKnm6BAJ72TVs1I?=
 =?us-ascii?Q?wdHhAxZAG0UBfqkD4ienMzEQPEj0PfuZJtR901WyiU8kSzkv58y12Pe/Lnzp?=
 =?us-ascii?Q?rOdge/CWrbSEIxTXrpYZ/C1yvUJXhEuA9i0NjnimMKK4U/dmz+Ut7qL8l04Z?=
 =?us-ascii?Q?MW0PRyhmh4u9MjjXZvuENIo6RX7YyVMpLMMLx/5f85jRKKzd4YztHuHZj8dY?=
 =?us-ascii?Q?wSVrs7F7L4ipeZ/Np9SCpbCLCyBoCKxU8fUe1BABTAqQCDeOu4JHlUYKfqd3?=
 =?us-ascii?Q?IHeb7TmTfxvmG6IgEZLddXhiM8Nm6Up3L6rozoIMqCGuUy9wEYjL0YKRbYrf?=
 =?us-ascii?Q?U7dlSJBmg/3wdDwDWAr/EJ3TOa1eWh0e7Gt3YK08HOa8LHewIYqmiDBPAp/m?=
 =?us-ascii?Q?jJGB/bs2//1jHMc7QUCmWlxb9/QHPvAWU8VI6084yqWQNbHq2c22sVCwV+3u?=
 =?us-ascii?Q?SqmbMtgXpS4E/dBs77QbxjHtLdnRDuuuJ3uaW6wuxBjCRiqywmez1lXQOGMy?=
 =?us-ascii?Q?Bp+VBLAH0r/vPfRdFGVs2RaHR/keWgA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6785f0c-896b-43ba-4a51-08da11ae724d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:36.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adqh3J3/V7EAKJFCMMwu4pVTHnKb8X8CdDl/3SSM4G/v+jFdy5fJDrpH71p84tWdEFhdteA6wh73PU4UVrzbdKRRCvx9d6mh3tK5/aUA6qM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: lWOwjpJoS_hHlCoiVbeFdvCXswLNiJYy
X-Proofpoint-GUID: lWOwjpJoS_hHlCoiVbeFdvCXswLNiJYy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a offload driver doesn't use the xmit workqueue, then when we are
doing ep_disconnect libiscsi can still inject PDUs to the driver. This
adds a check for if the connection is bound before trying to inject PDUs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 7 ++++++-
 include/scsi/libiscsi.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5e7bd5a3b430..0bf8cf8585bb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_task *task;
 	itt_t itt;
 
-	if (session->state == ISCSI_STATE_TERMINATE)
+	if (session->state == ISCSI_STATE_TERMINATE ||
+	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
 		return NULL;
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
@@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->frwd_lock);
+	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
+
 	if (!is_active) {
 		/*
 		 * if logout timed out before userspace could even send a PDU
@@ -3318,6 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	spin_lock_bh(&session->frwd_lock);
 	if (is_leading)
 		session->leadconn = conn;
+
+	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
 	spin_unlock_bh(&session->frwd_lock);
 
 	/*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 84086c240228..d0a24779c52d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -56,7 +56,7 @@ enum {
 /* Connection flags */
 #define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
 #define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-
+#define ISCSI_CONN_FLAG_BOUND		BIT(2)
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.25.1

