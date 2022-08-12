Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1653C25B0F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiHLBAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiHLBAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82106B14E
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5ZSI004328;
        Fri, 12 Aug 2022 01:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pBbr0FAhayQ8SzXJACSfQ/zq8OF/o+w0h7J0NNcJ02w=;
 b=S09zYX1pVtLrUp1TgIBMk8fCMS847nPCdSdsEtl3AYFPqy1A2izjgx/ZAkUqiiWqby0o
 mY4l18KF6CbiT/M6G1jImzAT3I46oxPHk0cdtlzV/Aslj4kkMm5xwu0zLVvzmbzgtVOk
 zeS3ntDHQKOiD/HIfxkq1ONqwOmTCbmlPNfHfQJ5Ks39tu4vYqKP15Gxkmw2rbWgYYEq
 iKj8/e4hu4UAEiua8+B0datpRbrAh/ns2NEu86G/hRn+6rWNwU9Ev9PeVYxL4eYfMuII
 HjY9nD0xWWm7YXZV0RA0lSbycdBqEpEWh/W44pBRHmuq8KdzZ7g3wuM5GvcwhnAfdL8a Jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq96bm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0BuYh023733;
        Fri, 12 Aug 2022 01:00:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhnq3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Htg3iY+4mJgnC/ieKMiy8uFEK5oZHLYi6TJ6Wva91meml21c2gA39BoiNQXqHaQJrVoaU16C1nfwReTqNe9aIB1B1lGh4K9eAPmzjbK4zsEWKAaFWyaAAnGF6AauT+SoCVViSitZSMsgjltMdz5dpIpqBI8ElaFaZMI2UXau1DsCkpwrsWoVhwfeF7pc1qDmr4Of3+IbADB0oarm0NzGzoLH+9Bs0vUlkBTYiue0Lb6bchSQ0V/LN1BRteioHjklyK0pUKWz1P+xy2AiSnHXm27rGWE+VN+h/xZBSwEeUyBz8aVz2uXaKJLhjjlSFgDq3JowdKmIMXG3YHqRJR0rLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBbr0FAhayQ8SzXJACSfQ/zq8OF/o+w0h7J0NNcJ02w=;
 b=BrhrK7T/YfAMRbZWa3hNey2/6cjLqiMWfqvlZT0LmHIsxZCKqBEfQFSp9PLSfI5tfdXjWVY1gGkQWi922ijFIoeezeCBLalZyYKk2VXRoKZq71rt/dcxWl+6udsEqRgF3nuGUza/wq8yHbePcFCECt/NQLB25Gr8nX/wjpF3TJcFcBqsT3aU7ZCeH30NUBBVtwA6tr/oF39Vv0TNipqP8UrJO3THs2ymIyzrqsQmC9LNRlJiIY6LhD2QPhVwtIkfm/E5qnHvXhAWyruIHRywXwA1bzPq6bBPAPGsBrlmTFK/Hw0v67bnj5LwOMl1RFASBrprUjOnvkwOvqv12atB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBbr0FAhayQ8SzXJACSfQ/zq8OF/o+w0h7J0NNcJ02w=;
 b=MI8zvIu4fImGvzugnSremL5IC7bqouTI1mmP5W+jBGZ0GutXPgOUn5Tw+yAb/jQ58eLykkKL8GXha6GOVY4aIPKw8BCR8Z55HuXTZEqZb/8mJP4W5Eu63zBc5i2avFD0CDuLJl8dC4H+DNvErP6fmUmAxXXukkY0av+Wj70+c40=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/10] scsi: storvsc: Drop DID_TARGET_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:19 -0500
Message-Id: <20220812010027.8251-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:610:cc::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95529f2a-3fb4-4c48-16bc-08da7bfe0ea3
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUZzR6auCMT/mcftOLdaFJKd0eRlJV52GJW1Wig90DIJ7BTcuFBvRaybci7LwWRrQ1lbGaF+cYAEZTFAVB1PtYnTRetJKKLDqtT+vQiDaANyn50h9ZtPYOwV/t9qPZni8AhOR+Upj7ACDs1XFACiWIpsCX6kK+y3Lk2ybVaHc4YlSh5CpjZRfqtun1nmBLjEi+2fqCDceBqmU5RclGZCL57wqIV6Q6FE3GzZsU7TcWal1WQy8b8TsLg+ZD967IET03NJkKBY3LxNSOHJCyu7HmAIoPBUG1sGPRQETfd8m4SIFf/P/ZdJM4omo+RgsFOqorS2G0jht5HnT52qPV0XPaXHvjJE+8vdJPxZlSfV6XWjgVAqdssSNWbz4V2m3e3vIgo7MhmVYmb7qFIk5XWCIadcmfG4y7JDoJNCC1sl1PseiX1VRFSCQ5BCTjtdjJCQE08YlVCOXMJs+AnrFPOO+UcICoI+9NESpIJmKjUi8gAwt/UuxjYMGRDm9C+8wIBl6PEVcB15vgqCsxuqd6nkY3CUAt/Yd0rNA9FPNSpnZxTwxsYmvNCYN/5LGd180q57/qznf3J68zYY0Tu5aPcPuv5ICMb4EP+MaB6hMj5CJkxRZX/Z89EcPEeYM9IbfzjZfkyn9qsqM4p9HTqb0eGlLxeXFwtGdykaEMI5QTL20cxVWXyC8PMcUzIxP41XwVhB5fbBe1p0rJ/XodX77w4xBzEW6pl/4vM+nMNqCi0wNAd441BWXcZW5sBP0Qben1PUvY/ht8jwkY+mvcDCLwqHuexPxWvHVNXEiWOcWY9fYMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(4744005)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mQ50CbQ8qzf6/rt0cXfH9ir/fgM4VKzeOjANpYunIUXdjOsesTB3wva/iqCp?=
 =?us-ascii?Q?bslsF06t3KCUxg+PV+0boG3HHUvMiJbe09lCT5v5Jq1PzIaRa5uE5Ha4C8p+?=
 =?us-ascii?Q?kSMmn7j0ftnn+aLvZdg5IUPo1N7/mE3mu5PubZrmgLQAra1nHHC9zCVsQava?=
 =?us-ascii?Q?PMqGA6ktd8bNWNt9mdFaIHMLEPxfpN6JJmI3enUoKM/xI+OdF9g3Pz2y6JLY?=
 =?us-ascii?Q?LxAicWKYfV5bIidgSYE4ePEhbNzM8IsZmBSu0aYvkWYpX1AYHh3pSKO7B9Sx?=
 =?us-ascii?Q?gxeqYqMh6adUoLEoxJWkCFFKmZ9XtQtaR32ZHhWy2KRksg//NfGijo1yDIax?=
 =?us-ascii?Q?YGi4PT8YqAYm9t6PV8fBxlWJZWuuiAG+/nm4jFaTvhRVsu9xdBk/Uzqc4K8F?=
 =?us-ascii?Q?UVgHrFh5xuClwy9o5qGjTwzFrE9oPLmuzn8YNsnukumIxvmAd+W0641fwLz1?=
 =?us-ascii?Q?EmB67Eb/XJ0ypZHO2rg9d+FInwuj234NHnkDvxRX5CBelTATDtdFHozPf7Fz?=
 =?us-ascii?Q?g8bsXkKtXtAP51DsrJ0Y5ib7ZyqpfxANsvugj7V//7cMLoCE4UAgvYDNkSLg?=
 =?us-ascii?Q?FfuyzhEl06B0Q7QaZkURsjFDVOtZ68HhmpBYJZna44ia7RTJGmhL8rHHQ29T?=
 =?us-ascii?Q?y6cyYz71rX3eZ+uQzYqmcYhhouGgrlmh7h8wPbnDwloBJixQgR2W3W+WfBTz?=
 =?us-ascii?Q?Wqt2A3d0RwbljANKjNNdUYf8IsSlhYt1hPCAlHD/8m66vlqg1bgwR7BAzi5m?=
 =?us-ascii?Q?2z9L8J8kNiC4xSIJrnpH3suZCMMV5jc9nNnrbH+NKDaqxuK99Cfkr2alojGs?=
 =?us-ascii?Q?LWJkcUGoEtw2h1yEdkqM0fexLomg7cGcawseXygPqxJ5tVJG8RcZY+Py8q0Q?=
 =?us-ascii?Q?KFB3cCT0QMhhPJHt36njCx5eHjpo6hwCL87szhT9j3aL8DyO1Krl0yCbuEnr?=
 =?us-ascii?Q?ZZxNeMe1zQlHMjPOQQratcLGZGSMZWKuI3srulXIZQoLWDZUB88NaY5wd53L?=
 =?us-ascii?Q?jALoo8pizsjgR/vvvaJimRyB7pwjCsvVyjP4UtjTAyWT3RLUm3cbrUI7j1VJ?=
 =?us-ascii?Q?/14UI8HwS2RSnkAzB6vZP6w4E9wm54IdjSCGwenfZiB+X2tfGJZIq/S/pnA3?=
 =?us-ascii?Q?WNuvZjAdR0Y+9yN/atEHaHCQwjRKXZGk9As8kOe3mcTOMnOOEgYcw5V5XK+Z?=
 =?us-ascii?Q?dwi1Ri5CT7Mj0icAkf3/xNLCuRZJgxAZ6FXkeTV2G6rPJNnzOxwhCP8b3ng6?=
 =?us-ascii?Q?x73LaaKmgRJCyt0P3sGinD8KdsbCI4dRcQKB/JT8Vootd/hl+qNm9Y3yWeHe?=
 =?us-ascii?Q?qZRBZI4cMbDSvmAfStVhDPVpCVS1Tw9fhYawoMu9zYFCOZJ23XqxlcwkzsZt?=
 =?us-ascii?Q?Hui0+70/AVJzH3Q88PHMzTZARG4h9jESZz2pFpuqycoQdDkWvzw44OB+MuK6?=
 =?us-ascii?Q?EHokCJuW1dFB+CBb4VcoAKffoNVWq/AllMYAtg9tlCFxIfZveWo5GGHyVt5X?=
 =?us-ascii?Q?GwsaSjcxqxUa2RNILH3BDXJeINwIkDh+eTbz/7HbM7vbGNXkmFBrU0+IqVFb?=
 =?us-ascii?Q?byEGvVN+gSEUHm8daFjLBdAhFTNBjppYq5k/l9nAIvFqv0tTp0r/sr9svlT1?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95529f2a-3fb4-4c48-16bc-08da7bfe0ea3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:32.4919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hoc8hQ0t9eykHOrgPweAUS8JC6MJ+aQaT3e1U0Pa6EogGrr5UECJ8nAHKEOxnxQ/N7CvvdooB6ch4YfSLIQa5CzPTjkxoRYUPcAE8m2sJTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: VGqCxKFHrR5VqWjKjVoQ1ZczdLcwz8nG
X-Proofpoint-ORIG-GUID: VGqCxKFHrR5VqWjKjVoQ1ZczdLcwz8nG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like the driver wanted a hard failure so this swaps it with
DID_BAD_TARGET.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/storvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fe000da11332..25c44c87c972 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1029,7 +1029,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	 */
 	wrk = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
 	if (!wrk) {
-		set_host_byte(scmnd, DID_TARGET_FAILURE);
+		set_host_byte(scmnd, DID_BAD_TARGET);
 		return;
 	}
 
-- 
2.18.2

