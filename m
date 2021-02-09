Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B0EC43333
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2A064E88
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBIMkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43228 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhBIMjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYAaC054680;
        Tue, 9 Feb 2021 12:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=T6JvKBuJn42fjKd9fb9+986NB1Fmjor/ovsyQ2sH1J+aWlBZ7zNrLCqHkOswLcyKXdyQ
 IGEHDiALWbc90xzTRFCYPfyCTDambmD9UkoI8XmpvXg3pY4/7ZDN1W4QRlLotyb9Om+Y
 TwZSaygv3neRc37mNEs9d/Zt1f8T8tX57fr+3r9fZqfVDoELhci06eMKm8Vf5JSEtEa/
 zYFvyZbFY0Vav/KD11f9E7EfEVjClWP6moD/KikyLIhbh3HU2gmUdZv+DLuNzVKKl72O
 7uaAl9CM3QnyWDCB5QdvkzFeOK+5Or+rsb/VToeoLxmBGHA/GAA/JkCbM6almipnjLyh ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmafe4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIM178533;
        Tue, 9 Feb 2021 12:39:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 36j4pnn0cr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8aF2mYTUypktRB1zJrRcOciPzN6dWfvr2EypReDp2SedrW/aPYtXDEfLC0g8KysoZWgqBo+BOXVNXrGn8+Hlo4FU4UhR1WDI72Ue73O1gLsMp0+C4YEEPYc9OfeO1NLm9kNLXxlZmSr6XdmHDFHBDDsOnmGYufns9IDiFG//Pzk4JfuEu4OO7FzPE5NPG8CD3uEtb8Dy0l3jLHHNMa3RXoRx5fus8lBgHhyxQ02YH7qzWv4s/FzXZmIKmulqaKwVYyD6ase3zEMF7x75cf7gKt+Qago6JOexmHoMnkpzpLNyACR4QqcT3u8KmHg5Wpt05kQS/2OOQFyHsfBl9RQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=beX95R03TGCizceeTKdgI3u33u8lLgUU0icSyTRgVEADy8xHVPgL5Gp2G8jYApiBJ2fBpaZCfWwnxtykwyUOt+wKrABsHRcx2THkFgtcnPpAwBZ3ZTL0Y+VZbsqJAPoGReANVsZOw6WYQ+nyjOc9aUXvCMGzmZ7x+t5f+xsEvoxEO0Gd8+5ews3Fxw32+WCNXiECiwul22jnXlOCoDc3FdzptuiTkSzFcXj9V3hud2+jbBnJNXszy8Rbtgyz0TyL3xrY+pdQ14tGVJ8B4qguFxNmzij0s9C3dPNw/rXoEo4Ve4CaxB6YvPXkoNgOA8kgR9/vVRd5gSR5WBOCEr3mQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=MMr51YEvQLQGykTwz5BbGNWwLDyQmlyBWrvMMPTuxFojh8zK7MVj0LTqAr0JcfHyUA0C1uFX6ofjiIII7BpkkVn4TO0uqt/AI6dshlH8hjROr1jalR4ZiIT3yCEF4zGCv6OUtAKVzOVe4Py0AeVIVQbJKUkRYtvE1Awb9NvLLF4=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/13] tcm loop: use blk cmd allocator for se_cmds
Date:   Tue,  9 Feb 2021 06:38:37 -0600
Message-Id: <20210209123845.4856-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 207522d1-9b49-468e-7806-08d8ccf7acd8
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600039B4D57A84ADB6659E4F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8LwlNjGT6BoSm1J9wOAnHXBf8elO/pw9sW9MAYIqNa1PY8bJjzbtr1/9oJntRLx3iK8Eaq+iC/4TQJfoOABuh4ofKRZ+rDfmQaF8SoOUL4XyI93VCc433QtaKIVk5WnYgrMyYsdaabyssZDG9/9jALrCtLCVTk+nRDu+tme3P7mbpC6SjM76QKmooxnknvBpqrxeGErVa0DwbcuqpgTGO7rPvSjOLczrCfpM6Up0eYNVrEOyXSUH4DVbm5XXbF3aMPyO5BPH/f2d0zYjZhN62nA5pKxBXZhGe0ebOm3TIa+mG2dRMaM3sRVb9zu2EBvkUsxpjiBYbjBXSuiS3dTIYOoWU5YMciKqASzLp1EE+LVHsOq/judPI2pEpR4jDa7g2Pj8a8hma0u2AUKwu8/8s/ce3ALuYjKbE4s55Ss5rvLfHp02qIWrkVs5N3UsJuT/VfFYaC/Ci3kuSikKOhNrPnKwR25JwMdq0ZAA1Tyx+xo7wSeLGIynfqS8PxcWRH9n9L5kHPVTTYmZmh7LliHFLUGDiUHV/X5Xy2z7eUBZ2Lz9lTtdGfLL4EGNDB8TetLk9JmRee/liwK8zvENx6tBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mreRhkh6qsX55VEMAnCGqiibKDuDaD68ET9DMDJ6gfD/mbG/3pjCr1bi0umq?=
 =?us-ascii?Q?6otmFXGhUhZsAYd/5U0rFpgJV8RD7pN0rsegwXDp5h9EfB6ufzOXWQvdrhV0?=
 =?us-ascii?Q?RZNDYQ5pjwmKb33fCmdRYu7C1St41Y+aw2OPeO6BVqfKxOdoxDX7WU3IVdlq?=
 =?us-ascii?Q?0q1ZEOlKG80cI4szoSzKq9lY5GUV/C6h8uTFT9XkRg56+FOtQ61TgETL1tBE?=
 =?us-ascii?Q?2Q0d/JHdUlHMYn1yETqmPb5shA2yn/YVhCVOhxnGT1p+1O0b+xy7KkSI0YA9?=
 =?us-ascii?Q?sLbyQyI2FVNYgzJglvs5NI8v3JtoA5En5BZUWrLsswISDgKOjuzf3lgXtAng?=
 =?us-ascii?Q?foI4aQ7FYw1IWjkGvHjqWopEfBfh5m6AgIjHaB4sVbwq3TWut85G4yh5UGR9?=
 =?us-ascii?Q?oqKLLSeAV0P3JB/UFy7yUAwSoesKzCd0ngnOlPfxxrUofGmApSnZfOeg6t17?=
 =?us-ascii?Q?CyCcWA7Mcn6+kqZDTYEXI5+85knIBkFV0roCLoGJFtvspTACgtjPibVLmACG?=
 =?us-ascii?Q?sLt4VWg9V8JHSg8d+kOzvXFC1gyFTrD4LY1AI42A7AYPbucn1iQZy6aapFp/?=
 =?us-ascii?Q?Nl3olz2/qgI4OED4YyBpkm5ebVfAmzV3M3T4JkMGaKNK5uehaT3ghTub9Ran?=
 =?us-ascii?Q?jch/LCMEgTiDvv/6url74H34haFv8lmIos43kNoSoh4SKsz76wdGGrESg3rM?=
 =?us-ascii?Q?IRCahriUgs+DZBrf/QnX0nNlg8FOiow6I5+9LEtA1gVYMFYlxgTCFgJWMKNk?=
 =?us-ascii?Q?7xsM682VklDF5ZztWy0HRntYk40h/k/J0t5RoIsfHbQJDS91sSjN+9LYht5V?=
 =?us-ascii?Q?NDWFvc+ircA7YYVL+XGvN6QFYKUpFBf3X9hOAkhymh7gUjY43EOyB31nInpu?=
 =?us-ascii?Q?5w3RdvUcv+KzBXPd8JwtZhstCUKorrseHncsBHevYjsCv3vNA+tP0qIcqkRB?=
 =?us-ascii?Q?EACLdQ5IHErDivZXh5BzblhPQ1vvdUVgPl3J3GweZqvXWgIUOknjLE0J/V/n?=
 =?us-ascii?Q?1YQgJoGldd20szXA3Od2TVhuIPRQvUEyrSYvwvYkSoyrOxkHkLSuaXgkeAwP?=
 =?us-ascii?Q?i1cNJ0bR8kTVdwrrpFpIsTvG0cUxqtBBGU7ZRk9ejF3P3zl1g68McumOb6jR?=
 =?us-ascii?Q?Y87gK0priQk8q3QDhPXGWzfaAY4c8S4rZFmRO3MAGsN3O65AsvbxPzRT1Top?=
 =?us-ascii?Q?LnmFoxnXvGSLA58WJwj61YyC96sEvGRB361OFearoas4P6y/gwoMUHVEErpr?=
 =?us-ascii?Q?27olOQmmlgVej5D5weOdOpMS8uFc+fclbUL5kweZUKnUQpwovZSS6r6YdDkc?=
 =?us-ascii?Q?JXpBrVlZcyZYp/xT4ihrUWae?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207522d1-9b49-468e-7806-08d8ccf7acd8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:00.3830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkvd0jU5EcTcYujEbD5AVlIqoNkYzjsSMbIwtUhwWXRn3uJ3YfG9Jd00fSjAD/lYDmRFk8cFeew+VVQIu1Lws3BJjFEPnLHfhhr7xllcoN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..274826a2b0bd 100644
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
@@ -165,7 +169,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	return;
 
 out_done:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
 }
 
@@ -175,20 +178,14 @@ static void tcm_loop_submission_work(struct work_struct *work)
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
@@ -320,6 +317,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct tcm_loop_cmd),
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
@@ -580,7 +578,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
 	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
 		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
 	return 0;
 }
 
-- 
2.25.1

