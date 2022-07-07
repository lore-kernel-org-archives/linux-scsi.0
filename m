Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A45C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiGGUsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiGGUso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:48:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA222C640
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 13:48:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCLpe020294;
        Thu, 7 Jul 2022 20:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=sIUDXyVXZ5vMVYY6RxCLAfsg3UHnwdSubujGgjtvBTc=;
 b=EeFuyxcZxgtiffDJsyKk6jL7XK+ugWE2XpovdvQkiVN0SbLUe0ZWrUChE5oNdGBu8/JS
 pJuiB86NegaszztaU35lUMCqTbXoR1NXJ3OYt0uV4grMSxhB0Gb05s3WG4f+sSfFMF7I
 ZNnuMPep3QePETEgAj3ZWsyTXh4vSUcy/TgLWKs7fLDr1eG8CWLPR7O7fvDyqrqu2sgl
 aYJqm/csR5JJhtqRU1iKX7qx0xcoT+8I+xxnN0lDXekBnOnh9brUSIUAJzH3yTi6Cz8c
 qDLm4RFezYMIBuVtP+aMRGAr/3i0N6cmny7GMO8dGNjeFk/Oz9mG6RZaHkd4fzG9iDyA Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby6cx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:48:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267KVYBu012790;
        Thu, 7 Jul 2022 20:48:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud70xtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:48:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEfT9KhA4w5OFDunBsrd2Xbp3oDkbBRusyuH5aGsK15VNFt1UxvnaSrrPslZOEjjNtjGvLcOTPqrUEsN/0qG69FEiw+wD5sKAC9xFqtkAMEdD/gw7EUP7U/7xPHUsbRMqi5c3lBKr9RStVfjgieyE1Dn1IYXy6gE6oblUwXYGWm/Pq6Z+UVoXTJNKjRCCk5ewxDAaR7c6xMsPejye/gPZGKst8c/LKl0o/jHDJCcGQVwwDU1tv6gb+fr1G6hJMYY43iIu0eyN9h9Z/pJHGoy+fZH9ZjO2KJOIPWHWF2lvYXpTLWVXeUqNSIpXCK5lzXDXAZaFTcZhw+UU3/fKtRsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIUDXyVXZ5vMVYY6RxCLAfsg3UHnwdSubujGgjtvBTc=;
 b=HeTOLJ2XgVSS7u99M1UrIxU6gTwUsY9g1qdsAiCaitQM6vqS3ejZQru3JziWXWOqT+gqGbSoraxD0qeE3UJYxTUJTtL1JXMbVztK3EBo7hxrgnlil5CG2CPyPgDrDe0+ArKQh8Is5c241NwTjWK1f8jb+onstX8wAczwuWNKpwi5MPLc4CpspUzDm36h/j0tTAZEHk4AoE13jz3xDywvu3FL9TnuqU/hRgSftfV8eim03gGO9lzb8hhTWE03sSDvYGG5EUoRKsj7f8CwoStHEItwN13SJfESc7t6mZOnPAADPzaqj/9m7UUB0ltI3nqa6zDMGhRg5bHsovscX/XQVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIUDXyVXZ5vMVYY6RxCLAfsg3UHnwdSubujGgjtvBTc=;
 b=A2JujvEclIfkWyFdIEC34y1hSpLwVcU6OtJBsbjZdODee5+0RCOws9p2AGlIIdwWViS+7mGu+5qQ/SBzuY/mmrKAaNAruDMJjHMpiifn8Y1QwaTGJ7vZzTR6H/3jLRLvKAkmUyd3YvaubzlzwOBQ0eMA5TiRMykpr6cD0JiLAwI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MWHPR1001MB2063.namprd10.prod.outlook.com (2603:10b6:301:34::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Thu, 7 Jul
 2022 20:48:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 20:48:35 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] mpi3mr: Use shared host tagset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h73s7ip2.fsf@ca-mkp.ca.oracle.com>
References: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 07 Jul 2022 16:48:30 -0400
In-Reply-To: <20220628074848.5036-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 28 Jun 2022 13:18:46 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16071a9b-0e1f-4d49-f40d-08da605a0f6a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dkbZ3XvUnZ4OHDmndFBNx1BvSR6S7ems4yoQnVQ7XK+ADEOCvhsBF1IhjGPfsH2SXier8L0XVZzGatVWnY/MNQXrO+FKdAagb+YHploj/G6T37ZOHpb+U6XgZzeVVIFSS92DH8h9/qtLstIciVs5r4i/yX/oLQ/pyfjY2YYBOdZPNGLwVCKZ69iCCkRDOI10EcAyTcNd28ei34gHz5CotD1aAEeqjc1HmiMvWsLRWp8eQxtrOqHwMM6CRlD3gX7KalmFFLPvbT2WCXaJDCWJIiaHr271UaWrKJDQoQutZDQ19g5ZPooSqsfmNHkDJW1GuadgPbwoSJl/jAKII0wU3jIEAyq9Tte6BlPbVHUE41xceUKopfJ2inybglmRUCykTm1U1r9/idhXmyX8asUvNE1dqql53LA5qAFjsaUGtWZ5UDGca68BjYDkuZuOu5mSNea2ikoI1l2DtI/9zt75FnTU/g/v0Fj3gyWP/w6lp97u+woiCNS7gsbViUVSgbVbnepnw/vYul10ehMC34MKrPq9B+MPTIcMLwSeUo/FagHTOrlEM8x/kVdoPdb7RhBqcJa9pvCMusyCNNwHL7GR0jQlJvrK2z2N+CMlHiHVBuRw6bb18N9PDTGuJAOFW6pDVZgRflbUpg3ogL4kU7uMvFtnAgmjnDplSaWz8jsjHr9ufuSGqzQ8G4GzRw3i8qky9vtos7f95rmThlqfIhh9pt0TTJrjUwdF3UV8Gza+/k8AnyTUmb0EYnkEMFklPQSj1d7zPIEVPE6tGjk5bbfbJI2yl0Lf+GqE3qWmVn1HWBJanBof3D2HX+C19XOBM1KV2C9YWj3i0wMVEPvwFdOBPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(136003)(39860400002)(558084003)(86362001)(66556008)(2906002)(66476007)(66946007)(6486002)(38100700002)(8936002)(186003)(36916002)(38350700002)(107886003)(6916009)(6666004)(6506007)(6512007)(26005)(52116002)(4326008)(5660300002)(316002)(8676002)(478600001)(41300700001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ApiozYN3QM+u1AfERhQpBlrAW3EkTvZALSusVirAeuRgEKuCBHt9V24pV5V?=
 =?us-ascii?Q?WBY0Rl/V2NaueHwtOOLtmBPFSEJQao7GrOaqPhDygokAVdHqg18HmV3kfypo?=
 =?us-ascii?Q?aWGDa0MjQvcvcZM+eXRlZ1HdZ6Lxy7XlxXGXGajpPTeU6S9WUsobgPto4zY6?=
 =?us-ascii?Q?rcoVm/GtdHKyrV9jb8mwp18zlT0xuZtgIDVdRJIBEXLaU0H4vel9cnvWjaZx?=
 =?us-ascii?Q?TifELFdj4E5U5NXsB7GbQF/WOz/y689UcDxw62qJzUrhe6GP+ePk/VmgCqPk?=
 =?us-ascii?Q?HZ0GlieyhIFFdpZq+yYIN6eaf2QG/jpQg+a9pZxjaAuEsupfuwR8ZQvwEPeJ?=
 =?us-ascii?Q?QsIERJZMquzSOX7+WSJRukIoWIzQXfxqTZWr1AnGxJGRsq+GRtzOjva/3Nfk?=
 =?us-ascii?Q?xOdQPOvmk5Jlx0xwb6v/BTM0+vYiQS9duk9RWm5/K02rPNakQRS0jj3zMsA7?=
 =?us-ascii?Q?zPpRYuyxu1XSArlg+1Ngfp1zbxyDYztTW4rZsADJC03R3LSugRh2MTsJpwA4?=
 =?us-ascii?Q?0vUNbV4LhsSbCUlVYy7AxfNALO8WZzU4SGxCu4A8HqdBfL76bpSV+Gw/yPlZ?=
 =?us-ascii?Q?3uQ2juMoKvVTYYZsnn7FZX8Cz77PYbzQLWecquP9uQf/mOo9v2xfI3++/urR?=
 =?us-ascii?Q?uehdcjEjbPkZBW0Pqtsp3tTFXEo8ixK+Lq6ArCUHs8EckN2awnJyEF8YwILR?=
 =?us-ascii?Q?RSBXnRrlQ8ZvrH5NisWH1P0O0Y/3RC30CBIKXGHxqEJvaCpDG5osOLtkTYmT?=
 =?us-ascii?Q?g80oZtU25radmcw7VTPyBVhGf6akiGtoeB9vJsIBBgblovxidiBXzk2kKNRp?=
 =?us-ascii?Q?WwggLmTCnY0DzNa9IDHC1CJxZQZ3fZ06NIdGJBTO7sJhOjcsEexqxL2j5Zzm?=
 =?us-ascii?Q?bTxaqSooBaNMC30IJjEEqwOwKJmVxuodRHLPznzW39pFv2g8RHgYgY3qmEtf?=
 =?us-ascii?Q?3cvZtdpi16bz6YyakO/FhOPPdBidg+IJpySjxp02+ttd8x+p91S0gEZ5EkJg?=
 =?us-ascii?Q?rVVeMbVTYe7sCe9nJ9oPGQSaDKs5PcNb8hLxX/5SrFXkLaDFMwq4duecfHCs?=
 =?us-ascii?Q?hJBauHusw7QppIwLQA3ahGGY/vPkhmghYt4cDyVqEGJvf84m1nkcmERPb/ey?=
 =?us-ascii?Q?flJdT2BTbjPyTSzyRPx7MaOk5qi5ruQZvYKn15hvf2AXWb61ikrz+PeWzhYY?=
 =?us-ascii?Q?MfKQkr2SUMshR1QBPa7WdGBUcxUZBvumEst0E98W2w3msCxGoz9P4o2ySJi7?=
 =?us-ascii?Q?4VpWksp47y0fRX12LGHqziuUQf5m+3AdjKHf7J9W0lhtdYI7AlIcZs8fkVV5?=
 =?us-ascii?Q?GqAszTQAiaabfb0PEWiwcE5hHUK/OLghsabyQChUAFkB9UROOaXXZvI9vHmU?=
 =?us-ascii?Q?9HM+RPDUkKoJx1Aa4aWYP8GievldIRRygZ+qqjg/3KNK1w0n2JdVxT1EkYiR?=
 =?us-ascii?Q?ijUcY7sofO7gzMoRNPWZDFd3PLe7Mfm1LzvAS+lCLZcbozvQRqeGnYvJ24zS?=
 =?us-ascii?Q?2SQ1I/LBDFts4fwByJ5Gv4Rycj8g6Gkkh+xbh7fCZpnBb0cLNlgPUktwfVWd?=
 =?us-ascii?Q?03/nJDXO7/E9T4XCOGUH3aG2DF2qlJAYEFk09D3gk6QYLpwQqlp3NwVvuiox?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16071a9b-0e1f-4d49-f40d-08da605a0f6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:48:35.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbpgEVrKbrzyPh6pJcMjzDjPDkGsQBJlyPUTKOaLqSbvvqO6PP/MYD2ArN7hhpxGAmhVAr6Pwc/No7uk0fruZ8qzgYvu83ybNtpivLhKkLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=676 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070082
X-Proofpoint-ORIG-GUID: Y4hBC953jqH9LKODGireKL5tB_7na2qa
X-Proofpoint-GUID: Y4hBC953jqH9LKODGireKL5tB_7na2qa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> - Enabled the shared host tagset,
> - Also increased the cmd_per_lun to 128.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
