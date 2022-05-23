Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CE4C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 08:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiEWI2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 04:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiEWI2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 04:28:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA332BC3C;
        Mon, 23 May 2022 01:28:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N4ixkd015229;
        Mon, 23 May 2022 08:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=l4J1jwnU7tC64Z8pxAt8VyDn+LjSkeHDje8DisTUYxc=;
 b=w1sl1HyKT31s6ANxt4hk3MIzlS7I27a3e1ihC0lDcT8xfZ9bG9y0d7SgIusVXWthQ98h
 hetoCeKeqC3Ym9tYZciI3Yuu08p+mWuasUdF1fDvLv6FPN31ELF6n0IyHk9z6k6plYt5
 9GDWJZjs6T9AhUVi7BWZ9rB4KRcyrOAngDu6FfI12VTev6CA7ETFHDMdlEewxrjyo7Zh
 1UPVOiiXdIkqXmtKQqDnJSAoRQNLexUmBspTdEl6cVTh0W2D5YbHsRueg/SqU9cbPpla
 vGUbiZIU1mPyFfcPeUAT166GweE7KmtPK1dYx79jOI5wIOul+jx+NkertPPXhT+Dhkl5 hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmttje0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 08:28:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N8AT4R035466;
        Mon, 23 May 2022 08:28:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1dbwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 08:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilxNZwd6B3h72fLZRYx77lpFUSpGXG5BIyxXDp1gL9uj3AzMSEWD8mrkhvHezGdP0lkUtScaGr5VhZ5VfLrZbgyT7INh/ul17a0TZFwtIpFTAd7M6KSpHHZFdVDi8oevq1CFwwuuxFfTsHIv2Gh/jn1bZTPOetYU2mU+lTO0rBcCCYpPq4UqNnLy1Lvme1a721IQPgNnTgNmff8ToViIpJHLHqehWN/y56XH3P8quqKgOi+ZFq4Z/XF+BZB1dxC+C9EOX24QGxy01QJiZyg1eZrBeCVqAbnSpna2pcBoPrGgIEm/bHhmjGfItIuJim4/inTo/DLtDGs5+CL2WuWIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4J1jwnU7tC64Z8pxAt8VyDn+LjSkeHDje8DisTUYxc=;
 b=Ss31VW27j9eekujH4bvhgAiyNLZYf0pM4K6bspp1Ha8XSBGJbx0yXA6k0WJLu7vAWSFWiy1Ukcjv9/SHshi+Q0QYQhKtX+MQ/3Skx9+0AxFO0SC5heOfdFlpCPQ/4z6or95dPMVrHjaV6axBGew4iw8+inrEyhiJMtK63IztTTpc6Wt67Mv0YCpBKbgXd3V93BqED1yvr/m0BAngVWxKpf3QG3brOsJB4mzSQbS+ZVcPf/urux4f+zwID8sdiU+TQY6QyD8YSZcXXm6M/dkhdfWEuTbGqEbluKR53j7jsUm2haxWzMcfTQwBnSarTcSLN3qKHbi3qY6nDxQgBSCIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4J1jwnU7tC64Z8pxAt8VyDn+LjSkeHDje8DisTUYxc=;
 b=Xs7kv2xGZsLJEN5GipjDY7QbZ6548/RO2UgO8BSFcwB6qP0aoQXulC16aXRTs88/Q4nBBOAewA1GzBtyc61IW33Y7VJcBISxSubfAM3fjvAci4UbI9fq4qrYpWTwsynL+RYVSfE6WVf3eRx4PZfeZolfxBblLQshDJ2A4thd5x0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3819.namprd10.prod.outlook.com
 (2603:10b6:5:1d4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Mon, 23 May
 2022 08:28:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 08:28:29 +0000
Date:   Mon, 23 May 2022 11:28:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshcd: delete unnecessary NULL check
Message-ID: <YotFotj43TkB8Rid@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8451dc7f-1d65-4399-4993-08da3c9636cf
X-MS-TrafficTypeDiagnostic: DM6PR10MB3819:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB381950787779E65F91AEFF758ED49@DM6PR10MB3819.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QK+EZuSk7WemIKgTf8efQlGMuTtGoykEFUq2iVFMS9c60CJBGb+hkYM3Nv8vjqSyMGfWds71BR9l1jOpnVcCuvbVHUZ70xbpnevBt0ZhCYbLjEkom9Y6VkEUCLMfkWjwEqH4tLC+F0pbuW3wX1mh7OQ8aWi4FVMCuryhPYzI8t60Os9+5zQsKGE3Oa2DrsO/FirASqeDYQCgcPagKF1vSURwRGGrHIL7/0csiOlKA/nxuvgWIuisKmtjQMJeJBgLAEAJmAqR+NFYFdP3Il4KDXecdNaQllBa6sCti/S66A+Oie7jNnyMvbrFSZ1OhH8ysBiLJ3KpD7hDqxvF1VVYVewEDpYwAnF/SpVFi7oR3dQV/HbEqs13mypr5Z1cA2qPuMp0VMBR+NORuvWLC/WkGGrXMa9QCzXCVbP43WYNwCyu9cd98QggHSPqvc/hL2W8jBuR963/uegs9eK6PPS4o7ty2kMfsM9zpexl6e3arrbE8SEnSRNJppYJgUzfQ4cEvJdB+hH7omB/pkXF4Ry+dfaYQfilM5Br4Ypevkmsh5MrEG/Agh8FsUlnQ9/2kFYcd4hagiFiAVoVU627eMkc4NI6EUfo0peaVbofxlmKEP7sLDuH4fAqxb9uVWEh6CYY2RE3479OPhvkrVxzO9ldJVlz2rQjCiFa4CbzwKnWgYedr/0lWwrXE5d891kHfzQQiYgSqQwUDaNPu7JUOo/aig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(186003)(6666004)(26005)(9686003)(6512007)(316002)(54906003)(6916009)(33716001)(52116002)(8676002)(66946007)(66556008)(66476007)(6506007)(4326008)(86362001)(6486002)(44832011)(4744005)(38350700002)(38100700002)(8936002)(2906002)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3FtzCk+tHXLOeDesIJ0zbVdFR6sbr6xFSkrIsbzLZdI6aGGAXlSlkMyIcQ3v?=
 =?us-ascii?Q?2rBDfsEl9hvA2fYERYrJwRiBvAMTe7EorIR9un3ALto2QIwD1KDSh62d/7UA?=
 =?us-ascii?Q?/Gu8WBUosw7oWaNzZVCXYv9jOZZAu9cofCCFNTxOR5co5+M6AieP/UI+L2Pf?=
 =?us-ascii?Q?sGXRDHSPsyScIl3DT1DiYTjfIzaFaTFAM9C+/Hi5RNP/AvldqChhABLD4Tp+?=
 =?us-ascii?Q?NbB/lleAuWSo0fDkoMokV3gEGYBTKgg4RMjgIC+iH5e0ycdN/ZV++RCIEtA6?=
 =?us-ascii?Q?ob581YQRaK5bA2rpxz+MmPgpppslTX16X+8gCsA7gtkEFNsxlmCDCrWnYDVw?=
 =?us-ascii?Q?sSm+MEytAccHMCjupHYCT2sPXYDmwuYbWVV85gKQl+mf/YOrrIE0qyJEGo72?=
 =?us-ascii?Q?ec3ldyNbCiHDOyfcIyOFZkZEpiMRiDOTtkrLmqFh3FFslG7e53WHHOO3+ZsV?=
 =?us-ascii?Q?Ej9FGtzroj9LzlP1luks3w2Qa2QYX4FbtwJW8Qtub4HDnZR8wklq6GS0WwxO?=
 =?us-ascii?Q?i0mVnsgXtTGMEyH4VucDMYfiLlHZJqTEm/vEaqdGPC28ixqUnk62Y2DNS8EI?=
 =?us-ascii?Q?Hb6yNVeCtuwcXWbDFYqxdVN59shMijXyr9qGe50YpMe2f/yjFiiZV9g/5s3v?=
 =?us-ascii?Q?J1akDqilp9tg4iWIuGQq4F93gSrZrWTAUkZVVTBuwArTrNngGwsU9nfBB1qX?=
 =?us-ascii?Q?wHeTz9zThg+ITy0hAypyvpuNwNK9tnnCHuaVOuG0GRB0kQRiVLdTt58z9Ip1?=
 =?us-ascii?Q?fSGbWN5J/eactk1ulvaXBBE6mVsxadwuYiLYnfndqP8VweTzrVjFwAO6Xr5C?=
 =?us-ascii?Q?AFZ3kWXt+kNpxfOYNs8KwjFk3aRLX/C1nTs0oGSMcyb4NZpSQck+W8km1Nch?=
 =?us-ascii?Q?+D7z+ezeKed03LR8kjCo59lggJ40eczM7OS57/VHc2O1Y1vgN4niuXSEpT8e?=
 =?us-ascii?Q?5QUL7o9i4dQGkLD+DssPhAluQcljuyDBqEq0nab+aVnT5WQNEVA90y+ArWH9?=
 =?us-ascii?Q?q5DBoCeocsf+M150cPKWIBu0ai394Bb2fnFt60jnjuxNBl+EVkFlP7j5WCrf?=
 =?us-ascii?Q?uqNtOTgTZzEdLYIQGmAU3nyA10CAVP4DUc7K4go5QzqrFQA8bC4eLzlXCH1n?=
 =?us-ascii?Q?2rywNFu0oaMyR7WGi6aJx1JmnaNh2LPPNpaOyxQr+pIADj7MKsVze12weoKM?=
 =?us-ascii?Q?r6BjvRDKXBIm29pykGlkJzZbvplF/vuad5uOLJtfiCsW1ZYqki0xvBOdDcAz?=
 =?us-ascii?Q?wpQIOPbCowaizcQ8ZZUztcX5LvMxKgMIuvGOTUfKTZJuhOAigZ/uHvMRs5p2?=
 =?us-ascii?Q?W8de2w5SWHx3Fyzm+/eBCiQ/tqrtzKhbXqv2Q6fjuDcoEgbM/3u7FAyEmkQq?=
 =?us-ascii?Q?be+mAoRr7aMG6/rQqVdUPMspb6+RDBCGWVcgLX1JxwqldEZy7xNW89gL0D0j?=
 =?us-ascii?Q?SzIVLuVSKzSFt4EtyIdWY0KZAAnWnAzCY3xCk/S2cgqlJUHtuxAFdQf2YGwx?=
 =?us-ascii?Q?JkMh28rnoaVKJj7PNZogYPa9pxPrCbZ9H9zLErMxD8aVHCl8eWZ95gU64+Yv?=
 =?us-ascii?Q?aXj7RTLf2PL6NrjkfxhFuoYNYwesriT/N1pRrQQAZRtwOw1SGoFtAqq3pXjk?=
 =?us-ascii?Q?xb1JFp9UKPpnvegLwkF7bMCykuKsAruc2HcCsfFWzLhuZULiM0yt6iwwAwc4?=
 =?us-ascii?Q?jYvUAl4fDZdqW3P1odoV+2jAVDgNmfuZuuQXmmnqZGG3/4n9/Rea8IcCdQ1S?=
 =?us-ascii?Q?12oRNWkF47oSwPYMhvlSzPpih4Jx/Yk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8451dc7f-1d65-4399-4993-08da3c9636cf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 08:28:29.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSeOK8ENda48Sois/LcXgbL8UfarU7PQ3OCKQh+zETAyVtGYOwblUKvOMnxZuMHR35LynCs4pZqGwmysKp4vNvodDF4rTK8ai4cvWaArSx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3819
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_02:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230044
X-Proofpoint-GUID: N5Wkw__cNaMdvDsFET7jaYeTnk3kloTH
X-Proofpoint-ORIG-GUID: N5Wkw__cNaMdvDsFET7jaYeTnk3kloTH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "info" pointer points to somewhere in the middle of the "hba" struct.
It can't possibly be NULL.  Delete the NULL check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index efe67a381c32..01fb4bad86be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8445,10 +8445,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 {
 	struct ufs_vreg_info *info = &hba->vreg_info;
 
-	if (info)
-		return ufshcd_get_vreg(hba->dev, info->vdd_hba);
-
-	return 0;
+	return ufshcd_get_vreg(hba->dev, info->vdd_hba);
 }
 
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
-- 
2.35.1

