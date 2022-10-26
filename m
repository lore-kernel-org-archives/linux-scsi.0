Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF75C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiJZXZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiJZXYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42A15B791;
        Wed, 26 Oct 2022 16:22:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM6l4Z014666;
        Wed, 26 Oct 2022 23:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4RVDIsVkIWmbnl+KNosyTGbwNhnc6ocTqs44CGxG+vs=;
 b=KPAedIG5FhKE+QXGbZ/WMyig5MCMFnyAoLskxxc0t2Doxk7qS+dO1KxTzAkHbGhz6eKU
 z0SKzCyRnDNISnYfSZhiyHdAGKstnSSSmX1x5737zgt9Rv3ylv8d7W6FN4UZa3T9f44/
 3+YdAEqw8B3kbNTOluy8nW2fArN9uM6YbEtWhP+u1GYZJKtBSQ8ERV/EA0rax958cV0j
 z5BnjnMsz+RHJuz1sxlZMK/nPyoukYiV0NRD0uSAP5jg7Q1CYbtSU86EnlSlZ4ukW6oT
 RBy4kJNCYuuHuq83u8ETlLO0g0JcIECpQkmEaM+gsAebDA7jjKaxhQ7srBItygt92+Mk hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0jf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMAWis006963;
        Wed, 26 Oct 2022 23:20:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrhk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdAVEsvMGwvepiDsOK8C/oTlE2X08SzxqFuSQUnqkr04CPkxVQreIfSJMlPk8u0pT74pvEgQpJbv9aayWmkiN2jMku66NMgkoaFmNF1tmLdmW2QIFTY+m3mo3QA6mro+3IDfoqPXidVc4Iozdsr0bIwGfgI0uQYZCRr/erTx+gGmW5RdxqRbcNcE8dY1X/SsqfK0ZnMVCXDv0hX4YL2KesiiAQsqux/Ue6NLwGz8Py9V/4p/zj1yTyBgn+6Ny4ylBsSwcNisHA5BFraYnT5voOSA71pOc2ajXNrisbZOUkxWxTUHx8jmAhubZqtcn7qCA6vL7VGE4pPvtr+WihGWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RVDIsVkIWmbnl+KNosyTGbwNhnc6ocTqs44CGxG+vs=;
 b=S+Dk6UuBZEm3EL7m/bHV8ImtoBaOpa53J5yf55aW+WsnUvhmZsBQPY6wXKQrBenmiTNg+yA2FQsAT93Aut2n4RfWEPQZAOfCq7h3NXb4lpi4RoDrcVZOTfLpFdvTncuvTiZ6cxCbNIGM+cF3SDiOksiBrXXE9v0DBILSFucKkXWNN4CJFyIszJs9uS/mkqTxcL+3iAebXzC+NhXzvIWviTUOppOLDi02ORu6kU6VyeyQwiWPaIN9pRkHVG8TpHvZivYDptW4RP/lKNqfksPZaLcSlR787Cg7+m6gFTMKKMmjyt1b2RXlgsD3Czr3EZF5YZhlgdYxtabXVtWhsWBD1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RVDIsVkIWmbnl+KNosyTGbwNhnc6ocTqs44CGxG+vs=;
 b=F6UeqsngVWhoxmUr7+0FCsPgqHf7FM5SzIimTPX4wb+Y/k1sN45htB21tdL5XQSKpj77NsROXGEciIjU2frxCarlVAr2WvJL0nY/ob5XFcfg8If8K9G7t9gjW6e6aMztRbiYhAch5TdWgB4MB/8NSfq2oZSybxNNiP3TFWVH/zI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:20:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 08/19] nvme: Move pr code to it's own file
Date:   Wed, 26 Oct 2022 18:19:34 -0500
Message-Id: <20221026231945.6609-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:610:4c::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f21984f-71d8-41a3-d4be-08dab7a89a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWSnxZiXARMpZF/xX99BcveV4P+u8W1rMfZb7BJB8M7I7x2Q4NC6Gakq7TNw+DgMaCUIJfyLLTMYIIdJRGshQ8bsjeiTuHbezVxneHU9aBFN+gxR0kMjBUiBbi++nXfZwo6B0lLCzlc8lO72dq1GWSv8YFZgk9lxlDz91PxMB/74TtWfCMMxydTnzKLcy5xnC8TlRz/a1Cygo0/ZJGkwTPJn9oNO+TJMvT5NWbNq98R9kE3W1EnWr915h8olTs/kmuESesRhtnS3/mORX1wR3KckNQRRNB7gYCRCdodXCP+v3uCmj1B639ilOi6Nx5QvUirJgnzqMnV13jipSSOyduAQFtafcpelI6t1Qqree3skeWmp9HqxiaIMCkQ0bMSCZBWemHO/7aPoxDEtIr6R/taUr5FuyUYAeBFaQZiosVG1HHrYBLvBqK/ohfCWuhljvM8QIJScJvhRZd3RPZCMi1s/Nbg+GWQWP0mfKB8gxKgqNQ4+lX6FyIP67wBHldUCUA62qIqYoETvjBYJxJ7N09i9mhQDwT3WQD5PEy5AZchaEDWRS9rJHqhTtXU5ClaDAjECw62avSMMuVT2oLLBCwdAI4QL65C1Iz0fo5vWHayjArbNcmTG7N4lBETd76RF5otegmNBs4fd83LHGFFzjSoVFLgn4dGCrQfA1PRc/sKTBw0svdz6dyrFj/QN8/m10vaZXMYwq5Lprafvo3rfoMCwAq6kM4pgQuHxLaLJ5NmX84iGvqI0BKXkqT8cMhuB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UUDGg7vutawteOS33rR/ch0FrloJKrh+g+2c0d/NyGzz70ilLvg9f9INTOwC?=
 =?us-ascii?Q?AXIiv64WmUIO8Y7gNXnHBo4r16DsPcl/oVPKH99//e+mxr6dI808UjYIe762?=
 =?us-ascii?Q?fHkF/ZmKlX0uud24Yq92/pW/FIW46DYL1x9X7G0bWNXKpMbKjVi9BBi9wZ+H?=
 =?us-ascii?Q?91wFTgsi2giIs8FiTc9EcS6DmU/PQxnvmooOk4Nae9Et8NDBk5tJke4ksyX2?=
 =?us-ascii?Q?H5ee8Bj6mDDCBwVw4+RXIj7JVFR5F1Y5tAHx99uRXdJxp53yd4kDJgtHEF8D?=
 =?us-ascii?Q?wOCrwKX7X+6MuNclqA47SxK6jMDhEjkD8txxDE9lyPP6+MBgsCImPCDAbtep?=
 =?us-ascii?Q?Q20/uddvlRLIXgxmywruz+zYHzdjwddN0uXnczTrmrA+qQ2UqGkdS11SvieD?=
 =?us-ascii?Q?YqU2XhOxwQU1SgTB4xvznRLzQ0wpg6fK5jUeVCjYjZGuUi8B8OgvmOJeZYyD?=
 =?us-ascii?Q?Sp6QlEE7miKn/BcVWCGSn3+GnvZVMueot/2QkkRJmjh3afB9PLoiPAlmr/T0?=
 =?us-ascii?Q?ao/pGnVcffiwUF3QJu+3JoLgG6XMcH6dUqx7tvLmr7NpYBM/JsaCrm7bxVkP?=
 =?us-ascii?Q?0x0Sl0NGwL6dfLs+fDBbR3I3Kk2jSlflbQPbkvWfw1koT04C16jCDkWcBNkc?=
 =?us-ascii?Q?o9jXrFBel5kMHTe/bHbdIIecAjrFGmz7jvHztwzfPuYA0SQ6MSAL9GFYNYJv?=
 =?us-ascii?Q?I3XKj2jkKZO81mi6OcGgrJDsJdJ4WWB7JCkqHAq+WZ78HmR+vKptqu3HwWMw?=
 =?us-ascii?Q?tbnCY9/D8xPWwYLlq1MefKoRSeTqdJ88YSEmM0qw/euzqF7npOTf08jHELK5?=
 =?us-ascii?Q?1PzqMghyn/llyJZ7gvHUnEnKJB11ZoHvFuOFaACdsFahQMucBx6j0hmoqSxp?=
 =?us-ascii?Q?FC7mbwOsOA7t/X3C+KEK4Wdwb49VKJWU3gsZTAc+JXe63shX+sPZrpGBY+pK?=
 =?us-ascii?Q?iGehJ8v+m+rqafbyDXvj9cBqpQcidXAmjvNcESz40ZzP+Qs9gjMGKyQXSpx/?=
 =?us-ascii?Q?elIr5h2Fj2tOjpg2LN8+O0JeOGnImEwfH+mbxqgR/eqJ5YKXQuQJU0XHy9dG?=
 =?us-ascii?Q?ELyMR/elaIDXeIRfNFFDswq7oKWI9QcYC9vxKgFDGbITk113J9i0JNGzfKnW?=
 =?us-ascii?Q?v/ydFxiSpBVBh32g6uIj772XTx/0UoqmzBR6z7IgHWgw6qmQPtx+3EUS5RWj?=
 =?us-ascii?Q?+vzoKKypwALX7rfya9scMWhJ3LzVFEOrrj/lj8ZQO3dec4IcMQsyA4CDRUht?=
 =?us-ascii?Q?PFKswUvxow1wCTdMzQVqaad6gthEEdXLRDtYo36qcV0EvtZ6S7mHRfsr+gwo?=
 =?us-ascii?Q?Nd6BH0p5nHeQXfD/jJtdYwEdfEfu2cn/LA2DYIHUx6ZmvVPYGtdwUw6k0A3W?=
 =?us-ascii?Q?5lA4MTE2ak3Spejssj9Nk8pfvkzTX2eEZexvBhDEg/aAY2/9lN5Qpg2ktGeb?=
 =?us-ascii?Q?0nhy6YFVopmD5/eDiwmdfiWtrd9BsYRUl1Lo6lFajgaiDpGHZOB1baUlhkUm?=
 =?us-ascii?Q?lYh8qzPwuBkfgoFze9k6+z0bDBaqjAfu0xl/ZzE3pqy1RXDjnrkayHIGM1kd?=
 =?us-ascii?Q?kARzMOWricTX5ko0rfbapDa0g/0G/fpXSs/MXg2t8nHc0YUQvzLyplldfrFH?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f21984f-71d8-41a3-d4be-08dab7a89a6f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:00.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQOrGutqRm+nA0aelZ9M6EwurYEYE2FdxA7CpnhBCqtcMTP7yzF5ZFmXIHu0yftJT49Te2QwoQJx7ekblJ6nkwB44jW7327DiB1cKoBC3VU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: N_EpuJu09MpqxCXPMvSXRaJ6MQPqJ-RF
X-Proofpoint-GUID: N_EpuJu09MpqxCXPMvSXRaJ6MQPqJ-RF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch moves the pr code to it's own file because I'm going to be
adding more functions and core.c is getting bigger.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/Makefile |   2 +-
 drivers/nvme/host/core.c   | 120 -----------------------------------
 drivers/nvme/host/nvme.h   |   2 +
 drivers/nvme/host/pr.c     | 127 +++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 121 deletions(-)
 create mode 100644 drivers/nvme/host/pr.c

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index e27202d22c7d..06c18a65da99 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
 obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
 obj-$(CONFIG_NVME_APPLE)		+= nvme-apple.o
 
-nvme-core-y				+= core.o ioctl.o
+nvme-core-y				+= core.o ioctl.o pr.o
 nvme-core-$(CONFIG_NVME_VERBOSE_ERRORS)	+= constants.o
 nvme-core-$(CONFIG_TRACING)		+= trace.o
 nvme-core-$(CONFIG_NVME_MULTIPATH)	+= multipath.o
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a79fa710d012..2de9c42094a6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2061,126 +2061,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 }
 
-static char nvme_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 1;
-	case PR_EXCLUSIVE_ACCESS:
-		return 2;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 3;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 4;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 5;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 6;
-	default:
-		return 0;
-	}
-}
-
-static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EWOULDBLOCK;
-
-	if (ns) {
-		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-	
-static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
-{
-	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-}
-
-static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
-{
-	struct nvme_command c = { };
-	u8 data[16] = { 0, };
-
-	put_unaligned_le64(key, &data[0]);
-	put_unaligned_le64(sa_key, &data[8]);
-
-	c.common.opcode = op;
-	c.common.cdw10 = cpu_to_le32(cdw10);
-
-	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
-	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data,
-						    sizeof(data));
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
-				       sizeof(data));
-}
-
-static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = old ? 2 : 0;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
-	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-}
-
-static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = nvme_pr_type(type) << 8;
-	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
-
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
-{
-	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-const struct pr_ops nvme_pr_ops = {
-	.pr_register	= nvme_pr_register,
-	.pr_reserve	= nvme_pr_reserve,
-	.pr_release	= nvme_pr_release,
-	.pr_preempt	= nvme_pr_preempt,
-	.pr_clear	= nvme_pr_clear,
-};
-
 #ifdef CONFIG_BLK_SED_OPAL
 int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
 		bool send)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a29877217ee6..e82be1f1373d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -19,6 +19,8 @@
 
 #include <trace/events/block.h>
 
+extern const struct pr_ops nvme_pr_ops;
+
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
 
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
new file mode 100644
index 000000000000..aa88c55879b2
--- /dev/null
+++ b/drivers/nvme/host/pr.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/blkdev.h>
+#include <linux/pr.h>
+#include <asm/unaligned.h>
+
+#include "nvme.h"
+
+static char nvme_pr_type(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 1;
+	case PR_EXCLUSIVE_ACCESS:
+		return 2;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 3;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 4;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 5;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 6;
+	default:
+		return 0;
+	}
+}
+
+static int nvme_send_ns_head_pr_command(struct block_device *bdev,
+		struct nvme_command *c, u8 *data, unsigned int data_len)
+{
+	struct nvme_ns_head *head = bdev->bd_disk->private_data;
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns) {
+		c->common.nsid = cpu_to_le32(ns->head->ns_id);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
+
+static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
+		u8 *data, unsigned int data_len)
+{
+	c->common.nsid = cpu_to_le32(ns->head->ns_id);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+}
+
+static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
+				u64 key, u64 sa_key, u8 op)
+{
+	struct nvme_command c = { };
+	u8 data[16] = { 0, };
+
+	put_unaligned_le64(key, &data[0]);
+	put_unaligned_le64(sa_key, &data[8]);
+
+	c.common.opcode = op;
+	c.common.cdw10 = cpu_to_le32(cdw10);
+
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		return nvme_send_ns_head_pr_command(bdev, &c, data,
+						    sizeof(data));
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
+				       sizeof(data));
+}
+
+static int nvme_pr_register(struct block_device *bdev, u64 old,
+		u64 new, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = old ? 2 : 0;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
+	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+}
+
+static int nvme_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_clear(struct block_device *bdev, u64 key)
+{
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+const struct pr_ops nvme_pr_ops = {
+	.pr_register	= nvme_pr_register,
+	.pr_reserve	= nvme_pr_reserve,
+	.pr_release	= nvme_pr_release,
+	.pr_preempt	= nvme_pr_preempt,
+	.pr_clear	= nvme_pr_clear,
+};
-- 
2.25.1

