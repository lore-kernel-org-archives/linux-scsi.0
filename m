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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD85C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5682664E76
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhBQUd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbhBQUbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOdqK147616;
        Wed, 17 Feb 2021 20:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=lWAqmefPxoHVO+eyUSxkFGoEVJIwmHv1D5NKuHU+KLIL6QOM8CwGpC95W3fQyr+jZDUt
 xgpA23GTTdSf9EYT0CQGkk29KUIYJTnFXKOTzs9V5g3UiuAWXMuI7sIEiDrHNW6+BNMo
 LIxvjGcSiL5FOfcyMe5sltdTV2bd/7tXYqGhThPmnzRrMuq3ObFCyuiNGvcHI8boB7bn
 +xovBD1fp4CnxOEhBGgwttGx8Qqnt3KdcD9+etEz7DXn9ER90C2jY+1+8VjIQgXYbMTj
 EKpkmpINa5CeWcYotCIpuwfa8f6ukBmfPyHshW4ztKKnIBpPktr7wgzohHvrRIGThLbE Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36p7dnkpk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQCcA191586;
        Wed, 17 Feb 2021 20:28:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 36prp0p6cr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NswLavDKnr5jD20amtxxYfNysRc3f1GJ+cp6R0hPSuHUgb+i2TREq5v3od16xeXbdjySmZaBZXcEPcSo/VE9yUC1vcKelvFwYOl7AwW2Y7h88aMA74JNQX6APJ9w28U6cud6iLrr7F9kpyYnAH1ZCmwmJ7Skkp6p5RB1S3BAJYomArZ9YspLXlGy6niW7ZKxllpQc9OLjdjxNa0tGAjwVrEXIwh3fdJ0h1R8MAVX+DI32Q6sBAyqJOM95r9kMBAQaTh41uTvqnTtRUvAnZY8uhXgMEInckyCrFdd62NGnkpZu5gTvZxL/Aj3up9OrQthvJF3PELSjti5UDSR9SN6Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=Ml/mg4r3Cl0WMg+VywUBmpEERv9+6uoCVIQ9WcCp7MUvvK4KEOW7em422+n9kNIfF+DfsOftL9U3UFpnKwH0NBynP6/1ZDnmDgwPRCSVKiU2dfeD0icBpGlO3oBMsDDn6ryZHN3tD19zKusL1D4qc/1N8VV71DHI0HqbUJ6WGYJYIKNZ/1OjfmYW9lZu/DrUaXiHnI/WX6pQDVPMxd77pW6zgOcvVfx227GoUdKOJyL7VipmpvKd0zPlpn7kVyBAsarOI+VNY1nGAwRHo31viItsEVppoXjh96hmk8FOq+nHj1u2oCbfbO4XL1OASSBWMHh9sYsvWar23WYpm5pV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=fzDRqOjk88e86CyEQ0UL0lJMerGKRQWqC62o6ZeHC0tGaVywGvZfaqt1s9nTPWXNAeGyIzLhM0yxDxhtR/fm8O4DuGuFJKyKp84k2vP2j9CaRI4DGmGEJ6FoUjdFdpAqziGG7cmZKo8TClVbS6Pqk05Y8SaPDsuyjvg74Pdn+xc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/25] tcm_fc: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:59 -0600
Message-Id: <20210217202811.5575-14-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edcbab2e-3bc1-4aa4-7691-08d8d382a0ba
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101DC6DA5B471D82B392F3AF1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsyIN2KK0rsAYx1d/jJ2TVvtffhnmKEsQaElC7WSq1GjVltIvJF2XWAIGaOKPgu7CqCAN/da53hCMAVmmYgfkDrPduauXF6etCm4ZSJyOn37K8J+JdlTB0yvyqtPxXzyhuDd/BbnYGuiIwML1YiXPVoCZ73kUYzBidrKnulzGYUoXhzrFPz5OGyOY24oXQfME9SpCjZ8oDCvILn+WyLtmBeGoeTTPzQ8eEOmam18e6SrRJAcnLSIYWSTCDq03HOrQbxTbdCOi6ACJSVI7dsJMDRDRwjqWrK1EW6JooRGYafcV/6qS7WgCPiUUaYG7Jp+/MMzCXBJQY9GVqBS42zouD5nYBR7ywsg3+WDr8+V9Di3iVXq0nT/fQ9V50iUUIR96TRcQX9QZesgUkVW37u706kHWi1XsmqVZOCwZkyXi/ucIESyuRwMDr7rqHpF/4e2PMH0E+BKy9N9JMtaZK2MmP6E7rmrD4m+rO4HzMx6JtFTKQY9wJHUIpARtgTjXrtD1fubMimT/y5T6udT0Efp0PVrFapS3x+HFN026PXvP8gBb6yeMXGWof1dgnpqyGoUUi1z2qt8cwJUu6He64ts8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JvB6dYjtQBZsjdnaZ25xBHd2kAsEZeV5Nx7NBCR7vYBDRtNnZ2R1/MPPlQxF?=
 =?us-ascii?Q?GL2ZMpFCD0KLP1FqXImt4QxHuLMQ+4Iq+vQKn4hBvWGbYKnTznPM8+MJQTb3?=
 =?us-ascii?Q?3kA6iGRRU+TnOjUIhlXoio2NzGKK7ULoRd7Com36m3It3Fl+ZNRpjdZ9LFNl?=
 =?us-ascii?Q?52h5jk2tLPeHOVOS2DQMza3vLnyZuvUWAN87bUuViFQTO/SaggkMmv2mBT6L?=
 =?us-ascii?Q?WHPesSWOEbvrPEfeDMzKfMDP6X/P++5afmUEKKztR7ncDyn5blyLW6mu2uIr?=
 =?us-ascii?Q?2z90hwdcvVQ4y9hb6ucB3CvLquofLzeu4BYZjnf76m9fgSt4qgAy9F/4osRf?=
 =?us-ascii?Q?zmskInXrvTxBXiMXrZ36HPLVnuZ2yXWkFZUCWCuV0IhoCIzdtH31kB1jRSSm?=
 =?us-ascii?Q?oU1rBINweHaiFRP+O+2qYBkXhEDCjR7UwDK1rJuzgzsd5dAa+vPzLk/0bRmj?=
 =?us-ascii?Q?pXQQMmWYjPmKHHFkDC2TeHPM1504WlXzcFm22nhOQmFragvUSFRKCXjpxEuT?=
 =?us-ascii?Q?GyZ1fTRxQoZ/jqfJWnYJiPszRBKyLipcSUkb14rUqEh2vSCWfC63E5RpzcmA?=
 =?us-ascii?Q?91YWnqkbyglUMHCcqBNcMhzV2uoSq33BA/QW4WdeIEuOMtc5ux7e85rOB5P9?=
 =?us-ascii?Q?O9votZWhcO9eKiWUbh1GR5WCPmYi8PdeLTYCQIxzolIyKMrG+CtrTrECskH/?=
 =?us-ascii?Q?5t3D24/qZIU5qs2XscCSuhwB1rIPMGpk4cAVv2fH++u1OzU3uNn/hpd5XXl6?=
 =?us-ascii?Q?n0yX1BsgYv63HIGwtCS72jWYPO4IGp/28CMgQ8wwGgKSWpBPO+CaEnjAX0/L?=
 =?us-ascii?Q?Y82D/AejiQi048ad9Wupv9vJ9LpmvqhBGG1m10b8Ou03gW26y/Cy3z0s2gGB?=
 =?us-ascii?Q?ST/CX1PS7mtIP6aWc3MR6IesI2ZzANe84POnIuJpzR2RniYSJHejNzNDKIdp?=
 =?us-ascii?Q?UsPUKXRvU1ztOHVDVBmg6+sbiK1RtYqPhiQy09mP36i+C1qoVZPnuSPZkRTg?=
 =?us-ascii?Q?XzFenwBwyviNLLEAMoJ2OGSwGhNppZf8WL/50gQz4JJJ9oUME6kNGNYrGtJU?=
 =?us-ascii?Q?1kfcGllbaff+ur4sd9JlTj1ZfNIDv2WneEp+xL9ghIje+Z9GooH8/fFXOnJf?=
 =?us-ascii?Q?4i9qYICauaIv459clvYgz9DOVQmLpoPu9SkHTENI61UWvUv7tH9fKtY5A/wx?=
 =?us-ascii?Q?7cN21hBaDOruW5oN2DRxgOqIerwWRy3Z0f2ycn6WFPGbku8MmD1qhmGo9T8k?=
 =?us-ascii?Q?XqcVSzmJzG178QUCtY5HxYS4r0GkxGtYkwxNwqTQ47eAUxVAfXJFvfBxxZ+q?=
 =?us-ascii?Q?09S0I+2CoswFt96XwZUp8Opi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edcbab2e-3bc1-4aa4-7691-08d8d382a0ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:47.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxYjW4xlbhjZFi4T0gRRHgtf0qKAnLlHIRQqE7mbMxJE/wgDQG4pEZ7/7/py6A6GssBfFs3FvgJxsXY4ISi/uX7t/Ps+pCeGGF6wyXRoic4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session,

tcm_fc uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit,
because target_init_cmd will now detect the target_stop_session call
and return an error.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/tcm_fc/tfc_cmd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 768f250680d9..1376501ee3d0 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -543,16 +543,22 @@ static void ft_send_work(struct work_struct *work)
 
 	fc_seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	cmd->se_cmd.tag = fc_seq_exch(cmd->seq)->rxid;
+
 	/*
 	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
 	 * directly from ft_check_stop_free callback in response path.
 	 */
-	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
-			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF))
+	if (target_init_cmd(&cmd->se_cmd, cmd->sess->se_sess,
+			    &cmd->ft_sense_buffer[0],
+			    scsilun_to_int(&fcp->fc_lun), ntohl(fcp->fc_dl),
+			    task_attr, data_dir, TARGET_SCF_ACK_KREF))
 		goto err;
 
+	if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
+			       NULL, 0))
+		return;
+
+	target_submit(&cmd->se_cmd);
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
 	return;
 
-- 
2.25.1

