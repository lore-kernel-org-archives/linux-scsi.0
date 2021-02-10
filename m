Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA67C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19EE764E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhBJE57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhBJE4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tiSi005006;
        Wed, 10 Feb 2021 04:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=jsqm693wILx/mwIxJVihZscliIIwsi/zGUMkMnUoSYL1Op/JaVC8qs07thOh+v0TG/nq
 po9BGJrTWMaZlWeZYuAJvt/TBZ3z83JoAcngayZEOFnIHc1LFKQ2xxj/UDXO7N23zqtV
 UK6ptpBcNBQ1qHLYbVhoVgV6vFMejhNVdK0L5RXOX51PacWiDT3K9HwPuLXIilz59Dhc
 mci/pS/ZQccna0zSi/AcBv5LXhMqlfT0Hy2aWS/SzyVpKVTomkZHeUyctov3dWZQYEFE
 vlk7ilDyux9RRDEhJXCrqJpwJQUSpVfHG3wHIyEZ4Y4Am67oW/AkQKDrv0fH+a4u3sf4 OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmaj0tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBF048727;
        Wed, 10 Feb 2021 04:55:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDlDDhGI8z7EqjBda3/BX0bIkf4nJ73Y7i/oPjcFDE5ufgKE4ehb08pfmLQoXNS9SD04PaIIuFh2g/0MTrdK2WveBU7OMEZh1wGHtEA1qXCuJR9kqx2l1VbrJmjc2AxlHvulOigjtees0m22TyUiaK8FavawpUOYqQ6RyVKMRmtf3BlfV0YoDsH74VotuKBA2P1O5oRkJCRtQYKEufnF8bep4UIfXrvduTf3vAXnlruZnQUnJAv3N/RR6Bli8XIxS5eUSeNMIZ9dqCbe8L9A92lzErfpk1eNaYckBXvW2yKLVCRCEYP2tJpGOAr/4s20L8RTS/BrETU3wPmUQW6oSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=jTGb2bfBLj2SPW63yX/+7eQeBZCke4UvUXOVy0n2ZqQMYWjvdAeC4Y2GQQYWxueoRr3WzMYkDEyoStmVp8/Gm98nsCYYSwOLsvv/wuiINQNWFFYxeowdW7v4Xlot8RS53RSJayt+vvE8nmrZ6yNOl61pHGbZDZegv5hWxU9QqB90EDT/JThM3y6v49trbWCy1y8r9ySMUIfurJZllnnh3iQOyjI5W+8Wl0XnugZsr/S2+9hu6nSyLAlQimI7IM6pKqGj4zdtYtJjmw/ADnM2XVbkPpe8XdfquKWkb25t1JGascq7xOKL61M3m1QgntVGdEQo2Dqb6NPvMPK1k7dcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE7X6Y2WJE8jMeetfbralCqoYoDOSmH6oPGYGkLKl6o=;
 b=g1Sj5vwGxafp4KxQ1uc13axf+fyLImZkIAfQxAWz0XSPGIVIbHfieyb4A7VHFORg42kc26/aA+A3MFGsSGlLCIee/Om0PNQRHLbOnWMN2sOkSAO6RFYYaKYrChSpvlsD7j8yudN67M6IJjy9Knbad40xk3QtV2S679bxhmJ/v3U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:41 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/13] target: flush submission work during TMR processing
Date:   Tue,  9 Feb 2021 22:55:16 -0600
Message-Id: <20210210045516.11180-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91390144-b315-4acb-87ce-08d8cd801dd2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366F145B5751C31D983C791F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReiFZrDdreP93MrewtF6COq6JvT65sk4dr46ySLPepyt5igI/cDOJk7DviqFcIjGI4CPF2zvRi2krRF2HMwn9+jHpmXLFSoSrq5oMqQJo8rECnSL+8wRJ0VOBI9mNzm9RsrNoP+qsMhvm5dEK/f03xt8XGtx0T4I+dOOLNk31X6NUZeqSX43PLe0GIB/IzT9QhHoKtt9lXpIhL6e0G4K9RK1KCXPGnN/lXTcSe5rgKFi87feUFwu6wI8qVVGmlNqpaSK3Aym3jt7gXXpHXCaxohrCrte9kS4Edx05p6cVOgBeLnnespbAmxeXp95PP53P4ub+GBQ0Jca9xQtHcPSPPibqVOGXkzHNOshVBT60HzSnd8eDkIk4bJPU9yjRgLgfRi4R8VZSaPQfrdqR+BuD8ixw74SUca0fGSv0BNXxtUNP8q2VHxw6q1vKXCh/ZI8IXVvNQl/Sufx89p8tROCjA2FO9Scq1Cdan98v8Yd59b/StpV2cI+FhLSprDrUxRbzmParQMWA/p4+tE7gQw5IDIiib3S2Xrm+PKAv0xCrmO+dt9jF7ckiIsS6WrFHHq5mZGHfsGylBpt0LLPZ7wKFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UWXo4M/W08wGU618OpNWLN6vOZ8CsZ+BRSFKoODJYpfa42Ix/SjXuqQW3ila?=
 =?us-ascii?Q?LtD4xb+AszeXohHsOElA0rKbIUEcsHzsAhcmZ6FFg5ZwkmnqvzFbWS6eyiH9?=
 =?us-ascii?Q?2XBoErshvoPuVxF6cUtQQzLPqGXVr2tfGDncG/33asvWCeAcGiI8qliLvD9E?=
 =?us-ascii?Q?YHOPZ5XMtgdyu1JDoNWG2KjYTT6Uf4YbBsD4wCzLgnBgvsfy/3GItaXJiyaG?=
 =?us-ascii?Q?1kPFy67WHS26Wow1eqUtXq/d+8WeXbrFEtUVDen8PmclbTEWLiViQeg4Sq8F?=
 =?us-ascii?Q?hkL+4dY4sXDh7Gz344EKbdyq7q6MyF+O1i2FS9xhk0oTZn4m4S3un6pRBQHf?=
 =?us-ascii?Q?xispl0g/Lr3Vl37q0I2MOWvoIKi+KDmr34AZRNW70KeGoPhJjZ0y3+31uLLU?=
 =?us-ascii?Q?yT+/rYpjIsXgzkbrcPc8M/u/EjMyOtn/ZJCkyAhapzSb/lV/w95XA3eIjJUC?=
 =?us-ascii?Q?BseReN8FVte8UvSjGU6tX5IHBlMI2bSxcUS8vhC9fsnFylwIrWQMkpAA//cU?=
 =?us-ascii?Q?nfYAHUoldS6PkZIGiIL1twdSy9P1eLETsVsV3JeuJrSmHnhPUQltApS8Ww5M?=
 =?us-ascii?Q?xo+8JdEDJ1w2YAZa0bA9wI86Q1HNmOoM7cuiBymWJlG31sBR8CIjhxbMXQrj?=
 =?us-ascii?Q?wBUvh+K2epFGQ/koDyaAJ4tR7bnZhzXvnFrrMAXJ8Lsvjq5OErEwofpXUFgH?=
 =?us-ascii?Q?N5TX5PTbVjavEhrG7lnF+fuU1F+DGmYewokFv58UfH1c6yiB36/c8q50fDkO?=
 =?us-ascii?Q?5X7ILQY+Hac5LTt1vFXxJQCKXROhJDRM6qU8CoP4oSprDP9VvL8J5My8oNzF?=
 =?us-ascii?Q?NWngLbxGTIKR3xEuc5mzEMxxznXJNJNv0WAZNGUs/0XdaO2tQ5qwyeJTdTgt?=
 =?us-ascii?Q?qrpX7L7GqC0GBJRK/C4n4iBR2cSMZ5gR4Kk0lM7yqHSlpjemzPtI+lJMJMNv?=
 =?us-ascii?Q?wB9/Dre5o47J6dE+qhMh+Y0TRQk+UjygaeD35FDHtjggSZa6E4Y68BGHpARn?=
 =?us-ascii?Q?x48/LACVpelsrWXLULGSVhcTGCuZCzOPnrS2PI4rFGrEZoyziVn8bGDCOKgS?=
 =?us-ascii?Q?QD1bbMXg6zqiW0TcL8HndftZdvO4Lt+EicWi1NLZpo128ugFvuBwlvC8B3R6?=
 =?us-ascii?Q?Q3abcKg9r3r/RHNcASHTpE9Hxeouo0enopMiDPiJUepwyvoozG3TAPyKm5yo?=
 =?us-ascii?Q?GvWV0lpw+pREWl5OzZiwH++Vd6ce2jadKunN0OO1sZ/lafKIzBpw+QH8A4uM?=
 =?us-ascii?Q?Zp2160xNyje2+hUWz7CxPdQHhm972+AaErXGZi0gLnCVSfwdr/+zJQpYT8OY?=
 =?us-ascii?Q?vFzPc1WlwsLjrsR8iBj0uKD8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91390144-b315-4acb-87ce-08d8cd801dd2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:41.4938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GK9dBtt23/1eXEO8k3Odq6qaHMMGtMaIAUqxwC27uirSbbxX6oBaSwySDCRP3OJjAOnweYf6NUwOE+P3/Qhocma/B/Fz3lEOYGOd/sA5z4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a cmd is on the submission workqueue then the TMR code will
miss it, and end up returning task not found or success for
lun resets. The fabric driver might then tell the initiator that
the running cmds have been handled when they are about to run.

This adds a flush when we are processing TMRs to make sure queued
cmds do not run after returning the TMR response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tmr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7347285471fa..e7fcbc09f9db 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -124,6 +124,8 @@ void core_tmr_abort_task(
 	int i;
 
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
 					 state_list) {
@@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
 	 * in the Control Mode Page.
 	 */
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
 					 state_list) {
-- 
2.25.1

