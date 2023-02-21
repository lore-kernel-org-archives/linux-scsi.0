Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7276C636D7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 23:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjBUXGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjBUXGA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 18:06:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A32632E4D
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 15:05:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMiaGN016251;
        Tue, 21 Feb 2023 23:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=hwoLeowNS0E7pJOAUN/DhIewmmt4SqpGlmgnMKzZ3F4=;
 b=Oiozl3sMRXIt+htLnwSgxGhQLgAv0BUGk05bc4B3seWwIJ7hJZ0hZzn+D4PSSFIFc+gb
 7XUEnHA0/N7OpIJUMQKZ9PLZ706VzEHk1i+CoTAu1gPfoLeW9ixSGCITGBojudC25lT3
 x5MUwggdy4Ur2oQzG1o1EKKMA59SF4UNQ7cbv3KfpGiOPrhz3oA9fOrf5coFDfCrqS+O
 AUkcpndnUVvfXyDo5NY9jDRmm+0mm6YPYYfR46ljwN/DDTQpAHBl92usE6Ip6k+c2Qwy
 yG8jwUO6eYHRqCsAS0Z26fsvRyiccnY7/YyRuPe7IlEyyrqCU2mLLsNR7t4WDzEtP9H0 UQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90pmxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:05:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LMnUDK031233;
        Tue, 21 Feb 2023 23:05:37 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45tc2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne6fKbRHXDUiJCYhYdy40E+5O2xfa0LwDNypAqg0J8dt+r3M2oYfrzqPi/9ZiCnBIyxksTwryHHmenLbgayoV1VZSIx1rrGTcgbBhKIlO4svuupdFqF5xR58Tj/jK0DUaOCrptyf+hIal0z48bjhNavKwssLa8w5EYdCRKymF9PHeR2Pbo0ejKzj39U176h+6g1b3EjT63g93VsgmEtKttMhyV2kCfMUdFXNuk+BzcB9/N6E+D6w9pFCua41SQS0BBphArOL2yMxnMbk6GrUvdCk3wFLjWawR522BjmlY9FdJmD4tQm+tuMG64/7KXAw6BNUUzJGAZGV5/bXxFJW/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwoLeowNS0E7pJOAUN/DhIewmmt4SqpGlmgnMKzZ3F4=;
 b=aFEdNaHwineLBuyKM7UjoRzhVe4cRRmux//RH0aIU0cpxLdhSoM0SsX5cPF3HRI5CRSp7/Jn6++v4HtEi/g7gVI2xSxck2bL6gY4lfamDFCn20wFKHvnEJTEZmRgGaSVUOdRxcgG0Ls664pRytMPTJy5/oIgrng7T/8Lam5WDw+K1ow/K2zzNEJjjlEmFK5BHwI4g/jjPnEA36Vovw/3lzTr2WlfiVrjKRoSKWKOVhHMtg7AJS2V2q0175HzOUe73raOj0bCPvPWCEQHMDr5nBRz1nsEiy1etPiVoqzxWtbKZeYgKsomaGLVmu06l2gS5t6CLyeq8KAgpzE+3LHm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwoLeowNS0E7pJOAUN/DhIewmmt4SqpGlmgnMKzZ3F4=;
 b=naHlb8SCo6DED+0OlH5uf0jVIppjafikEHoGVExs2hP9yd1shVwVstn8n+ErEF0H0KjIEjkCmhRqWVp+DTY62xouQt4X0qyHLzjf6a764dgvfbifyIFH05H569G1CNf0YaK25mBxsW435jjDyu7z6MxAzEtbvIVYupTU7g1PK1M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4862.namprd10.prod.outlook.com (2603:10b6:5:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16; Tue, 21 Feb
 2023 23:05:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 23:05:35 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Joao Pinto <jpinto@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Zhe Wang <zhe.wang1@unisoc.com>
Subject: Re: [PATCH] scsi: ufs: Make the TC G210 driver dependent on CONFIG_OF
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bklmsjpn.fsf@ca-mkp.ca.oracle.com>
References: <20230209184914.2762172-1-bvanassche@acm.org>
Date:   Tue, 21 Feb 2023 18:05:33 -0500
In-Reply-To: <20230209184914.2762172-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 9 Feb 2023 10:49:03 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0055.namprd06.prod.outlook.com
 (2603:10b6:5:54::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4862:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff82cf7-97dc-4cc0-70dc-08db146023f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u20u8QP5xFrd+qcBTLiPSzRqQ5aq8G9k/PIRsHqhP4nUA+mr5UosqI76cuSKAJNEjr47v8y5o6WGuXiimJvy7lzGzC9IQ+On4CqU03W8/IApzxvX8nTibXcFDaSLTj3Dua3EO87ukI1NOkhA/kJjO8eSuF5v4XD+3M+AE39SD/WIS5gXLEMjtOi8m7qnI7UWxdRoMMGIWI7CLbz+BCAGRKckMGTO5zkhB++tyV4idXsFktfz69KsfV9nD9nXMwHkZSMtIbjVoU+GQlYhAw41dveF5T0VEYpjZB5VvxxOyTcecskRaIp/N8Fz0E1MQK+b83UQV8sKzGUXp9A1QqVmUSHNSevpV0+1YS8+rJp1g7Yqiw8zOnzYtjVM9zCGLMHNDH+EkVqNCfdNh9ZKL7Bgp2lXcRprk882Y/XJ0RWUsUynkqicVDfv5ZPsoWXcmJqnAv2+xwHM2RTesg+8Dorfe7LtDeYMLDVrUYCmSHL8glecIedEWC13LluuCOqqlPbnMmbG9BaJ1Gckn1v7JCOKBcCAQHL/1JKVznaoSOJh4A+mDI0CuUgiljzzJCz+SjmqckGTSa5uXqr8DiD19j9c68nHu6s0c23e07nHzo7ytLtb4cC0vJVc3zDJyT8FT1RPpXsyqP6mLSi6E67P5LxY/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199018)(54906003)(6506007)(558084003)(6512007)(186003)(26005)(36916002)(6486002)(478600001)(8936002)(7416002)(38100700002)(2906002)(316002)(66556008)(5660300002)(4326008)(41300700001)(66946007)(8676002)(66476007)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tDZ5kd36zwK18VfKMsIHkW+GhV8Le5G5+a7zOHTPsHcDJXhAbYqj5uouOETG?=
 =?us-ascii?Q?Tr/Vg6I5q/NDoPXHQGZw9uHEYOM42gdTZyrcMMl51vrCvvsfK31nhlT7ix9X?=
 =?us-ascii?Q?uZ6W3k8WJLtUgeumYDe7H28Rm9DGttpTQjB0JHiGEBEs8vXMkwDrkFhY02VI?=
 =?us-ascii?Q?n8jJbnzqlbCR6Nu4n5LZWBapEp5X4uNLgpYqOxKr2n6U0Tl/bld7k42/eE1O?=
 =?us-ascii?Q?JpfCutRbi/20GESqM1kJQzxIoZx8Qt6HPK+AhyXmi0BZo6s49yBB2ojuWgPI?=
 =?us-ascii?Q?71FkgwjwAdAK7SmKxvaGE96B6yOY0eE1q1bPMsW6NjFY1WKFM21RJFEVo06N?=
 =?us-ascii?Q?JadbSnUB3XRQuOyICmaHatRcQTa9jhxQk4OuKz8wKNgRQPVX7FjGB49i7JQr?=
 =?us-ascii?Q?Jj6RnkF2/O8uf175pV3oOzYrqXCKmGnkcRPDR7llWuI7Sn6NtZTWnCb/1LEZ?=
 =?us-ascii?Q?Kb+9x3zuZCGW2eBoEFaKdyEqmQ8rwM6wkgP0kVBfI4JeFcmOd9JfO0Ze5m8f?=
 =?us-ascii?Q?s9FlCS+TVatfMMwUUy6HLsrNnnwFb3Pg37lVAJbrCf5pRc78xjKsZCPIGd54?=
 =?us-ascii?Q?CWrYbXwwlE6rNYsTokfjhlVqEVFkrOUygHdCCCA339dXt8uxVfUzYoNGIt2e?=
 =?us-ascii?Q?ty0YB0ljvJZW/gKj80j5zCzM6ehIJ+uYWRkIFKs6aVIfQw1OetTICZCb0ZFa?=
 =?us-ascii?Q?1efawmxmguN5h1ueGUmYw2mN6CQ2GlGPYhbUjDPz5fIx1fCXftfw1RSeLC5s?=
 =?us-ascii?Q?i8FPxTn8+hYmYbR0GKdlEgCf1oNiCalGoFp/lsl4dM+WDqTNKllpxA0w7YAG?=
 =?us-ascii?Q?bJ9mE6y7P3PDp4uKlc5tabdnpOm7ombCUKfyYcCWpChfr6b0rplSWUXPfTV9?=
 =?us-ascii?Q?iQryk0aNSJBzI/Fd4bpsxnk79yDwr6Zvkk/D3gzG75ir6BIXDCvGphyVt7ry?=
 =?us-ascii?Q?ch9rMZY09rSvJc5vbxP3ALfn+tGbv/2dOggb8//M1gxWrTHNRmQ2Z+ay/33b?=
 =?us-ascii?Q?3aKbnZC/9S9lfs+OXGXfKNT+Jme+b5ndNUa2rrW+m5Sg36ifESo2aG0BTRMd?=
 =?us-ascii?Q?rLsaYnJifE1J6+dhDHhf+dfaV/Rjappyh6HTpEo7I5Nutwyl7ILZzUqbniw/?=
 =?us-ascii?Q?FLAafVYLrPPlARvROOAynm2SykJccQd8HgVnpswILUR+mggKX1nPUWDhUPYa?=
 =?us-ascii?Q?sFHHfB67UgHyfwvhVLsq87VZ9RJglwWt4roy6bChHu5Hym4pLdghcqcDVSfy?=
 =?us-ascii?Q?4ZbXkHNT+J40Fvf9unglW90j7+BfWH0voYR/IMaoUPr4ha40P32hhqnneKs3?=
 =?us-ascii?Q?XKl15059LClGfjmnpYKLmzwi48b5CAR6/h3xLvRCxMNrM77j8yBT4LwSHKu5?=
 =?us-ascii?Q?xfZ3Cb3DRSoTyYzyRJLAK6mnj+zHNp2ZUJdHI5Y2QsuT1+doL9eTSPxbQ4qg?=
 =?us-ascii?Q?rr60LiRPigtlwQvOx46dsqo0RGXco1Hcv3tHy+4+TqNuw5RgntU71XWg2nXN?=
 =?us-ascii?Q?qAgiiPVEHT9e0vCBmoK3AjcuUflRRYnD8SwInZXv8p/JSCMcHhfOwmp07a27?=
 =?us-ascii?Q?ZS202CArhKySOAuRsjNOasHMjOjT/BhXMP3zVSZDyUmW6IsNgCJgQ3AkpsVC?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?BJqCqqpENvFemYJfnasb8IUR/S75/X43Du/sylt2gE7GEw/6UrmHCYdLQR6l?=
 =?us-ascii?Q?NeIVqkl2mNPcbyDG2GwG5lUDhHPBj22FnE8PfYJC7neGi1f7yum8UvrpAD1a?=
 =?us-ascii?Q?FM1PZhhPKkcDi6nx5wsTHNVP7LNk5rp3PDvgsU7ufKRoMMdAXdiEom1IgRdo?=
 =?us-ascii?Q?6cgI7K5DmWVYWhSL3PCf5jSx2M5n9Y2jf6zYXBbTJfP649QUFazO4IeaBtLC?=
 =?us-ascii?Q?L8KSuGLV8bQLzTfPi3M6eJYvwsi08FPtnRneEOdbMP0uUlhBNr5IyGcUTZ00?=
 =?us-ascii?Q?ijps0r0k8JGkj98T9x2Gjt6K4XrN3UTI5CKYopGJIuHrAMmkYbpLwdmdi6sB?=
 =?us-ascii?Q?SbjJDWwtEwqnR2sBEQ5HmIassNUK/5MKFNXLQxr5SStpQEu/5+xhQ6G3ogj6?=
 =?us-ascii?Q?/F2a4pxHkh9dqiU9BnCxpg2ABKRJwdJ5jOGZZbsnT4zDcdSbQMCQhh4Kz80k?=
 =?us-ascii?Q?/gLIuIzd/ILKLHdqsUohhUCjvbOqhG7meGVEqA59+Lyf/BHF9z+eJRFUdeQW?=
 =?us-ascii?Q?QQEoI7x/fvC2ArhdzJvMsfJZCovkOv11VIF3MoON1nMQz29Sd+qug2QYPyE8?=
 =?us-ascii?Q?blkfdP8H82BwU7QSqis8eAtHFBLsQ4czW7MaeAkx0XDxXJeVdQTdljm/KLSg?=
 =?us-ascii?Q?es9TCmfljRzoEc0GaP4twQtxG6ZiG1n58LrQ9vRyk8hppJOMOpPv18XqMI0e?=
 =?us-ascii?Q?WQOBb1Er+C/P9KWoS/APt2rAq2f4jPDA/0DLpbvRkVPQEhwwUGylp87U56IL?=
 =?us-ascii?Q?torHOaeVuvWVd+GroBj9/+dOgkJujUts9diY+sXsnRj2FqcPvhvAsEityAnu?=
 =?us-ascii?Q?pnk0kmGUJao6iX0BOmI+j72v08b2NMu45/nhmlrSkBeIcvYnUAWx9X+j3H6m?=
 =?us-ascii?Q?iOXT2vG66tGQ7AWZO4CmJsuqVnTD59A2kyWCPwNzJUJm/crxQ+36DW0L43Ma?=
 =?us-ascii?Q?K4PyKMYCtrU3IuX5Ab/MV4DzeMzNa0ihhh1JzGo6D9A5y4PAe3yXbwharP+b?=
 =?us-ascii?Q?LCR6pHjsjE3O0zr5cEPHBRhw6ET5k515e+SRsqHrXa2V/SE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff82cf7-97dc-4cc0-70dc-08db146023f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 23:05:35.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djBsOQdM+bb2orX2+bdfh5W+NjKS2civARetepM8vFL4PNm9kIWcveaC7n6hTGif9TUzFci99Oti6hKrs+O3+2s6iu4MbTUyaQWxkIMaVmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=920 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210198
X-Proofpoint-ORIG-GUID: UN64GlcDexdRmHi0yJG5DHJoSpiMjP7R
X-Proofpoint-GUID: UN64GlcDexdRmHi0yJG5DHJoSpiMjP7R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The TC G210 driver only supports devices declared in the device tree.
> Hence make this driver dependent on CONFIG_OF. This patch fixes the
> following compiler error:

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
