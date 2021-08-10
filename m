Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0A1C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A9826101D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbhHJF3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:29:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237676AbhHJF3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:29:09 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5QQXu031010;
        Tue, 10 Aug 2021 05:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6ywD+5R9EKcEAAlX9MvOWJuOhpHq+W0mpaot5nl1u64=;
 b=vslRQrKkycVGgzMb0iJT4TRk3lSmSLTNm+8rdhA8wtlCbpkdHrheCgENGdL8zy8b1QVH
 ty2z7ivZYbFcTlkVjeLhy9U2uxhLW4FFhKF61ikdKSGJXdXWWlH5St15AQI66jdmb8AM
 B9u0kjIZjEuZM/yjwbT+g9Ca6Eke5Pd3DPx+ZQs+U90yNnCRNhwML0PjunHWhSRjwVSz
 YgHYrARfdV9pkiaCSwqz0P7v8kwW22kfn2/SHSWzRkZgKNGxUALWiiOFVWC6VnRAPXPD
 vCAeT6WfCwGvkEeRS5554HDcYLwT9Nf8KsuyI0FsRxZSx24OOUrdmGOcgQBP0f2AiwYl Kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6ywD+5R9EKcEAAlX9MvOWJuOhpHq+W0mpaot5nl1u64=;
 b=cGcqLlFsGUENLoXT1LjkJPwnSQLAb8Z3+LSlyflLCKq0r+WQPE1nYGKCovO9IKXqHL/l
 22zwFXXA7//RQf04lO24wS3Lcp3WYVzuaqylcKTpRrgUp3b+H5wy1y+Us+4vTN9Cm6lW
 iHst6QhbMgEWYP00eedEdzrk5K9dAtZG3xPyVy4u2GZTw9aClJaxIH69L+vqNSoOZG9S
 oS3nz8WWOPz4X0pPQjmdmVZzFGXjsIqai6prNVDd7hTRxx5yYPnqoilQwLC8fwiQWuD+
 WZ/sS/lgdcsHgSauSYMzxZA4E6Umj+FvekwvT+BcTgOjz2BmildgT4shmFyF2aBVSy+q vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaq8aaybr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:28:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5AUqO192532;
        Tue, 10 Aug 2021 05:28:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 3aa8qsfn26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:28:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7dt3clDMcr2u3X5SLf/LPOGH+9e587eAoecQVNMLwrZd5y/bP0hTInEHBvGzvvL5FC2K8pz82uXR2LlNYsAJmyTxhvOrvJow4yLOr/amVv0X9Txa4uEI3N1bHBhQzX3StNsxMZ+tvLgkwCCQDpYrTeG8Sh/zU2xmcV1XLGm6tgjYzTTr8M9bcELbfwnJ7jMwkunGi6uZej/YwGqnsac1avTNYm9GGclec0Jdn/db6uAQYGQFBEyFHLeJbjuR5EhJ2AuU1jC0JNbl8r3NVhS1f64pJcF0EjNozo/ScBh2G/H0fbl0215zSzEVJlWS5yh7psj+0mk3Ox/TTckVtbuVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ywD+5R9EKcEAAlX9MvOWJuOhpHq+W0mpaot5nl1u64=;
 b=Gi4rPp8Gz5Bohjh1DtG3Pzf9srmg2hqjbVT0x+/zQHKXr8M4EHVg1xNDbQMmUjx2VXcePRKGKTwqp296pLfg4ax0MoFDYf38YiaR9C/6uCv734YmC9biHxs2FbyJiU8wtpxPeBf8IorAwccqpBFHIrjOGzIb7oNYjBAc8YV+Td0FdZrEm2Ebm17PZMmpjFS3JP4MCg/xrTmeym0TWE1tjaN0yatOTfgmPyDcI30LR/04W7CrlIpHiVzoiHdszXSjBmxvtC7Jx2ChN0biM5nlfFC/GGTSP/qKAciuo+EIzz9pNLQ8VqH+HKRPnZZ4SDo0uwJ8BDIH1SrXoRVgPAhnHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ywD+5R9EKcEAAlX9MvOWJuOhpHq+W0mpaot5nl1u64=;
 b=OOGhZFg1lQRuwmnM965Utbp7e/IJUv3YuJgNNvgTjavGWv67xFMQ/mjyySQk1wKch+kTGgTbDp+XiisLfT6P5PMOimUSrvztgXGP52rZ8lUZrj3klpUFdJYKB9iaxdmAH7vArwxObEeku8rufC55TkG0kYn4V9hnoR+jaiYVdDA=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 05:28:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:28:43 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/52] Remove the request pointer from struct scsi_cmnd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6lpvpk0.fsf@ca-mkp.ca.oracle.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
Date:   Tue, 10 Aug 2021 01:28:40 -0400
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 9 Aug 2021 16:03:03 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0095.namprd13.prod.outlook.com (2603:10b6:a03:2c5::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Tue, 10 Aug 2021 05:28:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a9722f8-4194-4cf8-c36d-08d95bbfb7c4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45017B194E6452F2CCB7E1318EF79@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWg7+Ni7B9a3k7WtX71REPp0Y5yHqhwSiZbd9puXI9WxCHF3/UEqbl2gnVe051huYpH6B1yLAM3voYbU2A+uzpZmVaxp/Zm4vQn7bs8O9CG+zNzhcZ8MrbLAEibpgvTMjEtDy1tA0cbHPBabIvlnA22170o9dEeAHfsMMYJ94paDSqGGmQcjfsVDYtamP4OmaKwC1NxrOU8JIrb6X5PSrLYF5kSO346+QNQNtzNWqRcCexavSR0FiIJkIXRvkxvMrVh6JIu49rRUzEwlUaHMG4cDs4thzZ9FJ0Fy/r8QXY0G51bZlnNVSZYup0Go/5q4YG0bqlisACqwaB79jZ0Bv/BxotOOo+ZlbuKZwvnGjy0bstotCm2VZGTrMfQI9fFaKtBLdHI72n552O5RRipty7cesWswFgeNWbBhiFKPyNOpwvjExXr5/68w0PylIIRfLsHPK9n1hWScjz1lQ4AYrDPQxKJs81uKBndjvXaSJjmhTVLuAF9GSKLPa2RQ338+9yNNZuFZinhxoxcfTQyEmHbJ8jwC8rl9ZbkrddJzF8zFhXKoURGPykiDyesebZcVVIlX+jVwLtl0y7VIYeT7BxbPkMDeI3+TA/zP7TcSdWL6iJDpTPLAIe+aUQBvkoPxPRDowUkncZxrR6h/ZwMTIY/9VXvjZSIQgdKZ7+LLqbLA90E67JpoJTh8NSbgfvODIMgnzXZYwNqcebsEoaP24w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(346002)(39860400002)(316002)(66476007)(2906002)(8936002)(83380400001)(66556008)(8676002)(7696005)(66946007)(478600001)(86362001)(52116002)(36916002)(956004)(26005)(4744005)(186003)(4326008)(5660300002)(38100700002)(38350700002)(55016002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcA5B8qN7c8ORRC/eRWRnHmDRpnQkt6tic0GFG+5Z4wNVw0tQWKtJ/Z4eLKZ?=
 =?us-ascii?Q?RTk+t7CMthDIe9i4EIPp8STAI+8Q9Tvg5QtBchBw4GbNC+iukBr5CycVNtg7?=
 =?us-ascii?Q?LlvduPStlwyOo+0sjz3Ujed3wVRzYzalNwtcEcTNNE0IQ+ukCKouV/Ac13zT?=
 =?us-ascii?Q?9kvCDNFHcWnbhZj4sZhOpRYbpwQo7kFTpJTGnqaMmB5ldx/7fsdUbBt4bSae?=
 =?us-ascii?Q?TnvBOtwTyoCXkjrw+5PwYLHWLOf1GC8K9A35yqy08Nrgdg/5Xi3kDBHqv4qB?=
 =?us-ascii?Q?KKy6qle/epUeIBSzvpMNmnnwuoxH1JFgEBdY3zQvnoztOToL2xiTIkG8xL3x?=
 =?us-ascii?Q?uRlixiVOwgtrsukZRRCjUfka1Wf/PDKFfIPpFm47VRLR61OKKF8ARKcMeaqp?=
 =?us-ascii?Q?TXwD19St5x9M0X+9OVB2+3ywZl0CQgbTw20mwZCgMMe9Z5sVnaEupb56y+EZ?=
 =?us-ascii?Q?xouENPzL7xjeoRR2Ym1kb+Q7NV3kpJpgL8d3TDs9tfM6r9+qLJk9RMVm4fT7?=
 =?us-ascii?Q?3z9NNBWWsOZHhe7SFCt4RdQFxgHiZ8Z+R93iOndlIGdkEuRkRHuiABPhvToh?=
 =?us-ascii?Q?ID1A1nTkLE+AH37HJdfXAvTgfGCO8dlF8iptYlP4d+sk3sGZlP4u49YTf8Qx?=
 =?us-ascii?Q?xBHjgHwY8F7kFXw9Th1exM991aNmRVv/1LVJB7r2pKIq6vXpnwU7qq0uh4Sz?=
 =?us-ascii?Q?YvJ1ImWJyvf9xFX3uS9cYaDq+ErObEYw2Lm/Y2RSQnnQ0I2PIwcwjnxmJkvW?=
 =?us-ascii?Q?QR1bY9xLr8P5dA4pJhUYIXZWx24yP8KIC4tV7/k8437eOIhcvsbb+AROcbqw?=
 =?us-ascii?Q?ln0DcADWTmOnCRpnsBucZaqD/Df7LQKYuKcRxO9m/f8rfn90FqfNh/cUw2br?=
 =?us-ascii?Q?UyDglkmHMJQROlhBJM222wSN22C6/M36gDBOPlCvp6/W4H7ZmCajLkDlelrH?=
 =?us-ascii?Q?JGH7FBknsMQ7iOe++h0npj7S6j8CTTnwHgJ40U+BiwXb/zuZ9NlORY6Mu3Ff?=
 =?us-ascii?Q?gO/C4Cl8wZannnVIa4ev2gsqnJZnMFAfFAx6+lcMZUXoW/NvrhJm6/uYlLp+?=
 =?us-ascii?Q?2p+q6fI1XzP/5SGsmB73kQjMMr25/AMD06VqpNhr1/AXTiC2FNtHoxQIMnJ3?=
 =?us-ascii?Q?JgD+fU3cRMCWfbYs5A89kzwtVsvZcysPvSVnWyXlO02VA69DX71ntKkZ00wl?=
 =?us-ascii?Q?KBaLt8hJSIJ2UKvqExI5bAJFlYy6xunQCTsQ3KPbBk5/EIHKp2TocJIsjaI0?=
 =?us-ascii?Q?GToBBCYzsaXNc1YuylQKwSDNfFoyTzwwwdXLNyc1HBqpswyupdpLDETktvxF?=
 =?us-ascii?Q?tzwrEmVT4pPEJbpXCvqkE58w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9722f8-4194-4cf8-c36d-08d95bbfb7c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:28:43.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlC1mcz7kZ/1Oz42Sb5JYi7N4Jdha198BOShqpKKtlUgaxb8R6D6rsUUltZXR6dSn2ifJZX8YBNwBO3rcDSuz66hhr3z19rVnZdGkgQ5i2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=957
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100033
X-Proofpoint-ORIG-GUID: E71FiRY96vECziPQ-MkI1QmI6tYF12ZI
X-Proofpoint-GUID: E71FiRY96vECziPQ-MkI1QmI6tYF12ZI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> This patch series implements the following two changes for all SCSI drivers:
> - Use blk_mq_rq_from_pdu() instead of the request member of struct scsi_cmnd
>   since adding an offset to a pointer is faster than pointer indirection.
> - Remove the request pointer from struct scsi_cmnd.

There were failures in storvsc and ufshpb. I fixed them up.

Also rebased my PI series on top and fixed scsi_logical_block_count() to
use scsi_cmd_to_rq().

> Please consider this patch series for kernel v5.14.

A bit too late for 5.14 :)

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
