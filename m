Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25BCC77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 21:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbjEVVlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 17:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbjEVVll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 17:41:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18804102;
        Mon, 22 May 2023 14:41:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKNrrN021948;
        Mon, 22 May 2023 21:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=8r8J7foxdcRIMGpkkFhHZ4vdX86D2+tqv4WlJIf/UvA=;
 b=Yq4B1lU6eD9FUOQTKneW2WrdWoE9sbWOScwA3B5nQO63uAB3c6lVCwInGjIph3+n+YxN
 zqcgWwXfC7mkFMfdamjantLZJMxe5Pt3pUGBvRn5bOej4P5zkRMTtYyZSZF9HjQBFDlo
 w6ycM0HxPIsgEefn4yI7otuaNM1Qp+A0Q+cYT35kWysYd6oeEdlza4BT+E+ELCvGU/93
 sm7B5bgI86C4O3uPGSHECWNNeEPSkD6MKn6aWjw32ZwLzxA+fb8khrdQCq+CJF4uZu36
 OJTmBRwmifp9eOhr814RDeIusFr++VcDvOikryfSisXQGIQn6Cco7GtuwI9/vbMBdjyx yw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3qkra2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 21:41:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MK0rZj028688;
        Mon, 22 May 2023 21:41:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2q8f4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 21:41:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0EHn2ev98sxI+mbBAk/rXWonfd3I7eHRNK7O37WZ3cWwAbHkqE4EMHwjJiK1PKHCeVAQim5E8uHsPsfd8QIz5Cj8bz5Hja/kcZ6JVoGxOBgUfpxtUfMJzucluvcKBRiznL+eGlnb5zjZmLa2aalDY4Eee8r4kKYoUyIO0zluSiDe9PMEwpviPfFV4UsbMqS88tLgmLVTx4wvZSvfb5pkMlei0xQcr9VBQUyFEqLQoGv4CPV5Ug8Tqw5xC7DGJ2tu/vx5dCNEACvSZg+WrxLWOywe9NkfAedC7VSWIlCxe9FStUvbRJf7GuSYtFsGYT0ExKSqr/CjC+tRQeoCkwnZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8r8J7foxdcRIMGpkkFhHZ4vdX86D2+tqv4WlJIf/UvA=;
 b=iRZr7Z5icjwYXZ6MPQ2TUjcC6yr1NUYBWp7pTiXXjOW2R00+9LP+ae1w0eBcCBqVKtBFNBat+2QBr4c0EpIBfQ/TmQoI1popkwllVzxWHpF+Ckj+ZdAXU7rxn3Y0J4oQsFmOhc41iylMv6LhpvL9cDgSkaEXOozYG8V9rkV04GQv//u2cU/yV/As/7ep/GGDcdascDVh/5JDGty8+KwuJ7PE+r83Sb1WCpFW3SL8+BxmYHlDGIYoILouFYybwVoTX+ZRz5D0S1bE8O8ACHwzps57WCdoSFm3MJXcM+ZYhgmc+CyQT/x+opwlm02LPBZHnbgKhC4Mg0zpLoULYPqNOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r8J7foxdcRIMGpkkFhHZ4vdX86D2+tqv4WlJIf/UvA=;
 b=hw/p4z0jP8or40hgSmglawWEQBlyj/HXWZKcznkbmMEJRyuIwLC7y8cIBqANSA4Nn8iOEPRXh8nB3KSB7bhawOjKArsjcQ9oZmWzS+WejC5ebEvQCiT/NiakFykbPu1hpViXsH7b072JtrA6tqZ9PuavWXUFUXdCxw4fdzE7cj0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5925.namprd10.prod.outlook.com (2603:10b6:8:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 21:41:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 21:41:22 +0000
To:     Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com>
References: <20230511011356.227789-1-nks@flawful.org>
Date:   Mon, 22 May 2023 17:41:19 -0400
In-Reply-To: <20230511011356.227789-1-nks@flawful.org> (Niklas Cassel's
        message of "Thu, 11 May 2023 03:13:33 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 2edab633-7b13-49fb-8390-08db5b0d48dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jSZp9r9Gyk8mGZyHHrbLejHeC64cExc0qMgQCbCzdwmhoFpf/MzLev9l4V9AYUkpbDHvKC5BPpcwCjWKuBsSrG5Tgvf55gjVGWbDQOn9rFgtwgCpN35mrGTGuf7drz9VbudhDI40fCKvDpkcd1ZsGSAVP79WiZzVC5R9j9RKsGKH46mIrO6iVymTm/VOmzh+VLg65c2zOcLunszxHxdRIj0tr5p50pf6h4JD2yB6+hY2MmOb1e+7VjjIc8j94FrHEip03X+NOJ7ZMP0W72ywirusKxvz08ujB7+MyM9/0ima0wh935jHndkw7w6c3JPgh2Km4U5sCrWrxZ/XG4w+leG+IrvlHXPfHPoDmlzE7pM/JaNMZ7Upv27uKSxJEywDIHII5QMK+uRlqiXuI+hRlWMdj/16iCVpriJRxbsCayEVbF7HbbbhrIQHyCHPFVxcSyphjKHj/W9bu+6Dco5ba8dkWSezaI5d5/UK8FEdT6koV3Ii+uJ8GGdX8UHKVqTaSVlVuwJyPsD6YokEsbeRw9NMTieJD2CfHuCTQfFGNed4LNBvsW9c3kJ88JUe0Pmf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199021)(8676002)(8936002)(5660300002)(7416002)(186003)(26005)(6512007)(6506007)(86362001)(38100700002)(83380400001)(41300700001)(6666004)(36916002)(6486002)(558084003)(66476007)(66556008)(66946007)(316002)(478600001)(6916009)(4326008)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/cLgp2tdOz6RANcjXNYtoxqi+oRCIY1RLsybjTgLKbPbNFRTdb1HC954WcQC?=
 =?us-ascii?Q?aZOfe/ISosz+I6SZfQDzzQYnPEjYhRc5RDGs6TrrVapvdVMbmgG2xPE3uagP?=
 =?us-ascii?Q?QeoSFLk5C+atxswFjtlggfVtrX1i4s2+n97/8/GHL+yzn05yaZMJATRmFkzR?=
 =?us-ascii?Q?0ApghBNJM5VmNCDqJ6b67SNVO0O89s2hhtBYvcUsF7js8uLNv1as1QR5NAYF?=
 =?us-ascii?Q?N/kZJoInuqbZTKagNFgfFxnU5eZzMxXThFO1LHTFkkQlJECFQJgY6xwLLPlh?=
 =?us-ascii?Q?jSbwISC4RNbun6CFs0q+Unr0JJGZh018vtFd8Joj+mJ/WmjTfLYM27B03ICm?=
 =?us-ascii?Q?4qr34LOwMLGj3ucPo9ikrXn6Jymg81yM81w25R3o2kOXa/lx99vmRSEhHz5E?=
 =?us-ascii?Q?CSEyNHithmrqUXrA6Scqgw6q0n5Q4cgnak62qkvuQY+kj/tTRzQLXxaXo5a+?=
 =?us-ascii?Q?+3zGziaOALkEDhn7kxJiSWMlFeG73laRSfc2iaSoEm0sE49oi0QferG+yVov?=
 =?us-ascii?Q?1VhApH7lrLmDfuAK7FtwNGQNawu/YUS5qSrCTBdCKVJ35spV5v2XQpwwCiPv?=
 =?us-ascii?Q?N6hnCsTD9lRf/xXqvipOFyxOVupYnyitruEcHFKCi1ViQnzRzL6t9SyGAFIe?=
 =?us-ascii?Q?6GGD24gvrG/AnwfLJ4HC7kr7+STAHGJlkJWb0rDDUZWWWZCewTDSTJSlgqoz?=
 =?us-ascii?Q?QmIoAIcplpity3xq0M8ecXir8tJHdyfZCIUloEh7+d71Y/fFYGGoOl6LOvsy?=
 =?us-ascii?Q?0NLM6OTuSLB4Epp6gLfenCVIsXSuT3C8BYnx0SIq8sEU6yo4CNBS59/p1qHg?=
 =?us-ascii?Q?TuZjdheTjh0Dx0rtOEtIob3EwoWP7emhIuyMItBT1HAtZzk6/vX/z2V6E7t8?=
 =?us-ascii?Q?cBcrqQvMREn31S6NBYDRHLCWShYTp3SwEqlmoPF/QObjFzjmBLynF+YmBDR6?=
 =?us-ascii?Q?NmV9BrTpnfEUhXuzW6MjtS2EC3sC8Y5ZaaH22YzCWGxkw+FfCCF8LrpihJ18?=
 =?us-ascii?Q?HEJCxtzp2KiZFlX3WkCuoyzpiCHTLCKxg3ElVsrvDjpLIcZVrSNFtnjHiquT?=
 =?us-ascii?Q?OF4CYTnF+KRgoDk7CILekmh3vsf3CeMFdopKYexQhI0H0EG2pEs+O5WzfhAe?=
 =?us-ascii?Q?cZ/QhWlaSkwQ4t5Je8qnH7uD36lVE2nXOkKxJKq43YWOUIjsXJV7VCwzVy3z?=
 =?us-ascii?Q?KjwmDb36KwwC8Wc5sZt4Y8z3GLtbcx75oMLIPAatM8IVDlVsCljDlUOa1Sxh?=
 =?us-ascii?Q?jeftCzO/9yw/Qxnzp9PhwIr8G/2vAfh7ZVob68dPLeZlau2eCP8VVwgr5GDV?=
 =?us-ascii?Q?rhcsGsA662z9gORARoWr6xLTcEakpuwygiBl8NsCcU3oATqtnX/0L+44gGXl?=
 =?us-ascii?Q?sacEa/ULPMNxZ/6mW+VEKFdFsk06CCApxGA/N2BpQRKjM8q19nXxkQf20HyD?=
 =?us-ascii?Q?pE38VUOpSKhzKsDamH0rOxq4RTOPYY1rsoN3Z/M15UI3iO+YVuhwJecwj06R?=
 =?us-ascii?Q?/c35AavGO6hI2QIcuojz2N30sx7UJjKRbEHiWtaZOwk2TCqzuDiJSzavdfHv?=
 =?us-ascii?Q?iz5CBpK4HE9lE3leTruvqYHSf/Rbd1R0mbm4za6Tp83cvFslTM/jUEuV3wT3?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?0mHE6wLzQtw8ikOZExi0yPFgynLkDTLRP6sKVpXNxKYi7xmWCIzkWKcol4fj?=
 =?us-ascii?Q?FGO5dGckeA97yWSgBa7m84tfRtgosdKxwRyqPoz/lowNJJ2R/3endGo9t3ry?=
 =?us-ascii?Q?x9D5NpeNvoSr/qxOTEB+iJppEd1IsjrCbtHo2wxvxOxvcbK1kO+E8INWkSLO?=
 =?us-ascii?Q?7iJuGXEV+OzrkyAQTOJPBLIPOAqGUmLTBKsBRQYEFR//pL5XoUiABaLolaCz?=
 =?us-ascii?Q?dCpzWTG0BNpMSL/5NUikLvr5r5xKgIC+dOp/tC5LAi7y2rRJS/RsR/jk4PJx?=
 =?us-ascii?Q?u5v/ok16N+hLB2/6LD71J++pakISZtlNBas3x8pLgBQm18vF2tNsDVQcHYDe?=
 =?us-ascii?Q?6uFzuQjOF93C5sXMciTeWeSXmdjFG5SkC7hknmvrwdqiTNRBDDZqSnT5CGwD?=
 =?us-ascii?Q?8xI4Z5GJzt8cNwnh8NtOjGwz1LKx73Go6x2qA6uVfM3gJ5xo955Dr2oZ7oT2?=
 =?us-ascii?Q?cO/Ir6nEOaIbkpF8EPwTlBDGHO4CvqjckV2C4k8OtyjD6gUhXvcphG72LvLS?=
 =?us-ascii?Q?MY9C2kEo99Wac4IuUFyfxLR2QAH2WOycrwkFTo8Al4qyPHjBF1lgSkDcHE2Z?=
 =?us-ascii?Q?5LO5QW83vULQ3UzpFgmreDVqLvPJUrBbxT93QsSPFS4e0e7adh2cgM5Clb0T?=
 =?us-ascii?Q?THN9m28jrtuAEY1LbTDtYOhAetVDxpy8pzDa+NodwHniIfTI65HDwtgx1xgZ?=
 =?us-ascii?Q?3wDl0CQE/OsKnLYA9YwaemR/Y4zgEJ/XR0KZBOHiVEnrJL0cvRPQYyC0UIuq?=
 =?us-ascii?Q?Ycpi5+E+m/i/33ajyRJKZEvuR34Xq25KpjM8NuUO3dC8IJ7Yim/s+K7lzdGd?=
 =?us-ascii?Q?bxWYwDhiveUO+f4wxMf2vepKPJ0H0ZPTUAFlNwk3TG5V4ItrcobWF31v3GX5?=
 =?us-ascii?Q?iGByiV6Y4TY9/08VZmIhjEH9ja27g9/J+LBdVxE37rFvVSOq3/z75EKq7exc?=
 =?us-ascii?Q?QvR8JN4/7nGiUKv//3xUJIZcW5kgNksf2pjEdhVqMdIMO2L4x+QkwY2CjYyc?=
 =?us-ascii?Q?zoYk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edab633-7b13-49fb-8390-08db5b0d48dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 21:41:21.9568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PxD7GUsD7FLfYc6BLsuncYEnsUNjXtiaLkvkiNGrme787xhdPck/WtsjGnB8gisuaCxf/+zrrhDNDD9ITyDWZszIW6smkCWbiF12C/5xf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5925
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=710 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220183
X-Proofpoint-GUID: 4IB-FM74jG5ATaXb3KRhNNwhSx8nSJEC
X-Proofpoint-ORIG-GUID: 4IB-FM74jG5ATaXb3KRhNNwhSx8nSJEC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

> This series adds support for Command Duration Limits.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
