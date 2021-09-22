Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315E9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 03:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A7B61178
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 03:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhIVD4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 23:56:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23266 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230054AbhIVD4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Sep 2021 23:56:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1wBpf010075;
        Wed, 22 Sep 2021 03:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aWpxUMaOeUuSy4dp2oHjwZLUVadIdgsPHeOSmiTBUgg=;
 b=V2TjWBgOdr1ufP5EneQ8gO/CZqGbx57w99fLJEsQKwgvPwtEd6Wypm+sdG8gzw6B0OX5
 p8wcZCTiqmTu3BEG6+xEw7i2IEU8617PtcAyZO8w1BtDDnGKbfrJH8Hd1kmP7h5IQ42P
 jMFjLybKSDG1DKDio/9CVRrrMckBp2hKOJ7ABn1arWTtShvfd+W5LG8nNdJlocqKYOjl
 LHdbQ1Thf4+cOmxnvjkChsQ7DiZY+3+ocOp+DQ50pnOaNv1oObtBlDd1jc1qu8BmYiZF
 l4LkjlQHx120bvmVdRDgQMP91TcPAEbGW5hMwUdqkgOLaaBdeM8BV3ZtmqJHoJlwB2/p Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p96u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 03:55:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M3o0gJ118831;
        Wed, 22 Sep 2021 03:55:07 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3020.oracle.com with ESMTP id 3b7q5vk23m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 03:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsPjlh/EWdc/mZwKHKwLvC4ez08JCwcg8jwfouxtI0qGU/WHAiAmp+vhuTngQULvTOLJ4BTJ39Jy+tlmisIJM/nrc+eUggt643bILjeRpSwMCxwX+dT0SSVUVas+iEZzTIhj2O7fyA2grxEYIrgWS1kZUFtdmRwAsjyfa9bdwUbaw1qq8hSF3ML38XsH85i7co2D0VjfeuYxOGanKwvRNVZ2mtZR9rdHESjE1MM2LF2KZ1XRzR4/Uy9Xqm7FRIhw0H03YQAHpDwAixSmh3wlzniGLSV0frS0TZcCEtHn1ZZRQca6mnqngwBy1lF6X9cbee1EsFKU1P3rYpVd9zgGSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aWpxUMaOeUuSy4dp2oHjwZLUVadIdgsPHeOSmiTBUgg=;
 b=lxJLqNCfeL/lRrKbGHOw1dr94DSf5Bonwx1tTGUPpWPZ/4hL1v8lF7b7isNqVp96lJ93qspr8Rtza1DPWTUYMsy1b34zrv73JZ/n24MbVBWsLbNy2cdG0159ltTVlJohW0I7eRfJg+Os1176dge7AFjG/CgD3tmHFGOc2hQS2ke4T5WoA9ZVWW/Vf2MWXKrJ47bNnW1EwsRSxzTdoerwD/CDq2IHeLuNGiBc1PzsO8+wyCWIMaNUHLqdH55oRzoQd1nZAHH2zxX7OTS/TOOU9tRnIYCEcXa2EJUjAn5TpiTw3WE05Y53/gP0rPP+un1Cbd4ZwM9FhDXn8P6sBrBIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWpxUMaOeUuSy4dp2oHjwZLUVadIdgsPHeOSmiTBUgg=;
 b=nOjJLsA9IWDVNVzk26/xvRxWe1UCPSTzIkHXcF+Z1/Av9dsaSjPzWz1Ra+QuFNetLZp4/iHC3jKVMsG+h6uAqylN4vuxjq4DbyL4pk6G5rZWiyO3jom7ER72Ac55r+KrlS0jUDCb9IrdAz36v+QYwANWjkshbP0gW851zjBxqDU=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 03:55:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:55:06 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH] scsi: core: Remove include <scsi/scsi_host.h> from
 scsi_cmnd.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0j9p8mo.fsf@ca-mkp.ca.oracle.com>
References: <20210917212751.2676054-1-bvanassche@acm.org>
Date:   Tue, 21 Sep 2021 23:55:03 -0400
In-Reply-To: <20210917212751.2676054-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 17 Sep 2021 14:27:51 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:208:35::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.33) by BL0PR02CA0109.namprd02.prod.outlook.com (2603:10b6:208:35::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 03:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11e48d27-08a6-47b6-fcc9-08d97d7cc375
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47250E9FBBD27A8E61AEDEF98EA29@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKpRW6RTIunhVItvcDbpzkJK2O3+NjiqnpqwWeqkYnjtfzyQzxMBp75XkXizK3P/o+kPVqNKAnLsBbImInz0SPvreFTEAZ5mnI0Z0jzv7UOJctfsMDikbR5kNqvc5XUm2sV36Q2YypySdWZ4zqHzg4d7AJHkgrOqgodmpV8O+Y/fHmASkEu85Khod1COByWQfKdCxGuCNebC+xIwYDLBzukZ8wseRaKeeiWYgcAivq7RwuY716XHS2W6thTbkV0ifLEe/yBljhrl7bAxKS+9hw8Jj0Y5kiWsbVtw+M+1B7yMIzxiNCLi3cThuVKxEs6+pJk3QowxcdhvpPlUoBtGQz0xZKsgp0cCPYKOiFH5Fc2UIv+iagYZ36yxXcMDNEIUshmg8EJAfxAMFbPEZVSZLqFqldn3vp2pZ1a71axedOg2Zg9xn/5l0xWrFQ2ENN8f8uj4ODppZ9oamq9DlDpaypv/XQpV/CqIHUoKZdSMZY4n3PE+RUSkIyVnbzBlHHRY2LQVCq2B67xbObTb6VKmnQ8CBYEJk1FPoZ0Y5MHHNVKsqeZL22/sZA9NovOWjzDHwtPppB+wEJu1Osux2sy8Sn1H+iMZPbiDbUv63Hux9qZKGC7BDs9P28g/v3Iqt9XkuH7VXwR69nzrLds2iIzSFxI3M1l/ODLu8aYVTCeOOlE7XvhHod0HEczBlVhsXZbgYzEWfJ+mMoKB7xsFiOOx0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(956004)(6916009)(8676002)(2906002)(186003)(8936002)(316002)(86362001)(508600001)(52116002)(66946007)(66556008)(66476007)(36916002)(7696005)(54906003)(55016002)(26005)(38350700002)(38100700002)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GpOe2eI/jk2xhDt7Mskn8H5MeeodKTGCAEGQsBtXzPKn9uNqnmZmUPuTPT34?=
 =?us-ascii?Q?T57CpXEdRuWSAQusIOt/zgOIwLNlyaZuCamBT9T6B3RbBVod9U4yu5MWFtMi?=
 =?us-ascii?Q?leaLVZSIvbuwXwiXokBdu2y3QaxN38ace4oLpmGdEP51Xno3jRrlb7KFhB8y?=
 =?us-ascii?Q?Czx1fpjqSt50/QNlGvo0KuejcM2uMn90gX/hBrC5r+y+FF/IPjXr/8vKQvL3?=
 =?us-ascii?Q?L7dOhhXF/sIvFORIclEq/yIYCOFAPdU55rAaqSvG5tcfLvWzGV92YLTTp2xM?=
 =?us-ascii?Q?y84ITZqCCx0KzfAZChCnZN9Ycn3h3uP9EY+grOqO8/YYIUVbokUuhVCCjNKk?=
 =?us-ascii?Q?v+CqzbmxmSHc15UX1RFo5QCsRZ/O34i6G5QSMyJzA3sFDvs853/1i7hwdrgf?=
 =?us-ascii?Q?6PggZOiKXdWPbKJxFAS9qRNzNxaGDAvOeMz+ieHysK5H3ZNCa+AmEmDyLT8z?=
 =?us-ascii?Q?yj2QSjS99RdMuCorWKdqFX4JnShxc0ZTCq5y/dl4v0OksM+YZmRhdJrzy9tz?=
 =?us-ascii?Q?/LeBcG6T/JUfB4HbFwqTM/RxJmXHHZmOEmEPeWkxItxk0C42l9vj2dXD7Bwp?=
 =?us-ascii?Q?6D0l1oL3u5WMTzsquRe3GJtzweZVOlOqS0n7BQcaR4K/7EiS1Tu9VnEKpvdj?=
 =?us-ascii?Q?qY9zR1rThpMM1lkPmTf0yArGubyI5dSkwIkqb+94D2OHobPF4akHpRvWXu8x?=
 =?us-ascii?Q?HZzUmelsPVJRuNTCNoVTWWHP0XQ/gNKO2H2Jp2S1oeneO33T3s5uxlS/iWKo?=
 =?us-ascii?Q?WFdBK7wUgrYqgBFRVuTXc5qKdaA/k//Ks4ZL/8dxrzA+RpMxJ9uSW3VczNvX?=
 =?us-ascii?Q?xf7jNfEQaycc20WCiyBUl/7UByK619ARZyR5OEsn0bx3UpYaJCD3oDaAP+5y?=
 =?us-ascii?Q?usc1j20s3ScKeww6TSfSQubsiKwj3GfQlDPTUDvc7yoyTr4IO9/8Y3nQG91E?=
 =?us-ascii?Q?PK1sOGZwvzCZOiSnNKZw6AgaLOwxAqSn6ru0mAHOTXEoqoyfLQQPYA9lzHzc?=
 =?us-ascii?Q?PgeR4aiSATn7DDyCKX9AqEZeTAzgLHSXLmHFcu1+OY1oJPJitnbvITF9Sq8y?=
 =?us-ascii?Q?aaNz7JCc9OWimGKU+SL1fZKl/H3wumMrr3Q3LQyCLaKqaph0MBL/VDRzpraK?=
 =?us-ascii?Q?7/0GvKiEjVjR8KjpmdblgmJvKvSBFdPe23ealu0sHsF971mjGBBMqSvMmEvz?=
 =?us-ascii?Q?xEn/hccl/Le/meC5Q7hTtvRdGt+72RmuZyOViMZVN/KP6L7PTqgWTGmaaw0s?=
 =?us-ascii?Q?zVZS4gOLU7kEXIzb+IP3+UBE3hZBjI+ys444FUZdESwhwUKuTJZ3pRkybWv/?=
 =?us-ascii?Q?X6Npq34Xxw+hFCbN0oddw4Sa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e48d27-08a6-47b6-fcc9-08d97d7cc375
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 03:55:05.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLN0xcdqwIraMNBKu5g9ZUZav0vDP2WnSMZzxv80DnWaF20IMa7g52qgdRaxK3O+BTQGX5RnJFPch/vDn4gpHPWvHd/6aaCIlqPdQSjhnXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109220024
X-Proofpoint-ORIG-GUID: 1QRwnDYteXngmlxuzrfMLtizM371Y_Fx
X-Proofpoint-GUID: 1QRwnDYteXngmlxuzrfMLtizM371Y_Fx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> There are no dependencies in <scsi/scsi_cmnd.h> on the <scsi/scsi_host.h>
> header file. Hence remove the scsi_host.h include directive from
> scsi_cmnd.h. This include directive was introduced in February 2021 by
> commit af1830956dc3 ("scsi: core: Add mq_poll support to SCSI layer").

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
