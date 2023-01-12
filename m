Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4890C54EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbjALDJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbjALDI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6034914E;
        Wed, 11 Jan 2023 19:08:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C2vI3V023849;
        Thu, 12 Jan 2023 03:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1bbx0DXywxyqmxDZclxxw6Rx/sNJuqdY7ell5Ce3UZI=;
 b=bty+t90rAt/wa5N85bI8AOy0MOS26uen1RGBcM6BXKK9+E+JJIS3hW0UbeJ/E9K/YO5l
 W75QihMBVhiYPF4PxubfSXJJIu07mo5lBkvEX/y5tle9zehyKA4/vdeU6dLXMO7Uf3+U
 j+gVLxcKqHOXcgPSX1eCbEITgnsNtkatDiCLxbPjAtB27569jlvhTCo9PkTK5mXsHlXG
 MC4jgyFe25hUKE1bXOtSSrw6E5Gfa2zxz0cem1iTzqaLRdNZmpnqTbJ1iTjwP5kO4Jw3
 hn49PwjR9vEmQqjsj/r3bPChuPOLtVSTBu3Zcq09wjknKjIDmR3uQcKL1ILu1RyoORLv 8w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n28ja82n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YH034176;
        Thu, 12 Jan 2023 03:08:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oz5ZRYn5hcoGdaT5rPU4oTBAqT5KXqDJd5U7ONzN5bFQIlTGbwVGieIgeG9vQUqxJmq3y58/wJvRsIVuWIrpCPM7L25eLoPELib8Oe4YaZi9fwW3e5+5lmAe/dOsGDkJjQf+0ryE572GTvtixXIKLO6Mn1B6HJsPJgb0OsbjhKOXhXza3bSB0PFZbaUnwENpO8TypuMN/btlvIbCOek9rb/aw0gc2Ur4JcDeqdMbViQ25gsVFzHAAG4uAd+Hp5Q/3Ffv/6h2QSL0hqeHD1NKLSmyJUpjm1vCmISxWWYXi38ZXSpbUG8Fsjzn1tTX1EhZaL0PNOS9jlzBlipQOH3onA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bbx0DXywxyqmxDZclxxw6Rx/sNJuqdY7ell5Ce3UZI=;
 b=NMrCBzvt7dTN3Gb+0JmVP0B8uKSn2GpH6jf25MTwyw+SIa3X48UultC7wnElXpwSCd0aaum/ZA5YRmhh1C+kBXKgRrTQEb7zwgACcn6OEezDvssy7gmdj2B0qJMpGPN1X6HUPFfFeb5OWSjwj9FEzULMl5sqLJaDGysiSoYrLv3X4L9fnamU0m9q3c4mNso/Cy2chsAgi2X/4/o6P8dMfdOKKng3djzl9z11fzmDWNmWEIBuF8yUIgshLBJO9apotfwYmF4pFgmpTM7medt4koqMKLKGCHf4gXKurDHUDTRvuYMl2pajy7MqVTybt8MiPko6jKpjNXcVA2CbfY4ABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bbx0DXywxyqmxDZclxxw6Rx/sNJuqdY7ell5Ce3UZI=;
 b=UEOXz3GH++bCndupdZ2gXUTIh0ci8wlxmiIclPK5XBadCb2z2m9B+q48LHNHufTQRckMa6SQqmN0MCqtR+9+IBbaPvsYHDCujKmTzGtK26JPViPKcEvqSdDplvjOwFxxbvvYLy+hS9pwJ6p9t91ZgzmUvPfVM82eQoulM4bZoTo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/13] scsi: target: drop tas arg from __transport_wait_for_tasks
Date:   Wed, 11 Jan 2023 21:08:27 -0600
Message-Id: <20230112030832.110143-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:610:59::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b1a28b-1339-4f7d-6939-08daf44a52c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATN/5mwgGzSNqfK0qN66Q1ABE4uDpJEjL8g1l1oWLbbW79PM2+1uNtRU7bSF3l/obHZuMimpNfTrkUd1i59Sv3Xfwb8ng9XgF/pFwJguE63gotRWagNNMYMcYwuZBvf1/Z+L8tA4rnxsHA0XlddZH611241q4eyGODPhA5JYjVCCtAV6Y/kJQlrj8BzaTma2yFpEoPYSFsrvbELUcY8xVst7N+L4XcW/z13tGn3YJHyR4Aq3upQMBuB65zqhQ4y1o7ne1REPbYRMUjwzAswI+UsXEWoGV5AnsHSe6XWUR6VJPUZM+WHL/xab7ZNfiMWjQ7bI7xWdPzV/4u8RoK1/Bc7hM4eQ3sYywSGbLARZRwIr2G2NB+tDgAwGQjXEFiJKLxg7kn9gaYbSWi3Fz+OelI+Yjx84pwdgadffWx2Wb6hzJf+eESXHnSs3vkoL6mRUz8e4eddEM1R65v1hzLn+O4ka6konM7cJ0vqqZ1ah+rlK7mK+VGw2XEST7v2qjUZW+faQKnmgQjLMy5an/nj8yppwJk6c7acYbT499mQlMC4pLSZ8iP3J56EdlPV1qw8rel9WyKrK45AnGcQoze2aNi4/7bNnneZ4FpVV8f3w4+gNEJs3fSWSFjodc7EoF6k7S1SgI4cmMfz5vJkgYH822Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7lkJn8piDB2VClzU0QJIfF+cCH/YjaZLLfhVXEeKzy+KFdlT3FwVMcWLs9jL?=
 =?us-ascii?Q?1p4lEUeAOjBYCD0mOU4thjn3SapNdDr9BH/BDxnFt7faRE2A/v4YOwMVsCPV?=
 =?us-ascii?Q?vG4W/Qv3BcU2LoOxc8FCX+DoIs/rBkIiY6+6Li4Uk+N8MP9FGpkzFCHpvF9u?=
 =?us-ascii?Q?Lan7NBLMXCVxpfxnle7J0YMuavbQG32S2Xu0oPn5vubIi29l+CxabjGALpk4?=
 =?us-ascii?Q?s2778IlX24R5gckmfxbmVR2klh8ia3x5pxDf0JeezZVh5G3ZHY7itNX9Cjb/?=
 =?us-ascii?Q?3zbERl/ybLcQnyjJvhtEwFbIIIOv2+G/1uHWrsKEZx658TpLNh9Zo6aaT2IF?=
 =?us-ascii?Q?samxO+Bm1ESNqefCxpWLJwIUnMZgDebcn2b99/fzz3MG3lD06et8rWBnWxSK?=
 =?us-ascii?Q?F0ezXo+1ZRtp9mKMXvRskYbrzlGwWAxTaJKxoOQmessClll0NdzWFt1TkIlN?=
 =?us-ascii?Q?/28502wNeSNudehud0o5vXcXT7ANO0e3hMNeD0TMijYpkE9Gr8norA8C7uQ6?=
 =?us-ascii?Q?stZeXuDvYOrxWQrJk1m1DNYo3WFc+nmwo4VjpgbgT4rsBLAyN3kW3tw+QvMV?=
 =?us-ascii?Q?vFMygGEZadHYlH7KCjjBNeAbDEZD/u8IdVOFYnVt8LazHORjeAMUifuveqx5?=
 =?us-ascii?Q?NuUT8odGvhXl9egUgjiwassZiMfzEGQyW8DwaXqDCfxK429HBEtNfsVLO5tl?=
 =?us-ascii?Q?omqfPZ7HJ52mZwxRmMWOxK0gqzP2IdO0bP0ayB8HyeW9M0eAdeNYPP3Guu6j?=
 =?us-ascii?Q?BWdQmsuz3BBhvSXgVO3q1rUX8xIsJ++sjfB2OYJjnxzrJua3mkrzNcnGUeFL?=
 =?us-ascii?Q?oZpdHVvR0W+HYVpqdF8kdgcb38/7bGs42rhCqEX/KQwoRSs4eaaiq6aOBQqa?=
 =?us-ascii?Q?13Ohbrwy6/G5jrobcFz5n+Y528A0SxhPY/QwH/fuiE46KenuePmGpdfTMqCS?=
 =?us-ascii?Q?WrORQCtbKh8WHAsFsYKb4Akv0kNhW5VD2FX5fY4zIqAc6KfeHVtvbUhaKoMm?=
 =?us-ascii?Q?KzF2HswXbdCnv1UuxWCOjNPmklCTwkcxlzyJXFKek+I5aBuG02xhDRLC470U?=
 =?us-ascii?Q?KBtLI6x7eqKbyP/PJ6UVF+KaU2mcnQXF7VTIjiz9O20hCNgoPXKxOTyEFVQA?=
 =?us-ascii?Q?9bm1aXdWQD4XKuGmwpMHYDuQwZnutiXUFWU8cIAF4jGTTv0ARX6G4dPoYyW5?=
 =?us-ascii?Q?ZCnoItQysTKH64oI2mv05UGf4i+xV1Mk9Ji8kmXbZ7SuJg6/iuvo0kF5N0/h?=
 =?us-ascii?Q?UzQUOQ3diSy7NiStz2AfiDU+E+/QQ6FdMnHVtNX/6wjRHqAwU63cCe6X5VHN?=
 =?us-ascii?Q?ACIMcT5ggOmwlrBvylRGlwkrO7NvxSkefiJ9TCxadbt6IvSKpAeEwJvRMX8D?=
 =?us-ascii?Q?6RJKyrbsV1+bjLYrFnMnMSziPYyJ1jYxLJnkgdZurpXS/J2Ey0+0sYzPOZG4?=
 =?us-ascii?Q?69eLbf8ThnezejpJ4ANzO8Dw8DtmyKiJUBi4lOFIki6U+DSysEMsVw+EM/fY?=
 =?us-ascii?Q?xm/BzxYBExHnhs9JK0JC9ilKK4KvSmJllsEhO7d8+8aJAcCit+lknYXlbMkZ?=
 =?us-ascii?Q?tBZFXOo/hHvdACKgbICO4qh4zyC5QBf6lPFexEQHQaq1TX6FbMtyQSoOikpP?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: l6xHuIUG44n1/2C1XWYVrVeCTL26aC1GG2Nw0LhRE24ASjGFP5draIkbZ7G+zg2PdciPIby8RYnwxK13eGDCsiXQ4Uei7RzpdGHqNmVB0yrjIZri5uO3Kpuv6MF9uA3eyxy5ZTaFq/v4/EnydwdxB53CjWSdqij4SRfcBAd4xS12m2172KQY/BCA16kP6/AN7OcuIy6azBkqe6zqadrPCf+gHtfoln7pTkfStD3Clho5Fn2jY6beKSoMVcVi6BkXuOEtWH6Sacw9VddGS97Dge/Iq7mHm1HQVwgXcIT2yxZQJHjAFrfRkb0zqsmCYLzWhC6W0zzEmI2GUUpGlE4A9xr6u0y/cS656s8yPq2HNAly1SjXtjBTE8jUh5Yar4XW6dNhQUNH9d9D7aIFicULstAHW+8ThdAQ2UjovpqALX6TyztqebsTPy3WCtMag+/NDdrmn5CFRgIPmpS/kzCAkTkbETIZGPPCHyoUD1ZoR4n/gWX5unZw09UrXDSTFxAkLuNGFIxh3+tQv0V2H+p05XKkBw0fIV16V0BsAqsDpAJPNWH7vNcbZJbfXMBPeZpSVvJI+AMRUjPlKWSDmTzOqRBmPnAsZCzwpbv8AKjsO8swlIe/LDGQ4GniqgwAPLIxxNQaDIQY+Ey4VukQpimuW3KecJMC1EXUDx1ybfif3iyBQ4HKyd+9fQx+UoOXXda56L867jXIwlZxaarK9U1E+xevkQWqPE3z2kV7UB2evIF4378KJ9NpR/PtNu7vR+htPAT7mZPg9JMdOEmFPOUFk3sTMODw9K/j4d16SfpXZ6VLAAjNIuJDhrg5VNg6AqxaBSuQEjgm9Q7z6UThsVlmMwFEi1nqS3Hs6jvXYXOjorwdIwNY4izsZVw2Nw3k4Zfj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b1a28b-1339-4f7d-6939-08daf44a52c2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:48.1138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZtSt8MFnekW/HR/3ckk4MykEqDVDUvJVAKJ9Ux9p+FnQzNdESE1rxl+hBPU5kAqvPNa7DtLEawYL923nAaqDi5NviIzcP0rb03QdXI0DKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: YPxzUEr8FFzG-ZWreeahAV58A5GMGyvz
X-Proofpoint-GUID: YPxzUEr8FFzG-ZWreeahAV58A5GMGyvz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tas arg is no longer used by callers of __transport_wait_for_tasks
so drop it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_transport.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86adff2a86ed..cb3fdc81ba3b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2899,15 +2899,14 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 }
 
 static bool
-__transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *,
-			   unsigned long *flags);
+__transport_wait_for_tasks(struct se_cmd *, bool, bool *, unsigned long *flags);
 
-static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
+static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	__transport_wait_for_tasks(cmd, true, aborted, tas, &flags);
+	__transport_wait_for_tasks(cmd, true, aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
@@ -2952,10 +2951,10 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	DECLARE_COMPLETION_ONSTACK(compl);
 	int ret = 0;
-	bool aborted = false, tas = false;
+	bool aborted = false;
 
 	if (wait_for_tasks)
-		target_wait_free_cmd(cmd, &aborted, &tas);
+		target_wait_free_cmd(cmd, &aborted);
 
 	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD) {
 		/*
@@ -3234,7 +3233,7 @@ void transport_clear_lun_ref(struct se_lun *lun)
 
 static bool
 __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
-			   bool *aborted, bool *tas, unsigned long *flags)
+			   bool *aborted, unsigned long *flags)
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
@@ -3246,9 +3245,6 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	if (cmd->transport_state & CMD_T_ABORTED)
 		*aborted = true;
 
-	if (cmd->transport_state & CMD_T_TAS)
-		*tas = true;
-
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
 	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		return false;
@@ -3289,10 +3285,10 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 bool transport_wait_for_tasks(struct se_cmd *cmd)
 {
 	unsigned long flags;
-	bool ret, aborted = false, tas = false;
+	bool ret, aborted = false;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	ret = __transport_wait_for_tasks(cmd, false, &aborted, &tas, &flags);
+	ret = __transport_wait_for_tasks(cmd, false, &aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return ret;
-- 
2.31.1

