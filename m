Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F13C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF4660E96
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244830AbhJQCbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:31:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49794 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhJQCbv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:31:51 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNc57h003979;
        Sun, 17 Oct 2021 02:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=v3vQl8TkeyoeX6grZpvYRG9UHOjuS8snMXQ1LtB5HzY=;
 b=0P5WdBoU2DTUvCVD29+bEYRwqLQAbBlv6yLZv+7NVuiR52rbG24f0JeYA5xb3roGuf1Y
 D52mFjIZ2lkkVyUi+uMP9/3mRMD/WDm64sk/21l383Ls1qMr8jk+oqb+wXvW/ALE5l7F
 8WRXnlIChLNciaUb+4p/KafuJs+hRDgwN8oiSMQAirPy2VPpR9MUJiink2fq34PvCJ9/
 TnmE1PdpWO8Vkv0yyXUrbVPhC+Viage7XXUZO7t0Nt1LfcUrcg+v4vHjAeul67q077NU
 +k7dOdk8x1+AVgEPHJbVRYnJPh5Sl+lRppV5rigWAQG9ErR+ImQ3K2DxjzB29BO9tZgI bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6sqmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:29:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2PYKg027770;
        Sun, 17 Oct 2021 02:29:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3030.oracle.com with ESMTP id 3bqkutrgtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:29:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeDNHXzMslVnvrnVO1NUH1SvoN/GjIQQ30KfOXnpwStH0aPYnzQUQkDwitoBEl5CJ9vEugNkZBK6LRlsGtW5+Nh1m3mJs/bPN0rqufqhuiebYo/vYir2nVANlOON/2lJzuZCYUba4c0Ehicjm2H5jbVLbDAHOVAtWV2L49v2aonydHVRh0xpmCW152vHDxGQ3dqKbuO54zB3knzaBYtaIL8wUsPCkETgnczJQihA1LTmF42lRWYU/bFmihMllsbrQMI5Q2JYsYXWPjXkkn5W9CfBh7ksrIiTg5NkZnCZd8Zy2E89axdZ+6RfbDXFHPaDO4wUMEN2aHkpZMhTBzKFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3vQl8TkeyoeX6grZpvYRG9UHOjuS8snMXQ1LtB5HzY=;
 b=GDjR5uafztLRH8q6ZpFNtZPVG92D3B3iNrhkQu3RwmR68TXRtySNG/cYZbyHKflmk69cttZMlBA40/9O50GWFg+Lgdm+C2b4aP6ZqPF2dIanGv2X0f9ZrvjtgffhOLeIkMetJiV/GyT0Ul1c4LJ9uaPiL46DBWMoqko6L9PgqyhC5xsjicAuJBFRR5221WLIA6yiIRWd7ovP6q5QPPNjf4hMzEPI5+HVDMSY/WsGBZCZ/K8C39+op63Yr6bWMYskJR5tvTT9tfcrGwo8sFiwtbBb6ysWpdQSNu8qRow5u0XHvDM+lcOcGR4vVZaT6BTWMptofL7GTwO21vTMFSXIFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3vQl8TkeyoeX6grZpvYRG9UHOjuS8snMXQ1LtB5HzY=;
 b=LRt/1shOf/BhB36Z1K1tupvlOl27eeK28G1yWgLA5kr06jZNstXaebcnPe2TPzRzL/l1ASqniVxqkOAskh+22PQx70Ro5yGfYCcuyL2BbmCGoXW6S2Tg16J8uClBIY7vOYNxP3+6DIg3MwHOW79nUugZh66GFmH+X/eZujdxW9s=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 02:29:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:29:35 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-xxx: Remove redundant initialization of
 variable retval
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k9ggz99.fsf@ca-mkp.ca.oracle.com>
References: <20211013182834.137410-1-colin.king@canonical.com>
Date:   Sat, 16 Oct 2021 22:29:32 -0400
In-Reply-To: <20211013182834.137410-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 13 Oct 2021 19:28:34 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0124.namprd11.prod.outlook.com
 (2603:10b6:806:131::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA0PR11CA0124.namprd11.prod.outlook.com (2603:10b6:806:131::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sun, 17 Oct 2021 02:29:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d8de0e4-0c70-4918-802c-08d99115f59f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55298E91947443FB1FA3A0248EBB9@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2GW8xww4JJBk6Cr/kV6En2mAdPyDt9xnJBb92ncWuvV+wNk/FBxVxvL/ICSVvmhCa8ngxbTFEcaThp1ddLebqdNRI4rYUvwmnesdopL1VtoU/WEMSAV8BHR0OnGSrLgPzvHeM/D83GmON7OCkzbxHFg4JYwEpaCWdreASqscxNikkSb0JqMgTDYXy48G18tE1BkN1AGsXY7DNi8+jCJFrEq+txzC8qtUVoWQMcXXwEwBsDexHYV0WYiWwcpavoK8oO3XhkKetDiOIMN8+EYkCmKgnxCrg0axV8JVJJqEKPTNUuHNpXCSBBqcGBJh8DRZjlxLbN86tor8dCjZu6f5vbtPvN+0R7KsCGAQgMgzks7KoM4ecgaIzNSuL2OxCVB5enssIvTWowL0DAmnyheP1Q38s2b3p9ezPLtJ/urQsGgDgCbbiAh/8qI3Fo4fTX880+AC2PDSFxvcRb1fB0lRgXHuZB0TkIK/wkJdBfB7qUs7rWvF8EbtVCe8/Kpymcp1lZrflS2bypKa5Z3GfgHJUS98pVtKmubwbJB0IFrYOlpp5ZuRdW9jD1YrJCPRicw2FcekuclB6TA1tm42xfpFgf5i+DtFJVyhh4mf4utj601TZp8L8UcGpsYJ7VbmlWft14lNFTDcIjEV2HgrMsACtvWxTHveDqDN7aSQWzQ/qlRWUUekvOFedbDVkXvTbu+7fBIg6iZyiaTpxJxn6WVmO4BQyltc8bNs8OhScgdjlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(86362001)(55016002)(956004)(5660300002)(8936002)(8676002)(54906003)(83380400001)(36916002)(316002)(26005)(7696005)(6916009)(38100700002)(38350700002)(508600001)(52116002)(2906002)(558084003)(186003)(66476007)(66556008)(66946007)(13513002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WzTruKcNKdq3M85v5NOcli3hWXnRcalan4KxhspTKsdz2xYdL7JkXL9BeXxw?=
 =?us-ascii?Q?RSGiJIiq1HeKyMbfgEOZqBYTi6Ey7jaxlaMjyWzueKLLF6ucTZoI5l8qHuUq?=
 =?us-ascii?Q?SToE8NKdlFh4zBeMYVabOlnDay6qSU62l8/FpPr2FgRINFQH7rII+UK4gfPR?=
 =?us-ascii?Q?vgIdOPmPNIAF2HfkbBEZnH+zxZIDbZ8ldesKk6paj0P4HhyU7yrdvZKnP3uA?=
 =?us-ascii?Q?SP4kL/ptMKtJwtRLyBppRajnFK2E5k4RqlSuwQC7cUHfchoKv8jf//19BS5j?=
 =?us-ascii?Q?bCMjD0KrXGSyQTnwa4Xx+NaXeQpESwP9BTQNM3LaD/FKdAuNLCkWYmwaHKj6?=
 =?us-ascii?Q?4yOXIZDwuuU/rl3iexVhoVqATyuRpr2iiIywjajQTI9y2Enn2TOVbmCoX1Yw?=
 =?us-ascii?Q?YrM1aadt0B/ILE1AhwzHVnhXIeJ5Gfw8tDMbM5hhzCi1RVZygsj1nomlCkBH?=
 =?us-ascii?Q?r2lnqoW23uaWUgnI6OfrQ6wAfdarXGEMqTVMFWNZLkINKmZXgcL3HKPPtxit?=
 =?us-ascii?Q?OyzfUrQjwP2GLJvD+0U+UzTpw4OjyL1AydsgWRMT9q7AAft66ddLXFIMazdF?=
 =?us-ascii?Q?vwdPF4uwD62LYyeztkYd+/TjgiMUWJqPbOJnGEpI6uDO0P6Nhg1lMFvr7XNm?=
 =?us-ascii?Q?W5FMhsj9kXmpwMhYaBGt5Ft1SnJAppHJIin5y/raF/r2UYjXJFF/Ab4ROqof?=
 =?us-ascii?Q?DPLS1vaYoVqyrLI7xd0uY64MJl3sRpnNpt/N12diGUUwbJ79BOwwnxMx0MAf?=
 =?us-ascii?Q?igLYhlQ4Le2z669Ws2P0MEYVKq70n1TvXzf1cz66bvCwzdGNdI91sEqep6BT?=
 =?us-ascii?Q?o6AoY1FoBE6mrpD6BajqxO6VbAgqc+/IpBO5PPZC2LO/j8SHbbGg1LZBP8EM?=
 =?us-ascii?Q?2bYIricOe1gINBXbagJe8gBpPDsDgpaKH/7CJb9kMLgX3DrK/17JT9bOWFHS?=
 =?us-ascii?Q?PjkK0HNduakImS+C3HBZVp2RYc0+iwoW9Emk9w1eqbEM3PMPlZFYhcIY91hk?=
 =?us-ascii?Q?ssBsXZlE6pFTYpEkZtUCuLqB9WRWVD1sk0/zVb+SoW/79k+ng9ZkI254vjE9?=
 =?us-ascii?Q?xK/E9v/fIkIRZWgp1WIAVPCNxvJ0QVcJeSDaTElEAbS080X5RZ/xFzGhuzK6?=
 =?us-ascii?Q?jdrVVJqC4mhDBcaCuOCm1sc2mxgegW4MVvLOgfoFo71YBWtuGMkIyc/5Mae/?=
 =?us-ascii?Q?ygQuYMUi5+r2HM0an/ISTiME+sLOY5Qhflf88lJnTSeVT66Y2TQTo4MH4WN3?=
 =?us-ascii?Q?7EQJdBGPwuZhgMYk/Jd5Om/yXqiV14pxCbrTuXTQPI7NFbZ4U1Nfp7pVb10T?=
 =?us-ascii?Q?EtnC2ytWGFplq2HL/I95UkdK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8de0e4-0c70-4918-802c-08d99115f59f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:29:35.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2UH3qhJdfncBPQS/aKIDjiliD5wALNCf2lL9iEfhsqPCUtagNq+lzjWJXVnxNKeWFk8I21D+zpTmgyENCHZal5Wdju2TwaKk9ik8f68klg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170015
X-Proofpoint-GUID: DAd1W9mGxhc4NtFIIIQnBfbNJCJ7ZGia
X-Proofpoint-ORIG-GUID: DAd1W9mGxhc4NtFIIIQnBfbNJCJ7ZGia
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable retvasl is being initialized with a value that is never
> read, it is being updated immediately afterwards. The assignment is
> redundant and can be removed.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
