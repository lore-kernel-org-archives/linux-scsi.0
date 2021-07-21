Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F1BC12002
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FEB360FDB
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhGUCdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:33:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47198 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232078AbhGUCcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 22:32:43 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L36sRw026988;
        Wed, 21 Jul 2021 03:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oSvTZu1AExwDkn+byWbvd5czm/LUlAN8v+a0g7Xhi18=;
 b=o1XJ1dme8gFaBcot27WWOZjyutanNCkzFrrejVZ+dACBAzL2X7RfHQ9Pbog426qhRQQd
 bM5ucGflIWQRn22KcPO2kILX8DsS2j4Yv9+5iJH78zZb+OPE5jOvASwEUlt1PKnMaRbV
 beHsfXUAr57QtrlqJNjjnKEjiARzGR6ABRBurThv58CnDoUk8yGFdYvDt47FA0wLeZii
 yOAv0CDWiYkN134YIROFHrCII9xosVf8qef38oLSV300U6Fq73Fa7Zt6J6uug3sKBx1d
 zgzvnT6ozPEBPsNJj4IlGxvOluGUByZ8cFG9EfZ5+1UENXHp+mYOmZEZdIcDbYnTTpdj hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oSvTZu1AExwDkn+byWbvd5czm/LUlAN8v+a0g7Xhi18=;
 b=wlyDx4ZuL1r9zzxW3L3J45CimKPOcLjOWtZ/ZQSA8oDyV2l6WlPI7Uzr1kuQZ39H/I5s
 LXgKb+6eNaDqrkew1DGNNkyl/uFRaZx9TuYxj08OH5QgSlW1DJarwbA7UDUgKqW3WTei
 7TF475hurUV0bmIMk8zrLR6BXoFXHtbT5mLGHGH4dT7tOCJPoNsDtLtvl+9ADo/Q4O6B
 0ykCeOM3DRQUqjGRyBW3waOQ04yj7Q1w8LCDF4OS0pYk4YC5iCXf0Ss7UZvKDvR4TU6M
 D/KxPYYAhlUh0hMI+pLU9YJs/lWo0CmWScABuIzFLPdsb4hP5KS91vqPofRnLwW4vA2c rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83cv8uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:13:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L358TO180969;
        Wed, 21 Jul 2021 03:13:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 39uq188cvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkOYNUEjZk/YZwaZ05kjwCBeHdJe5vFh9FyGCUuvs5izxE1xS9ELywMWKmsNti+U3iJQlnBEV3n7AvXgA84c6ICTMu1Cqy7UCp1UB1hHFgffyoVY2+uTwo6eMGQEzxd4DDPlFXLqvZClFhppwhyO39dqNqvP2VVPsdKwJPk43kJjn4qjRwak7LEqjdDmHm+MQ/M8BYu782W8at0coreUvZj6qEbKrf17qht8z3BBuOJh8NsFla5+RsfANCsoiD9jawukZjlTd/RYXljaBvnIE2TBFkNo4bTQIxolbQYPnTxIgh2aW5XXDJAwO7nvbYHnznTwVKrzG798heB4W558NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSvTZu1AExwDkn+byWbvd5czm/LUlAN8v+a0g7Xhi18=;
 b=eU9N8QHeJV+y/m5109aOCZ4hipaSRuyuEc9z+ErFng6iNiUMVZxX6OrdhEVeoPM/shrLCLveATVuenchSw/G+tvofCTyZ1FaDD0MRKv0yIkkoOuBEKRbE8/Kd2llq1DJtYEiPG7t7WQFlkObdTSa7TkamD3AvrJblS0auxe3ALvAGVMZ3wS4rMzRi1vCFZj8jOi25JZ7bSIELhDlxWrjjkq/PdjGJ/XDEInk18+o9lg/Ya5dvTWHo2Xin/6XXmndZtgis42whnyuGpETbmmi7mJDqjtAoDTV19cB934RHRizx2nwHwRiyZgRL1BeTPzVyBnJOycW3T2f1ZOmZ7PhXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSvTZu1AExwDkn+byWbvd5czm/LUlAN8v+a0g7Xhi18=;
 b=NQoJG+ZilO9BshRhXRhh6UCGjlsyO3UOlN4wP10skVsud0NMSkhI1zb/KZiFA/AqZLJ5HxvBR/4jVyKpSJcu+PL/0kfirmpDXmFx+T61lsXiMkE0HucQeV4P0uMQZZoHCtsLyXyYzFvxwOVu8aSerd47y9DTz8ZMON+ljN2KfPk=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 21 Jul
 2021 03:12:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 03:12:56 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: allow libsas include scsi header files
 directly
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135s8z7f9.fsf@ca-mkp.ca.oracle.com>
References: <20210716074551.771312-1-yanaijie@huawei.com>
Date:   Tue, 20 Jul 2021 23:12:52 -0400
In-Reply-To: <20210716074551.771312-1-yanaijie@huawei.com> (Jason Yan's
        message of "Fri, 16 Jul 2021 15:45:51 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:806:27::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0132.namprd13.prod.outlook.com (2603:10b6:806:27::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend Transport; Wed, 21 Jul 2021 03:12:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39570d91-87b0-4600-9b6c-08d94bf56f8c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422965F42CD769E9FC0C9148EE39@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJxI2YbOOW73SmiCB4kMXSeZiyOMsuOd/7bkAkNfZW3VJg89lGeC9eRZbYXWXKbNXLBuP4I0qdbAQ5RYP4yO8h3alGIipzfFYCN1rPjJQVh4wqMNIsgPqy3JXQUj1+Pq8xDaRt6yltxF8yNkOTO7lx7TPSywEw2xWy8Q/UWdbXdkoM5lGTQBdy0iKuIqjtJgPsIipXxhoFuYyEcQPawy4tnpCnVDElwGC1sdYGfHK8hhXafsEPq4PlJkjXlUoRzsx0MjCbyuf4ZYtwE43yEquKywwzwxTTMq0VjSfBQAixz8BgFlY/g6cNNk4qOxfIvlH8RxtlN8+oJxtsNMPUECZ/81JFbwUkqqr7PCsDBDmbk1XZQ92P8LCtmbIcz/NEvsW88jTr0K3JP8f8HUY9OzY5tJTw65YyJPug/KIYhzeDNkrchTfzCCiZZVhCIOCj3AlrhLaZT3nlTxspUVjSIgfuxPX3A3isKIBMxzmcfN8q5baM3saXBdX6vmpmGF1hE7qHzpW+wKRt+lokL4L6nduQwWEOoOjoPQXlkBhZxwpISuhXmbOACbJe4avZAvSrIojT/hVAiCkqfkSlWTwQTF8HwDLLJQd1frmjXJSyZFt0sdpMV0oH8Oqiyrpm86cQLKV3RYzTYuzlw+PDYc5Wqa7RUukXglPHXxuaWnslYIvOHNm8D1BQJYTOZh4aMLA9I4YNVKa8q4jgPHQEArjX1Y/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(136003)(396003)(55016002)(6916009)(38100700002)(6666004)(38350700002)(5660300002)(8676002)(54906003)(2906002)(26005)(956004)(4326008)(186003)(52116002)(86362001)(36916002)(558084003)(66946007)(66556008)(478600001)(7696005)(8936002)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wt/ZdKFLsoAKse/4xKzYwMCiNOW61RqA/tH+RZSEsTdGhEJqhPAkXnon1nRc?=
 =?us-ascii?Q?kQCfL5DKUYGe+TcHAyczHdyd+AvoLurFOs+ECRDVbPP50736NpZJ2b4crs4/?=
 =?us-ascii?Q?AGnAn8Eru8oFIdvo2bmIk1ss6tULlL9ZTkWrC7GpqqhRSrL1vJB2QS46MOjK?=
 =?us-ascii?Q?lBBuzuUkyYoQLq+dlfjz4LpyCOr4MIpAHIozSLPZuesfkQH7kJLntUuclvDW?=
 =?us-ascii?Q?5tc3/xtdRiV73Fn45lsr4Ge1BAwFbLE1avL2oPda7cIE17j5Xq9EMcYU/ILD?=
 =?us-ascii?Q?zK4faq71xxZj5cABN8utoV1Nwwnb/GEzFeZGDyc8EAJD60wrDfNr3FdRHg69?=
 =?us-ascii?Q?n/ws/e0tNuxZCY0/4Ey03iI/YolDOPJHHTWjowCNxHlmOTqfeYkvimz8zKWs?=
 =?us-ascii?Q?z8ARDD6+hSH4bWfRY+gxnkyzyUzomBKvBwwKD++IQS/0Bx0jQAN4RBB38fQV?=
 =?us-ascii?Q?wMsodT1op0T347sOYyghPcW+EWl/wtDwRGwjnan+WFMw2zYRDfc804/L3KNw?=
 =?us-ascii?Q?ZB8r9UVlW3A+22E43q5egH3zQ3JYzcWUhVelC/nFxWia3k4i1owtftpKqcuj?=
 =?us-ascii?Q?o3ZK+ueC9mOclgJ3eqLdeKKbiVVO40Y5WFXjuNP0Cq+xY6C0igQ9TCFw1w0E?=
 =?us-ascii?Q?FblYEUWOfkr5FLXb4ztPd1a7d4zAZAZbWkn0Y+ytQ05vQ3RPWJFZmvHowPoe?=
 =?us-ascii?Q?/3K82CkvFyjhbaTCj3EpXRVwE2O3eR3lkby3SXLurUJybo6C8N2GzWLlq7KO?=
 =?us-ascii?Q?sDWxzRPRRrtq6m3sT8cXb3/79eIDd4JtWpcexeU7CSmPMw7YWLbOgQMFQSKZ?=
 =?us-ascii?Q?N3S+Pk4VYYGB+XzcbP5PNTxypcVYsvJYPZbcMx3b52TL3FWX84/ARSaIAkPh?=
 =?us-ascii?Q?2ArMNdLp9bBJrwvHnRKzA8nmmypxNi9jpQS+CxlpERJgWMCyIRN9c0/VduKS?=
 =?us-ascii?Q?1lEkcZy0K85dmISeBoDxnwBhU01cYHbdR52HwfaQ0FSv8T58i+rCXPBmO7sZ?=
 =?us-ascii?Q?bH4T8Yb+lu0VoeluSjvLbOY99vmirJSCOVwLVGUtzXfUcKgZXCrfmZJkt2DL?=
 =?us-ascii?Q?LwJD/w8X1yKGTdmA8+QrV4vEzq6fyw++3RsDIbb+hpIIjYpkCDcsEJumVanY?=
 =?us-ascii?Q?Dw4nQWaQWU/evS8jbm6jl/8fASGPPJNoF5C2n5vMLP2/87L3dlcXgr/Cns1A?=
 =?us-ascii?Q?8XEoZp3L+WUsddLTLaQ5sprXbRXK0sxxN4izF6wdvwpdUjB5WmYlelFhnK+i?=
 =?us-ascii?Q?12KHC5lj6N6VNggfIHx7vpY2arOYnt9s7xYC2Sbx5IQEb0VvCoLAMsij7RZT?=
 =?us-ascii?Q?IJYqzge13MvAgIa8/Mp4so9y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39570d91-87b0-4600-9b6c-08d94bf56f8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 03:12:56.1337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAN3/sRf0EoG0XcCjuTJQ7C7r9zD7MrJ901mnJKMuBsZDcckKKRScdkfED46eW2SqNW/hrYfQTZAvMCt15Zl5TeJKDJ/Z9kBAgwwL0Kh58A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210016
X-Proofpoint-GUID: HzJLtCKwZwQ2FWcJzgUe75hbFnnpnTNJ
X-Proofpoint-ORIG-GUID: HzJLtCKwZwQ2FWcJzgUe75hbFnnpnTNJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> libsas needs to include some header files in the scsi
> directory. However they are now hardcoded with the path "../" in the C
> files. Let's do this in the Makefile to avoid the hardcode.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
