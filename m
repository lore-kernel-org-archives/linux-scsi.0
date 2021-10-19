Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC53C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D53E60E76
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhJSDLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:11:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22484 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhJSDLq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:11:46 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19INarRk025788;
        Tue, 19 Oct 2021 03:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BmSb7PGYmg+xlrgQfpop+eQF0CNUMxeHW6Mij6kGFag=;
 b=nOEZp0G6VUQ0NjKMCWkvbqFlK6Lvc77f9IAW3Cu3ts8MTuqAsLyMH6aWn4pMehdKOG2J
 B5voCHf9a7W/cvhCZ/+JW+QXMupOLZSe9P5VAzV7wJnTcrXFZ8kEKgAHMgPRKFh8SuPz
 RKvvwUTOegzmUuehRmG0jvpcChv/xvjNSP4+tGZeG5wp5kGhDC/nRJP/KcmbOhahrlc+
 y8A3bf6vkM6DH46Wptx0+z10qAaOaCfOJaV6fXH39iqdDdyMXX9NIYjgNYk3b9AsgAOz
 NBuqMFAFTmJqCvrc6XYqSJF3IXQao2AO4LtMJg3K33Hsv61Ra0Y7LAw/h/2WH1QuAQvN zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyfrfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:09:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J35UOJ185661;
        Tue, 19 Oct 2021 03:09:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3br8grkpbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxQv12WqqQjm1G9XNSWHlh+SO9CNWqDP0l0VWTaAcX0hHhwHUgBD/Ob2gDa+8TCIfcKe909Fz5nNG+iWNb9xqbkNdRjxSOYgisjt5vQcRiD6HqDgOKojp3YrdPpCecg8fQqPCrm7gr74WNOhyZFK0aRGceBw4fN6Ns3lMtJ75CY7YCAhCVo8bs4psmyM39L04fTXWbwN9gQYlXzVF3YFYO5OEFLxL3yY2/psDZ7LJ8YJ0mlsMsqnIU4CSu9nqRQ3FAeHuLFvRYp7ED53CH7Nsq1ZMhsyIKs7r0alLbUqU5H9VBlDK692tHcCVnnSESvXlfJpu0rJHwRxQSFyNCpddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmSb7PGYmg+xlrgQfpop+eQF0CNUMxeHW6Mij6kGFag=;
 b=FdGDsW7qIblnu2c9ChoT32Qn/vUj1pAYoZIcCLs1Fg8RJi05zPBW0yV5gP0Ng5S+4PffAU1ehMQhBxhuPalHzD5Aq73fB9hPAeb5H64MHka71N5Z64YkdL8PE3mGMvo8b9iF4/+jGkENAn59UUs4pfeLZxkWCGW3yNmD0wj3XckRO1f3rvIKNmexEyHWlp5sz9KgeKdyt5JVz5fWNOaoZB+PbRmVuf/1+1VjAiK/gPdOwyYQSDx+t2cC+1wj4cguOt7T32+QT1lMqvLU/+QkULfK3pQTtkiFPlzsIvIyrN+MoO6A2d1nuC3RTKSne0/hdtmKuZC9JlWPqadD//qfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmSb7PGYmg+xlrgQfpop+eQF0CNUMxeHW6Mij6kGFag=;
 b=RY9kegXsLgDyZ/gJjwvcmEJER9W3CLACsmvtGx+3ektdqzABsBRE8QbsgRRGQbqzVOHUbqiJ3+o15lwE/RXsdxkOaRtzkdgN6mVLVVJU1bj65b60Ae9XLcqxRgNmlgaq9LseLUwN8OXA0zo2mUmASIZBkYMVkwKsAqT1qNh2ZCs=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 03:09:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 03:09:23 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aha1542: use memcpy_{from,to}_bvec
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fssxd83b.fsf@ca-mkp.ca.oracle.com>
References: <20211018060802.1815982-1-hch@lst.de>
Date:   Mon, 18 Oct 2021 23:09:20 -0400
In-Reply-To: <20211018060802.1815982-1-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 18 Oct 2021 08:08:02 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:806:22::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.18) by SA9PR13CA0057.namprd13.prod.outlook.com (2603:10b6:806:22::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 03:09:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5af0f11f-8b64-4415-5b0e-08d992add9a5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459780772817F952E84FC8FA8EBD9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FatskVew0kQTIQrhA4uB4j2bBEgUBy0hYXcMg/UQ7RNzGjICr0YVnwTaKLLJvwGoxAv4P5pT66tRc8rywq8Ox9paZDhCZgoik+1APF9kbxwZirEa61nqZ5X51sG5HUrrmWOgvhZs2nP0VIEFIg/lqqLyvAWAs1LtM1i+lMpPrFJZ5SHBd7eN5C59Rh/R8fgq9N54P/8ZJwtB78rWVacwW/rOABKpnmS2N20IlYgvUKh6ip3LGVRPqx7fSgoaDlxxRVWggXzd2d/1M8SttkGYyqlZ+ZPkh1HrbfBdv7uDtOTvdC+ZDUOlxR+2S+TDR0c9LFH6NWSS00ZqBRLyOubcGKS0vNlOxB5kZVkoakZsQv/0jALtvqer/fKnX8Gf7bsY5qF4GT6fJJlunkWt9fWrd5kVkDHDOl9yS7VgQoMGCo/RY1ySsbmkvSKoXuHhkG+xj/TYAnaqjk+5fzhwo44xe1vEUx3SHohE2tA6A8JEoOoEqhzIF9A8zYc7FDrMhib+GA7kmjXqt2E0Gq3mikzuyh3bXMJZVd1ahorHRlZqD1bkkMWzMAbw0oLrpgfd7oZ8ixvWpZ72UMzPiLrdzCjo1oQ0OKd7t2EiAWZb8MQI2Y6cPGP4Xcs1Tvfl8Cwq1XqkZduXjS8gClTolHNZuaf8Lu6YudSgyYO6klTknbnCzrOW1yO9KeH9O+GONgmqiMAeNXjJo89ey75HIlfWpcd0Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66556008)(55016002)(36916002)(558084003)(4326008)(7696005)(66946007)(956004)(66476007)(5660300002)(6916009)(38100700002)(38350700002)(8676002)(8936002)(2906002)(52116002)(26005)(186003)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b2OA27Ne9p9oVupkclY1QnslKVJjjdjqOjDYcIINUVxy39BbcZ4T5ppK5tmj?=
 =?us-ascii?Q?Y+rFY6P+AU0FtWLANci5+J/ug3i4Fri5Pr6xYi63twMmNu5Ql4a9A//CuJPe?=
 =?us-ascii?Q?ycBOmGPu8smsqcBC3uQbbWw9seQwRvEDgMAuM8B+x5HtrhWPqPtt70LU6GD6?=
 =?us-ascii?Q?L0yp29jOx8szOFgrY5+DHwA7R6Nf+31JV4mAFltr6Rg9jaVMXct4JY27FGMe?=
 =?us-ascii?Q?LhySmETE7Cajew4TkSJeHiOmJuywJcpv2inm77a0yvYxV+NCngxBNj4uxkxm?=
 =?us-ascii?Q?wBT+U7xG+ILGiWbmNyA/53/7IeY5Y2KWnhfQMJVjG1vkflRo3QyCrArNMFRt?=
 =?us-ascii?Q?6FhXc6RLN4HhmLpHO0Jw8ZfZchn47mm9IZXRmxdy25AZuKnK+KMrzTCDsA7y?=
 =?us-ascii?Q?4LuuY65Jn/Cru0LwWmi/gg5856Sg4qnlvIPBOE1ajLRDdVRM3YujSLvHowzz?=
 =?us-ascii?Q?0jCX64HxwLAOlv+XTYwKsz64FlHkz56HKVkCDweV8xyQplqcALc20urkeshb?=
 =?us-ascii?Q?OP7CbqwyM95e9RsrvBpEUIM1vfnt+jFeBO0T0eEnDxqxEMRsGiJ+qzoMiqXL?=
 =?us-ascii?Q?ZxTOCUw0v/MvaVdj1t1XjCkScRSPjJUXkpac7bEQnK5hkWR8HL2c2m91dpev?=
 =?us-ascii?Q?nDgEUrePQu1raMUzW7AVRgp9nSi0YCyR/tzw5oSPFvZQ7dRs/PaqMugZHb0S?=
 =?us-ascii?Q?KA5Bt8f6Oz89ewc0j0qWnf5H7N+x62msSGu/m2lAEQ8bXNbZA8BmREjs9A3X?=
 =?us-ascii?Q?ro3wDmrIstQiQ5t5LvCQHig5MThHLG3NGfSDGzkwBsC3ywV2GTSFaV9g4wtY?=
 =?us-ascii?Q?/9BTvCnpg4goIyESy3FNZe101qVdqLzX0kPpU2A0muapsDfUgPWG+Hzezvdv?=
 =?us-ascii?Q?/Egt+1auWzVHIqYhI9ZdQMuWzXev5w3fY2wM8LXbLxNMry+LVDf/f4LUg9rK?=
 =?us-ascii?Q?ZVmGmkrFiVXOeOwdQ7wN693JTI/GwG89YQs5EitvpqehkCBFNpjpi+iuzQ43?=
 =?us-ascii?Q?xWgjxoKiOGPS0zV2DVuYAAFxbsBM0Muwr7I1y0fzGrFNJooUiswKcrpTA8Mk?=
 =?us-ascii?Q?wjc1la/LwZhx79W0rlcqpVhXuGutFuIyHEUBUgxFOegFZq06PaQhkwDZTT07?=
 =?us-ascii?Q?9sFIQn3dMTIDyDwuc3xl5hT4BaH2wuPtwxAAwaqjB9MISFxzdz2WjLmYLoYi?=
 =?us-ascii?Q?GFM9Fqr5mg9E6wkjc2QBEE4HFeN3wbrKov0IkiKJialQMi9r1Qp3xTVAJEnQ?=
 =?us-ascii?Q?UcaPv7onMZYvNyyA5Wesbo7eyqvggB/f8hgWuQEySCfJ6n9gwF5+A0exXNC5?=
 =?us-ascii?Q?Ys/7srafniYyvlDiPqvxlp+y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af0f11f-8b64-4415-5b0e-08d992add9a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 03:09:22.9241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McFTjPBrMNz38sT7+iZ6TlXkrRjwDkn+kCnKSZPhqDyMFIKop3h/X9nsZZj1SDubfi2KQ21mM1jSLoCLjaYxw6Ib5jxXf8cXAJjB4PRQrRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=778 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190015
X-Proofpoint-GUID: 4i8escMIf-r9gwa0qAwxgLS9IADNDIAH
X-Proofpoint-ORIG-GUID: 4i8escMIf-r9gwa0qAwxgLS9IADNDIAH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Use the memcpy_{from,to}_bvec helpers instead of open coding them.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
