Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971B3C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6760761289
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhD0Ctg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:49:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhD0Ctg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 22:49:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2hp5N047008;
        Tue, 27 Apr 2021 02:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KNywWrl+Jyy0decvA5oGl7HwFKdRznguRmnyMJdBhBk=;
 b=ReXvxlAaKMcbikauFn8D73GRfX04X6h3JFF3+1oVmESNE2owBF7Fb02T01+kYs3rMS73
 k+nAqupKrR5kCJIQyJHyGx/9nxSQM99mTPU8UKRPMF99I5rN2qFjZ/QqsINKY/RsM3kr
 7sW5N4qw7Yh25IN54tScPjxHJiv3F71BTZjLk5HjgSWSqEVZLppivISQzFk/S6z+1mDk
 APYOukZQl7EJHTHljNb8FiJYg4bkECxIFu6PWRgzauN6epxCwq6x2wzLCRIBwzdi5pVK
 ys2T1qaOQCWOdNx4Q/q+M5UmlvZsdLXgATG0TkprovaS0z2fcxUr0Gdb3IgBoh2JZYi6 sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 385aepuyps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:48:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2fkGI060362;
        Tue, 27 Apr 2021 02:48:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 384b55qsx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:48:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHpEW+ezwZB29/KUOPO2KZ/GaEPMsGPUQLth7l8rx1lzxPHWA48uA2joJ+TkENYZmvBH0WJyS/ZikhcvaeuCnhKHbSCBxc4e5b0QJ/XC5CqH/sKZN32B1NVDmPQnn55HuY6pOJ8ST5pqHRxfhfArpkLjV5ZZTHZivruUGYyELMgiF0ft5VkYIlTS6h84iHF+rbrOFZxmDojJz9q7RV+WNaudR8rdhYuk0snydOIHZ3VvWJwUv10STG5h78Lsxxu4hcFrwr+P46XPXRj+7NgLZ0ShdClqLAniSnSATcopGfdD3nLZndT0RXEiHxVcMjRUzbleumBTKYHLDoIL0+plZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNywWrl+Jyy0decvA5oGl7HwFKdRznguRmnyMJdBhBk=;
 b=LDO+fPaayD1jzFsdbNF7LAYrofoItZXGQf7nFzDkvBLOCfeAaDGWZGFd3yjCvJMV1N46scnDaypiltH0BAeIH98BYRrlUr1Hc8DQfzc6T6lNE6wtCMDNyr4Q7U9BWg2bodv3yQQUlSx/BgGIrhUARD0RQczbW3N1OqJPatnJKrCLxOgf3Z3KIK/K9EkzNezh5p5Ra5l4IYPZIyVVIFn0tEXQ2uBRO2gF9PjjI1taOQ5tZ2ncWHKcQMXayWAHU+s0c45OYYX+jdMVrldlViHZMo4pj8N1KMD2ldf6iCOp0IAJ+fP8KM1wdjXyR5nqEYlYynhFjmt5E1ygkgQoqZdD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNywWrl+Jyy0decvA5oGl7HwFKdRznguRmnyMJdBhBk=;
 b=vpB31AIwiPs/q6mEfZmqkJ4bHLs1LRFxbwHsBsKZRb2QgQxziJFOyndFsc/W2YXEUINjFdW9QOkaZz1QnKyDsaWUTFbX9XAIZrwWSnB/9qZTTQq4p4WRmSinA8Z8/KSvm3X0HHWkoT+wfoWj+40SL4Fhyy8BAfZlSVAYVBcLvtI=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5482.namprd10.prod.outlook.com (2603:10b6:510:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Tue, 27 Apr
 2021 02:48:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:48:44 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: Move * operator to clean up code style
 warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im48o327.fsf@ca-mkp.ca.oracle.com>
References: <20210416094713.2033212-1-colin.king@canonical.com>
Date:   Mon, 26 Apr 2021 22:48:40 -0400
In-Reply-To: <20210416094713.2033212-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 16 Apr 2021 10:47:13 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:806:d0::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0051.namprd11.prod.outlook.com (2603:10b6:806:d0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 02:48:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 187e52a0-7c73-4977-bb44-08d90926f917
X-MS-TrafficTypeDiagnostic: PH0PR10MB5482:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548237E2F9E9B0A59631F4E48E419@PH0PR10MB5482.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsZ/yeivxCuCgkqdLmfQd7pv+lF7LGtraqVL6NvHmDvep4hr2SIy8aVLg7C5qwFt3i0vZKOdfWFDGIkZ9wZEI7ICXWYkuemwlWCr0HZ5MeJVLPgxICvsoDvVa4rYbvCtAXMM3lFm0fDrVPNcg/P1fD2YKRuda8glF5rOGahTK5mEKKmIa0EUBaqQjsNGCiMasJoc3jdca1HN4U40QfBJSF/Bh6pwkx2/yUEpXAnmT3GUmV+Hv96lgB0lUuKVrejogSBhjYTM2mTrxTeQ6C4SXMdN3QeN6dHSqdYogIpSPF5YQlEWZIyLuMj2QHr3KkaEyzvMxphcoCZl7fCk5uM9M1mA4i7gYDW+AK5Xo5QcQNEELd/TOckI2Ov5sSLcxoKq2TDy6ZIILMTOYtffzGtjnCK2QVm4rp5sIxDIrR7fBFlcrWe+nowgju6eQV8Bifjprbd/n847dwTbdzoY0U4LlBWh1GFtOaEQ8E+sWdVOki054kMBKaUh7S+3woHZtdK6eI5EKas8rTNamrWNWE0C+1raA0t91r2y4FpprJqielPpDtdcbUJUeOH0ke4W2mf95Cb0PWjy4ypR2UOKqXjrRXnjhX8dU8nIOIennSuU4aU7vJATIIft5LJGTuwjco89PNtK70iDO1wGlirO6/LMg3ju78lbWatHlthkm6CDfS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39860400002)(346002)(26005)(478600001)(956004)(8936002)(5660300002)(4326008)(38100700002)(8676002)(186003)(2906002)(66476007)(66946007)(16526019)(66556008)(38350700002)(83380400001)(86362001)(558084003)(316002)(7696005)(52116002)(36916002)(55016002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BWWZIbcEPYrVwSqN7NP/FgNkXbe18zH5jTDsGHLJNQGorMZqT3fDWrJDN+5D?=
 =?us-ascii?Q?8eT8lMbFxU0780eXY2utXbnOlH8sW5jbvgV/rbjVVFlzoxDpa6awJ3npXjNX?=
 =?us-ascii?Q?umtjsYOiYA7IXhgA9TKy8RAphQTKGXAMRRnss6HbNZjI7jVOqU3+TZVkKZ0Z?=
 =?us-ascii?Q?UUENjfeUrNneRLwgv7CxsZqETt87PFK0V/YrnnsEF7PJhbWcwy2bVdJez3CB?=
 =?us-ascii?Q?eB6pSw+ZN/WM05N3lG+i6l4pFmZNE5CRjWsrh8d9QpLMP+mdczr7lbgTWIIJ?=
 =?us-ascii?Q?qW3H1dhuCOMdwNng+fdR71eh7XIc1opq5a52K0S9CmYR7sXf5dicr9/rf1Qa?=
 =?us-ascii?Q?IZ7eYcpbhhaTvMagEBPuqw4IVroDgqW3D3xnzwq03M9SLB9kOL3qpbPVJ/DM?=
 =?us-ascii?Q?OUl3Uc8g7DexoOqG5Rn4mhk5CGBDRxdTwAK2sChkUm2Igv+4u+0UJKHdH3fT?=
 =?us-ascii?Q?o3LNPyW8T03qe9kZgxxz1oD8Dl50hzqeSldpaXIYJs5HwXxQMSav0A89+gS2?=
 =?us-ascii?Q?gS5UqDATsVlZTEtQlYwsqY+S2DmtOD5+jyeu/ZnlFhXhUxbZTKRZDuAoG0XE?=
 =?us-ascii?Q?Sz4cEp9m3PAOq+nv8clAohS9ROO5olsedexh7szr1JwJx6IB4S+7ehqrFtmO?=
 =?us-ascii?Q?69LYi1IRykjTWts9NSMjbNYIC8m+WWClluPyLYZ0n4xVx3nZDAdWBS6pZ/Sn?=
 =?us-ascii?Q?iWkRuxoF6cgPxKBPrpJgiSyCMBpwGVYztr3mCukgoJtmCMJbwjWWCSE54YC0?=
 =?us-ascii?Q?t1+3bDjfvgMAxWr+y+2uZ8WUhZE8n7SngZdjIzTudDYz5bWOsO8Eesy8TWNA?=
 =?us-ascii?Q?dG83bEZpRQP+ALbUFj1yLsNTnE5rKYmUCxY6mRfJZw+8ww73egqGjcwzocNs?=
 =?us-ascii?Q?6J3ImskIS+MJ2/vxS4kNN4L/LwOoMRjXRXlbpjlJcdEz9w9vuam6thfZoNij?=
 =?us-ascii?Q?Ot1freQpt4WGoIQZqOfGDSFxbgT0KkkkPwHp+3XOtrIPl+LyK1mFzWZNkJr5?=
 =?us-ascii?Q?spm/YQdmMHVHVYRUT1njtC08331YFKgEJO4TKI0smY9ft99i2mHaVioxqy46?=
 =?us-ascii?Q?mJmFCu1ToPLTssukBWiY+RJAskWePH2BI7iWaGlGT4e0xj3YCjv8KoXK56SM?=
 =?us-ascii?Q?sfB5qZCH3PQ8iBn4uKaqFCCdw3uHPKHADbeERr58uEC5KBCcUcl7Xts4kSXP?=
 =?us-ascii?Q?E2cwEbqYXbH8zIthcAc25jCEOOHj/ooOP0WAN82DD4i3NXKW8bG8pJN8m+1N?=
 =?us-ascii?Q?fq8kH9POzVVkt1NRhKISkMKNNiQ4MrlWxUP9B0nQJNBkczTO6H/2AaP3/8v5?=
 =?us-ascii?Q?8LZrxaUXSsFSzn51pXfHiqM6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187e52a0-7c73-4977-bb44-08d90926f917
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 02:48:44.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5xuEIcMOqOjUWGh4WpsUcjV0jSZibQr1g22/u4SCrEZUfxeM5NCFXT8CE0GdRLBLgFuzYfZFBS+P4BsLnqcsne3qeTAnDeuqqmNorHn3WI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5482
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270017
X-Proofpoint-ORIG-GUID: giSMB8zX_Xe22N6esBq_5RD-e_7MeiGZ
X-Proofpoint-GUID: giSMB8zX_Xe22N6esBq_5RD-e_7MeiGZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Checkpatch is warning that char* text sould be char *text to match the
> coding style. Fix this.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
