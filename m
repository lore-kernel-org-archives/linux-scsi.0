Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE12BECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiIAEUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiIAEUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:20:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA410F944
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 21:19:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNnUcQ017482;
        Thu, 1 Sep 2022 04:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=zUlcPlpulzx8HBMfsktnVo50i6ITt++EEe5JfdiXW9c=;
 b=f/Fskn9Ry8iv0X3SOTsNoNTclNc9S/JxDF7iW+DmfL0Vtj1tPoLuW4//GE6jXLM2WnOk
 otV7o4kmn03XW0Cw1zIif6S5kkb5vJQZLMHPMxhk9v+6bQTJKtCeLwxD+W7zp1ciAAVw
 deeKcz+jIEfrDq6P+f87Id09UUxo9WNA2T/V7/9IqlvULj/Fqo/sNOpoi+xH0QJCzrMo
 LWGtK6sjR/y/WopItUTE/CgbRjWQ07T7srUzJvjtj9H1jvRycrEr1cZApYD5key51cBJ
 bgrB0ivIf4DtBMdnyruKjFugIa/nfymaJemWN5Qe74hPP0zYg5IzK6orEVtIIG942Snc hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79v0tx3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:19:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813UY12037739;
        Thu, 1 Sep 2022 04:19:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q5rumt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:19:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv4KjoTIF0zVjEu/JJdpHRiDYobrIYZ07QvBcxY8BMf7mnLtxZprdOGxVUIlH07+R2AOZ7MktvZu4ElmQZGU9qTjSj09CCcPII2mYDAb2PX/sGwZdo9/J3T7naOwZPNJFqunhYzmW7Opsc5IdrV65++l2HrcFYAdYDF8Ku0IsCPVbdN0yOBDC+cFCV/IpmlRSOoq97nIIP9pqOtuhUbevgzfdw235o5JC3yg5Jn84g7BIGIQWzM5ixTAGs1iaiqMXfYOnaCfSkVLVkc4izeXI1yNEkqQm7dBUHqyUrU3kep0sM7ONv6w/t8XFAgC828MXeDcqiHSQTEVnqsPwuFWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUlcPlpulzx8HBMfsktnVo50i6ITt++EEe5JfdiXW9c=;
 b=ZTZ5LalieTFeGVM59PY+3yHvlbF5Ms3k7jLwHPUMs7NjmHfJh4Xit44OFl22BaSlf6FVSImfwDXD2Q0jJQXBDpYGJ0gxHTQlLtVK8V0IZH7VgYl8+3JG+9WFO+12fyJam3p3or7SR4WUiHij64g3dQ5m1U3w0r7CbN3RaYyC3SqcuCCLf9kFPnBrGYmrI+6Q0LX2LGqlG8p3i0FqljdDK2m9MI7xBAX+RtozNvOX0Ixph4JQu4Jpf1NS7RvCH8q7JyKZSTwp5e/O0i+7BuoV+W7eN6eEZ15JcNV3SpAUIXLK6ksrLzfLum4O5nLUw5MDmDswhPxsDF3tI+YhMSsSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUlcPlpulzx8HBMfsktnVo50i6ITt++EEe5JfdiXW9c=;
 b=MKKiXCjcn0L22iwbjzIvxYZ01Jo6tpXzHNPz3Ql0+CIcCgZvcPxKbxK1xCiGmUZ5eghHZBMSOCgaXWiMBVdxCdnnOiyetMAoHQF6G1vp+fEzsghc235JM9SXRwDsCoZMOyAFFKKOPz5nIxhQChe6/sQHcGWIra2sQRyymc/7Czg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6480.namprd10.prod.outlook.com (2603:10b6:510:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Thu, 1 Sep
 2022 04:19:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:19:38 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 0/4] mpt3sas: Few enhancements and fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edwvn2um.fsf@ca-mkp.ca.oracle.com>
References: <20220825075457.16422-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 01 Sep 2022 00:19:36 -0400
In-Reply-To: <20220825075457.16422-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 25 Aug 2022 13:24:53 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:806:21::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 553a55d8-fc14-4654-3c30-08da8bd12f0b
X-MS-TrafficTypeDiagnostic: PH8PR10MB6480:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xq42Fs9iiwnoOm2DixgI66DJ6yImJK6FvRIYyGYHhCWiw9aH6l6fRm5QDTagjG2t3zjg/zs1QaFtUd9Uo2PrV93Zvgj+2dQZTBNJfAOIA3Q8+yMyfL6YItIlyduHp33aiehMuMcwlEvkvH+36pKvlrm+9KrztRCKSxUgqxKxJZCZAqu6acXnYi+rXak6JWCLDfwBQ63vJ5N6xyg3bPEaoxLmv7dxOwtjolE3WwTwN41cmlSn7R1n2V6z8EWCx226SZbaet2wWuElGEDTy0HNpgX9vNJ3vIm6aXY8Qnqc9+qSwzWm4BwVGH/lvjTLKyA1h2EAlCRD7TcEroRHw4tro6SdkCaxV0FGj3K7TA4fhbm5kX56qxnD/O1Y7MbFr6yGNptytiaJtVVYrXED1OTgJhp+hp8T4doD9GIXF4o8DrKm7Phpm5dRiM7yRIQSxHREvx/lXSDsOy7ailmcokYcaMBJUVwphGBCdt8n3OB2hfzuB1gwtmJqYQ+OZvkhy/mLoWVTLgJS3kYuIq5DW70aad0ld92CmS4bmtwuwYOTrI0mMOf8n0EFrMPWIL/kkyEpO49BMeXafKXz+Th3FEaoE8wmJboa3py+rRnaaXWSEfA2GJNqtVx3bB2iHD+VEL3jZy1NVJSBTqqB2Vbt8M6V6IkrogCmTuxj3SizXHsGW23MXzYp1tdsKnNWmzCL11giv+AdKa4YD/EVk3uZxOeZT5FGI3lirRrnyDPN54P9P1cx1L8/aPCVHdBq5QRnalmlMx4tou04Fbxcilki4KMHFivu68WoQneyivqUhRP6dBM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(346002)(39860400002)(366004)(8676002)(66476007)(316002)(66556008)(6916009)(5660300002)(558084003)(2906002)(86362001)(66946007)(8936002)(4326008)(478600001)(41300700001)(52116002)(38350700002)(186003)(107886003)(36916002)(6506007)(6512007)(26005)(6486002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2cMBHTBWZJb/vGrPw3RBZHon4oD71ZzZCqk+Q3XwWSbbMjj6IBXA645sNceD?=
 =?us-ascii?Q?ta1ftE4sGVrB18+zRM43chw+AQOWdTqin0wsjgeb7Jf1EdT6aZZnsxChMgSr?=
 =?us-ascii?Q?RES1DiBdR+LsfbW1qPnIuK55AgaiQuvQC2s12pD+2tJ/91ca+yq1bO4EdJBQ?=
 =?us-ascii?Q?UMJ35ucApAkcaC5DiR/byorvRClCCuRRJVRl59/SddFFd0Y4IFMkXK6Hjbyb?=
 =?us-ascii?Q?8F68JZFJDCPrti65ORZU9OrzRZGSUZuMIE12YNtI8AES26mI2hAGYAAUVpNh?=
 =?us-ascii?Q?QWBPicJ1MZJVMGmHor/bz66p9ydL/3ywabgYgo1A99qzQ7YdbmEc8go2xCNA?=
 =?us-ascii?Q?juuigMDxqiglWNXlN9lj6PS6z8fUuJHmkYG4JK3owZl0CWg+57Byn8/4U9i/?=
 =?us-ascii?Q?TbtPrPvLSe0cVS3XTihUmsW1dSz3yvCWC+2177Tey7J6gvPa8xaf6qd1yZRG?=
 =?us-ascii?Q?6kt5xxFD8Omzn1kTuXN72wff45TuWu6StjoaLBG4WktRB/+OELzvzO5wd6Le?=
 =?us-ascii?Q?yg0bvlY7O7pSATzaUTczh7fWMpI1JCkz9EP+NPYiRqPHmEBLIhIg4U2g5Lsb?=
 =?us-ascii?Q?p3LTVf3e5d2IJDZiSekK0rcQpwWsiM7AbfS167gtAOaPuXuxQwZERJleZjyj?=
 =?us-ascii?Q?KL9Oz7m09/egEBFNYDsZB0sm1cLrgqqWTpiLa2WgEQOWXMASM1nUcH1A0/Am?=
 =?us-ascii?Q?QspqaElt/a5j4L4xAwEsiWqAX3k7AsBr1V4FHA//tSK0bI/hnTdyKnoVxQGt?=
 =?us-ascii?Q?gwPFfdFeCpA/bx3SUHGhPiCjKLRaeDv4f4QMyJPvVnTxXYb+s0DjvdcBRC1x?=
 =?us-ascii?Q?+KIAAJBt6fQuILS8k9f8d4StfdSTXVhTtBtunlfZ7SGIda6qh1Pqkcd/zK7r?=
 =?us-ascii?Q?hNZvQbB1PcBcV5LK6MNX68OH2sOhSlxo300sxvMiv3KGniuC32MrDZ2n5Mqy?=
 =?us-ascii?Q?ny1T87cPkAY08uddV0rHn+RiQ0KBCgbT9EThOk7Im1+iz3aXHW0jFs4O0hN9?=
 =?us-ascii?Q?mhcLPs9v6uJxaPC+VCL1tsNaA/PoecO0KJttVi51rXvbhV0WiRSL+jOix1eC?=
 =?us-ascii?Q?Y/eQT9hXzZ8LuYb/sZNvK9T3awVI6NtW7FFtqkNXwch/tCsFyqem2n7Myvuf?=
 =?us-ascii?Q?k2nNycZiVkD5tuOJUnYxkMjkKk2UDqyOeoY4L3Uc9rPtqVTgzpXXea+mCTk7?=
 =?us-ascii?Q?feJn75HvAdkAsIZyJg+VKjFihJEyZnU2Z9ivwt7RI6BX3lEYSru6748gJ1gl?=
 =?us-ascii?Q?GZyC/nfAOOqSZc2BYaLeCuHfG0KLxaOiLhZu7R6i0/DgqnjmCsby9J3CdC7q?=
 =?us-ascii?Q?dGzln84vSKUntcPKPMNUz4Dgc7nw0aULSPdCRD+tN8n2QPxoe8GVkgKyMsEm?=
 =?us-ascii?Q?24jFNDzen0ho1SpCqMberYaiTcjLombIRMwKGl9+ySnRwCoBv2Hpe7cfCvFV?=
 =?us-ascii?Q?KAVoWRh4KQaq3YygaCOjS6vwwD5qEHA9jKVG78ef6krdORyBze6731TRiR47?=
 =?us-ascii?Q?b7hEbGLZOQ9Z2nxpOt/YtVh8GwIAVIWBuUff1M71t4QS5LkvE7Y9YZMQX7mx?=
 =?us-ascii?Q?Vycl/dSxYlgEA3Ict8Niizm8PRzBxehLyMTqS3VBavpG7IEuw1gYfICbJObG?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553a55d8-fc14-4654-3c30-08da8bd12f0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:19:38.2068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wopQ1qrQr0sO8nsn5Igtq4rLwZrk0tfUL2w9Xpz4MEUGPMvouB8G+9YGFZd4Tur6jO52dPWM/gioyWOtw/a2KXILnEo2lCxeLtliIaePXJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=776 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010020
X-Proofpoint-GUID: d2ftvmxRYn9JE8Pp_9K7mfdzN7PXcG_A
X-Proofpoint-ORIG-GUID: d2ftvmxRYn9JE8Pp_9K7mfdzN7PXcG_A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Few enhancements and fixes of mpt3sas driver.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
