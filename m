Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A1FC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 07:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F79C61177
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 07:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhJFHe7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 03:34:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1106 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237389AbhJFHez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 03:34:55 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1967VAwr024850;
        Wed, 6 Oct 2021 07:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=uRpg6XKheJdtjiZVFrnRRweFXLq8RBMANvbyYjgbLxo=;
 b=OnPpN6lEYaCrMZrIt4N7lqTMzecoDTcIeDUx/RwbRplQzo1iHIk3TImrdCiKEm+FZqC7
 Po+yjg32pRB2Ml4G9gndB4iOoKiQ+iZcC/0cB1Sv5qaZ/87WoXJjR1sSsL/0kmUbuuto
 pnqN+cYlN542Ht8It5YH1OvOZBzSPxF2cJ9pqUBm8FcvOKkADRV2YR8dGw5hSC8f52TB
 XoxSy2f+5YveCVSJ0FL/s5k3qKfmlWzrX1OrgHOoyx3c9/sCe2ZA95LarFqQFnnbAWyK
 qnKr8Pj5NxKZ9hLxT72lmyuAifA2/Z2tm74pjvogOzDtuE4BN7hT7gcjJUKRZRIGzWXk zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh10g9ut7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 07:32:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1967Q1pn157666;
        Wed, 6 Oct 2021 07:32:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3bev7uen0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 07:32:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBLO5Yc0PxJ04Cojqmvl+YJ6f5OwjAzWKg6thsjYRBZxfgM0ktpYYpEo1o/DD+Kib8gi//vRH/aFESWKRWuxZdjymgWO2JkEfvNOEQw+seTmHIRxqWIJEyJHzbrWVgfOanL8XZxDcOXsYcK6eAJjBt7XZw1+EQkuGzIyHq4Gor79BLp9ukx7M32L9Cr5GlC+HRlsCb71EOvacPZc2Jx44VyXpf2cO47q/Upd6AAkL9/AEg+glK/CXQEZJhSQuEGKj0JnmD79qwyQ6AMlkHIK7NwprbFO4InsoxmSutHR+IEdoUPq+mzrV8lyTwxllVh5LmiTrjKxgVlyTe7/wcuFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRpg6XKheJdtjiZVFrnRRweFXLq8RBMANvbyYjgbLxo=;
 b=BpjPVjDTN7iAGvuNJ8PR+Ve+1R2wrmVt9e+QOLq74gHCk4qKa87f6NkKAsfMzD/BK5ZxqxwjW7cIIPJasKh7nPYH+fEnB9AYRzzYxZYaI6kgFsS1WTqDzRUPeuMDaaoitf+rGjvph1JagcWRB6Wt57G7K9/5ndvmsTL2Sews1xA7oLrdztx+VnVuqtl9MVaBBhhsbmAbUvSRAfgjUGkD77QJ4Fd+v5vvUXe7QiUqVk9AWjEur+EFkNkzD3MpE3EWXli3RjgNokF0N6GR9Y8PwffA3wsDrLKAR6e1VhJCt9XAvsQGyKnMSg7sutBC/B2DVWHX+vvJeBh8/wZDIULiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRpg6XKheJdtjiZVFrnRRweFXLq8RBMANvbyYjgbLxo=;
 b=hPEc/gKcTai/d1gD2m0apuXie1oCO1HoH5MnMY3Lnlcj8oM5xQd4esfkOxLGSgAtf86h2CnaRKbAdm8Es5cgbeykJ0epiC08dRM2S6b/1BMzv7R184PQF1kqOB1zyz3uEGy3pu8DDk47AEYrQOJOXAEIBWXzlzrbnfmuXtgLZR8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4546.namprd10.prod.outlook.com
 (2603:10b6:303:6e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Wed, 6 Oct
 2021 07:32:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 07:32:56 +0000
Date:   Wed, 6 Oct 2021 10:32:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Naresh Kumar Inna <naresh@chelsio.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
Message-ID: <20211006073242.GA8404@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: VI1P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by VI1P195CA0014.EURP195.PROD.OUTLOOK.COM (2603:10a6:800:d0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 6 Oct 2021 07:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74e93a6d-3a86-42d7-63fa-08d9889b8377
X-MS-TrafficTypeDiagnostic: CO1PR10MB4546:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB454662FBAB8311FDA8C7153B8EB09@CO1PR10MB4546.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: loT7GZZwvZ9MnpI+ocs8JW5834u2APLyzetk09vdZhsRnsEv6OYpPlJNXZljw3BRIvPsr4JAh6PlOna0+33N5qO8ZvYGMh+KSdDpwn2LQO3KTHvQourpXROHkckQHhyFLgwwNrDNx3pngIWKnOzKCW+cm1KAcGSCunME2oKdziZzDIYkEUP6DOEPcUR6SKJEnQQGh/oBXhLJPo681l4PX/hV9ZBWT4/C0qWYDRuDz4pfzCOaK8FP0CDNZ5n5syIip6zlJgF7ipJs76t3+3B7nOQimb3Wettzo5ygVLJFLJ2REDP/dgFzG8tVwPzAuN9sgoDTR34ISfo0xnPtjzaM9exVpuoB+gK1gOwwVM5RE7/GcrdJElITeiqRl80VHYcGygLHiADBAn5GPvBB1HFd1giCqbPS536kWPwR0JNVp+1+u12XI87MOjV8mFrgm15Z3kMLQFAfcu73au11IxhdwvGiTf432gSMERsjXLGEJGjPOgahAmRrIr/aoE2jfLmRNhNpyb8e/Sk5NKzFSS+2Qn0zrcOFB2W5r4fWnDba5MN2HbQVGIPgZfrZO3JAaBzzS3tPxjrPut2KGqtKFXtGu7Hkk025wzgLY4c3aSoItyrCNUqlIuSAl6qflJhkqkAk8wzRKASBninZQsInNGIBS2f2CKE4Y3D6Fxs/QEADZ1wHB7dxvkFXO3Y9zZOGmPx7/pp+tCrti/tVRQarKTtLNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(86362001)(33716001)(1076003)(26005)(508600001)(6666004)(44832011)(956004)(4326008)(186003)(2906002)(38350700002)(52116002)(9686003)(6496006)(66946007)(66476007)(66556008)(8676002)(316002)(8936002)(38100700002)(110136005)(33656002)(55016002)(9576002)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+huCKGb4Ssftq6/Q/MTSb8IoGtzc5PtVwrGfkkpZ08mm+uHigCbovNDM/1Xe?=
 =?us-ascii?Q?iNG+J+faMhaBVapN4zAGZI2A003lLtfmzYTLW/KOXyL7dWEnKiJHQwtDI7bH?=
 =?us-ascii?Q?3JaXmHU5o9WT8AuttYnY/eUUatOgWmAIJS6+bVMUHU6dnXws8OLl9EgJLAOb?=
 =?us-ascii?Q?+HhSNoeoXRNAnVnbSrT0Pc71MxVHp6ED4KH7KdlpVQk/ORNvOMNEwRjUTg2E?=
 =?us-ascii?Q?uBrLQ6zcOcFKhzZzkccY487MGjMDvPTW7xdgVndv1AlQ1wauds/PsIBYdBUg?=
 =?us-ascii?Q?7Husc8jW7k/Z7H1XeYs3HZD+0AU+mrF5CII8eTe3Mb9q2bIgvKFRJMELvlSp?=
 =?us-ascii?Q?4nrQumI45Weah6pYIqe8BA2+y2rmq+2R9CBDAXerp7eJ4N/GBDhK4Vcgjf4Z?=
 =?us-ascii?Q?mFJ/sythyZ+pnyfO0kpLJhVJOprlhKugEBJ6EnDXGlZ1eyYvGZUHMvaJX+ft?=
 =?us-ascii?Q?KN4iXCaB5gScl2qVtatehgt+z1tHfgex+I7+huAhfcC0iSVFuhrpQA8pwljn?=
 =?us-ascii?Q?O+1YKBQgiL+4lnrWQFn89TWralzcJg/9RHv3gLXEDkm6HfOpPR0zeWziKwy7?=
 =?us-ascii?Q?4K48P0X3oTbcp9TBhEyEqfmdP/umSqffn32ZQrYSlVW2qBfKtAw/8j9a8DE4?=
 =?us-ascii?Q?8b0RZF/ARy/KN7WTCPnXI8M097ebdLTBUR6HDPhC7iayEV01xsjbaYanXFpV?=
 =?us-ascii?Q?nD1smeckbMX214KmN6/+vPllyEyuo7Nsu0n7sjTQtc5o3C+dRMADcEAw5geH?=
 =?us-ascii?Q?u2eLpM2ZaW0RksHoFLZugERl6ZiiC1mFhFMXq9xKVt4SFbCPr3RiUDojkDkE?=
 =?us-ascii?Q?UoXNpbhKgIPdgV+1VWlNxCKCDGpEYsbdTkNpD74GziygpkUCPs7vKrHmC+1P?=
 =?us-ascii?Q?xtIQzA1svMnX02R5mrkQ7vYj1JbqIX+Ydmndp0dRaqSnIqLOY4ZzPJHOIt+K?=
 =?us-ascii?Q?v+XSdJPkXCQMyVh1gmhcPy/FeO9rZWU0LLN0OXQ49X6NZdCOTxAiBzSVXkJm?=
 =?us-ascii?Q?l742vhQg5OaNT+A4eADeFhYf6GaYQUAWTBwpYky/XhQs3iB7UHC4FhYdYfcR?=
 =?us-ascii?Q?U8OxS6aLNIo+2o6V5QnvdvtkKxl2NqSfPHQOGJsvdCokpoKEgHheYwJOvf8A?=
 =?us-ascii?Q?C/uEfqJf7nXg7/Qwjn9brgBxAg4JAfufh27JqRy+uVxuc+rV28T+vw0kHCiW?=
 =?us-ascii?Q?GKhLFskkO606yWv+BT2I/ARTVk0vMdcJRNaWK2lfBZlHxjxXX2o9HgyktX/T?=
 =?us-ascii?Q?eXZefivBVfoqNfJmOTI/O0EAthhTfNaYEtqD97dyb+fLIpbt4XEhg/mdaO2N?=
 =?us-ascii?Q?Jei8h6pSqovACqgys/CWA0do?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e93a6d-3a86-42d7-63fa-08d9889b8377
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 07:32:56.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uS9l95qnquLM424VNUxQuj0IYxkxhqdWhL/+z97XmGqFlWZ22xt7f0FM+YtTIbigd3axBoDMSlOvk3cFFLK/PsuX5Spp8h3oefgcrXQ+vJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4546
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060046
X-Proofpoint-GUID: Ya7FnCs9WeynzkpNcGeqlnc9tseybnDq
X-Proofpoint-ORIG-GUID: Ya7FnCs9WeynzkpNcGeqlnc9tseybnDq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This variable is just a temporary variable, used to do an endian
conversion.  The problem is that the last byte is not initialized.
After the conversion is completely done, the last byte is discarded so
it doesn't cause a problem.  But static checkers and the KMSan runtime
checker can detect the uninitialized read and will complain about it.

Fixes: 5036f0a0ecd3 ("[SCSI] csiostor: Fix sparse warnings.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index dc98f51f466f..d5ac93897023 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -619,7 +619,7 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	struct fc_els_csp *csp;
 	struct fc_els_cssp *clsp;
 	enum fw_retval retval;
-	__be32 nport_id;
+	__be32 nport_id = 0;
 
 	retval = FW_CMD_RETVAL_G(ntohl(rsp->alloc_to_len16));
 	if (retval != FW_SUCCESS) {
-- 
2.20.1

