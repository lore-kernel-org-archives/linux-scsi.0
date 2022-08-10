Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AA6C25B0E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiHJDm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiHJDmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:42:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF89572EC8
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:42:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8W8026805;
        Wed, 10 Aug 2022 03:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gLkPC/Ecbzr7wVrNZUeNecZyWUXAFk+TI7XUTcb6cRU=;
 b=RrW+0HrXACFzwAuM2P+VV//mPLH4tJvsijXLwjIGOnGZfAHgLzamktQOKzjPK0x3f0xc
 Ce+bIIw6xcQcrEXWlXsQTifqtKtjYvGyANfmSZX+gEfBEjQPvCZm34I5a8Dq1PPcKIk4
 F48gHxIT7r3TVwQSxFfGbWnL9huH6BfbTATXLW10dzykE6fwcQZ+HL88jgtF5MuebuMJ
 ZqgE1XOQDpROM3flgxuFZbP897fxMOQ6ykmUZSUAOW1c0n78tTt8e1CyaDoCKOUG92+t
 3uR3sy6KBDZQmvYfhwBCzksk5rhwVvXIrvevVYCviLS1wLa2BGQKVkxbkc0irezQ7xzB Dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0dPNP019955;
        Wed, 10 Aug 2022 03:42:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhrx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U99mm1dzUYdwgf6JnDzGYetGTto30PlJXVre74QWA+QLDN8EF1WxdbRmgBop4grgTWkzqgJPXE2SAi2qQPsOHDtQRTP8CDpF6cn6KHfX78GdG+87KDhNS6KTRPB+Tgw6PItRabiYf7eqkxP0wjmQEveU0eWqKTYM25bP7qyFn4pNK4AhmPS3Gh40n4FDafalBFVh8x/RatDZw848Y7m6Xd8vBC6PhUlTmYPBRrO4n7b5+43FN+p7ZaaI1xzNHanI4kaquaREUFfGGS8d1QBGCu72oVJS/LlHygCMUywTo1+NOWo+uEsf29voShD8pfuatSqMgS7CLsb8cu5tc6Htjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLkPC/Ecbzr7wVrNZUeNecZyWUXAFk+TI7XUTcb6cRU=;
 b=Ju4oy1/9t87VsvzkTd9oi+VvuqQWrd/ZklyXLIeh17znT14GKL+mjBzHXMe2fkrKeRwA6fLcP/vktAIfuB/3wBaaG1rtb3rK6cu77SnAem2yBkWUf1Vn29Gd3O6t/WUKmWOiJyGxxjFM6v6pdbbOeJb/s8dJHKWD2n/8CCgIKnj3aKgOQZLPmrVFAKNomZgfMoY950vjrX7WYNVKLQPcnDJOYqVfJH5FqgvZXdfmDlvepAoG9v414UVRNLqzYgYr+2KpK1viZLYMCXBnvCnlSSvK5qr5H+8d5MJA1rNE1ooIssqKuWWRSC85mUneD2ORG8O2P4E1jpJTd7mW3PJ+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLkPC/Ecbzr7wVrNZUeNecZyWUXAFk+TI7XUTcb6cRU=;
 b=a5QQuacjGtNM6lIQBmzGjzkhU1G8Taws8dmO1xnrAlPy18CkoEPvPiQEp1Qh069vGnV3ey/72C4hH5wGi4pZ6ikwGiIJAQCTSLluoetkBozGRsCUHyRh6N3ityDxVIJGhnRcaZO2LLzPHJCQovhkn7BAC8OVHWvJiYacr2AahFo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:42:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:42:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/4] scsi: Handle UAs for pr_ops
Date:   Tue,  9 Aug 2022 22:41:55 -0500
Message-Id: <20220810034155.20744-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810034155.20744-1-michael.christie@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0200.namprd03.prod.outlook.com
 (2603:10b6:610:e4::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ce7aa9d-4be7-4132-c3dd-08da7a824a29
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+S97i8y5iWgPJR97C4E/zATgK0yBUTWOuwKhm91/EFIO1hLrRxmbfHAV1Bc7AOE62xam/vfpkV3rExwSBoW3EPQzg7aYBNWQ7AUHyt/63VMa4XVdm9dISlfV5weurdAoua8oRU/7AuNe4RAUgzD/N3tmNs1hMc35CiCmi8uL14x24kN6HB2U4772WQzuLio1te3TGE9HZY4vtMahKOOUKygSpVwRAMqOV1tVijRYlGkjcidOm4xeMXMLoVJeZKHlUkba8BNyVbqKtQfs73tAJde17xFhaQ5zmGW85tUJ/WnVzepjnkJE9IZBIe6dXcyuFMykVgL9/6AuJXudix7CUABNVNSZQ1UpV9xU1D8wlrQdUXDJwa8wr/G0AEl0M4JXH7YLQKlI+PHN47DcT05RHw+IKMfyx9ETrDsv1becrc/sRk046Rn+dyM1kBXDUSVPg+rJIgj9cfPnIcBexAJG8y3x6A+DuFHwsmC4tmGFi6jGbo/YXfXQQirF5t866oIXsBQH6GIHrkRrpairiVvFFZwNiXUh/4Lm3MmIvx1f5oKDJsHTqn0xG9VDABJDQkE3q/kU3LnhBhdmBPFu5jfPFxN+VKiKegQNZe9P+ZrlKJNzLXchPJe6X/NRRPQZ00wyVd8fiN7982SjcqOHMDLMEkhSqh+09I0Ki9A1NkMKn74Zari4G7G1r9R9hP9uiaJ+mcIVWU2o/gz7eYskEb3q5d2cFAPEOaxQxP7wyrmO7gZxiDyVemoIv0+PRE9rV3a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(6506007)(107886003)(316002)(41300700001)(38100700002)(6666004)(86362001)(2616005)(66556008)(6512007)(186003)(1076003)(5660300002)(66476007)(8936002)(83380400001)(66946007)(36756003)(6486002)(4326008)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?78OY9xzW8Z6Agd76BwZ+ItSo9gTfaKHOnLkDVvc79AjlqjQ2gGBHeC/kAFDk?=
 =?us-ascii?Q?c5AYZ5LGw74e4DLDJCdqhqvX+jUAp6ywoF8wKjy/HUkOkvDHRatygg11jTk3?=
 =?us-ascii?Q?HHJQeUQ+XyKheW7PKGyFCLCAvLicnxO/vhkPn8rbub431opmu/aaqEsd+NVL?=
 =?us-ascii?Q?ZEufACB0sPLNGTkZfNjCsEzCihl8QAHbhbhncSkQPtYVqF2XB6PveKvh3cgL?=
 =?us-ascii?Q?/ljtnbWllw8ZTfPDdbYW93wrxmEQ/oleF0QFGnySYkjeYQEPCl35ey4O2pLj?=
 =?us-ascii?Q?CuWwzUV55IQzBokCdlatdU0VcrjKLoJO6tJCxjLRAShr0jVv3bcND1EGYAzw?=
 =?us-ascii?Q?0XmSSvdde2FZ0B3rLo2kSVBMbgTlVghuqmxIPiQfCO/qbdyl70lD14AistWt?=
 =?us-ascii?Q?EBM9REVfZ8iP7/CpHj4/PhBXUv9brakj1ay4L3nfkUZcQkcLcehdERdwZobK?=
 =?us-ascii?Q?RpJpxZxwAPvFhFRen7yprCg0F0+wMbxVn2qPuGmsSDvfh3M5fy2y39qjlOfI?=
 =?us-ascii?Q?CtIoXgeTS6SGgslOKuN0kmlc7IxjN0X2e+sWKG65S0/UWr7NIj/WLztwTAP0?=
 =?us-ascii?Q?c9Jria0inaKdxFPe0ifD2EO2DcEn1xJ5U8ldpniRhDLJp/ufB+rO7mXAub4E?=
 =?us-ascii?Q?bBWYwI4mnq8GsI5+6Id1msU4nNTwRPiyN1Tw/ZNEEk3hSwXqxlMx5zWzRlol?=
 =?us-ascii?Q?lRplTHKvSTVEXpUlEdoOrbtS8IacO72vvFp8Nck+NR2HBxcYv2Liou1Vg9uM?=
 =?us-ascii?Q?Hf9XN3sOH0uePxbxgFcJVHopMhTro3fZhAn8nIZ3wCfFvfcR/xR/JuBvkCR7?=
 =?us-ascii?Q?77ii13n7MmCNTmYiAt/sLpcaTFlbawbYCNFZLWgvH33SmGwaCXjFFB3DZxks?=
 =?us-ascii?Q?bKLZ0ru52kd3P1Uu9X33zr9y6y1Ul0rm9w8AC5494mtZKMtuBX563DtEU31a?=
 =?us-ascii?Q?rAU0nVF6sTc/E+GduDZ4CA+Z/mGMh3bU4RK/uTVJZmS9fhNCdqeSdZ4evjyL?=
 =?us-ascii?Q?4ummN3eI/Vig6vFDyow0BSch8bG9QTMjmFs6JH+kZgUrxpzul6MTiRDREVYk?=
 =?us-ascii?Q?V7Suv8HaxzSXS0Gb67LB3wgvv6t3dkjzIUVvF1kMoJKQyz2X/GeERtA+mdLs?=
 =?us-ascii?Q?0NNhJbMtmZTiOXTxHzMpqkBu7wWWtszKxyVVmtFSE1kBkGCJYkd99GGyfrk1?=
 =?us-ascii?Q?P1ESJ5J9vouFDx48VlGa4AaGO74+85kA5hpHyQyYxfa+Yzbc0L6BRMxSqTTC?=
 =?us-ascii?Q?uUZmqYw2DzOSsJlue+Goyvwakd9V7bmzlUL59pE+aqGhRMVi49dbrtl5U1d5?=
 =?us-ascii?Q?o4nnErAD6f4jXtFbKlkc3JirCQP5MBhv9Uemlb/rQeXQOg2j9ZBn7dO1Xh+O?=
 =?us-ascii?Q?1I1QAIyjdL7cok/6ge6JM/WJXTLdu34gQb0jo8zSkr1/FcElTKeq3OosgcIJ?=
 =?us-ascii?Q?0yJSbRAAGOv0oQDACC0ZHQQWCk1quHKdWyZgA4FoiMM0eoRCSnkn/qcEVkA4?=
 =?us-ascii?Q?i3ouWZ7bi3j0aEjmChO2SkdS5IyFhMOVHvQOrNa1NIYBTqRzshR5Jn+XvP8m?=
 =?us-ascii?Q?a0Tw4kIREVnT0OjWdlB/VHgJtQdI/hgs7J2B8e5riEeONMb1mZ9rgOzTK0HS?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce7aa9d-4be7-4132-c3dd-08da7a824a29
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:42:03.6184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjaYHOxfCKtnUdCjGJJahqvxbKrAwGMshBHpF0repcj8j4xGOaKvdlwDOX1Ao0g4DCR2A4GG0nvy9zwNkWvbUPbdwqVMFr1H/Nw1u5u5qVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: Ijf_fHSwBppAWlITy0MgSf8t4kot70Rs
X-Proofpoint-ORIG-GUID: Ijf_fHSwBppAWlITy0MgSf8t4kot70Rs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's several UAs for PGRs that will occur when releasing/preempting
reservations. If we get these with the pr_ops right now, we just log a
failure and return. For dm-multipath this is a waste because it will
end up trying a new path since it doesn't know what a UA is. For
userspace it's also a pain, because they end up just retrying. This
patch adds the PGR related UAs so scsi-ml just retries for us.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 573d926220c4..59528138328d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -634,6 +634,14 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
+		/*
+		 * Registration/reservations preempted or reservation
+		 * released.
+		 */
+		if (sshdr.asc == 0x2a &&
+		    (sshdr.ascq == 0x03 || sshdr.ascq == 0x04 ||
+		     sshdr.ascq == 0x05))
+			return NEEDS_RETRY;
 		/*
 		 * Pass the UA upwards for a determination in the completion
 		 * functions.
-- 
2.18.2

