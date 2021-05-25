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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26F2C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D31A613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhEYSUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhEYSUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFHOh053070;
        Tue, 25 May 2021 18:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=DdCBZe+nHUhmiKUyEbtMWr1WBKS5zJe8EtGPkL8sQB6DnKuWW7pky5GFQBAiUefP85bm
 610gVBPxbcJWPhaT57ez5ELYM5sTkrbKB3+G9ttJo5qi/XC7yPpnFmF5DN7B9f8kHSCz
 IVUk5w2RExo0NHKqUN6svB9+oOa8Sfgg73D+7lHR6r2oXg6QXFCrYswNs9HhVFNJbqn+
 YwvVqmytRJk4CDKXmvEUBuKyhdpIo5vcjLXZELsYy63cvKSrmb9ZCXTk0Byy9/K4ui8e
 lnYKfbixQAIh6Yo8dyI1Xk/LlQUngveEWMSL5jAiYMDZUov4teHqJiIKxMQjyGXfqllu nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38rne42gu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtPt166079;
        Tue, 25 May 2021 18:18:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq4xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB4IwtcLwdsRWjQY3nKUHRMEenRLwGN8cmfdl1tKPNvW0oLt379ilgq0lTX9iZDIc/x4ZMm4EpQdHhrsDEPJoGVUvx0yVKwNnFx0g+8JSjO4ovGSRxnda83uDeMci61mPl65kESy3p3dvgvwNvuXpv0iXr8c4Z/z+mYzkjhfkXcslkqbbbIRuj4UkVfJkIdFfMBcYBCTXIfpKAXPUHXPH4tttW+E5jDTBOrzT5mA1JjFfcIulwYYqOJQt+wknBOsu24shjYgcBi/8VJy1/kyTAhMlwlln6u94OOPoswjC+4FPSIUonsN3RhkWf5fjPWbUajFHWouEj2nXWNq2V48Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=mfYKI9n0AGZf2Mbv6C6M0BY3RzPpD0Y+3st91hUclQIPy80g51jhx0T6qr73uS3WNoeW0BYDUak/9SdKIqI2iSTcy7r45iaYpv/cvOZIgP9C7vL3+IDvIjuHHJ2XJAzZlV3GzIoAO2FhFpYfd7mfhJnOBGrR553lzOKnys7nKM4tnGlF2M6RGelYM5F52sBwl/u0xnsZSprJOQOdegzo4tsH1yOVqYXdgDbvesFsK5BFqEEGsfDSj0YHZA/6CjD9ogkGSr3DGRQUZJlJ0eqb8cSnTeHG5i8xJFopv8NoEKnhFd3xa/0fQxRLICSP6Or9/G9UbWACCVLMesWt8XkJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=G6OUS80hkiwefK6vqTtz/cMLvAVouZR7fyd9MVEqKu0LxHdpz7wWVEgjCW02hD5swvz50uuvV6oQDo9JTIEpe6FAZb0Ki5pBWUI+B3cMOZ98iLfwGaFZweJgeg0FNMObPHssHyU/D7LIJPHp1ef/jeXQr76MzlauOJCY07uiRsw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/28] scsi: iscsi: Drop suspend calls from ep_disconnect
Date:   Tue, 25 May 2021 13:17:56 -0500
Message-Id: <20210525181821.7617-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf6b8744-2322-4a86-690c-08d91fa980eb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB476794B2502C9C31443E340EF1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vhztZHHfp43Cg8PRvjUyyuzf3EgdGyCHU9i1CndC20gm0RXTpeYbTYcmZPhi/20IXZzVyPmlQabBc5z1o8L3YkN1vdskq5oBVZh2QkSLtMoVah24mBz4vwTShCSwvKnR5TbFcu4CCNSjc+4jUZoGhAh4c4Z9znd/ggVVLU++tdvYsvc99xlz3zryvePIY1KyANbfP3PVIkyFxLPTiqyPb191mkP83muoMB5c7vHQntVbqieU983V23pGB20clwnz1tFJLeu/bOf+847HvwRDTQiritmK0y5CHiBc+6SWc8OLDNLuVx5R0UR+XlIgTPnhap8S1GXWgKVoqBAYdASCCXc3KPCNq+11opym0m8UaASlKjIm2USbQLCkM6VD+FRRQMlsdAumgA9fiBxgG9Cmh42i5VDvbcVACRwXkt4xWpGGyLGkISgMYstZWg5kWRbZEUHkMZL89P+bHtQfMZ4zi0fId7M5urvBj/uD527IEkpCHBEp7ojoEr1RLlHrCmSMEKZX9Dg9KxZfNu6mm7BtSHLO2U0wfda0ja3v0/J5C+IeTSEquOS49rlaZwMwx/12So7StTudULzeT9WGnQ74GjqGyqwD11of3h3MiuSuT5+3rtqr3jMPgG0H94x4HjS1M5X4sFi5ZGb762/S7XaqttScYutLJRMcVkhPeiVODI4XYwacN+s+gFiR6RXwYpn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(15650500001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nPeVlzLbX9ciaugWgk0Vs4pxOFyIYCqoVBhRGYZkFyoQ+CVXr6psWIMSAObC?=
 =?us-ascii?Q?UmWFd0HUWjQTh/xg4c17vSswgLWKIxoTWmEKE2L4qdsaRG+QK/Bg+ccQx9x4?=
 =?us-ascii?Q?NjPINnTvBeuMy+AIAf9JXK+4f8SWQEW325lw8GwwzKEpkVwENvRty5XDyCjF?=
 =?us-ascii?Q?TZTCSnsaQrf66SWxLk2PCfVpLi3oQRy+Vb82J9yjdrE/YAPKfVWFbg+CIRjz?=
 =?us-ascii?Q?4I2h2lQMlXpgEz8K2UueW1G4BXWCJfYZGgQzwG8NOZaEF6aP/xfNrOKH1Po6?=
 =?us-ascii?Q?Ru670sjJ4I/QqWNNQgO70oemB4TxlDXcrTdAZmbKuLl2LTUisS10N71knSos?=
 =?us-ascii?Q?nd9CA0dr5nH4JE87O8rI2KuJZ0cM/RMi9r4tM2PEauVnJJ1n4tWEFR4Em1Gz?=
 =?us-ascii?Q?4hsxUOypIzGu8orP3PIHcSpcKgzRibpyTnK6XX6Hj784nla1HCz2RU06sjsu?=
 =?us-ascii?Q?dGYE16Q6qSoiG3HpN7fSegmGmBsJPims0rxxaw7U2PhUH/RO+TJuymcYn6g+?=
 =?us-ascii?Q?F9Wj8YiCiEdGkAGg8pQ407DH/G6ZDT9dpLWpKzEgfqNNQNiwaEcXUu5Y31sG?=
 =?us-ascii?Q?uNy2XJgEStEFd++OF8+OaovDqa2os19p1TJ8b0EjIGoSV7kjOvV9yH6M+PXk?=
 =?us-ascii?Q?b+FdnETWeXMO11XgpdR7CPkThkS8/nqVw8wpZoOoB1Ei/HknEwaE4uCWyaa6?=
 =?us-ascii?Q?/xeW5HKeEXoNO0rnsUPTSKhYx/6XrtTUI7vK09lURpfvl2CkZBI2l1PbNTfI?=
 =?us-ascii?Q?gtHP6F54fe1lLFLZ4KRrA7gHxVcrTFuCyx9BtANCoaQoyxaVCYDHNakt82HH?=
 =?us-ascii?Q?/m8hZvpsmDk7f0/5CUSJCkLbaFfofhhl+58pkcJx3oUr5kuuz54saB/EishS?=
 =?us-ascii?Q?M7VWo9o3OyMD15ZsyEsNiPuYKELcOYGM1fqFcgmIV3hjhccNR6+mNh7D2/8+?=
 =?us-ascii?Q?16TQYD6hsENzMCHqb+E/AqyP5zBqKLKGD874kp/g1i8mjiKIg1UAbHFZfhlt?=
 =?us-ascii?Q?DTzQaVrddK6ouPHD/uEPqrLD9Jd+PY++JvlJc8JsBgOUCtkJUY9o9F7KSmpZ?=
 =?us-ascii?Q?hFtMbtx8WCuKbMU6mJg0A7TOGbcsXPvUf91TxA9a6J8lK5ag8a6VZHnT135/?=
 =?us-ascii?Q?x4im3PEvA06tfYKt8v5C6B5IEw8igeyZ0392dZBBkERXx23l5wXn0bv+XfcX?=
 =?us-ascii?Q?Eu01eLsfE/SezHPciMDOeeyhS9EWd6Gi6YxFkpmdatYOj6Gs4y1NVlhETNAP?=
 =?us-ascii?Q?sxVVaso2dqxo53/mIJTtSXHsw0CeT3i+WqUmlVFHgLfL3UUzuigq695I+NlF?=
 =?us-ascii?Q?uEObFikleS3FyAhhpBUyMPR1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6b8744-2322-4a86-690c-08d91fa980eb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:32.3850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a312XsKxASXG0jTTKHQgD6loEvXWKbu5OLTpCBEnfD2vSuFe0IdSDp/EbQ0HPkTECiNxIE4U1B1DOf1ANG6ONJ35OpQqnAnsecbFUvJ3oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: Qn_mqCGWfBjV2ID8FEpyEQDxH7ENF10V
X-Proofpoint-GUID: Qn_mqCGWfBjV2ID8FEpyEQDxH7ENF10V
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libiscsi will now suspend the send/tx queue for the drivers so we can drop
it from the drivers ep_disconnect.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 6 ------
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 6 +-----
 drivers/scsi/cxgbi/libcxgbi.c    | 1 -
 drivers/scsi/qedi/qedi_iscsi.c   | 8 ++++----
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 0e935c49b57b..51a7b19bfffe 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1293,7 +1293,6 @@ static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct beiscsi_endpoint *beiscsi_ep;
-	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
 	uint16_t cri_index;
 
@@ -1312,11 +1311,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 		return;
 	}
 
-	if (beiscsi_ep->conn) {
-		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
-	}
-
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..9a4f4776a78a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2113,7 +2113,6 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct bnx2i_conn *bnx2i_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct bnx2i_hba *hba;
 
 	bnx2i_ep = ep->dd_data;
@@ -2126,11 +2125,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
 		msleep(250);
 
-	if (bnx2i_ep->conn) {
+	if (bnx2i_ep->conn)
 		bnx2i_conn = bnx2i_ep->conn;
-		conn = bnx2i_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
-	}
 	hba = bnx2i_ep->hba;
 
 	mutex_lock(&hba->net_dev_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..215dd0eb3f48 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2968,7 +2968,6 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
-		iscsi_suspend_tx(cconn->iconn);
 		write_lock_bh(&csk->callback_lock);
 		cep->csk->user_data = NULL;
 		cconn->cep = NULL;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ef16537c523c..30dc345b011c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -988,7 +988,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct qedi_endpoint *qedi_ep;
 	struct qedi_conn *qedi_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct qedi_ctx *qedi;
 	int ret = 0;
 	int wait_delay;
@@ -1007,8 +1006,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
-		conn = qedi_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
 		abrt_conn = qedi_conn->abrt_conn;
 
 		while (count--)	{
@@ -1621,8 +1618,11 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 	struct iscsi_conn *conn = session->leadconn;
 	struct qedi_conn *qedi_conn = conn->dd_data;
 
-	if (iscsi_is_session_online(cls_sess))
+	if (iscsi_is_session_online(cls_sess)) {
+		if (conn)
+			iscsi_suspend_queue(conn);
 		qedi_ep_disconnect(qedi_conn->iscsi_ep);
+	}
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-- 
2.25.1

