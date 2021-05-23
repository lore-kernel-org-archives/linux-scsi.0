Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DC9C47082
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA5A610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhEWR7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46636 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbhEWR7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHtfD3154470;
        Sun, 23 May 2021 17:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=UhpVITqmgTC1X8kSh4Y6Lb7LiV7SnmCgI/M7/aYZD0W/fLy2G+TRelRTLNMBcjzbH98M
 sDQUnkwWPvGmqbM3YdBG4M1JghFW3lNGPyANmHXSwoSiYyOmCWB3WNLTUC0Yhhe7Ae63
 zpez2hlbsyLG+cLOcImsepTZdoEjQ9AOcjf0wMi2ELyF5RESRxSewFTqvDiDhnSocfmJ
 Ex5OcnRwjhLECQqaavhiMhI7zzEn3rfMkk6NZyPLM8kTROpcj/0umgUCFUO++9Tn8hDE
 ByBbIZsbNLhX4F0y8t9HjXaczbJkysIt+6LYuuc8CWjp0avmIYMM9hrui08wV3I6UAbK 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu15S119800;
        Sun, 23 May 2021 17:58:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg7e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxmFJY+B7jEbSnQS6Z975oZpCDRTHogksW4q1yOWS85ZE2Zn08mCzjhTIeE8ubYYKH3W1xM23VuuBKkFXxbLQL0lZuGWrZNEaCEx2790XRUsFumrGfRcBGsgCpg4/OQ5bODtua3WcQKZPQvj6LVgZiieA0CxEPm14yJqtsbc2cgXP8RgoxoabvmUjafnR2aFD2Ed9ibvTKpjHyHme7nDVpmadBYCxtjUg6PjoPtADyC2pTjWuew0+FlujUdHLM3tUNTMzSq9TdUYsngM1b/AeI/yoyi4QP8oCsT7PpIsGwklHz8fb/52Xz7pVhtKoW6wn53fOhccgCj57kMDXUWZ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=SG1tYxyfBgeIpDr5KvOp5ccHEjhIQ+qK0/RReM2FizHUE0LGL5WyM0ckC7LcWNlDQF5VvWcR16dCKQQgOO4OgkxivYHMTwijeZe6cP19x3CEMV7oRPVlHxJz/yApXevAoq/aozxZ7ym5TXomEDU91Ui3MRoWtWrJRgZs8w518GQ/cHgHNkxxu5bA3kyZQDzkJ+gD1ETzf7SRrKxHIytG7TuqW+s5GwWeSzGYx/jlmExtFkyt15+f1yF1yCcptHVEh9bs4xMZNW1s06gehiNUKqdrzQszd/YJlixRKnFKKwfGuRBqLkZ3QjzzNOPhgoyHRqQuPivRXyBhwX4s2Gez5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=JGLDjDv2a7RVb5oyOnZVG9SxXhCq99gjd1mT7rWT7DOnMouNzDupyJjaHq0MoYtyufo0eEbwP9HArEYoG2UCEJdMzJZGNqzBliVnKhdfMqIxopdydiL7CSMFO62YjEcMbTIcDJPOgaYo5suNFnCFu+RvEZmpS9uTw5SCXYafOv0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/28] scsi: iscsi: Fix shost->max_id use
Date:   Sun, 23 May 2021 12:57:25 -0500
Message-Id: <20210523175739.360324-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b46c92ce-518e-40ce-1595-08d91e145007
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB400409906A10EF6516DED8FEF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1bLR6Hy00cUxPUq1OyapdlIlsJdfFuZinvSxgp40oTI++EtIVCHNS5grqedVpU5j9eXeXUXZleYsN17qHlpfJpMhulljyjUpMztTz4Skld9FEO0Scyh3YgT3ZdJa4bZXhy2i/CWCvz1Ho5J03idnXV9EmfP6OfPZMAABKB0Cqw8aCsQ16ZfEgzjZ5NZJN9Oc5lkz4SKuT04tpftwPDEvUp096wa15gKl3nvDz7X8JvqTMAPIHK0fd5p+Mkr+jMJ4tw6ANdplUIQwUC9eFVirLTkH3LTThrThOShDuiHwkMkyPWH7c07pcUi7X30P/j4AmgTMchpN0MzlbB6xeXgwY/n+bVBbHmLNC7qhhwxh1ZiFCziladGVDEmzJwL9kAc9Ni2uy+tjYS3ze9jpCUYGxStKH2QqygHAMEYFtk0LKC7EoINYsoyRBVr/NLERcmPTRatVdpaAfqEoBLeGGtWdhE+gWWA38bakl+FwTtg3lNUD19CHc2Vr85vhMKDI1/SgF+yHoQpeFbsHVinzLeAJy6QEHam+wkDpF5CaiTj+AvQSkVHaJfXJsB0KJ9jeMq8FUFzr5DTDoOi6M5XGefCsHoNzp9BHITxOHfag7d+Y9L96rSoo+U1Kbu0Hw5Q4OtOmjAV/ZnDzaioDtaP9Dm7g5ORHJ553kB7dtdRUnngw0Si1iU1Ko+Ul0VCp+Z/+6QX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GDfcjkhCqDKMXbpcEArpU76O9LvPlMwlzJKqEiPR57A/rFXreQWTE07YTZ15?=
 =?us-ascii?Q?hGoNovNsFauYE3MoRKmnkELGozRu+NbO2wRKMJTWLoZvtHBkswTG+5P7GsZ+?=
 =?us-ascii?Q?qpyVLleOWYTIajWe62yE0USrMQysG3AKj+ZdJgZeKqSxzEpV4PDMsMBB/UDs?=
 =?us-ascii?Q?h/asNSR+Pi0r6ZLrFYU+kfR+hatEHd7Tg67nQ7qLKAn9ViqhRwTqepRv3uCO?=
 =?us-ascii?Q?xF5bSc9mQQev9+p6P5u8CqbzB37SskwhI0osZ6hzLcKjOYEtOKpZ8qlab2Sn?=
 =?us-ascii?Q?gkKGHVZF6HYg3d52IowxproaVmwoWmR5BlTaDApCzE8k1ksCS/u0AObgTfI2?=
 =?us-ascii?Q?gh3E3YDvjq4fj7G/zZUJ+Qd5V1PJ83zdEx7YJx9cYUp3QW5jVurMULS1l5J5?=
 =?us-ascii?Q?+x4FErU3fz4Dv2tESrPdQJ/QwYNQgg1jCHLMWEhPFpQf2tMGEg9c8y+FZQdY?=
 =?us-ascii?Q?K+tcYlPCM7f0+0NPL6z6+iF2LALsQ1IgwkfX4ZxeA3ULqhn2nIHa3tVUPtMS?=
 =?us-ascii?Q?+x1dwd5V0Oy8xi+653ifXHkHIRD6TATddDwEJtGJAwBYE/W5nEo3fHvL/Zul?=
 =?us-ascii?Q?mQTWAyZDPh5WpyWeDkCD7IAuJq3dhEqYUT8mPItvVbJ14tjIuQ1Vv3hjmqla?=
 =?us-ascii?Q?5Ccwa1TFWVCGUprAhx5Wd7LyhSutYxw+ctjnHAySbJldQ9plKQN2cc4nAMN/?=
 =?us-ascii?Q?3lNhYNJgsNT/yo05SwAZYYo+n8RHEuY2xn+JDFQqgpyw4YkI8W6RoUSXjdZD?=
 =?us-ascii?Q?F2W4ZIlHMaB9IrpNHz3jYVQuEGGJzMQCbES4nxA7/E56mNkeisstDNWNaBKh?=
 =?us-ascii?Q?fvpSVYFWGW5Av2VE/WKQVszBVH0TKioZNelvPbBMKdVEPYX4SZaJfk18r/FK?=
 =?us-ascii?Q?zZ4Mgj5zA/quxRBMAOJead5IrQhiT4/HUwM0VBtLP1a99TztSqveomVLlYQ5?=
 =?us-ascii?Q?c2kCBRTigpdYzkgMyhghzlRtp3Ev8NfOBnD72cgtS4JWz9ziUgRPEtw1RBDs?=
 =?us-ascii?Q?08EWNl/2nX8lEv/dkDVYapEVYR3W+f6zIcjVgyYnBP+VkeeWO6p97DAp1pML?=
 =?us-ascii?Q?yIya2pa3DJnCn+eLGO90T8kn8IE6rdm4qpZcrSZdzCqrexDE4T4vn/XVE5MV?=
 =?us-ascii?Q?oWM85vPGNVl4Y2aGVC475QI2YNHoMNClpzb8gKaKteqyGYz9j6zL5u+6DxtP?=
 =?us-ascii?Q?s/35DkRuI2wQ2zdOVVpqMBgfWKNxPnMffT1VJRBM1PKZKl5+65Q1Mkx9Y7aW?=
 =?us-ascii?Q?FLBGlxvgVSa0n7mStPVa//p3I34SysZ6CDSmgBjtmdzmiB1YhVicLqneN3QA?=
 =?us-ascii?Q?Auv7U8kg1sLhfFDIPrVxxDC1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46c92ce-518e-40ce-1595-08d91e145007
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:04.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rvhFg3t8SHv8GoM8I9sFjaPBsYZTqf2th76I6a4IUimby1nUj5Q1OvXI0X/2ppRlZgDQJqvxtrWThbj/EUpklxvRsH9NHNwpNJnjY5VFPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: F5ml6wO_GP7BkBaCGKsbfhdvqTX3-dfo
X-Proofpoint-GUID: F5ml6wO_GP7BkBaCGKsbfhdvqTX3-dfo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi offload drivers are setting the shost->max_id to the max number
of sessions they support. The problem is that max_id is not the max number
of targets but the highest identifier the targets can have. To use it to
limit the number of targets we need to set it to max sessions - 1, or we
can end up with a session we might not have preallocated resources for.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c  | 4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c    | 4 ++--
 drivers/scsi/qedi/qedi_main.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 27c4f1598f76..d941e1561527 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -416,7 +416,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
 		return NULL;
 	}
-	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_id = BE2_MAX_SESSIONS - 1;
 	shost->max_channel = 0;
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
@@ -5318,7 +5318,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
-	phba->shost->max_id = phba->params.cxns_per_ctrl;
+	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 26cb1c6536ce..1b5f3e143f07 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -791,7 +791,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		return NULL;
 	shost->dma_boundary = cnic->pcidev->dma_mask;
 	shost->transportt = bnx2i_scsi_xport_template;
-	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
+	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = 512;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index dbe22a7136f3..8c7d4dda4cf2 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_id, struct scsi_host_template *sht,
+		unsigned int max_conns, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
@@ -357,7 +357,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 
 		shost->transportt = stt;
 		shost->max_lun = max_lun;
-		shost->max_id = max_id;
+		shost->max_id = max_conns - 1;
 		shost->max_channel = 0;
 		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2455d1448a7e..edf915432704 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -640,7 +640,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 		goto exit_setup_shost;
 	}
 
-	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
+	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
-- 
2.25.1

