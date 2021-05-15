Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A6AC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 21:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563156135F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 21:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhEOVIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 17:08:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbhEOVIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 17:08:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FL5LaP132826;
        Sat, 15 May 2021 21:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SdU+BlbwFqd9LQ3ieK4wP/t+hrfNRygFtDRF7TWP88M=;
 b=V9N9V0sgCxwsxdxboAWZGHkD/stPf2fnVZi1lhI/SMvoag4vEQoz+gyoMf+ZmSDHhUkA
 ZBPvBUIbR8DIHDkzsUbxevbfRJTEBOceW5OClaaUf0paFvVGIaaw4O917fRewGO9TLNk
 2LynuSKJfIKMMVSJ2PDvsaj/DWRvha26ohOAbPjL+9L65P98+ubrIGWVrNxJk2LNL/Wd
 HfmDJK/QaxxIXKs8WMT8dEHEGQOqNrYN0fgDrIS1bu1EEJHS2hcBWtmGxYdonQfZ8kLf
 ZXvIGbGIqHP/MHggWpteDLlRxiwagdZK7IlPYuGLUaS1pVqusJUL0VRgA2QzngFhE7Ry 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38j6xn8nvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 21:07:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FL63Au081461;
        Sat, 15 May 2021 21:07:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 38j4ba1rfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 21:07:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXWMS2BqVAthrF6+u+J7OGD/4iA4WKj+BWY1Hs+xeqq5nx3U63K8tWH8bFcCxU7Cz+McLMyym0a8Ga4Vm0sOSD2ZPXU4iDIQpidnItb3WHdVZHhRNWilJ7xgxIwEJzMcFEVWhacKx1maHo3B99qoww2ELGQYBx5XnrsUpGe29/Lny8/QhboTv36dtxELmXMJ9dD0ysdEtjg7De+uqwDA2/f4k5X7onQcOuiOT1y+56f9p/nPEIf8G2+1yGIPjLBRokZfmjaaCxmgh5LhyFk4eNufHyfz5Cxf9t/sTmrqis2TabVjPrBKljkAKQ5IeCP/Co85xYNPbnsr4Ri28xZoLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdU+BlbwFqd9LQ3ieK4wP/t+hrfNRygFtDRF7TWP88M=;
 b=gXF9rgsC/wT0J+ck6CMEBw4dcQ9jqQ9bFHNh49etx+IhuwtfMe1ZvSRaM75vwA60/sMlJcIGDTWv5g594rF6RWhpX6tuELdfzK7DcrkA27pI7H53kKaknXrkd3cc/5SQancQ1Is1lPPWt/n/hvLoxmTkbb0Uj2kHn/dtP0GKni0KhQHFr3uWp3jQUBsj47wbYCbPwky6To15zBeKsJKcpjC6sb2YArlAFACo9A1ijaBqMDV31vXpkOmV6Rmv6TVnL+DT/7ejdW8jWb8NTK1TwBh7CT3bbz9SlvQ230SWjOyUpRPycV91CxYmVk+3BXnYt1loScdAI8lpPUkEQHi26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdU+BlbwFqd9LQ3ieK4wP/t+hrfNRygFtDRF7TWP88M=;
 b=a0nN0hJrXvuivAd7kau5xkx/jn6k6YjZ4uHp6TcjTIHG3SpbOSIYNaa1nmPt94cB7jB8ACRTf5UEFykgPRYB4dEbW+6xXa4Uxdq3y3x4yjPrwFyO7g/YYHLTMkH8URCbANUsjSQb5tluJMW1Fwh5BzHtlLZbnBPTerifnQyplo8=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 15 May
 2021 21:07:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 21:07:03 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: Remove usfhcd_is_*_pm() macros
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf8f905w.fsf@ca-mkp.ca.oracle.com>
References: <20210513171229.7439-1-bvanassche@acm.org>
Date:   Sat, 15 May 2021 17:07:00 -0400
In-Reply-To: <20210513171229.7439-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 13 May 2021 10:12:29 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0259.namprd03.prod.outlook.com (2603:10b6:a03:3a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Sat, 15 May 2021 21:07:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f56c817a-4eb5-419f-b2b8-08d917e5635e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546630AA4C613076D3554E008E2F9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaSxYJFfJv2q6LZvFfBySkeROkbxiT732CogMCs3o+1zx4H3ESXPE9DDxgilsbMFE6ST2TJJm6S834a5PUDXHxJxp3zoMxMX5G0OjBOP6nOL5k9I5qshoGzuqMNYsigJhoi3u91i/3uSD6WA4TxLY1UHqwoq7RZLNMiJRpwrz36ZSTuKjvudPx/jT4hKOXh04l7Cq+Sp8fl6+FMb247LgMRg5T+nos54IeES5FRUHbX3spWOFg3T4EcAkQrCxaqh2wL+VE7/DHLuSWZUUJFsq6GuJEwhZIdVhTr1ZmFmzFhuGazLQcPHF2CkBk08aDP5hgVu0K4nfoPuhGqqLyR0Dh44l3LxV+/B6ghha55wGiml1Dbh9UsetciFHeYn2EbaeiLNRfse/YHl6jTO0Tn8BEDNHb6fQuKh3uWPQERlWtMDq8Sh3EmY9LbQjYhpSQ2+D3BDwoADLLz4kFAo1Ta/SdTWnOH8Bl7HQht0j6NKyKhC34XogHJZBj4taOa3TIgq/p3hQNktHmB5ZDJu71pl3sipabqsm6+JHOWH+MXbdxtfVCW/BiAxinOjAWXTVZJ9KMYTVjd5I65pt4nwLnnXf01URO5b+CDo+PfWAKIcxs69IeuWOuJ5cIEb09pv0d6wYI2vGWHtuqTXj0CRODKvml+4TxuLSyWBWFPGes2JLaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(478600001)(2906002)(86362001)(38100700002)(186003)(16526019)(956004)(26005)(38350700002)(6916009)(5660300002)(54906003)(316002)(7416002)(52116002)(7696005)(66476007)(66946007)(66556008)(36916002)(4326008)(8676002)(558084003)(55016002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nXSrfJnZb8dXwVgpT+PZ4++9MDaujjM6UwohcBJfKeFDY74sgQeJHOytSpLl?=
 =?us-ascii?Q?B6vemNE5FJBz7gab2+ata5OG0j22m5Z4+yLR+V5Pzu2DctvpmPAgTc8E010B?=
 =?us-ascii?Q?kHIrE9jyIuGUbVroC7QtOMvkUOlHAoaMuC1d4Io2WjL2EM9cWBhScmD6+mH5?=
 =?us-ascii?Q?hjMF4dJ/01yl1N6APBdZDLAw/w6c96vrdh3BFEL9VY4wOaqskrEzjGU2PSsq?=
 =?us-ascii?Q?vheP0QExC2tQ9P+DFEF8Mym9PpcO/wLhbsUaQ693LjEdkwWDTahLh44zkypG?=
 =?us-ascii?Q?45kvHgM2kTsw6uQZ8TBD8oyMoHBq0jt+6rahqe3cM11XhaG6p7f1IOwjkDS2?=
 =?us-ascii?Q?cfQ2tz7alxzXeG3fmOeZUy6My13Tg6ukvg9RHM4Tk8S71Cb7c73RgJp8nSE8?=
 =?us-ascii?Q?xVV34I5Kx9rpc5Lcir960NrE+xBGCZYmpmxVmlaKbGgzBEmvM27MOBlf/DmL?=
 =?us-ascii?Q?yihdUDexuqFxNC1RCdTivRMN52B9NrX0uWYMvLClCtYnmTRGhL16h3NYC2zq?=
 =?us-ascii?Q?5zZPZ60lhLgJspBtMq+nLU0TxLBKg/xf/54azU8Za4wzykvQqqnCUw+ACXBA?=
 =?us-ascii?Q?wiDYwOmBouqMZP9l+F9NUdWiskKWttBxIEYUpRczoHA7kuNXN5mdhYuf74C8?=
 =?us-ascii?Q?QhlEgQmDV5lc3yUbt/DgZqnUTp5dsjcb/7a6SddOEEvSmu73VUYJSOMcAlcG?=
 =?us-ascii?Q?ZVn1QNznLfDVxqDUc7l0t/8sO/D1m+G2w1sFmZeS6Jl5N85DEc7m3/DPoNg3?=
 =?us-ascii?Q?DcNn0wohW56T0HA/nRntCGZR/hzf3siSCBjjn1eHW2aW8oYrtpa5khwJqmeN?=
 =?us-ascii?Q?mWSzVD+hkmaKkYjFXbyGf1C5PsvfmEwIgwkltQ7BMaxx9kUF72iBiwmqBy+M?=
 =?us-ascii?Q?UNcRoDZyjSZBgp0FTKVo2vWcsaGUGeSkmosoDmx+3nN+rjNTkhouW1ntI6kW?=
 =?us-ascii?Q?HaGhB9nzvp8/oEj7C5bjwaNchGbjTmAB1dVzXCMahRSiINfUaMQwYcLyeC5f?=
 =?us-ascii?Q?YwVE6sihb2RgNJQJX5q6HEuLtb0VCUHin8TCAxtRv/U5gdkI57tC4ZsaPG0Z?=
 =?us-ascii?Q?hIC0PAkwenfKfQd3qQZR3kVoeNO5U2TwCeTwk+Q0XEZX0jyo5VstHaPpCp6T?=
 =?us-ascii?Q?Q24VgC+YAtC+eiYf1kvJiWcBSDqKnf69F/zogCf9PECbJukpKC0as3QCbXIA?=
 =?us-ascii?Q?ubSxUt9K728FVJZb3bEAkP/HnIDFTWpItZKPEuoLDHneq55uwfuI1/2pjw3i?=
 =?us-ascii?Q?xB6JlAylIEEYxAGGzpu4V9QsBgRWPFMIg2WXQsBnIFMbdCLhzuzyK8ERkoyd?=
 =?us-ascii?Q?JDwhRt6dKUJ2GGiHSUoo387J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56c817a-4eb5-419f-b2b8-08d917e5635e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 21:07:03.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEJMEanEuQ3kXNKYKg5W9CwdNYDD08Xk2ssJv0XLbnGUg0JQgBlceJssAlMFU/scahun4EOJcOsBLkc60zE32/GmtaEcjpz+E1ZbCzkTmN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150163
X-Proofpoint-GUID: 6A4SI972VJZGB4EtfAsPrGDHciMkJ4Bz
X-Proofpoint-ORIG-GUID: 6A4SI972VJZGB4EtfAsPrGDHciMkJ4Bz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150163
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Remove these macros to make the UFS driver source code easier to read.
> These macros were introduced by commit 57d104c153d3 ("ufs: add UFS
> power management support").

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
