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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FEAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B9261244
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbhDMXHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348747AbhDMXHe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMi1Cx002773;
        Tue, 13 Apr 2021 23:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=rbNrZezBuxonb3RHSrFiD3lAw8qrlfo64w3rJm7cgIPGYYdSgZkv1W4fjRx1IGwvTXbm
 dtsWHrcrKvmUpTYDrFjfRd9+GUSGa9fc6YwPl0Vu5ADeP3u0dnCVZGVNXeDVUbnr0qF9
 NPwc8pVL8bjE4YnhgOKXEHbuNZjiQ4EFtmG6H2saDBUchmg4Qa5RbpMhciUXoktGgTG7
 nJpm5UvEqG0SpluovBWCiKS4UGLyL2ALbuv6DxKxV5JOgimznfy16ukhb5hGucuSGG6q
 y7n8Zs3wLP/jYRM4umQTNjlvYqMMRAL5uzFcYoi6pKFmaCEWCWPgC/uSzHdrHj9JdcPs fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3ergpf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjgkv142878;
        Tue, 13 Apr 2021 23:07:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 37unx0e1jj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYaXavIkR2WLnCrUokWfAaim74yCLaVOTae4tlYkvZSpBEXaRFHALL7wSnkmPj5cSEHEd0YpTQFTG0nbyA0wWi8P6DKrmJNYWKy/gvBoAC7osxCQcJgTLF6yHYmGevMJmab/+pFko9MiRSKT7VUj8beKjIju7JsOlvefQwAKXb4vFvU4NeUnCXwBZ0hXOMbPDhXgR4xdy4lBuW3wP/h3j6bOzmzmWg4xbz/tkoZ1tc56r8OSqjOwzyUg86i68kzNC15XaU6knP+XSfHflYIosbTX0xneHrNDn4S4XBuomFfAIO8blU6QRpSTDrc19s4mbqOmhauCDBkWNt25ldptUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=WgouHzu0z9mbcDRi+C1pYabkCSxjISyDHStLwv+9Ob6FH2siq9C5T3R1zvDy/1ujFThuSiDz49O3pLBGZCY8MZRj00kia/s1GTaVvby3T8dsSB76OkW3/7cFLfJDciHP16agwJQckmQYFJYD1+DX7mU0h79jokTYSu2gKRuUu4aelFoRSO1i74Sx7WrCCAccqg9s5TevF/ERA8ak66/RC5ejbtRM7o0zBovYmP1I/5Ll+/X0qswpsIpeA/JDcZ5tJQpjDWrEMIiNF9WzM9mb3VbEhJn2oP5tUi4kcmEnKTBxiIW/qz6Mr7vVcU3k5IN7PwY3H5EFPvwZswpBXZmo+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=Acds25ApLVG+11EXBtFS/zm56xGcaTVe88UCei84NQ63HTb6wc+BV6BEu208AUgDZQP/jkUg7WfT3IrDZMXs5hrt6WXZcQXvJjunDjcq5tdNQiD1iIsDaxWfKkWrfJwql7vY+Vr+3oq1q2KKovDI0adDqRtNYMh54/fZDjfBEz4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/13] scsi: qedi: use GFP_NOIO for tmf allocation
Date:   Tue, 13 Apr 2021 18:06:43 -0500
Message-Id: <20210413230648.5593-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83f51cc4-a943-43da-e422-08d8fed0daaf
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24691B0EDEBADEB3EE479E5CF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTFJJ1A8bvObHVjFNF8U0RjfCfhsBak/EYoXQDgfSOfC/uyCa0g4eEhjbjm2U9baLnz7mjrSd7obVRjpf5w+dm/3MllymMFFJVuEuvo0rhHHHHSDwLkbaoJ8raXyUt7fZ3NVR5hMGhHqHkFIC17eVIfBewDDx8Z0ijeAQvnqonWr+5xVRVRTf49FSWWKEG4ptgIJo23MqlDsasR4l+ulkeNcNCSZCHsc7D10yXd/toSQLCWwKRMtE3T3ZCc8u1gV5wfdO+4vx4le93fUqGp5lIUr+9gVFRTak4BUX9tXlynoNvLPO3VbKcNpK+RNiiXLCDTCupEhIyZrrdPXWhuktcGk/AK1sUKw70jof8zTqDHyr+s8+n40q3fBGg1AVyikyOmHea8vqF2ugIse0c9K9upPtE7E1qrQ6cvaf4xw832P61PPiorhDLoBIhGuFAc94pPLGzxp43BrRRVndNmkVdRRnIctcDx6KS79T6osxLZsYJ89OZLwIe1F7AIX0sCVCgliDdKbCc8H4y6F1Av8xQLkfuc+PoYgru7GmC1OLXaepv2fMqgdqTBjqLlw83iajm5VeNAq/eDJ6mNZbP4VotTaGjQVVFhduTTfrdaVxeJac0YHVcSlAQv9bjBGYss/NSuRDLoDU+fSsoraPIJxfERBkklivorG22pD6SawpPknDkWvkKms+qrXPD1TD3Aa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(4744005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iHNK67tXre6uTCfETtVd/F8pBdpIEHosrvk3HObhiBeI9d6F9JtPk7OhkKD7?=
 =?us-ascii?Q?JMtnOrDbC/wh4oKe7EHOWj0YaCQ9n5HDr0h8wOshTogGtMKmrzRmUH5DGkO9?=
 =?us-ascii?Q?usbNpE0Ji4ywx4pfJQnGPTd51uipT7wLUCDEwCPGQ8xk3TUdQVGv6GzuQGeh?=
 =?us-ascii?Q?J9o/pDMrHIN6IzDo01f5E2XT7ekisF7GOTXkSUZ+Ish3poYBdT1EQxvFuTYU?=
 =?us-ascii?Q?YczJWDgrTSgbc11iwQFvsnvZbu3WModE4OAXNU22ne16IBCR2AV6CdqkUqij?=
 =?us-ascii?Q?UEWmER43+pPtt0Rg85tQvRw4uM/PfwG26F5ubqMYbJpyO/f6tTy9kZTvBmvb?=
 =?us-ascii?Q?pXjz3SVqyB5CaOUN7ohDEyvdYXHU3TflIW7ulabSPNw4ucci+fYgTy4kcPTk?=
 =?us-ascii?Q?WJXly6zBIBtKUweifOpS7qbNEKCQP3ipbwPv8mrkxgAqU5+f2ONaLlec6+HQ?=
 =?us-ascii?Q?5UrVWYmdS5e+c93e4k0TH4F0x64E6A4Emf3xGQBBHFRbfY3jjGLqtzdsbPbC?=
 =?us-ascii?Q?nPyuwaNiqqTmBi815g4xKcfdb9dJGz1JZ6kGpi2F7O/1cSgzhANdLXxZeW+h?=
 =?us-ascii?Q?hiBl4HgKyslps6Hk+0Hg1C9ADNKheBbZS6zpULemBB/w09lWhnTsuaYCT8Ja?=
 =?us-ascii?Q?gcopaav7v19CBgdsU9zTENuMHG7zMCwiUXFR4CcK60ZRlWOZE8Ny/4iyuMnH?=
 =?us-ascii?Q?nDDEvM35qo6Ypfn3cAZHQLw99bjXA9QUFkVNXsHt0Pu4DDDVwp9EygR7p0RS?=
 =?us-ascii?Q?Koj/9s1Zat7hTgDoZJI8QthY1nTLCjadZRj80po0XmF09UxOCoMO0wJDI+Id?=
 =?us-ascii?Q?SWf1EnAzHKg+g8AmV21IxYJ2uUChGol8SXs4T8qYQR8N8WwpeFZZwV4Zz9Ok?=
 =?us-ascii?Q?hvwYDpwRTQJBf587IMx8Auiyce0Y2NpFi1H8Krk0A3xOs1Xuz9KWXjFZBvw4?=
 =?us-ascii?Q?QJTN+Qg68HD+ibsieA4sGlBwUrWc0oKHW7Z/1WZaRai5M11FIbfOOL6o3TXy?=
 =?us-ascii?Q?SrRGUaRnEEDvubbq5X46npboeFpMNiUfX0VS15z73axWs+VtQxKeYNxpF6dD?=
 =?us-ascii?Q?8pz8oAXuX2yEfoE61w/QpHE8NTW03ujpYHOMOWGglmoukS9p75zppkBlhhO/?=
 =?us-ascii?Q?Xp/XZeydBGi3WIUFjFENAr79lsIOjA9S4mUmKA1jWuB/lH8QdTjmvMcCJTyJ?=
 =?us-ascii?Q?SkjTTM8ZdIxEj5PRcqoFWJ59n8PP/rioRmfpmBcMjgtNYgImmgqx/GCd+8Jv?=
 =?us-ascii?Q?yOrovaG5eiZvT80f4p6Sfi19FnOYrmWcatgt+FN1Ge9yxM1eIz544nZwmWSS?=
 =?us-ascii?Q?hL5Ild0pmYeVoVCK2xWhYhB4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f51cc4-a943-43da-e422-08d8fed0daaf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:05.1246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNibXmvyWxzqvjyfjrysEexbRNFYg15UL+LpwqRrObaQI+dSU4nRyAxpWyEX3pveULpx8Q7HnsAuG7CQLtP/lg1p5YpytJQ/OYRI4IwbHT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: 9NFEWigUFtj6KpkCSUPBIeeHwN38N1AR
X-Proofpoint-GUID: 9NFEWigUFtj6KpkCSUPBIeeHwN38N1AR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 542255c94d96..84402e827d42 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1396,7 +1396,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto put_task;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto put_task;
-- 
2.25.1

