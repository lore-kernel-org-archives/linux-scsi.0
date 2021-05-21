Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319A7C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E73613EE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhEUVT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:19:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEUVT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 17:19:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LLFjjQ010605;
        Fri, 21 May 2021 21:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=E1EeWPPauoMnXVvTEcS9hqU0gsmyUsAmXx4gIhVaNyY=;
 b=JQGzeH5qRQaoUK+0LV77zi7sfCZyxvn9kB/dfGBu59Vg1kDiqGlXHnNaDdDPHPCFYQvG
 W+EWC5UbrYlQTVbXpLosDCNpz2i6PgPqKTdnBtHIAiN31amUym5sGyp2CCXMyGjfIzKO
 NMw4H5Z8Pcp/q1IQGAs99+JilUOGXWCf0BfbK3bhoMMKkNPvpYnH9Zvpl2F0m8KfpX8O
 Kuh71KNZdSvy6d5cne46jkIRYjJfYPjr/2Uc715s/V+yVA+BPoOl66IAjNLkam8wAF0X
 HsAhZ1NV3FUBq4J1eLfyzZDgO9kKVcYDa0EPiBznAdeqr5OBN3JpxVnRYysqS/K4vcqE 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38j6xnrq93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:17:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LLGPl8007397;
        Fri, 21 May 2021 21:17:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 38nry3u9j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:17:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNfdcprKC37nymjukLzNIaKqdQKu7j7QDFRGwm8jBxr8OeT8wx+Rvgk4WksFD9rDgtm/HXVzurEECZ+eqQb7h8SDpXdBGFHz0Pv1i+BOrUFncaojMIBOM8xVOJyR3rUcceCBxvwWoGZflpbRF1R1J6NaSqKBJicTWs5qPeYpHajAaR2bKlJtVwD6271U90oqhLROEMfvEPeAIoclWIp7uh/VKFn4Tqgi15B4Axyo35kKPlq9ka9GPbelE6rjS6I38Wskc+UslHGuc05aBsml7MpcQQDzZE2G5zEdp1YAllDttNacs+hDgiydpCO0Ed8hSdzSx3b/Fi1QI+jMUYmo3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1EeWPPauoMnXVvTEcS9hqU0gsmyUsAmXx4gIhVaNyY=;
 b=gvSBhZ5QQxU422SbRUStQZ2fpo9a2eviNCXkphmssxCvbWaH5Z6pla4wum5qIfrZXtvZ9SLZC05LHHQH1m1EhEzjh3dJXtIrX8N+Pc09PN8R8NnuQvQC8UfaMZOfXS2g8gv7QEkboZrLkPkRI8AqWmWVcECE8I8VHGrkNF5CQ5ZzL4fjJabOYsWfxKaoee8dx072Z1RC8IQKoOKrkYarcX4Z0wFSgX+/xN/8+t8Lp/BApfmcA2EweHOviZ3cGGvM42xqsV4QNU63VodTVqBZ/85/7HTBP1zHAOCYAv2ALBPTNH1Dmy9uph0egSAMmXqSwJxXSeldcNsF+WVQ7sSdeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1EeWPPauoMnXVvTEcS9hqU0gsmyUsAmXx4gIhVaNyY=;
 b=OFPA73cctT39LBA/MwakVAaGm6GBP1YFE8w8hmb5F2u1ZtsAYMhA78Ym/GdpnXX4KYcu3CgcZ0ZCj0l70D7diO25nbxV3nuqLJrx0fl4cn/UKQA1NxllScDZykrtc12Sry+9nU4E+BPe+y9bWJpTptvd+lss+se2Ah7qndEgyfs=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 21 May
 2021 21:17:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:17:56 +0000
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        juergh@canonical.com
Subject: Re: [PATCH] scsi: Remove leading spaces in Kconfig
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0nr23d4.fsf@ca-mkp.ca.oracle.com>
References: <20210517095835.81733-1-juergh@canonical.com>
Date:   Fri, 21 May 2021 17:17:52 -0400
In-Reply-To: <20210517095835.81733-1-juergh@canonical.com> (Juerg Haefliger's
        message of "Mon, 17 May 2021 11:58:35 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:806:23::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0067.namprd13.prod.outlook.com (2603:10b6:806:23::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 21:17:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb71dff-0065-4246-75fb-08d91c9de6d0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4693F2D570120CCDD78FE6E18E299@PH0PR10MB4693.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K4wN+A2X6WVSFPzerHCZjKAL2ygzc00xxNUiBaBJVbR+Z+VcZs3R13dgTlmSgkN/nttorHd0y1V9KdbT2EJDDIhIBpTzqR3r3nT4MbtwfaYmt2xRsobQOqMDIrrZuV1UvleWOu0vU1RpYk1mGXv/XRejeEh8SMCLGRIhK3Z1BQxHEHTVG4M2QXUqNLUDKZ8CLHkL4W0VHUh7tT+MZRLEP0b4jjjYnkVumQgQwBz3Jp5rXOVL1/XpWD30/+NC6bYGGZ488Ckr1uJ4mIEgE3Diw/fysklZKoOa1yYxolfVm1VfThxscLtl/PG9RyjMpFhz3LY4gp7t8cKfHraPZxpiBdQZ616CqnY/D1VVqNvcEmL5domaiEiIaV582bKwpZvxcbxdQ1NxNrrPZkGXgCpY8gjpbPhUreZTGOatPFZlyvJMYvYsBihXxNTLSTAEy2nCLKZAhBEWPDu/9h7hbfQn6L8jKvh80TkilA1DMcbBKYq2LAlN7POa+zphw1yUjJ8cxsN5OpB10Jl0oGOUVqpnJjmzRcO0ZuuEqsia4qoaGVtdjg43a6eRMqncJUAwtblSEoPs87V78cxfMCsVBuza8lV0cO8pQcRVPGXPbOF1wZB2Ak7yiYnwbWAgzgEf5we0WJRUpabXXRzeOd/bbaNCLL48POlpXL87I7VUrONy8Ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(396003)(376002)(956004)(8676002)(86362001)(38350700002)(66476007)(66556008)(55016002)(186003)(52116002)(36916002)(8936002)(2906002)(16526019)(38100700002)(316002)(478600001)(66946007)(5660300002)(7696005)(558084003)(6916009)(26005)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UqmUjHhzseLWA6J4tJxBrUQXKsTmwg8YxIgJ7k9cgFxgrinEgZ1FAtRapHhK?=
 =?us-ascii?Q?lMShCMW9NdGMLvA+BHnegEPzQ5QgY7+Panlqtm4XKJkdVVSfxRSdEan1OT81?=
 =?us-ascii?Q?JCK90roheZc+7zr2Fz46p7Hbr1H4i84hdgK+ymaKn01yVQV8b/DLSZ94fEgW?=
 =?us-ascii?Q?UK4UESpXACDMx+7ddo6vpkMZpBkFpsisfIeDd5aQGj7MYp1d9VkSGxO1/Y+s?=
 =?us-ascii?Q?E31RdbncOU9dh6LE/fAfAJpjsn3aazKBgYeLlzIMx++T5VN7+qiGfaoGLKMJ?=
 =?us-ascii?Q?Wy3SCM/OH+vSWQcRaS8AzlVTaLiMvhH14OEP1WYNRT77p8f8yjLaIqsmQl37?=
 =?us-ascii?Q?QCSL+s0CTCd3mpVGMOcDBptOc+9TRh3XPEmbRfpGVu+j/SJKGECNx7TbdMQ4?=
 =?us-ascii?Q?PKYwjz23JhojL1P15lvXJtMpsNMgE0o+mwTCmSOzc2nthwkmOxPJ25Iau9Uy?=
 =?us-ascii?Q?5Bt+Y35rNMi+4LZGqDHhPVMNXOwHNbjNpZIoQ5YNe62Lnd5nrJd/A/Z0KsKz?=
 =?us-ascii?Q?k5LG9A6SmOGDf4BPYoEgFXzV5JvD9kPoVioZc+1Q/wslwjVut8vkbPt2gc3m?=
 =?us-ascii?Q?NFg2WcMvT6zCajtLoLey6IOAO4j7GvM8LToPk+n/ZaZ2OZD9wTfz7QGx9pG2?=
 =?us-ascii?Q?GgMIeH89yBX6/r2R1eOvAIjIBwMjKZKpNZWazvOuJfY1j986qqJ/oE88sy63?=
 =?us-ascii?Q?SwFYvF7/1Y5UQJWeEqyGvCIbZU7J7p1m8T95ku5WnD270Vv7ZvEte5VNqeaq?=
 =?us-ascii?Q?DTkhqOrxlNQBJoHQWm6q+/EXngYFkzojge7al7hwEey9f679FAiAP4pbIzpT?=
 =?us-ascii?Q?p83bD1UWG99pW/zvvdKBChLSFBlHPsGbuVuVpvF/2VczY75cAAwx1vYXs1pQ?=
 =?us-ascii?Q?BMGmBaU68NHaon+ZTfAjrTBleXFydsPUQGrYnSelhgXDZDcQtDkQDy8LIwnj?=
 =?us-ascii?Q?nAP0LxFX5y14Kr+8j+skSBchHxmUSV4JBvzn1nyjPGTUlJsJ1b8V7R+Ym0Th?=
 =?us-ascii?Q?mDy/vujIVjThWYM8Ai9/P6i6sj1o+VCa/nk48XwIq+speF8+C/k0wvtqSrLO?=
 =?us-ascii?Q?TWSO/bLOowGhHAwqH/DV7MNK8y6TVgHIQ7KJjbOXIYSv2EBBwv5O9H9G/POs?=
 =?us-ascii?Q?akuf/YB58gHfCdsvNI2MeN02i+vEpl+GUYq9YCess7VTbEiH0CxQtig4a+at?=
 =?us-ascii?Q?aTuuPv2wFKGPH7bswT0X76QUZvrTmf4ISFpg5DzYiCdCLdzfh6/gCyFkXzYA?=
 =?us-ascii?Q?azEir/c00rr9sa5AtoM3Tku37ISjZhQXHb+1aUPYNgwa3+2LpCBtJL9qzmL8?=
 =?us-ascii?Q?EAd0oXRIrcZdx5CX4MYsn5kn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb71dff-0065-4246-75fb-08d91c9de6d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:17:55.8715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/LA09s/yJpMeHmZslPToDF3gzRLA8x1+WM0UdQjDyuhxplWEe2NBynjiqNAN7Ke2J9IzTEkjxOXx9rK5RVwJGk7rVXH8KyGitY+BMO90SA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4693
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210116
X-Proofpoint-GUID: 86kkbJOpBgvqE_PjKKQ4iNXmWLtbgic5
X-Proofpoint-ORIG-GUID: 86kkbJOpBgvqE_PjKKQ4iNXmWLtbgic5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Juerg,

> Remove leading spaces before tabs in Kconfig file(s) by running the
> following command:
>
>   $ find drivers/scsi -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
