Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D37C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7FE61004
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbhHFDM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:12:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55936 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhHFDMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:12:55 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763B4aD008668;
        Fri, 6 Aug 2021 03:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mLtDPVuATn2J4l8MFfCWAKM8S8ogHsq8O2rglMLdmRw=;
 b=tBMJ7IM2emfdP0S+8zvP4zN5tbc4kdYRiZ3BkhxxUGezTzC2XrCC0EgjyWA7Cst8kHJI
 r9ZnSOUpHARpIpuh/rKznLIfalLoSFwSeBqqMaZ3JklNiprzXMOb85YA5752Cp+AkO9C
 C0VYIj1oKIe99M1BxPuKLVq+5nOZfwVxmzPS0S6muUNMF1zDRs/CeVJYc8/vxMEs34Oa
 OCArqO77RHRrCkOhGw6+HDsFplrK/rWCWaMwS9blHbtw2v8vQMAr+c/RWH43jJegS+wZ
 8uZAlrlcfqQ+t14Wbqoo4yepLt0idnlCk7ojaW1dSOPAr6vQ4D7YJFzCtCOU3+OSLfgF Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mLtDPVuATn2J4l8MFfCWAKM8S8ogHsq8O2rglMLdmRw=;
 b=NZay6grxG2KFnKuB4uQ6wteYX6Mkbrbc7odSweX7x3hRG6/KQnsN7DyaucnfezlK6dkz
 TWt7dbMHNdjG1PR7EgUN2dQeI0IY3NCxGeFuMoYhS2OsbOqugRHKf9nfkjGl5IRsDVsE
 Kk1OgQDG/GNCAwb1f3KL5rVSVgthwPGxwpqMxoltt/aTQQZ70JYOU3pp4xvmIM9zeE+p
 N0ml+Fou3qiAetOpNA6+1ER5RGDMH5/I26uu5T1HnO4HzyO6ACdVi5Sr8nQ4gSIduzwA
 cPculjHPsIynJKpvNEiLiLKywVA8hbi8oXcBUhNMrkv4F3yIrwQeAOagx8sL6TLuTA2T Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubu2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:12:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17639YKd175057;
        Fri, 6 Aug 2021 03:12:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 3a5ga1e6uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:12:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXphdlBb9xkXErOxfXN3nHFwbDBhokicgIvgtFAfLNwGe0KNFHe/aFQMkTxhWtHT+Igq8DpE9fASOLMH5qRqwQfxlm8ezyk0D1wg5V8642aNB1K9/jcKy0l+kEBYGMR6X2L1lQFT0XS2TnS73NIUScqvWeh72zRG3v5ohAweZj06eqr8CrqG6DqqOUr2x9CqBuCKe71E4rAvf8Hbz+jCLvEJ2sqLS9JzLLgXJqoaauuOnL0+QWhDWF1KmhpbM8oqoAPbRdNfTMp0zg2SLH4jnGo1JuQXl1pUkWmfI9ep7Jtr5G7sNvoQLyY9iW57vm1EJbgNL5/OJRCxClAEObKA3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLtDPVuATn2J4l8MFfCWAKM8S8ogHsq8O2rglMLdmRw=;
 b=ZvTNBLY2Kx+CaY71WIrTUvfUTCurs/ErOfl7u83xW+fjR62DYNFlt2VpPqL5HGTws8o8/5D2I/7L1X8kyeksJNGjKxblLCxrOHE/OFCNB1eojxDqxvKAhw02M7vBGxFyzl8Lkbe6VcGt1L1zmqK3pNIuLnXVSkQf+LzJ4P0jOZihlGjUuOinxAHHumbmYlKFTbPcHSGv29SIUTreM+Afpw9zco2qRYTCU7hL6jGUMlFzgnw+7o+6YB2qyf5f02HxiRsIJ4lSF9wkgKK9Ow5mo574UsUYBVYvgiamTZjYj98jD561+EM0MrWRWcRELnskhhy9Za1RNcLyDSVim7ZPXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLtDPVuATn2J4l8MFfCWAKM8S8ogHsq8O2rglMLdmRw=;
 b=gYv59H++pVQ06LlwsDSP3OnUT67H8ZSrpe2f0HQytT8FjmtokI4VqGlHGP9ZNnBksBj+o5FZ7Uf5jGlo+oUa0TaAwCzzk6NP5vw4ln+tu8D75pNRQ3me1dmXa14aQbiHps4c7851NUYixCi4Y2bJIAV0FjcL2z3bXsyxfbqLBno=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 6 Aug
 2021 03:12:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:12:35 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix use after free in debug code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmurfeqt.fsf@ca-mkp.ca.oracle.com>
References: <20210803155625.GA22735@kili>
Date:   Thu, 05 Aug 2021 23:12:32 -0400
In-Reply-To: <20210803155625.GA22735@kili> (Dan Carpenter's message of "Tue, 3
        Aug 2021 18:56:25 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0342.namprd03.prod.outlook.com (2603:10b6:a03:39c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 03:12:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cc49e7f-98bb-4016-c6d7-08d958880985
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4647133F34AD6DB411E6D1058EF39@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0oZErYtbQJje3QoNTHg3P3V5YE3FyLMKuVxLCCRlCqgYbHDluoXZgw0c0Gam62tF1i5A/G1LXFZLmWkUIDq5OJYR3BmOuNVPdi6fjIpyXJWm7mgmS8AQw46CJiYmbpD6QfuT4ebDPCkX5Lmu1fkxQ7S2q+GBy2QdH8TFzLTh9wz8QwXbQDUOwPfT4b2eBswT34MSWK4dPzeBvPVwqavOGaGxtGgdbYZ2I4fI9Zpjp9jQhJLc1PgUfiJF0ML5GA2xs12j9pizzM4zj3I/Wlc3hh94id6snfBwc5uk24EU0tCFXIheu55JBTW0GP8GoDqVJxDGD/EvU0KvPwcQqc3Q9FFWHynpIGGw2zeD0iwzLFPX/sZXZ2WZYB+yBbVwzxx/Ol+07KCIwHWQACuNsUyIBBq/2mAgl+CyAoMfu0zpoKpCiI24Fs6/pkWytOIfVcVBjCmu3ZBkQo/IEsp5RNQ+aDsGdFzAZhhh4auma4xGAAeqHvi871HIk3UIX3qeujwUIqar96e2arkCf9DZrsLrL7OE2KgpHTZF5lYsRo0nbOdujw7Dfp3fJbM7xCjHnymrMVrxc0gnnpZVVX/ON98ceY+SHsYyMoHNqThjx6erQOR/GFuZR5nATKojqb8Qi/Mq1EgaUOZg1f5VYxNgEhQLFC9Trx2FNMnzXgfS4/sb+R9BhTY2OleeNLD1lZsSsA0jSVkUI8iopslprTzEd4gwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(38350700002)(478600001)(8936002)(4326008)(86362001)(956004)(52116002)(6862004)(7696005)(55016002)(2906002)(8676002)(36916002)(54906003)(38100700002)(5660300002)(26005)(186003)(6636002)(83380400001)(66476007)(316002)(66556008)(66946007)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmRSTApVMeHD2+12g143qaadjzV+24XqNJn57NCVSe8tenvQsEmXkaKlazs9?=
 =?us-ascii?Q?ylGKAOhpBtATX11lNfwGbC6bc4/jyvAHvAgguEprR7SfYkS1EYucmlXR/RBk?=
 =?us-ascii?Q?4oljEAq+ULx3rzaEsKoDaWWNE6hzeEOCJj1y3HvhVNfELGwLdncqjlUJRo1Q?=
 =?us-ascii?Q?hirIvHQOErNluvNRVUUrsTqijVueKbp55LVYRLjeCyFhwXI1DPtXO6+aBrkn?=
 =?us-ascii?Q?hSQKZ4CQ3lyQrWxok/IU71BJcoeqMmOakkpYIuiPwnm+yrLbrNGNmYnz0kaV?=
 =?us-ascii?Q?vFhecQHSORdsZ7p7Sl0NQXJRqN6s8BVuq3MC/dxA9l4VKi/gz4D4zBh7r+Wh?=
 =?us-ascii?Q?mg9hc2uWzhpij6Pkwpf+RSu+XtzbGPPY1gMTs2kDaHnicGD9oYity7kLyc61?=
 =?us-ascii?Q?psYPCyMFOmfYnelJtpNiRBZiapE7s+UlPLGcbq8gBlRE08a3G9X6ZSRPkV+4?=
 =?us-ascii?Q?1q2ydN6Y+9sdsm0WbSt5Zm2dbneWXYKfEtBnRRqPO4x+8nGyqd35E/o/p8oS?=
 =?us-ascii?Q?qmADizWFWsiITiPRy3oC8adQCgzZE1ZqE4Jy3LpXqdGO02qN6QnbJTLvEMIC?=
 =?us-ascii?Q?0NLExHTQ84RNfDITLH6jilz+zkELbPQeScBdkYf+FjX2e+cNe1A1VoCSJxoq?=
 =?us-ascii?Q?GvPGM5C0nWWQFUkmsDYFFyvL+Q7aEBGdKwTn1KKbuWnsJTp3Nuj8gHsacRXC?=
 =?us-ascii?Q?dzNkIdteinbPwmGyPkfI0QpsxkJhxoRl13tNDrT7Nx9/4BvMEQj1cmQSxFPG?=
 =?us-ascii?Q?/jUaZRQ0atJlpMnXwv7TRpXvnL5KKnQSNs3bzLx+GvMOACC7xWkkZNP6HxGf?=
 =?us-ascii?Q?wEUceQAgaATAisLA6v/8PcVB+XT49U9esqUbrFPh2UagIYSIamsVZUgXRj9i?=
 =?us-ascii?Q?iovV3e9s7gQxylsZKw1Ce+axHEiAbhSL/9LtQNwJCX8aPoidg7Qtwde1wU8H?=
 =?us-ascii?Q?s2tdN8R+BtfgQGkNCU2DwyamJJ3N20kVSwDGyPgPLcwyZIUAxUT/n0JfCZ+n?=
 =?us-ascii?Q?sev4hIWWRywxSvjKHvGTB0vpU1nXal/fE5SbBry7akROjrj7XxJJVV6rCzZb?=
 =?us-ascii?Q?c9HgZyjohC+vUvM0smYIrvVUp7D7XrntQv5LPrxEP/bbopzk3Ogn0KcviDdl?=
 =?us-ascii?Q?1KgSaaF5GakaD3lcNyMoeWTsM0IGBCRGrifBeh62lPxZmpTn+COcW0fpz8Bw?=
 =?us-ascii?Q?WQFWuL0rQiTLnmYep7PyoPo+7KOc50X4FyaK8eZqi39BizSHcMPLlriLgRnt?=
 =?us-ascii?Q?FnoVxLYa1j+DL+cW1gI1trLHBb9urhsCc2+cO8leIU4m2i6QONDjeW5JG0DY?=
 =?us-ascii?Q?MAYLmn/l6g/NQB9qvc7r2+K9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc49e7f-98bb-4016-c6d7-08d958880985
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:12:34.9498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7rntQ+Pc99jbLc1NHuzXScxkmyVhFWkhbeZGJCqEbLEWEPPmQrlzCSQmOnH5GH6JLtK6AcYkofpuixZNpsMAvR97G4p/rJmh5ReuFMZg18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=810 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060018
X-Proofpoint-GUID: UAW_F0dvEJg0mJeBcZDCskncIBVqSJgM
X-Proofpoint-ORIG-GUID: UAW_F0dvEJg0mJeBcZDCskncIBVqSJgM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The sp->free(sp); call frees "sp" and then the debug code dereferences
> it on the next line.  Swap the order.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
