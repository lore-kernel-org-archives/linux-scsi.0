Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF05C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 13:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392340AbiEFNVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 09:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbiEFNVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 09:21:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5676353E;
        Fri,  6 May 2022 06:17:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246D7sOP018740;
        Fri, 6 May 2022 13:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=XILoHO4lk5SIn8t9upT221NuQHZDqoruHQs3v4Us0Ck=;
 b=He49dGf/calUUciFGdwn/zDGRPNdz4Xtm4jrTDCuZpFUfXv5yosIMgFZPFinln63k00I
 rhf1J70kzZDVqLXXCJdA78LPkhvM+PblH2rbkq+WfXPV+cHUtBOghK7lxdqYBqRp6B04
 S69FZTG3/wZcKs/ZmGHSj/OSMnPk4werqxAYsG/8B9OnaShIiItpSBUScg5i+pUbRcmQ
 RJ73oblwlwYQMl2mYQczYMSUjjbPl3SvXZGLErRJzFdS5Rf9tIVuj4Odb1DCTBcizcp6
 w3dZeXn5Pq10WpLP5piMx+17ftu7Ibn8yJoY98/sNUeKzNJVCp8Pembr5jS0pcIvSO+i ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnte6w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 13:17:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246D1Rd7018019;
        Fri, 6 May 2022 13:17:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a8awq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 13:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACxrRhi6fGGoWCeVIfAwUwOskHiYpwlbJzc0H/XoM3DGY73/xfj77T5EiO4CJdolm3dy3P+xlTVgllBm3HB8srjdEzJmyZohtJYuVE9mSz9s13NFcB4TWs1YYuUWB8M6s/lbYOY5jcS8zRCZj68/LqmboDbqRV0B0I0W2WwsqPsMkoBvshcRd3dVwvRK0qIOcNojRiO7PlUhLXx27DLKldUGNW1VjLSvteSJh0imydByKNn1rDyjIDNiHKw6ux6gC+wbvR7+ujYatFE4CHKcv9FxGAeG9JdaRLVAFGNw/+d9ewXlGVLEcZqO9GJnB+3DiWLWk6ZnWHcEkOEDK8H12Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XILoHO4lk5SIn8t9upT221NuQHZDqoruHQs3v4Us0Ck=;
 b=noVP5jTywGRaAMlW17pugB+RdmYE1GZk3IIkTJp/RwD/HAdPLGw4im20SGVEb5wL3Ld3U0XLVDcQB3JRxtePwFyPXWsRuD/QqgxwNCvJ+1jz/GLDGhBWY3SCoC11Q43IbbyZOmKqQGb8d4jTFNqK9hIphCNVntHkxKZNgaZVqaThgmng1kOwPx66Zm6HIVCockXd6/4ZZ5+NPtdMpIdBONtK+RDinT9/TeIEul2FtsbA6+oMmaoDoSKNXGCrt+ElqC7cLMgIjdSjnOvRMa6QniDkLoo3/pZayAEPqiWtUpknqT32CsR31xh+CQBTbt24Do1UNgZXGzT6LfxqsH5+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XILoHO4lk5SIn8t9upT221NuQHZDqoruHQs3v4Us0Ck=;
 b=ExcA2PyIyupM4q3acj5NQeP6c1zFwDUK3PH8iOdU/URZJnq4KU8MyybdoC6+/PLBeqdcdau8vdTsB9Q3EfskmJZn8ekPXR0ZQk3rO9k/Z81TzrHfj0tI5KPImDYsux70D+nCsjJt9c4XZ5X17Iv4fstNF0b7ucUIffVbJRo0y54=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB2680.namprd10.prod.outlook.com
 (2603:10b6:a02:ae::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 13:17:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 13:17:47 +0000
Date:   Fri, 6 May 2022 16:17:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix a NULL vs IS_ERR() bug in mpi3mr_bsg_init()
Message-ID: <YnUf7RQl+A3tigWh@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0183faa5-276e-4e21-bb83-08da2f62cfeb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2680:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2680692EC5BAB207474525868EC59@BYAPR10MB2680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8Rtt86cMSc+UJwAB8rvDSTr4qOmm3cgyPQnXLeUojB26ZUMy9E9O4gTGkOhBzovcqWu4LocLi8BYEgF0kFDxEGFNv7ocs/91VzSdfrYCW/Yvd7YfvyQNpIcK7t5XCxyCCAQjicq3uc9WKl9nyINIL6D62uDN0NjfQn7Q4JjYYiSWx/y4H0W1wa9Kz+mGUSlCgWypiKd39CvP2wWPEG2AmVLMZU7vZBzczuFqn2+zrxEbiidu+SipPoXy0jQUx0mcaiuDqeY+3g04frQjP3lczbgyqXAwjNyklJVrbP0/d0LWollCGE3G410twU8DuSjHWldEHapdAWl+KpYI2K04p3IYle6Qrnt8SCKLlEFTe+NM5cGqTCaIlGqn7jUKReVgVSO0HAeUHm7xVZJsgwJlvWSqGFRoF+4Oj3Ct7PG03u3oJnLgmGTYcDYuxmwIsn/haedNGLDBflqkc71v2F0n6xBZv/sM+B4R9bOLHfbfsKNVgvLghQBstxVWBPRhyeq6l9p5nwVA8YLleOFxwEwAWS+t8Okqtb5Sn4u0nKOrPUPSN9bDtJ+JG2wl3qW/H1Npc5vXAckFn2qOrlknEPeQ4zqe+xbrTiVhbvpP/3OCCEY0tQpEbBgr+SeoXYPkcK/5j/8o6+FXEjwxk4Ihtinxe8hJLTObIH0HTWqDkyq3zm0uqYapbX4WPN1OurRDx/C0SQRoxGKdVrqvZx839xqwzpET5xgAmJlhPCCFrWTrZlcplLkc6P3OMEuGAkq3lfA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(110136005)(186003)(5660300002)(4744005)(2906002)(54906003)(83380400001)(8936002)(44832011)(52116002)(86362001)(33716001)(38100700002)(38350700002)(316002)(9686003)(26005)(6512007)(66556008)(6666004)(8676002)(66476007)(4326008)(66946007)(508600001)(6506007)(6486002)(32563001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?30iglIzsLCEBrpvtgFzrvmIM3S3Gw+T45qXbpUj1fI1wtuZRPc9BfW1/uBT0?=
 =?us-ascii?Q?dvtKWrEPrNfwzDGVbEGEmnWD0HpMhxvaxOcIZ+yhuGzmP0u7ZhPA61uOTkCo?=
 =?us-ascii?Q?qaHUE010JJDxeIDY3cI7NQqGpH8yC4YzAwcfNhYsDKI6Dpuch+vIX9F1poSd?=
 =?us-ascii?Q?66EDWQjPho1ixbT7KW/6y6s47O7bFOFh0Io1lCT//5PfWAj4wlYPbdMTOTIK?=
 =?us-ascii?Q?mmvyRAy7bhr2XPQJZeYP5HLGlD60agrR+NCHHwKWYNHFaNMLqc8NrB+UnyfC?=
 =?us-ascii?Q?y7Us97qLWeYLe4uCK2RGStWOoRR3+rghprK9uXnIOHYlRG/W2MTn0oc7MqFe?=
 =?us-ascii?Q?q77Q0AOcXQb1BpGQDgBH19NmestE2iYVrm0mKYR4y3nEii8w8VKFfSk1noZN?=
 =?us-ascii?Q?hqFfrB3AKyrSf3yXLJrHf+uwRigD+V5ajO3QKn4mdcGQB5qTUsNXCAxwJhOu?=
 =?us-ascii?Q?yq7+yRzHVItBI/2kZz58Dh6sD/xiva78tTI7prwBGc1yxS3ylnndElo6VyVt?=
 =?us-ascii?Q?5znfszaNyXiXqHGoxnjmlAsUS/LhW16t1/tvRjyduCBOapzKS3UZ22b+dcCV?=
 =?us-ascii?Q?xLpeQrC9irewtKQ53GsONT6/Vyh8eMnRPv88IDJkrj/qBng3jnPD4JOUjV1o?=
 =?us-ascii?Q?AecikTaRJ1sTeTejAFMR+0Ynl+064+g/dNcLXcPxvMs8IxTiQB7kYOw9MKUT?=
 =?us-ascii?Q?DwS7AilsfMJ1l5wU1wcppxGBwDGMkEs+CT/rfdpUiS9z468dgNJreiNiVVQl?=
 =?us-ascii?Q?9JAkz9DbhCUJhZ9xmtt03H02dKcpeH0VUU5BpkFo/oASONPAQUYWvQtJy94Q?=
 =?us-ascii?Q?UO0+B4zL6vWulikJuNLTPMwSUOKv9YTVXDQvxHDI7OvUiNjVR+H3EZS8ircS?=
 =?us-ascii?Q?E9uSBekGU/OWlgzAH1HQJnG7czVo5mBuOvtl88wi6dS87X/ndMC4zDnQnSdp?=
 =?us-ascii?Q?+1vBQXGVNikpCoa3X5ZqnBqWxCTpq6tUkZ4QEnZrDQQeCCW/IldZeIs7NUpJ?=
 =?us-ascii?Q?2F1wxgDDdAwsTSUgbWTtI+ixg8eQmdrXZOlxw0vVmabu55wC2cI7W82+RQzs?=
 =?us-ascii?Q?n25WX1sdFm4/N/CNtJTJcNFH97BBrKwDtxfnEzMrKEmSaDtTdkRB+5Xsw2EJ?=
 =?us-ascii?Q?wjlaWbiHQn0akFapJjcQ9a6vegvJ4ldMKVLlxb37KuwQHqhW7pCRxsyINRV2?=
 =?us-ascii?Q?AS7YCQzvslGsTvzf6rQzNfTDEL3Ot5iFc2uRhHRqdwnKBB8g3U5uSiC/4e7s?=
 =?us-ascii?Q?uBii8X5JdwKsfVSGDEcIYfTuthGftx/g09RIYTaOeuKVZdEzhtJ+z+wlFZeZ?=
 =?us-ascii?Q?p2u128hCNZ5nOVXDccXNyZYkrL+VqyWJyUiCkgenln+crTAAbNbfcPkgsc7N?=
 =?us-ascii?Q?swMF1J+tnyxrFJZlznGL4inRFOBzqzVVEdALi6AwNr3YykK28NWY5ZUw+QkQ?=
 =?us-ascii?Q?kvcjCBUp9KmM8/ospTZz7tHXvAQ3riAZbH5qvWZKf3qhdXEfp5bnH+fYLxna?=
 =?us-ascii?Q?sjinv2vw6O765s+mdd0H0XFRubHhXulg0SGJkRnOYq6iPLVjsZUWqeFOOS1X?=
 =?us-ascii?Q?PsXMQE+Hucx8HiB6MG0V+VyvOE9EpRb65+HYYXxf2kdaD8T3W5FT3p0eaLnD?=
 =?us-ascii?Q?yuWXI76jGHAvfnzDHUousEcMPa5shdIsAyvvo0PqkhjcMGxypmr9fJN6a4o6?=
 =?us-ascii?Q?SFcIY4VL53tpF5WqdXU/eccbovbw6wNbk3gL0m0+7bWBYtouAY3Tu86Kby9o?=
 =?us-ascii?Q?9gfVyvxHLQ7s2GlxOwWFOLAEoKDQEwU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0183faa5-276e-4e21-bb83-08da2f62cfeb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 13:17:47.2979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLZxa8gaTvSwrshXKw1/RO151gKYNQX6F7KqXU0/F0jrWYmo7QjK7HkrOcIn4u/09PrKtOufeSAlDZADNTPWlV5Q4gA5a6aA3q99DlMaWKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2680
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_04:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060074
X-Proofpoint-ORIG-GUID: 3_HR7GktcD2A9ilXg1FWmmezZQMC-3cx
X-Proofpoint-GUID: 3_HR7GktcD2A9ilXg1FWmmezZQMC-3cx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The bsg_setup_queue() function does not return NULL.  It returns
error pointers.  Fix the check accordingly.

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 73bb7992d5a8..8138a728d1ab 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1540,7 +1540,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 
 	mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
 			mpi3mr_bsg_request, NULL, 0);
-	if (!mrioc->bsg_queue) {
+	if (IS_ERR(mrioc->bsg_queue)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(mrioc->bsg_dev));
 		goto err_setup_queue;
-- 
2.35.1

