Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F182C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2A764E6B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhBLHbY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhBLH36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:29:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QtM2017743;
        Fri, 12 Feb 2021 07:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=GhyWGuoV+KoSqPLT7zg0QiTLKCf26fujLsoSMvcwwMQ=;
 b=JE+456zy5Hjc6jY1HiphaCl+4+SpSy2zrCkS32FkCdQrwlBGYx6JL4CklMML1HFRUOIN
 Cy7AJnoCN7EgW40RLNBgej3NHiYs7YQnAgHqYS176bNhV5IcJFNAkGLOO5HMlKZldP2B
 ZTF8MtUz7H9sImVlSu8wNcNnocaudyA5h+9D/34hg3xMzhc+P8U3lZeztiuFFN+uySD+
 iEW/HBZkz+NbtkaUN6vWZ9npQychS3OQ9DlyM67YrcSqeObM4ISEv9wWCoGQBs3dZ1mP
 ePjJLo2KA6qUKQ49kmRooKg40npzcIxMx5gDJ2+Q3HiSIy9Tj9Yrvs2PRHAp1jzo72Hw 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dvcup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BT090048;
        Fri, 12 Feb 2021 07:27:10 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsdarwYqRWIx7iDCtn2eb9Xu1nBxG+fHYdrShSG0Qqee9UJQj55HaqPBSYq8bpJAY+mNsEK2P/1TpOeGN1saFMBiqYHlYOvQBRWhe/SOtETIWwqvtpMu9F8vzDfdwUhU7Rna/0QCmiLnG7cDkz8NicoTBopeYnqo8qpwYKn95Nsg+D4nNop7NuSz0oiNtSWhEPPxn3cO/rIF5k0isXU9dAhnXquVDdoEzlneVjjEg/vBI/N/TH0GVEB6VvGt+0lWkzszd6gl/cT+MGeU+b2ACHa8ngXn9KquhhwtbXRSYDXEL6w2z+xiF5X8GlRBe9G1fcCO9SP9T4GqMRi8qb92Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhyWGuoV+KoSqPLT7zg0QiTLKCf26fujLsoSMvcwwMQ=;
 b=ipwR7Mc2MZNXt73sA22Y7eHSl1WrEk1ItiyGosUy4UhtEg92mmylnGmbd9ROVU6ikSZKGJ9kHVubZ6hK98XL4g1FVjnVS+3C6UEsBG5Y8FKVq3yBYalHiZI4nDSLjW84p2t2QlVxslN7atPvk0uWC5Wsiom9dWI3AonKqe1DSZaHtjEDOgfa4UoxMmeF8GadqZc9o6HuZ/DG3fklyGx1/6U3TCG4fs89vqe/ZGA8v/wQ3l/Swl91QQLdvKP5IguSCb88wizvG2kVMAdybWedmcsptELQj/6ZeZI5ZIy1dE+tBgp3GEHl7p1c9mGX5k0MEqsdax9BM/2FfkaKTuRlqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhyWGuoV+KoSqPLT7zg0QiTLKCf26fujLsoSMvcwwMQ=;
 b=xPtT1DkW6lf8Vua2r4fe/B885O1bmbLD5hF8ZeuEgUCuX4r95JsoKayip53jNITF2mOQ6hFyefxnirLla204CwlzfsZMmi2TeeacASXbLF7wixtJlslP1ute6uboUhGr82hhVDr2Khx55uekhxsem3u3ZGpXFSsCYoMVfJWo1xo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:08 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
Date:   Fri, 12 Feb 2021 01:26:32 -0600
Message-Id: <20210212072642.17520-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80af52b2-d7e0-4ccc-f174-08d8cf279aa3
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254A715E993B0E620C8AC7CF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fa+TwBzfGygiBbV61L2w34VqtoBo8ZS9ZIVCcz5amukd+mOP3uzSYBlv8hYZ+OMpuQ5s2OIpno7YhxXId+8tuaS3wUTQ4JNxIBA3hu0zD8XdAuV/3iH0hzGVfNKwDkBFu098JFfUjN8A//3fwfheGWBu0yY4inPwAX3CZqDoVB5t6zxB5eUCSiENFqvHlFCN9ZuwTLmcl1Bbwji1gP/PXR6msxyFqhNFfI30OvBo8US7nQyrI55KbzF3odF8BjbpXlcCNIYBl/rVrFtPnQpSiqCLguvvxoS6jHfHbUzHeN/Yln5npXYL+03TuiOfpF6WjTxY/8HEYGuSR7fyfp4KUCIeSjOAX9CUc5LY8cwlDIT9SgKH0/5Buf2NMVnQ/oUp3W0e+3w0TbVqhRaTWl+G1Buqf2akfdyQwoq47HXZQreJqNYtv2Vfz8QbYOfhX26XN/eumR46bmdnu72IJiw40VfMFqneSGT0CbpVRMUOvlGMxz1lIA9Sp+YRxqVkEEJhe1u3pGgnCUHE/A3CmePs/ty3+yGGjZLBsRO+ZQ6CFEliC2ZczxDHV9v1MPP4O6a3+JyzPBGqVruBtHVoH7efEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vm0egfoX7C7xHIXXewsncSdrQu7gv3rsylBNTJQNMdcg5OW+pVcZNowralCL?=
 =?us-ascii?Q?vd0nLsQs+JwhXOD8dCnNCiKNbvrYizzAYt0edysarG4WAtpf5p5DmHSoQVmG?=
 =?us-ascii?Q?j7FB9HbZQ0WOTUu8GzQD0tdq1LNEsBibG6cSMvCAkIo6Rng7sk8eia3ikl/o?=
 =?us-ascii?Q?td+rgZO6GjxRESrfgt6yC9mBHb35NwJG0lbXI/U4xqODIjg+aS/J30OWzyE9?=
 =?us-ascii?Q?4Xu9UBjzLSSWGbArPs6aTF/l+aBecpj4ZY7VYngeJsqljTaoEjuWup9pa9xt?=
 =?us-ascii?Q?xCd9A18Y2/fXopbh2y7zs2+S6pvtvBjCzEf62WoFZs48JAjOK1ygyMGAI1fO?=
 =?us-ascii?Q?+c80+YiZRC87voZhZWHrMhoKs4ZnGl9SZmD+VF49ZCW/xd4c7xwNy2mCr1d9?=
 =?us-ascii?Q?jLsKLLzPYdVi7MXybNMzI9XuAY99of3iXadJbhAonAUPBX0Yu5BdEWOVZn76?=
 =?us-ascii?Q?F6A3ZgOZLTH8nvCswZ+MSI4hFsYhq2NOUh35i1UEobsXH6CGhSwFWW0UZv9m?=
 =?us-ascii?Q?5TrPfJlYzAnI6aBd8hkwUpyvP0pBmWgp+ST07YDcNiMhKG1n5JZpGAbSnH07?=
 =?us-ascii?Q?0nVmkYXWrXA3VJgBXt7mT3S/DD9DRbpdjVTjKqCduLHrdObJP45mzBcgnVkS?=
 =?us-ascii?Q?53Qa/1541UVzilrfJywXsad3UWXgyfrnbr3uRCarpDqLo76NcC8JH8HElAsr?=
 =?us-ascii?Q?2MoneiJY5ZJ9G4dUyesyEB+g1F3vhR3vvj4Z/vXCSTauexFQm6BUOndM3TGW?=
 =?us-ascii?Q?/kLJZZ0qPYOr4mTXgX2iC6Hc0DB1/CrYFeac9stAtqctqkby6+SqJR8hK2R6?=
 =?us-ascii?Q?n42bAmsCNEtIEZlfQSLCd/qYXEj6FZT8bzuVnhxj6ZS5ID4niAU67atFUWoR?=
 =?us-ascii?Q?hTviJ+KaMXWvw5+LDh4Dr0psMlwxsubI0oenec/UNnnQ5ga6s6QZLqiRkIn5?=
 =?us-ascii?Q?beuD5qjAURXqDv5s0344Wc5E+QN/l4I924r+6CvLxwNZ5Sg4UBuc/kfbpDDK?=
 =?us-ascii?Q?f4jvGyO7nr4mtT/wwswhDai2Xc2clcpzTwjnM1vPTptz8mYGZ/2GVlIQiV7G?=
 =?us-ascii?Q?vdU2puwnsfqCV24xBbW7krnU1sHp/ZYvHIvx2KBWuctoQo3CZebW6HI+PAz2?=
 =?us-ascii?Q?dc+fCRXfZO238zQ60G9ESo/bZccPgr/wf8Br0UH/4utQ2l3M5v30TW+o6Mzn?=
 =?us-ascii?Q?irtNjRioVg4ypMmbsnlyJ+SQPLBSzCBiqWcxS4JTx5umThozIrHKVs65BgDJ?=
 =?us-ascii?Q?V5B21P/TpIgN9TDMF3vgk5ad3utdTLMpWjSVSTrwoABY0TQe8F+6n/nhUzAM?=
 =?us-ascii?Q?CE1iN5hZJQya5ESL8f58fuSp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80af52b2-d7e0-4ccc-f174-08d8cf279aa3
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:08.1482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4PNm+/nqIbBEOtEL+EfUvWO/R09nSNqEl6nSHdPhPJH6eZP35iwTOnxV+IoLHi3IG0W8emOUrU9lmIO5gCSx5FtlzgB3GGFTycmYKxEgsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tcm_loop could be used like a normal block device, so we can't use
GFP_KERNEL. This adds a gfp_t arg to target_cmd_init_cdb and covnerts
the users. For every driver but loop I kept GFP_KERNEL. For loop and
xcopy I switched to GFP_NOIO.

This will also be useful in the later patches where loop needs to
do target_submit_prep from interrupt context to get a ref to the
se_device, and so it will need to use GFP_ATOMIC.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c  |  3 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  3 ++-
 drivers/target/iscsi/iscsi_target.c    |  3 ++-
 drivers/target/loopback/tcm_loop.c     |  3 ++-
 drivers/target/target_core_transport.c | 13 +++++++------
 drivers/target/target_core_xcopy.c     |  2 +-
 drivers/target/tcm_fc/tfc_cmd.c        |  2 +-
 drivers/vhost/scsi.c                   |  2 +-
 drivers/xen/xen-scsiback.c             |  2 +-
 include/target/target_core_fabric.h    |  5 +++--
 10 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 87741e0b4bca..51c386a215f5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1537,7 +1537,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0,
+			       GFP_KERNEL))
 		return;
 
 	target_submit(cmd);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 56394d901791..12a2265eb2de 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -492,7 +492,8 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	if (rc)
 		return rc;
 
-	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
+			       GFP_KERNEL))
 		return 0;
 
 	target_submit(se_cmd);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f2107705f2ea..566adfde1661 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1166,7 +1166,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
-	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
+						GFP_KERNEL);
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
 			return iscsit_add_reject_cmd(cmd,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 461f4125fcab..677e4b8f0642 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -156,7 +156,8 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
 			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
-			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
+			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc),
+			       GFP_NOIO))
 		return;
 
 	target_submit(se_cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ad30a99a5cb2..4723cc6abf61 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1427,7 +1427,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 }
 
 sense_reason_t
-target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 {
 	sense_reason_t ret;
 
@@ -1448,8 +1448,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 	 * setup the pointer from __t_task_cdb to t_task_cdb.
 	 */
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
-		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
-						GFP_KERNEL);
+		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
@@ -1638,6 +1637,7 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
  * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
  * @sgl_prot: struct scatterlist memory protection information
  * @sgl_prot_count: scatterlist count for protection information
+ * @gfp_t: gfp allocation type
  *
  * Returns:
  *	- less than zero to signal failure.
@@ -1648,11 +1648,12 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
 int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
 		       struct scatterlist *sgl, u32 sgl_count,
 		       struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		       struct scatterlist *sgl_prot, u32 sgl_prot_count)
+		       struct scatterlist *sgl_prot, u32 sgl_prot_count,
+		       gfp_t gfp)
 {
 	sense_reason_t rc;
 
-	rc = target_cmd_init_cdb(se_cmd, cdb);
+	rc = target_cmd_init_cdb(se_cmd, cdb, gfp);
 	if (rc)
 		goto send_cc_direct;
 
@@ -1782,7 +1783,7 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 {
 	target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
 			task_attr, data_dir, flags);
-	target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0);
+	target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0, GFP_KERNEL);
 	target_submit(se_cmd);
 }
 EXPORT_SYMBOL(target_submit_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index e86cc6135587..d31ed071cb08 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -554,7 +554,7 @@ static int target_xcopy_setup_pt_cmd(
 	}
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
-	if (target_cmd_init_cdb(cmd, cdb))
+	if (target_cmd_init_cdb(cmd, cdb, GFP_KERNEL))
 		return -EINVAL;
 
 	cmd->tag = 0;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 1376501ee3d0..410b723f9d79 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -555,7 +555,7 @@ static void ft_send_work(struct work_struct *work)
 		goto err;
 
 	if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
-			       NULL, 0))
+			       NULL, 0, GFP_KERNEL))
 		return;
 
 	target_submit(&cmd->se_cmd);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 76508d408bb3..93f5631b469c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -811,7 +811,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 
 	if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
 			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
-			       cmd->tvc_prot_sgl_count))
+			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
 
 	target_submit(se_cmd);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7bf9a6bede6d..eb3d8e35cbcd 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -368,7 +368,7 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
 
 	if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
-			       pending_req->n_sg, NULL, 0, NULL, 0))
+			       pending_req->n_sg, NULL, 0, NULL, 0, GFP_KERNEL))
 		return;
 
 	target_submit(se_cmd);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 86b0d4a7df92..0543ab107723 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -157,10 +157,11 @@ int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
 		struct scatterlist *sgl, u32 sgl_count,
 		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count);
+		struct scatterlist *sgl_prot, u32 sgl_prot_count, gfp_t gfp);
 void	target_submit(struct se_cmd *se_cmd);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
-sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
+				   gfp_t gfp);
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
-- 
2.25.1

