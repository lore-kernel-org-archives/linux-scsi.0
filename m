Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7742C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8357B6023E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhIAXte (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 19:49:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48734 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230143AbhIAXtd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 19:49:33 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 181Lx1Su027798;
        Wed, 1 Sep 2021 23:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ahBZAulo74VNc1s8cMihaKEnZeoe7aNojyLRNSvtVtc=;
 b=Zcfq3vMjWC4/PI4DSXipNzktLqa5fScEKtKzSAl9ChoINxe0oYyt8frAiifwX1anS/0J
 ePUjM3opOiMT7EjpuWES/h+lt+pNNK3QmZl7RDlHaGPlcliE7Ssts06cF/oY1Th9Z8sy
 ltBabO5EazUxBwuwXIgbmbXm9wYn7hvhkuEG5Nck34sTARTt/4KYA5Di2MfC6vDzMwOc
 UW9loQCvu+/G5nFfdZqPkXfGGs009BsZV85bjiFKiu5Xv9OqdwhtHrVJJofZOpWhNKrO
 79U1nc1WEM+AFxKI8pSsCXpvtS5vliqWPINy5x8YMqC8nxgjV9nvLX5HV70Q8onyx1tL Sg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ahBZAulo74VNc1s8cMihaKEnZeoe7aNojyLRNSvtVtc=;
 b=gOHoSLAoqJarMJES3o4XOoWwILZ1WXIZxhZxedL7XTKzrI7/1p8cq8KIAO9WC+NW4jym
 CXco/Ccx8ugodtJjv2A1ndnPUesvZZuVZwhQgKizdfwHrerYgoEE2mN+gOeEofH+o7zL
 VK4sIVec4c/VwF1A3pris4FbIsXllGLbXiWoSzZOTbfMeF3Z3N2oJy2chORplfSqtgFI
 O8Ag0f3W0q6dQujU2w0mZPDDtxJ2pVLUQS3sQOG5FQ0SaVZal8ai6KtwxW3x6TBUUPIA
 WEamBFUAQYBxrdDVu6BG0y8hC/cvv0qwnc/0DP5OB+3nMv08kYpphzVvqSwvz4pdzlzv 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw00vby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 23:48:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181NjfcS155307;
        Wed, 1 Sep 2021 23:48:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3atdyunhyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 23:48:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Igfl/c0Y1u+uxbxUKXb4uRnvPjk1A+WTGvAhePFZV/E40KjPuJLcQMdC5JgduAU4gYgXc1DQRgIHhihSCY7iqYD5n9zDieqs6PFP9Tn/UgtHyuVcS8ceoDz3AxzSgx0HN9zrtbKGlbAu3S3TYhDT5CjbVSZTwPTfWno9gG3NP93mz8EVFy0SIlN4A24BRb0aZJBBDAEgS6SPYslmjLPu5KX0cLjsmX0hEt/FPVRZGKDG9veMuRERUyDoAW+lBa6szDMuyAldJ9wX6JfFOlyZ6sN55kXUIJCwtDndGKtgWPYZR3gvnzBLYokvF1gAiVSlzubbWV91di7/Lu8m7CsYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ahBZAulo74VNc1s8cMihaKEnZeoe7aNojyLRNSvtVtc=;
 b=nGbKqcvmF8539vJMhLK5LBXvUJ1hid03Yq60X8eu739QXUpF55l3Ujo7ZcbpFNLHN3APtfELxUJ6lJO3gT77vV9ejPr1DpMklcNt/PvGDhOQM7q0GNJTBDUN/cPMNy16+QYyfQMcxfAh1q+ZqocWBgJEsvT0WnKNoo7esEGgCk72+TFQHvnHhi2El8kV8oXX/yempibdvDZUVLHqeZ9iVEuKWwNii21bB2OfboOULYFJTSexVg0GV//qWfLpRnZKew90Vf4nNB8olwyl4TeTsS3zYtGcw8lg85mN7CsSClaM/Eg+4SIZCVcUeFIEMrCLpPgukiMYb941G6b59WaWDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahBZAulo74VNc1s8cMihaKEnZeoe7aNojyLRNSvtVtc=;
 b=tHfukwWCCn36Vab6HuUV5Se4tzxP6aqMDh+G0P8mHnrGClaSD7pTAfbqnbbLYhycDx1fZtvicuS2uCj0lbShLLdXNYquoMcVsc5Ah5oKuKrqeC23SRo8ztWV3ZTNvctG0xEkSoKWFDHzE+GXPonulW6XkoWLEgV24ZObeCKU6pE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 23:48:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708%7]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 23:48:31 +0000
Subject: Re: [Bug 214147] New: ISCSI broken in last release
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
References: <bug-214147-11613@https.bugzilla.kernel.org/>
From:   michael.christie@oracle.com
Message-ID: <17d498f2-b871-01c6-8d14-588eed73fed8@oracle.com>
Date:   Wed, 1 Sep 2021 18:48:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR2201CA0016.namprd22.prod.outlook.com
 (2603:10b6:4:14::26) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.3] (73.88.28.6) by DM5PR2201CA0016.namprd22.prod.outlook.com (2603:10b6:4:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Wed, 1 Sep 2021 23:48:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d73f0185-7b9e-4bd2-ed7c-08d96da300de
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40043E140EC2CC0C7DA882BAF1CD9@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTO0SssyiQoliwO+PAehTAJmnGx6+o1MXi/2au7xNW51Fbmpgxdkbj14K+3ZZojwyxNev52VBxS2QQRBboi62RHLjcRPWGmDhf/HOYQgEgMfOGMvApdHb21g1Tzr88CrXs8QQ5D6WPgB0vatl/uNIa/NqUjlhKbErm0vyBp4/h7claa62bCH7D1LQvBiQaFfqnKlv6bhKIq8wMhSCBOM53qth6MNyUErIres4kkX5ydBEdAWEIrB/ed6wV1oHSO7kfG4PV6CYWzqaNFBjpfpAj5nQl5Hi5OO5yjoUTq00eaSmzC/2CPZhQqM17uGGJg7aBUPwIVdQyp2A714bh08PapVOw6L1BMiWPtSAt+3xFb/CgpXYVxVRioTYiqPFec0xiQ/jTWDI1VXUrCmCVSOTnuMrWT9FLq5FV46zHgbnveHdOkQnVttsNXMCM2XfiftJVcRhkprbLN7b5ptGKHp5xVixnJhtZ94OcWK+nnH9ununmEuArvySd7gbH3WHzlLhbO1IrIcrRwlyOSuYOt553yMGV1bzCVgt08NnLjWvynrDmcs2/Wle2tTEdWllUhxbgZiPi6MR+XnO3NdhR3LxZjGF/rJFIZ3RzYqG2TJ/jhYfidpNDemlpIF7nda1eActmmTN5yHaOpemb4xo+qjZo9nCA/04f/t2ygdMuY+UmpBjngBofNSuo8N1AxQacxIJIP5HH5IX9UYdsx8jEqw4Yh67pQH+qFt9S15fjLfOHBdqwv1QRPiJTjkkLjM+zoen75xe28F4vTfozsZdNfrkA3EfxqMK/F/sRjyRlaG/RUjZQg6zQkxG9F+zwJAIxHSXRK8zKWWNQTfMiVTDaD0sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(83380400001)(6706004)(66946007)(8936002)(66556008)(2616005)(45080400002)(36756003)(5660300002)(31686004)(6486002)(316002)(66476007)(8676002)(16576012)(86362001)(2906002)(508600001)(9686003)(53546011)(26005)(966005)(186003)(31696002)(956004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGx6enFYaE5uODdweEZPM24rcHJidE9LenZTQUN1MkY5ZURTOENaVzE2TkZp?=
 =?utf-8?B?N2w4UVlBZHdmblhYYnV6ZmRiZnFHN3pSMTR6eDdFUzZ6R0pXVHFuKzUrbVVh?=
 =?utf-8?B?UDJQdVUxS0NCZXBSWUV6Y3dMdDBTQ3lIV0pKdlpTSisvSk5wRUNmU2c2dFZi?=
 =?utf-8?B?L29rRDZITHV0bE5NVTl4YVJEQ1BScG4wZ3FCTm1KNDVHM1hXSmIycHhUWU42?=
 =?utf-8?B?VDRaYWY4UG84TC9aQitzVzNabWJYL1JsKzIwb2tqNXY0TTdiZHhaS2p1b01X?=
 =?utf-8?B?djF1MzNTNTI2Tlo2N2EvRTFBK2Z3L1BDQVIzT2Zxdnp4ajg3YkM3aHBWckZZ?=
 =?utf-8?B?OHZpcXdLdWVmVEpwQjlXRnlYRzZ2ZVRKeXRFWWxReVNEZ0pXaVUrMlZjemcx?=
 =?utf-8?B?dHNPdGNqUWhacmdZVFF5aVhLTmV6S1NTTnJlalpDZ3VOVHgvK0oxQm9CRzBB?=
 =?utf-8?B?T0NZZGFTekRVRFRYR0gvcHpSVktkNGhBdGxidUVWeEFKQTFBMUxOUnUva3g4?=
 =?utf-8?B?UXdvUTNKNTVNajQ4SUZVWk9DQXl3b3RNR1RLbGZXa2VRcmNEZGhYQXlQNWpt?=
 =?utf-8?B?cmU2TU1hMWtFYncrbmQ2MTFQK2NYODhGMWx0NjlGaVY3clJxNzErTGIzZWp1?=
 =?utf-8?B?WGlWeFFpOVdyOTVTTlRidGpocVR0eFZpNXE4clcwVldwV2JyM1BWRmhrWUw1?=
 =?utf-8?B?MndYZWJWMDFYbndmY0JGZXRkanJMem1kaFRMalRkeGpQWGdqRE9yUkVqNmVx?=
 =?utf-8?B?Q3RzNW54NmovVmVBSStMNnBqU0NJUURzZGNVZTlhbkhaQ2l1VGZLUU45QTRB?=
 =?utf-8?B?NGgwMnVXcm5YbFNQa2psekc1d3B2VXpmbFhLVUJhY25abCtZc3JPeHZWbGIx?=
 =?utf-8?B?QXdQenNzYVFNaVRqcHFqTW11SmNCWW5vT2RzTS90VHBpS2cxY21OVmYrOVpO?=
 =?utf-8?B?cktIWTlobTI5d2trWjdzSVpHaWNSUW9YWjExc2pFNDFEY1FRNlBvUGlXRFMw?=
 =?utf-8?B?MGoveld4Wk9OQVJkdnBxZ0tXenQ2Z1JuMnQ0aWdJZXY1a05UdVovbTMzNjBq?=
 =?utf-8?B?RkdBWFM5L001QXM0aXZhbDRGaGx5V2hKVUVUOGlpSGRQMHl0dVVHdFhzWlNk?=
 =?utf-8?B?WC8yZ3NJN1lIS3AvZCtmUjZNNmhFUzMwOXBua2RSK2dXV0Urekxyd2ZpYnQ1?=
 =?utf-8?B?bFVlVThyaUFtTXdxNmUwc3MrRmZJRCs5bUQvR3Y0UTRPekpMQmRDMXlaUm8x?=
 =?utf-8?B?SmZRRFhKRldVbVdTMXREdUZvUWozaGoyV0RIMjVScWNjYjhPMm9VbFJTcTFt?=
 =?utf-8?B?OW1nb2NWWWY0K2VDM25oOHNiYkJRaVRiTWpRc3RQWE1BSXRoeDJxREtYNk5n?=
 =?utf-8?B?czhQSEdZeGdvaG9zYWVreGJhQVpyNGdKVE1ob0ozMUp3MkJ3YjQwYUdqcEJK?=
 =?utf-8?B?K2JQeEtsNkxVSENtYitxUXdSYnY5aUc5K3d0djJ4UzY2S05LZ29YWGkvcytY?=
 =?utf-8?B?L2xkL2NiOUcyaGw2L1BacDg3SFNreFhTSjhSNll5cTZqeTFmVGhvcTR1SGE1?=
 =?utf-8?B?a0lqdk5OczBOWDhCaWV5bm9pV2hqaVNXRktTK1FXcjFNVXRBUkJxQnhiK0tR?=
 =?utf-8?B?RmI1WFZQd1MranhUc24wRXdFU0M5QUp6V0hWVGJRc083YWQwcktrQTRsL3lU?=
 =?utf-8?B?cjJWRlovTjA5WHRyLy9ERDFGdEJnb2hnOUt6TldNRFB1ZDVUNmxYKzMvUkZs?=
 =?utf-8?Q?uVQyNYVVLS3jsAEe2D3OlvdfLYyus1QUQPYv3R9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d73f0185-7b9e-4bd2-ed7c-08d96da300de
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 23:48:31.3091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtBLZDuDfKSBqQn0e8XsEi//UUoJ1jdb4EQM0HvFjaNWFDMhFzkkYf2Q6O1iDNpjpIYEUJJ8Vr8MJ8S530kNFdKXds9YSegCnZvNEn4pers=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010140
X-Proofpoint-GUID: 4a9zMCaIahVsPHGXUgqyPBfsyy4H70Kh
X-Proofpoint-ORIG-GUID: 4a9zMCaIahVsPHGXUgqyPBfsyy4H70Kh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/21 6:08 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=214147
> 
>             Bug ID: 214147
>            Summary: ISCSI broken in last release
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 5.13.12
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>           Assignee: linux-scsi@vger.kernel.org
>           Reporter: slavon.net@gmail.com
>         Regression: Yes
> 
> Created attachment 298441
>   --> https://bugzilla.kernel.org/attachment.cgi?id=298441&action=edit
> dmesg log
> 
> After some time iscsi go to broke and help only reboot
> 
What are you doing when you hit the issue?

What does your target setup look like? What are you using for the
backing store?

Are you able to build your own kernels?

The only major changes between 5.12 and 5.13 is some target patches
to batch cmds. However, it looks like you start to hit a problem
earlier than when that code comes into play. We first see you hit
a data out timeout, so we don't even have all the data for the
cmd, so the target changes in 5.13 don't come into play yet.

[10931.107057] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus iqn.1991-05.com.microsoft:vhost11.dev.obs.group,i,0x400001370002,iqn.2003-01.org.linux-iscsi.vm2.x8664:sn.b07943625401,t,0x01


However, we do see some cmds have made it to the core target layer
because we can see the target layer is waiting on cmds to complete
for part of the lun reset handling:

[19906.593285] INFO: task kworker/4:1:3770999 blocked for more than 122 seconds.
[19906.603670]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_64 #1
[19906.613975] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[19906.624208] task:kworker/4:1     state:D stack:    0 pid:3770999 ppid:     2 flags:0x00004000
[19906.624212] Workqueue: events target_tmr_work [target_core_mod]
[19906.624247] Call Trace:
[19906.624249]  __schedule+0x396/0x8a0
[19906.624252]  schedule+0x3c/0xa0
[19906.624255]  schedule_timeout+0x215/0x2b0
[19906.624258]  ? kasprintf+0x4e/0x70
[19906.624261]  wait_for_completion+0x9e/0x100
[19906.624264]  target_put_cmd_and_wait+0x55/0x80 [target_core_mod]
[19906.624279]  core_tmr_lun_reset+0x38b/0x660 [target_core_mod]
[19906.624294]  target_tmr_work+0xb4/0x110 [target_core_mod]
[19906.624309]  process_one_work+0x230/0x3d0
[19906.624312]  worker_thread+0x2d/0x3e0
[19906.624314]  ? process_one_work+0x3d0/0x3d0
[19906.624316]  kthread+0x118/0x140
[19906.624318]  ? set_kthread_struct+0x40/0x40
[19906.624320]  ret_from_fork+0x1f/0x30

and we can see iscsi layer not able to relogin because of outstanding
cmds/tmfs.

I can send you a patch that reverts the core target patches. If we can
rule them out then it would help narrow things down.

Or, because it sounds like this is easy to reproduce we can turn on some
extra lio debugging.
