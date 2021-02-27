Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05ACC4332E
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D7E464EB7
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhB0RPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:15:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47950 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhB0REH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxcOU033030;
        Sat, 27 Feb 2021 17:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=88n/iaEqMlDdNWimYTScm0G2+2hTQhxw1NLa1CnNe7E=;
 b=TkiCBFHqDdMSqANTiWKJPUahkN9zWdbsedaPcjVSH/5FO9AOQ5sc4mKxuBUuheZ3/Rwy
 IQB3F0C8Z3P22Gr8E/AQne5Ne0JI/+B6vT8279K7B5QDa1xr4GtFpnTLYxyeQDSlng5B
 /EFT1xSgwWTKRqg5yZ4fqVUiINn3USc+S5lMsG1rApDBFWzILKSVApF27kDWjE9CdxLB
 kNgXsskqfDoaQaTpmc3UCIwVokqCtZZ/1aXU5moY3b2tS7MQgtIhJvCFUn9CPxdPbWOd
 BNMlvdDomWRCNf+Dgw1jSDC5ZreLtv3LrsEyQFNKlIj4g0od0/mEsqQEAi4Vh1oTaZ6v Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGsmDA041731;
        Sat, 27 Feb 2021 17:00:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 36yb6sam7c-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM7ooBypX5IdPLQGoPthwd8USueoEiNAWVi8XONTlrTVKHQddbpJqKvlrCiiSmbd108S79Q0OfyNP5M6YAyf0TGo93CGLo9xKMMGinX77OyfzBueV0MFIS7xlgKIyU0PxVna/HWmrchRClam2oJOc0A++iI/TEavEfD2xzCXaw1woX8QtgI9OcwvIa9QcyHFwxa2QsJbeqL8/5Q5qDsNibyQbOw1u6q54C/xGxddRYa6LA26v509BzQigD5thHCsd+eiKT7eo0KIZrQuTGAC2XQHRv8RYVSgopXUhE1JF996I/H/0RdBzyrSibnXS7++Yxpb9s+e/D+ckFrfB/Ngaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88n/iaEqMlDdNWimYTScm0G2+2hTQhxw1NLa1CnNe7E=;
 b=lmQ71PgWaPIhLsRQ6WFVhQsOiVAACM9kxhwa3VULb1uOY442Mb4/Q0zZeQV042uc5/JVqK2WX6X9QasNrdmFM8gfJmGsMJLrdzxxX/bQ6DrTCEzgXV7w5o71VhKtc6FGSXUNXYjj8ddb5aUdNM5EZmNK5icHCeXU4zCJAg2VODtHFybkqbL8J78qsxwTOY3lvCxoaCv1oVZM8gBWK8Pn8vpLiBZK+/PN44hC9Z9U3pcSdu5kPjFG1I7jS5tjSZGINqP1+tCQ4iWltriN0AFraGn/ZhvLUN/4/aqnCuDOEPG89uyklVTnX5eoQNzCJi/Uaeh6rtE0cf7yJ1QJty3N6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88n/iaEqMlDdNWimYTScm0G2+2hTQhxw1NLa1CnNe7E=;
 b=ccdPfCJ/BiwZSELmerP1l4njrWPjuNx5tnILNVR9LmEI5TOU73vVnsEWRh3QYIrihpEfOCGwGx5EUK4JSnPM61Zq83MXzyN4pS1w1jTkQ4Ru5iOUcnJeBgiVhnBs9dGznlIROuj7QdwuJJOnMyoU7ThGjNQp0iLLFFb+ynmm8bs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:28 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
Date:   Sat, 27 Feb 2021 10:59:56 -0600
Message-Id: <20210227170006.5077-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75de0d46-29ea-4506-436c-08d8db412f45
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB349937C93AF25BF148BA744AF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKdW98JTV8csiD/l/tQ8ArkxsJOYblXhIuD/+D4Wt1B1V2pK0ICMBPKE70AFsNjI2FMCtqH7JPx9x9w1Y2et01AushkNR1+k7hL0WkG49XuY8f4DjkYIkxdf1oMjKa0hhPREZ/SmedWs+PE24W56LVvlrOY/N2ZB7QN+RyRuOTxH6KL6DTOnMw/67bMpRwtW30GS0kZaXnNA5LMLUNLtM/LvFcAPrQVIYnKC0WilkqBW0rm4YdIA+a6X9upyZLMZO/mQ1M4EmnKRNvQk8l3JfpgRNqhSQSA9FH00xdQxg5VQAOf5d1Myh2baYtTIfMXi8oAdnGfrRUaS4fNYjbwO3627x8qlh3H8Pcpn1n45uatle1dHcQD1qNJ3yIN3QUwLnLI6ZVOyo1ij4xhTgYsu0JsDVHUDQn65EoguEQRLGu204yKfVkjuXWIMoTyWVeUh7TBKNpu/o3Mu4X1NQsyjFEeW4vAACquq8xkjOPM8RJ0CnsTdbKHLGylmB8bDWdcnucbrOWl1GVfylonrIGzUFVCMxdfo05F+I3dUH79q/zT/2QXyQ15/o6uO6WWwAZENy3k7afUAcEFH+ysggtvJ1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/GDuHgznm4K1VXLyMM43XKAwiGoeXCZ0ERUtb+Jk6x2kQ2eeNLP4kdm+8buM?=
 =?us-ascii?Q?bBC8BGDIlSkT9uW6+enWqUW7vzB6rpsjiDZ04Cb0Rhbrnnt2w9YgpUlqjW8l?=
 =?us-ascii?Q?tXb58CYi5PXQivlZ10dhIl5RoTHtZXDmtDsAKqt/vtamjXQo86SivlQOKFdo?=
 =?us-ascii?Q?TduoJteLBIUMMMTdh2elUov+DNsAenbSz/R1+J3raFldWJUwe5EBysbPeVnU?=
 =?us-ascii?Q?ZllDRfX2XyYBAJG/hM9Q6Fo6exRTu40ArU7mMcITTi+HsngJwGybZsx52xJl?=
 =?us-ascii?Q?e3t9cmhVf7SScsu2qZtQ0uRJ1NSkWJIACIZOCWsma+2Jl/dfJ1j/BRAQgLa2?=
 =?us-ascii?Q?LG15ARMuioz4pAvCzni4Ovw4jRnXsb0EvXFCDjSZrXdy2C0NP9P34tY63xEy?=
 =?us-ascii?Q?ep1DWHVOGHgRyUdRoYXkHAg7DxLPE4EhD9EdIfpyexs1G2ZyOUWr3bsnz+N2?=
 =?us-ascii?Q?BWTqOPn9jLXVDl78u7w7l5/DnES8LpA9kK+SbRZXeCDE9JCmYNKd9uikodgr?=
 =?us-ascii?Q?dOty7v3VMbMewoyEtuB6aG7DcgA17iL4jR4WWfQLq1Rl/2mUf/a8EK1XYhjk?=
 =?us-ascii?Q?V5Y2xTDB7VQk91xrLA6pNx99eayFoK5LtBqaSouBN2qAaQtcwJCptf0pVorZ?=
 =?us-ascii?Q?8VBCpeHPQoMJ0OMjSw6l1qVecfMOksLFKeTz7WbEXtKrT0twAx4mtFQr9gDI?=
 =?us-ascii?Q?RugCiiy9SpfR6wl/tZQlwxlF3NEwYijz4Q6wVZWC6AnDxCw/071hJ8qf/Nde?=
 =?us-ascii?Q?1OgeasGcD6gU1XGg1orEp6uyqzCa6ByrIuoXULVe1moP+IBJLXqNC0QU+gR8?=
 =?us-ascii?Q?fiDCih4YshJy7lg59b5zsYXMf+42bheENpczValgsBWHTKm0lNVGjdijwWT8?=
 =?us-ascii?Q?YdkecKGdG6UU7gHkXAPWDC/SEVH9kyBTXxTFgGpaCWdTrw+dpP1b3U7wN3rc?=
 =?us-ascii?Q?qkmtdkbC3d1uGKzfb5VwnM82I0W3NuxA3ARB2mAZvB2z02jp/o5DO+hKYd+e?=
 =?us-ascii?Q?ZzxEc/uKDWuqB458VmLDduhPanbAX9r3nXYYisvJNZAUaDD+x6IYTyYqZvKY?=
 =?us-ascii?Q?tj3whzJOLIr8s6aC3Hp1Fy0RTdQDw7CmQk2YtTbSf7o8ilqn/8a4Wksy0Tkd?=
 =?us-ascii?Q?CQ2ww76f6ERNbYfUUhMpRFFiDAur5CStyth1cJsKQ7ZwwdjnjuGDnPNDIrhP?=
 =?us-ascii?Q?pqDA8L/2BzB+GyqGAtembLzqzJzNDOUfdRqDLDZjeRhHgGoZQa7qIUwf9+/x?=
 =?us-ascii?Q?dpZeTjsvVdGBBdFCBX72G0jL29paxANOC0j4nlwWPRiv7F/4bEwYkoN9w+oK?=
 =?us-ascii?Q?JDfSFNjy8VF+tqrU6Sab0pqG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75de0d46-29ea-4506-436c-08d8db412f45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:28.7629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOo9iS8cCHKsqO4VYJ0/PBY7h2JfKT1QXa62RUVgbVeZlOF9YVgyvBRBB9TqHsv3DWqaKhyz4HbgpLSYJ0gxelrGSlctKjwW0klUN3l6Oo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tcm_loop could be used like a normal block device, so we can't use
GFP_KERNEL and should use GFP_NOIO. This adds a gfp_t arg to
target_cmd_init_cdb and covnerts the users. For every driver but loop
I kept GFP_KERNEL.

This will also be useful in the later patches where loop needs to
do target_submit_prep from interrupt context to get a ref to the
se_device, and so it will need to use GFP_ATOMIC.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c  |  3 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  3 ++-
 drivers/target/iscsi/iscsi_target.c    |  3 ++-
 drivers/target/loopback/tcm_loop.c     |  3 ++-
 drivers/target/target_core_transport.c | 14 ++++++++------
 drivers/target/target_core_xcopy.c     |  2 +-
 drivers/target/tcm_fc/tfc_cmd.c        |  2 +-
 drivers/vhost/scsi.c                   |  2 +-
 drivers/xen/xen-scsiback.c             |  2 +-
 include/target/target_core_fabric.h    |  5 +++--
 10 files changed, 23 insertions(+), 16 deletions(-)

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
index 1f35cce6e92b..6c88ca832da6 100644
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
+ * @gfp: gfp allocation type
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
 
@@ -1788,7 +1789,8 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	if (rc)
 		return;
 
-	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
+			       GFP_KERNEL))
 		return;
 
 	target_submit(se_cmd);
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

