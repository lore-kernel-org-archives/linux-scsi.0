Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592D0ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 11:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIOLLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 07:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIOLLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 07:11:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F8799268;
        Thu, 15 Sep 2022 04:11:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F7c0tP032491;
        Thu, 15 Sep 2022 11:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2022-7-12; bh=SLvQl+miW+0K6x6J/lT1oKPe0vuS0j0/9CmHWRpfLa0=;
 b=g9pxysPh71bTUAPW5/j75C+M7AzS185YMaFJa7kUgH32IE1vkcQintY71UqZNFjIqAcY
 7GVkWxBUQzcSTOwctV2qNVFsH0s8rcUtFKnumB4CmxOUONVYHBv4AANqrGNQWo8umMx+
 K64WXiAtZgBUWVKedXNmTR2NobUwSkS3gny3h2GIPmRu67Ly18LTzTKNqjSZGHX5rRgy
 YtMapVWIUaOeJxkPbq4YzDw6wbGxztvqPtO/skVROJDR3fEHOBMFBFULwuPuvLC/ZCcU
 pKqrpzsonyy+NNAwdwotAto3xm4vTKjHfvGmeld6daWBtE/qcKXxFyN83IZgTK2sljNN Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxyf4s60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 11:11:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28FB6WVq007322;
        Thu, 15 Sep 2022 11:11:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jjy5f9m23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 11:11:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ebm6MxW3s5CHctM+sszPfeB1H5KXY+P9ejtaQ6APnXzNdcFdt1KcLgXdAJwGrg0FASQlPlz46UT2AiV+kXCzdYZbae3Dii3C7M4yaFsMfeNn668v9+vPOZ6vfUAYEt7eKzQmmI4zifnQa44DyK3Vtc2ql1ERk/8LuB7sE+vdHHVqCY6GsxpQwo3ok9lEX9cAu7PVaHL5302CYXpMfTVH5ihRCn+32RgYa/UeZOuz1mO/EV32oaAeBQcmqB9ipvuGGOGEkMTN9xbC2fGMq/rCY510wVq/kDU0tumrMImpPGftN50xRWz1Ww9Nhz0JLuySuPYBi1Cj3yDKIR0dtSq6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLvQl+miW+0K6x6J/lT1oKPe0vuS0j0/9CmHWRpfLa0=;
 b=S1rWoYnlM80sYB12y525YvTiuLbpnaQqtsb7lCFBShoqtMWknDGUkw/iQGO0S0nLJi76cXOptIfWCbOWvvL662exoiCSK9CwxVDtpB6OHRznjgYp966PvFf2YGBuUv5dB12ORW0vYzoJwGCzZm8BHrcOb9JdI1Js5trUeiPERolE88koeEoTbbs45C5dF+BDeXbEvqZtzP1XrK9gQNYjRmnH89/PXWREi1bcws6I7hGjNpw2DJl11zICbaty127RJW3UPtVve7uVeGUBVj5iWZ3PU9MDlVARfN07Cm5TTzrBfg9Wqq7Cf7f3xtHF2qjKWnxprqbMP/fvBXDCgN4kQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLvQl+miW+0K6x6J/lT1oKPe0vuS0j0/9CmHWRpfLa0=;
 b=iIC/wIvuwMXttPJ0rhUhCEZNhcQHrxkyWXwpdK1er2rVPRrrTMCZzVDXOvzvE7vLDZIpBWkkYdQJUzoVAx7ciI25CFcdrdV9ElgTEmW1vTSGxIYQdyuaCWNV4WTMloM+Q/aZyDCCw3ZfAqpo639PS6gFLEHJNGFIk7OcfDoZmF4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS0PR10MB6173.namprd10.prod.outlook.com
 (2603:10b6:8:c3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 11:11:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 11:11:12 +0000
Date:   Thu, 15 Sep 2022 14:11:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] scsi: mpi3mr: Fix error code in
 mpi3mr_transport_smp_handler()
Message-ID: <YyMISJzVDARpVwrr@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyMIJh1HU2Qz9+Rs@kili>
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR2P278CA0033.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:47::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DS0PR10MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 441c2ba7-9476-4886-6629-08da970affb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rldKHLuI1OR1ivP5JTab5iUCwPqk3rXRnQWsRYvGr6c7SqShpGFcdxsb2hhbCwIUODxBAf342KZh1fg9H5qMLsPxXch6/uLeCtFdpjiHk6SV9rUUFmosa2VnfpySsbHMtKyqBMPFOMBX0A16rgOJN1lDa4fBXdq8SxjEsy4bP0Hg+4YKtyFP8Rpu/FSybOXWXnRRJ2N6dN/iJm39ISbUXOwbYXxxltgYimdOLW24fLWz71/3jtC0rpdi8SBUbh2VZ9QnylOmyFhxsgIxLDHeqbPhfVIQC5T9z4ZB6viTolhqjovnMio531rYaF83yQyhbBVoqNwIrkkdSoIVhXjjfyDoOUjpWKFh74a4+QKCnZ+dQliUK5T1MOZYBSDySo242PHG2YlW3dDrkyI9XcnyHxbjtHA71rjLFAV23GT9cnotczpVtB+WGI8cVLK2STs7fAVng4XNizjN5qXz4GDKcS5+Y7HXz9nYG20j0GKILAzcfcV06qj3fqhV6h+xqSLF61Vz7p0jlnCUG/HY5QsAaWW3/S4F0/gYyfTQi7Hdo7RIZpLuS6W/SrJgqGy8ELHcHLUMfQp8CwEOhTOOpivwZu1mduQy2+SqJ+XgwJUe8fQdGJ2IlnInHv0jha4SHGMaJj992iIUsYgKKwW3naK/ak3+7J8XAvXk0YHwranQVhxGrqGpun9MXntT9+eGCkPms2xO6Pzo0ySsF1e2VuXcVDN5XBDsAnPi2c3ce+DM6VtXannvgk4ppYn3eybe6Cvb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199015)(186003)(6666004)(6486002)(478600001)(9686003)(4326008)(66476007)(2906002)(41300700001)(6506007)(33716001)(66556008)(8676002)(5660300002)(110136005)(26005)(66946007)(8936002)(44832011)(83380400001)(6512007)(86362001)(38100700002)(316002)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2X2tghKMt1Ts3d04V2LgDNgCSXuELKuLeD0zn6NOuPwg5LtA7Qu6TKXRgvyW?=
 =?us-ascii?Q?EdJD9BOJMsXS7tj6jeLJozGvRpwkwi8NpuAbGmG5GbMK7E9Ea4DQTKXrrxu3?=
 =?us-ascii?Q?cKJG6oy/8yJFJ24UO01BcIlSFtIi7SWcKYl3E5zPeQHAiaYjnyPq8MhVl3k+?=
 =?us-ascii?Q?gMndtnpwMFYwEhQa5WAMq5FORC2HlYImgYMZ8Mm2geROWx770xUOwZ8ua+UY?=
 =?us-ascii?Q?AmKoNbH63ikgdLiLq7Gzpu2UXBsOro4SKkTWW0q7X3EIqvWbIZcj1/L0HwTD?=
 =?us-ascii?Q?q2Qe39h73ysNzylsTF7qxhFzaFxGdeqKSI2tyEKbJas6bmAD6Xq93WwzLsLD?=
 =?us-ascii?Q?rKroPzzKErb+FYwLb39/OiGOR+SljwDWBkGNtXkQtcVfguVCzSl1Ilo1h96k?=
 =?us-ascii?Q?h+VlRPzTQb7midRxhmNnhyUtfY4uWMR8iFQQGihJgPe9XQuMniVhjUSqI3Vb?=
 =?us-ascii?Q?O7yGo9ODQ6jRai5101C1fybRqMn6Ys+cRRZPhwtai+1kzpolCkBjHjZ65XrY?=
 =?us-ascii?Q?TGbrIhgytuaUkRFkUIWiHvnNFH46si30Snp1SZDGRQbHfx2hpy6XMo0ZTEYF?=
 =?us-ascii?Q?5chG0ef8j3IEI9Ck4Co38JgXjk5GAIH/h5nGyijObb3BsVTgtt9lKFYq3rXO?=
 =?us-ascii?Q?x/qBPcpKF9eEGGKEmL2mECMzV1LTrS/8KmfyADhFjQEqfEahrzslwUv7/Ov1?=
 =?us-ascii?Q?3W3RUQcTnARjCWmsy2TjBkH++FEeswDpCI85OnHFphOv42tU7U3a1OiUWcfH?=
 =?us-ascii?Q?YtZFcYCKPX3hIt7N5vmp9kg5R+ix4eyV6YnvHrRFvJWB0EPcrcExmCKAsyrf?=
 =?us-ascii?Q?YoHtb8xPA/Tko++PpW3272QLcLQWuEanTHYMrmj8hr2mlb7oVVc8wglzfPZm?=
 =?us-ascii?Q?MU7Lu9og79P2yPckpRH5TR0Nx4fXalBmjCPjjmSRJP5AIVC5jgVpJyXUu1/Y?=
 =?us-ascii?Q?qsObLcKLDtkmwKoVMGo0FUtA68HfSL545F9LiSA4buW01k8vUaEktx1iE2Ln?=
 =?us-ascii?Q?DtsxX0ExYOcDuIxY3I7A1RoYGuGjfYM7EgY4gnHZR/UiYdEiUm/n08nTaoRz?=
 =?us-ascii?Q?DseXyWyijozEuJDs9A4qjOiQKv6K/CVLGpDkmH9VkB+U4633qd7IM7L54F6m?=
 =?us-ascii?Q?0VzKHoX3wih8AfJltf3kSOlBDTSKO6x6sVPUjKM5IyiHG8pAHvw3OEO9L0Uc?=
 =?us-ascii?Q?J9r7AZxtk7DUMa62XxWMu//K5bvTpGdMQ+9ogW2C1Hbx2YYcpEDi3lvgdNxT?=
 =?us-ascii?Q?WY2nCs3tbu4YaO5dlnCNQdyOwwu0JfAYtnvH8fNul57mppKMIviGiE+uJioH?=
 =?us-ascii?Q?A6XFOx3J8cKub9fijJiurPu4lTppKWur6D4wcWpMX8XPsKWG0ivuJJJcP7vt?=
 =?us-ascii?Q?f6hG9/FZOF0ZmT3M730ihX54ZUQ/zlD0IVaE+O1nsqC6tEXIXMvdWALdKKW+?=
 =?us-ascii?Q?V/g1xo8OH8iI/isQD2Sak+h11yF1bRSmc9EQhkg8rMgU+fj2N3v9016pDmle?=
 =?us-ascii?Q?sX4JZnOw2KLESvbH76M2NPk8oFtc2S5OY2ySVJ6lv1fi18KyBsIZBWTwk6b4?=
 =?us-ascii?Q?fBbnMztr40aahVB+dKwvFJg6zLhdOmqRMFfNbPWMv+J6B+HWp1QlEvROkQTQ?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441c2ba7-9476-4886-6629-08da970affb7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 11:11:12.4679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBLcUhAzXV2VZQUoXWLSQxgdi+cxOn2N3nXsYTFINgqVv6mv/L7n+tifDUJLDtoaJmyAyKlAFyM9GHhohp36G/xrbRu6Clk/QBew/vZhNo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150062
X-Proofpoint-GUID: Lv5JJ_5MS4qGF2VSC0kOr8ccHFIsjKK_
X-Proofpoint-ORIG-GUID: Lv5JJ_5MS4qGF2VSC0kOr8ccHFIsjKK_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error code from mpi3mr_post_transport_req() is supposed to be
passed to bsg_job_done(job, rc, reslen), but it isn't.

Fixes: 176d4aa69c6e ("scsi: mpi3mr: Support SAS transport class callbacks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 74313cf68ad3..3fc897336b5e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -3245,8 +3245,10 @@ mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 	dprint_transport_info(mrioc, "sending SMP request\n");
 
-	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
-	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+	rc = mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+				       &mpi_reply, reply_sz,
+				       MPI3MR_INTADMCMD_TIMEOUT, &ioc_status);
+	if (rc)
 		goto unmap_in;
 
 	dprint_transport_info(mrioc,
-- 
2.35.1

