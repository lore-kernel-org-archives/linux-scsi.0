Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466BAC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjCIWdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjCIWdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5481BD7BA;
        Thu,  9 Mar 2023 14:33:37 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx1Zs003614;
        Thu, 9 Mar 2023 22:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8xcfLDWPaMgVcdlQrYif1pqD/aCtCDC6qLNcL5HiL/c=;
 b=StPUlqwRzjZJEQix/eG9vo2fNYHiAjpl+CoVo5WY7Yx1aGhFbW7PJc1Owazzd+ENiR1D
 JxlJNphoW7/F1M1agMCbiyrqgl5GSy1U/6/grrSWv3d2Dq2bHULSLK0MyE1wxrOB7dAD
 SoksEqqk0wNq9jDAShI4YWAJX5KgSXdL+dWrTeuwHcLX3uh2JF1nGKMmmhBOvkZkzdiH
 vXTPGNHz4g7s5O5pThwAGJP1SlcRmOhdiaDNjnJbv1MXYAakmgXeJ634/oWK7YIiKvGe
 +kQm13sDSsC4bVzzT/FLqUrW7PQ9WpnmKLBxK7H4ni3vkOaek5t8JkTCUGG+qpkVGbsX qA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wv205-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86J007359;
        Thu, 9 Mar 2023 22:33:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHpUCEH7gYqY6OO1ZvmNmNI93hi5RYX3R3yBb7I3mWk2+mcuwJV7P1qqbqlb8WMcDf+5wi5qaquvBOSI5sskoGmRjvK00Wvp2B0sCBK5/IvExyBoFR/y9ELdm6+STHsBdK4zM6JBLWtBJKZL9kLDoq6bC3SCEHvEy/OP/vumY+rxKjFswek6j3d5TrlJjzNukADVPzBk7tmhZ2wrbag4hmDEc9XL3JOedwHrTtONLwWymZ8FdL9C/GqvHhhC6SCNx3TXxs9/dsk2QaoxhjiqtfSGnBLiqaGbrZXSIx+FvNl7rAD2SG3HAIKqP+kIaEujY8GJiKdzi4MG/JVZgLrrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xcfLDWPaMgVcdlQrYif1pqD/aCtCDC6qLNcL5HiL/c=;
 b=mpFhvw5IzewoB6+m+zUrApAHmRCXET7F6Cpm/eU6+a3ayqhv0rDQItcijjv4g4kT0gprRo+A8qV4U8vdhDWgqigzF/0t2PMJinY3qecCPX/yFcBu2jY039odpH41LyC7eDhfc/S+ZrlLOwBy80nff6hQuhRzxlZgZPLDyA/RLAvU8gUb3AZ7GCrVTXcUWVaUYGCGqb2qlKuuhn5sDeefbjajnCt3HHzCHdUNfxDHz+QEq20MArWfDK4qBJLwFStlZ+ckWoEX6zgVlm3WIPPX38TLJL/wHodxjyaBxM23HyjxmGSbR8mxOsLp2ugNETjNYMAtq7Ne8li8q04k1Vwpeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xcfLDWPaMgVcdlQrYif1pqD/aCtCDC6qLNcL5HiL/c=;
 b=LVqOpC3bG2ci0uUQzr85ycXl8Gx29kgZ8KQ275dRqndOrHJQRTbGGQnVIqxdSbs+u5utRzoGBPxJOfuTWfQ2QqjZsNWzOK6JgNRM0+gdbi6kc3Kgo3TJsoBLZRMORyjRsvrNO7NERezzyZkuMFuZJpVNOlYxzDlEUY2sKVqjBfE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/18] scsi: target: iscsit: Add helper to check when cmd has failed
Date:   Thu,  9 Mar 2023 16:33:02 -0600
Message-Id: <20230309223312.94595-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:5:100::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d69d48-87c8-45bf-4ebc-08db20ee4c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kmi6HS5DNQ0PPLFzt0V9rq/IhoCuah40V2dv2aHJJFvFnjXKLEyRvpZkWd6G2cPDOPMjUAT4bOeFdw6/mHt3TvZQ7JT+z681OM/wzWfqnxeWYlCZx+sWUTV/4f7oOsjaTf9RnKt4mN9A3VK73pEtjhAIbfUG2QSp3HBS0T9YmpdUsMT+aAmSlbdi90E6HY8o2mv7x29+NL0EmfbcEQJAoEjQIhrL/1tgQCemRfugN0Q/XSNdfFXFNeqpyykMd2SVrtu75nJy1pTghmTUm11cwFwYoCOCbuNNldm6iOUPi4C7FeKBKHBsAyh3TO5Ssu0VpU2gO847qvpXyCSWbLdv9twsLuCXLGF2+HogMl/+iYNUhQmyArrSv7DYP5+iG0WEzNp/6yo6XkQP6OljlsfQnFPiikA04H2xsuIAQ6w3ug7ixh8FkMMRezG4osJV4/U99t9uP2bXhlIxh0lMzCnXf9KGQDePR6bQdRHekQ9UiLqPgCl6gNSYmd8vpdy0ililQu46VlLF4ZQ54gXquwMKCX70jG4PjVbq5cLwaK9X72g/MmTmeFwyb3EMpZNxelzRm58K2dihEu+W5uJH0kivzUJNpXZ2c4uhObKfLjgL0+Z/WYKFhKThSwkP73nuaDyD1ZmKta3J4hgVoaQLsKRTjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIf05ZEt1A8KVdKpmXg0MEzV7WVvA6EUFFl+nO1HJxS+gVL2pM5WebtnbBaO?=
 =?us-ascii?Q?sY2Q16jnxmbJWwNCQ0HosYb3Y6En8x4PDOZAJlkADwKuN/2E4D5sOkZNcSJl?=
 =?us-ascii?Q?uyotX7iq/uzP2DXUjshC6ntQtDPq0Bnb3guoX1DSKELTO1bTaYmLNt/8Tvnh?=
 =?us-ascii?Q?njghZSwi8iqUG8Sr2k5vzG4EcP+V5XD/WOw6MzCoShQFlGejBtbScHVlObDh?=
 =?us-ascii?Q?Abg9YtCIExP8J58AO1gwdraTPe+bS1fFbG83Xflx0MUMsvQOD8GHSxKhvfqc?=
 =?us-ascii?Q?AFI2wRsPFHkWJhbT5vm1xFMz+aIHvYSh1y7EpGLlJ5m2JUUEbV9qTNjQKtlQ?=
 =?us-ascii?Q?Mk1poUkrMUPHDGuejvR1TS1llXg1oxKtDO9z5EvxQ9CFIHMt7uWQ7gB0Oiz9?=
 =?us-ascii?Q?kNx4+0uLk98QOceInStydfd9O+2bs0JKJmoXpj6WJR7jzyN+QaohDB9oBwcA?=
 =?us-ascii?Q?lnWo0npsCCArk4CGt9bGnBAAvCY86kcSNiwBB4BS2+lCUl/M3VdwHp9FUGNb?=
 =?us-ascii?Q?4akYaiLngMgJbn/xqQjxQkAMGFceXGKfEVqblrQB7CAahGZUmCJMcqWMzV3J?=
 =?us-ascii?Q?vQZEFor1ZwPXATGDc2KmrW7mDdtu5sRmlr7QNv4EgdETwjXBw9mkQCgcUQ6k?=
 =?us-ascii?Q?VwjhgKZwxq5hIWi/AAu0285S9CEkMSQkTpKMLur7h9Fym+PFHAzRuUgXsiXf?=
 =?us-ascii?Q?cznpWii76PMiIVAdq+3FFH6p7Ph8t825nZKDpTFSDyXQanZmGVpi2274Q05+?=
 =?us-ascii?Q?frF0mFBflUlz+B0TBSqIcGAcdNpW1LT5vDDGi6eFxy+EyvdNacdyG7JKK3k/?=
 =?us-ascii?Q?58lsaFYFgOAplaNXUaOk3hNIABRdHuYd3vGpZuterXFabYprZXYhZplNfv9d?=
 =?us-ascii?Q?0sr9xJ4QqzZGjt7vfBYE+s8VKUo2mhYEO2KImDQjK7K5F80VfEki+j4Ih7eX?=
 =?us-ascii?Q?VDjvY8EdHG6pp3exPKV0S72DDxgn4Nz44DXoeCgohkcdxZA4WZjfSeycyKFb?=
 =?us-ascii?Q?hgLBZtEC1yRK6rki7/Lu/3pOC1ZQYoMt1tQlXkw/cZMWfdMuyeqoL3lf/M75?=
 =?us-ascii?Q?3wwbgm8hcpg0L+SJrYywvFz8bGa9/+OW/HfWYXLnqM7ew78HIQ9q/vbMQ+bX?=
 =?us-ascii?Q?kaElJufZstJYGCg45FYw3npKmCqOpKsEWO8S9BSnJAOkxSnbqzMOOkp6D489?=
 =?us-ascii?Q?p8f3bINUlOBVcoL3oYCfRm4omZREa/TLqrdjPV4c5Jo9HIFiQj4NkqsTSyFp?=
 =?us-ascii?Q?wUrSG7Bk0Q1A6vsbPYlKnz404gI9qfuFVH6+XfygNWPsZUatrfIp8h5NCVy+?=
 =?us-ascii?Q?bb671AAwH+d6rsSYatjN8pz8Ahcyvs+aV9GruhOs+QV6KXDf2M7VLEG2yTFd?=
 =?us-ascii?Q?VoaXujv/eJvsYzEgq/H0h0lPYNIOWGxmx1Vqo9fsh+tFN+CzkLJH/JyFIy5q?=
 =?us-ascii?Q?BH9Iy74OLaHxGj15zRBJZ3mKgfEV7P4SOtQP+CPhpZ6BeQkMOZhKHGRWYGMv?=
 =?us-ascii?Q?40bXOtQ4LfH9BfToxklM3qXgb0Mgwxb1vXyIj3A/tDjhA7IK4nyjFoOYidC0?=
 =?us-ascii?Q?Uk2aBkHMcRgTBDvvKiz3vhtnzTM/LfeGtkPHrvTmEBskxT7JqcHMxwc402cl?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RZq7iVtmMIrAiE3pBZqP6s7pHd/d2mW3+8psZdMMZEBOla9KmoG/7kDKZ5T+gfsn3BuCli4uf3R0WWRDC3vZj0Q+xWAy2XUiM4argEtGaj/ZnnkRgC9YCqVLb4ykf/KzkC5U8wM/gldPKdx0YfsdVB+jy5KPxjYNM1HhdZvitGkn6ZlQuSgMN4LcP10BaDqQQkQ8ldcv0WVMK17byBIbZgUvw/FZ9cuVhfpBtIPT9SNPplIVsyDgbZArKkJu6bHLlNVTrEEpVDGNPZInXeUUpKEB2xKZmvD35qOlfc9ji+5Me9TVDX1hKS3m30vLgtTIHlJ0ZQgbnDnCqGOyebOyULvOwxY7SzDWR9h4SjbqcVUxyCdPImmSZ1NGg4x2+Wvkb4hOFuMT6QW1J0qGJx1+ikabH3UEVYZMjQSc3QBdv+BExCaM+0t2ZztQzTgaf8odEeosETBjS8RlRo0nnUSPYwQxIBfnW68HUvOpUjU6+d6QjP2jbc0SMPyihG7PWAiMXbYylqa96QI6/38CXZEawUT2Qndx/JSp3kbqdRceJaaGn9RAfBCcucikLhizOnmxllk0YoF/Bzi1bEsYdp4RyLk+2AKZKPc4sC8QFbSi+wEdD9iVeuVTE0K8qpm1yd7Q2BQ48ViW4qnc5L37SIpEBOs7ycvoNddakZCTdX96510fcl8ijRVsm0lfbxqvDzQIcOjGXuBmj1MreG0GL+P7Fb94AEV6OAU8+c1m9pz57w+cgcJc2Ye2/X5aUoqTdojAaAHaxYXhQX6tG3bikEBoRklqp0HyYplh2w2aRJBbeTcd684L0mYKMNBGBYfr1qOc9e5uHGkGUaUfpCiMEHklE1BoCrgC+ZoZWXaAmSJUsb1VeUdt1Ykp7/zYr7wsgOcy
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d69d48-87c8-45bf-4ebc-08db20ee4c4b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:25.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtZfMBgG/+fxgs8MEYy28oxMuCWBZzSyVtQYS1jLSkPa5lKrvvMZJR5eZ4PfwQswA3GFJXrFwxwSuUqPNpCcP+EiobkvrpvJnlFtyYiKsJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: -gv4vnasYUF-2bLjfXUb2t-Rv1swdyjn
X-Proofpoint-ORIG-GUID: -gv4vnasYUF-2bLjfXUb2t-Rv1swdyjn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves the check in lio_queue_status to new helper so other code can
use it to check for commands that were failed by lio core or iscsit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

---
 drivers/target/iscsi/iscsi_target_configfs.c | 3 +--
 include/target/iscsi/iscsi_target_core.h     | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..82c1d335c369 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1411,9 +1411,8 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 
 	cmd->i_state = ISTATE_SEND_STATUS;
 
-	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+	if (iscsit_cmd_failed(cmd))
 		return iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
-	}
 	return conn->conn_transport->iscsit_queue_status(conn, cmd);
 }
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 229118156a1f..938dee8b7a51 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -913,6 +913,11 @@ static inline u32 session_get_next_ttt(struct iscsit_session *session)
 	return ttt;
 }
 
+static inline bool iscsit_cmd_failed(struct iscsit_cmd *cmd)
+{
+	return cmd->se_cmd.scsi_status || cmd->sense_reason;
+}
+
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt(struct iscsit_conn *, itt_t);
 
 extern void iscsit_thread_check_cpumask(struct iscsit_conn *conn,
-- 
2.31.1

