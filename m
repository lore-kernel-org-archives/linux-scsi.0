Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B291C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0E064E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhBQUej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:34:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbhBQUby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKT7Nm122975;
        Wed, 17 Feb 2021 20:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fEMPY+6qCvH0hiOt12Z4K7ndTKZZbQYi8f7FY3SVpRE=;
 b=X1qR6S9tEbHzAN1IkXjHYhowYaCatItdQGHpKEv+KBHi3WSr5iwKKeZhmh90/oZX5cWp
 SSc71MkmTAZWJIr+OsTd3SAfMnjvMPR2sk8QRowsW1r9e6zmlrAvnbxfYL9crnFV+crH
 Pll+CfiH5W9k3YWDYAajv5YaSm8ga9OTB/UhGuDK8xnSWHJNj+DLK8NzgiwrR9Bkb2Nm
 +64+q+6ODiGjdQ+xQKnBiWc6IJU4El26WWxchXNEftNekDrafvAYc+0u9bR0RLPOIRzZ
 1AmRBOuXanRR/TG0bnwJuDSWYoqAjKnhv4KyqTFJJS9KBNH3sLl/jwujhY6EjYEFrKdf lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r3sap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ6x8111972;
        Wed, 17 Feb 2021 20:29:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 36prpykfjh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guJ2w0+g4x+n+MVu1N9gnBX8RR7lRlVum84ZWYE4khfg5ikPs3/igETCynzB4aOIVGVuBjB9xr2mXu8KI9mZULoEPC9R+t/q+4xFkP86f6LzrKHquyeaQX3dpOGMCNoYApqi1wY12iKt5le3OY+meI1NNjLj3C68EF2GIQ8WR7j7gPYOZnAMpuxJBNManl7Ac5YtDP7scYKk5twWbOlbxu33TWzdwRYPVZDdkSBHUsQckKMKF/6ReMLJK4TwqMlyjp8dYlYbLeOndWjEf5a1wQ/X/hW1dhVcoXq5RUQf/yV7B+iUfaomgt18S0RgXo2YcF/gG+aeXkiQ99/lejUCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEMPY+6qCvH0hiOt12Z4K7ndTKZZbQYi8f7FY3SVpRE=;
 b=hBN92pOtev1f6I9+a+t+RtKvrfTtUt3NKO4AlYvwr4DMj0KtGNUQWPzhOVH7Slj+QtJCpsngiXlw2wl5hcQkDPNOZnrGORqTAAHnL8iKTZF0D9RA5RYa0e/eISC3v4cL3Bvb1Cp+/+jV3MhxmcVoJhkyGZWuDJ5cq+EgiH0ttiW+EWgMydkD1QZPeINfyDzKpKZC7RX5Trz6T9Fm2nQ4WMH4f20SgeRAMh8t+0SJUixFxW+NyMwUbK80UvuOOChqQMvRSXBprJtE36yGIX6QacUbJLOM3LBedpiqt4i3DNMpKlMc767Vg4/gKqaWwzAUz3Cv9BBOwQf+52eHyvsvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEMPY+6qCvH0hiOt12Z4K7ndTKZZbQYi8f7FY3SVpRE=;
 b=pvKUbnSXmswP4C2jrhY0egwrm85fcxpeOua4YKd1JRPx72aDfUj5OF8WawRmJnPFvH8fVpPGT8k8TqSfCJIZKV7yMqwkAVyJJgXUjLwbbWvmABQdupIct3PBBkl1HY636LYF0XkU9WPB1YCkNmTADSaHaqf4KIoMqwSud8oRvm8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:29:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:29:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 24/25] target: flush submission work during TMR processing
Date:   Wed, 17 Feb 2021 14:28:10 -0600
Message-Id: <20210217202811.5575-25-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:29:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0c421a2-67c9-49d2-e79e-08d8d382abad
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB394017322D8867C6E57C457CF1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpEaOnuBWCFE4q9s4oP048ZsvXkh+lN1Z5H1tD0rDawBJrGeUl5TdhifOIagH+nO/nU5mSeVzVaz+MEAy2LwgLOA7BvDeU7CBI7RYU7WcERZ+4Y5HakfmZFe2+M2R6oDjphpj+gU0KjPUdoxSBRGRbwr7TwDMjImxWOG2iC5rJssxsuJl4IEJKrIsW0YKLxHTugYLZINbWkFT0kdWLEcS47lBV9erPVljeXUaU3it++B5bvbVJXWnR8ZhenyFrFArV7b/o298VaLz5whgusH+uSUv1UuIEps62WBLrh2E9+6ej3J6gX/1J9wmo16rG4fRknEiqK+ssQLvfP2ZAQGltqE0dVktlGoQGnkEb+5bxpVrb0rr4U9eybzbtJ+4/td0KtthpJnIxUYCKdNbAgJx5nw+5eiwA+fZ0MMhgUbhV/nEH/nHt8zLFIpdD939/IJ6pH/r8YXpCpgGa/v55qE2kvTZRuB1fEbu034aoGJZKVEINmrcGWI7O+hgi749GFUhdvCugzvP7PkGjiHLs1ByiTHP0dQEC8Un54a6tvIn7HVcUkYcx/RpuOKepRAOFcTyHcqvyE5SlnYb/tUmf/K4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d3lLjBMwS2F/0Iz5MnF9wVuwL7WpbFsoSDfj1E7GBMKf+Z1KB8ujVSoyieAu?=
 =?us-ascii?Q?sgVYuLcMkWh2XHKY1/rjDNOk/o+BjhQZ1305EnRx1RwEzHWRgfWer47T9vl9?=
 =?us-ascii?Q?A9nwBhburmbP2A8ToenejWc5NqtOrlp7y/7X1Zg5VdpCmdQTs7vvoBbflaEr?=
 =?us-ascii?Q?U64IR6YRHNN3oH73Wwzs29bCyYHrdPEibbPHrIFvhzx2ThVohS4hgXa9IuKj?=
 =?us-ascii?Q?lEO6/rHI2iPJgpy8t4utojnLZXMAqN++gP76MxkiHYHieRCfV+5DzGwPu4ae?=
 =?us-ascii?Q?q8Ib5IbPcsRi3dHR0oXFDkDB5ZAvapPXsoZi4ZIXa9n5c64Wkwy7bGleO1Kr?=
 =?us-ascii?Q?DxFFldwJqHQtukWEZ6XFCmgT7q+5H0h8m5NfZyXPeezuibuaEiRVWOFiSb7k?=
 =?us-ascii?Q?PXZkJYtuNEGrhLXEUlG973cTckWGcHOlg6GVk+aFRUcbRnTGhTE4U4N98/nA?=
 =?us-ascii?Q?yideeAvozRRDpv1sYxdU+eZQCR/qFFAziWWv2oSyBRK/u9DRaj1MoJLBI8NT?=
 =?us-ascii?Q?qDsRilQKJmQtlGwzcH6apcRKM8bOSEOhXFRo36d721gV1szZJFYSfgY168ZD?=
 =?us-ascii?Q?gMHgshpDTrDucVlb6KweZFkOCxji51KqhlDe/kl7zkG0GFq+tGyrArwFeubN?=
 =?us-ascii?Q?MBxyUQ30X0F3Gr8rK/CunUlVp0JW+mdcs5InYRCDO6AZei9UsPOmF/LidWuX?=
 =?us-ascii?Q?U/8lI65xcdFW4M/1v4HVBtvwM0XOFZQYu6WyITG8bqJdotcA5bnfvohquO4w?=
 =?us-ascii?Q?PdRJcmCuW3k5fWtfnnyGNsdFJ/W8ex6yEgQjJLLDMSbAxQQhDPqsHOF/+zm/?=
 =?us-ascii?Q?gdOXnzJ+HVww48Nnw1Jq2+kig7149SSAOzEbyQGMhxpoQieRLMQBS8YqbzlU?=
 =?us-ascii?Q?O5I3K7WWvB7EuJJTlmR7YDp0+6sh+pKuj8LTvm0ZLCfsfUQOug9q1wM8YqbZ?=
 =?us-ascii?Q?ftyB9+4rzE0vPRxyzM11SwrztDEooWWoT9BPSF1UTIr4HFOn9tdxao72zOYr?=
 =?us-ascii?Q?cZT/S97muFxjPW50nmZv934b5ZJBp88zEIfPiAoN2i8LdEJzYt4N47MCZF7a?=
 =?us-ascii?Q?E/e67QWBfud20/RIZQ0be99lZ3z4U0IPi2lLWTz9X/6MgULSnzItM6qWiEXl?=
 =?us-ascii?Q?jooQkMYF3I/Oe36QPapVb4KAiJ1nl3rU3HK1r0QMBQBG7vp/f5q8ljOaHtLX?=
 =?us-ascii?Q?i29eYa+YCDJuSQ2V1LTUqNIxP3w9ebmxXydKmx+7URIFEekpMUjm1pJB+x53?=
 =?us-ascii?Q?2bacHtOp9tn5D17DNAgim//jFWWk9C5p8I9MtibEoSqe1jdDCYM+SiLMn+Fr?=
 =?us-ascii?Q?Q/o+O+V2Pm6ZJtGAo4GVXBjr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c421a2-67c9-49d2-e79e-08d8d382abad
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:29:05.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEUTNL2dDDLQ1vqJEvuW9yQ2JpoVPI3ctq/r/l9aAl+Vptcvq3l78PcEPPkNJqic6JDQDhVmLAWG+edrGjPzzV58s5nk2/j8LqyC5xoXvv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

If a cmd is on the submission workqueue then the TMR code will
miss it, and end up returning task not found or success for
lun resets. The fabric driver might then tell the initiator that
the running cmds have been handled when they are about to run.

This adds a flush when we are processing TMRs to make sure queued
cmds do not run after returning the TMR response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
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

