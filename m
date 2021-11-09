Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8835C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BDF61215
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhKIEGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 23:06:43 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241554AbhKIEGm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 23:06:42 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A923njN025578;
        Tue, 9 Nov 2021 04:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Of0g9vwy4x7LHOSkSkWkc4BNISJL2zKJJTPcHRVjLjA=;
 b=Ct/Y4n34EdqdXBdSrBN4p0+QM4azLecv6n4yEL2l7KPML1DGZ3c3YO7D5Axe4DHtZnyh
 c0mTdfl9YFdIExUWpqVI0KOzZqZ0Q01DIkdXOWd63nwxnV/W125ZTavlfQ6/1kwomKYh
 2ZthhJ0GnFQYGvARExAMrgLLOJYOEsoYKawBxFhuiVWPIr36fWbfbHUPQL4tDaz3Q8gm
 UhhFC88YvVSfbbfdCT3K852xyi+D3RtMdS6KUaNK02lC3mx0b57aoyXBooFHKZg85+jf
 HMR3tHVWP1dR3Yz6+CfQKU9BsJLhNVrpCef3tihW522tgBdNgWPxD89ykYrlYY2tJRdK iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6t707xw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:03:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A93uc4B076524;
        Tue, 9 Nov 2021 04:03:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3c63fsaxjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeReY8rPmiTgG8odS4GFQ7T75AULUpTfk7okKsH2VKw+ezbYq1xXOVsLa1q9XiED18Ss1RKdvyDOCgZxK4HW5UgOEVk6Jzz3Qe6dx7MPYfbXXfIaP4uGskOHlsBxytNo7sLePsgLXr6Bx8GUUBIgvc4GhrCeOGWtiD6oBy2sXEHyBUIhCoO/9zZYYUkbfSFe0cgPCqwh/5SYQ0B1BABM2YpXcyAV77qpFaZyI80y03MKdqO6hhzV2WVIyLe8HGnGGW5J+h1/qETjWYirXbkXyOWPXbXauWiOFe5xiB+85Oe04ucQD+pTpbPwSHj2cWaIaSNjjdjOyMVvdA78cnVX7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Of0g9vwy4x7LHOSkSkWkc4BNISJL2zKJJTPcHRVjLjA=;
 b=ftWZJa1SaPIQc8EoGrIwNBicvRFTEwxvEBZKQyKNsh9u8ly+eLgiAvVOQpJX+ex41uCQiWGAnKO9z1eoSnxzvtJ53n9AwRfvOLK1b0vm3H7YravhYKcIvEjEQpuD61PVjqUXViaTSklNWHdSTrCI7ndHPn0MsOIaxZ09HV89m/xzLhjATPbmwMLkOQmmabe2E5GHvp0UPtNoERb/T3IxRe2bl7KFECwQmKL76C2NuThNOSECiP1bBuJu0njW0X2Jzglda4IDtXccJp8Ubgp/fviQmzPa1jHLAYhUbymciWHm51MdJTCDrq91CP3wGlL2wMWGpetqCHBD+kMXclLLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Of0g9vwy4x7LHOSkSkWkc4BNISJL2zKJJTPcHRVjLjA=;
 b=FTySNxAigNJG4Wu8RK2V0Wx2ogoYEIngKS5k1YCXcGultRRtI/jFVz5fd1fNeDEeUzcbz4VEmouadjMKXlNtEQkshQPUGPmyJTws52nzzss+wkZSBDMkVTEN/2u/1O1DqhXWsz5AEJf+7r3cZIcSorkTVc6CP/jOPOZgPai/cyY=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 04:03:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 04:03:36 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fss6kmbc.fsf@ca-mkp.ca.oracle.com>
References: <20211104181059.4129537-1-bvanassche@acm.org>
Date:   Mon, 08 Nov 2021 23:03:34 -0500
In-Reply-To: <20211104181059.4129537-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 4 Nov 2021 11:10:53 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.57) by SJ0PR03CA0055.namprd03.prod.outlook.com (2603:10b6:a03:33e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16 via Frontend Transport; Tue, 9 Nov 2021 04:03:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e620e3af-d122-4b94-c2c8-08d9a335e779
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-Microsoft-Antispam-PRVS: <PH0PR10MB45194C7F00A76FE177EF895F8E929@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDyEcTXgsU4DyI0H2lfqsgFVCx2y49YYAMy/TSCwLl59LgCelU8Hl1SAyQOmZD6UNFcQPazsZv+H7Gk70yr84biRMeZzFrwbG5FYGliUzO4oZVwjCcaBq1jkXC3QuMLiXH68Dnm41rEoBTHIJR2vV5QBnVd/GVpo6pY7TIlQbdqxRWk9tdipbuWQ8WA/BuXrvxGoC4aDxC3eOwyydC8qg8/CBbOpTB4T9MqUw/Lgnmu4GGnrO/vVFYXPIB9vKE+ewKBHKv0tSlRXi1SQwSCWZ3kyIK4qHZEm/RXugb7iJc57s9+YpvKStYNZwMa4oZPPeRSutRzuDBLQ3aSVUEvGDZjOFOEDJbs8CBQVfNjd6QQsIwEA4RBUsnq2rm0ae4I+fD09zMds6ixXXzS30yfXIqWFo0z0Yyt7QYn8T+NYPDJmt4ZUBbhQeyin2o4U2dVihdxBEs6ciUgey/NwDSnum5u4jZCVPqrGclSINHGnsoaQX+Du1xdZUkmcafrL+2XUBCd8StGWo66MchbEdEEXlXtv4xnbx4v/uBDT9C14319OZDjSY1hIv4XT+Uj69yl1TFxfW/fRj12SRx8yqWx7ILierV2jUJqqENJx2CcCifhdp79MUXJ3Wt6mzIiMix05n99Pa4aiEgeMy/IzAZD0GEhyzpRgiVTQW/loQYk/58GhkAnb8xu0tCVntw/6kGlTXEadoC1hKcL9e96vCziGqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(26005)(186003)(558084003)(83380400001)(956004)(6916009)(86362001)(66556008)(66946007)(5660300002)(66476007)(54906003)(2906002)(38100700002)(38350700002)(316002)(52116002)(36916002)(7696005)(7416002)(55016002)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gq2+l80sxPEI26fYLf/7Wk5FZr0ktKOjdXOprSfsHHVoO4aeecApud46J5hK?=
 =?us-ascii?Q?W6mzH42SA2N4ryLk6QorlOkvCxXBeQrUwwe5GkamtJ93P/cpvZerEHQ8hXIT?=
 =?us-ascii?Q?4ku002E3GAbHsnseGSx/BxFqBEgZuK2s/Nkf+ICUTABoYN5WV7lVvcJbOU2j?=
 =?us-ascii?Q?BUZishljm4SnsBfrrhyejwxiJls5Kxeu2GI+cnWh3yjg/TgYfp2v5gxeqbGG?=
 =?us-ascii?Q?tUC9RMIgXy9Pf71pXOJnR2hBn7JY+TVPPyaVqgtX8GjWz3/C58ShXWcrvIrA?=
 =?us-ascii?Q?SVwMX/irafjeug+E6Xq5zJmoEq1Zs0tEdwrH8FI4MzO9pEtu2i0Ts+0WXebc?=
 =?us-ascii?Q?DSFMGKdY+I5CEbOLiianWyf5ZPzGBcCs5G5fZautllfL39Iva6YcWeVy8U4E?=
 =?us-ascii?Q?yYOs3AsKZHvZFNIbjALrq5U6wgtdZLbJnE7HOz3WIzFD8ITsIByQO8zJ9hWD?=
 =?us-ascii?Q?6jocq8euErsfS5TU2FAnsPIwtFBlBNrnOy10f7yw31Bw8GgSQUmdaMPz1iEk?=
 =?us-ascii?Q?u+j9vFSifretRMw0VZMwBm8K4TTIhh0GZ51UKwHYgwAtyZe1xzQ52Wvgsi5h?=
 =?us-ascii?Q?+9yR90zWGTRs1UlGZLDmN8UAOSzCTS12oSU+KynFxouWAXZuZNcFAY5e7VzX?=
 =?us-ascii?Q?Ba+C+f/132xxOfJZIFtQ5mBy0NKPKN1ZzGodso9YdR9N2b67XFMQcWL0dWrb?=
 =?us-ascii?Q?rN0UBE8o1FUdYLn1JBIvIPkGh32BDLrPYqozmgpQpRPqJYqWsz3ns17BQ9AM?=
 =?us-ascii?Q?0Y/IbherA+1whjjdXw5yxqt9R5eGIJl+6oIt6MXU3TpiWqahVKS4qlGAJGQy?=
 =?us-ascii?Q?smfPmTiarxUUo3bAZsoHtx6pNmnRdGASGUBkUVIxCTdHSvs4zk7nOE1vr+GA?=
 =?us-ascii?Q?/NpAMr+KipPKdB7Ib55K0p/WruBVt/039lZ2ncMiGMWcIGwJbJO7q2hc44MG?=
 =?us-ascii?Q?9sgWpjY/5J5uQ8+pnD4HsHlr+4Jvo3j8V1rZ3gxVK5bD60oU7rWbcZw0QPkj?=
 =?us-ascii?Q?38qXw07B8lfzS9wOyFcXVT3QzVcrtnVCz9QA6fc+TIzqKmGWBU2ZIX/41fVb?=
 =?us-ascii?Q?VJUo8CkdhIHFux8hI5pE7eFc777EdVEZSjavVPHNiZppLq5m7SXhNRcRFBEo?=
 =?us-ascii?Q?0EBPtgWFOV5VKn+9WWkxDpZeV8WYmsKqGEv8nhY3SR5xUJTMSZO6Na3je/U3?=
 =?us-ascii?Q?XaFFToM9C/sc+bWG6sEClBSLjMeRNEZTpVQ6VYLdBhxXg1IsAtaCOqAvoSwS?=
 =?us-ascii?Q?9/u+dqRhiu2nYymzLHPsXgbfIjIzkWDhiVSsumb/tQ86BVAPAJwh0C+H5TRU?=
 =?us-ascii?Q?YVZmgoUE+c/kPnS0TYb8GiVfjWsPPA7ELCUE1ZmSSqyJDJOBviPb5pDB2/+Z?=
 =?us-ascii?Q?Z689bWyh5+15jBwrCvKimQD5CQuMf0CNYH2W7piit//D1pvdXMeB+rEWLTp9?=
 =?us-ascii?Q?nI5Ohuk7zWZDf8Rlz3KivFowK1Napcn9fxpVDMSJ2XE2v+lFKJl7dn329GVL?=
 =?us-ascii?Q?YZVwl/bglqjhQRHNosvgIe4n3Tg6hCu9ugXdsmioujMnd+H2o5ezQ2ipQzb0?=
 =?us-ascii?Q?F7aWNvdi3ndyx/pqcCBqp9rsvk53MC9QTbLK136JG4i1K6IbI+GAeNEipxkP?=
 =?us-ascii?Q?d79JJVFLvXFnRb/OfuO8sb3PxiA8j1YTOB9xMTTMBBpVe7xr0NENlmW/gzai?=
 =?us-ascii?Q?Q+9XhQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e620e3af-d122-4b94-c2c8-08d9a335e779
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 04:03:36.3080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nhBWdubtVmGAKwDxOgj2CBA3DYGL8bIe1ekBBxHmTbckxNhK3CUy0gMp//afLYWRGEliaAXU3negcaYJ1nUDMK2sbcP63msX+TLwJrVoZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=748 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090019
X-Proofpoint-GUID: RxRhyW0KY_4Z335ycj0XHbd4iyyxIb-U
X-Proofpoint-ORIG-GUID: RxRhyW0KY_4Z335ycj0XHbd4iyyxIb-U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> That warning is triggered by the following statement:
>
> 	WARN_ON(lrbp->cmd);
>
> Fix this warning by clearing lrbp->cmd from the abort handler.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
