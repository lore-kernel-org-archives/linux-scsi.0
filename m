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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623E7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27C0864E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhBQUcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:32:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhBQU3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKSusL122843;
        Wed, 17 Feb 2021 20:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=awzXv+ANh7ITB8tXDzEV98mPACB4Ubg38R0b0/vcyysIbFlHcRCJWJoj+cKm1HEPMwVD
 6BbqonIji8fXMbRUzdT+VDgex0sLVG7qKwOGdESXEWJXfr8zolWLDsQKbhXuq42d6Frz
 hD7VFSUL2A98RTaiaTyUEa4zP3dj6yWi8H3UFriu8UiDO2UtrVkpHQ+vBnpGEi8W2RNn
 n3NubqlfaA2RTtkItRP3GK9A4taMlvoUGe5aDp99GXUAyOpEJzWpjq/ZPq0/DURR6tLj
 7Q57MERo7yof4M6KIj3KupqPt1LV6hVT99LzgNq1GZ8D+MAyJr+0tAwFjVdidwcIvHN8 MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r3sa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQCc9191586;
        Wed, 17 Feb 2021 20:28:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 36prp0p6cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF5/OK2zEv1kl6v4Uugtrhg7HOG6hO/zwIQg8wbkxPZMCrdlu/4Dr/+UTamJbGoYYqlWxpONfP8cJhybLLTbxg+QAiczr0mfy6lA66wasfa/N8C6WP/gNjKbzOO4ZoxdQGYSttGX+qwH+3ISoS4EDEYRNQXGNCLoXWcsgwHnHqHTTdAv/hUus0+qIw6ZKW8qk9ddxUI5vpRO04nss3nzOlFklMSiX07j6OSJoDl9oVMvYzY97R9LT4Z5cpKACrHjysdE6fMljlSyItM2KBFp4rpsCvYbRbYo7G+/MPu+YAFSNyypMnMoc35q74Y0BZNAsj1UiPwF44+ipaT3Hih++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=MSOTr3Yr+mL0Eogmvfdz1K9dAaXUlSJRfUJy0QoY8Z31roKE14Yr5wutihaJtg6EQ3Q0xz3Eaa5EHOnsaaSWiadmDkvlumKQB2Ojvdk1u4mIHhKEClE+i2dHryNrdR4JOcz4BMaYXuTmWJmoKxtuPwiZdCWNDf/DASlqM8fPqd1XN0NcoTEeLf3DO1cHnQE9jRoxpp5hH7A98Af2LSAqVY5IS/nxANKSvGvRz21UfHKxy5ESpFOEVMfWrEhTSQjAz9UZoxUgWnZpTzXbOVofsOhb3W3tgWdenhai9S6i0qyF6XeCR3HPgTF+cBqgKa7tEjJn2Y7tsVEHnomWGWUw+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=0IUGNExD27vybnuCXWz6O+97EgbaKsQUS0eH3uz8nb1btEp5Y7HAlu6sm7oPdJKuXisYgL7vd8lPDWGCw4SyMHhDJdb4vBln9DI2KeZ5K0P+6TNHs0fvP8nOvXeT/8hw+fX8YcjKyH+DoAPDX0spH5T6bgu1NuRwsTDQvMAcZK4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/25] xen-scsiback: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:58 -0600
Message-Id: <20210217202811.5575-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e980658a-c36d-4b23-e3cb-08d8d3829faf
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101C506EA41CAD9381FBABCF1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VOrBcypIz3w8xItLRRDd409dJG2EzTgQUBnQcru2Gz2pQvP4SzishaZVbSs5QE1+Xgz0nyCTPt13Ht5/8tXJw4bJKcHjUp/NauASArYz5vRIBwSfeIuOSKXUgVGXoZDH5VSOSGfH7wonhgHH0GMaUKwZCZAXc5NGgwnzBxqqZwMg47FqTEXFjCeqXdeuh/wqa5T1+gwq3AKfWnb8z5SGM/Fe5AkKUK3RxZQ3/36eYb2Ujw//xZsYY815MtOvV/l5hY6PInf3FGLvWmvqsvYqDWGf9PHtkD7n8Zlh60tz3Bkq4B0Z1fqdPjpPCGASn20g3RUT1HyYDw5hxVnc9YOWxw7aHeWvWltt6Cb1+Cb6IeWLg0q5bPC81wOrx35xokRMIw6pSXljZD3oNhyv4yQ6OB0EBxo/Zmm+Rzi98dp7NoVSUXO4K2VQYgViSgz+7h9DgXOBRUvOCfAzMQCCFNJmW8j3jf5EwkKYewzdYXpsMywVId6tqImNisjXJMonqy+HOWUxLPeyNY0s8tXo/M4nFKpeBtZ/7PPItxEKmBm7Y3Bu7+Fg/FrrXkYDOw/PZL+KE3M1V5vZL47dLd10BGgEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Obm7ek7SYCApre7zf/nsSmQaesaw8OlCa6LUBKCBPhm8uY+cO6mRgEpFtd1g?=
 =?us-ascii?Q?J8ubJVkftTEN/YtpbeNhE7rB5n7rrLGF/lIWJ6j5UeMKVxcSxhFPU3lu9RMz?=
 =?us-ascii?Q?KVG5hC/5HqP7CDMtKjv6+EvdLueJRxUKLfFyhd/78xokADEVV40432KC1taQ?=
 =?us-ascii?Q?yokLYUq2Vg4qg0PpxtysFEu7LBe93cUzEj1qqbJ33RSEWm5ZERBYHswmmpBX?=
 =?us-ascii?Q?k854W9LoCfGAxGe3uYCJm2Kc/FDbxU4qhQd5396A097R6IFi4RXk0FLRSY6l?=
 =?us-ascii?Q?XhUcSt+s8tjPyy4aVYX0osB5Tn+WwxLRhSJphLQx2HgKDxWPGsA2/QS4D9QN?=
 =?us-ascii?Q?tlr+d28fQob74SSg/6t45rwaLRJjcQPXZhLaiMqw/PYtnryjIqkM5mpDtTS1?=
 =?us-ascii?Q?srqtZjKdXVrYRGUfAO0dq7Djd4Z+XJr8PmNmqwkuyrbmmO39wUDi6lQ/0kLB?=
 =?us-ascii?Q?jlBJJstfyUscvMTw/f7jQvfCWfShL16Xy/8A3FG2qHQX5+/4OyOEVWUs7Nzf?=
 =?us-ascii?Q?QBRJNcV+Yb77ARgcDcH51UnhRxFEdB64wSTDAtW6PPgMVFNr196mZmtsk7nC?=
 =?us-ascii?Q?6jgncuS+hZdRmAudsNpcbB/pxoppViyCYo5YIN2HK0MJvyJyHemj+12P6Jci?=
 =?us-ascii?Q?SWFIJWSDtaqR40j9IGZDMO1DSzeKE9SkihCrBHG7/z7v8IJ+Xe0WJtc3kkaF?=
 =?us-ascii?Q?gcfR0TPKom+Ery2QDikHZ9tt3N52LCXaPi2igHfEObtkO9xt3vz5bI7e6msw?=
 =?us-ascii?Q?oSaZb6QdVQnvJLZFHsaxqP7TVlIqzK09PvdL/1utJ2Bb+eniih+k83pkFCyI?=
 =?us-ascii?Q?w5OAqg8zERe+PeI0gs2B6yaW2w/4IzYrYA3VlN2QyfMOPELbNXmKdQjF8XG0?=
 =?us-ascii?Q?LeRnMas6vy4BjkmUgl7S38ESX7wrQC4jnqMytQUQ73vEt7NNj23/pGMIpBcm?=
 =?us-ascii?Q?7NdpSNUNjkZWVIaQKi+yeNxeL68xHOU7+5IbbtkiBPnksRbwH+ATCmIpPZwX?=
 =?us-ascii?Q?MPV1G8PcHTA2j0S17Hl8Ag/pgQFVtMZpS+L47pm9K+078C5suNvYWifaIExc?=
 =?us-ascii?Q?PZj5bkwZWYqhWrGqzO6KmEG0RCV41cpZhuJ8Zg0g9POXLVSER3s7+Ac7sw7Z?=
 =?us-ascii?Q?0A3mCVa7JaGbHM8KuwNsQuWpju0UzIvtDRFthcxWUXh+T/Z17hzY463YBm/i?=
 =?us-ascii?Q?11c3QI6dx0avDLOcFF6EnAUDzzitHsGyuNBqPdlsD03elj4Bc1bLQevvtZ4i?=
 =?us-ascii?Q?U3Tm9ae+4EieFTMz1dIr8lEOVGHdpaXH1lYfx4cwVldadlEoiIE1Tq9aJ9Pv?=
 =?us-ascii?Q?AlAbra1asbpLTkJmXODip2Ef?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e980658a-c36d-4b23-e3cb-08d8d3829faf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:45.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzfLuw1mYP27+UBPlKC9kBmCSXiyiQ7hfq/93OpD4neZrPM4JZGwA+7GqNsaRWG/Hii37hnURsANSnSaylKoH+ByXD4wKzAFbFdXPK3PJfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170153
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

