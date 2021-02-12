Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3F0C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FF0B64E57
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBLH2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhBLH2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:28:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7NpC3169882;
        Fri, 12 Feb 2021 07:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=bBZl6XcBVYvu11vuyYl+TAIQjHs6gWBpMsFsnqKb2cc=;
 b=B7tKhvwUrrZuuZpIv1BOXoqWYD8Z5z58ZZ8oCxIbR8r1kJKVhi7XrROUyMHlC3izSTs+
 xnoFO/QScnN5lyxT6aCgC5lh0iNTrNJ9jXHegCI/mRzfEJbt7giZSMtg4p+ThCv5Uk5p
 qqeuhgAQy3kxoonaDQzwoOPJChedkRw8FiVQ3pyeJ7XwjpdjGqje/0cHOoDCa3D5lYQS
 pKqT7xwR57jLgwsEDb5aFxEz+KuUfhTXVmnJIqkBs6ah1+Ue1oNV81k/AsCdAc/SBa9X
 1eDXr97CjrfDTS2YpTYxSiN2uUBw9xFmXYyMNRdsFRPZ/ENUQwlGnDrWFFFXKABLR2BC Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrna555-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P9RN168446;
        Fri, 12 Feb 2021 07:27:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 36j5214tpg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpvBVx0Rngx2/cCu+BVfEXtBh0z3Cx8Qq/xH2CbFBmS8ESW/sU5D5oOezNxmy24L38VgCT6cg52SkuXJ0Wk2snfeRu3tmKtPo4EbaKPss5MmvoNgAdJf49YDVcQjD9/y1bx3kxQ92ZrWo6IXHFUgKz4r76Gbiy8M7Kl8nh5tRT1y0oe7B5VLwH9JSJv529SDg5edU9UrWZvuqXe0D7/uDNlQN5sb2wpr/2z0SpkL5kmvZQ8VlOxyyo5tQ+aCKRhEtY/qBDnTQvL+k9yYzD5rH9PULuBevWrsxWzOf9L+ntMoYcYiHiMdqIDy0OR76DJBvu0FNCngLaGMqSePLLUNkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBZl6XcBVYvu11vuyYl+TAIQjHs6gWBpMsFsnqKb2cc=;
 b=GlOBrXTTJOgDU6Petsdfjibw3tRYTNyh8Fu62Oo2gKbEqK6kEweisQfCthT79Tkp11S6mkjOVy+mCVlJNuSgu0RCG7QP/DtYR2kKz3BmehqUX8iiUmZa0Hgvq7l8RC/pDp7d3deFZXT2lnb22wRjEGqxWqFLJzlAMeJZzS27EAQI+qMltn1lcRrr0mJZL8h/VepHgYI2xhAHZoQvwSnhjMphZcGtIvG4SMiN7toas4h10vABr9TW2DstfBMcQaSJIdUKPM4tOS0iMxdKDdRZTWFIODTWTDX6jOJ1LUPLN4MVtpNAla3+FGifm6+xu5RD6n+lbPcUYSgrFGnHlMQsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBZl6XcBVYvu11vuyYl+TAIQjHs6gWBpMsFsnqKb2cc=;
 b=i4LND/z2GboV1hK8OqIiB04GXhdK+uH1fqt9X2Vn7TAsnUXEnrYRc5sWaToSCQQV7RG0UAgnBV99C74TvBLUu5vwddCnwdsyvOUwixMyuSs9gAbcoUFN/xdry+qk6bJ+v4HDgZnWnvAmVFgoKu3gDTnU1clQ7NDFLm/XiGYqyCI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:04 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/25] vhost-scsi: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:28 -0600
Message-Id: <20210212072642.17520-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30efe28f-05c3-4089-53dd-08d8cf279853
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254624DD18EFD0CE5FC9A80F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rou/GGQAm6+1R+pdbplv0J5giN++rFeUHqY3gUPNob0x5l6oqNeHUfGXvWW4av30tDnTf0v3hxsimWSxKbndmIQcTf15/AwNexo396y2H8v7MA6z0AVwnMtz1WqdwOXq7zSo/FKZ0/Gi5URe2E3xFlRaiVbtjl8NfR3eZBwVrHpV8tGriaaD23Vpm7T6LsHCLFXXh2iayz0rEs7xcg72498FUwE6B0TKq62Bd/j7K9xFJNbteQAvGXFuD63RENCZt4G7Ce9iLGznJTyiVjLbNfFPURVIC27G48ZCB6xtKehHuWQd9EZIlZF4QVG6J2W6kKo/Af50Ffx0C81EqNDtDRwWRTYP0u3pMcjFhGkwU3L7UKZOu9z9r3hoy1ceR3w2Tq8fslNiUUAj5T0xNRXUon1ZIeX1j4nvFvLLnH4YCDDWeoTCM/hFMWp6vIGXmEeP3UGJ0H+DkyrzlWbGzG/iyHWUJnmz8qBuRfLyKWaIkV8lizomMXdIwKkn9J37J68tbJgIyw45N1Dipo/AJ7jstwAKTeXwjYwjQ+lEhREKA3NFxGhypGGfG9ElSugEn+2N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T0xuIxxooDr+fT3fleEx5o1jr4mUU2XX2zucHAR3cp6CqFYdiGtDtjoZgD3j?=
 =?us-ascii?Q?oJ4j8+NPhCE5xRgclAXsI0M9aoUN5ZaPW3vV0S51YZIUtf9ZMLDHDJhu3gie?=
 =?us-ascii?Q?Wz56MWPNaXDPn3U8+YO0O8ppwLHD/iDPCWVLzxi2pUXzSRCFQcWI0erVeDnB?=
 =?us-ascii?Q?48B+Dzh4D8xD2NAmFdGrhhz/gvIZeI4H0R+9kkjhQNgorCNrwTbcCrr4h9W9?=
 =?us-ascii?Q?coE5C5AhD1b3hqdZeuHhIsIfxHN264eRZ+3NMm25bwnCEo9PBaWWCl5NDiyY?=
 =?us-ascii?Q?4WKHnYMzAvYTCNBilKExWdnUQbojYWo+6LukpWMmMoZI210dSVOzkFeGqXsl?=
 =?us-ascii?Q?dlpn26TjG1CXOlgGyD/5Me7DVCw4SsjlcDqG+nv0RH4Pt4OG1fExgewNwM/R?=
 =?us-ascii?Q?kJeuA3DnSbPYLfJQOpzt2NJzHw53uXKZi1zdU7i5Qe4YAn4sRVM3cmP2P2MC?=
 =?us-ascii?Q?J80ULOdC6RzBOEIoL0Knrtd8z2g9gbIIl72hCEbpXaBcM5PB43dt7miBlIy3?=
 =?us-ascii?Q?5k8cnyiMGQCGkAJ2JBgIbrJb9ADV7k7BuQ6uhrTw4cJnhAtPGD/940V96uAv?=
 =?us-ascii?Q?fgBY3wbVw38KobVXPfGeay6icyMmYyyUwiDtSDzZ3qDXnpo8xCyNgYu5zH1R?=
 =?us-ascii?Q?un0tyAlHGgjTzJJQk9oNSJZmz8XhpZu6NFTxFxqk8rXoi37ukD6y66Dl6szp?=
 =?us-ascii?Q?Ti8qUJDEy3Ld9RzqqQ04eoOV47ltX4h4Wqpi1S3Q5ELHY25nAdXbVUDStUAV?=
 =?us-ascii?Q?eqtfneoqbBFqC4JyxX9V0RxV2SoK8ADpj3m/3MznwDWTRiJEBl3t6pEgyi+y?=
 =?us-ascii?Q?Oy35VWc91lZFL8YbhUHkGVbzdp/QvT324pVy0aO31sXBs1c06OWr1CygGJKv?=
 =?us-ascii?Q?5uCjn6BOyQGa3rLn6JTj7mSt4haEeNSr/rCsmwlk6N9aVUvyhOyUe9QqAoDl?=
 =?us-ascii?Q?WbIprN86WLxbRdsS3aeLnlHU927KAn+EIaOQks+l+3R0IJDxBtXmXJvlPcHi?=
 =?us-ascii?Q?r+AGAw4Wr9Bpo3Acg3jzrTXbKOvT5ISV5G3JhHoTKhg4WWZyir2xY/uBd+6C?=
 =?us-ascii?Q?6gLzqrsOqdInsBKJSrleZYKcHTe+MbBvn0xJodechkwNv0qgUg43ofSZUiN0?=
 =?us-ascii?Q?lz9+itpeFICh97mvKUS7qWkC3By4t6jDb3oXvZSWCgKPivhHFWrKV21mRJr8?=
 =?us-ascii?Q?xyp58JZaJ/h3t3iQ0s0DFCpb0LirWTpxMvf4l205eKLSP+awUx3yxfJlS7uL?=
 =?us-ascii?Q?SXzIgU8enlAqPHc82IbJRryxJh8iMuEh/OIV3M2/h0U8nw5zVO4Teaga96UO?=
 =?us-ascii?Q?jjFTnBh+gcj7IGpT6pPdDDU7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30efe28f-05c3-4089-53dd-08d8cf279853
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:04.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lT1XCV4rMdJjLvHLidbkq2Aj8tl+wlTI/vRmG8jNKCuQ/fhDeYWcIZuu9egH9Pim+iDdZyjpNYZRmJvvLj+H/vQ7eFr2D+G22PFwAF/F32M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert vhost-scsi
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep,
and in the next patches we will do the target_submit step from
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

