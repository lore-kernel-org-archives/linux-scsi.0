Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACA9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbiCHA3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238792AbiCHA3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B33220F1
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LM0Bv031943;
        Tue, 8 Mar 2022 00:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=O4WvJaFnvoepKgzLrfrUUr1dyz8nRGu4XdkevVpVDvs=;
 b=JFFGY65JPrMkmEXpuOhAWhwtL/SHpc4r3NdchiD1o/Kz2TXvrGqgfbiJ63bxR5YPiZ18
 TComcXq1t3Bgu195pOlNmb+rObqAj54zGcDNsq4u/VPTjsnU54OJzVQ0DJnuPEZBODNA
 DVaQt6WCh+dgXGzQTa9gFU2jujYSy0NK4Iob+hkZMFUKmT21yC5AmyayEX+HqyuV2lO8
 C1L/EHs+WnmXjEKUZdtA2acB+tDGHwCRh0FitZEmmpkqz4v1jrcuyYs81yAjmzEpEYz2
 pG6+WZMVshlGSiGRC8KQpJ0JlOLcqLxxHmzKHmwomKFncH8DhBPXL3gMeLTEVXvVDAXH 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyranbun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKl3134578;
        Tue, 8 Mar 2022 00:28:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UANwHla2sj1gh8oW9SBC2347lnmDhua/5+5eLfvJzOT3sPjtopfh+i4+UitXrrYg59wyLAt8XivHTxlyh4Fj2Q+J2GJxHzr8lAO/2Z8AEKIVY9B27p0SGkfyLWdB44OjRBEHuEb9VXarNec0IPy4QKcp6ksxH2nigi4nnKF+VoEfle18eA8kSwgw2Hq1d9mMRrtYfQBDVsF5jyHrzg8OPJjRGBtQQgOv5NDzDmbs1Td0WVr71Xmp2RQvl0uFGTjP6y2oC2TEuhbgHFAl2ERPi/yoYj5ZTfUbWE673nYaoO/qZoNfcEwpwKjGiiYHYaqTBQd9s1/BqlWCx7+tZidxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4WvJaFnvoepKgzLrfrUUr1dyz8nRGu4XdkevVpVDvs=;
 b=KOHoYbT4EeXKLqQawWvnwaOFkT1n0c5Zj8ZE/0+Lxcs26aSlqG5G8WtPagYibWzHfv9jsaMbNKEQ8NMg82NPegz5ir3ZdqPlVOkxgLEi8hBrx4nT3SB/ROP9d1Ne09e5nceBlF0RE21cKJ7TVHk/D5D3FiWFJCXiZnpXI2o7NQ/Oaf4uiRuyoMqfgUK/7hiP/jaHe7arrtrf9kM8A7XTv5eDWSkaCnVdLLkMTPtFmlzqtdG437ZI8AAOlJ9oNaGEExExyIcCsbgipR24TZ2csnt8qfxouOO5JcL3m8ilxOnEJ1KY1cveHyn/He6Akn+o5aNvCReZgHyppDiOPRWaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4WvJaFnvoepKgzLrfrUUr1dyz8nRGu4XdkevVpVDvs=;
 b=ieiV/UYDGth74uTsQ+qZioZkdqL0p8/+hCYNyB4Ayk8IbJNE5Jo+GmwiOfjwX49PGbrIUKFtKNsyKQHjYz0PMK1qMwpntVXUEMeFDKTDg6xSYFXux9+3PHMLeZ27VyRfhwb+VbokuGIH7Ojazq+rfGu2bFKrrVH3PZD33j/Z8iQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:28:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/12] scsi: iscsi: Fix race between recovery and task xmit.
Date:   Mon,  7 Mar 2022 18:27:47 -0600
Message-Id: <20220308002747.122682-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 217bfd14-6b59-4085-9315-08da009a80af
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2809E8D0E8B22DB543CF1EFBF1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uprGOJXARyrB8cZd7U3O1ke2gm+KhYz1zblJWD0IvlMMASOfsav0IZPoUohLAJuKJIuE6x1TXmC7I7fXXomNgy0YKJ71ZJxiAWHbPUN0Sl3coENrFMdWyHq8j+aF6NW5/h2l9bbYxy0KMUPDmUvjQ8Ri6mo5I0oV8Wp3+ZM1ACkGYeGatnK72Sl1qL4uS76tN9C8Bq+l8K7XF5HcaPeH/6AoPqwvhsKRRVlzz/rSL0NM0iO3cSuS15/sert1J2ESxSrIhWjCi/Zcs715vL7SJmyW4bFxSrBhTBJe2jvNmiaxgaiHW/qRl6l1swVffGGby07igRIwpRZd8jOrKYdBZIYQgAIP3UZ9hJJ5nYYN7EbR7y1j/aZT3Mj2ISxZm9UMvaUjHZW7BrLo374dwiK37Xto65jkZmnY3IwqAwLup79GLfN9Vhkfob3tQseQxEpX4IKN9SC+AYQt8cP24kgYV7io6zTJbGhuvsv3i6qv8AdcBaiILLXpnDL3MEem7UFlmL5CLIs22eGHtH5ECD+8bdAoQ44z4ip4Eiwn11O/WLFXX+Ole/iCk941zfTfP47Jn++6pARZoOlhJCnewTBPayvFTRZa/JQHONe015Hlxqv3j3Tg0B0qULir/MDVb+2gsZoyeyeBjw5n2/kig9XWl/Rx7x7yWz6n8xmO3KhPahI+mxXIb4h6nSyb6U8kLay25K3pPCnTmHRo2SCBTbxTYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2gZ4AVM4uo/TAIZ9RXmYGuR+oNG7j5ekmANA8JB7NDsQNSefMYKfh/m4QGL8?=
 =?us-ascii?Q?MPZQ6VKXTZ1WgXPyaj0QhJ4gvKYNvkMCeHOCZEyMe+gA8nVyEtUVAaZsb0y+?=
 =?us-ascii?Q?OTqZfVSMbbqRti4UPM2cRrGtaOheyA+JdrDv3ftj4q9S2jBiF8X2dBylUwO/?=
 =?us-ascii?Q?ArTv0h9rmKR2XR8he7JjyloEtNClYS+NvCEm+G33Bv5TSIidQjar+seNsTdA?=
 =?us-ascii?Q?bZmiTsV8tcLG2Etma/MsvtXUw+ZVziKC9sG3oiT0HEptI4hKqjoDFignNahj?=
 =?us-ascii?Q?zGNcOgydUIjkj4QX6upyhlFp6xq7dKJ2TyfAqg9XBF0jzeRZm1sWPndiQnK8?=
 =?us-ascii?Q?uzGjFm4DjEU9/oWX3JE/7WSOTAB5kJxqLl4ShAETFNQ/YusxQCHhpHiuIUAR?=
 =?us-ascii?Q?thQj3xz8p06k9GNlw/lhInxf7ebfp5cWww6Yx8uNFv2Dh3O1QTxqeu+eYsQQ?=
 =?us-ascii?Q?KiqH3wJ2JTNbspm/WPVK/xMZ6POcWeqyR9gmFS1zL8ad7hS975lRrL2ggC8+?=
 =?us-ascii?Q?bajNKoBNkcWQIjlx/5grqir9LPFqEPH02RCYL/EhTCCi42Lb3DsFWVU76nkY?=
 =?us-ascii?Q?ZolFhPEuSTDrDsNHjQB87TfVAsBh9tWrycGyMfu3k9wjdlMYKKtJy6bEEaT3?=
 =?us-ascii?Q?ifCspWS58mj8koQnpsBuFwOOa3+BCkyDCIva4bwJoo+qmObNowzK24R/beT8?=
 =?us-ascii?Q?qxB5cNDAm7Ul+ccBmLMXOaFp3LIPhzGScQzUCaMDj8LkncUvCsfjjj3LaATU?=
 =?us-ascii?Q?uHr1qJuRVC5bKbgG2Hvjrkb8ZZjv+SQGIDeP88xQCwl+yxvzOHxuNDRPf9zh?=
 =?us-ascii?Q?WnhCC7CaSTKWtkWYx9zfFEUJDj+aCX84iBOJFPeYwwZ5bPZDZatXTyj8BFsZ?=
 =?us-ascii?Q?mir2B+Kl0nHVn81cRXGmzxoS9finquIx31Ve8/3p864/g1wzb5lf/Z6fdQt1?=
 =?us-ascii?Q?MHSLFfFtxOw2ko9/L0YZ0d29Dsw4A44dRBWqbUQBH8bjDFBP+6I8Ej6JVuzG?=
 =?us-ascii?Q?4jv6djAZtawoZtmbVLQ+X9C9daVrT9+GwHDuONNhu0gOSjlo8Pl0txnGiGzA?=
 =?us-ascii?Q?YDLbwdY9Fbf5g9Q7W1nGn16YVQEGdOb/Fit+36SGkE5QObE3dD0eHTfP6O9H?=
 =?us-ascii?Q?BTNq/Lunj6p09XB2SyCXcDVJecCnB80kNHzSuI66LLVFK1sA6LJljy57e8bb?=
 =?us-ascii?Q?7bn7CTedIVmSm7KmopcS5dW9PJY336X4TVAQWlWc+jtLHrH4tlPbP1YsWY8t?=
 =?us-ascii?Q?KgTkahhcWZtYLcSjsAiP9DuSmxnxldH9t39u0OdIojZdlL+om3Sgb5kXTiHH?=
 =?us-ascii?Q?fj0cd7/aZjLDnscNe25zQO5L2bL6gYRRZfXQG1bnYwSGIOTfXLQoErb5ZWWu?=
 =?us-ascii?Q?NpX8ktc5e5C/GSTbOoDxD9vU3gdlRk056FPzedrUFJ4e9oA0upVOmR4ow18h?=
 =?us-ascii?Q?uNZZEulYPanr1R3r80a+gT2jSBpu+WzyChLv1YUHQSGaSD0Z2sJPiDV6fj1S?=
 =?us-ascii?Q?W0mJ/Jz0Vi0VxXGEkz6L9ySPgEGlapPPxYs6cMjT2mkpiy6FbXUoIOwYhZZ6?=
 =?us-ascii?Q?8Ef9n1/Ol0HQjiSSb53fblz712BhDGFa56x+y7+ovmFELDvqgN3WLMIeR6Qn?=
 =?us-ascii?Q?j2SEhgutaAfQU2sBwsbqVuOLgzVket2MO5SRNxW/F314CC9HksKAs/TRvEZo?=
 =?us-ascii?Q?cJya8A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217bfd14-6b59-4085-9315-08da009a80af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:28:01.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8BgdKOL7eF5Prr982nEGXide+IYhw9DjDaOi+IDZbsyuN+GMnxxWXktLrAx8xF6wjqBIvFh3FJKSTnf5zHtXvR2DoDXLbr+bzh99Z2xycM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-GUID: aJWtiznAtHv6nKKFIdWk10_v_Ah-hbbm
X-Proofpoint-ORIG-GUID: aJWtiznAtHv6nKKFIdWk10_v_Ah-hbbm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

set_bit doesn't provide a barrier, so we can hit race where we've called
iscsi_suspend_tx and didn't see a work queued, and then a work is queued
and run and doesn't see the suspend bit is set. We will then call into the
driver when they might have already cleaned up their xmit related code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a165d4d10cea..b79739b41b10 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2020,10 +2020,14 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
  */
 void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
-	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
+	spin_lock_bh(&session->frwd_lock);
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	spin_unlock_bh(&session->frwd_lock);
+
 	if (ihost->workq)
 		flush_work(&conn->xmitwork);
 }
-- 
2.25.1

