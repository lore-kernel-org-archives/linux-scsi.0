Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41D6C07E95
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 03:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65F661CD8
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 03:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhGHDZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 23:25:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54492 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhGHDZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 23:25:49 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1683CO2R001356;
        Thu, 8 Jul 2021 03:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kHUuN4IBPeipx9yBpr2+KpKXZYOwVID7LJShqH9L06Q=;
 b=vFQyU+GNqJ98qNKJwQ8V6SyXM2oPwSq+8QH1NKS0+NSQ6lTTo+fZ+RAOw7oRl0PH8hzh
 QZqfLDe10dDxmjqowKqvRYAg8PpwmDsCFcgswZJaMje+mn28mP2SG93aTH+qZZV1i52a
 jSsF6DyKU0OaBgNgnLI5dQdFqzVcBdFuQGROZOZLba+jsTwGMKUag65V8fqyt70o/Zjo
 SNbLsP9mAAAXiNlCamEXfHMuJYG99kwMg51KRstXTk/zjMZZ99k0mDUALhfVSl4PsPoc
 4/OiCdv0n2QVaZAzJ14fj0sc2DgGDoTYMV4R7L6bZWzHFu4Q8Tek7L48TErtQZtFbBsc og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nphgg5fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 03:23:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1683AXdq107069;
        Thu, 8 Jul 2021 03:23:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 39nbg3aqaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 03:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIfgWDSO4OhXFJ7x2OempY5d70FkJCflRm3TZ0U9whLB+So0P5BQvzDOaJwYrL3ZmYRT/xfRpgXWFrkFdQLWtv7UsUv8CaQeKgEjQHqJn3l8Pb87DNN75YD+GddK7oVmv32f6Dls4GF2PCZJ2fcxvly/CRaPwNG0wqa6tQEH+mEjnOUdwBlk7itVeSrTm5tEtlSKMGMCnDFUTwkNBLlcxsV5H8UL5i4sDmFBtNvG8G0Kj5CVkLXXxq3lffrCkMep7QSAOy/AhX8w8mYvNowykh0eGHJqt8BU2v3Szi/Hd6S3rsP5mV0TlcVl5o5VB53C9pa2VJDvLefL/g0D8wK4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHUuN4IBPeipx9yBpr2+KpKXZYOwVID7LJShqH9L06Q=;
 b=LUXDM4YwgUc0pSqXBSF32Y9Gny75j4Li95o6DwDRpzWrrK89niMr7pGzIkAqcGvdbK/JJZDeKkidksANL9nzULatrAQs6tFl/0VEUbH3qjXVbrvNn+Z1mzFt0dyNHgRjKF4aTE7ev11xB/QcqKbT/Yp85gRiQBKkGs0+mywcTUI2uWL2W5B+Tdp9XE4SvWhN++TenO6Iy9F+XVmEWfDsgAoRXk6xGIao8My6j2oyVkUDlXDPxwtTP2pTjfwlLr6dnGbROD88BqkdvcIFdR+61zirt4ou0IcLOxOf7ZI0w+hTfH5N8HpMJzIsTtdYfQvV4x6/NWNAVw78V2Rb+y4HAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHUuN4IBPeipx9yBpr2+KpKXZYOwVID7LJShqH9L06Q=;
 b=tI+mF6uhi1/t4sdurJRTAB/BjP51Od8GqZFpp3jzSl7rUkif3aoQgy/A0NnAtjaJNxZTtskgCx7KQIkG7bnvy1lJiCbTzNCRIY5Lq4NLaTTCjs5Pozsvc8bFXOqPlms8Cf97j6BJ5SKI4izxZxRmKamj0T0YOPEOQIxj6gUigWI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4790.namprd10.prod.outlook.com (2603:10b6:510:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Thu, 8 Jul
 2021 03:23:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4308.022; Thu, 8 Jul 2021
 03:23:03 +0000
To:     Wang Jianchao <jianchao.wan9@gmail.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: Re: Discard performance regression after "scsi: sd: Remove LBPRZ
 dependency for discards"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmvtbiy2.fsf@ca-mkp.ca.oracle.com>
References: <279cb008-4c92-0535-efdd-6e877bea7349@gmail.com>
Date:   Wed, 07 Jul 2021 23:23:01 -0400
In-Reply-To: <279cb008-4c92-0535-efdd-6e877bea7349@gmail.com> (Wang Jianchao's
        message of "Tue, 6 Jul 2021 11:11:25 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Thu, 8 Jul 2021 03:23:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 004eb20f-8481-4ef8-1c1b-08d941bfb267
X-MS-TrafficTypeDiagnostic: PH0PR10MB4790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4790AA0F8974035EECBB3B388E199@PH0PR10MB4790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUxNeLMP/nauIDPEXOKD7f9Y3uvPZ7imtZOqQzj+kWMstZArlGdS2iJtFTrGc9Xm+7afFTTsDSZHXBHOgxghhDVGpQOOrQiw/OwGtqr8jDTYdiDsEteLZGqawfE/qMDru42jSCOZnE/fdFMoY9s6dUaeLdiOY5NTztc25zPKUMkglMwpH7j6jl+hHFAnZOT2QN/4ZciHYprWaryaZkXV5Msr8lS06OJ3x25se8JiEaCp+S0fa/OxBYO1dG18Ls9iVQ4iNYiJqxpjg4GpCfQUuczQ6d0sm9iK5kJisxgJvg+IZdI9f1GU3q8krVDl064Vav5ttstgTLRUkpntfh85KwH2xvpNj+F/8Cs9PyUYvOccka2BEpm3Xbz8LIeWkuN7IxSiMNrBuQo4OPVe7sELox6WSGtbwIOSwMM0eI5rk5ZOCj4XeR6fYE7VAt0fFV3hOOXZP/H+oFqR1inVQ6/FtUT1ioakLwPOGstpwGFxSDh7622qIWFbQBvG/tdl0Q3KSqT7/UgJfqegiT/y2CDjM+J7Pd85Byq2iS5IvaoNKGLc5QOzbTpkaoa4Bh2pI0HL4M7Hkz+xUPvpSdJ6hYam6olFEmaRpg4kokLh0rZXwnYIEoNpDaPAanImT3iTsGrNFBLZzvwEjZfRsmBKfxlr/ymSCI8lW1+exgNshKKg5cZmdLrwJGOIItSqCJWNUBlRbd5lktl1q+999dICNXEoTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(7696005)(38350700002)(316002)(478600001)(52116002)(8676002)(36916002)(2906002)(86362001)(4744005)(38100700002)(4326008)(956004)(5660300002)(66946007)(8936002)(83380400001)(55016002)(66556008)(26005)(6916009)(66476007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzCUPpaQTxDhju3L5GlNf7WHVn6aue4soQXVEIWdIA9s1JHlzx2IP4Ai9zVa?=
 =?us-ascii?Q?vHbF+qs174mcM/xlwqRXRzU1isT2iMpFoT7GbdkiPdBUyrl3FAk6v6F/3eWN?=
 =?us-ascii?Q?yyrgrccCIVC7L1y1XlH0iS62ft5+ItB1TUMMtk+xLNNaMzZZPGMQwJCck+Pu?=
 =?us-ascii?Q?Jst63LSAYqjDJ9Mb0XeYsFtK23tBBPWqKhlX9FiBzLWxrFISqCKDgzAQ/roB?=
 =?us-ascii?Q?JDm8/PpmY9DK9Sh/GPXdA+gZURLaPC+v0THoiij1u/FXZrbsinK+9emWBbc5?=
 =?us-ascii?Q?W7lo0WSY4Kc3y80LwrMoeaEaJ1og03IsiO9XwRtLQNWPjceQ+dsRvoqipmHe?=
 =?us-ascii?Q?5NnAO0nqDiDbDxdAgm25n24g6+H+TRFY2BWmXFdKqJdfM2rL+ZyGfCVXFsvg?=
 =?us-ascii?Q?yxfQeO/tlqJ1Sn43FkZaQ0ZbgNLtzG5E9bPm/N596a1rtdjXMcpwiYQTGU8u?=
 =?us-ascii?Q?hvep/opdDWvXEfzOe0UnCKLQZBvWW5nJSLYQuiv26OlHvq58wp2lj8PoZtIg?=
 =?us-ascii?Q?uacs6fCSsmKl+KyQhZHXM5OkH3hVvWYca6bMqA56+Vn18cBdTYGT0daauNp6?=
 =?us-ascii?Q?FxZe/eddNSQ/hsXgFTvqdwmgkSoMEAcbbUuw5dnVSj2Z+f1N3nA3k1+TUBU/?=
 =?us-ascii?Q?3CdcHldxCk0WZl3wgoyIvk9tAygEH95MoD3kUJ4KLP/8SHP1iMEUGK4i8zez?=
 =?us-ascii?Q?Qg62jg3IeAyj+x3VLEmp5hmltMTrQbYBuTqDFEuaBWWVWQCB51OHRXOUsS1O?=
 =?us-ascii?Q?cb10/TJFYQ3DOq+TXMxhNKkEcXAt6XjmQXz2kXXhzi8whe1jCZGQKs4ynXhK?=
 =?us-ascii?Q?n9aUNwslJKE/0vmi0CzoSTI2xUDaeCYoffEZZqnLfHk6bILyvR8Aacs9KTv+?=
 =?us-ascii?Q?Aj+ukvsRqeCrKsiJvlWk4Pd6625Xc1sNSJrNE+iaGayFSMq4VYV8LHlkJSCM?=
 =?us-ascii?Q?y0t7orp+mW3B53P8p+U1w26wRTkY94PT4V9mq6Op+vZzuMvmauTnNUzAyJ5b?=
 =?us-ascii?Q?ihQ3H8XjqJUZHkfxXpASe3U98KldpjNSrGG7J4wj80r7Rypnub2N/8T+YYwK?=
 =?us-ascii?Q?U8yt/IiJXnwV2+jWz7UnS75snT0hnJljXFlTymLxKsfxvNPytIqCxDnxAYKk?=
 =?us-ascii?Q?L2Xn3hJAEgxtPmIJtKoGTyYhhkUngB333mLSzI2R91zgxFoAobGcrS+wN8G/?=
 =?us-ascii?Q?x58DnTqt9oJ9XB4JqLcAM3cTJxftIWKKkMaCldLzEEnMbED0itPaXddANZ2f?=
 =?us-ascii?Q?w+ldpafhJNDgWaRtL90WKsifyBRJ7m1tYpXofKB10XP/CvLnP6yuoMv7JMFs?=
 =?us-ascii?Q?Z/oS/DZEobZ3f1q6r01I0pUA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004eb20f-8481-4ef8-1c1b-08d941bfb267
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 03:23:03.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9DpoZ/gCUv8nwkMwskdDWL0h9ZiAgU9L1aPJFEIuqtnaYg87aY8w8zu5N4QEYJFU0pNSE5XXASvwz1aTTjH6ItFgh41+xiCAOwFbDLLlik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4790
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080015
X-Proofpoint-GUID: cRjpbvcs-IIBZ-i6dayJJzVcUt2BcWFs
X-Proofpoint-ORIG-GUID: cRjpbvcs-IIBZ-i6dayJJzVcUt2BcWFs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wang,

> We have a sata ssd with following parameters,
>
>   max_ws_blocks = 0
>   max_unmap_blocks = 262143
>   lbprz = 1
>   lbpu = 1
>   unmap_limit_for_ws = 0

The device is explicitly asking for us to use UNMAP so the older kernel
choosing WRITE SAME(16) was not correct.

I have been working on an update to the discard/zeroing heuristics that
I'll post when 5.15 opens next week. But based on what's reported it by
your device we would still choose UNMAP for discards. LBPRZ only affects
which command we use for zeroing.

-- 
Martin K. Petersen	Oracle Linux Engineering
