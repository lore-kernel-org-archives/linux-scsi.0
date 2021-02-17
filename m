Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33571C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E16D64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhBQUeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:34:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbhBQUbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPFAD018342;
        Wed, 17 Feb 2021 20:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=kwzC9aP66iNQ+nDR0T9fVHAu4XDhbFYWB223P8zdcn5Oh4jGM+Cn720xPzk+JNaGD7MY
 3qKc7WAFZhoeRGpOdKt/3C6U0gXDDJ+vtaVAZNTg9fArRLVFtdBDSuOS6LCMSHbot0ww
 u3bkCDRLYDkbICe+tCRcUOwJt32YBao6BxgNL6R5zFRSdIribZSS9q/WAuIlBonaxT8d
 O7rOf6fy2FLSW/8aSvQe6uXUepCQh6WOwm9S/+E+92kT8nubKikShikYaI3CDd3W8jHL
 GaNKdL+Vzq+2xKq7tXGxr4Nv0Sg1WlnU1MQ6QkW7/oEfhUJFNEJOPS3sFwMLS8g/69oS OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bbwy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPcdd113504;
        Wed, 17 Feb 2021 20:28:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 36prhtb5ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPSFZGUo1HhegT8zi+79tJ49hmp7vrDTwwDZQhQXEARxf6bcPLX2u+3Yynd6PS6K+sI7u0bffHulLXNG8W7SQlJXhTnFHikLA7CGdgdOUGWb0x3pG23XtR0CtlKFkL9D3ZobEAB0ypisVFPE4v2D1onJVD1i+ne+aCo6/dYO32DbA67LAkQ2Vpooc94+eHTnvhrZyNl3ewSF2Ycr+s/3BS32KoxmJ3yZhU1TpKmKXZcW7632rCC5XBVGpdgxk3ycJMeiZUJrjM3lFFUhNf7mw4LVd2a4UP6J2VcVb8BHEnyDSvxBIGsHwGRjXV+XKMaC7aTW0qTJMCGD/k84W0YbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=HBPjom2MBmdWnzBGfPpjPKFIPM/FxRiUVLExc6jysOUYEyq493c0Vx/w2vtow92vrMcAqwNYJQGFePhJ6CnKvjOOQns1Q/26BJ7K3iTryWBDc/owiZ8fmHG0wIfoVTsNg7sDw6NfXPV9vLk6LZyLxiU6zPI+78C4YlVv3iN57dVed8FBSwKbot+toQO71g7rGiVKZAvnICesORqC2jfOkia3K0OgiTxdA6oDE3K+jRGLGMrEEp6IEZFnP/Iq6jJ7sCRtJt0vdmn4OS2qtmDpbVYxI0Y298x99pc8Zhleb9BylZirOQhSoK1YMJr0DQWcl8GW5ZesZkbVA8Gw1yRfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=uZwIyznky7h6dOZg495H2C2DwKnJB4eDdOtT6itn/6xzZOoqcefO60Meo9HxhYASN0yAs9gYXOXSn+T3SIYASaUY0tMvqNxBaWs/xdHUS8+6a9B6hjejmahXvU1gOtKP6bN3O0+QzCNTUFuydBEOsnOc9grZyWqooTFv3R83MP8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/25] tcm loop: use blk cmd allocator for se_cmds
Date:   Wed, 17 Feb 2021 14:28:04 -0600
Message-Id: <20210217202811.5575-19-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9de42fa-4caf-4672-dcfd-08d8d382a58f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB394044102D9E501D6AC43892F1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Sh2ShNNdFUJOl+XoruHx4dW04xBWC46L7M0esdHaNQV3+hJp2qCci2qGQr8w5jWPvV2v1APru55DH3567tJ+IKgDxYNCRvSPq+3TnbwFcGREpVWS+/qJqAHW+1pyhAoVDaAmlaQ/qlehNhy5CM6a/08DiM9PujYz/DkYw/6FiIt4S2dy8gNVIPJGb+3VioSCvCzRe9VJJiVfHvEGB0gvgWtmc0NZ1uYe/zEKl9crMXo6bdlwnR6i7mGpxmBLsFWqa6d4JGq/owqKHG9x+rnZx2aD+kA9XHIQqm0FXciGMztXra/4XnT+14sqcb6Miw7BAWqCbTZWeQzey3GAHGyh2IomzPDLo17DHcyBnc8mwUtYf84Dze1IWGkLR2qBH0sUQmTyft/cwXGvylYKcOlOMaJtldyb4KaZWiOx2arI1Ug2uWUwjPy5OVebS2pFqhLdfx4CtX3ACIr95VMEacE5J2VlvWP0OJ4U8qzfZVCvPaHs+5Dme/w3zPVHnkwagcb/UbOEckfynRXivY4JQnTgsajyVz3KgGx0Ad2vNV+b6MNN1xS4++BUV3IIi1eCxVeEdCF3c7YxSK5GjEDPO0uPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8gMbSEmwZ4KPxZGLfenRc851AjToEwQw2GkacArHHa+tp39g2VlmFnlro6Ri?=
 =?us-ascii?Q?6ksmoRP1zNYktWalYkdZHUlmuG58n0jaX+2uTz6Q1uYUAmbQZN2IOsMpBfFX?=
 =?us-ascii?Q?GEezKqwgoH/RK8Ix/eJb8RVVhVNGT/GajXJLylsZnZxVo2Ifm21kxdCeVKQH?=
 =?us-ascii?Q?4C4bpCi19PzSUEH/lASXiLNeO3SbhXAf7b4H0b4ap+k3imLT/UzP3gKeCbXs?=
 =?us-ascii?Q?VamiGUDFK03aUhoSk/BVsT/ijZJ0em2sUEmvqUcauUC14YHXP48xBBwJMWSo?=
 =?us-ascii?Q?xwSkqowt3Ws3U+z3u1I/zZkauPYHgClFe900cVpSdfbRH8pESNQ3YnPlMsG6?=
 =?us-ascii?Q?VV3npfeKnwjDhaUn6qJqXOe7ToK8Us2ou2UO8VnGmWHDodwsox9Y9XAWx26e?=
 =?us-ascii?Q?jZinIKGYt1VWT7BB0ET2c4S9zPnwwhs9462OviFGgiChKVd5d5jc0GrM24iV?=
 =?us-ascii?Q?2L56z+dKeKNN2kk/lN/QqzBwSBsb10PpBVIUSGvc3tzX6xhojBdzSt1VypSY?=
 =?us-ascii?Q?A7aicPGS7akIkg6DklqAMRJKWgJNkU/6fAFE+Zb6TjWp5efFtkfUrMprXKuj?=
 =?us-ascii?Q?at410tQ3/gHok27aEiCZfo2k6gPI1QM+cjVQrr/WUz8nUTkWReaAin6TNlf0?=
 =?us-ascii?Q?ZwAgIWlj2ZO4TuX89yACyX1xYIB6UmxO4/+O/48CzlwlpvjTNzHUd/ooebPE?=
 =?us-ascii?Q?/xakeDud9HJOoMX8FI0eQdMG4wVR1O9bAMqM0k7Q6TsCxPQbnH/y2FYr1RpS?=
 =?us-ascii?Q?AC+nqU17wN7ovGhBhQOkK3NgQzHRneGHopnPpHaVmLUEJLrWkDUNJyHnXDCd?=
 =?us-ascii?Q?gmMlGUvj+rVleFVDcPvVXVr9UFZl+EiqfNOJtQsWeJWk6Q/ylK+QgQtinWlV?=
 =?us-ascii?Q?YQTF4NbCA8T+haEXW1hj6popldVsW6v4I3PdvbnYUP9bTKUP44W8zVlo7SFT?=
 =?us-ascii?Q?EGmRV52j+oKz8yhfRPubooGHiK7tANlXgAEneWn+WjZwYzMJMZPlNlOg6jGJ?=
 =?us-ascii?Q?rtxIkW1pKaHSOm14K2I3YIJPNgxdfl9KPdrsPRxNW6KBd1D/aN9unnuI5TQs?=
 =?us-ascii?Q?kNaDapNaoYqEp7H0Eyqht+bb5Bp8u9L+Sj41CxVOjjIfmGJFHKg4UUkaad7z?=
 =?us-ascii?Q?vI6Me2n0NJk4WlBuG7MIcmoPHULd4Qxb4HAEcjS16Avnc8Axov6FNSvkHscy?=
 =?us-ascii?Q?0yVSPtenOoToSMfj03thA3C9CItnX3hc/IeAE/CGdC1tkMhlPwxWztlrdmTH?=
 =?us-ascii?Q?E+A3THE7+sAzSaiwWXV6lPhFUMRm5lvUMbeWIOyZ+ZBMu4/Vhj0TY52Xnqvi?=
 =?us-ascii?Q?vkANa313O6m+S87D4lJB2Vxv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9de42fa-4caf-4672-dcfd-08d8d382a58f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:55.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbhLRwdX4bfS7iK/BExIVvDjZCigHT4cG3e1LUz0yxJM1JuX/LApcM42c5qXCa2ECzWrPPgakUvAjl4RnLETbSA+nUFRI3iVjqBOPTsdeXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 677e4b8f0642..fb877aec6321 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -67,8 +67,12 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	else
+		sc->scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -164,7 +168,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	return;
 
 out_done:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
 }
 
@@ -174,20 +177,14 @@ static void tcm_loop_submission_work(struct work_struct *work)
  */
 static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
-	struct tcm_loop_cmd *tl_cmd;
+	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
 
 	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
 		 __func__, sc->device->host->host_no, sc->device->id,
 		 sc->device->channel, sc->device->lun, sc->cmnd[0],
 		 scsi_bufflen(sc));
 
-	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
-	if (!tl_cmd) {
-		set_host_byte(sc, DID_ERROR);
-		sc->scsi_done(sc);
-		return 0;
-	}
-
+	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
@@ -319,6 +316,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct tcm_loop_cmd),
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
@@ -579,7 +577,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
 	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
 		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
 	return 0;
 }
 
-- 
2.25.1

