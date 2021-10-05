Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB8AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C990061506
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJED4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:56:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14770 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJED4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:56:54 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952Qm8f029400;
        Tue, 5 Oct 2021 03:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tnvlyl7t7FqdWroqkgPnSS/NsS8YU9r2X8KNGkeZkV4=;
 b=ndiI2OXWKnPc8lI4QRKeNN+0ggXnFR6bsZjHsknrQ8Woy5Hjra02MDa/P69OHmyINNbg
 opYJBII3+bbs/Y1xjWjhsdl2YMsPBpeqIE2PASAvhWhbIRgE7A9NN5mjygqy+OJNIH8z
 Dtjh9trRVvDs5kkKJJNQcfdcXfiKXXkr8yCZHSYRXnhALZ0CoHN5JzFLcEGRHKymL7qD
 E0Jv7JZ6MpNg22fikjRzqZZNWpuS8I7cqAE1KzhuV3v30gA3wUKXtWou1Dl1DViTspAN
 monJhshVJz14Fq9wICMG2xd90WgYXfoH+VQ0Os8WL3P/ER7qW1RJcO2T/Vhfr+iIy1S3 Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kmgb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:55:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1953sfV6099168;
        Tue, 5 Oct 2021 03:54:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3bf16sd20s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyJdmn+52kTXiRO59kOWb6p98pybrvm+JzAh+IHuXCl19s0FfvAArKs/BWRoT1MN9aFwKU/I+g+RPJYBGo43GoCuZYMkY37C5EbNINFqwP1zWjrXUEqYi0ZHMrg7ahvvaF7gZeCjkMyLggHXU+v9rfdESVzpsoYR6a3tV2+ZFSwoS65x8cBIw8RAUU1cwORbRA6ek6qKL8a+xX40+s9EPjJTDw+UDxyuZ4QMbeRJlS+J2iD1GZdkNb0FW7dtiew/4zhJHL5Y1ERmjQnAgvPkTOZeF4oJvde3RmLkzLoy9/HGzv2GXthhQ6du7mDlBVPkJD0OjQbdIBn4g4SE6+gLAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnvlyl7t7FqdWroqkgPnSS/NsS8YU9r2X8KNGkeZkV4=;
 b=UE6ScXnlIRjqF00fKTlspVkGd+bQh221heim6jaEzotnDhIZImj1qFQcwVsO5wJAr8JZLPvIC6B2yBup+k8ShoBLX2hmQ3Hj+O/1oSW0XksTswmBrrbb7Yfd/+Js2A3jJ7/wD6PoLteNxL3azC0NH73z+xhMHB4cTAQXtcvxuwM0niTd4nBUmTCRvmX6YCe+OWLC3hKgYvbndw3+Dxu7PkxJHX5i3xrf2/pzXyVnvRLz1r0vKl6HgJnllc8Sa8HzNKS8sNaiTCzIRBT+QaK4K/kGckGsPW83OGoFEQFRonK0j1UY0HkQ/mzqWAxf2V+Vk6whot0oxPiFO4GLtnyCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnvlyl7t7FqdWroqkgPnSS/NsS8YU9r2X8KNGkeZkV4=;
 b=Srjjbv8kW1ncPzfIF3uRgMX6Xe+eh8rArcKW57loe9dLQbOujQBVdNqEGgS6WNWLnjFdR4uetO/5rDYjhK69rmc+1iOguDNU0II9Fzk+dHtAJgWWcqJ3uARKW1tqK1cip9Sw1nFJF7ACj0RlhpC8Yi85souq0uo3Pdt7B94jiX4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 03:54:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:54:57 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtno6s8t.fsf@ca-mkp.ca.oracle.com>
References: <20210916132605.GF25094@kili>
Date:   Mon, 04 Oct 2021 23:54:55 -0400
In-Reply-To: <20210916132605.GF25094@kili> (Dan Carpenter's message of "Thu,
        16 Sep 2021 16:26:05 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 03:54:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e950a1f3-132a-49d0-66ac-08d987b3e5fd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419888A204761E4E6FBAF048EAF9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ppYtFJTZQe1QCNOqebcXPNXgyj6QN9ilLjFrV9MPmzyHZf7mw5JPDcM2UUgPLroDw2sEZCrVs1+udYMhNUFDajLyC1OsKT6y5v5up9f+5vZVsOIjM31h44lCMfhHF3bkvhc4W3qLEt1+iDl1Kw0j/S3kPYWAQVmF6ZB1XoG0/tVHm7hH/p5aMBoQVQLpkMOkieKsS3Pxc3UQ4skHfoJkwOdN9SC7S9KYZowu4OngOTrGL2GPMJeOVKXZGr9IQreD6ZD5Kra68WZazOetTu7kYy2gqnjyAnwhcPM8Mr0xVLbx6JHbck7CMf44YEDi5lyfPamLFJJIRHch2H+w3ohsPFRRNXG4MvIdnXg6N3iSTfkDDP10cFOSandcyLC9+4EPpZtKRA8+S7C0Fq2dbk5sAqod7C02D0jEPLd5c77OnpZeb17/EdDMTUsSrcD1RVWxevz9Q1eRbDZoD4KcBaBCPmDOQE4SJo1vsETp/PDGyPzavd6oTbVzbALKGJKQJPvxNgzsn7jglvF8oNTjx/ZOtqf9A+Mn7kSZjp9NXQq8KqjGLlF/p3tuOIGKrLegrkG3GzTaW8K3mc6hUL/SKok9M9jaTVbw8gWz/ZbegL0ziBRgF6IGFWMSOgHubGXclM4DWeJSQPyTseUZHRMy9rG/zOOEFEvpAvz+T69Mfo+5LwN2+uXg2oz6412umL5ma6Z9lVAwf4RfVzwB6yfNBquGlxuN0wFGlZIKeUsctszslbY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66946007)(508600001)(2906002)(5660300002)(186003)(26005)(8676002)(66556008)(54906003)(6636002)(956004)(8936002)(6862004)(7696005)(4744005)(86362001)(316002)(52116002)(36916002)(4326008)(55016002)(38350700002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9R4nCDJvtNpx3jF/O37gDluVT7JZkhomao0zxIf+6d2oP/J5vGiUcShVD6wS?=
 =?us-ascii?Q?M5Gvyldeu+Fd/U8vBdojwyBquCNk7e7GyXi+/GswcP+6ldT7muExH26uLjLK?=
 =?us-ascii?Q?RcNAXN8yDez7yIlS2TQBaes4qJ4WLBZAR2PJKH0Y3EkZDhLeBBtIT07xRGw1?=
 =?us-ascii?Q?v5XE1P+wpp+djHqXn/FLx8wR8hOmiKCP5PEkrDyKvx2NIfXKuTUVyo+qUVrn?=
 =?us-ascii?Q?PeMhUJfA8/mDCJWfhXhWtwA6cWMUy/jwSeqk75V56aSTchfiIlar9KVL6iUu?=
 =?us-ascii?Q?ltoJHjlSnnYsw5lplqIDkEnY+VEZfeT3xm0bRwBor2bwcsewAN1HOw/BH4rk?=
 =?us-ascii?Q?Vwc8pU04ovWSPleyPwTbCy23LzV9qck0xJLpjEkmCzmKQXEM7OWoTX+XpYcg?=
 =?us-ascii?Q?+hBc9ItERNL2RvTwz0ZXiPUUSJmQrSm1ZTsZmOWPAjegEp/kcVqRCyF6NkeP?=
 =?us-ascii?Q?cPzcJYYFotgRMZAsvkg+WOnnOKMrESQt2LG6gYC3Crf+JZ/67yJ0v9GrON9y?=
 =?us-ascii?Q?62ndMsObKJUTwsHHB2pEksb8ZiCsgihe+iLVAzebgnPKOD5Uqm5oYMquHS22?=
 =?us-ascii?Q?a/F9alBbnCaodqfoQi4uF8xfSJYfijL3fnk7LNoMh0Xa1+6jswfQAxxPSuR3?=
 =?us-ascii?Q?1FSVNigL0LXYTzzZU/6jAXmXnZ5NLa/HnAiDQ3LJQZQE4k0MeZQ4SDrO9sl3?=
 =?us-ascii?Q?Gr69c3NWwC5ce6TTUiHi+CdZ5rp7ENfHsnvyc92DXptUQfvOHKY6uWYE8yO5?=
 =?us-ascii?Q?I9Wjdzjf33bPx9x2RHzIgHs1uDDLGVYjsxXOP43/4P5V3t4Cox55tQmIU2lZ?=
 =?us-ascii?Q?b61KsgYTpnR7eHdy8NLSxwg3E1ZM3ldDcQpqp1u1Js6HYx+55DLVw0WtU29b?=
 =?us-ascii?Q?qAuQ5ym7Go5+XY4DAC0vX4tMrjtwnr7WlCv14HHwYoi0ELebFOvwPxe36IBD?=
 =?us-ascii?Q?8sueuGDcf4Y4KQI8AThbGEWbPuuCCJva2LvTJ2SVqosARV5dWBzBvTcep1xG?=
 =?us-ascii?Q?lBHOHadG2lZzEETLpsUf2gjhgjWCCNJsNWFGbRdUM7J0kLnKh0lJvA1ZHpul?=
 =?us-ascii?Q?Foqm5xNQBKeF6npFDx1ypFh9t1uy/+ABRDuB54O9yk8xu8BVX71nJ0WoeVCW?=
 =?us-ascii?Q?1VUlHn+0fWDoLvFWq7Mr3dhgS8Ydq6r4gb/1JWrkGsYW9JxWEyQ41kUiVik+?=
 =?us-ascii?Q?Qu4VWnOTFgA+DQQRT4/rjck71W1n9ttGtYGmvD6EhBKB8uu8udwJqG8kefc1?=
 =?us-ascii?Q?+98PKGrrM34GaNnpSg1wt1vyTxftwuBaUKg/gW2Xo1WxCulkdmPTj3OaIOfq?=
 =?us-ascii?Q?BPXEFgbus8TIOrZGUVnRB3xb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e950a1f3-132a-49d0-66ac-08d987b3e5fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 03:54:57.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbxUGP7alubAK2x/pDow04TUv6UcvM8WvcxMoKrSPcSK90KSVxcqYWeRt1bBfkIl47UEzFVv55bx35J/Y+CCgA7rKhSsTqE04vyvu3xO4t4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=859 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050022
X-Proofpoint-GUID: Qb6mmYu6GcgxiGvVPGaF6-PkoB3yVsCy
X-Proofpoint-ORIG-GUID: Qb6mmYu6GcgxiGvVPGaF6-PkoB3yVsCy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This function is more complicated than necessary.
>
> If we change from scnprintf() to snprintf() that let's us remove the
> if bytes_wrote < sizeof(protocol) checks.  Also we can use bytes_wrote
> ? "," : "" to print the comma and remove the separate if statement and
> the "is_string_nonempty" variable.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
