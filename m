Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB8BC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E392D60F36
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhHPROi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:14:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37478 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhHPROh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:14:37 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GH5c77024924;
        Mon, 16 Aug 2021 17:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NOt8pQttxOjBQ3Gum1vQjwX3hfMPOYqye0nBQyc1tp4=;
 b=Tp3zm6l0/Pa/PlFyEA5rDadbo7YlgL2ey6+2q8g4qh7sVAJW6gdVWX3QBkdGsRTKlB52
 bsavD/jdqHPqgeYiEFVZ8c9w2YSyGsbOCPkfAd70PavGRh2szbju+L8CH851AMSmh98P
 uf8PS6aXZNOlCPYj4FO88jrcdBfB7h0ojPeNUga4+vtQE747jt6cOQMlm6LYKTn6wgAT
 vy08a+k5m0ft6eCZqQFvGdPN5pR7Al8MMAkWH07R0E2XasYyuhJ7NUYGGUIoLFShEllp
 DBw0K0PuSGOjq04dPGFARpPNIiwqePH6alq6IA41HZKo6Z57Wn7993o0dJvQ1YlNFYOA Yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NOt8pQttxOjBQ3Gum1vQjwX3hfMPOYqye0nBQyc1tp4=;
 b=ctdRL0l+Dp0dUeGcLaIrP1j7I+aOsHG9VwE32nnm39CvIosyvIOumslYKFWBND7VjfI9
 +L6sj6x2hkHAvmSiacySl/mH53lJ98sJX6uFJO2DSa05ZMvWV/2iwFvXFh8gFXl8PCLm
 i0OiaJL7BBYzePVi54CSE521TtQ/5H5khKSZcG7tL5M1aNHSpFswNigT7aJuAZEwTcHV
 KSPPnob6YNbahgKDT44aQJsYmqVfv79jI4NRZxwZSXEBersGsoEDs9z73f+dqEPga7n9
 ZtMtXxH+I16VPah9HfQLRhcMA7iA92CDA8VpTc9Du0wCK1dz5T9pcpkywxiLiv8Ax1dX SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpghp72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:14:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHAu3b144617;
        Mon, 16 Aug 2021 17:14:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3030.oracle.com with ESMTP id 3ae2xxjm0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSjxzzmvYlgT5wx0FkI/Wf2iH3pkIR21/x68W9rCBbjfc8vBBjDT86JnzIMPkCnicsyRzab1KVzGJLn3osdv+eri13twCiUiQ8ArABrY/qCkak5l2D8Ieh5+E3WRw3mjN2gryJttOqClcjY9aIXid/6C9YhhpFCeWNh8/QwOrJsiYTMv6hZW6UM4TQ3piZP1aP2cCibiotZfi7RNyOycQaaHGDYWCtsV+vf/wQSO54o0Msr9BfMdTIbI4/takNJ1OMti2sX4iDFuEqlr5d7yLquNcUHnxxjZoJ9lRekA5UXTkgbmuuEQQqITUXIuBvkFe+aHjtzeglH8pxWIKIWoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOt8pQttxOjBQ3Gum1vQjwX3hfMPOYqye0nBQyc1tp4=;
 b=PkRijbfbcZi+yl8z2MtCXScrowA7FRbr8py675QHM7/RO1Ezm9S9Y/jNlG7Hd+E0sgUjqyeZUqLDA9aIe8OqxsQ7clByPZf5pvP9cJ1HWx2SPPJ7UlxffC4G1h/xtf8UTpZG1yGkMoqwCphzJmdHeqB+aMhiHBIutv8zNr3bCgzqONSXO2WEXkvzGPbhU7hwwR4acQLtv9t7SvEt3DVezTrzCD6fUzoHqek8cFSujoL3JXPIXk8H0qkB0twMMf/ElyAYjdvSbAjTJ1dSqaBj+kmX2bEJOArQts/9X68FC5XidzNg7aeWFafkavgOV3oUpsxuOrpo57rwcHvTEMOZag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOt8pQttxOjBQ3Gum1vQjwX3hfMPOYqye0nBQyc1tp4=;
 b=DLQhfQ/t3sGqBUqh4ARHeTzEsvK57w+BxY0RGVjHmTJ52dszvjE0A+fToqT7IsP1xXAcfhBfXEJ+lv79NQykvHibHmCspu1FBh+HGCDgevGDQ+WLrEXvcF22a++oOIRXDljHZacM1Qu2Juc4AEMQfKZVt4/qBKDTRBG01pk5Y1I=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 17:13:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:13:59 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 29/52] mpi3mr: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnolpb42.fsf@ca-mkp.ca.oracle.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
        <20210809230355.8186-30-bvanassche@acm.org>
        <CAHsXFKFTOGb5Spt-U4ejxC-=i-iFuaggSR=4HZgUjgVRg++Lxg@mail.gmail.com>
Date:   Mon, 16 Aug 2021 13:13:55 -0400
In-Reply-To: <CAHsXFKFTOGb5Spt-U4ejxC-=i-iFuaggSR=4HZgUjgVRg++Lxg@mail.gmail.com>
        (Kashyap Desai's message of "Mon, 16 Aug 2021 14:02:12 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0012.namprd08.prod.outlook.com
 (2603:10b6:803:29::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0012.namprd08.prod.outlook.com (2603:10b6:803:29::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 17:13:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 795b4644-f2e5-40be-1ffc-08d960d93c9e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4536C57B3B528157723929D08EFD9@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvzmONzHAK1MW8qGVttaumJTkyYVVUUjXEXtADbh4iKjQjHNqLvsgt0y6tBBWq9r0KEaGd9584sTv/n134wLwRS5JneKTaKp1smZlC+1F4VmsyEd5+w3XCGI+p0Q+o9Ii410Bt+IFbnkSoXc2EBu/ht+lXKgHJOMxdxRTovPDiYZMrP7q2wNQsQ4AxsoWjQ4MLS+D4X0LI7KvpGB2L3IpFDhujfPdS0TCWhHBhOIq/yuqtZOEr/g5WD5GUfzZwQpfvDElOixQ5A+Et+2A/d3kHlLjXHC3N2EjDbu96GveqBnUz6MQ9/E3u/GZtuRUW6BG6J0LN529YEyMexWyq/KS1lJAZUn0CDH0+mPeqeIFUIukw7jF0CU9R8HBOl1IixicK7SBRc1P48MvXpKFKRAQjJdPAMe+fIlwnjpNK/02omM2zPmYg1P130nkPAxX81/hdNmujX2p9MW1qjQHuWemCF//tIqffNoTrAdDnYr1E1m+2hMt2q/+TNJuPySXYMA/FnTLnVbuCV4RyfWgSOVMiL1mE+/P8vel2Hb05wPEr0YXBDmlro/qmr9Rvf3o+VMyMRytnl7CyUwEUXep8cP20sJQeRtA8lC65Qh2TCvfkPxJtvcJWcJ+1HASlwEcglwpPF2tSaaxZckT3UL5GXZMWKI7DpEnbRK4ybkTJnzqwRzGStSfJyag/hE3R96sH4BzpRaC1BOWM1RhUhNaeFHCy+OS0uvfN6wvMZmYhJMVSE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(26005)(186003)(86362001)(8936002)(52116002)(66556008)(66476007)(7696005)(66946007)(2906002)(6666004)(54906003)(316002)(4744005)(956004)(36916002)(8676002)(83380400001)(5660300002)(55016002)(4326008)(38100700002)(6916009)(478600001)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zm5WLeThaBWaAi295jy7jfdVUbOlmhxK8Sph6uGwapEZWkB467hFnlz76Mc/?=
 =?us-ascii?Q?qCWdEOBtnGOGaBsUzkmiJjCeQjqeg6o5DQMG9gmKS9qoT/Nl2uS3/zqKW1Fa?=
 =?us-ascii?Q?6T0aoWzPeJS7OquhCu5qpyjYuNacfEA1alsRbgquXujuEQWk8TJ1IfnEtT8H?=
 =?us-ascii?Q?8okOQA8PGO2lUu6ELvwjeKsc30LNeEetoIdjPZq3DKWiMwEwzL6lLZPvMaQm?=
 =?us-ascii?Q?CEc7ea2IZ4M0ZY5a/QuGZTUSf9nFgg6KneEsGi+Zs2ZMr9jorrOLtgSZj4MC?=
 =?us-ascii?Q?3pOBKLHCdQMerwRd07ojPw/hJ82YKI7b8+Z6TNIZ1F6EoXugnfZ3VKl36f3r?=
 =?us-ascii?Q?hQgv1Z/oGtExKxCRVIlybeEZQ5Gzp6W5Si3UIUw7pAivTcbA8JzIkEzpXfrc?=
 =?us-ascii?Q?JRHyvQMTRSLv5QYYuzUnNdKiVOFFvdpL6AlAzPCcqeLbA0W0lAIV5kxTsJwV?=
 =?us-ascii?Q?sJlabfby3rPTYq+3SxHaDux9CMjYPb23xg4uvO7kCUuFqPnpASE7Nz8+z5/z?=
 =?us-ascii?Q?dGoWSFewJrTCH9snRenIMuwYts7/DgpblOjhHmBwNjlJY+oVxW9HxzwhrQC5?=
 =?us-ascii?Q?Ky2G2XsITGav4fGgKVUnVaktrqC4AxrueKMFJLsWlShsk2lM65nPpnNiww6q?=
 =?us-ascii?Q?REXL5rkbCsb+czmIxxnZWAYanGuQfpflJeFR8Um6JWD+6CWznPpY+5BUuyIZ?=
 =?us-ascii?Q?6TyMkuFX10+Rxz+NbPTd8ZEmZFlvmWO+nLDVkuzkFq3e/actg64FRQh6RGbA?=
 =?us-ascii?Q?0MVaBBj6Uo2+c+6xy1PJcMMcMh30Jh/G1apQ+eBlE5ZtB2OMaJ+FfU7qAfdw?=
 =?us-ascii?Q?X+7chEHb1JlyceryU3A77OYnsFGLG7WnW1cPQ+h8HrhYwxfgTddfLm6oU2vR?=
 =?us-ascii?Q?NZtzvX+2zqIEk8NPmjMNAQ07V1HO3fMGkYmT8v25JsCPtvVZl6dqmfISiins?=
 =?us-ascii?Q?nBxcjXjSP4sEKPIxQ5nOp8vfn4uRDrRohQulN/ma1dCLvpuZbGKj9+jCXlNV?=
 =?us-ascii?Q?M3uLFP9MRKjqjALOQIcCda+ngv1bpfRjWFdxFJpg+WQe3lSYWNZxL1EfIlfQ?=
 =?us-ascii?Q?YN8FDGV8wdTURSZZmPFuso3zg2EVZ1VDzOSqGRjdrJfxwZugSI/rYyHwrmbt?=
 =?us-ascii?Q?a/LSGXcmwRXFEuiQnWUEf/BCRZU04tnaEeaYhz44H+OJoYqAod8DShpRsXWx?=
 =?us-ascii?Q?TxWOmIU5Vqv2/WT6W5E9Jk5rBbYfx4fdPULtwgrDvjIVqqI9OBE+gzJ36Jfn?=
 =?us-ascii?Q?kA8eI7x6yhcWG57k+USJSFyH10X1k6FF87LKEVkIDDMzghtWngza/KOIVjNR?=
 =?us-ascii?Q?OTJUSuRO8rwJ8p2FABSjtKMS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 795b4644-f2e5-40be-1ffc-08d960d93c9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:13:59.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kf/adGRyHybtlIkL7a8hy8QSX1fF25bRE2vXHraPxoVTfIBBeV251m3kAZ9rcAavdfJAb7Qi/ZOIslIq41ROTvGMpq9tJTJxGADOXCwcZOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=843 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160109
X-Proofpoint-GUID: jvu6igtJiHkc-W89mvQr01jPHsplEBb6
X-Proofpoint-ORIG-GUID: jvu6igtJiHkc-W89mvQr01jPHsplEBb6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> t10_pi_ref_tag API is replaced by scsi_prot_ref_tag in the patch below
> posted by Martin.

> Rebase is required for mpi3mr and mpt3sas driver changes in this series.

I fixed this conflict when I merged the series.

The corresponding mpt3sas patch caused a zeroday warning and had a
bug. Posting a fixed version shortly.

-- 
Martin K. Petersen	Oracle Linux Engineering
