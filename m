Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F90C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3879E61261
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhKKJUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 04:20:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63488 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhKKJUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 04:20:44 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB7UGsk026259;
        Thu, 11 Nov 2021 09:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9gYjcwTziqBcLuHVuveaiRLkzOeQ9Q/dFRbZNr+talQ=;
 b=WuokzFQqP3FxQrgbcgWLseGaxWadxL4pJvWtHTprVRHS37U/tGeE01wM8XEWJKF6L8LS
 xbl8GpeQlsSlvcFkbIofMsZ5Q5GgJ/XR5dQR8lNV3NeYOzvK7/d8UsQyXRTrbyitloS9
 NTHb5L7NOwX5qq7Zoy4kYwW4iOkhUfDoXGaytb4D0aJqN6iZ61qLg5eAniyfpfXjhVSD
 0RqDpj+igbQ67xz5Dh57cl7WXJCsN+BMPoTpeGpCYGOc+KoT2D7xx4nzLS/azXB4i4sE
 kISuUo0VfcwyczP73c8OS6aXSx34JMxcYJI9w/lyCn4cyxXZTL+9JOYIJ+wtB46WIoby bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c85nshcsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 09:17:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB9GM5M001703;
        Thu, 11 Nov 2021 09:17:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 3c5hh6jydp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 09:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+FA8gKGllkKvYDNW+trKDLQzwRZBP/FZ9gsgfLM/JHbVLKSC3LJNAfdWKiqWje4GRX0wFTmnKsOHymWPb6tF/82Nb455NDJDr8tpRG8y2gxANnVYBBAbNqvqlmi4dlFFcJbEUuJCbujXe1znZt7sds3Wu6UmV1iXnLyRzNjpsLX/kXOZL3m69vvfVffckkmPkyeg5LkjvvyNM+MhGO40coVu/YQRCoaH+eBCmv0J9x04/zR6qma+b2vk4uces4DiQiAXF9BRopjFoxHgI2ah3lHWExObc90fN/s6O6oU03hdhIBiNcNURiNsaMDr0b+T2xAIP2v/S2DmWAcQY9yFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gYjcwTziqBcLuHVuveaiRLkzOeQ9Q/dFRbZNr+talQ=;
 b=EIVbH4ljSQiFfK/uolSfFXFGzuB8Q+8iT4fvIw+W+5qzmgBYLun8P3tVIfrw8jYzMp1rDsdzIOyiENXvSH35BnodGMK3V6UeZdac+qqIo3nx+iZ2LCBWuKb5G5AWo2SrhGDwkBn+GHR1G22iJ5LnPcmBTsWT91F4gQ8MmqTQ2XjRJERB/TmVIDF6Uvczo3uWOeZ2sA0L7blQcRgaeulk3E3095gBRdk+1dVUAfYjfyt6JYH+RUI2cNx0fxUvsjNSlYJaN0WIIE/i5Jl8MnUjbjErKODgpTUySpkqFzyXiHrUm+JwDGXUsebK/ZcZChYDWtOnC7D6YI7ZqY91lG5Lhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gYjcwTziqBcLuHVuveaiRLkzOeQ9Q/dFRbZNr+talQ=;
 b=Z1rT9ebwhIqoXP5XH0jtj7n7A9ofUE6KmVWX7UQI1bgE/92ZguX4oitefPDqq7Q3s05JxomdMM1Ok90MPc+QLNqJmQ05Iltd7adXRYuFJmAbkeZldpCNPycE7dpFvyGPN74CVavoEKc+zT02AyCcpx0SwEqhaklrWBYRB8charE=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5570.namprd10.prod.outlook.com
 (2603:10b6:303:145::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 11 Nov
 2021 09:17:33 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Thu, 11 Nov 2021
 09:17:33 +0000
Date:   Thu, 11 Nov 2021 12:17:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gmalavali@marvell.com, hmadhani@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix memory leaks in the error handling
 path of 'qla2x00_mem_alloc()'
Message-ID: <20211111091711.GO2001@kadam>
References: <cc2fe0148944cfac5e58339bf98e76fd5c3a54b8.1636578573.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc2fe0148944cfac5e58339bf98e76fd5c3a54b8.1636578573.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0043.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::31)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JN2P275CA0043.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Thu, 11 Nov 2021 09:17:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f53b72c-7279-4ff6-acdc-08d9a4f41816
X-MS-TrafficTypeDiagnostic: CO6PR10MB5570:
X-Microsoft-Antispam-PRVS: <CO6PR10MB557061E3E0D708FB188FE5FD8E949@CO6PR10MB5570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ZRV1cd4KLsBFHH6yLxbCz58srwqoae6AqvMxg27n/hpAwCNXjPM0CA7lu4z3tHD8J6rhOcXSFwXyAbEf72a7YUpXKFjZ8JsTJ+/grCv8Bldw5jAvtkHp1zttfeLS+o17xGKJSOeppcumNUHl550MBZvKZoY+HzMbSVfENwg0eDVPR6rRJv1d8wDslaV+ykySlLiguPzFYh86YglLAhU6g+HQ8xgXNj9hJHeUNJXh2ZVMEhG4SA5Sid6Md5AKDGA5Hi5zPw0yi97yfox5Mi2TPNI7batPVX0k+2QQBxK/uarT+BT8abn4++MLkxHFIdNhtIRinYCABSO+F9Gjr/nPQPM+q+TXSnniT9f+WcnPiaaPFvGjPPuQz7QvtrTTtAU0cpZudtpnfsqcQBdQJCXawijZ5/aB/UnxVCnP/Rkxqi2rHWWCTWeFLUMRk7RehfiVGlWNL7tsHHZBDGo1Fd8f4E7csGlGheDNm58RuhJaqae7u8BRJBvYiC9FBZwtIZoxqRvOG9l1fkFWIIFbMYt/HAkv+SLBQvu9Jgcko879oTk76f/hS+dJUtPLdfAifFUHnhjokXRSfLidu14xO4rXyG9n9NWypZa7NTuELc7B76B812kEfiKwDD7pN0n1eIhPrbfL3jL1ti4ry4iDWgtEedXRzjNxirHu1V3TtoYTZ+QLe0wItXGwcYxosns0ekdzRFYiN5pejp+UvXuF0bCNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(26005)(38100700002)(66556008)(66476007)(33656002)(66946007)(44832011)(33716001)(52116002)(6666004)(186003)(86362001)(508600001)(6496006)(8676002)(83380400001)(8936002)(55016002)(316002)(9576002)(4326008)(2906002)(956004)(6916009)(1076003)(5660300002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xi3t129GmfK11y4Vn7wT87ArEhCE552MAlzykxN1/fGi5+5c5RgqC7mkrcv4?=
 =?us-ascii?Q?DCoq65A31DPDYqsX0hzDEVdyx4FMCLRSiYYlhrQGw6QK4wbZs3j7xhkxzxuo?=
 =?us-ascii?Q?4W+LH/eGc5gTOUC0c2Ha+Bymywd1mH1f7iZiExTYOmduE3b+bmkpRxz21sLO?=
 =?us-ascii?Q?2MuhlZeNVYQq4+NuQNTrrhRqu5bGuApcgOH/iUK+xA9Hn26BQ74aTQH7W3vq?=
 =?us-ascii?Q?NThz9c5TeAXr+I346uKSNo+pJdEcuv35RilfuAC3HS0LauE82SR5f5lJ3v2z?=
 =?us-ascii?Q?ss2ENqLp/sRQISUqZoXgydWa1YVlPpFnw/ZCTe8XssmKM4c578FGKhsfR6sT?=
 =?us-ascii?Q?vYjpw+CSwnkBJhv4CaKICULUqg/hG+9TzdjyEtpvCZO7Nd9pkqI+UpwDXeC/?=
 =?us-ascii?Q?ZLhQnezLaxG4D8+6di4jiNraCVRrLLObJ6WbGw4Lg/k0Mwd5mFrFNGbeXej6?=
 =?us-ascii?Q?HdldfOo5MqHJthPI9KqvJfmwGpNZ6cKqjPlxVo33YJyNjf5k7s9YbpJ4a5di?=
 =?us-ascii?Q?pu144Cvc/mTfDkhxjmlXXT8YLyyqQnwnYXzw3eItUnLy+VuP8FXGwOqxMaz+?=
 =?us-ascii?Q?DSHcjpMXEu42YJGyNlTqdCOVgD+XJataQp7m/7QvEIX2JgyNl7eDZDYOiiZ0?=
 =?us-ascii?Q?lSqzAjK/FdqJq2v3HlYYes8tsV8+bGCnHWr2Ti8R3EDaT2MaXW3b1QEg1at5?=
 =?us-ascii?Q?AON7ZsZ34KCHCj/LXeC3ZSqkWIoTc3CZbk3wzbFMFUl35GvVk61Ls+aEZQ9y?=
 =?us-ascii?Q?vZQ0EcCCYLF7a58Hu4gMGd2CtVUDgNmQ0C8rwoul3kCPafq2/XcFv/0lKiQi?=
 =?us-ascii?Q?hDcuDZpkm0/FwAXKQeimvLf5qAjpFz/K+R8eUQBMIJmdTcKW7e/BSrQo+7fZ?=
 =?us-ascii?Q?oIi0oUeJqFI7rV+S+tKCFrAtRxKc/kBR9/Wpctu5Ud2C5e5EyuhNa4qMEfOA?=
 =?us-ascii?Q?tPzwbxWkpFWaF75kJIr6zKS+D4FLCSeOPFNsfVDHFBUjsqohudppDmG186W2?=
 =?us-ascii?Q?S90piVS5nFJXaQDXKu9sxTD27utjWn4VjTyG3UyWIXiqFscS1h+8jAsfv2LK?=
 =?us-ascii?Q?z0lDi5yet2Da83h/gM44hUBIljwwp865Dr/UzOreurOlxL+UvKAZNfBx6DJX?=
 =?us-ascii?Q?wImwY7MpmknlzZWu7+eWe7fGtfq38AQ/29LH+ZMMXDdn2zq4qTRdv8txY3nK?=
 =?us-ascii?Q?w3SH6yQgZUNacRlkIR2aNtp2Aq6G7UL0g1cAFHAWOYrPm0dvEHaVsiru6CJy?=
 =?us-ascii?Q?TfKn7q9ITie3xEFstJt4QwdLzhzBfp5MWKzvka2WYrp4pxl9f71FMcpMAZvD?=
 =?us-ascii?Q?bc37BFl6ZEhfdyddgiwqhw/I8y3OuYkTpPwf3qkBqHJinjqK0l9l5g+0kiUC?=
 =?us-ascii?Q?mbSLxQp8Ny382jdcFvGzWo7IJy0jPpGCARlaqgDRykpen8Rx6Y5QuMU9sA9L?=
 =?us-ascii?Q?Z0rl2sQVfE6j8+7K+5PZ87LRXLcqpz94W/xoFtCkB8inldhCLGXGMJnVQZen?=
 =?us-ascii?Q?wMZnmzR5D2VrdGmuvHU6cNaGYGrKsaj+RnECctBfY4iNBo2F1WW2ZqukZg2C?=
 =?us-ascii?Q?sYFdcMXHX5bLGQXN7GgvMb6SSa7iAwJobUb4x8IpAqGS38a8fvt57D+7BtvO?=
 =?us-ascii?Q?oZR1vW+L+WKbWpux0pf1k8AJHA/dO6QuQIQ+dstBMnLShHUDJlj8maoZoLU3?=
 =?us-ascii?Q?jpGXPTDUq8fKPmYEeX+++H42A4g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f53b72c-7279-4ff6-acdc-08d9a4f41816
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 09:17:33.8427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tnf9BJAPK6gbWKKB8u2uS0oGuv3JSn93tV4XVVLF7dU9mZy+XD0je35t8UyTpeaG6mRgFNTLe62T3pR+0A9gczv6Bapkur0KbmvUApH/chU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110055
X-Proofpoint-GUID: WIlsYQ0-3tHxNpGuBXKq32YkRp5hXhQa
X-Proofpoint-ORIG-GUID: WIlsYQ0-3tHxNpGuBXKq32YkRp5hXhQa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 10:11:34PM +0100, Christophe JAILLET wrote:
> In case of memory allocation failure, we should release many things and
> should not return directly.
> 
> The tricky part here, is that some (kzalloc + dma_pool_alloc) resources
> are allocated and stored in 'unusable' and a 'good' list.
> The 'good' list is then freed and only the 'unusable' list remains
> allocated.
> So, only this 'unusable' list is then freed in the error handling path of
> the function.
> 
> So, instead of adding even more code in this already huge function, just
> 'continue' (as already done if dma_pool_alloc() fails) instead of
> returning directly.
> 
> After the 'for' loop, we will then branch to the correct place of the
> error handling path when another memory allocation will (likely) fail
> afterward.
> 
> Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Certainly not the best solution, but look 'safe' to me.

Your analysis seems correct, but this is deeply weird.  It sort of looks
like this was debug code that was committed accidentally.  Neither
the "good" list nor the "unusable" are used except to print some debug
info:

                       ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0024,
                           "%s: dif dma pool (good=%u unusable=%u)\n",
                           __func__, ha->pool.good.count,
                           ha->pool.unusable.count);

The good list is freed immediately, and then there is a no-op free in
qla2x00_mem_free().  The unusable list is preserved until qla2x00_mem_free()
but not used anywhere.

regards,
dan carpenter

