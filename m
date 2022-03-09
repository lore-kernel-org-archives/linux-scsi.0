Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734D4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiCIDi7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiCIDi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:38:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C0B15DDD0
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 19:37:59 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8mTq021311;
        Wed, 9 Mar 2022 03:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FsN0hBr3b950zTR+9N9FWHWY9pO8ygME4w7B9b8pb5I=;
 b=EzoChtcIsSiDeOnTcqHZTuPv0eWFiO/rYPuBSJtCJFNgD0Irf+FmRPctwOCzt1p29pVj
 iXjl/XZq/aNXdWxenGBcG+ULN2hDTo6tN82pXC0dDHj8WfN4KUh7vYzZK0m2GOBkhHAa
 y700oVdgjou/gkZTW1dp8KDkSBHw48JaP1HewNM54wp4qvPRCr0tM1d7YHbHkmzP4thH
 Wvz/VXqA5zx5i5CN4IP+/yjGo3oXWQ8RgvtP5sHQxZITQns2Fpw3qhkgA/Lgcw9wurQn
 0Fsp+WJRqyswdpolwFrKOYfiID+MvBM5xSS5X0C/wgLpCj8LTWn3CCTkCQT0ktzro9oI oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsgsdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:37:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293aPBq057055;
        Wed, 9 Mar 2022 03:37:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 3ekvyvg9nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:37:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVcVfHQ7s8QT75+6p8Vqq0L/g9DUm1IdIhjC+XZ7XdRl+CqmTskIdj9SIyzP6SrR6UqKip2WSeFDuzGmh+4LlROpyngAJCyyu14QsSuqFM6J714w9dnOyhmRQotBd3yBjY5XCuduLUwEmd2SL7+qcbCT/spKfchAuuu6SJ1eq/dKjErqheCKUVN8Vek1TOXfe1co1LFyOhhCzRCBsyOSZeIr271wfFxAetSLCS9b4wtwAYGRaOwd3ZG9qmvdXvdKTC0S5q9dBpSN+Bvurf+bQr8nC1GYvRjdgQRqYTaidyfQ0fVgvGV3oPq9pX9lQJZjQM6aw5VN8EnlLzd08IRE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsN0hBr3b950zTR+9N9FWHWY9pO8ygME4w7B9b8pb5I=;
 b=Pul9vRsOrxubHb3Ro2lwzqqfZh2poRHl0FvdZNFRp0jANyrl6YnTN4UBA4XMgNZesBzKZ1y5bdnPRncLmGsoQevJ1lKvu2/Ld/9hiMCDTAGk/MzI/rZ6P+HslEiPJ5AqY5vnFEO9Jgx1GJ+8w4SGW+OqxXW2so7Ya1PEfeMZ35z8RqTru0AtEMY2uqEMCd0AQLREoSjut+Aa+QWxo5Gf787TygrdhNOIBmxr9DcaXZQQOBMpBE4lDCg60jYIUkn1y9/qle0JekQKO64544SR3Z6Mf/mcIi1t9CPiqUzfxPjN05dZezxRFKLBR3y1EZAl/6yXmRSBoTdyK5zjqaXBvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsN0hBr3b950zTR+9N9FWHWY9pO8ygME4w7B9b8pb5I=;
 b=lEkuVY9YVOZLUBlVseucjbpvCs3HFE30PMb2GDTE6I3gRh2JRMmVMOAMZwPJKmcabPDkQrLySg8h45tYJQo6YV2ZLlNdxjGCgsZ7bdai7UOHVF7nsMIhqTPD9Sz5qNU1k7e2tYjpqthpKvw2xp5Cx6M8GcRn3Uw5gTcZ068I77Q=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by DM6PR10MB3259.namprd10.prod.outlook.com (2603:10b6:5:1a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 03:37:54 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:37:54 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpt3sas: Fix incorrect 4gb boundary check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r17bkd87.fsf@ca-mkp.ca.oracle.com>
References: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 08 Mar 2022 22:37:52 -0500
In-Reply-To: <20220303140230.13098-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 3 Mar 2022 19:32:30 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0043.namprd04.prod.outlook.com
 (2603:10b6:803:2a::29) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da3c5757-bad2-430e-1593-08da017e31fd
X-MS-TrafficTypeDiagnostic: DM6PR10MB3259:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3259C58187C4556FA833400E8E0A9@DM6PR10MB3259.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bk5JpvEW+8iYOgk8c7NcwbwpxEdRbKhXSoWZOJuhHffE/DVcALG7EWdKlzXh6ESFEVaqBi+p3yXO6ki3dl2AVPva6j3ymg+Ez7VLXM4DtWpoZ7p/I4J+oAaqdHU2knPRv+DAu4EELPt6h4xJTjsAmEjfVxOdv9f51eITASAS/JcS0jQRIi4dFXS0Jh0tsXx/gOceo/vqYfSP5vLwUq7f+VNblMTcVm43wNYxaQM7vrSBZ6rohPw8SrDMZotpSHKpdpQK3deQlwL7IdiXlmDe8zw4wD8VyRs0LgfFT7BVb7epXf/jyPjtRSHcjI9nvSdi8hpB44INm9V+ABQpjojSfZRj8UJfBhNUZHRMPWzBwiQ6v+Sqr+NPvk25RjXlYQs7+HglntvS5aJeA7kEknB+y8i53CM8xktM+jdq5E9IgYyS4AebKa0VxHmChGorALkz2hWptoIrwOVDTkjI7z4jQfcxgy9aOV9kyfBPcTE67NKHEcPbLWWHImVOhDi3CtpcS8kpbviatCwcaeAceYEGyy4JCtra9MNi/UxSZAWmXs10R4FkQZZG2qOkaUaa1FG9d8JG7aQYSUk5cFTbGQZ7C97/rDGa3a9iATX4F4fYpFzGuDCNVN9qwOBSKP4rGDNLRU9q0FK8emvqgIajyiPr/H+pUHMQaXGZA7rxdZWZbRFmflvwFL+5xqAcVWgWAV+0DRtfUDSaKCqHviQCAiNlA6RYX76aCVhkAESYzJQ0BM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(2906002)(508600001)(107886003)(316002)(5660300002)(6506007)(8936002)(86362001)(6512007)(36916002)(558084003)(52116002)(6916009)(38350700002)(38100700002)(6486002)(8676002)(66476007)(66556008)(4326008)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zi1apl4oEETpPXJ9HS+xlzqeWctGSfcUMYpWJpPlnn6JDY6UBWOb6NMyDANB?=
 =?us-ascii?Q?ExDrs8S+4k10euquUo4Gn0oUJQ+dIKI2a4U95yETDxQtZWzD2FRBoD8t+FwN?=
 =?us-ascii?Q?qQzc2aahf7ieQzg2ic1CwgjGEggsZMpuBw/Iz8DrHIekdvQ8vai5TaOm+7zL?=
 =?us-ascii?Q?hNGlqKkCn5eJhQMuESf2uUmZJrgMXguaJau7a4k9gTuwjjF+akoRar8gtwzv?=
 =?us-ascii?Q?8Y71N8UXe2p1/493YxAm/H5YYNLp2hM/82SUuBKrJVbUD8Y7xpouhk30jtK+?=
 =?us-ascii?Q?FDFvAwLeE8rtBAwLN3vPkS5LRnRknmDoa7ERLPMtBfnmRsfQ9MVXHTilcao7?=
 =?us-ascii?Q?xtNySD/rvG+N2YGjXftI/x3Kbj/HnRI0dtz00CoAA2iNmG5zGyyl9b5I/M5d?=
 =?us-ascii?Q?COk6b8OFIdhMr4thz2NVW8j9dkKZjg1jasR6NZlpPWuxMs8WLnwP8pD/Uw7v?=
 =?us-ascii?Q?n/kMfni3wbs9zm3+1DJiTqsPloAkffUdGc++y/10rrAw3UynlRjqf9QWvJfd?=
 =?us-ascii?Q?LAuKS7woII/tUgbGMjQpDSYNaf7m9MHTw36Y/ZZilN1gn5m0kk4JFK0MxpEo?=
 =?us-ascii?Q?VmLPR7KhDWlLbRQ0Mt8gngqwRsGEMkFvigtJaCbibPRTvc+44g3ARv3LkeTF?=
 =?us-ascii?Q?k4/I4tZCUwTTzX/3QmD1o0PFRIwnBVq1ipBYXZU/W5vtOQLslhDft/zPX2bB?=
 =?us-ascii?Q?JWWV1wgU3hxknqL1jQNBZ6/xZ+qXGj0WOM6WYAhNmaBmYZt2C45a/fwn6Vgc?=
 =?us-ascii?Q?g6tFmqWHw80yUves05dt92uI3sfr6UlhOeBCCjK7/JJWmFwv1L0aWr2lfHma?=
 =?us-ascii?Q?NhbKSVAhXX5XDTa4DGkAJ4GDXmWWGJtpf8t0wDC/2LGHBAhwuenaIY1AJzvE?=
 =?us-ascii?Q?gajIs+FJNSDL4zRVZzYYYmtJjRADcps223VDUni0peH+tCTe2nhFyaI+Ra52?=
 =?us-ascii?Q?noa+LdNEBR4XW+skSMzwuuxCeQbUHAXYgAALQLhNBWXgV91mR/P6f4CmkvKn?=
 =?us-ascii?Q?LXeiw7AbDnWVG0P5+wmhsV3uIxnagyy4uf96O9aJf5MkGS9K2ZyzAxVZhA2q?=
 =?us-ascii?Q?w6pRkq94bCXYL99vBZYWiP9S9NApbBD3Gp7aqxNPmM40v+jcBqNC6kdSlcLl?=
 =?us-ascii?Q?pV2iXruZmhtlFBcX5A3T14UBfPmK1P5r29I1rD+r1YkyDKRqGyYMR8UW+5o0?=
 =?us-ascii?Q?O3K4Azxcl5k01LsSYb8v/o81qx7TAL7DzSfWBbOmtHwQgEwWRF+OKEMqJdfT?=
 =?us-ascii?Q?pzfsQlfRetwhleIZUQK9e5oPumJh102hETHGgVDtihzjRu32YIZtFl/s5iRn?=
 =?us-ascii?Q?cB+R5pgr2E450idWhzSVUuc69/ebYqqX6tcSM6CPrvurg7F/xts2aIZYTIFl?=
 =?us-ascii?Q?RWEsPtwZ8INOBQFWjymIg4InAPXSZl+71skJ1mBqSaGqwXB6/Qy+rRIpSRdG?=
 =?us-ascii?Q?VhS53Jjqy1wAEPEJqcjSKU/3dpsehptiQfAc7k80L5wPbMELAmCITPt37JqQ?=
 =?us-ascii?Q?HTYU6Ye7Lb4SOq/1zUO4lkf6RfqT/bAWrqvH5yPq0cqcBD8f4YV4KjHM+WO+?=
 =?us-ascii?Q?T2JEBltebnZqnN/A+LXbg/eoPZo1xz7Gbu38qwsjvEAcj7I+zL2BvkBDZDXH?=
 =?us-ascii?Q?QcWiOC2FIpoE2ol7wdNMsWJ7ibFjI7p77Pd8gDYxH/e28yhVhjzRknzq9prW?=
 =?us-ascii?Q?53sX3lNJQIApTJ3tjTPzOpjcEWo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3c5757-bad2-430e-1593-08da017e31fd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:37:54.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IE/A0PRQCMV0ow0cqF98bRjK76ki2jJlWSjhsm+d+fOmKLc+xbPlN9Xsd4wQPiRyjIv9yA7/cip497uqhpQd2OKTzK8V6iB/FxvAfcTMb3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3259
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=754 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090019
X-Proofpoint-GUID: -pVqNaqTaPU_DAXMfHEyGGEgkmOtUG1R
X-Proofpoint-ORIG-GUID: -pVqNaqTaPU_DAXMfHEyGGEgkmOtUG1R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Driver has to do a 4gb boundary check using the pool's dma address
> instead of using a virtual address.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
