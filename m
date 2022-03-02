Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0933FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbiCBEKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiCBEKT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:10:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756D250461
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:09:37 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222eVXv010950;
        Wed, 2 Mar 2022 04:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1rXW3+qTMK5uXpJergIxuj52hU/n/ktxVFwbr/auSEI=;
 b=dMPgDyeuqONXFYh5Km8Ma57RxxQyENhLQsBZ3wwZ02ZsEwN44RaIaqeZqE3EyXzKV2bG
 k5pGxERhGJSrd4h4Btk6sey8T9rGVg2t3MeBD4kWsZUcPDvmAdpSdYyhZajo/RRWLXAq
 6hQ8cv6gd01eJe5dqXbKKSvrVryBHnlE7wXJ84VE6K+r3hnwdZiULgO6hD812B4zcZ1A
 NLjRPACQ4JCR3pGNkEfMGkjsJeLPrqO4miA5g/gRUw+xpyp5JfAD6j1UXbXPwu1jJAG5
 oceGCoqvyZXG6HX181+KJmq0pmcATs3LbKjPWcLObS53Gs5ITsaIePWnExLMJQh9nUfg Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvspk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:09:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2223sprr036637;
        Wed, 2 Mar 2022 04:09:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 3efc15rgka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:09:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AufzTom6+xHGhWLc3d9Rto4YQbIJEa/MpqNvVsWONCAIJQQwadjtmx3bUX01fyPpICWpKO59Vg05LPaJfBjczzU12SlmCJvQjxpt6EcFhlmZX4DoFeQCPbdCPmMkFf7Imv/Z62VRHpApMtN6+y5Ub6/tY+Al27A4ZNBx/e9BZOYq4wARUgRCfOrEsaoIVZaQROnsqtHO7PMMfgg6bVjFoIN7QeJgk530/TlimF41sGnyavtFsGaLUyu6qsiA6ltGVVYl00cCYEuAv6R1YG29NeEWTmETt2EMm4509/7fAvdbbkkbJRu0P/Cz+mcHEEGZYxtsMom3tqHOR6vgZVnA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rXW3+qTMK5uXpJergIxuj52hU/n/ktxVFwbr/auSEI=;
 b=j1HTiqLs0BGEH6wfhwtZeWqMK3DCuxvTvJh17I0f6w0zcg4h+a7sn2TmdKVmK5e92DrZXnnOwJh6Ey45pJncKDJGEKAueWNn0uJ8SWP58OmX/xBD7ngLfi3e+9JWlZx7Tkz31typi8/unHarmJ8aPZsSgew/5sbzllISQrhRBYNRXO7icgHura+6t5SVBXGT0+UNQ/kgRPw7uj4ZCOOQfWlAXhapHjtgXZcMUpm1nRpupL5+LfwmlwmYopxfVHsHlqaBsY41KAjx+n6dtOblp9ZFceWjwNDVVz6zkUUARbitAAte7objxbtODdn12d3SCetDGA0sDfX8C2dRj1mxlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rXW3+qTMK5uXpJergIxuj52hU/n/ktxVFwbr/auSEI=;
 b=udSuBeVk0W6hNFDcC8l0qkvcSpjv9v0nlu5pBgezCbOGGxrONzjLRfaj72cb6VbgMs60IbpW0Nam0Es9Duo+evvxZCffq9pHjOtjhAQJnHgGSnX0Uzdtb6Nkx0jCwshqUG5HbalcIWRMZF254qrOZY4TKHwbKc2xNYJCDgvPXP4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR1001MB2056.namprd10.prod.outlook.com (2603:10b6:910:4a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 04:09:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:09:27 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2] scsi: libsas: cleanup sas_form_port()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fso10zdi.fsf@ca-mkp.ca.oracle.com>
References: <20220228094857.557329-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 01 Mar 2022 23:09:24 -0500
In-Reply-To: <20220228094857.557329-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Mon, 28 Feb 2022 18:48:57 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0168.namprd05.prod.outlook.com
 (2603:10b6:a03:339::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f894696e-398e-4dfb-d2fa-08d9fc027195
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2056:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB205621E1485698B9E761E31E8E039@CY4PR1001MB2056.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HemiwTsJtBsWJgXv75NOdIFzsK0XgXETlRP2v5SY1+yOm/Lr4RSbVShRICSQR/aAl5qLjcf8iQVjnqqorV6qIq8qtNJ0FnuArnWeWL8Qz5syERF3g94AskVfFExbNcwfjEXyJUT8mUZ5dU9MaIB++gEpVgSleE+onXZepE4J1Zjua8qgDesZA8Rf5pq5AAgdEDFFQ2sHXtYc0/fR5fh724Ycxbae4e8enjrwzTUloDao2tPDDBsLFIwgJIQ4ZKu3asm9Cj8cUEogvffKdiIlew2PWInMWIlofjAyo21WNRJE60m7dQPVsuiJJ0S7G+MSyEi5FVMdsN10MAmNWkRoURhvef2eHzoSABv2utEbACb+irv+3wCdd5lFNzloGd9CMAe4IpkXJLeTkSwF6HvEU7V3AbYCmRmjdzvbz/Zcn7u/bJIVdtv8paa1msAgyJUgvD5y3/fuQUlPwJWfCAqr1FhiE3D5IaEfhjye/eBIzwqx3I2VuTQ2+cFCirWe5IVJIJQ64JacQnfRNaTHN1aHNWJFYBFRN37Vcagdq7YOPA2xnQZ+ApAEvdFCjAG+FdWaiUa1nJz7Hgg9EnUb4bRdWtRe7KwSGzTPsvI8F8LgZmqZkIbpzytfz1h6PQPP3E9ZcUftvnAUM910aA7M44TaznviQLfrnXYH0LFbPsMUluMWbve0fiB6rdJpCkUNJG8ZZdw8AHvDvzBFQCKoJxTr9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(38100700002)(38350700002)(508600001)(6486002)(54906003)(4326008)(8676002)(186003)(52116002)(36916002)(6666004)(26005)(86362001)(66476007)(66556008)(66946007)(6916009)(316002)(83380400001)(4744005)(6512007)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yr2xg5XL8y2T2ZBWaPEgwG2UPaEN8srpNtcb9oKnk0fNaTaQgmH+PNcjwyK1?=
 =?us-ascii?Q?egsvscAzmu352eGfZE44dvUQU4qiAbUK9a5YCijiaLGb4U4nBA7kXfmCSZOI?=
 =?us-ascii?Q?6Lk6GCm2NbSR68foJ7rSjJ6VDSNmD+eDGZZ7pl8GdcYfTbml1h//26YJN8Qt?=
 =?us-ascii?Q?GwThCo3oLeROeJnll2ww4f4TCTzBBM9CCT66OIJJZWQViyeW1bgRKuLuS4nK?=
 =?us-ascii?Q?YtsUODpAdTjU+6/fcLmN9gAIQjHveH7WXt+JEP2wAliU+fqwLqt78Wl2Fiyl?=
 =?us-ascii?Q?xTjvM6fF/ps/UCXR0gtdwuP8pwWBZgyQUF07WTnUPPXf9p7CR+Eul+kgfhCM?=
 =?us-ascii?Q?diuVOSOtI14zaGB6hWRJ3rm6IskTbmvR8ggDILB6KK/txBV2zprdzgJyjrsQ?=
 =?us-ascii?Q?25oDd2kU+ex4v98lirAGvMbokxoXUrgLAU1+y4WXXvGHVhzzxRx19h871tX/?=
 =?us-ascii?Q?GdvBvC7v9EEXCrOge4/f7UizR/zy+MMII99rBuIpDMAeVoPd34TtIHzrmigx?=
 =?us-ascii?Q?YC2wUFs9TAjBn+dS6TWv366rFDaIX3tUxEowvYIdkYG0CyhzEYjilXf8p8Fc?=
 =?us-ascii?Q?cyMGgeTi7GELZnujr7MLm/9/w/k9eeV5aSpxyetgmXZHieIfez02dMKvYLSb?=
 =?us-ascii?Q?IroYs2XnPMRdIBsaYmHWDWlBtfh3rgRxjSeBlSIHdrVr+m9vRmC8m9hjYXVQ?=
 =?us-ascii?Q?Hv3t/GK7fNNUqTohke0IeOfKgwuQWvmqv3MN0Dcz7uAmXJW+isRe7k5agmXc?=
 =?us-ascii?Q?7UKMfiiJZvI8vN4g6pgKvdgsQ+4ixIFWdM58V2nqInbmH81BOFt47nPI7Q0+?=
 =?us-ascii?Q?3UiWAsZzzOO/PS9GW0tBjuDFM3dkaVXWM+PWPCoVWdn2HX+kAhpvMd1GLnQS?=
 =?us-ascii?Q?q4wVVSSA4sW6pkQoqJQsbMv9ilwLdz3AheegQi78imnxyPyzzUK67sRFOyr+?=
 =?us-ascii?Q?3L3EwQkyi5MaEnIsgUXNy/DxEIV9zAopwqjvBrjyU/nwsYlMjTubgS7yb43m?=
 =?us-ascii?Q?lQhnILFjDjn/5bBDA70Wg/l9O7Gggam5aV3uHEko+4B6hS/OiFfVlGdrNx+1?=
 =?us-ascii?Q?SAgBzveQEqu69UsRPSTtH7wNNN4IlkFO722F5EZ1wP0h8R9NJ6jNRaVsbHRA?=
 =?us-ascii?Q?+9n8rQkAKUrtGCU+ib3xSG9dna19QDEjxMeNkuT+NC3Og/5vjRKLHGpOwb8O?=
 =?us-ascii?Q?LmZj8x8/TBjc2cc9XwJJDtXOyUDhwh5qZ7gfm6hzOUCBbtR+eOaYWILZOuao?=
 =?us-ascii?Q?6gVNH54fZv0Hd3aGPtx6R/s1X7kfyKH67QLcLNS+6AdRcQMeQK1PZyrRzfXH?=
 =?us-ascii?Q?/6z7zD1+ZNUao4frRd2wVPxK0DxGH/o4rBogj49ZTlmqcOrFmHFm994Am/ai?=
 =?us-ascii?Q?jiVa1nrJXRFpR+AM+kE0UiZOMLgtVT3tI5RRJY8qdrI835HlZmfnwOQZIAYX?=
 =?us-ascii?Q?U8p9/bZIxizB2oXXgR6b6YxvksK8LtflCTf1AmQdMSIsncievdxYc87ATcwW?=
 =?us-ascii?Q?XCb+X05U4FM1iHWNOuXrqx/8l31wOv7UnGw4NM5yU2IXfrxW+dTvJboc3Aj/?=
 =?us-ascii?Q?aAI5m50+NIye+j1uaXExyjvXd6mnHCuNsS67DNbKjZjEsHcafcBwenwi5h/I?=
 =?us-ascii?Q?XGlwrz5SrzuIo9vIjRdK7DkSLU3Oummc6EHrr2mMlbLdytBsPLcftr7idPa9?=
 =?us-ascii?Q?uBdAPQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f894696e-398e-4dfb-d2fa-08d9fc027195
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:09:27.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neC+kR1Jmrbfphs8Up27esR/XsRdpvKnglLKOCJEPqLx58ZpUJgolpqTMvwy7N6MlIV+CeMpM73miOx654PuQczHrVonBkgNwZb5j109pyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2056
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=918
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020015
X-Proofpoint-GUID: Kpo3WcJ93G_aVBM7uejAzJGmKlHpN5FV
X-Proofpoint-ORIG-GUID: Kpo3WcJ93G_aVBM7uejAzJGmKlHpN5FV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Sparse throws a warning about context imbalance ("different lock
> contexts for basic block") in sas_form_port() as it gets confused with
> the fact that a port is locked within one of the 2 search loop and
> unlocked afterward outside of the search loops once the phy is added
> to the port. Since this code is not easy to follow, improve it by
> factoring out the code adding the phy to the port once the port is
> locked into the helper function sas_form_port_add_phy(). This helper
> can then be called directly within the port search loops, avoiding
> confusion and clearing the sparse warning.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
