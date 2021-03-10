Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87B3C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAC264F83
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhCJCgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:36:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbhCJCgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 21:36:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2aK1A127601;
        Wed, 10 Mar 2021 02:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=t/PZNVLQw6v/9W8e76ZrgZARfmI4hrPIqeyISeQoN2Y=;
 b=MfYtOh//ZyH0XAZfSok3+iLD6w3Hfy/3w5oxN8gB03X0dhyOE1xWfbKWjqxNGbL5esHP
 cxpGQmaFY1Gmq10DhQMmA0rvrCt8y7DpljHx2V1vG8CPN0qdaQoZk9453XSzeWeVk61a
 W3GGwPwqs2u3Ehe0ZjeCqRjKmV+s3G+9mD8xM+LwiylLyDRVpVJNhAc2xOfL0hPTJZ3f
 s46X6eVxRsz8RtyB7ZdG6jNhQboeNryO+nJ7j/DVXrLkcr3lQnOGt6XiyZ5IdLdjA6iJ
 26LtFYqeMAMNFEOWt++F+N/k9ARms30NfJ6D0qXxjCLbM8zQmzRgIrasXJKnXIxCTARP uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37415r9fcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:36:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2ZRMJ132194;
        Wed, 10 Mar 2021 02:36:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 374knxpc1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:36:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLQdyCdYVXxIzb9XvCo6HwcdyytDvmaJibjJlsGyYEPt54y816aciK4cyf7QNJ3Nir5dDkPL7ol540V3vaqBT/p952UrIwstituHFiKBRaax3pRIYjHKMDI8HWBFELU2zeRPiHYU8AYRkMQypZ3ne3l/NddpmjYaQzC5IkYEYEBEbQy7Sv7sUHpgfVPRqu4WwSNW3Ivc/GQPkhokbh/Yr2YTcWk0y4q5rLOWCu3yBlo504sDnVSYjWdbWH9s7sD0cNqcxy4Kxqg8fF+KzmEDVSha+jkJ6ShSATMQwfv3wMVhZlc6VNm+4BfNF7/JHyK5628Z2/KxYiC27bb2xmkRNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/PZNVLQw6v/9W8e76ZrgZARfmI4hrPIqeyISeQoN2Y=;
 b=ciCLh+gA0MBl/jJ93y/ZSjlOp/VNceCvCMNAmrj+mFohn1fZdt6ca2MFwieaUbVF16RdPewibuLaW07HXn0o/C8n3hfiHz4ODb/s7VcPHH+tsXcItZ4de8m8nTew4cpgcr71LXoOHMBqayPQ1ksfrQfwaLkwV+Qo7kzTK9vtjtdnkf9Tn11DONKfiFgiSJsbXZ8b2W5ljcW2BfS9tWDYeHOXvMpqflM5b8W9jl+K690/5WB8OwZXVZdLtyjFxVJnz8saLJFE2UfUIOlVgQ7vnwoTO5JiMPXR1q9xEmfWFXLa/odtgHcB8Lza3o/gljdvqZesu5y6u5kATiehGDwcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/PZNVLQw6v/9W8e76ZrgZARfmI4hrPIqeyISeQoN2Y=;
 b=v0L2tkRn7dMab1R2ObR9elhC9uBDKuoCIQtX/8YRjz/e+e5XJvADVIDRblbP6tCAMKvlAPBt1eQZy04oUeCCdmq2nZpoc1SlkT/nM+oZnhIyrK/GLcPXQ7yNXklhM5dfocBsQkSMJf/PDUcCZA1D8hx6ZjcgTI5W6HZlspeDiZU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Wed, 10 Mar
 2021 02:36:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 02:36:17 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Use GFP_NOIO while handling cmds or
 holding cmdr_lock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtvbburp.fsf@ca-mkp.ca.oracle.com>
References: <20210305190009.32242-1-bostroesser@gmail.com>
Date:   Tue, 09 Mar 2021 21:36:14 -0500
In-Reply-To: <20210305190009.32242-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Fri, 5 Mar 2021 20:00:09 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:217::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0007.namprd04.prod.outlook.com (2603:10b6:a03:217::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 02:36:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5a98f40-8927-4bc1-85f4-08d8e36d480e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663A1CAF67880971C1545588E919@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IAtrrGFTaw9rj8w69n31OPp6YTYlhXn5sZdEWi3lyJdZWWpXdrmHZb5EAcZgXinXZeik31ypv9xE2EeCTmBVdqj7KbZ1hXDpG4PFBgHS6PHrA/YaQVb7CATLkeSfNdxyQWp60KyIOtD51j0qYtSYONcpl+T7vIcPjfsZs6o0j1rw2aJgdCZRV2ivYaeFltVz52hYyVskKDT6naidrQSbP8oUWH6iIKSAaJdsQFvCTQdd9QxWfV9MKKISOWfCiLVpNSX5NWKRMNumdKicF09YqCq6VkhBvdyWWQVfo9tsHSrggc1VmncVWI3qj+/aFgO5ErKqhkm/S6vKyjgDofiH9c1zZiq8Gi9Ij/nKx/w0J6ZjRd8de8l/A6r2kbuni21bLhWWNJ/Ist8Y1EKeo4JXUQpJxRU1+Io6lAfKUFgxgzrkjmuTEGBwSJdW2xzfhvwOAm0X2yn4+zUzWzUO1ed0e6khN3nhaqGsQjyUIr88+X8S1NKF0c/okj1WEqtW43zGIatA5UCwufacPetPEtIAPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(52116002)(7696005)(956004)(5660300002)(8676002)(2906002)(55016002)(558084003)(36916002)(16526019)(107886003)(54906003)(6916009)(186003)(86362001)(66556008)(66946007)(66476007)(4326008)(478600001)(8936002)(26005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zKqtVTbo8jMG5rZ0cp0HPgnYOkbh5/Dq+YMhDG1MkA84dpal6YBa2CqifmEq?=
 =?us-ascii?Q?cENJdF3cz0IXp80GHBc497hN2f1iL5mrnQImRZlhn/wHLIiVKb4qSGfDyyZC?=
 =?us-ascii?Q?anqHsTByFerjRHkQ4JvmeymOzBmK9R7AQ8b66z8OGcP+JNYbTlFb6+FnFUtL?=
 =?us-ascii?Q?3pJAJafQiexXpceT2vT/CelJ3FSPtSrXb+4AwVJN6h75AI+Hkwc0Kps+tURq?=
 =?us-ascii?Q?U733dC4SaijWcVIre722TvF0mNZ8ljLTDByeyCIMotvXRJpuYkhYHrbouYp6?=
 =?us-ascii?Q?nb//RuhnwMpL8qJtfPZFl9A5tVO287EAeCUbmTRXAxwNf4X2akvnYIP4ypRa?=
 =?us-ascii?Q?wkIDyUuZZH5M/fubhxU2u13fQoaFhLKLGpg2T7MYTa+ze2ZCcoJO/MksZ3ut?=
 =?us-ascii?Q?LoZ1+Kmfi9nA9A/0LGHgr8fF/jdrDQ80R8Np2/6QpsgVMcGqC7VXyRvlDsp4?=
 =?us-ascii?Q?PS+hDb7wUZVTFi0TV6WJnZAWfQ4cdSgdwPLmJtHc6pcR+Yu/QkWAVtOVBDOp?=
 =?us-ascii?Q?Cx81h1GNwxjWWa0IRC3orJwTh/fhCnJ3N/t7ywGlDEMZl68D242/7EI8jEcN?=
 =?us-ascii?Q?8tofzfDNJsuXFtcNWuIHtquWv0Gh3a/1XszGjFhUpIYKR6hCaVIlso3VZiJv?=
 =?us-ascii?Q?qaeagNBEiyvSeV5PfTYHIvj1wCejXQIQXTZRQwYTyy74zlmH0kjYrP1st10Y?=
 =?us-ascii?Q?PyIXbkZ342uc2x9N22X6E5t1HMPHrYdaQX+vPvuMNkFqTRiaDU8vLamvRPF9?=
 =?us-ascii?Q?5ORvH00dik1NLpyToC2YtOm9Sr6PjOIh+5+LVgeFmVyZqi+QKvBLVgetePc5?=
 =?us-ascii?Q?/OLP0S03yIUxJQoEoLM/0cl4nG7KKiK14X7DtjkhdNMr/sNXUBpnoO9HFZu4?=
 =?us-ascii?Q?CoxrGhIRuF+FDkl57n+k7VrQ5EamCK7TRZcNFqlCnErdT9vZJQOliADncAQy?=
 =?us-ascii?Q?Vv58D08dN2+ZNwDN9Z/67yp3LZjFZhFsKKUl45Lnulrm0YUebjA9GmvAg92P?=
 =?us-ascii?Q?LPN9Huy8MoZMYWht9RHFL+ZlJZTgJwcAcMGt8InsGYPK5iFgizrUKHzl9kwd?=
 =?us-ascii?Q?9HEIBbyw0+xz3xoKrctZrNdOs1qS1EYJDctJVfaHcYmwXTnQRbxkJxNePhTc?=
 =?us-ascii?Q?l4Lo5eNNtrFJHA8YQuUdnMoat7wRXDWz7/bxUKYtTJkAmLu/W+SLhNjriCVe?=
 =?us-ascii?Q?xBUCEGTOlGLZG6u8SxLsGXyBZod+9OZ+v2uk2M5YWDu+PB4jsxD9AiJkTYRC?=
 =?us-ascii?Q?iRWgU4qp0T/LrftVSx/71NMVSS7QZpVv7f35c5n92MNQkWz28ZmYuW6J8a5U?=
 =?us-ascii?Q?4GetceLBEDEaYh/hLzvxqGiy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a98f40-8927-4bc1-85f4-08d8e36d480e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 02:36:17.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNzuKIb5s75ciFQw0TnI/1/fDd/O8x2dsoWVVkwRlt6bvCVIsJjXZkkwBtWWmobXO0HIHvrRLugUNVSrOKI5KqLtSQVFnR6XeeGfimTbBsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=896
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100011
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> Especially when using tcmu with tcm_loop, memory allocations with
> GFP_KERNEL for a LUN can cause write back to the same LUN.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
