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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505FEC4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B896117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhEWSAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbhEWR7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvEmo156161;
        Sun, 23 May 2021 17:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=vB1LVOsvOAt9ajMTRr+BR2A8h5SmaK0eXik1E/VMOkZlFhHxF5oMS3ezlKHESlBr9XmJ
 wVrTHEGHkeLoX15y4qZuLw2EyNlHKzTXO5cego35FF3tAGNWF4ZHnRMd4VMAo8j8DPPS
 RKGyqZptF9K+2OG4SeYhmC6Qz3nm7zM1fwQWShfA7ydoSRUF+G4jdBs7ZAFyuAqtlm/z
 BVUTB+vx7IJqKbCNrJeeUIFLpW6AWKU5fmcs/EBeLF1QIWKHci5HOEi7MvUMnZB9B62C
 O6uOEhuJrz3zZM+s0RSlWTzKXtoZqddkgM58V/Jf3i4g4+NRKUs9y7/aIPxgdRx23qVN Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38pswn9fqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDt161766;
        Sun, 23 May 2021 17:58:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILD6XYdv0goYw609GO1OAyRvmlH38Go2FGAJFUXRVPbXYaRA+Htm+90ROVF5bWeZBbxg2FlBdWnKEPo0iBnbSjyOP0ztT1NjPIfgvk+H7rzl5fuN2kdeJnIaJ7+XnNTw+B5v0Rbizldto4zWICLwT2m6A7TIAg1osF8sN/oqBPd1+4XhxdzvW0PzzhsZ8uL+wSJLkztHCBVgV+yk1/uJkkU5FAQ9ehsMGJ/yTgyDfbM2Fqp8f0EmiZSRTf/qA++Ly9sjORbWlD0xeg4u+PuN1vsZXhcxy7Cy9hPEIfc2DDJVU//GH+Boky2IXwvcA4a3KI1JpGc7YPI5OyQmpr4Rtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=iS+N69YrjGqc+zQGP6qeoBEpyU5Da7E6XwHPmncQ8gH1O843HuhjXexdg9x95k/YNTQjZNSJfdkqhk+pHYddza2/xAadMp3kVnM6qTus8f+6hw3Cjb9dUBOOqdlM5p2qslPNlkIG65gyfzF7LPew07h96mfI4hGeVgQueQOnZzE9rxnWYb0OO7+JnONca2KOl7KPE4EN5HyGJR3F8ZMYEdXbM9S/owyN7OCYxGqaim4C2hmE178FjReCTr0l+xYdeW3QyzrW/lPb6Af2UvhY70KyLUSRePPW0ToUbvkxoLH+Kcszf1FOuRebT20o38a9Qlbg+Xm9ohYIWerPINHYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC1Ou3vMgYRnWdJwVI2nq5UFYFv53gUtqv278MVXtSU=;
 b=E9nDzu17+8pDhT/07qNnhRv97JnuUud7GEZbObpLE8ujngDuNFO2ytqmxcVXvagdwrNl4j2DhmpRBfMTVlL2dZsFrQETH1QZVFg1Pb4Gxe1vrTsgfQmX95HnwMy1rGHC6drfQ9hAXsEAtQUlOoE/vwJUpFqXGZJZOcTQIQAC7Eg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:16 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 25/28] scsi: qedi: Fix cleanup session block/unblock use
Date:   Sun, 23 May 2021 12:57:36 -0500
Message-Id: <20210523175739.360324-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64216107-7fa2-42ca-6772-08d91e14573f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32394425BCD889C2CBFD1E32F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgDSVluMWkrVGwacPGK7Hj6dW1y8hYszhAYnWpKEbBnQfdHCROlaINj/sDx5A+IE5pxAYHTGff9mMFDD6neeo92kyGP92NoLMGYJq1caeZI+IL5wvTChlbqbJW4VHqqLBpI42Q2c58iB/oGq3HDqIxeJdZq6DciCrHxfKUHBmwl7iu1V6V5pPL106PnFWWUOTfU4Zskr0hX2cTqWkjRM4XB/2eO8UBk/XPV/t6Z0f80R6TtPPYsorSG3oyE4Wh/8Pyl2yFDOiD6d71WIQVYFXx9sVcmB31RPk3It5LtM5Fck8gKkjoh5m5LzkizURxq3v+7u/ZlYICmh4761E6PoISE7LZfLYYJuXjBwbzQEEOQCADf2Dn3eGemaKU8KS27I6MC3lWnEG6JtdNXxJfFb3+iXG7MfoRXl5MVD3ufwvcVdKS4fPDJup8r1PKII48VCFgtRbxEcr69luBAjZ79R1XcXJt6jvYhSf2cNCS5mp+z1LGxW/uNm3z+aNHHhZmCCMAbPC3JQkP4wRhcW/hKRDkH0hb9oLsA3ui/J01xeSCZ9ivFK+POT1pseEHirAdJKo6CRXaLNt6IwXbDx15ygnlwFLJMLJlf4ZCEJG61rFyj+sg+C5c42/bS5M0+Tm+RICQTbs93P8XQm5cTDwc0YciN4sSeJip1vHo86wsezfwPpjqJ3ccLnuXsWNYFGyIit
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xl4yuh0GyhOHGHwdRrTZrLQQ6W2CeqbCdihTZg7HmKwWUoPrpNmPfNpLTNke?=
 =?us-ascii?Q?YEwXzwcZ2VSTXSazxPbGCsqtpj6xZRF/4Ieh4y/0Ii+R6FBCFjANEWmjLwIw?=
 =?us-ascii?Q?71hlhAVOvGam2bZk/Bs07cnhf5EEldZtdqLNrWUVpcKdie+HqLJKZ4qhoF/J?=
 =?us-ascii?Q?SrFySLTo/rBty7a9t/5+kGs9+cJMXneumz2vGU3lsSsURH6EKpoJWgRs4UAl?=
 =?us-ascii?Q?g9uU9x+GIRaXqP9T/8DNyJns8bLtA54RbYEgXOFtmjT5i/1X5axfkCiP/Suz?=
 =?us-ascii?Q?ulQksepYCm8Oo3bkBwWnpUj06ba2w7M0VyonV7ceq6Ie44sl4vTQRdnhUZkL?=
 =?us-ascii?Q?zhIzggJ/p5NyxR/MEy2CJVR4lPQbNKD8SshQuGnlClFqlAgXWGgMdQyIACke?=
 =?us-ascii?Q?eyNs7DgkJFRUnqq1UPkonhk8aAp1/CgtcsMd37tTKlwZ2dGwIvU78FNmhNN9?=
 =?us-ascii?Q?KlU5ttc5g2FvtYtGNHFJFKOwRWJLpB9EYNziD/469eihQZQ4p+KaHrrZAM6m?=
 =?us-ascii?Q?tMz2MyNIJDDZBlS8DFNg2BWcsPGTnnBS9IilaWPhv3tyDFECq7uUfqZVjxnc?=
 =?us-ascii?Q?VC0HCBVZtMaDWLxxiVDv297LGH8N1u/1UF1V1HSmMhwad8wMG2XNBaRgSKYT?=
 =?us-ascii?Q?jr8LROazUXPxVF+0KXlCvQbWKXav0zo2rBiJEhvGoNDoNpMshaSf+ojMfEIb?=
 =?us-ascii?Q?4rFnZSUdXRX8O1sPHO3RskNRmfjUamMWwG+t3CfkDtOvh+0pmoH80N9xRBYu?=
 =?us-ascii?Q?RvthSuAm9fv88f4fCpDveMWL8YXKmt+TOanUx1uHp6d7cWha9QoFZgF592MJ?=
 =?us-ascii?Q?aOqYGx9kplNie9aYkBukUgisZmxIV4SjXIQhxk6GVXaX+Xton+nX+azzv+88?=
 =?us-ascii?Q?AXgmQYJzzH7Ol9SpISGXgMlb5axtFZK1knqG1UyMJOBuotiwE1L9LC6s36XN?=
 =?us-ascii?Q?ouP+ZXPF86CmyLy0YXaJ8eW8vmqip7Uwz3hew+hP+qmrtfKYp4K1rfgxWFqZ?=
 =?us-ascii?Q?4sp+BbmlzpkEg6/RodRnMXuSWDJRytgw0P9OTiAoGl/znprTnLpqTGQKytYU?=
 =?us-ascii?Q?Uo+7cFiR3sJ2/m6K1JLpVa9f5KGi+TZyq8XiT3zXTPOUS/7tqi+/Y0q7q2du?=
 =?us-ascii?Q?mGv/lsxW4zZ/39OkM1DLoNFwBRNmN7BKNGvE0Rxvf6kkI9/EQ2EeHcvpdLRu?=
 =?us-ascii?Q?pYNP+8PrvwDMbxDYPPoRFkov883rK4a8Rn2MO8kEFPvrulRiFlzueXITmuGG?=
 =?us-ascii?Q?pGSAaaeXH7j/hWFVTon2FBP0lqnprVayhrUFNHUqzT+4zKXX5/dD6P4GAdGR?=
 =?us-ascii?Q?WoM7hWwExyZ6HveeSJLgN8Xs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64216107-7fa2-42ca-6772-08d91e14573f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:16.3037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6bWy/0/MrBrqLvFaGC5DfjWAH8SkHerICxknltr4iAXDIeYzrIbm/XtnIklIXIaTZD9TGfrmTs0Qhsr8mZOvipqeOy8Q3uiXnfTGNdXntc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: garuphd6drXv7_ZAo0jh0na4dPn0qCvK
X-Proofpoint-ORIG-GUID: garuphd6drXv7_ZAo0jh0na4dPn0qCvK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host while
it drains the card.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi.h       |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index c342defc3f52..ce199a7a16b8 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -284,6 +284,7 @@ struct qedi_ctx {
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
 #define QEDI_IN_SHUTDOWN	7
+#define QEDI_BLOCK_IO		8
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0ece2c3b105b..ddb47784eb4a 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session *cls_session, uint32_t cid)
 
 void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	iscsi_block_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 void qedi_mark_device_available(struct iscsi_cls_session *cls_session)
 {
-	iscsi_unblock_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi,
@@ -800,6 +810,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
+	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
+		return -EACCES;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
-- 
2.25.1

