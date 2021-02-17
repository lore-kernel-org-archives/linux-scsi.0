Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7422C43332
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E33D64E76
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhBQUde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhBQUbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKNeiW190135;
        Wed, 17 Feb 2021 20:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pwXrh1RPob0q+fmPho3+wxeIiNLR1yLsz0TahiOMY10=;
 b=ulFRFHVE6XmDdL0HMsNQAaSrAIB9nj4JYWwhE/FKUjXy4oQ1YroSDY2Es3gvujqx1JGP
 WLxcT5U/fZ3KlXCwxuuNyarv5deyCrwk8jtnLHEWP+qOw+jt9TRPGqppV893X1sKKdn5
 uuJ3s0P/uc4sH+wUyMJPRVJI3pOMIYiwndqQ+lg9w6zD+FIz9iE/tuk9rXcGZjDRTkX6
 RdvpTtdAzGdYeZKk6Z/574sxQE5PEiBjhh02yzACkBWoUGBuvsNCiAwqYCBCOcM9FMqZ
 kr9KmbXne66H6K4vMvH84bphmL3htPXewhRvv7vmF7l0w3OOnRbt7OI5JIsTp5S0u7+q sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQCcC191586;
        Wed, 17 Feb 2021 20:28:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 36prp0p6cr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAjKS3eulema8IQ5TELMI9ypAUOkNnT7rKxFVmF6bNQals18BROOCefYDiZPpjW6iGCl0HAZTpeDARsnhXx/mqYXknFiT8xhkaJn9lyiMQygR8CUZjjT6Ly1vTUk+Gp0qh2Wwuql2nqAuSx7vZePIPLCCnyRA0Cc1AjCgy397S2pBCossibvSmWNn5AMrmChRO1VW1iXHCiX+fb1qXMJSWIsb8pM6ee63my946/0VeyDQFHnpw6J1nhJFgm+/1hKdL+co46W5vjnVhz046j+Yaegw+MtB5iR5bmsjgrIhBmVJSLupprvHtxTeU5fpW9A2ZX94d9RhBpX9zDeGcUT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwXrh1RPob0q+fmPho3+wxeIiNLR1yLsz0TahiOMY10=;
 b=Sxzd24dCdikibs/q1LBMtbBzsaumrwmRfwzJpb/pvP4Gm4ePQ8ENexdVn7hmCbhSSelCvFD6qWG6a3KkIpF+EVvJedCTrDCHiHg2D5myXQ0ZaSUa+AQcd1Jc/iOgFAaIzl08/3rLekQksk2572mxqqq26n5SFz8xQ1eTAO5xhg0O6KxJvpzO0i6OzDhhTGdUexyHNGsEpyQsmOg8miHudvvyHk8ci8VXNP8l+EyaQfJdi4aoPM+h5wbgePCo0O78M1CsAgRkuvbDv3uJjI+I6ZI8Ri9hiuOtUHlTjwjyYLwaYkUzI1K8/PDEns8NEy/u1XRNEM8RggHxPdSBDXoy8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwXrh1RPob0q+fmPho3+wxeIiNLR1yLsz0TahiOMY10=;
 b=SAyaTysgBDgQaDJ4e3ha0dub2iwfOkPaFyle+6XqUDe06Pin92dtixOh/RiN0D1yPjkMu7S0AWrzzzPbqWfJfY0UvyF9z/3H6J/+NBo2p4L7ql0p1RSjnp5RKkNuB0ZXcXoFX6iSA7nZOMIjWZLAKrfz1SQo/oMfc+Iy1ucSu0Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
Date:   Wed, 17 Feb 2021 14:28:01 -0600
Message-Id: <20210217202811.5575-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83e325f9-06ab-4d8e-4987-08d8d382a2d1
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101FF8E2CB8829EBE309168F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrTxnxBpB2vkpJLkr7/XTCpYDMphAIuiKpItFU548yXaj14qC1evdbD5VGj2YNxKd2b1VrYn85lsYi1oEjqj+dQhWVAGo/OIjvjj8kFnTa/ao37/oDRJqhcXHq3mDSU2D6RSls9VwOaD4Afh0TINd1FpI2sul8UcaorSc8MAdWTltrZJNXPQpXl2lH6maXCZUUO3WO8ioLEDopWs9N9YoD87u8n1W4nPhV7CdAk4zCpvUm7ORDi6hbUzs7+E9uM19WBQ95GWa1Hd+nI7oOOw3IJhIHrDEIJMs0AvRfVyFsH5Xoa/z1KV+sCt9Cy+/iJI+DwmpZfQJkEt15KAkPiy5oFwWBu0v5WjQMNkn/FcO/u9Q1G0Fe+/nNOskK2RrOJXdYILZMIHhRqerxICpDivtP3AZH+ps+itcgkoQ5ixs8uf3xCsimDIodGddiEUKJEWw9mSNo4pMi4emp38t0CrCcBJsdvrJBmVNS79FeTJJUxgtTiIAbzUuggNWYPYUL238J3RK3rlxLD0zqsDx/qtAt1x2efRxbLvE/6R/b5k8zTTyvH9Mkwde8v5nDEe3487BbSxO45eVUW+oNP0xSQQyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YGRz6ltCOsYmhm2RjoxUglFsNrx/FL6y6V0gSjEp5C3WNMykmA1iLX5wpRle?=
 =?us-ascii?Q?vXIDn5JfAKR1LbMuISMHL2zKfb9AqKGjpFXwEviKML2yflTZ2/wjVKLxHlNy?=
 =?us-ascii?Q?Pp0yr0actAeWFsRF7mMRJgR+Wat9NhoiTs//ossb8Vp469cQLA/mHbh/uJMn?=
 =?us-ascii?Q?rInfTOS6Qc6xrlk6xUqbIsLCzjiGGea3MesZP1qQrOyBqJPNG5QYfpn2Mejq?=
 =?us-ascii?Q?5o69/EqJJUPRdoWmme/QTy1VXjAIleRu1m2Ixh2OdkqauhwyNZTgQn44DEFz?=
 =?us-ascii?Q?R3zSTxN5Z+1M/VfkLffjmkqCCy+i2anDkuldJpoYEw4p0nlTyvkoUlBrk/PE?=
 =?us-ascii?Q?aKYt0Fa8O5JK/DUQCb4ZysYGAAxzLoQNog4l5brosfpNuSnChGxmKC4J+GAN?=
 =?us-ascii?Q?A/A3/bOHqYD003lmNxESvrRdWhJ9zOXEtEPMrVlgZ4vshgLQZKs9UvHn8r4F?=
 =?us-ascii?Q?QULqf87YbiwfLAVnzH+SEpNc4I52SwkDsc/77xml6F8IGw6mwv8xOOv371xb?=
 =?us-ascii?Q?mCKgifN6ePxDjHjW4NYQ1Ia1gXYh0FuWYi8CWpHfGBxTai4anE3Vv/fIqF1+?=
 =?us-ascii?Q?bkyUndg5UkdC5Kma7fbLyBHXl2Tb/JFguod61pjCRTeja2VPgo0Y285sVuSC?=
 =?us-ascii?Q?NqyqLiAWjQU7HFtg6/5z1+5+qpvWtmhDKcprIujzxurnNOp7l7sD82HIlLui?=
 =?us-ascii?Q?9nt/06tIjgi/oGC5tJkwkpQrH6Rp1Nidna7IcX9HMy/7bO6HGX7ZtUvEpC0g?=
 =?us-ascii?Q?UvaydI1VErHDwBxXKes8IsHcigFw4DYMe6L1B0DQER0+58RzzXNJVDbSjKTC?=
 =?us-ascii?Q?uVPFDVJiKrEnwXxnbN0fYqgFE5Li1wohfF3QzP7i/QRaASVT7utHHVp2DpCn?=
 =?us-ascii?Q?7Jqoc7dtrElnu7OzGWAv6B+7VdfnaYA3UGL2oVs1Urr5cJtfwFvGkH/vYCHt?=
 =?us-ascii?Q?kLpEr+bsaWjHRKo2VNVpZ4qXm9h/h3sXgeHxOu1XsPs2rJL17cS1vdDlBeDQ?=
 =?us-ascii?Q?qHSI76KbOUfNeBTmEswq673bgsNcLDWl0BHIKmUxz6hnmt3XTGLF/Cdt3+Ao?=
 =?us-ascii?Q?YyK+U+6k28UZayLTCXsjqNZ5Brd8GOcPmwAhQvlOv7+nrAAbBaL5fmyvgTPr?=
 =?us-ascii?Q?m6nYLLVOPcdOfV40ZzPbgF3svkj+x3GCBEZ3BBGGJr1HkuTGvOFarIVJpqec?=
 =?us-ascii?Q?Q3ccN3sn5q5fcRisymyjTk5STiwZoGmFuGsaBg12Vzoek4OA7QO86itA0dUP?=
 =?us-ascii?Q?PYaHSgcIPKauLrbFwsnZJYumJ5EZkh+ZmleD6xJCljeZg/OKR/PmEqAm7aC2?=
 =?us-ascii?Q?Kp9ry95UGF+PmCxldTFG5ugM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e325f9-06ab-4d8e-4987-08d8d382a2d1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:50.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5gGdU4WXJ2LgthML9sOECtKoOUAmNkg8t0mpXW12fLPc/NDE40ylPN5xDKijMdCU86QROrNdjiLRR9FAyVQloEKr9u6bgV54kMguKLv4WU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
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

