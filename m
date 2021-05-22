Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AC0C47081
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 274E461090
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhEVEnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhEVEnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:43:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZcZU004259;
        Sat, 22 May 2021 04:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=swWo198Ht9wUP5qoKjkxRhfbAN32N25DHXt1E3m4U3Q=;
 b=sIJndJERwf9me8T/SaKhhavjXofFROXY3lAX1AD6VGlnbb4RnPtsCzZ7p6pQCpRHa8cx
 RAknR/N01EQdSTcxNmxKSAeLFxKhnIojRUVt47Y4tkz1Pjv1Bb8NECxwUiJoHEOzJQIE
 tw3z6P1ovDLgYWvCxaz9rkJfoNvKR/1yRkV/Cgg4PMLSMvGK25yzAHNbHQCz6sWbS/iB
 fyTHfqk7n6mUhlAa7FR+X1eqF11i7Zb3CLf4bFZmxJPDIgzQUvc8zZGpCMWmyyaLG8Mt
 Dl22urKcubx8TyvcAJATfdzN9zmj/99p8F0PFQGeymRVGFUSj154fuBR8elCmZyfzXMg eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ptkp00j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4abKg072334;
        Sat, 22 May 2021 04:41:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 38pq2rp5n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzLBQmU92qqoj5vqLQWKXCxH9DVyjq7hperXVi2RshbC9QYJujZv7KanyYWesbi5V8U9zHpaN/2lk3OM+slOmcrTUKghfuM/jjJNjR5nlCOD+q7x/IuEcXggGsYXv8x2G6ePQB9NHzQ2MYRgZ+eCa426WhmpU+g2Y/ZbkV7A4NJ8sHEpmm19f+QJimIUONVy9gR3ktIZnNFv1GkqtkdRdIX5K+TdYxjVzM4mPyXLnAu5IdEWFxKatMNEAKRt3tG1GcZdBX9MVNwFXZtVjNoDvb5MpxpofIjpt8Js3/AxNi3TxxGOFjr8rDT/Ihw4zLFhirllYth/HaGr3A6UtkhD+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swWo198Ht9wUP5qoKjkxRhfbAN32N25DHXt1E3m4U3Q=;
 b=mCXxM4wQyEb/UZBeJD0N4NjiBKGcc2QRUqevYZsjG08BJIaqvR4grNg7H33s4/IfM60fGUvDQGCeeAyQuza60zwI6s9vYtD2+Zh0xDZCmMKTkXnAArlWgTmlgfwgthjKsNdHwNV/Em2f1S13FkfQtXLo7u7oLnBEc+aWemLO+inzL/DmOq/HCZJYhxMlPEpT3ZhPPNeFmobvbo5S9kjgKAH+WOdRMJbmU2Hg58nk8f+cwV3cIFti7IstbgevpWE7L/yr43lJDkFQf4/RtDSqCnaA3zCeHUE3yE7lrloN8WJNa4+ISKRHwS3aiMo/j0lMRsLdkia5Rku5YE8vsm402g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swWo198Ht9wUP5qoKjkxRhfbAN32N25DHXt1E3m4U3Q=;
 b=ys8vDNJGR52Fzn+EEkXq92DkcUdb9PYge5j508GIyxIctlodJeCJD000aES83j+CxTMR6Dgh9ErurhCtIeKKf6N1tQlVqsTF5Z1kdNBShVai23vAe/V/DR5ZNezJBnuINvqzmmfUxjM5F3i0sHoOaXjBV3iXaVrh4D3fGW3f/I0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Sat, 22 May
 2021 04:41:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH RESEND 0/2] scsi: target: user configurable IEEE Company ID
Date:   Sat, 22 May 2021 00:41:35 -0400
Message-Id: <162165846770.5888.8702819105460509546.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420185920.42431-1-s.samoylenko@yadro.com>
References: <20210420185920.42431-1-s.samoylenko@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78076d65-ef9a-40f8-6456-08d91cdbe6a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566069CE49824A771ADCBD28E289@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lzn5cPQa9Niqv7nOFfnn75yws1cpZFLBtaWv2XkYfAWrEP40S9fXULo1jUxE814ULBC09rBlTbECvKyku8BguYhDBy12So5kmXVs8k/wPy8GrAi3zyNncz3pFJkWmrKaDJIBh0vMsBhHv8u+21dIac6DvujOmWTt4R0rR44w2rivrj39LDtfgb9a6znPFZSRQYGmXK4NSI9L+MVvEQN+srw+ty5pX7aMT/eLbk0D/JfTLDnQ9Lj+8BVPYjYGbOQfwTBwFYsW4HPC1fIFR3BxmxjChLfbd3YgoBPiQ5J7MNrRkMI7QphFVk+QlFZhWyZ1SqPTEw0nOGmTx/2XdpN36JIo3skvJ3+sZe8ctWiFtdMJtSiLOb8azelgcbiye2GY+cSBdLbFvGjBJ9iGyHb4tKtaGKzn3l8TdcgNn2uTnQTyV1QUMfhfCmcwJcQRXN0lPOESh9BHUAVZeCQybhPVnxhmbohWhOcOWsTu389cHD4JRnJLdQzP6vsgS58Cpir6W3mWUT78QL/Sl2nh3Rp9siBBes1MCYBmRkbDGclJ7MxU6/x/mbNRO2SHC93SuH/KIObRMPuWNAn9iGAjXQ/L0w13E0Ncgn9oDulp650aQ02Chpd2kv1Dpptq5D732aXTMQCBY13MlhxQdOefN6BBgvMpt12VjzNnNVJwg7diQfRhY5meA+CBdxeO/S5H6YdnMPlcfhMI2FUlnaAyjkLoeryZRdyDnBqZOdhl+SNqAK5qiJRsEdpx0YMOHwtMhtEa8VnEDA+baOXUIfrBMBNcXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(7696005)(956004)(4744005)(2906002)(86362001)(52116002)(6666004)(38100700002)(478600001)(26005)(38350700002)(6486002)(966005)(5660300002)(2616005)(103116003)(16526019)(36756003)(66556008)(316002)(8936002)(110136005)(54906003)(4326008)(186003)(66476007)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nk5HTjdleHh5VmFJcUtTSlhiL3d3akw0ZURQYVEycVJ2bDBMWUFPdHRBcHNl?=
 =?utf-8?B?cERDRThpVEtTcVVaVzlVUGFPdXhHZjJkMnhXaVBkUm53QklJQTQ2VjBwYTRP?=
 =?utf-8?B?QWpzRFFURVZkc0lxS0ZPZDhiVFRwSnU4OGlvelJWNGM4a0g0VVFzSS9mOE5H?=
 =?utf-8?B?d1VQbkpPM05Rc1QzUDNpM2Eyekw0OVNIS1hmTnhCVWpBRjVMeTliYklzL0F0?=
 =?utf-8?B?bjJqN2t4Y0Rzd3cwNHNIKzYxbVJnTjdXc1E0OUxDbHFkenRXNUtMUGxsRyty?=
 =?utf-8?B?eXh4cEZIUnNrQ3NQcGpjR3NuWmtLQXdRbVhiS29YcVE5QXA4OFF3V3BMcUQw?=
 =?utf-8?B?ay9nemZaRGhvNDg0R0hkYkVoSVMvYkNSRTRYR05PWmFkUUcxRTlmOHRja285?=
 =?utf-8?B?dU9sV0UxNWYwallNcG9CUlNpVE1JYzlEMkdDK0g0Kzg0bWtsN1hnWjkzdVhI?=
 =?utf-8?B?anpkeVpDbnRkY1Y4K1p5R1ZEeUg4K24wdkV2dEkyMDdGTzlIZVhKK1ZXcm51?=
 =?utf-8?B?eExGNTdPclVPUStyZmhaeHJxYjY3YWptMHJVTkpHM1RwK2NQZ3h0M1YzVjB2?=
 =?utf-8?B?NmR4WXZINlNzQkk4SFVoRllZaVpGdGYrbnB3UXJndW8zR1hXVjNFV0UyVmVp?=
 =?utf-8?B?MmZZVjM3T1RLdkRReW9UTWhpMEZ6WWlwRUJBY09JRzF3b0ErTzFreTdUakpC?=
 =?utf-8?B?bklENGJ6RWxSaXlaSzBISFFNZnJRTFBmYU42OFJtKzk2cnF6ZjVtSnlxMUNy?=
 =?utf-8?B?UmJvMEpLOXRUekgvbXdvYmlyZmcybEYzamlPWkhaQWZXZmdrN0d4cURVNVZi?=
 =?utf-8?B?VlBXKzVMWDhzL3BoVjdUNDh2elE0Tk1OMUE1WTRWVjJmTHhnSVhINGxpVVkx?=
 =?utf-8?B?TDZ4Wk9HWVhBaXU3aFVoMEZZMXBtd3ZEaHVGQWxIMVRCdmc0djJDdEl0WEZV?=
 =?utf-8?B?aEtxb3FQQnZVNGpmU1NYV3FmL0RuVW5Td3JINy9DZEtjUVpmSU5PSGRZeUR4?=
 =?utf-8?B?RXZkbzlGNGlqaTZhN2IzNjl6c2YzYkFwOUVaRUhHRUExbGZPYzZtcEw3NVl3?=
 =?utf-8?B?OENRSnFoZXZhdnVxNzNMT3ZjSXFVVnZ5cmFXQ3Y1T2VkK1ZXSk5XdUZ3Rkkx?=
 =?utf-8?B?a3JZbnRPKzU1K1ZXU0R4U2p3WDczNWo3a1FGRDllanNXaVhRd3hmYVV0OUtX?=
 =?utf-8?B?MUJ2R2lPOW1SNlpwQzZxdkN2RTRzdDdmME5ReUtmdzQ3eGtmN0xQNmovL1dV?=
 =?utf-8?B?cXNyY2t3T1FzNlNuV1lZZ2tDYzBGUWhrRXZJS1ljRWd1WFkrN2F4bnBuN0hC?=
 =?utf-8?B?VUZEQUxUUERWRGJTTXZjYVNGY0NLNVJkcXB6NkV2K2lEeUY2UVAwWnRIMmR5?=
 =?utf-8?B?dlYrS0NkcXBvSUV3Nk1XMVFMeXNmaGtTMXkvZ3Q4NlFnNWhWTklJSTZ6bG8x?=
 =?utf-8?B?bXZ2cVRad2cyeExtK1MrQ2ErRFlIT2M0aWpmRFF5cFBydzEwN2NIMnNzTlFC?=
 =?utf-8?B?Q2pHR1VjY3VzTW5ySGJUTlBNZjVvSmhIc0ZTWXhQK0NwT2RmQjVYZUJXQUxt?=
 =?utf-8?B?RWZ4aGpjTG5KNks0cms1VlExb2kxcXAxYWdtS2RYblEzTGREbUZQaEZDb2hx?=
 =?utf-8?B?QVdBU0dPRmpMd0prS1J1TmZsWHJYOGM2bUExRkZrdGh6S0xVaGJBUzhycHoy?=
 =?utf-8?B?N3RObXBVN0E2aFcyTFpzK2dWdDhCTWVUOWVHaHc4MmVjZEUrRStwRHJqUUJi?=
 =?utf-8?Q?D7fPMLNnzn3ZqcoWge13P3wr2lxCe0Lrv7m7cqR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78076d65-ef9a-40f8-6456-08d91cdbe6a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:44.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bL8u0rIxznq7LIhIYQJHMfFKat3wvDmIndueTjHEyVqfGJiC9ojwNqBLqG0hTEFzqxaqa1aBw1AdBswikmQPESojdsbeSM66X4z7q7p1004=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=845 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: Hkmia_T5ndm7nEyUed8fBsWlF90ZUyp3
X-Proofpoint-ORIG-GUID: Hkmia_T5ndm7nEyUed8fBsWlF90ZUyp3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2021 21:59:18 +0300, Sergey Samoylenko wrote:

> The series allows to change IEEE Company ID component
> of NAA LUN identifier returned on the SCSI INQUIRY VPD
> page (aka WWID). Company ID can be changed via the
> target/core/$backstore/$name/wwn/company_id ConfigFS path.
> 
> Sergey Samoylenko (2):
>   scsi: target: core: Unify NAA identifer generation
>   scsi: target: core: Add IEEE Company ID attribute
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: target: core: Unify NAA identifer generation
      https://git.kernel.org/mkp/scsi/c/17f947b8b06f
[2/2] scsi: target: core: Add IEEE Company ID attribute
      https://git.kernel.org/mkp/scsi/c/2469f1e0412c

-- 
Martin K. Petersen	Oracle Linux Engineering
