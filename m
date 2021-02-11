Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F107AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A471864E2E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhBKMdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:33:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40482 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhBKM2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCO5bp097881;
        Thu, 11 Feb 2021 12:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=VAHnbB8xbWMLRbufWOeuFmbLGHFhYwYsOARJ6Jv4a+4=;
 b=JeTeNWaiN/1AnqjZWVqDSSVckHiHBuIuc3Bpnxx4n+w9jXgoTSP84L6GAJ7rEPdENeP4
 460BMfuuYqsWoO+o7lwYk/csx7ZqNzi8k16cdLBxITsiBgyULwUGz4fk18nkDd8O7cPh
 ajrlyhDp/d2fpfvcn4gtpr5XARfw47VXIgQv2oi8dic0Gi1PsJShNCj407BNXqMVvGy2
 qRi4Hi+g31iPlVVxutv9iyWaeAXYkIkXlDA+aIKqdiZYrxqpQ/XZW4dgVIW8Pk9v81fe
 P+SPM5dRN+FeLWvZtzH+UtCjoJo+sg0Sfw62uEzzZ6HTe29vO1LNCW+bzNYRIww4FpEK yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmaqbyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ2iD193594;
        Thu, 11 Feb 2021 12:27:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36j4prg59f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h23TSuvUhXhyUG9kHB3UvmvO6Dwq+EjsYtogfxy/JctaxulOel8LW4eSdm+/02ox9ngoH69UMsydBZk4FkeBXB0nAm2G0JwwfSuEDAEh1Xp8DlVr5TiE+W6coBwIcTukWM070ZugueDca9ENk93d9wQ4SYrdqJEnE6GN+Zo/0UPRTnQtherDUGEjTATE8cNY5C4pyDYiQzdUmEPLZMLia6Uin6DaMEuoU8mtjaioEyTIff2ER4HSay+ssbk7E9tUAjh7gKFvEkbvSi9ZkvFG/Zmbtfa0Hnmsq1jtOBSsarRp3ycICQicYh7V2R379WrEHT98Y4/prXvRAsQzhI2ZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAHnbB8xbWMLRbufWOeuFmbLGHFhYwYsOARJ6Jv4a+4=;
 b=ZK/Qz7BuCFNbM1tzLrcI2YZkSXgA4grXCWW1b7jdx3Clw8e/DTVrxxVgUxql3STibMj70VoAFKUWDX/RtdLplS+4WkG2+hGUZzGAMbhGv7ikq46O4x6Fxz5ZWRkKwpZlbS4hbwOdBOb6Eha8nch0HtBnUcwwqVsGytqlOqyxaP7RzKT0PL5haBno64mWvT2BPD3CzfHJDxfvGTRuixH2NtT01Tqrr4VnNxG7gzVsskBYz9u6L5jlyYrXTDcxpaA5pA/3n152ZSXlB9qR5wd6r7fF6UMtwjL2ZSDN3QUtv/Jj+BYHJmRqigS5Khn6RPBKJapqnSPBzDexIXzCDszZoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAHnbB8xbWMLRbufWOeuFmbLGHFhYwYsOARJ6Jv4a+4=;
 b=dKwRD6/CQptrIp365Z2IKmtwpQ5EfWAj4HexCjZWrZlzzMP796akrUroecuDwaDq/bPUKarrBRg1kYxVxdAr5phIsKosTlhuc7iBt0LP4nqZFRLxKTD7LjQAsjnqunylqgBLJrl3CuQ0H+336SutwlMulW+XD9KfsES5zBGPCd0=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/14] vhost-scsi: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:25 -0600
Message-Id: <20210211122728.31721-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeabae16-134c-45e6-1230-08d8ce887326
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339886D6737A0CDD1FF1144F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZfFOVLiV0pR41FR8GCxpJ6FIafySLwppmbmDFBOgPOY9cc/0EWSIKC4GDEFzeP/AxHdZVj+79umYxVqyufV0IdrGt1K2Yk5fLLlsgDPY9VYPhPeL4sIhg2jt7fJW/oNUJNTazZgmMcYpOZzDOwkyJmzePujf5eQxBqhQvaOdP8A/U4OkIaXi0zr586rVhy5O7og5ntnZV7aPs6utfSu+L/sIBm0I4KcHuIVxW3ZCfeQUkX3YEvlxkh7ZQIgXkEn0ZSXZ5gP4mYx3xN0xX/EMpmULfNfLuZYia/Roc2pfUIc4X6Ly6G3PNsDzzmSSSsIslsV1xnOa6qSDdVmZg5331NSBES1ooXjgKYr++SRjuTz6E/dNxmN8nbi+rw1MeU8/7/HIvwIvHPo0UGMYvdnPO1EZwaFR7Mcgkg168mOVQ0YQ3K4zeP8z2beACrDWBZAhlsR/Jv17mh1tyRnTHUkb9+diFec0Pa1UYH5fd3lTt4sZfnoF4qkrTPlO0Y9sPc//1aGdFVjPZTVor/ggQ8FdJNiUcJK9XkwXlfgfDWmFjDnG7g2Y18EK5XEDKH178Nt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tjTZewwwBDixktlD2TiMgSinnnq/J2vmuTbhcEDhv858YuEGCbthkDn8IHn+?=
 =?us-ascii?Q?zTTscUG9NfAHBr6qfII8l4na51R870xOKe0+ab8OzAh4Nkc/bsOJJ9h57qp+?=
 =?us-ascii?Q?bqfOVCt3/MWIUg4g1hGGCdE3HzfkbNBydSaCBc54QoQ+ruLXEf0/TJksyjfZ?=
 =?us-ascii?Q?j6rfE8jGMyEUGh22PE5ro6YAtkBZuFHbxRsE8iDoytXt4QNiFOsCAZE9BF2O?=
 =?us-ascii?Q?dOlBcrRFBkla2eJwHbyPUsO0Lslq3MF1Hjcqj0rQLPEHwUGkJ8tWIfVzoVXV?=
 =?us-ascii?Q?9HRFAvmY9HrHbtzqWLXwSH0iSivPR80/S3d0vY4tFrCij762qALI0Y9jK//3?=
 =?us-ascii?Q?5kau1aG8rvEmCJK9sMo3yA38oM7+U2NplWV6zjwTmzHauuRzqAoac/LN5rdk?=
 =?us-ascii?Q?JEDFkmRC1jTYLcnbRzJLP0mIlj+XxED6ynIMRC6GUMxjJ3BAKWAyo6LKlYDW?=
 =?us-ascii?Q?OK/vycATKH8omUOKlZI2l2CUxfB/ppBrqDxAX8CZAz+fU8qvvdLHXc7m5L8Y?=
 =?us-ascii?Q?GOQlkm2WBr2lrgVzTIicA0zHnGSH37VZLUhO38MMqkOXLUXmeCEH7LnPQPkK?=
 =?us-ascii?Q?7POof5TQNwLjdZ5u7roqVQTFfIvbQXk22pQNKmns+C5FOUuG7N30bqZKj7Tu?=
 =?us-ascii?Q?XFgzbBLjPVr5tA4yMmid+XDvv9RqcKl9mud9nvLYfeQrlxTHA9v77H/S2AUe?=
 =?us-ascii?Q?CnRsXKUuyAp6QXBMjBwfo0QXNBdZLOkZ+5cwlVYg5pAE1lvqjrHyWxqDJGxj?=
 =?us-ascii?Q?+qXkwUxdODZBTSU0O3qiXUXkxdYmxiBn6k6Fvgg5Re50pdbbLZGVEjH3rFPP?=
 =?us-ascii?Q?q0S7ZFocsX01YweObJ7QoMvCzf6LcMnIxqJWizDlULuTxiZ3AGc+cdNJM/Yi?=
 =?us-ascii?Q?K8duIifz/fJJ7IbneloY7bbdPq6lgruNhd9VgXbGpyozuf53P5bG8SZ7f0Ky?=
 =?us-ascii?Q?EBUNkYKhBRjgv62m2en4JV4gXaXAUw4FBlknfJcl7VOpVliHZ6FGQZP73hga?=
 =?us-ascii?Q?fOxhGsmpU0zc92sMjo/TUbTg/KNgn1SsJnerrSk24CZL9vGP4B5BPaw4Ij5x?=
 =?us-ascii?Q?+mKkLE3Wb+aEAeOTyKynhQhsiQ2xRp8kQEMvfu+w3EHasqqVAOLAbcK0/xZa?=
 =?us-ascii?Q?VrOdAfG/Dso/D+nl3aXrJQ7TmaIqMunrUWpcqmcWLbCtgPKV5PA87wHrofYB?=
 =?us-ascii?Q?amq7aGQhj79n2OAyVUpRawM4GPbOY0b+G3/yL++m0CMGpdz7V68+CV6qq137?=
 =?us-ascii?Q?wC3CjAVSJI+JK2OcW2dStJ1hXDK8QLn4AMylOmrSwZbC4VLzSZB+9m3+SEzh?=
 =?us-ascii?Q?JfPGsKavO3NgOhat0UYWtxE1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeabae16-134c-45e6-1230-08d8ce887326
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:51.9541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4obilOcjh8hQiJlY1F7iBkazWwxEQZQeUiB9P4cOXJPVjL3zBGefj+NSEbZT5PTAzEmL9bXWrb8Nv8vgMFSV/zZAMH0bfdXaT1SDXB6CSVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert vhost-scsi
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep,
and in the last patches we will do the target_submit step from
the lio workqueue.

Note: vhost-scsi never calls target_stop_session so
target_submit_cmd_map_sgls never failed (in the new API
target_init_cmd handles target_stop_session being called when cmds
are being submitted). If it were to have used target_stop_session
and got an error, we would have hit a refcount bug like xen and usb,
because it does:

if (rc < 0) {
	transport_send_check_condition_and_sense(se_cmd,
			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
	transport_generic_free_cmd(se_cmd, 0);
}

transport_send_check_condition_and_sense calls queue_status which
does transport_generic_free_cmd, and then we do an extra
transport_generic_free_cmd call above which would have dropped
the refcount to -1 and the refcount code would spit out errors.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..76508d408bb3 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -789,7 +789,6 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
-	int rc;
 
 	/* FIXME: BIDI operation */
 	if (cmd->tvc_sgl_count) {
@@ -805,18 +804,17 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	tv_nexus = cmd->tvc_nexus;
 
 	se_cmd->tag = 0;
-	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
+	target_init_cmd(se_cmd, tv_nexus->tvn_se_sess, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
-			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
-			cmd->tvc_prot_sgl_count);
-	if (rc < 0) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-	}
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF);
+
+	if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
+			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
+			       cmd->tvc_prot_sgl_count))
+		return;
+
+	target_submit(se_cmd);
 }
 
 static void
-- 
2.25.1

