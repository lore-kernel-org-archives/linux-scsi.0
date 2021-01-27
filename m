Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DB1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FB920715
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhA0EXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:23:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbhA0DvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:51:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R3Y5Sm171018;
        Wed, 27 Jan 2021 03:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2nYrbKSgAQELsK+Nd09TxK2+ceqkhwdDL91AdKt3dss=;
 b=uYkFHqsj5VSk5/It30Xcvb2M9OyB0mjOcLXNbThQStwnEmOjIifXnmZuGQAKT4+ZuNWU
 C8k4oyN8C8YBr90pOsEnYMfQOofg7m87tKH8zEVZwOqWcuf+5fek1fOD818yYrrODGPV
 D5zzC7iRIrXGXBXsONQCGZ39n5Fz5+um4k3mZ3PY4DKeiBo5u4n7DmYkwP5o/EVCy5yq
 0gk6gXcNZtX5DP5IQB88eqOnFvHdxG42HEr1Aulllv6H7uSvryfPLWO8nmWG5LBFZWCe
 J2z6Ss1hiEgtG4yY05a8xlkA0fx7jgi9Gwr7t9B+7tTCNSE4J0Cf43EdeImUDUrt/yvV 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qw374-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:50:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R3ZKti191401;
        Wed, 27 Jan 2021 03:50:11 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by aserp3030.oracle.com with ESMTP id 368wcnr3y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:50:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUe5GlXkACQaHJHYA+hvgs9ZQpvZJAfNGtckLrwuHcSENEWTdGK1p5N1mYVxD+HAeYE/ZIdqQ96D/ewiFVRbhpQ2BeuZgh5Mi3u23QNjs1Cz2XHcLWNYfszXKNwDM/UHaGJ1zaOsZ0CTB7wdUHZARchWHrGt2niRvLXrgKOII/b+0oEjS4+yfe4kDlD7DkoVqRn+9OlMfqNpuHcyiJ8HrGbj9U5AJG/uSOho60p+y30tWMdzQKFLrsZm239hQYN3c3fktRFE39Pc/A5QDM9gc6a+E9RU6tqL0hDnd+cewZtxd3dbQVFcnnQ/htcsYHPyxL3NdOi10Y1bkAKhB8gSJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nYrbKSgAQELsK+Nd09TxK2+ceqkhwdDL91AdKt3dss=;
 b=Abpu3ClOwe6FbCLUeNRHBWpimRFaBIG4CeYMH9HgS1CaRb5i2vj3v/zT6FXeD7a5wEr91nikR+TVgsPledARpeBhPjQvzu6L7yyDTgzmegYviSSiw4WlyBf5qM94kRu7tb7ODG7/bogixZ71LLy6DPwAFpTX9FGPnoAj3hCYihknr6WKkk/a4q9vjnGLi0x7yEkSkTOHoiSNkxVDm8jMZYiZnuURjxjk1p40s3E4NSHWkO2LGx9D89nWEV5frwRL2/9Yrt5HLWnOOzZ9Z/2QbyFNluINLHfDQO2becjeR0CkTwotaViMOLH+HYt9Kut4AJSvy8PNvp6LxS3FF/KioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nYrbKSgAQELsK+Nd09TxK2+ceqkhwdDL91AdKt3dss=;
 b=rgSxE+axwxSPmTpUNSUYoYZSgFnfZioJyc7jyjRA62+t/9ZJ3OX3VWzfFTU+8OJBszwvC3TCXfoihkiHqUE88Feg3gW1p0zd607H0FBG+SjfS40Xjrixat3WjDk2fRN/CvpGQ/qkk4bw6Ng+sMrXIMxNkpXcnW7RlSyyghDAfgU=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 03:50:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:50:09 +0000
To:     Changheun Lee <nanich.lee@samsung.com>
Cc:     martin.petersen@oracle.com, Damien.LeMoal@wdc.com, arnd@arndb.de,
        hch@lst.de, jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        mj0123.lee@samsung.com, oneukum@suse.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tur3vzkz.fsf@ca-mkp.ca.oracle.com>
References: <yq15z3o9vod.fsf@ca-mkp.ca.oracle.com>
        <CGME20210126041455epcas1p2c38ddc3bfe20bcf10217956b47096a33@epcas1p2.samsung.com>
        <20210126035927.4768-1-nanich.lee@samsung.com>
Date:   Tue, 26 Jan 2021 22:50:05 -0500
In-Reply-To: <20210126035927.4768-1-nanich.lee@samsung.com> (Changheun Lee's
        message of "Tue, 26 Jan 2021 12:59:27 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: MW4PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:303:b8::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by MW4PR03CA0196.namprd03.prod.outlook.com (2603:10b6:303:b8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:50:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fa6b203-4510-4468-1755-08d8c276a43f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760D3B78EBEC07B956066158EBB9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8hfLsBkYCM8S9LXbTaJ4Cf0cXGPgHC8TlQQrfXv/XXsM64payxYeUWk1Sc1C9yUS9N5mRFBt79C4Ty7c3s2ae1igxNTNvykKSiTZ+rnbVNQgN3O8omDCeEL4vviqe1Cc5cUQPUFP6CEuUlHtVNIxU2Uv7hR03UqgJS7u1hdz3CZ0YHE8FuNjwDhoS//TljarGcmiYdmNpwpRt88Da+zcRfdhda9/zUDainF5L4X8StutROArH/8hwgvfWWeD3Va+tLBIkIpDRvpPD8RZzDMswYipPRp49De/PSk+qCUluys4l1NnilkfApZINmfxAdEbtj6C1bfYIc1+64sZar7RB1QXYIMEAclnp9MrpkfEiJNQuAts/U7Ki7gZsuCj9O1oiFYytgqyb4urwzuwDjtMHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(346002)(366004)(5660300002)(7416002)(55016002)(2906002)(86362001)(6666004)(52116002)(478600001)(8676002)(7696005)(36916002)(66476007)(956004)(83380400001)(316002)(8936002)(4326008)(16526019)(26005)(6916009)(66556008)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c/IwUKWouTXZiiBdRxO0bGbwU6xRF8vYgRIbGJMdrqefVbPP6vDe8BNhlAZR?=
 =?us-ascii?Q?zMpoagPqXYU1LIhIkTP4HyyVrtAu5yND6jSyvbLBkKlW+YZBUcgxiS5cqr5C?=
 =?us-ascii?Q?rrMtreLzQw5Vip6doRbcQCWr60gRfmZB7HZQTS2dbppsife+8mWnxWlzRRBj?=
 =?us-ascii?Q?g95754uZHtiAAmCi5sADA+m62Mmijvre8QUO0Y8xATAHfvb4TqvlE+QwVYYO?=
 =?us-ascii?Q?dQSs3f7pZfY3+J/R9kVv8Lwg5NdO5l/UHxlT6Q6o5OQvxXEKIPPURpKfioq2?=
 =?us-ascii?Q?uqkeQ3jajZ7cJm/YSidHtrPp6erZC7OeyKvAxaWid11ptMw7Y5KWJ1j9MoPx?=
 =?us-ascii?Q?9HNOpJdyvNjjLwyd9zKLSp88jM0pCElXJIPhMz1UKWDU/2uAzSh5EWwtu8J+?=
 =?us-ascii?Q?fzRnCS7SBfJee8WbzX7El3rU/nQJ8sYNJNLEV/t/yc2upBmrP87Nr18WdvmJ?=
 =?us-ascii?Q?vZLQsU39kbgn3bd9pphH/cWzv8cqQT+sysJ2QABfHVzFiNuM2J5ybTyZX9Kx?=
 =?us-ascii?Q?El/RCQSNgmFx1NJHmXqgQlWfDGIwj6TwTALk7NljSuqcQyDXZMUHHUbESxbl?=
 =?us-ascii?Q?rmurazHghSfOFClpb20+2UNU0NE9zu4BFxdVEvZ/iNuoVoZsxXlVdzJvBvfR?=
 =?us-ascii?Q?UkIiFlOHpytNG9wugl0cOPeUGsyIuxINrxDYiHTGDQxC68tG5I24dw4hLnWp?=
 =?us-ascii?Q?DFs5j7Pl96jPR3fELXF1FbBCCLljwnrWxoFpqeqHgYnIMgge4W1cj++obAlI?=
 =?us-ascii?Q?126N6ym56dpgDDbmUY8Rsapwl7Qz5juceGfO4elT6XVF1GUEvtgEL1Zz4bHz?=
 =?us-ascii?Q?VVEhPhg0x1IWTPOHUBQgjZ9XIhDJEGehg9iEd4Sa5wmUFoGuscqw1xSkQnES?=
 =?us-ascii?Q?QqvccEB0RDnh8jLmphOcnbAZ2LjxIFfXY+F96iir1Pujio+NtftGlndx1WZ6?=
 =?us-ascii?Q?kZZLC+7LY0lAHbiDwIx9osQeYOZNKjR+5Pi0d+vEpy5Iiv3vaodniLiFCiLY?=
 =?us-ascii?Q?dhYWTb/W0BOWXzHb5JJJ2oKwzygEVpLl8oq/9OeOyi8qkv7LK8R5uw8184zt?=
 =?us-ascii?Q?7dFacK5+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa6b203-4510-4468-1755-08d8c276a43f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:50:09.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bm1q68hsYw9VeQ93TXbAqXXUfF9cikNxvvBjE9sTckG/uCtuwoj7mlMNkmJtjscIIKFJyldwnOlARkVCHZy/9/47IRUumYwPv3q8n4zKjY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270019
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Changheun!

> I want to discuss using max_xfer_blocks instead of opt_xfer_blocks as
> a optional.  For example, device reports opt_xfer_blocks is 512KB and
> 1MB as a max_xfer_blocks too. Currently rw_max is set with 512KB only.

Because that's what the device asks for. If a device explicitly requests
us to use 512 KB I/Os we should not be sending it 1 MB requests.

The spec is very clear. It says that if you send a command *larger* than
opt_xfer_blocks, you should expect *slower* performance. That makes
max_xfer_blocks a particularly poor choice for setting the default I/O
size.

In addition to being slower, max_xfer_blocks could potentially also be
much, much larger than opt_xfer_blocks. I understand your 512 KB vs. 1
MB example. But if the max_xfer_blocks limit is reported as 1 GB, is
that then the right value to use instead of 512 KB? Probably not.

If a device does not report an opt_xfer_blocks value that suits your
workload, just override the resulting max_sectors_kb in sysfs. This is
intentionally a soft limit so it can be adjusted by the user without
having to change the kernel.

-- 
Martin K. Petersen	Oracle Linux Engineering
