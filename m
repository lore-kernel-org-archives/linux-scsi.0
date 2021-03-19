Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6ECC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797BD64E02
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhCSDua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:50:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbhCSDuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:50:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Tiig090355;
        Fri, 19 Mar 2021 03:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9UX+g9uChL7cRJuDNPp8d00mBM/uz0PGjKKWfJVCuAU=;
 b=l3fkiIyEgPn6DVKjnx9ssCoMoE0tDw7mGXggigq/AW3Y/IJsWvHjNbI4L2mIwdpAK6sh
 Xr9XmyiLewerLALoRL365AYxeOjpwCw31yTy+WWRk3kMHJ2O/wNJr8R0YAv10Ty2wq2E
 qJrI6DUUZJ3V7v5M3bCSUAQIoMNcrt0z5ugs03JS48zobRkRbwuusHHNvuS8ej5s20aC
 Hom7BFKS7tDdNXnFTXmwmBZ7LpWKz2NH7eFh9IWdiXARLdY1WiaV0zbyAKvYjYGnrD8C
 e0GPVLhqDO3rwpdO4qwTGuo5RbJgw0AHMxU9TVjF+p4QbhrrEb3/TQwMs8ef6nmdCmlK Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1p1fyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U8ch175034;
        Fri, 19 Mar 2021 03:47:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 37cf2v0ds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfIBM3M9ChsQQb4Fseq1WlodTE83GWdQ44DGN8qVzw7ApHmPQp2nuo13Szq/aOB164nw25HbTZNSuWEBE98y+4DeOx5c4qnqSwEj4bzRU51V1GI5cTi1NLrHUHBsIwPOkBq1X/x581AV8i4+ufQVSeWjEweZgh2p9bZzFhO3a6P4s2jLvmY++BD7gRpPQewEtgPdMn3772BOvH+jFkqCwaEO0wOJU2MphA8zThxba4iccNeTygNIZtBC7dL5YoBsqNjGmiSoep5E2FoSXabjK2+2tljC04TJ0PEOEMcDjQHDF3Ul7XvA1pQJNat86V1yIyv1Ngag6S6WqzJSEp6qzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UX+g9uChL7cRJuDNPp8d00mBM/uz0PGjKKWfJVCuAU=;
 b=UnX8QZPBmtPUsM/ib+K/t50UUUPiPSs6lZydzi1OADNvDrMDt3ltMfZsubSY0B+ZtPT/2PXqXzwAVPXBEqO45SF2oGuXpXMdYNDye6aZ4oBwJCRk3hWGy1CvfhUHc5ZXlT/2OlNJHHIP0IhSTpk89n3e/4Ysh/x72sTqIwqaq8AfwMqBGmH8ryOPPHnF+kSA2zgiSyAJnunso9RC7ml1zxec/1U/NXf1VRK4DYPWhfz8dCRo6Vq+6d6+A8DU5D96Xc/iO8RubGfdBiaWuLokiEEdPX1bki9wkDzI6+b+OsG3BGRefe4DjjH0j82F4JiA9oZdSxIIsBTn48OfsK89Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UX+g9uChL7cRJuDNPp8d00mBM/uz0PGjKKWfJVCuAU=;
 b=QMJ9uglrtPUfMxLbdJiVCcj/6wCr9/Lsa+kQVJZlZQ5c7GUJcvFf17qP4h/QWDhPOPcGDhuxG0FA+zxpXFHdGiD5xoNaatGlijsHrTHAv3aRuZUP33hlxMgMCg2KxN/CU9JO3kyQ8oxhYYdjx+5ZFGAdVrBgi9Xnu5Q5O8Zw+h4=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Erich Chen <erich@tekram.com.tw>, Linux GmbH <hare@suse.com>,
        Oliver Neukum <oliver@neukum.org>,
        Joel Jacobson <linux@3ware.com>,
        de Melo <acme@conectiva.com.br>,
        Avri Altman <avri.altman@wdc.com>,
        Andre Hedrick <andre@suse.com>, Christoph Hellwig <hch@lst.de>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        QLogic-Storage-Upstream@qlogic.com,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        Hannes Reinecke <hare@kernel.org>,
        Nathaniel Clark <nate@misrule.us>,
        Jan Kotas <jank@cadence.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Adam Radford <aradford@gmail.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        "C.L. Huang" <ching@tekram.com.tw>, dc395x@twibble.org,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Ali Akcaagac <aliakc@web.de>,
        Vinayak Holikatti <h.vinayak@samsung.com>,
        linux-scsi@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        Karen Xie <kxie@chelsio.com>,
        Marcelo Tosatti <marcelo@conectiva.com.br>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        linux-drivers@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Subject: Re: [PATCH 00/30] [Set 2] Rid W=1 warnings in SCSI
Date:   Thu, 18 Mar 2021 23:46:38 -0400
Message-Id: <161612513546.25210.2837278111993841197.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ada95cf9-1be7-4628-4c3c-08d8ea89a9f5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB447012AA1A6D89DEB854EE408E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYQKUQaZY7Yej63fkEkqY+vEEeyLGaCFH7SMbftGQMG/YTgxQ7nElOMYBco1KEMkvDnayDSX5InnbpziGXt+X90+VaBr+BRRWLFHgepgDN0qh9wAP+4etqKHlVX9SAR4SxYJw/2015P95AWgg9xNCsLrOE78+4PsWezkGZ5uoU5qc9w8PzTseimIcKJztOxDZUN/nu2Q9dcywY1N917kGnQnIcYKvcJ5S71ZzUroDYo/uFCT+hz/KpBtXXL/POL/cnwLnbWQZeuiyxf6lGQGJ30dj7xP4770Y0e34oufSX5YaLLOpJv6oYjLApLpZeUOn7pl8EF8FRVcj8dxIbFCsYBU3/4p4cY0gE31AxsYF+zvNgTRErH0vGxL1yqdGS7NgSA6ZEUDBKn+hL3kb1KclMJQk78lZ0Ds3BorBAW7gXD8PRK3XFUqr1xItDyeas2+0JG2B1OBayjG6y0M+qsBDnZ7aMPDs1eH3LQfyn/mjbqf/rFeQFWQ2g0cxTKyRFUkxvRRxjswMj3iF5alZWVoyMC3Gjy+QtM/3OvwVp6j8cSGvNVH963lydrZJWKMxw+MDyjzVUX/HmG2saYlk48LJ63pIDIZvCjTfiRJQtx4h5PEd287srRx/RlT5Gq7vjckZCs8q0PFNJQ+UBZdImpyaXxuwSVY5leqVe77cHMSMJH3i4upqx0h/XbWT9eKaoDAXtX1TbcCY2arQ2nwRQm+UdE2ukJpN6lehDNPzBiAV2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(54906003)(6916009)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(7406005)(66476007)(7416002)(66946007)(36756003)(52116002)(7696005)(83380400001)(7366002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UUVkRmxZUjRVUllwWEVjL1pIaE9IRnptditmc3Vndmd2WXQxZWdVQ0JJRUd3?=
 =?utf-8?B?SHlUZy9xb2FaSzhQVndsSWNqYUNlUGt4SHc4T2VtS1IweWpCMHlKSEpBMm5n?=
 =?utf-8?B?RUdnVzlZV0x6RldWL2grT000VTA5cXZoaXpzT2JLMmtLeWptTHQ5VktRQmhT?=
 =?utf-8?B?RmtkWHh0ZGRMQjdiV25yRzFjUjJIVG1PbUlDVkYvaVFHREJvWHFWdlkxMjcv?=
 =?utf-8?B?dkZseGxTYXAwa2pudjhCZFYvdEh0ODFFREo3M2QzK3YyeExFZ2N1eHR0Z2R3?=
 =?utf-8?B?VkxlaTkzZ2FuYUh4dHZGWVk4TDFCSnhIZVZUalRlUVVTdmV3a0Q2UlVVRE5C?=
 =?utf-8?B?M29UVWF2YWUzRGJ6ZEo0WlBEMjhmYTF5WlF3Z21LT3EvT05BWDNONXNLZlE0?=
 =?utf-8?B?MWtvSUp6VXpxWjJsT3FJZHQ5clJYZUpZU1NwU2RrcDdncFF0NXVwd0N3bTQx?=
 =?utf-8?B?eG9tMmM1YmFXRXVSWHZmUDRvYmF4NlZMSncydVRMUFVvWWdaL3FLYmI2RE51?=
 =?utf-8?B?eGFZZFU1Y21UcGJxcjVaNDNYNmVKWWFmRmYrN0hQeTdNays0SlNSNjcvVkVi?=
 =?utf-8?B?aW1oeXNRNXB0S0lvR0YvTG8rTVA1UFZmc1RoYTdSZlZuYXE4ajBxZnd5cjVJ?=
 =?utf-8?B?RktzYzcrM0xjVnFWRlhZR2xVN1VIN1c0dy93TGVCQWVLKzN1VHlabjlNbDRx?=
 =?utf-8?B?UlRZek9kbE9uVEptclVpVXFxNHdaeDZYSXhVUThUamNBYStEUUJxSWRGV0U1?=
 =?utf-8?B?RmQ3RGIzYzdBQ21Ka2FPUUlrRTg3SkpEQzlVa056YlFKSjBUSUxwU3hXWDc0?=
 =?utf-8?B?c1RhR3p6MGk3K3MvaFQvUkpZN0VXQ01WK3pQZkg4cURsZHpyWXorUUVCdE9U?=
 =?utf-8?B?YVRwb283L3FhK2prQnRHbS9yKzdTRjR2eHN2eTVXYjEzeVdQWkJaTXp0UFpW?=
 =?utf-8?B?RlVQSEtHbXlTRGE2YkdrRHBRWW5jNENTc3FsVHRCOUNSYWFBajh2bzZWcUhU?=
 =?utf-8?B?M29IQ3JUQVJwQWdYYnAxV2owdjhzQlpXdGRpdUJUSHp4STBMc0owNmU1R3Jy?=
 =?utf-8?B?a1d5ZG5JdEQxOWJhbzBYMjZNa2V2QWdFL1FjM252Z003VmZLcDRZT0JINWxQ?=
 =?utf-8?B?dWRPNWZjZ1lUVytjT3lBdTV6cFFzTlRMejF1ejZ2Q1VNWFgwWE0rYUFrWFVF?=
 =?utf-8?B?WEpJS1JOcFNPb3hyN2VSbTh6MUxIWjdENEZSbEQ2cTJxWEhrSVArVXdFZFp3?=
 =?utf-8?B?UjFTSUVidzY3MXZBNDgvaGZySm9vby9IZUhKL2ZQVEpDSEJ0SEFKTTBlb05D?=
 =?utf-8?B?V2h0ek1Vb2s0aTBGSnp6R0dENlpOM0pkK2RsSEkvbFhkV2xvTnlyUGN5N3Z0?=
 =?utf-8?B?R0pseE1uWTRtTzZmTHd6ZlJBUG5iTzRFK1V6K1dWQnhXSmhDRE9yUkIvWVF6?=
 =?utf-8?B?ampsK2ZhMm5vTEdyc1Rrb2E3Rll3dFJraHQxd2Fkd01TRnFKenRaaWFDSDBh?=
 =?utf-8?B?YmIzQUJvMFpuTUVUYTJJcXZoR0t4Y0RzMlNvY2RNVEJZWkRVb3BRcVA3V2JL?=
 =?utf-8?B?MWRyczluZUR4NTBOaGZNLzh5cjlGQTU4blc4MExkZjVTdHN6Z3pUSjdYM0dL?=
 =?utf-8?B?MXNBK2tyM096TStzOER0TnhyRlFLNFdPcXUzN3FSRHU5alZNaklKdVRlcThM?=
 =?utf-8?B?TzFyNWFiTmR4MElhMHBhWEJwczJ1eVFxUVU1SEV5ZFE4VGcwU0lJN0RiVnhu?=
 =?utf-8?Q?OO5I8ze8Tb6auLru6dNmlpCVeIJBtIQ+hKu7mPs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada95cf9-1be7-4628-4c3c-08d8ea89a9f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:05.9553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/jp7Wb1CLguqiohhREw6w9WHwH6JMLN7u5JCkyO1Tk89T6T9hviYQSwBvKDrNz6lEn3nvAWv+HpDu1W/sufNkxJBv2aYQl1ulnkyLxgamM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 12 Mar 2021 09:47:08 +0000, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Lee Jones (30):
>   scsi: mpt3sas: mpt3sas_config: Fix a bunch of potential naming doc-rot
>   scsi: ufs: ufshcd: Fix incorrectly named
>     ufshcd_find_max_sup_active_icc_level()
>   scsi: lpfc: lpfc_scsi: Fix a bunch of kernel-doc misdemeanours
>   scsi: lpfc: lpfc_attr: Fix a bunch of misnamed functions
>   scsi: libfc: fc_rport: Fix incorrect naming of fc_rport_adisc_resp()
>   scsi: mpt3sas: mpt3sas_transport: Fix a couple of misdocumented
>     functions/params
>   scsi: libfc: fc_fcp: Fix misspelling of fc_fcp_destroy()
>   scsi: qla2xxx: qla_mr: Fix a couple of misnamed functions
>   scsi: mpt3sas: mpt3sas_ctl: Fix some kernel-doc misnaming issues
>   scsi: qla2xxx: qla_nx2: Fix incorrectly named function
>     qla8044_check_temp()
>   scsi: qla2xxx: qla_target: Fix a couple of misdocumented functions
>   scsi: lpfc: lpfc_debugfs: Fix incorrectly documented function
>     lpfc_debugfs_commonxripools_data()
>   scsi: lpfc: lpfc_bsg: Fix a few incorrectly named functions
>   scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the
>     heap
>   scsi: lpfc: lpfc_nvme: Fix kernel-doc formatting issue
>   scsi: ufs: cdns-pltfrm: Supply function names for headers
>   scsi: cxgbi: cxgb3i: cxgb3i: Fix misnaming of ddp_setup_conn_digest()
>   scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for
>     esas2r_log_master()
>   scsi: be2iscsi: be_iscsi: Fix incorrect naming of
>     beiscsi_iface_config_vlan()
>   scsi: be2iscsi: be_main: Provide missing function name in header
>   scsi: be2iscsi: be_mgmt: Fix beiscsi_phys_port()'s name in header
>   scsi: bnx2i: bnx2i_sysfs: Fix bnx2i_set_ccell_info()'s name in
>     description
>   scsi: initio: Remove unused variable 'prev'
>   scsi: a100u2w: Remove unused variable 'bios_phys'
>   scsi: dc395x: Fix incorrect naming in function headers
>   scsi: atp870u: Fix naming and demote incorrect and non-conformant
>     kernel-doc header
>   scsi: myrs: Remove a couple of unused 'status' variables
>   scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and
>     'tw_dev'
>   scsi: 3w-9xxx: Remove a few set but unused variables
>   scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/30] scsi: mpt3sas: mpt3sas_config: Fix a bunch of potential naming doc-rot
        https://git.kernel.org/mkp/scsi/c/cf9e575e62a4
[02/30] scsi: ufs: ufshcd: Fix incorrectly named ufshcd_find_max_sup_active_icc_level()
        https://git.kernel.org/mkp/scsi/c/11eea9b3fd4d
[03/30] scsi: lpfc: lpfc_scsi: Fix a bunch of kernel-doc misdemeanours
        https://git.kernel.org/mkp/scsi/c/0bb87e01d815
[04/30] scsi: lpfc: lpfc_attr: Fix a bunch of misnamed functions
        https://git.kernel.org/mkp/scsi/c/a3dbf5145d01
[05/30] scsi: libfc: fc_rport: Fix incorrect naming of fc_rport_adisc_resp()
        https://git.kernel.org/mkp/scsi/c/0dbea7c18873
[06/30] scsi: mpt3sas: mpt3sas_transport: Fix a couple of misdocumented functions/params
        https://git.kernel.org/mkp/scsi/c/54cb88dc3083
[07/30] scsi: libfc: fc_fcp: Fix misspelling of fc_fcp_destroy()
        https://git.kernel.org/mkp/scsi/c/775b4d65a6fb
[08/30] scsi: qla2xxx: qla_mr: Fix a couple of misnamed functions
        https://git.kernel.org/mkp/scsi/c/381095668d51
[09/30] scsi: mpt3sas: mpt3sas_ctl: Fix some kernel-doc misnaming issues
        https://git.kernel.org/mkp/scsi/c/782a1ab33f71
[10/30] scsi: qla2xxx: qla_nx2: Fix incorrectly named function qla8044_check_temp()
        https://git.kernel.org/mkp/scsi/c/a736e4490442
[11/30] scsi: qla2xxx: qla_target: Fix a couple of misdocumented functions
        https://git.kernel.org/mkp/scsi/c/dc49ab48a77c
[12/30] scsi: lpfc: lpfc_debugfs: Fix incorrectly documented function lpfc_debugfs_commonxripools_data()
        https://git.kernel.org/mkp/scsi/c/2c6400b78243
[13/30] scsi: lpfc: lpfc_bsg: Fix a few incorrectly named functions
        https://git.kernel.org/mkp/scsi/c/3145d2d69e16
[14/30] scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the heap
        https://git.kernel.org/mkp/scsi/c/a7a11b6cfec2
[15/30] scsi: lpfc: lpfc_nvme: Fix kernel-doc formatting issue
        https://git.kernel.org/mkp/scsi/c/f6b35a75042b
[16/30] scsi: ufs: cdns-pltfrm: Supply function names for headers
        https://git.kernel.org/mkp/scsi/c/d5db88b0ce89
[17/30] scsi: cxgbi: cxgb3i: cxgb3i: Fix misnaming of ddp_setup_conn_digest()
        https://git.kernel.org/mkp/scsi/c/181883786427
[18/30] scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for esas2r_log_master()
        https://git.kernel.org/mkp/scsi/c/1c666a3e0a54
[19/30] scsi: be2iscsi: be_iscsi: Fix incorrect naming of beiscsi_iface_config_vlan()
        https://git.kernel.org/mkp/scsi/c/1b8a7ee9308e
[20/30] scsi: be2iscsi: be_main: Provide missing function name in header
        https://git.kernel.org/mkp/scsi/c/a905a1dce8bf
[21/30] scsi: be2iscsi: be_mgmt: Fix beiscsi_phys_port()'s name in header
        https://git.kernel.org/mkp/scsi/c/ab4bab7a977d
[22/30] scsi: bnx2i: bnx2i_sysfs: Fix bnx2i_set_ccell_info()'s name in description
        https://git.kernel.org/mkp/scsi/c/0a386beb7ebd
[23/30] scsi: initio: Remove unused variable 'prev'
        https://git.kernel.org/mkp/scsi/c/78e40ac8b696
[24/30] scsi: a100u2w: Remove unused variable 'bios_phys'
        https://git.kernel.org/mkp/scsi/c/fb5b29b2ad3f
[25/30] scsi: dc395x: Fix incorrect naming in function headers
        https://git.kernel.org/mkp/scsi/c/167b7e6bfbf5
[26/30] scsi: atp870u: Fix naming and demote incorrect and non-conformant kernel-doc header
        https://git.kernel.org/mkp/scsi/c/6b71f60ca205
[27/30] scsi: myrs: Remove a couple of unused 'status' variables
        https://git.kernel.org/mkp/scsi/c/3cb0cfb557cd
[28/30] scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and 'tw_dev'
        https://git.kernel.org/mkp/scsi/c/6c31cb74a1ce
[29/30] scsi: 3w-9xxx: Remove a few set but unused variables
        https://git.kernel.org/mkp/scsi/c/ea7fb5344ad0
[30/30] scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
        https://git.kernel.org/mkp/scsi/c/475bff65c431

-- 
Martin K. Petersen	Oracle Linux Engineering
