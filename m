Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E4FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC3F61206
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhHXDXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:23:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13154 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhHXDXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:23:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xGh8012096;
        Tue, 24 Aug 2021 03:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4Pj9cLkwA9MkdEoDPHHjz6MMMQzD1pRcQlWk4Zye07I=;
 b=khqlXvKuue4Xw0jI+IL1VXoouubu9lABkmJ698RSkusT0cOBDzBEaVldmAfvcd5TazIK
 AbpHRFXuIVpwRJqeF9qVDqo7RCITW82rqxqGDZ+eSi9iLO/oGgPvlcyI+kqYHIVp5yEc
 Vs+IvgEkL8zGy6nB/nciuSw+D9rBL9MIWjkSzP5WZ16Ey2bFJjmd+xuZh7Eb1motH7O/
 idzEux5a9XeSeVoyHlWLzwM37eVFtf2PtVdjVutQUVDT5IDIygLDMLwFLYj5Xsb6A+sg
 2BRl0sGkDUboci8TNEmu9mv4+sjoRxU0sxUwf7PGEXEGVCLl4m0n5Ayj0mYdXXgoYm3V TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=4Pj9cLkwA9MkdEoDPHHjz6MMMQzD1pRcQlWk4Zye07I=;
 b=z0N8v3rPV1v73xZ559rzLoBqkJoDZ2FEpe5sbrAVcvcZakiVgxwnvUYd6kHzwPXRFtIi
 9PLHbcM74IXQegzSbgwi1oH5H4+sKORxs26GfOX2gzcYluTcCm+OsC/rvlyilnGh0Ovh
 4vxW17ryN7CJQAlp5NuEf1HLo2soD0Myia6sO3mzyM1stB2kX+gJWUCd8zCAWNzGk8cS
 /0k+DT96HVn+fD+mGPsI+gUH0R08X1zfSPdmGXtpCzBalyhuIC1/0rqlEBWoBBEH/QSr
 P8Kb++1mrobWvjUhEkTOt3Ft0hPBf/MO4EzvNor6ZqN0AIo3CFohocYsfiCV7IyEUR/r GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akw7nb6m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:22:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BBRS132788;
        Tue, 24 Aug 2021 03:22:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 3ajsa4ftrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:22:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB2Je8fR8v2aDpO9vXlDwAGu82T2TkxwMMVJV1uwbvnqn8bt4EPo8O321pewtSRbB47moBYwU8hsJ0S8k/zIBx0YWxCrJiZziEdIy8CyGOaTH649Ui4rNITcSxlEFjMBUmP7Ut9K97smggqcQSNv0M7EoRlfruY5yhvMQRZZbTJ6dCl48dDdxFglaBWZtzTTG6NPIj6CFN+Z2gX/n6yDNdl7mkgA6oBaBIOzn0RoxqD89f1ax8BhVU3SUCfOlO6svIL6yy1987EDoEyLoBEjyoDWR3mvLCzCWomJyjIvItrtjYFtDQ1vcHVI3wuLHPQ/9jEA1fBD7DUBhydZlX+pjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pj9cLkwA9MkdEoDPHHjz6MMMQzD1pRcQlWk4Zye07I=;
 b=DNpaq+/Ye5COC7LS+5vo20F8MfIC22rfJjaviLrKegdYcBRqFPC8d15VckeHkttjjNA9/XcaESoQG7IyT2NJyegLTk6+ZXNur0wRptvpDE8zGRrEIfN0MVNGl6e6OrZ3xPSeWOVcTeaJFw0IryLxcH6KJzFtmFn9uaD9wIlwupCQCySqRgk1NOdDySrZzzhVve5a7PI9jx42LIwTv/fqoXfN0IR8CDTl1lZLBsiyIR8UZgApEYi3VX2QPwx6BsOODPy8O4BHIMCg47JV5szkEUNN6sBbvOrxl6cT5/gFpywr3hAEdKFX/O0F+fqA52BYDgSeOUoY9Fkpk7kl1uTkjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pj9cLkwA9MkdEoDPHHjz6MMMQzD1pRcQlWk4Zye07I=;
 b=sr2Bk6wEVuvbMh59YekIrho1+f/Do/dSaNetaH+RcoznvFm8xvcsdwCCC2YkEjHVmi5pNiQsH7GXjoPUeVc6BIDQWA8GBbRCI77BAD1SaO3TBV4IjWRzvaUZ4Xrw3tlJ8/WVP+u7x1OUsaAkA9Cof355bB9Ik31MWemz1uFM9fg=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:22:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:22:18 +0000
To:     Keoseong Park <keosung.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: ufshpb: Fix possible memory leak
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfyzedd0.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210823090714epcms2p1e414fdd91582bdbf8170b4cefb8a0f74@epcms2p1>
        <1891546521.01629711601304.JavaMail.epsvc@epcpadp3>
Date:   Mon, 23 Aug 2021 23:22:14 -0400
In-Reply-To: <1891546521.01629711601304.JavaMail.epsvc@epcpadp3> (Keoseong
        Park's message of "Mon, 23 Aug 2021 18:07:14 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:22:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dea0f4a-adc5-4566-7b6e-08d966ae606c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB456646CEBB7B529FEDEE5C8E8EC59@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDn9LtuD5CSCmgwA1SkXyiWDEf6ccFNUyUM3AnrmjH9A5tBDE/9T2c4zrrFgtph9yvoCAVMtOr49Ur8quicBBMOZ6DW4rYmQjJEf4DJ7rYgAIocXTwmS5+j5vJRt4OifqkPJjK6+s4Ol8lD1U3IuID/gdPhc5t68oinTxYftL7h1VwnI9Rb9WtVLZg2YdZN55OiIu2yoSwY96xJxHUFTWHtSc8RM0gqHAY62UzT5ANJvN0GTF8oQwF3VkAKcIyQU/j5+6G+ck5nCldjaqFimJUvfVU1qxD62+xHeTioDWiyWy3EOWAB+26xVhhXo7qOzZe21SYJAm+fx/eRM3x9YE1FWL0PtKkylsKVWDiMV9DEcK7/HBkM415ZARSis2bwQMOyPUseDg7dAQLlNpne+r6bVMQ5k0lIF0NIXeM/MFYrDTl8d3PTzf0Mhc1LGW3iI/LJZI7Y6UV9yEsVIoNl5VxCGORnH2Ro2R1LwjCcLNVAZGYZ7YcQz9pke1PlvgGxSrS4mYpIh1bLDTmwGaJbtgOE8KHLbEVYA81scfg0LgyqCQO41MxDYbdQcupAsDkHKOUAB2mzWw/sBNgcq7P/H5Lvjodo95/5+5URCam8gCZ5zhm7J9by/niHFu6FlNKYkB8UYvCJ73PfzZLRQGpSIVrh/9Pc+cUtdamGf94R0FLVIAKgDciVffsrVLT73A2sUiiMJEH0o02W5/9mYqGe3Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(66556008)(38100700002)(55016002)(66476007)(52116002)(38350700002)(5660300002)(26005)(54906003)(4326008)(86362001)(6916009)(8676002)(6666004)(8936002)(7696005)(478600001)(2906002)(186003)(36916002)(66946007)(956004)(316002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOFi+YiCrpcWxa80fOzu3h0ZMszuD6EAMG/bXZFDtdPF68zRI6ed9wVTEoYB?=
 =?us-ascii?Q?16cV+X0vC08t1jIiCknXfixMj6WpR59JH0bKArOsoUUfeFjHrVShqvtMYJ3t?=
 =?us-ascii?Q?xI9pYLnWVInjiTiy3oA1WUGBSxAHoBkoF9Zp3ePX5EU+6JP77r7plShPtTla?=
 =?us-ascii?Q?LcKuT1TSvwR2bCJilIxuT0xOWV7m7wLVRaNSHQb0W1yBIgIoFsKp/+Nkx+9r?=
 =?us-ascii?Q?mJOXaATjyPn6iS0qI9nMTTwrZuXdi3ylUDAdaWyLctfJCIN/zlSXUExvudp8?=
 =?us-ascii?Q?gl9jAzNkE4FDVs7JQov4aEEvx6iFrS5KksAedSVSU5OW47I9Jv6uS47kD5QF?=
 =?us-ascii?Q?dPHJZ7MUAnJmU4HlGGaX8Ybju0K4blp8TqeGWcJh99q3CK1e3hlKY7Xi3T/n?=
 =?us-ascii?Q?Bxz7iMO9OJ6tGh2AMPU22Dj23qF6PWVyfA8w0mp5eWoXYOaLnRSwl8nVAcRy?=
 =?us-ascii?Q?Ongb9h4NEmKc8gJuC1QJ6/KbmsgmfT0EL25gPHWsFwezxWvYQ4UvSvUb4jlB?=
 =?us-ascii?Q?nyZl2DWjYcJlFvmQYun+upGQq21kYTZKFPJ8JWuBGU1LL9/xYOGygO9rvJUH?=
 =?us-ascii?Q?817x3XIf1nIj1g+vJP2C/sWJ4NwdKaNf+vAZl7MbgukSqpBLb6LrIm93FC6W?=
 =?us-ascii?Q?R6+pbzVpVrYay3ga7RpQkOHTg3T4DcgJMXxY1i2NrZ/tH8CP7nJMaqJB3z/t?=
 =?us-ascii?Q?hNyzKhkY32bF2i84moBGa9wSk8iZ7NlPVr59r20cjJ7mneDX80rOlkr4BLiN?=
 =?us-ascii?Q?aeas+jOBdx11cGhU+I1Z4V1re6Gx2IYzJ9EkKYY2KAZTzNiCDNIOt2cCLosK?=
 =?us-ascii?Q?svINRsnpKbEX0KpESN0scFGFyl6LgIMYWYZuD4mijyhi4HCHmepCudeQJPAK?=
 =?us-ascii?Q?psARq539dqhQBCEG3PL2cswNLQUgQS0M1qtoDEzUkp2ucy69jlccufHfYbcf?=
 =?us-ascii?Q?gSwi84FWYft7nJG2IcSyI2wjA4oyvU9YVVAmp06p1tboOJ19gCqIm/iKlIMy?=
 =?us-ascii?Q?7KFxiO8mlTowRphgHmv2u0lKrtrN8TVwkTcZNQyo7tMUEmARaG3DkkmYYLVh?=
 =?us-ascii?Q?Bm/tAxh+QL1Ho+bIrtkh3v6FdDfw41UQ2mJBzora3GKdCvudKGQpLgKCf1lU?=
 =?us-ascii?Q?Zqg8WyFz0aOomGq2N2ar4kNz36/b6tjTtgF4HP1UPn0pp0+QmrN7ev4LzrkP?=
 =?us-ascii?Q?QSiYnAR2ijtRaFKfrR7v/lqDec7xmjXY5yBBlEaIfvSTMcciYaDl/AVlbiLY?=
 =?us-ascii?Q?Fo9fD4hn+Id97qnZirwccKPs0YuRAvs6ao64/T1/86r30dgr3mIum9C8LG39?=
 =?us-ascii?Q?bEPSTLRkEUc4I/XXEL19A5C0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dea0f4a-adc5-4566-7b6e-08d966ae606c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:22:17.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5RjUkfnt8HuHAVwPBDcHazbNJ3kslXoxxCpvgrZydt5PP1bdzOxkZ3Yr9Zx0PPtQh5n4n5xBRK9pv6FN9IQnqKEvS3HMlx9sWkVRt+fKN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=906 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240019
X-Proofpoint-GUID: Xub-szSR7IwT_IW-I5UQetpMfUZzN9EZ
X-Proofpoint-ORIG-GUID: Xub-szSR7IwT_IW-I5UQetpMfUZzN9EZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keoseong,

> When HPB pinned region exists and mctx allocation for this region
> fails, memory leak is possible because memory is not released for the
> subregion table of the current region.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
