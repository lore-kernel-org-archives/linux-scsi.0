Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A3EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8650E64F9C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCQDkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:40:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52534 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCQDje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:39:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H3PMNv094650;
        Wed, 17 Mar 2021 03:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3+J78ja5lWnejA521/j8nwndXyyT8GmCzSXhpdHAZM8=;
 b=ZoO5yf7dw5HXy0rlaq3jm6VcdMhTuM2hOon3HIEFcw3Lg7k0zek3yQ72rCc33qsaYVyf
 Y2fe+N81t/qtNwdFlP6ZK4peiUoEzlackqGxV6yZBfoa4/+KATQdPf16dO5K67+fj4LQ
 1/4Occq5cJ8gRQ8SFtwdngN2tcKrRl2G+sbbhS2KGDmFOtFWBX1S4yLZXkQ601p8WLGc
 6OxctvBk2gZg82DH47M6S9ByZye2S/0QSrZconem+zEpDjxar+/+MOYnuO9hAvvfjP4e
 hhQr8+FsSwSJiUA1wolKPOEfZeuNCAA/6W1SqkyCpLakGAhlkUlQ5GHcncpuu1XDCwkE kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbjrff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:34:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H3Q2eB067756;
        Wed, 17 Mar 2021 03:34:21 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by aserp3020.oracle.com with ESMTP id 3797a223b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:34:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEhauNeGJNFLN4qGBU7MdG3UhV/3NG8v2+JgvcBMyjm5fdgR3nlKmcI6SsiCiYIWPFsaruUQ0D1QnmvyQY4GctVnJexewM7VduCxNBOUxLFm14LwD6OtWt1DyYv+M+ef67tpmZRQadb0kMObfViz2xYSoD+NJKYILq6RZ444M3X/3EwVYv48LhgOZqFCTEMnClCBDPb76ZUb6Rj7Uf5pfPppL8MZi0wBWs7izTlANbiNB/j1rIeNjd5+PA0ToLx3z8/ZqcbkxIrNJxdCwdZ1hzSuljIaEuZN+6P9teNWWWNTdr+CVWwC0VQmRFHWyGUPU8AktEWzGRbFf5raMBKjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+J78ja5lWnejA521/j8nwndXyyT8GmCzSXhpdHAZM8=;
 b=M4IW3eEOIUUO9hODV44l8RcS0k3HgQqzdgSoNfNm7bZaC5/0xIne+pIjzadcocQFRtEKGpxOF8NFy2uuuXwvvau+NfKC815jmNWYeDjJKmPyBJVwYMEVxd1janVaRZLtSK401GWxhvL5xEwky3STc9bcf6Y+//OjxpCJdXdDbrNZJHI3jQ0tcCEOBJd3wgxL+5kYSBBA4BdDLk6koK+JQoiBbsB3ijTl0stQoTCv4FW10srNTUecw89KyHXkXVPF06TA2celuPJnjUy9/3AUUqpti3EAPrO7B3rPh4dyvgBmevIf1Rnnw9WnxokyvPv8RTfV8eShzTS4cy8pmhzOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+J78ja5lWnejA521/j8nwndXyyT8GmCzSXhpdHAZM8=;
 b=u0S82aYk7FMT6ZGk6mkaWlpmj14FuUx3RGysuitZ3ZQ1dc6/zzL/KyXxwzXV4ykKyEGpP0W9hQeiKifUZwnAIDnC0HRJp3N0+/gWpi0DT4XVDA5RU+jVSY6NV9SjS5tb7JRS2HM4kbl7aiBJV3V2D7WgSNK0mvLGYmqrKaWA2Wk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4726.namprd10.prod.outlook.com (2603:10b6:510:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 03:34:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 03:34:19 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH] scsi: ufs-pci: Add support for Intel LKF
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s6m1mj1.fsf@ca-mkp.ca.oracle.com>
References: <20210312080620.13311-1-adrian.hunter@intel.com>
Date:   Tue, 16 Mar 2021 23:34:16 -0400
In-Reply-To: <20210312080620.13311-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Fri, 12 Mar 2021 10:06:20 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 03:34:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99943916-f4e1-4d9c-b6c6-08d8e8f58c7d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472691638A33412FE05227DD8E6A9@PH0PR10MB4726.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hbCAwa04dT7Uwnv9I3s6aODXEHjgV4HdKdmBrTRQMNZJAa7Gy9i2tFBQnZ3XzLGV6tFsog7J6tAGp0QLwvxLaBbSFYJ4xTillagm6YnDeogWP1ujO8LR0zuRTKNwsXIAFuPQ/pwuS2Dk3Q/Aft3aL+VWW9m7fN4XhAZR9MaSBp20SKrw33sGgsJCNAk6t8ziUreMbH9jzIaTLAwE3WzzKXQoHbBc1tsq41LxIrn1pZ934zwVTF3JHi+JcZZiNAKtUN5Yeeq5MZlVTjKd95uaLsb7FXcFm68iApKWldbY1T+OZjDksIFpAn+7r+W+CqvlP75+Uh45SHiKgNsC5K3eBeyPHdE06MrcdoJSlz905Lp0hexWaRO763cLPmdAzj+CP58P8rjzgYjiV2OI0jmF65sDa87d9GBrSnsAiLQmdA/zc5yoXg92Iy+o5RFkWWyYJ/6coBRgZUn8GUqxb8Phg73hfxDlZdWoqP+vamVQaVd5Pxd1ZGIHNGz9iy9n5LxCQOryUVy75QAKfNYmcl6EDS6vZLfmpiCXQx6/ZLYkGAMzmYxxHKePbV+sukbOqfi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(376002)(366004)(316002)(6666004)(54906003)(5660300002)(478600001)(66946007)(4326008)(66556008)(66476007)(26005)(2906002)(7696005)(6916009)(8936002)(558084003)(52116002)(956004)(186003)(16526019)(7416002)(55016002)(86362001)(8676002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7xU99MyhcZFi4CFP7fnr1wX7rhE0oJYUIEzFTPhNoUNeDdrcJrsWr2UQYxln?=
 =?us-ascii?Q?rhDaDfqREqOVp0E5Myyh1K5V++nIakRcS6rQP9SxBb/zERIT5ybed8dIn9XG?=
 =?us-ascii?Q?CifsgJSeBf00l8UR5dz42m17eO2a3zdxaChPKh4yf8cEpr4l4DOX87sWV/85?=
 =?us-ascii?Q?AgSTKvmj68/hLHt+wBCBlYtLH5VTAkRE45sgIgMYbPG2bJMUHEvabU7o1eYs?=
 =?us-ascii?Q?HfBnsPuwky6BaDYsmiVJoLQlOdZ3zv51W+Dv/7QeyJ/vMP1/lyaPrpKSi587?=
 =?us-ascii?Q?OiXi6QwGZ9KfyQdawWNVmyUxEL9ue95Otv7yYPX7T3Uci+Y4z/mt+l5XISg2?=
 =?us-ascii?Q?vMu9kMnI0c244dsLMgIIvcXe7fEueupXZGiQZBvq9vbDxCfXIyZfB3xEDckX?=
 =?us-ascii?Q?v8FOoMp9H9j1vbdYif1gHqdg3HY0SzsBbzmZ+66tT1Ai5qZ9lBJmh1hk5W0v?=
 =?us-ascii?Q?r7bihSCAwhXw+FY5w5Y6KVGTEYo5l696gXqds5vLP+J4SaUpe5ge8L9gjKjl?=
 =?us-ascii?Q?C+GSeGY8sQRDhLNBoCDuJuVrRDp4Dae8cAm5EFIN7YCmT7K9tqn2nZmSyOx5?=
 =?us-ascii?Q?d1+CuESDYMFhAjRcRt5LTlXUCetDvTZwCSx65I9qb9458aLuf4Lg5lgVERee?=
 =?us-ascii?Q?uVKwyhyRsh0PMeo87FAG8w0+6GJyWfccJlFEGaowxdMM9RXrCH6f0VbeoXap?=
 =?us-ascii?Q?0Maah5aZoLaUDlQhxmUuo+yPg+AOCm5U0od2r7YZahQ18r/b7hXAkbUHU1HJ?=
 =?us-ascii?Q?LYDIb5wh+1/WUQbKe6tByGFoAn/hn2X1FnkKgpEOFws8pgp1gIkXaL+szAnS?=
 =?us-ascii?Q?NyzAVjvm85h9MbubySbJLuOCieoN6KQh0LnD/Xr5ZmbqmEJCNa4zzMc7ULC/?=
 =?us-ascii?Q?XJXbNbE5nGvlnX07JyvoxoGCuc/r8B7y05bGMbxIyu1+k2V9tXCwarEPrNVG?=
 =?us-ascii?Q?0nh2APdwVOaF+R79hKPftRz2xtXf85g9WVAfcevmOekALEsV2pRlRLQdffCc?=
 =?us-ascii?Q?6PpWEA3kdGH3omgO0yVB9nK78JBAeHDJirmFhpjgwI3QZbJKYU5n8efixLOC?=
 =?us-ascii?Q?tcGEmvNlCheNgIoNs6uEzfDWzYg4O9RlwYyd8e/7MXggNFfGPbbVfuhhO/7g?=
 =?us-ascii?Q?wwXQ0WA9DslGidSZRVtT/Q1iyEJIQr7416zfYiw2N2G0RAA20wcwkr4kAldh?=
 =?us-ascii?Q?0Vh3OTFrel6IZAtaQNs3mJaC0BgXDn3PW0PnEHzjtRRO/J98RA6WISflEFzr?=
 =?us-ascii?Q?rskw2g6pWVmAncPmoLi5mxCtxrb4Pg2HqHTE8Sc7ZBHsfhEwBxTRngJlmgDy?=
 =?us-ascii?Q?7QwAiUH436ESk4qYd1yr6R4d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99943916-f4e1-4d9c-b6c6-08d8e8f58c7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 03:34:19.5770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLyGrtTI9a5D2Is4IJWAFEkQdVPk6kYSaUUxnXY2pgq6x/oQJio2tQ3cTH0pwJKy4ETTjfNChyuz6+vXDrJWGvVXmHBebunppd/K5cG+EdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4726
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Add PCI ID and callbacks to support Intel LKF.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
