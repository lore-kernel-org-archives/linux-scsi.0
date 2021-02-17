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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E664C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D58F64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhBQUcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:32:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbhBQU3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOx03109375;
        Wed, 17 Feb 2021 20:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=tbv4/8x0yQTyhiP5yx7cMkMr2zAOveoOmspuGEoAF/pTv83rSSPa/EIorVeCc6Mc/SME
 cor+UhEN44u7BPlhyDUgpkcvtLGbCl1XnRZJfxmmSIDRyMKfvIryE4mo2RlhSA8+bUgO
 7XxWcaz2aqs4qtmxi1iVuRH3eyCFltXFZrrzr6uCqHWWhYyzybkjiXD9tOVJeXf5ApEH
 JUxdc7/C7lRp+Wkug29fq01ml6B8f7WDH8UgdOEZpXsHAtLegwoYkC6jTkUKuZhNCEN7
 jB98HgmhYCZ8YYecrQiSWwnP4aFgDN7dpqXuc6Gh5NxrF78ol9dN7zTaZiNdEocQut4U 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66r3s9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQNvT004046;
        Wed, 17 Feb 2021 20:28:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 36prbpwwys-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyQl//bcY4ayGVxxAZ/f1Ayy4BMbKuYUZS9e5gZ8Wo1YbVVZ3AqUnTB0yHG1HofjXUwJi1n0G2sA/GGOcMAwQZAxfni8eqrEVqUqtb6gxhrM2il0YGjhZfMN7UZidqT9gDUF2eiV5CH3BR8vWQrxQyQcJNdz4IALYVlTNZc71M/Hzdktd/nswkLNqYMnPMXvF/GvKDBoBldnxAOpKC03nW1AYIO9stX0EK4yHzBM+i8A4F4gyGy1UoNehFBjkz7JEnXVdXqldQ8BwOnCxh/QsY+mrYpwSAq4WrmmZ4rG3Qv0BrMqeBQ2HBtosQDsJslb4kfetvnuR5cuSvpOZnqX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=gtzT2yYX56Pn/BmlpRyQWSjaOcCnHYEzGB1d+kUP3LrBpz2on9E0AnTYaw1iwinCf5g3tMvWXKORxyOYry0BaSso1O7sMvjGtTRRkrrttjPpRsSYZ6PYceuAV5pUsBwjmavfvTFD6e0/LKMNzK1iyLMD2mUjhEsnJ4C9NWdA57KJt4vvchNYXVe5cLIP/ax/zHWCfv6x1pCJHXPbnpAC7WQ1rs0OPH2bqDCVW/zYB1e/bYkaVCKlCB9Um957Jqmfj3y07aeHuQPK8KwBGPTWjznIvLkH7nNT9iKDIEkAyTujM+7fnPgHP78cO/8XCnravxYR6yIWujA+MjcPq6AwVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=JTndgcRQJIZMdMVfNP26pFMCMJyl17UWXK2etTOZcTcVYpUcxNkvZIFXEHSYTwM+rX2Zx1HNNttyFLH8dHQSsKJIs+8RQWrEKmPJ53fAht+HsKPCuZnqYk5OcHGv3c9WnNUTM61yUn1n0DK4aALvyrJc64431I+jOaLhsCz7yAU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 10/25] usb gadget: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:56 -0600
Message-Id: <20210217202811.5575-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e5e4f0c-7efd-4477-7da1-08d8d3829d94
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101D18BFB7248EF1C79B178F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvqVbprV7aH4dVcN1aFunjK/kyFez2o0PFPPJKAGc2WvgWElkw5WSvksNZKZZcY/Q5K2mqIYy2RuJGWT1nSaI2CphXTA81+EwAZUwT8SzkHtJe/wIvkdHBNhjd99m/ro1DBQEEfe1t9hjndlLBpoYVSqyQE9y8f8/E5K7mM6nFEZ9F/zU4vl0K5R3eirFVWwQzdb6LZuroQGndBqKnVEODweXuW1ba5/Nee8+0FDZ0GzZg/sP337q0vwzwt8HXAkOQfC0kUtPaWBL/Co9/xYOnlUiuu76fQbbYRKGqBdxDEwCzOSEdwSrWlUXwZEbKUQxRRFPlZ2KLG4Qgkig4EyH8+HMwWCR2jsa38gIlUYH1cyM1Hl1njQ8Rq5EJOygaAh6sSzeq5qC6kor3LedigoZw8y/jSD1V3NYR2umXruCLMaHUI4Wakq67/e1v7WjydGnui0BPRg6vWQCa5VGJwNyWQhwW7n2VxkeNkKCAONbvtnDF9yA+YW4Az2duabczdhzQne6XIcQ4u4mc8aQtBeyRj9YUQ5nIPEmXJqVIeegUyEGd6bPgQsr4x9AM8PzP/vHz6Qc/GF78DPF++CiCwJgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H+RLMphDTH3gKatkb6o9kbLPTDKtqsD4FEQX3sin37tWTq0AMIDoR3As+e6J?=
 =?us-ascii?Q?wzb/CMnFvD+yrN+6qF9/1GKMa+J48wL5t07ybuU5YKO6eH2SlP3SnoikjA3l?=
 =?us-ascii?Q?mIy0k2Mag5hhCVWEmQlN5EJoX4Y22xji8tC76oIha7R6g7W3PxTQcYKKT8W3?=
 =?us-ascii?Q?NldyE9kRnx36HFivL1QtNIKPDQcgPShbJhOwLsTeg7fBKDoCoGuiserbrUik?=
 =?us-ascii?Q?fhyXO4pEgPeDZQinseMVw5Ae6Gg7eQzPHQprjDkwbYzzSfsZZcsCNwHOXgju?=
 =?us-ascii?Q?C4Fq4QGaCOrxHjJ8SRH4vH9/GhCqW69FxbEBd1NeT6Bitji7WKaoi8UWr3bk?=
 =?us-ascii?Q?T5KlVo9RGISOiRNZZw3kjebaWo7vbGHhlwJhuAaattKSwg9Q/xsjaoxKySwQ?=
 =?us-ascii?Q?+rO3LJV0rlJka5IrKnRxKGCvc4OnyzfcR7XZqRHinxmWRtiM56SfiP/Nhja5?=
 =?us-ascii?Q?TtEbTQtgdXOS2y52n6SoNDrL4MDq4GvbIai99jOmVoQinOLBnON3HMi3lZVp?=
 =?us-ascii?Q?hdB9mp3oNl51heVCucxWG12Rs7ahKP8DTmgd+6GG4+RBYymJfjudz33n1Lr5?=
 =?us-ascii?Q?guALW+upU5RvHkdh/kN8B7fY2jcqqeev5O6JAbcRHUklfUEC7lSJKDDml3Pr?=
 =?us-ascii?Q?HBzJblJionqc9qbJFSrvBiR1L+U6biWTco3IAMQVN63l74Iaa5figpgliZKh?=
 =?us-ascii?Q?ay3TNAqlM9jWGuxaAH4xuhMwoVAss4hTbr0XXFuABEM1Jzvyh+HaNS3jaQU6?=
 =?us-ascii?Q?tBIrO334FwSHUfk1FHEZJkyRs5TdlOqes3TQyRarvEGi0yn+n0f/c/GQN/or?=
 =?us-ascii?Q?+Hu8YWeyu02Ze6bbVm9WjFxXzJWIRqv3bsTgNuHZ5mA2wV1b/gQkMQEIbpGr?=
 =?us-ascii?Q?a8zv0eLevkew+35vKeoQhUVXN9thMT+5C4CesVd+GVgl3K8tl4eVAC0XpuQr?=
 =?us-ascii?Q?yiW5Ctra977nOKmxuZOf2SYkPN8ETLCoONVjbJNBucSuIwRu2GxRK2SKilbD?=
 =?us-ascii?Q?DM11sm/G3z30bPXvDxeh7zXSduRASQF7qhbPiXPE+bzeyBAvcy2JyX8fod5V?=
 =?us-ascii?Q?6Q2SyvjyOMxe+2aRfWltJlq2Nz1wFn8AHjVuomwd/nIT3If88mb1NM8dRgWg?=
 =?us-ascii?Q?24+rP4aU7D4IRuf7mw9gsC1m1As0KLKycJviIEQPzQMYlkabgiBN1DwvyT6P?=
 =?us-ascii?Q?ZVC4RIVXqI4DvTPH/wv1kU3Zc9+QaAabEo89KGHsYDS70+2LLfAzz9szTADK?=
 =?us-ascii?Q?RnxElsLym59V3rt0FxvxFihTkpPGdE9YznL7czGiE4XvRAJgYoTAD92KsYJV?=
 =?us-ascii?Q?rwynk0MtKy2W5IXRLCiwQmUH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5e4f0c-7efd-4477-7da1-08d8d3829d94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:41.9556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8uxpZSPYSzLruwV6P5iUKM8PP08JcWL4XNa9KZh/6Keca7h6CmPGhzh3yldUlNi0WWyjPvV6WFK4JRpGQpj2L4ImQaeZ9+jF54NoWb0Mds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Note:
Before these patches target_submit_cmd would never return an
error for usb since it does not use target_stop_session. If
it did then we would have hit a refcount error here:

    transport_send_check_condition_and_sense(se_cmd,
                             TCM_UNSUPPORTED_SCSI_OPCODE, 1);
    transport_generic_free_cmd(&cmd->se_cmd, 0);

transport_send_check_condition_and_sense calls queue_status
and the driver can sometimes do transport_generic_free_cmd from
there via uasp_status_data_cmpl. In that case, the above
transport_generic_free_cmd would then hit a refcount error.

So that other use of the above error path in the driver is also
probably wrong, but someone with the hardware needs to fix that.

Cc: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/gadget/function/f_tcm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index dcce6e2605f5..7acb507946e6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1058,11 +1058,9 @@ static void usbg_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
-			      cmd->sense_iu.sense, cmd->unpacked_lun, 0,
-			      cmd->prio_attr, dir, flags) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
+			  cmd->sense_iu.sense, cmd->unpacked_lun, 0,
+			  cmd->prio_attr, dir, flags);
 	return;
 
 out:
@@ -1189,11 +1187,9 @@ static void bot_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-			cmd->data_len, cmd->prio_attr, dir, 0) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+			  cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+			  cmd->data_len, cmd->prio_attr, dir, 0);
 	return;
 
 out:
-- 
2.25.1

