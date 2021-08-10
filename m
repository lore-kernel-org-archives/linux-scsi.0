Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D19EC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0859D6101D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhHJDoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:44:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4696 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234613AbhHJDoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:44:11 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3g4CR029836;
        Tue, 10 Aug 2021 03:43:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CtHf4WU1zNWKpB+Z+AsFHsP5vCwoY0z+GS4djmidQYE=;
 b=PgAhTWdVM0/5u5TDOwP5OVxK6eXh8jlb4QtMX0nXM8FDeww4D+ig5QgOltvKbVfZhFOz
 85w1ocZ1UM9FK+e291q8Sj1deKWMhEgOJKql68BEgMxqmgsNJWNcv1KWcyXU9RKdtxxg
 fvXc6mjd8YdjHkaOzfDsg7JKkb4hozr6rp1BNGjsSOrpBUbH1iIK/jo5baYv6uFbyX8e
 MJzm1oVjpBJ41IbhXOki5PehJmVM+M4a0wwAkzrc9GrpekNwP5Hn2wnkDnrKEIChd+VX
 hDcD4OIZoiwMEhtFEW3sBUm8JbgyccjyfhFTXs1NsF7URvYffcT/X0nvNByWvPts1kBh dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CtHf4WU1zNWKpB+Z+AsFHsP5vCwoY0z+GS4djmidQYE=;
 b=Lvgxz2HjnRmYY1eYgwGfY1Dbm4LUuCO7WF4SWJHsnj4hHZ7eADDy6UlD7lI6ezJZ7SAD
 b8Sor7EIO3Tjr+UjCHowDBhqpmwktwvrMwDjLxYB+y8IISiZMwBksfv7IQk/tzpGsttz
 6yI6N3K/6TEvZ3AOCgXhO+PZ1LuxqVzKR1o3c6VfBMwQeA8pQRdmHs4IEkNjVofKlw22
 5P7XrtuGYd56rOrYWldr9fwpnVFEVOe5llqgk+65KqPj5HwOSAcrmL0nW0v2gRM7Hdi+
 dRthBkvJw5i4lQIYDQ7pIN/Kru7Rcbt+J+bkxD8qPDX1miZs4N7C63/fSXqeHzaudG1x Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fthw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:43:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3eLOf084969;
        Tue, 10 Aug 2021 03:43:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3a9vv3ypun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:43:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0VE5YtJ440QXEJTpnYRgmk8KKAw4K13ygSJKpy6mdcCeUlHjJJT5UhNiVQPYYkYUvAuBhIlGZJdDlPeSkwzVnpLjuX05qaJpqqVdCeTCzbGHkBICbqlH5XF09pXZM7KMxr4rKV+E9FqT6LMbjxQT1Pxz28Ha4LVG4TjeWOFM2k40ZoOl96BuZPM6n72G8DucgJOY99O3bkl9yV+YTb+m7Sq5CQLI5oJ0vH2PqYEOnAcApD5h0PTnxyrALdmc9VAnksXG/SAcAIDt0u6eh8dWFYM48KxYcN4opuGVoxvNfDvAu1DGvQRN44psCK4UOQ2uyVXWwryZlc4FH9NqbJsFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtHf4WU1zNWKpB+Z+AsFHsP5vCwoY0z+GS4djmidQYE=;
 b=l5otBiP9nPkpAH3DBbDf0s64o08ksj03x9d0Nny0OiIcDk6q/Pkaifp5h7O6kSv91Oex+r+uhVZDmnr/r3lxZp+2/4KOO2MIqAJpPDXRdsz5cfezRXOzLpLSbKEwXfbIGppdfb1MHYsMVcSv+HQJfGXfe4bP52aGaEB4EyLSVkmeJvi8hbkX0sbetJy0qvvlONvGND6nT6/lUVCyAz5kvhGm7ktHzzPjel7r9OF+a6wWzVMBaAvkX16mzA1jia7cPRiyqLIhD8MC7gFx3byTDOg2r9JFz7ufLgXmBd0P0Kx48wK8AdHaA5yJkvyarM3fiz5c/4PIOGlv9BDeZjFjuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtHf4WU1zNWKpB+Z+AsFHsP5vCwoY0z+GS4djmidQYE=;
 b=AotFZyzw9QEi5kLc0qit+1D5azpTSniooKMktSnvxL4Q6wQwFerzeWRd/4GW598heJLpmKxtKJ8SIH9SCxWctOgK/vMuD3r+x+9Sgh4Ag154lUswv23L/XG09+09HukVMtPZW0mGaP+xQgMKvtV6Vm5xebAPFIIvfcvRll+BbVo=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5641.namprd10.prod.outlook.com (2603:10b6:510:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 03:43:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:43:38 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshpb: Remove redundant initialization of
 variable lba
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnouufq8.fsf@ca-mkp.ca.oracle.com>
References: <20210804133241.113509-1-colin.king@canonical.com>
Date:   Mon, 09 Aug 2021 23:43:35 -0400
In-Reply-To: <20210804133241.113509-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 4 Aug 2021 14:32:41 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:806:a7::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0014.namprd10.prod.outlook.com (2603:10b6:806:a7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 03:43:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c23b9d4-0d7f-407e-5161-08d95bb109fa
X-MS-TrafficTypeDiagnostic: PH0PR10MB5641:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB56411FCBD4DCA9CBBFBAD4DE8EF79@PH0PR10MB5641.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlyzgLAZuFJHfu3ZZSz/0zcoARuseFWFHgA9Ez5bvw9ppcviDGtHkXtDtLl5YRlNXjo/QF1btT4x0HHc3TbccW6+m1E6PiCs1/fFcyQUH1myIZF3Dnc9dQwaOO09cGiFFgSNDKkSHeDufEB3uh7wLZuW1e8tm03Oq2ZZMvkXRJwx/M/psIRkGQlbhDZ9/hFAYss1ANBL8vsfsScJSobHUMHU49xfPYeTsb1RfO6u7maVcU/HinPOq0XIdgy+XDIieI2nr616n7NgmEgiO5q0P26EeeXHD7aHmBlazY2z/diEjeHstIlPM/PYpemD3vt8Z51+cv7x3tb3JF9lLL75CCEhKOOzfEYmIPJ8tyaPlvuLLHPDYbkw10rJI+XKfCV9MzVn6ndBjkgiuVbIgkifqlJiGySvZ3Z4s9q9lTeecSb1hnsSV3SDU9K9vMHXZnclchprbfWiZWtrS/Uu662Bw81O3+nTqsLiqm+UkwuKH11uIP/TryE1UeS3QjZ4ayGpma0V1n3j/9DUjKD42coOY4pJ8MI6exsW47Yc0hNKhZPsA2dhmiWUBWpzNH9kt7kgeo7sUlRCi5S3ZVHO3P/Yxr88O3bXmjvT5AGioFK42thUNdVckuSO/KEFr2HrfZh/6AtxZRNaIxX1cEXLVUCb5b/5B6qothmmN4jS7uo7TPtz4Ntufzi/c/BvTxQo/o3WVB0TUptPf954bsgBs9NH9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(396003)(39860400002)(83380400001)(6916009)(956004)(6666004)(5660300002)(38100700002)(316002)(86362001)(55016002)(8936002)(38350700002)(186003)(8676002)(36916002)(2906002)(66556008)(558084003)(66946007)(478600001)(4326008)(66476007)(7696005)(52116002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hqfE6pk4LYOEOSDa59eYdCSDLhq0gGI9OxZqKfbyWciFsaImznxvFML/6jlv?=
 =?us-ascii?Q?YdQbcTgaiH2qMifu/lm8QJ+O5qGz3qXoBhnb9SqUgvcRPVCWgC2n9N6VnVxv?=
 =?us-ascii?Q?0548jDG92mY3/zrIfLIXvDikyTJpqvkkgdzYiYlsdfs1Eyt34Q6a/0/POjtb?=
 =?us-ascii?Q?y49VKAa9ERx6pw0Az6rJUPQehnmJ7cQ7TDjx/wYMx9C4u+iD/xSSJhebSyFX?=
 =?us-ascii?Q?zAhWKOo8LOz9nwlTi1UoB6Ie66+6Je6R0AIOLeIMX+cClegXo+zXZ/eDxECM?=
 =?us-ascii?Q?bsfS5TFOKyYY6qYq2kT7ZTO0VbVzE32lXZ7tNE7lo4dO9ct8FvC1ciaMizGt?=
 =?us-ascii?Q?tThhAsqkukSDPxcKZE5Yul4r/8vDV9uWAuoSGvn2d/3IYBpfCWxH4wlMa+5T?=
 =?us-ascii?Q?1yWhStpJJYyCEnAmNB2i9CTpXVsCdChkcItm3AAdowbH6xCakOr+a9mUgGeA?=
 =?us-ascii?Q?QpMTBYdJPL3so9wxQga+YhAo5pYGWjfYAnV8lKefzJ+RGQ8e87gg/2QWDkn+?=
 =?us-ascii?Q?vdPFnMH66FGsaFzXBbPsiYVgJemhbER/XJOc3cmX/KrWiNHAbM8wOtFT3V+R?=
 =?us-ascii?Q?R/QLEvg6KO6nHFjJEWTvt3zHBUCZ7JUkdOpfVUrWSV9Oz1tFeh5CtqdDVES+?=
 =?us-ascii?Q?B+wnkdWxc1h9JB/ZL9t7K+gqZQ284Cg1PI70ScDHy7udvuxeUj4+2XfpBvXq?=
 =?us-ascii?Q?L+AJkfULC6WBbtH3r8uCpULo+jZsi+JKCYTZ5bwtKUk0A9yRbS8024r23GCv?=
 =?us-ascii?Q?1DsuYamlWItbleHgaWEoNWcyIJBU25mlQcdbVqj8JQuyny1Tlwhe7vsMuLwM?=
 =?us-ascii?Q?Gi4yVQXfjfHm8XfDCmpMvCM2Yzy8eWmIFIqj8cIUkqGBmExo399BN5g8mCcb?=
 =?us-ascii?Q?aU2l/MIha8MBZWzaeSAp6zjz8XuxVMktjA6wC9nEJPljOMCenpgGvS8RWtuf?=
 =?us-ascii?Q?CCS6yZDGIwy7Y8F1UtGdW6xy5565PSQGsch7xXedvTmNMcbOjT47zyWHaOkS?=
 =?us-ascii?Q?rGvTycpWxQkyA9uGLPygzvh66UeHm58y+rqlt2XVkkoeEkwrmZ81cXTuI0OI?=
 =?us-ascii?Q?czCwKrLMmau9Kl8OS5mhXvlH5OGF9R2F5UXHmvnYpa4kR4V0u52UbWh3YxLT?=
 =?us-ascii?Q?aMRTG+C1ggYi+WbrS6VErfH+NuRriiH4i5sImwQk1YBKET2gQk8hj1ZA5HsO?=
 =?us-ascii?Q?mb+bedhlUf9OEioJDmYBJ+HjsOhyo857n4dGEdVIn8b9kTor2kD20WkQvTgx?=
 =?us-ascii?Q?mvtBsKm2hGKybsbVnHoEVt69XorbCu3k9fzAo17wm5t+Ih41/k5xBFb4rDwc?=
 =?us-ascii?Q?E8JeA5Aw5aSgVJzMhQefGEpm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c23b9d4-0d7f-407e-5161-08d95bb109fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:43:38.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Ra2lHYxzZTdcpYRG9T7rBjBnm9eG6YXqpMnoc5h8pOMTYwqInsgmCWkdscaSYqikeVZW3/vQF5wUGJzzMmvMOvvHCScpbv3Huo53wBV2dU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5641
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100022
X-Proofpoint-ORIG-GUID: z32x8rEeQS6Be1tysFqt5HqYI9MlU_U_
X-Proofpoint-GUID: z32x8rEeQS6Be1tysFqt5HqYI9MlU_U_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable lba is being initialized with a value that is never read,
> it is being updated later on. The assignment is redundant and can be
> removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
