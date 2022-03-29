Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE66AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbiC2SHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiC2SHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36CCABF4E
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THrxfj013343;
        Tue, 29 Mar 2022 18:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qIYJrTvzNbhTzPQXp+YJmxt/RN0t3M/tgdPW9kD0KOw=;
 b=KMLM/4zM458x9NTzar/AqNPA9rR5U9zqPvx2BoPL19ocLxVUg7+YX4MYSfamX2Fl8JUO
 GQw2KsYsBAWnNc3yMFjcVpT9+vn0UeSuTJIvjHtJB4JanSKJ5PNgOfVHfeFC1pdI2X9H
 1SeUNlADAPHZc+XRY4fLVKiZOJtOegWgYIMq3RnvFM+aXcAle0MUzbCe0CXiwqROxQHq
 HleqRGkFvtIcYDj3jxe0/eNcE3v5riovWnlZVJ5XQuMsI/ciE1WvzhYPCZw/QBe6/tWR
 hvMNIDUc63H9iJ5vhr0QxEFmnM/h6ckvowKJsYB3tWJWxXbg2Nexi9RBDLiM/HoWQrlb Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2fdyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THuk6V127683;
        Tue, 29 Mar 2022 18:03:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3020.oracle.com with ESMTP id 3f1tmymau4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfRf3i/AJ/YS/eZxNWpCRUBTN10O5faO3Rjc4pfI53OULDUi7gFc8EpU8yaKVr7SZ6kDCsQAN+HGmgO3rUDJrCoYu9OBWSxikuQbVBBH/78B/JSvqhjJkW08S5M+aqnuDSijfu7XMnkPdLFXJ0ZGri78tvZYjMNwCgx0xfpfW3XzZXDRtcrC6Qfs3uXtUN8xdazqeo/RTkDFiY8tARrmLj7uL+KB63tQR1LMTF82c1U3tAIo/UXuqVqEB6ozWzMNcXZ083hE2p03Z5AneG6EyWvsBfFWVb2sStl02zsK9s9uLA5fcA/2ROqaCsEmCrgjdJ7Y5eznDuQR9LVbnPSebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIYJrTvzNbhTzPQXp+YJmxt/RN0t3M/tgdPW9kD0KOw=;
 b=LtK7sZQqjth1EyPhTOYAcUlCeYmGjfNIKqn79tHa8JUfPXnJhEg/i62Z1KByGUKZl2HHOpzYvKIfoAJe4qD5Yc5boUxfldjUttbGhQ0GRacfZUWnlIV/staMp7TbUXff1C2qkftfe8TlK+EoH6Qi2tuao+g6mvqaCTlYpFzy6LIXtkryVbWdVrBREPbUYfbrHyZNLwDyL0ISOeXRmHGjBnu+xPrILI8xOcoJ0zWcBQD7WJ27yBS5iOrZIlW9rhq72Ezr8cgjrOrPLZiVNPNFaneEE+fMrXBo2zDqMokqZqo5QXkBeKIudE/+k8qfHdpdyppPf0wlTSRTB3bySZDVwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIYJrTvzNbhTzPQXp+YJmxt/RN0t3M/tgdPW9kD0KOw=;
 b=J4+Ve0fstSXkoVrvaahc16d04kcl3CASD6BdPxOPMdFsKRTKNemGA+U6FfWl7QTrOAoe5db+BESk1Gv8AA1PbgZUVi5DrB6Un4Hv7wLYBZRJNGygsP7+fqr2yj1dTfF7iKMvKSQZGz2dvHHTI1VwmRqU0Gl7Z0I66/KFNfehGUo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 15/15] scsi: iscsi: Fix race between recovery and task xmit.
Date:   Tue, 29 Mar 2022 13:03:26 -0500
Message-Id: <20220329180326.5586-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 458805d3-f144-4519-0e07-08da11ae75bd
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584BEB355A6E8935A3B3532F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i8Gcdr5Qi+ShULdVK3bsHr5iaTZ24kyKeq7MlVeMT6HNaI9RIkhGr9FpmxJatjavwlD1xBXkAVtO9XDdoulaT82QpNtXgESHGWlxQeb7FvV97goFhUCkMiTei4wu5zefEFlqGl7vLWxPvhQgxW5A5Xf8vuuXK2hnhSyyCDe88U3FX6yCvWnnDeLZHDBAwFeAegyA3+8tcyhk/y8bUriqkHbdIEXhmvDch1yrcKQSroyz5WFFLjmHvYBpa6bUz8hjpvmzHsdrwKUASOMHr5wU8W/oC/HWmaWrtLHb2THxOVzuEBtiz9Aip91XPdJ8VTCiM+8Ho72/TOqks/o/0J72gVV6WZn4arjSll9LT1GoZa1KtAvrJDhdFVq68wNLW8cn/OZYrBpW7BFwHk1eiirjzfZX1P14gNvhLTWsqI0zB9KhkKsgs1CcF0AztMK/ZV7UytuHaOtNLPRulcuY37/0lPFyK2ejc3b9UOyN7zXIKJIxM0hb+Mf8CZbRspFw+YiOXCzRF+6p5VLrR4deVSu1hCDqBs83TWTOsWpJdKzGq2eiOTpQ3ynEImuTc4e0MoL/dsFbAiJCoUrCbdBRr8jNjTB2yT/B8psV/kyDLm9k8OlPS+fDZ+DsXmzVnrIvdI+PngLzUXm3TXnAQJKohu9H8zpBL7nYMP3AsAtSEsh+uQTCLIJEndQZmTNpTvt63mH3PQOuBKeBBZjS/LKS6dnh5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjOp9X2qdmZVZeuEiR5kKaAEaJ6o+r621x5rg0gGLpwaKaNnC3KFB7nsPQC3?=
 =?us-ascii?Q?xxsXTjcCt9fM5Sw+zkgFn719QEVItxvAX8BuhUxZ+fLbF022LkWK9pIam44R?=
 =?us-ascii?Q?HDdXSiCKIg3CW23rPyG7Q4YVSf3uXDfR3/vloSCiPcvEHZTzX0kHpOADmXNU?=
 =?us-ascii?Q?hXucJL/20efnCKo+DrQx8yMb5dE+vbumDlPWsRhqha/mR/PHkiF/itXYhhU5?=
 =?us-ascii?Q?e868zpbjN832vzLN4fhCdzfXvDHn/o0JXXeWNMpSq9pjae8ADvuqD63v2mfs?=
 =?us-ascii?Q?Bawg77sDqxDPNme86XVQqbAU6SasSjtQm2UYo+3I8QMOclgzqqH10SF7BH08?=
 =?us-ascii?Q?wvtATT13zaIoE1si7lGIpOYxaawFTGYRkEFCYC1zVsD15BTthFSsrt5gPrM/?=
 =?us-ascii?Q?ClX8n0muaYyDaM0LZZ2bxsg/rxL9AN/yK9kCGdGvU6TuM54KHHF0WggCZN8f?=
 =?us-ascii?Q?KmCAKGGKDWs2vfhXETq/lbWl5Nopq0n5I4X1jZyH063hCwkcYomXy1QW5d+s?=
 =?us-ascii?Q?VryA0FylZEzF3iYxDMywah4KzA8kN61qyjvPdV+0UKOLFUYFzZRY6K3ZNYuK?=
 =?us-ascii?Q?c+vfxWEFwNvzcfFGI3FvQGWtQu7g1x1qnVFuxmyYAohNpfBQuRP1GDdzctSV?=
 =?us-ascii?Q?a9Z2GK1xCMx6XtZBb5rNYD1h4vBFnlAr3Ia/zq8YEdY71WJWo3fUe8vBRPy1?=
 =?us-ascii?Q?OB96UWe6pAcFX90rO/lNOO4423Pk3/f9sSEkHbMhYWEFGFqk4pkAqAD7REoW?=
 =?us-ascii?Q?AjflI56XBA6yZvlQKvBkpG/V5LG7god94tyX4d5QBdZ4U9UfMhp3I+AqC3E6?=
 =?us-ascii?Q?UujsVbiuEPrvhabVDqIM9R31h/09hhh9CwdEeaUZNTO8OwBRPehVIzOjn7Ss?=
 =?us-ascii?Q?Mpd8P/wepsBxGD4nPvagB2nBqPDdd09kfpvfM5CMqmljY1vn4Qpetzc6WwCI?=
 =?us-ascii?Q?OA3AdtVRBbLAPIYJ3hilDsZFyhkyrVxTCCcmaCuWmUTCIK9ZhP0cKCAWIaxL?=
 =?us-ascii?Q?3K2hdBSkPBOrJ8zT/3zm1Zb9+lPPfTyTid+fut+pWirS3IOvz0rjKlSCjOQI?=
 =?us-ascii?Q?OZGuvUARxeZkshYO619Bu2ZIA/r+iE87Gp4NkUzLoQECIS/zqCVfTQw/kjF8?=
 =?us-ascii?Q?LMDyPW0nBxVsKi1EJajLqXI9IY2xZgWKlWYFcYAvQ5Bx0GzAxhTnV5OVvcun?=
 =?us-ascii?Q?2+7crC1KLW5qaZI4RkbrFBIGlJu/iD7slMlTiiHBouYxTLeeYPRvHp0W1QHt?=
 =?us-ascii?Q?xtwyJ5p7XbiAGpmPjvAa3HqstajYy+acPTpEa+y1lGU9GNUuXD7DgczfSQH/?=
 =?us-ascii?Q?jzgvV95oALmANAHX3zquDTvInIVSB8/ptUTp0GKromZ9zYtL2bn999D3FlJv?=
 =?us-ascii?Q?zLFAq+P9BgxjvzzoiaXofhZHmD+jRFp63ORUGXcbDsogR73DFqGd+IobVKbc?=
 =?us-ascii?Q?DikOnAG1wBUbfqcng707JG4nu48H8xPK92oe6bbMePkL9v4W3qz7w8ePS86F?=
 =?us-ascii?Q?8rDgvWqxDoiENcx9Ij3kz6FkkMnqtt7btCx0qFQb9p+vaTc6j++1eoAjFo5Y?=
 =?us-ascii?Q?1es1ZcjUaewFjCs4LquEa7/NpASnBQA4+CcSO4wvAt2l/u5UhxRWTQDpnvI3?=
 =?us-ascii?Q?is7So1EmqQ4gcf80QTY0V3Rui8Al/IdJBKaSl+CRPAljQP7eDmzuGLJeMpi6?=
 =?us-ascii?Q?O+2DDcKboTwR3HtAF3YpwQ2HNGdcv+kCDwx7JfvoAXP3TVsaxAje7vQ+aiwu?=
 =?us-ascii?Q?UoYc8hbg5Hvv7wg2VlR6i8rss+cqPXg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458805d3-f144-4519-0e07-08da11ae75bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:42.5683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+pbnP2+srwJWvoxMR46CTRkDPdTD8IN2G/01bAY+xMohWWk9haY5PgQnEV7gyBAECsRCoP1M+6I9Qk8HwB4NAAZN+XA5tskgHVrIo/AECc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: pUsNkPX9jrvBcEAlEW0ug25moieYeNLV
X-Proofpoint-GUID: pUsNkPX9jrvBcEAlEW0ug25moieYeNLV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

set_bit doesn't provide a barrier, so we can hit race where we've called
iscsi_suspend_tx and didn't see a work queued, and then a work is queued
and run and doesn't see the suspend bit is set. We will then call into the
driver when they might have already cleaned up their xmit related code.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5380216f7c05..24d4392f65d0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2021,10 +2021,14 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
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

