Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28947C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42C764EE3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBZEAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:00:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38642 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBZEAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 23:00:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3i3uT157549;
        Fri, 26 Feb 2021 03:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1cVpe0JxXT1t9nM5n3YDpXnw1EDJcXQRDcJceKZYYsA=;
 b=ddIXaU/HFQe679FpUizT4hxfRPBFYdnhgUccDh8W7UkNhnKfUQ2NOX1JWrzxmas+C2ui
 rqCHOj6t5gZrh+voiP8kfwui+d0OdFuuKoVRQX8ukq/DJA/qZ0FfdhzlS+N/oQEybo/K
 OQKhDDwRSTX69VImOGHe1wT75Pd+st5TnyTV51q0R8xZZ+tElD7GEoa7l7uEd+9+Sq73
 SD1QISAgJLwtlJwbRfZ5viuQKTGx/CAgtJO5LUQPEKrOZM7AnLz6n61BN9KBqI5FvNA8
 7fxzxhyXj3V2aaLBLx1UzEEuTML2OcK1Lw20guwVRUk9oABJp7C3NPDqs/ywOzlBN8OX qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur8nft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:59:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3kF77035925;
        Fri, 26 Feb 2021 03:59:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3020.oracle.com with ESMTP id 36uc6vcrvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:59:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR6jOLfJQsYr8T50rvLy1v2GIFTEScNmgYo2OhBNu0vmrLE1E6jaCXTdLOcdpBEaypkyQECaW3yZ84IjQjq9goBVw78MegQ45bGF7Zz3+xZhtCJU6bDT0C16N5GXr3UKSXnwS/vTNbK65x/oxlf5dQaPyG4V8NCYrNQnGlieHom2S7tR871GHmnDI76vRdQlVFhCOrIc3ulC9onsKNTQs60VEKzopky+17W7mm7e+p4/M78ms2cJNdzn5zYka5lc6xL3aSl/R0D5jeV9iElB/wOwTHjG8LNvXaeSPm/+nzI/CBxTMUtdyLZOJGRKSEveDS+3WtUUiOc9wZLujXq1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cVpe0JxXT1t9nM5n3YDpXnw1EDJcXQRDcJceKZYYsA=;
 b=LIZuGImFdBFHIj67MCfKf4mli5Tr+hM0aBn8b5SomP+ROEp8BkAqaYeZmUA3Yg21AZt6iWxq18Wtdy5hA6EbJHuZufjjlPF1vYw1fKFyIgkv1K/snhgRKoIcuqaQd9Juedm43vtyzVkNiNg8PWo2dXyVG4yfkbfXBn9aKRM0gGrnZ/QAiQeffTAuqPlGV3N9ZIYNkGDbeJZ1NAw5YRpr1F/mSyCSR+ebWaRiOzA5B0GOypkoxYrfSPlDxcK46nB+ON/YmXUrbvhSWh9k8vqwWkmIjIcIODvAm+cLtMIV1goD+wNyEdj9rib4A5qdsg2TbWkPXE+08hWg/Raa1+Yq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cVpe0JxXT1t9nM5n3YDpXnw1EDJcXQRDcJceKZYYsA=;
 b=ZieA7uVOV8fr7B+WwVWqdF4rGRFiH6txhXKtGqPTvmSjWifE9Kq9OQgFvL8p+aF1+L/iP8N3iIB9tk2oDWwCQEeRG8wBnKGjCFtRcu7/etdu5WJLDBOz0rDlCdj/7AtCR+VnWKql8N/6Iv6FxBWlHhwT2yMjHr3VeMeslfp7gls=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM5PR10MB2041.namprd10.prod.outlook.com (2603:10b6:3:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 26 Feb
 2021 03:59:16 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Fri, 26 Feb 2021
 03:59:16 +0000
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with
 XArray
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210224185335.13844-1-bostroesser@gmail.com>
From:   michael.christie@oracle.com
Message-ID: <b36fee7f-6fdc-b5de-3a7b-4396e5f9aab1@oracle.com>
Date:   Thu, 25 Feb 2021 21:59:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210224185335.13844-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:610:e6::29) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by CH0PR03CA0294.namprd03.prod.outlook.com (2603:10b6:610:e6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 03:59:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3beb14-eb85-4211-cfd2-08d8da0ae2eb
X-MS-TrafficTypeDiagnostic: DM5PR10MB2041:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB204181998490C0946D00B237F19D9@DM5PR10MB2041.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NooOSLGCxZVcXe7Hc/Z2DyC79o3zF43yjVEED/VeJ9d9KAwb8Jfc27IaVQXbrW8jGLNxyKLvyrKADYvVy/rPlGrcve63k7YhB4T2vu/OAUbdQ+AufPCuxKZXR1kfOxLnwDnxfs9BWMz6qA63wZzX2Ua/RhsTLW8D0YeGtV/fWTaRVP97R46FY1nAQp344W4mXKFK08ZHddiSiyRdY/zDNFot0O6Vu6WuWlnYPrI5imHog8MlLd4VTz7l11hrbe6L0CC+AVoUFsAONwQiWpbI4P0v87gOEwDN3Kp/auxcgfy9uuLsY7pprPtnEiIZDRcukCqNcYNErp1HQvOeR3TYZmFcituc8M3LbS0WSIoQbjAewXmEm5ix0grnmJkyPBLuBWF0jaUK96Y20PnqgdgDhOLLWSmMXjwmSpqnS7Mtgr8IDKPKcGmmro+XDbKR+o4DScObl/+wXxz/3is4i7K/z2nMDAfTugnD9ImoHYvG/ZMMAg5gfKN72s7pHMGtlLGEz/UeDHB3jb5jjPE+eu/2+jkk2M46kkPijQU7VFjEByQeNIMfEW1cBjLRljPi3ObstPoDJ+7U708A7QvRJI9Yk1eFrOa8Q9l/g/1zjOpu21I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(31696002)(6706004)(478600001)(8936002)(2906002)(53546011)(316002)(26005)(31686004)(66556008)(8676002)(5660300002)(956004)(9686003)(66946007)(66476007)(6486002)(2616005)(36756003)(86362001)(16576012)(186003)(16526019)(83380400001)(110136005)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTR1VVNoTmwrTjdUOVlDVzFvT0JpKzZXRGdORUFvU3d5Z0xrM0RMVHF5MUZi?=
 =?utf-8?B?RkxWVFcyYitFdmd1ZGpqMTRObWJYeFB1bzVUZFliTXRGSTdLWm51cWJOTlJh?=
 =?utf-8?B?T1c3WVBHYjYrRFdOaElNa2hidVFwdFd1ZWRMSWpMWnM4Q0J0Rm9ZZXBzNWFo?=
 =?utf-8?B?OTJjT0IwcjFFclgyUkp5WTdpVWY2YUFPbVJ6Z1NpUjByaVA4RTNnTjF6Qldx?=
 =?utf-8?B?YkVaTWNHbmpKMGlTdjZTY3YxR1prWmxuS3FhL1gvUzhQOFFVNm04S0xVVGhI?=
 =?utf-8?B?SEZmZE1nUnl3SmV0NVk3bW52U0VMbEJSUnc0TytrRHJHeitwRElCYUdHQzBh?=
 =?utf-8?B?Ni85UURsSXBReXRrWGxmblljdTRXcTlYdktLSVkzR0srK1MrSUdCSHdFNWZH?=
 =?utf-8?B?ZWM3RUZZaTd5MUZENC9NNm5YOVI3cGc2RytTaFlrcjMyc2FoWHBqUGdCSlpL?=
 =?utf-8?B?dDFCUmRaS3ZaMzIyUnd1RUk4WkFMTVRYVWdvVmFtcmFWVW9WTUN1RlF3VVd0?=
 =?utf-8?B?bm9Nd1o5TkErcTBiejhzTlRjTTRQOXlVQ213TkN0bWJPTERvUHBrYXQ3OFk3?=
 =?utf-8?B?Sm1EWWtwZXNvd09KM2JsOTFPNDBqTHFEWGJscTVLVWtsZ2w4TFR6Z08zVUYz?=
 =?utf-8?B?M3hWU1kycHF6WjRmN25LbFNrYVFCN0VxeTZRdnBDMkNBVzc5TkNma1RvZDFm?=
 =?utf-8?B?and6clE5U2trdFVKRW5CWXcwVFliNHY3Y1FMWlE3YkVyLyt3N0lLSU9GMXlT?=
 =?utf-8?B?Mno0azVUR294L1lrczY4RTBaYjN3aXRPZXRCSDlUaEY3Q01RdDMvVzFNdkFY?=
 =?utf-8?B?Znd5d0ZmQ0FSWWxHMXNvSHhuaFk2RHF5d1k4T3gvWEN6OVlLdjE0bXJTTVZN?=
 =?utf-8?B?N1NqcmJqb1pYS2pFRjd6UjNsckdpVUoxaEZWcWNpaGNZb1V4a3ZEaEVBUmtl?=
 =?utf-8?B?MlZyR2V3emQ3Wm1HTnNWcnNQY0o3RTJZRXg3Y0o0M3NsMTc3SnB6QjhhVXFp?=
 =?utf-8?B?YVV5WkM3bFltODR0VENrTVFWekx5R0xqbER4M1pFZ0VpNGx4cVVFbzBKcWpw?=
 =?utf-8?B?eGhzdnFaNFVtbE5ZR1U5MThWM1cyQmIyRkluTjQvWWpZLzB2STdJYWJBamVt?=
 =?utf-8?B?bC8rRWc4QjQzQ0U5RDlSb1ZtNUUrdnhENXZ3WHpRSkF0aHl6VGhPWFZnQWJn?=
 =?utf-8?B?Q2hxcE1kUkxURlR5Q0hhUDVpYmMyTStHMXVXeVdxNTc2Qks1QkdHQVFrcnBG?=
 =?utf-8?B?WkpmSmdDTDYyZFgweVVTQmZzL29SeTBpbjFjbWFBbWtya0U2VE01ajJrbEtq?=
 =?utf-8?B?SXZ2L3NENFdmcmoxWU9zdjRMQjJ2Q2hraGtOMzNsSDNwdlFiU1Q5MW5pWm41?=
 =?utf-8?B?QlEzWkRINE8vSllWUmZkQXhSSHBla3NDbmpLang1QkZNQWF5MnVVV0hka3RR?=
 =?utf-8?B?bXBEMWpUR2FGRFF5cTlJaTI3ZktYRHM0NTFiTHlOQVFxUCtCSFhHSUxhUkFM?=
 =?utf-8?B?Y29mVENaMFhQdllrb2lrVkNiTVBFb1EvYWdlUS9IVXE0WHhqMGVwcFVWbHpT?=
 =?utf-8?B?c1MzcFIvNnNnR2VSa2oybHRoSjNrS3hrUFdocWFVTlRPbFoyVHhRajV3ZlM0?=
 =?utf-8?B?L1hxUjZsVUhZYktGRFF1UEVKdEtDOW13R2tUSDlrc3FrUWljM3RMcXhTcnEv?=
 =?utf-8?B?NTlOVldtLzBkMVFVTnNvb3EyOGdJbE5UNXh5Nk1XdDFKS0RVS1lJUmVROWll?=
 =?utf-8?Q?bGnzCjxA+iLYR4yi4UcVcZuuAD+3/bLfkSOMGcm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3beb14-eb85-4211-cfd2-08d8da0ae2eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 03:59:16.6297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iyVQuxtPugBVwuj795gEIDJ0+iKHBMzgi6hr7zQaOA74Sjb57f1lWvhOvOgnz6Qem2r4NrWM67xL2cSiD8lBcVCGbCk83hyC0dnS1peHCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2041
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/21 12:53 PM, Bodo Stroesser wrote:
> This small series is based on Martin's for-next.
> 
> Future patches will need something like the - meanwhile removed -
> radix_tree_for_each_contig macro.
> Since general direction is to use xarray as replacement for
> radix_tree and IDR, instead of re-introducing or open coding the
> removed macro, with this series we switch over to xarray API.
> Based on xarray a future patch easily can implement an analog
> to radix_tree_for_each_contig.
> 
> Bodo Stroesser (2):
>   scsi: target: tcmu: Replace IDR by XArray
>   scsi: target: tcmu: Replace radix_tree with XArray
> 
>  drivers/target/target_core_user.c | 64 +++++++++++++++++++--------------------
>  1 file changed, 31 insertions(+), 33 deletions(-)
> 

Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

I think in a separate patch we need to change:

+		if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
 			goto err_insert;

to GFP_NOIO. There were some users doing tcm loop  + tcmu and
were hitting issues when GFP_KERNEL lead to write backs back on
to the same tcmu device. We tried to change all the gfp flags but
we missed that one, because it was hidden in the radix tree's
xa_flags.
