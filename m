Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31422EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjGJVo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjGJVoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:44:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A381F4;
        Mon, 10 Jul 2023 14:44:53 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AHqb7e024185;
        Mon, 10 Jul 2023 21:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=TZcmWkwppHOTgwEw40D5F6qGsMUpTMVQjjTMrBGj/Nw=;
 b=WWfOskzNpPPzB4oGbf6z+lmvKdkNSt3HJ+izrDWf526Hwl6otf9/E0FjMoNRDEm5nXZs
 78sHHbjfGHJfKuj31HatnIf4euBuN1SOJjH4WE/wpF4sT9QQSWVh0v8fILdV4/XYmNky
 amTuIxapNgK1Y8WHyQ9Y3BKSjN54qxC3gcLRfpuG7JtsJI2Nc9y7qngr3iFs+tDjpfTh
 KWNxgTQ07MRFMfahypGol72FXoZbqag0g6Rpsv0TLxP2zoIAa83FoiIYfU7CK2XfED4g
 ENqoEm201cbowRGFRrk2CoDxeR2g6p8FRoDK2sDnud3rLe6TI9T2OjqQFCX30Fs8q4+1 bQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7sc81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALJZIh022812;
        Mon, 10 Jul 2023 21:44:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841rqk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlD242uME2l07wNImz3eyelxtbebaNEuLov34A999cvBViL0jnAe6kQVJ4dKbBKwz6REyYH4I6u4Qdu5TPwAy+Q3hzUQQkFMmypgeheNawHIZqZzGIB7ype0ttA1yrGmikEtGtjFXJfWgBsk4sI3Sv+mrzuusjgA9L5Nxo1hrnZD7lsRmvMAafqirDxPfNBlOMCYMyBNUpa9QQ8Mc+2wWH0iFG+YB1XctW18TsFKxQDaa/Z8y5d4VnUQTwX2c6Lhfz6VyqFxySauX1nYrjQyw+it50NNTtzG2z7DUx8V5+T8Hp+UdGr6zMsxkzSRfErUDSE1N+A29/Jg+Wxz7VeILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZcmWkwppHOTgwEw40D5F6qGsMUpTMVQjjTMrBGj/Nw=;
 b=QB1gPy6DK7lGE8+t7bg+a3EmaKs7HyIE0sXboazcGprP6/4WsSVS6xLXPMEroSjcmutnMUgF/t5SnfbknNHnWKmF2QEkSygY46jSYvYIFoQI9SI9SQBcO2Gqoz4yTOYYXmr8500Q0W9eUPosCHCtJmNA68ryCDCWyukuyZbDejgYg+hfRknLJ9qlsq3Uho6xPhpZvIH/ffd3e4mGfRaAH5z/In93aThtnGe/7xlKy7JgiVhyedzRoWc2vFimMY/zydHbyX/MFzUmGEtzKC9UgUNF+wO5P9mbyciPn16C/460L8DvyVOpRrw3GO0mX3PMChHJiw3g+kbpfgZgqyZDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZcmWkwppHOTgwEw40D5F6qGsMUpTMVQjjTMrBGj/Nw=;
 b=F5saBIIQb4QT6PH/9QrnX7k//SKk+Gh9XTr77FQSh+0YVXRf6y+olBmnkVX4HoCqchczQAB2eXMvoRT4j8mTQofEZyicypOJvx0wWIUp3oa4Gjn2Pg7Snwf7x7Q+vgfdsbdDHQ4oRHZW38dfEfR5mkbC+AGfagu0GAvPzTcyfpU=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Mon, 10 Jul
 2023 21:44:51 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/5] scsi: target: Allow userspace to request direct submissions
Date:   Mon, 10 Jul 2023 16:44:40 -0500
Message-Id: <20230710214442.6718-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710214442.6718-1-michael.christie@oracle.com>
References: <20230710214442.6718-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:610:74::21) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 79e75a8d-440d-4d75-9d02-08db818ee3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWhqL61kjJmFtez2X0KNV+c5VGw2lhStGgousMYnoHDZ959laTiu/Zvh1khr2gw6zOx50/TkSu/1wQpLlM4M2tSo6WA9RjCOg93GEAv0x7ooUB1XyuDcekY+7Y7yeR8x0kITjCw8wYR33ejouafItTt+11McEqYUuvcEXM37ErhD2hkMguTUCBZ9ZLP2hjXKOBBomH/9VPBpx7FysBCOgxwc69Dnwa4Svd0DNaX7DOm6oS/Vx0jYw8UfuQz1omQUoFWasH7GfPh0Zi4/4p1KLmPeUj05aVSE4AbpG4H66wGpgo0g3VQuJbGULU8zQ1Ep/yk5/YYq17oJUpOZiFH0WmEWBQlz4WtIE4/S89we8M7W3+tbOI4GuYMsHksQvZv2EHRnwf+WNLboIOIy4siMXpM2C8SK9NzuA5MBNmnPGqR899bNN8pCMVAdlgjsoB8CMXV9KSDUzfLVezwQ62fZoo67+MKPPpsaCwywfkx1+iU/7kWkc+L6Ty4YTXOIzqAu1LbnjowfGCNwoLj3LRZfKfs90dvG7ypyvHvRfHdshv8apb5o8VW/UJli/8KvUhmh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(478600001)(6666004)(6486002)(8936002)(83380400001)(8676002)(41300700001)(2906002)(316002)(38100700002)(6512007)(5660300002)(26005)(186003)(86362001)(36756003)(107886003)(2616005)(1076003)(6506007)(66946007)(4326008)(66556008)(66476007)(450100002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXoM+Ra0KOltlvveVJW8yJb0yCF3Gpz3gslpVpYpoESvChsBuwlHwpcm1pLK?=
 =?us-ascii?Q?KXPYfqDmXeNbTUTM6Pp0eUeP+qMm+ogM72nTh2BL9l03DT+fbokdtvif387H?=
 =?us-ascii?Q?ACucj3Ytgpho2IxWgyGG6CIWmSp85g15wQNFWiKsZ9rYhkdT8CHVQMa+ykMT?=
 =?us-ascii?Q?cmGqtP2JTcLO5FF2A0q9ir53/vzm2wR2KWfx8jlWhwvzkDV0NbwlscI7Lo5Y?=
 =?us-ascii?Q?jSrbs6Dc43MGF0J1jh3IKXmXohL+/TAvR4Al4PnU9Auz5qJfx3XnTeqNjkNE?=
 =?us-ascii?Q?6h/phvVfn61bORvZxfGGPNzL97mVBEpnoJ/AcTtzHYnLEVayrh2p/2ShiDoz?=
 =?us-ascii?Q?hKIpgjVaYbLa9Rky8YHfL2eWFdHcizLTCr0y8mkhMOQCEK9dyF2CtNKOsJWu?=
 =?us-ascii?Q?2VUpUYCTpT7SggZXVPWSCocgEGsbKFYhpkG4DJeGV26vDJSiPFN+MujB85yc?=
 =?us-ascii?Q?JMUWpCnjQTOm3FHcAuAGYKTxyk268aWtmAAePg1AvjNhy/MPb0GXcSVLUIgm?=
 =?us-ascii?Q?qtFZZUoy3wZSOBMTwK/7YtswxFDkiu7GHoiZC0FJ4PYQl1bnYAw4x0QhTRck?=
 =?us-ascii?Q?rh4tZ+DD0pbCgvnwge5ThFekDCrqqlqTrMsllIylYoX/H8CWi42HSps+bnOD?=
 =?us-ascii?Q?n0xF4sjl6VXbiJLOyXdVkLUFzkzQFdSloPz3ZZR64uI8csFnC+5Flf2uvWQ1?=
 =?us-ascii?Q?S78GffyoW8Kcbal5WpfsXs437tcg3ux4PmRIeVB3gfRLhXXEqunaQhfwuG3e?=
 =?us-ascii?Q?YwZCPzGeFCEhMiWuwLZ0QDBTKiE60zOwRqQxpi6uKq7guHlSoKNHgE7ctWqc?=
 =?us-ascii?Q?0bDjR2mDLtExORGhnrY7DKfSi2ocqup1xSv9ElhUfyHm8tEqBQPIAwm7b1Id?=
 =?us-ascii?Q?uCCtEN4JCyMCMnMBVlgE2NCP89UFDBcICGexcu+BZahSp31q4xQZ5iSKoc2J?=
 =?us-ascii?Q?LRH0Qmex//DWaYmeaf1Y6ZiLClIIjsh/TXAscqzyc9w8iH/4vi4YCnQ5qeJy?=
 =?us-ascii?Q?SHPZeBEcjCSOS53g0ndZIIKHIBn7klWOnpJqJVprE6sXzRDSQA9bPyAL6WBc?=
 =?us-ascii?Q?q7omfxLw3+YzKKhb+Z2e35D09+ZBlUFmHSCDo1EXjvaVw7iSTEnBsNNsboM2?=
 =?us-ascii?Q?hWYJ6YTFjygXElxqDDhc7CesFLs5DFgMUTuaAFcvlhshn7OqC7DKpfnb5eLa?=
 =?us-ascii?Q?HlvLbWzJYjXiC6CcsvjUVYHgSImUtXMCKs9sDiCn4hIRVvz3P38a8QukgLCg?=
 =?us-ascii?Q?B3SbP0F2FLzZj0rdpFNammOZQbGS1KqhEelQBY+7sLqaqba4zJiQo7J2qtYP?=
 =?us-ascii?Q?yABgN3FyhJ7hpvwrLe08hptGs4rmVGUzKNmYX0dzRC0qMTEsbROxKrkT1ydp?=
 =?us-ascii?Q?mM6BHzezclP8uz9kZnOXQptmf6zkNp9/uDb6c7H31jbxXywQTErhAWMk5eKX?=
 =?us-ascii?Q?q/jAcokXyVNqo2sfoG46eipJJLR226hD1SqU4/vgpIYlEBO3NC0eeVy+QfIe?=
 =?us-ascii?Q?G13i+1Htdi2NrqLhvYJvejjINOCjRnlqB/0ZUTysCj+R5vK8OlG3LE6dsRbj?=
 =?us-ascii?Q?/jnRijJ+tOdGusexm7n3dPnlDDxG87Thpz88Iwha0cf4idcmipnnfIqGOMr2?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: B6T4fJoIwSfbXooy16yT0Yv1XDwYKjZlpyKpbYj/aGqLw67JA5qOrp8W+Abz81nxYn+VHgCcyQGFdBYDDMafM0XUaY7nkRI/EtwFBXaqNaIRq6rHp7YTOylYIxcizO1egzDK8OMm2786ysd0wg8rA0ELTZ8MS655Ji94a30BhTZzFmb4X00NvOYWF427oyr9zt0isM1A/5N99J09hVIrAX5MmwFBUovGfHKZt8Vnj5nzkwET07JbppWWkljYkl69eSJMyjQ6dBwRewi9dDYj9/dsiTMm/pL8g8JgBszRjsp8FWR/fyrTclnTpCQomFlrkY3O5QFZCSKtyr6JyUDzp3WzL3gZ1dMYYSbT5CttO8UcaH9orHyHsc4qTQuakKiY4vseRpTvTfo916ycqOoo/1yAOnHwUhRDkRSsyAWbeTu0S7XnbieoetnV5Igu2krFHTxECZT7JC3fhHyG5vwSMwUlzMTJU6AjW3N23glL0tnfqkSTLL4O3atniUfaavShm45xtqRFihza/6I2LqTDEdEXAMUx57XjJEX5oDi6jsy1a1sMwXXUzm7IY+o77tpQrDgHqIiLp2jVi5vT3bBCRJuAF9W9QTN3FE8dFLus/HYymZTJjoJZR73+kvBjzGzcAvDlOQIXP9hBDCdhSBD4IcsWSTug+GGAsV3ZlTnRsYh26MHr0nrmkhT8alx1qWQWoT8IfTBpXuiBJkJzQSd4//n2kJzgRMl1H6Za4ExY3d3812CbxkNQva0NK/9S06INeb0VVTTpjLp6GZq3iQpKaQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e75a8d-440d-4d75-9d02-08db818ee3ba
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:51.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jf4i2d5FmJLvQJcUazKj8QWLpRteHSbNIrpWlYnw/Up3reb6iakbHfW4KRKrgce1jqcEYBGS0NpPfFjpffMzVMXRfDYwD5AKLN6qSuf/QB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100198
X-Proofpoint-ORIG-GUID: vtTRgY0StzYrzSBWW94c_STnl8kWFivR
X-Proofpoint-GUID: vtTRgY0StzYrzSBWW94c_STnl8kWFivR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows userspace to request the fabric drivers do direct submissions
if they support it.

When using a nvme drive and vhost-scsi we see around a 20% improvement
in 4K IOs:

fio jobs        1       2       4       8       10
--------------------------------------------------
defer           94K     190K    394K    770K    890K
direct          128K    252K    488K    950K    -

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c     |  2 +-
 drivers/target/target_core_configfs.c  |  5 ++++
 drivers/target/target_core_device.c    |  1 +
 drivers/target/target_core_transport.c | 33 +++++++++++++++++++++++---
 drivers/vhost/scsi.c                   |  2 +-
 include/target/target_core_base.h      |  5 ++++
 6 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 75804303b175..fbbf80ae9766 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -154,7 +154,7 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 			       GFP_ATOMIC))
 		return;
 
-	target_queue_submission(se_cmd);
+	target_submit(se_cmd);
 	return;
 
 out_done:
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 936e5ff1b209..e4ddd8882f83 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -577,6 +577,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
+DEF_CONFIGFS_ATTRIB_SHOW(direct_submit);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -598,6 +599,7 @@ DEF_CONFIGFS_ATTRIB_STORE_U32(max_unmap_block_desc_count);
 DEF_CONFIGFS_ATTRIB_STORE_U32(unmap_granularity);
 DEF_CONFIGFS_ATTRIB_STORE_U32(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_STORE_U32(max_write_same_len);
+DEF_CONFIGFS_ATTRIB_STORE_U32(direct_submit);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_BOOL(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,	\
@@ -1266,6 +1268,7 @@ CONFIGFS_ATTR(, unmap_zeroes_data);
 CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
+CONFIGFS_ATTR(, direct_submit);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
@@ -1308,6 +1311,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_alua_support,
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
+	&attr_direct_submit,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
@@ -1325,6 +1329,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_emulate_pr,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_direct_submit,
 	NULL,
 };
 EXPORT_SYMBOL(passthrough_attrib_attrs);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b7ac60f4a219..b4c3e17ebfc9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -779,6 +779,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.unmap_zeroes_data =
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
+	dev->dev_attrib.direct_submit = DA_FABRIC_DEFAULT_SUBMIT;
 
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 687adc9e086c..5349a2dd8187 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1781,13 +1781,13 @@ int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
 EXPORT_SYMBOL_GPL(target_submit_prep);
 
 /**
- * target_submit - perform final initialization and submit cmd to LIO core
+ * __target_submit - perform final initialization and submit cmd to LIO core
  * @se_cmd: command descriptor to submit
  *
  * target_submit_prep must have been called on the cmd, and this must be
  * called from process context.
  */
-void target_submit(struct se_cmd *se_cmd)
+static void __target_submit(struct se_cmd *se_cmd)
 {
 	struct scatterlist *sgl = se_cmd->t_data_sg;
 	unsigned char *buf = NULL;
@@ -1825,6 +1825,33 @@ void target_submit(struct se_cmd *se_cmd)
 
 	transport_handle_cdb_direct(se_cmd);
 }
+
+/**
+ * target_submit - submit cmd to LIO core or queue it's submission
+ * @se_cmd: command descriptor to submit
+ */
+void target_submit(struct se_cmd *se_cmd)
+{
+	struct se_dev_attrib *da = &se_cmd->se_dev->dev_attrib;
+	u32 direct_submit;
+
+	if (da->direct_submit == DA_FABRIC_DEFAULT_SUBMIT) {
+		if (se_cmd->se_sess->se_tpg->se_tpg_tfo->default_direct_submit)
+			direct_submit = DA_DIRECT_SUBMIT;
+		else
+			direct_submit = DA_QUEUE_SUBMIT;
+	} else if (da->direct_submit == DA_DIRECT_SUBMIT &&
+		   se_cmd->se_sess->se_tpg->se_tpg_tfo->direct_submit_supp) {
+		direct_submit = DA_DIRECT_SUBMIT;
+	} else {
+		direct_submit = DA_QUEUE_SUBMIT;
+	}
+
+	if (direct_submit == DA_DIRECT_SUBMIT)
+		__target_submit(se_cmd);
+	else
+		target_queue_submission(se_cmd);
+}
 EXPORT_SYMBOL_GPL(target_submit);
 
 /**
@@ -1922,7 +1949,7 @@ void target_queued_submit_work(struct work_struct *work)
 			se_plug = target_plug_device(se_dev);
 		}
 
-		target_submit(se_cmd);
+		__target_submit(se_cmd);
 	}
 
 	if (se_plug)
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ed6cc84c0b85..e2603eb1b638 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -772,7 +772,7 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
 
-	target_queue_submission(se_cmd);
+	target_submit(se_cmd);
 }
 
 static void
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 159567359bbb..4f37324ada5d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -103,6 +103,10 @@
 #define DA_IS_NONROT				0
 /* Queue Algorithm Modifier default for restricted reordering in control mode page */
 #define DA_EMULATE_REST_REORD			0
+/* Command submission settings */
+#define DA_FABRIC_DEFAULT_SUBMIT		0
+#define DA_DIRECT_SUBMIT			1
+#define DA_QUEUE_SUBMIT				2
 
 #define SE_INQUIRY_BUF				1024
 #define SE_MODE_PAGE_BUF			512
@@ -717,6 +721,7 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		direct_submit;
 	struct se_device *da_dev;
 	struct config_group da_group;
 };
-- 
2.34.1

