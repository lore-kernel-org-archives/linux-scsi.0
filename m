Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65234C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1993F23120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAMFiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:38:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54940 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAMFiG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:38:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5OBr8123034;
        Wed, 13 Jan 2021 05:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Yryc2jxh44Kf191pcebg48qacrdBIQY3Uwco1SKLX0U=;
 b=DjYF/jnxHks2451RLxthnIB4CBE6zSvLXoXxqGptiWjAeTMft2wFXPDAIBpynTgM8oDF
 vlidf6UIbj4ACz3XdYAU1ERuGeJSUwrSczA4QULCiWxpuXnVVoacu6pGNerpLZdkgOkd
 Z1psjukTNWq9+GuemEYoZKADLRN28Z10vfTC5tSDsWypu7NT/Xc7Ekyg2GuVXvxJ+rOP
 ojVo08xGvkP7jF7m+lYaHhV+squkSZZ8D69t7XB6DE0VBYfvqTV9PosdM7vwMsYzW/DP
 eMomTFGLcDKiBuyyQHZMCLeSbZn5QLQ62g5U3F4hqPDsVdSKexp6y6iU9Y15mEW9bBid sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1smhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:32:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5QZeP026657;
        Wed, 13 Jan 2021 05:32:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3020.oracle.com with ESMTP id 360kf6v1vk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhEH0UyMyqwJJo6retlNuOURzWI5WHJ6sP56FAn8s76oLP2qfersQKSmMaeovmQanAWMlohTGM5RCxWfNYQo7jbHkWDGvQlSkeXfOJZDuKrNXRgY4y2CwtMjcwvGQmPYlyVcq/XiPoTUWIbONDCC9u8j/Uob1W7t5JTit/Bn7Un4FMj4SPlHuorL5t9l9xBpNWMPRPioNs40UAvCR1NQYltltP7/zCXGGNwWGtlVynNHFhG5T4va+tqfP1YkqCdg2gWR8LdlRaKQj8+nM5uYek1l5KY5u5v7ncjPrOlpr5oxVum+dNyNYOkwdAMLi7TvSuFai8WZCygMhOplH/h0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yryc2jxh44Kf191pcebg48qacrdBIQY3Uwco1SKLX0U=;
 b=ntVgdJ4u5Jgulz4Un4oidFM7CaSivUyHiOppPpBRyDUrlgkaHSshndyVIJwpChLFb4Ik3FSapjiphggHTA7c0UBC9xN5eLdFzc20muPjZjHuAyhY2XIF+mQo38ibNFB9a2KE4kZVBZSpPO38EtInDdTx6iy8nKxzshRlyLdH6sVK69eGJUIRn09jrfYDiU27eaxVqA/og/k5ZwCR2qW0k32i4Fj7ef0j0BK2M2HBTakti4712XWEzKkuqjYvzUBvoEVNuCdCOEGWsA8wLP61mTaA01Z1YbY3G9ngz4CbH53DEJdz8jA2slp399VCxMOiihKCLP3cr6ynT46C52fyWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yryc2jxh44Kf191pcebg48qacrdBIQY3Uwco1SKLX0U=;
 b=XamghtylSWor7A4oowQi04T3LwgEwWa6N+jcBqFk1GTSx4dzRlwAbxUNHNuBApmdXrM6P1XE8nLWj9N0IT9lW2rVYsI+CH/IbizajT9d3eVQq5zMoWu0bntC1M3pkYdWOHdQkRiAgLVe9Q2n5vThoULgoH32YkZ9xRVVEB0gIH8=
Authentication-Results: omprussia.ru; dkim=none (message not signed)
 header.d=none;omprussia.ru; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 05:32:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:32:16 +0000
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Improve comments in Adaptec AHA-154x driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im812yiy.fsf@ca-mkp.ca.oracle.com>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Date:   Wed, 13 Jan 2021 00:32:12 -0500
In-Reply-To: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru> (Sergey
        Shtylyov's message of "Sun, 10 Jan 2021 19:45:34 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0066.namprd05.prod.outlook.com
 (2603:10b6:803:41::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0066.namprd05.prod.outlook.com (2603:10b6:803:41::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Wed, 13 Jan 2021 05:32:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3bfa471-f224-475e-0af2-08d8b78496a5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46948923798C40A4336961938EA90@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtLoTzBwYDV95mKYpj4wYfTVs+SZIWX15C+lQ2zF3c0hFXkDYTsrXP3Izz4RH/e+IX1bNix0JBTHgWxLxLbwYRQvxIjjaK0fzR5xNWbQ7ZRDhdEK4Kf1sgETd34lwkqYJH/8DWzdxy24+8Z3ekHw6jTa65gZZFFa2/9aW5L+rUNednQ7mdBb+PcvFu4uVW1GzAJEPeGMfzM9yiCJp8ffldn+4xIfxnwa9rLNYBoDwl43f+JGaDX3cez4Cl39x8ULOPVECMxMxkYoQHR6MI4+yvS5IhHEPWxgq7NtX44yoEozTZUFFbXvpcWhiw8YAQ0QByISDEwemGdswcRcnpKqcMJMoVUphAFEgw9FGyV2oj6mH2GOsANpKeVxqRPy5p4XM1RjIr4kpjmvF31+gGBpLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39850400004)(55016002)(66556008)(54906003)(66476007)(316002)(66946007)(186003)(8676002)(16526019)(4326008)(86362001)(956004)(5660300002)(4744005)(6666004)(7696005)(6916009)(52116002)(8936002)(2906002)(36916002)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VxH6yoAdENd9sr5M9oVE7l4ko69KWTn2A8wORQaRvoecpqru+f7rIo+8w0no?=
 =?us-ascii?Q?ebHw4mrovDF3DdQPDq6fKTpnoZOMM6SxS32Xn9mN08wlnyGo21//00GwoZPw?=
 =?us-ascii?Q?aivMtq4LyXK3IhYLPBmcesU/6pVrJUtYoP6vD6ZrG4bn1nQqLQ2X7/+GwIYd?=
 =?us-ascii?Q?dZZFk0VMe3qj1mUWE4P5gGb1UtgYUo++LeZqAwWKCT5WTwOdKaqwJrGEYwbW?=
 =?us-ascii?Q?vY72/rBRhH6CmjeEPs0Sc9dk9svLQnDK6QW3rx9jSWvkrD0csvlFKEbBq4Zq?=
 =?us-ascii?Q?4+HK/ZFN+sYuH2x2iI+rhYGZcCkjW8IDNn3MJS99omcHErh+tkEQCWPhGteR?=
 =?us-ascii?Q?R0026Gg2bv/UO5DiWFXeGJgDc7szGIhKu1h1UqgqrCyYuVVG+AQjbtdDQfhu?=
 =?us-ascii?Q?fUVQwdhoYOQf/QfqChOcJ20j47g6SmWczRLSHpTSHOX0olO8ukQVCLQsoxVv?=
 =?us-ascii?Q?jVJfd9I6No61v2LmKqaqnqrYDD2ZnHcLD6+CjRfvhV1InesJpLmjfgxdQvIk?=
 =?us-ascii?Q?Nhkck+wLn3bQmTr0tn6RJegio0IajRWxERMcOxExXxO/w0pHVpNqSLxFEUKu?=
 =?us-ascii?Q?tbDxaWU1PhZVc8mD3F48jSYGYSrcLcnDHQ2cH3bhs4lOQ6BVczRIKjahOIps?=
 =?us-ascii?Q?VeZ0ja+TdVmBmhALKh6BMvqMhs9Pk6i6VnhlRwM/XOKxw4TsLgEV8u1l2YLZ?=
 =?us-ascii?Q?H85g1Lb4aRp45oa0zyt6Y+tzSbisPAfO0aGCH82aRDdpw3/3phslNp2Bi/Se?=
 =?us-ascii?Q?c+j0u6P29JPSKje61C7hrtdFSCJ7hPk0RoeMKkWBhN4H3yQEiG6PtywmaRKr?=
 =?us-ascii?Q?LZw5rCcXRXMmL/2zv7otVaY8Mqg7zFKx+fcEHDgY2x0BEnIpql2ierWOkAUi?=
 =?us-ascii?Q?BCMRn5VG4lFCsj5/wbXzCnJuQNl6nTQDzItZ3uv/WWT8YjLigiWlvcc4Wrgm?=
 =?us-ascii?Q?fXeBAooZiPvAOC0r3Ock8F0jhrPS25kA3bzjKaZ9RGY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:32:16.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bfa471-f224-475e-0af2-08d8b78496a5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51edq3TEHXMxrT1dQh5Q3m0n9ks9L/G+Ubb8vPyMeaWqjyEuSeJWZ8rl8Ok+LLU7pOmwtaq57TkVRM8vhd1rT5pIm9jAgd9fmkb+9foJV+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sergey,

> Here are 3 patches against the 'for-next' branch of Martin Petersen's
> 'scsi.git' repo.  I'm trying to clean up and improve the driver
> comments...

Typically don't take cleanups but I found the documentation bits
helpful.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
