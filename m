Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D593C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiBZXFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiBZXF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D137015DB0C
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:53 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QIHOfD008190;
        Sat, 26 Feb 2022 23:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nusCi8CcKQzZCFWYcongskSEqa8GkYjQvs0VkSC2rC8=;
 b=K5C+0DGGcEIjnme0WLVdXKuRYuHrVRajDnfLXoYpAxov56QNlx04ENeVEYH2JnaTDzCY
 EHuTw5D+/85Ohcq3C1T0kKKkBwQnpWgVz9IBtYBDrJ0AnvuxYKy/JEKYKfDh8l2h/gmt
 nktLUJyogc8M3Wv5x+I1+OXcHCz3007+uJjZ9zB/EyZFkmwSZt8QTEZq83+uhqaY8hAL
 jRZU+zhVci19unfIHLmubPmkt3uEMsE8IxJkPTTgFvoDy7iwnsaDI4iiv40yaXWc2kPE
 9Ee9EKedQcFcs6oex5YlsHgz8wruaCJHNxsJyb3TU56kcowC88WZA6f6UENyw47R/mhb yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02hbcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtKAK179769;
        Sat, 26 Feb 2022 23:04:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 3efa8awbct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr9F0D9VxnZFcfdQCmSSLB5qXd47cEIQk2tut3NjKX3QaRTfhKUwDOJWH+ToIMyoWrDkwk2KfLXJPogJKtrqIBEckJv21yARKcfzw7+EYPRn128EzegyE2Vozwuldq0tJDYmDpMs8pCXInA5VwVf167Ev+laUREVSxBReafvFDD7bJlKc+unXbUO56hBnEPVzwiMdBb4lXDiCiRrkBN4kHnMkJgUySmudsNmVbA/Kmug6sdUdxXw/MoPlmUu725BqQOQLd8X9HmHwPAa1lYvhJhd+9lYWJkeg9VtK0q78LBhWhebZs7f7dykean78yX23DMZJYBb9ht9zJam+IcjIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nusCi8CcKQzZCFWYcongskSEqa8GkYjQvs0VkSC2rC8=;
 b=lKvzhcYVWEnyw+atjzgbIhdu/txbmYtzH7OKtRVUhwQZSyRuSUolMa0JEBgEMl7ljaWNG69b4F5G/VUFxI3rLraE0YrW2Bv1W1/Nku9D5HTOKRZmzi8oGKOrc45A2iQ1+3MmeXNUnYI+s258nxlUy4ER0hVYng20TqGAimzRLNdxAJf0CRpLLS0N9faOUMJsxaZqqgVZ2I8eWMqgaHvHMArwX97w2Yxu/8NsQYoRUC4jeP6O3IAbhgkzGqa8y9qsqEqamgqrQ+IWmboMS1gi/2QJWKV9U2/w9ywU4RrM3fBDI63JnPIe3OU36pCsKr6OczojMonwxn+7B7GTqlRM6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nusCi8CcKQzZCFWYcongskSEqa8GkYjQvs0VkSC2rC8=;
 b=0J7N0s9H30ZPQpCS8uGZfv+u35NZeq/LfVTffp+gfH5h5gFmK6NQUqSpnIFITlA6S+XhZhOeTcsxDdUHmJojOHq4g0Wa7N7vpEmEgtVgir8pqtODImOHt13//3BQzk+JblpMBtvFQ0PWLBTiVgZKk5iDjyfjMKoeOUUb+4RJ1wY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/6] scsi: iscsi: Fix recovery and ublocking race.
Date:   Sat, 26 Feb 2022 17:04:30 -0600
Message-Id: <20220226230435.38733-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb59eb19-b6d1-4df4-376b-08d9f97c6055
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB575099BE2F0F0938E8F7E004F13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuaJS5XvQocFOkKLfJS/ytB8mB02/NjbSTfJVv3WQpVfgrfK+1xdyj5cdqQtyOB57YYxPiH9eIWxWyTBvG9bxVCv0SmYE1YK3q+X1hhtgE6vhBv59YZuBY8tgcOSLfhFd2ZyPvG1iXfbUmRNYKRJzDoPfn7DeYne2Sy/bhtmkO8RZDfaqCDLh16wUz0SuOyq3h79HUHHgLo24ewl7f5+jTjRpBmTbp9mukbRPs7SxKEd/ryfRL/S8C72/3IlHw/YDmRigjogqhhMReguDX2ffoRlYuN6Fc5VOHwuYJYyTsn/0URAe74jEtGD0c02+4TkJep1ypsxwbcSbbZW1rP51MEPjPhbvjlQaBPSjo0TzGHge3HIEzPYGIMGY7Lp/MTcnVKJX9R/2wPL0ba0GVi7gixL843SLAvTtgQxkmRLt21K6xlx1ZskmXyMFw1BOyBWNfxXUi1BH3av7xYrHZ3Igxun8cXLRnju4GUA/BtegEi/EYuoW2L+WzSf2gXaTqRAkdg7AskwriJUol6E0pQkelDrquM8kFgn35vFVJ7MnGXYICzA2lV9ES++QEnMrWrxkAs9SAcC8CHyuvA52RQ9Cgh8xEzQ+Zaoc85yIAfWMFa0pQnZUb1zil/yaeoKBYbNrlCF5jPVC99fZguw8i4tObN2zq9czwHXgWSlgW7oivMU2FLd+zW4qXwKLUWg2x8bMTDH9QurIDkNjmyNEdMPuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CwqmjJrk8X2L8vVdHOKzYDhrAVYGfVE4ko+h46Vwq10NUIQNPOfx9gHa1Esz?=
 =?us-ascii?Q?pFtR88YWFBT5Lx90afz0O4fNSCT15uisd25LjrnbdW6LLFlh1xpYZF3jK0lZ?=
 =?us-ascii?Q?iG6w1m93f7r+pOT8N7P1PSgzh3HwMp60sndNlvUZHu3v9gopicxdfmziyzoq?=
 =?us-ascii?Q?7CvvGIScsVr4td3+qu7o4VLCFPF1K6TUPzksd6wJ0z65Sw35G81jA5ao5tdB?=
 =?us-ascii?Q?aQ+03VOk2WdJpChzJ3fg8NW8Sj1Qd/+eSsqrd8jwPyNZMGHQiSONBRV/XD8Q?=
 =?us-ascii?Q?xy7vLQtbFNkDZy811Md/BmVIgEmK8OXcufnwgvjhueu2Rb1+tFCa0OyuQgWu?=
 =?us-ascii?Q?9NZCMM+at85LG3TUO/m7TTh4TNV/z8Dlzz/KFYvzDvB1Unyk0gW/sMcmxSdL?=
 =?us-ascii?Q?idWuhgSvse/widUQLEpIr+P+iA4eKHSejLZrT3YyVbxiiis3ApoBqMifrKCH?=
 =?us-ascii?Q?XkG7HWJvl/gaJf7x/bR0xX1ImtEXW9J65IAHSUsiK0cKrSJnP1yEEdH4goiR?=
 =?us-ascii?Q?8S3TnkNFRUQXL95KdJu211nnbCKmEiLQUcpCZZwprgTemAWVjs1h2AJ95TZo?=
 =?us-ascii?Q?jJHLE+h4USolf7GG3L7Lv6l6YwtQ6mBy6/iv8awzk76h1un7VNlWTXiDEfMM?=
 =?us-ascii?Q?0V/+Ai+FwjSc5qcKaBiAgJdzMI4J2Y+YTbui33vMt2CzjBMvFFoh28cxk1Ks?=
 =?us-ascii?Q?c7iSrdfVaWuB9l6Zwu12krPLLI1rwapkROsGgF1zGumsojKXOv0oZYMbjU6j?=
 =?us-ascii?Q?CVC0jRsYNahCxiIYRGTD50PbdM+vQbg9nyBkUrVkX+Im9VOAIKklWp142Shu?=
 =?us-ascii?Q?OAsRm7TNgz/SJk30ryP1L+mzTRV+k1lpJf+I7O1ut2tNrgjBgPFxjH1qiK4Z?=
 =?us-ascii?Q?Ps5lNbFLVQUWJO6eVhNIN3+WDnFFC58utph22AIgQR7xLHB9/ByAJEbYd0YE?=
 =?us-ascii?Q?I50gc7hiXaI/ZItxCx9qH5PGr/hvjYZufOSkylInhAiYBsz0AwaA3pLGyL4b?=
 =?us-ascii?Q?yOKrqtlxRQIUSmP+uug/k473nhVvFuky1d06Q7X/j50fkHzkrheNWsH7KTBG?=
 =?us-ascii?Q?+rMR1d2Ad+n0pqay+Bp3eZqXVZlLl6G/+PkG+I/ADSAOajHuKctFqcL/3lYr?=
 =?us-ascii?Q?F4EA6tbFbkF1TIp4xbP1GM3XXgKztNWsHToq1KbT4lFjlNR4VAcmK0P/PgFs?=
 =?us-ascii?Q?O8427QbV7JWrJOwcc3RFrlqx9V9j9AvnsCmWeMKAP8PKdnOobyAE376+k6S2?=
 =?us-ascii?Q?4vyziPr9JtrgKMijznesiU5Pt/PwbTYmFrLIL2NM/RqhNPLq1TIDPXS7HClB?=
 =?us-ascii?Q?GHMQRuFdO9hy32ES/ZxJprKSSm8lvPYPN/++t2ucgzfwvZkzbiDpouZRf345?=
 =?us-ascii?Q?EXEDXq1TyJRnZ9Y3OOrMzTjB4BNFWmwvnuAsh8It8U8IEqLU6Gwtz6B8MvWr?=
 =?us-ascii?Q?OLtWTR7ue83BOqhpn+EH4dQsx0rsP72AoRrulS1fcDLpRxI5aTSP7afIN+QD?=
 =?us-ascii?Q?CFG2WvRrSGL6VDAC07YxdX+ITuNTIa7Pbpfi94hgW+JPeva4vGzMd92QVRIs?=
 =?us-ascii?Q?QQCV+I2QwwcmWZKjNDDLs9GtfIYH6kEHIe/wHeggMRBDI03vjB1XZtaijIpU?=
 =?us-ascii?Q?TO3/anQLmQ5wLo8dksgRBobJ3Mkw1e+OvMYlmcrbH2eC+aqXJV3y8CFWG9/8?=
 =?us-ascii?Q?iO451A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb59eb19-b6d1-4df4-376b-08d9f97c6055
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:43.8969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQmEIZ5ojwIWtvFKxPVOvh8faGh0rtVqL1EJgQ8AhbLJqVWTxGEfZTds0EUPI/3ci3qG4ZEFAl1rAb42xsQFSeaWvajUNVh5EoLRMPQlHto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-GUID: c6u_Dz9OOND7dAeRcKaH1q1i2uVRWUsP
X-Proofpoint-ORIG-GUID: c6u_Dz9OOND7dAeRcKaH1q1i2uVRWUsP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the user sets the iscsi_eh_timer_workq/iscsi_eh workqueue's max_active
to greater than 1, the recovery_work could be running when
__iscsi_unblock_session runs. The cancel_delayed_work will then not wait
for the running work and we can race where we end up with the wrong
session state and scsi_device state set.

This replaces the cancel_delayed_work with the sync version.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 554b6f784223..c58126e8cd88 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1917,11 +1917,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	unsigned long flags;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
-	/*
-	 * The recovery and unblock work get run from the same workqueue,
-	 * so try to cancel it if it was going to run after this unblock.
-	 */
-	cancel_delayed_work(&session->recovery_work);
+
+	cancel_delayed_work_sync(&session->recovery_work);
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_LOGGED_IN;
 	spin_unlock_irqrestore(&session->lock, flags);
-- 
2.25.1

