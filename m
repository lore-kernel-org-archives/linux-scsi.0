Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69906C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbiCBEVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiCBEVD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:21:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF051E3D1
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:20:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222dZ9B016176;
        Wed, 2 Mar 2022 04:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kfdTfWXulL21fBxJQUdMEYDj2eYdhlHt+XRRdPtvJG4=;
 b=lq7PeOOLDy+JpJUZ0AwTv6AGxo/8IjlDBR8AhTfYNGSI5UnuMCXw25mZ0SYDUR89zrhy
 L7H/G7+Z9gazeqFq5XgKRxXW5YSyMfOUDcq4QjcuUJvYU5TyG9Q3D4c1qmSLv0VXtGM1
 9k1XP74vcM9Klh7eOyNsd3cjGL9hdelNY+4y9jxuVGh4syLXZKmLe1vIi2A/csBmnBjS
 gpJOge2ROSeeK/cXvKzkjlAwYKjzWTdWujT3GXP5XhTKWh8NQ5xkkHswGPJmZLv8SIGF
 SeGDe3kboKnwYzqsCeXQo2G+fELM3KmgRjjHNktL58XSiVT3BbQJQXcRKs958lxJOg2y Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk9b7x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:20:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2224G39v080601;
        Wed, 2 Mar 2022 04:20:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 3ef9ayujer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEWfCxJZL9nfIwGzqUvKik1uU1ZfWD45CXDjsT5shpGokoHI8lp0UoQ9Duzr1WbrOG6ef+nesjOLoddAjsFyPafzkZzy4m18Mw360qCBToMmx5kuaNjmvLUstUfRI0hoi+0f5eXPC4Cmqus794pkl3ZgFY6nfYGGbw5J4h9S9+vxD0wrvvuislNmxEGckiEfuDR9QL8KGytLUuOAz808SbEbM87sJMvXhb+wZFwdy7VA7KeLsYmvWliT5zebRB8kaPk5kjta5uYfI7APf6AWAyk/N0EjRJ1dkpmY0+Mx6ksqg9+bFZ5QHDDZTifPgz/C+IgsqkQK3h+NpajxE9gPlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfdTfWXulL21fBxJQUdMEYDj2eYdhlHt+XRRdPtvJG4=;
 b=Wu/5XFj6hXmEHEYv2Xjfa/syFomp1WA6P9tmkLlv5zI9JPT7arGkZYdGCYWcjYGheSXlDwyKEqdCLrx/mETDJGygqlLABgSDHVvqfQRwwLMA7hhZmiO7V73erfOmFeheAjcykOSle+kvQvi8eWiCA38Rrk5EZxf7D3xn7dWLhOKD1VaXdzYpNFbY1Hp7xftvNn/w5Q769LPK1zhtxudJkVC74unZhvHihRzvePwXbss0FUXHfyJnrQlR2WW90F5qPIgyqbulosFfhj4ifQsWPtgdh0SwgIPs/RPFgDqWTqCX4iBUdPxIoSGdCMSrB7w/JDYIYTSYEScoq/0peyGKZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfdTfWXulL21fBxJQUdMEYDj2eYdhlHt+XRRdPtvJG4=;
 b=eHyVVRZUL0GZ50WlSw3U5+av9GL+mjpnOPdqMtfjZlVt1Qm8ne3El99MgGpvGnje3twSf1tz1cqTHjZSzJ8ND0tgh18ZjPH0Sp7TNhtSww29qoGRI08fBGDyBsauBZtWQxKUR4c7rm6jeOFQXX/iKUnxwCBaVPKDkhTnBFwoozc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4762.namprd10.prod.outlook.com (2603:10b6:806:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 04:20:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:20:11 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Subject: Re: [PATCH 0/6] iscsi: Speed up failover with lots of devices.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6e90yvl.fsf@ca-mkp.ca.oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
Date:   Tue, 01 Mar 2022 23:20:08 -0500
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com> (Mike
        Christie's message of "Sat, 26 Feb 2022 17:04:29 -0600")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c07fe2ae-cd10-495a-031b-08d9fc03f110
X-MS-TrafficTypeDiagnostic: SA2PR10MB4762:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB476238D5B893113C6684797D8E039@SA2PR10MB4762.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH9KbBD5nlhNMw2QsMl+thY/8xCUWhXSGpZmdoPEQJO5RaEe5oMITPI/jsF8H6Aqm9sQqcDOQy+69V8sQKKdovnw3LBTR1Kldrza56PTnY70oDYZ4GXoEVGK+9u8HzKhqAzukjKRAishCtgYM7lHVc9qFhYNKAK03gqIW8q+kXxXYxmn6CyjHDbdCi3sg8ah/hgWfPvS2hZD+t+PWEGHA8ysOCnM1A+ER1MTlQBkSf+LQ0BbZ/Zxwe0t7i7FqFK7d5SeBfb0ovxGqmrWc1ZTyg0SZ5715Be7/jv+OwyBGbym3W9+/54Nd00HpgeT/8TH0et4KvPNL5J/NANnk221NztBIy+ic/ZB76KXmA/Ty6PKulTR7Oh7Fx2ta19N+GLwppNKnxq3gEuxyOV6ZPk2CHfVjAuO2a4bjNzCIjlpKzVSG++MiczybhIwUUVnfgs1mJhPnm4+DaoqmiSKcJGFuOLVO3FzgThl946qxSBMvWHPDC6DyIeP8W7pPTPVcMnuuVN8r7gRbV2wbLOQC8bnHzeHLpKXkgWANsFQbmEpUOXASxOI6nZy32ICFDxmLAvorbiQWwkW6LvHn0dAfmg+O+yhP+zXAGYi8N52DvTSn5M79zLIBo+jL06u9SP75abO56pcriQtsegHx98PJbqXmJhk4VmzwhlCwJTIEtcbyagYawzKdri5PJpGSR7l+hDONuCFyrPrQ0rq15W9Ijz/xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(36916002)(38100700002)(316002)(6506007)(38350700002)(52116002)(6512007)(2906002)(6486002)(6636002)(8936002)(6666004)(5660300002)(26005)(4744005)(86362001)(6862004)(66946007)(66556008)(66476007)(4326008)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GSqNgCbwrXhwKGDFfG4JFgzeKtsF0HjQVzMqosW8eIL+k1X3NfeuE0G54I9C?=
 =?us-ascii?Q?UBs+/42G5OS+u3D7jMZLQEieqmiNOpm7fbmPvNFf8TCoXjqi0kERsevrVUkF?=
 =?us-ascii?Q?e0sTbrv27NclJwUUJ0fQK/SvDj8xJ+DS5RGSYxWGQeQHrman3INDvzB7MD+S?=
 =?us-ascii?Q?pPckHPo7/2mESic/B2Z3D7GugCAn73pZwvZbkl3UR4U8Q7DG2rfto+OwttMe?=
 =?us-ascii?Q?saPC/0IEp6Hecy0lH6rC8/2kCQUiyEa0z+KqlzEP/omFNPpYHxxiStnWVxka?=
 =?us-ascii?Q?wBChxLTOgF6yJYV9kXnL0CkPsXoLVZYyrkQs4q0l55J7OEBr6ZC1c4kH9SSX?=
 =?us-ascii?Q?h1B3nr+x5oe/3Cu53jbMc38+m1opj9iZYBZSr8t7R8DzGdrKNJJAzAxT189O?=
 =?us-ascii?Q?2mk/0eFm50hX2+R0kbmYotqZqwXLyfCKSYUlyIyyX7hsHde6NnoC3jf+3V+6?=
 =?us-ascii?Q?H3jaKeYBQ59lFHk/D03jjgaQcJMvgDdzeS4EFBYvzaB6c6pgQyP4jDQ3xA7/?=
 =?us-ascii?Q?PhYT80EuGZzNM2oyJfkwGmxhAnS7Mi0jFBtqDvIu0LOkBAmmc8eOENEr/01T?=
 =?us-ascii?Q?+NE9WwhzR5KIXBiBplV9mHYcOMqaL1vecq1c1/TCaHIux6YVx3Sa7Rm6nSst?=
 =?us-ascii?Q?EsvAG8y3qkeJ8dsdEUV86KdDNqKpqO5epA7mKW1+iDF/sZqViSbrd1P2mVeh?=
 =?us-ascii?Q?g/UbOIcJL57s/r+b98/anFMxb56O2NRN4tq6b7rPsvyFMKmXc2Ua6ghKC+2I?=
 =?us-ascii?Q?YWeQs0iiDI+R+KKX4vS68vUg01r+ZdHXBKnBwvo1Ho6s/+rcWD7R3vizWtl/?=
 =?us-ascii?Q?h94GHfKdJoIa4sisb2s88GzCEqT7R7A0n4GHvu4+H/+KvgHxF4oRskmT4sd3?=
 =?us-ascii?Q?sEWfDnzyUiDotYJHOCL8fQIA9aav6uAUdRhkXCwn5hbY/so5pSLDhH6Z2SRw?=
 =?us-ascii?Q?1mG1axY1nErwe1HJZ8gKCY5gthWj3t0JAFrN+El0IId6TXDt4+mk4nF8zA6Y?=
 =?us-ascii?Q?fPE/G2h65pJ1w0vUM83M3nJJPOHshJ/OrpywieTReoiCjD9vcq5uxb+pdyfz?=
 =?us-ascii?Q?fVZiKOdLY1pLNSXkuSmy/5k1EUfnBI5DcupWLkJb9SRdAbNG63pCvPZLaVn3?=
 =?us-ascii?Q?uZy/4xFnRYx+XEwIwrdcbjXqKYP+PrCUbIFpfWBuxvDtjISfWUh1n3tq9f4P?=
 =?us-ascii?Q?ugUMLQZYTu+JX9utv/ms6Jms1TOR/IujBF1BEQXErnmiKgLQwxb1hALX7fng?=
 =?us-ascii?Q?67aIw+QmZi3xzxAOLu4CCID1bnHSAMUxy6BHPuV5AJVWN+s8e7lONgx2SG0/?=
 =?us-ascii?Q?Trof4F9TcMSvbxNPg+WGkxZMcR3tuFVDgxGA3jSG8R/9UwHIQVZc3DCB5jJr?=
 =?us-ascii?Q?uD4e5A5R7n9ehJYDUuWpNkb95jMW8NZZXOQ6XZsWq9amou+9MnnOo2FyTAVd?=
 =?us-ascii?Q?WdANkyfzxdn4lGwsBUdV8iI7ufLcf3dhGstn+ayawtxCmKu/xyIQlwIXYxI7?=
 =?us-ascii?Q?qMt78ej26Jsc4T4aSi1TeiJqsM93U1pfhf44q6x9L3iisYSaM7eeK/UPkDsp?=
 =?us-ascii?Q?TxaU1Zg8puqIVbrDnQp91VTHvje7RqCMjjOkU/PoAOW4Z9W4i2rx5fOW9qK1?=
 =?us-ascii?Q?awolbpItg6lnQWMqmM5VzOkGnAFEvm5QNDbjvGZkrnzNpzd3G1X8wlzhWljM?=
 =?us-ascii?Q?no6WcQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07fe2ae-cd10-495a-031b-08d9fc03f110
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:20:11.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRE5DKskl1ZMQXU4uIZpvqMqxOfErAYyCuotqtk4XpHSzRRlCu1ABX6RHGk1YOZLdByQh2BmOq0rrCVnUyMmQUvLd4BHHMl63OIycoCGak0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4762
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020018
X-Proofpoint-GUID: ADKh9DmI3NCeZqbcJ2Ku5bR8godUJ7EG
X-Proofpoint-ORIG-GUID: ADKh9DmI3NCeZqbcJ2Ku5bR8godUJ7EG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> Zhengyuan Liu found an issue where failovers are taking a long time
> with lots of devices (/dev/sdXYZ nodes). The problem is that iscsid
> expects most nl operations to be fast (ignoring mem issues) and when
> the session block code was written blocking a queue/scsi_device was
> just setting some flag bits and state values more or less. Now a block
> call will actually handle IO that has been sent to the driver, so it
> can be expensive. When you add in more and more devices, then a
> session block call will take longer and longer.
>
> This patchset moves the recovery and unbind operations to a per
> session work queue instead of the mix or per session, host and module.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
