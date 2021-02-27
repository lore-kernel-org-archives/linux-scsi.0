Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B25C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD30664E83
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhB0RKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:10:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51252 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhB0RCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0TgY079934;
        Sat, 27 Feb 2021 17:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=wXhcciP7R68NZ9NTCbqsRF2OSJR7gXF4yfyGwVyG4jaUh1HPdMdbinpgmGWHp+J0MuDg
 dVLHWRVeXhmM8E+sq8LO20x9VTN9aGC9i9q0aGTk8RS1mWu0wevvNW6oX1cA0OvL1Hfb
 CCo9AfQMJJDmfS3QDWpYDC3OHAKeJDeJoiCX7OesuxjKZJRGIz+/6FhVVXyck6QxdzOa
 hNwfcJVjsuK/wPUpceEKtunis0jiSUIApdsxid2p1qgVBoad76tFC++xVMg9Ze2VwTu8
 mcIquaqFeqbz3hUQTPZfo8NjTdz8a18HnZf2rC7K3cavLr+1MDARFNBwXIM518RKiZEW yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36ydgr0rs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGsmD5041731;
        Sat, 27 Feb 2021 17:00:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 36yb6sam7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlPwZ9O5uvYvbDg6URAiVl/8R2zKsWPQ4/pLXs9ufxQKEMgr4KO48wYy8YcbPaNGElW4SUm8B3Yev4zBW7dUF7zgfth5Du7JTWxxWKlcwuswFBtiaWsLdLFPTx2SiCwnHKWNx6WZNR0YOjOPERudMSde4mvYbkg+pPnqkONvQ6CX8m4MZJ+1HFcbYClDZEKPPQAONAYHrWZ2fXik7AucFIbQbZ7oVg0cYAL88HC1e59CTnm/IQQ/jXkTi6g94E01FJ0AYW7f4pyoOEJjoNUR5i5lNHdSrxUeP3dpRESVzhvkS+HXQoRYepWZKE77drcsT/plk7PmznwhMYcuHG1r2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=Nu52qH/U7Uoz9irRUeF7DPWrxVCS59raGoIK2PyLwa+7obiZQSDI6kX0UXc1vqM49ME7pJh3zSD1yifMMhPSpk56lLFLY7gXw0A20BVv0b5MFxsCbnQQlKreYf9T5Nk0hBgEVRy0iSOozfZxxgP3BGsUqWXSCgRG2KbU/7IROGbOQYDeppou7qRNarmgsJWFXS8MBeYMP3w9TMKe+6gzV4X07fquaHqj/qxFJgOt0Ysl7H44gXLjDkvQ1g4uiEHP8Z2khgsUczO4BL7gMRqy1vGM7M9exH/2MMoJ7pmdU5R4J27NZhAVeTkPNPscHniUA2EIhPMSFIoxnBlMrRl5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=M+OOTCqpLTVml52cjps6eJYKdSyp8esB/JVTFLqTlS9NpwTN4/s6PKcAoBeoOpYgWUWhmKjy5MrfsuekUQ5UFK2nxFGUT1dlcKnUK6eal5HBvKTO+BnZlp5+gpJi3C6tnOjwjT4P2GgpT/3nrfOXDI8gGOgUWaioBBP8prWgR40=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:26 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/25] xen-scsiback: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:53 -0600
Message-Id: <20210227170006.5077-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 509ebed9-4692-4e9b-dc3a-08d8db412dbe
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB34991A16304383AF651465E2F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpHZTQRO4/y3OZYc7s2fUaiVr/0mQpyG6txuQl++Yevc9KzgPZPQsbMDFEe2OGdrLvFyMwYjBqQ7VBILrdEhQ2x5+/KcXFTwizafgYpfC+J8FGXeRaA6SQTv90AafPNxHbl18IxwScYadkB9TLOGzIvZ5hfDfJqnH78wPhWIApYqC5sX7TBTDBKBmssR9WwVYqlGszHs12BgdWAvh7g1GBnH/3xpvQ0Lqu9QEaolcp9LlUeNDJaHU+U3lTa3Ei0waFrl1hwqJkkJA5fV3XVhtgp6yBk5YoctTx/b5sT2u+nl1yFl9bqIganInNA74Y/fOSBtfpVgTvr5LCD2TQK5/5Fo95QgRPEnmPi3LjZG9yK0tydbxJ+HmHEOCo/XLaOZiCsPhtLwBzq35uzIzxDcBmlLahTwlWdkUAD7MVEKGZZfdRPbk/DMNf1zEg9kcxLvnJWt8MOHlRLgCcV/oT5K4BjooUP4hKBdclDsPvxZAeQJnpDXKZ2GimUG0TH+D3Cdw05ep3TNb8ywy5qD0ZrCFMlJVKnSvNTDBbyyybjNhHQvFURFgCv9ku4lQTtQhC+3iO7KrnZSiI73T8WIdwT2Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PqbepmigSEyIrv/+KASurLJIzW9yfWNfE3eWnsz47zuHG7QtYbseJLqpfaWa?=
 =?us-ascii?Q?gzMdbY7YcNU3YCPYHX9qC41UU4Xk0yedvWOeuMGYP6ejODj5uNU4M60tdk2U?=
 =?us-ascii?Q?iI9Dir5ZkmedxOTFC9F1FWNAT0sbzK3q551qHzLygPxm2Yrzv4JTLpz1vYWa?=
 =?us-ascii?Q?sz38f87R5Ey/uK/kLqYw8BiXWasQZBgXW0q3R/+nKBtI3X5UNgmcsAsHRe//?=
 =?us-ascii?Q?VRUOxwqu8kxuwutzQ5M6V5F1V0Cg8/FLHAQZ4zakGAlRUBYGNXfEg/XB2duO?=
 =?us-ascii?Q?tcu7tgsPdOGycTJFMHRU5VnxuURACPlbDPy7di3u/WSExB7XSEAwfyqJrCmq?=
 =?us-ascii?Q?ZN3xEg+MUQZc+YjHu2dAJIrSTw7n6CqeiGSBbLh31ioZw9fiY/D1WVhoDLYp?=
 =?us-ascii?Q?Lm40+OfBLNnSi+IoJRjFyWolX55KTnNtf69ZlLYWO7DWUUV58q+39+GuROTz?=
 =?us-ascii?Q?/Mtz92HRAzu7riauFh7pwpELXN3mbI0dFWdhaoFJuA8HlkocHu01F6pzosPI?=
 =?us-ascii?Q?tbEV8LlTcrB4Fd15DK/TZs7QJNcCUsGfwryWC1QjjBgpajIZmAlI8gpH2x09?=
 =?us-ascii?Q?CGf0yoC2jP34Fb7FyU8NabpFslXtuSo25ysDdFWcEOStC3+dCoRI50Vvuwk4?=
 =?us-ascii?Q?7C1rMb4x6czqo9jjXRyUaVxZ0kGcmDnxFoP0ou0mW3R5DOEKmuqxeXe3snwM?=
 =?us-ascii?Q?ut/QiSzmtrjldLSkOMCKoUyt5JYJqYH3QRW9TcsuieEE9r0J8PSk8TkLIx12?=
 =?us-ascii?Q?nV8PyA0fcMh2mydNLYN1c2Y8ZrpB37Wc56FwsU14Pq0xYMN9ffCmgx2NdUXx?=
 =?us-ascii?Q?vh9cqEqnCBYYqkGdAsq7A/aVAssN0wy2i3DCIxxyOlTMX48UHCYy8eppSN0P?=
 =?us-ascii?Q?SWeVvvXHl0MaMq2LmWcaWW7O3uPcTD9un6Up9Zv2VzLizMSBdpWzw911FgE2?=
 =?us-ascii?Q?eH2qFfsbzHmwV4e+G/dKuPatzKIStfGg8qcA0n1Xwp5+rx/cDIRpAjngxDo6?=
 =?us-ascii?Q?naRjUWV1tVcO/QSwnFQAR37v7buZa4/KKIa6S1JRAc4B28/ECZPOtato10T7?=
 =?us-ascii?Q?Ege8cNUIFUQqysJqJ0aiHP2Jvg8OCVRJEoKaS2KBbnA+9cpjsvBU9BhxlSS9?=
 =?us-ascii?Q?OWJtQwwwr6rPG4QGIQhazaU22zvs+j+rFYJE4zeSeM1+CCdXvp6gf7wxxgKQ?=
 =?us-ascii?Q?jiWLjuTY3uQk+7f5wI5mTxjo3Hg52h03lz6ZlI0t6vzP9zg0nm/21gxgco4S?=
 =?us-ascii?Q?x16jKFqhjWdhpVh9g6aWNO7+0JKU3bG5rVzt9K4BcaklUn0yHW3zagNFGngZ?=
 =?us-ascii?Q?b2jtvo/TvZXOtPOWGBCRNphg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509ebed9-4692-4e9b-dc3a-08d8db412dbe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:26.1564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrMFmJTaYMRYwazIE+4z4iWWMrO+q74n6DL4Spquynouf/CNAL9aP1obqXgA9L5IQP960FtQ0C/phzTdol2FQ0mh5+ZoUwrVJfE1kzTKrLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert xen
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep.
target_init_cmd will never fail for xen because it does it's
own sync during session shutdown, so we can remove that code.

Note: xen never calls target_stop_session so
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
calls scsiback_cmd_done->target_put_sess_cmd. We do an extra
transport_generic_free_cmd call above which would have dropped
the refcount to -1 and the refcount code would spit out errors.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/xen/xen-scsiback.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 862162dca33c..7bf9a6bede6d 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -360,21 +360,18 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 {
 	struct se_cmd *se_cmd = &pending_req->se_cmd;
 	struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
-	int rc;
 
 	scsiback_get(pending_req->info);
 	se_cmd->tag = pending_req->rqid;
-	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
-			pending_req->sense_buffer, pending_req->v2p->lun,
-			pending_req->data_len, 0,
-			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF,
-			pending_req->sgl, pending_req->n_sg,
-			NULL, 0, NULL, 0);
-	if (rc < 0) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-	}
+	target_init_cmd(se_cmd, sess, pending_req->sense_buffer,
+			pending_req->v2p->lun, pending_req->data_len, 0,
+			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
+
+	if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
+			       pending_req->n_sg, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(se_cmd);
 }
 
 static int scsiback_gnttab_data_map_batch(struct gnttab_map_grant_ref *map,
-- 
2.25.1

