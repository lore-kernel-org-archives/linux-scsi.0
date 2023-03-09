Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974AEC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCIWdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjCIWdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF256B7D9F;
        Thu,  9 Mar 2023 14:33:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LxK7o004827;
        Thu, 9 Mar 2023 22:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=mJBOWLvr2hBhZBhwDsdJ4U1aHeHuHZPgSVC85DiGpXlp1GO+uXnXdF1DJRSgCtGX0FjD
 S7PkdHPUHyrmJYXE7cddyOHFbEP6DDRTYN0wU5LDTK1h08QM5tq9f0ajieMCq37+tbHf
 J0pxblTlH9Z7iN45u7MVBKavCf6xwQEMmVq8Y9Y1qff9A211tAzFueVg5iYRPi7sdltd
 l2Fjr5udG/y1MTlRmJXZxa7AWNSn9QxNNS70bAYg8xHeCsvm83h/sQ6fr4Q7j/LV/Xf3
 mg9MmZn9a+ikomgBfYnBiIOjbWawlfCN0Is7wQkGIYPII+PGe5Hxr/TuaOO4tqy/8A0i Jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wv202-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86C007359;
        Thu, 9 Mar 2023 22:33:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnDs4deYyWkOTrctkOhaVrbSy7z1RDXOysYGonMd8QPnsfVkKZyMlt3tS+nqDJ3X2J9q6URHxxQOxKbVFL6lOnHLAw448qlY0wR9nQGemEEjtf0ZjxgKjD2zqmbhAmpFcO8Vz3/XdSPZ3WlWs2zPYaTPS74hZiiSSz4hri4NYdYPVT3ljai6Qxc8fDPS8goEdn9W0A1OAGs7k/e/txgiTKPfYrWkQ2qULXDAeDs6mS3ZuEBF1bG5Dyd9nnSSaxcNPeRQDpWNfBuH8qbgEkXgoMqP8gNBTfiIIRrzUyCO/pLmJKZ/rOeBH+H87vh0yLg5+gXx3oahd75LMjIV10OA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=YDcdv6ELYZojYTczUrxe5rUyRJA5MB5DlmuFwVh35s+et9yXl2gQtQnaTgUANimVVgpC1sA6329iwb1wh8DzS/ZRBIE5/eT6er2GkX/nCd4++9tZqnfe5ki7Gf8VFiKVBILDR5JnJKdpZvVP2we6ZSd3Z3bBt/A/gNAdnxjcB3J1GsjDraeNVinsWkz4arvF8Sl0RSTnPLmPbYGlk+A2GR9PNcnoYIWEIgoDRZNNyQhWVs7RzXGfKV2f6iC0UHqNW3PpK3l8XItc9XwLJ97QtGRr8Cz/7mWczgFEH+T4EOStGSPEe35KEy04QHLMdjnfBTIxHPTwksAYhMCeBIUPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=MWeEXrXZz81Mc6TTO+IR16rCQ5tu2w0ctzP8AkieJTojedqbPQ4+znRHnXSfq4A3GSu7O7JRvrBbwsV4LehN+5gn7Uzdqsz1Ooh6lNiEIwcokrpTBHWTHNS+/kCJWqO4u7+5BVMomt5O5nABQfZda1a8ZTsHdsviSnljV7o2sMc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/18] scsi: target: Pass in cmd counter to use during cmd setup
Date:   Thu,  9 Mar 2023 16:32:57 -0600
Message-Id: <20230309223312.94595-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: c41751fa-115b-4f0b-b7d7-08db20ee4872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d411kaRavqG4+YSRvqFbV6wEDV1pMEBO/rY32zELDuc884wPI80tDHydCuVdujlWVd7UIUxFfLY76IAeyM7QQzOOpYZ4JTK0UodGSOcmj1pAE0ojbxECpqaK7diQQkYX/d7ZU1WeZJKgBzh+UAEcphvfrWLcKP7stw3QfvGHv6oA8ggXcYcnScc+RZeYED7gfB+zHmhoENEpYM5ACMxgOBdN9MjwJ1gBOxPohgNz8paLnMXOsX/5NAcHjcEekVnxoZncAI8KSrMXOVLHUYIm/LVOkQpGcE0fcD1tKFw5jwS2YErnkgc3Jtm0/slDuE9b6BeQG3v4ccz+fiufKE/h2S5GGuHgqXlHiQmyTtrsCnpsGuUFDu0pYhv7zLyampf492EunRh7W9VDcrHkbjA9vlczPVMJTgGOJKVVZi47IKoBZORSUUiBQc9dtbHBn+wVkYS4iM3TS2K2olZH81tRfcTLDx19cbY6v2UD+wlrSdGkHZfUF7xrD9XZafXDPeTy3URS6drqBE5R7VBwKClWgDvTnR9iSKrNlGKPGRJU0X0MmUbiTJMRdsr7Sqei+luxmtMfzteBaHuGFet2viV5q+wy0uNtZDSPYN/l5LhUL8w1f4tkmauLOIGivY03Unj7XrV+ftNn+JOxf8EWIJXwng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XC42kgCFHTovNOKaE/0412TUgNoYh1CHHzaEoAZHi6chWc31q5DejQguinVi?=
 =?us-ascii?Q?Rnz5YAbWieFo9ECSw9YIrey2KhZVwuejH4tJxJkLEbVokT4rie6RnRGNM9Sb?=
 =?us-ascii?Q?cI2n1rRAxJAu9U42I6wtu/ElH5JTpYF4luBHkmYaUjipWDNiDyi6tq5EMA4p?=
 =?us-ascii?Q?yMzK0sv2Uudu9NeVH5akVms+aU51fKEbPR99gHVmhX1ed9PycgsqwgfnRDah?=
 =?us-ascii?Q?WympcIWbgMeL6jU2ohvq6XaKmQeFTVfEj7/lWMp0vjn9wfBS/pSRpcIrsSmC?=
 =?us-ascii?Q?NLpVuWaWLZCEyxNqgTiJaPgj1DKkrQ/U3yXqFl1j+X/TqbHj1kJ8u2/KXa/J?=
 =?us-ascii?Q?b/5alJWwm4Ojv/b4JPBz9IqMYxT2Kk/CMH/ZBcdI4pX/PWOuRW9jlLfDlIjw?=
 =?us-ascii?Q?juvjoqdtvsQLJP5x6KV3OtDLXp2sAmioj+8BgW77e5egTIQwSh6MY5pkBSGt?=
 =?us-ascii?Q?fqgnTwEOL9F7ftamgGDHQvxGoqqxXiWkuXpasxVy/0NqoEhsY+b88j99+oIq?=
 =?us-ascii?Q?urpl4ztz3MNjUJVEZRblEOGkx1eLvBK1NXsXzIrI60c1zpgg8+hNPPoxs0Gg?=
 =?us-ascii?Q?YlU0y66gHiMilWw9R4gqDv6lahOiYcjWFlznwRkkeFG4LaXN/259X124MHvA?=
 =?us-ascii?Q?Tu10G8BhBTKdYyQzQj72MVJbB1lHz6Nb2tLgQHP1zdNr3lNaBJ0auHmkA1L0?=
 =?us-ascii?Q?d4vgi831nLiwYGVYvb9dtLhdt4dxIZpKZ1b/IaPxhP6LHTiutn92i6Q22IRt?=
 =?us-ascii?Q?wm9QGVPj6EV8e9UOCiniJQ4fPOrJ1nZh+iHwuQF9qWRIsyIy93+EAC8OTw6C?=
 =?us-ascii?Q?TDiAeC6dvJ23w5lBsNru0makLeU7eQ0Gbbmdn7K5gGAUG7kUBCx30xUZ3/9+?=
 =?us-ascii?Q?eAFG4fKUo/1cMxarHtnJHPfIHABO+bm19XyzAMIxKF5PxAZmfzIIDoCqdy03?=
 =?us-ascii?Q?YcI7lklw+b8vCUptcmqbIUgulcChgegTBLdDUHGz5jf97ntLaLExW2A0XY3U?=
 =?us-ascii?Q?3+KXFCJaCCk3BM1Wr6MhoEQHatzMO+D6tuDlTGX84rcWvimoLPkcbIe3bMBh?=
 =?us-ascii?Q?mplLE/vZBleiX1SqGItf+ZgZzLNb1c8FwpcoCxjWz2HMYJJdPY/6DuzExQQq?=
 =?us-ascii?Q?DA9GT3Z3FHhDz2nvNt36mYHHRZ5a4ZACknLkljWbI9a5NGBM/7jQgju7O/Y9?=
 =?us-ascii?Q?51paodQYCVA7do4RhuLc58KyKGpWnZGP/jNx/x3PFBUM+7SqHeTnwj5Pl/WV?=
 =?us-ascii?Q?t1XqAl+XWwnRi7TBMRcI3paik/T4tbhMdJPYUv5HY7T4j+rfwU0rRr36aiXl?=
 =?us-ascii?Q?fsLm6eKx+EjTDVWfeBF5Uw7mKHs4RmN5WHu8h8OIlKuYifZ4uQyla+AILhfk?=
 =?us-ascii?Q?L+hW1p3W/GxFlgZvz7DPmAXgwXQ3bnud4ffgDhx6fHfpxElsDt90CZKx3VFy?=
 =?us-ascii?Q?JB/nvucwZn4f85CvKaHlG1aj/AOfWYZxQO9E2bVG4/VQKl0HxQJX0o15CSgS?=
 =?us-ascii?Q?LxkkqTM9pkg7M7IbSnbXGfTSjEkl9h/9O++KSnEI6CeXUV6WxbdGQC3baFLQ?=
 =?us-ascii?Q?sP34dIe9wV7vRYw9jsRbDJex64eoVPofBX2h4Kg2d4S3bt4eofTgmEIvoNLu?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fs30/bab4IVNL0/i+NE974FGIvPMJiNgDCKIjlN6SF/KM/BpbBlkC5mS23Yb/Ax/ZNEnT2+I9hcxSpYPjTK1F1t6xeDpP7/c5yleq2kGCPrl7iBtEWbEXceCA4jvMPtKIVi8WuCwu9vXDU3FBAxdWbzFCP0YBNnBWz45GCm+IKqvzmQ664NWZS+RP7nTnl6xUXrY2NpNgx112WvQEG9CjaVLDXtZQUmVWqlhsap48Grfhk6rPXG8sUY5KjtV0uebVozQNZoEvJkMPm0aJGjgljTY6Ok8rRJorGQdrui1LIY0GKT/XmqgLqawdMGj4lWBFgCkPk+9UtqjZ40JMgTuQ5dQX4CREviTF/eL/SMDOIsSvCFcHSZd8pWgfSrAO2ObqGqdGJZL9NEpw65CC5ZdHodCwFUZIJjnx5syl2YKfRByqEo09+KNDpEj5g4xfVzJWpatTLijzzoFjd6b8ZNmTXyo3ZFv4sQfpnZa/shnn2q3+Sz9AvnZQqFDMT+Oeu+JqpidOrE7QXlJmO30U9vESEYFnpuDA4uHLK6jID01MwM5FLq6BDTnfFPm/G+Sl+2eVUSJBjaQRc+wmy+f8JFMuD5qwo8jYGxMwBOkxrUyobv8wxGVFR97a5+ggLNbMiaiypnb7TwDQHN8c+C5magd+ITyQ42qYmyc2e6JSIGxvB7m3D/QDAbyk1V+u+SirbUeC7h9LzWr7BHKc2/JPV2kv5MoaJ8CnOwHFRC8/gaxtrabkikBkF+5g5p9ulhvgN7Y5yGTqHZUhUYwMV+k2I/EIctXxYLtJ8K3SPkPPRm3ytJnEbAOg7Z15VQniyIRUwPOOepm6c4a8foeqdB1OW/CdTv4wx6OGFhM17wlkK3o9a7hPJD+ieE4Ni7NhjbBI2d+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c41751fa-115b-4f0b-b7d7-08db20ee4872
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:19.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luLaxsTlux7MYV+4MMY+12GrfI7JhkKXdmTqAJ5KKonVD1Ph9DqFiwAqGFwuGw+hmgYjZbcus+NKxclGuL/qmiU7fytARfgzhNu+Wwp5cLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: 7NasSqLTYhkcQjRUKld1efmbJygmlOln
X-Proofpoint-ORIG-GUID: 7NasSqLTYhkcQjRUKld1efmbJygmlOln
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows target_get_sess_cmd users to pass in the cmd counter they want
to use. Right now we pass in the session's cmd counter but in the next
patch iSCSI will switch from per session to per conn so this patch will be
needed for that conversion.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 10 +++++----
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..87927a36f90d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1190,9 +1190,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
-			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			  cmd->data_direction, sam_task_attr,
+			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,8 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60647a49a1d3..c395606ab1a9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1441,14 +1441,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1468,6 +1466,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1687,7 +1686,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1982,7 +1982,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2986,7 +2987,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3003,11 +3003,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b7..91ed015b588c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..c21acebe8aae 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 65527174b8bc..d507e7885f17 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,9 +151,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.31.1

