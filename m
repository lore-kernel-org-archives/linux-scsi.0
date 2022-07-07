Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01189C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbiGGVeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiGGVe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:34:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8549564E6;
        Thu,  7 Jul 2022 14:34:25 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCSdr026373;
        Thu, 7 Jul 2022 21:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L4nYstiWQIG0neLKLHOC3fIuQANZE5/juqotHQZVJ2Q=;
 b=bpdwoqKEV7TN25qmgmbz8Z7Gz4D0/+byp+XR5lWCxqMxRmp6pa4UTYrLGucQYFI7JA9v
 6ZJ2yixiSbQUsUx7nzchmNpPb+CU7jqqfwGlPAPrHk8YLs2wTp9DC+R5/dCgxNo5dSTi
 04lqVMjsikHdxrtvg6zGpuryc6d4i24VQyHtpjGmXRhzqBDUDkO4+dqhAPZjIT/6zCeQ
 tOpQPiC8NSOoWT/BLH6A4exYRajNDQXX7Pc2b+VI8TrSMvoWQVjlqoWvuubD/2PUuYcP
 G6FvsZdVm4vbVmKwi+7qchGz+Asm0SsDO92Ix0R2vGlGu76TqAMwPYjtc2A5ADqwtYh3 FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypfm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:34:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LBK3p009063;
        Thu, 7 Jul 2022 21:34:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud66s1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBD3DSz+FDWIh4m8kGVDWsInkmuE5BJhaEeFqVtVAJUroszSOPPupoA75xGxNAISG6mTLD2t33pKibbrmZTrcW3W5TTVMjJTxni1Zkv/1W2Ie8izLaPCOXG0I1fq3pV8ALJg68RAz3q7oBq0FdTq1SCQDO+J23MnZeikcuHiyWq8yXke2zWQUUCIQTjvSCNPniEqBKAdpzDwo/W4RgtdOOjmR7hKcDI0+zH1TY2xWje+Z1ma12HK+6E8g9kgQNsOziOhV70d5mVB2fisl+9Oropd5p3NRhpBIchcfCWTRq1qYx2OmBaU/haXRJd1G4WhXo/PGs/U8THyb+Zj7FRf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4nYstiWQIG0neLKLHOC3fIuQANZE5/juqotHQZVJ2Q=;
 b=OVU8GMlVmtQ36RWtBhvHpSeCuhYS1O3pOVGQbX+Gs42aE1gZlDnTIld4NvQsKEGrmA82XwEBbjHkEjQfFPquC5zOi/xR62kfy0uAX15b4tHIbWolJZys48YP2nkGW8ioV3imM52l/ItIK8WCUlhAHLmY1clnDDnqfncY4dMG6SZwPEPBmFoWpV0lTdddOesj804HHqgqeYz9VV0n5cmVX9NwqnsX/vElGjJbs7LH9FiHO/xcHVMxZKTsL1RQeZyWlvG6JQ8UPnE4aKcKA36ow8HCIFiLY4ii/7RB1i0nHyiW+1jSV4yuFvDhRSIWQFO6/sejy7YvF16u7P3u6WDC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4nYstiWQIG0neLKLHOC3fIuQANZE5/juqotHQZVJ2Q=;
 b=xnAlVKIHZbVITqS7zHNlKHOBzoQroif4YDFNrftohOOq5XoQK3vgJkRvcJPCZmwFd1eCXEv9QhGsoRzZ5h8voNj74FKG14bjeBZgZIV88NFu2IFEtJQUSacYQtJmHLyBU79Kz7WAcpgJXw8CxoQJq4tsizv6PeAKkqJNRnMbua8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4831.namprd10.prod.outlook.com (2603:10b6:5:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 21:34:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:34:17 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Jiang Jian" <jiangjian@cdjrlc.com>, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/2] zfcp changes for v5.20
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11quw620k.fsf@ca-mkp.ca.oracle.com>
References: <cover.1657122360.git.bblock@linux.ibm.com>
Date:   Thu, 07 Jul 2022 17:34:11 -0400
In-Reply-To: <cover.1657122360.git.bblock@linux.ibm.com> (Benjamin Block's
        message of "Wed, 6 Jul 2022 17:59:38 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0099.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0e9e0b1-d766-4ba6-3e46-08da606071cb
X-MS-TrafficTypeDiagnostic: DS7PR10MB4831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVPZRC3/bgcX/oIhb3khBrWPwP+Qq6bKkfK6fL8uilky1ADvSjVZaQ2VRtBOg+wVMkx28NzgElW17uIusJAGHUW53r5nHUDYGlq1OHGsuqQ/n10kNXHbcOE3ySydzlIQC0RExd4PL6Zmu/xCK8ZxB+16ISxykzq5Tt7vZ+LzEfYqM2AswsIxWb9eiOKvh7tCLxQNyagX/UrJRCbPuIgOBErfwfe+MZr3C9DTWjZJzsopZLmQnWGxxOx0Z+WeNDMM2REanOVhx2BFLo022CcIseeClVs18L0ULeJkbx4SG0B+iX2tzV3T8/ZrcqvTQ6I1Kho1maf9KSqUFwCIZ/QxbZluE15kN9byGDlHqYBc/ofGT0+ZF/IBeezLRB/xW8kp65Sw8c8zwZHkfZ9BdcyOTeGaQ2h4dx+HkUY3QEbpvpXKIx/W05lO1ZgPghUh3wHaBQn1+GzCvkLzhBwShiAANTd3oFw9uj8GOXTm1t2w8O+038WcwtAmJAvysYFM8k7LtbtY9YxLTqTo+K0ivQW7I5mROlcvE6w220YmWhbFGoCpoOucURwv3MCy9rM15nfd8u+ZAkMDwXf1F9AOL2lKgC8SIJ43hCnQUhntE9S/9V3VqHjRO7ihkYgRNMDBLjfSNLdzyP3/di/CB/02dgZeuPeLJn5y5X+sOBX0VUdEDBZlKixKBJi42DFfZ5t/vRYCPlIBEO0+5yEWbd9kz4iX4AYQzsiW2xROZ4eBGppHr41V9C4nplY6j5468K6IyIqaPjuaKjRi5fLM77x3wGXNuIH3Y5jiXOA7ForWfYRup9vtQIplPURqho4CJsCjsyuq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(376002)(396003)(66556008)(2906002)(38100700002)(66476007)(54906003)(66946007)(6916009)(86362001)(38350700002)(316002)(7416002)(8936002)(8676002)(4326008)(4744005)(52116002)(6512007)(6486002)(26005)(5660300002)(83380400001)(41300700001)(6506007)(478600001)(36916002)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iix2DmjROwdeTUeC4nDPPLtbBeFrNWcgpOkJWnx+zkgReJYs0eUra3ZmCExq?=
 =?us-ascii?Q?BzWtKciwhf8KpP/xFrpEEWctJNAF4kqjVCPYzzFlbBUMH2cf13woXkA41h4t?=
 =?us-ascii?Q?g4STgDs44d8TB2XnW1skGEA5HupKIrnWKjue8IoW87BvBZt8qEFvEpcgHot6?=
 =?us-ascii?Q?YMlRI6Aw9WZ77noGj0HapbQJXt9wBaVsHeMQyh/VGqkdPJTNMKfr7wOQ2TsQ?=
 =?us-ascii?Q?HrWhTQOsmBtX9nGK1/IwdGzLQCvJ0HLgPEj5JO2cxSFAOR7Ut2S4y0Fq+Pqr?=
 =?us-ascii?Q?tQDl8ssbmIllr49LBDQa2a7NXWXG17kT8C43HtaOTBiSc3VmwaWTH/7XRFu6?=
 =?us-ascii?Q?14UitS6Fcp5QNndhzsMyhbTShFAByUX4O3gktEvj4UB1pHEXuHqW7Gd3uaPo?=
 =?us-ascii?Q?1UWSOjP9H+eFLYmfb/zMn057tkYK/N/4daAyx5kRWNJFK/JhUfgZ4ckzBBWz?=
 =?us-ascii?Q?xFiApkdX76tbMJO50I6WoHVeCViw+2akPQYlnaCuOwbr6sD+StCn6lbE8s1k?=
 =?us-ascii?Q?l9xXeNZMzaj9GmTctQ0rjmNUbfOJor2ig7rt6oEnZeCYOnILIZfxc2U3K1Ce?=
 =?us-ascii?Q?9G2NL/6J9mxfaBRS+gFFUOPSn2tYAJ2x3KQfzoMs37cG2OJhv543tpmATRss?=
 =?us-ascii?Q?7GmB96jcKPc2qRQbNNlt9hB36gwja50wexFw5s7+zgYIK+32y1gS4n5iRQa5?=
 =?us-ascii?Q?pKrEoC9JeyKkE3eNIyyIRYzixyBOsv2HFz9kwCnDrHc03X52l1+jR7kTvRbt?=
 =?us-ascii?Q?+DFrTRQNBwY6ksYxO91wBr+9GpUWVvpjFJpxNX41Sz2KbXsHDPdgofFwNcqJ?=
 =?us-ascii?Q?dBExbh+eTpzijqf7c+VUcV/DOgLdly+wkyQ0cEnG65NgDLedoUTzqcWviBPn?=
 =?us-ascii?Q?3VQ2xtYNcB2uQvYatf9cQRPW5BXK8X10xBHXZjUbLeieghtM2nAWSZTDKfCe?=
 =?us-ascii?Q?lhNsL5TodOoTsucyfuKsqAve3ftbhvdxRZsexcSjoOr/trS+CMWCMVBN/MuW?=
 =?us-ascii?Q?UJMa1vUFjhRgUEusFy8e1alk2OdLCXKhNZsvaj9grKtw67rV1aNd+Nva01gx?=
 =?us-ascii?Q?0jP4uMzU3qkzOxSZNK4GPV8W+SKRfgLJEGIh4zCdoVdrw0g6ehNZA8vkDqaF?=
 =?us-ascii?Q?SLIkFt2OTEQo2dpJlwoM32AW7Ey9mLGABBNceUQpCCftuPOQe752LIHOjRrH?=
 =?us-ascii?Q?3yih3vkzt6Q2Vxfl2q3UWleCo6D3YoMpAs/JWef8CZOc/i3BfDt429sGoO/L?=
 =?us-ascii?Q?sxUzryBLRWNS6ZH33fIzG1hCOfw/3l6LknQ5X2JEW0tKM58bFMLdfNxM5g4t?=
 =?us-ascii?Q?exwrbicXdOp6zM5M//DWMWk9kg58z9LFOFgZpWucnOKjKYpWwUGwzVApBQ8Y?=
 =?us-ascii?Q?fhWeqmDcphswq0xM4QqHJ//LnPcveiQ+Wl9zAIUOUZ6iJl93EojnzjsjGeAg?=
 =?us-ascii?Q?R7Lpt1pM8Nb0AGZSCG53DxJXYeykQBQvnQfdk0Z2RJGqJJLGN5SksRPfr6ew?=
 =?us-ascii?Q?h7YFcsVecTNT+WnI0pTOtIwl7eUz2jZLq6a8CPwKBp/31JJQz7Hst2AhDlYr?=
 =?us-ascii?Q?ffZfSXqCmdtHPr2NtceBnaZtEc9fFLujtn2k04zbLdcNIMyOs1fElxXGoRqI?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e9e0b1-d766-4ba6-3e46-08da606071cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:34:17.2992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAJUuSnQ0vA3AGwjfqGOX9z+WmUGp7DM5IlENDPAks1SUFUq5DlhoyPXsxnuxy/DI4S0EglxxVZRVDNZwzqjQMNDDMR7LNCoD5gWLexzrpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4831
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=588 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070084
X-Proofpoint-GUID: 7w8weB-8HtslCDJLbDwVlkPLcWhnowfZ
X-Proofpoint-ORIG-GUID: 7w8weB-8HtslCDJLbDwVlkPLcWhnowfZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> here is a (very) small set of changes for the zFCP device driver. The
> change from Jiang Jian came in recently, and Julian's patch has been
> laying around for quite a while now, so I didn't want to let them
> linger any longer in anticipation of any bigger change that might
> come.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
