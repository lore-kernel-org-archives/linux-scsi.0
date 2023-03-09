Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFE1C6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCIWdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCIWdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80642B53DE;
        Thu,  9 Mar 2023 14:33:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx5ZT004320;
        Thu, 9 Mar 2023 22:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=jRXDMizH9GorGxs5urTZRMz0cM9aJjMkcX1z7Nd5SvIKErIL2RRtc2rZWj03YTi3bXEJ
 Tc3koazNttLzA4ySPmwIK/Mlz0GyvDKrwXHKisc7vFU1FXw0lmrt7Ggw82CRkBcvEgtn
 uigBfCAvIPfWB+K6P+y1NTdzNJcfJ7jXarh12TdBUHKXTf54Sga4r3FO3Llaob/VauBa
 dMdSEs8MNCh4PWT6odLsNYigHKTCxgZohNG7aKeVi2QuK3VS7YpV/R6jkaGN33z3eSOA
 QbnwT7mvL9dVceAo6415KD7gzv5Vwmmc+PqXcJGKUt5Eb6zCyjcj0i7lpz5s2jClYRJA tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn98bp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86D007359;
        Thu, 9 Mar 2023 22:33:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=km0X3UJwdo+PO1U7K67dUUQzTIouNNbZQZlI1TcYuFLY6OixTWP2tFV+4kwWb072Ap8SiBOGKaolCH771GjA2vvGgvAUi9sf+oKE3o1fy87ImR9gw2qRcZeVr9rFwTgGe54AfpaISNT8ROEPBVSAWCSZqoP79ursJlsReNI2AAUjK46heNVjDcS9dHedx387qCsdKLeCd8WjiljbrGlDF2dSk58z3y6v/RqwfRO4f85wFr9x8xKYAQxk0J5jE36+qB4ZDhWTLGJ8Dco066Skw/aJLpnyVyGlJG/CBXGgaqykwIwlTua6kK4XDqvCmtl9fzIqaophL8fQcW6eeAbcaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=By8KhxGlv5XYLJKtoaGTHvnA3Re0uBLFt2Egf2kOaeJEFxDk9mgq+if7lYwpPCfteMkL9YEWG5ElKwE0xF8vWvaHU5QjifmSTY3aVly5HwQXmG0KtMDCe9BBFnNfzuCQ91p9SeWEDagG5s3GMe/BpYUwLVTz4pnqdL+vTPY4jJkgCrQILv7bxGaruS2QPxgOnigviuxBGB6x5gVrzG62LFNJGe1p7UjJxMorqrWq1uBGtw687oc1yEtsIrZIibx6AQsg9eduz3yulBuKrzv2JnNYNZoR9ymtdeNz9n5RDqjvrkAQ0W3WQ0EVQHlCV5YUck7IjgW+SN9cdtuqYPKOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=WlrL56cr3tEDe3HbQudNI2EMIeK5MawfzVkaHCT7JjxWasUwO1SGgdJ+4G/xXAPfqpMbNdnS7uD19xXapvd2M7b/9seNDdXWsdhXJV86J/JUVyKdCja6/yPgo9SXBtyRilGZe9EvIZsEZmdASxdB+4qIVdKAjjczKBLfKCgiofY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/18] scsi: target: iscsit/isert: Alloc per conn cmd counter
Date:   Thu,  9 Mar 2023 16:32:58 -0600
Message-Id: <20230309223312.94595-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 38d15fc9-cc12-4000-d267-08db20ee4933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFtTHe1y/dLGmAjVwDOI9jx0JU0Or//TtcR7CtG03A1MwkrE2ZBTeBj+v4O3waqbnmTR/mrBARPLVowXlpgj8tYVLL70BoM40yEHZopgy/WiKg23IvDrz03P1VE9ziUEuN1cKuArK67XvKwBhA6rAjAKA/uxc49QFdY/pcKuk+carKD2+4B6CY1UaUcncCKtT0FMZvmPiJFjxxbbob2p3qfjAndwLo265ocDn247brHneNH02E1ZT335guMB0kqFI/Z+Ej9wI+BiVlULyYz9IkBe3MYGRdTJ+giyWNTQD/nk29iIQR9NpDbljDXhNpQkHlQTXm1Qh2AtwPS/38Gj2ad8KrhwkKJD5VdKigqumdzyKRYIzQVVKfSxu02Xuy9GOJOhNn2sf/nJ+Wy2FzCFvmbEH/ZvJrxc7sJdNBEoe8I87a/veMnwnJsp7P/HOmv4uUu2FG0rUMaFVSWtCPmTBDikkGWXurh/79MzkRMsS7AcNb3nDVCqdtWx0iUMO9TsBaB+5Lqe7F/KSz3LodeLGkC0ktkwffX+vS2i036VfJvE2+cvq3XV/ifMQVmV31s0ADIDlZbfflQ3sYaEPcBOEzErVX1O5otw1v79Eh9gL+PPiQUu4WtTOsLPz0g+LoLnWqCKt+34XmsS/VNxPugGXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YfECem1VYWaqnVEUxF9FOsOx0JIqrbkYwpmLecrzJFxTX+8e4vdbewmz+KjT?=
 =?us-ascii?Q?ASWn71ZpEsys0V2Ht9AsbeHNmTZ1pvZ6QtMtWHpHUz3YL4RkRmn8ImwalU+3?=
 =?us-ascii?Q?qiyDfdvN0v8FYsdNljaay4C9/cF8myaEQ6/ohWj8gQkEvuDskvKHL6GTZ876?=
 =?us-ascii?Q?vlhh9rupnO5dH31vUFjNuFYJ9aDHC43zjAlsSTuV4CkYgzW0y1Abl/m7CZ5U?=
 =?us-ascii?Q?QC7NoP0XbwzxpfH/idUDe/d24uygjOOxEDWhNrRMssBUiqh2TXroU9Yvwdmf?=
 =?us-ascii?Q?HD33O4dfwDJjyI3VtpcgpIYf3mgfd3AjyUnPKoIS7FbWjqqoGG1tzbNy0k0I?=
 =?us-ascii?Q?N46SkxqnbYAv4dHYoUeXynvUd/yq7XDymCttIB9mF4r6E8VTHsI5JLyNx3AY?=
 =?us-ascii?Q?9ziSB1hdQLeep+Bf0hdzltURNRkDrWlsXwHdn2eJvu3nWgLiAO/F0TNCOdN1?=
 =?us-ascii?Q?6xMa8w6/OOKFQz6sL3DYUBQ7U8QlQrRAlUS9mp8qfQw0fdo09SWIEfsazeLU?=
 =?us-ascii?Q?AVMLUCcPPkJKzk/3YbVlpJyWvuJb9t6HuYPZSra83Y3IEC3eUPHg8DFo4ARg?=
 =?us-ascii?Q?RyfvN6UquV+f6EMbjHKGUDTDL0lxAMY1CB6SofCbeP3lbjZI9Lbkvq54BQvt?=
 =?us-ascii?Q?jgoTmjB/A0BYVuzwPEefQjI7zLaH32ezxIvdXeXEwLZAns0Q95W4fDmr2Hgo?=
 =?us-ascii?Q?q7nIsT2QMleW+WnHYkvlSi+sa0lTCVLvEiyNUEGhJN8X87OznREb/YQOCGRD?=
 =?us-ascii?Q?Xg/Gt7DfrQ8tcCZqRujtBGqhJeOuIP/FSSrUFDOoof2qTARDKD+mUJiIKTJz?=
 =?us-ascii?Q?nd+kTKG4xg+iUGcIUh2OIfRGwmpMcbP6ouknHTfUwA7WnGy07zGSItLHuKG/?=
 =?us-ascii?Q?6eX81X51BCfnfRdS+a5/WUTBP9eiVAXMXruJ3OdPHzabSXUvc2EL/hR3W01M?=
 =?us-ascii?Q?Phqh5BMr/GWuYVeqN22CE7EOyU5kAkYZ9wTNtvp/qg6tlaIPH3ZE2gH0I8cA?=
 =?us-ascii?Q?lMYwzIb18BsJEGyGH1wk8UNyJZDm+g/khRDQSW5XgSNEQ7PYbEsfzSJXtu0p?=
 =?us-ascii?Q?t2dV6uBHzDD0fbKf9YFQt32ySXQ03nSj7rKgV5/0FLtDGyUKmHNbQy1BaJvz?=
 =?us-ascii?Q?xID+PhmyxQxRvo4eJZbxAIo71wVKZNe4kOVXp3IF9Q7jx19Fn25nVq08FVKY?=
 =?us-ascii?Q?WGYa2r8yp23UVhPTRhsu7nNEBYpMGBbiiqtGlWY0KbPvnFQxOgWHJpmzdl3i?=
 =?us-ascii?Q?P+62NR3+GjCossDmv8XcFm3gpeVnfpuwMwHC6GYpW89eY99DxC4byKDOFNOt?=
 =?us-ascii?Q?0xE1gsTD/J70XwYifGZbxlAGI12udUMPjnuxZxcobmE1AsmgEeLvXuSzdHm0?=
 =?us-ascii?Q?B0Cbq1u06cXuGVNc6vwefm1X7dj6DxMqYxITgXtzokyBG5CQdcECpDrHTrfg?=
 =?us-ascii?Q?7kahMXnLlEn8DmhUZZCEDfKFYW1LAaOXcLOM1ta9IeyPDSXPoCsl0c07MW7h?=
 =?us-ascii?Q?SqX7aMpf19KuywOgJ2caRsef/aB47ELOEZYS2ktmK30Plwu0a2IeqvnqBb2v?=
 =?us-ascii?Q?I50y2dAVe7kTO15uSnTIJgTLk+LIO58JuFKPqCSi64zWc9od+invlM5qvuGl?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SFrmzF0n0g/Bq6GKM/j/zCfso+oB9nsXgqGnMBqXV5z1G95M1E6SXbhf8JVTW7t8IXHNPIpjx6Scn5XUhrisRLD2/7/TjaMI2d6esTQElxTaietLj/zHsr+8ODNZycuRqPr6aCM3JIjA5HJ/hQG4sBatKEYqgynFgibVUVpwQA1NXG58mT41jVXRfZSGKQdG8j2TKxaFf9gpZ3BAsZ+ylKwRNrD73EP03dREyYkCnWl5hEOz88SIMUXF4KLGFvUDLO6HkBEs46bIvIK4p5sM8Jsu7tWUwcwcbHl8pmGn6wJ0N7F0eeQHEVzS34FQB8lastzWwbbTjKJw2ObWKnTGPP4f6ADDbkyCkG1ZLirF+pOQ7KVAwAiIubke7SrcOEbMpyxGqhOr752elkObq4HrC0vzOb129steoh2AlxlDJ4qlh56TQjGFEjLUzws/C7qUzTsw55rKbwU/em72jyBzSObJmi5RDKYMq22AkzhqYvywUmvdXA+q6hbH1GDHMpVCZ6XmzY4DwIlbVHryJzEFXG3aa6FkNHXstctdIwFySBDX740lIInUVMFxgMaQm56QSzu7Z2d3ZzXmDZNFXVAKuq9MTzQpOS+4eIJ3GW7+WC6XTQmbST+WaSBZurv24Qau6sXP9ihn8GRP44GPyqvzRy6x2rbQ/sbkuRYynyTCjNFGpPkeBKmD0pJLeLCHhu4rYBW7i+52I0W76Akl4Dm/GpC7I96aHy8I9a/g0QXgPJZpfn3sEpX4ul0cHAiCS1gvqfNsT9ngD+IQ6CBwwgu6ni9voD2N8sFSzA7iSuRxuIRPsrPu1PnAwHPHcpEGLgu+xLc+CkIl1NaPipe1+TSpIpFL/HbENBkDZu9N0J5aeWxBgZc+SS3RDwxitM4sjJCm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d15fc9-cc12-4000-d267-08db20ee4933
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:20.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 150n2tunD5XOyJi9RIlfqYYGcl6D5JA68mzwhDkqqG3S13vBplaJo6LWKWEVbCJVzjTbG18VWD266kjEuP0UfEVNyWcJr8+lgQatvMpZY/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: -aWt9eIy2J3kKCk5hUrxj3W9KlzM7K_K
X-Proofpoint-ORIG-GUID: -aWt9eIy2J3kKCk5hUrxj3W9KlzM7K_K
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
2.31.1

