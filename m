Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E7DC6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCIWeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCIWds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFB3F31F7;
        Thu,  9 Mar 2023 14:33:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwtCn018103;
        Thu, 9 Mar 2023 22:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TFJzELSchRUQEtTBbwjLGxNY4rLxL7TqMFkQgj20msc=;
 b=lZtyqaC1y0GVB6ofHxphazjOw4hIsYRyLzxvDOqrpJ72sQ0byDLvdRDV1pwqfkYrvL31
 V6cNqPi4ZiW6aHwku9eL/m5Od0OOw6HY94aTKx3l6WYp+b8eay1qisoGvht1NFIaIEz1
 /zNKas3JdeAvwmBKlSBOD5Kw0OJkcKb+caEMmRCrOEECXHArv57F/9qmu8rM3IWdqMPj
 VcEj/580YNsk3wEc0vqloHK7C53Bl1uRAhIDV37tOQAu0W+8UMXwKV6mlg9ncNRNu/y2
 +tLVfeDz0uaj6Apt4va8zuHzfvNGygFAupowYLU5uJ6q1E5AWXV+wnI9Skyv7S2RJPKy 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168v15k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86L007359;
        Thu, 9 Mar 2023 22:33:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTgpQeu6Xcv4xUBN3xg0/7CynJxz9nWuMgNtANNzd0yb2j8SZwEkWBzCd07uE1bCC2D1YPYss00nfQgAjgoLXhcrR/PK9c6sHrVcm1BqaVS3KjkEYKZOKV1KM/CtwBDJlM5ZVgB46jB/SbQoSJ8Ed66WG+3tn5c0kQhv08h/FMO07oxb6Q/QJA3XY5K19EH7sRs9K/br0jX6xZ/e2deNak16kI+jcPeGXr+yfsiYLSkSmhfWnw5JRz+h9uiaO2zGaf8WT+ns0zBjkmly4qPkClNElFd7FQDBomVUvrBd3IazBYz7Vyh4fKU+SSyB+29f3+3BgDM8VmxDoEbNjFgysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFJzELSchRUQEtTBbwjLGxNY4rLxL7TqMFkQgj20msc=;
 b=RVS6o7XwU7F+Wf3+visRMb+/ALdSTcTRZROKVQywumB8SpL775P+LtcOXLrTnVZajR6eal67C/T4BoS2ld0ej6LV1p9pgB9O/WyNS10AGM+OfEb2FbksAewswOD9x+mVGcpwXz3L8lzfifhOdvlyV2Nk8pzN+UkEDs7609q+kG66SIwxqiE/KyTYWEJwdIvKzDgXVocChXmARkJzr81p7+GokaYIhQ6+UkkKtAbyjuuns+sA/P7+KEts95PtE1wsOe4/uPoJN/A0Sbx7wLrQ/3FlJ4axaym2tU2OwgE4GbJCmhDP3jzDw/2zmlpRZ3NthJsHo3o6PvGivpA4JS86hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFJzELSchRUQEtTBbwjLGxNY4rLxL7TqMFkQgj20msc=;
 b=IkgS7EdmLP/uemYluJgPfGWE8rjrFdr3cFCbYWp/7hLyrfKi+wrem9kcczvFcgeRmZYxRDR0LeeTV316x0233daqmXClQoafRfZ3jGS8FcL9OAaiQ6Q7vtZPME4+3+OfxMd8XJf/YqoiJk3Y4XYMlQ0evf3EUmyKa7LIO4Tp4UI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/18] scsi: target: iscsit: Cleanup isert commands at conn closure
Date:   Thu,  9 Mar 2023 16:33:03 -0600
Message-Id: <20230309223312.94595-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:5:100::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa19ba4-96f9-46fc-c75d-08db20ee4d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VE5SQzL+WKtXuiHCHWtLaCcwuFr5pXU6qp3TABPstbGKzj1daF3LwxpA8N/VYq5OHbKHw28WaqkK3fE2UdQ97uaXpZWLF1Dv6XY4WP9RNupwJ8u2r+ucFs83+Av4Kh/FhJ+qrYZ6MxHzszLYlosERvI8SoPo0aSBALItUC4eel7DnYm8j4puAPoc35FpJ2I7UfuKjs5mMwtqH+5ww5nJk1smULj+IUi1z3yOZi3W7Mx+A9B+BvDl0zIuvuIMaSEi9yeYYoHBXWoSIHUS825tduNJ+7r/zdxpn6fXt6js9AIPaWJYknuMgpGGdq9xSVvzpDd4YA4C/+0aKkWz6x+v92RrBW0CKCXaqJdkt8mtXlVpkoALJUEBav1Ggs5wlmIfGYjHGTZah+os+GkHWbQAxaXScgr10/8nH99f4tjp81ZpconldkL68LUHfneif6HfAjvkV22orSeib+FRghwOJ89pP47Lpcq6OUbdhUTSoq+V0Tye3L/lva27f69E7X0Erm1AsSPkE/QmhE2QNiFJ9snfUC0vLSHEPKqZmwZp+c0gwJwrIJHE4nh3vYIC/V6jlASN44eY5cWHxBqV1IAowhAxXOfDDFvjpNfrDQirkGjyWolGTMAJ/DuQI7/dLdLoFyhE3CtPRBAI+TBWuR4vwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wQPlj+UYc9t/CilarTsOpQBT//u4UEtcjbI/AlAAx4cL/pe/MxfSjvI2uCkL?=
 =?us-ascii?Q?gXyMObIGc8yGNEJdJW9aS6V1X70ZI+y6Ha1hkKwQcf+yvN7HRoIO0tdsALZR?=
 =?us-ascii?Q?e01pGO3wLeIhyFL6y9JVpumW1OK37fa8PYg514mx9/NqjxF//jgC/vtGfLqI?=
 =?us-ascii?Q?qF2wryciXA7zbBcu0g0YWByE9v0oFYUYg2bOruT/s01QRYIh/FToVjiZQUgo?=
 =?us-ascii?Q?k3F/81ySbPsv1gSrFZ8u1cYavQ7jPTZ3tKThQsI//ast9dElCePVXPoylZFf?=
 =?us-ascii?Q?qIYBt1vmyEIypZ9gsuX772UytGnRE7ZFAjm3NwoclCi1WfnFbF4eWoF/vAjU?=
 =?us-ascii?Q?lP+ORrLQd6PYx1xtzYSLfuHLFltZ2qfs0dfeJdWp8l6QLK8Dil7lP0lXL7jq?=
 =?us-ascii?Q?X/9oLYetM/8y+lQu0BN+KZwqAcR+CAfjy5UFk0IHD05xWHrwhH6sdV8zH4BO?=
 =?us-ascii?Q?XFBV3ivF8QxmyyIZR8QtnpQEoT+rT/kP/qXjCwNURLucgsQmjpzj/iSOsJ+V?=
 =?us-ascii?Q?avDQIy8EYcPsqMYG6uyo25+/LF9fbfq4TQOnkRQagq3Wa7EldkY3IgD0hvXp?=
 =?us-ascii?Q?OddBhYhPIyhtGy7maUdgL+kt4TkrMFJvOR0HNRQkY0gXA5KqgvS88eBoslj0?=
 =?us-ascii?Q?MqtCabghWnCQBQRYIVNLWwDJ8lQg7VKfHg2y7Fz84aGPPU6JVmpHRoy0s7h4?=
 =?us-ascii?Q?3M5BTNfyk7ziH/AVx70bBLtSDA8pmR7AzCsrwaRIDxe7uoxzqZawLBmB8o41?=
 =?us-ascii?Q?0RS0FvUSjzBBGSFfzJ3fUBSn/7Q9wc2fBIzniaRebcsI4AKdPbEzGtfvS4nY?=
 =?us-ascii?Q?3TA/Aqwc31JzNlQw9SQDJdnKJ9MdBVzOMxPtYI92XpKsi2+xPf1+Gkgv7iZ7?=
 =?us-ascii?Q?XDtn3RLhbeOgQM4hy6efinJZo7jT3OLj/itYJwwez483DBu2LW4zBk/Zrryt?=
 =?us-ascii?Q?8fOFi2CGDe/5w4ttLQEb66EqkmCRrbC3FIrIAuA8aoOEodWItFok9PPkzxJZ?=
 =?us-ascii?Q?XonVr4i2+CdDm6SJIzh43B57uyPJERpanerffAXokoJwptiEpZmaRppdUgVL?=
 =?us-ascii?Q?Mo/0W61Hhmg7cJqXgiSiJGjBtwFqS/+RStuaKUwho1JkRQnJJRRslft/mFNI?=
 =?us-ascii?Q?33auV++u/2LG2vTWi0lNLcFCdfd3N6l/T+I0mdDo55ckvZZxv+iS62cbeI85?=
 =?us-ascii?Q?T0FF3JNZgj3wXUGmySb4hTT3YO99LRfLYZcWfCDN8z7ZUWe19dRzEVQSzCJC?=
 =?us-ascii?Q?ZOkWIRfQB8pDmOASW1E6EUcHyK6JDnYC2oNi/ibIekEHJiBFdBoSdWuGBxmk?=
 =?us-ascii?Q?es/0uu3T3L1+iqLR7bXUvqtmuVs8l5XKQ+ERByhunQf1mW3T0fACkRZQvINC?=
 =?us-ascii?Q?X1iRT2E73Oz/9cQRh0e2JmwxoC6ywIvonLNvUBaumvDuqKMFp8ZnK/fRNNw+?=
 =?us-ascii?Q?zE3urpLJ4HNqVh+JF73KeBDLEWQlQUqyGS+y60rxtkUnDbq05TXU1KqDxvn8?=
 =?us-ascii?Q?bnOmRj/8pb0ZsXJRaUjziasC5NdX04JhDtJpZL7D7XU0L1CgAWsXWEl2Mkrh?=
 =?us-ascii?Q?ZwvGjrcI5Y5sZMH7/rnWRk54kYLUFKGwL3ND8xLT9vDCEIipzUF+p4i1+8UN?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xQMzsoMrsdzjdAHuQMM8mut9Tcqxh0nMSOirobxGnwbx+op42AKKtuxwWFpfm5NwW3Giizrrwq17zOeXQlZSlheGIZY6sGaK6IvBItZXG9wsfG+sZHadywyuudCyHq4Wat/8mQOh8ZQwcF2YI581Gf0v+Fz3PtKCMora0Si6VBQ2bB/V8u1M9vgf01/3cbT0piG6gObVH5tv1ERPDVDp3CXS8C8v7RqeHNpxz70D00SowBWzQvADrWTl+ukj2iiKoGOVUNL7G2oyX/Npkg4YGIM8xot8tcbIUJGWZ9xaop8G0zcLqEgTYRKmNc9yG0+RclNrTmaAgHjTx3SgRsMhS+Kkv/SMCtxBf63kMvyjlHnRnh+CLI/Kgf3Xo4z1jLI6UfVw7E3i3SJbxeBVtzj22Pb8JQdnF/6/nW+3Gg8kraF0v2IPzWixYayvMYewwnxXIKswPh037HGGGPKOsG9MzF2q6+pS88SrgYVi5qzJc03Xa/fvl6nL/C2USL7tMSCF0o+xlC/17iViXJsTB/SapynNXoONCBkD/Yu80P9fl7AcH5aEey5InQlB0+Efc/dZzjVMBDqYL89TJ4QOWWWN+tgaiIOBoRaFJCfqsJ6OXBBEf5d2HghhoIo/YMYO2fci3NpBvDaLJcciANVsscs1oYUlHx6rv6D40VUDexg1ipMu5Trg9pxZs84IS3HOpe+D1UPikBAj/j8ngTWmUapn4k940hy15/78zt8SwkahoyT8tZi0hlFXrv3AK1vODIHBGjkKAUKCDOMNK73N3MIS6fukSlfC2KYex78Wwh+c3z/DgoDw1MjPMEDmZmyZawepbv/R634SB8ekSWlaFds3Ej2JXDfNn+nRzbp2EzYaPIneDrGt70SC20BrT3sAoL/X
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa19ba4-96f9-46fc-c75d-08db20ee4d4c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:27.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZ9z3dNU7DXYTiPt8CbXIJsFyQ1t/fo0e6VIlDUTBOYA/RpheYxfdXBCM2VLN42NLYFgu4rjgwY8YsRRyHtH7t2vnpTa8hUIVPLoNEg4tdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: hz9FeliLDVP1DDRxliR-16srGA8SJ7DV
X-Proofpoint-ORIG-GUID: hz9FeliLDVP1DDRxliR-16srGA8SJ7DV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, isert does target_wait_for_cmds before iscsit calls
iscsit_release_commands_from_conn because we can race where LIO core
calls into isert when it wants to cleanup the connection. The wait
prevents isert from freeing the connection while trying to post responses
but it can result in a hang during connection closure if there are se_cmds
on the iscsit response queue, because when isert calls
target_wait_for_cmds the tx thread is stopped or we are running the wait
from it.

For example this is hit when a command times out on the initiator,  the
initiator sends an ABORT, then the connection is closed. When the command
completes it will be placed on the response queue if TAS is set, and the
ABORT response will be placed on the response queue. So at the very
least we will hang waiting on the last put on the ABORT's se_cmd which
will never happen.

This patch adds support to iscsit so it can now handle isert and iscsit
running commands during connection closure so we can have a common place
for the code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c      | 33 ++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_util.c |  8 +++++-
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83b007141229..2e9c0d7b36a9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4230,6 +4230,15 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
+			} else if (conn->sess->sess_ops->RDMAExtensions &&
+				   (se_cmd->transport_state & CMD_T_COMPLETE) &&
+				   !iscsit_cmd_failed(cmd)) {
+				/*
+				 * isert is still handling these cmds so wait in
+				 * target_wait_for_cmds.
+				 */
+				list_move_tail(&cmd->i_conn_node,
+					       &conn->conn_cmd_list);
 			} else {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
@@ -4242,19 +4251,27 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
+		/*
+		 * Free cmds that:
+		 * 1. we have not got acks for.
+		 * 2. are (or will be when the backend completes them) stuck
+		 * on the response/immediate queue (failed cmds, TMRs, iscsi
+		 * reqs).
+		 * 3. completed ok on the backend, but hit the CMD_T_FABRIC_STOP
+		 * or CMD_T_STOP checks.
+		 */
 		iscsit_free_cmd(cmd, true);
-
 	}
 
 	/*
-	 * Wait on commands that were cleaned up via the aborted_task path.
-	 * LLDs that implement iscsit_wait_conn will already have waited for
-	 * commands.
+	 * We need to wait:
+	 * 1. for commands that are being cleaned up via the aborted_task path.
+	 * 2. for isert we need to wait for iscsit_queue_status calls
+	 * that posted a response after the ib_drain_qp call returned but
+	 * have not yet called isert_send_done.
 	 */
-	if (!conn->conn_transport->iscsit_wait_conn) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
+	target_stop_cmd_counter(conn->cmd_cnt);
+	target_wait_for_cmds(conn->cmd_cnt);
 }
 
 static void iscsit_stop_timers_for_cmds(
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..b0d7d6c73a1c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -753,7 +753,13 @@ void iscsit_free_cmd(struct iscsit_cmd *cmd, bool shutdown)
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
 		if (!rc && shutdown && se_cmd->se_sess) {
-			__iscsit_free_cmd(cmd, shutdown);
+			struct iscsit_conn *conn = cmd->conn;
+			/*
+			 * The command wasn't aborted via ABORT_TASK but didn't
+			 * reach the driver so allow it to cleanup resources
+			 * now.
+			 */
+			conn->conn_transport->iscsit_aborted_task(conn, cmd);
 			target_put_sess_cmd(se_cmd);
 		}
 	} else {
-- 
2.31.1

