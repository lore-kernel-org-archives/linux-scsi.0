Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C59AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7628C613A9
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbhI2DRr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:17:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39750 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230022AbhI2DRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:17:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T28TNb027581;
        Wed, 29 Sep 2021 03:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=TUk8MVLZC0LkLi4ZsRtohCorDFM+/+ZARVwjPHF/GCE=;
 b=02Dhrq2ERnthJF2d/BTBHnqYyuYImjoT7lTfSTRT+PBIZHYh9ZC1mlW4qaaFxCN+8pzc
 FA4afHjjih0BJDKEY18XGxN1tVstbAe6LWPMFnmcci1s7+CF5B0zahqu/gUyL5IgnnDi
 Cxt4qsCHRVFjn/eLu9vLzU5v3Xy5CM/Io/c9zfySWa1wRPrLie5tqXjZhWSRL1UUAX+2
 wpNkFV3LKFleOTcyEUbQeXE0soXwtrQj6FrLiF2JA2iWvBv08D4eRhzwAcym+HqSbPDy
 sKjX1X7MeHV4gXw+ZLkbMh/UEq6esX+PDFDY/pV16UDglOH3eTZUfzo+Z5YMv4v5/51e hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvc495g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:16:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3EwBn016829;
        Wed, 29 Sep 2021 03:16:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3bc4k8mu0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnC4PEQKSvcJMPjO6lZ+Ch8omTDpyDlEn6TkW0WyYnwR+TPgGVRvucAqZA92TFKi7+rd13kjfd0AAHqhSb9pj6VNFUbKcB3ZyTfY0gZM4PmgyzdjjrzPeg1RE3zEtinRLHXKD8kx/5qbL57bKNYGQKscUmVft2i6+JD0iuKM6uOB5p2gopitoJT84jE8LFOcTYNbJnK4MPyG29ZYGhmYKCbO3UUQSFR6n89WVPkWSip50ATZJlzF+HwgpfanD/lfCoanE4yJvoW0uGdBLISsN6LUi0mmQ3qiturQO/ZbNL8q4IklRyGCBO5mXBgEWsdMMTGLyayY/4TXYXKbLkyUCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TUk8MVLZC0LkLi4ZsRtohCorDFM+/+ZARVwjPHF/GCE=;
 b=GYfw7CuZVKeZld25cIIn7Ne2jIBV4Z9NjLTDAfcefXoYHqbKCA/RTW2zXcpW2r0sjxi0MaXyVWz1n92Xw84P0Q3fCps2GH8JL8u2cGSHD15lj90t4za/VfbfxT3TQlNO6MK1WNa/mu7iSTvQlgYZpuVQkXx88JeEAcut+3e42m5DSgvoluNFkYASvrsdazpyW1fLwi8Zcs4ntUkKfYSND2i+ieKxvlsHWvZcJYA09rqzfaYiiCs+6hfurH58on/tdX3ODGaVBI3CCdQxzkPC6sqUAnAm2A+PmtSJtV4M+WtG/pixNFhgMBRLYLe4pKF5pc2bunUPhYrljVcujn3JUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUk8MVLZC0LkLi4ZsRtohCorDFM+/+ZARVwjPHF/GCE=;
 b=GvKvInCWuISrKmavLSfmJWroPYhYRtTbA/j/PF5CuS1otrxS84v/tXK2UHePY6VxPVlECLSUPRj4zbcYzgjiYSJqLHOsKWW0ETH3V5WxTKSZl6tyiUHkXnQoqRLTUtuj5DQR3HkDc7MTHnkSNdkB4zJZ9/Xry7tzVZFgelJhkDI=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 03:15:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:15:58 +0000
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Michael Reed <mdr@sgi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] scsi: lpfc: Fix a function name in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0j0f4wr.fsf@ca-mkp.ca.oracle.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
        <20210925125324.1760-3-caihuoqing@baidu.com>
Date:   Tue, 28 Sep 2021 23:15:56 -0400
In-Reply-To: <20210925125324.1760-3-caihuoqing@baidu.com> (Cai Huoqing's
        message of "Sat, 25 Sep 2021 20:53:23 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:a03:100::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by BYAPR08CA0023.namprd08.prod.outlook.com (2603:10b6:a03:100::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 03:15:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24f9f10f-7f5b-4f92-3884-08d982f7753a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB477340EF67D435668D8B42B68EA99@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7qtJjjOV1kR8QYdNGWYnQKs1j5PTeMKIlfvQXuo20G9tYujc/lwod9afXn3fCqrAK1gm5H4jF+PSQCpiUOwqBpCrhkAO7iiemKQOrxLOCG+Hl7qHpMxUuTYagelW/bLbBTlWPhlySegMiRNmTBkdkaBSTiovjGQblMZkBZ2AMohX7/4mFDqCXHEXoa2MQR5TEVdRHcdy7J/odDpoQQLaPqvImTez5ORWC+dUUtOJ5mMs2Wa6QkRAbKBQjADz6Bee/IEArmAyU3FYDJrVSZ4kcnOX3jc+KECOuRJFQIsG7e9ts6SkWBQ1r71rveuuEFTacr890HKhRoq1uuQBWTF2sb7jaClMoQ3rIcffpii/UhH2Dh7nlXXyDuq3qI+PahMmHlOACLrvo7bsr5PJO7F/1XyG5WnvkCYmmEwG7afUAHmgubpYdi/YRMKkGZH3DGh8p7amWPX3cKBYJkmcdLYPy26nqI8JxN52kwvpy8spy1xMP0FdPe/59YOvp33MHPEz6G++NUIOnn2JIE5ZAXBty19FSoUnsnJSyGTuEullfIJQ2Tqrn7sLlDL+yR0ThrT/rSSHjHGrKCBbP7eYelIODMtwJ6HmnYbOUasagKOWvxkueFTz2/SMV7PR1xjHhCC1//4mGSytesP+g1VDutXpmz3BxC8JjXD/FgOexPfxzk6kIRh/oKvmYl9Atl1TZGHnjCOP5rn0M1jOQ+77+/YGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(52116002)(36916002)(956004)(54906003)(5660300002)(186003)(26005)(6916009)(508600001)(8936002)(316002)(66556008)(8676002)(4326008)(66946007)(558084003)(55016002)(66476007)(38100700002)(2906002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMvhrzpqusUMvpWPK8Rc/ACVg5AMy8lzakubYMQ5TEPXeLhDcLKVYqF4wb9q?=
 =?us-ascii?Q?XtKtTYRpvW+YWWmQXZ5yznPH+2SbpYCeV9ykL7mEHiiWm+Pmfcc1P7r1ddsc?=
 =?us-ascii?Q?78iD+BfvyltBoxfw7NlVEvJ/FwTDxb6Jf0ylMqGNgPQqzb2qgKGkvxpjOWEE?=
 =?us-ascii?Q?yS4gi4kkPoPpTbgEKEdvJgJwpJig5KUK+o1hogqZuVqzgwNUuzUH03ai/re1?=
 =?us-ascii?Q?v1p8bhmbrr7fXzy+0IovIWwFRGFnxtbowAerI//QyWnZHM20gmCdpgikJTO5?=
 =?us-ascii?Q?nwX9z17QwA763B8axG86zqeVUgNrtg/nN6N9EWEKyEFZQ1BhuyqCbggp5ae6?=
 =?us-ascii?Q?L8jCBAgAaqBgM0t4yQ+fB0UFelmLGvbaR3dDDxKDQbaDglN0fvqtoXP/paa0?=
 =?us-ascii?Q?8j2/LClwY12zOd025uYOpHlHwE3oSEkOBIAiGp/zLIst6T1AXQ/pt9EgGqz7?=
 =?us-ascii?Q?cySzHz+/E0Y28PAFevLLLkCzvDgqXnLDSyH3hZ4bWc2I8wMPVA2KdudSQsGk?=
 =?us-ascii?Q?L0P6hfALJnVjaaY1wNe+bjhsFeb3AgXdgo2jpaemExZBqQ2F7IUxOV4vFyZV?=
 =?us-ascii?Q?MqrhPEWT9wZlg8aE9r+/2pDvdBWU4jbPQNlhRjgOdw93Q95/5nPFm2pttKYV?=
 =?us-ascii?Q?N18GCsqap7ZxwQQdNMkWYSM5fCg5fE2JmxAHKxXdHGemTJC0CDsGf0RtMt9B?=
 =?us-ascii?Q?ncGORxXyfBSAr88dd8W0IQGvmTvA4eG8V7CNVTIN5EY8kxxI0ika+/6iHHdO?=
 =?us-ascii?Q?GJA0pqx9lOtUBy//c8+YKnFZ3IkmTh9hJBmJL4JrgsUJ7b9VNSsABkzdwIhV?=
 =?us-ascii?Q?cwRcRITBb5nXy0nH/WK06xCrWyqbY6dwN6XY2N4eGpOdo9H2mkz7yM0kLXVm?=
 =?us-ascii?Q?qPL6xUNNFbsHPDP8jZR1EMTwgdQe6CTTd60yGBmvF3SNlbXlqScZHKR1x2n/?=
 =?us-ascii?Q?r5cFPc3xGqFciHhUJr8EifX4pqlaPq1/04pl2lptyv1EdxB+8kCLr6K4d/9S?=
 =?us-ascii?Q?ATaULGv37GbeK0SW0bVxtBUQyo2IPjARSbkyOKPyqwSDA6jphrX0k2jbWUEj?=
 =?us-ascii?Q?IOrFAMC2f+2337Qctz+bcwsT9r3lJGc61uMxmpG+pc7ijIV2lqz457a0zcsd?=
 =?us-ascii?Q?7hfTR9ZMT8jb0tcMfrL9Hr9Dhw+QZ4IR411Yz9tDM0AkVp8FmrJWf1S5CK//?=
 =?us-ascii?Q?mNn4e/J9ody9ocN3f4m45IdxZw4UuBZqQAhKyCg2GmFYSQ7N7mxvF9yT4dEj?=
 =?us-ascii?Q?k5bAojmVP9Gupg7Hx6MN5xoKGWw87XKUisxnFUHULq3FRxfKGBYLj11lwW5F?=
 =?us-ascii?Q?E78+hIqlfhFFbUHiWuwdzF86?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f9f10f-7f5b-4f92-3884-08d982f7753a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:15:58.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4tQZX8wkU+NA0pwQnk2RnT8WysJczz6Dqe6DMGNoCeG/2A6aq2sE9Od1FpLJVMl2GNCRsdeC+LRIMhWuMTEagrf1kojV50IPVCN20Al1W4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=936 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290018
X-Proofpoint-ORIG-GUID: MYKDOUnMX2p1YZfZbIzIOCNuRHGekp5M
X-Proofpoint-GUID: MYKDOUnMX2p1YZfZbIzIOCNuRHGekp5M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Cai,

> Use dma_map_sg() instead of pci_map_sg(),

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
