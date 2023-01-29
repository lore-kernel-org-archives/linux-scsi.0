Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7855FC61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbjA2XpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjA2XpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB1218B13;
        Sun, 29 Jan 2023 15:45:05 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMkTq9025111;
        Sun, 29 Jan 2023 23:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=j4euk1gcVE9ECbI1zFtyWPtER0ZZeTvaCA+w2iILEP0=;
 b=WUHGw1WtNUijOFUwdOc9CBRcME+upprifAy91CFDGl/S6GrnOgfP+SNaSNzZgTKeGV2p
 IZ4nnTfi4GsIXyUH7KP2bI8/gTJvQcoPgaaspCbQlDdhebvAL9zwtwsoWm9Z7DXpaxAl
 gwR3oK71hWCfLjGn2GPFCvTNKQFyLyXAXodwp+BGzeM58pfqVoMuJ4ZqdC2Ge9P1RKdT
 Inw7zENk7L4RvKnVE1tnVqAYkwiEBc2liue2KJX57PyTNE6gJT3N9YdbParLVJNT2Gat
 VWl9gII5zX/hHmq0EnD1fpQjtFibFJGVuqD2pnsjsmuvS1DnxnXBe967JWvM7WJZq5lP gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvr8hry0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIZL1P019074;
        Sun, 29 Jan 2023 23:44:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3c9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCq51CZ0DFNjI7cob0gNIlKVvPG+1Q/uxORGDuGSzTP39ud/tQTh52+VFcCYJnhB62zB14heMo9Ovh8A6amKciNM5hDstEcWSuojmiihFjZBrK/8EwKfCoPvR0hF7hZ42vlxmWCBq/KOX8OFkrniKCv8AmkxyX9zSXe8daWM1rSQhDYe1Yxh4sPt0q7UXLBnaByfy0oUG2W8Ts/MaEzfL9tT3S2HKt1m1Fe9VEiJqh6EdErt+YAVhnQ05sgVQcJr4ldkx9MCcFKBCCkuiq88qabe+SxtmCVtWm4YMpXSrSa/zn+ZDoII2RIMA2fg+Uy26ZclOa+nWo/tGXNCmNNUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4euk1gcVE9ECbI1zFtyWPtER0ZZeTvaCA+w2iILEP0=;
 b=OrLdMXISOzC6RI9SKc0QyKcnJWLP8GeL/D7lzxN4qDUBf2gp4YkiMntNeCXhL+oWPNi+rQrzpTOqAk9AQhDBOg1P0o5+mpLoGb7m4AJf6bL11nkXt0lmHAjzw9nzpDJScBuY/EA2U0MDu4cuQk6RJ0lvTrgYhTqyVrWoWbnnErsmyffQk0HtwVOLaN+YxjcfIefGBy15u3Ra6h+gzRulfbhXobYtO2oGI8NJpbOa+sySRc0TF6ZyLsUCZ87fzMVlYIsVFG+5116yKv1ypWw+PQgII0Bt9GOoknLtXvxzUzWC0CckuaZQ4niPLkF+WrgwmEVUQFDOPHeifSvVYo68Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4euk1gcVE9ECbI1zFtyWPtER0ZZeTvaCA+w2iILEP0=;
 b=I0T5ZMbjfTfVoDmGaUXewMhfs5iFzs27bdmtfSh+UsCn64aZ2zAhkveY3tsG0s1KEzT7SzjFYNAsn94/PviHHPvRg0dtPQogIxabUmpYHXruFxvE/jFiZgVpgpoFaL43Vc/Mnfm09QZqaXurxPM2vhsI3xfNWONLWGgKyjm1sYg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/14] scsi: target: iscsit/isert: Alloc per conn cmd counter
Date:   Sun, 29 Jan 2023 17:44:31 -0600
Message-Id: <20230129234441.116310-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:8:57::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: e901d4cc-8afb-4768-f908-08db0252cfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTDLiXRvSdC12xCY8Q78b26r5/x+eMuNT+4DvqSiUZnbccrWG7if6xxlwPklGkJLm0ZGsXTE6f8YmcXd7R9H5LPU/JDhAGKlXK7lQMmEGltX4FyA8EgCnpoNuXapDwzrig3jvbMpZOMxO9VWGRnzixRjSju4Otwf/60q85NW0KST9KjbfGWcsRKwX7X1K7Ovxbe1XimK0/3mXnV6W86SpZGgbMtqEOuXGx1RRr4kblIlbvzl0uqdIpgFh8Ki0+vnmCuX1v409PWIrq0UAziwwd/6ljytFeOl1YQ13bXS8yKsgLRctWgVb1yMmmmCduRE5rS1nnO5qgAfy3C1BApa7BDtMxn3D3ik+YDn4KV+m2Gt3VcQsBMJq1hfMfaf2bMsoTxAPLXPypytwHqHKIt5QExARWY2pcExLHW+fBBsATEZvkkTcE7KB2jA/OaWZOPsrt7O/sNofnbgghYNG6W29OjGoKYTdjbv7q6I6aFN7wR3d56Pqfou4dE8QMpTzCAEylbkZb9xm6//atKcOr+lGdXPirW5C8MVqUjhM9CGCZp7q4WTpjqr7VbLO3paIMqtIHSY7SZuum0qgRuHS+hzCzc734EelcvBtPTxH7v/jVLgu/WTMI8m48nVUp7bn+9UUpujFOGSKvSOL9ntPj9h5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZaliS1ta3tCCkGU2MVEpAQS0tG/YSrLoe9BVOuzZ4OlI6LcJ4ekeDz7Stxj?=
 =?us-ascii?Q?TFq0wsaGz6SA1Wvgj/rCrc2Jv7KGzZusu5vb7cuCLXCAqfLzAfCxjgW+PJ5P?=
 =?us-ascii?Q?cXVrD/9e/+Gd17TBF+3gnY1oVwR8DJWPQY/MyKmamgZirNr0s0FIOpjksebh?=
 =?us-ascii?Q?TrRNrdzkZMGgg7gjELyL1rP/ZNX96sMYVRXLsdAyywQ8mLL1aEbYZwfYkaEI?=
 =?us-ascii?Q?t5uHcfN+jqXxTTaKC/D+MnHewI2/aOacxIsCpnWvkZSUvg90TNsMAUTcAIsE?=
 =?us-ascii?Q?lTXpo+acZKWliWT4USaycAl3kAy5nfDpHQxMbIyDpq/1/OjrJHonmwiwtm4l?=
 =?us-ascii?Q?gHxDsEMFswsJ7GCTp5psmgn7+ohZq6JL+v57eoYIEJxxJJbJ8SZ4007Enuv0?=
 =?us-ascii?Q?3RGUPk/7c5RTRIO9TJtQ/nvSpMTATjY1xN6dsFUiY3oA+nPG3bzD5aNE1N9b?=
 =?us-ascii?Q?Wn2VSrql9Ae2/gBP4OR16jOehYak0ZsY+rygLVmIqenHsY0W83IewLE2+XaB?=
 =?us-ascii?Q?cTRCRW3en75B3Dyvw+QUwF7KRla1LS3ZcfTP8KyTtzwgzEzxbqdhpKQHrju2?=
 =?us-ascii?Q?mue0UCMIEaEDweynZDQU5RERRTob4Rr4tYT7lDXMi1vAichOYwx7vMPlbF8m?=
 =?us-ascii?Q?M7pGUiH9kDy+fkqoBdvw+S9+6rlx+tNQZ/v+y7w13gJcZPoDGjXJd9ex+0ll?=
 =?us-ascii?Q?bRwRtAeIpCUccEAZI8oRZVZbA9FW4+4dsWH+pqEXmn5aci2ZzhaPwO/IDS6U?=
 =?us-ascii?Q?g/wjtOGfUrOcU4aBDhl7MJy9n44+kczq5OKBKOVsJWP7+m1JMtyATDen7VHH?=
 =?us-ascii?Q?SWVtx6bQ11RDRIaGY1bLn737/PHU5L2hePwz0gcPJBUKiO+C7KVJgqRjJdXe?=
 =?us-ascii?Q?P/mrBrbpVrS7w3MzHKmq7FfCJ+KWuV6G+dTNRXx08JcL8P7GR6o9orXzhDhh?=
 =?us-ascii?Q?S4nz1SvIgQcAMT0UzVj/ug+u9ro92S7bZ6hRa8XoHwGZC+Aa0Q0GRQpfM45e?=
 =?us-ascii?Q?603AfUE0ZPwwtNL7lDjoWs0Hm1GlSCXkpj+H+jxJ4LxFoqa5/QnIXaU66KTR?=
 =?us-ascii?Q?ySOid7w4csUQs60HSBgPQrcOzYTRpjn68V5jbHJ708BSoOkp/R2wqDaObCrC?=
 =?us-ascii?Q?JgX83KSlspqX5dvDLyG+ms7b03AUpuJyWF2VH373Aot9uz5gpDuzvlFygttW?=
 =?us-ascii?Q?0lXR7k2Pk0/832j0vOJd/MrQkGg3Uh65oKW6F+2y7+/xeoA4TkdbIu7G0l4M?=
 =?us-ascii?Q?hkmqJLSAz3RDLdEEgAr5Z/r1a3qdhUpUdxBPae8ndgaxOkZocK6zMGmoAAFQ?=
 =?us-ascii?Q?+XKXcBHURrvpXt6uoPJWPvQylxZeBIfkLWxDR9tDONmS18ue2UP/wjq66Kmf?=
 =?us-ascii?Q?lxlSfugP/xdCmXwzvqkdRmqZGSzmgB6msy97qMwlAmfiVzYSHzZxcsAPedrM?=
 =?us-ascii?Q?3ENW6KCBKucM6KzAd2UpvpYnFXrbEcSoGNkVbaPuhMMWuKAjpjByYH7W0exg?=
 =?us-ascii?Q?H7Y869FxX4PBahPc9oeOedyYQK43JcfXdDqbQ1ZwATPgGCB1Z1tIa5ZjMRPe?=
 =?us-ascii?Q?urkYYANOAzYg54aYV1n0FN7GMvu5USRDcChGqbP+BLGGcngImcUnfpmr/J9L?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LVoQFsOAA0daa7KyT9DAfsUVIaaEtoKOPXZl4VMsqb0eCapjDrycIaflHdQHg6yWEjUGDPFRaazEC1r/eGJPFVr6vUnqFjNQxrq4SsM1t5u3xndAleW67oWoPl5BURafYztVN4TK7EV+zXZgfsb4cDbWewSKmHYXe5imRHl7y/EByUrbQot83cVglqUb3rB9cw/JrImEvKTj1omdnXPpI0ZgEalcz7uNAa1ya8dk6GS6wg8mAfWLSCejHVUPDUoU3nEv82PRR/iTVMTaEezCCSNp9Nf7BrSCc1hXpJZzXXh/rJdjmOeDayYoO15WpH1ojmShxp3Q8xfG/CJndGH2tts7RKq5p6XAFM+BnN6OaEMBK6oiKsBtZv8PqzqwfDuvWrbanwe32DXaQunXvOx93Se2AgUz/SmxnAY6W3qeEWLDe8k2TZ6+yNjNiatr0AXSMKLUdFQGTJ/gBY021+EfSgnMbBFU13XpBtalRHXKUlyA2SS+4aZwbcfM4pKlupXzADJrrT/rba7HZhEPQVvkyKng+OnGmIBeX6weJOftXZSlDF5apWQIaly96rloWBGRDkDATLcmYAfO7NXiOZtzz6UepfnIRdsmbhXrq9tRmfdfYE0RG5NBAojOdidscMPil5ituc35l/DbRuoLO2ItW0w3SWbjwyW7QNw2hJA7OvPrv9lrIRdg70x6NoxanaxTi3U7qKIse7pGFdm+/QhLeCAsFpN4D5BAELOGJl5w1z3gzD47CluXvWEqT+SForGwbLoffCUD0YNFiEfbUHJQOZ71y+B/o5eX28K0xQlkMTmN1Ew2oi6Yzrq7xGewwtgmygFJbtn9v2u/O3CMyUa8wQyhkwIHGpfv7q5ZWEKp56pH83CXgCK28i2UPax99Z4L
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e901d4cc-8afb-4768-f908-08db0252cfcc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:50.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lP6992greWw1rCecEcVH0WxSHfiYX4ph7RWmPPT6Hw2Vjgs+ez83bwa9XPhFGBV5yDGIuA6zO3H5HHgGd8wiVsFgWel59SQz65kAq9uMKJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: wt5NmwS3NRijG8UrhwgM7Gvrfiwwa9sS
X-Proofpoint-ORIG-GUID: wt5NmwS3NRijG8UrhwgM7Gvrfiwwa9sS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has iscsit allocate a per conn cmd counter and converts iscsit/isert
to use it instead of the per session one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c   |  4 ++--
 drivers/target/iscsi/iscsi_target.c       |  4 ++--
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++----------
 drivers/target/target_core_transport.c    |  9 ++++++---
 include/target/target_core_fabric.h       |  3 +++
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 75404885cf98..f290cd49698e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2506,8 +2506,8 @@ isert_wait4cmds(struct iscsit_conn *conn)
 	isert_info("iscsit_conn %p\n", conn);
 
 	if (conn->sess) {
-		target_stop_session(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
 	}
 }
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 87927a36f90d..11115c207844 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1193,7 +1193,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			  cmd->data_direction, sam_task_attr,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2057,7 +2057,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
 			  scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8ab6c0107d89..274bdd7845ca 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,18 +324,8 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
-	/*
-	 * This is temp for iser. It will be moved to per conn in later
-	 * patches for iscsi.
-	 */
-	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!sess->se_sess->cmd_cnt)
-		goto free_se_sess;
-
 	return 0;
 
-free_se_sess:
-	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
@@ -1157,8 +1147,14 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 		goto free_conn_cpumask;
 	}
 
+	conn->cmd_cnt = target_alloc_cmd_counter();
+	if (!conn->cmd_cnt)
+		goto free_conn_allowed_cpumask;
+
 	return conn;
 
+free_conn_allowed_cpumask:
+	free_cpumask_var(conn->allowed_cpumask);
 free_conn_cpumask:
 	free_cpumask_var(conn->conn_cpumask);
 free_conn_ops:
@@ -1172,6 +1168,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 void iscsit_free_conn(struct iscsit_conn *conn)
 {
+	target_free_cmd_counter(conn->cmd_cnt);
 	free_cpumask_var(conn->allowed_cpumask);
 	free_cpumask_var(conn->conn_cpumask);
 	kfree(conn->conn_ops);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c395606ab1a9..86adff2a86ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -254,7 +254,7 @@ struct target_cmd_counter *target_alloc_cmd_counter(void)
 }
 EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
-static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	/*
 	 * Drivers like loop do not call target_stop_session during session
@@ -265,6 +265,7 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
 }
+EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
 /**
  * transport_init_session - initialize a session object
@@ -3170,13 +3171,14 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
  * target_stop_cmd_counter - Stop new IO from being added to the counter.
  * @cmd_cnt: counter to stop
  */
-static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	pr_debug("Stopping command counter.\n");
 	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
 		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
 					    target_stop_cmd_counter_confirm);
 }
+EXPORT_SYMBOL_GPL(target_stop_cmd_counter);
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
@@ -3192,7 +3194,7 @@ EXPORT_SYMBOL(target_stop_session);
  * target_wait_for_cmds - Wait for outstanding cmds.
  * @cmd_cnt: counter to wait for active I/O for.
  */
-static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
@@ -3208,6 +3210,7 @@ static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+EXPORT_SYMBOL_GPL(target_wait_for_cmds);
 
 /**
  * target_wait_for_sess_cmds - Wait for outstanding commands
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d507e7885f17..b188b1e90e1e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,10 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt);
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt);
 struct target_cmd_counter *target_alloc_cmd_counter(void);
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
 
 void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
-- 
2.25.1

