Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB377C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C5B61875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347557AbhI3CGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47956 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346934AbhI3CGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:19 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0C6DK017464;
        Thu, 30 Sep 2021 02:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=lByVmpQiT7Xcjm6HY4ceH48atnToinN4nMJT3IH9wvo=;
 b=ARTY2L6QztrnFdkUGO6zrLPFyNrebC57IQSO/LIYnat2T/fDpF6MI2NcuiKRV/v4+VdM
 a+M5DFRL7wSjmxEASvqxM6FzLKfcj5havPqHCjB3fxO+wFWfhPIwQfqRLrB/QMxaslQz
 EWxylU2e1iR7TSeSxWk24DNA07DYh7hMMFXsR6nic+R2Pj5JgSFjhO5Ddf+s+e8NFrpU
 WAhDxD3fhxKaqUI2g9squd8obmylSzQGBZEQBXuZUWiPUMkjJoKAUfLVlzQBMhF2A2m7
 F1q7SDbeI9RvKIVW1bY6fm2xS2VnFjDoIqoJAdcocsgRy/pfhY3M4iXVqab7s5hMQhVA Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hswrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20Fu0160315;
        Thu, 30 Sep 2021 02:04:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3020.oracle.com with ESMTP id 3bc3cf5ava-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGKJJ/zO/BUc8QR/5fPouzUOk8Zuu+qp7nLp0oKoo1FHdVUOHnQ5yeBIuW2RhaxsJ2o37BGh1zKIjyUoFLOgDWN4cUda/2C9CMZ4xCOGgkfSYUoVds5gUbka9tlNGsMdzW/nQK7Hay2d7P1FLEx0ssFBezkuE4H+77jKsnNEEuJ/CZIpSfCjCzpJ8LMxn1EJL/QRjKE6lzPdMp8c4MAw5jteya/lPLMCLIpmdnm9AUu8D9Ovym8W2G6Yn7pRhlrUOfY2SLyqN3uwxwAH2rcW18/H1PpVja06LWnY9SYmRiWd/dgijdyKAvz5oy2DrshUvB90aT5SQYdW8swgiBLrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lByVmpQiT7Xcjm6HY4ceH48atnToinN4nMJT3IH9wvo=;
 b=On+63doDbUqqcoWgFsMHQLNsRnQBCU2A0D/Mv458oFwJGmyQgDMmPRkL7LV7iN+1j7jxt3SMe5KDtQpq6h8Qi34O9y9m9dEPjfgrffBY9IUvmk1K2YMQGG+nDxA2W1FG+o7VzMwaUf8kOxWYQqv/UQMavwNlMZ1E8duKJpbwi46SRQkdkWNiLWaswqwsFmc/XGWGxNaj474m56F6RLwb7fGG9DliusLnrxRIgFX4nz1pXesZ8upl+4ZvxHG+9gnCbXvKl8DQ4sUW0c96qi0CZ1SH045nC89Q2nm3aCpiBke0mjNm49186/1BRdwlYBZIeN5jnJylKueZUB+qdSmxxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lByVmpQiT7Xcjm6HY4ceH48atnToinN4nMJT3IH9wvo=;
 b=QO5TF1yDvPpJKqDyfDvt8nQ33J1eor7fXLkvxmAvnM+VIj3/Gp60HCNqUDn+d2RgJ7tq8somIBq3qdjEI66LOSoYnVszmIW4CJAhDA2dWe03l2UQQ991Eo+p9yhyLTiPUFHvbj13hY+tXybx/TfkQRdVoRn/Eis3eK/+fzYATF4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/5] target: replace lun_tg_pt_gp_lock with rcu in IO path
Date:   Wed, 29 Sep 2021 21:04:21 -0500
Message-Id: <20210930020422.92578-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6729f218-bdd7-4d39-4d34-08d983b6a564
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB4909A59D3FE58B4CD1E88E9AF1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MGlEp0lT7CM9FeckobZq13wF4c6co3JdJ3iokh16OMhbTq9hmr/S2bC6imuWKqLcmHwwmlqGD6174SFaF6qgc3KTzQaA4mU2QSjO++LKAa+I3T7mLzPr2Kn0jeOG8jkAqu8xMQ4nB33xI6+UnniucFN8yH5W6jgMrFqiiguogghSM8j9GSDDy1KmIpe6akXkofuF2dQU4fvD+8hIT3q3yF793gIDzlQ/X2+4jP0SmTiG4rTmka3uRJZ/rpjK6bScqQZMazY/4A4yFt6BLRkc50qq+g5YMkd/OrZFSlxhWQz8WbrOLJXfk9l2ORJnZnAUby7ay16GjijkoQHCTnp5XfFMEHvq065fTsZPBCBaIgJaTsaupgkrRMqD16kIxZFn1a7n4Tddpxn871SK6+T80oVBzOIpBSEZo68mtSihiXs+olOIMqPykDw+nE4TOTxSOYX5IbFc9PU4Dc/Qhco3EuqwNbyKJOGnhlR78f9tEdV3Sy/8Nf6JjEulKGySxgqKqNoqCTxWWETC3i/SXxC64LciPw+NWbweqEARe671qzbQKjx05XfPZNvBb+rxqG+xXxN4XK1OAwL6mUp6v1MspLB3VUHvu2463xttzJ5sX/loZ9hE1feAvlA/LcA+WCGQJAj/RHqx/gtp2fuyKPQQ4XSyO7Xh/nvsehDoDSi4++Vb9wvERBGCZIhSifSDIduQwyGJbX4EwBE0PELds+Lsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(4326008)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(107886003)(508600001)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ISBBD+s8zZfpb4YeltjFFrwjjvMaNzzNsUBCXRv/BXeSdui1u14oUOIhqFm6?=
 =?us-ascii?Q?dSk7o3qEN/E/9fKehFlf7LUzKF7ihIXNEXu5ZpnliVBoPWz6F/jtvepvDIv1?=
 =?us-ascii?Q?WvEgQDOqfg4nzdAvjiomSyA6Xg+5wSI56O3hi3Qibf0CjAJE15Y91iI+uRKw?=
 =?us-ascii?Q?a6fERsnKES8PiByYnrdMIeDTcz1d7NylHjZpmBFRislD9gZWt3YPdRDelw8D?=
 =?us-ascii?Q?zkjrbPSCV3mS+iouxNUzYWOwRdu2l/h97VBR1aaHPX4qVjN3G9nDoZRVU2h1?=
 =?us-ascii?Q?f7VjpxTUFXll6H4LRBQhmWot4wB0IflRhXyQiX6dOimhtfaTVjUpEKzZGwoW?=
 =?us-ascii?Q?/t7MNb0pZD9/JL3ELDVxSxDrwt6SCvpf52jflGSvyMpC5d+qhHEeX7WrXwJg?=
 =?us-ascii?Q?E/07F6Pd+EMx+tAtAnzSm6DtAohTWmlPtA0rUKHbiMp/98tsLIDHDMk3Vkhr?=
 =?us-ascii?Q?E4I9AM5RJyDtMXQBGPmK2ueWGIRZFKbILSu0pvb4QQ7eXeEoz3QTwxcC4QsS?=
 =?us-ascii?Q?XCGQCEtALOngvbxjR8mHzyerPJ/zxnBAd3TtMAX086tUcGTRbRvRkEbxPhHX?=
 =?us-ascii?Q?RUShSpFTWDc+W3XIF3pIc6lN024AMf8IGrMKQ+uw5Ji0tB9MdV78vVqLB5ZP?=
 =?us-ascii?Q?P8c6sSU50QYWvx5KZ9kmdaOa4TTCidirwJLJTEZ3wAqPYmR/SIlVbAd+3YQk?=
 =?us-ascii?Q?XMLep4O1nsqikekoRNE33dMz2pzbm0EIQpHcqCpjR4VnFYlEqcneOmmMn8/s?=
 =?us-ascii?Q?ZL5XgfaHmCdaAaGO2cVnc6jnk07DZB/oDDUpRyZ2n2G3jFnNfn5z42mR55HA?=
 =?us-ascii?Q?LOC8mEELhm8FouRv6HsLe+WglUpHoh96mvErNp95NANwNjGeXPuzz5sNKxw7?=
 =?us-ascii?Q?R/5v5X68SYy7bOy7809cu89nT1NmUoH9py1K6u7B/021XJjaWqDEZrRDCZtx?=
 =?us-ascii?Q?LktH3HQVtSlSHppJh4+tdDgqZRfaKOzZrOlLkZqg5qtwwcKg57o3ENdRy0vA?=
 =?us-ascii?Q?xM9/p6eZZyxqkpu0mkPisXCGbzVQ6vezoJlllrSLvyS5pfAn1DOtNIUuyxVT?=
 =?us-ascii?Q?dxIem1oZ3195tXM7Dqnbw+h8ow+QXIMcaOLeGMIiAwEvPzSDfQSJsYUZjzrF?=
 =?us-ascii?Q?mFqFSUw1mearCg6jHWDrX/ylCG+TgbSccy+0GWW/YPa5CV9Q9x5C1ZR6C8xN?=
 =?us-ascii?Q?QqQ5cxOJ8LBeTzySttOVHVs96IoU9vdKqbrrrkN6fPTVcNIUMbR7yTXgNJLi?=
 =?us-ascii?Q?Xs/tdxlrsTstk25Uen/JTAicVCFH4FDE/tqW9xxINO6pWvDJobmEAI95ifrB?=
 =?us-ascii?Q?8CSQnh4ip2QXzsmQbCaX9QNR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6729f218-bdd7-4d39-4d34-08d983b6a564
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:33.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTSPxp/omoNPgpJaIsjM6CY0BA+q7q0RYv2xUyEgyxD1P86nUyzGFt2ZQd91pe3bGNH0Lk4t41fD/gnnTS+ZIDSeCRjPwRYKaiyOQ4WdBVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300009
X-Proofpoint-GUID: zavX18Q5GES3gMcxgYjdQ5bKexU_Qhw8
X-Proofpoint-ORIG-GUID: zavX18Q5GES3gMcxgYjdQ5bKexU_Qhw8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are only holding the lun_tg_pt_gp_lock in target_alua_state_check to
make sure tg_pt_gp is not freed from under us while we copy the state,
delay, id values. We can instead use RCU here to access the tg_pt_gp.

With this patch IOPs can increase up to 10% for jobs like:

fio  --filename=/dev/sdX  --direct=1 --rw=randrw --bs=4k \
--ioengine=libaio --iodepth=64  --numjobs=N

when there aire mulitple sessions (you are running that fio command to
each /dev/sdX or using multipath and there are over 8 paths), or more than
8 queues for the loop or vhost with multiple threads case and numjobs > 8.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_alua.c | 61 +++++++++++++++++--------------
 include/target/target_core_base.h |  2 +-
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index bd0f2ce011dd..74944b914b4e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -247,11 +247,11 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		 * this CDB was received upon to determine this value individually
 		 * for ALUA target port group.
 		 */
-		spin_lock(&cmd->se_lun->lun_tg_pt_gp_lock);
-		tg_pt_gp = cmd->se_lun->lun_tg_pt_gp;
+		rcu_read_lock();
+		tg_pt_gp = rcu_dereference(cmd->se_lun->lun_tg_pt_gp);
 		if (tg_pt_gp)
 			buf[5] = tg_pt_gp->tg_pt_gp_implicit_trans_secs;
-		spin_unlock(&cmd->se_lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 	}
 	transport_kunmap_data_sg(cmd);
 
@@ -292,24 +292,24 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	 * Determine if explicit ALUA via SET_TARGET_PORT_GROUPS is allowed
 	 * for the local tg_pt_gp.
 	 */
-	spin_lock(&l_lun->lun_tg_pt_gp_lock);
-	l_tg_pt_gp = l_lun->lun_tg_pt_gp;
+	rcu_read_lock();
+	l_tg_pt_gp = rcu_dereference(l_lun->lun_tg_pt_gp);
 	if (!l_tg_pt_gp) {
-		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 		pr_err("Unable to access l_lun->tg_pt_gp\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
 
 	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
-		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
 				" while TPGS_EXPLICIT_ALUA is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
-	spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 
 	ptr = &buf[4]; /* Skip over RESERVED area in header */
 
@@ -662,17 +662,17 @@ target_alua_state_check(struct se_cmd *cmd)
 				" target port\n");
 		return TCM_ALUA_OFFLINE;
 	}
-
-	if (!lun->lun_tg_pt_gp)
+	rcu_read_lock();
+	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
+	if (!tg_pt_gp) {
+		rcu_read_unlock();
 		return 0;
+	}
 
-	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
 	out_alua_state = tg_pt_gp->tg_pt_gp_alua_access_state;
 	nonop_delay_msecs = tg_pt_gp->tg_pt_gp_nonop_delay_msecs;
 	tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
-
-	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 	/*
 	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED in a separate conditional
 	 * statement so the compiler knows explicitly to check this case first.
@@ -1219,10 +1219,10 @@ static int core_alua_set_tg_pt_secondary_state(
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int trans_delay_msecs;
 
-	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	rcu_read_lock();
+	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (!tg_pt_gp) {
-		spin_unlock(&lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 		pr_err("Unable to complete secondary state"
 				" transition\n");
 		return -EINVAL;
@@ -1246,7 +1246,7 @@ static int core_alua_set_tg_pt_secondary_state(
 		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
 
-	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 	/*
 	 * Do the optional transition delay after we set the secondary
 	 * ALUA access state.
@@ -1754,13 +1754,14 @@ void core_alua_free_tg_pt_gp(
 			__target_attach_tg_pt_gp(lun,
 					dev->t10_alua.default_tg_pt_gp);
 		} else
-			lun->lun_tg_pt_gp = NULL;
+			rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
 		spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
+	synchronize_rcu();
 	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 }
 
@@ -1805,7 +1806,7 @@ static void __target_attach_tg_pt_gp(struct se_lun *lun,
 	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	lun->lun_tg_pt_gp = tg_pt_gp;
+	rcu_assign_pointer(lun->lun_tg_pt_gp, tg_pt_gp);
 	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
 	tg_pt_gp->tg_pt_gp_members++;
 	spin_lock(&lun->lun_deve_lock);
@@ -1822,6 +1823,7 @@ void target_attach_tg_pt_gp(struct se_lun *lun,
 	spin_lock(&lun->lun_tg_pt_gp_lock);
 	__target_attach_tg_pt_gp(lun, tg_pt_gp);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	synchronize_rcu();
 }
 
 static void __target_detach_tg_pt_gp(struct se_lun *lun,
@@ -1834,7 +1836,7 @@ static void __target_detach_tg_pt_gp(struct se_lun *lun,
 	tg_pt_gp->tg_pt_gp_members--;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-	lun->lun_tg_pt_gp = NULL;
+	rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
 }
 
 void target_detach_tg_pt_gp(struct se_lun *lun)
@@ -1842,10 +1844,12 @@ void target_detach_tg_pt_gp(struct se_lun *lun)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 
 	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	tg_pt_gp = rcu_dereference_check(lun->lun_tg_pt_gp,
+				lockdep_is_held(&lun->lun_tg_pt_gp_lock));
 	if (tg_pt_gp)
 		__target_detach_tg_pt_gp(lun, tg_pt_gp);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	synchronize_rcu();
 }
 
 ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *lun, char *page)
@@ -1854,8 +1858,8 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *lun, char *page)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	ssize_t len = 0;
 
-	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	rcu_read_lock();
+	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (tg_pt_gp) {
 		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID:"
@@ -1871,7 +1875,7 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *lun, char *page)
 			"Offline" : "None",
 			core_alua_dump_status(lun->lun_tg_pt_secondary_stat));
 	}
-	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 
 	return len;
 }
@@ -1918,7 +1922,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	}
 
 	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	tg_pt_gp = rcu_dereference_check(lun->lun_tg_pt_gp,
+				lockdep_is_held(&lun->lun_tg_pt_gp_lock));
 	if (tg_pt_gp) {
 		/*
 		 * Clearing an existing tg_pt_gp association, and replacing
@@ -1941,7 +1946,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 					dev->t10_alua.default_tg_pt_gp);
 			spin_unlock(&lun->lun_tg_pt_gp_lock);
 
-			return count;
+			goto sync_rcu;
 		}
 		__target_detach_tg_pt_gp(lun, tg_pt_gp);
 		move = 1;
@@ -1958,6 +1963,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		tg_pt_gp_new->tg_pt_gp_id);
 
 	core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
+sync_rcu:
+	synchronize_rcu();
 	return count;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2121a323fd6c..d7d31a508dec 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -749,7 +749,7 @@ struct se_lun {
 
 	/* ALUA target port group linkage */
 	struct list_head	lun_tg_pt_gp_link;
-	struct t10_alua_tg_pt_gp *lun_tg_pt_gp;
+	struct t10_alua_tg_pt_gp __rcu *lun_tg_pt_gp;
 	spinlock_t		lun_tg_pt_gp_lock;
 
 	struct se_portal_group	*lun_tpg;
-- 
2.25.1

