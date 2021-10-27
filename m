Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5F6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A2C761040
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhJ0D2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:28:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22206 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhJ0D2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 23:28:04 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0n2r4015496;
        Wed, 27 Oct 2021 03:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PuZZ98qzk7gWXH+rH25mmGGmpRuDsfOkLSYdp7+PaAM=;
 b=WEL9QGZ6c94vdCh85lEwRsESVn8TNanFxAPTm3bwQXQOcvLLXrk/FHnQtAyHR9OZAHcE
 Bj+fah5y3gjszEYL8vpqCZyrsn2lQ+nVfM2DkcfDXoaV7gcRLGwvV5qQvU5QWpAwElOz
 CkrEdp1ynEcxqtjiPk5bt6QOuGCbn+BFlskWauLhl4JpohS8SPSGEoWEKgmuCh8vb9Aa
 y/NoQkuJAF2rOEUNh1JYI7hfzw914xfkkIqrh0uGUZZy56fBS7Kixc+JizADf27Fp8KP
 s49Wi2qpjKXmF68BQbrbtsPR5EwXUrY74gVW3oua5uJ8f75xBIXJcpmUj+pWTi0l4cXe yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0qn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:25:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3FXjX092810;
        Wed, 27 Oct 2021 03:25:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 3bx4gc1m12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:25:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdpPgtpR9oKrvNK+/MOYhfzXxZqVhhly34TMfFHnU6IsLEfkZbzlblaTHR37TOVX8i+OWijkwFhDM7zKl8+ZGl1wAlIx1R8apGtXP3DO9n5OcK3zbbSa7F7PbkDivOAMZngX6Av333Yw+3Te5r7grvRtf3FtUvwDMev6IWBxdxJHjrfgw/EcrTITBzj3/8lSOjfB1GWWt85crT1mVo8sQKLK+GDjcsxdfh5F8rr7XJ02akTtJYjZhWNC8BCAbtKZtxfOSVgI1IrlytWpdHDLle1dcPXesp1EiTmlu/8HRUHevO5P8oE1+OzGizC6VtHjdwsU39yTQwMaQru9mUDajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuZZ98qzk7gWXH+rH25mmGGmpRuDsfOkLSYdp7+PaAM=;
 b=BzbgAdZwPqJKyEtQHbQroYzkOD0ITpDk2UhrSaVNchUu+sFjLvPn2mXvSUkuZQBij59g1JHZOyJ7PscSHnyPQovVu32HV4O3L17ooke3l7m3gnPwOD+OFmUQ+UWUFWThM5+mwekNFhU9sHQuTVxOXCBAw/o0dKvmVLAOTVFrRJ0zlPTuozTUXne7aNDPWJxH+D0jjFHwyh9C5cD2lhSeKrW49XaU4g9BXuXufkQgGhm1a+ExQ0TvaZDCgRZ3nps5Qr5eHO/92b+DCgfF0GM9z91VhsRD9PrN3YVa2euRDKjBXMephGpL2OvOqunjP2DyVduPN09x17ELoxAouDmnKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuZZ98qzk7gWXH+rH25mmGGmpRuDsfOkLSYdp7+PaAM=;
 b=X9LJte0l+T+6/6tTitC0esj0UQL1W5RMx1vHOz4yfc0igXpIADOwaoPoW1NVVyCceQAY8UDYN20aGQyODnNCg6f/mGsiEUFf7LSgq4YI0pCl4d3r23pzQHaES8OkvZSoDd7ycwJUWz197U47GOgwYT+R/YnYttSIFYeCnxht+lI=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 03:25:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 03:25:31 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 00/10] UFS patches for kernel v5.16
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1c7174w.fsf@ca-mkp.ca.oracle.com>
References: <20211020214024.2007615-1-bvanassche@acm.org>
Date:   Tue, 26 Oct 2021 23:25:29 -0400
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 20 Oct 2021 14:40:14 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0230.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by BL1PR13CA0230.namprd13.prod.outlook.com (2603:10b6:208:2bf::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Wed, 27 Oct 2021 03:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cac18f6-0120-4207-b474-08d998f96e61
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5449CFEF8CB8B0FD49CED2BB8E859@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40BqgA4FXRnT6FT5cK1IB04/fVUm7cFLQnLIgoazlwWotrBokd9voum+cJeATi92BddnH5S8eh5A0uM9Dyw6N5ehWhxpb4S3bo6zKulICL+JFRIRY22cHg4masNReokWEJn/wX1UkV1PTLDZuzjscHwGJQxbpcY9scN3h5QWRgh39z6BNj9arQEeJqBSjamlhidiWfzaj+amPy0b0GOS4BYwilps/+HxVDFAJBfdakeDVF7d4MOm4eyTkm00H/x1VU++nC8b9Tq3rUWcjVkm1WgMdj0DaphR8r3gk6K8mKEl7ePu568ecw1llgBNaCTuHuotbbvnAEfFd4RY/7/WPCrOCA9aGsVjBzaUhz30U2o858te3h5CiZgznR+xJqhya62RCcyDchxb2J24Jhd3cK5kjPoAndFOcdg3VyyNbu6mfpWF801Dl2DSpyB5lFteWSv2BofaaTszySko+ySJjwxn/RiqIHbbhoX5duMlrFwG45BrCQv3yfGHUtV1LZH6dVb4OkU8q1kmIiV2+8PiCn1kMdPEkFUBChdz5AmVBOq4OQ5AwLhzOYOOeuTrqZFO16m1LVaPGOFq00LV4kiz/Ex/DOC6/PT3qcMmJNj4lQf9OLbxGT8IEcsA0AsJevukVMdWSYMO5NyXEgXuvax8410CQAOZqyfLLdkS03gyDHq/wc19xJeAegjypi1KmWfD1ILWwraN2iayKc29rcq4Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(186003)(6916009)(38100700002)(36916002)(7696005)(8676002)(956004)(316002)(66556008)(54906003)(66476007)(8936002)(558084003)(86362001)(2906002)(5660300002)(38350700002)(66946007)(55016002)(52116002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hG66Do1CUmtxN0+b5zRR4r/gARlb+nxBsO0zxKlf3OKvK6R2uJsPtx43v7rS?=
 =?us-ascii?Q?AbBGMIXp9jAmN7yKRwZs0PVwXoYO7+m9Mrzo+GeLLN/iL4Nmfhq7tzUKVuQa?=
 =?us-ascii?Q?OpWg5rcHtZzwSbMffSVxzcg2ZI95k00u8WcZQUg8l9sSHhFfjGDTWcW7OUkH?=
 =?us-ascii?Q?lhfLZfZe1B8aWz76w9izmlNNUpi5R9tft+Ni4ohqOikF2E3NFxVmpcycQawi?=
 =?us-ascii?Q?gkDqaq7bFrk41QSHrqsl86FjIptJKepIguu3s9vX42/e3+X1+FOMmQBzOafB?=
 =?us-ascii?Q?6LB4yAJnRmH6oUHbOr/0itZUoWu9V1y9G4oOKVTV36NNU2V/2ydNk6g3Nyt8?=
 =?us-ascii?Q?eDD31wiWDNvZWXuZ6zr/ls6YVMGNA4ljRs1ATZA/Q+ASNWalJrG1wxLTtQ33?=
 =?us-ascii?Q?UQa087nw8cvUBrPibROj9lG73bgkEkCI50l0iaalAKuuNDrovp2TuAA1RjDa?=
 =?us-ascii?Q?GE/xWo6v8DS7qVBur6jWmxuMeIjkRmplPuH+jWB50DHGrNvY2j9ulecBksoU?=
 =?us-ascii?Q?MQNiEAsEJWmgKeqUye7yt3+EzNMVjDSOYQXRzz+cURNEMDhB1q4HWbupYk96?=
 =?us-ascii?Q?u2OtHz3TIDAQ+G09iBsLoLCWP9uceCVyC4DV1tGjD0yb0+0SOfBGr8NMMDwx?=
 =?us-ascii?Q?ZPeuABdtYBBVPTSLRZQfMKlFvjN1pd/+vAD/IhbZ7/8PlgeH0cfWCXMIgYXc?=
 =?us-ascii?Q?EJTqfqD/eM8LHrG6Zwq4+/e6vKUAPRZaco+NbweHV1eOOLYbYCcTdfckaAQu?=
 =?us-ascii?Q?OB4L8yl6I+3rRz5rzW6+K3HtCnSO7ydlkV5YDjNmQVLJQu9zo6rfSgTp5A/D?=
 =?us-ascii?Q?L2H2NXggaa/IbCh6MTOQFvqyNxhGH7VpqMR4hsASrS2t0CAeIWl+KaD1bqVi?=
 =?us-ascii?Q?KaKQu5tMs7TH4U/OTpHaAlrgqrblC091pwrBsSw+D9NsTeQjw5C8trDNlBex?=
 =?us-ascii?Q?4ZDT0lgDYa5Ttv7m2r+ezaA0a6hHsIoOh7reo/cFcU1h0IDAw77GsgCgP3+0?=
 =?us-ascii?Q?9oBnpRevyHQ4mW47Lna4U9Lz2XMkTkUekZvYw0bc+CFWedrhR+/P4v0HrwOy?=
 =?us-ascii?Q?YJnGZmmzbjzmLxIlmcuN8cmCjikFaLmUeDR0+Q7ClTjuwRfrIb8FJ9kMPwPl?=
 =?us-ascii?Q?JalCRv68oKcoXCMiqb7J/IloaPkcT4X3Rt5tX44alZ+RtfW7Zm//XaRZg9FW?=
 =?us-ascii?Q?GqtYOPZdnWt5HXkoB9Is5bhuv9IL1ldNT3vzgZJUviyt4KnZ7qsg0MGtLL4u?=
 =?us-ascii?Q?RFGTG9JIMyL/J9qGVE5ooMkMzOUTprPzyqfB1N489KU6GtQqSuqG3mAXeh0N?=
 =?us-ascii?Q?Fh6oceSzcRkWqdr2XS9z6BcY2Mu2nwWIhguonbZfRhyiLS7uDgXZcKM62p3y?=
 =?us-ascii?Q?1BiYO935DLwTxow7/Di/RdEvujvbe09N1VMXC5aEs3y7C7kEqknZZzyOfDDm?=
 =?us-ascii?Q?WnyUUwg/mvvrvGk1L4VS4P4XmpWQ7jVhsmtwQUh22laG+WhNYKcEKzJIeca7?=
 =?us-ascii?Q?shz3tYOqdPxCMUpg7hU1CCKlzlSIHoCUlOsJaCXb0HcrGbbVG+tPj5vD1nHw?=
 =?us-ascii?Q?HRpgGF4KthGiWHNVB38NXDGX6A0HYt45X1oV1ippoGrh7GDwj92nljiRxA9Y?=
 =?us-ascii?Q?8zr7MAqr/JZvU8jZZLHmnxae90pD6vOJgTiNhu8XP2v64ACZXblWajj8UFAv?=
 =?us-ascii?Q?B2kHCw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cac18f6-0120-4207-b474-08d998f96e61
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 03:25:31.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/HaK+EnjFjQFCAlYWNZNkbiDYzQgN6FuH9qyesb0/pCyAR1zyVRHZTJHTX+UbVIoQmYf7FAqnvMfUJM6V02Z34qlIre/sO6e5L2CVz8GxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=907
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270017
X-Proofpoint-ORIG-GUID: MCsMgr0jIxw9OskQxjYQ6tKNt1nfRd_n
X-Proofpoint-GUID: MCsMgr0jIxw9OskQxjYQ6tKNt1nfRd_n
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series includes the UFS driver kernel patches I would like
> to see included kernel v5.16. Please consider these patches for kernel
> v5.16.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
