Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB6EC25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 02:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbiHLCNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 22:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiHLCNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 22:13:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84972A2605
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 19:13:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6AUL002850;
        Fri, 12 Aug 2022 02:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=5D97NVjcv5ekXtyysbyfBKGh3910psuNTgniefDfsQw=;
 b=WwQceUacdGNRTj42hifKSc2QOZVTwi0t95P8YXXv2hml/XHBx/K+VKbnJfBaXVMxb5im
 nmns1LYYGUQ0wF+B0LGTIJSpM+ojeG02wkBBk8lpd5yV5hXF5ep7F8E7QmnTXV3E6EcI
 MO/Jww3MIGVVUYeRCdcGKPhOH/cc+AOgwET7cf9N1uXVqAKv0/NKx/834xtpj6oLLQvt
 4Q3xAafRUSq9jZ+dBa4IFhXoucSWWbE7cIuubMP3VpgqVYqWofpHZh9C4N+m8Lpou3Vq
 1pRNSTzkwzvZ/R7JnMmhPFdfaOJS7By9qoMRbs+2gCC+DpdpkOmASo6l4/nwsqMPyUjw 9A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdxbbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:13:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BNiQ7g035259;
        Fri, 12 Aug 2022 02:13:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkr0kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:13:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZU7kDfhxt4bUcV9GKkQW0HBrQoRoPBaGprjbHobMkSXvWv9K4u6fF0evfUAPNzZoVWqHCBJ3U0KVM8rLjhCKK7v5Ba3r/vAQiLduHM9ZpvW4+7qhOBQFVs3/2ectbGPlj2xAp6ck2HEklsPDjxJ+naqLkjp04mJGlkeZISnziqLqps1iVOMIDuORGz5Ht/m+iEAi8YxOlb1Sd916ozGI8sUUXhtqfYMEi/oGZoGNHWBaZJH/EUdvQGiyrpWnh0LnED1DOGamoFS7y5LHApTCui52zPcXAcwKvKABJakspkZTGFz43us7ZMlcoXfIKd/mjPBJpt2K1/R6/O/Qa6ff5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5D97NVjcv5ekXtyysbyfBKGh3910psuNTgniefDfsQw=;
 b=GRU/ekF4mqVwJvBARflVPNdZu6mvLtSviYtfXvDEUGzdzGtrvC2DdR/0KWyHCBayuq2TzD45pkEiH2GfB0qle6bTo1XwCh/yLfTf+w31SRhuGP1cxt7+2Gpr05wfQM4c8T16eOwBVkFsnh64u4Q2aqSZA4yMPl/mxogZ9h0NjQFczMBtMH9l59RxEgkUO8wrBKrjUbN1zGpp842f1GENXGy5gm7enFSEtYO9bWVozfOfA3L4r0JuXEUABju3gLvEFB7LU/qzdiU9K11PVv3SGmErLXcV+DxObQR4Wdrivv+aIsbrlx9QO5VRUpfPCDxKtw2ALKxnL/3AxXzrHZWwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D97NVjcv5ekXtyysbyfBKGh3910psuNTgniefDfsQw=;
 b=PjUUaGOvVFnNgYdu+M2aS8DPtIgiC/oqnYWe2QnPEq1g0PRSONUVcDdT2ZqPXb+p76GVbCpAnE5oQIKETW5x3Rmf/qIGCmyRQE6rrX9tOZVi2+/4L196DKwQtytvoB3MlceDJJy/ox/Dmvh1+QevsngFG5Qr/3UoDoNPjiFRJGY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR1001MB2327.namprd10.prod.outlook.com (2603:10b6:910:43::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 12 Aug
 2022 02:13:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 02:13:36 +0000
To:     Guixin Liu <kanie@linux.alibaba.com>
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: fix double kfree
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135e2mcop.fsf@ca-mkp.ca.oracle.com>
References: <1659424729-46502-1-git-send-email-kanie@linux.alibaba.com>
Date:   Thu, 11 Aug 2022 22:13:32 -0400
In-Reply-To: <1659424729-46502-1-git-send-email-kanie@linux.alibaba.com>
        (Guixin Liu's message of "Tue, 2 Aug 2022 15:18:49 +0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3750d15-bafd-43dd-506a-08da7c08436c
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxB7fnjIJxHdARX/jFZY6FfcfgGBsdGRGgQhavbRZwGA3pVZvRllyGkX9SKxemwqRs48xQTMtpcXTmCv5jWogmxq8Nx/k2VgXVo8mgGi2bxcQLn9k2H38xwVfjPssrFxBKnWG3ZX96FWRDa7V4jUOJqb0bzBYs3lK9ofWPyLU5T3EpyzfMB3JBkNY3YZKCv6tQkJgHcl/DNKVp1PLjyqg2kurCn9rt47R29OhXghwnnt0nIsfDPK0pTkmIhtFS4dDcHjGjV8Lb6omMUDULvxx2k9U7gMUsXfye4SMbnpO4pNx1Fxs8QsF+6JRMF18HmLGsMOUsqAuaj9VGIxrNe3t4PRnBe2QxTizH6t1fuKihT0cNVfnxiX2Sy+wcWo0jqI17gF9at+5BkJ4Sec7lEmTE5skkyGV7UoOA2g0Bm3yqmIrxhJOzP/ov+WYyBgO1N/V/QvtlYOM9BYYfbv6uuPpnlUKsqXFd74cdcnM8qFqiUQQjJmE6kffONlk4AjAtkez1uMJvDdg2NQ+cUpV27YbnYRHOGvl6epAkt3lQ7JP9Z5LOd00zll859WqOEHrqS6vIQ6OKwayj6vvhHESNOBHCangkoV8x/RDGHeD5YfiSfxlNkMy8rDkGNO9UF/XKAEB2kAR4fOAhZdILK3sm5FPBffBSxVoH8u2DnLFK5tiH6K1WKP+uQCkrJggwxp85hQ0L2Lb0wh7MwOCXd/Xyz16SxYPnW/RdzB6smJ2bkrE93lRYv3xHDJnYkHsqT1ZRcMWTIPCSFmZUQ33TJYCvNLoIB9IZOwR90XUSBpv3uU7y9jkFiS0Kx13muZnemHQ/17
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(39860400002)(366004)(396003)(41300700001)(86362001)(478600001)(6512007)(6506007)(26005)(6666004)(52116002)(36916002)(558084003)(6486002)(186003)(5660300002)(4326008)(66556008)(66476007)(316002)(66946007)(8676002)(6916009)(38350700002)(38100700002)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hi3SWuxwc7/QnLsQGueGcciMsJUd4d8jRLrmMmhSBbYtGkgI/GjRDv61aD9a?=
 =?us-ascii?Q?v+sHHE6j4EU5AIwXY6jl2vjPb4bth66Bmc3+Tj2VXvo88IApZeSjSDctqxxp?=
 =?us-ascii?Q?+kGgHcgz3GnCRphL1EXxpwluL7MOSyQOHwObtYDjwOiVbFHqxsRy3IIZ+0Sr?=
 =?us-ascii?Q?B2lfsvC42A0KP96175Hz9G6BHJDYxMgmVXwocE4EhDedXSRGFum5/fB18U1j?=
 =?us-ascii?Q?G8unCRl58iKnkI+UdW0GYxUhplkLYkI2G0zIrbYHjjEXE4X4fmm+C792jbvQ?=
 =?us-ascii?Q?K8TwzYwvnWmGPOj5t3aGpYtSjWtNT+UyXn+gGXKu05/rcS5yM13ha1uO1hvq?=
 =?us-ascii?Q?dSFhMBDGYoefSjAtSKy29NEhgAOVqSk20ISEHT0gZS0R05kiuqKYeYGPSOz2?=
 =?us-ascii?Q?Zpo86XPuMMkJSpZl9yku48FOrUuwxkfJhyIf042iy6LTUJZh2F8XAVnTjJUp?=
 =?us-ascii?Q?jpVQzb5Jt33C1RUFjSrrboAb97eZtB7z3gMiBeaNROB1LcdVSWMHYEiAMb5K?=
 =?us-ascii?Q?G24rqvv5UMXzFbSSyEPzoEx5xwulog0ZiRXv7oDbc9XsUrlEBlc/4elUx3YH?=
 =?us-ascii?Q?adgPEv54wh79UVDSOGApnK0XfkPgcBHaI8J7Ey9GdKvkJOZ1NfKg8BSV6qqX?=
 =?us-ascii?Q?VuvaDfykrBXV9QjbkiaRkCZD9eaYbHGZrEcDFA9V/xLIyE5AoIySyr4Ltyaw?=
 =?us-ascii?Q?OK75fZHqCz4xDVPW0AIYGG1F6yK9qaT5zJm6deZHg9ik/mx77bunW4z80jvL?=
 =?us-ascii?Q?zmjGgOErCoNlCCVxxJFcKQTSZBg9GsV0s9UB0OmQ7VltjqkHujYDwYj/tXmI?=
 =?us-ascii?Q?esrHMHyt8JFSNfXaFL3guS2qtp70rbpGH2W/WhnbThJqlfpys/oevjcjcP1Q?=
 =?us-ascii?Q?OHczQ1riR/3hi7VyzMX00T4NinUXtl/RsUcfkF4ix/G1wOPDBi9vJAkHjt9H?=
 =?us-ascii?Q?lRYTyj92+Wnf+w4k7NATyYWtxwaZKqY+wUjRBGeDbmew2nbZrGZNFLhGTh1H?=
 =?us-ascii?Q?hSmCGowlKQzAwc5vko5Ynp5r8GxzHAWrkzLnts4isQQyYoxkaVYVU4t31VAs?=
 =?us-ascii?Q?dD7xsLePliaeQDI6jwcQ8/SC9jgOfsN9R10l8T7+4Xj8CzYzJt+v83gVcSC/?=
 =?us-ascii?Q?5nwrUS64JLGKQxgW2fAEJwrd4oOgW7LItKYNm9gQLfzWLP2hSOsbDXxP/8CD?=
 =?us-ascii?Q?kTvWPRAreQnYdRe7HMKZr6njNoMdeqf8t83CHffeFyKpN/4/Qokjet6VbJm0?=
 =?us-ascii?Q?JZquLdEQ1ytp4N/GPm+mDoFS+wVNzXZ6D6qTBiq9ZGfUblqEc+ZG2o4weLPO?=
 =?us-ascii?Q?NojzX1TxUrHSpatEACNjz0Z+rXVqHGmCPxz4yK2w5uCQOn9DGyQUuu99VGUU?=
 =?us-ascii?Q?nz1SkO19ja6ZOGSPRkwf6HBQmAV12QrKMc9fe1DNZR5LBihZWv5400CFWhmB?=
 =?us-ascii?Q?/f6HM2LuMQ2zs+h9tHMgSe+clkGQagw2NuMRqd2a3Vq4KgJXb4w+cAdVA7Pe?=
 =?us-ascii?Q?oXeHdkwIVLFVwJ5/fzBUlD7e79lvgcQRrfoJwA4isrNEKj4C3wC+VlKK3r10?=
 =?us-ascii?Q?6+VqLVVb0S5oEc2dOK2vU+0th5uhhI1NSs8f9CY7cSP+2Ll6CjBvFSlontZF?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3750d15-bafd-43dd-506a-08da7c08436c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 02:13:36.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAYy5CkfPDcbK2EneByV/ZalatStEL9NNH8iv2cZ+/M2eaG77ngsLJVywgBZ5pVhODXBfOO3T7Rj8Sb3o1IxGQaFghli95i9nqHdpln86k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_02,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=856 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120005
X-Proofpoint-GUID: 1QB8FU1DRPHOclalt1XB4ESNFGf4S50t
X-Proofpoint-ORIG-GUID: 1QB8FU1DRPHOclalt1XB4ESNFGf4S50t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guixin,

> When alloc log_to_span fail, call kfree(instance->ctrl_context) first,
> then jump to megasas_free_ctrl_mem() in megasas_init_fw(), call
> kfree(instance->ctrl_context) second.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
