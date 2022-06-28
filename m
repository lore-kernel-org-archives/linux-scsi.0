Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2533BCCA483
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiF1C1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244373AbiF1CZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:25:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A382559A;
        Mon, 27 Jun 2022 19:23:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S22ZBJ020701;
        Tue, 28 Jun 2022 02:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=h9WUTDzW5i9o20f1ZCp6f1TmWNju4x2ZAk5utu2FFXU=;
 b=iHjtpbtOk3eFofJ4gEcL+fHtSCqJhHtCNKjpODkJBA8PMb5CdyYVFDIsh3NfziWZUM6J
 fqdWQFieepe8Fm3adlo2K1SkyG9hUwfULcHwiufjthi94weswmWKlsQ091BN20YTx95s
 7bH6ON8xhnwEyVjClULJhxZSD7ELBWClxMA58gJnl4NHg87KfY+IdNExFzUcg0swb6W0
 LwbJwaxaW0YAqIoMm4FgNktyK0LUmVgZJG2MM1yxOGwdPQl6clZqiydM5PQ0Xf72Ai/c
 uyppy7/342OUZeBNdC9OPQqePhmBkv+Il5Goo851hEKoSJqQ/MNO1Mgu/4FBJ8wnU0iH Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwt89vq2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:23:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2L1Gs015908;
        Tue, 28 Jun 2022 02:23:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7hr45-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnpMi1Guqf0A9Nbic+yhBiVJjGaid+FaMsOx6HvZ6+ZvGygXpSywvpcCUxmXw3ioQ4s3pswVBF/s/3V64Uw5Mi483jY3ddvpb+XgDXXKOX6HQa+p1HBEBLo14/OA7Ar2tNJv298bZVls7nP8snHKIPGgJXmz3/mQgckcMA0e86ApWqQ2+yw5yf+G1+feNa+hQorHqrdbpTqVnJvNEkMIuVS/qroMw3hH1hFwxwytcFDYW9Kshfr+OM7f/nTbYcMFooLO/nn96s+YjRqaPRUqz9TGktcdwanggc49cESrc/veVDiStKDZpR1UyNaNHz3OelTTQtNuXKbeHoR2Ydw+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9WUTDzW5i9o20f1ZCp6f1TmWNju4x2ZAk5utu2FFXU=;
 b=ihUE77HPfTPDQKFcj1kiWonl/HQ5b4OWVmOxYqG0X7PLg3UU2He2I2KKzgMkFnn/vu5kbsKVLVm+JHCokwR0xjdTuixNimf+wn0AlHBEJLiyB5mTF9kNoha4jkWH02DW8Vv1ZL5uXG4KCIUeCUy0NU0LXzXCdZ7XklHYtRWGzHhQPonm/CGrkNL4PUvxVq4F34G2yp7OMQB9zis3c259uPNTML4/5eICL/MuaakTD0XtoP8CmkHRL8Kwd6rNPV9GVgHDUAWdP/sQ4qnA8krA6hUh1evGbTHn8AaP8E/B1fpHdEwPGnn4BX8mbFdLTOweJFGnUOLNutr/uqdjPVKfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9WUTDzW5i9o20f1ZCp6f1TmWNju4x2ZAk5utu2FFXU=;
 b=RMuIGqQ6naxZg6GXm4U8wcKoTP3g6N36L/Bk5XtiinVNVgZs1YETid6QtbthF6yoCftqaGHrzPke/LLs7eO2BV1IFHDsKuP0PjE4/r6Z+pKMA9pZq3ifaQyfq9SRCtWtv0mZURrmnXlGX1L4EufoJHdFSJq3cJdlgYVXdn7ta/w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:23:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:23:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date:   Mon, 27 Jun 2022 21:23:25 -0500
Message-Id: <20220628022325.14627-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022325.14627-1-michael.christie@oracle.com>
References: <20220628022325.14627-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:610:e5::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a80f13b-ee39-4bfd-a686-08da58ad326b
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cNQtALkSozWJdQeEal5E0Oi1FkdGlf+AmYq9nFGIPYh+eXDIo1zzEc/mwr2VcEQbIAB76l+8Lpn+bTz6QmVMjhf1lffChPGLgEk2eMW7ZXdFKOGutywCI1C8BlXLU8gNbG0kxG5qMFv799PfTxkmNdFOBXp6XRphxp9vQj8azOvRhQJpYUy0LD/oHxQV++RlAO0Xc9icjweNTN2QeTL8hZyTN/dok8NyZjL/Rhq/Tpn9iLpqBaOYXaoJ+TvVX3sGrF2O6fQ7ts9ty44iRwofjqo9NTZ6t7iKqzoBkEQk8WyHqKaG+w8qSC47txqTwQieYfmM6M7gSW70E10We517q9vjY7SUZe6veY8iwMTN5ey85PvLagOqInvWqwFu0v+q2IRNW39vHncnJSvj/8/MPBZPOdB/R+QC8+WK9614YgAw0/375VgLCnhVHrOcoYXASHz6hv6IJhi/hoSIg/HtLDQsHRHzD/hYs283zrgoTjocTDto7HRa+2cwvt3NDSDdu+oINRWmLFcT4SvFXATzIAJCkN3mWZQG21XR3fx98Xdg5rQX4RLdhVS2G4oa0NO9TXlagCj81WKL6QzQOvFot7gChqBHVLKpR48VOOb7iolrP4vWb94wzPdSXw07DnMvT6jM7KMGo+I8PCndVCS85wu74/RJDBvAVkd8ZkCaNAMtpcaftkQa+jy3e2TlqSJTShdrcXnyAcH5pFcObCV4rSFDDxjtxzQ59n+b9SQPvc3/12hVRJjLqefx/GYMVD/4CcB5aKCg0Lkoe4is8TSp6vxrn6OWgBaeXnqL7JKjtE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(366004)(346002)(136003)(1076003)(36756003)(38100700002)(66556008)(6666004)(8936002)(66946007)(38350700002)(316002)(66476007)(41300700001)(6506007)(86362001)(6512007)(6486002)(478600001)(26005)(83380400001)(107886003)(52116002)(2906002)(5660300002)(186003)(4326008)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qQpJcsgZRssCjUUziWVs1VMVIIQlcjA/2ABT0VMv+af3Y/ej7gsdGf+tPba5?=
 =?us-ascii?Q?P60ITLdd13H6wnDWPWE97REGtfPX+zaKi41KkORBEvTbhZaMqLAjyKks6Zho?=
 =?us-ascii?Q?VnNUh3cNzRWgfPE+uf+gs0fKZuH9adSAhI1QNHlf8Hu4XKc8Uc6mB4BlDu+M?=
 =?us-ascii?Q?PgRGC2hv338Wd8jgfST/phDBM/dTWUI80TwqdnXwfD9C+Uf/fJsBDVLNoi2k?=
 =?us-ascii?Q?nVQpW9lF7T0j+ZbT/C8zzcL/8z6gI3OtzdXGmsqBy4pPBwhsOH/4hQc5O1lV?=
 =?us-ascii?Q?Y9qBw7VDy8zuoSilLKTBtM3rcw5XlpPeIKt8Ue3D2MsDEVsjRkHzEgXhky/q?=
 =?us-ascii?Q?JTbWhl4CJFZp8CnVFdQvI6H30DDjPB9Yxy5PLJxB271MrwpcLE5GjrBc2j8y?=
 =?us-ascii?Q?BvyVDhoIyp15TxJy4OSZqdtDvG2IXlONH7a1E7IdSFfRrueU75LTM1pkQJed?=
 =?us-ascii?Q?WMMSUMi+6LxEWKOe0VPj0R1pul3Oe4GBj74NKlMRcHnFquuINR/DB2vl/b2y?=
 =?us-ascii?Q?yZH/cYURX3ZGBrGKHZAZ3LKrMH7WWY3I0h8Kcp88QTzYiVnN1KVXcX1Id/VQ?=
 =?us-ascii?Q?zTjR8vwwIS0Vuk0BtLk0d3FGeMU5z0p+6SpriOfNziqXIveGlcZpEgqOtuct?=
 =?us-ascii?Q?snwAckyeDF27qQLGktxJ6Gx71UlPX39vkqss1B5Nx3OT+2T6ELdgqcwnXYse?=
 =?us-ascii?Q?ZPA6E+dFuybtUd6BSGweeqgecA3jPnPyZwWjsn8s9HYeURY9fgPZli3ySHD8?=
 =?us-ascii?Q?1xeZu1aV4FVRRDHe8qbNs1QfJu1Mcv6oHhaFHu2ArslloZUHAjyLJcOYCkcb?=
 =?us-ascii?Q?yaluFmD88ipQYT0ueL/semF31qLGm48ERmpV5VmXtfK5wClcQXM4dtjdaf07?=
 =?us-ascii?Q?IGzx7QGfzS+0SZpCBPl2u1as62wXi2Y8vHEW68cc0+RNK3iweq5tD8PgEVzA?=
 =?us-ascii?Q?QdWPn3RepnTVyWyK5NATR8kZMN/XPgUvveJe4X73yilNBnRi96vF4D3aVqLX?=
 =?us-ascii?Q?a854GdiJ1jBszEZpavwABSdY3FFMdm62M5icXkcdx827ddV42dCXQObuRAWv?=
 =?us-ascii?Q?763Vq3ch/rOvCF9fKKieU/givFHKLxhpFIv61rFuPw2lTGYhW1fIegOkEdGn?=
 =?us-ascii?Q?SYCuv+TUKYu8IiZ2gDk54827wlNPpi3XdEhgIqKnYwL76/QHwiG4D5MPvBky?=
 =?us-ascii?Q?MfMbe8MQT9CABX14GRkS70EiMxm6ggwaSuT1iMo1XVTAJdwW4EOXcmJMwWQ2?=
 =?us-ascii?Q?AGUL86PoAAMCY0YSAhNc5BEOstBoCGSr2qcHzsUXOvLL3UrYEbmureImoeZG?=
 =?us-ascii?Q?m3SQg3xdt4G/pEfYD0i77CpMmkC5phRj5z5S7XwP2bvLjImYNNUMOajPp7mU?=
 =?us-ascii?Q?yzxzLnRaRBXTY4cUkQExF61CvApSyh7fDiSnkcaJpIio87TCjD8PfQnpFxrt?=
 =?us-ascii?Q?r55j+C+OHYK3htrSNK+El6z3wIqyTQ4yKpZ2p/USq/aoW/uen3swlZIy13r0?=
 =?us-ascii?Q?e0+EyhW6lrz6AyrlT1kohMyY9q8tyYg8lIT4oM28iaajUEHLsLcP1dcbza+8?=
 =?us-ascii?Q?14rLhqVrJZ25Pska4pp9Sz/1kGAVKqDvLDDKqlkADZuZVVdBLTbq02/SmesD?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a80f13b-ee39-4bfd-a686-08da58ad326b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:23:32.6567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwBRcB7OOeqbPxmd1Gm2RH3Lf1FBfo9ofvNG6yD1hDVlP4DZyoAx06HnsBcZJmkTi+rzdxfmAj/8xoWoSP8pcVFWnMrbC6SQam8P3woBU7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: aTH9BcORq3r70YaYt5ci0O8XdCzHhPJX
X-Proofpoint-GUID: aTH9BcORq3r70YaYt5ci0O8XdCzHhPJX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In newer version of the SBC specs, we have a NDOB bit that indicates there
is no data buffer that gets written out. If this bit is set using commands
like "sg_write_same --ndob" we will crash in target_core_iblock/file's
execute_write_same handlers when we go to access the se_cmd->t_data_sg
because its NULL.

This patch adds a check for the NDOB bit in the common WRITE SAME code
because we don't support it. And, it adds a check for zero SG elements in
each handler in case the initiator tries to send a normal WRITE SAME with
no data buffer.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_file.c   | 3 +++
 drivers/target/target_core_iblock.c | 4 ++++
 drivers/target/target_core_sbc.c    | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e68f1cc8ef98..6c8d8b051bfd 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -448,6 +448,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 378c80313a0f..1ed9381751e6 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -494,6 +494,10 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	sg = &cmd->t_data_sg[0];
 
 	if (cmd->t_data_nents > 1 ||
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ca1b2312d6e7..f6132836eb38 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -312,6 +312,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
+
+	if (flags & 0x01) {
+		pr_warn("WRITE SAME with NDOB not supported\n");
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	/*
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
-- 
2.25.1

