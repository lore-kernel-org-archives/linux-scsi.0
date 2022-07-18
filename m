Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D970C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 11:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiGRLVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 07:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiGRLVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 07:21:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4BB20BF2;
        Mon, 18 Jul 2022 04:21:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IB417V031994;
        Mon, 18 Jul 2022 11:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=eNeghAUZBYjSYOERhVnkk0hTkDQol4qRHkO+9YlYWIs=;
 b=RgpcCPnFvC29Sw4nXnMIkqvcKv8S7FbAWFcDXHdMnYDEDE0SOJbPwIjHZ1vPStyViJTk
 FzGIfs2tZASE4o+mHOBpi657uyRWsMsuwn9P8Ddau3WNjlPtzpFzfECbrbnuZO5E5lWD
 GOQrs3IqTnHbr/r9L4tw4tNs2/R37GygmrA3xfHMY/B2wtyxA2mLzLYiN3NVmBVf/d3a
 Du2+KCkdLCLoWYZNdfWHDd0bRy4SF8lPUuaunFlU/ukD0nKm7nx6+5XWk71Ca97kxOxf
 4FObKdjf3xbkEGGlNknOHJ+RbOTvQFwG8sgsf/HNX8cexoDnxxZC0zD1BgvDwZiNhFnK eA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs2xh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26I8i11N004192;
        Mon, 18 Jul 2022 11:21:07 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k3qpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3yWKB3bTP6LWFemaU+c4NjHGANInsKNERZLcWeCK1fdUe3J57SrOnYifL8eBAiYLXk34HnBmTwlUrL4b0QzQQ157N9tM0yCzTIaHK3bGDZMNIDWzWJHIjj6Fvxl/9sKxG6DmqEx2nT6vQu9UkjM1Ej90cn2GL2O0zmFX1+qI56eZvVE5Ikpvs4IDu7KvUdWZncqWQNm1LXzhTa/+ow10Hvx6nG4meRTr+/L7cpaKUYwoUq/pUtN0QAIMmFjQ+CP7JWrZSfYKgW81K2lKLKSJQVxEwCeYcnHKjUmHqmTqppXswy9nZRk5rgFdXEv4ZpRRtsovAMXsYS7JdLFuqU0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNeghAUZBYjSYOERhVnkk0hTkDQol4qRHkO+9YlYWIs=;
 b=ammrRVy1EjS/GCzRw7JHraV1bumRyGhACDhatz2qroy+Xb5LJC/sJzSLC3y+EOuasA65CTQ6uiMta1Z6OPqw22/nwgga8Tdx9PiYQ27kGGn1tRQpLt9qijFehCYj53cpUrr0i64Uxqz0wpa/yATHR+dUD0hy8dtFBb5b9LZJdhtAp9G6tlfGxeNzvkQ3Z7OdZPqALczrLhJ96su+MGriR9AVS2oYNAFXb2MlHalkt6beVNE9186SuJAY81QEgcHIS8RAJUhRfqWMtHFaYci6M+wz+Ctc6FelacUdVPgrMbS6q505csFtJfK6YFdzIwIGbuQs9OCsvNV2chtbn40/JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNeghAUZBYjSYOERhVnkk0hTkDQol4qRHkO+9YlYWIs=;
 b=t0ss1ypiudSLCnbc9ywh11oWqFPkaWldbliZThjK6xGpz8XJT/Naimz2a6ggR7KuUPTeAmlceDOUeKnhe3PH/u9RSVwHsOR7bWFkXj3uHNA62oqeQlk+DlGPIYZsbSmFmD4xUuacfjpnnTNfJbPdmz7AeQ2nRCQ7+PGIlmhaR3I=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB5455.namprd10.prod.outlook.com
 (2603:10b6:a03:3b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 11:21:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 11:21:05 +0000
Date:   Mon, 18 Jul 2022 14:20:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: delete a stray tab
Message-ID: <YtVCFshEJNC7ELid@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48ce132a-77e5-4e94-9ba5-08da68af9ad8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zaoRR+qRGaxvqf/AxHuuJXilwOZxhSM5QvhtW8otgrUAoKbhO0KHr8whZB2ecepaFG4J2DC/5kgCtH1f35UFgFsl25d/hc0Bf+q6zBgV5Tkffq98hrYPsx9SgAArWmF8pzGHBCNPhe2xqMetvgP5etblFMHHESJCPiTp+atqed359F+4rKXIeg2qSybJL1cJLfh9n+dfSuXmm2XEjSkijVy6aJ+SUOFCTJR7JQ/UfPqqSjCfBdkohEw2/cD2iRKw2/yeZwYq6eKjDJsk+rKKGVGvdNh6RjBK9zAD/5TndPghdNpcR2e+oNalBe/gnuS8DAD8DE9/Yj92uACVBq42bReMXKrcSr8kGoHBxaFgnUQLeofRPYz7sHVc/5cOufHqoaxZZT/GrzBKSMxhNqVFCORBRiQUHS1kyTlyH6GGHmCzmYyUD7hLIzHWAPrYvgGUmoHnMcHmUkumEtpHKlftW12PfWUYwA61GyKCn8hemDCUZyUZH/gOZYHmduioWd5t2AgZ3ey789n7PGLTO8xe1JPgqt/7kXJg91Kboi3dycK1a/zBxHd5HgFdNYwQuiE6n2xjlpCTJJcH+S0D2bat6kTpHOmIEAgWwvlP2J7OT+VPMa6kxFmzLMZuDxcqSXCC2FNwpahc7EdIQtHp67JZtrYbg+4PQQZZE1/H3MGOzCYp2kqCoruV7P1zBC0EFqDl1vEPX1NOXj529vjW4v2fpr+WhHu77B2fWlxlfIHUXrkPUWAp1tVZtPj3Cj9nRrB7jD0JBzdYbIDwv0j2+nKz+SLq2l6KflYE4Dc8YlfPIncKMmtsg4GksqEcpIh06U/FIMAQ+ReaFTRKsrB86OMHnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(376002)(366004)(396003)(136003)(6512007)(83380400001)(4744005)(9686003)(26005)(44832011)(41300700001)(6666004)(2906002)(52116002)(186003)(6506007)(86362001)(478600001)(6486002)(5660300002)(8936002)(38100700002)(316002)(6916009)(38350700002)(4326008)(8676002)(66476007)(66556008)(33716001)(66946007)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ziCLtRaAzOGTKPt6EhT4Jp7eSZMnEOMHKU3ONCHxtwdIy+K4kUQYfwBqipfP?=
 =?us-ascii?Q?3+XDRi0s0cqynfq+igG2I1SGqaXNRCulZFK2JRZGxrI8coEOCZpBTyQEHt4M?=
 =?us-ascii?Q?gviKNLzlCUwx1U8bI8HrRWuR2OtzcwPFvok5dEPc+y0FJJt/tvNREgO18mTs?=
 =?us-ascii?Q?W5LSxl9/yp81O9DZcehBcIOybCrOCVqTwmm4Uve+qioSMiU+MzNtdwYT/VDE?=
 =?us-ascii?Q?gkfW5fDCR2YDNY4HWnp63CoDNPDJDgLwMZ3J3Ov04uwdoQNvcPodwiRv7tnu?=
 =?us-ascii?Q?dExdBochftWOENgw4j7zvWeogNq0HbyIvfCz7hobEv8a2A3OT+1z2yuydl+q?=
 =?us-ascii?Q?aAAUys8TfePBVV9vxXTR19l0FhyUXArdP4ciUN3bN5lKDHgjJ+xWnIapPuh4?=
 =?us-ascii?Q?Ry+j1YIuFWnKJdrNCr38ME6NL/jPmw8GRCVa2VVRWBm0p7mpN8D5A7+GrLs4?=
 =?us-ascii?Q?O7W4yibhEpP/X8cmOW9Mj2/CThQkeBFtkeh1AWyWOfQpoP38wuyDSrhG88XY?=
 =?us-ascii?Q?nxyrn/dq4k13Lhg04nLmcHpIb2s5lvGMwDhnmFliMhQkaZ8eku7PNTNFgoA5?=
 =?us-ascii?Q?3Ra3cixPZFBHq/tpyFxE6rizGK6Cz1zxAv+Noz+Qa+6gZBTpAVqt/EIuKEri?=
 =?us-ascii?Q?j0bdlamiKy4dtSTE7XrgdJAFr63AgFkKeFGa/Gc1BY89jHNhv2y4VRNqD7AN?=
 =?us-ascii?Q?NkUsoakSzp6tGbxIikEUZAtUVwr9gjEw+BfPjPSAqxXX4xKS581S4ItuSEbL?=
 =?us-ascii?Q?oSD5yQv1kxHCEy91SWfDOx44SfoY6FplpYci8wWD3p40eHRx4vCjpkuDJxHf?=
 =?us-ascii?Q?mnePs7lcT2ZTbuLHQNEEvLFVj1jof3j84anAdWRy6rrbC6/r1SAM6ptAS1WN?=
 =?us-ascii?Q?Q5lvIDLUPMxPqamaFaa1bNjRvcZtGINF7PI3NBJS1PY8qaEww/EbZ3J1HTUY?=
 =?us-ascii?Q?Vsx/c1BK1N5mgcS+SuNHv0GER7yKMlXi8WumIadYs9VGIPVUBgORb45FntA/?=
 =?us-ascii?Q?F3bZoWUlNftPTS8Ve2+tYDKuiNtJIsdwOZOfMcAEHHdG1CP1aPuhFHKDW6W5?=
 =?us-ascii?Q?13Wf7JuwJsYpq0d3eZnQ+4AKnT6wXLVZQbPlMkuL2T/bNkYFlyi9Bd3pfoFd?=
 =?us-ascii?Q?RiOdRL+A7zlpJssXlgc0oZdqKZquMO52+UnmKHQiNhtdd97XnjFayczUDyWR?=
 =?us-ascii?Q?4fOahWeNK6BvFj1mCJ5Yj/R1Mp5ERGgzBFFcv4YqvMniWgIDGcICAxwWmdAR?=
 =?us-ascii?Q?kcO42KCJTmTJr7qoTBJG+2HNFR8+LWq1i81T2T0Ry97sVqhJQol2FvWHdPHK?=
 =?us-ascii?Q?HCF1LQMmpFa9ZWToCLkrOL6IyOsunPkU4jLwj/TgwaNcODxe9eo7uAsShnUg?=
 =?us-ascii?Q?gG+reHaQwUK4d4mYg+YiuYIi8rL3THZbCakKzt52V9Srnp4ATXqoS7kDSTkT?=
 =?us-ascii?Q?bzUu6WVnYjtZinSggBm4i6BYDwCpaeCqtI7k0nYaN49y1vfhr83fxQNeCY+y?=
 =?us-ascii?Q?eecncSXY0XeWpYfCeNoGZQoY6SpaHemCZcP4dy30o5ecLoptVIuuAUoYcDhd?=
 =?us-ascii?Q?nCT0s5hXLKGev0pmmdBQbRKw4ABqZ8XUjrd75ezZ4CADMI6we565i0Kivis0?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ce132a-77e5-4e94-9ba5-08da68af9ad8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 11:21:05.4361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSBtTjjpCIi/cd+7zzKFVSpc4kQ76hQ9RvpL9v3K2oRrFpjLw6F7h1u+jox88WiVtckCgIUubESvI/uJiFPGOFDSKWIfVOklfGwO2oBfPro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_10,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180049
X-Proofpoint-GUID: MgPTa6as_FYQbTna5szf_-t5dguScmSV
X-Proofpoint-ORIG-GUID: MgPTa6as_FYQbTna5szf_-t5dguScmSV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code is intended one more tab than it should be.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6a47f8c77256..cf00df020b1e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4333,7 +4333,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 	op_req_q = &mrioc->req_qinfo[scmd_priv_data->req_q_idx];
-		data_len_blks = scsi_bufflen(scmd) >> 9;
+	data_len_blks = scsi_bufflen(scmd) >> 9;
 	if ((data_len_blks >= mrioc->io_throttle_data_length) &&
 	    stgt_priv_data->io_throttle_enabled) {
 		tracked_io_sz = data_len_blks;
-- 
2.35.1

