Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869C9C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjGKVrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjGKVrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31731718
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDHOE018447;
        Tue, 11 Jul 2023 21:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=vP/T17ynun4gnAWJrgXRRUHLwegVzHhPtNFL2/Tazns=;
 b=cUHVL7UjkzceWwKYzjQAZbMaIXE992D8XGiTZ8G13diykaoYsoN7NPfuAqONnwZNVnds
 9Q3oHBzPxInZ2Z3WNFNavNFRK9CUYtL7Z440YxItT3f26y93DHeiEOuCSVcOI5iMiG8B
 ynEgJtlv7Iy3q3S8pccdvS9I/6Jhf0Nv6anMJVdO0sHc2aCWhLXuSLddECr9n2FcsvXr
 C7Ku4x4JgSJaWN/bntj+MJ+VOK+hx6dpHtyl/FDu+8/0y+3tcmHDI/0ZZlEJmhXwmo6h
 xPmLbw8R1v9jjM18/8PJufs0gUvbASq7L1GFV5txv29Vl/f+uEarI4jkl9h5NT/khDX4 PQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydtwxyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK1ae0000502;
        Tue, 11 Jul 2023 21:46:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29shak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/WTJr/Q+OmVVTWVvXw6TU4csuwn7lI/86UCpmgNmC/IhEcHmbA1WSmlYyG+zpUBRtuveKy2S4ScyYtta3HARXbAdz6NcXoZNJQyUMQw057HZuLVfkpSMYv44RF5Rx9emD1xC7NebXMSsVcs2J9iXaVhuUKi3nMR6h2rJpq8KpR2jTWYVWeZyIe04qq2pqcQrjXjq+ZyuFkS0gSgf8JjqeXYBi8Zb7GzlS6jkf+3wNAu6ZDD1bEX578t84dLTHffev98aqZDt4NI/BacXdmnkdV/o3kEGHQMKl6UdSGdLx+uGOoU4fQZobQPhKnwEw2dYqWwVqYLpOas6KCs2kW0lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vP/T17ynun4gnAWJrgXRRUHLwegVzHhPtNFL2/Tazns=;
 b=l0q02iHJxULfwTMS4vQTSoFIWCEWIwyIcBHJ79tdL2vW5dm81v/T6aNWlZeQs3yHYvuOgEykwK7BmLuLHJ5v8UUwfGhAPayUObHuCYMFDYAarlA9v1ldh3t5OYPY56tRO0QfQGavazItGmTbfh+5sBb4xZOB7XZy6Ai4QfKBzMVXpfl5um6bSdIVf0mu0sHwkfssRt4+DEEXGeXmS+rg4loSaItzHsEHd1xZSe3wG45VgnLVFw/YNkg1k35vCoapGD1CoDet/ED1pKJfyzU/gdLRXX+p+VGlde88iyKF6/NfNP4S1VbeWhMCbIfh36DylRZykUcKtKQSj0L8qzP2SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vP/T17ynun4gnAWJrgXRRUHLwegVzHhPtNFL2/Tazns=;
 b=kbYJM8NuVl3MUyG+ntV18i+n6I1hHsES3boCvLKtlbbeweL7KdpCIFTZjKeRJTaf80XFPAE8bAPp0bsN+exL4cBUMhO/8hfGOnaE4ZHb8v7nf4FmJjw09rUdJ47522uOwi4voXHCXMD2V/zUUlYJBnnDRkMXJqiI5qD/Ntlu5m4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 14/33] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Tue, 11 Jul 2023 16:46:01 -0500
Message-Id: <20230711214620.87232-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::6) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cba81ec-6812-43ec-3982-08db8258573c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVr/SUglTMxxKFp5nxxDlofu1nljZJdwWRKd0rLaHj4zCyYVJ7jMYekNJutv43CWez81NQyRZGYn5sTOsGCdBC4J0M6I/X6MXz/jVtxZwB+Qpuz7nQoEerUlMYr0iP6P8ObX2DRBFJcHU58JstrH6hWLJZih3jnt3R2yzQTA/tz9Y3o0Yuo+ZHIIMMlTrZF9UIjrx/aKloeQRAp4SIivIbOpVvjtw7AGfxpQFo8omwLgJBuU466kGqLIj5QlurDiKk4pOA7UayutI8WSbWw8oGTaNi4UQKgCUQNMgSsalV0tBYGxAVdjY4BKYFgcT2f1goKea0G54UQCY9C+JakiP+GLoEgQhXov8f4CV6ZHWAM51g4K3ex3mtMVh+zW18yVUtEXYqYp0C5Gsb1sAy+LHahIfUsnqRflUnWjQFl1xAkwPbknvLg5q8rgQOBjLQfy4T45gDNiQrz+t1jJdQliTwOUpUosg1DN9TJitVfvu4noACKe8+PD+fBXRGUKbOPEuN1SClkOj7D7RCWUdxTswikqjDV6mboh5RdpMKJofOIv7WUNBKSe5M50dZJULEcS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9RN9NZEeuzfg+/AoVA/VeYIjVk5t4EVX/ql/haUeDJOru+Sa8xkRJxlDsva?=
 =?us-ascii?Q?8WekfXniv7z/EP6al4yAnBjE5aI9zeYpOUy5NW/jKswlx86Jm1dmvw0IlKjR?=
 =?us-ascii?Q?im1+b4nrgke3csIdnSZ/IpXE1pEhMnN0fPoSHmpdyL+0NhBMR9lKH+6kfyzx?=
 =?us-ascii?Q?NpDeB/d3q3YnmyDf8fq1bhvfd0yQtv8ur1t8v+FRRJAjYXzL/3E9U/IIYzgj?=
 =?us-ascii?Q?BI61048E8FmwH0cVvV0Iu1qqmzPmJejp0znMsZkgIqQHTCOlSwiwJcQfVIwR?=
 =?us-ascii?Q?l46z3KNCHrjjMy1UJR8xmckO4YcCZeVBy6dGVCa8EVpZdXPQwpPbJCj2oujr?=
 =?us-ascii?Q?5ifLgh37l31QjCD5g3mL8lUVaQPJ5Om4q0kUG/B45lAHkUF7SLylPsGlwNR9?=
 =?us-ascii?Q?g2inXmG4e+Wt3biRCyhjwZQbEW55JOYyVoBldQpHgC/GeH/OITLF5yLCjWgK?=
 =?us-ascii?Q?HeE32NuTqY3wIlOo0rm29GfCQKuFDMcU2Ic82TPi6Y2mCnm8Hl7b/pgP6B39?=
 =?us-ascii?Q?PRcRh7OUb4bBKkpLzmWUhW5i4Q/rcL2AHMwBW4c3EBugbW0ITQC6XzDoPcUx?=
 =?us-ascii?Q?ODfMVe5xeFyRPIHd14c2at7CyJYP9YM98wDxHevEfz+GNf9Tz074DGGTUuK8?=
 =?us-ascii?Q?Gb2iHCgo1RX1SjrubYNuKcvqOTzexwxZsLoFX2kMx+YDsQnQgElw9aFN1uNE?=
 =?us-ascii?Q?PXrVRUZzpLoVSskUOBz1enCp0wZYk6b+cMMMbn4OuGrFkbyexHGzewTprijX?=
 =?us-ascii?Q?EHJJWNIR805U948TfKGdYbqK2gtexB+jRv5WPwwIlxG9cSXF3K3/asppMANU?=
 =?us-ascii?Q?NSbEd0Hno7BI33FhiSx9+bL8+K1W81F4TRpMqI1MJeWXPd8qaLBrdZ1g09xt?=
 =?us-ascii?Q?1xRkeGGxv/zUC7NmIiu2ztiDJLcLTW1sVo/xIO/e4iq9FmH7RT1DNpkAdL/A?=
 =?us-ascii?Q?yy0DC7kF85N4XhWn2Ce/dvuzTDwStaysnOA4Zrr5PTiAlYJYZWp3BI+6VlM/?=
 =?us-ascii?Q?6CQLeoj1Y6b3rzcLkCSZ4YHwEa+8n2jzRkofjgQqon1A7NKKf0JAxNKZWC84?=
 =?us-ascii?Q?3dYiwRG3Rj42qYjD6vS7XZ0sF749bCdr9K5q8EFaCF1fn2Y0VOZTvV0Y4COS?=
 =?us-ascii?Q?DK9LP8Ufsms8udAj/r3t6ZIMu7S6JUqs1SetHX6XREJQhIRI183k0t9w8+RO?=
 =?us-ascii?Q?J9zEPIHe7rfxxzJdOaFnfq4gDcBaTMU7ctNx0fJmbFyEtmUmU5cBXsGPFx1t?=
 =?us-ascii?Q?iRB3zpSfqM2sPACSORHmzv6dNSpte7mn1Ghx5HGkvB6bDxFs2jOLueuluIl6?=
 =?us-ascii?Q?4Z9BJRXtNGCfJ7ItWP3XaXpsCIs9CNh+yDEoFmAYiBbEk8OS9pmU6rxpeDoH?=
 =?us-ascii?Q?auEpfdM+RDS/8pzgTyh3kvtijN31CwMO1vPiJbhLBkog7n5A+wBqfJjzKVk9?=
 =?us-ascii?Q?JxPw246psZ8w6jeEVWmLYVOcsRpOmTwPC8oH6/6YhNSVKFy/mKTIywaIlW3U?=
 =?us-ascii?Q?F5suwa82msaXMnc+UJCsMzm4B8YKmCP16ESsh3QQlaoJEaU2C12ID+0IK/ci?=
 =?us-ascii?Q?9sOAE6h/Rx8OmiRDAeGXaTRvjw0TH2wi1eeDb097E49AQJJhLHbfUvzlBe+z?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yFuQf/3XV2MyGheZD6Bwu6p7R68no5rvyy6y7eSTS7YSSAQ3GwVEtNfkXy14q1C/xN9+IfJfmwGjs7t1xhmcFdEFpR8F+e9lqMQod+ieybGNvyy1T7LuQOAxya19f/iiQM9m/01b8OTVW6pDGqNz+FAwRZvc0o5xJIQg3OQOCcKdPK9qIIOdrqr+NkB1TBfjk4WYp1rD5MsFsq53rYV6XpaD+lRcQclSSDdnpTvw1zYeKDKzDjOCu94jN/CsyxtPDrvl8SCbMpO/gi1RoGcBXUJfqid0jqLY9oBRrCvUHSdVaVExxeTsKNXvTSLrMXi2FrdvKUvKM/f1mYv6IY6KP1omNxDcSLQsWHOXcYIHQdkR2MA9WBTy4Re5MMKUmAWS8HiEAXfOHn/WdQkF8sGRCNoP5Z2FTrsNkn2JSYuRZIVDwmusUo57ckLfDcx5g4jBolS0xkQa/CPBFg2klewpBjczHXBlandJ/mMbUW7FCdbf4UxR9odLTrnPHLl1IE0jThYq0TN1znN1Ey1kIy8MldQ/odWr7zbWfJVmaysfMldJJxkjhGxwF87rHgC1eV1CH1PxQGZqlwhpvQP8s86xgCSe/zZ0xK6IWXrO9BvJDaM1AJfm2yBWxuSsae4Q/j4uzUVFhIhjYAUYNVu1ZGaikKdDNeOVX7FUhzrhcDHR/lDcfyDw8+uCF4vTnRXG3YQrfsRQ04jl5eBdtZqnGApTuZzPfVwgFbTXBIrKlFCgxveN4tWZI7IhfL9OKZtYyvykK0DaBWlNyw+trsKYFGacdSOxihRgLj0sKWkWG4dATDzyIvryJQcVY72AY3D7uFv1iZnjdzNc9RdjryBub7DzfmwX/fym3dkGEPcQz0G0Ri5vGWQf7/xwmrL5dr8UALWb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cba81ec-6812-43ec-3982-08db8258573c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:53.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1mcSFQhpj37PId+BhEG6Xcxs0nBcR6Bm3gBM1kSFlNHhhsIuCPy8yZQSsIK34mhrH/0VBhZ1O0N6AtGB7cXRTCZjHyHCHRmIDEw7P5f9hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: -UW6D3pkJN8MVGYn5h40XsIl_0aWu3cu
X-Proofpoint-ORIG-GUID: -UW6D3pkJN8MVGYn5h40XsIl_0aWu3cu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

There is one behavior change with this patch. We used to get a total of
5 retries for errors mode_select_handle_sense returned SCSI_DH_RETRY. We
now get 5 retries for each failure.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 92 ++++++++++++----------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index cdefaa9f614e..9811f9788432 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,52 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int rc;
 
@@ -549,27 +567,19 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, MODE_SELECT command",
+		 (char *)h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
-	if (rc < 0) {
+	if (rc < 0)
 		err = SCSI_DH_IO;
-	} else if (rc > 0) {
+	else if (rc > 0)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
 
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
-- 
2.34.1

