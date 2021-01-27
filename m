Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3797BC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA09C20709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbhA0EWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:22:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbhA0DEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:04:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R316MW114233;
        Wed, 27 Jan 2021 03:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2bt2giP+OfcFGQHxuRaznGO+wQxO0T9cwRBzeWDLAUQ=;
 b=qMf1PkaYKQlL6tV10OmHMi2/xxy2cqfdAD19U0FJzKgvPvZ9EL0MpxDEygpbQtIh0d8D
 OlXQIynTMzItXAqeRoOpc0fzSKSbOdLgscvk20R4LurFVQ+owyeYuDUXUTF9NxIJxKCl
 X8UmzaPUS4571uZ7oubQAbAbaXEOuLShskIMQ7psRK1YlXORdbWcX2SacOksDoCiCKxU
 dTisFslENlm8L8VirmeRMTWicoPkQwpBq1q8qHjNT2JvM8qqW0ctlGh8KGG0PEIF8zZb
 urW0gW4W0aaqUpqfobmonrp30dgeQ4K0f7UU0oGwwAnmiUeLBw7ZY2sJ/BuWSmy+TMD+ VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7qw0qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:03:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R309Gu000774;
        Wed, 27 Jan 2021 03:01:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 368wqx8kv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKN1tF66dQtSFuIAfcG9sD6WkGh0D8B/JzO8B9Gd7r42TmCv1nqDVTLbQasM0esKcjjrqXbVv+QC+lzX9Us1i+i69f05DmyivYhm4yZt42o0ROYbieUG/gIr3ml0N9fXyx9+tcD2gm4eq8lu0JPzU8JAGyl2Z3G923rE4MJLUfIpBwGwlfMscZtWLSJYvn4fbl/0QzCrlnrY8KsNTfbkSm7goQtw86AnzTzwJlV1AMm4COoanwABh6+QYsKDDtym1S1+IPrT1JFojWrA2NZq2ohlEmqsLK2Jxu+cUANgQB/bO+kJm7rObPlFT1o3FcbxiG6OCDjrX8/t0qj2+NZ9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bt2giP+OfcFGQHxuRaznGO+wQxO0T9cwRBzeWDLAUQ=;
 b=C7VKpeNR12xR/1sh3WKY9GbTCpSd2nxC3X7Yx7m8Tr3iVG7snTQZdczPYpcPXG0wNAQy4A1RsYL+O1OvtHUftgraSueM5jjInCEbicowTbrEEptnKLyYWt1MAPvrHIe1BHm+Oq5I95+UKnkIjGzwbXBHRIP99T7CFJUP2sTRyraANCxFCrjE4S4QxCMSTXfbjfp3J0bHvp8VeQufqhvwbDaNhk4JHHJs4dkQCTooSLj5QRjJEd+HEx1RhsxZh+l1Mb9CVdecZ+dfZSWOlvimSd4a+ahvqPhM0QhYe1FeZ78yTHWtjXKbiijPY38e1uv0WIalo8ur4gaTD32EgsUthA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bt2giP+OfcFGQHxuRaznGO+wQxO0T9cwRBzeWDLAUQ=;
 b=C03Pek8JR2W3/nEtBHYo/EDs6wIM5SM1RZO1aYMBogErS9rQlfMQluSFTCGJ2/AnSKCMww5gpjHi5TBV06kD/Mts1qmQSA0ZgkAXh6Kd3C7EsRz1hFyskSVh6wqI/2Umbya4CKaKpMc3IUHW/O776n2xKrH82aA0tA2E4PhZ0FE=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 03:01:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:01:51 +0000
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH 2/2] scsi: ufs: use devm_blk_ksm_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtwvxf1s.fsf@ca-mkp.ca.oracle.com>
References: <20210121082155.111333-1-ebiggers@kernel.org>
        <20210121082155.111333-3-ebiggers@kernel.org>
        <CAPDyKFo_nsZuCX+nVBDTJ5QxZ18mQMx=MssJZtWTfJfFC=u+xw@mail.gmail.com>
Date:   Tue, 26 Jan 2021 22:01:47 -0500
In-Reply-To: <CAPDyKFo_nsZuCX+nVBDTJ5QxZ18mQMx=MssJZtWTfJfFC=u+xw@mail.gmail.com>
        (Ulf Hansson's message of "Tue, 26 Jan 2021 10:57:59 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:903:98::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR20CA0008.namprd20.prod.outlook.com (2603:10b6:903:98::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:01:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09a5999e-87b8-49c0-85f8-08d8c26fe521
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422A0D6AF7B7590C8C0194D8EBB9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eB38DNvc+u+0E+Kb86wvKjy0FMuxgntmzvjdEjXcYNxdxJJPczeszQVoSJVineH9Do8jZlzoWaWEcGuSTzWHPY4+pgi/JlzoHaapOG6w9xtffCnFfnQ7utfn0mcMvNP50bSHPuOQ21De+AcyrlanybsMaLnsVgZK5ACfdY4zmAU2NAhxzYbf+Nfud+VRKj9K5oaWO6Ddy3UU1xSerW+8ccRiKXHNIxhrQO2+ya1JG6MYJnID3QwNXrTu2jlccolYAeOKI17/arfqsMeCaruS11Eevl+D1FAwTy9GRStbH2P5lQ/lBORecia2+7TwUbIxiOyZm/kB1AEfbeaON62+Zf/16idQQox8CkPhYM6HgcTmyUi7rZkvx/Mg46z8Mz3ERHY9BeVEzZAGFRc5btVYAgNHlDuUuQFb1hFw6fTiQLTo9mDd7/mgsHIt0aL7Lu067JqDAtbaVOymQKs/Bf2y28WQn7ja9t2A1aZnmibLAzFZTGOuNT0GLWuMkZWGSAU/jEcySbdMEaXPpLSQaNuMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(8936002)(52116002)(36916002)(7696005)(86362001)(8676002)(4326008)(66476007)(54906003)(83380400001)(66946007)(5660300002)(956004)(55016002)(316002)(478600001)(16526019)(6916009)(4744005)(2906002)(26005)(66556008)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FFAcThC6XRimfXdbzt3rO1jOdpw2Mxa0zMnQbQYpa5pi8IIMqMONp2BfTn4Q?=
 =?us-ascii?Q?kPzYIzt4Ln/vG57uVgBoGyn5l7X2euPHeUq05EgQsEifoMCce8rXtIKoPq5O?=
 =?us-ascii?Q?dsGfBeDDqBjEtyTItRgbCvTa7g7fiBAtH4kTSl6Ye1Lolq1WQ0RKXDCwdzPX?=
 =?us-ascii?Q?lFk6MEdM4jTxYWJl5kGsRTc7UpeKP0CANDlFO2Wi4EpQBVF1dy6NcsCkLcED?=
 =?us-ascii?Q?c/6ZvJRs2QIjeyywzExZYdyO/piRFgeAwZVwLt+AP9Q1gRR7URlsNcdXl4YI?=
 =?us-ascii?Q?HRcC9Qrtc+ygCWcTgfor+SqPlAitEx9sxcLGSswmVn+khAMXiVKbjdsFyBo9?=
 =?us-ascii?Q?8XuJxWegGoC3gFXf8S22mkAeLtBT9dAWXSudqIe9flH+8VOXphrC5pFozYWp?=
 =?us-ascii?Q?w7zDQVNpJIADKIw5p8gAVcDrPSs9bR0S4wGL+rYDPJr83wHIaknCuD4X+K3p?=
 =?us-ascii?Q?+s2OKq981JGwHUiUagrdRezXKcetocUIKpjvjcf2pQghM1ljrc/RGfbPb/CT?=
 =?us-ascii?Q?D1uA+ZaThTA+Wigx+TJbSGnv4ftDxaT5U+jgVpVMLnTTQ8w+G0nES8M6aFgW?=
 =?us-ascii?Q?Mqu1IVDhzHn5/QGTig8C3EBedfDz8rhj+roKxtqFILvIWhn8n0Jz99cx31CM?=
 =?us-ascii?Q?gAyhybiKe6BZuwJL2FhhtfdvksDLBKt1Qz7yMtbBP5BnrDd8I0zkMAyqgb+B?=
 =?us-ascii?Q?QnhZDvkK6k4j6C4BGf8s9iytNkMHC0H30DNVWOMN41GbeFH3UsHJ6bJ8hyD/?=
 =?us-ascii?Q?CyBKN9XZEGqkaajxLL35KwjzBkg3kfJ8IX8zPCSKrD/U+LflSSqA8bDPY+El?=
 =?us-ascii?Q?3DxrFoJvnJogqNm0FzEDvSN2RaEFcAjlLQTBRT4NY3UNNQWsCJihJbA+6m1o?=
 =?us-ascii?Q?I45Os67fvgHsgbJWg4Fmb6lAcBVNkX62YurKDd2UnlGW0XEw/yiSSG17tMcR?=
 =?us-ascii?Q?99KkrojH9Dckqdj8BYkA2QoluxoFstwZsnsCX608XlgsHX52f2HewSxR13DB?=
 =?us-ascii?Q?qlhCPXIcYPC6qXkfiSgwzRXDhmX/OjmogbxmAcygGqhpcIduCxz747EnCxZx?=
 =?us-ascii?Q?Eo/FHRMf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a5999e-87b8-49c0-85f8-08d8c26fe521
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:01:51.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtDnDua5flZMvE/JFbt1nZZ7M2QJ54qbdaRFJtC0HzaNrKDlJyJmXjIW68cwy4BfQGPpN/Yt31J/nGJQige8LgFtuE6tUpGoUCj8JdVJQIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=960 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ulf,

> I took the liberty of applying this one to my mmc tree along with
> patch1, as it looks trivial to me.
>
> Martin/James - if you have objections or want to ack it, please tell
> me.

That's fine. Just a heads-up that there has been a lot of churn in UFS
in this cycle so there may be some merge fuzz.

-- 
Martin K. Petersen	Oracle Linux Engineering
