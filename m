Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2B9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F3360F6F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhHJDOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:14:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12306 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233987AbhHJDOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:14:00 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3B4U0014820;
        Tue, 10 Aug 2021 03:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=79Xger1gdRgWqQSoiSVpBufrFQxbMvR+4DyqFaWIP1U=;
 b=0b5fX5JoY2mvUpwtEe6RhA1Gl9xd0F1BMA5iQs8jQBdVZrty7wDdnaqbtn92NsMeKxyJ
 8mT1o2uQ3cKeCOBtl28d55iE/gxcLcabrbQN0DSC7+wZaTvXCcMmATt6IYBqg0mlcKGm
 o969uD8ZQ8D+PVBM6vFPsp6ZvaNbCjBUJAeW1ZzO8G5rLjrFKW2Y8VvuCAX6+1Tj/yHP
 DrbKvzUfdADCPjeWJpIKEPWwr91f8d77+D48g17puzMn6AG4TzoeI3ER93yOZ96aYz2e
 uxvI4FWXvcCKclBxzVScpLAlzHROotfA9DrRblNEczgyGoe7fFYUUquzXOMBnB/esd67 vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=79Xger1gdRgWqQSoiSVpBufrFQxbMvR+4DyqFaWIP1U=;
 b=dN/QzC7DVkgVysArI0SeDVGblgo6xEp6fq/yh3ZFGxkORtoARviatt6eneKqndRHJr2E
 BvbA+BJ3xkTFiftl6KqQY/zUMb82e1lP6AMfaMme09wdjXGgerQfl85Ye8lhQD+zmOzT
 Nyczm0+QwapC8UAOYLaUf0RXTcVIJlgDk/zfErSAYloXA7YkN4sBuw1k5ceA0SMAFUtP
 I9KcXq6nGAkQbfqUdkZXIrIpa8KsyvIxivpVZLnLLsI5/wmTgDVjuaQULmtRVwcT+/z6
 2Zq2kxtSn1nLE+XrDwpuXMftFjn8s0AEMcQcfvo8JXeULPhKiHdGmu0J369TkAqjhDkC qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmutuqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:13:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3DIA0022577;
        Tue, 10 Aug 2021 03:13:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3a9vv3xq5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUNbulKyN25gaQqftGeolu1tVhbeWGESyX2NjHWUABrb0tKrPCpHo0C1nyYfBFsz6lpZF9GTMRSsMMR5pf+aJfALGJ8X9OQT9UqST1lKSTdAHiXtAwEK5xwLjSoDiWt1A74qxN+UQDwsvFOw5vVZOjIPfZIhP+fvLN8B3eQeMMd7v2g/jLDNYy/cRoPXl2+Q8DbzB7mOTkjl9tr6wIl3gWGAFyUh4COVfDnQhavizaFOTGsG2qcNqzcu0jv5/iAe9/rem5fTQ21hvZWjJnBMwKTKVf+Kv1CXil8VJ84iKa2S3TZV+MyyZf/VAKZbrXSa278RvG6qJpJNxfCuLWev2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79Xger1gdRgWqQSoiSVpBufrFQxbMvR+4DyqFaWIP1U=;
 b=NGjoya8j58bsuvh+X0h3i3OvQEH4Il7l+rouPxfzHap2672VMauwliXfcTDI91Ig6ExSLs1zfAJgiLWtUlnvMUxKrsF/wue0+HTyvI/4VllpGIYDBPjhcaJXnzbOgYs8IYiQwzBm/S7T/wzhzeTBj4f3cDAjDuwdh3QC+D3LdBv/moM4ffS6tW9Skcw+yRGxV0fZUdURgK7J2aTHJSwL5tpbluhvAcWPGfAGhuy6irtIfmZ1YNTWzZdYSik/VzXDmjSSo07QCzPYw6ptfGDuyiREzOoOUt6FPbFDFYNQGW1WvAK3kXoc1fHR73mTDKdv5gSnaTUjwWbbHiSo97GzXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79Xger1gdRgWqQSoiSVpBufrFQxbMvR+4DyqFaWIP1U=;
 b=Qcd7aaHmymSyGCwcXUDrXq5FavShmndrbcDh/3/pqSTPJckhgx81Czks8pJkZPEBuOkPl3UzZ78vh3AIeVWcoNbusjs1rBx741a18mAXbrngt6CDf3nELBGEHFJA0bhi/JHv5HQg3kY77p8VD+kmvDbWEmnRPdw19C0g2DBHhwU=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:12:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:12:24 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH 0/2] mpt3sas: Use Firmware Recommended Queue Depth.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dguxabg.fsf@ca-mkp.ca.oracle.com>
References: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
Date:   Mon, 09 Aug 2021 23:12:20 -0400
In-Reply-To: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Mon, 9 Aug 2021 12:56:37 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0071.namprd16.prod.outlook.com
 (2603:10b6:805:ca::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR16CA0071.namprd16.prod.outlook.com (2603:10b6:805:ca::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 03:12:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e93630f-2539-4396-e349-08d95bacaca5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648D17A35273086384E48738EF79@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sia45pBPXcLwEeqq4u5mV6YH/E1Rxv2iapIRHAKTRN8hQOpttZfimOBBO0kmqbQGVm1vAFEI+K96J5ARI00P9o3wFMKwAaxITCeHZr4T/eHkt7PPrjiTJaBWqp9HL/jGGFNSnqatw6Z2P0MxBgQvNP5lhWvLf/eEsGBwSUmDSsoSEceAVVrjbDzmVYHdmEEFUa6mwsHxlHaW/M+rSwNob0nkrBGN4dP0jKaRvfGgzjP29/EWkBi2+JLFmigz8Zo3L9gbF3a2dJXF4I/2EcEscYgP1jP6MM1BAWO3YK2Y/V0F4ruRmyXF70ZG4EB3yh144APRcKWhOzk7p/QBTB+uei/dyMbs7hPpGt+qc2eCp0jcDTCD7uwpRaktNAU6vRK42NJ0P2IurQGoafuTVb1cHDSoHclgdWcfVnx+jJ4+5SBtXF8aI5FyqOpaRdG0iuaHzx8eG+qlJxaqlwZQtLSWsT0VZpAsrY48wsrAhcH3zxEbuPaW3sHDZYozv77A98Az0CzIHB2KjM8/NSM62D3ioeucBrirzYOa2S4ib6ZJSfmvCYtT3jY784Ll0tGdzoHk136c4Uzr+yAXBmxWD9ml9WdyOWNu+9FXylPzPWAJ8SqQod85iYZ7xN7RUTMK3Kh97y6GLqmm1pjgbt5oxAD+o41Lecdd1DkCLCAau+WmdpcDIgmktnCVD0qodLJ26dKXVoBFkhFCE/0wXSNVzziv2H4ht8dZPZeUnajUXVAz9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(366004)(396003)(26005)(8676002)(558084003)(52116002)(7696005)(2906002)(186003)(316002)(6916009)(66476007)(55016002)(66946007)(66556008)(86362001)(478600001)(956004)(4326008)(38350700002)(38100700002)(8936002)(36916002)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1VrQTVK2DnoNDy9O3d4grNwLDu08iXfwgtNT+fBw7qkjbbx8lWkQUoTrtTeQ?=
 =?us-ascii?Q?+ka9t2YzYmoCfKLjD5WF0baBE12mQ0T+KRoyR6QAp46viceI4YfTkjVO13fU?=
 =?us-ascii?Q?s1RGTBU/XcOMpomsIBIHzd26jfWVtOgfIJ/87zazfv+Nq0aqJu0iizmIACZQ?=
 =?us-ascii?Q?FGmCLee02sc9XK7JvqEx40uDt0DOPuxsB8ydrvYiMS47exvDKpzRWogbjCw5?=
 =?us-ascii?Q?UYPWXbVRJmRjytJF4XR73LrYGt0PpcZLccvb3Y9U9Ol7Xt0eIckmDwAunylY?=
 =?us-ascii?Q?KxukCwD6qrSv98buIOi1eiaswRufrPVk50vN7i78u85bxOsfc6YVvqPaP6ZJ?=
 =?us-ascii?Q?ovLiTtkuxm00trqClun97CNOHoxWjHGWRiNvUdE3+awGrj0/8PJR7Od3VTQb?=
 =?us-ascii?Q?CsRhO3zDX/pimHvLauKazRfrmjcv8aO0zKJz80uJXSZZxqJSjBJnEsZ8WWFz?=
 =?us-ascii?Q?lEke72YGVzImasdJbL2wnx1e3dX8hs8vuQfLmndiab1DkE1mNanTV1GQB7ag?=
 =?us-ascii?Q?MoN4T49MN3Ju8//q9kyfjhW336RQcR4qLocHAqTu/TMDGdqKwoOmBISdhcaX?=
 =?us-ascii?Q?C8zt2GPBgkj419lrj+jsBAY/G6mTWUOJljaW86Sljg2MYl11FT5sBFkWxpfl?=
 =?us-ascii?Q?Px+v2kbBW/9GMYgyL00msQpXBrlLqWtysjjClwJbV3jlo9jMbwbocCg9RluA?=
 =?us-ascii?Q?rtQ0tq/awCu0+N0TSsVYU7j1utu3rSMtjB1CXXHBo2uJHJZjmfimDMk6742s?=
 =?us-ascii?Q?qq2IapAUANrfBH5setM2J40oGvBsQtPdY0Dzj5DYeKJWagOrRciDmZJT0IeH?=
 =?us-ascii?Q?woop9mrfZhFBK+Tic3eyZWpHuU++CNjxa20rXJnYWMRY4JYPSKJvW7p2ruGK?=
 =?us-ascii?Q?R1mYzsd+EwSpzv/qvvzTys+zhZhdYZ7pIUEoUjXzs0Juo4OUKNKFqOWTSwxk?=
 =?us-ascii?Q?FD7nwqDu5QDNuej8kUteKkeGqXKvJf6rCotQXktLNh6bTOM96Dckl3fwuE8+?=
 =?us-ascii?Q?2Bvuc2b3266BvYU17lLIsRvAEzPD/ww08jefDefTHS4t9I5xGgFU4covBccX?=
 =?us-ascii?Q?GfkVS+YofzqxtbEEazWi7hQgAM8w5M8gSkxKUmqq1yGm1d0jK62eCPYW4HDT?=
 =?us-ascii?Q?LDOnryi9RVy1iPvVHLb6b36KSlI0GNgJ/60ZCvko5+moZSaDe4TNYeOtVVqw?=
 =?us-ascii?Q?9j4jZc8S2riVu5XY57uirGtUeSDsUDKltQS3TvNjAZTWHk6Xoe4kAohbcq8C?=
 =?us-ascii?Q?R4V6nbLhpNC3mMvJ3PfeKBQxWl/aIbsfWgE0Zlsm/8rii06IpK0ifZJhpneL?=
 =?us-ascii?Q?oADEYlPp8F6sPw/4SDr1qK9w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e93630f-2539-4396-e349-08d95bacaca5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:12:24.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/elnmyGqETqYIqRfE+YEWH1w9Y/oH8MHleFMVHEYBFZx9EOxW/Cowscwc/IAPldAMbAhtVcDuMFZMTFqcDciDIcZQzP9fLsaz6Mj3c6Ztc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=916 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100019
X-Proofpoint-GUID: xA886ngX7wBO8m7-TdseTisW0NK7rw6A
X-Proofpoint-ORIG-GUID: xA886ngX7wBO8m7-TdseTisW0NK7rw6A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> Currently mpt3sas driver sets below predefined queue depth for the
> SAS/SATA/NVMe drives. 
> SAS	-  254
> SATA	-  32
> NVME	-  128

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
