Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C54EC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767476195D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC3DJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:09:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhC3DJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:09:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U35GxN042132;
        Tue, 30 Mar 2021 03:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tAn0aNZlTZ0vY5htk+YyVsLKrPxz5RHSU4UbFQgVwbw=;
 b=FiO3yCwPJAeon4Y/XVbA1O5wccoIJhtlERBCb3XlELZESGMdo2kpD1q99tasiNOFnx6U
 vrBGcHRAW/3WJMczCSZpWVFqJ7JQtYREwgRQreIVVd3tc1npKQLRWwFr1YnqRknTCM8t
 ySBsQOoz4OobOyxQRDWuMJz6HsK3t1aYzLvLeyFqJ3xN2amA+mf4VApOpZXPV4tuDeWn
 n3x/YvkF3EdFD/Sx59Fmwwh9crlU9Y1/6nk+OS+iBw+fvJkTmO4/T2aawlFuRLEi7YSD
 GVaWl0uz3KHD8bakkKAtsvbrw62GFfjccuTKQVD9P1AGT6wdYbZl51RCM7GC3BtNpEO1 VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5gx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:08:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U30b7j123835;
        Tue, 30 Mar 2021 03:08:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 37jefrjk2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:08:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5ODzrmCLVQokDd+0N6iXzUKgBQA1Dzi4DSZkjxPYZkwdiH1kLWIYbmFd4uh3DY5s4fXAC6EFcddD480BPJ1eh8ecBSJc9PBsdBBEmLODlfagPpUlKAx11+tgtLR61fnuf+DlSCWK44sbpp8O/T1PhB8MO7XR4CWXRVJwjkeL89BD2bvUWXWl4ZwBaEScrH9yxr47Zhk5xwWNgpbCH6vkSWpXsr6yXSWaXeXEBx5xa3nhzC5F2KB0DYIb65rC6cELRn8kBaauwXUhhGtEpqLzyCiPgIHlW8BopGHFqK5yT/ow/yco5CaN9BSHrSXbYSSIOLfmndl4uC1PRvMREulkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAn0aNZlTZ0vY5htk+YyVsLKrPxz5RHSU4UbFQgVwbw=;
 b=dGdLcbrnhiFFyBpTa06YV5LVBVee2eGibr8V7jhdiVXPCiQ6ERnFkP+mwMJCQddjQIF93vmCx6OLGDOn2QJiwvKWvHwh7mN/1CPJkKbENgMgKStg+lvdmIKoP2WbRp70NyFsj9pwhh+uag/etfdWr81kS613oYcRtfXRU5AqllAToowSbDh4fMalEpLrBDvVb21d548vPOHh9iGXTsRWWqk8eNbEJP8QF/hLGdeky2zSkbqUv+Rtg55RgYAzlSwwCL+jBdUk3LPpX/hvdJj8w64rJAkG/2elUo1hp9TsKWhx/3NfPYC3+MSD8fKTbmMGbDl8TyvqvdLcGNrEorJ9Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAn0aNZlTZ0vY5htk+YyVsLKrPxz5RHSU4UbFQgVwbw=;
 b=BJ4SAzzqN7aJmK1PS4AdtTslUlBRseC2Ada8jsgropd1CaW7Ffwacql4cGO33P4T/qDQilQhXHNZKjyCFkj7TcwAF0lCLXbyJ8MGtQRo1eZQHmc24/QgRJUUMQR+dYAmj/SSpASy6l0HXb6YGDHyMwgtX67VMaxD/PYpfgcSbg4=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Tue, 30 Mar
 2021 03:08:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:08:05 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: start removing block bounce buffering support v2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1jxgx15.fsf@ca-mkp.ca.oracle.com>
References: <20210326055822.1437471-1-hch@lst.de>
        <5dad4408-7539-6edd-7aa8-6ddf9af38c9e@kernel.dk>
Date:   Mon, 29 Mar 2021 23:08:03 -0400
In-Reply-To: <5dad4408-7539-6edd-7aa8-6ddf9af38c9e@kernel.dk> (Jens Axboe's
        message of "Fri, 26 Mar 2021 17:15:31 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:08:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202a3ecb-7232-44fd-3463-08d8f32909a4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4471E315B8D829A78129AE9F8E7D9@PH0PR10MB4471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wcSBbU300GRsAy2eGn53OM1/yFUQ89uXUEFZ9sUMJI3Gn07HITPcWpcDeE1kS9/0uzYOGwDFD61jHwNpmYhPbp5jwUZNgHUVeo9aOUrPfAmOA4VtB3lJvPxs/lAf6kSwsRNJmGTYCw5CJWXzLMiOH88bP6yMfiWMKXlTOd4qfwR9QH70Aud+1IjebrVt2lydBI6O8FJpcsHZRFxVxn1tnvVOYMZJU9WBbwPnuR63cUeRv/ZXB9i8LgiDpfTk9gck/4fUXuAA7Qk95hvilPI2GNLTQAoBhYOWE9Py/xtRe2qF7A01YOlk9ih1IzKkloSgyRsajHBja6/MSQpS6foOkooSO6yMEwE6fddguzmD52B58XTkgiUIsv5V527ZoGdJ+CVMxOBvrK5JaqmLA9qgYb6mOJMEXLxt7U9vhqOXokaOSA/xqcXOyM+bodgaAm4NGCRi/DIi/lOzh6k5b7yKtGwqrgo5DaT6IdqnwWmVPrqoaglCAjGbR9l4mrVIIFw/DX8hqKeEuMah/H5BVKAYwZwZeiubYLdJQ8AsQ1ACE+hnjWnLlsXiJG59JUmBVGGTUetQf5xH94eszCaIbMl+hr1nMUd7aA+ulw7CPOTmrg/g6LR0N4AneFGmupfjyoSJHqjMALGtRon208R1V/j9CervqRVUyCwAUToQcVe9iY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(2906002)(36916002)(8676002)(956004)(4326008)(55016002)(6916009)(478600001)(558084003)(86362001)(16526019)(7696005)(186003)(38100700001)(316002)(66556008)(66476007)(54906003)(5660300002)(52116002)(66946007)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ld+kFSy0w+tmynrvfaCUzVIBMlOOuOeAXGkdl3A/JjDipvukM45PItj9SuV1?=
 =?us-ascii?Q?UNfrtK1l+a/3P560843EA+ALSwR4do7tkCGB4BEaSjAEOjrbTTm3+gtXd23i?=
 =?us-ascii?Q?PMJSBjIicCK5Wj4dEnXr56bTphG2eduDDcX10vddW7Vg74CvQJ78V6BOSdm2?=
 =?us-ascii?Q?CBkSK9JUK/wG2bEVlaDTkFlPbFMeUz245xxym7DgG8xGqM+o3haXVmGKCVYH?=
 =?us-ascii?Q?OTb9RGEVVM7BUboIZR//pfGzulyRMUNvRP3AWgutKgaCVO1Be8/0NpNFjzw/?=
 =?us-ascii?Q?tlinwOoDg+rC9rr+pL5cd9L7EY5A0bN2O4v4c3YXgmhqHrred6oy1UaFIZ+J?=
 =?us-ascii?Q?1qiYejln0jmLfE7LjDw9QyqNVO0t3mC8WEO+UNFPZeyiISW6BrA/u1LUSvZY?=
 =?us-ascii?Q?flro7iI/rnVzGejHkUXrqsuJXsovhStxL5sJbGBx/RuCh8MlsqC7riTieRBm?=
 =?us-ascii?Q?bAsOorN/vBQIcF6OdPlk1WsbdbUcaiJRMOleciUeAvo23ktgNafUGlAWdtop?=
 =?us-ascii?Q?LDJ82TaR10ZSaSsG69gLbgOdhZThtIFa9iSeLV/7E2A8Ku0ZeT9JQxdIFDhR?=
 =?us-ascii?Q?HrQWyyLJRAgyuG1Qmn2AjKwWDxIrP+ZPHrb0kbUByGzzGMiCRu3cJfRq6SOE?=
 =?us-ascii?Q?qWOwzSeTS16kPORuTYZiNQlt7dtyAF3aKaRx7YRZA98NTQkFztEZtXrDJD+a?=
 =?us-ascii?Q?vwC5Z+h7DzxC/UPh2Q5MLkjKnYRRjlxOnwVgLWWbHn+v1cao2BEES4aSCKqK?=
 =?us-ascii?Q?ZoleZB4nQH4/TYbGyinx/GkmBS7NasXSLkr/NAugcNz90F3NC/YleVssFm/b?=
 =?us-ascii?Q?d7TF1pHqJV/sF0pSCrCgZq1RIqPjoWRwfm1qqwFQmjpVxDPyoSjqCe6Yj01g?=
 =?us-ascii?Q?sS8UXJ6xHHHmaTFRboMhY1lw1XrMv3/C4K5Uf5f4eGIQ6yuP4UrA3Zyv3uKt?=
 =?us-ascii?Q?xLJZbMoEnFH/bwlIrDMiiCQKN9Q4QoxwqXWRdpOiKW0zfC/6RxxHVTZ3qMWy?=
 =?us-ascii?Q?C4uopeh1JWvElZWMnm8BpC8ZD7Qoin+JSxzbZBKf2b0AlNvHpgFyRqtqL5Jk?=
 =?us-ascii?Q?3tKiP41kTGdaHhu+8VBpNFMWYXk4jJmZG6QVx0/DypfbdoRsIsze7DVPIq+Q?=
 =?us-ascii?Q?KGbxLaUDkVwh63JjPFZJy6BszP7xq32HURASH/vWu1mcPPxEKpWt4HNf84QD?=
 =?us-ascii?Q?qpu+eK0ZWB/o89676hiTBByDsi1OdGnoI5FCOqsEUZsz8EkUXllJRvtw9gDz?=
 =?us-ascii?Q?yv9o+TQqt2x3Ov9upbht2fymjIAUfHxM0POvXIIJVxnIdO0V0xqthep985Hc?=
 =?us-ascii?Q?MJgh+TNSKKt1lWs0jR2drLq5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202a3ecb-7232-44fd-3463-08d8f32909a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:08:05.5542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxl3H/Xvoywq8ai/nJSwGEJ91QduZeN+H5ADdAIZDd4B+pNw9IlpZ8DA/Pbrw/tQ2AkoAgrL4icdNcx2A5Pd2Qzi2rOgixSe0NA5a8kstgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300020
X-Proofpoint-ORIG-GUID: xVa56lH5PJ7h1PzBN_ZLZzYlrJw91Q8K
X-Proofpoint-GUID: xVa56lH5PJ7h1PzBN_ZLZzYlrJw91Q8K
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> The core parts look good to me. If we can get the SCSI side to sign off
> on those changes, I can take it for 5.13.

No objections from me assuming the ISA vestiges pointed out are removed.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
