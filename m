Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AC7C74A5B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjCIWeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjCIWeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C5EF6925;
        Thu,  9 Mar 2023 14:33:49 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx525004314;
        Thu, 9 Mar 2023 22:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BgfAWHdwN6LbnYK9qhMYYGPd1UoSr02+IYqU5zXxYWc=;
 b=DtyFmrzZv3rMBJ1GBHc2eMYRtEloK+fWzuTgDamW3n3/oBeNJub/8gLfneUjd80aAhTt
 e00COmoPejx9WIw+N0ovSg75Bj8LBI9oHN6WCQxE4Lyrmnoh5gj4z9PbBttnNLgCvjdJ
 l8HBc/9aBQLfErcNtBKd6Aj7V+zyXBErbGrgNbfLxYacVVRRgZrcvFfzEU6WVjlOMtWQ
 qSPazMtfV7/6bHEy3YnLdv+Y4+Ohq/Ut8iyw7z5aVdlfQWm+XZ0YTwBP+bewfHSMdckN
 ewVtuMFz1iyPxoz/GL3qIhOIQRwrT0sc9zhPlBmpWJXGCvtQQdsu3GMAkBEFAbLeHZPl Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn98bpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Lf5B8020892;
        Thu, 9 Mar 2023 22:33:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fua4rk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nG6WXauqIKtcRM5QsrxjASuzbEYPDMURSeK3PsJoz3teNlQctJ8avnGLVnGYY34PbIRF4WJolwVWciJsGUj6jAfRkvcfZy2Ylm7n7lBX6au5pgvb8hx5pbH4OzL3oY9sS/3mBZTvnEYsurkO+PdQU/WA/iUT7RRUWfEV1JOQqfpL/KGgCBgNSScQJqKCCciDCclGSbBGBt5T1P55f3F1maSJDpXfS8jy2nDYNwt6cBA9LB/uWesfNQ9Pu9atgRiGen4fUBenH9nPvRKkb+UigPTidkL0x32RbQHJ7HxBwaMGawIQ+jeSZDK58rHmD2RRLWd4tHOCc4SxB2tdq4WEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgfAWHdwN6LbnYK9qhMYYGPd1UoSr02+IYqU5zXxYWc=;
 b=FXLQl8F0/ovwV8Khf7+IguD5La+1QyAXWNRKRDosiy1bGviuo9EQ7X+rv8n3qOg7ONwJrwn3ls1VZIc1gF8wT13HY9HC7me6wOub6MHaTk2J5HtMvzmGQuQm2r/3J404Nz/rKQ1lNCS/n6uOsyG3flM7G/+0Y8zzNS0IeIm0xb/FyG5RxGU2DuO2DH1xidE+Ag6ayb1vYZMMjUj8CG1q58u0jOR313R6pMz+q7S5MV3dgrl/C6si8ELag89hA58EbXY2suZd1hKkQL5/hAP1l3GytiapHC7iAW2vpo1DYpGqxwkWdmglKNLP5JrI7llPpvKeohtMXEvbdVYCCTjLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgfAWHdwN6LbnYK9qhMYYGPd1UoSr02+IYqU5zXxYWc=;
 b=xbnJG5jchoEiKy4bj8KFSbZnyBc/UDg+qzxcn7iZOiuoV372q1jqAKqMA3KGVw6uKl9ao4XMd6/P+nIBuYKmI84+TrlwhC4l3KriJ7Hu+pN82xTC57eglaj0mgRgCqujp5Dn/Fluw6uz59D1X9WaX+Zql5s9ZJHT5vGgSuXMboM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 22:33:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/18] scsi: target: iscsit: Fix TAS handling during conn cleanup
Date:   Thu,  9 Mar 2023 16:33:09 -0600
Message-Id: <20230309223312.94595-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:5:40::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b5fbe46-3df2-4d0e-a39a-08db20ee52d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KzcsFdRvcD3GhlYwkrcb6ryUfUfBnXvkRZGHhAXPBMYMF2C++42fbBdCqxjy5r2Lm32SLbss1BxWNQj+Yi1/eWXL/36rPOKYU1CqBOn9+3Syf6k/K2w//mjxa/ZFc/QrOGizz/qavZXJOQTb2aaVdVPz2K0Q10WFpMtHDW2+E+m5ElMyFFL83tNo8wIBfjp8H4q7+83gWVkJCMT6RAurszWv4YcHufKM9WeS5QabIcfP2rUh00oO/hduZU1P2Zux2RpccaPFGo/nbP56jePU8mvSUsGcMUGLyCt3P6kZdUXO/IoDWDR+L498Ha9ZKZsgmjjsV3E2V9LRqL5HWE1j39tdmeXXd3XzstzkTO6ArNLXl9z5ClC0tg/gjja70fh2ZEYlC+H8dbwvDggoCGMcVLQy4jDMr9iry4ZRZGbt6+nRpgx1ak+EOoXqLjiQ1LqOot8T+7+ywPscgSfnq375tq+wWPGj5glDGMcnq0k0eMz7yodwx3ei4c4aGV6KIgC2VLQvARS+Wq9S6v28YHs12S5aD4+xVVW4QXgtOJaC928gbrCsCttp0rtn4YegIcrr6xvFHOSlv9Ecj9Rs7fLrXWbyc0YAKeswaBmkvoikeqlqH1hnJ04/vkJuj4srV7N3Whf/Sl6cAsbHyW5r/gf5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(36756003)(478600001)(316002)(38100700002)(6486002)(2616005)(107886003)(6506007)(1076003)(6666004)(6512007)(186003)(26005)(5660300002)(66556008)(66946007)(8676002)(2906002)(41300700001)(66476007)(8936002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WEvh4iWw6jSc2wwHDYoXfyCCOiX93OyFOYBTheHnhMxZW4QnHrERA8WXOo3A?=
 =?us-ascii?Q?PnRIMUFxdRfPVDHb6LxrSw4spDWWIBDyHd99VMzj3RUlfv10zziuYuK6xr6+?=
 =?us-ascii?Q?P0mfRo0JKuQQf031aqcGzwsAUFq6L1rYfffKsElM/se1XcnrCzeMMIHucMrE?=
 =?us-ascii?Q?fHaTthQozdQN6dVZFXFeZuurD3F9c3T0ohJbN0i3DZC1U7lWh5Z8PvXol5y+?=
 =?us-ascii?Q?7DtcSuh2iljWA6lWhnSEG9ybbCRQATjogjcNy97pMoT2fnfSJdVWo6SyXJmQ?=
 =?us-ascii?Q?4zruPctjlV9Hnk7cDeVUwbfBA4udUL5XzF9u18yL2ihQjHAHXFjp8cA9DGL0?=
 =?us-ascii?Q?8rWSaYMJTOPFZpenpOB0tuneTGDBU4UosrGqouaKeZzTKwFquDqi/57HDR5L?=
 =?us-ascii?Q?SfndmJhyFjw1neNNyc79TSIk7N8B0qAb+HuogFYqC53RoiPWOS5PhhTT4BHh?=
 =?us-ascii?Q?/W+skj4oBtKzxxDt4HJv/x3u3aDoidjtLODudbQa655KaYb6p6/ULqHkPlit?=
 =?us-ascii?Q?Op1RLfAVN7I6YJIIF0o1auaZeM5LbQPgfYwTPIdRRW9wE3mO/mHd2gh304gh?=
 =?us-ascii?Q?MPU7eEz5Ue8v1rOspngGCFd3lvqQWPS8/d4z1+EcsTu5RFf/OczlI76dxawE?=
 =?us-ascii?Q?EfE4FQG+A8f6nDltoHBe60JSgvcGSvJjaZ3RCEu8Z+MbrUrXcSBY+BCdsM8g?=
 =?us-ascii?Q?M63keWpJTsC+IGYLtMWajUCwyo3w2ZU8mWEn5y+3zdCAyRzWEdq61SkyqjLr?=
 =?us-ascii?Q?CH/WFkmbdS7DUyXoFXpzWwACcuLjC8yHK/a88Ola433Yw6oZatro/BUGiMUF?=
 =?us-ascii?Q?+01OJ7EiYdtt0jeaHurcUsBm+WAWtbCW0WhR58YHWyvIBZEH9c0OXTDMGAee?=
 =?us-ascii?Q?dHGqiiFN6cdJQOoP7xVkYxkGlN+tgtRuz7wEHVQjCo0htKn/L9NMvB/8Wt4/?=
 =?us-ascii?Q?UpDnegOpXCnGkiIMc1kLr7/nJPhgmXGw1SDU4gy2Uz1yMLZTS0Ic5cn8gFD5?=
 =?us-ascii?Q?4/BJLpgIBK6khILzRZY8Dug2e4kBZda2BB+PSNU6c0YlOMw0QcBXKfnIO+4h?=
 =?us-ascii?Q?1AbsbQ6HfQuKSqA3uyrcWj/pXGbqFHhnIEYL0qM7Y6zSdBTO++1gWqZ2ImSM?=
 =?us-ascii?Q?UMnxSwg9AHVjAMyiYnIOczG0OvuuxF1nIbwkbhPl9gWyMH4nD+nn7bNoZcuL?=
 =?us-ascii?Q?RbDxCdigQoT577Q8mrR2J+bemosgNF1QMjNY/Qp/ZhJI24mfUYB3PQMywZbP?=
 =?us-ascii?Q?T2NpJWHh+uzQFcCrVVD0SBmUr3Zf7RTrfKOwH5guKOerZ6v5N34VNJ+myYl7?=
 =?us-ascii?Q?AY8GO2/eEp/qr+lN88evlPoNCSeFl8RyxbONeBfoeAGiLo/RxnpKwbj6Cr5I?=
 =?us-ascii?Q?u7+2T2WDigx1Jh3G47zPpN+O9LUPfLencB4cJvHcu4tPY7PkZlMB4BuXtrYa?=
 =?us-ascii?Q?WkqjS2ItlHre95hNcgrIjrFrOtlkfN4vXnjjJhmty69H2XzdgzyYGHl2CmIP?=
 =?us-ascii?Q?pnUP01630Zszza6hzzEYb6/I1MN0ZCGVMiw128aVjLjY7qUCEt0ymtZauDpB?=
 =?us-ascii?Q?huuIR9QToZ5AdRc0e9YoW1Cv8R1DKF61YuUNVsNXIxlxt/ITsfww4NzcGZDx?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zAq6fo4LUwvaqV5LAqpghGdoAlN8LNM/x2wgi8u1gPhiBG0Fmek6cGEA4X1TtrO6dwAzHCqHnECesYR4L7BH7Ub5bcv6jvmDrmWHdvg3qmv2aHiRl3OgPwzQmj791hlZ62Wce67581Xjy+Tg/LnLtWqO4jzi31BUpRMB1PHGmPzk23/TRwhZh46gLGKsTY9/DP8RNgkO9BH1FPSMxXjY+QmFQsItcr7NB+W1M6bu6c9doPjR37G/Ky4qEcFIYCNJe+0iEDLi8aC0RTs+Z9W61vWPuJQXwxKYLtgCA/UWbEYJ/5rfx2VXLzlb4Ma+hj+fdncSgGq+h0leoRJLVGXZYI6SjayCjLvfLegrLsvBs+oIMY9krPngIpLkbSTQv42NH6kvfT6PeKh+nxHYanRx2F1dhVqm3b0r3lojMXNfHJ3Qe+SDautI/A9FUwzkIAOrnBTZWzP8RgkiffIbOMXiNoZ4hbZo5F3s1br7XuPxGQRbvQjKtnwXF3jCl/E/xwW0/mEbW/G8e6fBrg6or6nyzldFzLAohsOkAUw4GYOu1q9eCQAHquDNziCVMKKh0v7Zj1/K2UHBDKAuiziN4pHuPFUNPa/fNe7qQ4smKep76L9YKRglI8jx49viNp1R5sO/3Hsl2t7LOegmIbh6NbDho/lJDEWJ0BwQ7NJZhKtibm5d3moNyytKW9ZlJfuMR7EyundYX4lqGbDbuD3kX0Oe7ejeXzWBHzB9gfN3ldyuoTRieMsEG+MVD5oQ6Q1B0iUQwMFKiYxlOAXvhUDIw/Tg+M+kSsTP0HBX4hKJZ/JsZ3/TMBlSAPVRlHBAIbzdmuxoLB4O7ds8pFFkli5bdpm0h6D9gaKLo1feV42YUT4Fko1JCe4eCww5TOUA2ytyHd+a
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5fbe46-3df2-4d0e-a39a-08db20ee52d9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:36.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwgJXSFrp/iVo4cG1uyLZQ7oss5OCC3ff85y4Y8w+cIoYx+fL1rjR931OQKoz2ClpUsaMzXOaIZABYrj/nfjwYGURQd6sewoHc8/xmLJPyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090180
X-Proofpoint-GUID: JuYcn5gZ5aB_4dKbir7hMgF8uS1DUGLx
X-Proofpoint-ORIG-GUID: JuYcn5gZ5aB_4dKbir7hMgF8uS1DUGLx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If CMD_T_TAS is set on the se_cmd we must call iscsit_free_cmd to do the
last put on the cmd and free it, because the connection is down and we
will not up sending the response and doing the put from the normal IO
path. This patch adds a check for CMD_T_TAS in
iscsit_release_commands_from_conn so we now detect this case and run
iscsit_free_cmd.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 52 ++++++++++++++++-------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cd9ef668a054..a64b984b9dca 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4220,30 +4220,36 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_list, i_conn_node) {
 		struct se_cmd *se_cmd = &cmd->se_cmd;
 
-		if (se_cmd->se_tfo != NULL) {
-			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
-				/*
-				 * LIO's abort path owns the cleanup for this,
-				 * so put it back on the list and let
-				 * aborted_task handle it.
-				 */
-				list_move_tail(&cmd->i_conn_node,
-					       &conn->conn_cmd_list);
-			} else if (conn->sess->sess_ops->RDMAExtensions &&
-				   (se_cmd->transport_state & CMD_T_COMPLETE) &&
-				   !iscsit_cmd_failed(cmd)) {
-				/*
-				 * isert is still handling these cmds so wait in
-				 * target_wait_for_cmds.
-				 */
+		if (!se_cmd->se_tfo)
+			continue;
+
+		spin_lock_irq(&se_cmd->t_state_lock);
+		if (se_cmd->transport_state & CMD_T_ABORTED) {
+			/*
+			 * If TAS is set, we complete it similar to a normal
+			 * cmd and will wait on and free it below. We don't
+			 * set any of the STOP bits, so we work like other
+			 * drivers and wait on the cmd's free_compl.
+			 *
+			 * If TAS is not set, then LIO's abort patch owns the
+			 * cleanup, so we put it back on the list and let
+			 * the aborted_task path handle it.
+			 */
+			if (!(se_cmd->transport_state & CMD_T_TAS))
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
-			} else {
-				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
-			}
-			spin_unlock_irq(&se_cmd->t_state_lock);
+		} else if (conn->sess->sess_ops->RDMAExtensions &&
+			   (se_cmd->transport_state & CMD_T_COMPLETE) &&
+			   !iscsit_cmd_failed(cmd)) {
+			/*
+			 * isert is still handling these cmds so wait in
+			 * target_wait_for_cmds.
+			 */
+			list_move_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
+		} else {
+			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 		}
+		spin_unlock_irq(&se_cmd->t_state_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
@@ -4256,7 +4262,7 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		 * 1. we have not got acks for.
 		 * 2. are (or will be when the backend completes them) stuck
 		 * on the response/immediate queue (failed cmds, TMRs, iscsi
-		 * reqs).
+		 * reqs, aborted cmds with TAS).
 		 * 3. completed ok on the backend, but hit the CMD_T_FABRIC_STOP
 		 * or CMD_T_STOP checks.
 		 */
@@ -4265,7 +4271,7 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 
 	/*
 	 * We need to wait:
-	 * 1. for commands that are being cleaned up via the aborted_task path.
+	 * 1. for commands that are being aborted with no TAS.
 	 * 2. for isert we need to wait for iscsit_queue_status calls
 	 * that posted a response after the ib_drain_qp call returned but
 	 * have not yet called isert_send_done.
-- 
2.31.1

