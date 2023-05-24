Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E16DC7EE37
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 23:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbjEXXeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbjEXXeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 19:34:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9CB12B;
        Wed, 24 May 2023 16:34:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ONUTXd012706;
        Wed, 24 May 2023 23:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Arl852qeVvHDG0pqkOTsxY/WsVUKuZpNa9BcJBtkj+U=;
 b=y1plxDL8LKkrdWDajyMWQqXHZGSDKrKrLOprDKcy+hzrtGpXjrKoIu7AjmcWmz+BVJIC
 oMi4rw6Y2tTE9nIDxiF8ioRtWkRkYd35IJizFPGFrcW5zab0gq3pay9atBwOBhkeEYi8
 L0iuDyioQJNMxTDzrtwNXMdgaALn6Fqj93aYWCJ4OmPOQK7esfkAqi7utDrxN5tCQt0F
 CJnco8vYrNTp5AA4xn0Cw/sELpuYvkjnZGH7AsA9VABEjDYCHS3jhYupROubVMEKpAuK
 6rDYTvPI2YhKIVH5cQd07xTuPKQzEEedwahIqWqSvnOoAaICfna4+vLAVMe+4VTMdFL8 KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qsva4806d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34OMHrQI028521;
        Wed, 24 May 2023 23:34:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2t52hk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDoEaA41C1RVvRVZPVnLsmPyD+Yv7gteJ4PohsTWJYpOx5+DiMgm2K+sRNyDlGkCBGJqRWzIuhj3jQZYKomUb53s7HyV1c9Gbypc+Dtw7mtnzt/l9LC1OmK2iXI9oa5kRxTs0JKUQ67CEx5KkmcF5pLM1HbhybkYZnbVCV5Kmey9J/u+yT8vtDrV4gkrsznLkvl0bDV+WNEylYdE0be+15Tcq3U6zYnfnqWWNtDN571+58A/khF3BNKWtnWvEUkKjt1YDegSLPWzNNzdR8Kd9ZdEccY/e08zs2SqCxaS7KDx7pPRf+igxyRsHKMVA6nTdK6Ils0DNzhfl6EcC1mu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Arl852qeVvHDG0pqkOTsxY/WsVUKuZpNa9BcJBtkj+U=;
 b=gtjlbnd6fkE+Y66IqI6RyMtyTrtg70D3mhGovK3Q0VoiJExU1dVr0CtynG2ZWJaeHxruFdW+13edQwykr1g5n3XPn/9WLkHDycu+kC9PwfT7WKeTeDn59f6t7XLrz8mqwX833FejkxpmlY+xqXbvfMVw2VCyIAI5oKVWWVyb3LIccSrDQZX94+J9SNxSCi67F+Op5vFPo8UwDjnVJAc9VWAqEcgAM1aZadYog9zsYcnfdCjW2DXc4MTjQE9QWi6pRXokc7v2RIcX2Mgnc4+ux4va6i0X/fPNoSyCfW0Yrpg5k13QW6ek++BBXQd+ehU0TFcwOmgdBN1YnNiW57fmwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Arl852qeVvHDG0pqkOTsxY/WsVUKuZpNa9BcJBtkj+U=;
 b=Ynmw2NxEJ/+4jkBHVpsJdiBplXi3sTdGTMkGQNPwwrJoD+8m1cePzbWlEHefrLks4FQs5otJB17ulcTLaJickYsvxrJ0QpWRxuUYco488SRnUxNUELcMN5xGtcDPIPaDxHK67SdTGKWAUCxSXsRpFiBRPzfefTbYo/3RAeM40rI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 23:34:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 23:34:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/3] vhost-scsi: Fix alignment handling with windows
Date:   Wed, 24 May 2023 18:34:05 -0500
Message-Id: <20230524233407.41432-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524233407.41432-1-michael.christie@oracle.com>
References: <20230524233407.41432-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:5:74::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 9873608d-a580-40d7-1a04-08db5caf60f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KeD/nap5Lbun7Dn0QJxuZOP9Ecu3ecQRtkOSrimRLFPUZF8bFFw+kgyVJhhhSGCeYPEsWai+p1Tslv8PQM6YFaOrra5dHqH2UO/L2BITxwfWp9OGnq1Pcvovqn55hT8t/5un/UR75u5x5MZmIyi3nvKb01kFdi4PqkZTmqDB+ijPctNqU7l2LyZnWW5ZEHCNuvTbN/XbSai1PxoN9T/Lts3ao6H7aXszQkEph95qqvolTKSgsPhXJdjd36sOg/Kfnzk46aol78gT91XO33YDoEq3cToPNOJoBjhTKXWGuHaGFadBqUzO/1WbIlPuw98n+ThkSLV9S769QBivUAwaptPbeIOQg+utwz7z9xoyudi3JekKFJUdzhCP0QrGdoZGyoiGDx5WaZeybec8fQMEu/zd2uX6PqLIPDYIwEWP38nfmx1iaervsJUhvtsVdqYfv8cksSUZnlTcwBncb1b+yEY5KolULtxNcdmmdm5wpMim5vrweciyn98u7yqwEFMbOvPiJLTUvwASTNO/wHuTnCx+BqiwbTmjriuGRx50zQQ0zW2PXx9YzQS2vVk3193l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199021)(2906002)(5660300002)(8936002)(8676002)(316002)(41300700001)(66556008)(4326008)(66476007)(478600001)(66946007)(6486002)(36756003)(6666004)(6512007)(6506007)(26005)(2616005)(1076003)(86362001)(38100700002)(186003)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eucvvrRp92lVZUx1Bh+HIzbr9SokZU5nmtC9vp/jtFmAK6VSWyJeqj+i+o6m?=
 =?us-ascii?Q?MRf44ui5NJtci2XpCAweGZkd0b00N6DFGQx1oWZDEk9TZOxX1Mv+OgbJfGz9?=
 =?us-ascii?Q?kxptbD3vnqafefwY7mIfjAZWwXjYH0NcTCmnYhW1kyyQTcJNg25hebJ5mUAL?=
 =?us-ascii?Q?GKAVJBwjZoadfL8NwbdDStv/uzO8Vfvm/vPYoesBqORgzZng0b5gM5ao/y2x?=
 =?us-ascii?Q?mXF1bd0EdK4PAZGqowwxp+152Uzvmwv3bMQ8wTYRVAU4aM29fhPW1KqZ2Kjn?=
 =?us-ascii?Q?N+oub8Le61cz72HUIxa1qpYMR/Plh5r4M1WzvseQu3vQBdBqtoozd04Q5ATG?=
 =?us-ascii?Q?A7ppLB5CnOADWwyydUyYggo16j3YofbQ1rz7GcbiSEsREtJs804u3bYCMBwD?=
 =?us-ascii?Q?txAOC2OEH4CMjFaKdx6aorzEPGyt/l6ESrQW/tgO/W0YhYAGaQyVvx93sxxp?=
 =?us-ascii?Q?RytIZEXiN0dFzuy5rtE93So77F9AnHxrPFy3NL6cVCHwwTwwQp0M6G7w6+E0?=
 =?us-ascii?Q?yE0Yb81frsPnEwXwNMKzw3ml6CCplI0ZQSbAmcj+cn5Cyf9pjlX322E0bFfr?=
 =?us-ascii?Q?GaaZl/vNrFszPodF0ZIL05cULBhesfwTfK9SLvvGLfboGc/rqsY7pB5mPkyJ?=
 =?us-ascii?Q?sKPpG9rGM3JHSK2B5i5smiLCEbJLbmF4PUilvg9/0ZZwHow5zm8nDQng0KhH?=
 =?us-ascii?Q?CdXtj9cMLUzG++BEbgAc9KlXlAntpOijaeMPO2tPaWnQ8yLuJYKUdiUK9U5S?=
 =?us-ascii?Q?MEGL/QTIu1ldc8CGjcxLl/bqEiiOISREaHaJMc5fyjchxew4ZpU+2QJdY6m5?=
 =?us-ascii?Q?1d3csUqAhQPCgTZktUt760+zDCgHmpn6R3YtyDhbBYBjnLg0GQoepprXF8tc?=
 =?us-ascii?Q?aoRlZ2gvfsmoMu0fSkfLkeKcb01xzMqq5qki2mRvtP6zE2j97n3qer20eSWm?=
 =?us-ascii?Q?wST9WkNyRk+rTSISYUibERAnW5mgtSwXSJ2KOGe8th6HP+vF3DyOA1+5U/+e?=
 =?us-ascii?Q?lAsV1BckLcnepT65jonPRoh1NYKdXLTT7rOQlLI4ku0wVbYlGHhboUQJmKUw?=
 =?us-ascii?Q?F1WY37Snyz2XoGYMUbXt0Gt/JCtqNZLkVvd2T0QZMFvxn5huJkzDovLLatvr?=
 =?us-ascii?Q?NOJBonT4LiWgYkRGR4NBByfrPBNs3QKlS3i8Dx0D+zueo2sMFkJkPh+Sd6uX?=
 =?us-ascii?Q?XIrYATsrMSAZjsmJmUHw7nxXV/i94964T7L26Sqnn0ZTmWnmmSxdt+YBkhhR?=
 =?us-ascii?Q?WfHncYpl/6A/feEO43Z2QWFfonB3UwqSMLHln1Zn3JAUNoUfSP0JiQ8pJZWv?=
 =?us-ascii?Q?sOvtfnRVPhf2U8fU7kw1qtaTeGPyGh+5FWTo8m9qcC8FVYVfaBx5zFNCL+s5?=
 =?us-ascii?Q?zaW5DqdstZS0zmzaih8XUZijNEFRXXM983DmLM1aquQiUnco4CphS3/mO/yT?=
 =?us-ascii?Q?xogXqsr77l3IKGRLyhlAhp/EhlmqgyN50ttiaD9LUaIV35CtaMUAv/+Tpte0?=
 =?us-ascii?Q?R9cfH5qcqSB/X15rFEWsdEdqEz8Ii0eitMZGAhPV2RSUUp1PagXqoIvJcKJH?=
 =?us-ascii?Q?AZBWpLqHK48lAZmUGUyx4RtHSXKYVJeKK2PlGkDIqiWKzXzJ8ktpX20/KEGg?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KckTUkx/IFIIpw4quC7ijNSpBEgYv7nBzIRShk56Wm4RFeNjJu9YDL6iKYNLQisuA10ogJ5eOsg+jNY+OE0NjBF0IF0Kbd9sZ7B4zcawt54WbyDS7FU1DB9dPjF3CQNzhxgiYqh9yNFimVKSENtA1TUM61jTWSwL12QxpJHy9wEkuPbajD3Kneoo9wJQ/r3TX1D0Ln5OCQ7PUpjBDVfTNbhvl1EqbexHTQwLMizu/kK1uOkwye8ZsWXnPnqCTfGG49PANpFArfg4G2K6CuZ+BOpW4TwSrk+9wxUkY3Qqx0rU3f99l9Jk57SRWp1dXn6p/DKXFcZj6RiXLM7u/tZXc7Q0cWJRGco7QA1qq9z8egy38OvdI6Y3fBO84QOJiZI1oP8zgxdIB4apzgr4GEB1W7zjvb+oJOziIibX0gXCWBCNUNxsNAowquSI6R+8N4hU7VdbQmrt2Wn0j+sCtergeMcqs6XBvgdPYbyl9LSYJfubOJN2C1yPMQAbnG90gYtN/4THdQmNPIN/WzbXovFjLBQcn5lGtLkjzXgw9TV5jfUK0vbLmKvQ+U9Wj1W55W1dB4Tn4zNjQIE0hJOT+giGf8+LyoSqTI54bD3W7W2Scre2LCMtlnNAyMHk7xfZSHoxcz0SVY5lOiVA/SjRa7Tke9XTzXwoImSOAh4xXssaDUwyOH8h9y4HmVqVO2jKQovhp1XR1rc210/KH819XI8rn3U/MTLFuvIg36AgGjrqJNGpE3Z9x1Gt4By5Dni8eEVuNOwB4bU//AIkZK29zuoVLJc0j1Co/LCTddXqhYwUBjthlXsa15xlj08A+uf5H18w8cThoh92rvfzpVQMDHxWL1Miy4zA3EOeJfEl3OzZxPk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9873608d-a580-40d7-1a04-08db5caf60f3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 23:34:12.0364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3oAjYgTPFTjcne9nWW1eZ695vHdHBKJEp/Kb2DW5EXovX+XLMFvMbms2nyT0nxCMrFjfEaszdATlLSURduaDXbY4Wy4srSZMdEBzTgZSG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_16,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305240197
X-Proofpoint-GUID: QaTvh_86HisHrpzg8WckD52uzClHfiaD
X-Proofpoint-ORIG-GUID: QaTvh_86HisHrpzg8WckD52uzClHfiaD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The linux block layer requires bios/requests to have lengths with a 512
byte alignment. Some drivers/layers like dm-crypt and the directi IO code
will test for it and just fail. Other drivers like SCSI just assume the
requirement is met and will end up in infinte retry loops. The problem
for drivers like SCSI is that it uses functions like blk_rq_cur_sectors
and blk_rq_sectors which divide the request's length by 512. If there's
lefovers then it just gets dropped. But other code in the block/scsi
layer may use blk_rq_bytes/blk_rq_cur_bytes and end up thinking there is
still data left and try to retry the cmd. We can then end up getting
stuck in retry loops where part of the block/scsi thinks there is data
left, but other parts think we want to do IOs of zero length.

Linux will always check for alignment, but windows will not. When
vhost-scsi then translates the iovec it gets from a windows guest to a
scatterlist, we can end up with sg items where the sg->length is not
divisible by 512 due to the misaligned offset:

sg[0].offset = 255;
sg[0].length = 3841;
sg...
sg[N].offset = 0;
sg[N].length = 255;

When the lio backends then convert the SG to bios or other iovecs, we
end up sending them with the same misaligned values and can hit the
issues above.

This just has us drop down to allocating a temp page and copying the data
when this happens. Because this adds a check that needs to loop over the
iovec in the main IO path, this patch adds an attribute that can be turned
on for just windows.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 174 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 151 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index bb10fa4bb4f6..dbad8fb579eb 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -25,6 +25,8 @@
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
+#include <linux/blk_types.h>
+#include <linux/bio.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -75,6 +77,9 @@ struct vhost_scsi_cmd {
 	u32 tvc_prot_sgl_count;
 	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
 	u32 tvc_lun;
+	u32 copied_iov:1;
+	const void *saved_iter_addr;
+	struct iov_iter saved_iter;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
@@ -107,6 +112,7 @@ struct vhost_scsi_nexus {
 struct vhost_scsi_tpg {
 	/* Vhost port target portal group tag for TCM */
 	u16 tport_tpgt;
+	bool check_io_alignment;
 	/* Used to track number of TPG Port/Lun Links wrt to explict I_T Nexus shutdown */
 	int tv_tpg_port_count;
 	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
@@ -328,8 +334,13 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
-		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		for (i = 0; i < tv_cmd->tvc_sgl_count; i++) {
+			if (tv_cmd->copied_iov)
+				__free_page(sg_page(&tv_cmd->tvc_sgl[i]));
+			else
+				put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		}
+		kfree(tv_cmd->saved_iter_addr);
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
 		for (i = 0; i < tv_cmd->tvc_prot_sgl_count; i++)
@@ -502,6 +513,27 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	mutex_unlock(&vq->mutex);
 }
 
+static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
+{
+	struct iov_iter *iter = &cmd->saved_iter;
+	struct scatterlist *sg = cmd->tvc_sgl;
+	struct page *page;
+	size_t len;
+	int i;
+
+	for (i = 0; i < cmd->tvc_sgl_count; i++) {
+		page = sg_page(&sg[i]);
+		len = sg[i].length;
+
+		if (copy_page_to_iter(page, 0, len, iter) != len) {
+			pr_err("Could not copy data. Error %lu\n", len);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 /* Fill in status and signal that we are done processing this command
  *
  * This is scheduled in the vhost work queue so we are called with the owner
@@ -525,15 +557,20 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 
 		pr_debug("%s tv_cmd %p resid %u status %#02x\n", __func__,
 			cmd, se_cmd->residual_count, se_cmd->scsi_status);
-
 		memset(&v_rsp, 0, sizeof(v_rsp));
-		v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq, se_cmd->residual_count);
-		/* TODO is status_qualifier field needed? */
-		v_rsp.status = se_cmd->scsi_status;
-		v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
-						 se_cmd->scsi_sense_length);
-		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
-		       se_cmd->scsi_sense_length);
+
+		if (cmd->saved_iter_addr && vhost_scsi_copy_sgl_to_iov(cmd)) {
+			v_rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
+		} else {
+			v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq,
+						     se_cmd->residual_count);
+			/* TODO is status_qualifier field needed? */
+			v_rsp.status = se_cmd->scsi_status;
+			v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
+							 se_cmd->scsi_sense_length);
+			memcpy(v_rsp.sense, cmd->tvc_sense_buf,
+			       se_cmd->scsi_sense_length);
+		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
@@ -682,7 +719,52 @@ vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
 }
 
 static int
-vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
+vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+			   struct scatterlist *sg, int sg_count)
+{
+	size_t len = iov_iter_count(iter);
+	unsigned int nbytes = 0;
+	struct page *page;
+	int i;
+
+	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
+		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
+						GFP_KERNEL);
+		if (!cmd->saved_iter_addr)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < sg_count; i++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			i--;
+			goto err;
+		}
+
+		nbytes = min_t(unsigned int, PAGE_SIZE, len);
+		sg_set_page(&sg[i], page, nbytes, 0);
+
+		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+			goto err;
+
+		len -= nbytes;
+	}
+
+	cmd->copied_iov = 1;
+	return 0;
+
+err:
+	pr_err("Could not read %u bytes\n", nbytes);
+
+	for (; i >= 0; i--)
+		__free_page(sg_page(&sg[i]));
+	kfree(cmd->saved_iter_addr);
+	return -ENOMEM;
+}
+
+static int
+vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		 size_t prot_bytes, struct iov_iter *prot_iter,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
@@ -703,10 +785,8 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iter,
 					    cmd->tvc_prot_sgl,
 					    cmd->tvc_prot_sgl_count);
-		if (ret < 0) {
-			cmd->tvc_prot_sgl_count = 0;
-			return ret;
-		}
+		if (ret < 0)
+			goto map_fail;
 	}
 	sgl_count = vhost_scsi_calc_sgls(data_iter, data_bytes,
 					 VHOST_SCSI_PREALLOC_SGLS);
@@ -717,14 +797,32 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 	cmd->tvc_sgl_count = sgl_count;
 	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
 		  cmd->tvc_sgl, cmd->tvc_sgl_count);
+	/*
+	 * The block layer requires bios/requests to be a multiple of 512 bytes,
+	 * but Windows can send us vecs that are misaligned. This can result
+	 * in bios and later requests with misaligned sizes if we have to break
+	 * up a cmd into multiple bios.
+	 *
+	 * We currently only break up a command into multiple bios if we hit
+	 * the vec/seg limit, so check if our sgl_count is greater than the max
+	 * and if a vec in the cmd has a misaligned size.
+	 */
+	if (tpg->check_io_alignment &&
+	    (!iov_iter_is_aligned(data_iter, 0, SECTOR_SIZE - 1) &&
+	     bio_max_segs(sgl_count) != sgl_count))
+		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+						 cmd->tvc_sgl_count);
+	else
+		ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
+					    cmd->tvc_sgl, cmd->tvc_sgl_count);
+	if (ret)
+		goto map_fail;
 
-	ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
-				    cmd->tvc_sgl, cmd->tvc_sgl_count);
-	if (ret < 0) {
-		cmd->tvc_sgl_count = 0;
-		return ret;
-	}
 	return 0;
+
+map_fail:
+	cmd->tvc_sgl_count = 0;
+	return ret;
 }
 
 static int vhost_scsi_to_tcm_attr(int attr)
@@ -1077,7 +1175,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			if (unlikely(vhost_scsi_mapal(cmd, prot_bytes,
+			if (unlikely(vhost_scsi_mapal(tpg, cmd, prot_bytes,
 						      &prot_iter, exp_data_len,
 						      &data_iter))) {
 				vq_err(vq, "Failed to map iov to sgl\n");
@@ -2068,11 +2166,41 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
 
 	return sysfs_emit(page, "%d\n", tpg->tv_fabric_prot_type);
 }
-
 CONFIGFS_ATTR(vhost_scsi_tpg_attrib_, fabric_prot_type);
 
+static ssize_t
+vhost_scsi_tpg_attrib_check_io_alignment_store(struct config_item *item,
+					       const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg, struct vhost_scsi_tpg,
+						  se_tpg);
+	bool val;
+	int ret;
+
+	ret = kstrtobool(page, &val);
+	if (ret)
+		return ret;
+
+	tpg->check_io_alignment = val;
+	return count;
+}
+
+static ssize_t
+vhost_scsi_tpg_attrib_check_io_alignment_show(struct config_item *item,
+					      char *page)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg, struct vhost_scsi_tpg,
+						  se_tpg);
+
+	return sysfs_emit(page, "%d\n", tpg->check_io_alignment);
+}
+CONFIGFS_ATTR(vhost_scsi_tpg_attrib_, check_io_alignment);
+
 static struct configfs_attribute *vhost_scsi_tpg_attrib_attrs[] = {
 	&vhost_scsi_tpg_attrib_attr_fabric_prot_type,
+	&vhost_scsi_tpg_attrib_attr_check_io_alignment,
 	NULL,
 };
 
-- 
2.25.1

