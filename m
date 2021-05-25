Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982F2C47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E24061408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhEYSUc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44150 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhEYSUY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFVht125090;
        Tue, 25 May 2021 18:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=YpoJbLaMIIeHlF+uVQecXCsyeFFlbolTc7zlF0mi7pBNEHSK0JI/Q1tTAE5lDj67dwQV
 5E8hZZZLU924bUCPqaKgyk4T2OGlAcbzF8UOjGoLk5LXQIPNt8wDH9D/rGwj74MG6M70
 L4OvXYLKUu2oVZhe2dh+DYLLzmm1A8sij/057ual7mpAczncj9WUM3lhtX7gnw+5sAEf
 85pk9VuqQK4sWd5FervxtpmK4ytBeo1KTCCvHNWtRg39p6tboBIwoaK0M8DLePvmu+E6
 4LLUU6m6/u3WOnY5tVcZGQq+sAXdohDQk0v5MbbBpgMCiL0nenyP/OxjCtFsXnMf8ETP pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfceyrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGDX5010869;
        Tue, 25 May 2021 18:18:46 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 38qbqsgh0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSJuBnU+5+d4PkfpWtQyLPLlsIL4PlhzpRQG0E//Qe9m3N//Y+y5IkoK4e07FpN9+Y0MRTdjC+EKXjOjfqLEt6jU4u3c+fnHOmKN0aFdGOohgDsxBb6UWUrsDIS7oY0Rw7oFAw1/XaX6LeuynhjbtkzeY4zi/4OcSK8rClXtQpxx3e700QkqQikAVcTaC6Hcaf42AVQL/c9z5Dqzo2AJIqZmr0SFC0YjZW2WKNBYMfsYr9/LnPKFODYRVFxn+zaPdJ+642y+QXTsMEsyzCCfBEdwZBUiY+gPtGMtnTp9fRuhCtObihSa2ztHTtzfvw/OSixjHYbwSsrBAYNQvww2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=ikV427tLenA/CwJmQkMpqqElVYyo+XSJhM4AuVDyGTyd3DQt6peDLdTdXvSZC/TTmVT6ZjvOytYmG1KLzNR8xnpdnPlHDCcDaWETSLxgLk70n5JTyvJ36Jfg1BjNnuGU0xV6YJxkNA5tGoezdVGN9dwiYfpqFVb+KgddXkY1YrYecXlinZ0Bih0qe4H4LRLFk0YrbMkUpmGdF2msno9PAUJDWXgpY3RkdCMgUtpr0cgyg6iAzFuMMMzRhdcJZhwHnBYLedXXrFPt/fxmanBFxCVR96WWlrPEWw5U04UrbSgU+kvOjNGJSGA4/6ZfqDBgN9P7D2KPSukVOEdrWkbxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEMuAWAvBA/bJHR/aPTTEQUBCaFIm/HY9Zw0x26Y8jc=;
 b=bmBEF3OekZy5+fQ+b4qeNDwvey53ke3Hzko/Lh9M7aQ+tDFx5RqAG+n/5L0GoLqKsxi/QGdwIaKpHx1xWe8swRX6ecrtuFV0iFrx/vUcluftZaRzLxjd/xs99y0KPQWXcM+oNiBDdrWJYQgEPBdEhcaaSv+0d1pW8bIuvFmzCuU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:44 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 14/28] scsi: iscsi: Fix shost->max_id use
Date:   Tue, 25 May 2021 13:18:07 -0500
Message-Id: <20210525181821.7617-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75fd3701-5214-4513-3027-08d91fa987e9
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38916AA8D17CACE372A66378F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLBJSqWDmD0UyOl8ew7POyJqLRLr5kRRtRLGqu1eNQWn9RARkFCAyOyKz0C98rwxIAF1FMTUK66BxdqEK3p0QMRQtvytiX4T2MZNqyPv3wo0oq5wJ+1R+52NGRtFMy+LCmJ9hWcuXcFPsCI7fkCXsN0OfchsjuMkIHrrayd7YoShre1j9agETgzf2doibvKrh2Y22BH0rwaCA+XwSVqI2n+Bdk7MA9KvTQysq8+lSxJIY9lakVD1SpiOuzN5Z92K3zXTZcDVopOueoYwQQjdpcmkGMNuJz/AF7uksnx1wmJx4rdzEAGEBUX3BSIMEqm6H2tvdAZPfSoifo6Pth5NSDH+yLeCN9g6TzSPqg7rGgwBlFlxOIKV3o9O22NT1dtVQx67EU/XKSCbs9vjPjwVqCqyH2crh0/J4ujYiGVkqyIJdKzqQE59sAU3f8Wy+LYVLjwXhOqU/23T9KfyX7vRhYq1sGvspTRiZOF+lVcB145p40eTL7PdUQD3DOr3TLe1imtVw8ptK5Gjaer9jrkMjm1l/kfRfnOP1YuRaj1infOdCvqqm0Bvsk2pYauIQG6mVA+f2NxdoBDqU/XHHaxl1sBJJsYNvsMgtjfn6OLuOgNWZkcKVbA1g00xQTZsX+EP4TTTd071/uVri+9uSPx66XmHKuf3OzwMUw4YON84qkZY0jKJyCMu3nQ2MxFG1Icj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pPwB5U7+HQI4M5+Au7rjUGqkOmSJuaDuB3rJz25V2hk0YqDU4oGNBu5Nu2a0?=
 =?us-ascii?Q?TP224vQcvpcTDUNubHXeuq4O6vqwEvxxBi1M8D6tY6knkRprnnl68l+Hi5n1?=
 =?us-ascii?Q?eYiEbuvhGTQ2USsXO9chTsj/2m7P96T4cty6DqngFOR5ukHwsX7EX0+QMkxC?=
 =?us-ascii?Q?YKmKPp+Bj3u6dCqDFFO7sl3O7Wd+pfkAKQsscjJHN4a7qvNmI4D06EYaclBL?=
 =?us-ascii?Q?CSDe1jiQXh872UxQW4uKBzPX+KrqCiRfVLD3CAz+89dp1wqZNzFKQ6LIgUjt?=
 =?us-ascii?Q?jzlbQRU3R4lfbXby3zqeC/yuLSoAk53PQI8VACq45jkZ9thwia3KxY+zGXLp?=
 =?us-ascii?Q?wiQGDqpvMvU/OVgh97DG9j2GnHsE3E4s3InHN8ycyWVpKRluOoyMn2d0bo0t?=
 =?us-ascii?Q?s9ypqTGCfbBCi1IwwRghJ6kVDINBzfraCRmWxHjofpN25Ojutjt4LafT16qJ?=
 =?us-ascii?Q?/i66P4Eo2MOxovyA5VxvABGpJFuJ2e+6Q25QFiIOtHwh+m2Mqm/vecrnXbvo?=
 =?us-ascii?Q?Prt+1WaqY/99fz4Fpoy1CNmry+SyOluHCmW32tNDyxllsDsEkaUKLpHRK//r?=
 =?us-ascii?Q?a51PQJislVTfMIDuY9Ii3mxK0Nn4W80v636IVhCqVu6NJ2a5PVfggkgzLper?=
 =?us-ascii?Q?CAaV8osCBbwxCx81dEVBgML79cKuFotKcH5qKwwjdlJff6gsRtRp06XSkJcI?=
 =?us-ascii?Q?mOQDcFtnm3xC+82kCV1GoA9O379wgHbV3JgSrBCeBvEgbOKu+rZph+iqFbPG?=
 =?us-ascii?Q?O1ARZkOBdlwn/n0vRY7GE5rY+9oumApwHy5qllXDPf8fKknmlqGQYMksME0y?=
 =?us-ascii?Q?H+jtDZZjKDO6NDGdAUhUbwn9ahXX1u0jfTTpuRMU/3Y2FKsVpQSWP45Fddon?=
 =?us-ascii?Q?MWTnoqrU5AgBwH2sImb5CD0lF4pRaEb7SUC7VS9GOzcoHQWYIWPl+U4h7f8+?=
 =?us-ascii?Q?ZTFNCv9o5Tc8wdVeqKSSqqyjQsHL9hyBe4fZRsziNL6VRwg9rL4jv3hI+rMZ?=
 =?us-ascii?Q?9sqQKVWD/gCtD4MDQfaEwQZBXNzrVowTRbHA0p0rH1CKTp7TS1N4cIVbyjcI?=
 =?us-ascii?Q?KC9dCBkkXbn4W5toawlnNMMpV9sBCj5HEL2GD/wld/Ggwt8ZoIVW7sNAKURC?=
 =?us-ascii?Q?Sy3VqWL4/oq/JYA7jWTmYQs2Zxnqh6lpVfL0ru6mq0N8f0Lb9+lP4Qz/f3/G?=
 =?us-ascii?Q?WNFnuB10105lBJ7t3uq6MFc2KbaS/eX3dYIpMBuoEiripLNmZrFHOVlwVozX?=
 =?us-ascii?Q?OmlMx6XnomaI+NfiOSc0YwldKa3udNIhXea12i+njt2jHJtqv9++n/XyyaEb?=
 =?us-ascii?Q?5WVBGsrSPX3qcjquvqRmanOd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fd3701-5214-4513-3027-08d91fa987e9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:44.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRxMgo0WsDAYW/y20aOusd1VFO2JSy9NJug3wxf3EdwBQ4cmq++V5vdG/owuVpZOacZvlhM927+gZLwivzcABRdwO7aGVLA9XIhlb+TK7jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: f_oK4dcDRZC6qY1QqOEnNiudEV3miHC3
X-Proofpoint-GUID: f_oK4dcDRZC6qY1QqOEnNiudEV3miHC3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi offload drivers are setting the shost->max_id to the max number
of sessions they support. The problem is that max_id is not the max number
of targets but the highest identifier the targets can have. To use it to
limit the number of targets we need to set it to max sessions - 1, or we
can end up with a session we might not have preallocated resources for.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c  | 4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c    | 4 ++--
 drivers/scsi/qedi/qedi_main.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 27c4f1598f76..d941e1561527 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -416,7 +416,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
 		return NULL;
 	}
-	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_id = BE2_MAX_SESSIONS - 1;
 	shost->max_channel = 0;
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
@@ -5318,7 +5318,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
-	phba->shost->max_id = phba->params.cxns_per_ctrl;
+	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 26cb1c6536ce..1b5f3e143f07 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -791,7 +791,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		return NULL;
 	shost->dma_boundary = cnic->pcidev->dma_mask;
 	shost->transportt = bnx2i_scsi_xport_template;
-	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
+	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = 512;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index dbe22a7136f3..8c7d4dda4cf2 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_id, struct scsi_host_template *sht,
+		unsigned int max_conns, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
@@ -357,7 +357,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 
 		shost->transportt = stt;
 		shost->max_lun = max_lun;
-		shost->max_id = max_id;
+		shost->max_id = max_conns - 1;
 		shost->max_channel = 0;
 		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2455d1448a7e..edf915432704 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -640,7 +640,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 		goto exit_setup_shost;
 	}
 
-	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
+	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
-- 
2.25.1

