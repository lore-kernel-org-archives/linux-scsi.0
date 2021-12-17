Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6EAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 03:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhLQD6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 22:58:07 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4102 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhLQD6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 22:58:06 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2NXXh012919;
        Fri, 17 Dec 2021 03:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6xLSh2yiR2sWwz0b2VjQlBq6CetJsTL8JN0WpFvgOw4=;
 b=mFTSdzgbM/GXfjtHz5O5DaeYJPkRonXt37oa0J4NAyEtR3PWjagPEe6u4KuccEWR9/cR
 8/LqMpAqWEbPGhaUDWUnmBS/CLiZ2IPMR7fysz2EEH6t+OG6H9eAS9O54zV9UDMqths1
 h1TZgnNRfpq+PqQTz/K3B0+uLdMBjLCIuW7VbaMriGGJkZdTa0TcHGOIfVquRExjYWAy
 2XOzlIM4pTVMJ2bj2Sd80CvXUQ9+97ePC3cXkIPxSkHhtxNaQFzUF1ro56EtTCyLeGlk
 ppfso6l6/qc4okQTx6lYB4RQN6L9hbcOKfm/1jBzs56CBJCDrENB7QlB5UKT8KUBasNx Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknrmkxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 03:58:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH3oDGl156282;
        Fri, 17 Dec 2021 03:58:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3cyjuawv7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 03:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFU/NXxqAiRbp9w+6+7dCG9JSmmFTlEGObiSYQEyZCWu7dfLK0MgNdrGZq94EcBSZvkL01/NFGujRIaq4P8F3W+oESHNWsDHL7An5HreffR7gkHzQT7oeX/fG+VsP/jz06lKdeH+lanDCA2NdzVDy9YF2GywF4njFrsL5cFU5lVDdjg0lKfFgXhNrDLmKC/CJ41yLUXCIZJadfjL853syQpVsvb0zodBIR9gsseDZOGzsbPNRPlDL5hKqTAXOLafQwgyak0eBhMIduhoEy/DHVSCIqyB4xyP7xKr2a0mPxH9Y9yKFJcgY6qDWqk3DTvW5bYrUu02jixZmF0K1FIdRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xLSh2yiR2sWwz0b2VjQlBq6CetJsTL8JN0WpFvgOw4=;
 b=m01e22D0d/uGxT1rjE7Q2bgEb7TVUeqDHn6C+mGugNneLK7/PBSKCvuIVMYzql/PX5tBrM6AbHsV89UOxYhV6i1ikBdQqd2/n6/0VjapmGXWWey6WXc2bG9yJHsD9H89346cu2c51CtMenbs89T88GzrIzUAcE0DpZniANF2Nd+UQolbaS9/ixTN67eT0cRwgndBHnD+VJmD8217ye9GxsSpZq8HHE+sdklohoLD1kCjXYARYko5DpsL5TfXWLNDcVBn2iJtDphD5QGjgXGJ/GF0hWnCoUZE84w5z9YWr7Ru7zNOPqDvuJO49Ws8FOuArj5dm6oXhsp+bWATgccMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xLSh2yiR2sWwz0b2VjQlBq6CetJsTL8JN0WpFvgOw4=;
 b=cJN5f5RiX6J5rQnAciBy8SkxbtbEX2n0/GLMiBiMpX6vPbOc+d0E/xcsXxticxzWeC3Owdwq6N8eyMh8A1EpkhGOCMDk4uE32Ta2Wt8xByliEs0NIQmQGuPk9jsIjVIvmbbCMxuJHgfKMohPCkxUwm7ItD+ibpy+Ij3KQM54MEU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5450.namprd10.prod.outlook.com (2603:10b6:510:ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Fri, 17 Dec
 2021 03:58:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 03:58:01 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steve Hagan <steve.hagan@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>
Subject: Re: [mpi3mr] RE: [PATCH 2/7] miscdevice: adding support for
 MPI3MR_MINOR(243)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnk3khqt.fsf@ca-mkp.ca.oracle.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
        <20210921184600.64427-3-kashyap.desai@broadcom.com>
        <yq1h7dw6qsx.fsf@ca-mkp.ca.oracle.com>
        <9e544200d3c6e879ed1f655f0f1ab0db@mail.gmail.com>
        <yq1fssn16rp.fsf@ca-mkp.ca.oracle.com>
        <41d922ea207d661046d4febca5872aae@mail.gmail.com>
        <CAL2rwxrjm-kd3H1f0d3CakQNULgdbhwo2s=Cd1X4d3u+OnGYVA@mail.gmail.com>
Date:   Thu, 16 Dec 2021 22:57:58 -0500
In-Reply-To: <CAL2rwxrjm-kd3H1f0d3CakQNULgdbhwo2s=Cd1X4d3u+OnGYVA@mail.gmail.com>
        (Sumit Saxena's message of "Mon, 13 Dec 2021 17:53:54 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8fd8b68-b29c-4a25-bc9d-08d9c1116b43
X-MS-TrafficTypeDiagnostic: PH0PR10MB5450:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5450256C929DE8B8EA4A96CD8E789@PH0PR10MB5450.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+o+6ftHUXcWFadrwmay6fzDoBF+GdL6cxfcbtk/Z/Arurgfzkzz/l/ApLgZMmbpPg0fyoSi5qWXIFCt1NzmhjwPTKIAneL5ePDdoU5T5zNEcq792ZEu3YPz7uJQyQ/SHcy5PKgmSx7DVfC7ZzwFQv7s5NzbhRes/RZdesO+lHRLOfmMK0/RHRVqVoBGVo4RWiHAU1iRBcAMl9uH8cDUKc5DI2iqVG96tyaltU5tGp+8jptAElzqh47EzjNXGpxyId0EpJwIpgLjHJXn445MZgZsUFa4wfpddQ48Jx2i4n9uaqML0lPatq6L8U+4J200ms46bbdnyb5VUnNaPumDO45THwfxFAyQypHHbgHydalZbo8Be09zTdu4bNAq5hln2z3ZAeJ/rd2RKIo0Mke2IsYorKXHAc+GOKcucp7Jzb4dBR5xUO5AXWqxKUIabsVT4Wah+y8TiddL2AbvuBlfWjqmEGFuQRC6Fs1PMUhW3666uMKKGrP6kJkKmvsL6N5vxeyqBDadtdOPotxrvcUh6Ejletp+sEwDx8RiCtzROosEqBltcDtDmObZuRkYk4e/3U2VyLBLShdi1V4aUXRJ8Z2e9FSKPs8qZqGAzjTuoEVN52HTzDs1d1ce7LmTB7mSvNOurptqbuVxQbU2qc2JMEHtEWxWE6NAlQw0b8wiPNVCsMWzeY6E8S7XPAilx2iVlZCrgsEa5URw//Kuxno0jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(36916002)(4326008)(38100700002)(54906003)(8676002)(316002)(26005)(8936002)(6666004)(6916009)(508600001)(4744005)(86362001)(186003)(5660300002)(66946007)(66476007)(66556008)(2906002)(52116002)(6512007)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RtZwEJ+4pIMVnOhDV5IFiU24fHYz7KPB/CQrnGECJjb7QKsxbyL7p22eOCVf?=
 =?us-ascii?Q?HxsLj7gsXKMAVPgQMkEL4BMnw3ijlpw/zrrWM8sx5jx/EAcW85lFuv2Y7Ziz?=
 =?us-ascii?Q?GjsonRprpB6xXnMHyxV8gyudExFk9RpLc4y3mUs/XUBgia5pDEr1XlFSzd7J?=
 =?us-ascii?Q?bmJ1Jr29WLq3bvyXEYSrhVNjt24Xc1G3fxYbfCTCtBa/IaFuDEXMAscH2FFF?=
 =?us-ascii?Q?7txTBAYStCtOiHAT+njVVkdFKt2jSklaGbezoVqOR3sMeZ+Xj/IwGWTvtonL?=
 =?us-ascii?Q?KTdLzseZ5QJ3n+68ts5ZvmXRzqpbYfA+OZaAh38VuxZb976EmyxZKVwPPWBn?=
 =?us-ascii?Q?AyoBdQi4CojARLukeKTA4rLEynaNtiJDwWj9ujK6qhzU5edOiICLw9mCZCVO?=
 =?us-ascii?Q?60oJCrnbAXIWReZxgEq9jxpuruuR5FK6ZvdXEwZwGGNbQ/JNe48PMbXyTGg7?=
 =?us-ascii?Q?nnS041xw1gbNGoUGuClB9kiyvJFdWLvIioB7bu1qkGKdcpCLT7pUsZjOC+R3?=
 =?us-ascii?Q?g/8PqTsdiHXzmboM4ou2Nk4JXre39R/6ZxjQbvVcQXBZtvipT9AXlvSRn3TM?=
 =?us-ascii?Q?gmYxCeBLK2MetAbsRZS74BTCXFbCk+hqLWcSeYMSmrN58YKWO6jgc1HLefnA?=
 =?us-ascii?Q?tNYb9NfygzsVX9RK+0oEwyMWx2Av2pagnh/qZliojitfcYQVgKn+unZhAhO3?=
 =?us-ascii?Q?R1X3eAN9SZcjp77C2Ju4Mm6j9Y73+l+cT6Vrct1HvM0Hh+a4PNIoscxOOQ/o?=
 =?us-ascii?Q?vZWUvD6xNx6pExfOyYmgRPYR/KvKqbGvMwYlPOr5QYsFf6mlj/3u/i6zGvLX?=
 =?us-ascii?Q?KIusQ+nHJqV2dW4gEkHhVsd1D0mFnxbYjGkH7KlJIE9TVW0LwvsJmdVEe3hN?=
 =?us-ascii?Q?rP3mYhCGZOX6/ps6XnVp6EjE9wEQpf8Tyreo5WIWXr00qTDVG7o18CTs2VQk?=
 =?us-ascii?Q?q0pcJLz/4MAYILdIMjpRXavrZPCCJHnPFoe+Ukj+MhRuyrfUNHZfZ/iLv9pD?=
 =?us-ascii?Q?omUViZgQvOeElflgjqiBfIC1z+CD8UKg5Rz9WmFuk4In5xu2TzRcul6WsPYc?=
 =?us-ascii?Q?qdJ4RLlLXr7c+wRK79/rt0nic+v6v1LnDmIoWiePT9Sxh9TFuz1s1MLlBDKc?=
 =?us-ascii?Q?TteS7DCk1zamunWWMhLQNNmJKaao0y38ifDC2DrLL8AdUIkvJU+Y5ofjj7mW?=
 =?us-ascii?Q?CWVUpwARMt6hPC0CLdZCqnc85H2ngUdjYXJSt4xNqgW4MDctjr7guavVz90s?=
 =?us-ascii?Q?zQtIqAlWiQyfgoWdvz7/onOlz+1gbDxMOtWuSQ44O7NlAd/5tyUqOUhTCp1A?=
 =?us-ascii?Q?YXhWP7DktHXch4dbvFAJkdqi89XbCNa4C6FWyVuCblyk+zxZ4G4ry2+TxHab?=
 =?us-ascii?Q?7ZGRbPugJRT/RIhbCLvUJfX0vYL5bE76kpCERIXIYBqxHYkInLw24VzreFVz?=
 =?us-ascii?Q?blFsDBfrKnCSx8kbHBCgTpm7c1YTQO+JD5qZrujY92e8x85P/nqswDGIxJYy?=
 =?us-ascii?Q?H37MyDntVCeZe6j9IciVWJKvdapkKMEdUpFICVZXl6/Ho+sLLvH984Fvyzay?=
 =?us-ascii?Q?samI6TRd4NFoBtQJnALM4jHew3fRYR6/dqHvNR/luzKumFl1Do2iDnk//2oD?=
 =?us-ascii?Q?/5tzFSdClahuvMqiU6hERh7tGf70G5WRxukpyut26315dC1/RvmcXJCo173K?=
 =?us-ascii?Q?pSxc7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fd8b68-b29c-4a25-bc9d-08d9c1116b43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 03:58:00.9404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEU3kXDt1T0wQgD7SeDsIGQw2r/iyTdnLGXhjZYNvvzbKMoNxMWzAM/STbl6yj6hXNWe+2/bfuQhmg0FWNmnkrqYNU3KW7ZO+btbr1TK5SI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5450
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170019
X-Proofpoint-ORIG-GUID: a7QXl7ing2To9_m9M9BKy_qbiGPeqNns
X-Proofpoint-GUID: a7QXl7ing2To9_m9M9BKy_qbiGPeqNns
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> We have a requirement wherein the userland application/daemon
> waits/listens for asynchronous driver/firmware events.  With driver
> IOCTLs, we were using the "fasync" interface for this. How can we
> achieve the same with bsg interface ?

Going forward I suspect io_uring is going to be the preferred interface
for async I/O. But for now can't you just wait for events in a separate
thread?

-- 
Martin K. Petersen	Oracle Linux Engineering
