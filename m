Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B4C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF1460FF2
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbhJQCWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:22:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6430 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhJQCWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:22:43 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H0BvYr025619;
        Sun, 17 Oct 2021 02:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tbkvnCYVfUDGqV8nFgCZ1sDd5jjsxUXIvwnzHJnNUrc=;
 b=H4YzXCCRRr5LQzlOAlqFBFXQ9LVQ5QRQZX9JbcnHKvN7XIHSNzvcOjXbt1hrKyDitHu4
 H0o7/H9/sk1W0AKyn8suSGufmDU3cJ8XLMyZuv6+m0px5QYEi/k+Fytbaqz7JxLDHods
 LUEDqyfE5kDCMzgUsrYyY72/ctIEE1I2NkuVeLznOuSMScFzeOhSByc4/88VjGwr4mtT
 QH6gPlmicdyVJa5cjUIrcbf1JYtLrFaDQr2uvoyuLUXdL8ymiIrCWwQE5SzxNlxptSKG
 bgvE1grDk92VQx2uoC+owZ8DvU9DzmFnpfEutLnpSLri2errdyq1cbK+r+flamLJ4vO8 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqjc9q81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:20:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2GeMG044387;
        Sun, 17 Oct 2021 02:20:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3bqmsbk60j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djgkqQMeT29SvKvBcek27TQaWZHtNhkA9Ssv7+NBdRxIC4xb9iydSaxs/CZgpbuobwsCaN4fQEkeAUgaDuwCwoj+aQsoUJ0sJ2BiwrOs67fIrklgLDm0koMGmFpy3n900gBcsA9ggDxGTBaPECvSV4b1vUgj5l33PmXNJcrvtaEGUV8aSCYzC62+mWfYm5QhidHGA9fK/uvR4AWyNjrwS6asIdaaWMiGceeuH4J33iJ8j4+XreSlck0imcUN2qqbSw7+dKKryqSRogW8f29xzBb6J7ecx4s0+1Th8U8spTXMk/h4askhAM0GhLX1D4ZwgleVF5S+nxEitSTNXMislw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbkvnCYVfUDGqV8nFgCZ1sDd5jjsxUXIvwnzHJnNUrc=;
 b=Uh/RThgbXnyDcQJIUXwH1SKPKaORv7kECqJsXkpbaYbUjvsHQr85UWVLS1LTNdjpgWB97VLTZmwQOx/s9buauS2LNND4od71vaydlzE97c8o6TvVkG0HOqcTRlcXiINFODNBM2E4MUZ100ksbvw5FdPOzKkE2zK3GtNRKkQkJOvmAKxg1xgsj5yOE0QZTU++ekUf4u/euD/Szl2a0tUDncWWZWna0b/E+DbOOLj2eQcNsugoBhvbBkNiVuGC/wKr7IlL/HezV2+77BRdXJZAMYNYqijUF1Il3TOC3TDyeE7GXemzZ358VDp3m6iD/odJERo0eepbOmpyo2F+2CSY1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbkvnCYVfUDGqV8nFgCZ1sDd5jjsxUXIvwnzHJnNUrc=;
 b=hLHte+W6I5POm1d7dZChhEx6aM9bc8t622qgGHLpwPPBDcyfaWvPMYU6Be2BPJhg0Qb7SgjnkkcHWC7MqRtA7BJwPc+zI8JranyZF0e0qfhdr7m4JCOEi1gHhPC8HtaLywUuJkQOZeMUdHGju7UGvlcRc2X/ldTbEnrSJaYJxfY=
Authentication-Results: ellerman.id.au; dkim=none (message not signed)
 header.d=none;ellerman.id.au; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:20:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:20:17 +0000
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>, tyreld@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, james.bottomley@hansenpartnership.com,
        linuxppc-dev@lists.ozlabs.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in
 initialize_event_pool
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtn8gzra.fsf@ca-mkp.ca.oracle.com>
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
        <bbab1043-ee3a-6d5b-7ff5-ea5ed84e9fb8@linux.ibm.com>
        <878ryuykd3.fsf@mpe.ellerman.id.au>
Date:   Sat, 16 Oct 2021 22:20:14 -0400
In-Reply-To: <878ryuykd3.fsf@mpe.ellerman.id.au> (Michael Ellerman's message
        of "Fri, 15 Oct 2021 15:36:56 +1100")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:806:120::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SN7PR04CA0054.namprd04.prod.outlook.com (2603:10b6:806:120::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:20:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac1c3ea5-04a6-483b-0494-08d99114a927
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805D9D52807C2CDC09657508EBB9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /07EDdbih/dLGgc4ErNQI0/o8FbLvEyLjqIPiCQ8DcWGX0sep/GlN+LVbQHQ2Ze7hNWtSxm4F58zGqNGSxyL4qEp3RFrpSzNJkg1Vv+aVZ8gkqxy78NFqxCjO3RGhmtN8GV795FgyBp0TqJ9bMHsfsjZ2ls0YcCjInJs9jZmfrybU+vPMLihdCCeHQ3+xr3Vh1AOImycSB1IkrCr5p0bo0/VT905lFlRo5lAfMyT8qMbPu4kU0dT/zfgnXpjOgSukxWoHUg3v0WM+iR7r/8YlPzmcvOXwLsSKiIME/hTt8rDUp79Q/IF2S9mpm54+ZMUhvqKhB6hhLtynfActpu/JO+DOZ4fPp1hNvtnFUYPHt3LUTwjm1JBZSfOziYiYjt1heGQ4HKPAZWh4BzaVjooP+KWh9TFYBySkNSnQhqfHMsVmw1eQkh7/d68Fu63ppjn3rOY+rkK1mofADp+9OO98jAM29KxuinyOKTFkbrsIP2hmaKG+DcjABCn4UtmuF8DdUJ9h+CIjWLcE5s3lyDyQLyhAGIRJHLGP2Sveu1Ib+8YZYhNFao1oZYRjQ5RP5AghUlON/OYjNHwCYayY5ftszO9b5oed8yMLzZoSkdZTD51DYdx0WR7GK71neKisOy2M8tR29U1WaHdnQqm/hjoxO8ohgMeL1dCmhHE18rDPWiuPicHSxATDbaRkk46hVNcA5F5IHBttymw8BSQpHqHRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(7696005)(36916002)(66476007)(316002)(956004)(38100700002)(52116002)(4326008)(8936002)(6916009)(6666004)(66946007)(558084003)(2906002)(38350700002)(66556008)(55016002)(26005)(186003)(83380400001)(5660300002)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uv1hx9aeTS+AL2ycqzdpfrqu1N6co33yJfAPf0MMbhK8VBXnoGRJ073BZ1av?=
 =?us-ascii?Q?YqGnxekBvBtZBf1dFZt41XApkU9WpWZzs/U8no3zQE9/4QQgR9rmZwjMokOZ?=
 =?us-ascii?Q?msPNmGG1/wW2lOb/pPZRMLESk5ZqIAa8YT3gjCnV1lfVRbEq+KHF/g95driw?=
 =?us-ascii?Q?fBLIJO2Ia43evHAYtnOLI+xjLi99G1z2Fyf/0EQ/SMrPQhNoIaIWVJDDe7ia?=
 =?us-ascii?Q?U0wlWaYuZhdb8ldzpZGKos4r6J+WiivaroyCT/l0E/0ceDvnDMT2ojk55guh?=
 =?us-ascii?Q?Y5zbfJnbmP1Gt7wCFsN2UFBpUK5mlYcR/Nfl0LgNEO4dv7fkmGezWCcB6eLE?=
 =?us-ascii?Q?psNnSIOOhgQYk0jVfpe1Yokkq10qR/CHpvza1LOmxcf9cd8VTgh39Kb6mXye?=
 =?us-ascii?Q?iG1MNNJkOPYk0Ub6oYXDVWoAklBV2lvrmF633sn5jYXtJAyUYo6wTG2rVjpd?=
 =?us-ascii?Q?XJ/Far4ganhrBF4HixdY952ybJRg+YS9+phHQUk35PpyX8rn/T3VqjJJSz5o?=
 =?us-ascii?Q?R6j7QYiTZdVe51meb1khOF4vjOxTPzXFqgJ8AbSQhFR9dGDWlZtFFRFsGr60?=
 =?us-ascii?Q?DoEmUpYvAVToCrw23Dv5Qq1QsX2EvhxkaLjjKtLWfQDtFlT+plBoJBGddywX?=
 =?us-ascii?Q?ted42XXagd+P4SvVWeQ8r6F77sHRepcpoICTmzQ2qpTsPnFexbXTcy1l3QeU?=
 =?us-ascii?Q?KHMzcxkpBdIoqK+q89IoS7SRiqIHwA3hFe/x4KJ3OOLlon8eGGIONA5BCHIM?=
 =?us-ascii?Q?PEY3namB39bD8WlyxtX7eT0gXj6t2CromLyYG9aDr+phNzKF2BDs3R4V9mbN?=
 =?us-ascii?Q?xCdHTOUJaSvFMqJ5SXWgR3O58uY9U1p8HSqljc+LXKkFqHV8rswjqKF17087?=
 =?us-ascii?Q?PXgtb3kcpe80WNj/Nj1mudPzmXyOSM6+BE3RR3hwPqfv7OEa/fpnqc2h2h3j?=
 =?us-ascii?Q?tsYAP74+2paUDPM35M4D6PSvIsodraiIvHRuYUOWpYODDPgiHHeguip5IqzY?=
 =?us-ascii?Q?+V3+xVSrPYsAKK6wUuxF91r8L4/fCfjL67ZoL4hmxnYNyFq92JAOPpT5fOx1?=
 =?us-ascii?Q?ynCwUZFgzejxb7MUphnzmb1eyLGAmRfaQp/yqhRklp4phefgZzA6zJ6HQWKA?=
 =?us-ascii?Q?B0qCmbVVivhgktcNN5vHMEHXqFJzu/B6854pKoeMbPy1gdNs4GWYODlXKiOR?=
 =?us-ascii?Q?wjPM9U65QabDJSBzmMU32zlP6eI/iirCLAqIiTooGKXLu2r5LFaA+kdRZv2X?=
 =?us-ascii?Q?tWZXWv4mYqsz9LAAK0KO1HtNnCAjBFoIpk7yd9pT5dTN1Ze+Ea/o2Y4GhAPC?=
 =?us-ascii?Q?i6GkTfzG0aFFQqPsq8aiBioF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1c3ea5-04a6-483b-0494-08d99114a927
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:20:17.3841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoMOmGdSMvbbHg8ThO4EOzfUPLF64JVHrdg31hgmEh2u2+bekIitmgewloMeP2GgBUvbtLd4MDQsc4QfiTUUJK8cy46X3cHwe131rJYRY2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170014
X-Proofpoint-GUID: mnZbgqIjbvbIvyf9Te2UXGBB_lM8OXir
X-Proofpoint-ORIG-GUID: mnZbgqIjbvbIvyf9Te2UXGBB_lM8OXir
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Michael,

> It's marked "Changes Requested" here:

Not sure why.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
