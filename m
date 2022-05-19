Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3B0C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiESAgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiESAgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45F5DAD
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMItWD027473;
        Thu, 19 May 2022 00:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=OkywGtEctvvjAAW2vSNXYW1hGrwLYw+O5t5/yW2+pX5aybs0eoTSD+Z85gNBstSLkVue
 rwzvM6405Vi+WRMIrwaP/r36rz6VcFaySCNtlcV3SrQsrT+23pVlV3QiXEaJrqw2MmJA
 6u8CNuynsA+x5+xArjCz27qHsufiraZhio7U2I/yM4JECL4R1lBoCMcsJtzvW8/2UJuZ
 hzmy2O52arXYPzZj/WF2lOneXgr/pNoSfKD44TfbUo045z2iWmS9XuZJ/ZqKzExXSG90
 WvKVaZDmPsUoIgmH7TXIuK7NCNSN6wvtiODXh41Am0d3t1ua65O1KG36uwqUtfpHRNV8 tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sautk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VJ015306;
        Thu, 19 May 2022 00:35:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNel9ilDycjXtXXtN1CQTMMG1YKVMv13+At6zI6hatJOgkm4dA53ZeuHisSYeEGOCMUGsNw/lFXX5EPjzQdzdMlRlegmMm+fHXme13GrXrv+YE5NWO2RYyDpXqni6h66dFSReob1VIPCGDiBUULfqH0f06UiNRPv4iVk9EVaqRHj3ZnK8HpMxbMuGt2tFXwB9BcKfEDmjhHhEWTbNMezgNeH/GjKh82JYcUsxexWXOQ8CXAa3ujXEvl73YtLSQRFSi2sUqOW3WwNY1Om2/LrxsigrsLvj3ybuEkA5ErkkS6daVnbno2WGzY5lRp2x0qpRzQTX7x5XVtmvyHCR76HtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=IBhsTWRnDuub4zFwpeXsA9M2jVi0Secxea0IcNV5zF2bmTpj6ja29JsgS9YNG3aCUfo4k68+SGRRuHbqdha6nvq6k+hpPqbU11DwdKKJVV3etflXeakOykzVv3nf42/wY3Nd2e/Vn6EglETqgJ68ARVtb5kYauxvjts/uXaJusYPCacYptc0fvxU4HsrfzV3BOrJIuYAqyxiUjjcrOYMmzoS50RDJCGBvo7h/iAXRY6WrSq+78fmNfm9xNkhO9EKk72domwv4VT8n5FZMZa6aYsLMPdViM7BMskghCcHP8CenkVmj9ooy93pahyZbPHNjt32FjLHNS16DQ/GUYFtfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=UsZrBlezuSsohsFSrTQ8L6EkcuixQdp6mlEelztsxpz8BjhW1mtqk00DC/xM7RvHudr/2WtalJ5lQrmjiJRqbjDZ9kLbQBoSx2WgPSQ11xeLhYf6oxJyiFrVB/3oiuIYYUUe/jmoGXvS1Ec1R5D6FdeosK5C7v8IGOt++xl6L6o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 13/13] scsi: libiscsi: improve conn_send_pdu API
Date:   Wed, 18 May 2022 19:35:18 -0500
Message-Id: <20220519003518.34187-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4bf5059-e424-4662-a144-08da392f7b36
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020EDB125E71F055F4826E2F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLRp5MB///kyAtExGYHk5vP6N//9zJsvucD5H9OjSXTeZJUoSbcr1AWMLBFM8BYWSi4ZhuHFFFTvN2VEVdLfG+aOQkdk9dwSOd+ZwtfuP8Hr32wbzjK2vL3XjheNp0xj24ULUfJ14jz7ldIvAbYTndt114h3kUOldlnMuWnW46oum0cyMzStxWZUTLEycN3A0pk9R+6D2uqN/vcGMEN/b2VNRjI/GcSRy78/yWPeZMnZI2OgcfO1GpNip15zYT+VC2E+IrtCvx1MVbe0rDwEZDQZhTMLm++8OEm8Qg4Rz7uW++iGNl3lrZcIf9HHyvoJz3WKysbDY4Jj1xCIBqk6yxxHOdXt+EQdt1I/dEMXO5UpBluUMIHc9uespCpnvGLcI23QfxGVTVgrCvrdVHQbCeNctODNJ5TFipYJZlryJRwAwvnwkhygTqyi4hbt9Bwg0jvySFnj5m2lsXu2HU531LMpTbEuS/356A+0fSVkuQpRyb6kE9Wbj7VvcYSwsiO9WVjgwFHtxx92ep0f0T3LEPBOyVqAJRV/wBMYNrDtPsXXMGmRjzBnjsAwou4X3aDwdYBZ899xqeSM/77mUvaOZkCgenTnTm86334MGIc+ow98QfZzLZi1nA6g9cc7J6x/xjkxFyc77LMqH1su19VpvwOsnnhHT65tGh7jCvmKywBtOD9X575UBjITChiUoEoMg+O3osXXnkF1GOiiqx5Uhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Q1vO9HuSwfpPtezrGFoNFGPoT7ukT5v7j1zHkDWtBdXIjlmqP1PQWHIpn8z?=
 =?us-ascii?Q?k6X+Hz8+REmAMTrILpm6zu/ayL5itOXt6HxwYsx1p1EgK6qW32Rw2pHykERK?=
 =?us-ascii?Q?S04hGvToH/CjPgbYP9a38DECtvh1NzAHCpazZXwxseHpB8fJJ00nK/7ZTDpY?=
 =?us-ascii?Q?Cx62dfsr9Cz9mjGQRin1+5TjTOCAhMv/Xs1FotrW55dA1m+XhfB5gj0gPdhr?=
 =?us-ascii?Q?2ocN2i2XdtDbT8RDX+jilW0sGS+zmakwLUXHOz0C32S4Lpt4Qn3l656w1+ry?=
 =?us-ascii?Q?T2+ci9KgcPO36ADESG78gAJjKH2ou5lli3wTqa+qLm1XyGPPGTSfsAqEOeq2?=
 =?us-ascii?Q?QVDlsFxtdhHf/piXz1Juy2qP7slb0cNTJE9YNsyR6tr44tR3xZ17YlEF7AP3?=
 =?us-ascii?Q?hiFbSWfPJUNybtrfbr4pV2IaJgR1MyAnozB/c34Yl88Lti9ZanOuFUazqo5W?=
 =?us-ascii?Q?mxbauRROIaczzhzanjrWvrPFhxkAMhl7ZrAR2eewuIseHlhIEBV0s030d27k?=
 =?us-ascii?Q?csMIKViLoAovvDutdIZEGfouZZPvVGw7jsXi34lTamwPY7/gL7fgsnNF+KIt?=
 =?us-ascii?Q?sqzi5p4UIQMv/qnbUV7BxAyRa4PhShHxGanYYU8n7/ZnRq6i+/EyoZgXcopX?=
 =?us-ascii?Q?1TIoR3hwySEEJ4l1D85jcBRysjI7sMHcoYnHB9qDRp/9oz320tYyl7zfWaAA?=
 =?us-ascii?Q?t1AGLng9um/kCX+t07PRLAvbDNCUURhZa7vYCwBECWN1afLqxNOpBsAQKpKT?=
 =?us-ascii?Q?ZNUAhyWwvoRmkqsIICBFfUkRG3cfj2b/9WnpnAVuMtufJ3donKM+O+DRlXfT?=
 =?us-ascii?Q?8FKb122kmryXIEI0aVgaf4rwTiyjWXvH28SmiDFWFn9WVh9rG5z9ZX3+54Hz?=
 =?us-ascii?Q?FTtLCZhETpc52zzfvEHp9CwYfcnhEgy5C4rHjhuqeZwWGw0jVO1vmmicYpIu?=
 =?us-ascii?Q?vYFgOlr8UPrwRBSqZnF1yYeEBYoWsLPEcK82vRSUXYRs/lYq21OMEpaPFmcS?=
 =?us-ascii?Q?PuVskFDmyrti6fCSstLwxZEhCPuNnZHMziQ4z4n//XzWxWeQF2PfG76RYeKi?=
 =?us-ascii?Q?cxbQrRtFoVyhjuB36v2kEBPEyxITFgUikxSzTVMYgDSJpfRhSEQHUNPUcPta?=
 =?us-ascii?Q?E6o09gOjI8GLsw05ayPP0wGenG++n9MYWKl3sgSspFONzKvepj2D5XyHurHS?=
 =?us-ascii?Q?jjj7Ts8A8GHVncZU8GfrW7zxk3Cd6MCSBwk9PEnoVCWO+qNW9Q3B5tVW0a0m?=
 =?us-ascii?Q?6FCnqI/9eEwzOPCORzw5RiJlbOFWlzPW6rGR060Y50s0iKMkdkXihFxSLiHK?=
 =?us-ascii?Q?IDlKc8CtVzBHhBFuHTnR/R2bmo2sIazg/q3Srl30nVfTr/1ef5w7OOXMIIh4?=
 =?us-ascii?Q?6hvBEFF4cCNn5VVzSrfvjqR6nybnO/PhA8LoXr+cAsChalyhqPA7N1MDjnPD?=
 =?us-ascii?Q?QZvJ6fa36HTmf/UbS+o8a06SQJH+XOjTkMioZhnfiAa5pNjrloxObKSiUreS?=
 =?us-ascii?Q?M0ZqoR30zre/13LWtvHNb/FGAl94JJuGPcol5VxktKSq8GhQOsmrDyXuDtaO?=
 =?us-ascii?Q?HIdEoaWGmm80l3lp6aDjCgCbQnk/9qEJ5fZ7xqt+U4ef3Ykre4XwuJWcZheH?=
 =?us-ascii?Q?Zt6gCM9g0FN/LTMAwDK3by3qppn2uSLeXlSELl+4ydb08Ge1jQFoU5TBlR/T?=
 =?us-ascii?Q?wFfXNTte2NLWQV1kuF286+iBtBOfHStn9pxcc5zGPPILaNEnKX9SqUWMVbCK?=
 =?us-ascii?Q?wlAFK6RAHU3TBmiqVqk1Y8bJA8unayc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bf5059-e424-4662-a144-08da392f7b36
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:32.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atO0vUqT87dNhZlv/gD7yhwjvJ3P0uS8QOEcBhYNftOHBsjT377WJJnHcaEccw1vIvkdR7LouNvfnkeL8wK/Zd2blqPUY1bsbXA/F4d05lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: b9bYSe2UKFJpvl-xHKZgfw8CgiEncb2Y
X-Proofpoint-ORIG-GUID: b9bYSe2UKFJpvl-xHKZgfw8CgiEncb2Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent and
do whatever book keeping is needed before it's sent.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 85 ++++++++++++++++++++++++++++++-----------
 include/scsi/libiscsi.h |  3 --
 2 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2bba10464cfa..ea0c67bc54bd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -695,12 +695,18 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return 0;
 }
 
+/**
+ * iscsi_alloc_mgmt_task - allocate and setup a mgmt task.
+ * @conn: iscsi conn that the task will be sent on.
+ * @hdr: iscsi pdu that will be sent.
+ * @data: buffer for data segment if needed.
+ * @data_size: length of data in bytes.
+ */
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
@@ -781,28 +787,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+/**
+ * iscsi_send_mgmt_task - Send task created with iscsi_alloc_mgmt_task.
+ * @task: iscsi task to send.
+ *
+ * On failure this returns a non-zero error code, and the driver must free
+ * the task with iscsi_put_task;
+ */
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_xmit(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -813,7 +848,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -986,7 +1021,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -1000,10 +1034,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1870,11 +1912,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7baffeac279f..b3efcd318f47 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,9 +135,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.25.1

