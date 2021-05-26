Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C859C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011A16143B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhEZEJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhEZEJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q418UQ142728;
        Wed, 26 May 2021 04:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gk/k+kb+AvEddNd9ZTBr1AvBazWvyyqQJ0I0ssmnjYw=;
 b=wGvr3E7FXWrhcVumRrmOiIu4FuRgly34jR2KM1AEuWgNOocwrqz5MZVWDpOKhXvGyx0A
 l7zqXsQMqdYEWsKrEFQKew1oP1GHmKaWL7nCrJPpl1UMvm9PsLiXRQ81NOYo9aH+43+a
 DNB8v90JXwmHvOG4jqgj7rwD7rdG3Arr68J5d8oxmzYCP6UVUujJOOQmvFsAkf2ImK8K
 fQioCGqqbWEY/wFtdeZnj/toZ0uXhrJdUqN3nSPTA1Kx6LZyUFRWDrvrT3j5LbR40SPQ
 Y7d4Q2zYOwzSbgblsCta3cvHKCvlbi5oKKL8FBMqyVjUcAc5wS5MOSBB8YxARQILA8kM ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp7pyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q44tGR175510;
        Wed, 26 May 2021 04:07:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 38rehbs0ea-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfpfB3zrX7GKwf+i+4h403w4FS5IqIdXcBblozWVzv5+yhNZyHHYowxQkB2G9mSUtJaXkajSpvXwPJmJi7NnD5WHzHWtGyOi1PUq1lPg9rF47UyKY7LpbPZNscxF1+9gFICiZ1fyY8EcWQtJDZ//0xET+fBySbCsmWWUMQoR0DkUhD8lP+aKM3psq3pOyB908lObNIfoAw53N2e07J53w1H2gz4qqPvldnRpO3GwsAKegmWLN+GahTWDIjtZSI5w/hIF/R31mDjfid2vPwHlwVg9fDvQP0IQtl3CrGOyo8uuJ20O8rioIPvw1aRGqsdJKOgK0ewpXB8vt6VJN05jQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gk/k+kb+AvEddNd9ZTBr1AvBazWvyyqQJ0I0ssmnjYw=;
 b=Eksg95BUsP8CMDK8uNlkHbdRi7udedZODNJd7hfnGaxNWjMB4KtmCzjdTM1WY6OYwW1MtltFy5qgNJabicSghzqvr3eR6p7pdzm4EnyheEp52QkDrjUApfLGY40BaJAJJ30ROzG+0K0uW1n9H8XdZt05zo5QY4DPm7ewoq2u/X7Hf7NJwlaeSF0tSbeF917J8dvP2HE82vFVbFrG7oAkzJcmRdAzP6m+0OXV7LuamwUJ/Pl2Lu2++TrmOxlXaovq/qXEhtueUypDlPiGJYHW0ldiWdxhwv9QdTd984fQX8sB5tk+MEa0xVmV2+MDR2/ZX2P7fzEDgogSPPhQAsDh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gk/k+kb+AvEddNd9ZTBr1AvBazWvyyqQJ0I0ssmnjYw=;
 b=ABQCVwWCHt4rRvG9bYuBMu4Un4zP4YtBEzPUaAFYtPgF0T2VeXwd4s+338/Br4f7ioAx8/i/ehTHK1K6Zm0SyukJDEyG398M5jwMArNtwAbNz5rqnoQhDSR82n8Ha3W6PoQdCRkOVwE43rk+arQyJ4wRGG6KcOk1LriyQiBJ2zU=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        skashyap@marvell.com
Subject: Re: [PATCH -next] scsi: qedf: use vzalloc() instead of vmalloc()/memset(0)
Date:   Wed, 26 May 2021 00:07:32 -0400
Message-Id: <162200196241.11962.51667683911393626.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518132018.1312995-1-yangyingliang@huawei.com>
References: <20210518132018.1312995-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44dacef0-9b4b-4542-6278-08d91ffbd698
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469FD7F743962D7ED9851288E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZPX1I8tuIlkiZUGI0VohnycLUAuKnDZfgY83mhmyNGuG/BrbsfujvITqRH0N0Yfr+eAbv/glUJ2M0An1eANmmCnvmzoLRLviJ3OwuIwlfoJx/Xgij6C8AShfx+ensFrotqpU2cc+2ibTaxCg4LD32xQ+bhy8yjfGUJ3yVkAL7aahn45o1JcvGEhWexQmFpCbpSzt7Fbh1mVOwLkAK8Im2LUAPU6/qiYFFjYmiXU+2XUCQSeDbnEFfEEWoenXj8wHxI8169TQIir4HCv3mk/UDO8Kcs2JK404RGqmJfJzdP3UGZOjunN8RkMV39k4+5vv2jtwUaH4EXZ/+NfJcwVLAv1Ood/S8M2TmRJWZM4Za80Vyh5ERj8yw13nZVYw2WPcHYJM6Xk15xw1C19UFMO/xGHpJHIHZOFLrB6SCaRRXwtqBGVjLZskzMre4xFPvGtzARvgAQv79Q0ijydJSadS3edARGXT5dbYyOKuJijGVkOrI8JuZ/xG0s3alO8PfNeHZV8Q9BJAk8qAmHz1px2ay/axd3ZJmmlTVWjGozNFUDLLn8INR15Ou068r3D9ZiGPVCBbcBDYijo69mmv+HdXUlKRmT5fY8lyFHLl5EF9qqh9Fk3/6ErBDn8k5U7bbrBL5Lnpa7AbMYAl73UsSBc5ih9aN8cFYvTfIOQEGEsLZnLIQAkwKoWNLdgS9jCaXnOdJCrRCNXS7zUvMAeHeJp/sFWr2IdAZh0mU6lE7cuvWRhpF/tn6JjT+x3OUTmxisKq9qbljuVBJl1CUrgL7iOlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1NzcTczUEh4OC9NY29iWDgwdkNvUUFvSDBnYWh5L1pPcGZUWFJvWFpIWXoy?=
 =?utf-8?B?Z3Brem1lMWora3kzNys3NnZQOUV2YnltS3psNlVBZ3ByeDNHdlNJNFZTMDhZ?=
 =?utf-8?B?SXdIMGpqTVlwN1NBRzFlWW5sM0RZMzJxak52Tnh3T3NpclhBZmZMQWRxbEN2?=
 =?utf-8?B?dE1BODZnT0h4VjZwSjFQVzI3b0dXSVN5b0xOZjk4SDYyb2w5VVBkQ3YxcmxG?=
 =?utf-8?B?cjJseFhybWRlb09zZVp6ZHlJTlZRRUw1cFV2dzRCU3pLZWJBMWRpL3BVLzFD?=
 =?utf-8?B?QWhtbGRzWWgrYWMzM0JLRllHQitTQ3BJby8rNU85YStpZ3RqZUw3eVhPNmph?=
 =?utf-8?B?c3BXaE54dURldXJNWi9oZjNhV2xwMUllM0s2Z05pRGdDWUZveUUrZWJ5UmJU?=
 =?utf-8?B?cXkrUzVOcDYvU3Urb3FIdXNCOVVQQWN2VWJ2TlozOEd4ZnBWNlFqakdFVXdo?=
 =?utf-8?B?ZkpZU2ovclM5WllzMFdycXdja3ZQZ3dtM253N0t1NUNPaWRNVDljaHNmRVN5?=
 =?utf-8?B?eDJaODlVSEVlbzB6aVhuRm5ja3c2Q3ZsNTJQajM0bDBXQVBESGc0cDNHU0or?=
 =?utf-8?B?ZFBrVHRMNmtpNHA4dVFxdmtHUCtxcHRuTzIrRjJuZEZUNWloV1BVVjhnOEsz?=
 =?utf-8?B?YzBaOG9sTitYTkt6M3NCUW9YdWFnNThwOXhqRDlvNVY5bEd3TmxYU1hFWlNh?=
 =?utf-8?B?Nzd1aHZKNVd4UHFHRzl5SE9IczVtd25aYlRsOEtlYStveE8rR2t2WldzNzFJ?=
 =?utf-8?B?M1preHJ6eWtjSndhblQwc1ZvSkZKeHdYQW5ZUmVaYmNDdHF1Tlh5QTFmVVNK?=
 =?utf-8?B?Z2FvbFdpUFpsa0FGYUhVVW11d05qQjdqSkRxdmJoazUxT1RmUGlha3BZNU5w?=
 =?utf-8?B?N3ZHRzZ6aGxZUDZNYWkrc0pISmM0NVpoVkJrN0F4bTBRMHRGc3FTRk9NOENh?=
 =?utf-8?B?dm0xWmRiRFlyY3VOMTJnblk2Nmw2T0VHVkJua1ZMdHJPVW9XWVBDR080dENw?=
 =?utf-8?B?UjdHbzhpWGZjVytIZFQyNDVhRUUxVjJ6TCtpdnFpUnNaZTdOZjg0NmxWdjRV?=
 =?utf-8?B?RmQ3V2hBczdzNU9FQzZJa2N3WnhnUnRsd0lBYXVNYmFnaFJYLzhlWnNiMEl2?=
 =?utf-8?B?eGZubUFiQ3V1SmJ1dktRTXpDeURzckNKM1o3Z2ltL1poakdYSFhnaWU2U0Jm?=
 =?utf-8?B?blZKblIrZERYNnZnNjBjTHg1cWQ1K0xzVHlXOEpTejcvbUw2UnVqV3g2bUo2?=
 =?utf-8?B?ZHNiMzByb3FpQzJnM1ZydmVKRW10YjhRZEJPenBQKzdaRWNaaEdwRTVCNEJT?=
 =?utf-8?B?bkZPQkh4RWxjakdjRU5kNjdULy9JQnIxMjl5ck5UOHY5cHR4anVZQlRodGFo?=
 =?utf-8?B?S0VxSUpLSXgvNG5NV1JaTEF3L3JsWm1CMkR0eEZrUmErRlZKK1djUk1FWTZ3?=
 =?utf-8?B?TVJEZzRGdzB3VTh1WE1acHFsb2hpVCtIeFVWbE1YaFZ5ajBySTJudG5IUkQw?=
 =?utf-8?B?S1JKbDd1ZmhWWVVaa1ByeGJROGh2ZWx3TWdsVUtlTGduZXJ5UHlFbW4xbE84?=
 =?utf-8?B?ZFh1M2MxZzhCY0grbjhhQmh0aHpjTGxvaXpSS3UrTTZkdHZsK0RGQ3FDUHNa?=
 =?utf-8?B?Vy9odzRvTVp3bkx4WFEvUy9hRG03NVZ0dFkwVmFkN1Z2d2FYODczbWpJTnNS?=
 =?utf-8?B?czdyRTlzVmFVUEliWkl4czFJaExneWhHMHM1ejNIc0RlSDE3VEpVcXgxWlVo?=
 =?utf-8?Q?S2LhKZSBRo3kN97N7RSdEeIvsB9AuNhTLPGPnPg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dacef0-9b4b-4542-6278-08d91ffbd698
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:55.0275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxQMK1VCX7ER6tcrSyHSb19aDuLZZYxKWtd49k9K/f1h627DADynoKiYgMSvb2x7GmXJcINRIQXhz7wjAa9lrNh+PoUao6JfHX5O4HIMYGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: kMt8HweTiIQ3yS8cThg98agRB1baTcgu
X-Proofpoint-ORIG-GUID: kMt8HweTiIQ3yS8cThg98agRB1baTcgu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 May 2021 21:20:18 +0800, Yang Yingliang wrote:

> Use vzalloc() instead of vmalloc() and memset(0) to simpify
> the code.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: qedf: use vzalloc() instead of vmalloc()/memset(0)
      https://git.kernel.org/mkp/scsi/c/2a38d2a8b4a6

-- 
Martin K. Petersen	Oracle Linux Engineering
