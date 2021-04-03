Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B88C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CBC461360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhDCXZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236633AbhDCXZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOvVb041947;
        Sat, 3 Apr 2021 23:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=6m/an33mev425U6J8CS50EjBY2eqVe6qeigwC7ISfDY=;
 b=uIB+oYgTUqyIlc8PnrmJW25ui+U8OSxnqe6m0rU4N+kFJTmfPGZc8pyUV2D6CMZXQ5Qn
 bkviKACnozK2Ep+duPoxSLCADjiIrq8E17ZVDv6Hp8XacrhcTl6Cc5S61s4+9zB8k6Gl
 EOeON3HzsJtR3JDWStfDCEjHkofvY6ws0aYJ1VQ7LtBq1DhndTzyap242e3mF71oFcdM
 Ugva7/q39iBXfJ0Lt2cegvHrQtGjke3b3ryJ9IExnTI5TKYAapZqd6xmPmV5F5Zb0ITS
 P5iDB/L3oB67B+1xPy9w/BnlTFyOHGXQjs7sUAciK/HOGJhwi7R5taPpSuMLNQ4Y8wP9 uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBR117020;
        Sat, 3 Apr 2021 23:24:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXLBtoWvDB8eORd+ndJmj33TT2xrnzKBl6V2xJl6GC41QCkW5Fg5Hh1MvChzladByocqNS3fbWtHck6xHHapPFml01pzisnb0bNqiSFBo5JjLn00RbvZE99OSTwRaCNtwAGrUPo/xrT4gzvnkI0+AJqmsiu0LqnD03psyKoggozotAYEnMVF8tMYg3q1ZxaYvqbElPZy3BHN8Oifc5PdxdHSZnfKNk/mMofEnHPC4c9ORnOVvyTwBK1sh8TO1OWGn6eF1Ouz7X6yPzk6CH4MEs0MFhX7jlRo9heJjASYgCW8ZI1I+sYi4Q+w/N1I3um1JFnwxJOwBH155fSp0h8DHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m/an33mev425U6J8CS50EjBY2eqVe6qeigwC7ISfDY=;
 b=XJOGLwyksHx+30vhKU5phw4kD348/GOwACLaTDy7q3c8TtCfQd/cYIjJ9HH1MhjbwlcLmhpU9eHFjh4t5SkgZM42T+Hw6Kph9tTWllzB8lNkxARcDN+C2fDXklLhVP+WuQJTfAxZUy9/twNiU+14WCS+dr4bLlGyqE30Z+NK6UMS4CVrKVqCPjoKB/2jCU8iDmUrtY7O8AJO3n+QmGtza68RNIxSRmK6/eh1Bv9UkVTQgeEeu1PfJ7GkW+ckzNdceahdSougcjQO/bS+RTdXGBJ3Wg9ZXqd+SVRAiMva2PRhqEx0+2/FU4SGS5MjcNhKDPa1y3CEfckzDecvRsDn7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m/an33mev425U6J8CS50EjBY2eqVe6qeigwC7ISfDY=;
 b=JeshIR/bA1Cm2Jq2t65eu4TxTRHHGlOLfjzUDPePF72Qu0uu+dUc02LLPAguBxsvtPeFB6Yh67xxqAIuPWN+nTKkxQiK1aXL49dcHjqK4OT60+LRXtc+qJhgtuIZYy3S+8fmIR6GEx9DvohSc0PB2YS45YwaUuLzjFpYbWTkT/k=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 30/40] scsi: be2iscsi: prep for back_lock removal
Date:   Sat,  3 Apr 2021 18:23:23 -0500
Message-Id: <20210403232333.212927-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53d57d42-4db2-4557-c884-08d8f6f79db9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB343128F68B4E0C52DBB3237DF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vf0xxvZpJT+OALhiYCZHeHrvNoAbHSUSDAfRDkbdp+fgiPnWAQpVzdE1ODN2bMtiIz00+4IrfMuk0ECN+x2Bo8rd3NUcjwl83lG7n6E4PjgdWxSn6mdCD4HoFGeGFBqlLV9dmPleJfBZUXoLTR7E4iKQhhY5oiBicpwaARb+h4NhcW+rVPshpQcTKMWgGnHQqMTAA4PpXay9G4SVFjbrGok4QR2Vzift7rmM0gtKhhz8jEAhhVGGj0EHMmazZBabXalkRAUTF6cxHvAlPNeNVbld6HfIsBb/swGbXDdGY3k4yFvSfBEsJ4QTftnCGntg4bOa5s9tPzOQSNfqY51s4UpZ/Nm767YlA84CUbKRcFsNyTwk87+63cAKrk+MPqApQhMjuOqHMUkXgWq6p93TDENKYiCJm+XWrFn0XcQIT2y7/IWZv8ImljhsZhF/fPc6SJVB8bguGBuRlG+a+A3Jr7TMMJU2mgHeOzOAMp4xR+XUiy/UuNKE8CoiYScIQMt4hoNi18ervcZwfKrnFEz5xz8ks29Ek6utkaa7p9ZrAsg38u3IxLr5UjXvdqvqjHZNJgp9xccWU3i/8xkntkJodRlubSaEYCBCocn/1LAhex+rU2qJ/OERD+7sDLShxjgQfFw3Uy89ZOrYN8zjI44KlFpt8u3OqXp2DrSg48d7EF89DEK5NVTCLsZexvghiD50hdiGCCe588U5QjbYxpTTlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tTsiSKdmp5PwihrsQitW+x84F19ZJaXjHfDA7Sl36ImhwVeKlt6WUyzHpNUb?=
 =?us-ascii?Q?7AsdQi9Eu1cmlpFS52n9SK6C1hgxDSrLDRS1bISvM+OD30C0QNtNUkceYwEv?=
 =?us-ascii?Q?QeKZBXoQ0X75vAG9p9iAGlgqfzyODv35dS0bxjYFuwgjxSvwZAUEoDOJ8YWM?=
 =?us-ascii?Q?K+t/gdi/cwbd2swuZn24BQZNoQFhB62ri/FcWRbtMUbzS05m+DQnOg19o7zv?=
 =?us-ascii?Q?nbtNdGAPerF2ZkHdViO1ByjWtT98V1XsO1S31y+fg2LQSxAZDm0v5PEMGvx8?=
 =?us-ascii?Q?c1LZP+pYHkB4g8K2mhnA8xj3pm+PwTTn4uDoluUQ9WOK2cnWnaFXiPWdMsRR?=
 =?us-ascii?Q?9bMpQ/WRdn3LkNsJdXx+9RkCugRM8wA18rwqdDe0j6ciRMzB/PGSVW98Hfzo?=
 =?us-ascii?Q?jb8oBdtkRu5z4ei/KhFiWiUzIt3H9Fdn4LOyFJCSqPNUSRim0eeSJ/IQuTpR?=
 =?us-ascii?Q?ocx0Jji0GS3ZDuTQ48bLTaezyz3jAuwz3nf1TjAf6fF1aZvWvRe4vu/9q4dO?=
 =?us-ascii?Q?Cc/nby2afLJdoGesfUBDVQGsdsH0usxO6Z9ukjBzQ0ObXnEnTiX3RAs1kn0V?=
 =?us-ascii?Q?AWbXarPY87VczCukHDE6/YtSYO7q44iBHaeOxvd93QgQovBWqmNwnrego0F1?=
 =?us-ascii?Q?GEWgk96U/VSCKNnISJYgfRipl/hXC+TTJyXkVzyE59kz6Gd74Qy1nw9Dpu5v?=
 =?us-ascii?Q?00TqEgvuSI0JfYIyJIX8eNjx5y/M7sq328KJhmy+/VeP9d0WrvmgoxJsJCIr?=
 =?us-ascii?Q?YnEyRaLq7PsW6jtcs88pgYsVaJea0oSHuSMWmMjGnP/NhbctJvc6RcYD5RM7?=
 =?us-ascii?Q?e1xAJWI0nKAiD+YJZQ2HW+bjbcDhqKk3XvfW4REhS3ZmgeDkivDgDQOo52G/?=
 =?us-ascii?Q?K905OI3VMBZlnScsHN/D6Y5Iixj67nm4PMAYFwXc5D7pQhoAqO2H2OkYCR8X?=
 =?us-ascii?Q?qneGPqGuBIDlCLHYKbFDk68pVUeH+LpmHXeNxWiFds8CTTxMYJfqsII2BAPq?=
 =?us-ascii?Q?FiYIuYMXFl67a5REUedN3zKwDjz5JqGmXikSTLPk/ktqYRkr3IcMVkp8k69i?=
 =?us-ascii?Q?Gt6Dt7KITopGTu4FpBvQgkDRIW9NNzUtW7A+CVgXBAuIZZCAQb+a0TlFDxyN?=
 =?us-ascii?Q?mkz0rOABGHA7m+++s9AdtwSL8aI1T1m9W/T+6hh3wnDm1ReB2qOfl9Kdq4zE?=
 =?us-ascii?Q?2t+4XBd/tN796Os6LX2J/hf/uYY+7bHPhBs7cRF9JKLGC5n+YV93zpuGt7by?=
 =?us-ascii?Q?jUfX6NCXZLOcSMFbqHgMv1RvaKzWWyEUXL1VyMHvcqOA7pt6DfICmSWquNH6?=
 =?us-ascii?Q?JUH3l+35gLDtnZ8WbaYjYiNK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d57d42-4db2-4557-c884-08d8f6f79db9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:23.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOns3/V1E11HkihiugyL+oV9rwzoDJ3s8PsYMp1hr9kWETO0R5R0+klB0f4UgOXfNpZLJwib9BZDpgu98Ak3ICOcbQh/XjxIcSkCWPbFpEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: NkEKhxlZCk0LIc6jw53l_GY00rJiPCdL
X-Proofpoint-GUID: NkEKhxlZCk0LIc6jw53l_GY00rJiPCdL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset removes the back_lock. To prep for that this patch has
be2iscsi check if the cmd has completed in the driver under the wrb_lock
and then grab the task lock to check if it's completed in libiscsi. We
then get a ref to the task to make sure it doesn't complete from under
us while we process it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 39 +++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index da5ede4ef7f4..fd62258b1b6d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1228,8 +1228,8 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	uint16_t wrb_index, cid, cri_index;
 	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle;
-	struct iscsi_session *session;
 	struct iscsi_task *task;
+	unsigned long flags;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	if (is_chip_be2_be3r(phba)) {
@@ -1247,12 +1247,21 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	cri_index = BE_GET_CRI_FROM_CID(cid);
 	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[wrb_index];
-	session = beiscsi_conn->conn->session;
-	spin_lock_bh(&session->back_lock);
+
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	task = pwrb_handle->pio_handle;
+	if (task) {
+		spin_lock(&task->lock);
+		if (!iscsi_task_is_completed(task))
+			__iscsi_get_task(task);
+		else
+			task = NULL;
+		spin_unlock(&task->lock);
+	}
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
+
 	if (task)
-		__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+		iscsi_put_task(task);
 }
 
 static void
@@ -1338,6 +1347,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct wrb_handle *pwrb_handle;
 	struct iscsi_task *task;
 	uint16_t cri_index = 0;
+	unsigned long flags;
 	uint8_t type;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -1351,12 +1361,22 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[
 		      csol_cqe.wrb_index];
 
-	spin_lock_bh(&session->back_lock);
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	task = pwrb_handle->pio_handle;
-	if (!task) {
-		spin_unlock_bh(&session->back_lock);
-		return;
+	if (task) {
+		spin_lock(&task->lock);
+		if (!iscsi_task_is_completed(task))
+			__iscsi_get_task(task);
+		else
+			task = NULL;
+		spin_unlock(&task->lock);
 	}
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
+
+	if (!task)
+		return;
+
+	spin_lock_bh(&session->back_lock);
 	type = ((struct beiscsi_io_task *)task->dd_data)->wrb_type;
 
 	switch (type) {
@@ -1398,6 +1418,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	}
 
 	spin_unlock_bh(&session->back_lock);
+	iscsi_put_task(task);
 }
 
 /*
-- 
2.25.1

