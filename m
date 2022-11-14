Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8F0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 17:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbiKNRV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 12:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiKNRVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 12:21:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72F523BFB;
        Mon, 14 Nov 2022 09:21:39 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEH0g32019443;
        Mon, 14 Nov 2022 17:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8QJvN82/uepSkAlQwtk9uhKNugm+Z0JnzYU3f8aDiCA=;
 b=oD0fqgYs9ixCzpFxowhFt5URoWRBz6ilvyJPJMiNJck41PSNRQ5pFETGxIELmNo/Z6ci
 f4knCKrcB9zJvFlv0tKKlQePC9N4uUP5WqMkfmVYtYBduW6TNh7borG5CuVfQ9BOUnms
 Ob4DbZkS28XX1QWpyRdocItK6hE4dieFhMkkffiXlPsb0ayl6CAs1AOIsmAkeYpbBohb
 EjYzRxA6KuJd6cOF2Gs3x4P4tnu+lFMS+IKvLbFdLh5pXFKC/WRXOxwDKT6fDq7imks6
 SYgsFrYOAHRQqHAqp1kxaVpq19lGTgkRcBEPvPqrIk5vNHSfI5WP639zhyYJIdJa0HIT BQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ku1dbam9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 17:21:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEGOmJn010206;
        Mon, 14 Nov 2022 17:21:26 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xaqdgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 17:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNRKUNWCWyaClIUluUSCtx6P6gvLfQYxp1jlOnHVET0JX/KBkfhwB5R4UIri+xQCEZvY+DWhIGGD+IVXqBXwRF+IWFLIaJNXNF86ZNPep8/KJEr2HqinhfLkchWng5oN8D4IMmYWiay7XKEjVa+u0/wUzGqGh+9JVlH4H6BsXFtylhO4GsDmqZqDzL0k5pZk/jPK4BxD74MUGt1EGIDHse/EJaCuddBGvYozz2fi5Mr7PR11M0SLxxC8t/t6f80ya+yIA5TdYiHs0KfEZXK1V9Vfd9ATSnMUrNViVYY6ZirKSNUdFqBe+w6HvxrfmgijIEFA4Ibk5/CvKgUK0u117w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QJvN82/uepSkAlQwtk9uhKNugm+Z0JnzYU3f8aDiCA=;
 b=a4b0pQykJ2N9pKW3SlZFb2v4N6HsbtbLypJpLeeZEjCQYh0XyoTwBX9dKRQ0m+gdnMOqG1zaRX1WF/iJDHRu/0s+d2IYl3PoNnOL43uGtXjrNSUPziWO7rN7niuD9B69LE97SP5QcnkdAfwnZHdnn+jIcb6Zaq3JVyHNG3pPf2XqRbm8b2etpwn8mBBtHimO94f1SO+wpB1k2A6lY8jjRovBRfXJH7+cvPBxp+IiWph+QY5p1qsHfanruj1obQZhNaKfwElqg/Ci8kuRBKuU/DrrRz9xDWM+mJ4SLoEr0XymmedDTGt4RYDJigjOon+4YEb2Z/Im67/kSY794H6XwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QJvN82/uepSkAlQwtk9uhKNugm+Z0JnzYU3f8aDiCA=;
 b=t0Bk1ASL8NlWZl5Aieku8SLpD4ydK0Ocx7r5PEQnfcVgYBgKm4tBe10QGPUNdaZR4kaNJU59CUKvoMC0WHBWWTKGAcqXsHjy2iEdeahrk2Wr2+IxKEP34UUFwNRzT52SSVX56AQLMYzX32b0aOFGF8e8/Oa2HATN78qaPHF1k0s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4528.namprd10.prod.outlook.com (2603:10b6:a03:2d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 17:21:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:21:23 +0000
Message-ID: <d28447fe-35c6-cfbc-1e1d-7db6b2841313@oracle.com>
Date:   Mon, 14 Nov 2022 11:21:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] scsi: target: tcm_loop: fix possible name leak in
 tcm_loop_setup_hba_bus()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hch@lst.de
References: <20221114154556.2985745-1-yangyingliang@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221114154556.2985745-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:610:11a::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0fd9cc-4206-49b2-5fe5-08dac664a75e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cj6DSKd+v7gBOVqdmutzO9iX4FDik8zjLammuuaaHIsL0u3XvX14QtRUKhJqx1Ajz9L/pJpOuJcRXuZ0YurJTG247rcLovC8Q/LSjJsAm9tRKieWDJc3Q5DXnzC05VXKSmbe/49PYg01JYIIzwtQiEaHy5N9z5jKI0GaFTp+Fqfgbo1QX0tyP/gIXHeobsI8LfdkCxvNFQYoa6aRiHbomlWjnyY1mAU7U5X5QpQD7Oa2RdM2WwS4IvcjjFz8qMn90Z2ntndwRppZTYD/WkpnCP3wH3Yu+PIwtgtxxDvhWOqs8/RZVLJHdfhx2/KLAFZ/L9btwVulHJTPd8sdQEVuoWjf1GgmGqDuDnOAoo4ygOlLFK8sEfGw+T8scYOypL/aVnlwvaLFGigCcXYkU4lHI8D/T9+/L4sTNOzqfM4S7eJnH7C4J0OSBcq3Wnnr3l5DFCFttB5MWBl3dsjQvhb5acH5iyE59cSyQNZwlnXuAafOBgo1wv/kWOtTwRCg+KtQ3ZUCzY3tmxr0wYbeyHGwsYOnNwXtjSYxVxGkI/kVxQAnPsp6n1lmB9X3ScQKtCnD6g3kwxIRlCyOfFiRHQjQH7iFjFkTsdMT8XDyXxaFLKNyZksx1I0VOiRtAswfO2zj2bk6uNn3i43svPr6Bj7qe0k/eS74VwYuAauF/8Ef/LS1eAJWOjCUt7SOSllJ8nChafDRohqe1nTzqoV16ODZfhpUAFIfIF/we6Sz1WNB+3Z6R3Vla62eNXmxJMFrzbTvKMejkAAtS9AccJVr89Ji4HTsFaIUzSFmea7/EqtG6KE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199015)(6506007)(53546011)(316002)(26005)(6512007)(2906002)(86362001)(31696002)(66476007)(38100700002)(6486002)(4326008)(36756003)(8676002)(66556008)(478600001)(66946007)(186003)(83380400001)(31686004)(5660300002)(2616005)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmVxSFZrUTFLOEphSktLR0hnQzJiYXIyVllXbGlvd3lQNlU2UWxJUk5UNnZW?=
 =?utf-8?B?QjE0MWtZL1BQdWtPdjZZL1ZVMUw1bHBXQk81dlQrbHVhTXlqMHVIZGVZYVJM?=
 =?utf-8?B?VWx3YkV1NXZRZ3lpemtydjUzMjJuNVBxdGpWRTJJdGNxTTErWmQwVTNqdGYx?=
 =?utf-8?B?NlNzdWNGaHlPMitjdzc5UG1UbGtjMTlXR3lWNHZnbTEwRDBzdnhJZzJkV3VQ?=
 =?utf-8?B?RGtKUGF3RmFNU0dXUzdKWFVyczhWMEdldGpocTVCM3lMMW85YTNYUmZUeklV?=
 =?utf-8?B?L2xIQkg3NnhtWmxpa0N1di9IRDl2SjhxcERIUksrbWdpNllGQVRCQzdLU0Ni?=
 =?utf-8?B?djdlWTBiQm9HeERaQVRJMk5kSHIvQmpLZGVhM3pjK3g1Y016dzhLMDlkK1lw?=
 =?utf-8?B?VjhLblQwVkt2NFpDcnMzZDk3TDJtNGk5eWhVOTEzQVZUYm0xbWRFeHJuN09p?=
 =?utf-8?B?ZC9JMWpqcmxpQlhYTFBIZEFzbWlRYjVCVzZCM284SU1hWTN5WkRUVDQ4Zlha?=
 =?utf-8?B?clhnU05xSDdTUkp4MmVkSVdibmFJbzFta1NiYXJNcHlDMmFMdkNrYjhoU2Za?=
 =?utf-8?B?eVZ5SUsvR0sxcU1rcmM2SThSUnpQM05UUkI0WEdMOElRUFV3ZGw1UmVkNXhy?=
 =?utf-8?B?Z2V6SDdhcklXRUVod1kwdWZjc0dPNThiMEE2WlNtNHp1TVJMNFJKaFJ1ckFR?=
 =?utf-8?B?SnQyblBmSXJNMldGc3hmOVU4em9JSUc5V2JlTERORU5qd3EyYzcrZUtEYVpW?=
 =?utf-8?B?WmFKNGhLSXliRXRDQVAzajJzVzcxZWp4VnQvS0NDaTV6QnVSTENaN2Z3YlUy?=
 =?utf-8?B?Q2FvZHZYc1p1Tjk2VGtFTjhXYW1Oa3NrUVFTZEhGemxLemRyU3l6d2xOSnhN?=
 =?utf-8?B?djVlbUltM25Oc2dQelg4bUYyUmM5dmxGbkdVMTJZMDJFRlVBUTVRMVBkemlO?=
 =?utf-8?B?NUFselhEYjRQUDdZR2cydHUxL3pLa1hoTVozd1Z4R0pPMmE0MkJUSzExd0Y1?=
 =?utf-8?B?aDhjVmJkU3gva1dsNUd4WmFWREtHSWtHVkJNQ00yaDVqdFlwVCtlUFJQcjBB?=
 =?utf-8?B?enU5WHdyZUl5OEFtcWlJSFlwTUJOOTg0SDRzbzVLZEJjbCtUWFJrNzBXUGQz?=
 =?utf-8?B?dmtJQmdBU0lpK1FHcjJFY0hlemVDZDFJdVlaNllWMUJtRkRrUTExM2Zrdmhx?=
 =?utf-8?B?c2dqRUM3K0dmMUZxWlp5T3ZUZzBaYW1PT2QrZys2MEIrNERtQjNIODgvWGtm?=
 =?utf-8?B?cFlPNlVpYnVjM1RmRHZCRGRWRVBta1FFZ1RjRkhIZVpSQzZWNVhFNzZ4YkFX?=
 =?utf-8?B?UE4wMWlRUDJCem10OXdlVi9MZFd1NERnNVpNS2FDSi9SRVJ4SmRKRVZkZmRx?=
 =?utf-8?B?RnV1ZTdwb3J5N1dGWlQ2SldsZVZMZzd0UVFSSWdWRnpkNEhhQjFtVVdxUFMy?=
 =?utf-8?B?SDA0Z05OaWRXOGNOdlF0Zk16V1hJTFhMVjU4Ymg5RHIvZjlBZTNPWHpCd29C?=
 =?utf-8?B?emttU0JlTkM4emt1NEJzOXhHKzFTWlpteElSWXVuR3ZTUVhCMEtWdURSQm9E?=
 =?utf-8?B?bnVRVlE0aUdJWE13Q3A5THBGeHFGWGRnSGl3Y1J4VGV5UHYvVjhxUXhWZnVH?=
 =?utf-8?B?azdkaGJuQ1JOcDBrQVJ1UjM2dHd6SUtOcklFQm9rYzUxT0hOZlhzL0ZSLzhp?=
 =?utf-8?B?KzRPeW45MCs5MW9OVUJKQTZFMFQ1RVQwOWpQbWVkdTVraTFsZHRiQUMvUHdi?=
 =?utf-8?B?V0NxbHI0YkZIMU4xd0NxSHlLZjFGc1hRamgralNyNVJQZXRrbTZld0ZDM2R2?=
 =?utf-8?B?LzlzYzBWalBtZnBBaWd5VVNQQkJkZHdyMXYyMU1Ycm5kYlNPRGNXWVhTQVBQ?=
 =?utf-8?B?aXUxZVc5ZFYyTGhJbWpFTGhlckNqeWZWMXREV1RCSlp2MTkzQUdvZVBjK1Fz?=
 =?utf-8?B?OFkzUDlDd2JzNTJJclZ6N2JkR3hkcGdJcFNNT0ZvSDJ0SUkwUjRqMitCMmxk?=
 =?utf-8?B?RFRGMjZaWFU0d1ZqczNGZWZGNWF6Ym1XZzRHZUhjWnlwQkdaemhwdHIwa1dm?=
 =?utf-8?B?T2cya2ZLM001cVAxOGhKeWtKSVBVQ3VzaEFwVnZzbXQwL0RnL3d5TjkyM1o2?=
 =?utf-8?B?S1ZsU2JIaWI5NVFoL0RZRDAxZW1aSkxGYzE2M2gyeGVtOUV2MlM4UmF0b25P?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OvKUo17R5O1n9CTFRE8C2NyRHjCALpPyrtfGeSgD9+xvLWF3MgoJrWeP13IKMuIBWNFijhX142ifqHIUFW/CcxbzAAPk6bZ6oLmlO7d77Ssh7Tl70M5VAg3ovOaPrCWr9TJBpIVlUIuBn+jJuSSSRuqgJFeoicadHGXP7NV7GUYv3XIydaVYnlJZcQqOPjpwhB2hCWmxXAL9ije41rQA6VgrsPwE96/qhmJ8JynTLYQY039ly8nOGjEvNY9xXMwETK6yeDtjXIS0vuGJQRlCEuxzupFCNml9L18V9lh1TdeGCzEYGheQ24C+VGuXSMKOHytyZvkBaJizSgWjheurgTPS57BES7pRaqpVmXkFT88QbOKfyKnwoRzGMXYf9ALpKPJeHNugGd5JSImiE9VRLFZt2iuygjArLSTsFGAwFMvOD1OjGA78NrTL4zM3NSwwzZpj+D5YVEMYQAGZllr2qnBFIwZrIOCGniwhTpQpECVkFqrdrMsm4e6jopFMXsAiQD+FbUnCNAoYtLWX7OtWK64l2Wvoc4cX0EHCVjZYauv5NMrl7AJaiDdJEqFWuzL1gnyeo54KfsUV2OCYtF81QpWzmdePFaBnLzq34j1SSRyOt40f6Djrleld6E7dkohlzIWzBqdjuRnMET7Ew7B7820q+Y0/HWDwcaq5XivNTcO6uUmyqewLdC8NIeCGnYoHCkQP7jIBh3mpY9dtUSjcRyo4DCahubVtFZVHNZplAYwsnanw4P5KaQ/kQ7+olJmurklpIAfFWgkJNFIfCGzq335AksQzziFEpMHvFXza06fi/pWtjBAeJCWxjPaB5Ltirhs0RgAHq7VB67jdgGHJCSvQHAKPltw8EAWTL0bRlps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0fd9cc-4206-49b2-5fe5-08dac664a75e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:21:23.4761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YX9AHWbNg+unIi59MkyazIIFg/4SbFfXrNXmvc+PGbr0Rv+i75oZEdVYgx9cVFMC4lKjODYEJitG2Fw5k9B+3Q5XuoCOcZr1xN592sX8Fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_13,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140124
X-Proofpoint-ORIG-GUID: NdD3BIL9VAxJ6fa0mM3l1hgl-eF9zdJQ
X-Proofpoint-GUID: NdD3BIL9VAxJ6fa0mM3l1hgl-eF9zdJQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 9:45 AM, Yang Yingliang wrote:
> If tcm_loop_setup_hba_bus() returns error, the name allocated by
> dev_set_name() need be freed. As comment of device_register()
> says, it should use put_device() to give up the reference in the
> error path. So fix this by calling put_device(), then the name
> can be freed in kobject_cleanup(). The 'tl_hba' will be freed in
> tcm_loop_release_adapter(), so it don't need goto error label in
> this case.
> 
> Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/target/loopback/tcm_loop.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 4407b56aa6d1..d3277993ce17 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1072,8 +1072,10 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
>  	 * device_register() callbacks in tcm_loop_driver_probe()
>  	 */
>  	ret = tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
> -	if (ret)
> -		goto out;
> +	if (ret) {
> +		put_device(&tl_hba->dev);
> +		return ERR_PTR(ret);
> +	}
>  
Can you put the put_device in tcm_loop_setup_hba_bus? Since
tcm_loop_setup_hba_bus does the device release setup and device_register
call it seems nicer for tcm_loop_setup_hba_bus to handle the failure as
tcm_loop_make_scsi_hba doesn't know about the struct device code.


