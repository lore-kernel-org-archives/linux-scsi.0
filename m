Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F24C25B0C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiHIAE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244477AbiHIAEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844E418E13;
        Mon,  8 Aug 2022 17:04:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGF020677;
        Tue, 9 Aug 2022 00:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Gw08AuZkpmpYZy3bhAUFnhOjUW1qYsumfDBhP64yZ44=;
 b=jy9wT7BQErwMBdO8yDdt2RfoFm/GH+6DGhSMrmOGjws91lp+Tb71ljGQKysqFADUSBY/
 BTEROSY7Nzmlg4WEwTGlz713NV12JlySoTePnJ/ZXMh/vuuiJP0DAPH6R7+y6qHdHHrf
 y14FOpC/PPhoELvDdnzm3QfGlrrAHmvK7GgbFOEVmnM2vN2eZy1uZyhFluaI9MCQDEX+
 pGEzKmDyFPcp5DkFLeG4ghjVasWlY1BQgAFX7ydpz+wRcLDq0qLMf6XtdSDHslFvb57f
 gQRU1lhVRAvYJDOFrq3Ty1CmUgNipGiYGkn0EKfmAgH/kYqdiiVMDQuJcTU6lJ4U+vPd 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0h7n011564;
        Tue, 9 Aug 2022 00:04:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser26u66-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmSWTwVOsWl/O0j5AIbNLgxdJZymKaEHu0WP2NPTPyHiz5P5UGB2ksGjpEloz1WU9ttX4a+0b2OceG1l7TUJgCMvNi5ayiduMf8G0dLUuungnUKdjrU6s0Ey3HFMxl9KVxeXxIShRpB6PVxRu4G8EMw+WJbJ+WvIp/K9MJw9YKy9aiPI01qmYxQrNbERzQ48IXGk4rLbFz3BCCOHXXiqS2VplxeEEHEcYAYlr0RaaduI0lvXVdbBHOWjop5icMaLe/gRCtlP/EjAQHk0LTAFmOM0kC751ftFDlUzth7gSLoLV/68tNAKrrmTLU8KVGAm0m6mfwpYf1xEY/0WhYA2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gw08AuZkpmpYZy3bhAUFnhOjUW1qYsumfDBhP64yZ44=;
 b=mH2RlPU5mxylr8xnVq+EJzT0Kw7sElPfQIkQrI/4LGzUIjvLRKwVzHr1yKbRni9E/3HOJ1IEHhZav5X/Tm50n/zs4+3pmfogDks5czFyrKrYk59m0V3Pa+M/JdAe9xfkWwRGchP7UzeaGnTsnwCkJZ743NI/gXxaLFMWGdDOwoT6CocoeEVT7zCyhLkQLULgf6Tv++8XbAlgsN3uQus8o/KFI78Wl/LbhXRpBZmJ0hN0W3L2GKwCohHlQPQRSF9gdFd5EbWq+6sw7yBY0FAdOPVoC1sjp7OFjI37k8WYLuHYh1cOa8Kg223nMitka0KFFOXHBv2caqZhimSmed5PCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw08AuZkpmpYZy3bhAUFnhOjUW1qYsumfDBhP64yZ44=;
 b=r8RjjarpuKX1yaQY6X/EAXA7Jd+8QIb/1Idv7fKG2+P9yoXult1ZnA/hvXmly61bq6/Ubm4vF/6+p89B8rTSdBkqpaTK874DraJZtQI3qeTt/Mc6+yjZEo1LMSZikInTEIK2VpPleIH8BYQ7SD/N0Rmc7dpPc+JZBbXRzRobkTY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/20] nvme: Don't hardcode the data len for pr commands.
Date:   Mon,  8 Aug 2022 19:04:06 -0500
Message-Id: <20220809000419.10674-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:610:e4::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f5e2cf6-692e-4914-946a-08da799abc1e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPNjE1eVnZaAauowI7QaXchWa14QA5JrnBwEWBq0R47tO5yvZf5RKcKcseGnbjMZhJDm4/BacuH6M7M9pSrKVg3STJ44GWoRO4Wgw15Nzt34k8z+qtfguJtwEISoJZundwmyE7AntbMTfeEftMFg/ajn5g/pb4zvQjb758bWabhDOHMZeKooDTiX0L5Cw7poW5tBf0iR8avgeEvVVe6QNt2Q1+GHZXj6K5XGLuIzibKU47UVKhM5chEjFXUIsGy2YwZYIifrGCc2JYS0RPTixP5iCRMtzDJfbIMYVfs4TRXzLM9D9/I6PVxCecqNZNqTWG0weDKucmx8YDR/LR3rQ8fyaOYQ12MXfHtTfSiecJniC6HsuYX/8uVz0zUKX9Afxy4auuX9WCjAWUPkjadUN3dlLsmpHt2Y6yNpXFNpLPkW640Sjq+wcDCJv/kc+9FOSm8c+WqwXwXOGjJmYcnjrNrGKWc9siDQHk2U69VKRtdQbhZVmkK6T11feFewjMCqmEOecKNfbdr7TPWSh+11jRAmkLQk0eTEOY2hRI+g4+hmXiC5bmkv+gfI52Xj5oMoT9bBblohg1OFQ1hrjfKTaDOJJ6jSaG4F6N3hUgs1iQhSuirnNM9Hsn0NUNJh+kZXWFjhBX44ZAKRq01DrPj+cwg7qwvg8kPw/xIW3JpwVgw0VEbxY8HP4fdF178fpNdvX8w22Uq2ABkOUHRQC9kDllXxixI6K1R2F/hYkLzQvOw2jDA8TCZ3/dr4bumqM27euBAlInvb+69Q73opvK1O62C/G5zcSA3jEVEvau4tsok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Bvu9/4+f85oUOCkUtotIBbP2HqYgss2MZR+1vdG6TmvLySZM7+ndqy+DeGL?=
 =?us-ascii?Q?6T9Nmr3WBIhcWhnhASPjH8IzIJ6eTeFwQnDpeIr+YfHFGnsjRpLL2+eDvOKe?=
 =?us-ascii?Q?gAoAYr8a5PCgdvvWXwaaGORWfp7H42m8G721ofzX0z7O1NKMAUPCeglHb4mG?=
 =?us-ascii?Q?2CKHs+6e8DMWAVQmulnQdcESGnwZ2VCpB3tZYe9s+wZpqs1zVtn+ymPTVvSC?=
 =?us-ascii?Q?+Gbwc7tvnVQ3JksVXs8uHutL/8XOv26qOnvPyH0+NHuqjkLEV+3M7QtAmyHm?=
 =?us-ascii?Q?nUmMUyGbb6vCWSH1XZi1/dqWv0Say3pwHD89rYvZ6WnGigo7wANis7kkJqyF?=
 =?us-ascii?Q?aKUdAly3VYucuMAG7vMGG8XfoY2Ewr1n4Xw5cDCFwSpfEIBG264vbWPHWvID?=
 =?us-ascii?Q?JTulos4yd5YfRTKNA4hG9wOCMHeZrn2kzkWmiqtSx4Wlj9SbKN39apBuGafu?=
 =?us-ascii?Q?U2RZG7uw+2foPDymtJG3G7LX5zmHfE17ATnHGnR9Axq4oqLTFAr02dHSgMIk?=
 =?us-ascii?Q?2DpdxIc1CU6qB8Z98EjLT8T3BTxFmBHjKwvGpUzpMixxXQiDga3k5Hf92jvm?=
 =?us-ascii?Q?GZCo3PVlIKpheZKMjJAe9iWXZEfgyMBftdVCvroIAlExH+sfQfAwBBiHIqJS?=
 =?us-ascii?Q?Tgl8ihiNBBmQFgjPlah0pXsLKnpzitNxdOUNKnUcLnf7EX+0ntLkIcA3R1ju?=
 =?us-ascii?Q?8vF9jLxZppeS6UNKdb0aZRrK0xoDMfIhILq1iMolzbQsl6r4iAtq66nzdrBH?=
 =?us-ascii?Q?F6gzSYf5ht8zXmCZ/jLEsDwkQnrddaqwl5LOoR1/cmCnBytyESGMp9XWlt4x?=
 =?us-ascii?Q?dJxk8e2VakEQ91TWB/llqbtvXewwOb7Brf54Qr2Ygf7yBwvTPe8w53Cqp+9x?=
 =?us-ascii?Q?okSoUfX3nmgcTpHhWQ0tK7toUMK6/hszjh/AJgEFZxgvWCuo+n1QhjdZ1S25?=
 =?us-ascii?Q?bZ6Q/PBlLD4IzcPj5I/4rfhF2KXvMVC3wzXnzbswh6RlbYRnJGKiIM5ibRca?=
 =?us-ascii?Q?xYO4aJsamG1Z2yA4ED1eQXlm/TE5bii98a0/2SElRm+uwyRaWYxeGWh0sfnW?=
 =?us-ascii?Q?YnustDYdezUSy5CvEZTouzMvg9iI5f6SOc15Q59iz8a8CuqVHDKG5fPiMPKo?=
 =?us-ascii?Q?oc2o79w68RbbD8DW6DXrQr6p6uB0/bQo41C5LT5cBf/e1xKdtGlFoyFGpy/Z?=
 =?us-ascii?Q?SVYLLHYSnmBYCSfs+gbCrXEVZnUQ8LRKdcPsxqPMAQ19bhgB4dIW7XH7HQOU?=
 =?us-ascii?Q?UJ6qkWdVlqBWQYpiQeYLwwSwl8wUN4SdbALfsLLKZap3BRyoxUf2srlR8pxC?=
 =?us-ascii?Q?adeGasjdena3PM23fEZOanInUGnrn53aTEY1kuCWTPvgjZQf+h5hXBnUDxTk?=
 =?us-ascii?Q?rb0+9N+stUNtBsoa6WOUcBNHLIqMXhv59pbt4eM0Uukba3k4bWpAV5kIwEX4?=
 =?us-ascii?Q?hVlpoUsdRfyCVh2wTVr1B78OUVxjJCBh/FH5SxFgVkmr1ct61qHgzbChFzID?=
 =?us-ascii?Q?iG6aav7BngjFW50k1t/od0IXedlO4zqJ0DP6H7bXJQdLRX73cLaZ2VadUC7r?=
 =?us-ascii?Q?vZesgmC3UMmqrtlnQY97tSEkg37wQ2vR5yzG7pSOpn0YKOnpGqKBm7LHyhhv?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5e2cf6-692e-4914-946a-08da799abc1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:31.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMvn1ZkNBdm86LzEP/vwfPucUgJhhwP6vlOqQ+8F+PJR9cbclFW+GWLSk98IZpqWgGdYvpuuWI+2w7fN6vOJ5Md0YCywWMVMeHTAs5yFJB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: jJcrh_hnpl-ld1fjQ_QgDWpEF08LTI07
X-Proofpoint-GUID: jJcrh_hnpl-ld1fjQ_QgDWpEF08LTI07
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reservation Report support needs to pass in a variable sized buffer, so
this patch has the pr command helpers take a data length argument.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af367b22871b..3f223641f321 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2085,7 +2085,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 data[16])
+		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -2094,17 +2094,17 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 
 	if (ns) {
 		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, 16);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 	
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 data[16])
+		u8 *data, unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
@@ -2121,8 +2121,10 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data);
+		return nvme_send_ns_head_pr_command(bdev, &c, data,
+						    sizeof(data));
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
+				       sizeof(data));
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-- 
2.18.2

